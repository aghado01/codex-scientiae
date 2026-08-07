"""
tests/shared/test_pwsh_interop.py - Interoperability test between Python JsonlEngine and PowerShell jsonl-v2.ps1
"""

import os
import tempfile
import subprocess
import unittest
from jsonl_engine import JsonlEngine
from jsonl_engine.paths import RepoPaths


class TestPwshInterop(unittest.TestCase):

    def test_powershell_reads_python_jidx_v2_index(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            jsonl_path = os.path.join(tmpdir, "interop.jsonl")
            jidx_path = os.path.join(tmpdir, "interop.jidx")

            with JsonlEngine(output_path=jsonl_path) as engine:
                engine.append({"id": "rec_0", "val": 100})
                engine.append({"id": "rec_1", "val": 200})
                engine.commit()

            # Anchored through the engine's own __file__-based resolver rather than the current
            # working directory, so the test passes from any invocation directory.
            ps1_path = RepoPaths.resolve("src", "shared", "jso-ops", "jsonl-v2.ps1").replace("\\", "/")

            ps_script = f"""
            . '{ps1_path}'
            $idx = Read-JsonlIndex -Path '{jsonl_path.replace('\\', '/')}' -IndexPath '{jidx_path.replace('\\', '/')}'
            Write-Host "VERSION:$($idx.Version)"
            Write-Host "COUNT:$($idx.LineCount)"
            Write-Host "IS_CURRENT:$($idx.IsCurrent('{jsonl_path.replace('\\', '/')}'))"
            """

            proc = subprocess.run(["pwsh", "-NoProfile", "-Command", ps_script], capture_output=True, text=True)
            output = proc.stdout
            if proc.returncode != 0 or "IS_CURRENT:True" not in output:
                print("STDOUT:", proc.stdout)
                print("STDERR:", proc.stderr)

            self.assertIn("VERSION:2", output)
            self.assertIn("COUNT:2", output)
            self.assertIn("IS_CURRENT:True", output)


if __name__ == "__main__":
    unittest.main()
