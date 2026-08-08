"""Concurrent writers on one artifact.

The engine publishes by rename, which is atomic on its own. The transaction around it is not: a
commit publishes the store and then writes two sidecars against the file it just published. Two
writers interleaving across that sequence leave a store signed by neither.
"""

import os
import tempfile
import threading
import unittest

from jsonl_engine import JsonlEngine, JsonlStore
from jsonl_engine.sidecar import lock_path, temp_write_path


class TestScratchPaths(unittest.TestCase):
    def test_two_writers_do_not_share_a_scratch_file(self):
        """The bug the lease was masking: '{artifact}.tmp' is one path for every writer.

        Both transactions open it 'wb', interleave records into it, and the first rename publishes
        whatever the blend happened to be -- with a .sig covering only one writer's records.
        Windows surfaces this as a sharing violation; POSIX publishes the blend.
        """
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            first, second = JsonlEngine(output_path=path), JsonlEngine(output_path=path)
            with first:
                held = first.tmp_path
            with second:
                self.assertNotEqual(held, second.tmp_path)

    def test_a_scratch_path_is_per_transaction_not_per_engine(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            engine = JsonlEngine(output_path=path)
            with engine:
                first = engine.tmp_path
                engine.append({"n": 1})
                engine.commit()
            with engine:
                engine.append({"n": 2})
                engine.commit()
            self.assertNotEqual(first, engine.tmp_path)

    def test_no_scratch_file_survives_in_the_artifact_directory(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 1})
                engine.commit()
            self.assertEqual([], [f for f in os.listdir(tmpdir) if f.endswith(".tmp")])

    def test_the_lock_does_not_live_beside_the_artifact(self):
        """A lock is machine-local process coordination, not state a reader should ever see."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            self.assertNotEqual(os.path.dirname(lock_path(path)), tmpdir)
            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 1})
                engine.commit()
            self.assertEqual(["s.jsonl", "s.jsonl.jidx", "s.jsonl.sig"], sorted(os.listdir(tmpdir)))


class TestWriteLease(unittest.TestCase):
    def test_a_second_writer_is_refused_while_the_lease_is_held(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            holder = JsonlEngine(output_path=path)
            holder.__enter__()
            try:
                blocked = JsonlEngine(output_path=path, lock_timeout=0.3)
                with self.assertRaises(TimeoutError) as caught:
                    blocked.__enter__()
                self.assertIn("write lease", str(caught.exception))
            finally:
                holder.append({"w": "holder"})
                holder.commit()
                holder.__exit__(None, None, None)

    def test_the_lease_is_released_after_a_commit(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            for writer in ("a", "b"):
                with JsonlEngine(output_path=path, lock_timeout=1.0) as engine:
                    engine.append({"w": writer})
                    engine.commit()
            self.assertEqual([{"w": "b"}], list(JsonlStore(path)))

    def test_the_lease_is_released_after_a_failed_transaction(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with self.assertRaises(RuntimeError):
                with JsonlEngine(output_path=path) as engine:
                    engine.append({"n": 1})
                    raise RuntimeError("caller blew up")
            # A stuck lease would make this hang until the timeout, then raise.
            with JsonlEngine(output_path=path, lock_timeout=1.0) as engine:
                engine.append({"n": 2})
                engine.commit()
            self.assertEqual([{"n": 2}], list(JsonlStore(path)))

    def test_racing_writers_serialize_into_a_coherent_store(self):
        """Whichever writer wins, the published store is one writer's output and verifies."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            errors = []

            def write(tag):
                try:
                    with JsonlEngine(output_path=path, lock_timeout=20.0) as engine:
                        for n in range(20):
                            engine.append({"w": tag, "n": n})
                        engine.commit()
                except Exception as exc:  # noqa: BLE001 - surfaced by the assertion below
                    errors.append(exc)

            threads = [threading.Thread(target=write, args=(t,)) for t in "abcd"]
            for t in threads:
                t.start()
            for t in threads:
                t.join()

            self.assertEqual([], errors)
            records = list(JsonlStore(path))
            self.assertEqual(20, len(records))
            self.assertEqual(1, len({r["w"] for r in records}), "records blended across writers")
            self.assertTrue(JsonlStore(path).verify())

    def test_locking_can_be_declined(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path, lock=False) as engine:
                engine.append({"n": 1})
                engine.commit()
            self.assertEqual([{"n": 1}], list(JsonlStore(path)))


if __name__ == "__main__":
    unittest.main()
