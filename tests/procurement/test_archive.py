"""Safe source-archive extraction and LaTeX-tree inspection contracts."""

from __future__ import annotations

import gzip
import hashlib
import io
import os
import tarfile
import tempfile
import unittest
from pathlib import Path

from jsonl_engine.deposit import _fingerprint_tree as deposit_fingerprint_tree
from jsonl_engine.publication import PinnedPublicationRoot
from procurement.source.archive import (
    ArchiveLimits,
    LatexSourceError,
    LatexSourceInspector,
    SourceArchiveError,
    SourceArchiveExtractor,
    extract_source_archive,
    fingerprint_source_tree,
    inspect_latex_source_tree,
)


def _limits(**overrides: int) -> ArchiveLimits:
    values = {
        "max_archive_bytes": 1024 * 1024,
        "max_gzip_payload_bytes": 1024 * 1024,
        "max_extracted_bytes": 1024 * 1024,
        "max_member_bytes": 1024 * 1024,
        "max_entries": 100,
        "max_component_bytes": 255,
        "max_path_bytes": 4096,
        "max_tex_bytes": 1024 * 1024,
        "max_resolved_bytes": 1024 * 1024,
        "max_input_depth": 16,
    }
    values.update(overrides)
    return ArchiveLimits(**values)


def _tar_payload(
    members: list[tuple[str, bytes | None, bytes | None, str | None]],
) -> bytes:
    """Build tar members as (name, body, type, linkname)."""

    payload = io.BytesIO()
    with tarfile.open(fileobj=payload, mode="w", format=tarfile.PAX_FORMAT) as archive:
        for name, body, member_type, linkname in members:
            info = tarfile.TarInfo(name)
            if member_type is not None:
                info.type = member_type
            if linkname is not None:
                info.linkname = linkname
            if info.isdir():
                info.size = 0
                archive.addfile(info)
            elif info.isreg():
                raw = body or b""
                info.size = len(raw)
                archive.addfile(info, io.BytesIO(raw))
            else:
                info.size = 0
                archive.addfile(info)
    return payload.getvalue()


def _tar_gzip(
    members: list[tuple[str, bytes | None, bytes | None, str | None]],
) -> bytes:
    return gzip.compress(_tar_payload(members), mtime=0)


def _regular(name: str, body: bytes) -> tuple[str, bytes, None, None]:
    return name, body, None, None


def _directory(name: str) -> tuple[str, None, bytes, None]:
    return name, None, tarfile.DIRTYPE, None


class SourceArchiveTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def _write_archive(self, name: str, payload: bytes) -> Path:
        path = self.root / name
        path.write_bytes(payload)
        return path

    def _extract(
        self,
        name: str,
        payload: bytes,
        *,
        limits: ArchiveLimits | None = None,
    ):
        archive = self._write_archive(f"{name}.gz", payload)
        destination = self.root / name
        result = extract_source_archive(archive, destination, limits=limits)
        return archive, destination, result

    def assertNoPayloadScratch(self, destination: Path) -> None:
        self.assertEqual(
            [],
            list(destination.parent.glob(f".{destination.name}.gzip-payload-*")),
        )

    def test_single_tex_gzip_extracts_inspects_and_matches_deposit_fingerprint(self) -> None:
        source = (
            b"\\documentclass[11pt]{article}\n"
            b"\\title{A {Nested} Title}\n"
            b"\\author[short]{Ada {Lovelace}}\n"
            b"\\author{Grace Hopper}\n"
            b"\\doi{10.1234/Example.DOI}\n"
            b"\\begin{document}Hello\\end{document}\n"
        )
        payload = gzip.compress(source, mtime=0)
        archive, destination, extracted = self._extract("single", payload)

        self.assertEqual("single-tex+gzip", extracted.archive_kind)
        self.assertEqual(1, extracted.archive_entries)
        self.assertEqual(len(source), extracted.gzip_payload_bytes)
        self.assertEqual(len(source), extracted.extracted_bytes)
        self.assertEqual(hashlib.sha256(payload).hexdigest(), extracted.archive_sha256)
        self.assertEqual(source, (destination / "main.tex").read_bytes())
        self.assertEqual(str(archive.resolve()), extracted.archive_path)
        self.assertEqual(str(destination.resolve()), extracted.destination_path)
        self.assertNoPayloadScratch(destination)

        inspection = inspect_latex_source_tree(destination)
        self.assertEqual("main.tex", inspection.entrypoint)
        self.assertEqual("single-candidate", inspection.entrypoint_selection)
        self.assertEqual("A {Nested} Title", inspection.embedded_metadata.title_tex)
        self.assertEqual(
            ("Ada {Lovelace}", "Grace Hopper"),
            inspection.embedded_metadata.authors_tex,
        )
        self.assertEqual("10.1234/Example.DOI", inspection.embedded_metadata.doi)

        fingerprint = fingerprint_source_tree(destination)
        deposit_hash, deposit_files, deposit_tex = deposit_fingerprint_tree(str(destination))
        self.assertEqual(deposit_hash, fingerprint.sha256)
        self.assertEqual((deposit_files, deposit_tex), (fingerprint.count, fingerprint.tex_count))
        self.assertEqual(fingerprint.sha256, inspection.tree_sha256)

    def test_retained_extraction_and_inspection_use_the_pinned_tree_generation(self) -> None:
        source = b"\\documentclass{article}\n\\begin{document}Pinned\\end{document}\n"
        archive = self._write_archive(
            "retained.tar.gz",
            _tar_gzip([_regular("main.tex", source)]),
        )
        destination = self.root / "retained-tree"
        with PinnedPublicationRoot(self.root) as root:
            root.mkdir_leaf(destination.name)
            with root.pin_child(destination.name) as tree_root:
                extraction = SourceArchiveExtractor().extract_pinned(
                    root,
                    archive,
                    tree_root,
                )
                inspection = LatexSourceInspector().inspect(
                    destination,
                    publication_root=tree_root,
                )

        self.assertEqual("tar+gzip", extraction.archive_kind)
        self.assertEqual(
            hashlib.sha256(archive.read_bytes()).hexdigest(),
            extraction.archive_sha256,
        )
        self.assertEqual("main.tex", inspection.entrypoint)
        self.assertEqual(source, (destination / "main.tex").read_bytes())

    def test_tar_extracts_nested_source_and_resolves_literal_inputs(self) -> None:
        main = (
            b"\\documentclass{article}\n"
            b"\\title{Resolved {Source}}\n"
            b"% \\input{missing}\n"
            b"\\input{sections/body}\n"
        )
        body = b"\\author{A. Author}\n\\include{nested}\n"
        nested = (
            b"literal \\% percent\n"
            b"\\doi{10.5555/resolved}\n"
            b"\\begin{document}Body\\end{document}\n"
        )
        control = b'{"manifest": "upstream"}\n'
        payload = _tar_gzip(
            [
                _directory("sections/"),
                _regular("paper.tex", main),
                _regular("sections/body.tex", body),
                _regular("sections/nested.tex", nested),
                _regular("00README.json", control),
            ]
        )
        _, destination, extracted = self._extract("tar-source", payload)

        self.assertEqual("tar+gzip", extracted.archive_kind)
        self.assertEqual(5, extracted.archive_entries)
        self.assertEqual(
            len(main) + len(body) + len(nested) + len(control),
            extracted.extracted_bytes,
        )
        self.assertEqual(nested, (destination / "sections" / "nested.tex").read_bytes())
        self.assertNoPayloadScratch(destination)

        inspection = inspect_latex_source_tree(destination, slug="paper")
        self.assertEqual("paper.tex", inspection.entrypoint)
        self.assertEqual("single-candidate", inspection.entrypoint_selection)
        self.assertEqual(4, inspection.file_count)
        self.assertEqual(3, inspection.tex_file_count)
        self.assertEqual("Resolved {Source}", inspection.embedded_metadata.title_tex)
        self.assertEqual(("A. Author",), inspection.embedded_metadata.authors_tex)
        self.assertEqual("10.5555/resolved", inspection.embedded_metadata.doi)
        self.assertEqual(
            ("00README.json",),
            tuple(item.path for item in inspection.package_control_files),
        )

    def test_tar_accepts_pax_headers_and_additional_zero_padding(self) -> None:
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        payload = io.BytesIO()
        with tarfile.open(
            fileobj=payload,
            mode="w",
            format=tarfile.PAX_FORMAT,
        ) as archive:
            info = tarfile.TarInfo("pax.tex")
            info.pax_headers = {"comment": "explicit PAX regression header"}
            info.size = len(source)
            archive.addfile(info, io.BytesIO(source))
        raw = payload.getvalue()
        self.assertEqual(b"././@PaxHeader", raw[:14])
        raw += b"\x00" * (3 * tarfile.BLOCKSIZE)

        _, destination, extracted = self._extract(
            "pax-zero-padding",
            gzip.compress(raw, mtime=0),
        )

        self.assertEqual("tar+gzip", extracted.archive_kind)
        self.assertEqual(1, extracted.archive_entries)
        self.assertEqual(len(source), extracted.extracted_bytes)
        inspection = inspect_latex_source_tree(destination)
        self.assertEqual("pax.tex", inspection.entrypoint)

    def test_tar_rejects_nonzero_trailing_bytes_and_concatenated_archives(self) -> None:
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        first = _tar_payload([_regular("main.tex", source)])
        second = _tar_payload([_regular("second.tex", source)])
        with tarfile.open(fileobj=io.BytesIO(first), mode="r:") as archive:
            self.assertEqual(1, len(list(archive)))
            terminator_offset = archive.offset
        self.assertEqual(
            b"\x00" * (2 * tarfile.BLOCKSIZE),
            first[terminator_offset : terminator_offset + (2 * tarfile.BLOCKSIZE)],
        )

        nonzero_padding = bytearray(first)
        nonzero_padding[terminator_offset + (2 * tarfile.BLOCKSIZE)] = 1
        invalid = (
            ("appended", first + b"trailing", "nonzero data"),
            ("padding", bytes(nonzero_padding), "nonzero data"),
            ("concatenated", first + second, "nonzero data"),
            (
                "one-zero-block",
                first[: terminator_offset + tarfile.BLOCKSIZE],
                "canonical two-zero-block",
            ),
            (
                "one-zero-then-concatenated",
                first[: terminator_offset + tarfile.BLOCKSIZE] + second,
                "canonical two-zero-block",
            ),
        )
        for name, raw, expected in invalid:
            with self.subTest(name=name):
                archive_path = self._write_archive(
                    f"tar-tail-{name}.gz",
                    gzip.compress(raw, mtime=0),
                )
                destination = self.root / f"tar-tail-{name}"
                with self.assertRaisesRegex(SourceArchiveError, expected):
                    extract_source_archive(archive_path, destination)
                self.assertFalse(os.path.lexists(destination))
                self.assertNoPayloadScratch(destination)

    def test_entrypoint_selection_is_explicit_deterministic_and_ambiguity_visible(self) -> None:
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        tree = self.root / "entrypoints"
        tree.mkdir()
        (tree / "paper.tex").write_bytes(source)
        (tree / "other.tex").write_bytes(source)

        with self.assertRaisesRegex(LatexSourceError, "ambiguous"):
            inspect_latex_source_tree(tree)
        selected = inspect_latex_source_tree(tree, slug="paper")
        self.assertEqual("paper.tex", selected.entrypoint)
        self.assertEqual("preferred-name:paper.tex", selected.entrypoint_selection)
        explicit = inspect_latex_source_tree(tree, main_tex="other.tex")
        self.assertEqual("other.tex", explicit.entrypoint)
        self.assertEqual("explicit", explicit.entrypoint_selection)

        (tree / "main.tex").write_bytes(source)
        preferred = inspect_latex_source_tree(tree)
        self.assertEqual("main.tex", preferred.entrypoint)
        self.assertEqual("preferred-name:main.tex", preferred.entrypoint_selection)

    def test_archive_paths_must_be_normalized_portable_relatives(self) -> None:
        invalid = (
            "../escape.tex",
            "/rooted.tex",
            "C:/drive.tex",
            "a\\backslash.tex",
            "./dot.tex",
            "a/../dotdot.tex",
            "a//empty.tex",
            "CON.tex",
            "trailing./source.tex",
            "control\x01.tex",
            ("x" * 256) + ".tex",
            ("a/" * 2048) + "source.tex",
        )
        for index, member in enumerate(invalid):
            with self.subTest(member=member):
                archive = self._write_archive(
                    f"invalid-{index}.gz",
                    _tar_gzip([_regular(member, b"x")]),
                )
                destination = self.root / f"invalid-{index}"
                with self.assertRaises(SourceArchiveError):
                    extract_source_archive(archive, destination)
                self.assertFalse(os.path.lexists(destination))
                self.assertNoPayloadScratch(destination)
        self.assertFalse((self.root / "escape.tex").exists())

    def test_limit_configuration_rejects_non_integer_and_inconsistent_values(self) -> None:
        with self.assertRaisesRegex(ValueError, "positive integer"):
            ArchiveLimits(max_entries=True)
        with self.assertRaisesRegex(ValueError, "non-negative integer"):
            ArchiveLimits(max_input_depth=False)
        with self.assertRaisesRegex(ValueError, "cannot exceed"):
            ArchiveLimits(max_extracted_bytes=1, max_member_bytes=2)

        tree = self.root / "wrong-limits"
        tree.mkdir()
        (tree / "file.txt").write_bytes(b"x")
        with self.assertRaisesRegex(TypeError, "ArchiveLimits"):
            fingerprint_source_tree(tree, limits=False)  # type: ignore[arg-type]

    def test_links_and_special_tar_members_are_rejected_without_residue(self) -> None:
        unsafe = (
            (tarfile.SYMTYPE, "target.tex"),
            (tarfile.LNKTYPE, "target.tex"),
            (tarfile.FIFOTYPE, None),
            (tarfile.CHRTYPE, None),
        )
        for index, (member_type, linkname) in enumerate(unsafe):
            with self.subTest(member_type=member_type):
                archive = self._write_archive(
                    f"special-{index}.gz",
                    _tar_gzip([("unsafe", None, member_type, linkname)]),
                )
                destination = self.root / f"special-{index}"
                with self.assertRaisesRegex(SourceArchiveError, "unsafe link or special"):
                    extract_source_archive(archive, destination)
                self.assertFalse(os.path.lexists(destination))
                self.assertNoPayloadScratch(destination)

    def test_duplicate_case_colliding_and_file_directory_conflicts_are_rejected(self) -> None:
        cases = (
            [_regular("same.tex", b"a"), _regular("same.tex", b"b")],
            [_regular("Case.tex", b"a"), _regular("case.tex", b"b")],
            [_regular("Foo/a.tex", b"a"), _regular("foo/b.tex", b"b")],
            [_regular("node", b"a"), _regular("node/child.tex", b"b")],
        )
        for index, members in enumerate(cases):
            with self.subTest(index=index):
                archive = self._write_archive(f"collision-{index}.gz", _tar_gzip(list(members)))
                destination = self.root / f"collision-{index}"
                with self.assertRaises(SourceArchiveError):
                    extract_source_archive(archive, destination)
                self.assertFalse(os.path.lexists(destination))

    def test_archive_and_expansion_boundaries_are_enforced(self) -> None:
        single = gzip.compress(b"x" * 33, mtime=0)
        tar_two = _tar_gzip([_regular("a", b"a" * 8), _regular("b", b"b" * 8)])
        tar_member = _tar_gzip([_regular("large", b"x" * 9)])
        cases = (
            (single, _limits(max_archive_bytes=len(single) - 1), "archive"),
            (
                single,
                _limits(
                    max_gzip_payload_bytes=32,
                    max_extracted_bytes=32,
                    max_member_bytes=32,
                ),
                "gzip",
            ),
            (
                tar_two,
                _limits(max_extracted_bytes=15, max_member_bytes=15),
                "extraction",
            ),
            (
                tar_member,
                _limits(max_extracted_bytes=16, max_member_bytes=8),
                "member",
            ),
            (tar_two, _limits(max_entries=1), "member limit"),
        )
        for index, (payload, limits, expected) in enumerate(cases):
            with self.subTest(expected=expected):
                archive = self._write_archive(f"bounded-{index}.gz", payload)
                destination = self.root / f"bounded-{index}"
                with self.assertRaisesRegex(SourceArchiveError, expected):
                    extract_source_archive(archive, destination, limits=limits)
                self.assertFalse(os.path.lexists(destination))
                self.assertNoPayloadScratch(destination)

    def test_invalid_gzip_utf8_and_existing_destination_are_fail_closed(self) -> None:
        invalid_payloads = (
            b"not gzip",
            gzip.compress(b"valid text", mtime=0)[:-3],
            gzip.compress(b"bad utf8 \xff", mtime=0),
            gzip.compress(b"nul\x00text", mtime=0),
        )
        for index, payload in enumerate(invalid_payloads):
            with self.subTest(index=index):
                archive = self._write_archive(f"invalid-stream-{index}.gz", payload)
                destination = self.root / f"invalid-stream-{index}"
                with self.assertRaises(SourceArchiveError):
                    extract_source_archive(archive, destination)
                self.assertFalse(os.path.lexists(destination))
                self.assertNoPayloadScratch(destination)

        archive = self._write_archive("existing.gz", gzip.compress(b"text", mtime=0))
        destination = self.root / "existing"
        destination.mkdir()
        marker = destination / "owned.txt"
        marker.write_text("caller", encoding="utf-8")
        with self.assertRaisesRegex(SourceArchiveError, "already exists"):
            extract_source_archive(archive, destination)
        self.assertEqual("caller", marker.read_text(encoding="utf-8"))

    def test_inspection_requires_strict_utf8_for_every_tex_file(self) -> None:
        tree = self.root / "invalid-tex"
        tree.mkdir()
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        (tree / "unused.tex").write_bytes(b"\xff")
        with self.assertRaisesRegex(LatexSourceError, "not valid UTF-8"):
            inspect_latex_source_tree(tree)

    def test_input_resolution_rejects_escape_missing_cycle_and_depth_overflow(self) -> None:
        cases = {
            "escape": (
                b"\\documentclass{article}\n\\input{../outside}\n\\begin{document}x",
                {},
                _limits(),
                "dot path segment",
            ),
            "backslash": (
                b"\\documentclass{article}\n\\input{dir\\file}\n\\begin{document}x",
                {},
                _limits(),
                "backslash",
            ),
            "missing": (
                b"\\documentclass{article}\n\\input{missing}\n\\begin{document}x",
                {},
                _limits(),
                "unresolved",
            ),
            "cycle": (
                b"\\documentclass{article}\n\\input{a}\n\\begin{document}x",
                {"a.tex": b"\\input{main}"},
                _limits(),
                "cyclic",
            ),
            "depth": (
                b"\\documentclass{article}\n\\input{a}\n\\begin{document}x",
                {"a.tex": b"fragment"},
                _limits(max_input_depth=0),
                "depth limit",
            ),
        }
        for name, (main, extras, limits, expected) in cases.items():
            with self.subTest(name=name):
                tree = self.root / f"input-{name}"
                tree.mkdir()
                (tree / "main.tex").write_bytes(main)
                for relative, body in extras.items():
                    (tree / relative).write_bytes(body)
                with self.assertRaisesRegex(LatexSourceError, expected):
                    inspect_latex_source_tree(tree, limits=limits)

    def test_resolved_source_size_and_document_marker_are_required(self) -> None:
        large = self.root / "large-resolved"
        large.mkdir()
        (large / "main.tex").write_text(
            "\\documentclass{article}\n\\begin{document}" + ("x" * 100),
            encoding="utf-8",
        )
        with self.assertRaisesRegex(LatexSourceError, "resolved LaTeX source exceeds"):
            inspect_latex_source_tree(large, limits=_limits(max_resolved_bytes=40))

        incomplete = self.root / "no-document"
        incomplete.mkdir()
        (incomplete / "main.tex").write_text(
            "\\documentclass{article}\nNo document environment.\n",
            encoding="utf-8",
        )
        with self.assertRaisesRegex(LatexSourceError, "no document environment"):
            inspect_latex_source_tree(incomplete)

    def test_non_tex_literal_input_is_strictly_decoded_and_fingerprinted(self) -> None:
        tree = self.root / "literal-input"
        tree.mkdir()
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\input{fragment}\n",
            encoding="utf-8",
        )
        (tree / "fragment").write_text(
            "\\author{Literal Input}\n\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        inspection = inspect_latex_source_tree(tree)
        self.assertEqual(("Literal Input",), inspection.embedded_metadata.authors_tex)
        self.assertEqual(2, inspection.file_count)
        self.assertEqual(1, inspection.tex_file_count)

        (tree / "fragment").write_bytes(b"\xff")
        with self.assertRaisesRegex(LatexSourceError, "not valid UTF-8"):
            inspect_latex_source_tree(tree)

    def test_tree_fingerprint_is_sorted_and_deterministic(self) -> None:
        tree = self.root / "fingerprint"
        tree.mkdir()
        (tree / "z.tex").write_bytes(b"z")
        (tree / "A.txt").write_bytes(b"a")
        sub = tree / "sub"
        sub.mkdir()
        (sub / "b.tex").write_bytes(b"b")

        first = fingerprint_source_tree(tree)
        second = fingerprint_source_tree(tree)
        self.assertEqual(first, second)
        self.assertEqual(("A.txt", "sub/b.tex", "z.tex"), tuple(item.path for item in first.files))
        deposit_hash, deposit_count, deposit_tex = deposit_fingerprint_tree(str(tree))
        self.assertEqual(
            (deposit_hash, deposit_count, deposit_tex),
            (first.sha256, first.count, first.tex_count),
        )


if __name__ == "__main__":
    unittest.main()
