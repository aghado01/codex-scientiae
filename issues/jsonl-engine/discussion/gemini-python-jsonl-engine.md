First, a quick technical clarification about **UTF-8 vs PDF Codepoints**:

> **Standard UTF-8 actually covers ALL 1,114,112 Unicode code points** ($U+0000$ to $U+10FFFF$), including all Private Use Area (PUA) math symbols, ancient scripts, ligatures, and astral plane characters.
>
> What actually "squashes" or breaks exotic PDF characters during extraction is **unpaired UTF-16 surrogate halves (`U+D800`–`U+DFFF`)** or raw unmapped font bytes produced when a PDF has corrupt/custom CMap font tables. Standard Python `open(..., encoding='utf-8')` throws a `UnicodeEncodeError` when trying to serialize these lone surrogates into UTF-8 bytes.

To handle this cleanly in Python, the core engine must support **configurable text encodings** (`utf-8`, `utf-16`, `utf-32`) **AND flexible error handlers** like Python’s **`surrogateescape`**, **`backslashreplace`**, or **`xmlcharrefreplace`**.

Here is the complete **Python JSONL Core Engine & Base Artifact Registry**.

---

### 1. The Core Python Engine (`JsonlEngine`)

Handles binary byte-stream writing, flexible encoding/error handlers, on-the-fly byte-offset indexing (`.jidx`), SHA-256 fingerprinting (`.sig`), and atomic `.tmp` $\to$ target replacement.

```python
import os
import json
import hashlib
import struct
from typing import Any, Dict, List, Optional
from datetime import datetime

class JsonlEngine:
    """
    High-performance, streaming JSONL engine in Python.
    Supports flexible encodings (utf-8, utf-16, utf-32) and error handling
    strategies (surrogateescape, backslashreplace) to safely handle exotic
    PDF codepoints, broken font CMaps, and lone surrogates without data loss.
    """
    def __init__(
        self,
        output_path: str,
        encoding: str = "utf-8",
        errors: str = "surrogateescape",
        emit_index: bool = True,
        emit_sig: bool = True,
        ensure_ascii: bool = False
    ):
        self.output_path = output_path
        self.tmp_path = output_path + ".tmp"
        self.encoding = encoding
        self.errors = errors
        self.emit_index = emit_index
        self.emit_sig = emit_sig
        self.ensure_ascii = ensure_ascii

        self.offsets: List[int] = []
        self.line_count: int = 0
        self.hasher = hashlib.sha256()
        self._file = None

    def __enter__(self):
        os.makedirs(os.path.dirname(os.path.abspath(self.output_path)), exist_ok=True)
        # Open stream in raw binary mode to control exact byte offsets & error handling
        self._file = open(self.tmp_path, "wb")
        return self

    def append(self, record: Dict[str, Any]) -> None:
        if self._file is None:
            raise RuntimeError("Engine must be opened within a 'with' context manager.")

        # 1. Capture exact byte offset before writing line
        offset = self._file.tell()
        self.offsets.append(offset)

        # 2. Serialize to JSON string (ensure_ascii=False preserves literal Unicode symbols)
        json_str = json.dumps(record, ensure_ascii=self.ensure_ascii, default=str) + "\n"

        # 3. Encode to bytes using specified encoding and error strategy
        # 'surrogateescape' lets lone PDF font surrogates round-trip without throwing UnicodeEncodeError
        json_bytes = json_str.encode(self.encoding, errors=self.errors)

        # 4. Write to disk & update SHA-256 hash incrementally
        self._file.write(json_bytes)
        self.hasher.update(json_bytes)
        self.line_count += 1

    def commit(self, stage_metadata: Optional[Dict[str, Any]] = None) -> None:
        if self._file:
            self._file.close()

        # 1. Write binary seek index sidecar (.jidx)
        if self.emit_index:
            self._write_jidx(self.output_path + ".jidx")

        # 2. Write provenance signature sidecar (.sig)
        if self.emit_sig:
            sig_payload = {
                "sha256": self.hasher.hexdigest(),
                "line_count": self.line_count,
                "encoding": self.encoding,
                "errors_strategy": self.errors,
                "metadata": stage_metadata or {},
                "created_at": datetime.utcnow().isoformat() + "Z"
            }
            with open(self.output_path + ".sig", "w", encoding="utf-8") as f:
                json.dump(sig_payload, f, indent=2)

        # 3. Atomic rename (.tmp -> final)
        os.replace(self.tmp_path, self.output_path)

    def _write_jidx(self, index_path: str) -> None:
        """Writes binary seek index (Magic 'JSOI' + Ver (1) + Count + Int64 Offsets)."""
        with open(index_path, "wb") as f:
            f.write(b"JSOI")  # Magic magic bytes
            f.write(struct.pack("<i", 1))  # Version 1 (int32)
            f.write(struct.pack("<i", len(self.offsets)))  # Line count (int32)
            for o in self.offsets:
                f.write(struct.pack("<q", o))  # Offset (int64)

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self._file and not self._file.closed:
            self._file.close()
        # Clean up temp file on failure
        if exc_type is not None and os.path.exists(self.tmp_path):
            try:
                os.remove(self.tmp_path)
            except OSError:
                pass
```

