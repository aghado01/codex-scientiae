"""Bounded LaTeX source archive extraction and tree inspection."""

from __future__ import annotations

import codecs
import gzip
import hashlib
import ntpath
import os
import posixpath
import re
import shutil
import stat
import tarfile
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Iterator, Literal, Sequence
from uuid import uuid4

from procurement.errors import SourceMaterializationError


_INVALID_PORTABLE_LEAF = frozenset('<>:"/\\|?*')
_WINDOWS_RESERVED_LEAVES = frozenset(
    {"CON", "PRN", "AUX", "NUL"}
    | {f"COM{number}" for number in range(1, 10)}
    | {f"LPT{number}" for number in range(1, 10)}
)
_DOCUMENT_CLASS = re.compile(r"\\documentclass(?:\s*\[[^\]]*\])?\s*\{")
_DOCUMENT_MARKER = re.compile(r"\\begin\s*\{\s*document\s*\}")
_INPUT_COMMAND = re.compile(r"\\(?:input|include)\s*\{([^{}]+)\}")
_CHUNK_BYTES = 1024 * 1024


class SourceArchiveError(SourceMaterializationError):
    """A source archive could not be safely expanded."""


class LatexSourceError(SourceMaterializationError):
    """An expanded LaTeX source tree did not satisfy the source contract."""


@dataclass(frozen=True, slots=True)
class ArchiveLimits:
    """Resource boundaries applied during extraction and source inspection."""

    max_archive_bytes: int = 4 * 1024 * 1024 * 1024
    max_gzip_payload_bytes: int = 4 * 1024 * 1024 * 1024
    max_extracted_bytes: int = 4 * 1024 * 1024 * 1024
    max_member_bytes: int = 4 * 1024 * 1024 * 1024
    max_entries: int = 100_000
    max_component_bytes: int = 255
    max_path_bytes: int = 4096
    max_tex_bytes: int = 32 * 1024 * 1024
    max_resolved_bytes: int = 64 * 1024 * 1024
    max_input_depth: int = 32

    def __post_init__(self) -> None:
        positive = (
            "max_archive_bytes",
            "max_gzip_payload_bytes",
            "max_extracted_bytes",
            "max_member_bytes",
            "max_entries",
            "max_component_bytes",
            "max_path_bytes",
            "max_tex_bytes",
            "max_resolved_bytes",
        )
        for name in positive:
            value = getattr(self, name)
            if type(value) is not int or value <= 0:
                raise ValueError(f"{name} must be a positive integer")
        if type(self.max_input_depth) is not int or self.max_input_depth < 0:
            raise ValueError("max_input_depth must be a non-negative integer")
        if self.max_member_bytes > self.max_extracted_bytes:
            raise ValueError("max_member_bytes cannot exceed max_extracted_bytes")


@dataclass(frozen=True, slots=True)
class ArchiveExtraction:
    """Result of expanding one gzip source archive into a private directory."""

    archive_path: str
    destination_path: str
    archive_kind: Literal["tar+gzip", "single-tex+gzip"]
    archive_entries: int
    archive_sha256: str
    gzip_payload_bytes: int
    extracted_bytes: int


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
class EmbeddedLatexMetadata:
    """Literal metadata declarations found in the resolved LaTeX source."""

    title_tex: str | None
    authors_tex: tuple[str, ...]
    doi: str | None


@dataclass(frozen=True, slots=True)
class LatexSourceInspection:
    """Validated entrypoint, source closure, metadata, and tree identity."""

    root_path: str
    entrypoint: str
    entrypoint_selection: str
    file_count: int
    tex_file_count: int
    tree_sha256: str
    files: tuple[TreeFile, ...]
    package_control_files: tuple[TreeFile, ...]
    embedded_metadata: EmbeddedLatexMetadata


@dataclass(frozen=True, slots=True)
class _TarMemberPlan:
    name: str
    relative: str
    is_directory: bool
    size: int


@dataclass(frozen=True, slots=True)
class _TreeEntry:
    relative: str
    path: Path
    info: os.stat_result


