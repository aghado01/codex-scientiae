"""Subprocess contract for the locked procurement MCP runtime."""

from __future__ import annotations

import asyncio
import ctypes
import json
import os
from ctypes import wintypes
from pathlib import Path
from unittest import mock

import pytest
from mcp import Client, StdioServerParameters
from mcp.client import stdio as stdio_module


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
PACKAGE_UV = REPOSITORY_ROOT / "packages" / "uv" / "uv.exe"
MCP_REGISTRATION = REPOSITORY_ROOT / ".mcp.json"
RUNTIME_ARGS = [
    "run",
    "--project",
    str(REPOSITORY_ROOT),
    "--locked",
    "--no-sync",
    "--no-dev",
    "--offline",
    "scientiae-procurement",
]

_TH32CS_SNAPPROCESS = 0x00000002
_SYNCHRONIZE = 0x00100000
_PROCESS_QUERY_LIMITED_INFORMATION = 0x1000
_WAIT_OBJECT_0 = 0


class _ProcessEntry32W(ctypes.Structure):
    _fields_ = [
        ("dwSize", wintypes.DWORD),
        ("cntUsage", wintypes.DWORD),
        ("th32ProcessID", wintypes.DWORD),
        ("th32DefaultHeapID", ctypes.c_size_t),
        ("th32ModuleID", wintypes.DWORD),
        ("cntThreads", wintypes.DWORD),
        ("th32ParentProcessID", wintypes.DWORD),
        ("pcPriClassBase", wintypes.LONG),
        ("dwFlags", wintypes.DWORD),
        ("szExeFile", wintypes.WCHAR * 260),
    ]


def _windows_process_table() -> dict[int, tuple[int, str]]:
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    kernel32.CreateToolhelp32Snapshot.argtypes = [wintypes.DWORD, wintypes.DWORD]
    kernel32.CreateToolhelp32Snapshot.restype = wintypes.HANDLE
    kernel32.Process32FirstW.argtypes = [
        wintypes.HANDLE,
        ctypes.POINTER(_ProcessEntry32W),
    ]
    kernel32.Process32FirstW.restype = wintypes.BOOL
    kernel32.Process32NextW.argtypes = [
        wintypes.HANDLE,
        ctypes.POINTER(_ProcessEntry32W),
    ]
    kernel32.Process32NextW.restype = wintypes.BOOL
    kernel32.CloseHandle.argtypes = [wintypes.HANDLE]
    kernel32.CloseHandle.restype = wintypes.BOOL

    snapshot = kernel32.CreateToolhelp32Snapshot(_TH32CS_SNAPPROCESS, 0)
    if snapshot == ctypes.c_void_p(-1).value:
        raise ctypes.WinError(ctypes.get_last_error())
    records: dict[int, tuple[int, str]] = {}
    entry = _ProcessEntry32W()
    entry.dwSize = ctypes.sizeof(entry)
    try:
        present = kernel32.Process32FirstW(snapshot, ctypes.byref(entry))
        while present:
            records[int(entry.th32ProcessID)] = (
                int(entry.th32ParentProcessID),
                entry.szExeFile,
            )
            present = kernel32.Process32NextW(snapshot, ctypes.byref(entry))
    finally:
        kernel32.CloseHandle(snapshot)
    return records


def _descendants(parent_pid: int) -> dict[int, str]:
    table = _windows_process_table()
    descendants: dict[int, str] = {}
    frontier = {parent_pid}
    while frontier:
        children = {
            pid: name
            for pid, (ppid, name) in table.items()
            if ppid in frontier and pid not in descendants
        }
        descendants.update(children)
        frontier = set(children)
    return descendants


def _open_process_handles(process_ids: list[int]) -> list[int]:
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    kernel32.OpenProcess.argtypes = [wintypes.DWORD, wintypes.BOOL, wintypes.DWORD]
    kernel32.OpenProcess.restype = wintypes.HANDLE
    handles: list[int] = []
    for process_id in process_ids:
        handle = kernel32.OpenProcess(
            _SYNCHRONIZE | _PROCESS_QUERY_LIMITED_INFORMATION,
            False,
            process_id,
        )
        if not handle:
            raise ctypes.WinError(ctypes.get_last_error())
        handles.append(handle)
    return handles


