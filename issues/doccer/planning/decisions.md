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
| D29 | Joint K2 contract and Allen abstraction bridge: K2a/K2b/K2c share exact frozen-batch occurrence bases and land consecutively; reference `ComposePairs` is ordinary extensional relation composition over an identical middle batch and never derives exact edges from `AllenCompose`; the Allen image of exact composition is contained in the canonical composition of the input images, with the adjacent-gap witness refuting the converse; reference C# relation/property oracles own the initial proof burden, while Lean remains deferred until an optimized or generalized backend makes universal no-false-negative equivalence load-bearing | recorded; joint K2 contract frozen, Lean not activated |
| D30 | Occurrence selection closure (K2a): `ClaimSelection` is an immutable set of ordinals on one exact frozen `SpanBatch`; `None`/`All`/validated `Create` and `FromPredicate` construction, count/emptiness/membership, union/intersection/subtraction/relative complement, value equality/hash, and ascending-ordinal enumeration preserve occurrence identity; `Records(ClaimOrder)` is the explicit ordered projection and `Coverage()` the explicit identity-forgetting projection; grouping, gap cadence, suppression, and legacy predicate conveniences share the selection-backed reference path; D25's policy-bearing `Select` name remains reserved for K4; no durable ID, pair carrier, or join transition lands in K2a | implemented; K2a closed |
| D31 | Exact occurrence-pair closure (K2b): `ClaimPairView` is an immutable exact finite relation over an ordered pair of frozen-batch references, with validated creation/geometry relation, derived Allen labels, ordinal-diagonal identity, lexicographic enumeration, value equality/hash, converse, projections, and exact-basis semijoins; `ComposePairs` is direct middle-ordinal relational composition and `ClaimPairWitnessView` is separate basis-stamped evidence for one composition; the D29 Allen-image inclusion and both non-converse mechanisms are executable while `AllenImage` remains nonpublic; `IntervalJoins.Join` now accepts `AllenRelationSet?` and only projects `ClaimPairView.Relate`, removing its independent join meaning | implemented; K2b closed |
| D32 | Strict stack pairing closure (K2c): exact `ClaimSelection` inputs assign open/close roles and an exact named `PairingPolicy` object owns compatibility; the combined selected geometry must be one non-overlapping token stream; each closer consumes only the stack top into either a `ClaimPairView` match or correlated mismatch evidence, with empty-stack closes dangling and final opens unclosed; `PairingResult` retains exact input/policy stamps, match edges, complete selection-backed unary residue, mismatch pairs, and an explicit identity-forgetting `PairedRegions()` envelope projection; environment and fence witnesses plus all 5,461 two-key words through length six satisfy an independent oracle and partition/forward/one-to-one/noncrossing laws; no repair, recovery search, containment, parenthood, delimiter vocabulary, or Lean activation lands | implemented; K2 closed |
| D33 | Joint K3/K4a located/flat-path contract: `LocatedRelation` uses the concrete `(compatible TextMaster, exact window)` basis, collapses equal geometry, owns the declared-window diagonal and one Boolean geometry-reachability implementation, and rebases exactly through `TextSlice`; `CandidateRegionGraph` preserves parallel claim ordinals and projects explicitly to that geometry; graph reachability and identity-bearing path results remain different sorts; K4a reserves path-specific segmentation residue and a named first-ordinal reference path, while budget-admissible candidates remain cost-free; K4b starts with objective-structured flat-path selection rather than a universal solver, K4c keeps family-specific structural policies, and common selection types wait for demonstrated repetition | recorded; joint contract frozen; core implemented by D35, K4a results pending; Lean not activated |
| D34 | K3/K4a peer-review correction: K4b flat-path selection and K4c structural families are sibling continuations after K4a, with K4b retained only as the default execution priority; graph/results remain strict to one exact frozen `SpanBatch` while located operations use compatible-master/equal-window geometry, and projection is the identity-forgetting seam; first-ordinal determinism is exact-basis only; joint-core and K4a-result gates are separate; K4c must repair `Laminarizer` under D2/D21/D30; located `CanSeq` is endpoint equality admitting diagonal empties and is not Allen `Meets` | recorded; D33 amended; core implemented by D35, K4a results pending; Lean not activated |
| D35 | Joint K3/K4a core closure: immutable `LocatedRelation` implements the compatible-master/exact-window geometry value with canonical duplicate-collapsing extents, full scalar-boundary diagonal, union, endpoint-equality `Seq`, consuming projection, direct finite reachability, value equality/hash, and exact `TextSlice` rebase; exact-batch `CandidateRegionGraph` retains a validated nonempty contained `ClaimSelection` as parallel ordinal edges and exposes `ToLocatedRelation()` as the sole identity-forgetting projection; all 64 values and 4,096 compositions on the three-boundary carrier agree with independent oracles, 262,144 triples satisfy associativity/distributivity, bounded closure/rebase/refusal/projection witnesses are green, and the non-injective lax counterexample remains test-only; no result/path/policy surface or Lean activation lands | implemented; K3 and K4a core closed, K4a results active next |

