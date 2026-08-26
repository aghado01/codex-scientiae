# Resolution & Architectural Overhaul (V3 Engine)

## Overview

Addressing all points raised in `opus-engine-v2-feedback.md` under the principle of **strict determinism, fail-fast robustness, and zero silent fallbacks**.

---

## 1. Schema Validation & Header Fix

- **Problem**: Header line 0 crashed `validate_record` when `SCHEMA` required body fields like `page_num`.
- **Resolution**: Separated `HEADER_SCHEMA` from payload `SCHEMA`. `build_header()` validates against `HEADER_SCHEMA` (`__type__ == "header"`, `kind`, `version`, `created_at`). `validate_record()` validates payload records against `SCHEMA`.

---

## 2. Deterministic Serialization & Lossless PDF Surrogates

- **Problem**: Silent `try/except orjson` fallback produced different byte outputs (`{"a":1}` vs `{"a": 1}`) depending on `orjson` installation, breaking `.sig` SHA-256 hashes and `.jidx` byte offsets. Additionally, `orjson` cannot serialize lone UTF-16 surrogates from PDF text extraction.
- **Resolution**: Removed third-party serialization fallbacks. Standardized on standard library `json.dumps(record, ensure_ascii=True, separators=(",", ":"))`.
  - **Compact ASCII/UTF-8 Determinism**: Always produces compact JSON without whitespace discrepancies across any platform.
  - **Lossless PDF Surrogates**: `ensure_ascii=True` escapes lone UTF-16 PDF surrogates (`U+D800`–`U+DFFF`) into standard JSON `\uXXXX` sequences (`\ud800`), fulfilling RFC 8259 cleanly and safely.

---

## 3. Binary JSOI v2 Index Format Compatibility

- **Problem**: Python engine wrote JSOI v1 without `sourceLength` and `sourceLastWriteUtcTicks`, breaking staleness detection and interop with `src/shared/jso-ops/jsonl-v2.ps1`.
- **Resolution**: Aligned binary index header with JSOI v2 layout:
  `ASCII 'JSOI' | int32 version=2 | int32 lineCount | int64 sourceLength | int64 sourceLastWriteUtcTicks | int64[lineCount] offsets`

---

## 4. Completed Reader API

- **Added `ArtifactReader.seek_record(jsonl_path, index)`**: Random-access record retrieval by seeking directly to byte offsets in `.jidx`.
- **Added `ArtifactReader.verify_signature(jsonl_path)`**: Re-computes SHA-256 checksum over `.jsonl` and verifies against `.sig` sidecar payload (raises `ValueError` on hash mismatch or line count discrepancy).
- **Strict Binary Reader (`'rb'`)**: Catches CRLF line ending contamination and malformed UTF-8 sequences immediately.

---

## 5. Discipline Modes (`CREATE`, `APPEND`, `SEALED`)

- **`Discipline.CREATE`**: Atomically creates fresh (replaces existing file).
- **`Discipline.APPEND`**: Appends lines to existing stream, building upon existing line counts, byte offsets, and SHA-256 state.
- **`Discipline.SEALED`**: Protects immutable ledgers; write attempt raises `PermissionError`.
