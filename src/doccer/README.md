# Doccer engine

This directory contains the domain-neutral C# engine (`CodexSci.Doccer`). It is intentionally
separate from Markdown, LaTeX, PDF, MCP, and workflow code: those systems may emit claims or
consume views, but none owns the interval substrate.

This README is the contract surface. The decision canon, roadmap, and completed-item ledger
live as current-truth documents in [issues/doccer/planning/](../../issues/doccer/planning/)
([decisions.md](../../issues/doccer/planning/decisions.md) — records D1–D30, the carrier/law
registry, deferrals, question
ledger — [roadmap.md](../../issues/doccer/planning/roadmap.md) — what is ahead — and
[ledger.md](../../issues/doccer/planning/ledger.md) — what has landed); per-iteration chip briefs
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
SpanBatch + ClaimSelection        + typed occurrence queries
Scoped collectors                 + declarative recognition
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
travels in the C# surface. One compat note for pre-graduation DLL consumers (T2-5):
`PatternRule`'s positional parameter order places `scope` before `priority` — bind both by name.

## Carrier boundary and algebra names

Doccer's expansion is many-sorted. The public vocabulary distinguishes valid master boundaries
(`P`), located extents including diagonal empties (`L`), nonempty Allen intervals (`I`),
identity-bearing claim occurrences (`C`), later canonical semantic facts (`F`), and later
output-to-source origin relations (`O`). These are not interchangeable views of one universal
span carrier:

- diagonal empty extents belong to located `L`, not to Allen `I`;
- Allen `Equal` is geometric identity on `I`, never occurrence identity on `C`;
- claim-pair identity is the ordinal diagonal on one exact frozen `SpanBatch`;
- origin identity will be the atom diagonal between compatible master bases.

The operation names therefore state their sort: `AllenCompose` (canonical qualitative upper
approximation), `ConcreteCompose` (exact composition on one carrier), located `Seq`,
`ComposePairs`, `Saturate`, policy-bearing `Select`, `ComposeOrigins`, and `Materialize`. There is
no unqualified public `Compose`. Names in this paragraph reserve the public contract vocabulary;
`AllenCompose` is implemented, while the later-tranche names remain reservations rather than
implementation claims. The canonical assurance owners and Lean reactivation triggers live in the
D25 registry in [decisions.md](../../issues/doccer/planning/decisions.md).

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
- immutable exact-batch `ClaimSelection`, the occurrence set over one frozen batch's ordinal
  universe: `None`/`All`/validated `Create` and `FromPredicate` construction, membership, count,
  emptiness, union/intersection/subtraction/relative complement, value equality/hash, and
  ascending-ordinal enumeration; compatible masters or equal rows do not make separate batches
  interchangeable; `Records(ClaimOrder)` is the explicit ordered record projection, while
  `Coverage()` explicitly forgets occurrence identity and normalizes selected geometry into a
  `SpanSet`; `FromPredicate` leaves D25's policy-bearing `Select` name reserved for K4;
- normalized Boolean `SpanSet` projections bound to their originating master;
- suppression as named `Admitted`/`Excluded` queries over that algebra, accepting an exact
  suppressor selection with predicate conveniences delegating through it — never a claim property,
  so the same claim suppresses under one question and is the target of the next;
- all thirteen Allen interval relations and a reference relation join (semantics only — no
  performance contract);
- immutable `AllenRelationSet`, the qualitative Boolean value over exactly those thirteen atoms:
  `None`/`All`/`Equal`/singletons, validated sequence construction, membership and subset, union,
  intersection, complement, pointwise converse, value equality/hash, and deterministic enum-order
  enumeration, plus explicitly named canonical `AllenCompose`; its 13-bit representation and
  literal 169-cell table are private and create no persistence or wire contract; the table is
  checked against an independently encoded endpoint-predicate oracle over all 3,375 triples of the
  fifteen nonempty six-boundary intervals (169 cells, 409 atomic triads), while the adjacent-gap
  witness prevents canonical composition from being mistaken for exact fixed-master composition;
- set-theoretic interval semantics: an empty span intersects nothing, and point location is its
  own named query (`TextSpan.Contains(int)`, `SortedSpanLookup.FindContaining`) rather than an
  empty-span special case — `TextTopology.Project`'s insertion-point convention is the one
  documented exception;