## Joint located/graph core closure (D35)

D35 implements the first of D34's two independent source gates. `LocatedRelation` is an immutable
geometry value over one compatible `TextMaster` identity and exact validated window. It admits empty
extents, materializes the full scalar-valid declared-window diagonal as `Identity`, canonicalizes
duplicate geometry, and supplies `Union`, endpoint-equality `Seq`, `Consuming`, and direct finite
`Reachability`. Its equality/hash follow the existing compatible-value `SpanSet` precedent. New
`TextSlice.ToParent`/`ToChild` overloads translate the relation window and edges together; the
injective map commutes exactly with union, `Seq`, and reachability, while a test-only collapsing-map
counterexample retains the deferred lax boundary without publishing a generalized map API.

`CandidateRegionGraph` remains occurrence-strict. It retains the exact input `ClaimSelection`,
derives its exact frozen `SpanBatch` source from that stamp, validates its exact window, and refuses
selected claims outside it. Parallel equal-geometry ordinals remain distinct graph edges.
`ToLocatedRelation()` is the explicit identity-forgetting hop: different exact occurrence graphs
may project to one equal compatible geometry value, and equal geometry collapses only there.

The contract harness checks every relation value and composition on the complete three-boundary
carrier against independent nested-pair and Floyd-Warshall oracles, then exhausts all 262,144
relation triples for associativity and both distributive laws. Separate cases cover scalar
boundaries, diagonal-empty adjacency, consuming nilpotence/finite star, compatible/equal-window
refusal, exact slice rebase, empty windows, graph containment, exact-batch identity, and parallel
projection collapse. Harness 1779→1834. No `ReachabilityView`, `PartitionView`, segmentation value,
reference path, token/chunk fixture, selection objective, or structural-family migration lands;
those remain in the separate K4a-result and sibling K4b/K4c gates. Full report:
[D35 core brief](../briefs/sol-doccer-k3-k4a-core-20260805_182229.md).

## K3/K4a review correction (D34)

Peer review accepts D33's carrier split and immediate source chip but corrects its dependency
notation. The workplan DAG records type/design dependencies, so K4c cannot be downstream of K4b
when D33 deliberately refuses to invent a shared K4b carrier. Both lanes consume K4a:

1. joint K3/K4a core — located algebra, exact-batch graph, explicit projection;
2. K4a results — reachability, partition/path results, residuals, and bounded witnesses;
3. sibling continuations:
   - K4b flat-path selection is the default execution priority for tokenizer/chunker work;
   - K4c packing, cover, laminar, hierarchy, and resolution work is independently available;
4. common selection types only after both lanes demonstrate genuine repeated structure.

The basis seam is now explicit. `CandidateRegionGraph` and every graph-stamped result retain the
exact frozen batch reference inherited through `ClaimSelection`. `LocatedRelation` is a geometry
value: its operations require `TextMaster.IsCompatibleWith` and an exactly equal window. The graph
projection is the single licensed transition that forgets occurrence identity; different graph
bases may project to one equal located value.

`FirstOrdinalCompletePath` keeps its visibly arbitrary baseline policy. Since batch ordinals are
assigned in insertion order, it is reproducible only for the exact graph/batch named by the result.
Recollection or insertion reordering creates a different occurrence basis and may choose another
complete path. K8 must retain the graph and policy stamp rather than claim cross-batch invariance.

The first source chip is accepted on located identity/union/`Seq`/closure/rebase laws, exact graph
basis validation, explicit projection, and parallel-edge collapse. The second chip separately owns
reachability and partition/result values, the reference path, gap/dead-end/empty cases,
token/chunk witnesses, and independent path-oracle agreement.

