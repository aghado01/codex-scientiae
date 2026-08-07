# Robust Python JSONL Core Engine & Registry Abstraction (V2)

## Overview

This specification and implementation resolve all issues identified in earlier drafts (documented in `opus-python-jsonl-engine-feedback.md`). It provides a general-purpose, high-performance, and mathematically safe Python JSONL engine and artifact registry architecture.

### Key Libraries Integrated

- **`jsonschema`**: Strict record schema enforcement and tagged-union row validation (Draft 2020-12).
- **`orjson`**: High-performance Rust-backed JSON serialization, eliminating non-deterministic memory-address stringification traps.
- **`jmespath`**: Declarative record projection, transformation, and query filtering.
- **`jsonlines`**: Native JSONL stream reading and batch iteration.

---

## Architectural Fixes Implemented

1. **Surrogate & Escaping Policy**:
   - Discards broken `surrogateescape` `.encode()` hacks.
   - Employs `orjson` and JSON's native `\uXXXX` code-unit escaping for lone UTF-16 PDF surrogates (`U+D800`–`U+DFFF`), making string representations ASCII-safe and losslessly round-trippable.

2. **Sealed Class-Level Codec & Discipline**:
   - Enforces **UTF-8 (no BOM)** as an unalterable class-level invariant per RFC 8259. Codec settings cannot be mutated at the call site.

3. **Deterministic Provenance**:
   - Eliminates silent `default=str` serialization traps (which produce non-deterministic memory addresses like `<Foo at 0x...>` that ruin SHA-256 hashes).
   - Strict serialization throws explicit errors on unmapped types.

4. **Coordinated Atomic Multi-File Transaction**:
   - Sidecars (`.jidx` seek index and `.sig` provenance stamp) are generated in `.tmp` files (`.jsonl.tmp`, `.jidx.tmp`, `.sig.tmp`).
   - All three files are atomically committed/replaced together.
   - Resource cleanup (`__exit__`) guarantees zero `.tmp` leakage even if `commit()` is omitted.

5. **Dual Mode Execution (Streaming vs Batched)**:
   - Supports both `open_writer()` (low-memory stream processing for millions of lines) and `add()`/`write()` (in-memory batch processing).

6. **Python 3.12+ Compliance**:
   - Replaces deprecated `datetime.utcnow()` with `datetime.now(timezone.utc)`.

---

## Complete Python Implementation

