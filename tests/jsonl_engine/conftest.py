"""Process-local isolation shared by the Python test containers."""

from __future__ import annotations

import os

import pytest

from jsonl_engine.sidecar import SCRATCH_ROOT_ENV


@pytest.fixture(scope="session", autouse=True)
def _isolated_json_scratch(tmp_path_factory):
    """Keep engine lock files inside this pytest process's temporary boundary.

    A batch adapter may provide its own absolute job-local root. Direct pytest invocations receive
    an equally isolated session directory instead of touching the production repository default.
    """
    previous = os.environ.get(SCRATCH_ROOT_ENV)
    supplied = previous is not None
    if not supplied:
        os.environ[SCRATCH_ROOT_ENV] = os.fspath(tmp_path_factory.mktemp("json-scratch"))
    try:
        yield
    finally:
        if supplied:
            os.environ[SCRATCH_ROOT_ENV] = previous
        else:
            os.environ.pop(SCRATCH_ROOT_ENV, None)
