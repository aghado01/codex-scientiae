"""Retained source-tree inventory and deterministic fingerprinting."""

from __future__ import annotations

import hashlib
import os
import stat
from contextlib import nullcontext
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

from jsonl_engine.publication import PinnedPublicationRoot, PublicationError

from procurement.errors import SourceMaterializationError
from procurement.source._safety import (
    _CHUNK_BYTES,
    _PortablePathRegistry,
    _plain_directory,
    _portable_relative,
    _same_path,
    _same_path_generation,
    _stat_identity,
)
from procurement.storage.safety import is_link_or_reparse
from procurement.source.contracts import ArchiveLimits, LatexSourceError


@dataclass(frozen=True, slots=True)
class TreeFile:
    """One file participating in a source-tree fingerprint."""

    path: str
    bytes: int
    sha256: str


@dataclass(frozen=True, slots=True)
class TreeFingerprint:
    """Deterministic source-tree identity compatible with jsonl_engine deposit."""

    sha256: str
    files: tuple[TreeFile, ...]
    count: int
    tex_count: int


@dataclass(frozen=True, slots=True)
class _TreeEntry:
    relative: str
    path: Path
    info: os.stat_result
    publication_root: PinnedPublicationRoot


def _tree_inventory(
    root: Path,
    *,
    limits: ArchiveLimits,
    publication_root: PinnedPublicationRoot,
) -> tuple[_TreeEntry, ...]:
    """Inventory one tree through retained directory routes."""

    if not _same_path(root.absolute(), Path(publication_root.path).absolute()):
        raise LatexSourceError("LaTeX source root does not match its retained directory")
    entries: list[_TreeEntry] = []
    registry = _PortablePathRegistry()
    pending = [""]
    total_bytes = 0
    seen_entries = 0
    while pending:
        relative_directory = pending.pop()
        context = (
            publication_root.pin_descendant(relative_directory)
            if relative_directory
            else nullcontext(publication_root)
        )
        try:
            with context as directory:
                directory_before = directory.stat_root()
                names = directory.list_names()
                directory_after = directory.stat_root()
                if _stat_identity(directory_before) != _stat_identity(directory_after):
                    display = directory.path
                    raise LatexSourceError(
                        f"source tree directory changed while it was enumerated: '{display}'"
                    )
                for name in names:
                    seen_entries += 1
                    if seen_entries > limits.max_entries:
                        raise LatexSourceError(
                            f"source tree exceeds the {limits.max_entries} entry boundary"
                        )
                    info = directory.stat_leaf(name)
                    relative = f"{relative_directory}/{name}" if relative_directory else name
                    try:
                        relative = _portable_relative(
                            relative,
                            limits=limits,
                            label="source tree path",
                            directory_member=False,
                        )
                    except SourceMaterializationError as exc:
                        raise LatexSourceError(str(exc)) from exc
                    display = publication_root.absolute_relative(relative)
                    if is_link_or_reparse(info):
                        raise LatexSourceError(
                            "source tree contains a symbolic link or reparse point: "
                            f"'{display}'"
                        )
                    if stat.S_ISDIR(info.st_mode):
                        try:
                            registry.add(relative, is_directory=True, member=False)
                        except SourceMaterializationError as exc:
                            raise LatexSourceError(str(exc)) from exc
                        pending.append(relative)
                        continue
                    if not stat.S_ISREG(info.st_mode):
                        raise LatexSourceError(
                            f"source tree entry is not a regular file: '{display}'"
                        )
                    if info.st_size < 0 or info.st_size > limits.max_member_bytes:
                        raise LatexSourceError(
                            "source tree file exceeds the "
                            f"{limits.max_member_bytes}-byte boundary: {relative!r}"
                        )
                    if info.st_size > limits.max_extracted_bytes - total_bytes:
                        raise LatexSourceError(
                            f"source tree exceeds the {limits.max_extracted_bytes}-byte boundary"
                        )
                    total_bytes += info.st_size
                    try:
                        registry.add(relative, is_directory=False, member=False)
                    except SourceMaterializationError as exc:
                        raise LatexSourceError(str(exc)) from exc
                    entries.append(
                        _TreeEntry(
                            relative=relative,
                            path=Path(display),
                            info=info,
                            publication_root=publication_root,
                        )
                    )
        except LatexSourceError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            display = (
                publication_root.absolute_relative(relative_directory)
                if relative_directory
                else publication_root.path
            )
            raise LatexSourceError(f"source tree cannot be enumerated: '{display}'") from exc
    try:
        publication_root.assert_current()
    except RuntimeError as exc:
        raise LatexSourceError(
            "source tree no longer names its retained directory generation"
        ) from exc
    if not entries:
        raise LatexSourceError(f"source tree is empty: '{root}'")
    entries.sort(key=lambda item: item.relative.encode("utf-16-be", "surrogatepass"))
    return tuple(entries)


