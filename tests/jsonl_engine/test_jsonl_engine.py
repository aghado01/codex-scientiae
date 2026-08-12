"""
tests/jsonl_engine/test_jsonl_engine.py - Unit Tests for Python JSONL Core Engine & Registry (V7)
"""

import os
import json
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import jsonschema

from jsonl_engine.engine import JsonlEngine, Discipline
from jsonl_engine.kinds import (
    ArticleManifest,
    BaseStore,
    InventoryRegistry,
    KindCatalog,
)
from jsonl_engine.reader import JsonlStore, read_index
from jsonl_engine.schemas import get_schema_catalog
from jsonl_engine.paths import RepoPaths, find_repository_root
from jsonl_engine.sidecar import store_paths

from jsonl_test_support import article


class DeclaredMissingSchemaRegistry(BaseStore):
    KIND = "broken"
    RECORD_SCHEMA = "non_existent_schema_file.schema.json"


class TestJsonlEngineV7(unittest.TestCase):

    def test_engine_import_does_not_load_procurement(self):
        environment = os.environ.copy()
        environment["PYTHONDONTWRITEBYTECODE"] = "1"
        process = subprocess.run(
            [
                sys.executable,
                "-c",
                (
                    "import jsonl_engine,sys; "
                    "raise SystemExit(any(name == 'procurement' or "
                    "name.startswith('procurement.') for name in sys.modules))"
                ),
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=30,
            env=environment,
        )
        self.assertEqual(0, process.returncode, process.stderr.decode("utf-8"))

    def test_engine_catalog_excludes_application_schemas(self):
        self.assertFalse(get_schema_catalog().has_schema("deposit.metadata.schema.json"))

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
        # The batch runner deliberately places each job's temporary directory beneath its
        # caller-owned run directory. That run directory may itself live in the repository,
        # so filesystem placement cannot be used to manufacture the no-sentinel condition.
        with patch("jsonl_engine.paths.os.path.exists", return_value=False):
            with self.assertRaises(RuntimeError):
                find_repository_root(start_path=os.path.abspath(os.sep))

    def test_inventory_row_is_an_article_object(self):
        """An article object is inserted verbatim as a row; no projection, no row shape."""
        with tempfile.TemporaryDirectory() as tmpdir:
            inv = InventoryRegistry(target_dir=tmpdir)
            out_file = inv.rebuild([article()])
            self.assertTrue(os.path.exists(out_file))
            self.assertEqual(os.path.basename(out_file), "inventory.jsonl")

            records = list(JsonlStore(out_file))
            header, rows = records[0], records[1:]
            self.assertEqual("header", header["__type__"])
            self.assertEqual(["/slug"], header["identity"])
            self.assertEqual(1, header["count"])
            self.assertEqual([article()], rows)

    def test_one_schema_governs_article_and_inventory_row(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            self.assertEqual(
                InventoryRegistry.RECORD_SCHEMA,
                ArticleManifest.RECORD_SCHEMA,
            )
            record = article()
            InventoryRegistry(target_dir=tmpdir).validate_record(record)
            ArticleManifest(target_dir=tmpdir).validate_record(record)

    def test_graph_primitive_is_dormant(self):
        """It is discoverable as a reference, and no kind declares it."""
        catalog = get_schema_catalog()
        self.assertTrue(catalog.has_schema("codex-scientiae/graph-primitive/0.1"))
        declared = [KindCatalog.get(k).RECORD_SCHEMA for k in KindCatalog.kinds()]
        self.assertNotIn("graph.primitive.schema.json", declared)

    def test_inventory_rejects_a_malformed_article(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            inv = InventoryRegistry(target_dir=tmpdir)
            broken = article()
            del broken["source_forms"]
            with self.assertRaises(jsonschema.ValidationError):
                inv.rebuild([broken])

    def test_engine_commit_sidecars_and_exact_ticks(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "test_output.jsonl")
            sidecars = store_paths(out_path)
            jidx_path, sig_path = sidecars.jidx, sidecars.sig

            engine = JsonlEngine(output_path=out_path)
            with engine:
                engine.append({"a": 1})
                engine.append({"b": "hello ∫ f(x)dx"})
                engine.commit(stage_metadata={"test": True})

            self.assertTrue(os.path.exists(out_path))
            self.assertTrue(os.path.exists(jidx_path))
            self.assertTrue(os.path.exists(sig_path))

            index_obj = read_index(jidx_path, out_path)
            self.assertTrue(index_obj.is_current())
            self.assertTrue(JsonlStore(out_path).verify())


if __name__ == "__main__":
    unittest.main()