- opt-in slice lineage: `TextSlice` mints a deterministic fragment-local child master over a
  parent window (`{parent}#{start}-{end}` at the parent's revision, so recreated slices are
  compatible coordinate spaces) and rebases geometry back — child→parent is total and bijective
  (offsets, spans, sets, batches, plus weaving several fragments' batches into one parent-bound
  builder), parent→child is partial and loud (out-of-window geometry is refused, never clamped;
  scope sets by intersecting with the window first; no batch projection down — clipping claims
  needs a residual policy, which is `OffsetMap`'s business); claims rebase with coordinates
  changed and everything else untouched, and collection commutes with rebase — collecting on the
  fragment then rebasing equals collecting on the parent scoped to the window;
- basis-stamped group and project views: `Grouping.ByKey` groups claims under an explicit
  selector (`ClaimFacts` mirrors `AtomFacts`; plain delegates, tuple composition, caller
  comparers, null a legitimate key) with a deterministic contract — first-appearance group
  order, ascending ordinals, the key carried on the group; keyed and line grouping both accept a
  `ClaimSelection`, while batch conveniences delegate through `All`; `Projection.Project` gives
  claim-major line ranges and `Grouping.ByLine` the line-major transpose, total over the line grain
  (claimless lines present) under a named `LineMembership` policy — `EveryLineTouched` occupancy
  vs `StartLineOnly` attribution; every view stamps its basis (source batch, master, policy) so
  it answers "over what was I computed", and views hold ordinals, never claim copies;
- gap cadence, the first individually named density measure (transcribed from the mdnav
  profiler): start-to-start gap statistics — count, median (upper-median convention), mean, cv,
  span fraction — over a declared window basis that admits claims by start position, with
  an exact input selection and the window-admitted `Population` retained beside its ordered
  ordinals; predicate/batch conveniences delegate through that selection path; statistics are
  present whenever defined, and meaning thresholds stay in the consumer;
- named lookup orders: `FindIntersecting`/`FindContaining` answer in `ClaimOrder.Geometry` (the
  unchanged default) or `ClaimOrder.PriorityThenGeometry` (priority descending, then geometry,
  then ordinal — a total order) — resolution order is query policy, never a data-model change;
- deterministic priority-based laminar extraction, equal-geometry grouping, and crossing
  residue (max-priority admission is a documented default, not a judgment; a future
  `ResolutionPolicy` is a query parameter, not a data-model change);
- declarative regex collection with load-time rule validation (uncompilable and empty-capable
  patterns, capture groups checked against the compiled pattern's identity, undefined enum values
  rejected in the constructors), rule options that always union `CultureInvariant` at the
  `PatternRule` boundary — inventory rules and direct DLL callers are one collector contract,
  matching never inherits ambient culture, and options augment that baseline rather than replace
  it (`ECMAScript` is rejected as a different matching profile; the invariance is with respect
  to ambient culture, not runtime/Unicode-version case-table changes) — an explicit execution
  scope (whole-master or per-line) that
  composes with the caller's region set by intersection, and region-scoped matching that cannot
  bridge exclusions; collection is transactional — a sweep stages what it recognizes and commits
  only when every rule and region succeeds, so a mid-sweep failure leaves the caller's builder
  untouched;
- a JSONL pattern-inventory loader with per-line provenance on every failure, whose wire records
  are the loader's own and are declared once through a source-generated JSON context;
- intrinsic and declarative relation/impossibility validation whose durable relation filters carry
  `AllenRelationSet`, plus Tier-1 invariants —
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
- the rest of the lift algebra — project, group, run-within, and slice/rebase are in;
  materialize is not;
- further density measures beyond gap cadence (never a generic `Density` verb — each future
  measure arrives individually named, declaring numerator, denominator, window basis, boundary
  policy, exclusions);
- suppression bitmaps (an acceleration of the suppression query, never a claim property);
- Unicode block and script properties as break-key facts: unlike the major-class fold, they would
  ship as versioned UCD data and need a data-provenance decision first;
- persisted batch formats; indexed join strategies;
- Tier-2 and Tier-3 acceptance — direct-versus-derived matching, tolerances, agreement scores;
- exact `ClaimPairView`, `ComposePairs`, and pairing residue. `ClaimSelection` landed in K2a/D30;
  D29 freezes the remaining joint contract: reference pair composition requires actual middle ordinals, and its
  observed Allen image is contained in canonical `AllenCompose` without a converse/equality
  promise. D27 leaves the terminal raw-list `IntervalJoins.Join` unchanged until K2b replaces its
  semantics through `ClaimPairView`, rather than introducing a transitional filter-only overload.

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
- `brewery/doccer/build-doccer.ps1`: verified refresh into `packages/doccer` — contract harness,
  publish, a smoke test that loads the *delivered* assembly and runs the delivered CLI, then a
  `doccer.manifest.json` recording source commit, build timestamp, target framework/runtime, and
  the harness result. A package without its manifest is an unverified package.
- `artifacts/doccer`: compilation and test intermediates for all three projects, module-scoped by
  `Directory.Build.props` so nothing lands in a shared top-level `bin`/`obj`. Fully regenerable.
- `packages/doccer`: selectively refreshed reusable payload; its `doccer.manifest.json` states
  which source revision the payload represents.

Run the contract harness with:

```powershell
dotnet run --project brewery/doccer/Doccer.Tests.csproj
```

Refresh the payload with:

```powershell
./brewery/doccer/build-doccer.ps1
```