---

### 2. The Abstract Base Registry (`BaseArtifactRegistry`)

```python
from abc import ABC, abstractmethod

class BaseArtifactRegistry(ABC):
    """
    Abstract base class for all Python artifact registries.
    Subclasses define KIND, VERSION, and custom record validation logic.
    """
    KIND: str = "base"
    VERSION: str = "1.0"
    DEFAULT_ENCODING: str = "utf-8"
    DEFAULT_ERRORS: str = "surrogateescape"

    def __init__(
        self,
        target_dir: str,
        run_id: Optional[str] = None,
        encoding: Optional[str] = None,
        errors: Optional[str] = None
    ):
        self.target_dir = target_dir
        self.run_id = run_id
        self.encoding = encoding or self.DEFAULT_ENCODING
        self.errors = errors or self.DEFAULT_ERRORS
        self._records: List[Dict[str, Any]] = []

    def get_output_path(self) -> str:
        suffix = f".{self.run_id}" if self.run_id else ""
        return os.path.join(self.target_dir, f"{self.KIND}{suffix}.jsonl")

    @abstractmethod
    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """Subclasses implement custom schema checking or field coercions."""
        return record

    def build_header(self) -> Optional[Dict[str, Any]]:
        """Header record placed at line 0."""
        return {
            "__type__": "header",
            "kind": self.KIND,
            "version": self.VERSION,
            "encoding": self.encoding,
            "errors_strategy": self.errors,
            "created_at": datetime.utcnow().isoformat() + "Z"
        }

    def add(self, record: Dict[str, Any]) -> None:
        validated = self.validate_record(record)
        self._records.append(validated)

    def write((self) -> str:
        out_path = self.get_output_path()
        engine = JsonlEngine(
            output_path=out_path,
            encoding=self.encoding,
            errors=self.errors,
            ensure_ascii=False
        )

        with engine:
            header = self.build_header()
            if header is not None:
                engine.append(header)

            for rec in self._records:
                engine.append(rec)

            engine.commit(stage_metadata={
                "kind": self.KIND,
                "version": self.VERSION,
                "run_id": self.run_id
            })

        return out_path
```

---

### 3. Implementing a PDF Codex Registry Subclass

Here is a registry tailored for extracting exotic PDF glyphs, math characters, and raw font byte representations:

```python
class PdfExtractRegistry(BaseArtifactRegistry):
    KIND = "pdf_extracted_tokens"
    VERSION = "2.0"
    DEFAULT_ENCODING = "utf-8"
    DEFAULT_ERRORS = "surrogateescape"  # Retains lone surrogates from broken CMap tables

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        required = {"page_num", "text", "bbox"}
        missing = required - record.keys()
        if missing:
            raise ValueError(f"Record missing required keys: {missing}")
        return record

    def add_token(
        self,
        page_num: int,
        text: str,
        bbox: List[float],
        font_name: Optional[str] = None,
        raw_cid_hex: Optional[str] = None
    ) -> None:
        self.add({
            "page_num": page_num,
            "text": text,
            "bbox": bbox,
            "font": font_name,
            "raw_cid_hex": raw_cid_hex,
            "codepoints": [ord(c) for c in text]  # Explicit integer codepoints for verification
        })
```

---

### 4. Example Usage in an Extraction Script

```python
# Create registry instance
registry = PdfExtractRegistry(target_dir="./output_artifacts", run_id="pdf_batch_001")

# Add exotic math characters, ligatures, and PUA glyphs safely
registry.add_token(
    page_num=1,
    text="∫ f(x) dx = ∑ λ_i (𝔄 ⊗ 𝔅)",  # Complex math & Gothic symbols
    bbox=[100.0, 200.0, 400.0, 220.0],
    font_name="CMEX10",
    raw_cid_hex="0x00A1 0x00B2"
)

# Write to disk
artifact_file = registry.write()
print(f"Artifact successfully written to: {artifact_file}")
# Produces:
#  - ./output_artifacts/pdf_extracted_tokens.pdf_batch_001.jsonl
#  - ./output_artifacts/pdf_extracted_tokens.pdf_batch_001.jsonl.jidx
#  - ./output_artifacts/pdf_extracted_tokens.pdf_batch_001.jsonl.sig
```

### Why this addresses the PDF codepoint challenge:

1. **`surrogateescape`**: If a PDF text extractor yields an unmappable character or malformed UTF-16 surrogate (e.g. `\uD800`), standard Python crashes. `surrogateescape` safely encodes these into high-byte escapes without throwing exceptions.
2. **Explicit Integer Codepoint Array (`[ord(c) for c in text]`)**: Keeps the exact numerical Unicode codepoint ($U+XXXX$) alongside string representations, guaranteeing zero ambiguity when inspecting rare symbols.
3. **`ensure_ascii=False`**: Writes raw UTF-8 Unicode characters directly to disk rather than escaping them as `\uXXXX` strings, producing much cleaner, readable JSONL.
