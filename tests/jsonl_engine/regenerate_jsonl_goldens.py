"""Explicit maintenance entry point for the JSONL byte-equality fixtures.

Run this file directly after an intentional byte-format decision, then review the binary fixture
diff before committing it. Pytest never imports or collects this utility.
"""

from __future__ import annotations

import os
import shutil
import tempfile

from jsonl_engine.sidecar import SCRATCH_ROOT_ENV

from jsonl_golden_cases import CASES, GOLDEN_DIR, emit


def main() -> int:
    os.makedirs(GOLDEN_DIR, exist_ok=True)
    with tempfile.TemporaryDirectory() as workspace:
        prior_scratch = os.environ.get(SCRATCH_ROOT_ENV)
        os.environ[SCRATCH_ROOT_ENV] = os.path.join(workspace, "json-scratch")
        try:
            for name, case in CASES.items():
                produced = os.path.join(workspace, name + ".jsonl")
                destination = os.path.join(GOLDEN_DIR, name + ".jsonl.golden")
                emit(case, produced)
                shutil.copyfile(produced, destination)
                print(os.path.relpath(destination, os.path.dirname(GOLDEN_DIR)))
        finally:
            if prior_scratch is None:
                os.environ.pop(SCRATCH_ROOT_ENV, None)
            else:
                os.environ[SCRATCH_ROOT_ENV] = prior_scratch
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
