"""Reader behaviour that is easy to regress: optional sidecars, policy diagnosis, refusals.

The byte-level cases live in test_byte_equality.py. These are about what the reader says when
something is off, and about the store configurations it has to tolerate.
"""

import os
import tempfile
import unittest

from jsonl_engine.engine import JsonlEngine
from jsonl_engine.policy import Eol
from jsonl_engine.reader import JsonlStore, read_json, read_json_or_none
from jsonl_engine.sidecar import store_paths


def _store(tmpdir: str, name: str = "s.jsonl", **engine_kwargs) -> str:
    path = os.path.join(tmpdir, name)
    with JsonlEngine(output_path=path, **engine_kwargs) as engine:
        engine.append({"a": 1})
        engine.append({"b": 2})
        engine.commit()
    return path


class TestStoreWithoutAnIndex(unittest.TestCase):
    """emit_index=False is a supported write, so the reader must not require the .jidx to exist."""

    def test_iteration_list_and_len_all_agree(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _store(tmpdir, emit_index=False)
            store = JsonlStore(path)
            expected = [{"a": 1}, {"b": 2}]

            # list() probes __len__ for a size hint, so it forces the index where a for-loop does
            # not. These three must not disagree.
            self.assertEqual(expected, [record for record in store])
            self.assertEqual(expected, list(store))
            self.assertEqual(2, len(store))

    def test_random_access_falls_back_to_scanning(self):
        """Absence of a sidecar is a normal state: slower to seek, not unreadable."""
        with tempfile.TemporaryDirectory() as tmpdir:
            store = JsonlStore(_store(tmpdir, emit_index=False))
            self.assertFalse(store.has_index)
            self.assertEqual({"a": 1}, store[0])
            self.assertEqual({"b": 2}, store[-1])
            self.assertEqual([{"a": 1}, {"b": 2}], store[0:2])

    def test_require_index_makes_absence_an_error(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = JsonlStore(_store(tmpdir, emit_index=False), require_index=True)
            with self.assertRaises(FileNotFoundError) as caught:
                store[0]
            self.assertIn("require_index is set", str(caught.exception))

    def test_a_stale_index_still_raises_because_absence_is_not_staleness(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _store(tmpdir)
            # Rewrite the store behind its index: same path, different bytes and mtime.
            with open(path, "ab") as handle:
                handle.write(b'{"c":3}\n')
            with self.assertRaises(ValueError) as caught:
                JsonlStore(path)[0]
            self.assertIn("Stale JSONL index", str(caught.exception))

    def test_verify_returns_none_when_the_store_is_unsigned(self):
        """None, not False: no check ran, so there is no failure to report."""
        with tempfile.TemporaryDirectory() as tmpdir:
            store = JsonlStore(_store(tmpdir, emit_sig=False, emit_index=False))
            self.assertFalse(store.has_signature)
            self.assertIsNone(store.verify())

    def test_require_sig_makes_an_unsigned_store_an_error(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = JsonlStore(
                _store(tmpdir, emit_sig=False, emit_index=False), require_sig=True
            )
            with self.assertRaises(FileNotFoundError):
                store.verify()


class TestPolicyDiagnosis(unittest.TestCase):
    def test_unknown_encoding_is_not_reported_as_a_framing_limit(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            with self.assertRaises(ValueError) as caught:
                JsonlStore(os.path.join(tmpdir, "s.jsonl"), encoding="utf8-typo")
            message = str(caught.exception)
            self.assertIn("unknown encoding", message)
            self.assertNotIn("frame", message)

    def test_utf16_is_refused_for_framing_with_its_own_reason(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            with self.assertRaises(ValueError) as caught:
                JsonlStore(os.path.join(tmpdir, "s.jsonl"), encoding="utf-16-le")
            self.assertIn("frame JSONL records", str(caught.exception))

    def test_utf16_is_fine_for_a_single_object(self):
        """The limit is line framing, not the encoding knob."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "doc.json")
            with open(path, "wb") as handle:
                handle.write('{"a":"∫"}'.encode("utf-16-le"))
            self.assertEqual({"a": "∫"}, read_json(path, encoding="utf-16-le"))

    def test_utf16_read_as_utf8_names_the_encoding(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "doc.json")
            with open(path, "wb") as handle:
                handle.write('{"a":1}'.encode("utf-16-le"))
            with self.assertRaises(ValueError) as caught:
                read_json(path)
            self.assertIn("NUL in JSON text", str(caught.exception))


class TestRefusals(unittest.TestCase):
    def test_blank_line_is_named_not_reported_as_malformed_json(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "b.jsonl")
            with open(path, "wb") as handle:
                handle.write(b'{"a":1}\n\n{"b":2}\n')
            with self.assertRaises(ValueError) as caught:
                list(JsonlStore(path))
            message = str(caught.exception)
            self.assertIn("blank line", message)
            self.assertIn("record 1", message)

    def test_foreign_sidecar_is_reported_as_foreign(self):
        """Another lane writes its own shape to .sig; that is not corruption."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _store(tmpdir)
            with open(store_paths(path).sig, "wb") as handle:
                handle.write(b'{"stage":"pdfdig-ir/words","records":0}')
            with self.assertRaises(ValueError) as caught:
                JsonlStore(path).verify()
            self.assertIn("not a JSONL engine signature", str(caught.exception))

    def test_bom_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "doc.json")
            with open(path, "wb") as handle:
                handle.write(b"\xef\xbb\xbf" + b'{"a":1}')
            with self.assertRaises(ValueError) as caught:
                read_json(path)
            self.assertIn("BOM", str(caught.exception))

    def test_nonfinite_number_extensions_are_not_json(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            for literal in (b"NaN", b"Infinity", b"-Infinity"):
                with self.subTest(literal=literal):
                    path = os.path.join(tmpdir, "doc.json")
                    with open(path, "wb") as handle:
                        handle.write(b'{"n":' + literal + b"}")
                    with self.assertRaises(ValueError) as caught:
                        read_json(path)
                    self.assertIn("not JSON", str(caught.exception))


class TestOptionalDocument(unittest.TestCase):
    def test_absent_is_none_but_malformed_is_still_an_error(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            self.assertIsNone(read_json_or_none(os.path.join(tmpdir, "nope.json")))

            path = os.path.join(tmpdir, "bad.json")
            with open(path, "wb") as handle:
                handle.write(b"{not json")
            with self.assertRaises(ValueError):
                read_json_or_none(path)


class TestTerminatorEnforcement(unittest.TestCase):
    def test_lf_store_read_as_crlf_is_refused(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _store(tmpdir)
            with self.assertRaises(ValueError) as caught:
                list(JsonlStore(path, eol=Eol.CRLF))
            self.assertIn("bare LF", str(caught.exception))

    def test_valid_looking_unterminated_tail_is_not_a_record(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "unterminated.jsonl")
            with open(path, "wb") as handle:
                handle.write(b'{"a":1}\n{"b":2}')

            with self.assertRaises(ValueError) as caught:
                list(JsonlStore(path))
            self.assertIn("no LF terminator", str(caught.exception))

            # len() scans when there is no index and must enforce the same framing contract.
            with self.assertRaises(ValueError):
                len(JsonlStore(path))

    def test_nonfinite_number_is_rejected_inside_a_store(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "nonfinite.jsonl")
            with open(path, "wb") as handle:
                handle.write(b'{"n":NaN}\n')
            with self.assertRaises(ValueError) as caught:
                list(JsonlStore(path))
            self.assertIn("not JSON", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
