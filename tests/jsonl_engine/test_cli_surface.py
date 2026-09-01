"""The Python command boundary preserves JSONL data and failure semantics."""

import copy
import json
import os
import subprocess
import sys
import tempfile
import unittest

from jsonl_engine import JsonlEngine
from jsonl_engine.policy import Codec, Eol
from jsonl_engine.sidecar import SIG_SCHEMA_ID, store_paths
from jsonl_test_support import article as article_record


def _run_cli(*args: str) -> subprocess.CompletedProcess:
    """Invoke the package boundary and retain its byte-exact stdout/stderr contract."""
    return subprocess.run(
        [sys.executable, "-m", "jsonl_engine", *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=120,
    )


class TestCliBoundary(unittest.TestCase):
    def _write(self, path: str, records, **engine_options) -> None:
        with JsonlEngine(output_path=path, **engine_options) as engine:
            for record in records:
                engine.append(record)
            engine.commit()

    def test_ascii_codec_surrogate_crosses_the_utf8_process_boundary(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "surrogate.jsonl")
            self._write(path, [{"text": "\ud800"}], codec=Codec.ASCII)

            proc = _run_cli("head", path, "-n", "1")
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            self.assertEqual({"text": "\ud800"}, json.loads(proc.stdout))
            self.assertIn(b"\\ud800", proc.stdout)

    def test_unframed_success_remains_bare_compact_json(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "plain.jsonl")
            self._write(path, [{"n": 1}, None])

            proc = _run_cli("head", path, "-n", "2")
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            self.assertEqual(b'{"n":1}\nnull\n', proc.stdout)

    def test_ordered_find_skips_missing_and_incomparable_values(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "heterogeneous.jsonl")
            self._write(
                path,
                [
                    {"n": 2, "value": "12"},
                    {"name": "absent"},
                    {"n": "two", "value": [1, 2]},
                ],
            )

            proc = _run_cli("find", path, "/n", "gt", "1")
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            self.assertEqual(
                [{"n": 2, "value": "12"}],
                [json.loads(line) for line in proc.stdout.splitlines()],
            )

            contains = _run_cli("find", path, "/value", "contains", "1")
            self.assertEqual(0, contains.returncode, contains.stderr.decode("utf-8"))
            self.assertEqual(
                [{"n": "two", "value": [1, 2]}],
                [json.loads(line) for line in contains.stdout.splitlines()],
            )

    def test_default_verify_does_not_hide_an_unterminated_tail(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "torn.jsonl")
            self._write(path, [{"n": 1}])
            with open(path, "ab") as handle:
                handle.write(b'{"n":2')

            current = _run_cli("verify", path)
            self.assertEqual(1, current.returncode)
            self.assertNotEqual(b"", current.stderr)

            committed = _run_cli("verify", path, "--at-signature")
            self.assertEqual(0, committed.returncode, committed.stderr.decode("utf-8"))
            self.assertTrue(json.loads(committed.stdout)["verified"])

    def test_signature_policy_makes_crlf_readable_without_an_extra_flag(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "crlf.jsonl")
            self._write(path, [{"n": 1}], eol=Eol.CRLF)

            proc = _run_cli("head", path, "-n", "1")
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            self.assertEqual({"n": 1}, json.loads(proc.stdout))

    def test_malformed_optional_signature_does_not_block_an_ordinary_read(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "malformed-signature.jsonl")
            self._write(path, [{"n": 1}])
            with open(store_paths(path).sig, "w", encoding="utf-8", newline="\n") as handle:
                json.dump({"schema": SIG_SCHEMA_ID}, handle)

            count = _run_cli("count", path)
            self.assertEqual(0, count.returncode, count.stderr.decode("utf-8"))
            self.assertEqual({"count": 1}, json.loads(count.stdout))

            verified = _run_cli("verify", path)
            self.assertEqual(1, verified.returncode)
            self.assertNotEqual(b"", verified.stderr)

    def test_framed_output_preserves_sequence_and_value_cardinality(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "values.jsonl")
            self._write(path, [[1, 2], "scalar", None])

            proc = _run_cli("--framed", "head", path, "-n", "3")
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            frames = [json.loads(line) for line in proc.stdout.splitlines()]
            self.assertEqual([[1, 2], "scalar", None], [frame["value"] for frame in frames])
            self.assertEqual([0, 1, 2], [frame["sequence"] for frame in frames])
            for frame in frames:
                self.assertEqual("codex-scientiae/jsonl_engine-cli", frame["protocol"])
                self.assertEqual(1, frame["version"])
                self.assertEqual("value", frame["type"])

    def test_framed_json_keeps_array_scalar_and_null_as_one_value_each(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            for name, value in (("array", [1, 2]), ("scalar", 7), ("null", None)):
                path = os.path.join(tmpdir, f"{name}.json")
                with open(path, "w", encoding="utf-8", newline="\n") as handle:
                    json.dump(value, handle)

                proc = _run_cli("--framed", "json", path)
                self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
                frames = [json.loads(line) for line in proc.stdout.splitlines()]
                self.assertEqual(1, len(frames))
                self.assertEqual(0, frames[0]["sequence"])
                self.assertEqual(value, frames[0]["value"])

    def test_capabilities_reports_protocol_framing_and_stable_verbs(self):
        proc = _run_cli("capabilities")
        self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
        capabilities = json.loads(proc.stdout)
        self.assertEqual("codex-scientiae/jsonl_engine-cli", capabilities["protocol"])
        self.assertEqual(1, capabilities["version"])
        self.assertIs(True, capabilities["framing"])
        self.assertEqual(
            [
                "capabilities", "info", "count", "deposit", "build-inventory", "fold-inventory",
                "head", "tail",
                "range", "get", "select", "find", "validate-json", "verify", "sig", "snapshot",
                "inspect-prefix", "repair-prefix", "schemas", "json",
            ],
            capabilities["verbs"],
        )

        framed = _run_cli("--framed", "capabilities")
        self.assertEqual(0, framed.returncode, framed.stderr.decode("utf-8"))
        frame = json.loads(framed.stdout)
        self.assertEqual("value", frame["type"])
        self.assertEqual(capabilities, frame["value"])

    def test_validate_json_uses_the_shipped_schema_and_one_value_frame(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "article.json")
            article = article_record("validated")
            with open(path, "w", encoding="utf-8", newline="\n") as handle:
                json.dump(article, handle, ensure_ascii=False, indent=2, allow_nan=False)
                handle.write("\n")

            valid = _run_cli("--framed", "validate-json", path, "article.schema.json")
            self.assertEqual(0, valid.returncode, valid.stderr.decode("utf-8"))
            frame = json.loads(valid.stdout)
            self.assertEqual(0, frame["sequence"])
            self.assertEqual(article, frame["value"])

            invalid = copy.deepcopy(article)
            invalid["initialized_utc"] = "not-a-date-time"
            with open(path, "w", encoding="utf-8", newline="\n") as handle:
                json.dump(invalid, handle, ensure_ascii=False, indent=2, allow_nan=False)
                handle.write("\n")
            rejected = _run_cli("--framed", "validate-json", path, "article.schema.json")
            self.assertEqual(1, rejected.returncode)
            self.assertEqual(b"", rejected.stdout)
            self.assertEqual("JsonReaderError", json.loads(rejected.stderr)["error"])

    def test_validate_json_applies_article_deposit_semantics(self):
        cases = (
            "order",
            "archive-path",
            "tree-path",
            "counts",
            "derived-from",
            "entrypoint",
            "selection",
        )
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "candidate.json")
            for case in cases:
                with self.subTest(case=case):
                    invalid = article_record("semantic-cli")
                    archive = next(
                        item
                        for item in invalid["source_forms"]
                        if item["role"] == "latex-source-archive"
                    )
                    tree = next(
                        item
                        for item in invalid["source_forms"]
                        if item["role"] == "latex-source-tree"
                    )
                    if case == "order":
                        invalid["source_forms"][:2] = reversed(invalid["source_forms"][:2])
                    elif case == "archive-path":
                        archive["path"] = "other.tar.gz"
                        tree["derived_from"] = archive["path"]
                    elif case == "tree-path":
                        tree["path"] = "other-tex"
                    elif case == "counts":
                        tree["tex_files"] = tree["files"] + 1
                    elif case == "derived-from":
                        tree["derived_from"] = "other.tar.gz"
                    elif case == "entrypoint":
                        invalid["evidence"]["latex_source"]["entrypoint"] = "other.tex"
                    else:
                        invalid["evidence"]["latex_source"]["selection"] = "different"

                    with open(path, "w", encoding="utf-8", newline="\n") as handle:
                        json.dump(invalid, handle, ensure_ascii=False, indent=2, allow_nan=False)
                        handle.write("\n")
                    rejected = _run_cli(
                        "--framed", "validate-json", path, "article.schema.json"
                    )

                    self.assertEqual(1, rejected.returncode)
                    self.assertEqual(b"", rejected.stdout)
                    error = json.loads(rejected.stderr)
                    self.assertEqual("JsonReaderError", error["error"])
                    self.assertIn("schema validation failed", error["message"])

    def test_validate_json_does_not_dispatch_an_article_as_a_jsonl_header(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = os.path.join(tmpdir, "header.json")
            header = {
                "__type__": "header",
                "kind": "article",
                "version": "0.1",
                "created_at": "2026-08-08T00:00:00Z",
            }
            with open(path, "w", encoding="utf-8", newline="\n") as handle:
                json.dump(header, handle, ensure_ascii=False, indent=2, allow_nan=False)
                handle.write("\n")

            rejected = _run_cli("validate-json", path, "article.schema.json")

            self.assertEqual(1, rejected.returncode)
            self.assertEqual(b"", rejected.stdout)
            self.assertEqual("JsonReaderError", json.loads(rejected.stderr)["error"])

    def test_bad_arguments_are_one_json_error_line_with_exit_two(self):
        for prefix in ((), ("--framed",)):
            with self.subTest(prefix=prefix):
                proc = _run_cli(*prefix, "head")
                self.assertEqual(2, proc.returncode)
                self.assertEqual(b"", proc.stdout)
                self.assertEqual(1, len(proc.stderr.splitlines()))
                error = json.loads(proc.stderr)
                self.assertEqual(
                    {
                        "protocol": "codex-scientiae/jsonl_engine-cli",
                        "version": 1,
                        "type": "error",
                        "error": "ArgumentError",
                    },
                    {key: error[key] for key in ("protocol", "version", "type", "error")},
                )
                self.assertIn("required", error["message"])

    def test_runtime_failure_is_protocol_error_with_exit_one(self):
        proc = _run_cli("get", "does-not-exist.jsonl", "0")
        self.assertEqual(1, proc.returncode)
        self.assertEqual(b"", proc.stdout)
        self.assertEqual(1, len(proc.stderr.splitlines()))
        error = json.loads(proc.stderr)
        self.assertEqual("codex-scientiae/jsonl_engine-cli", error["protocol"])
        self.assertEqual(1, error["version"])
        self.assertEqual("error", error["type"])
        self.assertIn("error", error)
        self.assertIn("message", error)


if __name__ == "__main__":
    unittest.main()