def _is_reparse(info: os.stat_result) -> bool:
    return bool(getattr(info, "st_file_attributes", 0) & 0x400)


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
    if not stat.S_ISDIR(info.st_mode) or stat.S_ISLNK(info.st_mode) or _is_reparse(info):
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
    if not stat.S_ISREG(info.st_mode) or stat.S_ISLNK(info.st_mode) or _is_reparse(info):
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
    if not value or value in {".", ".."} or value[-1] in {" ", "."}:
        return False
    if any(ord(char) < 32 or 0xD800 <= ord(char) <= 0xDFFF for char in value):
        return False
    if any(char in _INVALID_PORTABLE_LEAF for char in value):
        return False
    if value.split(".", 1)[0].upper() in _WINDOWS_RESERVED_LEAVES:
        return False
    try:
        utf8_length = len(value.encode("utf-8", "strict"))
        utf16_units = len(value.encode("utf-16-le", "strict")) // 2
    except UnicodeError:
        return False
    return utf8_length <= limits.max_component_bytes and utf16_units <= 255


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


def _safe_remove_private_directory(path: Path, *, parent: Path) -> None:
    if path.parent != parent or not path.name:
        raise SourceArchiveError(f"refusing to remove an unscoped extraction path: '{path}'")
    if os.path.lexists(path):
        shutil.rmtree(path)


def _has_tar_header(path: Path) -> bool:
    with path.open("rb") as handle:
        header = handle.read(512)
    if len(header) < 512 or not any(header):
        return False
    field = header[148:156].strip(b"\x00 ")
    if not field or any(byte not in b"01234567" for byte in field):
        return False
    try:
        expected = int(field, 8)
    except ValueError:
        return False
    actual = sum(header[:148]) + (8 * 0x20) + sum(header[156:])
    return actual == expected


def _is_tar_payload(path: Path) -> bool:
    looks_like_tar = False
    try:
        looks_like_tar = _has_tar_header(path)
        with tarfile.open(path, mode="r:") as archive:
            archive.next()
        return True
    except (tarfile.ReadError, EOFError, OSError) as exc:
        if looks_like_tar:
            raise SourceArchiveError(
                "gzip payload has a tar header but is not a readable tar archive"
            ) from exc
        return False


def _assert_tar_zero_tail(path: Path, *, terminator_offset: int) -> None:
    """Require a two-block tar terminator followed only by zero padding."""

    if terminator_offset < 0 or terminator_offset % tarfile.BLOCKSIZE:
        raise SourceArchiveError("source tar terminator is not block-aligned")
    try:
        with path.open("rb") as handle:
            handle.seek(terminator_offset)
            terminator = handle.read(2 * tarfile.BLOCKSIZE)
            if len(terminator) != 2 * tarfile.BLOCKSIZE or any(terminator):
                raise SourceArchiveError(
                    "source tar archive lacks a canonical two-zero-block terminator"
                )
            while chunk := handle.read(_CHUNK_BYTES):
                if any(chunk):
                    raise SourceArchiveError(
                        "source tar archive contains nonzero data after its first "
                        "canonical terminator"
                    )
    except SourceArchiveError:
        raise
    except OSError as exc:
        raise SourceArchiveError("source tar tail cannot be validated") from exc


def _plan_tar(path: Path, *, limits: ArchiveLimits) -> tuple[tuple[_TarMemberPlan, ...], int]:
    plans: list[_TarMemberPlan] = []
    registry = _PortablePathRegistry()
    extracted_bytes = 0
    regular_files = 0
    terminator_offset = 0
    try:
        with tarfile.open(path, mode="r:") as archive:
            for member in archive:
                if len(plans) >= limits.max_entries:
                    raise SourceArchiveError(
                        f"source archive exceeds the {limits.max_entries} member limit"
                    )
                if member.isdir():
                    is_directory = True
                elif member.isreg():
                    is_directory = False
                    if member.size < 0 or member.size > limits.max_member_bytes:
                        raise SourceArchiveError(
                            f"source archive member exceeds the {limits.max_member_bytes}-byte "
                            f"boundary: {member.name!r}"
                        )
                    if member.size > limits.max_extracted_bytes - extracted_bytes:
                        raise SourceArchiveError(
                            f"source archive exceeds the {limits.max_extracted_bytes}-byte "
                            "extraction boundary"
                        )
                    extracted_bytes += member.size
                    regular_files += 1
                else:
                    raise SourceArchiveError(
                        f"source archive contains an unsafe link or special member: {member.name!r}"
                    )
                try:
                    relative = _portable_relative(
                        member.name,
                        limits=limits,
                        label="source archive member path",
                        directory_member=is_directory,
                    )
                    registry.add(relative, is_directory=is_directory, member=True)
                except SourceMaterializationError as exc:
                    raise SourceArchiveError(str(exc)) from exc
                if is_directory and member.size not in (0,):
                    raise SourceArchiveError(
                        f"source archive directory has a nonzero payload size: {member.name!r}"
                    )
                plans.append(
                    _TarMemberPlan(
                        name=member.name,
                        relative=relative,
                        is_directory=is_directory,
                        size=member.size,
                    )
                )
            terminator_offset = archive.offset
    except SourceArchiveError:
        raise
    except (tarfile.TarError, EOFError, OSError) as exc:
        raise SourceArchiveError("gzip payload is not a complete readable tar archive") from exc
    if not plans or not regular_files:
        raise SourceArchiveError("source tar archive contains no regular files")
    _assert_tar_zero_tail(path, terminator_offset=terminator_offset)
    return tuple(plans), extracted_bytes


