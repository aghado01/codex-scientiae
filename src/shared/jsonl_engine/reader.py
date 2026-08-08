"""Read JSON files and JSONL stores.

Bytes are read in binary and decoded under a declared encoding. A leading UTF-8 BOM is accepted for
a single document only when the caller declares the BOM-consuming ``utf-8-sig`` codec; plain UTF-8
remains BOM-free. Optional `validator` is a compiled jsonschema validator applied after parse. A
JSONL store is one path triple (`.jsonl`, `.jidx`, `.sig`); `JsonlStore` holds its policy and
validator as state and parses the index once.

The three text-policy axes are declared, never sniffed -- see policy.py. For a store this engine
wrote, the `.sig` witnesses them, and verify() reports a policy disagreement before it reports a
hash mismatch, because the second is a consequence of the first.

Does not check canonical ordering, key uniqueness, or cross-artifact identity.
"""

from __future__ import annotations

import codecs
import hashlib
import json
import os
import struct
from copy import deepcopy
from dataclasses import dataclass
from pathlib import Path
from typing import Any, BinaryIO, Dict, Iterator, List, Optional, Union

import jsonschema

from .policy import DEFAULT_ENCODING, Eol, is_line_framable
from .sidecar import SIG_SCHEMA_ID, StorePaths, get_file_dotnet_ticks, store_paths

UTF8_BOM = b"\xef\xbb\xbf"


