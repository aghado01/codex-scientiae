"""Physical inspection and stable views of a store that may be actively appended.

This engine publishes both CREATE and APPEND transactions by rename, so its readers never see a
half-written replacement. A foreign or uncoordinated producer may still extend a file in place;
reading that file to EOF while the write is active can expose a torn final record.

The fix is a bound plus a captured file generation, not a lock. Readers do not take the write lease
-- one long scan would stall every writer, and a reader has nothing to protect. Instead a reader
fixes the length it intends to read and refuses if the pathname is later replaced. An append may
extend the captured generation, but cannot expose a partial record below the bound.

Two bounds are worth having, and they answer different questions:

    at_length(n)   whatever was complete when I looked
    at_signature   whatever the .sig attests to

The second is the stronger one. A signed prefix is a population someone committed to, so reading
there gives a view that verifies, rather than merely a view that is not torn.

inspect_prefix walks records until the first framing or JSON failure and reports that valid prefix.
It does not take the write lease. repair_prefix is a writer: it takes the lease, copies the live
file to a sibling .bak, and publishes the kept prefix onto the store.
"""

from __future__ import annotations

import hashlib
import os
import re
import struct
import tempfile
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, BinaryIO, Callable, Dict, List, Optional, Tuple

from .policy import DEFAULT_ENCODING, Codec, Eol
from .sidecar import (
    SIG_SCHEMA_ID,
    StorePaths,
    get_ticks_offset,
    lock_path,
    store_paths,
    temp_write_path,
)
from .writer import publish_staged_file, write_json

__all__ = [
    "StoreInfo",
    "StorePrefixScan",
    "StoreRepairReceipt",
    "inspect_store",
    "inspect_prefix",
    "complete_prefix",
    "repair_prefix",
    "snapshot",
]

_REPAIR_LABEL = re.compile(r"^[a-z][a-z0-9-]{0,31}$")


@dataclass(frozen=True)
class StoreInfo:
    """Physical facts about a store, gathered without decoding text or parsing JSON.

    Deliberately byte-level. Answering "how big, how many lines, is it terminated" should not
    require the store to be valid, decodable, or even the encoding the caller expects -- those are
    exactly the questions worth asking about a store that is misbehaving.
    """

    path: str
    exists: bool
    size: int
    line_count: int
    terminated: bool
    eol: Optional[Eol]
    has_index: bool
    has_signature: bool

    @property
    def is_empty(self) -> bool:
        return self.size == 0


def inspect_store(path: str, *, chunk_size: int = 1 << 20) -> StoreInfo:
    """Gather StoreInfo for `path`, scanning bytes only.

    Safe against an active append boundary: it reads to whatever EOF it finds and reports what it
    saw, rather than asserting the file was quiescent.
    """
    paths: StorePaths = store_paths(path)
    target = paths.artifact

    if not os.path.exists(target):
        return StoreInfo(target, False, 0, 0, False, None, False, False)

    size = os.path.getsize(target)
    newlines = 0
    tail = b""
    with open(target, "rb") as handle:
        while chunk := handle.read(chunk_size):
            newlines += chunk.count(b"\n")
            tail = chunk[-2:] if len(chunk) >= 2 else (tail + chunk)[-2:]

    terminated = tail.endswith(b"\n")
    eol: Optional[Eol] = None
    if terminated:
        eol = Eol.CRLF if tail.endswith(b"\r\n") else Eol.LF

    return StoreInfo(
        path=target,
        exists=True,
        # A trailing partial line is a record in progress, not a record.
        size=size,
        line_count=newlines,
        terminated=terminated,
        eol=eol,
        has_index=os.path.exists(paths.jidx),
        has_signature=os.path.exists(paths.sig),
    )


def complete_prefix(path: str, *, chunk_size: int = 1 << 16) -> int:
    """Byte length of the last complete record in `path`, i.e. one past its final terminator.

    The bound a reader wants when it has no signature to read at: everything below it is a whole
    record, and a record in progress above it is excluded rather than truncated.
    """
    target = store_paths(path).artifact
    with open(target, "rb") as handle:
        return _complete_prefix_from_handle(
            handle,
            size=os.fstat(handle.fileno()).st_size,
            chunk_size=chunk_size,
        )


def _complete_prefix_from_handle(
    handle: BinaryIO, *, size: int, chunk_size: int = 1 << 16
) -> int:
    """Find the complete prefix in one already-open generation of a source file."""
    position = size
    while position > 0:
        window = min(chunk_size, position)
        position -= window
        handle.seek(position)
        block = handle.read(window)
        found = block.rfind(b"\n")
        if found != -1:
            return position + found + 1
    return 0


