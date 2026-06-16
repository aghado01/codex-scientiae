# I/O + Root Hardening Report

Scope of this session: Items 1 & 2 against `src/mcp-server.ps1` (+ `STANDARDS.md`, `src/SETUP.md`).
Line numbers are post-edit (current file). **No `serving.ps1` functions were edited** — see the
merge note at the end.

---

## Item 1 — Own the protocol channel + pin to UTF-8

### What changed (`src/mcp-server.ps1`)

- **Channel ownership, pinned UTF-8 (no BOM)** — new block at **lines 190-199**, before the banner
  and main loop:
  - `$script:Rpc` = `StreamWriter` over `[Console]::OpenStandardOutput()` with UTF-8(no-BOM),
    `AutoFlush = $true`.
  - `$script:In` = `StreamReader` over `[Console]::OpenStandardInput()` with UTF-8(no-BOM).
  - `[Console]::SetOut([Console]::Error)` — backstop so ambient `Console.Out` (stray
    `Write-Output`/`[Console]::Write`) lands on stderr, never mid-frame on stdout.
- **`Write-Rpc` / `Write-RpcError`** (lines **205-210**) now write via `$script:Rpc.WriteLine(...)`
  instead of `[Console]::Out.WriteLine(...)`. (Critical: after `SetOut`, `[Console]::Out` *is*
  stderr — leaving them unchanged would have sent every frame to stderr.)
- **Main loop read** (line **228**) now `$script:In.ReadLine()` instead of `[Console]::In.ReadLine()`.
  EOF behavior preserved: `ReadLine()` returns `$null` at EOF; the `while ($null -ne ...)` guard still
  terminates (verified: empty stdin → exit 0).
- **`Write-Log([string]$m)`** helper (line **202**) wrapping `[Console]::Error.WriteLine($m)`. The
  startup banner (line **224**), the discovery line, and the fatal bad-root diagnostic all go through
  it. All server-side logging is stderr-only.
- **Belt-and-suspenders for host writes** — new `Invoke-ToolGuarded` (lines **181-188**), called from
  the `tools/call` branch (line **266**) in place of the bare `Invoke-Tool`. See the deviation note.

### DEVIATION from the spec (read this)

The spec said to capture the result with `6>&2 3>&2 4>&2 5>&2`. **PowerShell cannot redirect a stream
to stderr** — `n>&2` is *"reserved for future use"* and is a hard parse error (`The '6>&2' operator is
reserved for future use.`). Only `n>&1` (merge into success) and `n>file` are legal. I verified this
empirically (the literal spec form fails to load the script at all).

Implemented the **equivalent intent** in `Invoke-ToolGuarded`: merge the Information(6)/Warning(3)/
Verbose(4)/Debug(5) streams into success (`3>&1 4>&1 5>&1 6>&1`) and split by record type — the tool's
stream-1 result (an `IDictionary`/hashtable) is returned; every other item is written to
`[Console]::Error`. Net effect matches the spec: diagnostics → stderr, stream-1 result captured,
stdout stays frame-only. Stream 2 (errors) is deliberately *not* merged, so the existing `try/catch`
around the call still catches terminating errors and emits the `isError` frame unchanged.

Empirical note: after `[Console]::SetOut([Console]::Error)`, a probe showed `Write-Host`,
`Write-Warning`, and `Write-Information` **already** route to stderr in `pwsh -NoProfile -File` (the
ConsoleHost UI writes through `Console.Out`, which we redirected). So `SetOut` alone already protects
stdout here; `Invoke-ToolGuarded` is the portable guard for any host variant that bypasses
`[Console]::Out` by writing the raw handle (it intercepts the records at the PS layer before the host
renders them).

### STANDARDS.md

Added **§7 "Daemon/Library Stream Discipline (src/)"** codifying the rule: src/ daemon/library code
targets streams explicitly at the .NET level (`[Console]::Error` for logs, the owned UTF-8 stdout
writer for frames); no `Write-Host`/`Write-Output`/`Out-*` for diagnostics; tool results are return
values, never host writes.

### Verified

`initialize` + `tools/list` piped through the server (UTF-8 in/out, stdout→file, stderr→file):
- stdout = exactly **2** lines, **all parse as JSON**; nothing else on stdout.
- stderr = only `codex-membrane MCP server up (root=...\ingestion)`.

