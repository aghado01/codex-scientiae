# Test fixtures

Durable, committed artifacts that let tests pin behavior without depending on regenerable working output.

## `goldens/`

Byte-equality pins for `JsonlEngine` text policy. `tests/jsonl_engine/jsonl_golden_cases.py` names this
directory. Refresh only through `tests/jsonl_engine/regenerate_jsonl_goldens.py` after a deliberate format
change.

The former `chunks/` fixtures and their regenerator belonged exclusively to the retired codex-membrane
corpus suites. They were removed with the remaining active-tree references after that product's eviction.
