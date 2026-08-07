Let me verify the load-bearing claims in it before I comment.

Good bones, and it independently lands on several things we worked out — but its central claim is wrong, and I can show it.

## What it gets right

- **The PUA diagnosis is correct** and matches my measurement: UTF-8 covers every scalar value; lone surrogates are the actual problem.
- **Binary mode + explicit `.encode()`** is a better shape than either of your PowerShell writers. In `"wb"`, `\n` stays LF on every platform — that's the clean fix for the CRLF divergence in `jsonl.ps1`.
- **Offsets from `tell()` during the write**, not a rescan — the same insight as your own jsonl.ps1 comment.
- **Incremental SHA-256 while writing** — free provenance, and it revives the v1 `.checksum` idea at the tier where it's actually meaningful.
- **`__type__` header record** and **`KIND`/`VERSION` as class attributes** — that's the tagged-union conclusion and the declaration-as-type shape.
- `get_output_path()` deriving the filename from `KIND` is "the kind knows its own companions."

## The central claim is false

`DEFAULT_ERRORS = "surrogateescape"  # Retains lone surrogates from broken CMap tables`

Measured:

```
U+D800 (high — what UTF-16 PDF extraction yields)  -> UnicodeEncodeError
U+DC80 (in surrogateescape's own range)            -> b'\x80'
U+DFFF (low, out of range)                         -> UnicodeEncodeError
```

`surrogateescape` only round-trips **U+DC80–U+DCFF** — the range it itself produces when _decoding_ undecodable bytes. It is a byte-smuggling mechanism, not a surrogate-preservation mechanism. On the exact case the document names, it raises.

The handler that works is `backslashreplace` → `b'\\ud800'`. But the principled fix is one layer up:

```
json.dumps({"x":"\ud800"}, ensure_ascii=True)  -> '{"x": "\\ud800"}'
```

JSON's own `\uXXXX` escape _is_ a UTF-16 code unit — it carries a lone surrogate losslessly, and the output is pure ASCII so no encoding error is possible. The draft explicitly disables that (`ensure_ascii=False`, justified as "cleaner, readable JSONL") and then reaches for a broken error handler to fix the problem it just created.

That's the escaping-policy slot in miniature: escaping isn't cosmetic. It's the lossless carrier for code units that have no UTF-8 form.

## The UTF-16 option is unusable as written

```
line1 -> b'\xff\xfe{\x00"\x00a\x00"\x00:\x001\x00}\x00\n\x00'
line2 -> b'\xff\xfe{\x00"\x00b\x00"\x00:\x002\x00}\x00\n\x00'
```

`.encode("utf-16")` emits a BOM **per call**, so every record gets one. The offsets would still be "correct," so the index would faithfully describe an unreadable file. (`utf-16-le` avoids it, but no JSONL consumer reads either.)

## `default=str` is the Python cognate of the depth bug

```
{"t": "2026-01-01 00:00:00", "s": "{1, 2}", "o": "<__main__.Foo object at 0x000001F0C1F4BC20>"}
```

Silent stringification producing valid-but-wrong JSON — the same failure as `"System.Collections.Hashtable"`. And note the **memory address**: with `default=str`, byte-identical reruns are impossible, which destroys the SHA-256 provenance the engine is otherwise carefully computing. Those two features are in direct conflict.

## Other confirmed defects

- **Line 178 `def write((self) -> str:`** — doesn't parse.
- **Sidecar naming diverges**: `foo.jsonl.jidx` (append) vs `Resolve-JsonlIndexPath`'s `ChangeExtension` → `foo.jidx`. They won't find each other's indexes.
- **Index regression + magic collision**: `JSOI` version **1** with only count + offsets — no `sourceLength`, no `sourceLastWriteUtcTicks`, so **zero staleness detection**. And that's now a third distinct layout claiming that magic (PS v1 `JSO\x01`/.jli with offset+length pairs; PS v2 JSOI with length+mtime; this).
- **Sidecars written before the atomic rename** — a failed `os.replace` leaves `.jidx` and `.sig` describing a file that doesn't exist. The atomicity doesn't extend to the sidecar set.
- **`__exit__` leaks on success-without-commit** — cleanup only runs when `exc_type is not None`, so a forgotten `commit()` orphans the `.tmp` permanently.
- **"Streaming" is half true** — `BaseArtifactRegistry.add()` accumulates everything in `self._records`. The engine streams; the registry buffers the whole lane.
- `datetime.utcnow()` is deprecated in 3.12+.

## The architectural read

The ABC has roughly the right skeleton — `KIND`, `VERSION`, `validate_record`, `build_header`, `get_output_path` are four of the slots. What's missing is what we established actually separates your kinds:

- **no discipline slot** — `write()` always creates fresh. No sealed, no append-only, no mutable.
- **no key, uniqueness, or ordering.**
- **no row-type union** — `validate_record` is a single function, so nodes-and-edges-in-one-file can't be expressed. And the header bypasses validation entirely: `build_header()` output goes straight to `engine.append`, never through `validate_record`.

And the one I'd flag hardest: **the codec is a constructor parameter, not a kind property.**

```python
PdfExtractRegistry(target_dir=..., encoding=..., errors=...)
```

Any caller can change a kind's encoding and error strategy at the call site. That's the exact leak the whole design exists to close — the class declares `DEFAULT_ENCODING` and then lets it be overridden per instance. If codec facts belong to the kind, they can't be arguments.

Same structural caution as before on inheritance-as-declaration: `PdfExtractRegistry` gets its identity by subclassing, so a kind that is both scoped and append-only needs mixins or composition, not a second parent.

Net: worth keeping as a source of ideas — binary-mode writing, incremental hashing, offsets-during-write, and the ABC skeleton are all real. But the encoding story needs inverting (escape at the serializer, don't rescue at the encoder), and the slots that distinguish your kinds aren't there yet.
