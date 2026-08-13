"""Shared filesystem-generation and reparse policy for procurement storage."""

from __future__ import annotations

import os
import stat
from collections.abc import Callable

from jsonl_engine.publication import PinnedPublicationRoot

ErrorFactory = Callable[[str], Exception]


def is_link_or_reparse(info: os.stat_result) -> bool:
    """Return whether a stat witness names a link or Windows reparse point."""

    return stat.S_ISLNK(info.st_mode) or bool(
        getattr(info, "st_file_attributes", 0)
        & getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)
    )


def same_directory_generation(left: os.stat_result, right: os.stat_result) -> bool:
    """Compare physical directory generations across platform stat APIs."""

    if left.st_ino or right.st_ino:
        return left.st_dev == right.st_dev and left.st_ino == right.st_ino
    left_birth = getattr(left, "st_birthtime_ns", None)
    right_birth = getattr(right, "st_birthtime_ns", None)
    if left_birth is not None or right_birth is not None:
        return left.st_dev == right.st_dev and left_birth == right_birth
    return left.st_dev == right.st_dev and getattr(
        left,
        "st_ctime_ns",
        None,
    ) == getattr(right, "st_ctime_ns", None)


def require_current(
    root: PinnedPublicationRoot,
    *,
    label: str,
    error: ErrorFactory,
) -> None:
    """Require a retained root to keep naming its captured generation."""

    try:
        root.assert_current()
    except RuntimeError as exc:
        raise error(f"{label} no longer names its retained directory generation") from exc


__all__ = ["is_link_or_reparse", "require_current", "same_directory_generation"]
