"""Repository-local temporary-path boundary for pytest."""

from __future__ import annotations

import os
import sys
import tempfile
from pathlib import Path

import pytest

_REPOSITORY_ROOT = Path(__file__).resolve().parents[1]
_ARTIFACT_ROOT = (_REPOSITORY_ROOT / "artifacts").resolve()


def _resolved(value: str) -> Path:
    path = Path(value)
    if not path.is_absolute():
        path = Path.cwd() / path
    return path.resolve(strict=False)


def _require_artifact_path(value: str, *, label: str) -> Path:
    path = _resolved(value)
    if not path.is_relative_to(_ARTIFACT_ROOT):
        raise pytest.UsageError(
            f"{label} must be under the repository artifacts root: '{_ARTIFACT_ROOT}'"
        )
    return path


def pytest_configure(config: pytest.Config) -> None:
    """Reject pytest processes that could write through ambient temp or cache paths."""

    basetemp = config.getoption("basetemp")
    if not basetemp:
        raise pytest.UsageError(
            "pytest requires an explicit --basetemp under the repository artifacts root; "
            "use the repository test entrypoint"
        )
    _require_artifact_path(str(basetemp), label="pytest basetemp")

    temp_values = {name: os.environ.get(name) for name in ("TEMP", "TMP", "TMPDIR")}
    if any(not value for value in temp_values.values()):
        raise pytest.UsageError("TEMP, TMP, and TMPDIR must all be explicitly configured")
    resolved = {
        name: _require_artifact_path(value or "", label=name)
        for name, value in temp_values.items()
    }
    if len(set(resolved.values())) != 1:
        raise pytest.UsageError("TEMP, TMP, and TMPDIR must name one job-local directory")
    if not sys.dont_write_bytecode:
        raise pytest.UsageError("pytest must run with Python bytecode writes disabled")

    tempfile.tempdir = str(next(iter(resolved.values())))
