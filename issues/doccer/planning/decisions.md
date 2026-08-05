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
| D25 | Many-sorted carrier boundary and assurance registry (K0): valid boundaries, located extents, nonempty Allen intervals, claim occurrences, later canonical facts, and later cross-master origins remain distinct carriers; the public operation vocabulary names each composition by its sort; every load-bearing law names its assurance owner and a concrete Lean reactivation trigger where proof is deferred | recorded; K0 closed |
| D26 | `AllenRelationSet` (K1a) is the immutable Boolean value over exactly thirteen Allen atoms: private 13-bit representation; explicit stable enum ordinals; `None`/`All`/`Equal`/singleton and sequence construction; count, emptiness, membership, subset, union, intersection, complement, converse, value equality/hash, and deterministic enum-order enumeration; duplicate atoms collapse and undefined casts fail loudly; no raw mask, wire form, or composition contract | implemented; K1a closed |
| D27 | K1b–K4 sequencing boundary: K1b closes the qualitative Allen semantics and migrates durable validation filters but does not retrofit the terminal `IntervalJoins.Join`; K2a/K2b/K2c are jointly specified and landed as consecutive buildable chips, with pure selection membership distinct from ordered query views, `ClaimPairView` becoming the semantic replacement for the terminal join, and pairing witnessing the tranche; K3/K4a are co-designed, with geometry-only `LocatedRelation` separate from the identity-bearing candidate graph; every tranche carries a bounded witness and K8 is final integration | recorded; workplan resequenced |
| D28 | Canonical Allen composition (K1b): `AllenRelationSet.AllenCompose` is the additive lift of a literal 169-cell table in frozen atom order; a separately encoded endpoint-predicate oracle exhausts all 3,375 triples of the 15 nonempty \(D_6\) intervals and recovers all 169 cells/409 atomic triads; JEPD, identity, annihilation, distributivity, converse reversal, and associativity are executable laws; canonical composition is an upper approximation rather than exact fixed-master composition, retained by the adjacent-gap counterexample; durable validation filters now carry `AllenRelationSet`, while `IntervalJoins.Join` remains unchanged for K2b | implemented; K1 closed |

## Qualitative Allen closure (D28)

K1 closes with one public composition name and one deliberately asymmetric assurance boundary:

- `AllenCompose` is canonical qualitative composition over unions of the thirteen Allen atoms. Its
  13×13 atomic table is literal row-major mask data, indexed by the explicit D26 enum ordinals;
  no runtime table generation, raw-mask API, persistence shape, or generic-calculus descriptor is
  introduced.
- The harness does not reuse that representation. It defines the thirteen endpoint predicates
  independently, proves them jointly exhaustive and pairwise disjoint over all ordered pairs of
  the fifteen nonempty intervals on six boundaries, and checks `Relate` against the unique result.
  Exhausting all \(15^3=3375\) interval triples reconstructs the 169 cells and 409 atomic triads.
- Composition has `Equal` as two-sided identity and `None` as two-sided annihilator, distributes
  over unions, reverses under converse, and is associative. The lifted laws sweep all 8192 relation
  unions under deterministic operand permutations; the associativity kernel checks all
  \(13^3=2197\) atomic triples.
- Canonical composition does not promise an intermediary inside one finite master. Although
  `Before AllenCompose Before` is `Before`, no nonempty integer interval lies strictly between
  \([0,1)\) and \([2,3)\). Exact claim-pair composition remains K2b work.
- `RelationRequirement.AcceptedRelations` and `ForbiddenRelation.ForbiddenRelations` now carry the
  closed `AllenRelationSet` value and refuse `None`. D27's no-half-measure boundary holds:
  `IntervalJoins.Join` receives no filter-only transition before `ClaimPairView` replaces its
  terminal semantics.

## Sequencing boundary (D27)

D27 distinguishes **completion priority** from **type dependency**. K1b was the first completion
priority and is now closed by D28. K2 does not depend on the canonical composition table: it
depends on K1's closed `AllenRelationSet` as an exact-join filter.

The resulting boundaries are:

1. **K1b closes semantics, not a transitional join API.** It owns `AllenCompose`, the independently
   encoded table, the separate \(D_6\) oracle, JEPD/classifier closure, the adjacent-gap
   counterexample, and migration of durable validation filters. `IntervalJoins.Join` is not given a
   one-chip relation-set retrofit when K2b will replace its terminal result shape.
