# Doccer roadmap — state of work and next steps

Living document — current truth, corrected in place. Decisions and the question ledger live in
[decisions.md](decisions.md); arguments in the runstamped briefs under [../briefs/](../briefs/);
evidence in [../discussions/](../discussions/).

## Where the work stands (2026-08-01)

Engine at `src/doccer` (`CodexSci.Doccer`), delivered via `brewery/doccer` recipes into
`packages/doccer` (HDBSCAN pattern). Contract harness: `tests/doccer/Program.cs`, **1263 checks
green** (`dotnet run --project brewery/doccer/Doccer.Tests.csproj`).

Implemented: identified immutable masters (raw-code-unit fingerprints; lazy fingerprint +
topology; fragment-local masters first-class); total scalar tiling with explicit
malformed-surrogate atoms; derived run views under explicit break-keys; overlap-preserving
columnar `SpanBatch` with interned string columns; master-bound `SpanSet` algebra; the 13 Allen
relations + reference join; deterministic laminar extraction with equal-geometry grouping and
crossing residue; suppression as `Admitted`/`Excluded` queries; scoped regex collection with
load-time validation and `WholeMaster`/`PerLine` execution scopes (PerLine = content extent,
terminator excluded); JSONL inventory loader with per-line provenance and a source-generated
JSON context (the future CLI wire format's seed); intrinsic + declarative validation and Tier-1
invariants.

Tranches 0 (correctness), 1 (decision canon + README), 2 (substrate completion) are **done**.
D15 landed post-Tranche-2. The founding run's brief carries the full history.

## Sequencing doctrine

Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex is
renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
consumers witness (D14). Per-topic containment: `planning/` = living truth; `briefs/` = one
small runstamped brief per chip iteration, guidance + that chip's report appended on completion;
`discussions/` = captured evidence.

## Queue

1. **Tranche 3 — closed contracts, one chip:** `TextSlice` + rebase (total bijective case, no
   OffsetMap dependency); `Group` + `Project` with basis stamping (D7); gap-cadence as the first
   named density measure (D8, mdnav template); priority-aware sorted lookup. Parked small
   questions ride along: columnar visibility (T2-1), selector-shape note (T2-4), positional-order
   compat note (T2-5).
2. **First CLI verbs (D13):** `doccer collect` (inventory + scope in, claims JSONL out) and a
   span-algebra verb — the macro-expansion witness as a working demo. user-repl anatomy:
   hand-rolled router, per-verb files with no hot path, wire format extending the loader's JSON
   context with span/claim payloads, run manifests where verbs produce artifacts.
3. **Harvest survey** (feeds and refines the verb list): sweep codex-scientiae and other sources
   — masks.ps1 operations, latex.ps1 span producers, membrane density/mask calculus, md-repair
   byte offsets, mdnav constructs — mapping each to the doccer primitive or verb it implies.
   Anticipate-the-consumer: capabilities resurface as domain-agnostic utilities first.
4. **Adapters (last):** masks.ps1 reborn as a thin PS veneer over the DLL; LaTeX consumers
   migrated as thin consumers, old behavior as witness. This work generates F1's honest
   edit-plan requirements as a byproduct.
5. **Proactive contract closures, at discretion (D14):** F-UCD data-provenance record →
   block/script facts; OffsetMap pressure-test (segment granularity, ambiguity encoding) if
   judged ripe; register columns only once the math-register design stabilizes.

Maturity-gated beyond that: F2 persisted batches → F4 indexed joins → F5 Tier-2/3 agreement
scoring → F6 markdown adapter and the mdnav succession (oracle harness on the doc-dive
fixtures; exceed mdnav precisely at its collapse points; conserve its instrument virtues).

## Open questions in play

- **Regex options union with `CultureInvariant` (T2-2)** — proposed, awaiting user confirmation;
  one-line change + record when confirmed.
- Full open list with context: see [decisions.md § Open](decisions.md).

## Standing context for future sessions

- Decision canon and this roadmap are the entry points; `src/doccer/README.md` is the in-repo
  contract surface and must stay in agreement.
- MarkPig legwork = historical evidence, never amended. mdnav relation = succession + spec
  witness, no cross-talk (its three strata: pseudo-parsing → supplanted eventually; instrument
  verbs → spec witness; doc-dive skill semantics → permanently above the engine).
- Doccer is expected to graduate cross-project; anything a graduated doccer would need must live
  in the C# surface, not PowerShell (D13 boundary test).
