"""Read JSON files and JSONL stores.

Bytes are read in binary and decoded under a declared encoding; a BOM is rejected. Optional
`validator` is a compiled jsonschema validator applied after parse. A JSONL store is one path triple
(`.jsonl`, `.jidx`, `.sig`); `JsonlStore` holds its policy and validator as state and parses the
index once.

The three text-policy axes are declared, never sniffed -- see policy.py. For a store this engine
wrote, the `.sig` witnesses them, and verify() reports a policy disagreement before it reports a
hash mismatch, because the second is a consequence of the first.

Does not check canonical ordering, key uniqueness, or cross-artifact identity.
"""

from __future__ import annotations

import hashlib
import json
import os
import codecs
import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Iterator, List, Optional, Union

import jsonschema

from .policy import DEFAULT_ENCODING, Eol
from .sidecar import SIG_SCHEMA_ID, StorePaths, get_file_dotnet_ticks, store_paths

UTF8_BOM = b"\xef\xbb\xbf"


class JsonReaderError(ValueError):
    """Raised when a JSON value fails to read, parse, or validate. Includes `path`."""

    def __init__(self, path: str, message: str) -> None:
        self.path = path
        super().__init__(f"{message}: '{path}'")


def _raise(
    path: str,
    message: str,
    cause: Optional[BaseException] = None,
    *,
    record: Optional[int] = None,
) -> None:
    if record is not None:
        message = f"record {record}: {message}"
    err = JsonReaderError(path, message)
    if cause is not None:
        raise err from cause
    raise err


def is_line_framable(encoding: str) -> bool:
    """Whether newline framing survives at the byte level under `encoding`.

    JSONL splits records on a newline byte before anything is decoded. Under utf-16-le a newline is
    b"\\n\\x00", so a byte-level split lands mid-character and every record after the first is
    garbage. Single-object JSON has no such constraint -- there is nothing to split.

    An unknown encoding name is a different failure and raises LookupError rather than answering
    False; conflating the two reports a typo as an architectural limit.
    """
    codecs.lookup(encoding)
    return "\n".encode(encoding) == b"\n"


def validate(
    value: Any,
    validator: Any,
    *,
    path: str,
    record: Optional[int] = None,
) -> Any:
    """Apply `validator` to `value`. Returns `value`."""
    try:
        validator.validate(value)
    except jsonschema.ValidationError as exc:
        where = " -> ".join(str(p) for p in exc.path) if exc.path else "root"
        _raise(
            path,
            f"schema validation failed at [{where}]: {exc.message}",
            exc,
            record=record,
        )
    return value


def loads(
    raw: bytes,
    *,
    path: str,
    encoding: str = DEFAULT_ENCODING,
    validator: Any = None,
    require_object: bool = True,
    record: Optional[int] = None,
) -> Any:
    """Parse JSON from `raw` under `encoding`. Rejects a leading BOM."""
    if raw.startswith(UTF8_BOM):
        _raise(path, "JSON must be without a BOM", record=record)

    try:
        text = raw.decode(encoding)
    except UnicodeDecodeError as exc:
        _raise(path, f"not valid {encoding} ({exc})", exc, record=record)
    except LookupError as exc:
        _raise(path, f"unknown encoding '{encoding}'", exc, record=record)

    # Literal NUL is invalid in JSON text. It appears when utf-16 bytes are read as utf-8, which is
    # the failure a declared encoding exists to make legible rather than mysterious.
    if "\x00" in text:
        _raise(
            path,
            f"NUL in JSON text decoded as '{encoding}' (is the declared encoding right?)",
            record=record,
        )

    try:
        value = json.loads(text)
    except json.JSONDecodeError as exc:
        # Inside a store the line number is always 1 and the record index is the locator that
        # matters; for a whole file it is the other way round.
        where = (
            f"malformed JSON (column {exc.colno})"
            if record is not None
            else f"malformed JSON (line {exc.lineno}, column {exc.colno})"
        )
        _raise(path, where, exc, record=record)

    if require_object and not isinstance(value, dict):
        _raise(path, f"expected one object, got {type(value).__name__}", record=record)

    if validator is not None:
        validate(value, validator, path=path, record=record)

    return value


def read_json(
    path: str,
    *,
    encoding: str = DEFAULT_ENCODING,
    validator: Any = None,
    require_object: bool = True,
) -> Any:
    """Read and parse one JSON file."""
    full = os.path.abspath(path)
    try:
        raw = Path(full).read_bytes()
    except FileNotFoundError as exc:
        raise FileNotFoundError(f"JSON file not found: '{full}'") from exc
    return loads(
        raw, path=full, encoding=encoding, validator=validator, require_object=require_object
    )


def read_json_or_none(
    path: str,
    *,
    encoding: str = DEFAULT_ENCODING,
    validator: Any = None,
    require_object: bool = True,
) -> Optional[Any]:
    """Read one JSON file, or return None when it is absent.

    For optional sidecars, where absence is a normal state and a malformed file is still an error.
    """
    if not os.path.exists(os.path.abspath(path)):
        return None
    return read_json(
        path, encoding=encoding, validator=validator, require_object=require_object
    )


