# Doccer expansion round 2 — evidence excavation and sequence amendment

Runstamp 20260806_093159. Canon at entry: D1–D40; K0–K4 closed; contract harness 1976 checks
green. This is a planning and evidence chip. It changes no Doccer source surface and does not
claim a new performance result.

**Supersession note (2026-08-10):** D46 supersedes this brief's provisional single-carrier V0
shape with a basisless `BooleanVector` and explicitly named `Utf16UnitMask`, and temporarily places
their portable V1 reference implementation before the already frozen K6 source chip. The A/F
lanes, V2 measurement gate, and separation of packed `SpanSet` and suppression work remain in
force. See the
[V1 read-ahead](../discussions/sol-doccer-v1-portable-vector-read-ahead-20260810_013729.md) and
[D46 contract](sol-doccer-v0-boolean-vector-unit-mask-contract-20260810_013731.md).

## Decision (D41, amended after owner clarification)

Keep the current K critical path unchanged: K5a remains the default next chip; K5b and K6 are
sibling lanes; K7 follows K6; K8 remains the cross-carrier integration close. Broaden the
round-two result from a source-reuse screen into a capability excavation:

- **V — code-unit vectors:** reserve a low-level, basis-stamped Boolean-vector carrier with direct
  use and explicit harvest exits. V0 contract work and V1 portable reference work are independent
  of the K arc; V2 word/SWAR/SIMD acceleration follows a named workload and differential evidence.
- **A — measured acceleration:** baseline first, then the set-bit walker and flat-path recurrence
  as independently landable candidates under the frozen D30/D37 semantics. The broader transfer
  repertoire—span-first kernels, exact allocation, flat layouts, operation/worker scratch,
  bounded heaps, stable online reduction, deterministic parallel state, and reference/fast
  backend pairing—is applied per capability rather than turned into a generic framework.
- **F7 — edit/correspondence and derived-origin producers; F8 — direct comparison,
  hashing/signature/sketch/index capabilities; F9 — statistical feature and weighting views.**
  These families split into subchips by their real inputs. They are not collectively dependent on
  K8: low-level contracts and current-carrier kernels may proceed independently, while
  origin/materialization integration waits for K6/K7 and the broader implementations retain a
  post-K scheduling default.

ThermoMapper is a source of concepts, patterns, and prototype capabilities, not a policy authority
for Doccer. Donor implementation defects become requirements the Doccer lift must address; donor
benchmark gates, placement rules, and local adoption policy do not become Doccer gates. Detailed
ThermoMapper repair guidance is kept outside this canon in
`D:\aghado01\ThermoMapper\issues\doccer-excavation-hpc-hashish-review-20260806.md`.

## Study contract and coverage

The requested study had three obligations: separate the conceptual threads, check concrete claims
against current source, and integrate only the supported parts into the plan.

| Source | mdnav partition | Coverage | Use |
|---|---:|---:|---|
| [Round-2 transcript](../discussions/opus-doccer-expansion-round2.md) | H1, eight chronological turns | 38,721 / 38,721 bytes (100%) | User direction, model proposals, ThermoMapper/hashish claims |
| [Grok ideation](../discussions/grok-doccer-expansion-round2-ideation-20260804.md) | H3, 38 topical units | complete partition; 57,437 / 58,039 bytes emitted (99.0%) | GigaToken/simdjson transfer argument and its own caveats |

The 602 bytes omitted from the second read were image-reference text stripped from mdnav output,
not unread structural units. The remote GigaToken performance numbers were not promoted into
codex-scientiae evidence; D41 relies only on the architectural pattern and the source's repeated
warning that wider vector code can lose to scalar code.

Direct validation covered current Doccer source and a deliberately broad cross-section of the live
`D:\aghado01\ThermoMapper` tree:

- `ClaimSelection`, `PathSelection`, `SpanBatch`, `TextMaster`, `PatternRule`, and
  `RegexCollector`;
- all 22 files under ThermoMapper `src/hashish`;
- graph/layout/traversal code including `CsrGraph`, `UndirectedEdgeWalk`, `UnionFind`, `Dijkstra`,
  `PathNeighborRefiner`, `GraphLaplacian`, and the manual/TensorPrimitives vector kernels;
- allocation/numerics code including `EarthMover`, Welford state, generic scatter accumulation,
  GMM log-sum-exp, `SeedTree`, and checkpointable xoshiro state; and
- reference/fast persistent-homology pairs plus dynamic connectivity/MSF structures, as evidence
  for incremental backends and mechanistically independent oracles.

