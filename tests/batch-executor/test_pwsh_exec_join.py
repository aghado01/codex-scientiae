"""Joined MCP/executor fixture: pwsh_exec Job Object around a CDXSCI batch.

Skipped unless PWSH_EXEC_ROOT names a science-facility mcp/pwsh_exec checkout
with invocation.py. Does not import the executor into the MCP; the MCP child
loads batch-executor.psd1 itself.
"""

from __future__ import annotations

import json
import os
import sys
import threading
import time
import uuid
from pathlib import Path

import pytest

_REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
_EXECUTOR_MANIFEST = _REPOSITORY_ROOT / "src" / "batch-executor" / "batch-executor.psd1"


def _pwsh_exec_root() -> Path | None:
    raw = os.environ.get("PWSH_EXEC_ROOT")
    if not raw or not raw.strip():
        return None
    root = Path(raw.strip())
    if not root.is_dir():
        return None
    if not (root / "invocation.py").is_file():
        return None
    return root.resolve()


def _bundled_pwsh(root: Path) -> Path | None:
    configured = os.environ.get("MCP_POWERSHELL_EXECUTABLE")
    if configured and configured.strip():
        candidate = Path(configured.strip())
        if candidate.is_file():
            return candidate.resolve()
    bundled = root / "deps" / "bin" / "pwsh" / "pwsh.exe"
    if bundled.is_file():
        return bundled.resolve()
    return None


pytestmark = pytest.mark.skipif(
    _pwsh_exec_root() is None,
    reason="PWSH_EXEC_ROOT must name a pwsh_exec checkout with invocation.py",
)


@pytest.fixture(scope="module")
def pwsh_exec(tmp_path_factory):
    root = _pwsh_exec_root()
    assert root is not None
    executable = _bundled_pwsh(root)
    if executable is None:
        pytest.skip("pwsh_exec bundled/configured PowerShell executable is missing")
    sys.path.insert(0, str(root))
    import invocation  # noqa: WPS433 — client import of the MCP invocation module

    return {
        "root": root,
        "executable": str(executable),
        "invocation": invocation,
        "scratch": tmp_path_factory.mktemp("pwsh-exec-join"),
    }


def _run_mcp(pwsh_exec, code: str, *, timeout_seconds: float, output_name: str, cancel_event=None):
    out = pwsh_exec["scratch"] / output_name
    if out.exists():
        raise AssertionError(f"output_directory already exists: {out}")
    return pwsh_exec["invocation"].run(
        code,
        executable=pwsh_exec["executable"],
        profile=None,
        cwd=_REPOSITORY_ROOT,
        timeout_seconds=timeout_seconds,
        unbounded=False,
        output_directory=str(out),
        mcp_root=pwsh_exec["root"],
        cancel_event=cancel_event,
        cleanup_seconds=8,
    ), out


def _executor_preamble() -> str:
    manifest = json.dumps(str(_EXECUTOR_MANIFEST))
    return (
        "$ErrorActionPreference = 'Stop'; "
        f"Import-Module {manifest} -Force; "
    )


def _write_worker(directory: Path, name: str, body: str) -> Path:
    path = directory / name
    path.write_text(body, encoding="utf-8")
    return path


def _pid_running(pid: int) -> bool:
    if pid <= 0:
        return False
    try:
        import ctypes

        handle = ctypes.windll.kernel32.OpenProcess(0x00100000, False, pid)
        if handle:
            ctypes.windll.kernel32.CloseHandle(handle)
            return True
        return False
    except Exception:
        return False


def _parse_join_payload(stdout: str) -> dict:
    for line in reversed([part.strip() for part in stdout.splitlines() if part.strip()]):
        if line.startswith("{") and "cdxsci/join-fixture/0.1" in line:
            return json.loads(line)
    raise AssertionError(f"join fixture payload missing from stdout: {stdout!r}")