def _validate_record_boundary(handle: BinaryIO, limit: int, *, size: int) -> int:
    """Validate and return a byte limit that ends immediately after a complete record."""
    if isinstance(limit, bool) or not isinstance(limit, int):
        raise TypeError(
            f"record boundary must be an integer byte offset, got {type(limit).__name__}"
        )
    if limit < 0 or limit > size:
        raise ValueError(f"record boundary {limit} is outside source extent [0, {size}]")
    if limit:
        handle.seek(limit - 1)
        if handle.read(1) != b"\n":
            raise ValueError(f"byte offset {limit} is not a complete-record boundary")
    return limit


def _paths_equivalent(first: str, second: str) -> bool:
    """Whether two spellings identify the same destination, including existing hard links."""
    canonical_first = os.path.normcase(os.path.realpath(os.path.abspath(first)))
    canonical_second = os.path.normcase(os.path.realpath(os.path.abspath(second)))
    if canonical_first == canonical_second:
        return True
    try:
        return os.path.samefile(first, second)
    except (FileNotFoundError, OSError):
        return False


def snapshot(source: str, destination: str, *, limit: Optional[int] = None) -> int:
    """Copy the complete-record prefix of `source` to `destination`. Returns bytes written.

    Byte-for-byte, with no re-serialization: a snapshot that reformatted its input would no longer
    answer the question it was taken to answer, and its hash would not match the source's .sig.
    Bounded at `limit` when given, otherwise at the last complete record. The source is read through
    one handle and the destination is atomically replaced only after an adjacent temporary copy is
    complete.
    """
    source_path = store_paths(source).artifact
    destination_path = os.path.abspath(destination)
    if _paths_equivalent(source_path, destination_path):
        raise ValueError(
            f"snapshot source and destination identify the same file: '{source_path}'"
        )

    parent = os.path.dirname(destination_path)
    if parent:
        os.makedirs(parent, exist_ok=True)

    # Open once, then derive and copy the bound through that handle. If a rename publishes a new
    # source while the copy runs, this snapshot remains entirely of the generation it opened.
    with open(source_path, "rb") as src:
        size = os.fstat(src.fileno()).st_size
        bound = (
            _complete_prefix_from_handle(src, size=size)
            if limit is None
            else _validate_record_boundary(src, limit, size=size)
        )
        src.seek(0)

        descriptor, temporary = tempfile.mkstemp(
            prefix=f".{os.path.basename(destination_path)}.",
            suffix=".tmp",
            dir=parent or None,
        )
        try:
            written = 0
            with os.fdopen(descriptor, "wb") as dst:
                while written < bound:
                    block = src.read(min(1 << 20, bound - written))
                    if not block:
                        raise OSError(
                            f"source ended at byte {written} before snapshot bound {bound}"
                        )
                    dst.write(block)
                    written += len(block)
                dst.flush()
                os.fsync(dst.fileno())
            os.replace(temporary, destination_path)
            return written
        except BaseException:
            try:
                os.close(descriptor)
            except OSError:
                pass
            try:
                os.remove(temporary)
            except OSError:
                # Preserve the operation that failed. A cleanup error is secondary and the
                # uniquely named scratch remains isolated and identifiable as transaction debris.
                pass
            raise


@dataclass(frozen=True)
class StorePrefixScan:
    """How far a store parses as complete JSONL records under a declared policy."""

    path: str
    exists: bool
    valid: bool
    size: int
    valid_prefix_bytes: int
    record_count: int
    error_line: Optional[int] = None
    error: Optional[str] = None
    records: Tuple[Any, ...] = ()


@dataclass(frozen=True)
class StoreRepairReceipt:
    """Result of publishing a complete-record prefix onto the live store."""

    path: str
    backup_path: str
    original_bytes: int
    committed_bytes: int
    removed_bytes: int
    signed: bool
    indexed: bool


def inspect_prefix(
    path: str,
    *,
    encoding: str = DEFAULT_ENCODING,
    eol: Eol = Eol.LF,
    validator: Optional[Callable[[Any, int], None]] = None,
    collect_records: bool = False,
) -> StorePrefixScan:
    """Walk records until the first framing or JSON failure. Does not take the write lease.

    `complete_prefix` is the last terminator. This bound may be shorter: a complete line that is
    not JSON, or that the optional validator refuses, is excluded together with everything after it.
    """
    target = store_paths(path).artifact
    if not os.path.lexists(target):
        return StorePrefixScan(target, False, True, 0, 0, 0)

    if os.path.islink(target):
        return StorePrefixScan(
            target,
            True,
            False,
            0,
            0,
            0,
            error="JSONL data path must not be a symbolic link",
        )
    if not os.path.isfile(target):
        return StorePrefixScan(
            target,
            True,
            False,
            0,
            0,
            0,
            error="JSONL data path is not a regular file",
        )

    # Local import: reader imports complete-prefix helpers from this module.
    from .reader import loads

    terminator = eol.terminator(encoding)
    records: List[Any] = []
    valid_prefix = 0
    record_count = 0

    with open(target, "rb") as handle:
        size = os.fstat(handle.fileno()).st_size
        for line_number, line in enumerate(handle, start=1):
            try:
                record = _parse_prefix_line(
                    line,
                    line_number=line_number,
                    path=target,
                    encoding=encoding,
                    terminator=terminator,
                    loads=loads,
                )
                if validator is not None:
                    try:
                        validator(record, line_number)
                    except ValueError:
                        raise
                    except Exception as exc:
                        raise ValueError(str(exc)) from exc
            except ValueError as exc:
                return StorePrefixScan(
                    target,
                    True,
                    False,
                    size,
                    valid_prefix,
                    record_count,
                    error_line=line_number,
                    error=str(exc),
                    records=tuple(records),
                )
            record_count += 1
            valid_prefix += len(line)
            if collect_records:
                records.append(record)

        if os.fstat(handle.fileno()).st_size != size:
            raise ValueError(f"JSONL data changed while it was inspected: {target}")

    return StorePrefixScan(
        target,
        True,
        True,
        size,
        valid_prefix,
        record_count,
        records=tuple(records),
    )


