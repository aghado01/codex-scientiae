r"""
src/shared/jsonl_engine/engine.py - Deterministic Streaming JSONL Engine (V7)

Implements primitive JSONL file mechanics with strict determinism invariants:
- Universal UTF-8 without BOM and LF-only newline records.
- Refuses appending to unterminated JSONL files (missing trailing LF).
- Deterministic compact ASCII-escaped JSON serialization (RFC 8259 compatible).
- Binary JSOI v2 seek index format (compatible with src/shared/jso-ops/jsonl-v2.ps1).
- Reordered commit transaction: .jsonl published first, stat'd for exact integer .NET ticks.
- Incremental SHA-256 provenance checksums (.sig).
- Coordinated multi-file atomic transactions (.jsonl, .jidx, .sig).
- Discipline modes: CREATE, APPEND, SEALED.
"""

import os
import json
import struct
import hashlib
from enum import Enum
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

# Exact integer Ticks offset between .NET Ticks (0001-01-01) and Unix Epoch (1970-01-01)
DOTNET_TICKS_OFFSET = 621_355_968_000_000_000


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


class JsonlEngine:
    """
    Deterministic JSONL engine for stream emission and transactional sidecar management.
    """
    def __init__(
        self,
        output_path: str,
        discipline: Discipline = Discipline.CREATE,
        emit_index: bool = True,
        emit_sig: bool = True
    ):
        self.output_path = os.path.abspath(output_path)
        self.discipline = discipline
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
        Enforces compact ASCII-escaped JSON (ensure_ascii=True, separators=(',', ':'))
        to guarantee byte-exact determinism across platforms and LF line endings.
        """
        if self._file is None or self._file.closed:
            raise RuntimeError("JsonlEngine must be active inside a 'with' context manager.")

        # 1. Capture exact byte offset before writing line
        offset = self._file.tell()
        self.offsets.append(offset)

        # 2. Deterministic serialization (compact, ASCII escaped for surrogate safety, LF line ending)
        json_str = json.dumps(record, ensure_ascii=True, separators=(",", ":"), sort_keys=False) + "\n"
        json_bytes = json_str.encode("utf-8")

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
                "sha256": self.hasher.hexdigest(),
                "line_count": self.line_count,
                "file_size": file_size,
                "ticks": ticks,
                "discipline": self.discipline.value,
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
