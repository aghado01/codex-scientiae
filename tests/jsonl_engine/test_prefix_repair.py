"""inspect_prefix reports a valid JSONL prefix; repair_prefix publishes it onto the store."""

import json
import os
import tempfile
import unittest

from jsonl_engine.engine import Discipline, JsonlEngine
from jsonl_engine.inspect import (
    complete_prefix,
    inspect_prefix,
    inspect_store,
    repair_prefix,
)
from jsonl_engine.reader import JsonlStore
from jsonl_engine.sidecar import store_paths


def _seed(path: str, records) -> None:
    with JsonlEngine(output_path=path) as engine:
        for record in records:
            engine.append(record)
        engine.commit()


def _tear(path: str) -> None:
    with open(path, "ab") as handle:
        handle.write(b'{"n":3}\n{"n":4}\n{"n":5,"tor')


class TestInspectPrefix(unittest.TestCase):
    def test_missing_store_is_vacuously_valid(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "nope.jsonl")
            scan = inspect_prefix(path)
            self.assertFalse(scan.exists)
            self.assertTrue(scan.valid)
            self.assertEqual(0, scan.size)
            self.assertEqual(0, scan.valid_prefix_bytes)

    def test_torn_tail_stops_at_the_last_complete_record(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": n} for n in range(3)])
            _tear(path)
            scan = inspect_prefix(path)
            self.assertFalse(scan.valid)
            self.assertEqual(5, scan.record_count)
            self.assertEqual(complete_prefix(path), scan.valid_prefix_bytes)
            self.assertLess(scan.valid_prefix_bytes, scan.size)
            self.assertEqual(6, scan.error_line)
            self.assertIn("not terminated", scan.error)

    def test_invalid_json_line_is_excluded(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with open(path, "wb") as handle:
                handle.write(b'{"n":1}\n{"n":NaN}\n{"n":3}\n')
            scan = inspect_prefix(path)
            self.assertFalse(scan.valid)
            self.assertEqual(1, scan.record_count)
            self.assertEqual(len(b'{"n":1}\n'), scan.valid_prefix_bytes)
            self.assertEqual(2, scan.error_line)
            self.assertIn("non-finite", scan.error)

    def test_validator_failure_stops_the_prefix(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}, {"n": 2}, {"n": 3}])

            def refuse_two(record, line_number):
                if record.get("n") == 2:
                    raise ValueError("n=2 is refused")

            scan = inspect_prefix(path, validator=refuse_two)
            self.assertFalse(scan.valid)
            self.assertEqual(1, scan.record_count)
            self.assertEqual(2, scan.error_line)
            self.assertEqual("n=2 is refused", scan.error)

    def test_collect_records_returns_the_valid_prefix_only(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with open(path, "wb") as handle:
                handle.write(b'{"n":1}\nnot-json\n{"n":3}\n')
            scan = inspect_prefix(path, collect_records=True)
            self.assertEqual(({"n": 1},), scan.records)

    def test_it_does_not_take_the_write_lease(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            engine = JsonlEngine(
                output_path=path,
                discipline=Discipline.APPEND,
                lock_timeout=0.2,
            )
            engine.__enter__()
            try:
                scan = inspect_prefix(path)
                self.assertTrue(scan.valid)
                self.assertEqual(1, scan.record_count)
            finally:
                engine.__exit__(None, None, None)


class TestRepairPrefix(unittest.TestCase):
    def test_apply_keeps_the_valid_prefix_and_rewrites_sidecars(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": n} for n in range(3)])
            _tear(path)
            before = open(path, "rb").read()
            scan = inspect_prefix(path)
            receipt = repair_prefix(path, scan.valid_prefix_bytes)
            self.assertEqual(len(before) - scan.valid_prefix_bytes, receipt.removed_bytes)
            self.assertTrue(os.path.isfile(receipt.backup_path))
            with open(receipt.backup_path, "rb") as handle:
                self.assertEqual(before, handle.read())
            with open(path, "rb") as handle:
                self.assertEqual(before[: scan.valid_prefix_bytes], handle.read())
            self.assertTrue(receipt.signed)
            self.assertTrue(receipt.indexed)
            store = JsonlStore(path)
            self.assertEqual([{"n": n} for n in range(5)], list(store))
            self.assertTrue(store.verify())

    def test_refuses_a_bound_that_does_not_shorten_the_store(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            size = os.path.getsize(path)
            with self.assertRaises(ValueError) as caught:
                repair_prefix(path, size)
            self.assertIn("remove at least one byte", str(caught.exception))
            self.assertTrue(JsonlStore(path).verify())

    def test_refuses_a_non_boundary(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}, {"n": 2}])
            with self.assertRaises(ValueError) as caught:
                repair_prefix(path, 3)
            self.assertIn("not a complete-record boundary", str(caught.exception))


class TestRecoverUncommitted(unittest.TestCase):
    def test_default_append_still_refuses_an_unterminated_tail(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with open(path, "wb") as handle:
                handle.write(b'{"n":1}\n{"n":2}')
            with self.assertRaises(ValueError) as caught:
                engine = JsonlEngine(path, discipline=Discipline.APPEND)
                with engine:
                    engine.append({"n": 3})
                    engine.commit()
            self.assertIn("unterminated", str(caught.exception))
            with open(path, "rb") as handle:
                self.assertEqual(b'{"n":1}\n{"n":2}', handle.read())

    def test_opt_in_recover_drops_the_torn_tail_then_appends(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            with open(path, "ab") as handle:
                handle.write(b'{"n":2')
            with JsonlEngine(
                path,
                discipline=Discipline.APPEND,
                recover_uncommitted=True,
            ) as engine:
                engine.append({"n": 3})
                engine.commit()
            store = JsonlStore(path)
            self.assertEqual([{"n": 1}, {"n": 3}], list(store))
            self.assertTrue(store.verify())

    def test_recover_flag_is_append_only(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            with self.assertRaises(ValueError) as caught:
                JsonlEngine(path, recover_uncommitted=True)
            self.assertIn("append discipline", str(caught.exception))


class TestCliPrefixVerbs(unittest.TestCase):
    def _run(self, *args: str):
        import subprocess
        import sys

        return subprocess.run(
            [sys.executable, "-m", "jsonl_engine", *args],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=120,
        )

    def test_inspect_prefix_reports_a_torn_store(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            with open(path, "ab") as handle:
                handle.write(b'{"n":2')
            proc = self._run("inspect-prefix", path)
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            payload = json.loads(proc.stdout)
            self.assertFalse(payload["valid"])
            self.assertEqual(1, payload["record_count"])
            self.assertGreater(payload["size"], payload["valid_prefix_bytes"])

    def test_repair_prefix_is_a_dry_run_without_apply(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            with open(path, "ab") as handle:
                handle.write(b'{"n":2')
            before = open(path, "rb").read()
            proc = self._run("repair-prefix", path)
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            payload = json.loads(proc.stdout)
            self.assertTrue(payload["needed"])
            self.assertFalse(payload["applied"])
            with open(path, "rb") as handle:
                self.assertEqual(before, handle.read())

    def test_repair_prefix_apply_shortens_the_store(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "s.jsonl")
            _seed(path, [{"n": 1}])
            with open(path, "ab") as handle:
                handle.write(b'{"n":2')
            proc = self._run("repair-prefix", path, "--apply")
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            payload = json.loads(proc.stdout)
            self.assertTrue(payload["applied"])
            self.assertTrue(os.path.isfile(payload["backup"]))
            store = JsonlStore(path)
            self.assertEqual([{"n": 1}], list(store))
            self.assertTrue(store.verify())
            self.assertTrue(inspect_store(path).terminated)


if __name__ == "__main__":
    unittest.main()