UTF-8 SMP round-trip — `tools/call get_summary` with `paper = "doc_𝔼é"` (𝔼 = U+1D53C, a surrogate
pair; é = U+00E9):
- input codepoints sent: `U+D835,U+DD3C,U+00E9` (literal UTF-8 bytes over the pipe).
- stdout frame **contains UTF-8 bytes `F0 9D 94 BC` (𝔼) and `C3 A9` (é)**; **no** `EF BF BD` (U+FFFD),
  **no** `?` (0x3F) substitution.
- echoed text: `error: invalid paper name: 'doc_𝔼é'` — exact round-trip through read→parse→write.

---

## Item 2 — Derive `-Root`; work-scope as a runtime arg

### What changed (`src/mcp-server.ps1`)

- **Param block** (line **23**): `-Root` is no longer `[Parameter(Mandatory)]`; it defaults to
  `(Join-Path (Split-Path -Parent $PSScriptRoot) 'ingestion')` → `<repo>/ingestion`. Still accepts an
  explicit override. Header comment (lines 12-16) updated to match.
- **Bad-root guard — fail fast, in the agent's feed** (startup `$script:Fatal` block + a guard inside
  the `tools/call` branch): if the resolved `$Root` does not exist or is not a directory, the server
  records `$script:Fatal` and logs `FATAL: ...` to stderr. The connection **still mounts** —
  `initialize` and `tools/list` succeed normally, so the seeing agent comes up and can orient — but
  **every `tools/call` short-circuits to an `isError` result** carrying the diagnostic and the fix
  (`correct the -Root launch argument or create the directory and reconnect, or escalate to the
  user`). Rationale: a tool result is the channel the agent reliably sees in its feed; a failed
  `initialize` handshake tends to surface to the harness/operator as "server failed to connect" and
  can prevent the agent from ever seeing or acting on the message. This is the behavior the requesting
  user asked for across two rounds: fail fast, but as a brief in-feed notification the agent can act on
  (self-correct or escalate), not a silent degrade and not a swallowed handshake error.
- **`Resolve-Scope([string]$scope)`** helper (lines **114-126**): empty/whitespace → `$Root`;
  otherwise `[IO.Path]::GetFullPath(Join-Path $rootFull $scope)`, and **throws** if the normalized
  result escapes `$Root` (trailing-separator `StartsWith`, `OrdinalIgnoreCase`). Guards against `..`
  and absolute-path escapes.
- **`scope` property** added to the inputSchema of exactly three tools: `list_documents` (line **38**),
  `get_batch_summary` (line **83**), `dispatch` (line **86**). Tool **count unchanged at 21** (adding a
  property does not change the catalogue size — verified).
- **`Invoke-Tool` wiring**: passes `Resolve-Scope $arguments.scope` as the effective root —
  `list_documents` (line **130** → `Get-IngestionScan -Root`), `get_batch_summary` (line **154** →
  `Get-BatchSummary -Root`), `dispatch` (lines **156-159** → `Invoke-Dispatch -Root`). Paper-addressed
  tools resolve across the whole root and were left unchanged.

### `src/SETUP.md`

- Dropped `-Root ingestion/compendia` from the launch line, the `.mcp.json` (Option A), the
  `claude mcp add` (Option B), and the Verify snippet — all now show the bare
  `-NoProfile -File src/mcp-server.ps1` form.
- Documented `scope` as a runtime tool arg (new subsection + examples), updated the "For agents" steps
  and Notes. Verify section still asserts **21 tools** (confirmed unchanged).

### Verified

- `list_documents` with `scope="compendia/ph"` → scoped survey (returns WRD2025, VSMJ2011, …).
- `list_documents` with `scope="../src"` → `isError=true`, `scope escapes the ingestion root: '../src'`.
- `get_batch_summary` with no scope → whole-root survey (WRD2025, DBK20…).
- Bare launch (no `-Root`) → banner shows derived `...\codex-scientiae\ingestion`.
- Explicit `-Root <abs>` override → loads, EOF → exit 0, empty stdout, banner only.
- Bad `-Root <nonexistent>` (fail fast, in-feed) → `initialize` (id=1) `ok` (mounted), `tools/list`
  (id=2) `ok (21 tools)` so the agent orients, `tools/call list_documents` (id=3) → `isError=true`
  with feed text `error: ingestion root not found or not a directory: ... -- correct the -Root launch
  argument or create the directory and reconnect, or escalate to the user.`; stderr showed `FATAL: ...`.
  Good-root regression in the same run: id=1/2/3 all `ok`.

