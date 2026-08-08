"""The write path: sidecar transaction, and the two ways a kind can produce a store.

commit() publishes before it can build sidecars, because both record the published file's length
and ticks. These cover what happens in that window, and that the streamed and buffered writers are
interchangeable.
"""

import hashlib
import os
import tempfile
import unittest
from unittest import mock

import jsonschema

from jsonl_engine import engine as engine_module
from jsonl_engine.engine import Discipline, JsonlEngine
from jsonl_engine.reader import JsonlStore
from jsonl_engine.sidecar import store_paths
from jsonl_engine.kinds import BaseStore

from jsonl_test_support import article


class ArticleStore(BaseStore):
    """A plain JSONL store kind, declared here rather than shipped.

    The writer tests need an ordinary store: rows under a schema, no registry semantics and no
    single-object document. The package ships neither -- inventory is a registry now and article is
    a manifest -- and inventing one in the package to satisfy tests would be the tail wagging.
    """

    KIND = "test-article-store"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    NAME_FORMAT = "articles.jsonl"


class BrokenHeaderStore(ArticleStore):
    """A headered kind whose declared identity is deliberately contradicted."""

    KIND = "broken-header-store"
    EMIT_HEADER = True

    def header_fields(self):
        return {"kind": "not-broken-header-store"}


def _sha(path: str) -> str:
    with open(path, "rb") as handle:
        return hashlib.sha256(handle.read()).hexdigest()