def _stable_hash(entry: _TreeEntry) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    try:
        with entry.publication_root.open_stable_relative_file(entry.relative) as handle:
            before = os.fstat(handle.fileno())
            if (
                not stat.S_ISREG(before.st_mode)
                or is_link_or_reparse(before)
                or not _same_path_generation(before, entry.info)
            ):
                raise LatexSourceError(
                    f"source tree file changed before measurement: '{entry.path}'"
                )
            while chunk := handle.read(_CHUNK_BYTES):
                size += len(chunk)
                digest.update(chunk)
            after = os.fstat(handle.fileno())
    except LatexSourceError:
        raise
    except (OSError, PublicationError, RuntimeError, ValueError) as exc:
        raise LatexSourceError(f"source tree file cannot be read: '{entry.path}'") from exc
    if _stat_identity(before) != _stat_identity(after) or size != after.st_size:
        raise LatexSourceError(f"source tree file changed while being measured: '{entry.path}'")
    try:
        current = entry.publication_root.stat_relative(entry.relative)
    except (OSError, PublicationError, RuntimeError, ValueError) as exc:
        raise LatexSourceError(f"source tree file path changed: '{entry.path}'") from exc
    if (
        not stat.S_ISREG(current.st_mode)
        or is_link_or_reparse(current)
        or not _same_path_generation(after, current)
    ):
        raise LatexSourceError(f"source tree file path changed: '{entry.path}'")
    return size, digest.hexdigest()


def _same_inventory(left: Sequence[_TreeEntry], right: Sequence[_TreeEntry]) -> bool:
    return len(left) == len(right) and all(
        first.relative == second.relative
        and _stat_identity(first.info) == _stat_identity(second.info)
        for first, second in zip(left, right)
    )


def _fingerprint_inventory(
    root: Path,
    entries: Sequence[_TreeEntry],
    *,
    limits: ArchiveLimits,
    publication_root: PinnedPublicationRoot,
) -> TreeFingerprint:
    records: list[TreeFile] = []
    tree_digest = hashlib.sha256()
    tex_count = 0
    for entry in entries:
        size, digest = _stable_hash(entry)
        record = TreeFile(path=entry.relative, bytes=size, sha256=digest)
        records.append(record)
        tree_digest.update(f"{entry.relative}\0{size}\0{digest}\n".encode("utf-8", "strict"))
        if entry.relative.casefold().endswith(".tex"):
            tex_count += 1
    current = _tree_inventory(root, limits=limits, publication_root=publication_root)
    if not _same_inventory(entries, current):
        raise LatexSourceError("source tree changed while it was being fingerprinted")
    return TreeFingerprint(
        sha256=tree_digest.hexdigest(),
        files=tuple(records),
        count=len(records),
        tex_count=tex_count,
    )


def fingerprint_source_tree(
    root_path: str | os.PathLike[str],
    *,
    limits: ArchiveLimits | None = None,
    publication_root: PinnedPublicationRoot | None = None,
) -> TreeFingerprint:
    """Return the canonical source-tree fingerprint without following links."""

    selected_limits = ArchiveLimits() if limits is None else limits
    if not isinstance(selected_limits, ArchiveLimits):
        raise TypeError("limits must be an ArchiveLimits instance")
    if publication_root is None:
        try:
            root = _plain_directory(Path(root_path), label="LaTeX source root")
        except SourceMaterializationError as exc:
            raise LatexSourceError(str(exc)) from exc
        try:
            with PinnedPublicationRoot(str(root)) as retained:
                return fingerprint_source_tree(
                    root,
                    limits=selected_limits,
                    publication_root=retained,
                )
        except LatexSourceError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise LatexSourceError(
                f"LaTeX source root could not be retained: '{root}'"
            ) from exc
    else:
        try:
            publication_root.assert_current()
        except RuntimeError as exc:
            raise LatexSourceError(
                "LaTeX source root no longer names its retained directory"
            ) from exc
        root = Path(publication_root.path)
        if not _same_path(Path(root_path).absolute(), root.absolute()):
            raise LatexSourceError("LaTeX source root does not match its retained directory")
    entries = _tree_inventory(
        root,
        limits=selected_limits,
        publication_root=publication_root,
    )
    return _fingerprint_inventory(
        root,
        entries,
        limits=selected_limits,
        publication_root=publication_root,
    )


__all__ = ["TreeFile", "TreeFingerprint", "fingerprint_source_tree"]
