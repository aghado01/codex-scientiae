Now the Pester battery:

Pester here is v6, which forbids root-level `BeforeEach`/`AfterEach` — wrapping the suites in one outer `Describe` fixes it:

Done — the logger landed as a shared substrate, committed as `32794a5` with 16/16 tests passing.

**On the prior art:** your suspicion was right — `RepoLogger.psm1` and `NaturalLogger.psm1` are the same class line-for-line (Natural just adds an alias plus `Export-ModuleMember` lines that don't actually work — there's no `-Class` parameter). `CyberneticLogger` was the interesting one: JSONL records, multiple sinks. The adaptation takes RepoLogger's file-first shape and CyberneticLogger's JSONL records, rebuilt on house invariants.

**What was built** — [log.ps1](src/shared/log.ps1), a dot-sourced sibling of `runs.ps1`/`jsonl.ps1`, plus [log.Tests.ps1](tests/shared/log.Tests.ps1):

- **One JSONL trace per run**, records shaped `{ts, el, lvl, comp, msg, data?}` — `el` is milliseconds since run start, the execution-trace clock. JSONL because you asked for parseable/scannable/sliceable: `Get-JsonlSchema` and your jso-jackson utilities speak it natively, and a `Get-RunLog` slicer (`-MinLevel`, `-Component`) is included.
- **Console stays quiet**: the file records everything, stderr mirrors warn+ only, and _stdout is never touched_ — your lanes emit data there and the MCP servers speak protocol there, so a logger writing to stdout would corrupt both.
- **Sink resolution ladder**: `-LogPath` → `-RunDir` (drops `trace.jsonl` into a run dir you already minted via `New-ModuleRunDir`) → `$env:CODEX_RUNLOG_DIR` (a child process joins its parent's run as `trace-{module}-{pid}.jsonl` — one file per process, never a shared handle, which matters given your multi-agent concurrency) → minted `artifacts/{module}/logs/{stamp}.jsonl` (already gitignored wholesale).
- **Configurable without touching call sites**: `-FileLevel`/`-ConsoleLevel` params, overridable per run by `CODEX_RUNLOG_LEVEL` / `CODEX_RUNLOG_CONSOLE` (`off` disables a sink).
- **`Measure-RunStep 'name' { … }`** — timed scopes that log duration and ok/fail, and _rethrow_ on exception (the trace observes, never swallows).
- A second `Start-RunLog` in-process **joins** the live context, so composed lanes trace into one file; `-Force` replaces. Logging before any `Start` is safe — warn+ still reaches stderr.
- Appends are per-record `[File]::AppendAllText` — crash-safe, no handle discipline; UTF-8-no-BOM, LF (byte-checked in tests, SMP/ligature round-trip included).

Typical wiring:

```powershell
. "$PSScriptRoot/../shared/log.ps1"
$runDir = New-ModuleRunDir 'latex-ingest' $slug
Start-RunLog -Module latex-ingest -RunDir $runDir | Out-Null
Measure-RunStep 'unpack' { ... }
Write-RunLog 'channel batch' -Data @{ channels = 3 }
Stop-RunLog
```

Two things you may want next, when you're ready: retiring the four duplicated `Write-Log` stderr one-liners in the MCP servers (reader/arxiv/scholar/zenodo) in favor of this, and first real wiring into latex-ingest since it already mints module run dirs. I left all call sites untouched — integration order felt like your call.

One environment discovery: bare `Invoke-Pester` now resolves **Pester 6.0.0** (not 5), which rejects root-level `BeforeEach` — I hit it, restructured the tests, and updated the stale memory accordingly.

## 2026-08-04 follow-up: JSONL and managed-store draft

The logger review exposed a broader shared-JSONL boundary. The pending replacement now lives in
`src/shared/jsonl-v2.ps1`; temporary compatibility behavior is isolated in
`src/shared/jsonl-v2-compat.ps1`, and managed lifecycle/database-like operations live separately in
`src/shared/jsonl-store-v2.ps1`. The `-v2` suffixes are temporary filenames only. Public commands are
intentionally unversioned, and none of these drafts is imported by production callers yet.

The division is now:

- `jsonl-v2.ps1`: strict UTF-8/Unicode-safe JSON serialization and parsing, atomic whole-file publication,
  coordinated append, stable reads, structural byte-offset indexes, validation, slicing, projection,
  exact lookup, snapshots, and basic file/index lifecycle inspection.
- `jsonl-store-v2.ps1`: named create/add/remove/subtract/sort transactions over those primitives. A
  mutation refreshes an existing `{stem}.jidx` automatically; `-BuildIndex` establishes one. Content
  publication followed by index-refresh failure is reported explicitly and leaves a detectably stale
  index rather than pretending that the whole transaction succeeded.
- `jsonl-v2-compat.ps1`: legacy index discovery/reading only, kept out of the replacement's core namespace.

### Store policies

A managed JSONL store is the generic substrate; inventory catalogs are only one store kind. Applications
bind a policy when they call the generic operations. The policy carries the kind, key selector/pointer,
key comparison and uniqueness rules, canonical sort descriptors, and an optional record-schema validation
hook. It is not persisted as another per-store sidecar.

For the prospective inventory store, the current draft policy is:

- The caller chooses the eventual JSON Pointer for the key; no inventory field name is frozen yet.
- The key value is the forward-slash relative path from that catalog's scope root to the document parent
  directory. `.` is the canonical whole-key value for the scope root itself. Rooted paths, backslashes,
  empty segments, embedded `.`/`..` segments, controls, and non-NFC strings are rejected.
- Uniqueness is checked case-insensitively to surface Windows/path-portability collisions. The preserved
  path spelling is sorted ordinally for deterministic output.
- Creation validates all records, rejects duplicate keys, sorts once, publishes once, and builds/refreshes
  the index once.
- Policy-aware add validates both existing and incoming records, applies explicit `Stop`, `KeepExisting`,
  or `Replace` duplicate behavior, canonically sorts, publishes once, and refreshes the index once. The
  correctness-first implementation currently rewrites the store; a later fast path may append only when
  every incoming key is unique, already sorted, and strictly after the current final key.

The scoped-parent key encodes a useful layout invariant: one logical document leaf per parent directory.
One direct document at a catalog scope has the key `.`, but multiple unwrapped documents there collide on
that key and are rejected instead of being silently conflated. Existing deposits that violate this invariant
need normalization or an explicitly different inventory identity rule.

### Decisions intentionally left open

Before the inventory policy is integrated, it still needs an actual row schema and JSON Schema file. That
design needs to settle:

1. The key field name and schema dialect/runtime used to validate it.
2. Logical document identity versus location identity, including whether moves are represented as identity
   changes, aliases, or history.
3. The source-manifest filename and required identity/provenance fields.
4. The artifact model for PDF, source archive, extracted source tree, supplementary files, checksums,
   acquisition timestamps/providers, and derivation relationships.
5. Direct versus recursive catalog scope and any depth semantics, so bottom-up and top-down builds converge
   byte-for-byte.
6. Which row-level attributes are authoritative and which store-level counts/digests are derived and must be
   recomputed in the same maintenance transaction.

No generic JSONL primitive should infer those ingestion rules from directory contents. Catalog construction
should consume explicit leaf manifests; filesystem inference belongs in a reviewable bootstrap/migration
tool because extracted source and converter output trees contain files that look like source documents.

### Logger implications

The initial logger description at the top of this discussion is historical, not the final integration
contract. Application/tool wrappers should bind their own run-directory and filename defaults, producing one
append-only log for the intended end-to-end run scope rather than defaulting to a proliferation of per-process
files. The shared logger should use the hardened JSONL write boundary for cooperating concurrency, remain
non-fatal to the run when logging itself fails, and make every fallback/degradation visible on stderr or in a
returned status. Those changes remain unapplied to production callers while the JSONL draft is being vetted.
