"""
tests/shared/test_jsonl_engine.py - Unit Tests for Python JSONL Core Engine & Registry (V7)
"""

import os
import json
import tempfile
import unittest

import jsonschema

from jsonl_engine.engine import JsonlEngine, Discipline
from jsonl_engine.registry import BaseStore
from jsonl_engine.reader import ArtifactReader
from jsonl_engine.schema_registry import SchemaRegistry, get_global_schema_registry
from jsonl_engine.paths import RepoPaths, find_repository_root
from jsonl_engine.registries import (
    RegistryCatalog,
    InventoryCatalogRegistry,
    ArticleRegistry,
    DocGraphRegistry
)


def _article(slug: str = "1105.4224v1") -> dict:
    """A minimal object satisfying codex-scientiae/article/0.1."""
    return {
        "schema": "codex-scientiae/article/0.1",
        "state": "source-ready",
        "slug": slug,
        "initialized_utc": "2026-08-07T00:00:00Z",
        "title": "Quantum Chaos",
        "authors": ["Author"],
        "abstract": "Abstract...",
        "identifiers": {"arxiv": "1105.4224", "arxiv_versioned": slug, "doi": None},
        "categories": ["cs.CL"],
        "primary_category": "cs.CL",
        "published": None,
        "updated": None,
        "evidence": {
            "provider_metadata": [],
            "latex_source": {
                "entrypoint": "main.tex",
                "selection": "single-candidate",
                "declarations": {"title_tex": None, "authors_tex": [], "doi": None},
            },
            "package_control_files": [],
        },
        "source_forms": [
            {
                "role": "latex-source-archive",
                "path": f"{slug}.tar.gz",
                "format": "application/gzip",
                "bytes": 1,
                "sha256": "0" * 64,
            },
            {
                "role": "latex-source-tree",
                "path": f"{slug}-tex",
                "format": "application/x-latex-source-tree",
                "derived_from": f"{slug}.tar.gz",
                "entrypoint": "main.tex",
                "files": 1,
                "tex_files": 1,
                "sha256": "1" * 64,
            },
        ],
        "validation": {
            "status": "valid",
            "validated_utc": "2026-08-07T00:00:00Z",
            "publication": "published-new-tree",
            "checks": [
                {"name": "gzip-readable", "outcome": "passed", "archive_kind": "tar+gzip"},
                {
                    "name": "entrypoint-unambiguous",
                    "outcome": "not-applicable",
                    "reason": "entrypoint named explicitly; the ambiguity scan did not run",
                },
            ],
        },
    }


class DeclaredMissingSchemaRegistry(BaseStore):
    KIND = "broken"
    RECORD_SCHEMA = "non_existent_schema_file.schema.json"


class TestJsonlEngineV7(unittest.TestCase):

    def test_fail_fast_on_declared_missing_schema(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            # Must raise KeyError immediately on construction
            with self.assertRaises(KeyError):
                DeclaredMissingSchemaRegistry(target_dir=tmpdir)

    def test_append_mode_refuses_unterminated_file(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "unterminated.jsonl")

            # Create file without trailing newline
            with open(out_path, "wb") as f:
                f.write(b'{"a":1}')  # Missing \n

            # Append mode must raise ValueError immediately on enter
            with self.assertRaises(ValueError):
                with JsonlEngine(output_path=out_path, discipline=Discipline.APPEND) as engine:
                    engine.append({"b": 2})

    def test_repo_paths_dynamic_resolution(self):
        root = RepoPaths.root()
        self.assertTrue(os.path.exists(os.path.join(root, "AGENTS.md")))

    def test_find_repository_root_fail_fast(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            with self.assertRaises(RuntimeError):
                find_repository_root(start_path=tmpdir)

    def test_inventory_row_is_an_article_object(self):
        """An article object is inserted verbatim as a row; no projection, no row shape."""
        with tempfile.TemporaryDirectory() as tmpdir:
            inv = InventoryCatalogRegistry(target_dir=tmpdir)
            inv.add_article(_article())
            out_file = inv.write()
            self.assertTrue(os.path.exists(out_file))
            self.assertEqual(os.path.basename(out_file), "inventory.jsonl")

            records = list(ArtifactReader.read_records(out_file))
            self.assertEqual(len(records), 1)
            self.assertEqual(records[0], _article())

    def test_one_schema_governs_article_and_inventory_row(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            self.assertEqual(
                InventoryCatalogRegistry.RECORD_SCHEMA,
                ArticleRegistry.RECORD_SCHEMA,
            )
            article = _article()
            InventoryCatalogRegistry(target_dir=tmpdir).validate_record(article)
            ArticleRegistry(target_dir=tmpdir).validate_record(article)

    def test_graph_primitive_is_dormant(self):
        """It is discoverable as a reference, and no kind declares it."""
        registry = get_global_schema_registry()
        self.assertTrue(registry.has_schema("codex-scientiae/graph-primitive/0.1"))
        declared = [
            RegistryCatalog.get_registry_class(k).RECORD_SCHEMA
            for k in RegistryCatalog.list_kinds()
        ]
        self.assertNotIn("graph.primitive.schema.json", declared)

    def test_inventory_rejects_a_malformed_article(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            inv = InventoryCatalogRegistry(target_dir=tmpdir)
            broken = _article()
            del broken["source_forms"]
            with self.assertRaises(jsonschema.ValidationError):
                inv.add_article(broken)

    def test_engine_commit_sidecars_and_exact_ticks(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "test_output.jsonl")
            jidx_path = os.path.join(tmpdir, "test_output.jidx")
            sig_path = os.path.join(tmpdir, "test_output.sig")

            engine = JsonlEngine(output_path=out_path)
            with engine:
                engine.append({"a": 1})
                engine.append({"b": "hello ∫ f(x)dx"})
                engine.commit(stage_metadata={"test": True})

            self.assertTrue(os.path.exists(out_path))
            self.assertTrue(os.path.exists(jidx_path))
            self.assertTrue(os.path.exists(sig_path))

            index_obj = ArtifactReader.read_index(jidx_path, out_path)
            self.assertTrue(index_obj.is_current())
            self.assertTrue(ArtifactReader.verify_signature(out_path))


if __name__ == "__main__":
    unittest.main()
