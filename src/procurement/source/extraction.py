"""Bounded extraction of gzip-wrapped source archives."""

from __future__ import annotations

import codecs
import gzip
import hashlib
import os
import posixpath
import tarfile
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import BinaryIO, Callable, ContextManager, Literal, Sequence

from jsonl_engine.publication import (
    PinnedPublicationRoot,
    PublicationConflict,
    PublicationError,
)
from jsonl_engine.sidecar import temp_write_path

from procurement.errors import SourceMaterializationError
from procurement.source._safety import (
    _CHUNK_BYTES,
    _PortablePathRegistry,
    _plain_directory,
    _portable_relative,
    _regular_file,
)
from procurement.storage.safety import same_directory_generation
from procurement.source.contracts import ArchiveLimits, SourceArchiveError
from procurement.source.tree import _tree_inventory


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
class _TarMemberPlan:
    name: str
    relative: str
    is_directory: bool
    size: int


_OpenMember = Callable[[str], ContextManager[BinaryIO]]


def _has_tar_header(handle: BinaryIO) -> bool:
    handle.seek(0)
    header = handle.read(tarfile.BLOCKSIZE)
    handle.seek(0)
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


def _is_tar_payload_handle(handle: BinaryIO) -> bool:
    looks_like_tar = False
    try:
        looks_like_tar = _has_tar_header(handle)
        with tarfile.open(fileobj=handle, mode="r:") as archive:
            archive.next()
        return True
    except (tarfile.ReadError, EOFError, OSError, PublicationError, RuntimeError) as exc:
        if looks_like_tar:
            raise SourceArchiveError(
                "gzip payload has a tar header but is not a readable tar archive"
            ) from exc
        return False


def _assert_tar_zero_tail(handle: BinaryIO, *, terminator_offset: int) -> None:
    """Require a two-block tar terminator followed only by zero padding."""

    if terminator_offset < 0 or terminator_offset % tarfile.BLOCKSIZE:
        raise SourceArchiveError("source tar terminator is not block-aligned")
    try:
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