def _assert_processes_exited(handles: list[int]) -> None:
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    kernel32.WaitForSingleObject.argtypes = [wintypes.HANDLE, wintypes.DWORD]
    kernel32.WaitForSingleObject.restype = wintypes.DWORD
    kernel32.CloseHandle.argtypes = [wintypes.HANDLE]
    kernel32.CloseHandle.restype = wintypes.BOOL
    try:
        for handle in handles:
            assert kernel32.WaitForSingleObject(handle, 5_000) == _WAIT_OBJECT_0
    finally:
        for handle in handles:
            kernel32.CloseHandle(handle)


@pytest.mark.skipif(os.name != "nt", reason="the committed uv bootstrap targets Windows")
def test_locked_uv_launches_from_unrelated_cwd_and_closes_process_tree(
    tmp_path: Path,
) -> None:
    assert PACKAGE_UV.is_file()
    unrelated = tmp_path / "unrelated"
    runtime_temp = tmp_path / "runtime-temp"
    unrelated.mkdir()
    runtime_temp.mkdir()

    environment = {
        "CODEX_SCIENTIAE_ROOT": str(REPOSITORY_ROOT),
        "UV_PROJECT_ENVIRONMENT": str(REPOSITORY_ROOT / ".venv"),
        "UV_PYTHON_INSTALL_DIR": str(REPOSITORY_ROOT / "packages" / "python"),
        "UV_CACHE_DIR": str(tmp_path / "uv-cache"),
        "UV_NO_PROGRESS": "1",
        "TEMP": str(runtime_temp),
        "TMP": str(runtime_temp),
        "TMPDIR": str(runtime_temp),
        "VIRTUAL_ENV": "",
        "PYTHONHOME": "",
        "PYTHONPATH": "",
    }
    parameters = StdioServerParameters(
        command=str(PACKAGE_UV),
        args=RUNTIME_ARGS,
        env=environment,
        cwd=str(unrelated),
    )

    async def exercise() -> tuple[object, dict[int, str], list[int]]:
        captured: list[object] = []
        create_process = stdio_module._create_platform_compatible_process

        async def capture_process(*args: object, **kwargs: object) -> object:
            process = await create_process(*args, **kwargs)
            captured.append(process)
            return process

        descendants: dict[int, str] = {}
        handles: list[int] = []
        with mock.patch.object(
            stdio_module,
            "_create_platform_compatible_process",
            side_effect=capture_process,
        ):
            async with Client(
                stdio_module.stdio_client(parameters),
                read_timeout_seconds=15,
            ) as client:
                result = await client.list_tools()
                assert len(result.tools) == 17
                assert result.tools[0].name == "discover_search"
                assert result.tools[-1].name == "list_procurement_providers"
                assert len(captured) == 1
                supervisor = captured[0]
                deadline = asyncio.get_running_loop().time() + 5
                while not descendants and asyncio.get_running_loop().time() < deadline:
                    descendants = await asyncio.to_thread(
                        _descendants,
                        supervisor.pid,
                    )
                    if not descendants:
                        await asyncio.sleep(0.05)
                handles = _open_process_handles(list(descendants))
        return captured[0], descendants, handles

    supervisor, descendants, handles = asyncio.run(exercise())
    assert descendants, "uv did not expose its Python-hosted MCP child"
    assert any(
        name.casefold().startswith(("python", "scientiae-procurement"))
        for name in descendants.values()
    )
    assert supervisor.returncode == 0
    _assert_processes_exited(handles)
    assert list(unrelated.iterdir()) == []


@pytest.mark.skipif(os.name != "nt", reason="the committed uv bootstrap targets Windows")
def test_project_local_registration_launches_from_repository_root() -> None:
    document = json.loads(MCP_REGISTRATION.read_text(encoding="utf-8"))
    registration = document["mcpServers"]["scientiae-procurement"]
    assert registration["command"] == "./packages/uv/uv.exe"
    assert registration["args"][0:3] == ["run", "--project", "."]

    parameters = StdioServerParameters(
        command=registration["command"],
        args=registration["args"],
        env=registration["env"],
        cwd=str(REPOSITORY_ROOT),
    )

    async def exercise() -> object:
        captured: list[object] = []
        create_process = stdio_module._create_platform_compatible_process

        async def capture_process(*args: object, **kwargs: object) -> object:
            process = await create_process(*args, **kwargs)
            captured.append(process)
            return process

        with mock.patch.object(
            stdio_module,
            "_create_platform_compatible_process",
            side_effect=capture_process,
        ):
            async with Client(
                stdio_module.stdio_client(parameters),
                read_timeout_seconds=15,
            ) as client:
                result = await client.list_tools()
                assert len(result.tools) == 17
                assert len(captured) == 1
        return captured[0]

    supervisor = asyncio.run(exercise())
    assert supervisor.returncode == 0