## Ownership of the ideas

The transcript mixes owner decisions with assistant-generated elaborations. D41 preserves that
boundary.

| Status | Item |
|---|---|
| Owner direction | Treat Doccer as a growing numerical-computing stack, not a unitary scanner or one-application pipeline. |
| Owner direction | Low-level vector values should support both direct consumption and eventual claim/candidate emission. |
| Owner direction | Vectorization is a missed capability; useful ThermoMapper code, patterns, and concepts should be transferred selectively, not vendored wholesale. |
| Owner clarification | The task is to excavate transferable HPC concepts and useful capabilities, not to screen for verbatim ports. A flawed donor implementation may still expose a valuable capability. |
| Owner clarification | ThermoMapper's implementation/adoption policies—including local benchmark cautions—do not dictate Doccer sequencing or gates. |
| Owner clarification | Preserve ThermoMapper implementation critique for later ThermoMapper work, but keep that guidance in the ThermoMapper repository rather than the Doccer canon. |
| Owner direction | Use **codex-scientiae** in full for project-level references. |
| Model proposal requiring adjudication | “One carrier, two exits,” a K0-grade mint, automatic residual projection, and immediate Lean activation. |
| Model proposal requiring adjudication | Public numeric columns, `MemoryMarshal.Cast<char, ulong>` as the general UTF-16 answer, and generic struct policies. |
| Model proposal requiring adjudication | Ambient `RegexOptions.NonBacktracking`, a `TextMaster` prefix-hash column, and computed alignment as origin by definition. |
| Model proposal requiring adjudication | IDF/BM25/entropy/PMI, signatures, and sketches as presumptive engine work. |

The owner direction and clarification are adopted. The concrete model proposals below are placed
by Doccer's contracts and dependencies. Source defects influence the acceptance criteria of a
lift, not whether the underlying concept is admitted.

## D40 already closed the stale questions

The transcript predates the final D40 amendment. It does not reopen:

- graph value equality on one exact source batch;
- the K5a identity/support and K5b saturation split;
- K5/K6 sibling sequencing and the optional K5a-to-K7 derivation seam;
- K6's exact ordered tagged middle basis;
- positive-material K7 pieces and absence/residue for deletion; or
- Doccer **registers** as codepoint-address spans/families, distinct from the application-level
  **math channel**.

D41 inserts no new prerequisite into the K arc. Its sequencing correction is to expose work by
actual dependency rather than assigning every new capability to a blanket post-K bucket.

## Source findings

### Current Doccer

1. `ClaimSelection` already stores `ulong[]` words and uses `PopCount` when combining values, but
   its iterator is a `yield` state machine that tests every ordinal through `Basis.Count`. A sparse
   selection therefore allocates an iterator object and performs work proportional to the whole
   basis rather than the selected population.
2. `PathSelection.Select` scans every admissible candidate at every boundary and allocates/copies
   a full suffix ordinal array for each viable transition. The final contract needs one path; the
   recurrence need only retain score plus successor/predecessor evidence and reconstruct once.
   At a fixed boundary, equal-score choices have distinct first ordinals, so D37's full-sequence
   lexicographic tie reduces locally to the first candidate ordinal.
3. `SpanBatch` is already internally columnar. D20 deliberately leaves numeric columns internal;
   an in-assembly backend needs no public `ReadOnlySpan<int>` surface to use them.
4. Named policy objects are retained evidence stamps. Replacing them with generic structs is a
   contract/API change, not an invisible devirtualization trick.
5. `PatternRule.Options` already permits a caller to request `NonBacktracking`. Forcing it would
   reject regex constructs the present contract accepts; the two hashish call sites do not justify
   a D18 amendment.
6. `TextMaster` correctly notes that its current raw-code-unit SHA-256 byte view is host-endian.
   This is harmless for the current in-process compatibility floor and a live F2 gate before any
   cross-platform persistence.

### Transfer repertoire and what the Doccer lift fixes

This is a capability map, not a file-port shortlist. “Fix in the lift” names a Doccer contract or
implementation requirement. ThermoMapper's own maintenance actions are deliberately absent here
and live in the auxiliary report.

