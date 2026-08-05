# Brief — archaeology on the legacy JSONL substrate

Report written after the work, 2026-08-05. Feeds [LOGJ-101](../planning/roadmap.md) (disposition map)
and [LOGJ-103](../planning/roadmap.md) (error and result vocabulary). No code changed.

## Objective

Extract the invariants earned by `src/shared/jsonl.ps1` under production pressure, and check each one
against the unintegrated `jsonl-v2.ps1` / `jsonl-store-v2.ps1` drafts. Motivating claim: legacy code
and forward drafts have opposite evidential status. Legacy behavior survived contact with real
workflows and is therefore evidence; a draft with no production callers is a hypothesis. The contract
documents named in the [contract-closure brief](next-session-contract-closure-20260804.md) should be
written from the former and used to judge the latter.

## Method

Read `jsonl.ps1` in full (265 lines, 6 functions plus the `JsonlIndex` class), then
`tests/shared/encoding-invariants.Tests.ps1`, then compared marker-by-marker against the two drafts.
Every claim below cites a line or a measured count.

## Principal finding

**The invariant set is not undiscovered — most of it is already codified.**
`tests/shared/encoding-invariants.Tests.ps1` exists precisely to hold this taxonomy as executable
assertions, in three tiers: glyph gauntlet, chokepoint, and trap canaries that fire when PowerShell or
Newtonsoft behavior drifts. Its own header names the failure history it was built from — culture-
sensitive string ops no-oping on ligatures in the membrane era, PSObject pipeline-wrapping poisoning
serialization, nullable auto-unwrap making guards read always-false, serializer escaping dialects
forking bytes on math glyphs.

**That harness loads `src/shared/jsonl.ps1` and does not exercise the drafts.**
The dot-source is at [encoding-invariants.Tests.ps1:23](../../../tests/shared/encoding-invariants.Tests.ps1).
`jsonl-v2.Tests.ps1` has its own encoding coverage, so the draft is not untested — but it has never
been held to the harness that encodes the earned invariants. Pointing that harness at the draft is the
single cheapest source of conformance evidence available, and it should happen before any contract is
frozen.

## Invariant register

Status legend: **kept** — draft preserves it; **dropped** — draft does not implement it;
**moot** — the draft's design removes the precondition; **improved** — draft supersedes it.

| # | Invariant | Where earned | Draft status |
|---|---|---|---|
| I1 | UTF-8 no BOM on every read and write; encoding is constructed explicitly, never defaulted | 7 explicit `UTF8Encoding::new($false)` sites | kept (`$script:JsonlUtf8`) |
| I2 | The Newtonsoft fast path and `ConvertTo-Json` must emit **identical bytes**; `StringEscapeHandling.Default`, never `EscapeHtml` — EscapeHtml was tried first and diverged on math glyphs, byte parity verified on the 84p bench | [jsonl.ps1:107-111](../../../src/shared/jsonl.ps1) | moot — draft has **zero** Newtonsoft references |
| I3 | Pipeline-emitted values are PSObject-wrapped and must never be stored into records; Newtonsoft reflects the wrapper into a self-referencing loop. Safe forms: if-expressions, `@()` over collections, hashtable members | header lines 22-23; canaries at test:143-148 | moot in codec — hazard leaves with the fast path |
| I4 | A serialization failure degrades **that record** to the cmdlet path rather than failing the stage, incrementing a counter, retaining the last error, and warning with stage + output + count + cause | [jsonl.ps1:129-134](../../../src/shared/jsonl.ps1), [:143-150](../../../src/shared/jsonl.ps1) | dropped — see conformance note below |
| I5 | Line-start offsets accumulate **during** the write; a per-byte rescan cost 17.5s on a 33MB lane. External indexing hops newline-to-newline via `[Array]::IndexOf` | [jsonl.ps1:118-119](../../../src/shared/jsonl.ps1), [:44-46](../../../src/shared/jsonl.ps1) | changed — index is a separate operation |
| I6 | The index is **co-emitted** with content from offsets the writer already holds, not derived by a later pass | [jsonl.ps1:152-153](../../../src/shared/jsonl.ps1) | dropped — `New-JsonlIndex` is separate |
| I7 | A `.sig` stamp records source SHA-256 + stage + record count so a stage's output is checkable **stale against its input** — explicitly "the source fingerprint the original `.jidx` never carried" | [jsonl.ps1:11-13](../../../src/shared/jsonl.ps1), [:155-165](../../../src/shared/jsonl.ps1) | dropped — **zero** `.sig` references in either draft |
| I8 | Writing the same records twice yields byte-identical `.jsonl` **and** `.jidx` | test:113 | kept (needs re-verification under the harness) |
| I9 | SMP, ligature, and U+FFFD codepoints round-trip byte-exact through write and indexed seek | test:71-80 | kept (needs re-verification under the harness) |
| I10 | JSOI index format: magic + int32 version + int32 count + int64[] offsets, little-endian; magic and version validated on load | [jsonl.ps1:32-75](../../../src/shared/jsonl.ps1) | superseded by D14 naming; format continuity unverified |
| I11 | The durable artifact is ground truth; a convenience index must never fail the write | [jsonl.ps1:167-180](../../../src/shared/jsonl.ps1) | correctly dropped — application concern under D17 |
| I12 | Concurrency is solved by **partitioning**, not locking: one ledger file per document, so fan-out never contends | [jsonl.ps1:241-242](../../../src/shared/jsonl.ps1) | n/a — draft chose leases (D10, provisional) |
| I13 | The ledger is append-only; last line is current position, whole file is history. Terse milestones, not a verbose log | [jsonl.ps1:239-243](../../../src/shared/jsonl.ps1) | n/a — application layer under D17; already canon as D26 |
| I14 | After seeking the underlying stream, `DiscardBufferedData()` before reading, or the reader returns stale buffered bytes | [jsonl.ps1:197-199](../../../src/shared/jsonl.ps1) | moot — draft reads bytes directly rather than via `StreamReader` + seek |

