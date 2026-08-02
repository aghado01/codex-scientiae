# Doccer roadmap — what is ahead

Living document — current truth, corrected in place, holding only work **not yet done**.
Decisions and the question ledger live in [decisions.md](decisions.md); completed roadmap items
move to [ledger.md](ledger.md); arguments in the runstamped briefs under
[../briefs/](../briefs/); evidence in [../discussions/](../discussions/).

## Current state (2026-08-02)

Engine at `src/doccer` (`CodexSci.Doccer`), canon **D1–D24**, contract harness **1500 checks
green** (`dotnet run --project brewery/doccer/Doccer.Tests.csproj`). The capability inventory is
`src/doccer/README.md` — the in-repo contract surface; the completed-item record is the
[ledger](ledger.md). Tranches 0–3 are done: the substrate is complete, the lift vocabulary
lacks only materialize, the first D8 measure is landed. Delivery: `build-doccer.ps1` →
`packages/doccer` with `doccer.manifest.json` as provenance (`packages/` is untracked; refreshes
are local-only).

## Sequencing doctrine

Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex is
renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
consumers witness (D14). Per-topic containment: `planning/` = living truth (decisions, roadmap,
ledger); `briefs/` = one small runstamped brief per chip iteration, guidance + that chip's
report appended on completion; `discussions/` = captured evidence.

## Queue

1. **Harvest survey** (before any durable CLI contract): sweep codex-scientiae and other sources
   — masks.ps1 operations, latex.ps1 span producers, membrane density/mask calculus, md-repair
   byte offsets, mdnav constructs — mapping each to the doccer primitive or verb it implies.
   Anticipate-the-consumer: capabilities resurface as domain-agnostic utilities first. The
   survey's output freezes the verb list and task grain the CLI then commits to.
2. **First CLI verbs (D13):** `doccer collect` (inventory + scope in, claims JSONL out) and a
   span-algebra verb — the macro-expansion witness as a working demo. user-repl anatomy:
   hand-rolled router, per-verb files with no hot path, wire format extending the loader's JSON
   context with span/claim payloads, run manifests where verbs produce artifacts. The current
   `inspect`/`relate` commands are **disposable developer diagnostics** predating D13 (`relate`
   is operation-grain; `inspect` serializes an anonymous object outside the source-generated
   wire context) — reconcile or delete them when `collect` lands; they are not contracts.
3. **Adapters (last):** masks.ps1 reborn as a thin PS veneer over the DLL; LaTeX consumers
   migrated as thin consumers, old behavior as witness. This work generates F1's honest
   edit-plan requirements as a byproduct.
4. **Proactive contract closures, at discretion (D14):** F-UCD data-provenance record →
   block/script facts; OffsetMap pressure-test (segment granularity, ambiguity encoding) if
   judged ripe; register columns only once the math-register design stabilizes; materialize (the
   last lift operation); a callable runtime Tier-1 runner exposing the harness-law checks, if a
   consumer wants them at run time.

Maturity-gated beyond that: F2 persisted batches → F4 indexed joins → F5 Tier-2/3 agreement
scoring → F6 markdown adapter and the mdnav succession (oracle harness on the doc-dive
fixtures; exceed mdnav precisely at its collapse points; conserve its instrument virtues).

## Open questions in play

- See [decisions.md § Open](decisions.md): register/value/metadata columns (entangled with the
  math-register design), the meaning of "register" in sol's Tier-1 list, and the named
  per-line terminator-kind view (unscheduled). All Tranche-2 stragglers are closed — see the
  [ledger](ledger.md).

## Standing context for future sessions

- Decision canon, this roadmap, and the ledger are the entry points; `src/doccer/README.md` is
  the in-repo contract surface and must stay in agreement.
- MarkPig legwork = historical evidence, never amended. mdnav relation = succession + spec
  witness, no cross-talk (its three strata: pseudo-parsing → supplanted eventually; instrument
  verbs → spec witness; doc-dive skill semantics → permanently above the engine).
- Doccer is expected to graduate cross-project; anything a graduated doccer would need must live
  in the C# surface, not PowerShell (D13 boundary test).