| Donor repertoire | Capability lifted into Doccer planning | Fix or strengthening made by the Doccer lift |
|---|---|---|
| `CsrGraph` construction and induced-subgraph remapping | count → prefix → exact allocation → fill; compact adjacency/column layouts; stable dense remapping | freeze basis and ordering, validate overflow/duplicates, and choose CSR only for an admitted repeated adjacency workload |
| `UndirectedEdgeWalk`, union-find, sorted-row intersection, bounded Dijkstra | pattern enumeration, edge-once traversal, resettable connectivity state, merge-walk intersections, target-bounded search | choose the least restrictive public shape; make invalid graph cases and deterministic order explicit; benchmark claims belong to Doccer's own workloads |
| flat Laplacian/TF-IDF rows, parallel-array top-K, `TensorPrimitives`, manual SIMD tiers | layout-aware flat buffers, structure-of-arrays bounded heaps, library-vector kernels, hardware tier plus scalar tail | preserve semantic reference kernels, layout stamps, remainder paths, and differential agreement instead of treating a cast or intrinsic as semantics |
| Levenshtein and operation-scoped geometry scratch | common-affix trim, shorter working dimension, stack/pool threshold, caller/operation-owned workspaces | separate distance, thresholded screening, edit trace, correspondence, and origin promotion; pool once per operation/worker rather than inside multiplied inner loops |
| `PathNeighborRefiner`, GMM parallel E-step, `SeedTree`/xoshiro | per-worker reusable state, independent partitions, stable log-sum-exp, structural RNG fan-out/checkpointing | define determinism, tie/reduction order, cancellation, parallel threshold, and evidence stamps at the capability boundary |
| Welford and histogram code | streaming/mergeable statistics and caller-owned output spans | carry the exact population, basis, smoothing, error/overflow, and merge contract; do not expose an unstamped generic statistic |
| reference and dynamic PH engines | a slow/obvious semantic oracle paired with an incremental/optimized backend; dynamic connectivity/MSF as future index patterns | use the pattern when Doccer has mutation/update workloads, without importing topology semantics or ThermoMapper activation policy |
| seeded hashes, Bloom, Count-Min, HyperLogLog | span hashing, compact membership, approximate frequency, approximate cardinality, mergeable streaming summaries | stamp algorithm/version/seed/domain/unit/encoding and error model; keep approximate populations distinct from exact selections |
| CTPH-style chunking and rolling-window ideation | content-defined boundaries, rolling/window fingerprints, dual-resolution comparison | specify a true evicting window or another honestly named recurrence, canonical serialization, exact unit basis, and boundary verification |
| MinHash/LSH, SimHash, TLSH-like locality signatures | duplicate/near-duplicate candidate generation and similarity indexes | define feature preprocessing and parameters as signature identity; verify candidates against an exact measure where the operation needs exactness |
| exact Jaccard/Dice/cosine/NCD/edit distance | reusable comparison capabilities over sets, vectors, bytes, and code units | name domain, empty/zero convention, direction, normalization, and bounds; retain exact calibration paths separately from heuristic distances |
| explicit tokenizer/shingler stage and alternate dictionary lookup | reusable feature projection, token/shingle views, allocation-avoiding fitted lookup | performed normalization becomes a producer with loss/origin evidence; feature identity includes normalization/tokenization policy |
| IDF/BM25/TF-IDF/co-occurrence/PMI/PPMI/entropy | basis-stamped feature models, weights, sparse vectors, conditional/context views, similarity search | fitted artifacts are deeply immutable; vocabulary order, population, window, smoothing, direction, normalization, and residual/OOV policy are explicit |
| bounded top-K and sparse-query × dense-row scoring | deterministic ranked query over large candidate populations | separate candidate generation from exact scoring, state score/tie policy, and avoid materializing/sorting a full result population |

The repertoire does not require one shared “HPC framework.” Span kernels, scratch/workspaces,
indexes, accumulators, and vector backends land with the capability whose repeated work they remove.
Only a genuinely shared second consumer justifies extraction into a common internal primitive.

## V lane — code-unit-vector substrate

### V0: registry and contract, available now

Reserve `V(M,W)`, an immutable Boolean value over the UTF-16 code-unit ordinals of exact window
`W` on a compatible `TextMaster` value.

- Empty-window and all-zero vectors are ordinary values; they are not empty intervals.
- Equality and Boolean algebra require a compatible master value, the same exact window, and the
  same vector length. The representation is not public identity.
- Bits denote code-unit positions. F3 byte addressing remains a different coordinate map, and
  scalar/codepoint views must be derived explicitly.
- Boolean operations, bounded shifts, population/set-bit enumeration, and prefix parity are pure
  operations. Chunked prefix operations must state carry-in/carry-out and prove concatenation
  agreement.
