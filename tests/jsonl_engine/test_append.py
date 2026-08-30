"""APPEND discipline: adopting a published store into a new transaction.

Adoption is the one write path that reads. What it accepts has to match what the reader accepts,
or the engine produces stores that can be extended but not read.
"""

import os
import tempfile
import unittest

from jsonl_engine.engine import Discipline, JsonlEngine
from jsonl_engine.policy import Codec, Eol
from jsonl_engine.reader import JsonlStore


def _seed(path: str, records, eol: Eol = Eol.LF, **engine_kwargs) -> None:
    with JsonlEngine(output_path=path, eol=eol, **engine_kwargs) as engine:
        for record in records:
            engine.append(record)
        engine.commit()


def _extend(path: str, records, eol: Eol = Eol.LF, **engine_kwargs) -> None:
    engine = JsonlEngine(
        output_path=path,
        discipline=Discipline.APPEND,
        eol=eol,
        **engine_kwargs,
    )
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

    def test_unsigned_store_appends_under_the_callers_declared_policy(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "unsigned.jsonl")
            with open(path, "wb") as handle:
                handle.write('{"text":"café"}\n'.encode("latin-1"))

            _extend(path, [{"text": "touché"}], encoding="latin-1")

            store = JsonlStore(path, encoding="latin-1")
            self.assertEqual([{"text": "café"}, {"text": "touché"}], list(store))
            self.assertTrue(store.verify())


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

    def test_non_finite_json_extension_is_rejected_before_any_write(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":NaN}\n')
            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"n": 2}])
            message = str(caught.exception)
            self.assertIn("record 0", message)
            self.assertIn("non-finite numeric literal", message)
            with open(path, "rb") as handle:
                self.assertEqual(b'{"n":NaN}\n', handle.read())

    def test_signed_latin1_store_refuses_a_utf8_appender(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "signed.jsonl")
            _seed(path, [{"text": "café"}], encoding="latin-1")

            with self.assertRaises(ValueError) as caught:
                _extend(path, [{"text": "next"}], encoding="utf-8")
            message = str(caught.exception)
            self.assertIn("conflicting write policy", message)
            self.assertIn("encoding", message)
            self.assertIn("latin-1", message)
            self.assertIn("utf-8", message)

            store = JsonlStore(path, encoding="latin-1")
            self.assertEqual([{"text": "café"}], list(store))
            self.assertTrue(store.verify())

    def test_signature_policy_checks_eol_and_codec_too(self):
        cases = (
            ("eol", {"eol": Eol.CRLF}, {"eol": Eol.LF}),
            ("codec", {"codec": Codec.ASCII}, {"codec": Codec.UNICODE}),
        )
        for field, seed_kwargs, append_kwargs in cases:
            with self.subTest(field=field), tempfile.TemporaryDirectory() as tmpdir:
                path = os.path.join(tmpdir, "signed.jsonl")
                _seed(path, [{"text": "café"}], **seed_kwargs)

                with self.assertRaises(ValueError) as caught:
                    _extend(path, [{"text": "next"}], **append_kwargs)
                message = str(caught.exception)
                self.assertIn("conflicting write policy", message)
                self.assertIn(field, message)

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

    def test_tail_precheck_failure_releases_the_lease(self):
        """Keep the failed engine alive so FileLock finalization cannot hide a leaked lease."""
        with tempfile.TemporaryDirectory() as tmpdir:
            path = self._corrupt(tmpdir, b'{"n":1}')
            failed = JsonlEngine(
                output_path=path,
                discipline=Discipline.APPEND,
                lock_timeout=0.2,
            )
            with self.assertRaises(ValueError):
                failed.__enter__()

            # CREATE does not repeat the framing failure; it reaches the same artifact lease and
            # proves the failed __enter__ released it even while `failed` remains strongly held.
            with JsonlEngine(output_path=path, lock_timeout=0.2) as replacement:
                replacement.append({"n": 2})
                replacement.commit()
            self.assertEqual([{"n": 2}], list(JsonlStore(path)))