Test commands lived in `$env:TEMP` scratch files (UTF-8 no-BOM in/out, stdout & stderr redirected to
separate files); each run was `Get-Content -Raw -Encoding utf8 <in> | pwsh -NoProfile -File <server> 1><out> 2><err>`.

---

## Startup ceremony — discovery handshake (follow-up)

The requesting user observed that a dead-root failure should be *rare* because the filesystem walk
inherently yields only valid paths — so if an agent is ever working against a dead directory, the
**startup ceremony** is what's incomplete. Root cause confirmed in `crawl.ps1:46`: `Invoke-Crawl`
**returns empty for a non-existent root, identically to an empty-but-valid root**. So from a projection
alone, "dead mount" and "nothing to do" are indistinguishable, and the startup banner only reaches
stderr (the operator), never the agent.

Fix — the walk is now **part of the handshake**, and its result is handed to the agent via MCP's
`initialize.instructions` field (clients inject this into the agent's context). In the `initialize`
handler:
- **Valid root** → `instructions` = `serving ingestion root '<root>' -- N document(s) discovered, M
  preprocessed. Begin with get_batch_summary or list_documents; ...`. The walk is done once and cached
  in `$script:Readiness`.
- **Empty-but-valid root** → `instructions` explicitly says `mounted but EMPTY -- 0 documents
  discovered ... do not assume there is simply no work` (disambiguates the crawler's ambiguous empty).
- **Dead root** → `instructions` = `error: <the fatal diagnostic>`; tool calls still isError (the
  belt-and-suspenders from the prior round remains).

Net effect: the agent receives validated bearings (resolved root + counts) at ceremony time, so the
dead/empty/wrong-mount cases are loud at the handshake instead of silently inferred. A `Write-Log
"discovery: N document(s), M preprocessed under <root>"` line also lands on stderr for the operator.

Verified (all via a single `initialize` frame): derived root → `7 document(s), 2 preprocessed`;
fresh empty dir as `-Root` → the EMPTY instructions; non-existent `-Root` → the error instructions.

## Batch robustness — fault isolation (follow-up; PARTIAL)

Question raised: pointing an agent at a whole folder of units. The ceremony/discovery already extends
to the batch (initialize reports `N document(s) discovered, M preprocessed` — the batch's bearings,
and the orchestrator loop is `get_batch_summary → dispatch → apply`, PROCEDURE.md). The gap is
**fault isolation**: the survey functions loop over units calling `Read-Chunks` (serving.ps1:31) /
`Get-LedgerStage` (jsonl.ps1:192), both of which throw a *terminating* error on a malformed JSON line.
One corrupt unit therefore aborts the entire loop → the orchestrator gets `isError` for the WHOLE
batch and goes blind to every healthy unit. **Proven**: a temp root with one healthy unit + one
corrupt `.chunks.jsonl` made `Get-BatchSummary` throw and return zero rows (healthy unit lost too).

DONE this round (mcp-server.ps1 only — no serving.ps1 touch, no merge risk):
- **Discovery guard** in `initialize`: the `Get-IngestionScan` walk is wrapped; a malformed unit no
  longer crashes the handshake — the server mounts and `instructions` honestly warns that a unit is
  unreadable and surveys may be affected until it is isolated.
- **Daemon backstop** around the whole request switch: no single request can crash the read loop; an
  uncaught handler exception becomes a `-32603` (if the request had an id) and the loop continues.
- Verified: a root with a corrupt `.ledger.jsonl` → server exit 0, `initialize` mounts with the
  degraded warning, `tools/list` still 21 tools; `list_documents` returns `isError` (not a crash).

DONE — per-unit fault isolation in the three survey functions (user chose "implement now"):
- **`Get-IngestionScan`** (serving.ps1, ~:48-56): the per-unit `Get-LedgerStage` call is wrapped; a
  corrupt ledger sets `stage='unreadable'` for that unit instead of aborting the scan.
- **`Get-BatchSummary`** (serving.ps1, ~:271-302): the whole per-unit body is wrapped; a malformed
  unit emits a flagged row `{ stage='unreadable', actionable=0, error=<msg>, ... }` and the loop
  continues.
- **`Invoke-Dispatch`** (serving.ps1, ~:320-343): each unit's `Get-LeasedIds` + `Read-Chunks` are
  materialized inside a try (so a corrupt line throws atomically, before any lease/add); a bad unit is
  added to a new **`skipped`** array on the result and skipped, never aborting the bundle.
- Verified end-to-end through the server on a batch of {healthy A, corrupt-chunks+corrupt-ledger B}:
  `list_documents` → both rows (B `stage=unreadable`); `get_batch_summary` → both (B flagged + error,
  A `actionable=1`); `dispatch` → `count=1 batch=[A] skipped=[B]`. Server exit 0, no wholesale isError.

## Merge coordination — `serving.ps1`

**Item 2 (scope) touched NO serving.ps1 functions** — the three survey functions already accept
`-Root`, so scope is implemented entirely in `mcp-server.ps1`.

**The batch follow-up DID edit three serving.ps1 functions** (fault isolation, per user's
"implement now"): `Get-IngestionScan`, `Get-BatchSummary`, `Invoke-Dispatch` — and only those three.

Reconciled with the concurrent codepoint follow-up (now finished — see
`.claude/codepoint-followup-report.md`): **no logical conflict.** That sweep's serving.ps1 edits are in
*different* functions (`Get-LeasedIds`/`Set-LeasedIds`, the proposal/edit/apply read-write paths,
`Add-ReviewRequest`) and it explicitly left the `.Length` byte-budget proxies inside `Get-BatchSummary`
and `Invoke-Dispatch` alone. I verified both sets of edits coexist in the current on-disk file (e.g.
its `ReadAllText` leases read at serving.ps1:66 sits beside my fault-isolation block at serving.ps1:49)
and the server loads + runs clean.

CAVEAT for anyone cross-referencing line numbers: my three insertions ADD lines, so every
serving.ps1 line number the codepoint report cites *below* my edits is now shifted down (e.g. its
leases read cited `:62` is now `:66`; its `:270`/`:308` proxies and `:410` append are further offset).
The function names in both reports are stable — trust those over the line numbers.

## Residual risks / recommendations

- `Invoke-ToolGuarded` treats any stream-1 `IDictionary` as *the* result and writes everything else to
  stderr. A membrane function that erroneously emits a second hashtable to the success stream would
  overwrite `$result` (last-wins); a non-dictionary stream-1 emission would be silently logged to
  stderr rather than returned. Today every `Invoke-Tool` path returns exactly one `@{content=...}`
  hashtable, so this is latent, not active — but stream-1 hygiene in the membrane libs is the real
  guarantee. Worth a lint/assertion if those libs grow.
- `[Console]::SetOut([Console]::Error)` is process-global; anything later in this process that *wants*
  real stdout must use `$script:Rpc`. That is now the documented contract (STANDARDS §7).
- Bad-root is **fail fast as an in-feed `isError`**, not a warn-and-serve and not a failed handshake.
  The connection mounts deliberately so the agent can SEE the message (via a tool result) and act on
  it; `initialize`/`tools/list` therefore succeed even with a bad root. The process never `exit`s on
  this path. If you ever want the opposite (hard-fail the handshake so the harness reports it to the
  operator instead), error `initialize` in the switch when `$script:Fatal` is set — but note that
  tends to hide the message from the agent's own feed.
- A non-existent *scope* (vs root) is NOT fatal — it resolves cleanly and yields an empty survey
  (a subtree with no docs is legitimate). Only a missing/!directory *root* is fatal. Revisit if
  callers want missing scopes to error too.
- A fault-isolated unit reports `stage='unreadable'` with `actionable=0`, so the orchestrator's
  "prefer most-actionable" heuristic (PROCEDURE.md) will not auto-select it — the agent must treat
  `unreadable` as an explicit escalation/repair signal, not skip it as "no work." Consider surfacing
  an `unreadable` count in the discovery `instructions` if silent skipping becomes a concern.
- `Get-BatchSummary`'s flagged row carries an extra `error` field that healthy rows lack (heterogeneous
  shape); fine for JSON/agent consumption. `Invoke-Dispatch` adds a top-level `skipped` array to its
  result — additive, not reflected in the tool's text description; update the `dispatch` description if
  you want it documented for the agent.

## Net files touched
`src/mcp-server.ps1` (UTF-8 channel, derived root + scope, fail-fast ceremony, discovery handshake,
daemon backstop), `src/serving.ps1` (per-unit fault isolation in `Get-IngestionScan` /
`Get-BatchSummary` / `Invoke-Dispatch` — coexists with the codepoint sweep, different functions),
`STANDARDS.md` (§7), `src/SETUP.md`, and this report — **4 source/doc files + report.**
