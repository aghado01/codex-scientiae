"""APPEND discipline: adopting a published store into a new transaction.

Adoption is the one write path that reads. What it accepts has to match what the reader accepts,
or the engine produces stores that can be extended but not read.
"""

import os
import tempfile
import unittest

from jsonl_engine.engine import Discipline, JsonlEngine
from jsonl_engine.policy import Eol
from jsonl_engine.reader import JsonlStore


def _seed(path: str, records, eol: Eol = Eol.LF) -> None:
    with JsonlEngine(output_path=path, eol=eol) as engine:
        for record in records:
            engine.append(record)
        engine.commit()


def _extend(path: str, records, eol: Eol = Eol.LF) -> None:
    engine = JsonlEngine(output_path=path, discipline=Discipline.APPEND, eol=eol)
    with engine:
        for record in records:
            engine.append(record)
        engine.commit()


class TestAppendRoundTrip(unittest.TestCase):
    def test_lf_store_extends_and_stays_readable(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}, {"n": 2}])
            _extend(path, [{"n": 3}, {"n": 4}])

            store = JsonlStore(path)
            self.assertEqual([{"n": i} for i in (1, 2, 3, 4)], list(store))
            self.assertEqual(4, len(store))
            self.assertTrue(store.verify())

    def test_crlf_store_extends_under_its_own_terminator(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}], eol=Eol.CRLF)
            _extend(path, [{"n": 2}], eol=Eol.CRLF)

            with open(path, "rb") as handle:
                raw = handle.read()
            self.assertEqual(b'{"n":1}\r\n{"n":2}\r\n', raw)
            self.assertTrue(JsonlStore(path, eol=Eol.CRLF).verify())

    def test_offsets_survive_adoption(self):
        """Adopted records keep byte offsets, so random access spans the seam."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}, {"n": 2}], eol=Eol.CRLF)
            _extend(path, [{"n": 3}], eol=Eol.CRLF)

            store = JsonlStore(path, eol=Eol.CRLF)
            self.assertEqual({"n": 1}, store[0])
            self.assertEqual({"n": 2}, store[1])
            self.assertEqual({"n": 3}, store[2])
            # Two-byte terminators: offsets advance by payload + 2, not payload + 1.
            self.assertEqual([0, 9, 18], store.index.offsets)


class TestAdoptionRefuses(unittest.TestCase):
    """A record the reader would refuse is a record adoption refuses."""

    def _corrupt(self, tmpdir: str, raw: bytes) -> str:
        path = os.path.join(tmpdir, "s.jsonl")
        with open(path, "wb") as handle:
            handle.write(raw)
        return path

    def test_blank_line(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\n\n{"n":2}\n')
            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"n": 3}])
            self.assertIn("record 1 of s.jsonl is blank", str(caught.exception))

    def test_cr_inside_a_record(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\n{"n":\r2}\n')
            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"n": 3}])
            self.assertIn("CR inside the record", str(caught.exception))

    def test_crlf_store_opened_as_lf(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\r\n')
            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"n": 2}], eol=Eol.LF)
            self.assertIn("CR inside the record", str(caught.exception))

    def test_lf_store_opened_as_crlf_fails_on_the_tail_precheck(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\n')
            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"n": 2}], eol=Eol.CRLF)
            self.assertIn("unterminated", str(caught.exception))

    def test_unterminated_final_record(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\n{"n":2}')
            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"n": 3}])
            self.assertIn("unterminated", str(caught.exception))

    def test_a_refused_adoption_leaves_nothing_behind(self):
        """__exit__ does not run when __enter__ raises, so the tmp must clean up itself."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\n\n')
            before = sorted(os.listdir(tmpdir))
            with self.assertRaises(ValueError):
                _extend(path, [{"n": 2}])
            self.assertEqual(before, sorted(os.listdir(tmpdir)))

    def test_the_published_store_is_untouched_by_a_refusal(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}\n\n')
            with self.assertRaises(ValueError):
                _extend(path, [{"n": 2}])
            with open(path, "rb") as handle:
                self.assertEqual(b'{"n":1}\n\n', handle.read())


if __name__ == "__main__":
    unittest.main()
