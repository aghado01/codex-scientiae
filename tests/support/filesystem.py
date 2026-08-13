"""Filesystem capability witnesses shared by Python test containers."""

from __future__ import annotations

import os
import subprocess
import unittest
from collections.abc import Iterator
from contextlib import contextmanager


@contextmanager
def directory_link(
    link: str | os.PathLike[str],
    target: str | os.PathLike[str],
) -> Iterator[None]:
    """Create a directory junction on Windows and a directory symlink elsewhere."""

    link_path = os.fspath(link)
    target_path = os.fspath(target)
    if os.name == "nt":
        process = subprocess.run(
            [
                os.environ.get("ComSpec", "cmd.exe"),
                "/d",
                "/c",
                "mklink",
                "/J",
                link_path,
                target_path,
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=10,
        )
        if process.returncode != 0 or not os.path.lexists(link_path):
            reason = (process.stderr or process.stdout).decode(
                "utf-8", errors="replace"
            ).strip()
            raise unittest.SkipTest(f"directory junctions are unavailable: {reason}")
    else:
        try:
            os.symlink(target_path, link_path, target_is_directory=True)
        except (OSError, NotImplementedError) as exc:
            raise unittest.SkipTest(
                f"directory symbolic links are unavailable: {exc}"
            ) from exc
    try:
        yield
    finally:
        if os.path.lexists(link_path):
            if os.name == "nt":
                os.rmdir(link_path)
            else:
                os.unlink(link_path)