def test_normal_completion_correlates_mcp_and_executor_identities(pwsh_exec, tmp_path):
    worker = _write_worker(
        tmp_path,
        "join-ok.ps1",
        "param($Item, $Context, $RunspaceState, $CancellationToken)\n$Item.Value\n",
    )
    code = (
        _executor_preamble()
        + f"$worker = {json.dumps(str(worker))}; "
        + "$run = Invoke-BatchExecutor -InputObject @(@{ Id = 'join-ok'; Value = 42 }) "
        + "-ScriptPath $worker -ExecutionMode Runspace -WorkingDirectory "
        + f"{json.dumps(str(tmp_path))} -MaxWorkers 1 -CleanupTimeoutSeconds 8; "
        + "[pscustomobject]@{ schema = 'cdxsci/join-fixture/0.1'; "
        + "jobId = $run.Results[0].Id; state = [string]$run.Results[0].State; "
        + "cleanup = [string]$run.Cleanup.State; floor = [string]$run.Runtime.Floor; "
        + "value = $run.Results[0].Output[0] } | ConvertTo-Json -Compress"
    )
    result, out = _run_mcp(pwsh_exec, code, timeout_seconds=40, output_name=f"ok-{uuid.uuid4().hex}")
    assert result["schema"] == "pwsh_exec/invocation/0.1"
    assert result["outcome"] == "exited"
    assert result["success"] is True
    assert result["native_exit_code"] == 0
    assert result["cleanup"]["status"] in {"complete", "not-needed"}
    payload = _parse_join_payload(result["stdout"])
    assert payload["jobId"] == "join-ok"
    assert payload["state"] == "Succeeded"
    assert payload["cleanup"] == "Confirmed"
    assert payload["floor"] == "7.5"
    assert int(payload["value"]) == 42
    saved = json.loads((out / "result.json").read_text(encoding="utf-8"))
    assert saved["id"] == result["id"]


def test_worker_timeout_keeps_completed_sibling(pwsh_exec, tmp_path):
    worker = _write_worker(
        tmp_path,
        "join-timeout.ps1",
        "param($Item, $Context, $RunspaceState, $CancellationToken)\n"
        "if ($Item.Hang) { Start-Sleep -Seconds 30 }\n$Item.Id\n",
    )
    code = (
        _executor_preamble()
        + f"$worker = {json.dumps(str(worker))}; "
        + "$items = @("
        + "[pscustomobject]@{ Id = 'fast-sibling'; Hang = $false }, "
        + "[pscustomobject]@{ Id = 'hung-sibling'; Hang = $true; "
        + "ProcessSpec = @{ TimeoutSeconds = 2 } }"
        + "); "
        + "$run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker "
        + "-ExecutionMode Process -WorkingDirectory "
        + f"{json.dumps(str(tmp_path))} -MaxWorkers 2 -ExecutionTimeoutSeconds 12 "
        + "-ProcessTimeoutSeconds 30 -CleanupTimeoutSeconds 8; "
        + "[pscustomobject]@{ schema = 'cdxsci/join-fixture/0.1'; "
        + "states = @($run.Results.State); ids = @($run.Results.Id); "
        + "cleanup = [string]$run.Cleanup.State } | ConvertTo-Json -Compress"
    )
    result, _out = _run_mcp(
        pwsh_exec, code, timeout_seconds=40, output_name=f"worker-{uuid.uuid4().hex}"
    )
    assert result["outcome"] == "exited"
    payload = _parse_join_payload(result["stdout"])
    assert payload["ids"] == ["fast-sibling", "hung-sibling"]
    assert payload["states"] == ["Succeeded", "TimedOut"]
    assert payload["cleanup"] == "Confirmed"