@dataclass
class Jidx:
    """Parsed .jidx sidecar (JSOI format version 2)."""

    index_path: str
    jsonl_path: str
    version: int
    line_count: int
    source_length: int
    source_last_write_ticks: int
    offsets: List[int]

    def is_current(self) -> bool:
        """Whether source length and last-write ticks still match `jsonl_path`."""
        if not os.path.exists(self.jsonl_path):
            return False
        if os.stat(self.jsonl_path).st_size != self.source_length:
            return False
        return get_file_dotnet_ticks(self.jsonl_path) == self.source_last_write_ticks


def read_index(jidx_path: str, jsonl_path: Optional[str] = None) -> Jidx:
    """Parse a .jidx file. Accepts JSOI version 2 only."""
    index_path = os.path.abspath(jidx_path)
    if not os.path.exists(index_path):
        raise FileNotFoundError(f"Index file not found: {index_path}")

    if jsonl_path is None:
        jsonl_path = store_paths(index_path).artifact

    with open(index_path, "rb") as handle:
        magic = handle.read(4)
        if magic != b"JSOI":
            raise ValueError(f"Invalid JSOI index magic bytes: {magic}")

        version = struct.unpack("<i", handle.read(4))[0]
        if version != 2:
            raise ValueError(
                f"Unsupported JSOI index version: {version}. Expected version 2."
            )

        line_count = struct.unpack("<i", handle.read(4))[0]
        source_length = struct.unpack("<q", handle.read(8))[0]
        source_ticks = struct.unpack("<q", handle.read(8))[0]
        offset_bytes = handle.read(line_count * 8)
        if len(offset_bytes) != line_count * 8:
            raise ValueError(
                f"Truncated JSOI index: expected {line_count} offsets in {index_path}"
            )
        offsets = (
            list(struct.unpack(f"<{line_count}q", offset_bytes)) if line_count else []
        )

    return Jidx(
        index_path=index_path,
        jsonl_path=os.path.abspath(jsonl_path),
        version=version,
        line_count=line_count,
        source_length=source_length,
        source_last_write_ticks=source_ticks,
        offsets=offsets,
    )


