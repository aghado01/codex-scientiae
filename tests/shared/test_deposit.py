"""Article-deposit service and CLI transaction contract."""

from __future__ import annotations

import copy
import hashlib
import json
import os
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from unittest import mock

import jsonschema

from jsonl_engine import (
    ArticleManifest,
    DepositConflict,
    DepositError,
    deposit_article,
)
from jsonl_engine.reader import read_json

from jsonl_test_support import article as article_record


PROTOCOL = "codex-scientiae/jsonl-engine-cli"
_NO_CLOBBER_OPERATION = "rename" if os.name == "nt" else "link"


def _write_json(path: str, value) -> None:
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        json.dump(value, handle, ensure_ascii=False, separators=(",", ":"), allow_nan=False)
        handle.write("\n")


def _tree_fingerprint(root: str) -> str:
    records = []
    for directory, _, filenames in os.walk(root):
        for filename in filenames:
            path = os.path.join(directory, filename)
            relative = os.path.relpath(path, root).replace(os.sep, "/")
            with open(path, "rb") as handle:
                raw = handle.read()
            records.append((relative, len(raw), hashlib.sha256(raw).hexdigest()))
    records.sort(key=lambda record: record[0])
    witnessed = "".join(
        f"{path}\0{size}\0{digest}\n" for path, size, digest in records
    ).encode("utf-8")
    return hashlib.sha256(witnessed).hexdigest()


def _article_scratch(document_dir: str):
    return sorted(
        name
        for name in os.listdir(document_dir)
        if name.startswith("article.json.") and name.endswith(".tmp")
    )


def _run_cli(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, "-m", "jsonl_engine", *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=120,
    )


class DepositFixture:
    """One source-ready boundary payload under a temporary document directory."""

    def __init__(
        self,
        parent: str,
        *,
        slug: str = "1234.5678v1",
        with_provider: bool = False,
        with_pdf: bool = False,
        checks=None,
    ) -> None:
        self.parent = parent
        self.slug = slug
        self.document_dir = os.path.join(parent, slug)
        os.mkdir(self.document_dir)

        self.archive_name = f"{slug}.tar.gz"
        self.archive_path = os.path.join(self.document_dir, self.archive_name)
        self.archive_bytes = b"\x1f\x8bdeposit-fixture\x00"
        with open(self.archive_path, "wb") as handle:
            handle.write(self.archive_bytes)

        self.tree_name = f"{slug}-tex"
        self.tree_path = os.path.join(self.document_dir, self.tree_name)
        os.mkdir(self.tree_path)
        self.entrypoint = "main.tex"
        with open(
            os.path.join(self.tree_path, self.entrypoint),
            "w",
            encoding="utf-8",
            newline="\n",
        ) as handle:
            handle.write(
                "\\documentclass{article}\\title{Tést ∫}"
                "\\begin{document}Body.\\end{document}\n"
            )

        self.checks = copy.deepcopy(
            checks
            if checks is not None
            else [
                {
                    "name": "gzip-readable",
                    "outcome": "passed",
                    "archive_kind": "tar+gzip",
                },
                {
                    "name": "archive-members-confined",
                    "outcome": "passed",
                    "entries": 1,
                },
                {
                    "name": "no-links-or-reparse-points",
                    "outcome": "passed",
                    "files": 1,
                },
                {"name": "tex-valid-utf8", "outcome": "passed", "tex_files": 1},
                {
                    "name": "entrypoint-unambiguous",
                    "outcome": "passed",
                    "entrypoint": self.entrypoint,
                    "selection": "single-candidate",
                },
                {
                    "name": "literal-inputs-resolved",
                    "outcome": "passed",
                    "unresolved_input_action": "Stop",
                },
                {
                    "name": "document-environment-present",
                    "outcome": "passed",
                    "basis": "resolved-input-text",
                },
            ]
        )
        self.findings = {
            "checks": self.checks,
            "declarations": {
                "title_tex": "Tést ∫",
                "authors_tex": ["Ada"],
                "doi": None,
            },
            "package_control_files": [],
        }
        self.findings_path = os.path.join(parent, "findings.json")
        self.write_findings(self.findings)

        self.provider = None
        self.provider_name = None
        self.provider_path = None
        if with_provider:
            self.provider = {
                "id": "1234.5678",
                "idv": slug,
                "title": "Provider título",
                "authors": ["A. Author", "B. Author"],
                "abstract": "Provider abstract",
                "categories": ["cs.AI", "math.OC"],
                "primary_category": "cs.AI",
                "published": "2026-01-01T00:00:00Z",
                "updated": "2026-01-02T00:00:00Z",
                "doi": "10.1/example",
                "fetched_at": "2026-08-08T00:00:00Z",
                "fetched_by": "test-procurement/1",
            }
            self.provider_name = f"{slug}.arxiv.json"
            self.provider_path = os.path.join(self.document_dir, self.provider_name)
            _write_json(self.provider_path, self.provider)

        self.pdf_name = None
        self.pdf_path = None
        self.pdf_bytes = b"%PDF-1.7\nfixture\n%%EOF\n"
        if with_pdf:
            self.pdf_name = f"{slug}.pdf"
            self.pdf_path = os.path.join(self.document_dir, self.pdf_name)
            with open(self.pdf_path, "wb") as handle:
                handle.write(self.pdf_bytes)

    @property
    def article_path(self) -> str:
        return os.path.join(self.document_dir, "article.json")

    def write_findings(self, value) -> None:
        _write_json(self.findings_path, value)

    def kwargs(self, **overrides):
        values = {
            "document_dir": self.document_dir,
            "slug": self.slug,
            "archive": self.archive_name,
            "archive_kind": "tar+gzip",
            "tree": self.tree_name,
            "tree_sha256": _tree_fingerprint(self.tree_path),
            "files": 1,
            "tex_files": 1,
            "entrypoint": self.entrypoint,
            "entrypoint_selection": "single-candidate",
            "publication": "published-new-tree",
            "findings_json": self.findings_path,
        }
        if self.provider_name is not None:
            values["provider_json"] = self.provider_name
        if self.pdf_name is not None:
            values["pdf"] = self.pdf_name
        values.update(overrides)
        return values

    def cli_arguments(self):
        values = self.kwargs()
        arguments = []
        for option, name in (
            ("--document-dir", "document_dir"),
            ("--slug", "slug"),
            ("--archive", "archive"),
            ("--archive-kind", "archive_kind"),
            ("--tree", "tree"),
            ("--tree-sha256", "tree_sha256"),
            ("--files", "files"),
            ("--tex-files", "tex_files"),
            ("--entrypoint", "entrypoint"),
            ("--entrypoint-selection", "entrypoint_selection"),
            ("--publication", "publication"),
            ("--findings-json", "findings_json"),
        ):
            arguments.extend((option, str(values[name])))
        if "provider_json" in values:
            arguments.extend(("--provider-json", values["provider_json"]))
        if "pdf" in values:
            arguments.extend(("--pdf", values["pdf"]))
        return arguments


