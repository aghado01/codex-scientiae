Let me verify rather than take the summary — claim 3 is the one that failed before, and mtime behavior is subtle.

Verified — claim 3 holds. `delta=0` on every case, and PowerShell now reads through the index:

```
[create]       ticks exact=True  delta=0      Read-JsonlIndex -Path : OK
[append]       ticks exact=True  delta=0      Get-JsonlRecordCount  : 5
[empty-append] ticks exact=True  delta=0      Read-Jsonl            : 5 records
```

`st_mtime_ns // 100 + OFFSET` against the post-rename stat matches `LastWriteTimeUtc.Ticks` exactly. The append path also works properly now — reconstructed `[0,20,40]`, committed `[0,20,40,60,80]`, records `[0,1,2,3,4]`, and the empty-file case gives `line_count=0 offsets=[]` then `count=1 offsets=[0]`. Both bugs closed.

Worth noting the two fixes are coupled: publishing `.jsonl` before the sidecars moves the crash window to "live file, stale index" — which is only safe _because_ the ticks now work and PowerShell throws on it. Previously that ordering would have been silently wrong.

## One corruption bug left: unterminated last line

```
existing:  {"a":1}\n{"b":2}          (no trailing newline)
after:     {"a":1}\n{"b":2}{"c":3}\n
index:     count=3  offsets=[0, 8, 15]
```

APPEND concatenates onto the partial line, fusing two JSON objects into one physical record. And the index is the dangerous part:

- `Read-JsonlIndex -Path` → **OK**, count=3 (offsets are strictly increasing, in range, first is zero — structurally valid)
- `Get-JsonlRecordCount` → **3** (answered from the index)
- `Read-Jsonl` → **THROW: Malformed JSONL**

So the index asserts three records over a file with two physical lines, one of which isn't valid JSON — and the index is the artifact that passes validation. Offset 15 points into the middle of the fused line.

`__enter__` reconstructs offsets by iterating lines but never checks `content.endswith(b"\n")`. The PowerShell side already models this — `Initialize-Jsonl`'s Append mode is documented as opening "a valid line-boundary target." Same guard is needed here: refuse, or terminate the file first.

(I probed `Test-Jsonl` too crudely to interpret its result — ignore that line in my output.)

## Two tradeoffs worth being deliberate about

**`EMIT_HEADER = False` moves identity to the filename.** Pragmatic for existing lanes, but it gives up the property that made the header interesting: the artifact no longer declares its own kind. With the header off, kind is recoverable only from the filename or from `.sig`'s `metadata` — and `.sig` is optional and separable, while filenames get renamed, copied, and relocated. Given how much moves around this repo, that's the fragile carrier. Not wrong as a default; just worth knowing that unheadered artifacts are name-dependent for their identity.

**`NAME_FORMAT` is bypassed on the stem path.** The `elif stem:` branch hardcodes `f"{stem}.{self.KIND}.jsonl"` and ignores `NAME_FORMAT` entirely. A kind declaring a hyphen-infix format gets silently dot-infixed whenever a caller passes a stem. That's the declaration-overridden-by-call-site pattern again, in a smaller place — the stem branch should render through `NAME_FORMAT` like the fallback does.

## Unchanged

APPEND still does `content = src.read()` and copies the whole file — one line onto a 100 MB ledger reads and rewrites 100 MB in memory. That buys crash-atomicity, which is a real trade, but it's the cost the discipline exists to avoid. Worth deciding explicitly rather than inheriting: an append-only store can recover from a torn write by truncating to the last complete line, which is cheaper insurance than a full copy.

`DISCIPLINE` as a class attribute is the right fix and closes the leak. Still absent: key, uniqueness, and ordering slots — the ones that would let this express an inventory rather than just a stream.

`$ref`s are all internal (`#/$defs/...`), so no cross-file resolution needed — good. Let me test the rest.

Discovery works — both schemas indexed by `$id`, filename, and stem, all three key forms resolve, internal `$ref`s resolve, both pass `check_schema`. Schemas as external data addressed by `$id` is the "declaration is data" conclusion actually landing.

But every defect I found is the same species: **a silent fallback where a refusal belongs.** Three instances, and two of them chain.

