Much closer. Let me read the reader and then actually test the interop claim.

Now the real test — does a Python-written index actually pass the PowerShell reader?

Round trip run. Three real wins, and four failures — one of which blocks ordinary reads, not just validation.

## What works

**Serialization is now correct and lossless:**

```
{"__type__":"header","kind":"demo","version":"1.0"}
{"id":1,"text":"PUA \ue000 and astral \ud835\udd38"}
{"id":2,"text":"lone surrogate \ud800 here"}
```

Compact, LF, ASCII-escaped. PUA preserved, astral preserved as a surrogate pair, lone surrogate preserved as `\ud800`. That's the lossless carrier working exactly as intended.

**The JSOI v2 binary layout is byte-correct.** PowerShell reads it clean: `version=2 count=3 srcLen=150`. And `seek_record` and `verify_signature` both work — the sidecars aren't write-only anymore.

## The ticks are wrong, and it breaks reads not just checks

```
index ticks       : 639216777354910080
file mtime ticks  : 639216777354910118
delta             : -38 ticks
```

PowerShell: `THROW: Stale JSONL index`. And critically, so does `Get-JsonlRecordCount` — an _ordinary read_ consults the index, so a Python-written store isn't merely unvalidatable from PowerShell, it's **unreadable through the indexed path**.

Two independent causes:

1. `commit()` records `datetime.now(timezone.utc)` — wall clock at commit, not the file's `LastWriteTimeUtc`. Close by luck, never equal.
2. `timestamp() * 10_000_000` in float64 can't hold an 18-digit tick value. Measured drift against integer math: **28 ticks**.

Fix is both — `os.stat(...).st_mtime_ns // 100 + OFFSET`, integer throughout, read from the **final** path after `os.replace`. That reorders the transaction: rename the `.jsonl` first, stat it, then build and rename the sidecars.

## The two readers disagree about the same file

```python
return abs(ticks - self.source_last_write_ticks) < 10_000_000   # 1 second
```

Python's `is_current()` returned **True** for the file PowerShell called stale. That's worse than either being wrong — it's a semantic fork in a shared format. The v2 contract as PowerShell implements it is exact tick equality; a tolerant reader on the other side means a file is simultaneously fresh and stale depending on who asks, and it hides the ticks bug from the side that could have caught it. The tolerance should go.

## The lone surrogate survives the file but not the .NET reader

```
Read-Jsonl -> Malformed JSONL line 3:
  "Cannot read incomplete UTF-16 JSON text as string with missing low surrogate."
```

This isn't a bug in either side. Python's `json.loads` yields `'\ud800'` because Python strings hold lone surrogates. .NET strings can too — but System.Text.Json refuses to _materialize_ one from a `\uD800` escape.

So the escaping fix is genuinely lossless on disk and in Python, and unreadable by your existing PowerShell reader. That makes lone-surrogate preservation a **cross-language contract decision**, not a codec setting. Either the PowerShell side gets a raw-text read path for such records (`GetRawText()` rather than `GetString()`), or the extraction boundary converts them — the string carries U+FFFD and an integer code-unit array carries the evidence, which is what the original draft's `codepoints` idea was reaching for.

That's the earlier claim demonstrated rather than argued: the unrepresentable-input policy belongs upstream of storage.

## APPEND on an empty file produces a structurally invalid index

```
after __enter__: line_count=1 offsets=[0]
committed      : line_count=2 offsets=[0, 0]   actual lines=1
```

Duplicate offset. `Read-JsonlIndex` enforces strictly increasing (`$offsets[$i] -le $prior` → throw), so that index is rejected outright. Cause is the unconditional `self.offsets.append(0)` before the reconstruction loop.

And the append path itself does `content = src.read()` then copies the whole file to `.tmp`. Appending one line to a 100 MB ledger reads and rewrites 100 MB, in memory. APPEND exists precisely to avoid that — right now it's CREATE with extra steps.

## The slot leaked again

```python
def __init__(self, target_dir, run_id=None, discipline=Discipline.CREATE):
```

Discipline is a **constructor parameter**, while `KIND`/`VERSION`/`SCHEMA` are class attributes. So a caller can append to a kind that should be sealed. Same shape as the encoding leak you already closed — discipline belongs as `DISCIPLINE: Discipline` beside the others.

Related: `SEALED` only raises in `__enter__`. Nothing marks the artifact sealed on disk; `.sig` records it and no reader consults it. A caller passing `CREATE` overwrites a sealed store without resistance.

And `open_writer()` writes no header while `write()` does — two file shapes for one kind depending on which entry point the caller picked.

## Order I'd fix in

1. **Ticks** — integer math, real mtime, stat after rename. Unblocks all PowerShell reads.
2. **Drop the 1-second tolerance** — make Python agree with the contract instead of papering over it.
3. **APPEND offsets** — the empty-file case emits an index the other side rejects.
4. **`DISCIPLINE` as a class attribute**, and header emission moved somewhere both write paths share.

The surrogate question is the one I'd actually think about rather than patch — it's a decision about where evidence lives, and both answers are defensible.
