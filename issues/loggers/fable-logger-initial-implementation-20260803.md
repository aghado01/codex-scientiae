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
