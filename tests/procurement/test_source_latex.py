"""LaTeX entrypoint, closure, and metadata inspection contracts."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from procurement.source.contracts import ArchiveLimits, LatexSourceError
from procurement.source.latex import inspect_latex_source_tree
from procurement.source.tree import fingerprint_source_tree


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

    def test_nested_duplicate_documentclass_defers_to_the_unique_root_file(self) -> None:
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        tree = self.root / "nested-duplicate"
        nested = tree / "copy"
        nested.mkdir(parents=True)
        (tree / "paper.tex").write_bytes(source)
        (nested / "paper.tex").write_bytes(source)
        inspection = inspect_latex_source_tree(tree)
        self.assertEqual("paper.tex", inspection.entrypoint)
        self.assertEqual("equivalent-source-copies", inspection.entrypoint_selection)
        self.assertEqual(1, len(inspection.duplicate_copies))
        copy = inspection.duplicate_copies[0]
        self.assertEqual("copy", copy.directory)
        self.assertEqual(".", copy.canonical_directory)
        self.assertEqual("copy/paper.tex", copy.entrypoint)
        self.assertEqual("paper.tex", copy.canonical_entrypoint)
        self.assertEqual(("paper.tex",), tuple(item.path for item in copy.files))

    def test_complete_copies_preserve_assets_paths_and_physical_fingerprint(self) -> None:
        tree = self.root / "complete-copies"
        bundle = {
            "paper.tex": b"\\documentclass{article}\n\\input{section}\n"
            b"\\begin{document}\\bibliography{refs}\\includegraphics{fig/chart.pdf}"
            b"\\end{document}\n",
            "section.tex": b"\\author{Same Source}\n",
            "refs.bib": b"@book{example,title={Example}}\n",
            "paper.bbl": b"A bibliography.\n",
            "fig/chart.pdf": b"%PDF-1.7\nfixture\n",
        }
        for directory in ("", "Copy A", "Copy B", "Copy A/nested"):
            for name, data in bundle.items():
                path = tree / directory / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(data)
        before = fingerprint_source_tree(tree)
        inspection = inspect_latex_source_tree(tree)
        after = fingerprint_source_tree(tree)
        self.assertEqual(before, after)
        self.assertEqual(before.sha256, inspection.tree_sha256)
        self.assertEqual(20, inspection.file_count)
        self.assertEqual("paper.tex", inspection.entrypoint)
        self.assertEqual(("Same Source",), inspection.embedded_metadata.authors_tex)
        self.assertEqual((), inspection.unresolved_inputs)
        self.assertEqual(3, len(inspection.duplicate_copies))
        for copy in inspection.duplicate_copies:
            self.assertEqual("paper.tex", copy.canonical_entrypoint)
            self.assertEqual(5, len(copy.files))
            for item in copy.files:
                self.assertEqual(
                    (tree / copy.directory / item.path).read_bytes(),
                    (tree / copy.canonical_directory / item.path).read_bytes(),
                )

    def test_sibling_copies_use_depth_then_ordinal_order_without_rebasing_inputs(self) -> None:
        tree = self.root / "sibling-copies"
        source = b"\\documentclass{article}\n\\input{shared}\n\\begin{document}x\\end{document}\n"
        for directory in ("nested/first", "z-copy", "a-copy"):
            path = tree / directory
            path.mkdir(parents=True)
            (path / "paper.tex").write_bytes(source)
            (path / "shared.tex").write_bytes(b"\\author{Directory Copy}\n")
        (tree / "shared.tex").write_bytes(b"\\author{Compile Root}\n")
        inspection = inspect_latex_source_tree(tree)
        self.assertEqual("a-copy/paper.tex", inspection.entrypoint)
        self.assertEqual("equivalent-source-copies", inspection.entrypoint_selection)
        self.assertEqual(("Compile Root",), inspection.embedded_metadata.authors_tex)
        self.assertEqual(2, len(inspection.duplicate_copies))

        explicit = inspect_latex_source_tree(tree, main_tex="z-copy/paper.tex")
        self.assertEqual("z-copy/paper.tex", explicit.entrypoint)
        self.assertEqual("explicit", explicit.entrypoint_selection)
        self.assertTrue(all(
            copy.canonical_entrypoint == "z-copy/paper.tex"
            for copy in explicit.duplicate_copies
        ))

    def test_differing_copy_files_require_explicit_selection(self) -> None:
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        variations = {
            "changed-asset": {"paper.tex": source, "figure.pdf": b"different"},
            "missing-asset": {"paper.tex": source},
            "renamed-asset": {"paper.tex": source, "other.pdf": b"asset"},
            "extra-asset": {"paper.tex": source, "figure.pdf": b"asset", "extra": b"x"},
            "changed-document": {"paper.tex": source + b"% changed\n", "figure.pdf": b"asset"},
        }
        for name, files in variations.items():
            with self.subTest(name=name):
                tree = self.root / name
                (tree / "copy").mkdir(parents=True)
                (tree / "paper.tex").write_bytes(source)
                (tree / "figure.pdf").write_bytes(b"asset")
                for leaf, data in files.items():
                    (tree / "copy" / leaf).write_bytes(data)
                before = fingerprint_source_tree(tree)
                with self.assertRaisesRegex(LatexSourceError, "copies differ; specify main_tex"):
                    inspect_latex_source_tree(tree, slug="paper")
                explicit = inspect_latex_source_tree(tree, main_tex="paper.tex")
                self.assertEqual((), explicit.duplicate_copies)
                self.assertEqual(before, fingerprint_source_tree(tree))

    def test_duplicate_pair_does_not_hide_a_third_conflicting_copy(self) -> None:
        tree = self.root / "third-copy"
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        for directory, body in (("", source), ("copy", source), ("different", source + b"% changed\n")):
            path = tree / directory
            path.mkdir(parents=True, exist_ok=True)
            (path / "paper.tex").write_bytes(body)
        with self.assertRaisesRegex(LatexSourceError, "copies differ"):
            inspect_latex_source_tree(tree)
        explicit = inspect_latex_source_tree(tree, main_tex="different/paper.tex")
        self.assertEqual("different/paper.tex", explicit.entrypoint)
        self.assertEqual(1, len(explicit.duplicate_copies))

    def test_duplicate_selection_keeps_missing_input_evidence(self) -> None:
        tree = self.root / "duplicate-missing-input"
        (tree / "copy").mkdir(parents=True)
        source = b"\\documentclass{article}\n\\input{missing}\n\\begin{document}x\\end{document}\n"
        for path in (tree / "paper.tex", tree / "copy" / "paper.tex"):
            path.write_bytes(source)
        inspection = inspect_latex_source_tree(tree)
        self.assertEqual("equivalent-source-copies", inspection.entrypoint_selection)
        self.assertEqual("missing", inspection.unresolved_inputs[0].literal)

    def test_differently_named_identical_documents_are_not_duplicate_copies(self) -> None:
        tree = self.root / "different-names"
        tree.mkdir()
        source = b"\\documentclass{article}\n\\begin{document}x\\end{document}\n"
        (tree / "paper.tex").write_bytes(source)
        (tree / "other.tex").write_bytes(source)
        with self.assertRaisesRegex(LatexSourceError, "ambiguous"):
            inspect_latex_source_tree(tree)
        self.assertEqual((), inspect_latex_source_tree(tree, main_tex="paper.tex").duplicate_copies)

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

    def test_missing_literal_input_is_recorded_and_does_not_abort(self) -> None:
        tree = self.root / "input-missing"
        tree.mkdir()
        (tree / "main.tex").write_bytes(
            b"\\documentclass{article}\n\\input{missing}\n\\begin{document}x\\end{document}\n"
        )
        inspection = inspect_latex_source_tree(tree)
        self.assertEqual("main.tex", inspection.entrypoint)
        self.assertEqual(1, len(inspection.unresolved_inputs))
        hole = inspection.unresolved_inputs[0]
        self.assertEqual("input", hole.command)
        self.assertEqual("missing", hole.literal)
        self.assertEqual("main.tex", hole.referenced_by)

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

    def test_nested_inputs_resolve_from_the_compile_root(self) -> None:
        tree = self.root / "compile-root-input"
        (tree / "sub").mkdir(parents=True)
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\input{sub/wrapper}\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        (tree / "sub" / "wrapper.tex").write_text(
            "\\input{leaf}\n",
            encoding="utf-8",
        )
        (tree / "leaf.tex").write_text("\\author{Compile Root}\n", encoding="utf-8")
        (tree / "sub" / "leaf.tex").write_text("\\author{Containing File}\n", encoding="utf-8")

        inspection = inspect_latex_source_tree(tree)
        self.assertEqual(("Compile Root",), inspection.embedded_metadata.authors_tex)

    def test_unique_casefold_input_target_resolves_when_exact_leaf_is_absent(self) -> None:
        tree = self.root / "casefold-input"
        tree.mkdir()
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\input{Introduction}\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        (tree / "introduction.tex").write_text(
            "\\author{Casefold Input}\n",
            encoding="utf-8",
        )
        inspection = inspect_latex_source_tree(tree)
        self.assertEqual(("Casefold Input",), inspection.embedded_metadata.authors_tex)

    def test_leading_dot_slash_is_normalized_at_the_input_boundary(self) -> None:
        tree = self.root / "leading-dot-input"
        tree.mkdir()
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\input{./fragment}\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        (tree / "fragment.tex").write_text(
            "\\author{Leading Dot}\n",
            encoding="utf-8",
        )

        inspection = inspect_latex_source_tree(tree)
        self.assertEqual(("Leading Dot",), inspection.embedded_metadata.authors_tex)

    def test_subfile_is_resolved_as_a_literal_include_with_command_provenance(self) -> None:
        tree = self.root / "subfile-input"
        tree.mkdir()
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\subfile{chapter}\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        (tree / "chapter.tex").write_text(
            "\\author{Subfile Chapter}\n",
            encoding="utf-8",
        )

        inspection = inspect_latex_source_tree(tree)
        self.assertEqual(("Subfile Chapter",), inspection.embedded_metadata.authors_tex)

        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\subfile{missing}\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        missing = inspect_latex_source_tree(tree)
        self.assertEqual(1, len(missing.unresolved_inputs))
        self.assertEqual("subfile", missing.unresolved_inputs[0].command)
        self.assertEqual("missing", missing.unresolved_inputs[0].literal)

    def test_bare_literal_forms_follow_texdig_token_boundaries(self) -> None:
        tree = self.root / "bare-inputs"
        tree.mkdir()
        (tree / "main.tex").write_text(
            "\\documentclass{article}\n"
            "\\input bare% target stops before this comment\n"
            "\\include ./chapter.tex\n"
            "\\subfile appendix\n"
            "\\input\\dynamic\n"
            "\\include[dynamic]\n"
            "\\include]dynamic\n"
            "\\subfilefoo\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        (tree / "bare.tex").write_text("\\author{Bare Input}\n", encoding="utf-8")
        (tree / "chapter.tex").write_text("\\author{Bare Include}\n", encoding="utf-8")
        (tree / "appendix.tex").write_text("\\author{Bare Subfile}\n", encoding="utf-8")
        (tree / "dynamic.tex").write_text("\\author{Dynamic}\n", encoding="utf-8")
        (tree / "foo.tex").write_text("\\author{Control Word Prefix}\n", encoding="utf-8")

        inspection = inspect_latex_source_tree(tree)
        self.assertEqual(
            ("Bare Input", "Bare Include", "Bare Subfile"),
            inspection.embedded_metadata.authors_tex,
        )

        (tree / "main.tex").write_text(
            "\\documentclass{article}\n\\subfile missing\n"
            "\\begin{document}x\\end{document}\n",
            encoding="utf-8",
        )
        missing = inspect_latex_source_tree(tree)
        self.assertEqual(1, len(missing.unresolved_inputs))
        self.assertEqual("subfile", missing.unresolved_inputs[0].command)
        self.assertEqual("missing", missing.unresolved_inputs[0].literal)

    def test_class_specific_title_author_and_doi_declarations_are_collected(self) -> None:
        cases = (
            (
                "aistats",
                "\\documentclass{article}\n"
                "\\runningtitle{Short}\n"
                "\\runningauthor{You and Cho}\n"
                "\\aistatstitle{Geometric Information Decomposition}\n"
                "\\aistatsauthor{\n"
                "  Kisung You \\\\\n"
                "  Baruch College\n"
                "  \\And\n"
                "  Boram Cho \\\\\n"
                "  Affiliation\n"
                "}\n"
                "\\begin{document}x\\end{document}\n",
                "Geometric Information Decomposition",
                ("Kisung You", "Boram Cho"),
                None,
            ),
            (
                "icml",
                "\\documentclass{article}\n"
                "\\icmltitle{Project Alexandria}\n"
                "\\icmlauthor{Ada Lovelace}{equal}\n"
                "\\icmlauthor{Author Name}{yy}\n"
                "\\icmlauthor{Grace Hopper}{equal}\n"
                "\\begin{document}x\\end{document}\n",
                "Project Alexandria",
                ("Ada Lovelace", "Grace Hopper"),
                None,
            ),
            (
                "icml-center",
                "\\documentclass{article}\n"
                "\\begin{document}\n"
                "\\twocolumn[\n"
                "\\icmltitle{Project Alexandria}\n"
                "\\begin{center}\n"
                "\\textbf{\n"
                "Ada Lovelace$^{1}$ \\quad Grace Hopper$^{2}$ \\\\\n"
                "}\n"
                "\\end{center}]\n"
                "\\end{document}\n",
                "Project Alexandria",
                ("Ada Lovelace$^{1}$", "Grace Hopper$^{2}$"),
                None,
            ),
            (
                "ieee",
                "\\documentclass{article}\n"
                "\\title{An IEEE Paper}\n"
                "\\author{\n"
                "\\IEEEauthorblockN{1\\textsuperscript{st} Ada Lovelace}\n"
                "\\IEEEauthorblockA{University}\n"
                "\\and\n"
                "\\IEEEauthorblockN{2\\textsuperscript{nd} Grace Hopper}\n"
                "}\n"
                "\\begin{document}x\\end{document}\n",
                "An IEEE Paper",
                (
                    "1\\textsuperscript{st} Ada Lovelace",
                    "2\\textsuperscript{nd} Grace Hopper",
                ),
                None,
            ),
            (
                "jmlr",
                "\\documentclass{article}\n"
                "\\title{Rdimtools}\n"
                "\\author{\n"
                "\\name Kisung You \\email kyou@nd.edu \\\\\n"
                "\\addr Notre Dame\n"
                "\\AND\n"
                "\\name Dennis Shung \\\\\n"
                "\\addr Yale\n"
                "}\n"
                "\\href{https://doi.org/10.1016/j.simpa.2022.100414}{DOI}\n"
                "\\begin{document}\n"
                "\\href{https://doi.org/10.9999/bibliography}{bib}\n"
                "\\end{document}\n",
                "Rdimtools",
                ("Kisung You", "Dennis Shung"),
                "10.1016/j.simpa.2022.100414",
            ),
            (
                "title-footnote-doi",
                "\\documentclass{article}\n"
                "\\title{On the Wasserstein median\\footnote{"
                "available online: \\url{https://doi.org/10.1080/10618600.2024.2374580}.}}\n"
                "\\author{Kisung You}\n"
                "\\begin{document}x\\end{document}\n",
                "On the Wasserstein median\\footnote{"
                "available online: \\url{https://doi.org/10.1080/10618600.2024.2374580}.}",
                ("Kisung You",),
                "10.1080/10618600.2024.2374580",
            ),
        )
        for name, source, title, authors, doi in cases:
            with self.subTest(name=name):
                tree = self.root / name
                tree.mkdir()
                (tree / "main.tex").write_text(source, encoding="utf-8")
                inspection = inspect_latex_source_tree(tree)
                self.assertEqual(title, inspection.embedded_metadata.title_tex)
                self.assertEqual(authors, inspection.embedded_metadata.authors_tex)
                self.assertEqual(doi, inspection.embedded_metadata.doi)


if __name__ == "__main__":
    unittest.main()