K4c carries a hygiene migration independent of K4b. The current `Laminarizer` predates D2's named
policy stamp, D21's basis stamp, and D30's selection backing. K4c separates greedy admission,
laminar-family validation, explicit nearest-parent projection, and an explicit multiple-parent DAG.
Its greedy contract remains deterministic and inclusion-maximal, not maximum.

Finally, the located-family adjacency condition is
`CanSeq(left,right) := left.End == right.Start`, shared by `LocatedRelation.Seq` and
`PartitionView`. It admits diagonal empties, so it is not Allen `Meets`; no unqualified
`TextSpan.Meets` API or change to D17 intersection semantics is authorized.

These corrections add no proof burden. Direct finite reference semantics and the separate bounded
oracles remain sufficient; the D33 Lean triggers are unchanged. Full reasoning is in the
[D34 review adjudication](../briefs/sol-doccer-k3-k4a-review-adjudication-20260805_151759.md).

## Located geometry and flat-path contract (D33)

The K3/K4 read-ahead retains D27's macro-order but corrects two assumptions that would otherwise
produce transitional APIs.

First, “one reachability implementation” means one Boolean **geometry** closure. A graph with
parallel claims over equal spans has more identity-bearing paths than its located projection, so a
located reachability edge cannot also be the path witness. `CandidateRegionGraph` projects to
`LocatedRelation`; `ReachabilityView` delegates boundary reachability to that closure; a partition
or reference path separately retains the ordered claim ordinals.

Second, the earlier K4b outline placed a universal `SelectionProblem` before packing, cover, and
laminar result families existed. An arbitrary objective over arbitrary subsets does not supply an
algorithmic contract. K4b now begins with the flat DAG family and must state the objective form,
feasibility, tie rule, and exact deterministic/optimality guarantee. K4c may reuse those obligations
where they fit, but a common selection carrier is extracted only after at least two families
demonstrate the same shape.

The implementation order as amended by D34 is:

1. one joint K3/K4a core chip: geometry-only `LocatedRelation`, minimal
   `CandidateRegionGraph`, and explicit projection;
2. one K4a result chip: graph-stamped reachability over K3 closure, `PartitionView`, the named
   `FirstOrdinalCompletePath`, path-specific `SegmentationResult`/`SegmentationResidual`, and bounded
   token/chunk/gap/dead-end/empty witnesses;
3. sibling continuations after K4a:
   - K4b flat-path selection with declared objective structure, the default execution priority;
   - K4c packing, cover, laminar-family, hierarchy, and resolution views plus family-specific
     policies, independently available;
4. a shared selection abstraction only if repeated contracts from both lanes license it.

The dependency DAG removes the former K2b-to-K3 arrow. The located carrier uses a master/window and
the graph uses `ClaimSelection`; finishing K2b before this tranche was completion priority, not a
`ClaimPairView` type dependency.

The located basis is compatible master identity plus an exact validated window. Binary operators
require compatible master values and equal windows. Graph/result operations are stricter on one
exact frozen batch; projection is the deliberate transition from occurrence identity to geometry
value. The located identity is every scalar-valid diagonal boundary inside the window, whether
represented explicitly or implicitly. `TextSlice` rebase translates the window as well as the
edges; expanding it to the parent extent would break exact identity and `Seq` preservation. No
generic boundary hierarchy or generalized map lands. The non-injective direct-image law remains a
deferred lax inclusion obligation.

The graph accepts only selected nonempty claims wholly contained in its window. Parallel ordinals
survive until the explicit located projection. An empty window accepts the empty selection and has
a zero-edge partition, distinct from the located one-point identity. A coverage gap is absent
material; a connectivity dead end can occur despite total geometric coverage when overlapping
candidates do not meet. `SelectionResidual` remains reserved for policy-bearing K4b results;
K4a uses segmentation/path terminology.

The K4a chunk witness is now called **budget-admissible**: an external rule has already admitted its
candidate edges, but the graph carries no objective or cost. “Best budgeted chunking” remains K4b.
The first reference path is explicitly first-ordinal among edges whose suffix remains reachable; it
is a deterministic completeness witness on one exact frozen graph, not an optimizer or a promise
of invariance after batch reconstruction/reordering.