def _parse_prefix_line(
    line: bytes,
    *,
    line_number: int,
    path: str,
    encoding: str,
    terminator: bytes,
    loads: Callable[..., Any],
) -> Any:
    """Frame one physical line and parse it as JSON. Returns the decoded value."""
    where = f"line {line_number}"
    if not line.endswith(b"\n"):
        raise ValueError(f"{where} is not terminated")
    if not line.endswith(terminator):
        raise ValueError(
            f"{where} does not end with the declared {terminator!r} terminator"
        )
    body = line[: -len(terminator)]
    if not body.strip():
        raise ValueError(f"{where} is blank")
    if b"\r" in body:
        raise ValueError(f"{where} contains a CR inside the record")
    return loads(
        body,
        path=path,
        encoding=encoding,
        require_object=False,
        record=line_number - 1,
    )


def _copy_entire_file(source: str, destination: str) -> None:
    """Copy `source` byte-for-byte to `destination` through an adjacent temporary file.

    Unlike snapshot(), this does not require a complete-record bound: a repair backup must keep
    the torn tail that is about to be dropped.
    """
    source_path = store_paths(source).artifact
    destination_path = os.path.abspath(destination)
    if _paths_equivalent(source_path, destination_path):
        raise ValueError(
            f"backup source and destination identify the same file: '{source_path}'"
        )
    parent = os.path.dirname(destination_path)
    if parent:
        os.makedirs(parent, exist_ok=True)
    temporary = temp_write_path(destination_path)
    try:
        with open(source_path, "rb") as src, open(temporary, "xb") as dst:
            while True:
                block = src.read(1 << 20)
                if not block:
                    break
                dst.write(block)
            dst.flush()
            os.fsync(dst.fileno())
        publish_staged_file(temporary, destination_path, overwrite=True)
    except BaseException:
        if os.path.lexists(temporary):
            try:
                os.remove(temporary)
            except OSError:
                pass
        raise


def _replace_with_prefix(path: str, bound: int) -> None:
    """Replace `path` with its first `bound` bytes through an adjacent temporary file.

    Caller holds the write lease. `bound` must already be a complete-record boundary.
    """
    target = store_paths(path).artifact
    temporary = temp_write_path(target)
    try:
        with open(target, "rb") as src, open(temporary, "xb") as dst:
            remaining = bound
            while remaining:
                block = src.read(min(1 << 20, remaining))
                if not block:
                    raise OSError(
                        f"source ended at byte {bound - remaining} before prefix bound {bound}"
                    )
                dst.write(block)
                remaining -= len(block)
            dst.flush()
            os.fsync(dst.fileno())
        publish_staged_file(temporary, target, overwrite=True)
    except BaseException:
        if os.path.lexists(temporary):
            try:
                os.remove(temporary)
            except OSError:
                pass
        raise