class TestInPlaceAppend(unittest.TestCase):
    """APPEND extends the published file; an uncommitted transaction restores the adopted prefix."""

    def test_append_to_an_absent_path_still_publishes_by_rename(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with JsonlEngine(output_path=path, discipline=Discipline.APPEND) as engine:
                self.assertFalse(engine._in_place)
                engine.append({"n": 1})
                self.assertTrue(os.path.lexists(engine.tmp_path))
                engine.commit()
            self.assertEqual([{"n": 1}], list(JsonlStore(path)))
            self.assertTrue(JsonlStore(path).verify())

    def test_it_does_not_stage_a_copy_of_the_published_bytes(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}, {"n": 2}])
            engine = JsonlEngine(output_path=path, discipline=Discipline.APPEND)
            with engine:
                self.assertTrue(engine._in_place)
                self.assertFalse(os.path.lexists(engine.tmp_path))
                engine.append({"n": 3})
                self.assertFalse(os.path.lexists(engine.tmp_path))
                engine.commit()
            self.assertEqual([{"n": 1}, {"n": 2}, {"n": 3}], list(JsonlStore(path)))
            self.assertTrue(JsonlStore(path).verify())

    def test_at_signature_still_verifies_the_adopted_commit_during_the_extend(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": n} for n in range(3)])
            with JsonlEngine(output_path=path, discipline=Discipline.APPEND) as engine:
                engine.append({"n": 3})
                view = JsonlStore(path).at_signature()
                self.assertEqual([{"n": n} for n in range(3)], list(view))
                self.assertTrue(view.verify())
                engine.commit()
            self.assertEqual([{"n": n} for n in range(4)], list(JsonlStore(path)))
            self.assertTrue(JsonlStore(path).verify())

    def test_an_uncommitted_transaction_restores_the_adopted_bytes_and_signature(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            before = open(path, "rb").read()
            with JsonlEngine(output_path=path, discipline=Discipline.APPEND) as engine:
                engine.append({"n": 2})
            with open(path, "rb") as handle:
                self.assertEqual(before, handle.read())
            self.assertTrue(JsonlStore(path).verify())
            self.assertEqual([{"n": 1}], list(JsonlStore(path)))

    def test_a_poisoned_mid_append_rolls_back_to_the_adopted_prefix(self):
        class FailAfterPassthrough:
            def __init__(self, handle):
                self.handle = handle
                self.fail = False

            @property
            def closed(self):
                return self.handle.closed

            def tell(self):
                return self.handle.tell()

            def write(self, raw):
                if self.fail:
                    raise OSError("simulated append failure")
                return self.handle.write(raw)

            def flush(self):
                self.handle.flush()

            def close(self):
                self.handle.close()

        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            before = open(path, "rb").read()
            with JsonlEngine(output_path=path, discipline=Discipline.APPEND) as engine:
                wrapper = FailAfterPassthrough(engine._file)
                engine._file = wrapper
                engine.append({"n": 2})
                wrapper.fail = True
                with self.assertRaisesRegex(OSError, "simulated append failure"):
                    engine.append({"n": 3})
                with self.assertRaisesRegex(RuntimeError, "poisoned"):
                    engine.commit()
            with open(path, "rb") as handle:
                self.assertEqual(before, handle.read())
            self.assertTrue(JsonlStore(path).verify())
            self.assertEqual([{"n": 1}], list(JsonlStore(path)))

    def test_sidecar_failure_after_extend_keeps_the_previous_signature(self):
        from unittest import mock

        from jsonl_engine import engine as engine_module

        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            with mock.patch.object(engine_module, "write_json", side_effect=OSError("disk full")):
                with JsonlEngine(output_path=path, discipline=Discipline.APPEND) as engine:
                    engine.append({"n": 2})
                    with self.assertRaises(RuntimeError) as caught:
                        engine.commit()
            message = str(caught.exception)
            self.assertIn("was extended but its sidecars were not rewritten", message)
            self.assertIn("previous signature still describes the adopted prefix", message)
            view = JsonlStore(path).at_signature()
            self.assertEqual([{"n": 1}], list(view))
            self.assertTrue(view.verify())
            self.assertEqual([{"n": 1}, {"n": 2}], list(JsonlStore(path).at_length()))


if __name__ == "__main__":
    unittest.main()