Direct finite relation/matrix semantics, an independent bounded oracle, projection adversaries, and
path fixtures own K3/K4a assurance. This does not activate Lean. Reapply the gate before compressed
or incremental closure, a generalized exact-versus-lax map surface, or a K4b public global-optimum
or optimized/reference-equivalence guarantee. D35 closes the joint core at 1834 checks; the
separate K4a result gate is active next.

## Strict stack pairing closure (D32)

`Pairing.Pair` closes K2 with the first structural consumer of both exact occurrence carriers:

- `OpenInput` and `CloseInput` are retained exact selections, possibly on distinct frozen batches
  over compatible masters. They assign roles; Doccer does not universalize delimiter kind names;
- `PairingPolicy` retains a required diagnostic name and either a direct opener/closer rule or a
  `ByKey` selector/comparer. `PairingResult` retains the exact policy object that ran;
- the combined selected spans must form one pairwise non-overlapping geometric token stream. An
  occurrence in both roles or equal/overlapping token geometry is refused rather than ordered by
  insertion, ordinal, or an engine-chosen role tie;
- execution is strict stack discipline. A closer on an empty stack is dangling; otherwise it pops
  the top opener. Compatible endpoints become `MatchEdges`, while incompatible endpoints become
  `MismatchedPairs` and are both consumed into fault residue. The engine never searches below the
  top for a replacement;
- final stack members become `UnclosedOpens`. Match projections plus `OpenResidue` and
  `CloseResidue` are disjoint complete partitions of the two input populations; mismatch
  projections preserve their correlated pair evidence;
- `PairedRegions()` projects each accepted edge to `[open.Start, close.End)` and normalizes through
  `SpanSet`. Its possible collapse of nested or adjacent envelopes is the advertised
  identity-forgetting boundary, not a second pairing truth.

The environment witness covers nested keys and envelope collapse; the fence witness covers a
second key family, custom comparison, sequential matches, and distinct compatible bases. One
adversarial execution simultaneously retains dangling, mismatched, matched, and unclosed outcomes
and confirms that mismatch is top-only. An independent abstract stack oracle agrees on all 5,461
words of length zero through six over open-A, open-B, close-A, and close-B; every result is also
checked for exact stamps, complete category partitions, forward compatible partial one-to-one
edges, and noncrossing.

This finite deterministic reference operation creates no present Lean burden: its result laws are
checked directly and no alternative backend or recovery-equivalence claim exists. Reassess only if
an optimized/parallel implementation or a new recovery policy claims equivalence. Harness
1733→1779; K2 is closed, and the joint K3/K4a located-relation/candidate-graph design became active
next. D33 has since frozen that contract and made the joint core the active source chip.

## Exact occurrence-pair closure (D31)

`ClaimPairView` realizes K0's exact `ComposePairs` family without importing qualitative
possibility into occurrence identity:

- `LeftBasis` and `RightBasis` are exact frozen-batch references. Pair construction validates
  compatible coordinate spaces, derives every edge's `AllenRelation`, deduplicates membership, and
  enumerates lexicographic ordinal pairs;
- `Identity(batch)` is the ordinal diagonal. `Relate(batch,batch,AllenRelationSet.Equal)` may also
  contain off-diagonal pairs when distinct claims share geometry, so the two identities remain
  visibly different;
- converse swaps bases/ordinals and inverts labels; left/right projections return
  `ClaimSelection`; semijoins require the selection's exact corresponding basis;
- `ComposePairs` equates actual middle ordinals on an identical shared batch, deduplicates outer
  pairs, and derives their labels from outer occurrences. `ClaimPairWitnessView` separately stamps
  the three bases and reports complete ascending middles per outer pair, with no support-algebra or
  persistence claim;
- `IntervalJoins.Join` has no geometry loop of its own. Its `AllenRelationSet?` filter feeds
  `ClaimPairView.Relate`, and the method only resolves exact edges to legacy `SpanJoin` rows.

The bounded assurance checks all 16 relations on a two-by-two basis, all 256 ordered composition
pairs against a separate nested ordinal oracle, and all 4,096 relation triples for associativity.
The six-boundary bridge checks 3,375 exact middle paths pointwise before the union-level
Allen-image inclusion. Actual images are distinguished from requested filters; different middle
identities and the complete adjacent four-boundary carrier separately refute the converse.

This closes the initial reference proof burden at 1,733 harness checks without exposing
`AllenImage` or activating Lean. The D29 reactivation gate remains attached to a later backend that
uses qualitative summaries to omit exact work or changes the inclusion, basis, or public
abstraction contract. D32 subsequently closes K2c and the full K2 tranche.