class TestSidecarTransaction(unittest.TestCase):
    def test_a_normal_commit_writes_both_sidecars(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                eng.append({"n": 1})
                eng.commit()
            paths = store_paths(path)
            self.assertTrue(os.path.exists(paths.jidx))
            self.assertTrue(os.path.exists(paths.sig))

    def test_sidecar_failure_names_the_published_unsigned_state(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                eng.append({"n": 1})
                eng.commit()

            boom = OSError("disk full")
            with mock.patch.object(engine_module, "write_json", side_effect=boom):
                with JsonlEngine(output_path=path) as eng:
                    eng.append({"n": 2})
                    with self.assertRaises(RuntimeError) as caught:
                        eng.commit()

            message = str(caught.exception)
            self.assertIn("was published but its sidecars were not written", message)
            self.assertIn("disk full", message)
            self.assertIn("intact and unsigned", message)

    def test_a_stale_sidecar_is_removed_rather_than_left_describing_dead_bytes(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                eng.append({"n": 1})
                eng.commit()
            paths = store_paths(path)
            sig_path, jidx_path = paths.sig, paths.jidx
            self.assertTrue(os.path.exists(sig_path))
            self.assertTrue(os.path.exists(jidx_path))

            with mock.patch.object(engine_module, "write_json", side_effect=OSError("nope")):
                with JsonlEngine(output_path=path) as eng:
                    eng.append({"n": 2})
                    with self.assertRaises(RuntimeError) as caught:
                        eng.commit()

            # Both sidecars described the bytes this commit replaced, so both are named and gone.
            message = str(caught.exception)
            self.assertIn("Removed now-stale", message)
            self.assertIn(os.path.basename(jidx_path), message)
            self.assertIn(os.path.basename(sig_path), message)
            self.assertFalse(os.path.exists(sig_path), "stale .sig should not survive")
            self.assertFalse(os.path.exists(jidx_path), "stale .jidx should not survive")

            # The store itself is published, complete, and simply unsigned.
            self.assertEqual([{"n": 2}], list(JsonlStore(path)))

    def test_no_leftover_tmp_after_a_failed_commit(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with mock.patch.object(engine_module, "write_json", side_effect=OSError("nope")):
                with JsonlEngine(output_path=path) as eng:
                    eng.append({"n": 1})
                    with self.assertRaises(RuntimeError):
                        eng.commit()
            leftovers = [n for n in os.listdir(tmpdir) if n.endswith(".tmp")]
            self.assertEqual([], leftovers)

    def test_unsigned_by_request_is_still_a_clean_commit(self):
        """emit_sig=False is a declared choice, not the failure this transaction guards."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path, emit_sig=False, emit_index=False) as eng:
                eng.append({"n": 1})
                eng.commit()
            self.assertEqual([{"n": 1}], list(JsonlStore(path)))
            self.assertFalse(os.path.exists(os.path.join(tmpdir, "s.sig")))


class TestAppendTransactionState(unittest.TestCase):
    def test_a_caught_serialization_failure_does_not_advance_the_index(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                with self.assertRaises(ValueError) as caught:
                    eng.append({"not_json": object()})
                self.assertIn("record 0", str(caught.exception))
                self.assertIn(path, str(caught.exception))
                self.assertEqual([], eng.offsets)
                self.assertEqual(0, eng.line_count)

                eng.append({"n": 1})
                eng.commit()

            store = JsonlStore(path)
            self.assertEqual([{"n": 1}], list(store))
            self.assertEqual([0], store.index.offsets)
            self.assertEqual(1, store.read_sig()["line_count"])
            self.assertTrue(store.verify())

    def test_a_partial_stream_write_poisons_and_cannot_be_committed(self):
        class PartialThenFail:
            def __init__(self, handle):
                self.handle = handle

            @property
            def closed(self):
                return self.handle.closed

            def tell(self):
                return self.handle.tell()

            def write(self, raw):
                self.handle.write(raw[:3])
                raise OSError("simulated partial write")

            def close(self):
                self.handle.close()

        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                eng._file = PartialThenFail(eng._file)
                with self.assertRaisesRegex(OSError, "partial write"):
                    eng.append({"n": 1})
                self.assertEqual([], eng.offsets)
                self.assertEqual(0, eng.line_count)
                with self.assertRaisesRegex(RuntimeError, "poisoned"):
                    eng.commit()

            self.assertFalse(os.path.exists(path))
            self.assertEqual([], [name for name in os.listdir(tmpdir) if name.endswith(".tmp")])


class TestSidecarPolicy(unittest.TestCase):
    """Sidecars are declarable, on by default, and never orphaned once they exist."""

    def test_flags_are_honoured_on_a_store_with_no_sidecars(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "bare.jsonl")
            with JsonlEngine(output_path=path, emit_index=False, emit_sig=False) as eng:
                eng.append({"n": 1})
                eng.commit()
            paths = store_paths(path)
            self.assertFalse(os.path.exists(paths.jidx))
            self.assertFalse(os.path.exists(paths.sig))
            self.assertEqual([{"n": 1}], list(JsonlStore(path)))

    def test_an_existing_sidecar_is_rebuilt_even_when_the_write_declines_it(self):
        """Presence on disk is a standing request; the alternative is a sidecar describing
        bytes that no longer exist."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                eng.append({"n": 1})
                eng.commit()

            with JsonlEngine(
                output_path=path,
                discipline=Discipline.APPEND,
                emit_index=False,
                emit_sig=False,
            ) as eng:
                eng.append({"n": 2})
                eng.commit()

            store = JsonlStore(path)
            self.assertEqual([{"n": 1}, {"n": 2}], list(store))
            self.assertTrue(store.index.is_current(), "index must not be left stale")
            self.assertTrue(store.verify(), "signature must not be left stale")

    def test_the_same_holds_when_create_replaces_an_indexed_store(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path) as eng:
                eng.append({"n": 1})
                eng.commit()

            with JsonlEngine(output_path=path, emit_index=False, emit_sig=False) as eng:
                eng.append({"n": 99})
                eng.commit()

            store = JsonlStore(path)
            self.assertEqual([{"n": 99}], list(store))
            self.assertTrue(store.index.is_current())
            self.assertTrue(store.verify())

    def test_a_kind_declares_its_own_sidecar_policy(self):
        class Unsigned(ArticleStore):
            KIND = "test-unsigned-store"
            EMIT_INDEX = False
            EMIT_SIG = False

        with tempfile.TemporaryDirectory() as tmpdir:
            registry = Unsigned(target_dir=tmpdir)
            with registry.open_writer() as writer:
                writer.append(article())
                writer.commit()

            paths = store_paths(registry.get_output_path())
            self.assertFalse(os.path.exists(paths.jidx))
            self.assertFalse(os.path.exists(paths.sig))
            self.assertEqual([article()], list(registry.open_store()))

    def test_the_default_kind_is_signed_and_indexed(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = ArticleStore(target_dir=tmpdir)
            with registry.open_writer() as writer:
                writer.append(article())
                writer.commit()

            paths = store_paths(registry.get_output_path())
            self.assertTrue(os.path.exists(paths.jidx))
            self.assertTrue(os.path.exists(paths.sig))


class TestStoreWriter(unittest.TestCase):
    """Streamed and buffered are the same write; the choice is memory, not correctness."""

    def test_streaming_applies_the_kinds_validator(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = ArticleStore(target_dir=tmpdir)
            with self.assertRaises(Exception):
                with registry.open_writer() as writer:
                    writer.append({"not": "an article"})
                    writer.commit()
            self.assertFalse(
                os.path.exists(registry.get_output_path()),
                "a refused record must not leave a published store",
            )

    def test_a_rejected_header_releases_the_already_open_engine(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = BrokenHeaderStore(target_dir=tmpdir)
            writer = store.open_writer()

            with self.assertRaises(jsonschema.ValidationError):
                writer.__enter__()

            self.assertIsNone(writer.engine._lock)
            self.assertFalse(os.path.exists(store.get_output_path()))
            with JsonlEngine(store.get_output_path(), lock_timeout=0.1) as engine:
                engine.append({"recovered": True})
                engine.commit()

    def test_streamed_and_buffered_produce_identical_bytes(self):
        with tempfile.TemporaryDirectory() as d1, tempfile.TemporaryDirectory() as d2:
            buffered = ArticleStore(target_dir=d1)
            for _ in range(3):
                buffered.add(article())
            buffered_path = buffered.write()

            streamed = ArticleStore(target_dir=d2)
            with streamed.open_writer() as writer:
                for _ in range(3):
                    writer.append(article())
                writer.commit()

            self.assertEqual(_sha(buffered_path), _sha(streamed.get_output_path()))

    def test_sig_metadata_defaults_to_the_kind(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = ArticleStore(target_dir=tmpdir)
            with registry.open_writer() as writer:
                writer.append(article())
                writer.commit()

            sig = JsonlStore(registry.get_output_path()).read_sig()
            self.assertEqual(ArticleStore.KIND, sig["metadata"]["kind"])
            self.assertEqual(registry.VERSION, sig["metadata"]["version"])

    def test_the_store_reads_back_through_open_store(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = ArticleStore(target_dir=tmpdir)
            with registry.open_writer() as writer:
                writer.append(article())
                writer.commit()

            store = registry.open_store()
            self.assertEqual([article()], list(store))
            self.assertTrue(store.verify())


if __name__ == "__main__":
    unittest.main()