@dataclass(frozen=True)
class _FileGeneration:
    """Stable identity of one file generation, without keeping its handle open.

    A bounded view may coexist with an in-place append to the same file, so size and timestamps
    are deliberately not part of the normal identity. Replacing the pathname creates a different
    file identity even when the replacement happens to have the same bytes and timestamps.
    """

    device: int
    inode: int
    fallback_ctime_ns: int

    @classmethod
    def from_handle(cls, handle: BinaryIO) -> "_FileGeneration":
        stat = os.fstat(handle.fileno())
        return cls(
            device=stat.st_dev,
            inode=stat.st_ino,
            fallback_ctime_ns=getattr(stat, "st_ctime_ns", int(stat.st_ctime * 1_000_000_000)),
        )

    def matches(self, handle: BinaryIO) -> bool:
        current = type(self).from_handle(handle)
        if self.inode or current.inode:
            return self.device == current.device and self.inode == current.inode
        # Some filesystems expose no usable file id. A changed ctime is conservative there: it may
        # reject an append, but it will not let a replacement masquerade as the captured file.
        return (
            self.device == current.device
            and self.fallback_ctime_ns == current.fallback_ctime_ns
        )


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
    """Parse JSON from `raw` under `encoding` and its declared BOM semantics.

    A leading UTF-8 BOM is data-policy, not something to sniff away: only a codec alias resolving
    to ``utf-8-sig`` consumes it. Plain UTF-8 rejects the same bytes.
    """
    if raw.startswith(UTF8_BOM):
        try:
            declared_codec = codecs.lookup(encoding).name
        except LookupError as exc:
            _raise(path, f"unknown encoding '{encoding}'", exc, record=record)
        if declared_codec != "utf-8-sig":
            _raise(
                path,
                "leading UTF-8 BOM requires declared encoding 'utf-8-sig'",
                record=record,
            )

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

    def reject_nonfinite(token: str) -> Any:
        raise ValueError(f"non-finite numeric literal {token!r} is not JSON")

    try:
        # Python accepts NaN and infinities as JavaScript extensions by default. JSON does not.
        value = json.loads(text, parse_constant=reject_nonfinite)
    except json.JSONDecodeError as exc:
        # Inside a store the line number is always 1 and the record index is the locator that
        # matters; for a whole file it is the other way round.
        where = (
            f"malformed JSON (column {exc.colno})"
            if record is not None
            else f"malformed JSON (line {exc.lineno}, column {exc.colno})"
        )
        _raise(path, where, exc, record=record)
    except ValueError as exc:
        _raise(path, str(exc), exc, record=record)

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
        bound: Optional[int] = None,
        _generation: Optional[_FileGeneration] = None,
        _signature: Optional[Dict[str, Any]] = None,
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
        # Read bound. None means "to EOF", which is correct for a quiescent store and torn for one
        # being appended. See at_length / at_signature for the bounded views.
        self.bound = bound
        self._generation = _generation
        self._signature = deepcopy(_signature) if _signature is not None else None
        self._index: Optional[Jidx] = None
        self._offsets: Optional[List[int]] = None

    def _with(self, **overrides) -> "JsonlStore":
        """A sibling view of the same artifact, differing only in the given settings."""
        settings = {
            "encoding": self.encoding,
            "eol": self.eol,
            "validator": self.validator,
            "require_object": self.require_object,
            "require_index": self.require_index,
            "require_sig": self.require_sig,
            "bound": self.bound,
            "_generation": self._generation,
            "_signature": self._signature,
        }
        settings.update(overrides)
        return type(self)(self.paths.artifact, **settings)

    def at_length(self, length: Optional[int] = None) -> "JsonlStore":
        """A view bounded at `length`, defaulting to the last complete record right now.

        For reading a store another process is appending to. Readers take no lease -- one long scan
        would stall every writer, and a reader has nothing to protect. A bound is sufficient
        instead. An in-place append preserves the captured file generation and only grows above
        the bound; a replacement changes generation and makes the view fail clearly.
        """
        from .inspect import _complete_prefix_from_handle, _validate_record_boundary

        with open(self.paths.artifact, "rb") as handle:
            generation = _FileGeneration.from_handle(handle)
            size = os.fstat(handle.fileno()).st_size
            if length is None:
                bound = _complete_prefix_from_handle(handle, size=size)
            else:
                bound = _validate_record_boundary(handle, length, size=size)
        return self._with(
            bound=bound,
            _generation=generation,
            # A length-bound view has no claim on a signature inherited by another view.
            _signature=None,
        )

    def at_signature(self) -> "JsonlStore":
        """A view bounded at the length the `.sig` attests to.

        Stronger than at_length: a signed prefix is a population a writer committed to, so this
        method verifies the captured signature before returning rather than merely producing an
        untorn extent.
        """
        from .inspect import _validate_record_boundary

        # Retain this exact sidecar. Reading it again during verify() could bless a later commit
        # than the one from which this view took its bound.
        sig = self.read_sig()
        with open(self.paths.artifact, "rb") as handle:
            generation = _FileGeneration.from_handle(handle)
            size = os.fstat(handle.fileno()).st_size
            _validate_record_boundary(handle, sig["file_size"], size=size)

        view = self._with(
            bound=sig["file_size"],
            _generation=generation,
            _signature=sig,
        )
        # at_signature() promises a signed view, not merely a view sized from an unchecked
        # sidecar. Fail at construction if the captured signature does not attest to these bytes.
        view.verify()
        return view

    @property
    def has_index(self) -> bool:
        """Whether a .jidx accompanies this store."""
        return os.path.exists(self.paths.jidx)

    @property
    def has_signature(self) -> bool:
        """Whether this view carries a signature or one accompanies the live store."""
        return self._signature is not None or os.path.exists(self.paths.sig)

    def _assert_handle_generation(self, handle: BinaryIO) -> None:
        """Refuse to read through a pathname that now names another file generation."""
        if self._generation is not None and not self._generation.matches(handle):
            _raise(
                self.paths.artifact,
                "store generation changed after this bounded view was created; create a new view",
            )

    def _assert_current_generation(self) -> None:
        if self._generation is None:
            return
        try:
            with open(self.paths.artifact, "rb") as handle:
                self._assert_handle_generation(handle)
        except FileNotFoundError as exc:
            _raise(
                self.paths.artifact,
                "store generation is no longer available; create a new view",
                exc,
            )

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

        A generation-bound view scans even when an index exists. The artifact is bound to the file
        identity captured by at_length() or at_signature(), but an index opened later through its
        pathname could belong to a replacement generation. An unbound view uses a current index;
        a manually constructed extent-only view uses it only when it describes exactly that bound.
        """
        # A generation-bound view cannot consult a sidecar through the live pathname: that
        # sidecar may belong to a later replacement. Scan the captured artifact extent instead.
        if self._generation is not None:
            self._assert_current_generation()
            if self.require_index and not self.has_index:
                raise FileNotFoundError(
                    f"Index file not found and require_index is set: {self.paths.jidx}"
                )
        elif self.has_index:
            jidx = self.index
            if self.bound is None:
                if not jidx.is_current():
                    raise ValueError(
                        f"Stale JSONL index: {self.paths.jidx} does not match {self.paths.artifact}"
                    )
                return jidx.offsets
            if jidx.source_length == self.bound:
                return jidx.offsets

        if self.require_index and self._generation is None:
            raise FileNotFoundError(
                f"Index file not found and require_index is set: {self.paths.jidx}"
            )

        if self._offsets is None:
            # Derived from the same bounded walk iteration uses, so the two can never disagree
            # about which records this view contains.
            scanned: List[int] = []
            offset = 0
            for line in self._raw_lines():
                scanned.append(offset)
                offset += len(line)
            self._offsets = scanned
        return self._offsets

    def __len__(self) -> int:
        """Records in the store. O(1) from a usable .jidx, otherwise one scan.

        Scanned rather than refused because list() probes __len__ for a size hint, so without this
        list(store) would fail where an equivalent for-loop succeeds.
        """
        return len(self.offsets())

    def _raw_lines(self) -> Iterator[bytes]:
        """Every record's bytes, in order, stopping at the bound.

        The one place the bound is applied to a sequential read. A partial line straddling the
        bound is excluded rather than truncated: half a record is not a record.
        """
        consumed = 0
        try:
            handle = open(self.paths.artifact, "rb")
        except FileNotFoundError as exc:
            if self._generation is not None:
                _raise(
                    self.paths.artifact,
                    "store generation is no longer available; create a new view",
                    exc,
                )
            raise

        with handle:
            self._assert_handle_generation(handle)
            if self.bound == 0:
                return
            for record, line in enumerate(handle):
                if self.bound is not None and consumed + len(line) > self.bound:
                    _raise(
                        self.paths.artifact,
                        f"read bound {self.bound} is not a complete-record boundary",
                    )
                self._require_declared_terminator(line, record=record)
                consumed += len(line)
                yield line
                if self.bound is not None and consumed == self.bound:
                    return

            if self.bound is not None and consumed != self.bound:
                _raise(
                    self.paths.artifact,
                    f"store ended at byte {consumed} before read bound {self.bound}",
                )

    def __iter__(self) -> Iterator[Any]:
        """Stream every record in order, stopping at the bound. Needs no sidecar at all."""
        for record, line in enumerate(self._raw_lines()):
            yield self._loads_line(line, record=record)

    def __getitem__(self, index: Union[int, slice]) -> Any:
        offsets = self.offsets()
        if isinstance(index, slice):
            return [self[i] for i in range(*index.indices(len(offsets)))]

        n = len(offsets)
        record = index if index >= 0 else index + n
        if record < 0 or record >= n:
            raise IndexError(f"Record index {index} out of bounds [0, {n - 1}]")

        try:
            handle = open(self.paths.artifact, "rb")
        except FileNotFoundError as exc:
            if self._generation is not None:
                _raise(
                    self.paths.artifact,
                    "store generation is no longer available; create a new view",
                    exc,
                )
            raise
        with handle:
            self._assert_handle_generation(handle)
            handle.seek(offsets[record])
            line = handle.readline()
            if self.bound is not None and offsets[record] + len(line) > self.bound:
                _raise(
                    self.paths.artifact,
                    f"record {record} crosses read bound {self.bound}",
                )
        return self._loads_line(line, record=record)

    def _require_declared_terminator(self, line: bytes, *, record: int) -> None:
        """Require the framing policy without decoding or parsing the record payload."""
        if self.eol is Eol.CRLF:
            if line.endswith(b"\r\n"):
                if b"\r" in line[:-2]:
                    _raise(self.paths.artifact, "CR inside a record", record=record)
                return
            if line.endswith(b"\n"):
                _raise(
                    self.paths.artifact,
                    "store is declared CRLF but this record ends with a bare LF",
                    record=record,
                )
            _raise(
                self.paths.artifact,
                "store is declared CRLF but this record has no CRLF terminator",
                record=record,
            )
        if not line.endswith(b"\n"):
            _raise(
                self.paths.artifact,
                "store is declared LF but this record has no LF terminator",
                record=record,
            )
        if b"\r" in line[:-1]:
            _raise(
                self.paths.artifact,
                "CR inside a record (store is declared LF)",
                record=record,
            )

    def _loads_line(self, line: bytes, *, record: int) -> Any:
        """Strip the declared terminator, then parse. A declared terminator is enforced."""
        # This engine never writes a blank line, so one is a hand-edit or a foreign file. Refused
        # rather than skipped, and named -- "malformed JSON at column 1" describes the symptom.
        if not line.strip():
            _raise(self.paths.artifact, "blank line", record=record)

        self._require_declared_terminator(line, record=record)
        line = line[:-2] if self.eol is Eol.CRLF else line[:-1]

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
        if self._signature is not None:
            captured = deepcopy(self._signature)
            if schema_registry is not None:
                return validate(
                    captured,
                    schema_registry.get_validator(SIG_SCHEMA_ID),
                    path=sig_path,
                )
            return captured
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
            from .schemas import get_schema_catalog

            schema_registry = get_schema_catalog()

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

        # Hashed over the same bytes the view reads, so a view bounded at the signature verifies
        # against it rather than against whatever the file has grown to since.
        hasher = hashlib.sha256()
        line_count = 0
        for line in self._raw_lines():
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