## Occurrence selection closure (D30)

`ClaimSelection` closes the unary occurrence-query algebra without turning result order or geometry
into identity:

- its universe is the ordinal range of one exact frozen `SpanBatch` reference; a second batch is a
  different basis even when it uses the same `TextMaster` and contains claim-for-claim equal rows;
- `None`, `All`, `Create`, and `FromPredicate` copy membership into an immutable value; duplicate input
  ordinals coalesce, undefined ordinals fail, and binary operations refuse different basis
  references before combining membership;
- `FromPredicate` deliberately names ordinary predicate filtering without spending D25's reserved
  policy-bearing `Select` verb; K4 still owns that nonmonotone decision surface;
- canonical enumeration is ascending ordinal. `Records(ClaimOrder)` applies the same internal
  geometry/priority total orders as `SortedSpanLookup` but does not alter set equality or canonical
  enumeration;
- `Coverage()` deliberately forgets occurrences and normalizes their spans as a `SpanSet`, so equal,
  overlapping, or adjacent geometry may collapse;
- `Grouping.ByKey`, `Grouping.ByLine`, `GapCadence.Measure`, and `Suppression.Admitted`/`Excluded`
  accept selections. Their batch/predicate conveniences construct `All` or predicate selections and
  delegate; `GapCadenceMeasure.Population` retains the exact window-admitted occurrence set beside
  its start-ordered ordinal evidence.

The bounded assurance sweeps all 64 subsets of a six-claim basis and all 4,096 ordered subset
pairs against an integer-mask oracle, with complement, difference, De Morgan, commutativity, and
distributivity checks. A 70-claim witness crosses the private bitset word boundary. Adversarial
tests retain equal-membership cross-batch refusal, undefined ordinals, coverage collapse, explicit
orders, consumer parity, and lazy-topology behavior. This closes K2a at 1,651 harness checks without
changing `IntervalJoins.Join` or activating Lean; D31 subsequently closes K2b's pair/join boundary.

## K2 exact-to-qualitative bridge and proof gate (D29)

Let \(R\subseteq A\times B\) and \(S\subseteq B\times C\) be exact `ClaimPairView` relations whose
middle basis is the identical frozen batch. Reference `ComposePairs` is ordinary finite relation
composition:

\[
R;S=\{(a,c)\mid\exists b.\ (a,b)\in R\land(b,c)\in S\}.
\]

For a pair relation \(R\), let \(\alpha(R)\) be the `AllenRelationSet` image of the actual edges
under `AllenAlgebra.Relate`. This is contract notation and a harness oracle, not automatically a
new public method and not the originally requested construction filter. The cross-carrier law is:

\[
\alpha(R;S)\subseteq\alpha(R)\mathbin{\mathrm{AllenCompose}}\alpha(S).
\]

The proof burden is real but presently executable: every output pair has an exact middle witness;
its three spans form an Allen atomic triad; D28's independently certified table contains the outer
atom. The inclusion is deliberately not equality. \(\alpha\) forgets which middle identity
realized each input atom, and the adjacent-gap counterexample separately shows that a qualitatively
permitted outer relation need not have an exact middle interval on one finite carrier.

Consequently, K2b must:

- implement one direct exact middle-ordinal reference composition without calling
  `AllenCompose`;
- check extensional output against an independently written nested relation oracle;
- check the Allen-image inclusion, its per-witness atomic form, and the adjacent-gap non-converse;
- require every exact output edge to have an actual middle ordinal;
- make any retained `IntervalJoins.Join` a projection from `ClaimPairView`, not a second join
  implementation.

This statement does not activate Lean. Its direction is settled, its proof is a witness chase over
standard finite relation algebra, and the Doccer-specific plumbing is visible to reference and
property tests. Reactivate the Lean gate before a compressed, indexed, incremental, or independent
pair backend uses qualitative summaries to omit exact work and claims universal no-false-negative
equivalence; also reactivate if equality replaces inclusion, the middle-basis rule changes, or the
abstraction becomes a generalized public qualitative-calculus contract.

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
  \([0,1)\) and \([2,3)\). Exact claim-pair composition was assigned to K2b and is now closed by
  D31.