def _extract_tar(path: Path, destination: Path, plans: Sequence[_TarMemberPlan]) -> None:
    terminator_offset = 0
    try:
        with tarfile.open(path, mode="r:") as archive:
            iterator = iter(archive)
            for expected in plans:
                try:
                    member = next(iterator)
                except StopIteration as exc:
                    raise SourceArchiveError(
                        "source tar changed between validation and extraction"
                    ) from exc
                if (
                    member.name != expected.name
                    or member.isdir() != expected.is_directory
                    or member.size != expected.size
                ):
                    raise SourceArchiveError("source tar changed between validation and extraction")
                target = destination.joinpath(*expected.relative.split("/"))
                if expected.is_directory:
                    target.mkdir(parents=True, exist_ok=True)
                    continue
                target.parent.mkdir(parents=True, exist_ok=True)
                source = archive.extractfile(member)
                if source is None:
                    raise SourceArchiveError(
                        f"source tar member has no readable payload: {expected.relative!r}"
                    )
                written = 0
                try:
                    with target.open("xb") as output:
                        while written < expected.size:
                            chunk = source.read(min(_CHUNK_BYTES, expected.size - written))
                            if not chunk:
                                raise SourceArchiveError(
                                    f"source tar member is truncated: {expected.relative!r}"
                                )
                            output.write(chunk)
                            written += len(chunk)
                        output.flush()
                        os.fsync(output.fileno())
                finally:
                    source.close()
            try:
                next(iterator)
            except StopIteration:
                terminator_offset = archive.offset
            else:
                raise SourceArchiveError("source tar changed between validation and extraction")
    except SourceArchiveError:
        raise
    except (tarfile.TarError, EOFError, OSError) as exc:
        raise SourceArchiveError("source tar extraction failed") from exc
    _assert_tar_zero_tail(path, terminator_offset=terminator_offset)