def _plan_tar_handle(
    handle: BinaryIO,
    *,
    limits: ArchiveLimits,
) -> tuple[tuple[_TarMemberPlan, ...], int]:
    plans: list[_TarMemberPlan] = []
    registry = _PortablePathRegistry()
    extracted_bytes = 0
    regular_files = 0
    terminator_offset = 0
    try:
        handle.seek(0)
        with tarfile.open(fileobj=handle, mode="r:") as archive:
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
                            "source archive member exceeds the "
                            f"{limits.max_member_bytes}-byte boundary: {member.name!r}"
                        )
                    if member.size > limits.max_extracted_bytes - extracted_bytes:
                        raise SourceArchiveError(
                            "source archive exceeds the "
                            f"{limits.max_extracted_bytes}-byte extraction boundary"
                        )
                    extracted_bytes += member.size
                    regular_files += 1
                else:
                    raise SourceArchiveError(
                        "source archive contains an unsafe link or special member: "
                        f"{member.name!r}"
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
                        "source archive directory has a nonzero payload size: "
                        f"{member.name!r}"
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
        _assert_tar_zero_tail(handle, terminator_offset=terminator_offset)
    except SourceArchiveError:
        raise
    except (tarfile.TarError, EOFError, OSError, PublicationError, RuntimeError) as exc:
        raise SourceArchiveError("gzip payload is not a complete readable tar archive") from exc
    if not plans or not regular_files:
        raise SourceArchiveError("source tar archive contains no regular files")
    return tuple(plans), extracted_bytes


def _extract_tar_handle(
    handle: BinaryIO,
    plans: Sequence[_TarMemberPlan],
    *,
    ensure_directory: Callable[[str], None],
    open_member: _OpenMember,
) -> None:
    terminator_offset = 0
    try:
        handle.seek(0)
        with tarfile.open(fileobj=handle, mode="r:") as archive:
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
                    raise SourceArchiveError(
                        "source tar changed between validation and extraction"
                    )
                if expected.is_directory:
                    ensure_directory(expected.relative)
                    continue
                parent = posixpath.dirname(expected.relative)
                if parent:
                    ensure_directory(parent)
                source = archive.extractfile(member)
                if source is None:
                    raise SourceArchiveError(
                        f"source tar member has no readable payload: {expected.relative!r}"
                    )
                written = 0
                try:
                    with open_member(expected.relative) as output:
                        while written < expected.size:
                            chunk = source.read(min(_CHUNK_BYTES, expected.size - written))
                            if not chunk:
                                raise SourceArchiveError(
                                    f"source tar member is truncated: {expected.relative!r}"
                                )
                            count = output.write(chunk)
                            if count != len(chunk):
                                raise OSError(
                                    "short write while extracting source tar member "
                                    f"({count} of {len(chunk)} bytes)"
                                )
                            written += count
                        output.flush()
                        os.fsync(output.fileno())
                finally:
                    source.close()
            try:
                next(iterator)
            except StopIteration:
                terminator_offset = archive.offset
            else:
                raise SourceArchiveError(
                    "source tar changed between validation and extraction"
                )
        _assert_tar_zero_tail(handle, terminator_offset=terminator_offset)
    except SourceArchiveError:
        raise
    except (tarfile.TarError, EOFError, OSError, PublicationError, RuntimeError) as exc:
        raise SourceArchiveError("source tar extraction failed") from exc


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
        try:
            with PinnedPublicationRoot(str(archive.parent)) as archive_root:
                with PinnedPublicationRoot(str(parent)) as parent_root:
                    if parent_root.lexists(destination):
                        raise SourceArchiveError(
                            f"source extraction destination already exists: '{destination}'"
                        )
                    try:
                        parent_root.mkdir_leaf(destination.name)
                    except OSError as exc:
                        raise SourceArchiveError(
                            "source extraction destination could not be created: "
                            f"'{destination}'"
                        ) from exc
                    created = parent_root.stat_leaf(destination.name)
                    try:
                        with parent_root.pin_child(destination.name) as destination_root:
                            if not same_directory_generation(
                                created,
                                destination_root.stat_root(),
                            ):
                                raise SourceArchiveError(
                                    "source extraction destination changed while it was retained"
                                )
                            return self.extract_pinned(
                                archive_root,
                                archive,
                                destination_root,
                            )
                    except BaseException:
                        try:
                            current = parent_root.stat_leaf(destination.name)
                            if same_directory_generation(created, current):
                                parent_root.remove_owned_tree(destination)
                        except (FileNotFoundError, PublicationConflict):
                            pass
                        raise
        except SourceArchiveError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceArchiveError("source archive extraction transaction failed") from exc

    def extract_pinned(
        self,
        archive_root: PinnedPublicationRoot,
        archive_path: str | os.PathLike[str],
        destination_root: PinnedPublicationRoot,
    ) -> ArchiveExtraction:
        """Populate an empty retained destination from one retained gzip archive."""

        if not isinstance(archive_root, PinnedPublicationRoot) or not isinstance(
            destination_root,
            PinnedPublicationRoot,
        ):
            raise TypeError("extract_pinned requires retained archive and destination roots")
        try:
            archive_root.assert_current()
            destination_root.assert_current()
            archive = Path(archive_root.absolute(archive_root.direct_leaf(archive_path)))
            destination = Path(destination_root.path)
            if destination_root.list_names():
                raise SourceArchiveError(
                    f"source extraction destination is not empty: '{destination}'"
                )
        except SourceArchiveError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceArchiveError("retained source extraction roots are not available") from exc

        payload = Path(temp_write_path(destination_root.absolute(".gzip-payload")))
        archive_digest = hashlib.sha256()
        payload_bytes = 0
        try:
            try:
                with archive_root.open_stable_file(archive) as input_handle:
                    archive_size = os.fstat(input_handle.fileno()).st_size
                    if archive_size > self.limits.max_archive_bytes:
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
                        with destination_root.open_file(payload, "xb") as output:
                            while chunk := compressed.read(_CHUNK_BYTES):
                                if (
                                    len(chunk)
                                    > self.limits.max_gzip_payload_bytes - payload_bytes
                                ):
                                    raise SourceArchiveError(
                                        "source gzip exceeds the "
                                        f"{self.limits.max_gzip_payload_bytes}-byte expansion "
                                        "boundary"
                                    )
                                payload_bytes += len(chunk)
                                count = output.write(chunk)
                                if count != len(chunk):
                                    raise OSError(
                                        "short write while expanding source gzip "
                                        f"({count} of {len(chunk)} bytes)"
                                    )
                            output.flush()
                            os.fsync(output.fileno())
            except SourceArchiveError:
                raise
            except (
                gzip.BadGzipFile,
                EOFError,
                zlib.error,
                OSError,
                PublicationError,
                RuntimeError,
            ) as exc:
                raise SourceArchiveError(
                    "source archive is not a complete readable gzip stream"
                ) from exc
            if payload_bytes == 0:
                raise SourceArchiveError("source gzip expands to an empty payload")

            with destination_root.open_stable_file(payload) as payload_handle:
                if _is_tar_payload_handle(payload_handle):
                    plans, extracted_bytes = _plan_tar_handle(
                        payload_handle,
                        limits=self.limits,
                    )

                    def ensure_directory(relative: str) -> None:
                        destination_root.mkdir_relative(
                            relative,
                            parents=True,
                            exist_ok=True,
                        )

                    def open_member(relative: str) -> ContextManager[BinaryIO]:
                        return destination_root.open_relative_file(relative, "xb")

                    _extract_tar_handle(
                        payload_handle,
                        plans,
                        ensure_directory=ensure_directory,
                        open_member=open_member,
                    )
                    archive_kind: Literal["tar+gzip", "single-tex+gzip"] = "tar+gzip"
                    entry_count = len(plans)
                else:
                    if payload_bytes > self.limits.max_member_bytes:
                        raise SourceArchiveError(
                            "single-TeX payload exceeds the "
                            f"{self.limits.max_member_bytes}-byte boundary"
                        )
                    decoder = codecs.getincrementaldecoder("utf-8")("strict")
                    target = Path(destination_root.absolute("main.tex"))
                    payload_handle.seek(0)
                    try:
                        with destination_root.open_file(target, "xb") as output:
                            while chunk := payload_handle.read(_CHUNK_BYTES):
                                if "\x00" in decoder.decode(chunk, final=False):
                                    raise SourceArchiveError(
                                        "single-TeX gzip payload contains NUL"
                                    )
                                count = output.write(chunk)
                                if count != len(chunk):
                                    raise OSError(
                                        "short write while extracting single-TeX payload "
                                        f"({count} of {len(chunk)} bytes)"
                                    )
                            if "\x00" in decoder.decode(b"", final=True):
                                raise SourceArchiveError(
                                    "single-TeX gzip payload contains NUL"
                                )
                            output.flush()
                            os.fsync(output.fileno())
                    except UnicodeDecodeError as exc:
                        raise SourceArchiveError(
                            "single-TeX gzip payload is not valid UTF-8"
                        ) from exc
                    archive_kind = "single-tex+gzip"
                    entry_count = 1
                    extracted_bytes = payload_bytes

            destination_root.unlink(payload)
            _tree_inventory(
                destination,
                limits=self.limits,
                publication_root=destination_root,
            )
            archive_root.assert_current()
            destination_root.assert_current()
            return ArchiveExtraction(
                archive_path=str(archive),
                destination_path=str(destination),
                archive_kind=archive_kind,
                archive_entries=entry_count,
                archive_sha256=archive_digest.hexdigest(),
                gzip_payload_bytes=payload_bytes,
                extracted_bytes=extracted_bytes,
            )
        except SourceArchiveError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceArchiveError("retained source extraction failed") from exc
        finally:
            try:
                if destination_root.lexists(payload):
                    destination_root.unlink(payload)
            except (OSError, PublicationError, RuntimeError, ValueError):
                pass


def extract_source_archive(
    archive_path: str | os.PathLike[str],
    destination_path: str | os.PathLike[str],
    *,
    limits: ArchiveLimits | None = None,
) -> ArchiveExtraction:
    """Expand one bounded gzip source archive into a new private directory."""

    return SourceArchiveExtractor(limits).extract(archive_path, destination_path)


__all__ = ["ArchiveExtraction", "SourceArchiveExtractor", "extract_source_archive"]