- `RelationRequirement.AcceptedRelations` and `ForbiddenRelation.ForbiddenRelations` now carry the
  closed `AllenRelationSet` value and refuse `None`. D27's no-half-measure boundary holds:
  `IntervalJoins.Join` received no filter-only transition; D31 replaces its terminal semantics
  through `ClaimPairView`.

## Sequencing boundary (D27)

D27 distinguishes **completion priority** from **type dependency**. K1b was the first completion
priority and is now closed by D28. K2 does not depend on the canonical composition table: it
depends on K1's closed `AllenRelationSet` as an exact-join filter.

The resulting boundaries are:

1. **K1b closes semantics, not a transitional join API.** It owns `AllenCompose`, the independently
   encoded table, the separate \(D_6\) oracle, JEPD/classifier closure, the adjacent-gap
   counterexample, and migration of durable validation filters. `IntervalJoins.Join` was not given
   a one-chip relation-set retrofit; D31 performs the planned K2b replacement directly.
2. **K2 is specified vertically before its chips land.** D29 freezes the shared bases,
   projections, residues, identities, reference pair semantics, and Allen abstraction law. K2a,
   K2b, and K2c remain separate buildable implementation chips and land without an unrelated
   tranche between them.
3. **Selection membership is not result order.** `ClaimSelection` is a pure set over ordinals on
   one exact frozen batch and canonically enumerates ascending ordinals. Geometry- or
   priority-ordered records are explicit query projections under `ClaimOrder`; order is not part
   of selection equality. Existing ordered lookups are not mechanically changed to return an
   unordered set.
4. **K2a includes the stable population integrations.** Predicate selection, `Coverage()`,
   grouping, cadence, and suppression accept or produce `ClaimSelection` where their semantics are
   set-valued. Predicate conveniences may delegate to that carrier rather than remain independent
   implementations.
5. **K2b owns the join transition, completed by D31.** `ClaimPairView` supplies exact basis-stamped
   relation rows, projections, semijoins, converse, and `ComposePairs`. `IntervalJoins.Join` is
   retained only as a compatibility projection backed by this carrier, never as a parallel
   semantic path. Middle-witness grouping remains transparent; packed or bracket-independent
   support waits for K5's support identity.
6. **Pairing witnesses K2.** `PairingResult.MatchEdges` uses `ClaimPairView`; unary fault
   populations use `ClaimSelection`, while mismatches retain explicit pair evidence. Pairing does
   not invent repair, containment, or parenthood.
7. **K3 and K4a are co-designed.** `LocatedRelation` is the pure geometry set over \(L_M\): it
   carries no claim labels and collapses duplicate geometry. `CandidateRegionGraph` owns claim
   ordinals and parallel identity-bearing edges and exposes an explicit identity-forgetting
   projection to located geometry. D33 makes the algebra plus minimal graph projection one core
   source chip; the result layer follows separately. One geometry closure serves both, while graph
   paths retain occurrence identity in their own result sort.
8. **K4 continuations are siblings.** D34 corrects the workplan dependency: K4b flat-path selection
   and K4c structural families both follow K4a. K4b stays first only as the default execution
   priority; neither lane may manufacture a shared carrier as a prerequisite for the other.
