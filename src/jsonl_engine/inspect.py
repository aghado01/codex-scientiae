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
"""

from __future__ import annotations

import os
import tempfile
from dataclasses import dataclass
from typing import BinaryIO, Optional

from .policy import Eol
from .sidecar import StorePaths, store_paths

__all__ = ["StoreInfo", "inspect_store", "complete_prefix", "snapshot"]


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