- A classification result separately stamps classifier identity/completeness and carries a vector
  residual for units it did not classify. A plain vector does not acquire an implicit meaning.
- Scalar-boundary violations discovered while turning bits into spans remain vector/harvest
  residue. They do not masquerade as `ClaimSelection` residue.

The carrier has two explicit exits:

1. direct consumption as a peer numerical value or compact structural index; and
2. a named harvest operation that emits ordered offsets/candidates and, only with explicit
   producer/source/rule evidence, may populate a `SpanBatchBuilder`.

The harvest result is the bridge between residual sorts. It does not assert that a code-unit mask
and an occurrence selection have the same basis.

### V1: portable reference and integration, independently available after V0

Land scalar/reference classification and algebra first, with bounded exhaustive cases and random
cross-window/chunk tests. Demonstrate both exits without embedding quote, tokenizer, or NLP meaning
in the carrier. Direct vector work and harvest into existing builders require no K5–K8 type.
Explicit normalization producers may later supply derived masters once K6/K7 origins are
available; that integration does not block V1 and V1 does not create a parallel provenance type.

### V2: accelerated backends, evidence-gated

Add word/SWAR, `Vector<T>`, or architecture-specific paths only for Doccer-measured operations and
input distributions. `MemoryMarshal.Cast` is a layout tool, not a semantic shortcut: endianness,
remainder units, lane carries, surrogate boundaries, and scalar fallback remain explicit.

Every accelerated path must agree differentially with V1, retain the same basis/policy/residual
stamps, and document its runtime fallback. Reapply the Lean burden gate at V0 and before V2.
Activate it only when proof can change the public contract or bounded/property differential
evidence cannot honestly support a claimed universal equivalence. Bit packing alone is not an
automatic activation.

## A lane — measured, contract-preserving performance

This lane is independently available and does not wait for V or K5–K8.
Its measurement rule is a Doccer evidence decision: an alternate backend that promises lower
time/allocation while preserving a frozen result must name the workload on which that statement is
made. It is not inherited from `UndirectedEdgeWalk` or any other ThermoMapper adoption policy.

| Chip | Work | Gate |
|---|---|---|
| A0 | Establish representative dense/sparse selection, graph, and path workloads; record time and allocated bytes for delivered builds. | No “hot path” claim without a named workload and before/after baseline. |
| A1 | Add a word-skipping set-bit walker using `TrailingZeroCount` plus clear-lowest-bit; migrate internal high-frequency loops while preserving ascending ordinals and interface compatibility. | D30 exhaustive masks, 70+-ordinal word boundaries, dense/sparse parity, allocation evidence. |
| A2 | Index admissible edges by start boundary, retain one best successor per boundary, and reconstruct once. | D37's 16,384-problem oracle, checked-score behavior, overflow/refusal cases, tie equivalence, allocation evidence. |
| HPC pattern applications | As V/F implementations land, use span-first destination kernels, operation/worker workspaces, count-prefix-fill layouts, bounded heaps, online accumulators, or hardware-tiered scalar-tail backends where each removes repeated work. | No generic utility layer without a second consumer; each capability owns lifetime, layout, fallback, and differential evidence. |
| Later/F4 | Consider CSR/sweep and static/incremental indexes for a named repeated relation/query workload. | Frozen reference semantics, deterministic ordering, update model, and a separate public-layout decision if any column escapes the assembly. |

A1 and A2 are high-confidence candidates, not already-proven speedups. The per-capability HPC
repertoire is not a chip or framework. D20 numeric-column visibility, public policy objects, and retained
evidence identity stay unchanged unless a later independent contract amends them.

## K6/K7 producer boundary

The transcript correctly connected normalization and alignment to correspondence, but it
collapsed two epistemically different results.

- A producer that performs a transformation—slice, normalization, or materialization—knows how
  output was born and may emit actual K6 origins plus loss/unmapped residue.
- A post-hoc aligner comparing independently supplied texts computes a correspondence hypothesis
  under a named edit model, cost, tie rule, and resource limit. Its trace, ambiguity, and unmatched
  material are evidence; they are not historical provenance by definition.
- An explicit promotion step may treat alignment correspondence as origin only when the caller
  declares the provenance assumption and retains the aligner/policy stamp.

Therefore K6 remains the small declared origin algebra, but F7 is split by dependency:

- **F7a distance and correspondence:** exact/thresholded edit distance, an edit-script or other
  correspondence carrier, ambiguity/unmatched residue, cost/tie/resource policy, and cross-master
  evidence are independently designable. They do not claim historical origin.