9. **Witnesses move left.** Pairing witnesses K2; ambiguous token and budget-admissible chunk graphs witness
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
| K2-SELECTION | `ClaimSelection` is exact-batch occurrence membership; Boolean algebra is basis-closed, canonical enumeration is ascending ordinal, and ordered/coverage projections do not change identity — **implemented in K2a (D30)** | bounded exhaustive C# mask oracle plus adversarial basis/projection/integration witnesses | all 64 subsets and all 4,096 ordered pairs on a six-claim basis; a 70-claim word-boundary case; cross-batch refusal; order/coverage separation; grouping/cadence/suppression parity | a compressed, persisted, incremental, or independent backend changes batch identity or claims extensional equivalence without differential coverage |
| K2-CONCRETE-PAIRS | the `ConcreteCompose` family is exact basis-checked finite relation composition; `ClaimPairView` realizes it as `ComposePairs`, with claim identity the ordinal diagonal on one exact frozen batch — **implemented in K2b (D31)** | direct middle-ordinal reference implementation, independent nested relation oracle, and C# property tests | all 16 bounded relation values, 256 differential compositions, 4,096 associative triples, exact-basis refusal, identity, converse, projections, semijoins, complete middle witnesses, and one semantic `IntervalJoins.Join` path | a compressed/indexed backend claims equivalence without differential coverage, or a packed witness representation is asked to inherit extensional identity, associativity, or bracket-independent support |
| K2-ALLEN-ABSTRACTION | the Allen image of exact `ComposePairs(R,S)` is contained in `AllenImage(R).AllenCompose(AllenImage(S))`; equality and qualitative edge generation are refused — **implemented as a K2b assurance law (D31); `AllenImage` remains nonpublic** | D28 atomic-triad certificate plus pointwise C# witness law and adjacent-gap/correlation counterexamples | actual edge images rather than requested filters; all 3,375 six-boundary middle paths satisfy atomic containment; union-level inclusion; executable non-converse | before an optimized backend uses qualitative summaries to omit exact work and claims universal no-false-negative equivalence, or if equality/generalized public abstraction is proposed |
| K2-PAIRING | strict stack pairing over exact role selections produces forward compatible partial one-to-one noncrossing matches and disjoint complete named residue; mismatch consumes and records only the stack top — **implemented in K2c (D32)** | direct reference implementation, two concrete delimiter-family witnesses, independent bounded abstract-stack oracle, and result-law checks | environment/fence cases, combined dangling/mismatch/match/unclosed adversary, and all 5,461 two-key words through length six; exact stamps and ambiguity refusals retained | before an optimized, parallel, incremental, or recovery-bearing implementation claims equivalence with the strict reference policy |
| K3-LOCATED-SEQ | geometry-only located `Seq` uses `CanSeq(left,right) := left.End == right.Start` on the compatible-master/exact-window basis, admits the declared-window diagonal, is associative, distributes over union, and supplies the sole Boolean geometry reachability used by K4a — **implemented by D35** | direct finite C# reference semantics, independent nested-pair/Floyd-Warshall oracles, and bounded exhaustive laws | all 64 values, 4,096 compositions, and 262,144 triples on three boundaries; identity, associativity, distributivity, consuming finite star/nilpotence, exact window-preserving rebase, compatible/equal-window refusal, diagonal-empty adjacency, and the test-only non-injective counterexample | a compressed or incremental closure algorithm replaces the reference semantics, or a generalized map reopens the exact-versus-lax boundary |
| K4-FLAT-PATH | exact-batch `CandidateRegionGraph` preserves parallel claim ordinals while projecting to compatible located geometry; a partition retains an ordered `CanSeq` path and exactly covers its window; gaps and connectivity dead ends remain distinct; first-ordinal determinism is exact-basis only — **graph/projection core implemented by D35; result layer pending** | K3 closure plus graph-specific reference traversal, independent bounded path oracle, and construction-time result validation | D35 closes exact selection/window validation, exact-batch graph identity, compatible-geometry projection, and parallel-edge collapse; the separate result chip owns ambiguous paths, stamped first-ordinal complete path, empty partition, independent gap/dead-end cases, and budget-admissible chunk candidates without cost | an alternative/packed reachability backend claims equivalence, all-path enumeration gains a complexity guarantee, cross-batch invariance is proposed, or path/partition preservation is generalized beyond the frozen hypotheses |
| K4-SELECT | each family-specific `Select` executor runs a named caller policy and promises only its declared feasibility/objective/tie invariants, never an implied optimum; K4b and K4c are sibling lanes and no universal selection carrier is yet promised — **reserved after K4a by D34** | deterministic policy contract plus family-specific reference semantics and adversarial C# result validation | exact basis, objective form, policy stamp, tie rule, selected/rejected alternatives, conflicts, residuals, and score/unit remain visible; reuse occurs only after demonstrated repetition | before a public global-optimality guarantee, an optimized/reference equivalence claim, or a generalized objective algebra becomes load-bearing; policy choice itself is not a theorem |
| K4-STRUCTURE | packing, cover, laminar-family, and hierarchy views retain their exact basis and named policy; greedy admission, family validation, nearest-parent projection, and multiple-parent DAG construction remain distinct — **reserved for sibling K4c by D34** | construction-time validation, independent policy oracle, and adversarial C# result checks | D2 policy stamp, D21 basis stamp including empty results, D30 selection backing, explicit maximal-not-maximum greedy counterexample, and refusal to infer unique parenthood without policy | before a structural executor promises a global optimum or an optimized/reference equivalence; deterministic validation and policy choice alone are not theorem work |
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
