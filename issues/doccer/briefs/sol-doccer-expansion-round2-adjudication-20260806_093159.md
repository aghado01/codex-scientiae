# Doccer expansion round 2 — evidence adjudication and sequence amendment

Runstamp 20260806_093159. Canon at entry: D1–D40; K0–K4 closed; contract harness 1976 checks
green. This is a planning and evidence chip. It changes no Doccer source surface and does not
claim a new performance result.

## Decision

Record D41. Keep the current K critical path unchanged: K5a remains the default next chip; K5b
and K6 are sibling lanes; K7 follows K6; K8 remains the cross-carrier integration close. Add two
independent lanes and three post-K families:

- **V — code-unit vectors:** reserve a low-level, basis-stamped Boolean-vector carrier with direct
  use and explicit harvest exits. V0 contract work is available now; V1 reference implementation
  defaults after K8; V2 word/SWAR/SIMD acceleration follows evidence rather than aspiration.
- **A — measured acceleration:** baseline first, then the set-bit walker and flat-path recurrence
  as independently landable candidates under the frozen D30/D37 semantics. Public column exposure
  and policy representation are not part of this lane.
- **F7 — derived origin and alignment producers; F8 — hashing/signature/sketch contracts; F9 —
  statistical feature views.** These preserve distinctions the transcript blurred and default to
  post-K or adjacent work.

No proposal from the research transcript becomes source work merely because it is attractive.

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

Direct validation covered current Doccer source and the live `D:\aghado01\ThermoMapper` tree:

- `ClaimSelection`, `PathSelection`, `SpanBatch`, `TextMaster`, `PatternRule`, and
  `RegexCollector`;
- ThermoMapper's `UndirectedEdgeWalk`, `CsrGraph`, `Minkowski`, and `PersistenceClearing`; and
- all 22 files under ThermoMapper `src/hashish`, distinguishing useful code, reusable patterns,
  useful concepts, and counterexamples.

## Ownership of the ideas

The transcript mixes owner decisions with assistant-generated elaborations. D41 preserves that
boundary.

| Status | Item |
|---|---|
| Owner direction | Treat Doccer as a growing numerical-computing stack, not a unitary scanner or one-application pipeline. |
| Owner direction | Low-level vector values should support both direct consumption and eventual claim/candidate emission. |
| Owner direction | Vectorization is a missed capability; useful ThermoMapper code, patterns, and concepts should be transferred selectively, not vendored wholesale. |
| Owner direction | Use **codex-scientiae** in full for project-level references. |
| Model proposal requiring adjudication | “One carrier, two exits,” a K0-grade mint, automatic residual projection, and immediate Lean activation. |
| Model proposal requiring adjudication | Public numeric columns, `MemoryMarshal.Cast<char, ulong>` as the general UTF-16 answer, and generic struct policies. |
| Model proposal requiring adjudication | Ambient `RegexOptions.NonBacktracking`, a `TextMaster` prefix-hash column, and computed alignment as origin by definition. |
| Model proposal requiring adjudication | IDF/BM25/entropy/PMI, signatures, and sketches as presumptive engine work. |

The owner direction is adopted. The concrete model proposals below are accepted, narrowed,
deferred, or rejected individually.

## D40 already closed the stale questions

The transcript predates the final D40 amendment. It does not reopen:

- graph value equality on one exact source batch;
- the K5a identity/support and K5b saturation split;
- K5/K6 sibling sequencing and the optional K5a-to-K7 derivation seam;
- K6's exact ordered tagged middle basis;
- positive-material K7 pieces and absence/residue for deletion; or
- Doccer **registers** as codepoint-address spans/families, distinct from the application-level
  **math channel**.

The only sequencing change in D41 is to expose independent work beside the K arc, not to insert a
new prerequisite into it.

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

### ThermoMapper transfer audit