def _tree_inventory(root: Path, *, limits: ArchiveLimits) -> tuple[_TreeEntry, ...]:
    entries: list[_TreeEntry] = []
    registry = _PortablePathRegistry()
    pending = [root]
    total_bytes = 0
    seen_entries = 0
    while pending:
        directory = pending.pop()
        try:
            directory_before = os.stat(directory, follow_symlinks=False)
            if not stat.S_ISDIR(directory_before.st_mode) or _is_reparse(directory_before):
                raise LatexSourceError(
                    f"source tree contains a symbolic link or reparse point: '{directory}'"
                )
            children = list(os.scandir(directory))
            directory_after = os.stat(directory, follow_symlinks=False)
            if _stat_identity(directory_before) != _stat_identity(directory_after):
                raise LatexSourceError(
                    f"source tree directory changed while it was enumerated: '{directory}'"
                )
        except LatexSourceError:
            raise
        except OSError as exc:
            raise LatexSourceError(f"source tree cannot be enumerated: '{directory}'") from exc
        for child in children:
            seen_entries += 1
            if seen_entries > limits.max_entries:
                raise LatexSourceError(
                    f"source tree exceeds the {limits.max_entries} entry boundary"
                )
            try:
                # ``DirEntry.stat`` returns zero device/inode fields on Windows even
                # when ``stat`` and ``fstat`` expose a stable file ID.  Capture the
                # pathname witness through ``os.stat`` so later handle comparisons
                # do not reject every unchanged file on that platform.
                info = os.stat(child.path, follow_symlinks=False)
            except OSError as exc:
                raise LatexSourceError(
                    f"source tree entry cannot be measured: '{child.path}'"
                ) from exc
            if stat.S_ISLNK(info.st_mode) or _is_reparse(info):
                raise LatexSourceError(
                    f"source tree contains a symbolic link or reparse point: '{child.path}'"
                )
            relative_native = os.path.relpath(child.path, root)
            if os.sep != "/" and "/" in relative_native:
                # A literal slash cannot occur in a Windows leaf; separators are converted below.
                raise LatexSourceError(f"source tree contains an invalid path: {relative_native!r}")
            relative = relative_native.replace(os.sep, "/")
            try:
                relative = _portable_relative(
                    relative,
                    limits=limits,
                    label="source tree path",
                    directory_member=False,
                )
            except SourceMaterializationError as exc:
                raise LatexSourceError(str(exc)) from exc
            if stat.S_ISDIR(info.st_mode):
                try:
                    registry.add(relative, is_directory=True, member=False)
                except SourceMaterializationError as exc:
                    raise LatexSourceError(str(exc)) from exc
                pending.append(Path(child.path))
                continue
            if not stat.S_ISREG(info.st_mode):
                raise LatexSourceError(f"source tree entry is not a regular file: '{child.path}'")
            if info.st_size < 0 or info.st_size > limits.max_member_bytes:
                raise LatexSourceError(
                    f"source tree file exceeds the {limits.max_member_bytes}-byte boundary: "
                    f"{relative!r}"
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
            entries.append(_TreeEntry(relative=relative, path=Path(child.path), info=info))
    if not entries:
        raise LatexSourceError(f"source tree is empty: '{root}'")
    entries.sort(key=lambda item: item.relative.encode("utf-16-be", "surrogatepass"))
    return tuple(entries)


def _stable_hash(entry: _TreeEntry) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    try:
        with entry.path.open("rb") as handle:
            before = os.fstat(handle.fileno())
            if (
                not stat.S_ISREG(before.st_mode)
                or _is_reparse(before)
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
    except OSError as exc:
        raise LatexSourceError(f"source tree file cannot be read: '{entry.path}'") from exc
    if _stat_identity(before) != _stat_identity(after) or size != after.st_size:
        raise LatexSourceError(f"source tree file changed while being measured: '{entry.path}'")
    try:
        current = entry.path.lstat()
    except OSError as exc:
        raise LatexSourceError(f"source tree file path changed: '{entry.path}'") from exc
    if (
        not stat.S_ISREG(current.st_mode)
        or _is_reparse(current)
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
    current = _tree_inventory(root, limits=limits)
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
) -> TreeFingerprint:
    """Return the canonical source-tree fingerprint without following links."""

    selected_limits = ArchiveLimits() if limits is None else limits
    if not isinstance(selected_limits, ArchiveLimits):
        raise TypeError("limits must be an ArchiveLimits instance")
    try:
        root = _plain_directory(Path(root_path), label="LaTeX source root")
    except SourceMaterializationError as exc:
        raise LatexSourceError(str(exc)) from exc
    entries = _tree_inventory(root, limits=selected_limits)
    return _fingerprint_inventory(root, entries, limits=selected_limits)


def _stable_read_text(entry: _TreeEntry, *, maximum: int) -> tuple[str, str]:
    if entry.info.st_size > maximum:
        raise LatexSourceError(
            f"LaTeX input exceeds the {maximum}-byte read boundary: {entry.relative!r}"
        )
    try:
        with entry.path.open("rb") as handle:
            before = os.fstat(handle.fileno())
            if not _same_path_generation(before, entry.info):
                raise LatexSourceError(
                    f"LaTeX input changed before it was read: {entry.relative!r}"
                )
            raw = handle.read(maximum + 1)
            after = os.fstat(handle.fileno())
    except LatexSourceError:
        raise
    except OSError as exc:
        raise LatexSourceError(f"LaTeX input cannot be read: {entry.relative!r}") from exc
    if (
        len(raw) > maximum
        or len(raw) != after.st_size
        or _stat_identity(before) != _stat_identity(after)
    ):
        raise LatexSourceError(f"LaTeX input changed while it was read: {entry.relative!r}")
    try:
        current = entry.path.lstat()
    except OSError as exc:
        raise LatexSourceError(f"LaTeX input path changed: {entry.relative!r}") from exc
    if (
        not stat.S_ISREG(current.st_mode)
        or _is_reparse(current)
        or not _same_path_generation(after, current)
    ):
        raise LatexSourceError(f"LaTeX input path changed: {entry.relative!r}")
    try:
        text = raw.decode("utf-8", "strict")
    except UnicodeDecodeError as exc:
        raise LatexSourceError(f"LaTeX source is not valid UTF-8: {entry.relative!r}") from exc
    if "\x00" in text:
        raise LatexSourceError(f"LaTeX source contains NUL: {entry.relative!r}")
    return text, hashlib.sha256(raw).hexdigest()


def _remove_line_comments(text: str) -> str:
    lines = re.split(r"\r?\n", text)
    cleaned: list[str] = []
    for line in lines:
        cut = len(line)
        for index, character in enumerate(line):
            if character != "%":
                continue
            slashes = 0
            cursor = index - 1
            while cursor >= 0 and line[cursor] == "\\":
                slashes += 1
                cursor -= 1
            if slashes % 2 == 0:
                cut = index
                break
        cleaned.append(line[:cut])
    return "\n".join(cleaned)


def _entrypoint(
    entries: Sequence[_TreeEntry],
    document_class_candidates: Sequence[str],
    *,
    slug: str,
    main_tex: str,
    limits: ArchiveLimits,
) -> tuple[str, str]:
    by_path = {entry.relative: entry for entry in entries}
    candidate_set = set(document_class_candidates)
    if main_tex:
        try:
            explicit = _portable_relative(
                main_tex,
                limits=limits,
                label="explicit LaTeX entrypoint",
            )
        except SourceMaterializationError as exc:
            raise LatexSourceError(str(exc)) from exc
        if explicit not in by_path or not explicit.casefold().endswith(".tex"):
            raise LatexSourceError(f"explicit LaTeX entrypoint is missing: {main_tex!r}")
        if explicit not in candidate_set:
            raise LatexSourceError(
                f"explicit LaTeX entrypoint has no document class declaration: {main_tex!r}"
            )
        return explicit, "explicit"

    candidates = sorted(
        document_class_candidates,
        key=lambda value: value.encode("utf-16-be", "surrogatepass"),
    )
    if not candidates:
        raise LatexSourceError("no LaTeX entrypoint with a document class declaration was found")
    if len(candidates) == 1:
        return candidates[0], "single-candidate"
    preferred = ([f"{slug}.tex"] if slug else []) + ["main.tex"]
    for leaf in preferred:
        hits = [
            candidate
            for candidate in candidates
            if posixpath.basename(candidate).casefold() == leaf.casefold()
        ]
        if len(hits) == 1:
            return hits[0], f"preferred-name:{leaf}"
    raise LatexSourceError(
        "ambiguous LaTeX entrypoint; specify main_tex. Candidates: " + ", ".join(candidates)
    )


def _resolve_inputs(
    entrypoint: str,
    entries: Sequence[_TreeEntry],
    expected_digests: dict[str, str],
    *,
    limits: ArchiveLimits,
) -> tuple[str, dict[str, str]]:
    by_path = {entry.relative: entry for entry in entries}
    digests: dict[str, str] = {}
    active: set[str] = set()

    def get_text(relative: str) -> str:
        text, digest = _stable_read_text(by_path[relative], maximum=limits.max_tex_bytes)
        prior = expected_digests.get(relative, digests.get(relative))
        if prior is not None and prior != digest:
            raise LatexSourceError(f"LaTeX input changed during inspection: {relative!r}")
        digests[relative] = digest
        return text

    def pieces(relative: str, depth: int) -> Iterator[str]:
        if depth > limits.max_input_depth:
            raise LatexSourceError(
                f"LaTeX input nesting exceeds the depth limit of {limits.max_input_depth}: "
                f"{relative!r}"
            )
        key = relative.casefold()
        if key in active:
            raise LatexSourceError(f"cyclic LaTeX input detected at {relative!r}")
        active.add(key)
        try:
            text = _remove_line_comments(get_text(relative))
            cursor = 0
            directory = posixpath.dirname(relative)
            for match in _INPUT_COMMAND.finditer(text):
                yield text[cursor : match.start()]
                name = match.group(1).strip()
                try:
                    requested = _portable_relative(
                        name,
                        limits=limits,
                        label=f"LaTeX input referenced by {relative!r}",
                    )
                except SourceMaterializationError as exc:
                    raise LatexSourceError(str(exc)) from exc
                candidates: list[str] = []
                for value in (requested, f"{requested}.tex"):
                    candidate = posixpath.join(directory, value) if directory else value
                    if candidate not in candidates:
                        candidates.append(candidate)
                selected = next(
                    (candidate for candidate in candidates if candidate in by_path),
                    None,
                )
                if selected is None:
                    raise LatexSourceError(
                        f"unresolved LaTeX input {name!r} referenced by {relative!r}"
                    )
                yield from pieces(selected, depth + 1)
                cursor = match.end()
            yield text[cursor:]
        finally:
            active.remove(key)

    output: list[str] = []
    total = 0
    for piece in pieces(entrypoint, 0):
        encoded = piece.encode("utf-8", "strict")
        if len(encoded) > limits.max_resolved_bytes - total:
            raise LatexSourceError(
                f"resolved LaTeX source exceeds the {limits.max_resolved_bytes}-byte boundary"
            )
        total += len(encoded)
        output.append(piece)
    return "".join(output), digests


def _braced_content(text: str, open_brace: int) -> str | None:
    depth = 0
    for index in range(open_brace, len(text)):
        character = text[index]
        slashes = 0
        cursor = index - 1
        while cursor >= 0 and text[cursor] == "\\":
            slashes += 1
            cursor -= 1
        escaped = slashes % 2 == 1
        if not escaped and character == "{":
            depth += 1
        elif not escaped and character == "}":
            depth -= 1
            if depth == 0:
                return text[open_brace + 1 : index]
    return None


def _command_values(text: str, command: str) -> tuple[str, ...]:
    pattern = re.compile(re.escape(f"\\{command}") + r"\s*(?:\[[^\]]*\]\s*)?\{")
    values: list[str] = []
    for match in pattern.finditer(text):
        value = _braced_content(text, match.end() - 1)
        if value is not None and value.strip():
            values.append(value.strip())
    return tuple(values)


def _embedded_metadata(text: str) -> EmbeddedLatexMetadata:
    titles = _command_values(text, "title")
    authors = _command_values(text, "author")
    dois = _command_values(text, "doi")
    return EmbeddedLatexMetadata(
        title_tex=titles[0] if titles else None,
        authors_tex=authors,
        doi=dois[0] if dois else None,
    )


class SourceArchiveExtractor:
    """Extract gzip-wrapped tar or single-TeX source into an exclusive private directory."""

    def __init__(self, limits: ArchiveLimits | None = None) -> None:
        self.limits = ArchiveLimits() if limits is None else limits
        if not isinstance(self.limits, ArchiveLimits):
            raise TypeError("limits must be an ArchiveLimits instance")

    def extract(
        self,
        archive_path: str | os.PathLike[str],
        destination_path: str | os.PathLike[str],
    ) -> ArchiveExtraction:
        """Create and populate ``destination_path`` without overwriting existing state."""

        try:
            archive = _regular_file(Path(archive_path), label="source archive")
            destination = Path(destination_path).absolute()
            parent = _plain_directory(destination.parent, label="source extraction parent")
        except SourceMaterializationError as exc:
            raise SourceArchiveError(str(exc)) from exc
        if destination.parent != parent or not destination.name:
            raise SourceArchiveError(
                "source extraction destination must be one child of its physical parent"
            )
        if os.path.lexists(destination):
            raise SourceArchiveError(
                f"source extraction destination already exists: '{destination}'"
            )
        try:
            destination.mkdir(mode=0o700)
        except OSError as exc:
            raise SourceArchiveError(
                f"source extraction destination could not be created: '{destination}'"
            ) from exc

        payload = parent / f".payload-{uuid4().hex}"
        archive_digest = hashlib.sha256()
        payload_bytes = 0
        archive_before: os.stat_result | None = None
        try:
            try:
                with archive.open("rb") as input_handle:
                    archive_before = os.fstat(input_handle.fileno())
                    if archive_before.st_size > self.limits.max_archive_bytes:
                        raise SourceArchiveError(
                            "source archive exceeds the "
                            f"{self.limits.max_archive_bytes}-byte boundary"
                        )
                    while chunk := input_handle.read(_CHUNK_BYTES):
                        archive_digest.update(chunk)
                    input_handle.seek(0)
                    if input_handle.read(2) != b"\x1f\x8b":
                        raise SourceArchiveError("source archive is not a gzip stream")
                    input_handle.seek(0)
                    with gzip.GzipFile(fileobj=input_handle, mode="rb") as compressed:
                        with payload.open("xb") as output:
                            while chunk := compressed.read(_CHUNK_BYTES):
                                if len(chunk) > self.limits.max_gzip_payload_bytes - payload_bytes:
                                    raise SourceArchiveError(
                                        "source gzip exceeds the "
                                        f"{self.limits.max_gzip_payload_bytes}-byte "
                                        "expansion boundary"
                                    )
                                payload_bytes += len(chunk)
                                output.write(chunk)
                            output.flush()
                            os.fsync(output.fileno())
                    archive_after = os.fstat(input_handle.fileno())
            except SourceArchiveError:
                raise
            except (gzip.BadGzipFile, EOFError, zlib.error, OSError) as exc:
                raise SourceArchiveError(
                    "source archive is not a complete readable gzip stream"
                ) from exc
            if archive_before is None or (
                _stat_identity(archive_before) != _stat_identity(archive_after)
            ):
                raise SourceArchiveError("source archive changed while it was being expanded")
            try:
                current = archive.lstat()
            except OSError as exc:
                raise SourceArchiveError(
                    "source archive path changed while it was being expanded"
                ) from exc
            if (
                not stat.S_ISREG(current.st_mode)
                or _is_reparse(current)
                or not _same_path_generation(archive_after, current)
            ):
                raise SourceArchiveError("source archive path changed while it was being expanded")
            if payload_bytes == 0:
                raise SourceArchiveError("source gzip expands to an empty payload")

            if _is_tar_payload(payload):
                plans, extracted_bytes = _plan_tar(payload, limits=self.limits)
                _extract_tar(payload, destination, plans)
                archive_kind: Literal["tar+gzip", "single-tex+gzip"] = "tar+gzip"
                entry_count = len(plans)
            else:
                if payload_bytes > self.limits.max_member_bytes:
                    raise SourceArchiveError(
                        "single-TeX payload exceeds the "
                        f"{self.limits.max_member_bytes}-byte boundary"
                    )
                target = destination / "main.tex"
                decoder = codecs.getincrementaldecoder("utf-8")("strict")
                try:
                    with payload.open("rb") as source, target.open("xb") as output:
                        while chunk := source.read(_CHUNK_BYTES):
                            if "\x00" in decoder.decode(chunk, final=False):
                                raise SourceArchiveError("single-TeX gzip payload contains NUL")
                            output.write(chunk)
                        if "\x00" in decoder.decode(b"", final=True):
                            raise SourceArchiveError("single-TeX gzip payload contains NUL")
                        output.flush()
                        os.fsync(output.fileno())
                except UnicodeDecodeError as exc:
                    raise SourceArchiveError("single-TeX gzip payload is not valid UTF-8") from exc
                archive_kind = "single-tex+gzip"
                entry_count = 1
                extracted_bytes = payload_bytes

            _tree_inventory(destination, limits=self.limits)
            return ArchiveExtraction(
                archive_path=str(archive),
                destination_path=str(destination),
                archive_kind=archive_kind,
                archive_entries=entry_count,
                archive_sha256=archive_digest.hexdigest(),
                gzip_payload_bytes=payload_bytes,
                extracted_bytes=extracted_bytes,
            )
        except Exception:
            _safe_remove_private_directory(destination, parent=parent)
            raise
        finally:
            if os.path.lexists(payload):
                try:
                    payload.unlink()
                except OSError:
                    pass


class LatexSourceInspector:
    """Validate an extracted LaTeX tree and return its source-ready facts."""

    def __init__(self, limits: ArchiveLimits | None = None) -> None:
        self.limits = ArchiveLimits() if limits is None else limits
        if not isinstance(self.limits, ArchiveLimits):
            raise TypeError("limits must be an ArchiveLimits instance")

    def inspect(
        self,
        root_path: str | os.PathLike[str],
        *,
        slug: str | None = None,
        main_tex: str | None = None,
    ) -> LatexSourceInspection:
        """Validate UTF-8 source closure, entrypoint, document marker, and tree identity."""

        try:
            root = _plain_directory(Path(root_path), label="LaTeX source root")
        except SourceMaterializationError as exc:
            raise LatexSourceError(str(exc)) from exc
        if slug is not None and not isinstance(slug, str):
            raise LatexSourceError("slug must be a string or None")
        if main_tex is not None and not isinstance(main_tex, str):
            raise LatexSourceError("main_tex must be a string or None")
        selected_slug = slug or ""
        selected_main_tex = main_tex or ""
        if selected_slug and not _portable_leaf(selected_slug, limits=self.limits):
            raise LatexSourceError(f"slug is not a portable leaf: {selected_slug!r}")
        entries = _tree_inventory(root, limits=self.limits)
        decoded_digests: dict[str, str] = {}
        document_class_candidates: list[str] = []
        for entry in entries:
            if entry.relative.casefold().endswith(".tex"):
                text, digest = _stable_read_text(entry, maximum=self.limits.max_tex_bytes)
                decoded_digests[entry.relative] = digest
                if _DOCUMENT_CLASS.search(_remove_line_comments(text)):
                    document_class_candidates.append(entry.relative)
        if not decoded_digests:
            raise LatexSourceError("source tree contains no .tex files")
        entrypoint, selection = _entrypoint(
            entries,
            document_class_candidates,
            slug=selected_slug,
            main_tex=selected_main_tex,
            limits=self.limits,
        )
        resolved, input_digests = _resolve_inputs(
            entrypoint,
            entries,
            decoded_digests,
            limits=self.limits,
        )
        decoded_digests.update(input_digests)
        if not _DOCUMENT_MARKER.search(resolved):
            raise LatexSourceError(
                f"resolved LaTeX entrypoint has no document environment: {entrypoint!r}"
            )
        fingerprint = _fingerprint_inventory(root, entries, limits=self.limits)
        by_path = {record.path: record for record in fingerprint.files}
        for relative, digest in decoded_digests.items():
            if by_path[relative].sha256 != digest:
                raise LatexSourceError(f"LaTeX input changed during inspection: {relative!r}")
        controls = tuple(
            record for record in fingerprint.files if record.path.casefold() == "00readme.json"
        )
        return LatexSourceInspection(
            root_path=str(root),
            entrypoint=entrypoint,
            entrypoint_selection=selection,
            file_count=fingerprint.count,
            tex_file_count=fingerprint.tex_count,
            tree_sha256=fingerprint.sha256,
            files=fingerprint.files,
            package_control_files=controls,
            embedded_metadata=_embedded_metadata(resolved),
        )


def extract_source_archive(
    archive_path: str | os.PathLike[str],
    destination_path: str | os.PathLike[str],
    *,
    limits: ArchiveLimits | None = None,
) -> ArchiveExtraction:
    """Expand one bounded gzip source archive into a new private directory."""

    return SourceArchiveExtractor(limits).extract(archive_path, destination_path)


def inspect_latex_source_tree(
    root_path: str | os.PathLike[str],
    *,
    slug: str | None = None,
    main_tex: str | None = None,
    limits: ArchiveLimits | None = None,
) -> LatexSourceInspection:
    """Inspect one expanded LaTeX source tree."""

    return LatexSourceInspector(limits).inspect(root_path, slug=slug, main_tex=main_tex)


__all__ = [
    "ArchiveExtraction",
    "ArchiveLimits",
    "EmbeddedLatexMetadata",
    "LatexSourceError",
    "LatexSourceInspection",
    "LatexSourceInspector",
    "SourceArchiveError",
    "SourceArchiveExtractor",
    "TreeFile",
    "TreeFingerprint",
    "extract_source_archive",
    "fingerprint_source_tree",
    "inspect_latex_source_tree",
]
