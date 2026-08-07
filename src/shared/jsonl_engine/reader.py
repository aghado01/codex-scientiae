"""Reading a JSONL store and verifying it against its sidecars.

Records are read in binary. Text mode applies universal-newline translation, which removes CR before
it can be observed. CR is insignificant whitespace in JSON and is rejected here rather than by the
parser, which accepts it everywhere except inside a string value.

read_index parses JSOI v2 and compares length and mtime ticks against the file. seek_record resolves
a record by byte offset. verify_signature validates the .sig against its schema, then recomputes
SHA-256 and line count.

Canonical ordering, key uniqueness, path shape, and cross-artifact identity are not checked.
"""

import os
import json
import struct
import hashlib
from dataclasses import dataclass
from typing import Any, Dict, Generator, List, Optional

from .json_document import read_json_document
from .engine import SIG_SCHEMA_ID
from .schema_registry import get_global_schema_registry

# Exact integer Ticks offset between .NET Ticks (0001-01-01) and Unix Epoch (1970-01-01)
DOTNET_TICKS_OFFSET = 621_355_968_000_000_000


@dataclass
class JsoiIndexV2:
    index_path: str
    jsonl_path: str
    version: int
    line_count: int
    source_length: int
    source_last_write_ticks: int
    offsets: List[int]

    def is_current(self) -> bool:
        """
        Strictly checks whether the index is current with the JSONL source file on disk.
        Enforces exact integer byte size and exact .NET LastWriteTimeUtc tick equality.
        """
        if not os.path.exists(self.jsonl_path):
            return False
        stat = os.stat(self.jsonl_path)
        if stat.st_size != self.source_length:
            return False
        ticks = (stat.st_mtime_ns // 100) + DOTNET_TICKS_OFFSET
        return ticks == self.source_last_write_ticks


class ArtifactReader:
    """Utility class for reading, random-access seeking, and verifying JSONL artifacts."""

    @staticmethod
    def read_records(jsonl_path: str) -> Generator[Dict[str, Any], None, None]:
        """
        Streams records from a JSONL file.
        Reads in binary mode to strictly catch raw line endings and UTF-8 errors.
        """
        with open(jsonl_path, "rb") as f:
            for line_no, line in enumerate(f):
                if not line.strip():
                    continue
                # Ensure line is LF ending
                if line.endswith(b"\r\n"):
                    raise ValueError(f"CRLF line ending detected on line {line_no} of {jsonl_path}")
                try:
                    yield json.loads(line.decode("utf-8"))
                except UnicodeDecodeError as e:
                    raise ValueError(f"Invalid UTF-8 sequence on line {line_no} of {jsonl_path}: {e}")

    @staticmethod
    def query(jsonl_path: str, jmespath_query: str) -> List[Any]:
        """Evaluates a JMESPath query against records in a JSONL artifact."""
        try:
            import jmespath
        except ImportError:
            raise RuntimeError("The 'jmespath' package is required to execute JMESPath queries.")

        compiled = jmespath.compile(jmespath_query)
        matches = []
        for record in ArtifactReader.read_records(jsonl_path):
            res = compiled.search(record)
            if res is not None:
                matches.append(res)
        return matches

    @staticmethod
    def read_index(jidx_path: str, jsonl_path: Optional[str] = None) -> JsoiIndexV2:
        """
        Parses a binary JSOI v2 index file (.jidx).
        Format: ASCII 'JSOI' | int32 ver=2 | int32 lineCount | int64 sourceLength |
                int64 sourceLastWriteUtcTicks | int64[lineCount] offsets
        """
        if not os.path.exists(jidx_path):
            raise FileNotFoundError(f"Index file not found: {jidx_path}")

        if jsonl_path is None:
            jsonl_path = os.path.splitext(jidx_path)[0] + ".jsonl"

        with open(jidx_path, "rb") as f:
            magic = f.read(4)
            if magic != b"JSOI":
                raise ValueError(f"Invalid JSOI index magic bytes: {magic}")

            version = struct.unpack("<i", f.read(4))[0]
            if version != 2:
                raise ValueError(f"Unsupported JSOI index version: {version}. Expected version 2.")

            line_count = struct.unpack("<i", f.read(4))[0]
            source_length = struct.unpack("<q", f.read(8))[0]
            source_ticks = struct.unpack("<q", f.read(8))[0]

            offsets = []
            for _ in range(line_count):
                offsets.append(struct.unpack("<q", f.read(8))[0])

        index_obj = JsoiIndexV2(
            index_path=jidx_path,
            jsonl_path=jsonl_path,
            version=version,
            line_count=line_count,
            source_length=source_length,
            source_last_write_ticks=source_ticks,
            offsets=offsets
        )
        return index_obj

    @staticmethod
    def seek_record(jsonl_path: str, record_index: int, jidx_path: Optional[str] = None) -> Dict[str, Any]:
        """
        Performs random-access record retrieval by seeking to the exact byte offset in .jidx.
        Validates that the index is current before seeking.
        """
        if jidx_path is None:
            jidx_path = os.path.splitext(jsonl_path)[0] + ".jidx"

        index_obj = ArtifactReader.read_index(jidx_path, jsonl_path)
        if not index_obj.is_current():
            raise ValueError(f"Stale JSONL index: {jidx_path} does not match {jsonl_path}")

        if record_index < 0 or record_index >= index_obj.line_count:
            raise IndexError(f"Record index {record_index} out of bounds [0, {index_obj.line_count - 1}]")

        offset = index_obj.offsets[record_index]

        with open(jsonl_path, "rb") as f:
            f.seek(offset)
            line = f.readline()
            return json.loads(line.decode("utf-8"))

    @staticmethod
    def verify_signature(
        jsonl_path: str,
        sig_path: Optional[str] = None,
        schema_registry: Optional[Any] = None
    ) -> bool:
        """
        Verifies the SHA-256 integrity signature of a JSONL artifact against its .sig sidecar.

        The sidecar is schema-validated before its values are trusted, so a truncated or edited
        .sig reports itself rather than presenting as a content mismatch.
        """
        if sig_path is None:
            sig_path = os.path.splitext(jsonl_path)[0] + ".sig"

        if not os.path.exists(sig_path):
            raise FileNotFoundError(f"Signature file not found: {sig_path}")

        # A malformed .sig must report itself, not surface later as a hash mismatch. Resolution
        # failure raises: the schema is declared by the engine, so its absence is a broken install
        # rather than a decision to skip validation.
        validator = (schema_registry or get_global_schema_registry()).get_validator(SIG_SCHEMA_ID)
        sig_data = read_json_document(sig_path, validator)

        expected_hash = sig_data.get("sha256")
        expected_line_count = sig_data.get("line_count")

        hasher = hashlib.sha256()
        line_count = 0

        with open(jsonl_path, "rb") as f:
            for line in f:
                hasher.update(line)
                line_count += 1

        actual_hash = hasher.hexdigest()

        if actual_hash != expected_hash:
            raise ValueError(f"Signature verification failed for {jsonl_path}: Hash mismatch ({actual_hash} != {expected_hash})")

        if line_count != expected_line_count:
            raise ValueError(f"Signature verification failed for {jsonl_path}: Line count mismatch ({line_count} != {expected_line_count})")

        return True