class TestDepositCreation(unittest.TestCase):
    def test_minimal_deposit_has_exact_document_bytes_schema_and_source_hash(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            result = deposit_article(**fixture.kwargs())

            self.assertEqual("deposited", result.status)
            self.assertIs(True, result.created)
            self.assertEqual(os.path.abspath(fixture.article_path), result.article_path)
            self.assertEqual("codex-scientiae/article/0.1", result.article["schema"])
            self.assertEqual("source-ready", result.article["state"])
            self.assertNotIn("document", result.article)
            self.assertIsNone(result.article["title"])
            self.assertEqual([], result.article["authors"])
            self.assertEqual([], result.article["evidence"]["provider_metadata"])

            archive, tree = result.article["source_forms"]
            self.assertEqual("latex-source-archive", archive["role"])
            self.assertEqual(len(fixture.archive_bytes), archive["bytes"])
            self.assertEqual(hashlib.sha256(fixture.archive_bytes).hexdigest(), archive["sha256"])
            self.assertEqual("latex-source-tree", tree["role"])
            self.assertEqual(fixture.kwargs()["tree_sha256"], tree["sha256"])

            with open(fixture.article_path, "rb") as handle:
                raw = handle.read()
            expected = (
                json.dumps(
                    result.article,
                    ensure_ascii=False,
                    indent=2,
                    allow_nan=False,
                )
                + "\n"
            ).encode("utf-8")
            self.assertEqual(expected, raw)
            self.assertFalse(raw.startswith(b"\xef\xbb\xbf"))
            self.assertNotIn(b"\r", raw)
            self.assertTrue(raw.endswith(b"\n"))
            self.assertFalse(raw.endswith(b"\n\n"))
            self.assertIn("Tést ∫".encode("utf-8"), raw)
            self.assertEqual(result.article, ArticleManifest(fixture.document_dir).read())
            self.assertFalse(os.path.exists(fixture.article_path + ".jidx"))
            self.assertFalse(os.path.exists(fixture.article_path + ".sig"))
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_provider_and_pdf_are_projected_and_fingerprinted(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir, with_provider=True, with_pdf=True)
            result = deposit_article(**fixture.kwargs())
            article = result.article

            self.assertEqual(fixture.provider["title"], article["title"])
            self.assertEqual(fixture.provider["authors"], article["authors"])
            self.assertEqual(
                {
                    "arxiv": fixture.provider["id"],
                    "arxiv_versioned": fixture.provider["idv"],
                    "doi": fixture.provider["doi"],
                },
                article["identifiers"],
            )
            provider = article["evidence"]["provider_metadata"][0]
            with open(fixture.provider_path, "rb") as handle:
                provider_raw = handle.read()
            self.assertEqual(fixture.provider_name, provider["path"])
            self.assertEqual(len(provider_raw), provider["bytes"])
            self.assertEqual(hashlib.sha256(provider_raw).hexdigest(), provider["sha256"])
            self.assertEqual("arxiv", provider["provider"])
            self.assertEqual(fixture.provider["fetched_at"], provider["fetched_at"])
            self.assertEqual(fixture.provider["fetched_by"], provider["fetched_by"])

            forms = {form["role"]: form for form in article["source_forms"]}
            pdf = forms["pdf-source"]
            self.assertEqual(fixture.pdf_name, pdf["path"])
            self.assertEqual(len(fixture.pdf_bytes), pdf["bytes"])
            self.assertEqual(hashlib.sha256(fixture.pdf_bytes).hexdigest(), pdf["sha256"])

    def test_witnessed_checks_are_persisted_verbatim_and_in_order(self):
        checks = [
            {
                "name": "gzip-readable",
                "outcome": "passed",
                "archive_kind": "single-tex+gzip",
            },
            {
                "name": "archive-members-confined",
                "outcome": "not-applicable",
                "reason": "single-payload gzip archive has no members to confine",
                "archive_kind": "single-tex+gzip",
            },
            {
                "name": "entrypoint-unambiguous",
                "outcome": "not-applicable",
                "reason": "entrypoint named explicitly; the ambiguity scan did not run",
                "selection": "explicit",
                "entrypoint": "main.tex",
            },
        ]
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir, checks=checks)
            result = deposit_article(
                **fixture.kwargs(
                    archive_kind="single-tex+gzip",
                    entrypoint_selection="explicit",
                )
            )

            self.assertEqual(checks, result.article["validation"]["checks"])
            self.assertEqual(checks, read_json(fixture.article_path)["validation"]["checks"])

    def test_framed_cli_emits_exactly_one_result(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            proc = _run_cli("--framed", "deposit", *fixture.cli_arguments())

            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            self.assertEqual(b"", proc.stderr)
            self.assertEqual(1, len(proc.stdout.splitlines()))
            frame = json.loads(proc.stdout)
            self.assertEqual(
                {
                    "protocol": PROTOCOL,
                    "version": 1,
                    "type": "value",
                    "sequence": 0,
                },
                {key: frame[key] for key in ("protocol", "version", "type", "sequence")},
            )
            self.assertEqual("deposited", frame["value"]["status"])
            self.assertIs(True, frame["value"]["created"])
            self.assertEqual(os.path.abspath(fixture.article_path), frame["value"]["article_path"])
            self.assertEqual(read_json(fixture.article_path), frame["value"]["article"])

    def test_retry_is_byte_and_mtime_idempotent_even_when_publication_changes(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            first = deposit_article(**fixture.kwargs())
            with open(fixture.article_path, "rb") as handle:
                before = handle.read()

            # Make preservation observable without relying on filesystem clock granularity.
            fixed = 1_700_000_000_123_456_700
            os.utime(fixture.article_path, ns=(fixed, fixed))
            before_mtime = os.stat(fixture.article_path).st_mtime_ns

            retry = deposit_article(
                **fixture.kwargs(publication="recovered-existing-tree")
            )

            self.assertEqual("already-deposited", retry.status)
            self.assertIs(False, retry.created)
            self.assertEqual(first.article, retry.article)
            self.assertEqual(
                "published-new-tree", retry.article["validation"]["publication"]
            )
            with open(fixture.article_path, "rb") as handle:
                self.assertEqual(before, handle.read())
            self.assertEqual(before_mtime, os.stat(fixture.article_path).st_mtime_ns)
            self.assertEqual([], _article_scratch(fixture.document_dir))


class TestDepositRefusals(unittest.TestCase):
    def test_article_manifest_publish_and_read_have_no_path_override_surface(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            manifest = ArticleManifest(tmpdir)
            record = article_record("fixed-name")
            outside = os.path.join(
                os.path.dirname(tmpdir),
                f"{os.path.basename(tmpdir)}-escaped-article.json",
            )

            operations = (
                ("publish filename", lambda: manifest.publish(record, filename=outside)),
                ("publish stem", lambda: manifest.publish(record, stem="alternate")),
                ("read filename", lambda: manifest.read(filename=outside)),
                ("read stem", lambda: manifest.read(stem="alternate")),
            )
            for operation, invoke in operations:
                with self.subTest(operation=operation), self.assertRaises(TypeError):
                    invoke()

            self.assertFalse(os.path.lexists(manifest.get_output_path()))
            self.assertFalse(os.path.lexists(outside))

    def test_invalid_existing_article_is_a_conflict_and_remains_untouched(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            invalid = b'{"schema":"wrong"}\n'
            with open(fixture.article_path, "wb") as handle:
                handle.write(invalid)
            fixed = 1_700_000_000_123_456_700
            os.utime(fixture.article_path, ns=(fixed, fixed))

            with self.assertRaisesRegex(DepositConflict, "existing article.json is invalid"):
                deposit_article(**fixture.kwargs())

            with open(fixture.article_path, "rb") as handle:
                self.assertEqual(invalid, handle.read())
            self.assertEqual(fixed, os.stat(fixture.article_path).st_mtime_ns)
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_article_schema_requires_exactly_one_archive_and_tree(self):
        record = article_record("exact-source-forms")
        for role in ("latex-source-archive", "latex-source-tree"):
            with self.subTest(role=role):
                duplicate = copy.deepcopy(record)
                duplicate["source_forms"].append(
                    copy.deepcopy(
                        next(form for form in record["source_forms"] if form["role"] == role)
                    )
                )
                with self.assertRaises(jsonschema.ValidationError):
                    ArticleManifest(".").validate_record(duplicate)

    def test_article_schema_requires_deposit_source_fields(self):
        required_fields = (
            ("latex-source-archive", "archive_kind"),
            ("latex-source-tree", "sha256"),
            ("latex-source-tree", "entrypoint_selection"),
        )
        for role, field in required_fields:
            with self.subTest(role=role, field=field):
                invalid = article_record("required-source-fields")
                form = next(item for item in invalid["source_forms"] if item["role"] == role)
                del form[field]
                with self.assertRaises(jsonschema.ValidationError):
                    ArticleManifest(".").validate_record(invalid)

    def test_article_schema_rejects_nonportable_slug_and_path_segments(self):
        for case in ("reserved-slug", "alternate-stream", "reserved-segment", "empty-segment"):
            with self.subTest(case=case):
                invalid = article_record("portable-paths")
                archive = next(
                    item
                    for item in invalid["source_forms"]
                    if item["role"] == "latex-source-archive"
                )
                tree = next(
                    item
                    for item in invalid["source_forms"]
                    if item["role"] == "latex-source-tree"
                )
                if case == "reserved-slug":
                    invalid["slug"] = "NUL"
                elif case == "alternate-stream":
                    archive["path"] = "portable-paths.tar.gz:payload"
                    tree["derived_from"] = archive["path"]
                elif case == "reserved-segment":
                    tree["entrypoint"] = "source/AUX.tex"
                    invalid["evidence"]["latex_source"]["entrypoint"] = tree["entrypoint"]
                else:
                    tree["entrypoint"] = "source//main.tex"
                    invalid["evidence"]["latex_source"]["entrypoint"] = tree["entrypoint"]

                with self.assertRaises(jsonschema.ValidationError):
                    ArticleManifest(".").validate_record(invalid)

    def test_article_manifest_rejects_impossible_cross_field_values(self):
        for case in (
            "order",
            "archive-path",
            "tree-path",
            "counts",
            "derived-from",
            "entrypoint",
            "selection",
        ):
            with self.subTest(case=case):
                invalid = article_record("semantic-invariants")
                tree = next(
                    item
                    for item in invalid["source_forms"]
                    if item["role"] == "latex-source-tree"
                )
                if case == "order":
                    invalid["source_forms"][:2] = reversed(invalid["source_forms"][:2])
                elif case == "archive-path":
                    archive = next(
                        item
                        for item in invalid["source_forms"]
                        if item["role"] == "latex-source-archive"
                    )
                    archive["path"] = "other.tar.gz"
                    tree["derived_from"] = archive["path"]
                elif case == "tree-path":
                    tree["path"] = "other-tex"
                elif case == "counts":
                    tree["tex_files"] = tree["files"] + 1
                elif case == "derived-from":
                    tree["derived_from"] = "other.tar.gz"
                elif case == "entrypoint":
                    invalid["evidence"]["latex_source"]["entrypoint"] = "other.tex"
                else:
                    invalid["evidence"]["latex_source"]["selection"] = "different"

                with self.assertRaises(jsonschema.ValidationError):
                    ArticleManifest(".").validate_record(invalid)

    def test_changed_archive_is_a_conflict_and_does_not_rewrite_article(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            deposit_article(**fixture.kwargs())
            with open(fixture.article_path, "rb") as handle:
                before = handle.read()
            with open(fixture.archive_path, "ab") as handle:
                handle.write(b"changed")

            with self.assertRaises(DepositConflict):
                deposit_article(**fixture.kwargs())

            with open(fixture.article_path, "rb") as handle:
                self.assertEqual(before, handle.read())
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_archive_replaced_after_assembly_is_refused_without_a_sentinel(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            replacement = b"replacement archive bytes\n"
            deposit_module = sys.modules["jsonl_engine.deposit"]
            assemble_article = deposit_module._assemble_article

            def assemble_then_replace_source(**kwargs):
                candidate = assemble_article(**kwargs)
                with open(fixture.archive_path, "wb") as handle:
                    handle.write(replacement)
                return candidate

            with mock.patch(
                "jsonl_engine.deposit._assemble_article",
                side_effect=assemble_then_replace_source,
            ):
                with self.assertRaises(DepositError):
                    deposit_article(**fixture.kwargs())

            with open(fixture.archive_path, "rb") as handle:
                self.assertEqual(replacement, handle.read())
            self.assertFalse(os.path.lexists(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))

        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            replacement = b"replacement in the final publication interval\n"
            deposit_module = sys.modules["jsonl_engine.deposit"]
            assert_witnesses = deposit_module._assert_file_witnesses
            replaced = False

            def check_then_replace_source(witnesses):
                nonlocal replaced
                assert_witnesses(witnesses)
                if not replaced:
                    with open(fixture.archive_path, "wb") as handle:
                        handle.write(replacement)
                    replaced = True

            with mock.patch(
                "jsonl_engine.deposit._assert_file_witnesses",
                side_effect=check_then_replace_source,
            ):
                with self.assertRaises(DepositError):
                    deposit_article(**fixture.kwargs())

            with open(fixture.archive_path, "rb") as handle:
                self.assertEqual(replacement, handle.read())
            self.assertFalse(os.path.lexists(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_changed_provider_is_a_conflict_and_does_not_rewrite_article(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir, with_provider=True)
            deposit_article(**fixture.kwargs())
            with open(fixture.article_path, "rb") as handle:
                before = handle.read()
            fixture.provider["title"] = "Changed provider title"
            _write_json(fixture.provider_path, fixture.provider)

            with self.assertRaises(DepositConflict):
                deposit_article(**fixture.kwargs())

            with open(fixture.article_path, "rb") as handle:
                self.assertEqual(before, handle.read())

    def test_changed_witnessed_tree_hash_is_a_conflict(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            deposit_article(**fixture.kwargs())
            with open(fixture.article_path, "rb") as handle:
                before = handle.read()

            with self.assertRaises(DepositConflict):
                deposit_article(**fixture.kwargs(tree_sha256="f" * 64))

            with open(fixture.article_path, "rb") as handle:
                self.assertEqual(before, handle.read())

    def test_invalid_existing_date_times_are_conflicts_and_remain_untouched(self):
        invalid_fields = (
            ("initialized_utc",),
            ("validation", "validated_utc"),
        )
        for field_path in invalid_fields:
            with self.subTest(field_path=field_path), tempfile.TemporaryDirectory() as tmpdir:
                fixture = DepositFixture(tmpdir)
                deposited = deposit_article(**fixture.kwargs())
                invalid = copy.deepcopy(deposited.article)
                target = invalid
                for component in field_path[:-1]:
                    target = target[component]
                target[field_path[-1]] = "not-a-date-time"
                invalid_bytes = (
                    json.dumps(invalid, ensure_ascii=False, indent=2, allow_nan=False) + "\n"
                ).encode("utf-8")
                with open(fixture.article_path, "wb") as handle:
                    handle.write(invalid_bytes)

                with self.assertRaises(DepositConflict):
                    deposit_article(**fixture.kwargs())

                with open(fixture.article_path, "rb") as handle:
                    self.assertEqual(invalid_bytes, handle.read())
                self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_semantically_equal_noncanonical_article_is_a_conflict_and_is_not_rewritten(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            deposited = deposit_article(**fixture.kwargs())
            noncanonical = json.dumps(
                deposited.article,
                ensure_ascii=False,
                separators=(",", ":"),
                allow_nan=False,
            ).encode("utf-8")
            self.assertFalse(noncanonical.endswith(b"\n"))
            with open(fixture.article_path, "wb") as handle:
                handle.write(noncanonical)

            with self.assertRaises(DepositConflict):
                deposit_article(**fixture.kwargs())

            with open(fixture.article_path, "rb") as handle:
                self.assertEqual(noncanonical, handle.read())
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_existing_article_directory_is_a_conflict_and_remains_a_directory(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            os.mkdir(fixture.article_path)

            with self.assertRaises(DepositConflict):
                deposit_article(**fixture.kwargs())

            self.assertTrue(os.path.isdir(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_existing_article_symlink_is_a_conflict_when_symlinks_are_available(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            deposited = deposit_article(**fixture.kwargs())
            target = os.path.join(tmpdir, "article-target.json")
            os.replace(fixture.article_path, target)
            try:
                os.symlink(target, fixture.article_path)
            except (OSError, NotImplementedError) as exc:
                self.skipTest(f"symbolic links are unavailable in this environment: {exc}")

            with self.assertRaises(DepositConflict):
                deposit_article(**fixture.kwargs())

            self.assertTrue(os.path.islink(fixture.article_path))
            with open(target, "rb") as handle:
                incumbent = json.loads(handle.read().decode("utf-8"))
            self.assertEqual(deposited.article, incumbent)
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_malformed_and_unknown_findings_are_refused_without_a_sentinel(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            with open(fixture.findings_path, "wb") as handle:
                handle.write(b'{"checks":')
            with self.assertRaisesRegex(DepositError, "strict UTF-8 JSON object"):
                deposit_article(**fixture.kwargs())
            self.assertFalse(os.path.lexists(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))

            unknown = copy.deepcopy(fixture.findings)
            unknown["invented"] = {"claim": True}
            fixture.write_findings(unknown)
            with self.assertRaisesRegex(DepositError, "unexpected.*invented"):
                deposit_article(**fixture.kwargs())
            self.assertFalse(os.path.lexists(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_relative_paths_cannot_escape_their_declared_roots(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            outside = os.path.join(tmpdir, "outside.json")
            _write_json(outside, {})

            for override in (
                {"provider_json": "../outside.json"},
                {"entrypoint": "../main.tex"},
                {"archive": "folder\\archive.tar.gz"},
            ):
                with self.subTest(override=override), self.assertRaises(DepositError):
                    deposit_article(**fixture.kwargs(**override))
            with self.assertRaisesRegex(DepositError, "portable relative path"):
                deposit_article(
                    **fixture.kwargs(archive=f"{fixture.slug}.tar.gz:payload")
                )
            self.assertFalse(os.path.lexists(fixture.article_path))

    def test_archive_and_tree_must_use_the_canonical_deposit_paths(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            alias = f"arXiv-{fixture.slug}.tar.gz"
            with open(os.path.join(fixture.document_dir, alias), "wb") as handle:
                handle.write(fixture.archive_bytes)
            alternate_tree = "alternate-tex"
            os.mkdir(os.path.join(fixture.document_dir, alternate_tree))

            for override in ({"archive": alias}, {"tree": alternate_tree}):
                with self.subTest(override=override), self.assertRaisesRegex(
                    DepositError, "canonical deposit path"
                ):
                    deposit_article(**fixture.kwargs(**override))
            self.assertFalse(os.path.lexists(fixture.article_path))

    def test_a_symlink_cannot_escape_the_document_directory(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            outside = os.path.join(tmpdir, "outside-provider.json")
            _write_json(outside, {"idv": fixture.slug})
            link_name = "linked-provider.json"
            link = os.path.join(fixture.document_dir, link_name)
            try:
                os.symlink(outside, link)
            except (OSError, NotImplementedError) as exc:
                self.skipTest(f"symbolic links are unavailable in this environment: {exc}")

            with self.assertRaisesRegex(DepositError, "escapes the document directory"):
                deposit_article(**fixture.kwargs(provider_json=link_name))
            self.assertFalse(os.path.lexists(fixture.article_path))

    def test_failed_atomic_publish_leaves_no_sentinel_or_scratch_and_releases_lease(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            with mock.patch(
                f"jsonl_engine.writer.os.{_NO_CLOBBER_OPERATION}",
                side_effect=OSError("injected publish failure"),
            ):
                with self.assertRaisesRegex(OSError, "injected publish failure"):
                    deposit_article(**fixture.kwargs())

            self.assertFalse(os.path.lexists(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))
            retry = deposit_article(**fixture.kwargs(lock_timeout=1.0))
            self.assertEqual("deposited", retry.status)
            self.assertEqual([], _article_scratch(fixture.document_dir))


class TestDepositConcurrency(unittest.TestCase):
    def test_concurrent_deposits_create_once_then_return_the_same_article(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            fixture = DepositFixture(tmpdir)
            start = threading.Barrier(4)
            results = []
            errors = []
            result_lock = threading.Lock()

            def run() -> None:
                try:
                    start.wait(timeout=10)
                    result = deposit_article(**fixture.kwargs(lock_timeout=20.0))
                    with result_lock:
                        results.append(result)
                except BaseException as exc:  # surfaced by the assertions below
                    with result_lock:
                        errors.append(exc)

            threads = [threading.Thread(target=run, daemon=True) for _ in range(4)]
            for thread in threads:
                thread.start()
            deadline = time.monotonic() + 30.0
            for thread in threads:
                thread.join(max(0.0, deadline - time.monotonic()))

            self.assertEqual([], [thread.name for thread in threads if thread.is_alive()])
            self.assertEqual([], errors)
            self.assertEqual(
                ["already-deposited"] * 3 + ["deposited"],
                sorted(result.status for result in results),
            )
            distinct_articles = {
                json.dumps(result.article, sort_keys=True) for result in results
            }
            self.assertEqual(1, len(distinct_articles))
            self.assertEqual(results[0].article, read_json(fixture.article_path))
            self.assertEqual([], _article_scratch(fixture.document_dir))

    def test_atomic_no_clobber_has_one_winner_under_a_forced_publish_race(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            first = article_record("race")
            second = copy.deepcopy(first)
            second["title"] = "A different valid contender"
            rendezvous = threading.Barrier(2)
            original_publish = getattr(os, _NO_CLOBBER_OPERATION)
            successes = []
            errors = []
            result_lock = threading.Lock()

            def racing_publish(source, destination, *args, **kwargs):
                rendezvous.wait(timeout=10)
                return original_publish(source, destination, *args, **kwargs)

            def publish(record) -> None:
                try:
                    path = ArticleManifest(tmpdir).publish(record)
                    with result_lock:
                        successes.append(path)
                except BaseException as exc:  # surfaced by the assertions below
                    with result_lock:
                        errors.append(exc)

            with mock.patch(
                f"jsonl_engine.writer.os.{_NO_CLOBBER_OPERATION}",
                side_effect=racing_publish,
            ):
                threads = [
                    threading.Thread(target=publish, args=(record,), daemon=True)
                    for record in (first, second)
                ]
                for thread in threads:
                    thread.start()
                deadline = time.monotonic() + 20.0
                for thread in threads:
                    thread.join(max(0.0, deadline - time.monotonic()))

            self.assertEqual([], [thread.name for thread in threads if thread.is_alive()])
            self.assertEqual(1, len(successes))
            self.assertEqual(1, len(errors))
            self.assertIsInstance(errors[0], FileExistsError)
            self.assertIn(read_json(os.path.join(tmpdir, "article.json")), (first, second))
            self.assertEqual([], _article_scratch(tmpdir))


if __name__ == "__main__":
    unittest.main()
