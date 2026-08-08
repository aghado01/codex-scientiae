"""Reading a store another process is appending to.

A writer publishes a replacement by rename, so a reader never sees half of one. It can see half of
an APPEND, which extends the file in place. The answer is a bound rather than a lock: a reader
takes no lease, because one long scan would stall every writer and a reader has nothing to protect.
"""

import os
import tempfile
import unittest

from jsonl_engine import JsonlEngine, JsonlStore
from jsonl_engine.inspect import complete_prefix, inspect_store, snapshot


def _signed_store(tmpdir: str, count: int = 3) -> str:
    path = os.path.join(tmpdir, "s.jsonl")
    with JsonlEngine(output_path=path) as engine:
        for n in range(count):
            engine.append({"n": n})
        engine.commit()
    return path


def _tear(path: str) -> None:
    """Extend past the signature and leave a record half-written, as an active append would."""
    with open(path, "ab") as handle:
        handle.write(b'{"n":3}\n{"n":4}\n{"n":5,"tor')


class TestInspect(unittest.TestCase):
    def test_it_reports_physical_facts_without_parsing(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            info = inspect_store(path)
            self.assertTrue(info.exists)
            self.assertEqual(5, info.line_count, "a partial tail is not a record")
            self.assertFalse(info.terminated)
            self.assertTrue(info.has_index and info.has_signature)

    def test_it_answers_for_a_store_that_does_not_exist(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            info = inspect_store(os.path.join(tmpdir, "nope.jsonl"))
            self.assertFalse(info.exists)
            self.assertTrue(info.is_empty)

    def test_it_reports_the_terminator_in_use(self):
        from jsonl_engine.policy import Eol

        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "c.jsonl")
            with JsonlEngine(output_path=path, eol=Eol.CRLF) as engine:
                engine.append({"n": 1})
                engine.commit()
            self.assertEqual(Eol.CRLF, inspect_store(path).eol)


class TestBoundedViews(unittest.TestCase):
    def test_an_unbounded_read_of_a_torn_store_fails(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            with self.assertRaises(ValueError):
                list(JsonlStore(path))

    def test_at_length_yields_whole_records_only(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            view = JsonlStore(path).at_length()
            self.assertEqual([{"n": n} for n in range(5)], list(view))
            self.assertEqual(5, len(view))

    def test_at_signature_yields_what_the_sig_attests_to_and_verifies(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            view = JsonlStore(path).at_signature()
            self.assertEqual([{"n": n} for n in range(3)], list(view))
            self.assertTrue(view.verify(), "a signed prefix must verify against its own signature")

    def test_random_access_respects_the_bound(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            view = JsonlStore(path).at_signature()
            self.assertEqual({"n": 2}, view[-1])
            with self.assertRaises(IndexError):
                view[3]

    def test_a_bounded_view_does_not_treat_a_grown_file_as_a_stale_index(self):
        """The index describing the whole file is expected to disagree with a prefix view."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            self.assertEqual(3, len(JsonlStore(path).at_signature()))

    def test_complete_prefix_excludes_the_record_in_progress(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            bound = complete_prefix(path)
            self.assertLess(bound, os.path.getsize(path))
            with open(path, "rb") as handle:
                self.assertTrue(handle.read(bound).endswith(b"\n"))


class TestSnapshot(unittest.TestCase):
    def test_it_copies_the_complete_prefix_byte_for_byte(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            _tear(path)
            destination = os.path.join(tmpdir, "snap", "s.jsonl")
            written = snapshot(path, destination)

            self.assertEqual(complete_prefix(path), written)
            self.assertEqual([{"n": n} for n in range(5)], list(JsonlStore(destination)))
            with open(path, "rb") as src, open(destination, "rb") as dst:
                self.assertEqual(src.read(written), dst.read())

    def test_a_snapshot_of_a_signed_prefix_still_verifies_against_that_sig(self):
        """No re-serialization: a reformatted snapshot would no longer match the source's hash."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = _signed_store(tmpdir)
            sig = JsonlStore(path).read_sig()
            _tear(path)

            destination = os.path.join(tmpdir, "snap.jsonl")
            snapshot(path, destination, limit=sig["file_size"])

            import hashlib

            with open(destination, "rb") as handle:
                self.assertEqual(sig["sha256"], hashlib.sha256(handle.read()).hexdigest())


if __name__ == "__main__":
    unittest.main()