- **F7b performed transforms:** normalization or another transform becomes a K6-compatible producer
  of actual origins plus loss once the origin carrier exists.
- **F7c promotion and materialization integration:** treating computed correspondence as assumed
  origin requires an explicit promotion and retains the correspondence policy; realization through
  output pieces composes with K7.

F7a may proceed without K6/K7. F7b/F7c wait for the carrier they produce or consume. None enlarges
the K6 core gate.

## Hashing and adjacent numerical concepts

### Four hash jobs, four contracts

| Job | Honest guarantee | Placement |
|---|---|---|
| Identity commitment | Collision-resistant commitment over a declared raw-unit encoding | Existing in-process D1 SHA-256; F2 must freeze canonical byte order, algorithm, and version before persistence. |
| Material prefilter | Cheap rejection of unequal windows; every positive is verified against code units before equality is claimed | F8a/F8b; no default per-master prefix column without a repeated query, but a standalone span/window kernel needs no K dependency. |
| Similarity signature | Lossy representation whose comparison estimates one named similarity | F8c or adjacent index; feature policy, parameters, basis, algorithm, and version retained. |
| Aggregate sketch | Approximate streaming population statistic with a declared error/merge contract | F8d over a named current or later population; approximate state never becomes `ClaimSelection`. |

F8 now decomposes by capability rather than by one omnibus “hash utility”:

| Subfamily | Capabilities excavated from `hashish` | Doccer dependency and contract |
|---|---|---|
| F8a direct comparison and hash substrate | code-unit/byte hashing, Hamming, exact Jaccard/Dice, cosine, edit distance, normalized-compression-style heuristics | independently available over declared spans/sets/vectors; name whether the result is exact or heuristic plus input domain, zero/empty convention, direction, normalization, bounds, and verification |
| F8b rolling/window and content-defined producers | prefix/rolling fingerprints, repeated-window prefilters, content-defined boundary collectors, dual-resolution chunk comparison | independently available on `TextMaster`/`TextSpan`; specify true recurrence/window, seed/trigger, unit basis, canonical serialization, boundary policy, and exact verification |
| F8c signatures and candidate indexes | MinHash, SimHash, locality digests, banded LSH, bounded top-K | candidate generation only; stamp preprocessing/signature parameters and deterministically rescore or verify under the named downstream operation |
| F8d streaming sketches | Bloom membership, Count-Min frequency, HyperLogLog cardinality | one named key projection/population/error/merge contract; current `SpanBatch`/`ClaimSelection` populations are sufficient for first in-memory witnesses, while fact populations may follow K5 |

There is no K8 dependency in the low-level F8 contracts. Full implementation remains behind the
current K queue by default, but F8a/F8b contract chips or a small current-carrier witness may be
pulled forward. Persistence still depends on F2's portable artifact identity.

### Statistical feature and search views

F9 retains exact counts/histograms, Welford-style online aggregates, IDF/surprisal, saturating
frequency, length normalization, contextual entropy, PMI/PPMI, TF-IDF/sparse embeddings, and
ranked similarity search. They are not one generic `Score` and they are not presumed to be NLP:

- **F9a counted/online views** declare the current population, key projection, address/grain basis,
  smoothing, overflow, and merge rule. Existing batches and selections can witness this now.
- **F9b fitted feature artifacts** declare vocabulary/column identity, population, feature
  projection, OOV/residual policy, window, smoothing, direction, normalization, and immutable
  fitted parameters. Dense and sparse forms are representation choices under one artifact.
- **F9c ranked queries** declare candidate population, exact or approximate score, deterministic
  tie rule, and top-K completeness. A bounded heap and sparse-query/dense-row kernel are
  implementation patterns, not a generic ranking policy.
- BM25-style saturation is a separately named weighting/objective. If applied to paths, it does not
  silently widen `AdditivePathPolicy`.
- PMI over Allen-labeled `ClaimPairView` populations is one plausible domain-neutral recipe;
  claim/fact/origin-specific feature recipes wait only for the carriers they name.

D8/D10 decide kernel versus adjacent package one named measure/artifact at a time. They do not
require an already-wired application, and they do not demote numerical feature machinery merely
because its first donor happened to process text.

## Doccer boundary decisions after excavation

These rows reject a conflation or default, not the broader capability.