| Donor | Transfer | Limitation retained |
|---|---|---|
| `UndirectedEdgeWalk` | Pattern-based struct enumeration and hot-loop inlining | Its own remarks require a benchmark before replacing fused loops. `ClaimSelection` need not become a `ref struct`; a normal word walker can preserve broader use. |
| `CsrGraph` | Count → prefix sum → exact allocation → fill; stable dense remapping | Public mutable arrays and struct identity are not Doccer precedents. CSR belongs only after a repeated adjacency need. |
| `Minkowski` | Span-first scalar contract with a specialized library path | Floating-point `TensorPrimitives` does not mechanically transfer to branchy integer interval logic. |
| `PersistenceClearing` | Evidence that ThermoMapper mixes optimized and ordinary code | Lists, dictionaries, hash sets, and a sorting lambda remain; “ThermoMapper pattern” is not itself a quality stamp. |
| `hashish/levenshtein` | Trim common affixes, put the shorter dimension in scratch, stackallocate below a threshold, pool above it, swap spans | A distance-only two-row DP discards the trace and cannot by itself supply correspondence or provenance. |
| `hashish/bloom` and bit sketches | Word-packed membership, `PopCount`, leading/trailing-zero primitives | Approximate membership/counting semantics are separate from exact Doccer selections. |
| `hashish/seeded` | Seed-indexed span hashing is a useful primitive shape | Callers would still need explicit domain separation; FNV/SplitMix-style values are not identity commitments, and persisted values require algorithm/version/byte-order contracts. |
| `hashish/ctph` | A negative specimen for careful rolling-hash design | The implementation reinterprets native-endian words for Base64, and its trigger accumulates a prefix rather than maintaining a true evicting window. |
| `hashish/measure` | Illustrates typed measure vocabulary | No `IMeasure<T>` consumer exists in ThermoMapper; generic devirtualization is therefore unproven and does not license policy rewrites. |
| `hashish/tokenizer` | Explicit preprocessing is the correct stage boundary | It returns normalized text without correspondence, which violates Doccer's provenance requirement. |
| IDF/BM25/co-occurrence/statistics | Useful mathematical concepts and some span/alternate-lookup patterns | Population, feature projection, normalization, direction, and policy are part of each contract; the files do not establish engine placement. |
| MinHash/SimHash/TLSH/HLL/Count-Min | Candidate signatures and streaming/index concepts | Implementations are mixed: string allocation, low-byte UTF-16 treatment, multidimensional arrays, and simplified formats prevent wholesale transfer. |

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

### V1: portable reference and integration, post-K default

Land scalar/reference classification and algebra first, with bounded exhaustive cases and random
cross-window/chunk tests. Demonstrate both exits without embedding quote, tokenizer, or NLP meaning
in the carrier. Explicit normalization producers may supply derived masters once K6/K7 origins are
available; V1 does not create a parallel provenance type.

### V2: accelerated backends, evidence-gated

Add word/SWAR, `Vector<T>`, or architecture-specific paths only for measured operations and input
distributions. `MemoryMarshal.Cast` is a layout tool, not a semantic shortcut: endianness,
remainder units, lane carries, surrogate boundaries, and scalar fallback remain explicit.

Every accelerated path must agree differentially with V1, retain the same basis/policy/residual
stamps, and document its runtime fallback. Reapply the Lean burden gate at V0 and before V2.
Activate it only when proof can change the public contract or bounded/property differential
evidence cannot honestly support a claimed universal equivalence. Bit packing alone is not an
automatic activation.

## A lane — measured, contract-preserving performance

This lane is independently available and does not wait for V or K5–K8.

| Chip | Work | Gate |
|---|---|---|
| A0 | Establish representative dense/sparse selection, graph, and path workloads; record time and allocated bytes for delivered builds. | No “hot path” claim without a named workload and before/after baseline. |
| A1 | Add a word-skipping set-bit walker using `TrailingZeroCount` plus clear-lowest-bit; migrate internal high-frequency loops while preserving ascending ordinals and interface compatibility. | D30 exhaustive masks, 70+-ordinal word boundaries, dense/sparse parity, allocation evidence. |
| A2 | Index admissible edges by start boundary, retain one best successor per boundary, and reconstruct once. | D37's 16,384-problem oracle, checked-score behavior, overflow/refusal cases, tie equivalence, allocation evidence. |
| Later/F4 | Consider CSR/sweep indexes, pooled scratch, or vectorized column kernels only after A0/A1/A2 identify a remaining repeated cost. | F4 semantics and a separate public-layout decision if any column must escape the assembly. |

A1 and A2 are high-confidence candidates, not already-proven speedups. D20 numeric-column
visibility, public policy objects, and retained evidence identity stay unchanged.

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

Therefore K6 remains the small declared origin algebra. Normalization becomes a K6-compatible
producer after the carrier exists. General computed alignment is F7 after K7/K8 by default and
does not enlarge the K6 core gate.

## Hashing and adjacent numerical concepts

