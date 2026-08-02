# Doccer engine

This directory contains the domain-neutral C# engine (`CodexSci.Doccer`). It is intentionally
separate from Markdown, LaTeX, PDF, MCP, and workflow code: those systems may emit claims or
consume views, but none owns the interval substrate.

This README is the contract surface. The decision canon and roadmap live as current-truth
documents in [issues/doccer/planning/](../../issues/doccer/planning/)
([decisions.md](../../issues/doccer/planning/decisions.md) — records D1–D15, deferrals, question
ledger — and [roadmap.md](../../issues/doccer/planning/roadmap.md)); per-iteration chip briefs
with their reports sit in [issues/doccer/briefs/](../../issues/doccer/briefs/), and topic
evidence in [issues/doccer/discussions/](../../issues/doccer/discussions/). The MarkPig legwork
documents are historical evidence — consulted and cited, never amended.

## Governing doctrine

Claims carry evidence. Queries execute named policies and return results. Orchestration selects
policies and interprets results. The representation never pre-resolves: the engine implements
resolution mechanisms — suppression scoping, admission ordering, intra-geometry resolution,
coarser typing — as explicit, deterministic, parameterized operations, and executes whichever
policy the caller names; it never selects one. All judgment — which query, which policy, what
the result means, what happens next — belongs to orchestration.

## A library of primitives, not a pipeline

Every rung is usable without the rungs above it, and construction cost scales with what a job
touches. "Full doccer" — sweep → collect → validate → laminarize → tiered acceptance — is one
composition of these primitives, never the entry price:

```text
TextSpan / Allen relations        pure, zero dependencies
SpanSet                           + master identity
SpanBatch + scoped collectors     + typed claims
LaminarView / joins               + structure derivation
Validation tiers / inventories    + cross-examination
```

`TextMaster` computes its fingerprint and topology on first use; a small interval-algebra job
pays for the string and the spans it touches, nothing else. Masters scale down with the job: a
master is a coordinate space, not "the document" — minting one over an isolated math span or a
macro-expansion site is first-class. The identity floor governs mixing, not extent: spans bound
to one master refuse to validate against another, so coordinate-space confusion fails loudly
instead of corrupting silently. Lineage back to a parent (slice map + rebase) is opt-in.

The engine never normalizes Unicode. Text is analyzed exactly as given (identity is the default
form); normalization, when wanted, is an explicit producer step yielding a new master plus an
offset map, and compatibility forms (NFKC/NFKD) are treated as lossy transforms whose loss the
map records.

The domain-agnostic surface is the DLL (operation granularity, in-process composition) and the
CLI (task granularity — one-shot à la carte jobs, with domain knowledge arriving as data
inventories, never as flags or verbs). PowerShell helpers are site-local ergonomics and domain
adapters, deliberately thin: anything a graduated, cross-project doccer would have to carry
travels in the C# surface.

## Implemented contracts

- immutable, identified UTF-16 text masters; fingerprints hash the raw code units, so identity
  distinguishes everything the topology distinguishes (including which lone surrogate a text
  contains); fingerprint and topology are lazy and cached;
- a total Unicode-scalar tiling and line topology, including explicit malformed-surrogate atoms;
- derived run views over that tiling, emitted on demand under an explicit break-key: the atoms
  carry facts only, and any coarser grouping is a per-call view whose runs carry the key they
  broke on rather than a fixed type field;
- append-only collection followed by a frozen, columnar, overlap-preserving `SpanBatch` whose
  string columns are interned at freeze into per-row IDs plus a distinct-value table;
- normalized Boolean `SpanSet` projections bound to their originating master;
- suppression as named `Admitted`/`Excluded` queries over that algebra — never a claim property,
  so the same claim suppresses under one question and is the target of the next;
- all thirteen Allen interval relations and a reference relation join (semantics only — no
  performance contract);
- deterministic priority-based laminar extraction, equal-geometry grouping, and crossing
  residue (max-priority admission is a documented default, not a judgment; a future
  `ResolutionPolicy` is a query parameter, not a data-model change);
- declarative regex collection with load-time rule validation, an explicit execution scope
  (whole-master or per-line) that composes with the caller's region set by intersection, and
  region-scoped matching that cannot bridge exclusions;
- a JSONL pattern-inventory loader with per-line provenance on every failure, whose wire records
  are the loader's own and are declared once through a source-generated JSON context;
- intrinsic and declarative relation/impossibility validation, plus Tier-1 invariants —
  reconstruction, run-view tiling, line consistency, suppression laws, resolution determinism,
  and interning round-trip — in the contract harness.

## Deliberately absent

These families are absent because their contracts are not closed — that is the only gate on
engine work here. A consumer's arrival prioritizes and validates; it never authorizes, and its
absence is never by itself a reason to leave a gap. Where the brief names a "first consumer"
trigger, read it as a prioritization default for a contract whose remaining questions a real
consumer's shapes would answer best; any item may be pulled forward the moment its contract
closes honestly without one:

- `OffsetMap` — contract shape drafted (sum-type point results `Exact | Range | Unmapped`,
  segment-list storage, span projection under a named policy with explicit residuals); the
  remaining open questions are the ones a first real edit-plan or normalization job would settle,
  so that job is the prioritization default rather than a permission condition;
- the rest of the lift algebra — project and run-within have landed; group (with basis stamping),
  rebase, and materialize have not. Slice/rebase is the total bijective case and may land ahead
  of `OffsetMap`;
- named density measures (never a generic `Density` verb — each measure declares numerator,
  denominator, window basis, boundary policy, exclusions);
- suppression bitmaps (an acceleration of the suppression query, never a claim property);
- Unicode block and script properties as break-key facts: unlike the major-class fold, they would
  ship as versioned UCD data and need a data-provenance decision first;
- persisted batch formats; indexed join strategies;
- Tier-2 and Tier-3 acceptance — direct-versus-derived matching, tolerances, agreement scores.

This is a growing kernel, not a closed specification. Additions to the engine must pass the
admission test: deterministic; eliminates repeated mechanical work; preserves literal source
material; decides nothing about meaning. A feature failing the last test belongs in an adapter
or the consumer. Mask helpers belong above `SpanSet`; syntax recognition belongs in external
adapters or declarative inventories.

## Build boundaries

- `src/doccer`: engine source and public contracts.
- `brewery/doccer/Doccer.csproj`: reusable `CodexSci.Doccer.dll` recipe.
- `brewery/doccer/Doccer.Cli.csproj`: thin executable referencing that assembly.
- `brewery/doccer/Doccer.Tests.csproj`: dependency-free contract harness.
- `brewery/doccer/build-doccer.ps1`: verified refresh into `packages/doccer`.
- `artifacts/doccer`: compilation and test intermediates for all three projects, module-scoped by
  `Directory.Build.props` so nothing lands in a shared top-level `bin`/`obj`. Fully regenerable.
- `packages/doccer`: selectively refreshed reusable payload.

Run the contract harness with:

```powershell
dotnet run --project brewery/doccer/Doccer.Tests.csproj
```

Refresh the payload with:

```powershell
./brewery/doccer/build-doccer.ps1
```
