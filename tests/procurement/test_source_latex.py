"""LaTeX entrypoint, closure, and metadata inspection contracts."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from procurement.source.contracts import ArchiveLimits, LatexSourceError
from procurement.source.latex import inspect_latex_source_tree


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


class LatexSourceTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

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


if __name__ == "__main__":
    unittest.main()
