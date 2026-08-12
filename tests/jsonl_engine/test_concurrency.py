"""Concurrent writers on one artifact.

The engine publishes by rename, which is atomic on its own. The transaction around it is not: a
commit publishes the store and then writes two sidecars against the file it just published. Two
writers interleaving across that sequence leave a store signed by neither.
"""

import os
import tempfile
import threading
import time
import unittest
from unittest import mock

from jsonl_engine import JsonlEngine, JsonlStore
from jsonl_engine.sidecar import (
    SCRATCH_ROOT_ENV,
    find_stale_scratch,
    lock_path,
    scratch_root,
    store_paths,
    temp_write_path,
)
from jsonl_engine.writer import write_json


class TestScratchPaths(unittest.TestCase):
    def test_create_only_commit_does_not_replace_an_uncoordinated_writer(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            peer_bytes = b"peer-writer-owned\n"
            with self.assertRaises(FileExistsError):
                with JsonlEngine(output_path=path, require_absent=True) as engine:
                    engine.append({"writer": "engine"})
                    with open(path, "wb") as handle:
                        handle.write(peer_bytes)
                    engine.commit()
            with open(path, "rb") as handle:
                self.assertEqual(peer_bytes, handle.read())

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
            self.assertEqual(scratch_root(), os.path.dirname(lock_path(path)))
            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 1})
                engine.commit()
            self.assertEqual(["s.jsonl", "s.jsonl.jidx", "s.jsonl.sig"], sorted(os.listdir(tmpdir)))

    def test_atomic_document_writes_do_not_share_the_legacy_tmp_name(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "doc.json")
            legacy_tmp = path + ".tmp"
            with open(legacy_tmp, "wb") as handle:
                handle.write(b"another transaction")

            write_json(path, {"n": 1})

            with open(legacy_tmp, "rb") as handle:
                self.assertEqual(b"another transaction", handle.read())

    def test_scratch_glob_escapes_metacharacters_in_the_artifact_name(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s[draft].jsonl")
            paths = store_paths(path)
            expected = [
                temp_write_path(paths.artifact),
                temp_write_path(paths.jidx),
                temp_write_path(paths.sig),
            ]
            prefixed_artifact = temp_write_path(path + ".backup")
            malformed = [
                path + ".worker.0123456789ab.tmp",
                path + ".123.01AB.tmp",
                path + ".123..tmp",
                path + ".123.01ab.extra.tmp",
            ]
            for scratch in (*expected, prefixed_artifact, *malformed):
                with open(scratch, "wb") as handle:
                    handle.write(b"{}\n")

            self.assertEqual(sorted(expected), find_stale_scratch(path))

    def test_transaction_scratch_uses_compact_process_serials(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "doc.json")
            first = temp_write_path(path)
            second = temp_write_path(path)

            self.assertNotEqual(first, second)
            for candidate in (first, second):
                suffix = candidate.removeprefix(path + ".").removesuffix(".tmp")
                pid, serial = suffix.split(".")
                self.assertEqual(str(os.getpid()), pid)
                self.assertTrue(serial)
                self.assertTrue(all(char in "0123456789abcdef" for char in serial))
                self.assertLessEqual(len(serial), 4)

    @unittest.skipUnless(os.name == "nt", "Windows path identity is case-insensitive")
    def test_windows_case_aliases_share_one_lock(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "MixedCase.jsonl")
            self.assertEqual(lock_path(path), lock_path(path.swapcase()))


class TestScratchRoot(unittest.TestCase):
    def _production_root(self) -> str:
        """Resolve the production default without creating its shared directory."""
        with mock.patch.dict(os.environ, {}, clear=False):
            os.environ.pop(SCRATCH_ROOT_ENV, None)
            with mock.patch("jsonl_engine.sidecar.os.makedirs"):
                return scratch_root()

    def test_production_default_stays_on_the_repository_volume(self):
        """A process writing to the repo should not reach another volume to coordinate with itself."""
        from jsonl_engine.paths import RepoPaths

        root = self._production_root()
        self.assertTrue(
            root.startswith(RepoPaths.root()),
            f"scratch root {root} is outside the repository",
        )
        self.assertEqual(
            os.path.splitdrive(RepoPaths.root())[0], os.path.splitdrive(root)[0]
        )

    def test_production_default_is_flat_rather_than_run_stamped(self):
        """A lock is per-artifact and outlives any single run."""
        self.assertTrue(
            self._production_root().endswith(os.path.join("artifacts", "json-scratch"))
        )

    def test_process_override_uses_the_job_local_coordination_root(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            configured = os.path.join(tmpdir, "job", "json-scratch")
            artifact = os.path.join(tmpdir, "artifact.jsonl")
            with mock.patch.dict(os.environ, {SCRATCH_ROOT_ENV: configured}):
                self.assertEqual(os.path.abspath(configured), scratch_root())
                self.assertEqual(os.path.abspath(configured), os.path.dirname(lock_path(artifact)))
            self.assertTrue(os.path.isdir(configured))

    def test_process_override_must_be_an_absolute_directory(self):
        for configured in ("", "relative/scratch"):
            with self.subTest(configured=configured), mock.patch.dict(
                os.environ, {SCRATCH_ROOT_ENV: configured}
            ):
                with self.assertRaisesRegex(ValueError, SCRATCH_ROOT_ENV):
                    scratch_root()


class TestStaleScratchSweep(unittest.TestCase):
    """Scratch must live beside its target, so strays are swept rather than relocated."""

    def test_scratch_orphaned_by_a_dead_writer_is_removed_on_the_next_write(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            orphan = temp_write_path(path)
            with open(orphan, "wb") as handle:
                handle.write(b'{"half":"written"}\n')
            self.assertTrue(os.path.exists(orphan))

            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 1})
                engine.commit()

            self.assertFalse(os.path.exists(orphan))
            self.assertEqual(
                ["s.jsonl", "s.jsonl.jidx", "s.jsonl.sig"], sorted(os.listdir(tmpdir))
            )

    def test_the_sweep_is_skipped_without_a_lease(self):
        """Unleased, a stray is indistinguishable from a peer's work in progress."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            orphan = temp_write_path(path)
            with open(orphan, "wb") as handle:
                handle.write(b"{}\n")

            with JsonlEngine(output_path=path, lock=False) as engine:
                engine.append({"n": 1})
                engine.commit()

            self.assertTrue(os.path.exists(orphan), "must not delete what it cannot prove is stale")

    def test_the_sweep_does_not_delete_a_prefixed_artifacts_transaction(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            sibling_scratch = temp_write_path(path + ".backup")
            with open(sibling_scratch, "wb") as handle:
                handle.write(b"another artifact's live transaction")

            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 1})
                engine.commit()

            self.assertTrue(os.path.exists(sibling_scratch))

    def test_the_sweep_leaves_the_artifact_and_its_sidecars_alone(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 1})
                engine.commit()
            with JsonlEngine(output_path=path) as engine:
                engine.append({"n": 2})
                engine.commit()
            self.assertEqual([{"n": 2}], list(JsonlStore(path)))
            self.assertTrue(JsonlStore(path).verify())


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

            threads = [
                threading.Thread(target=write, args=(tag,), daemon=True)
                for tag in "abcd"
            ]
            for t in threads:
                t.start()

            deadline = time.monotonic() + 30.0
            for t in threads:
                t.join(max(0.0, deadline - time.monotonic()))

            alive = [t.name for t in threads if t.is_alive()]
            self.assertEqual([], alive, f"writer threads did not stop within 30s: {alive}")

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
