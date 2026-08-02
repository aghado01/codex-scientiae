# Doccer decision canon

Living document — states what is decided **now**, corrected in place as decisions evolve (the
judgment rule: amendments preserve decisions; this file need not preserve every sentence). The
full arguments live in the runstamped briefs under [../briefs/](../briefs/) — the
[founding run](../briefs/fable-doccer-dev-brief-20260801_222912.md) minted D1–D14, the per-chip
briefs carry the later contracts with their reports — and the evidence in
[../discussions/](../discussions/). Completed roadmap items are recorded in
[ledger.md](ledger.md). The MarkPig legwork is historical evidence — cited, never amended.
`src/doccer/README.md` is the in-repo contract surface and must agree with this file.

## Doctrine

- **Claims carry evidence. Queries execute named policies and return results. Orchestration
  selects policies and interprets results.** The representation never pre-resolves; the engine
  hosts resolution mechanisms as explicit, deterministic, parameterized operations and never
  selects among them. Some policy flows *into* queries (scoped matching and laminar admission
  change what is computed); the rest operates on results in orchestration.
- **Contracts gate; consumers witness (D14).** Contract closure is the only gate on engine work.
  A contract closable from first principles is closed by design — anticipate the consumer.
  "First consumer" triggers are prioritization defaults, never permission. Implementing against
  an open contract is the one forbidden move (D10).
- **Engine boundary — the admission test (D10):** deterministic; eliminates repeated mechanical
  work; preserves literal source material; decides nothing about meaning. Failing the last test
  puts a feature in an adapter or the consumer.

## Decisions

