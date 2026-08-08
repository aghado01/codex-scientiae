"""Primitive JSONL file mechanics: serialization, byte offsets, and atomic publication.

A committed store is UTF-8 without BOM, LF-terminated, compact-separated, in insertion key order.
Two sidecars accompany it: a JSOI v2 byte-offset index (.jidx) shared with jso-ops/jsonl-v2.ps1, and
a SHA-256 signature (.sig) accumulated during the write.

Offsets are captured from file.tell() as each record is written.

commit() renames the .jsonl into place, stats the published file, then writes and renames the
sidecars. The index records that file's length and last-write time; ticks are integer arithmetic on
st_mtime_ns.

Discipline selects create, append, or sealed. SEALED refuses to open this engine for writing and
does not mark the artifact on disk, so it constrains the declaring kind rather than the path.

Codec selects the escaping policy. Text with no UTF-8 form is escaped or refused; it is never
substituted.

Contains no knowledge of kinds, schemas, ingestion, or run layout.
"""

import os
import json
import struct
import hashlib
from enum import Enum
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from .policy import DEFAULT_ENCODING, Codec, Eol
from .sidecar import (
    SIG_SCHEMA_ID,
    SIG_SCHEMA_PATH,
    DOTNET_TICKS_OFFSET,
    TICKS_PER_SECOND,
    get_file_dotnet_ticks,
    get_ticks_offset,
    store_paths,
)
from .writer import JsonWriterError, serialize_json, write_json

# Codec and Eol are re-exported from policy, ticks and schema id from sidecar, for existing
# importers. The definitions live in the leaf modules that both the writer and the reader share.
__all__ = [
    "Codec",
    "Eol",
    "DEFAULT_ENCODING",
    "Discipline",
    "JsonlEngine",
    "SIG_SCHEMA_ID",
    "SIG_SCHEMA_PATH",
    "DOTNET_TICKS_OFFSET",
    "TICKS_PER_SECOND",
    "get_file_dotnet_ticks",
    "get_ticks_offset",
]


class Discipline(Enum):
    CREATE = "create"  # Replaces or creates fresh output
    APPEND = "append"  # Appends to existing output stream
    SEALED = "sealed"  # Immutable; write attempt raises PermissionError


