"""Physical inspection and stable views of a store that may be actively appended.

A writer publishes by rename, so a reader never sees a half-written *replacement*. It can still see
a half-written *append*: APPEND extends the file in place, and a reader that runs to EOF while that
is happening reads a torn final record.

The fix is a bound, not a lock. Readers do not take the write lease -- one long scan would stall
every writer, and a reader has nothing to protect. Instead a reader fixes the length it intends to
read and stops there. Bytes below that offset are already durable and never change: JSONL only ever
grows at the end, and a rename swaps the whole file rather than editing it.

Two bounds are worth having, and they answer different questions:

    at_length(n)   whatever was complete when I looked
    at_signature   whatever the .sig attests to

The second is the stronger one. A signed prefix is a population someone committed to, so reading
there gives a view that verifies, rather than merely a view that is not torn.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Optional

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
    size = os.path.getsize(target)
    if size == 0:
        return 0

    with open(target, "rb") as handle:
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


def snapshot(source: str, destination: str, *, limit: Optional[int] = None) -> int:
    """Copy the complete-record prefix of `source` to `destination`. Returns bytes written.

    Byte-for-byte, with no re-serialization: a snapshot that reformatted its input would no longer
    answer the question it was taken to answer, and its hash would not match the source's .sig.
    Bounded at `limit` when given, otherwise at the last complete record.
    """
    source_path = store_paths(source).artifact
    bound = complete_prefix(source_path) if limit is None else limit

    parent = os.path.dirname(os.path.abspath(destination))
    if parent:
        os.makedirs(parent, exist_ok=True)

    written = 0
    with open(source_path, "rb") as src, open(destination, "wb") as dst:
        while written < bound:
            block = src.read(min(1 << 20, bound - written))
            if not block:
                break
            dst.write(block)
            written += len(block)
    return written
