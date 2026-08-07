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

from .json_document import read_json_value

# The JSOI index records last-write time as .NET ticks: 100-nanosecond intervals since 0001-01-01
# UTC. The representation belongs to the format, which jso-ops/jsonl-v2.ps1 compares against
# DateTime.LastWriteTimeUtc.Ticks. The offset is derived from the two epochs rather than written as
# a literal.
_DOTNET_EPOCH = datetime(1, 1, 1, tzinfo=timezone.utc)
_UNIX_EPOCH = datetime(1970, 1, 1, tzinfo=timezone.utc)
_EPOCH_DELTA = _UNIX_EPOCH - _DOTNET_EPOCH
TICKS_PER_SECOND = 10_000_000
DOTNET_TICKS_OFFSET = (_EPOCH_DELTA.days * 86_400 + _EPOCH_DELTA.seconds) * TICKS_PER_SECOND

# The .sig sidecar's schema ships with the engine at schemas/sig.schema.json. Its identity is read
# from that file rather than restated here, so the schema is the only place the id is written.
SIG_SCHEMA_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "schemas", "sig.schema.json")
SIG_SCHEMA_ID = read_json_value(SIG_SCHEMA_PATH, require_object=False)["$id"]


def get_file_dotnet_ticks(file_path: str) -> int:
    """
    Computes exact integer .NET UTC Ticks from the filesystem st_mtime_ns.
    Guarantees exact byte-matching with PowerShell's (Get-Item file).LastWriteTimeUtc.Ticks.
    """
    stat = os.stat(file_path)
    return (stat.st_mtime_ns // 100) + DOTNET_TICKS_OFFSET


class Discipline(Enum):
    CREATE = "create"  # Replaces or creates fresh output
    APPEND = "append"  # Appends to existing output stream
    SEALED = "sealed"  # Immutable; write attempt raises PermissionError


class Codec(Enum):
    """Escaping policy for text with no plain UTF-8 form.

    UNICODE  ensure_ascii=False. Non-ASCII is written as UTF-8. An unpaired surrogate has no UTF-8
             encoding and raises at write time. Default.

    ASCII    ensure_ascii=True. Non-ASCII is written as \\uXXXX, a UTF-16 code unit, so an unpaired
             surrogate round-trips. For extracted text, where a PDF font CMap can yield code units
             that are not scalar values. Costs roughly 1.2x on multilingual prose.

    Substitution is not offered. Declared on the kind; separators and key order are fixed in
    append() and are not part of this choice.
    """
    UNICODE = "unicode"
    ASCII = "ascii"

    @property
    def ensure_ascii(self) -> bool:
        return self is Codec.ASCII


class JsonlEngine:
    """
    Deterministic JSONL engine for stream emission and transactional sidecar management.
    """
    def __init__(
        self,
        output_path: str,
        discipline: Discipline = Discipline.CREATE,
        codec: Codec = Codec.UNICODE,
        emit_index: bool = True,
        emit_sig: bool = True
    ):
        self.output_path = os.path.abspath(output_path)
        self.discipline = discipline
        self.codec = codec
        self.emit_index = emit_index
        self.emit_sig = emit_sig

        base_path = os.path.splitext(self.output_path)[0]
        self.jidx_path = base_path + ".jidx"
        self.sig_path = base_path + ".sig"

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
                # Check for unterminated trailing line
                with open(self.output_path, "rb") as check_f:
                    check_f.seek(-1, os.SEEK_END)
                    last_byte = check_f.read(1)
                    if last_byte != b"\n":
                        raise ValueError(f"Cannot append to unterminated JSONL file (missing trailing LF newline): {self.output_path}")

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

        Compact separators, insertion key order, and an LF terminator are fixed for every kind.
        Only the escaping policy varies; see Codec.
        """
        if self._file is None or self._file.closed:
            raise RuntimeError("JsonlEngine must be active inside a 'with' context manager.")

        # 1. Capture exact byte offset before writing line
        offset = self._file.tell()
        self.offsets.append(offset)

        # 2. Deterministic serialization; the codec decides escaping only
        json_str = json.dumps(
            record, ensure_ascii=self.codec.ensure_ascii, separators=(",", ":"), sort_keys=False
        ) + "\n"

        # The stdlib error names neither the record nor the remedy; re-raise with both.
        try:
            json_bytes = json_str.encode("utf-8")
        except UnicodeEncodeError as exc:
            raise ValueError(
                f"record {self.line_count} in {os.path.basename(self.output_path)} contains a code "
                f"unit with no UTF-8 form (typically an unpaired surrogate from text extraction). "
                f"This store's codec is '{self.codec.value}', which refuses rather than replaces. "
                f"Declare CODEC = Codec.ASCII on the kind to carry it losslessly as a \\uXXXX "
                f"escape, or repair the value upstream. Underlying error: {exc}"
            ) from exc

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
                # The hash covers codec-dependent bytes; record which codec produced them.
                "codec": self.codec.value,
                "metadata": stage_metadata or {},
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            sig_str = json.dumps(sig_payload, ensure_ascii=True, indent=2) + "\n"
            with open(self.sig_tmp, "wb") as f:
                f.write(sig_str.encode("utf-8"))

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