### Defects the archaeology also turned up

- **CRLF at the source.** `$nlBytes` derives from `$sw.NewLine`, which is platform-dependent, so
  Windows writes CRLF ([jsonl.ps1:125](../../../src/shared/jsonl.ps1)). Offsets stay self-consistent
  because they are computed from the same value — this is **not** index corruption, it is a canonical-
  format violation of D9. Same family as the `AppendLine` defect already named in the roadmap baseline.
  **The draft fixes this** — it sets ``$sw.NewLine = "`n"`` explicitly and rejects any serialized record
  containing a literal CR or LF.
- **Sidecars are not atomic with content.** Content is written and disposed, then `.jidx`, then `.sig`,
  then inventory. A crash between any two leaves stale sidecars. This is exactly D15's territory, and
  I6 is why the legacy mostly avoids it: co-emission means the index cannot describe content that was
  never written.
- **Inventory read-modify-write has no lock** and is swallowed by a bare `catch { }`
  ([jsonl.ps1:170-180](../../../src/shared/jsonl.ps1)). Concurrent stages writing different outputs to
  one scratch directory race. Note this contradicts I12's partitioning discipline within the same file.
- **Format drift**: `Get-Inventory` reads `inventory.json` — whole-file JSON, singular — while the
  manifest decisions relocated to latex-ingest D13 speak of `inventory.jsonl`.
- **Silent depth truncation.** `ConvertTo-Json -Depth 12` (stage) and `-Depth 6` (ledger) truncate past
  the limit with only a warning. The legacy does not trap it.

## Conformance deltas against the drafts

### Where the draft is better, and the contract should say so

1. **Explicit LF.** ``$sw.NewLine = "`n"`` at two sites, plus an outright rejection of records containing
   literal CR or LF. Fixes the defect behind all 129 CRLF artifact files.
2. **Strict encodability gate.** `ConvertTo-JsonlLine` proves every line is UTF-8 encodable via
   `GetByteCount` before it is written — D8's one-gate rule, implemented.
3. **`-WarningAction Stop` on `ConvertTo-Json`**, which converts silent depth truncation into a failure.
   A genuine invariant the legacy lacks.
4. **Incomplete-tail detection.** Several sites check whether the final byte is `0x0A`; the legacy has
   no concept of a torn tail.

### Where the draft regressed, and the contract must decide deliberately

1. **`.sig` provenance is gone (I7).** Zero references in either draft. The legacy header records this
   as a deliberate *correction* of jso-jackson — the fingerprint the original index never carried — and
   the draft has silently un-corrected it. Stage-output-stale-against-input is no longer checkable.
   This is the sharpest single regression found.