class JsonlEngine:
    """
    Deterministic JSONL engine for stream emission and transactional sidecar management.
    """
    def __init__(
        self,
        output_path: str,
        discipline: Discipline = Discipline.CREATE,
        codec: Codec = Codec.UNICODE,
        eol: Eol = Eol.LF,
        encoding: str = DEFAULT_ENCODING,
        emit_index: bool = True,
        emit_sig: bool = True
    ):
        self.discipline = discipline
        self.codec = codec
        self.eol = eol
        self.encoding = encoding
        self.emit_index = emit_index
        self.emit_sig = emit_sig

        paths = store_paths(output_path)
        self.output_path = paths.jsonl
        self.jidx_path = paths.jidx
        self.sig_path = paths.sig

        self.tmp_path = self.output_path + ".tmp"
        self.jidx_tmp = self.jidx_path + ".tmp"
        self.sig_tmp = self.sig_path + ".tmp"

        self.offsets: List[int] = []
        self.line_count: int = 0
        self.hasher = hashlib.sha256()
        self._file = None
        self._committed = False

    def __enter__(self):
        if self.discipline == Discipline.SEALED:
            raise PermissionError(f"Cannot open sealed JSONL artifact for writing: {self.output_path}")

        os.makedirs(os.path.dirname(self.output_path), exist_ok=True)

        if self.discipline == Discipline.APPEND and os.path.exists(self.output_path):
            file_size = os.path.getsize(self.output_path)
            if file_size > 0:
                # The existing stream must end on this store's declared terminator. Appending past
                # a partial line would corrupt the record it lands on, and appending LF to a CRLF
                # store would leave a file no declared policy can read.
                terminator = self.eol.terminator(self.encoding)
                with open(self.output_path, "rb") as check_f:
                    check_f.seek(-min(len(terminator), file_size), os.SEEK_END)
                    tail = check_f.read()
                    if tail != terminator:
                        raise ValueError(
                            f"Cannot append to unterminated JSONL file (expected a trailing "
                            f"{self.eol.value.upper()} terminator, found {tail!r}): {self.output_path}"
                        )

            # Copy existing file to tmp to continue stream transactionally
            with open(self.output_path, "rb") as src, open(self.tmp_path, "wb") as dst:
                content = src.read()
                dst.write(content)
                self.hasher.update(content)
            
            # Reconstruct offsets and line count cleanly
            self.offsets.clear()
            self._file = open(self.tmp_path, "r+b")
            self._file.seek(0)
            
            offset = 0
            for line in self._file:
                self.offsets.append(offset)
                offset += len(line)
            self.line_count = len(self.offsets)
            self._file.seek(0, os.SEEK_END)
        else:
            self._file = open(self.tmp_path, "wb")
            self.offsets.clear()
            self.line_count = 0
            self.hasher = hashlib.sha256()

        self._committed = False
        return self

    def append(self, record: Dict[str, Any]) -> None:
        """
        Serializes and appends a single record line.

        Compact separators and insertion key order are fixed for every kind. The escaping policy,
        the encoding, and the record terminator are declared; see Codec, DEFAULT_ENCODING, and Eol.
        """
        if self._file is None or self._file.closed:
            raise RuntimeError("JsonlEngine must be active inside a 'with' context manager.")

        # 1. Capture exact byte offset before writing line
        offset = self._file.tell()
        self.offsets.append(offset)

        # 2. Deterministic serialization under this store's declared policy. The writer names the
        #    encoding and the remedy but not the record; re-raise with it, since in a store of
        #    50,000 rows the index is the part a caller cannot recover.
        try:
            json_bytes = serialize_json(
                record, encoding=self.encoding, codec=self.codec, path=self.output_path
            )
        except JsonWriterError as exc:
            raise ValueError(f"record {self.line_count}: {exc}") from exc

        json_bytes += self.eol.terminator(self.encoding)

        # 3. Write line & update SHA-256 hash incrementally
        self._file.write(json_bytes)
        self.hasher.update(json_bytes)
        self.line_count += 1

    def commit(self, stage_metadata: Optional[Dict[str, Any]] = None) -> None:
        if self._file and not self._file.closed:
            self._file.flush()
            self._file.close()

        # REORDERED TRANSACTION:
        # 1. Atomically rename .jsonl.tmp -> final .jsonl FIRST
        os.replace(self.tmp_path, self.output_path)

        # 2. Stat the final published .jsonl file for exact size and .NET integer ticks
        file_size = os.path.getsize(self.output_path)
        ticks = get_file_dotnet_ticks(self.output_path)

        # 3. Generate JSOI v2 .jidx.tmp sidecar using exact stat ticks
        if self.emit_index:
            self._write_jidx_v2(self.jidx_tmp, file_size, ticks)

        # 4. Generate .sig.tmp sidecar
        if self.emit_sig:
            sig_payload = {
                # The sidecar names the schema that governs it, matching the manifest convention.
                # Unheadered stores carry no identity in the .jsonl itself, so this is where a
                # reader learns what it is holding.
                "schema": SIG_SCHEMA_ID,
                "sha256": self.hasher.hexdigest(),
                "line_count": self.line_count,
                "file_size": file_size,
                "ticks": ticks,
                "discipline": self.discipline.value,
                # The hash covers bytes produced under all three text-policy axes; record every one
                # of them, so a signature that fails to reproduce is attributable to a policy
                # difference rather than merely wrong. A reader learns the store's policy here.
                "encoding": self.encoding,
                "codec": self.codec.value,
                "eol": self.eol.value,
                "metadata": stage_metadata or {},
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            # The .sig is written ASCII-escaped and UTF-8 regardless of the store's own policy: it
            # is the artifact that tells a reader what that policy was, so it cannot require the
            # answer in order to be read. atomic=False because the rename is step 5 -- both
            # sidecars appear together or not at all.
            write_json(
                self.sig_tmp,
                sig_payload,
                encoding=DEFAULT_ENCODING,
                codec=Codec.ASCII,
                indent=2,
                atomic=False,
            )

        # 5. Atomically rename sidecars into target destinations
        if self.emit_index and os.path.exists(self.jidx_tmp):
            os.replace(self.jidx_tmp, self.jidx_path)
        if self.emit_sig and os.path.exists(self.sig_tmp):
            os.replace(self.sig_tmp, self.sig_path)

        self._committed = True

    def _write_jidx_v2(self, target_jidx_path: str, file_size: int, ticks: int) -> None:
        """
        Writes binary JSOI v2 index format:
        ASCII 'JSOI' | int32 ver=2 | int32 lineCount | int64 sourceLength |
        int64 sourceLastWriteUtcTicks | int64[lineCount] offsets
        """
        with open(target_jidx_path, "wb") as f:
            f.write(b"JSOI")                              # Magic (4B ASCII)
            f.write(struct.pack("<i", 2))                 # Version 2 (int32)
            f.write(struct.pack("<i", len(self.offsets))) # Line Count (int32)
            f.write(struct.pack("<q", file_size))         # sourceLength (int64)
            f.write(struct.pack("<q", ticks))             # sourceLastWriteUtcTicks (int64)
            for o in self.offsets:
                f.write(struct.pack("<q", o))             # Line Offset (int64)

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self._file and not self._file.closed:
            self._file.close()

        # Clean up temporary files if uncommitted or on exception
        if not self._committed or exc_type is not None:
            for tmp_file in (self.tmp_path, self.jidx_tmp, self.sig_tmp):
                if os.path.exists(tmp_file):
                    try:
                        os.remove(tmp_file)
                    except OSError:
                        pass