2. **K2 is specified vertically before its chips land.** K2a, K2b, and K2c remain separate,
   buildable implementation chips, but their shared bases, projections, residues, and identities
   are frozen together and they land without an unrelated tranche between them.
3. **Selection membership is not result order.** `ClaimSelection` is a pure set over ordinals on
   one exact frozen batch and canonically enumerates ascending ordinals. Geometry- or
   priority-ordered records are explicit query projections under `ClaimOrder`; order is not part
   of selection equality. Existing ordered lookups are not mechanically changed to return an
   unordered set.
4. **K2a includes the stable population integrations.** Predicate selection, `Coverage()`,
   grouping, cadence, and suppression accept or produce `ClaimSelection` where their semantics are
   set-valued. Predicate conveniences may delegate to that carrier rather than remain independent
   implementations.
5. **K2b owns the join transition.** `ClaimPairView` supplies exact basis-stamped relation rows,
   projections, semijoins, converse, and `ComposePairs`. `IntervalJoins.Join` is retired or retained
   only as a compatibility projection backed by this carrier, never as a parallel semantic path.
   Middle-witness grouping remains transparent; packed or bracket-independent support waits for
   K5's support identity.
6. **Pairing witnesses K2.** `PairingResult.MatchEdges` uses `ClaimPairView`; unary fault
   populations use `ClaimSelection`, while mismatches retain explicit pair evidence. Pairing does
   not invent repair, containment, or parenthood.
7. **K3 and K4a are co-designed.** `LocatedRelation` is the pure geometry set over \(L_M\): it
   carries no claim labels and collapses duplicate geometry. `CandidateRegionGraph` owns claim
   ordinals and parallel identity-bearing edges and exposes an explicit identity-forgetting
   projection to located geometry. They may land in separate commits, but one tranche must prevent
   duplicated reachability semantics or a hybrid carrier.
8. **Witnesses move left.** Pairing witnesses K2; ambiguous token and budgeted chunk graphs witness
   K3/K4; bounded materialization witnesses K6/K7. K8 remains the final cross-carrier integration
   demonstration rather than the first time earlier contracts meet a consumer shape.

## Carrier and law registry (D25)

This section is the canonical K0 registry. A row may reserve a contract before its implementation
tranche, but its status and assurance gate must make that distinction explicit.

### Carriers

For one immutable master `M`, and an output master `N` where applicable:

| Symbol | Carrier | Identity and empty posture |
|---|---|---|
| \(P_M\) | valid boundaries recognized by `M` | points only; not interval or claim identities |
| \(L_M\) | located extents \((i,j)\) over \(P_M\), with \(i\le j\) | includes the diagonal empty extents used by located `Seq` |
| \(I_M\) | nonempty Allen intervals \((i,j)\), with \(i<j\) | `AllenRelation.Equal` is the geometric diagonal |
| \(C_M\) | identity-bearing claim occurrences | in-process identity is an ordinal on one exact frozen `SpanBatch`; equal geometry does not imply equal claims |
| \(F_M\) | later canonical semantic facts | distinct from occurrences; value identity remains open for K5 |
| \(O_{N,M}\) | later output-to-source atom-origin relations | cross-master and basis-checked; distinct from support or causal derivation |

Consequently, diagonal empties belong to \(L_M\), not to Allen's \(I_M\). Claim-pair identity is
the ordinal diagonal on one exact frozen batch. Origin identity is the atom diagonal between
compatible master bases. None of these identities may be borrowed by another carrier merely
because its projected geometry is equal.

### Reserved operation vocabulary

| Operation | Sort and meaning |
|---|---|
| `AllenCompose` | canonical qualitative atom-set upper approximation |
| `ConcreteCompose` | exact relation composition on one declared carrier |
| `Seq` | shared-boundary located composition on \(L_M\) |
| `ComposePairs` | exact composition of claim-identity relations |
| `Saturate` | positive fixed-point fact inference |
| `Select` | explicit nonmonotone policy execution |
| `ComposeOrigins` | basis-checked cross-master relational composition |
| `Materialize` | realization of a supplied output-piece plan as a new master |

There is no unqualified public `Compose`: sharing algebraic notation does not make the carriers or
their result semantics interchangeable.

### Assurance registry