| # | decision | status |
|---|---|---|
| D1 | Fingerprint hashes raw UTF-16 code units — identity distinguishes everything the topology distinguishes (incl. which lone surrogate) | implemented |
| D2 | Laminar equal-geometry groups admitted by max priority as the *documented default*; a future `ResolutionPolicy` is a query parameter, not a data-model change; determinism, not optimality, is the contract | implemented (default) |
| D3 | Suppression is a query policy, never a claim property (`is_mask` dead); `Suppression.Admitted`/`Excluded` compositions; the legwork bitmap = acceleration of that query | implemented |
| D4 | Atom tiling carries **facts only** (span, scalar, category, validity, line); coarser typing and run emission are derived views under an explicit break-key; a run carries the key it broke on, nothing else; UCD version = recorded metadata; the 64 KB LUT = implementation strategy, out of contract | implemented (`EmitRuns` + `AtomFacts`; block/script pending F-UCD) |
| D5 | Pattern priority = default evidence recorded on the claim; resolution order = query policy | implemented |
| D6 | No syntactic obligations on patterns; `SpanLevel` = claim metadata only; execution scope (`WholeMaster`/`PerLine`/region set) = explicit collector parameter; rule scope ∩ caller scope | implemented |
| D7 | Five lift operations named separately — project, group, run-within, rebase, materialize; all cross-grain arithmetic in master coordinates, every derived measure basis-stamped; slice→parent rebase is total+bijective and does not wait for OffsetMap | project (span + batch), group, run-within, slice/rebase implemented (D19, D21); materialize pending |
| D8 | Never a generic `Density` verb — individually named measures declaring numerator, denominator, window basis, boundary policy, exclusions; gap-cadence first (mdnav template) | gap cadence implemented (D23); doctrine standing for every future measure |
| D9 | Contract minutiae: `Project` empty-span convention documented; load-time rule validation names the rule (empty-match probe; capture-group identity checked against the compiled pattern; undefined `SpanLevel`/`ExecutionScope` casts rejected at construction and at `builder.Add`); `Join` carries a no-performance-contract note | implemented |
| D10 | Engine additions gated by the admission test (see Doctrine) | standing |
| D11 | The engine never normalizes Unicode: identity default; normalization = explicit producer `original → (map, normalizedMaster)`; NFKC/NFKD documented lossy; ASCII transliteration stays out of the substrate; grapheme clusters = derived view over scalar atoms if ever wanted | standing (code conforms) |
| D12 | Library of primitives, never a pipeline: every ladder rung usable without rungs above; construction cost scales with what is touched (lazy fingerprint/topology); **masters scale down** — a `TextMaster` is a coordinate space, not "the document", fragment-local masters first-class; identity floor governs *mixing not extent*; lineage (slice map/rebase) opt-in; evidence/cross-examination attaches to compositions that ask | implemented (lazy substrate landed) |
| D13 | À la carte tools surface doccer-native: DLL = operation grain, CLI = task grain with domain knowledge as **data** (inventories/scope files, never flags); CLI verbs = named **domain-agnostic capabilities** one reaches for (collect, span algebra, pair, …), never domain tasks — the domain-specific things-to-capture live in **per-domain pattern stores**; PS layer = site-local veneer + adapters only; two boundary tests — graduation ("lost on graduation ⇒ wrong layer") and the **rewrite test** (a PS site is finished when it collapses to capability calls + store entries + genuinely-domain policy; refusal to collapse = missing doccer surface, a census signal, or permanent adapter policy); minimal JSONL wire format precedes and feeds F2. Engineering precedent: ThermoMapper `user-repl` (no hot path; hand-rolled router; wire format declared once in a source-generated JSON context with CLI-owned records; presets/manifests as data; rehydrate-not-recompute) | standing; CLI verbs not yet built |
| D14 | Gating doctrine (see Doctrine) | standing |
| D15 | `PerLine` matches the line's **content extent** — terminator excluded (CRLF/LF claim-text determinism; `.` matches `\r`); terminator codepoints remain first-class atoms (exclusion is scope, not erasure); per-line terminator-kind view = named future derived fact | implemented |
| D16 | Collection is **transactional**: `CollectInto` stages every recognized claim and commits only after the whole sweep succeeds, so failures load-time validation cannot see (context-dependent zero-width match, timeout, non-scalar-boundary match) leave the caller's builder untouched | implemented |
| D17 | Interval semantics are **set-theoretic**: an empty span intersects nothing; point location is its own named query (`TextSpan.Contains(int)`, `SortedSpanLookup.FindContaining`), never an empty-span special case; `Project`'s insertion-point convention (D9) is the one documented exception | implemented |
| D18 | `CultureInvariant` is an **engine invariant**, unioned at the engine boundary (`PatternRule` constructor), not merely in the JSONL loader — inventory rules and direct DLL callers share one reproducible collector contract; supplied options **augment** the baseline and never replace execution policy, so `ECMAScript` is rejected as a different matching profile (net10 itself would permit `ECMAScript\|CultureInvariant` — rejection is the contract; a case-sensitive-only ECMAScript carve-out is possible if a concrete need ever appears); the guarantee is independence from **ambient culture**, not from runtime/Unicode-version case-table changes (closes T2-2; boundary refinement and ECMAScript posture are the user's) | implemented |
| D19 | Slice/rebase contract (Tranche 3a): `TextSlice` = the opt-in lineage object; child identity **derived and deterministic** (`{parent}#{start}-{end}` at the parent's revision — a GUID would make slicing nondeterministic, and determinism buys interop: recreated slices are compatible masters); child→parent rebase **total and bijective** over offsets, spans, sets, batches, plus `ToParentInto` weaving several fragments into one parent-bound builder (the macro-expansion witness); parent→child **partial and loud** over offsets, spans, sets — out-of-window geometry refused, never clamped (recipe: intersect with the window first); **no parent→child batch projection** (clipping claims needs a residual policy = F1's business); composition = chained `ToParent`/`ToChild`, no combinator until witnessed; law: collection commutes with rebase for whole-master **and** per-line scopes, because both routes match identical sliced region strings | implemented |
| D20 | Columnar surface visibility (T2-1): interned string columns (`Kinds`/`Sources`/`RuleIds`) public; numeric columns (`Starts`/`Ends`/`Levels`/`Priorities`) internal, consumed through `SpanRecord` views — verified sufficient for batch rebase (in-assembly access); widen only when a real columnar consumer witnesses the need (F2 will revisit) | implemented (as-built, now contractual) |
| D21 | Group/project contract (Tranche 3b): both are **basis-stamped derived views** — in-process, the stamp is typed references and named policies on the view object itself (source batch, master through it, key or membership policy), so a view always answers "over what was I computed"; serialized stamps = F2. `Grouping.ByKey` = the batch sibling of `EmitRuns`' break-key discipline (first-appearance group order per the interning precedent, ascending ordinals, key carried on the group, caller comparers honored, null a legitimate key, no topology forced); `Projection.Project` = claim-major line ranges; `Grouping.ByLine` = line-major, **total over the line grain** (claimless and empty final lines present — the grain is a partition, not a claim summary; extents are partition extents, deliberately not D15 content extents), under a **named `LineMembership` policy** — `EveryLineTouched` (occupancy) vs `StartLineOnly` (attribution, each claim exactly once at its start line); the transpose law ties the two directions; views hold ordinals into the frozen batch, never claim copies. Boundary behavior as declared policy starts here — the D8 discipline 3c inherits | implemented |
| D22 | Fact selectors stay **plain typed delegates** (T2-4): `Func<SpanRecord, TKey>` beside `Func<TextAtom, TKey>`, each with a discoverable static vocabulary (`ClaimFacts` mirroring `AtomFacts`, tuple selectors for composition); no promotion to a binding record — two parallel vocabularies sharing one shape settle the question by precedent | implemented |
| D23 | Gap cadence (Tranche 3c) — the first D8 measure, transcribed from the mdnav profiler: gaps between successive claim **starts** (the name pins the semantics — an end-to-start interstice measure would be a separate named measure, never a parameter); facts = gap count, median gap (upper-median template convention, integer domain), mean gap, cv (0 when mean 0), span fraction; **window basis** declared (default master extent; admits a claim iff its start lies within; length divides the span fraction; `AddressUnit` rides the stamp); **exclusions** = caller predicate, recorded as measured ordinals in deterministic start order — evidence on the result, not a lost delegate; statistics present whenever defined (≥2 members), absent otherwise; meaning thresholds (mdnav's ≥4 occurrences, cv<0.6) stay in consumers (D10) | implemented |
| D24 | Lookup order is **query policy** (D2/D5 at the query surface): `ClaimOrder` names the answer order — `Geometry` (stable start order, the default, unchanged) or `PriorityThenGeometry` (priority descending per the D2 max-priority posture, then geometry, then ordinal — a total order, so determinism needs no stability argument); optional parameter on `FindIntersecting`/`FindContaining`; undefined casts refused; pure per-query ordering, acceleration = F4 | implemented |

## Deferred families (F) — trigger = prioritization default, per D14

| # | family | state | default trigger |
|---|---|---|---|
| F1 | `OffsetMap` | contract shape **drafted**: point results `Exact \| Range \| Unmapped`; ICU-Edits-style segment list (`Identity/Expand/Contract/Delete/Insert`); span projection under a named policy (`Clip/Expand/Drop/Residual/Refuse`, **Residual** default posture); exactness laws on preserved coordinates; maps compose; acceptance edge-cases in [grok-offsetmap-unicode](../discussions/grok-offsetmap-unicode.md) | first edit-plan or normalization job |
| F2 | Persisted batch format | interning tables landed as groundwork; mdnav sidecar = identity/staleness design donor; subsumes the CLI wire format, not duplicates it | first cross-process consumer |
| F3 | Byte addressing | encoding map (bytes↔code units) is a distinct object from the Unicode-form map; reconcile with OffsetMap, never bolt onto `TextMaster` | byte-exact reproduction/provenance need; a successor-design decision |
| F4 | Indexed joins / lookup acceleration | semantics are the contract; pure acceleration | Tier-2 tests freeze semantics |
| F5 | Tier-2/3 acceptance, agreement scoring | needs an honest pair of independent producers (ATX vs setext natural) | markdown inventory exists |
| F6 | Markdown adapter + mdnav succession | oracle harness vs mdnav on doc-dive fixtures; exceed at the collapse points (quote-nested fences, setext/ATX disagreement, multi-line HTML, H1×breaks join); conserve instrument virtues; doc-dive skill retargets unchanged | Phase-2 exit + markdown inventory |
| F-UCD | Unicode block/script facts | decision-gated: needs a UCD data-provenance record (pinned version, tables as versioned data, lazily computed); then lands as ordinary `AtomFacts` selectors | schedulable any time (D14) |

## Question ledger

| # | question | resolution |
|---|---|---|
| Q1 | equal-geometry priority | D2 |
| Q2 | atom taxonomy / run-key incoherence | D4 |
| Q3 | `is_mask` intrinsic vs query | D3 |
| Q4 | global vs query priority | D5 |
| Q5 | loader syntactic rules | D6 |
| Q6 | "lift" conflation | D7 |
| Q7 | density ambiguity | D8 |
| Q8 | 64 KB LUT status | D4 |
| Q9 | coverage invariant strength | cursor-based check (pre-existing) |
| Q10 | fingerprint vs lone surrogates | D1 |
| Q11 | OffsetMap honest form | F1 (shape drafted) |
| Q12 | persisted batch format | F2 |
| Q13 | byte addressing | F3 |
| Q14 | indexed join strategy | F4 |
| Q15 | agreement-score vocabulary | F5 |
| Q16 | what supplants mdnav, when | F6 |
| Q17 | normalization silent vs explicit | D11 |
| Q18 | monolith risk / entry granularity | D12 |
| Q19 | where à la carte tools surface | D13 |
| Q20 | does engine work wait for consumers | D14 |
| Q21 | when codex-scientiae adapters land | roadmap — CLI + primitives first, adapters last |
| Q22 | PerLine terminator in or out | D15 |
| Q23 | regex options vs ambient culture (T2-2) | D18 |

## Open (no decision record yet)

- **Register/value/metadata columns:** contracts open; entangled with the math-register design —
  sequence deliberately, don't close from the doccer side alone.
- **"Register" in sol's Tier-1 list:** meaning itself unresolved.
- **Per-line terminator-kind view** (D15): named, unscheduled.