| Proposal | D41 disposition |
|---|---|
| Force `RegexOptions.NonBacktracking` | No ambient change; per-rule opt-in already exists and individual lifted regexes may use it when their language permits. |
| Expose numeric `SpanBatch` columns merely to claim SIMD | D20 stands; internal flat/column kernels are available now, and a later real public column consumer may reopen visibility independently. |
| Treat `MemoryMarshal.Cast<char,ulong>` as the UTF-16 SWAR design | No; it is one layout technique under explicit lane, byte-order, remainder, surrogate, and fallback rules. |
| Convert retained policies wholesale to generic structs | No API rewrite; retained objects remain evidence identity. Internal generic struct kernels/devirtualization remain candidates wherever a capability can preserve that public identity. |
| Add a lazy prefix-hash column to every `TextMaster` | No default column. F8b admits standalone/on-demand prefix or rolling indexes and may cache them under an explicit workload/lifetime contract. |
| Call a fast hash an exact-equality oracle | No; verify material after a positive prefilter match. Approximate similarity remains valid for explicitly approximate queries. |
| Treat computed alignment as provenance automatically | No; retain correspondence evidence and require explicit promotion. F7a correspondence remains useful without that promotion. |
| Vendor `hashish` | No wholesale copy; lift capabilities and selected implementation patterns under Doccer contracts. |
| Import ThermoMapper's local implementation gates | No; Doccer owns its sequencing, measurement, assurance, and activation decisions. |
| Activate Lean merely because a bit backend exists | No; reapply Doccer's burden gate at the contract/equivalence boundary. |

## Integrated sequence

~~~mermaid
flowchart LR
    K5A["K5a: fact/support identity"] --> K5B["K5b: positive saturation"] --> K8["K8: integration"]
    K6["K6: declared origin algebra"] --> K7["K7: materialization"] --> K8
    K5A -.->|optional derivation reference| K7

    V0["V0: vector contract"] --> V1["V1: portable reference + two exits"] --> V2["V2: accelerated backends"]
    A0["A0: benchmark/allocation baseline"] --> A1["A1: set-bit walker"]
    A0 --> A2["A2: path recurrence"]
    A0 -.-> AP["Per-capability HPC repertoire"]

    F7A["F7a: distance/correspondence"] --> F7C["F7c: explicit origin promotion"]
    K6 --> F7B["F7b: transform-origin producers"] --> F7C
    K7 --> F7C

    F8A["F8a: direct measures/hash substrate"] --> F8B["F8b: rolling/content-defined producers"]
    F8A --> F8C["F8c: signatures/candidate indexes"]
    F8A --> F8D["F8d: streaming sketches"]

    F9A["F9a: counted/online views"] --> F9B["F9b: fitted feature artifacts"] --> F9C["F9c: ranked queries"]
~~~

V0/V1, A0–A2, F7a, F8a/F8b contract work, and F9a are independently available. K5a remains the
default next chip, so most larger implementations retain a post-K queue position; that is workload
priority, not a fictitious type edge. V2 and other accelerated backends follow their reference
semantics and Doccer-owned evidence. F7b/F7c and claim/fact/origin-specific F8/F9 recipes wait only
for the carriers they actually name.

## Report

D41 was integrated into the decision canon, carrier/assurance registry, architecture workplan,
roadmap, completed-item ledger, and engine README, then amended after owner clarification. The
current K edges remain unchanged. The amendment broadens the transferable HPC/capability inventory,
replaces blanket post-K dependencies with subfamily-specific edges, and moves ThermoMapper-facing
maintenance guidance into its own repository. No Doccer source, public API, package, or harness
count changes in this planning chip. Verification and final commit identifiers are reported in the
task handoff.

## 2026-08-06 D42 formal-assurance amendment

D42 refines, rather than reverses, D41's Lean disposition. The combined V0–V2 assurance entry is
split into the vector carrier, prefix-scan refinement, and harvest bridge. A future packed
`SpanSet` representation and a future D3 suppression bitmap receive separate registry rows
because packed-region representation equality and an occurrence-selected
suppression-to-`SpanSet` query are different claims.

V0/V1 remain independently available and the Lean harness remains deferred. V2 reapplies the
burden gate per concrete backend. A peer vector or bit packing alone does not activate Lean; an
arbitrary-input packed `SpanSet` or suppression backend advertised as interchangeable with
the existing reference presumptively meets optimization pressure unless a smaller complete
certificate or weaker contract closes the gate. The full restart procedure and theorem split are
in the dated D42 addendum to the deferred Lean brief.