## 1. A typo in `SCHEMA_NAME` silently disables validation

```
GoodReg   validator_bound=True  -> rejected (ValidationError)
TypoReg   validator_bound=False -> ACCEPTED junk
```

`TypoReg` declares `inventory-row.schmea.json`, gets `None`, and accepts `{"total":"garbage"}` without complaint. The comment says it plainly — _"registry operates unvalidated."_

Your PowerShell side already forbids exactly this. `New-JsonlStorePolicy` throws:

> `'SchemaPath requires SchemaValidator; schema validation must not be implied but skipped'`

Same failure mode, already named and refused, one directory over. The Python side needs the same distinction: **not declared** (both `SCHEMA_NAME` and `SCHEMA_ID` are `None` → unvalidated is intentional) versus **declared and unresolvable** (→ raise at construction). Right now `schema_key = self.SCHEMA_ID or self.SCHEMA_NAME or self.KIND` collapses them — the `KIND` fallback is what makes the two indistinguishable.

## 2. Root resolution outside the repo returns a wrong path, not an error

```
'C:\Users\azrie' -> 'D:\aghado01\codex-scientiae\ingestion\inventory'
'C:\'            -> 'D:\aghado01\codex-scientiae\ingestion\inventory'
```

No sentinel found anywhere up the tree, so `find_repository_root` falls through to `return os.path.abspath(os.getcwd())` — and cwd happened to be a random subdirectory from an earlier command in my shell. That's now "the repository root."

The chain: bad root → `RepoPaths.resolve("ingestion","inventory")` points nowhere → `auto_discover` hits `if not os.path.exists(path): continue` → **empty registry, no error** → every registry falls into bug #1 → the whole pipeline runs unvalidated. Two silent fallbacks compose into total silent failure.

Two fixes, both small: start from `os.path.dirname(os.path.abspath(__file__))` rather than `os.getcwd()` — the module knows where it lives, cwd is caller state — and raise instead of falling back.

**Worktree collision confirmed** as a related case:

```
'...\.claude\worktrees\elastic-faraday-a21f6a\src' -> '...\.claude\worktrees\elastic-faraday-a21f6a'
```

That worktree has its own `AGENTS.md`. `__file__`-based resolution handles this correctly either way — from a worktree copy of the module it _should_ resolve to the worktree.

## 3. `open_writer` with `EMIT_HEADER=True` writes no header

```
file contents: b'{"body":1}\n'
```

```python
engine = JsonlEngine(...)
if self.EMIT_HEADER and (...):
    with engine:
        engine.append(self.build_header())   # <- exits without commit()
return engine
```

The `with` block exits uncommitted, so `__exit__` deletes the tmp. The caller then re-enters, `__enter__` reopens `"wb"` and truncates, and the header is gone. `write()` honors `EMIT_HEADER`; `open_writer()` silently doesn't — same kind, two file shapes, decided by which method the caller picked.

## Smaller

- **Draft is hardcoded.** `Draft202012Validator` regardless of the file's `$schema`. Both current schemas are 2020-12, so it's latent — `jsonschema.validators.validator_for(schema)` closes it.
- **No `check_schema` at registration.** Both pass today. A malformed schema would compile fine and silently under-validate, since JSON Schema ignores unknown keywords. One line where you already load the file.
- **Key collisions overwrite silently.** `stem = filename.split(".")[0]`, indexed into a namespace shared across all search paths, resolved in `os.walk` order. No collision now; nothing would tell you about the first one.
- **`NAME_FORMAT` is now bypassed by three of four branches** (`filename`, `stem`, `run_id`). It applies only in the bare case. Either route them all through it or drop it.

## The through-line

Every one of these is the engine choosing to continue over choosing to fail. That's the opposite posture from the PowerShell layer next door, which fails loudly on stale indexes, refuses implied-but-skipped validation, and rejects CR in a record. For a validation and provenance layer, continuing is the wrong default — a silently unvalidated store is worse than no store, because it looks like evidence.

I'd fix in this order: `_resolve_payload_validator` raising on declared-but-missing, `find_repository_root` starting from `__file__` and raising on not-found, then the `open_writer` header. The first two are three lines each and they're what stands between this and a pipeline that quietly validates nothing.
