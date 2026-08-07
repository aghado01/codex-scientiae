"""
tests/shared/test_jsonl_engine.py - Unit Tests for Python JSONL Core Engine & Registry (V7)
"""

import os
import json
import tempfile
import unittest

from src.shared.jsonl_engine.engine import JsonlEngine, Discipline
from src.shared.jsonl_engine.registry import BaseArtifactRegistry
from src.shared.jsonl_engine.reader import ArtifactReader
from src.shared.jsonl_engine.schema_registry import SchemaRegistry, get_global_schema_registry
from src.shared.jsonl_engine.paths import RepoPaths, find_repository_root
from src.shared.jsonl_engine.registries import (
    RegistryCatalog,
    InventoryCatalogRegistry,
    DocumentMetadataRegistry,
    DocGraphRegistry
)


class DeclaredMissingSchemaRegistry(BaseArtifactRegistry):
    KIND = "broken"
    SCHEMA_NAME = "non_existent_schema_file.schema.json"


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

    def test_inventory_row_validation_from_schema_registry(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            inv = InventoryCatalogRegistry(target_dir=tmpdir)
            inv.add_inventory_row(
                slug="1105.4224v1",
                title="Quantum Chaos",
                authors=["Author"],
                abstract="Abstract...",
                identifiers={"arxiv": "1105.4224v1"},
                categories=["cs.CL"],
                metadata_sha256="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
            )
            out_file = inv.write()
            self.assertTrue(os.path.exists(out_file))

            records = list(ArtifactReader.read_records(out_file))
            self.assertEqual(len(records), 1)
            self.assertEqual(records[0]["slug"], "1105.4224v1")

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