### Four jobs, four contracts

| Job | Honest guarantee | Placement |
|---|---|---|
| Identity commitment | Collision-resistant commitment over a declared raw-unit encoding | Existing in-process D1 SHA-256; F2 must freeze canonical byte order, algorithm, and version before persistence. |
| Material prefilter | Cheap probabilistic rejection of unequal windows; every positive is verified against code units before equality is claimed | F8; no default `TextMaster` prefix column without a measured repeated query. |
| Similarity signature | Lossy representation whose comparison estimates a named similarity | F8 or adjacent analytics/index package; basis and algorithm/version retained. |
| Aggregate sketch | Approximate streaming population statistic with an error contract | F8/consumer tooling unless a repeated Doccer-native population witnesses admission. |

A rolling or content-defined hash may later drive a domain-neutral boundary collector, but it must
name windowing, seed, trigger, version, UTF-16/byte basis, and stability claim. Hash partitioning
and LSH are candidate-generation accelerations under F4/F8, never proof of equality.

### Statistical feature views

IDF/surprisal, saturating frequency, length normalization, contextual entropy, PMI/PPMI, and
TF-IDF embeddings are retained as F9 specimens, not discarded. They are not one generic `Score`:

- each declares the population, feature projection, window/grain, smoothing, direction, and
  normalization;
- IDF/entropy/co-occurrence may become basis-stamped named views or measures;
- BM25-style saturation is a separate non-additive objective if applied to paths, not a silent
  widening of `AdditivePathPolicy`;
- PMI over Allen-labeled `ClaimPairView` populations is a plausible composition/analytics recipe;
  and
- sparse embeddings and similarity search are an adjacency seam to ThermoMapper-style numerical
  tooling, not evidence that the Doccer kernel owns a model.

The D8/D10 admission test decides eventual placement one named measure at a time.

## Rejected or held proposals

| Proposal | D41 disposition |
|---|---|
| Force `RegexOptions.NonBacktracking` | Reject as ambient policy; callers can opt in now. |
| Expose numeric `SpanBatch` columns for SIMD | Reject absent a public consumer; D20 stands. |
| Treat `MemoryMarshal.Cast<char,ulong>` as the UTF-16 SWAR design | Reject; it is only a representation technique under explicit lane and boundary rules. |
| Convert retained policies to generic structs | Reject; API/evidence identity changes, and the donor pattern has no measured consumer. |
| Add a lazy prefix-hash column to every `TextMaster` | Hold for F8 workload evidence; O(n) memory and probabilistic semantics are not free. |
| Call a fast hash an exact-equality oracle | Reject; verify material after a hash match. |
| Treat computed alignment as provenance automatically | Reject; retain correspondence evidence and require explicit promotion. |
| Vendor `hashish` | Reject; pull only audited code, patterns, or concepts under Doccer contracts. |
| Activate Lean merely because a bit backend exists | Reject; reapply the burden gate at the contract/equivalence boundary. |

## Integrated sequence

~~~mermaid
flowchart LR
    K5A["K5a: fact/support identity"] --> K5B["K5b: positive saturation"] --> K8["K8: integration"]
    K6["K6: declared origin algebra"] --> K7["K7: materialization"] --> K8
    K5A -.->|optional derivation reference| K7

    V0["V0: vector contract"] --> V1["V1: portable reference + two exits"] --> V2["V2: accelerated backends"]
    A0["A0: benchmark/allocation baseline"] --> A1["A1: set-bit walker"]
    A0 --> A2["A2: path recurrence"]

    K8 -.->|default priority, not dependency| V1
    K8 -.->|default priority| F7["F7: derived producers/alignment"]
    K8 -.->|default priority| F8["F8: hashes/signatures/sketches"]
    K8 -.->|default priority| F9["F9: statistical views"]
~~~

V0 and A0–A2 may proceed while the K arc continues. The dotted K8 arrows express scheduling
preference, not type dependencies.

## Report

D41 was integrated into the decision canon, carrier/assurance registry, architecture workplan,
roadmap, completed-item ledger, and engine README. The current K edges were not changed. V0 and
the measured A lane are independently visible; V1/V2 and F7–F9 carry explicit default placement
and admission gates. No Doccer source, public API, package, or harness count changed in this chip.
All local Markdown links across the six touched documents resolve, `git diff --check` is clean,
and the Doccer contract harness remains 1976/1976 green.
