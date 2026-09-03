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
    """Require CODEX_TEMP under artifacts/. Ambient TEMP is not a substitute."""

    basetemp = config.getoption("basetemp")
    if not basetemp:
        raise pytest.UsageError(
            "pytest requires an explicit --basetemp under the repository artifacts root; "
            "use the repository test entrypoint"
        )
    _require_artifact_path(str(basetemp), label="pytest basetemp")

    codex_temp = os.environ.get("CODEX_TEMP")
    if not codex_temp:
        raise pytest.UsageError(
            "CODEX_TEMP must be an absolute path under the repository artifacts root; "
            "use the repository test entrypoint"
        )
    temp_root = _require_artifact_path(codex_temp, label="CODEX_TEMP")
    if not sys.dont_write_bytecode:
        raise pytest.UsageError("pytest must run with Python bytecode writes disabled")

    tempfile.tempdir = str(temp_root)
    for name in ("TEMP", "TMP", "TMPDIR"):
        os.environ[name] = str(temp_root)

    clock = os.environ.get("CODEX_PROCUREMENT_RATE_CLOCK")
    if clock:
        _require_artifact_path(clock, label="CODEX_PROCUREMENT_RATE_CLOCK")
    else:
        os.environ["CODEX_PROCUREMENT_RATE_CLOCK"] = str(temp_root / "procurement-rate-clock.json")