2. **Non-fatal attributed degradation is gone (I4).** Measured failure posture:

   | file | `throw` | `Write-Error` | `Write-Warning` |
   |---|---|---|---|
   | `jsonl-v2.ps1` | 58 | 0 | 2 |
   | `jsonl-store-v2.ps1` | 34 | 0 | 0 |
   | `log.ps1` | 0 | 0 | 0 |

   92 throws and roughly 15 structured-outcome fields across the two drafts. **The legacy already
   implemented D5's posture** — degrade the record, keep the stage, count it, retain the cause, warn
   loudly — before D5 was written down. LOGJ-103's three-way disposition therefore is not an open
   design question in full: part of it was adjudicated under production pressure and the draft
   regressed against it. Note the logger draft fails the same decision from the opposite side, with no
   signalling channel at all.
3. **Index co-emission became index derivation (I5, I6).** D15's committed-content/failed-refresh case
   exists *because* the draft separated emission from derivation. That may still be the right call —
   the draft supports indexing files it did not write — but it is a trade, and it should be recorded as
   one rather than inherited by omission.
4. **The fast path is gone (I2), and its reason went with it.** The draft serializes exclusively through
   `ConvertTo-Json`, which returns the ~160k cmdlet invocations per document the fast path existed to
   avoid. Dropping it also removes the PSObject poison hazard, so the trade may well be correct. The
   danger is that the *reason* for `StringEscapeHandling.Default` now lives only in a legacy comment and
   a trap canary: nothing stops a future optimizer from reintroducing a fast path with EscapeHtml and
   forking bytes on math glyphs again.

## Recommendations

1. **Run `encoding-invariants.Tests.ps1` against the draft** before freezing any contract. Tests that
   do not apply (serializer parity, fallback telemetry) mark exactly where the draft made a trade; tests
   that fail mark regressions. This is a few hours of work and it produces the conformance table the
   contract needs.
2. **Lift I1, I7, I8, I9, I10, I14 into `jsonl-contract.md` as contract text**, each carrying its
   evidence. They are earned, and several are invisible from the draft alone.
3. **Settle LOGJ-103 with I4 on the table.** The question is not "what should the error model be" in the
   abstract; it is "why did the replacement drop a working non-fatal degradation channel, and does D5
   permit that." The answer determines whether D15's partial-success outcome is expressible at all.
4. **Record the four trades in §Conformance as decisions**, not as silent differences: fast path
   removed, index derivation separated, provenance stamp dropped, inventory self-registration moved to
   the application layer. Each is defensible; none is currently written down.
5. **Add a decision assigning forward drafts an evidential status.** D20 grants legacy code the status
   *evidence, not automatic boundaries*. D18 quarantines the draft's filename and forbids importing both
   generations; D19 isolates compatibility. Nothing states what authority a `-v2` draft carries over a
   contract. With no rule, 90KB of concrete working code sits beside three unwritten documents and wins
   by default. Proposed shape: legacy supplies invariants, external mature tools supply capabilities,
   forward drafts supply feasibility evidence and are judged against the frozen contract.

## Disposition map contribution (LOGJ-101)

| Surface | Disposition |
|---|---|
| `JsonlIndex` class, `Write-JsonlStage` serializer/offset core | **primitive to extract** — densest earned-invariant surface in the file |
| `.sig` stamping | **primitive to extract** — currently absent from the replacement |
| `Read-JsonlRecord`, `Get-JsonlSchema` | **primitive to extract** — schema probe is a useful discovery tool with no draft equivalent |
| Inventory self-registration inside the write chokepoint | **domain policy to retain** at the application layer (D17); do not reproduce in the substrate |
| `Add-LedgerEntry`, `Get-LedgerStage` | **domain policy to retain** — 6 lines, path derived by regex off `.chunks.jsonl`; the *design* (per-document partitioning, append-only, last-line-is-position) is worth keeping, the implementation is not |
| `Get-Inventory` | **retire** — reads a singular `inventory.json` that has drifted from the current inventory model |

Live caller confirmed: `src/bibliotecha/publish.ps1:216` consumes `Add-LedgerEntry`. No other production
consumer of this file was found.
