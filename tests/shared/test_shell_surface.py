"""The PowerShell front-end reads what the Python engine writes.

Replaces the old jsonl-v2 interop test. That one proved a PowerShell implementation of the JSONL
format agreed with the Python one; there is no longer a second implementation to agree with. What
is worth proving now is that the front-end works from a clean shell: it resolves an interpreter,
marshals arguments, and brings records back with their codepoints intact.

Skipped rather than failed when pwsh is absent, so the suite still runs on a machine without it.
"""

import json
import os
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

SHELL = RepoPaths.resolve("src", "shared", "jsonl_engine", "jso-shell.ps1")


def _pwsh() -> str:
    return shutil.which("pwsh") or ""


@unittest.skipUnless(_pwsh(), "pwsh not available")
class TestShellSurface(unittest.TestCase):
    def _run(self, script: str, store: str) -> str:
        body = f". '{SHELL.replace(os.sep, '/')}'\n$p = '{store.replace(os.sep, '/')}'\n{script}"
        with tempfile.NamedTemporaryFile(
            "w", suffix=".ps1", delete=False, encoding="utf-8", newline="\n"
        ) as handle:
            handle.write(body)
            script_path = handle.name
        try:
            proc = subprocess.run(
                [_pwsh(), "-NoProfile", "-File", script_path],
                capture_output=True,
                text=True,
                encoding="utf-8",
                timeout=120,
            )
        finally:
            os.unlink(script_path)
        if proc.returncode != 0:
            self.fail(f"pwsh failed ({proc.returncode}):\n{proc.stdout}\n{proc.stderr}")
        return proc.stdout.strip()

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
