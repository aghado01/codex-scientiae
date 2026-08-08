Substantially tightened — the sidecar naming, the temp-file leak, the pre-rename sidecars, `default=str`, and the encoding knobs are all fixed. Let me read the reader and check one thing that worries me.

Confirmed two real bugs, one of them fatal on first use.

## The header fails its own schema

```
header validates against body schema: False
-> 'page_num' is a required property
```

`build_header()` ends with `return self.validate_record(header)`, and `validate_record` checks against the single class-level `SCHEMA`. So **any registry with a meaningful SCHEMA crashes on line 0 of every write.** Not latent — immediate.

Root cause is the tagged-union point: `SCHEMA` is one schema for all rows, but the store holds at least two row types. The fix has to be `oneOf`/`if-then-else` keyed on `__type__`, or a separate `HEADER_SCHEMA`. That's the schema slot becoming a dispatch table, which is the thing the design needs anyway.

## orjson and stdlib produce different bytes

```
stdlib default : {"a": 1, "b": [1, 2], "c": {"d": "x"}}    38 bytes
stdlib compact : {"a":1,"b":[1,2],"c":{"d":"x"}}           31 bytes
orjson         : always compact
```

Same record, different bytes depending on whether orjson happens to be installed — and it's an `ImportError` fallback, so it flips silently on a `pip install`. That breaks the two things the engine works hardest to provide: the `.sig` SHA-256 stops being reproducible, and the `.jidx` offsets stop matching across environments. The feature that needs byte determinism is undermined by the feature that trades it for speed.

`separators=(",", ":")` closes the gap for spacing. But there's a harder problem underneath: **orjson has no `ensure_ascii` option** — it always emits raw UTF-8 and raises on invalid UTF-8 by design. So the two backends cannot be made byte-identical if you ever need ASCII escaping. And you do:

## The surrogate capability was removed, not replaced

```
stdlib: UnicodeEncodeError - 'utf-8' codec can't encode character '\ud800'
```

Dropping `surrogateescape` was right — it never worked. But nothing took its place, so the PDF lane this was built for now **throws mid-write on exactly the input it exists to handle.** Better than corrupting, but it's an unhandled exception in the middle of a lane.

`ensure_ascii=True` fixes it losslessly (JSON's `\uXXXX` _is_ a UTF-16 code unit), and it incidentally kills the non-ASCII escaping divergence too. But orjson can't do it — orjson literally cannot serialize a lone surrogate at all. So for `pdf_extracted_tokens`, orjson is not a valid backend, and the serializer choice can't be a global try/except.

## The index collision is now live on both sides

`reader.py` refuses anything but version 1:

```python
if version != 1: raise ValueError(f"Unsupported JSOI index version: {version}")
```

Meanwhile [jsonl-v2.ps1](src/shared/jso-ops/jsonl-v2.ps1:23) writes `JSOI` version 2 with `sourceLength` and `sourceLastWriteUtcTicks`. Same magic, same `.jidx` extension, same `src/shared/`, mutually unreadable.

And dropping those two fields has a consequence beyond compatibility: `commit()` does three separate `os.replace` calls. Each is atomic alone, the set is not. A crash between them leaves a new `.jsonl` beside a stale `.jidx` — and with no length or mtime in the header, **that staleness is undetectable**. Those fields aren't decoration; they're what makes non-atomic sidecar publication safe.

## Both sidecars are write-only

`read_index()` returns a list of offsets and nothing consumes it — there's no `get_record(n)` that seeks. `.sig` is never verified. So random access and provenance exist on paper; the reader streams from byte zero either way. Worth closing that loop before the formats calcify, because a reader is what shakes out whether the format carries enough.

Minor: `read_records`' fallback opens in text mode, so universal-newlines silently absorbs CRLF — the reader can't detect the contamination the writer is careful to avoid.

## What's genuinely better

- Multi-file `.tmp` → `os.replace` for all three artifacts.
- `_committed` flag plus `__exit__` cleaning up on uncommitted-or-exception — the leak is gone.
- `__enter__` resets offsets/count/hasher, so the engine is safely re-enterable.
- Sidecar naming now uses `splitext` → `foo.jidx`, matching `Resolve-JsonlIndexPath` semantics.
- **`SCHEMA` as a class-level dict is the right move** — the declaration is _data_, not an abstract method. That's the shape we wanted: a kind declares, it doesn't implement.

## Still absent structurally

No discipline slot. `write()` and `open_writer()` both create fresh and `os.replace` over the target, so there is no append and no seal — **a ledger is still unrepresentable**, and `.sig` implicitly assumes sealed. No key, uniqueness, or ordering slots.

The two I'd fix before anything else are the header/schema crash and the serializer bifurcation — the first blocks first use, and the second quietly poisons the provenance story that justifies the `.sig` at all.
