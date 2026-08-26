# Resolution: Engine V7 Fail-Fast & Integrity Tightening

## Overview

Applied zero-tolerance fail-fast principles across `paths.py`, `schema_registry.py`, `engine.py`, and `registry.py` following Opus V4 feedback.

---

## Key Refinements Implemented

1. **Unterminated Last Line Guard on `APPEND` (`engine.py`)**:
   - `JsonlEngine.__enter__()` checks if existing file ends with `\n` (0x0A).
   - If trailing LF is missing, it raises `ValueError("Cannot append to unterminated JSONL file (missing trailing LF newline): ...")` immediately upon opening stream.

2. **Fail Fast on Declared-But-Missing Schemas (`registry.py`)**:
   - If a registry specifies `SCHEMA_NAME` or `SCHEMA_ID`, but `SchemaRegistry` cannot resolve it, `BaseArtifactRegistry.__init__` raises `KeyError` immediately at construction time.
   - Eliminates silent unvalidated fallback bugs.

3. **`__file__` Anchored Root Discovery (`paths.py`)**:
   - `find_repository_root()` starts searching from `os.path.dirname(os.path.abspath(__file__))`.
   - If sentinel markers (`AGENTS.md`, `.git`, `Directory.Build.props`) are not found, raises `RuntimeError` immediately rather than falling back to arbitrary caller working directory.

4. **Schema Checking & Collision Protection (`schema_registry.py`)**:
   - Runs `validator_cls.check_schema(schema_data)` on registration to guarantee schema validity.
   - Uses `jsonschema.validators.validator_for(schema_data)` dynamically.
   - Detects name/key collisions and raises `KeyError` if two distinct schemas attempt to register under identical names.