| ID | Public claim and status | Assurance owner | Evidence or landing gate | Lean reactivation trigger |
|---|---|---|---|---|
| K0-CARRIER | \(P_M\), \(L_M\), \(I_M\), \(C_M\), \(F_M\), and \(O_{N,M}\) are distinct; empties occur only in \(L_M\) among the interval carriers — **frozen** | deterministic contract plus adversarial C# boundary cases | existing empty-span refusal in `AllenAlgebra.Relate`; K3 must add the located diagonal positively | a generalized public interval carrier would change empty participation or an operator signature |
| K0-IDENTITY-GEOMETRY | Allen `Equal` is identity on \(I_M\), never claim identity — **frozen** | C# oracle/counterexample | classifier cases plus equal-geometry distinct claims in the batch/laminar harness | only if a generic qualitative-calculus or quotient API is proposed |
| K1-ALLEN-JEPD | the thirteen Allen atoms are jointly exhaustive and pairwise disjoint on \(I_M\) — **implemented in K1b (D28)** | finite exhaustive C# certificate | independent endpoint predicates are unique and agree with `Relate` on all 225 ordered \(D_6\) interval pairs; all thirteen atoms occur | only if Doccer generalizes beyond the finite linear interval carrier |
| K1-ALLEN-CONVERSE | converse is involutive and agrees with argument reversal — **implemented in K1a (D26)** | finite exhaustive C# oracle | all 8192 relation-set values plus every nonempty interval pair on the six-boundary model | only if a generalized relation carrier changes converse semantics |
| K1-ALLEN-COMPOSE | `AllenCompose` is the canonical weak-composition upper approximation, not fixed-master exact composition — **implemented in K1b (D28)** | independently encoded table, exhaustive \(D_6\) certificate, and external cited formalization | literal shipped table and independent endpoint oracle agree on all 169 cells/409 atomic triads; algebra laws are executable | a generic qualitative-calculus proof API or non-finite carrier is proposed |
| K1-ALLEN-FINITE-GAP | canonical `Before AllenCompose Before` may contain `Before` even when a fixed finite master has no middle witness — **implemented in K1b (D28)** | smallest executable counterexample | \([0,1)\), \([2,3)\), and the four-boundary carrier retain no intervening nonempty interval | none presently; the counterexample fixes the contract boundary |
| K2-CONCRETE-PAIRS | `ConcreteCompose`/`ComposePairs` are exact basis-checked relations; claim identity is the ordinal diagonal on one exact frozen batch — **reserved for joint K2 design** | reference C# relation oracle and property tests | exact-basis refusal, extensional identity and associativity, projections, semijoins, and one semantic replacement for `IntervalJoins.Join` before landing | a packed witness representation is asked to inherit identity, associativity, or bracket-independent support |
| K3-LOCATED-SEQ | geometry-only located `Seq` uses a shared boundary, has the declared-window diagonal identity, is associative, and distributes over union — **reserved for joint K3/K4a design** | simple C# matrix/reference semantics and bounded exhaustive tests | identity, associativity, distributivity, finite consuming closure, rebase laws, and explicit graph-to-geometry projection before landing | a compressed or incremental closure algorithm replaces the reference semantics, or an exact-versus-lax map boundary remains disputed |
| K4-SELECT | `Select` executes a named caller policy and promises only that policy's result invariants, never an implied optimum — **reserved for K4** | deterministic policy contract plus adversarial C# result validation | policy stamp, tie rule, rejected alternatives, conflicts, and residuals remain visible | only if a replacement optimizer claims equivalence or a new global optimality guarantee; policy choice itself is not a theorem |
| K5-SATURATE | positive finite `Saturate` is monotone and inflationary and reaches one least fixed point independent of fair rule order — **reserved for K5** | reference worklist, order-permutation C# tests, and standard external theorem | canonical fact identity must close first; repeated derivations add support rather than duplicate facts | before parallel or incremental saturation claims semantic equivalence |
| K6-COMPOSE-ORIGINS | `ComposeOrigins` is ordinary basis-checked relation composition; identity is the atom diagonal between compatible master bases — **reserved for K6** | reference C# relation oracle and property tests | tagged middle-basis refusal, identity, associativity, and functional-embedding laws before landing | compression, stage fusion, or a functional fast path relies on semantic equivalence |
| K7-MATERIALIZE | `Materialize` realizes a supplied ordered piece plan whose pieces partition and exactly reconstruct a new master with declared origin or synthetic explanation — **reserved for K7** | construction-time validation and adversarial C# tests | gaps, overlaps, unmapped output, unused pieces, and origin/support conflation are refused or retained as named residue | before stage fusion, intermediate-master elision, or a nontrivial global reconstruction guarantee |

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