class JsonlStore:
    """One JSONL file with its .jidx / .sig sidecars, read under a declared policy.

    A store written by a registry kind takes its policy from that kind. An ad-hoc store -- anything
    this engine did not write -- takes it from the caller. The defaults are the engine's own
    posture, which is why they are correct for the first case and arguments for the second.
    """

    def __init__(
        self,
        path: str,
        *,
        encoding: str = DEFAULT_ENCODING,
        eol: Eol = Eol.LF,
        validator: Any = None,
        require_object: bool = True,
        require_index: bool = False,
        require_sig: bool = False,
    ) -> None:
        try:
            framable = is_line_framable(encoding)
        except LookupError as exc:
            raise ValueError(f"unknown encoding '{encoding}'") from exc
        if not framable:
            raise ValueError(
                f"encoding '{encoding}' cannot frame JSONL records: a newline is not a single "
                f"0x0A byte under it, so splitting on newline before decoding would land "
                f"mid-character. Single-object JSON has no such limit -- use read_json()."
            )
        self.paths: StorePaths = store_paths(path)
        self.encoding = encoding
        self.eol = eol
        self.validator = validator
        self.require_object = require_object
        self.require_index = require_index
        self.require_sig = require_sig
        self._index: Optional[Jidx] = None
        self._offsets: Optional[List[int]] = None

    @property
    def has_index(self) -> bool:
        """Whether a .jidx accompanies this store."""
        return os.path.exists(self.paths.jidx)

    @property
    def has_signature(self) -> bool:
        """Whether a .sig accompanies this store."""
        return os.path.exists(self.paths.sig)

    @property
    def index(self) -> Jidx:
        """Parsed .jidx, loaded once. Raises when there is none; see has_index."""
        if self._index is None:
            self._index = read_index(self.paths.jidx, self.paths.artifact)
        return self._index

    def offsets(self) -> List[int]:
        """Record offsets, from the .jidx when there is one and by scanning when there is not.

        Sidecars are optional on the write side, so their absence is a normal state rather than a
        fault: what the engine emits by convention the reader uses by convention, and a store
        without an index is slower to seek, not unreadable. Pass require_index=True to make absence
        an error.

        A *stale* index is a different matter and still raises. Absence means nobody wrote one;
        staleness means someone wrote one and the bytes moved out from under it, which is the case
        the sidecar exists to catch.
        """
        if self.has_index:
            jidx = self.index
            if not jidx.is_current():
                raise ValueError(
                    f"Stale JSONL index: {self.paths.jidx} does not match {self.paths.artifact}"
                )
            return jidx.offsets

        if self.require_index:
            raise FileNotFoundError(
                f"Index file not found and require_index is set: {self.paths.jidx}"
            )

        if self._offsets is None:
            scanned: List[int] = []
            offset = 0
            with open(self.paths.artifact, "rb") as handle:
                for line in handle:
                    scanned.append(offset)
                    offset += len(line)
            self._offsets = scanned
        return self._offsets

    def __len__(self) -> int:
        """Records in the store. O(1) from the .jidx, one scan without it.

        Scanned rather than refused because list() probes __len__ for a size hint, so without this
        list(store) would fail where an equivalent for-loop succeeds.
        """
        return len(self.offsets())

    def __iter__(self) -> Iterator[Any]:
        """Stream every record in order. Needs no sidecar at all."""
        with open(self.paths.artifact, "rb") as handle:
            for record, line in enumerate(handle):
                yield self._loads_line(line, record=record)

    def __getitem__(self, index: Union[int, slice]) -> Any:
        offsets = self.offsets()
        if isinstance(index, slice):
            return [self[i] for i in range(*index.indices(len(offsets)))]

        n = len(offsets)
        record = index if index >= 0 else index + n
        if record < 0 or record >= n:
            raise IndexError(f"Record index {index} out of bounds [0, {n - 1}]")

        with open(self.paths.artifact, "rb") as handle:
            handle.seek(offsets[record])
            line = handle.readline()
        return self._loads_line(line, record=record)

    def _loads_line(self, line: bytes, *, record: int) -> Any:
        """Strip the declared terminator, then parse. A declared terminator is enforced."""
        # This engine never writes a blank line, so one is a hand-edit or a foreign file. Refused
        # rather than skipped, and named -- "malformed JSON at column 1" describes the symptom.
        if not line.strip():
            _raise(self.paths.artifact, "blank line", record=record)

        if self.eol is Eol.CRLF:
            if line.endswith(b"\r\n"):
                line = line[:-2]
            elif line.endswith(b"\n"):
                _raise(
                    self.paths.artifact,
                    "store is declared CRLF but this record ends with a bare LF",
                    record=record,
                )
        elif line.endswith(b"\n"):
            line = line[:-1]

        if b"\r" in line:
            _raise(
                self.paths.artifact,
                "CR inside a record"
                + (" (store is declared LF)" if self.eol is Eol.LF else ""),
                record=record,
            )

        return loads(
            line,
            path=self.paths.artifact,
            encoding=self.encoding,
            validator=self.validator,
            require_object=self.require_object,
            record=record,
        )

    def read_sig(self, schema_registry: Any = None) -> Dict[str, Any]:
        """Read and validate the `.sig`. Reports a foreign sidecar as foreign.

        `.sig` beside a `.jsonl` is not exclusive to this engine; other lanes have written their own
        shape to the same suffix. Such a file is valid and simply not ours, so it is named that way
        rather than reported as a schema failure, which would read as corruption.
        """
        sig_path = self.paths.sig
        if not self.has_signature:
            raise FileNotFoundError(f"Signature file not found: {sig_path}")

        raw = read_json(sig_path, encoding=DEFAULT_ENCODING)
        declared = raw.get("schema")
        if declared != SIG_SCHEMA_ID:
            _raise(
                sig_path,
                f"not a JSONL engine signature (schema is {declared!r}, expected "
                f"{SIG_SCHEMA_ID!r}); another lane writes its own sidecar to this suffix",
            )

        if schema_registry is None:
            from .schema_registry import get_global_schema_registry

            schema_registry = get_global_schema_registry()

        return validate(raw, schema_registry.get_validator(SIG_SCHEMA_ID), path=sig_path)

    def verify(self, schema_registry: Any = None) -> Optional[bool]:
        """Check the `.sig`, then SHA-256 and line count against the JSONL file.

        Returns True when the store verifies, and None when it carries no signature at all -- an
        unsigned store is a supported state, not a failed check, and returning False would claim a
        verification that never ran. Pass require_sig=True to make absence an error instead.

        Policy disagreement is reported first: a store read under the wrong encoding or terminator
        fails its hash, and "hash mismatch" would name the symptom instead of the cause.
        """
        if not self.has_signature and not self.require_sig:
            return None

        sig_data = self.read_sig(schema_registry)

        for field, declared in (("encoding", self.encoding), ("eol", self.eol.value)):
            witnessed = sig_data.get(field)
            if witnessed is not None and witnessed != declared:
                raise ValueError(
                    f"Policy disagreement for {self.paths.artifact}: written with "
                    f"{field}={witnessed!r}, read with {field}={declared!r}"
                )

        hasher = hashlib.sha256()
        line_count = 0
        with open(self.paths.artifact, "rb") as handle:
            for line in handle:
                hasher.update(line)
                line_count += 1

        actual_hash = hasher.hexdigest()
        if actual_hash != sig_data["sha256"]:
            raise ValueError(
                f"Signature verification failed for {self.paths.artifact}: "
                f"Hash mismatch ({actual_hash} != {sig_data['sha256']})"
            )
        if line_count != sig_data["line_count"]:
            raise ValueError(
                f"Signature verification failed for {self.paths.artifact}: "
                f"Line count mismatch ({line_count} != {sig_data['line_count']})"
            )
        return True

    # No query() method. The store is iterable, so a comprehension does the job with no dependency
    # and fails loudly on a mistyped key, where a query expression would return an empty list. A
    # query *language* is worth its weight only where the expression arrives as a string from
    # outside the process -- an MCP tool argument, a CLI flag -- and it belongs at that boundary.
