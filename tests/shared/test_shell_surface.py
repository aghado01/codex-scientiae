"""The PowerShell client module reads what the Python engine writes.

Replaces the old jsonl-v2 interop test. That one proved a PowerShell implementation of the JSONL
format agreed with the Python one; there is no longer a second implementation to agree with. What
is worth proving now is that the front-end works from a clean shell: it resolves an interpreter,
marshals arguments, and brings records back with their codepoints intact.

Skipped rather than failed when pwsh is absent, so the suite still runs on a machine without it.
"""

import json
import os
import signal
import shutil
import struct
import subprocess
import tempfile
import unittest

from jsonl_engine import JsonlEngine
from jsonl_engine.paths import RepoPaths

# SMP math, a ligature, and the replacement sentinel: the glyphs a default Windows console cannot
# render, which is exactly why they belong in a round-trip assertion rather than a screenshot.
GLYPHS = "∫ 𝔼[X] ﬁﬂﬃ 日本語 �"

CLIENT = RepoPaths.resolve(
    "src", "shared", "jsonl-engine-client", "jsonl-engine-client.psd1"
)


def _pwsh() -> str:
    configured = os.environ.get("CODEX_TEST_POWERSHELL_PATH")
    if configured is not None:
        return configured if os.path.isfile(configured) else ""
    return shutil.which("pwsh") or ""


def _terminate_process_tree(process: subprocess.Popen) -> None:
    """Bound cleanup for pwsh and the Python CLI process it launches."""
    if process.poll() is not None:
        return

    if os.name == "nt":
        try:
            subprocess.run(
                ["taskkill", "/PID", str(process.pid), "/T", "/F"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=10,
                check=False,
            )
        except (OSError, subprocess.TimeoutExpired):
            pass
    else:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except OSError:
            pass

    if process.poll() is None:
        process.kill()
    try:
        process.wait(timeout=10)
    except subprocess.TimeoutExpired:
        pass


@unittest.skipUnless(_pwsh(), "pwsh not available")
class TestPowerShellSurface(unittest.TestCase):
    def _run(self, script: str, store: str) -> str:
        body = (
            f"Import-Module '{CLIENT.replace(os.sep, '/')}' -ErrorAction Stop\n"
            f"$p = '{store.replace(os.sep, '/')}'\n{script}"
        )
        with tempfile.NamedTemporaryFile(
            "w", suffix=".ps1", delete=False, encoding="utf-8", newline="\n"
        ) as handle:
            handle.write(body)
            script_path = handle.name
        process_options = {}
        if os.name == "nt":
            process_options["creationflags"] = subprocess.CREATE_NEW_PROCESS_GROUP
        else:
            process_options["start_new_session"] = True
        try:
            proc = subprocess.Popen(
                [_pwsh(), "-NoProfile", "-File", script_path],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                encoding="utf-8",
                **process_options,
            )
            try:
                stdout, stderr = proc.communicate(timeout=120)
            except subprocess.TimeoutExpired:
                _terminate_process_tree(proc)
                try:
                    stdout, stderr = proc.communicate(timeout=5)
                except subprocess.TimeoutExpired:
                    stdout, stderr = "", "process pipes did not close after tree termination"
                self.fail(
                    "pwsh and its jsonl_engine child exceeded 120s:\n"
                    f"{stdout}\n{stderr}"
                )
        finally:
            os.unlink(script_path)
        if proc.returncode != 0:
            self.fail(f"pwsh failed ({proc.returncode}):\n{stdout}\n{stderr}")
        return stdout.strip()

    def _store(self, tmpdir: str) -> str:
        path = os.path.join(tmpdir, "s.jsonl")
        with JsonlEngine(output_path=path) as engine:
            for n, name in enumerate(("alpha", "beta", "gamma")):
                engine.append({"n": n, "name": name, "math": GLYPHS, "meta": {"tag": name[0]}})
            engine.commit()
        return path

    def test_it_reads_records_written_by_the_engine(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run("(Get-JsonlHead $p 3).name -join ','", store)
            self.assertEqual("alpha,beta,gamma", out)

    def test_codepoints_survive_the_round_trip(self):
        """The console cannot render these; the data still has to arrive intact.

        Compared as UTF-16 code units rather than code points, because that is what a .NET string
        is made of: 𝔼 is one code point to Python and a surrogate pair to PowerShell. Comparing
        ord() against [char[]] would fail on a correct round trip, which is a worse outcome than
        the drift it is meant to catch.
        """
        expected = list(
            struct.unpack(f"<{len(GLYPHS.encode('utf-16-le')) // 2}H", GLYPHS.encode("utf-16-le"))
        )
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run(
                "$m = (Get-JsonlRecord $p 0).math; "
                "(([int[]][char[]]$m) | ForEach-Object { $_.ToString() }) -join ','",
                store,
            )
            self.assertEqual(expected, [int(x) for x in out.split(",")])

    def test_a_json_pointer_projects_through_the_shell(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run("(Select-JsonlPath $p '/meta/tag') -join ','", store)
            self.assertEqual("a,b,g", out)

    def test_a_predicate_selects_records(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run("(Find-JsonlRecord $p '/n' gt 1).name", store)
            self.assertEqual("gamma", out)

    def test_it_verifies_the_signature_the_engine_wrote(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run("(Test-JsonlStore $p).verified", store)
            self.assertEqual("True", out)

    def test_the_signature_reports_the_declared_text_policy(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run(
                "$s = Get-JsonlSignature $p; '{0}/{1}/{2}' -f $s.encoding,$s.codec,$s.eol", store
            )
            self.assertEqual("utf-8/unicode/lf", out)

    def test_an_engine_error_surfaces_as_a_terminating_error(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run(
                "try { $null = Get-JsonlRecord $p 99; 'NO ERROR' } "
                "catch { $_.Exception.Message }",
                store,
            )
            self.assertIn("IndexError", out)

    def test_info_answers_without_parsing(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            store = self._store(tmpdir)
            out = self._run("(Get-JsonlInfo $p) | ConvertTo-Json -Compress", store)
            info = json.loads(out)
            self.assertEqual(3, info["line_count"])
            self.assertTrue(info["terminated"])
            self.assertTrue(info["has_signature"])


if __name__ == "__main__":
    unittest.main()
