"""Portable path and filesystem-generation policy for source processing."""

from __future__ import annotations

import ntpath
import os
import posixpath
import stat
from pathlib import Path
from typing import Literal

from procurement.errors import SourceMaterializationError
from procurement.domain.deposits import is_portable_leaf
from procurement.source.contracts import ArchiveLimits
from procurement.storage.safety import is_link_or_reparse
_CHUNK_BYTES = 1024 * 1024


def _stat_identity(info: os.stat_result) -> tuple[int, int, int, int, int | None]:
    return (
        info.st_dev,
        info.st_ino,
        info.st_size,
        info.st_mtime_ns,
        getattr(info, "st_ctime_ns", None),
    )


def _same_path_generation(handle: os.stat_result, path: os.stat_result) -> bool:
    """Compare handle and pathname witnesses across platform stat APIs."""

    if handle.st_ino and path.st_ino and (
        handle.st_dev != path.st_dev or handle.st_ino != path.st_ino
    ):
        return False
    return handle.st_size == path.st_size and handle.st_mtime_ns == path.st_mtime_ns


def _same_path(left: Path, right: Path) -> bool:
    return os.path.normcase(os.path.normpath(str(left))) == os.path.normcase(
        os.path.normpath(str(right))
    )


def _plain_directory(path: Path, *, label: str) -> Path:
    requested = path.absolute()
    try:
        info = requested.lstat()
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not accessible: '{requested}'") from exc
    if not stat.S_ISDIR(info.st_mode) or is_link_or_reparse(info):
        raise SourceMaterializationError(f"{label} must be a physical directory: '{requested}'")
    try:
        resolved = requested.resolve(strict=True)
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not resolvable: '{requested}'") from exc
    if not _same_path(requested, resolved):
        raise SourceMaterializationError(
            f"{label} must not traverse a symbolic link or reparse point: '{requested}'"
        )
    return resolved


def _regular_file(path: Path, *, label: str) -> Path:
    requested = path.absolute()
    try:
        info = requested.lstat()
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not accessible: '{requested}'") from exc
    if not stat.S_ISREG(info.st_mode) or is_link_or_reparse(info):
        raise SourceMaterializationError(f"{label} must be a physical regular file: '{requested}'")
    try:
        resolved = requested.resolve(strict=True)
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not resolvable: '{requested}'") from exc
    if not _same_path(requested, resolved):
        raise SourceMaterializationError(
            f"{label} must not traverse a symbolic link or reparse point: '{requested}'"
        )
    return resolved


def _portable_leaf(value: str, *, limits: ArchiveLimits) -> bool:
    return is_portable_leaf(value, max_utf8_bytes=limits.max_component_bytes)


def _portable_relative(
    value: str,
    *,
    limits: ArchiveLimits,
    label: str,
    directory_member: bool = False,
) -> str:
    if not isinstance(value, str) or not value or "\x00" in value:
        raise SourceMaterializationError(f"{label} is empty or contains NUL")
    text = value[:-1] if directory_member and value.endswith("/") else value
    if not text or text.startswith(("/", "\\")) or ntpath.splitdrive(text)[0]:
        raise SourceMaterializationError(f"{label} is rooted: {value!r}")
    if "\\" in text:
        raise SourceMaterializationError(f"{label} contains a non-portable backslash: {value!r}")
    components = text.split("/")
    if any(part in {"", ".", ".."} for part in components):
        raise SourceMaterializationError(
            f"{label} contains an empty or dot path segment: {value!r}"
        )
    if any(not _portable_leaf(part, limits=limits) for part in components):
        raise SourceMaterializationError(f"{label} is not a portable relative path: {value!r}")
    normalized = "/".join(components)
    if posixpath.normpath(normalized) != normalized:
        raise SourceMaterializationError(f"{label} is not normalized: {value!r}")
    if len(normalized.encode("utf-8")) > limits.max_path_bytes:
        raise SourceMaterializationError(f"{label} exceeds the portable path boundary: {value!r}")
    return normalized


class _PortablePathRegistry:
    """Detect case collisions and file/directory prefix conflicts."""

    def __init__(self) -> None:
        self._nodes: dict[str, tuple[str, Literal["file", "directory"]]] = {}
        self._members: dict[str, str] = {}

    def add(self, relative: str, *, is_directory: bool, member: bool) -> None:
        components = relative.split("/")
        for index in range(1, len(components) + 1):
            prefix = "/".join(components[:index])
            key = prefix.casefold()
            node_kind: Literal["file", "directory"] = (
                "directory" if index < len(components) or is_directory else "file"
            )
            current = self._nodes.get(key)
            if current is not None:
                if current[0] != prefix:
                    raise SourceMaterializationError(
                        f"source paths collide by portable case: {current[0]!r} and {prefix!r}"
                    )
                if current[1] != node_kind:
                    raise SourceMaterializationError(
                        f"source path is both a file and directory: {prefix!r}"
                    )
            else:
                self._nodes[key] = (prefix, node_kind)
        if member:
            key = relative.casefold()
            prior = self._members.get(key)
            if prior is not None:
                raise SourceMaterializationError(
                    f"source archive contains a duplicate or case-colliding member: "
                    f"{prior!r} and {relative!r}"
                )
            self._members[key] = relative