def repair_prefix(
    path: str,
    committed_bytes: int,
    *,
    backup_label: str = "corrupt",
    lock_timeout: float = 60.0,
) -> StoreRepairReceipt:
    """Publish the complete-record prefix of `path` onto the store. Takes the write lease."""
    if isinstance(committed_bytes, bool) or not isinstance(committed_bytes, int) or committed_bytes < 0:
        raise ValueError("committed_bytes must be a nonnegative integer")
    if not isinstance(backup_label, str) or _REPAIR_LABEL.fullmatch(backup_label) is None:
        raise ValueError("backup_label must be a lowercase filesystem-safe name")

    from filelock import FileLock, Timeout

    target = store_paths(path).artifact
    lease = FileLock(lock_path(target), timeout=lock_timeout)
    try:
        lease.acquire()
    except Timeout as exc:
        raise TimeoutError(
            f"Could not acquire the write lease for {target} within {lock_timeout}s "
            f"(lock file: {lock_path(target)})."
        ) from exc

    try:
        if not os.path.lexists(target):
            raise FileNotFoundError(f"JSONL data does not exist: {target}")
        if os.path.islink(target) or not os.path.isfile(target):
            raise ValueError(f"JSONL data path is not a regular file: {target}")

        size = os.path.getsize(target)
        if committed_bytes >= size:
            raise ValueError(
                f"repair prefix must remove at least one byte from a {size}-byte store"
            )
        if committed_bytes:
            with open(target, "rb") as handle:
                _validate_record_boundary(handle, committed_bytes, size=size)

        paths = store_paths(target)
        had_index = os.path.isfile(paths.jidx)
        had_signature = os.path.isfile(paths.sig)
        policy = _read_signature_policy(paths.sig) if had_signature else None

        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
        backup_path = f"{target}.{backup_label}-{stamp}.bak"
        _copy_entire_file(target, backup_path)
        _replace_with_prefix(target, committed_bytes)

        signed = False
        indexed = False
        try:
            signed, indexed = _rebuild_repaired_sidecars(
                paths,
                had_index=had_index,
                had_signature=had_signature,
                policy=policy,
            )
        except (OSError, ValueError, TypeError):
            _discard_sidecars(paths)
        return StoreRepairReceipt(
            path=target,
            backup_path=backup_path,
            original_bytes=size,
            committed_bytes=committed_bytes,
            removed_bytes=size - committed_bytes,
            signed=signed,
            indexed=indexed,
        )
    finally:
        lease.release()


def _read_signature_policy(sig_path: str) -> Optional[Dict[str, Any]]:
    from .reader import read_json

    try:
        raw = read_json(sig_path, require_object=True)
    except (OSError, ValueError):
        return None
    if not isinstance(raw, dict) or raw.get("schema") != SIG_SCHEMA_ID:
        return None
    return raw


def _discard_sidecars(paths: StorePaths) -> None:
    for sidecar in (paths.jidx, paths.sig):
        if os.path.lexists(sidecar):
            try:
                os.remove(sidecar)
            except OSError:
                pass


def _rebuild_repaired_sidecars(
    paths: StorePaths,
    *,
    had_index: bool,
    had_signature: bool,
    policy: Optional[Dict[str, Any]],
) -> Tuple[bool, bool]:
    """Rewrite sidecars that existed before repair so they describe the kept prefix."""
    if not had_index and not had_signature:
        return False, False

    offsets: List[int] = []
    hasher = hashlib.sha256()
    offset = 0
    with open(paths.artifact, "rb") as handle:
        for line in handle:
            hasher.update(line)
            offsets.append(offset)
            offset += len(line)

    published = os.stat(paths.artifact, follow_symlinks=False)
    file_size = published.st_size
    ticks = (published.st_mtime_ns // 100) + get_ticks_offset()

    indexed = False
    signed = False
    jidx_tmp = temp_write_path(paths.jidx) if had_index else ""
    sig_tmp = temp_write_path(paths.sig) if had_signature else ""
    try:
        if had_index:
            with open(jidx_tmp, "wb") as handle:
                handle.write(b"JSOI")
                handle.write(struct.pack("<i", 2))
                handle.write(struct.pack("<i", len(offsets)))
                handle.write(struct.pack("<q", file_size))
                handle.write(struct.pack("<q", ticks))
                for item in offsets:
                    handle.write(struct.pack("<q", item))
                handle.flush()
                os.fsync(handle.fileno())
            os.replace(jidx_tmp, paths.jidx)
            jidx_tmp = ""
            indexed = True
        if had_signature:
            payload = {
                "schema": SIG_SCHEMA_ID,
                "sha256": hasher.hexdigest(),
                "line_count": len(offsets),
                "file_size": file_size,
                "ticks": ticks,
                "discipline": (
                    policy.get("discipline") if policy else "create"
                ),
                "encoding": policy.get("encoding") if policy else DEFAULT_ENCODING,
                "codec": policy.get("codec") if policy else Codec.UNICODE.value,
                "eol": policy.get("eol") if policy else Eol.LF.value,
                "metadata": dict(policy.get("metadata") or {}) if policy else {},
                "created_at": datetime.now(timezone.utc).isoformat(),
            }
            write_json(
                sig_tmp,
                payload,
                encoding=DEFAULT_ENCODING,
                codec=Codec.ASCII,
                indent=2,
                atomic=False,
            )
            os.replace(sig_tmp, paths.sig)
            sig_tmp = ""
            signed = True
        return signed, indexed
    except BaseException:
        for tmp in (jidx_tmp, sig_tmp):
            if tmp and os.path.lexists(tmp):
                try:
                    os.remove(tmp)
                except OSError:
                    pass
        raise
