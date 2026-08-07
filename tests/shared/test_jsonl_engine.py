"""
tests/shared/test_jsonl_engine.py - Unit Tests for Python JSONL Core Engine & Registry (V3)
"""

import os
import json
import tempfile
import unittest

from src.shared.jsonl_engine.engine import JsonlEngine, Discipline
from src.shared.jsonl_engine.registry import BaseArtifactRegistry
from src.shared.jsonl_engine.reader import ArtifactReader


class DummyRegistry(BaseArtifactRegistry):
    KIND = "test_kind"
    VERSION = "1.0"
    SCHEMA = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "type": "object",
        "required": ["__type__"],
        "oneOf": [
            {
                "properties": {
                    "__type__": {"const": "item"},
                    "id": {"type": "string"},
                    "value": {"type": "integer"}
                },
                "required": ["id", "value"]
            }
        ]
    }

    def add_item(self, item_id: str, value: int):
        self.add({"__type__": "item", "id": item_id, "value": value})


class TestJsonlEngineV3(unittest.TestCase):

    def test_engine_commit_sidecars(self):
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
            self.assertFalse(os.path.exists(out_path + ".tmp"))

            # Verify sig payload & hash
            self.assertTrue(ArtifactReader.verify_signature(out_path))

    def test_binary_index_v2_seeking(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "indexed.jsonl")
            jidx_path = os.path.join(tmpdir, "indexed.jidx")

            records = [{"id": f"rec_{i}", "val": i * 10} for i in range(5)]
            
            with JsonlEngine(output_path=out_path) as engine:
                for r in records:
                    engine.append(r)
                engine.commit()

            index_obj = ArtifactReader.read_index(jidx_path, out_path)
            self.assertEqual(index_obj.version, 2)
            self.assertEqual(index_obj.line_count, 5)

            # Seek directly using seek_record API
            rec3 = ArtifactReader.seek_record(out_path, 3, jidx_path)
            self.assertEqual(rec3["id"], "rec_3")
            self.assertEqual(rec3["val"], 30)

    def test_signature_verification_and_tamper_detection(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "signed.jsonl")
            sig_path = os.path.join(tmpdir, "signed.sig")

            with JsonlEngine(output_path=out_path) as engine:
                engine.append({"__type__": "test", "data": "alpha"})
                engine.commit()

            self.assertTrue(ArtifactReader.verify_signature(out_path, sig_path))

            # Tamper with the jsonl file
            with open(out_path, "ab") as f:
                f.write(b'{"tampered":true}\n')

            with self.assertRaises(ValueError):
                ArtifactReader.verify_signature(out_path, sig_path)

    def test_jsonschema_validation_and_header(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            reg = DummyRegistry(target_dir=tmpdir, run_id="run_01")
            reg.add_item("item_1", 100)
            reg.add_item("item_2", 200)

            # Header + records write cleanly without crashing
            file_written = reg.write()
            self.assertTrue(os.path.exists(file_written))

            records = list(ArtifactReader.read_records(file_written))
            self.assertEqual(len(records), 3)  # Header line + 2 item lines
            self.assertEqual(records[0]["__type__"], "header")
            self.assertEqual(records[0]["kind"], "test_kind")
            self.assertEqual(records[1]["id"], "item_1")

    def test_pdf_surrogate_escape_lossless(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "pdf_surrogates.jsonl")
            
            # Record containing lone surrogate from corrupt PDF font extraction
            surrogate_record = {"__type__": "token", "text": "Math symbol \ud800 unicode", "page": 1}
            
            with JsonlEngine(output_path=out_path) as engine:
                engine.append(surrogate_record)
                engine.commit()

            records = list(ArtifactReader.read_records(out_path))
            self.assertEqual(len(records), 1)
            self.assertIn("\ud800", records[0]["text"])

    def test_discipline_modes(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "discipline.jsonl")

            # CREATE
            with JsonlEngine(output_path=out_path, discipline=Discipline.CREATE) as engine:
                engine.append({"line": 1})
                engine.commit()

            records_v1 = list(ArtifactReader.read_records(out_path))
            self.assertEqual(len(records_v1), 1)

            # APPEND
            with JsonlEngine(output_path=out_path, discipline=Discipline.APPEND) as engine:
                engine.append({"line": 2})
                engine.commit()

            records_v2 = list(ArtifactReader.read_records(out_path))
            self.assertEqual(len(records_v2), 2)
            self.assertEqual(records_v2[1]["line"], 2)

            # SEALED
            with self.assertRaises(PermissionError):
                with JsonlEngine(output_path=out_path, discipline=Discipline.SEALED) as engine:
                    engine.append({"line": 3})


if __name__ == "__main__":
    unittest.main()