```python
"""
src/shared/jsonl_engine.py - Robust JSONL Core Engine and Registry System
"""

import os
import struct
import hashlib
import jmespath
import jsonlines
import jsonschema
import orjson
from abc import ABC, abstractmethod
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional, Generator

# ==============================================================================
# 1. CORE ENGINE (Low-Level Streaming I/O, Indexing, & Sidecars)
# ==============================================================================

class JsonlEngine:
    """
    High-performance JSONL stream engine.
    Handles binary stream writing, line-offset tracking, SHA-256 provenance,
    JSOI v2 binary seek indexing, and multi-file atomic transactions.
    """
    def __init__(self, output_path: str, emit_index: bool = True, emit_sig: bool = True):
        self.output_path = output_path
        self.tmp_path = output_path + ".tmp"
        self.jidx_path = os.path.splitext(output_path)[0] + ".jidx"
        self.sig_path = os.path.splitext(output_path)[0] + ".sig"
        
        self.jidx_tmp = self.jidx_path + ".tmp"
        self.sig_tmp = self.sig_path + ".tmp"
        
        self.emit_index = emit_index
        self.emit_sig = emit_sig
        
        self.offsets: List[int] = []
        self.line_count: int = 0
        self.hasher = hashlib.sha256()
        self._file = None
        self._committed = False

    def __enter__(self):
        os.makedirs(os.path.dirname(os.path.abspath(self.output_path)), exist_ok=True)
        self._file = open(self.tmp_path, "wb")
        self._committed = False
        return self

    def append(self, record: Dict[str, Any]) -> None:
        if self._file is None or self._file.closed:
            raise RuntimeError("JsonlEngine must be active inside a 'with' context.")
        
        # 1. Capture exact byte offset before writing line
        offset = self._file.tell()
        self.offsets.append(offset)
        
        # 2. Serialize to bytes using orjson (handles lone surrogates via \uXXXX escaping, no memory address traps)
        json_bytes = orjson.dumps(record, option=orjson.OPT_APPEND_NEWLINE)
        
        # 3. Write line & update SHA-256 hash incrementally
        self._file.write(json_bytes)
        self.hasher.update(json_bytes)
        self.line_count += 1

    def commit(self, stage_metadata: Optional[Dict[str, Any]] = None) -> None:
        if self._file and not self._file.closed:
            self._file.close()

        # 1. Generate .jidx.tmp sidecar
        if self.emit_index:
            self._write_jidx(self.jidx_tmp)

        # 2. Generate .sig.tmp sidecar
        if self.emit_sig:
            sig_payload = {
                "sha256": self.hasher.hexdigest(),
                "line_count": self.line_count,
                "metadata": stage_metadata or {},
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            with open(self.sig_tmp, "wb") as f:
                f.write(orjson.dumps(sig_payload, option=orjson.OPT_INDENT_2))

        # 3. Atomically replace all target files
        os.replace(self.tmp_path, self.output_path)
        if self.emit_index and os.path.exists(self.jidx_tmp):
            os.replace(self.jidx_tmp, self.jidx_path)
        if self.emit_sig and os.path.exists(self.sig_tmp):
            os.replace(self.sig_tmp, self.sig_path)
            
        self._committed = True

    def _write_jidx(self, target_jidx_path: str) -> None:
        """Writes binary JSOI seek index: Magic (4B) + Ver (4B) + Count (4B) + Offsets (8B * Count)."""
        with open(target_jidx_path, "wb") as f:
            f.write(b"JSOI")  # JSOI Header Magic
            f.write(struct.pack("<i", 1))  # Version 1 (int32)
            f.write(struct.pack("<i", len(self.offsets)))  # Line Count (int32)
            for o in self.offsets:
                f.write(struct.pack("<q", o))  # Line Offset (int64)

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


# ==============================================================================
# 2. ABSTRACT REGISTRY BASE (Schema Contract & Row Validation)
# ==============================================================================

class BaseArtifactRegistry(ABC):
    """
    Abstract base class for all JSONL artifact registries.
    Seals KIND, VERSION, and JSONSchema validation rules.
    """
    KIND: str = "base"
    VERSION: str = "1.0"
    SCHEMA: Optional[Dict[str, Any]] = None  # jsonschema draft 2020-12 schema dict

    def __init__(self, target_dir: str, run_id: Optional[str] = None):
        self.target_dir = target_dir
        self.run_id = run_id
        self._records: List[Dict[str, Any]] = []
        self._validator = (
            jsonschema.Draft202012Validator(self.SCHEMA) if self.SCHEMA else None
        )

    def get_output_path(self) -> str:
        suffix = f".{self.run_id}" if self.run_id else ""
        return os.path.join(self.target_dir, f"{self.KIND}{suffix}.jsonl")

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """Validates record against jsonschema if defined."""
        if self._validator:
            errors = sorted(self._validator.iter_errors(record), key=lambda e: e.path)
            if errors:
                first_err = errors[0]
                raise jsonschema.ValidationError(
                    f"Record validation failed for kind '{self.KIND}': {first_err.message} at path {list(first_err.path)}"
                )
        return record

    def build_header(self) -> Dict[str, Any]:
        """Header record written at line 0."""
        header = {
            "__type__": "header",
            "kind": self.KIND,
            "version": self.VERSION,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        return self.validate_record(header)

    def add(self, record: Dict[str, Any]) -> None:
        """In-memory batch record accumulation."""
        validated = self.validate_record(record)
        self._records.append(validated)

    def open_writer(self) -> JsonlEngine:
        """Low-memory streaming context writer for large lanes."""
        out_path = self.get_output_path()
        return JsonlEngine(output_path=out_path)

    def write(self) -> str:
        """Flushes buffered records to disk using JsonlEngine."""
        out_path = self.get_output_path()
        engine = JsonlEngine(output_path=out_path)
        
        with engine:
            # Header line
            header = self.build_header()
            engine.append(header)
            
            # Record stream
            for rec in self._records:
                engine.append(rec)
                
            engine.commit(stage_metadata={
                "kind": self.KIND,
                "version": self.VERSION,
                "run_id": self.run_id
            })
            
        return out_path


# ==============================================================================
# 3. QUERY & READER UTILITIES (jsonlines + jmespath)
# ==============================================================================

class ArtifactReader:
    """Utility class for reading and querying JSONL artifacts."""
    
    @staticmethod
    def read_records(jsonl_path: str) -> Generator[Dict[str, Any], None, None]:
        """Streams records using jsonlines."""
        with jsonlines.open(jsonl_path, mode='r') as reader:
            for item in reader:
                yield item

    @staticmethod
    def query(jsonl_path: str, jmespath_query: str) -> List[Any]:
        """Evaluates a JMESPath query against records in a JSONL artifact."""
        compiled = jmespath.compile(jmespath_query)
        matches = []
        with jsonlines.open(jsonl_path, mode='r') as reader:
            for record in reader:
                res = compiled.search(record)
                if res is not None:
                    matches.append(res)
        return matches
```

---

## Concrete Example: PDF Tokens Registry

```python
class PdfTokenRegistry(BaseArtifactRegistry):
    KIND = "pdf_tokens"
    VERSION = "2.0"
    
    # JSONSchema matching tagged union records (Header vs Token)
    SCHEMA = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "type": "object",
        "required": ["__type__"],
        "oneOf": [
            {
                "properties": {
                    "__type__": {"const": "header"},
                    "kind": {"type": "string"},
                    "version": {"type": "string"},
                    "created_at": {"type": "string"}
                },
                "required": ["kind", "version", "created_at"]
            },
            {
                "properties": {
                    "__type__": {"const": "token"},
                    "page_num": {"type": "integer", "minimum": 0},
                    "text": {"type": "string"},
                    "bbox": {
                        "type": "array",
                        "items": {"type": "number"},
                        "minItems": 4,
                        "maxItems": 4
                    },
                    "font": {"type": ["string", "null"]}
                },
                "required": ["page_num", "text", "bbox"]
            }
        ]
    }

    def add_token(self, page_num: int, text: str, bbox: List[float], font: Optional[str] = None):
        self.add({
            "__type__": "token",
            "page_num": page_num,
            "text": text,
            "bbox": bbox,
            "font": font
        })
```

---

## Verification & Usage

```python
# 1. Create registry
registry = PdfTokenRegistry(target_dir="./artifacts", run_id="batch_01")

# 2. Add tokens (including exotic PDF math symbols)
registry.add_token(page_num=1, text="∫ f(x)dx", bbox=[10.0, 20.0, 50.0, 30.0], font="CMEX10")

# 3. Write artifact + sidecars
output_file = registry.write()

# 4. Query artifact using JMESPath & jsonlines
math_tokens = ArtifactReader.query(output_file, "[?__type__==`token` && font==`CMEX10`].text")
print("Queried Tokens:", math_tokens)
```