def test_outer_timeout_contains_descendants_and_keeps_evidence(pwsh_exec, tmp_path):
    marker = tmp_path / "grandchild.pid"
    worker = _write_worker(
        tmp_path,
        "join-outer.ps1",
        "param($Item, $Context, $RunspaceState)\n"
        "$startInfo = [System.Diagnostics.ProcessStartInfo]::new()\n"
        "$startInfo.FileName = Join-Path $PSHOME 'pwsh.exe'\n"
        "$startInfo.UseShellExecute = $false\n"
        "$startInfo.CreateNoWindow = $true\n"
        "[void]$startInfo.ArgumentList.Add('-NoProfile')\n"
        "[void]$startInfo.ArgumentList.Add('-NonInteractive')\n"
        "[void]$startInfo.ArgumentList.Add('-Command')\n"
        "[void]$startInfo.ArgumentList.Add('Start-Sleep -Seconds 30')\n"
        "$grandchild = [System.Diagnostics.Process]::Start($startInfo)\n"
        "[System.IO.File]::WriteAllText([string]$Item.GrandchildPidPath, [string]$grandchild.Id)\n"
        "Start-Sleep -Seconds 30\n",
    )
    code = (
        _executor_preamble()
        + f"$worker = {json.dumps(str(worker))}; "
        + "$item = [pscustomobject]@{ Id = 'outer-hang'; GrandchildPidPath = "
        + f"{json.dumps(str(marker))} "
        + "}; "
        + "$null = Invoke-BatchExecutor -InputObject @($item) -ScriptPath $worker "
        + "-ExecutionMode Process -WorkingDirectory "
        + f"{json.dumps(str(tmp_path))} -MaxWorkers 1 -ProcessTimeoutSeconds 30 "
        + "-CleanupTimeoutSeconds 8"
    )
    result, out = _run_mcp(
        pwsh_exec, code, timeout_seconds=6, output_name=f"outer-{uuid.uuid4().hex}"
    )
    assert result["outcome"] == "timed-out"
    assert result["success"] is False
    assert (out / "result.json").is_file()
    saved = json.loads((out / "result.json").read_text(encoding="utf-8"))
    assert saved["id"] == result["id"]
    assert saved["outcome"] == "timed-out"
    if marker.is_file():
        grandchild = int(marker.read_text(encoding="utf-8").strip())
        deadline = time.monotonic() + 8
        while time.monotonic() < deadline and _pid_running(grandchild):
            time.sleep(0.1)
        assert not _pid_running(grandchild)


def test_cancel_then_reuse(pwsh_exec, tmp_path):
    worker = _write_worker(
        tmp_path,
        "join-cancel.ps1",
        "param($Item, $Context, $RunspaceState, $CancellationToken)\nStart-Sleep -Seconds 30\n",
    )
    code = (
        _executor_preamble()
        + f"$worker = {json.dumps(str(worker))}; "
        + "$null = Invoke-BatchExecutor -InputObject @(@{ Id = 'cancel-me' }) "
        + "-ScriptPath $worker -ExecutionMode Runspace -WorkingDirectory "
        + f"{json.dumps(str(tmp_path))} -MaxWorkers 1 -CleanupTimeoutSeconds 8"
    )
    cancel = threading.Event()

    def _cancel():
        time.sleep(1.5)
        cancel.set()

    thread = threading.Thread(target=_cancel, daemon=True)
    thread.start()
    first, _out = _run_mcp(
        pwsh_exec,
        code,
        timeout_seconds=20,
        output_name=f"cancel-{uuid.uuid4().hex}",
        cancel_event=cancel,
    )
    thread.join(timeout=5)
    assert first["outcome"] in {"cancelled", "timed-out"}
    assert first["success"] is False
    second, _out2 = _run_mcp(
        pwsh_exec,
        "Write-Output 'reuse-ok'",
        timeout_seconds=20,
        output_name=f"reuse-{uuid.uuid4().hex}",
    )
    assert second["outcome"] == "exited"
    assert second["success"] is True
    assert "reuse-ok" in second["stdout"]
    assert first["id"] != second["id"]
