# Doccer architectural expansion workplan

Living workplan for the many-sorted kernel expansion. This document retains the detailed
architecture and dependency rationale; current cross-arc status and next closure gates are
consolidated in [status-registry.md](status-registry.md). It refines the short queue in
[roadmap.md](roadmap.md); the decision canon remains [decisions.md](decisions.md), and completed
work still moves to [ledger.md](ledger.md).

The evidence base is:

- [the compositional-kernel deep dive](../discussions/sol-doccer-expansion-deep-dive-20260802.md);
- [the expansion review](../discussions/grok-doccer-expansion-review-20260802.md);
- [the chunker-factory expansion](../discussions/grok-doccer-chunking-expansion-20260802.md);
- [the formalization audit and Lean inventory](../discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md);
- [the ICDT 2025 ET close read](../discussions/fable-et-framework-close-read-20260803.md);
- [the post-K4 review](../discussions/opus-doccer-k3k4-review-k5k7-notes.md) and
  [D40 correction](../briefs/sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md),
  as superseded for K5a by the
  [D43 fact/support contract](../briefs/sol-doccer-k5a-contract-20260809_193131.md) and for K5b by
  the [D44 saturation contract](../briefs/sol-doccer-k5b-saturation-contract-20260809_215158.md),
  and for K6 by the
  [D45 origin contract](../briefs/sol-doccer-k6-origin-contract-20260810_001537.md), and for K7 by
  the [materialization read-ahead](../discussions/sol-doccer-k7-materialization-read-ahead-20260810_171743.md)
  and [D47 contract](../briefs/sol-doccer-k7-materialization-contract-20260810_173159.md);
- [the round-2 expansion transcript](../discussions/opus-doccer-expansion-round2.md), its
  [Grok ideation source](../discussions/grok-doccer-expansion-round2-ideation-20260804.md), and the
  [D41 capability excavation](../briefs/sol-doccer-expansion-round2-adjudication-20260806_093159.md);
- [the material-basis/XOR inquiry](../discussions/sol-doccer-material-basis-and-public-composability-20260806_105530.md)
  and [D42 Lean-gate addendum](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md),
  as adjudicated for V0 by the
  [V1 read-ahead](../discussions/sol-doccer-v1-portable-vector-read-ahead-20260810_013729.md) and
  [D46 contract](../briefs/sol-doccer-v0-boolean-vector-unit-mask-contract-20260810_013731.md);
- the implemented contracts in [the engine README](../../../src/doccer/README.md).

## 1. Executive result

The architectural direction survives the deeper literature review:

> Doccer should become a small many-sorted kernel over finite ordered carriers. "Tokenizer
> factory," "chunker factory," "pairing factory," and "rewrite factory" are instruments assembled
> from those sorts and externally supplied domain rules; they are not subclasses of one universal
> parser or transducer abstraction.

The ICDT 2025 extract-transform framework changes one placement in the plan. It is a rigorous
formalization and possible compiled backend for a restricted fixed linear-growth fragment. It is
not the foundation for Doccer's general materialization layer:

- its extensional result is a bag of output strings;
- equal geometry has no occurrence identity;
- its principal equivalence, enumeration, and composition results concern **linear ET**, not
  arbitrary ET or arbitrary polyregular ET;
- it does not retain intermediate documents, support graphs, or output-to-source origins;
- document-supplied rules and data-dependent recursive expansion are outside the model.

Therefore the kernel critical path remains:

~~~text
close value and query carriers
    -> explicit pairing and located composition
    -> structural views and policy-driven selection
       +-> canonical fact/support identity -> positive saturation
       '--> exact-basis origin algebra ------> rewrite plan and materialize
                         optional D43 FactReference joins only at materialization
~~~

Lean is a deferred, burden-triggered rigor lane. The law registry chooses among counterexamples,
finite certificates, C# oracles, external theorems, policy contracts, and Lean proofs. The proof
assistant is activated only when proof pressure can change a public design or protect a nontrivial
equivalence; it does not turn the architecture into a mandatory theorem-prover pipeline.

## 2. Adjudication of the ICDT 2025 close read

### 2.1 What transfers directly

The paper defines three nested levels that must not be conflated:

\[
\begin{aligned}
ET &: \text{multispanner} + \text{partial string function},\\
PolyregularET &: \text{regex multispanner} + \text{polyregular function},\\
LinearET &: \text{regex multispanner} + \text{linear-growth polyregular function}.
\end{aligned}
\]

The strong algorithmic results transfer only with the last profile and its fixed-program
assumptions:

- equivalence with nondeterministic streaming string transducers under bag semantics;
- linear preprocessing and output-linear delay in data complexity;
- effective closure under sequential composition;
- persistent packed enumeration of register valuations.

A future <code>LinearEtPlan</code> capability may license those guarantees. An arbitrary Doccer
adapter, rewrite plan, or dynamically synthesized factory product must not inherit them.

The canonical annotated input word is also a useful normalization precedent: boundary annotations
are ordered deterministically, geometry has one canonical serialization, and the whole input
remains visible to the transform. A Doccer encoding would additionally need master identity,
occurrence IDs, and sidecars for support/origin.

### 2.2 Qualifications to retain in the workplan

The following phrases from the close-read evidence are useful intuitions but not literal transfers.

1. **A multispan tuple is not necessarily one global packing.** Pairwise disjointness is imposed
   separately within each variable. Different variables may overlap or cross. Path, cover, and
   global-admissibility constraints remain Doccer structures.
2. **Bag multiplicity does not individuate runs.** It preserves a count of distinct operational
   runs that emit the same string, not stable run IDs or derivation structure.
3. **Copylessness does not itself supply Doccer origins.** A run can be instrumented with output
   birth events, but constants may be introduced by initial, transition, or final assignments, and
   no canonical copied/transformed/synthetic source-coordinate classification is provided.
4. **Multiref-language concatenation is not located <code>Seq</code>.** It concatenates annotated
   documents and shifts coordinates; located <code>Seq</code> joins edges at one equal boundary
   inside a fixed master.
5. **Garbage-free and ECSA are precedents, not specifications.** Garbage-free is register liveness
   along accepting runs; ECSA is a persistent DAG for register valuations. Neither is already
   Doccer's plan-residue contract or fact/support hypergraph.

### 2.3 Architectural placement

The ET framework belongs here:

~~~text
Doccer semantic plan and evidence
        |
        +-- retain stages, identities, support, origins     default
        |
        '-- prove plan lies in fixed LinearET profile
                -> optional NSST-style compilation
                -> fuse stages only under an explicit
                   evidence/origin preservation contract
~~~

There should be no universal core <code>ETProgram</code> type now. A restricted compiled profile is
an optional backend after Doccer's own result and lineage semantics are stable.

## 3. Factory aspirations mapped to kernel requirements

| Instrument | Existing substrate | Missing intrinsic capability | First bounded witness | Explicit non-promise |
| --- | --- | --- | --- | --- |
| Scoped extractor factory | masters, regions, regex collectors, claims | composable claim selections and extensional result values | current LaTeX/Markdown inventories | full document-spanner compiler |
| Pairing factory | ordered nonempty claims, exact geometry | match-edge result plus identity-bearing fault residue | environments, fences, dollars, braces | syntax repair or semantic parenthood |
| Tokenizer factory | overlapping candidate claims | located edge algebra, paths, partitions, explicit commitment policy | fixed KaTeX/PDF lexical subset | one normative parser strategy |
| Chunker factory | candidates, grouping, laminar view, measures | candidate graph, partition/packing/cover views, stamped costs and constraints | paragraph/sentence budgeted path | semantic scoring invented by the kernel |
| Structural deduction factory | exact joins and pairing | canonical facts, support hypergraph, finite positive saturation | adjacent/nested token derivations | universal grammar DSL at first landing |
| Rewrite/macro factory | slices and rebasing | origin relation, ordered output-piece plan, materialized master, residuals | fixed bounded macro substitutions | unrestricted TeX expansion or confluence |
| Compiled linear ET backend | none required for semantics | profile recognizer/compiler and origin-preserving instrumentation | cached fixed adapter plan | general polyregular or document-defined recursion |

The factory metaphor names a reusable construction recipe. It does not license a
<code>TokenizerFactoryBase</code>, <code>ChunkerFactoryBase</code>, or one catch-all plan class.

## 4. Dependency shape

This is a dependency DAG, not a mandatory runtime pipeline. D12 continues to hold: every landed
carrier is independently usable.

~~~mermaid
flowchart TD
    K0["K0: carrier and law registry"]
    K1A["K1a: AllenRelationSet"]
    K1B["K1b: AllenCompose + oracle"]
    K2A["K2a: ClaimSelection"]
    K2B["K2b: ClaimPairView"]
    K2C["K2c: PairingResult"]
    K3["K3: located algebra"]
    K4A["K4a: flat graph + results"]
    K4B["K4b: flat path selection"]
    K4C["K4c: structural families"]
    K5A["K5a: fact + support identity"]
    K5B["K5b: positive saturation"]
    K6["K6: origin algebra"]
    K7["K7: rewrite plan + Materialize"]
    W["K8: cross-carrier integration"]
    V0["V0: raw vector + UTF-16-mask contract"]
    V1["V1: portable vector/mask + two exits"]
    V2["V2: accelerated vector backends"]
    A0["A0: benchmark/allocation baseline"]
    A1["A1: selection set-bit walker"]
    A2["A2: flat-path recurrence"]
    AP["Per-capability HPC repertoire"]
    F7A["F7a: distance/correspondence"]
    F7B["F7b: transform-origin producers"]
    F7C["F7c: promotion/materialization integration"]
    F8A["F8a: direct measures/hash substrate"]
    F8B["F8b: rolling/content-defined producers"]
    F8C["F8c: signatures/candidate indexes"]
    F8D["F8d: streaming sketches"]
    F9A["F9a: counted/online views"]
    F9B["F9b: fitted feature artifacts"]
    F9C["F9c: ranked queries"]
    Q["Optional QSTR networks"]
    ET["Optional LinearET backend"]

    K0 --> K1A
    K1A --> K1B
    K0 --> K2A
    K1A --> K2B
    K2A --> K2B
    K2B --> K2C
    K2A --> K3
    K3 --> K4A
    K4A --> K4B
    K4A --> K4C
    K2B --> K5A
    K2C --> K5A
    K4A --> K5A
    K5A --> K5B
    K4B --> K6
    K6 --> K7
    K5A -.->|optional D43 FactReference| K7
    K2C --> W
    K4A --> W
    K4B --> W
    K4C --> W
    K5B --> W
    K7 --> W
    K0 -.->|D41/D42/D46 registry addenda| V0
    V0 --> V1
    V1 --> V2
    A0 -.->|evidence gate| V2
    A0 --> A1
    A0 --> A2
    A0 -.-> AP
    K2A -.->|frozen D30 semantics| A1
    K4B -.->|frozen D37 semantics| A2
    F7A --> F7C
    K6 --> F7B
    F7B --> F7C
    K7 --> F7C
    F8A --> F8B
    F8A --> F8C
    F8A --> F8D
    F9A --> F9B
    F9B --> F9C
    K2A -.->|current population witness| F9A
    K1B --> Q
    K7 --> ET
~~~

The DAG records type and design dependencies, not completion priority. D27 keeps K1b ahead of K2 in
the execution queue because finishing the small Allen algebra is cheaper than carrying it half
closed; K2b nevertheless depends only on K1a's relation-set filter, not on the composition table.
Likewise, D33 removes the former K2b-to-K3 type arrow: located geometry uses a master/window and the
candidate graph uses K2a's `ClaimSelection`; completing all of K2 first was execution order, not a
`ClaimPairView` dependency.
K3 and K4a retain an arrow because the graph projects to located geometry, but D33 makes their first
source chip a joint core so the projection lands with the algebra. D35 lands that core, and D36's
K4a result chip shares K3's Boolean geometry closure while retaining graph-ordinal path evidence.
D34 removes the former
K4b-to-K4c arrow for the same reason: both are consumers of K4a, and K4c neither consumes a K4b type
nor waits for a universal selection carrier. K4b remains the default execution priority for the
tokenizer/chunker trajectory and is closed by D37; independent K4c later closes through D38–D39
without acquiring that dependency. D40 applies the same correction to the former K5-to-K6 arrow:
K5 support and K6 origins remain distinct sorts, while K4b already supplies the selected output
evidence needed to design origins honestly. K5a freezes only the narrow optional derivation
reference that K7 may retain; K5b saturation is not a K6 or K7 dependency. The full adjudication
is in the
[K1b–K4 sequencing brief](../briefs/sol-doccer-k1b-k4-resequencing-20260804_184200.md) and the
[joint K3/K4a contract](../briefs/sol-doccer-k3-k4a-joint-contract-20260805_105443.md), as amended
by the [D34 review adjudication](../briefs/sol-doccer-k3-k4a-review-adjudication-20260805_151759.md)
and [D40 correction](../briefs/sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md).

D41 adds V, A, and dependency-split F branches without a type edge into the K critical path. D46
closes V0 as a basisless Boolean vector plus explicit UTF-16 unit-mask wrapper and has now closed
its bounded portable V1 chip before K6 as execution order only. V2 follows only measured reference
semantics. A0–A2 may proceed beside K5–K8 because D30 and D37 already freeze their
observable behavior; the per-capability HPC repertoire applies inside later capabilities, not one
utility framework. F7a is independent while F7b/F7c use K6/K7. F8a/F8b low-level work and F9a current-
population work are independent; fitted/indexed/persisted or fact/origin-specific forms wait only
for their own artifact and carrier inputs. The dotted arrows are semantic constraints or current
witnesses, not invitations to change public carriers. ThermoMapper contributes patterns and
capabilities but no Doccer gating policy. Full adjudication:
[D41 round-2 expansion](../briefs/sol-doccer-expansion-round2-adjudication-20260806_093159.md).

## 5. Cross-cutting tranche gate

Every public tranche closes only when all applicable rows are satisfied.

| Gate | Required evidence |
| --- | --- |
| Carrier | Basis, identity, equality, empties, and compatibility are explicit. |
| Operator | Composition and result sort are named; no law is borrowed from another sort. |
| Residual | Unused, rejected, ambiguous, or unmappable input remains visible where meaningful. |
| Policy | Kernel mechanism and caller-supplied judgment are separated. |
| Reference semantics | A simple implementation exists before acceleration. |
| Representation | Public semantics are independent of a private scalar, word, vector, column, or index layout; any exposed layout is itself an intentional contract. |
| Acceleration, when claimed | A named workload and time/allocation baseline justify the path; every runtime backend preserves the carrier, policy, result, and residual stamps and agrees differentially with the reference. |
| C# contract harness | Positive, boundary, adversarial, and law-oracle cases are green. |
| Lean/theory | A theorem, finite decision certificate, or explicit reason that this is policy rather than algebra is recorded. |
| Witness | At least one bounded adapter recipe demonstrates the operation without donating domain meaning to the kernel. |
| Documentation | Decision canon, status registry, README, roadmap, and ledger agree with the landed state. |

The law registry introduced in K0 records which assurance mechanism owns each claim:

~~~text
Lean theorem
finite exhaustive certificate
C# property/oracle test
deterministic policy contract
external cited theorem
~~~

## 6. Kernel tranches

### K0 — carrier and law registry (closed 2026-08-04)

Closed as D25 in the decision canon. The registry freezes the carrier distinctions and operation
names below, assigns an assurance owner to each load-bearing law, and records a concrete Lean
reactivation trigger wherever proof is deferred. No engine type was added by this definition chip.

Freeze the carrier distinctions:

\[
\begin{aligned}
P_M &= \text{valid boundaries},\\
L_M &= \{(i,j)\mid i\le j\}\quad\text{located extents},\\
I_M &= \{(i,j)\mid i<j\}\quad\text{Allen intervals},\\
C_M &= \text{identity-bearing claim occurrences},\\
F_M &= \text{canonical semantic facts},\\
G_M &= \text{finite grounded positive implications over }F_M,\\
O_{A,B} &= \text{output-to-source atom origins between exact tagged stages}.
\end{aligned}
\]

Reserve unambiguous operation names:

| Operation | Sort and meaning |
| --- | --- |
| <code>AllenCompose</code> | canonical qualitative atom-set upper approximation |
| <code>ConcreteCompose</code> | exact relation composition on one carrier |
| <code>Seq</code> | shared-boundary located composition |
| <code>ComposePairs</code> | exact composition of claim-identity relations |
| <code>Saturate</code> | positive fixed-point fact inference |
| <code>Select</code> | explicit nonmonotone policy execution |
| <code>ComposeOrigins</code> | ordinary output-to-source relation composition over one exact shared middle <code>OriginBasis</code> |
| <code>Materialize</code> | realize a supplied output-piece plan as a new master |

Exit gate:

- diagonal empties belong to \(L_M\), not Allen;
- Allen <code>Equal</code> is identity on \(I_M\), never on claim IDs;
- claim-pair identity is the ordinal diagonal on one frozen batch;
- origin identity is the tagged-atom diagonal on one exact reference-identity `OriginBasis`;
- the formalization audit's corrections are reflected in public contract language;
- the law registry names the assurance medium for each claim and records a concrete reactivation
  trigger wherever Lean is deferred.

### K1 — close the qualitative Allen value layer

Land as two small chips:

1. immutable thirteen-bit <code>AllenRelationSet</code> — **closed as D26 on 2026-08-04**;
2. independently verified canonical composition table — **closed as D28 on 2026-08-04**.

D27 made the second chip a semantic closure rather than a transitional consumer rewrite. D28
lands <code>AllenCompose</code>, the table/oracle boundary, classifier closure, counterexample, and
durable validation filters. D31 subsequently performs K2b's one semantic transition from the
terminal raw-list join to an exact composable pair carrier.

Surface:

- singleton, <code>None</code>, <code>All</code>, and <code>Equal</code>;
- membership and subset;
- Boolean union, intersection, and complement;
- converse;
- explicitly named <code>AllenCompose</code>.

Exit gate — **closed by D28**:

- all thirteen predicates are JEPD over nonempty intervals;
- converse is involutive and agrees with argument reversal;
- <code>Relate</code> satisfies the predicates;
- canonical table laws are checked;
- a separately encoded table equals exhaustive \(D_6\) triad enumeration;
- the finite adjacent-gap counterexample is retained;
- durable validation filters use <code>AllenRelationSet</code> rather than ad hoc hash sets;
- K1b adds no filter-only overload to <code>IntervalJoins.Join</code>; D31 makes it a projection
  backed by <code>ClaimPairView</code> and removes the transient general-set filter.

Not included: empty spans, claim identity, path consistency, generic QSTR descriptors, or
Ghourabi's proof-grouping unions as privileged runtime values.

### K2 — close the claim query algebra

D27 treats K2a, K2b, and K2c as one vertically specified tranche that lands in consecutive,
reviewable chips. D29 closes their common basis, identity, projection, ordering, residue,
reference-composition, and exact-to-qualitative abstraction contracts; D30 lands K2a and D31 lands
K2b against that contract. Joint specification does not mean one monolithic commit.

#### K2a: <code>ClaimSelection</code> — closed by D30

A basis-stamped set of ordinals into one frozen <code>SpanBatch</code>. Earlier research used the
working name <code>ClaimSet</code>; <code>ClaimSelection</code> better distinguishes an
occurrence-level query result from the later set of canonical semantic facts.

Required operations:

- all, none, predicate selection, membership;
- union, intersection, difference, and relative complement;
- canonical ascending-ordinal enumeration;
- explicit geometry/priority-ordered record projection under <code>ClaimOrder</code>, without making
  order part of set equality;
- explicit identity-forgetting <code>Coverage()</code> projection to <code>SpanSet</code>;
- basis compatibility checks.

The basis is the identical frozen batch, not merely a compatible master. Ordinals are batch-local:
two batches over compatible masters still have different ordinal universes.

Persistence is not part of this contract. Ordinals are in-memory occurrence identities; F2 later
decides durable identity.

K2a is not complete as a bare bitset. Predicate selection and the stable set-valued population
operations land against it: grouping, cadence, and suppression accept selections where applicable,
and predicate conveniences may delegate to the same reference path. Existing ordered lookups are
not mechanically changed to return an unordered selection; an ordered record projection remains
explicit query policy.

D30 implements this surface. `ClaimSelection` uses exact frozen-batch reference identity,
validated ordinal/predicate construction, basis-closed Boolean algebra, value equality/hash, and
ascending enumeration. `Records(ClaimOrder)` shares the lookup order implementation;
`Coverage()` explicitly forgets occurrences; grouping, cadence, suppression, and legacy
claim-to-region conveniences delegate through selections. The bounded oracle exhausts all 64
subsets and 4,096 ordered pairs on six claims, with a separate 70-claim word-boundary witness.
Harness 1577→1651; K2a is closed.

#### K2b: <code>ClaimPairView</code> — closed by D31

An exact relation between explicit left and right claim bases.

Required operations:

- construction from exact geometry and an <code>AllenRelationSet</code> filter;
- explicit ordinal-diagonal identity on one exact frozen batch, distinct from the geometric
  <code>Equal</code> filter;
- converse, projection, and semijoin;
- exact outer-pair composition when the middle basis is the identical frozen batch;
- a direct middle-ordinal reference `ComposePairs` implementation and an independently written
  nested relation oracle;
- transparent grouping of middle witnesses for one composition;
- projection of left/right <code>ClaimSelection</code>s.

This is the semantic replacement for <code>IntervalJoins.Join</code>. If the old method is retained
for compatibility, it projects from <code>ClaimPairView</code> and contains no independent join
implementation.

Keep two contracts distinct:

~~~text
ComposePairs
    canonical extensional set of outer ordinal pairs

GroupMiddleWitnesses
    transparent outer-pair -> middle-ordinal query for one composition
~~~

The extensional outer relation is associative. The middle-witness query is not a normalized support
carrier and receives no associativity or bracket-independence claim. A packed witness
representation waits until K5 defines support identity and normalization.

Reference `ComposePairs` is ordinary finite relation composition:

\[
R;S=\{(a,c)\mid\exists b.\ (a,b)\in R\land(b,c)\in S\}.
\]

It deduplicates outer ordinal pairs and never calls `AllenCompose` to generate exact edges. For
the contract and harness, let \(\alpha(R)\) be the Allen-relation image of the actual edges in
\(R\), not the relation filter originally requested at construction. D29 adds the cross-carrier
law:

\[
\alpha(R;S)\subseteq
\alpha(R)\mathbin{\mathrm{AllenCompose}}\alpha(S).
\]

This is a one-way abstraction. Every exact outer edge still requires an actual middle ordinal.
The abstraction forgets correlation between relation atoms and middle identities; the adjacent-gap
counterexample also exposes the finite carrier's missing-intermediate boundary. Together they
refute the converse and forbid using qualitative table membership as evidence that an exact edge
exists. `AllenImage` remains contract notation and a test oracle: the K2b implementation found no
concrete diagnostic or consumer that justified a public surface.

K2b exit gate:

- exact middle-basis acceptance and cross-basis refusals;
- extensional equality with the independent nested relation oracle;
- ordinal-diagonal identity, associativity, converse, projection, and semijoin laws;
- duplicate outer-pair collapse plus complete, ascending middle witnesses;
- per-witness atomic containment and union-level Allen-image inclusion;
- the adjacent-gap non-converse remains executable;
- `IntervalJoins.Join` has one semantic implementation path through `ClaimPairView`.

D31 implements this surface. `ClaimPairView` derives Allen-labeled edges over exact ordered batch
bases; validates arbitrary ordinal construction; supplies the ordinal diagonal, converse,
selection projections, and exact-basis semijoins; and composes by a direct shared-middle ordinal
join. `ClaimPairWitnessView` separately stamps left/middle/right bases and reports complete
ascending middles without support-algebra identity. `IntervalJoins.Join` now accepts
`AllenRelationSet?` and projects `ClaimPairView.Relate`; its independent nested loop is gone.

The bounded harness covers all 16 two-by-two relations, 256 oracle-differential compositions,
4,096 associative triples, and all 3,375 exact middle paths on the six-boundary Allen carrier. The
D29 inclusion, actual-image distinction, middle-correlation loss, and adjacent-gap non-converse
are executable. Harness 1651→1733; K2b is closed and `AllenImage` remains nonpublic.

#### K2c: pairing as the first structural consumer — closed by D32

Pairing was the strongest witnessed missing mechanism; D32 lands it after the small
identity-bearing query carriers so it does not create another terminal bespoke result.

~~~text
PairingResult
  Basis / policy stamp
  MatchEdges          ClaimPairView(open basis, close basis)
  PairedRegions       optional geometry projection
  Faults              selection-backed unary residue + mismatch pair evidence
~~~

Exit gate:

- accepted edges are forward, partial one-to-one, and noncrossing under the declared stack policy;
- caller-supplied role/key compatibility owns delimiter meaning;
- every considered input occurrence is matched or appears in named residue;
- faults retain occurrence IDs and evidence;
- the accepted/fault populations witness the K2 carrier and projection contracts;
- no repair action is performed;
- matching, containment, and parenthood remain separate relations.

D32 implements this surface as `Pairing.Pair` over exact `OpenInput` and `CloseInput` selections
plus a named `PairingPolicy` compatibility object. The combined selected spans must form one
non-overlapping geometric token stream; ambiguous dual roles or overlapping token positions are
refused. Each closer consumes only the stack top: compatible endpoints become `MatchEdges`,
incompatible endpoints become correlated `MismatchedPairs`, empty-stack closers become dangling,
and final stack members become unclosed. Match projections plus exact unary residue are disjoint
complete input partitions. `PairedRegions()` is a separately requested, identity-forgetting
`SpanSet` projection of full delimiter envelopes.

Nested environment and sequential fence witnesses exercise two caller-owned key families,
distinct compatible bases, and normalized geometry. One adversarial run retains dangling,
mismatched, later-matched, and unclosed outcomes simultaneously. An independent abstract stack
oracle agrees on all 5,461 words through length six over two opener and two closer keys; every
result also satisfies exact stamp, category-partition, forward, compatibility, partial one-to-one,
and noncrossing laws. Harness 1733→1779; K2 is closed without repair, hierarchy, a delimiter
vocabulary, or Lean activation.

### K3 — located-relation algebra (core closed by D35)

K3 and K4a are one design tranche. D33 requires the first source chip to land the located algebra,
the minimal candidate graph, and their projection together, then the K4a result layer as a second
reviewable chip. D35 lands the first chip and D36 the second. The core is a basis-stamped,
geometry-only
<code>LocatedRelation</code> over \(L_M\), including diagonal identity extents, plus the minimal graph
projection below. It is a set of located geometry: duplicate extents collapse, and it carries no
claim labels or occurrence references.

Its concrete basis is a compatible <code>TextMaster</code> identity plus one exact validated window.
The window is algebraic state, not metadata: binary operations require equal windows, and the
boundary carrier is every scalar-valid master boundary inside that window. Do not add a generic
<code>BoundaryBasis</code> while this concrete finite chain suffices.

Compatibility on this identity-forgetting carrier is `TextMaster.IsCompatibleWith` value
compatibility. The occurrence-bearing graph side is stricter: it retains one exact frozen
<code>SpanBatch</code> reference through <code>ClaimSelection</code>. The graph projection is the
deliberate identity-forgetting hop between those bases.

Core:

- empty relation and declared-window diagonal identity;
- union and shared-boundary <code>Seq</code>, using the located-family condition
  <code>CanSeq(left,right) := left.End == right.Start</code>;
- the consuming projection and reflexive-transitive geometry reachability;
- injective rebase.

Located-algebra half closed by D35:

- <code>Seq</code> is associative and distributes over union;
- the diagonal is its identity;
- strict consuming edges are acyclic/nilpotent on a finite chain;
- consuming star is a bounded finite union of powers;
- zero-length identity edges are algebraic objects, not token claims;
- equal geometry has one located edge regardless of how many claims project to it;
- <code>TextSlice</code> rebase maps both edges and the declared window and commutes exactly with
  <code>Seq</code> and reachability;
- no generalized map API lands; the deferred contract gives collapsing or range-valued maps only
  the lax inclusion law.

Candidate-graph half closed by D35:

- an exact-batch <code>ClaimSelection</code> source and exact retained window;
- loud refusal of empty claims, out-of-window candidates, different batch references, and
  incompatible projection bases;
- an explicit graph-to-located projection preserving geometry while forgetting ordinals;
- an adversarial parallel-edge witness showing collapse only after projection.

The D35 harness exhausts all 64 relation values, 4,096 compositions, and 262,144 triples on the
three-boundary carrier against independent composition/closure oracles, then adds rebase, refusal,
empty-window, exact-batch, and parallel-projection witnesses. D36 closes the formerly separate
partition, reference-path, segmentation-residual, and token/chunk result gate.

Do not call this a full Boolean relation algebra: ordinary converse leaves the upper-triangular
carrier.

### K4 — flat results, then sibling selection and structure lanes

#### K4a: flat candidate graph and partition results (closed by D35–D36)

Co-designed with K3, the smallest identity-bearing sequential core landed across two gates:

- <code>CandidateRegionGraph</code> — implemented by D35 with explicit
  <code>ToLocatedRelation()</code> projection;
- <code>ReachabilityView</code> — implemented by D36 over the D35 closure;
- <code>PartitionView</code> — implemented by D36 with exact graph and ordinal-path identity;
- <code>SegmentationResult</code> — implemented by D36 as an exclusive success/failure value;
- <code>SegmentationResidual</code> — implemented by D36 with gap and dead-branch evidence.

The graph uses one concrete <code>TextMaster</code>, one validated window, and a
<code>ClaimSelection</code> of nonempty candidate claim ordinals as parallel edges from
<code>Start</code> to <code>End</code>. It owns occurrence identity and exposes an explicit projection
to geometry-only <code>LocatedRelation</code>. Do not introduce a generic address/boundary hierarchy
while this concrete basis suffices.

Graph construction, equality, and all graph-stamped results are reference-strict on the exact
frozen source batch. Located operations use compatible master values plus an equal window. Two
different occurrence graphs may therefore project to the same located value; no graph operation
may silently substitute compatible-batch equality for exact source identity.

The graph is already the packed representation of all alternative paths. Geometry reachability is
implemented once: the graph projects to <code>LocatedRelation</code>, K3 computes the Boolean closure,
and the graph-stamped <code>ReachabilityView</code> delegates to it. Identity-bearing path construction
is a different result operation: it traverses claim ordinals while consulting that closure. Parallel
claims therefore remain distinct even though their geometry projects to one reachable edge.

The reference tranche provides one explicitly named deterministic
<code>FirstOrdinalCompletePath</code> result; it does not enumerate every complete path and does not
spend the policy-bearing <code>Select</code> vocabulary reserved for K4b. At each boundary it chooses
the lowest candidate ordinal whose end can still reach the window end. The result promises one
complete witness when one exists, never maximal munch, minimum cost, or semantic preference.

That determinism is scoped to one exact frozen graph/batch. Ordinals reflect insertion order, so a
recollected or reordered batch is a different occurrence basis and may select another path. K8
retains the exact graph and named policy stamp; it does not claim cross-batch path invariance.

Each result declares its source graph/window and validates its own invariant.

The separately gated D36 K4a-result chip closes with:

- graph-stamped reachability, partition, segmentation result, and segmentation residual values;
- partition adjacency using the same empty-admitting <code>CanSeq</code> endpoint equality as
  located composition, plus disjointness and exact window coverage;
- the named first-ordinal operation and an independent bounded path oracle;
- parallel alternatives, empty window, gap, dead-end, ambiguous-token, and budget-admissible chunk
  witnesses.

Its assurance suite enumerates complete paths independently for all 128 subsets of a seven-edge
basis and separately checks DFS reachability, material gaps, dead branches, exact stamps, and
exclusive result laws. Harness 1834→1874.

<code>CanSeq</code> is not Allen <code>Meets</code>: the located carrier admits diagonal empties while
Allen classification refuses empty intervals. Do not add an unqualified <code>TextSpan.Meets</code>
surface merely to share this sort-specific condition.

Required distinctions:

- partition: ordered, disjoint, gap-free, total cover;
- <code>EnvelopeOf</code>: convex hull;
- <code>ExactCoverageOf</code>: actual covered material.

<code>SpanSet</code> cannot represent partitions because it deliberately merges meeting spans and
forgets claim identity.

An empty window has the coherent zero-edge identity partition. Distinguish a coverage gap from a
connectivity dead end: both block a complete path, but they are different residual evidence.
The tranche closes with both an ambiguous token graph and a **budget-admissible** flat chunk graph,
plus separate gap, dead-end, and empty-window cases. The chunk witness proves only that an external
budget rule can admit candidate edges; costs and preferred-path claims wait for K4b.
D37 subsequently supplies one named additive minimum-cost complete-path contract without changing
the cost-free K4a graph or baseline result.

#### K4b: named flat-path selection execution (closed by D37)

With flat result invariants closed by D36, D37 adds one candidate-graph-specific selection
contract:

~~~text
PathSelectionProblem
  exact source graph and admissible edge basis
  AdditivePathPolicy: named nonnegative Int64 edge costs + unit
  CompletePath feasibility
  LexicographicOrdinal tie policy

PathSelectionResult
  source-graph PartitionView or PathSelectionResidual
  selected / rejected-admissible / hard-excluded ordinals
  score, unit, guarantee, tie, and exact policy stamp
~~~

`AdditivePathPolicy` evaluates caller code exactly once per source-graph candidate and retains the
cost table. Nonnegative costs plus a construction-time Int64 sum bound make every possible path
score representable. `PathSelectionProblem` retains the exact admissible selection and derives an
exact admissible graph for K4a feasibility evidence; exclusions remain distinct from objective
rejections.

`PathSelection.Select` uses the direct descending-boundary DAG recurrence for the globally minimum
sum among complete admissible paths. Equal sums compare full ordinal sequences lexicographically.
The result's score is rechecked against retained edge costs, selected plus rejected equals
admissible, and admissible plus excluded equals the source graph. Failure wraps K4a gap/dead-end
evidence computed on the exact admissible graph.

Flat tokenizer and chunker witnesses come from the same candidate graph:

- tokenizer: explicitly labeled token, token-with-trivia, trivia, and recovery candidates where
  hard admissibility excludes recovery and supplied penalties choose different geometry from
  K4a's first-ordinal baseline;
- chunker: a hard external size budget forms admissibility while separate breakpoint penalties
  choose the minimum-cost complete chunk path.

The independent oracle enumerates every complete path for all 128 admissibility masks crossed with
all 128 binary cost tables on a seven-edge basis (16,384 problems). Direct cases cover exact stamp
refusals, one-shot cost evaluation, negative/overflow refusal, hard exclusions, parallel ties,
gap/dead-end failure, and the empty zero-cost path. Harness 1874→1914.

Do not publish a universal <code>SelectionProblem</code>/<code>SelectionResult</code> merely because
several families choose claims. A common abstraction is extracted only after at least two result
families demonstrate the same basis, feasibility, objective, and result shape; it is acceptable if
they do not. Partial paths, signed/vector objectives, maximum weight, fewest edges, and other tie
rules remain separately named future contracts rather than silent extensions of D37.

#### K4c: additional structural families, hierarchy, and resolution — closed by D38–D39

K4c is a sibling of K4b after K4a, not its dependent. D38 freezes four separate gates and D39
implements them without a type dependency on the path-selection algorithm:

- <code>PackingView</code> validates exact pairwise-disjoint selections inside a declared window;
  meeting and gaps are valid, and exact gaps remain visible;
- <code>CoverView</code> validates exact total-window material while allowing overlap, nesting,
  meeting, and parallel equal geometry;
- <code>LaminarView</code> validates an exact no-proper-crossing selection without filtering or
  parent inference, and equal geometry remains an exact ordinal-backed group;
- <code>Laminarizer.Admit</code> separately runs the named grouped-max-priority greedy policy and
  returns exact accepted/crossing-residue populations under an <code>InclusionMaximal</code>, not
  maximum, guarantee;
- <code>HierarchyView</code> validates explicit evidence-labeled DAG edges, including disconnected
  nodes, multiple parents, and explicit transitive edges, while
  <code>LaminarHierarchy.NearestContainers</code> is the sole containment-derived immediate-parent
  projection and names its lowest-ordinal equal-geometry tie;
- <code>ResolutionView</code> retains a named exact layer independently of claim kind,
  <code>SpanLevel</code>, and budget units; <code>ResolutionMap</code> retains explicit compatible-
  master incidence, functional aggregation, or normalized exact-material aggregation without
  inferring geometry edges or calling same-master membership origin.

The pre-D39 <code>Laminarizer.Extract</code>/<code>LaminarNode</code> path is removed rather than
preserved as an unstamped second implementation. All structural views retain exact selections,
windows, and family-specific policy objects, including empty results. The bounded assurance suite
covers 1,024 structural masks, 4,096 greedy admission problems, every valid bounded nearest-parent
family, 4,096 directed four-node edge sets, and 2,048 resolution endpoint problems. The explicit
middle-versus-two-outers witness proves greedy maximal-not-maximum behavior.

Do not promote document-oriented <code>SpanLevel</code> into the universal grain or resolution
type. K4b and K4c demonstrate repeated stamping vocabulary but not one repeated feasibility,
objective, result, or algorithm shape, so no common selection abstraction is licensed. Full
contract and report: [D38](../briefs/sol-doccer-k4c-structural-contract-20260805_194514.md) and
[D39](../briefs/sol-doccer-k4c-structural-results-20260805_201030.md).

### K5 — occurrences, canonical facts, support, and saturation

D40 splits this lane so identity/support can close before saturation without serializing K6.

~~~text
SpanBatch              existing exact occurrence table
CanonicalFactTable     one identity per semantic fact key
SupportHypergraph      rule application + ordered premise IDs
GroundRule             finite data-only positive implication in FactKey space
SaturationProblem      exact initial support graph + canonical ground rules
SaturationResult       exact problem stamp + newly frozen support graph
SemiringView           optional quotient/evaluation
~~~

#### K5a: canonical fact and support identity (closed 2026-08-09)

The contract is frozen by D43 and its
[superseding brief](../briefs/sol-doccer-k5a-contract-20260809_193131.md). K5a is immutable fact
canonicalization plus supplied support evidence. It introduces no executable rule carrier,
worklist, or fixed-point claim. The carriers are implemented at `src/doccer/Facts/` with the
full exit gate below (harness 1976→2091).

The master-relative key is:

~~~text
FactKey
  required ordinal domain and kind
  immutable ordered TextSpan geometry tuple
  immutable ordered canonical string-value tuple
~~~

Doccer's historical “register” meant a named span of codepoint addresses, or a named family of such
spans. Block/Script/GeneralCategory assignments are classifications derived from membership in
those registers. Their representation remains F-UCD work. The application-level **math channel**
(legacy repository name `math-register`) is unrelated. Neither blocks K5. D40 adds no universal
`Register` column and does not pre-decide F-UCD's carrier.

Compatible master value plus `FactKey` value defines semantic fact identity. Geometry is an
ordered argument tuple rather than one span or a normalized `SpanSet`; zero geometry arguments
and empty located extents are admitted without creating empty claim occurrences. The value tuple
provides explicit framing while leaving domain interpretation, canonical component construction,
and future wire encoding outside the engine. Producer source, priority, level, and collected rule
metadata remain evidence unless an adapter deliberately promotes a value into the named fact key.

`CanonicalFactTable` snapshots proposals, validates geometry, collapses duplicate keys, and uses
one deterministic domain/kind/geometry/value order independent of proposal order. Table value
equality uses compatible masters and the canonical key sequence. A `FactReference` is stricter:
it is one exact fact-table reference plus a validated fact ordinal. It is K7's optional narrow
justification seam and requires no support graph.

`SupportHypergraph` retains one exact fact table, one exact compatible-master `SpanBatch`, and
immutable edges containing a conclusion ordinal, required rule ID, ordered premise ordinals,
ordered parameters, and ordered originating occurrence ordinals. Exact duplicate edges collapse;
alternative supports remain. The fact table is independently usable and facts may have no support.
Empty-premise seeds and cyclic support are representable. K5a validates structure but does not
certify adapter reasoning. A tagged multi-batch occurrence basis,
support-path reference, semiring view, and persistence format remain separate future contracts.

Exit gate:

- equal keys collapse to one fact while every domain, kind, geometry arity/order/value, or value
  component distinction remains semantic;
- canonical fact enumeration and table equality are independent of proposal order;
- all supplied geometry, value, premise, parameter, and occurrence sequences are snapshotted;
- incompatible masters, foreign fact-table references, missing facts, and invalid exact-batch
  occurrence ordinals fail loudly;
- exact duplicate supports collapse while two alternative paths to one conclusion remain visible;
- empty/master-global facts, boundary-valued facts, empty-premise seeds, and cyclic support have
  explicit behavior;
- the manual K4c hierarchy diamond supplies one `Ancestor(a,d)` fact with two support paths without
  executing saturation; and
- `FactReference` remains valid without retaining a `SupportHypergraph`.

#### K5b: finite positive ground saturation (closed 2026-08-09)

D44 and its
[saturation brief](../briefs/sol-doccer-k5b-saturation-contract-20260809_215158.md) replace the
provisional callback/combinator shape with finite data-only ground implications. `GroundRule`
retains one conclusion `FactKey`, required rule ID, ordered premise keys, ordered parameters, and
ordered exact-batch occurrence ordinals. It has no variables, matcher, guard, delegate, evolving
store view, or proposal method. Adapter-side matching may compile to this carrier, but its
correctness and termination are outside K5b.

`SaturationProblem` retains one exact initial `SupportHypergraph` and a canonical snapshotted rule
set. Every initial table fact is a seed, including unsupported facts; initial edges are preserved
evidence rather than executable rules. The finite universe is exactly the union of initial keys and
all premise/conclusion keys named by the finite rule set. Geometry and occurrence ordinals validate
against the initial graph's master and exact occurrence batch.

The positive operator adds a rule conclusion whenever every premise position is already reached.
It is inflationary and monotone, and the finite universe gives one least fixed point independent of
fair worklist order. A zero-premise rule is immediately enabled. Unseeded cycles derive nothing;
reached cycles and self-rules contribute their finite support edges.

Support semantics are complete relative to the frozen program: retain every initial edge and one
edge for every ground rule enabled by the final closure, even if that rule did not first discover
its conclusion. Worklist identity is `FactKey` value. After closure, create a new
`CanonicalFactTable`, remap initial and derived supports to final ordinals, and create a new
`SupportHypergraph` over the same exact occurrence batch. Input `FactReference` values never rebind.

Exit gate:

- rule values, problem inputs, and every supplied sequence are immutable and canonicalized;
- the finite key universe, monotone operator, least fixed point, and strict-addition bound are
  explicit;
- fair rule, seed, initial-support, and agenda orders yield the same final fact and edge sequences;
- every derived fact has support, every enabled alternative support remains, and initial facts may
  remain unsupported;
- zero-arity rules, duplicate premises, disabled keys, self-rules, reachable/unreachable cycles,
  exact duplicate rules, and key-order shifts have explicit behavior;
- final ordinals are assigned only after semantic closure and all initial edges rebase by key;
- the executable four-node K4c diamond derives four direct ancestors and one outer ancestor, with
  `Ancestor(a,d)` represented once and supported through both branches; and
- a direct worklist agrees with an independent bounded repeated-scan/powerset oracle.

The implementation lands all four D44 owners in `src/doccer/Facts/Saturation.cs`. The reference
agenda operates only on `FactKey` values; final support construction remaps every initial edge and
every finally enabled ground rule through one newly frozen canonical table over the original exact
occurrence batch. Direct refusal/snapshot/edge-case tests, all 24 seed × initial-support × rule
permutations, and the executable hierarchy diamond cover the adversarial gate. An independent
closed-superset powerset oracle exhausts all 256 programs over the complete two-fact zero/unary
rule vocabulary and agrees on both fact closure and enabled support. Harness 2091→2324 with zero
build warnings; K5b is closed.

A variable-bearing Horn/Datalog grammar, arbitrary callback carrier, serializable rule IR,
negation, deletion, aggregation, winner/stage policy, proof-tree unfolding, semiring evaluation,
parallel/incremental execution, and persistence remain separate contracts.

### K6 — origin algebra before materialization (closed 2026-08-10)

K6 is a sibling of K5a/K5b after K4b. It does not consume canonical facts or saturation; support
and origin remain different types. D45 freezes the contract in the
[origin brief](../briefs/sol-doccer-k6-origin-contract-20260810_001537.md).

Origin is a finite basis-stamped relation, not a generalized <code>OffsetMap</code>. An exact
reference-identity <code>OriginBasis</code> contains an immutable ordered tuple of unique ordinal
tags and exact <code>TextMaster</code> slots. Its carrier is the tagged disjoint union of the slots'
<code>TextTopology.Atoms</code>. The same or compatible text may occupy two differently tagged slots
without making them the same provenance identity.

D45 uses that basis sort symmetrically at both endpoints:

\[
O_{A,B}\subseteq TaggedAtoms(A)\times TaggedAtoms(B).
\]

A normal materialization still uses a singleton output basis and a possibly multi-source input
basis. The symmetric carrier is the smallest type-closed form for explicitly declared multi-slot
stage composition; it does not imply that one materialization emits several masters or that D47
infers a combined-stage lift.

Direction is fixed: output material to tagged source material. <code>OriginRelation</code> retains
exact output/source basis references and a canonical edge set. <code>Identity(B)</code> is the full
tagged-atom diagonal on that exact basis. For <code>R : A -&gt; B</code> and
<code>S : B -&gt; C</code>, <code>R.ComposeOrigins(S)</code> is ordinary relational composition and
requires <code>ReferenceEquals(R.SourceBasis, S.OutputBasis)</code>. Matching tags, exact masters,
value-equal basis contents, and compatible master values cannot replace that middle object.

Required semantics:

- an output atom may have zero, one, or several source origins; relations may be many-to-many;
- zero origins do not themselves assert synthesis or error—K7 separately requires origin or a
  positive-material synthetic explanation for every output atom;
- exact-relation-stamped span projection returns one <code>SpanSet</code> per source slot, preserves
  disconnected regions, and never silently substitutes a hull or merges compatible slots;
- deletion is plan/change residue or explicit absence, not a fictitious reverse origin;
- an empty span selects no material atoms; a singleton empty output master has zero atoms and an
  empty identity relation while retaining its exact basis;
- copy origin, transformation origin, correspondence, causal derivation, and claim support are
  different types.

Exit gate:

- exact-basis relation equality, tagged-atom identity, and associative <code>ComposeOrigins</code>;
- functional/total origins embed as ordinary relation specializations and composition preserves
  their standard laws;
- compatible or value-identical clone middle bases fail loudly;
- duplicate-compatible tagged source slots and disconnected projection remain distinct;
- <code>TextSlice</code> supplies the exact total injective functional special case and slice chains
  agree with direct rebase only when they reuse the exact middle basis;
- a direct finite implementation agrees with an independent Boolean-matrix oracle on all
  two-atom relations/pairs/triples; and
- birth-event instrumentation from a future NSST backend is only one origin producer.

The reference implementation is landed under `src/doccer/Origins/`. Construction snapshots and
validates exact basis-relative coordinates; direct composition and exact-relation-stamped
projection retain the contract above. The harness exhausts all 16 relations, 256 composable pairs,
and 4,096 triples, and separately covers exact-middle clones, duplicate-compatible slots,
disconnected images, degenerate bases, and scalar-width `TextSlice` chains. Delivered-payload
smoke pins the six public carrier names and their essential signatures (harness 2536→2639; zero
warnings; **K6 closed**).

K6 does not infer retagging, slot substitution, pass-through identity, or DAG flattening. A mixed-
source K7 stage presents a complete relation over its exact middle stage; D47 defers a separately
named parallel/slot-lift constructor until a concrete repeated-plan consumer needs one.

D41 keeps producer epistemics explicit. A stage that performs a transformation, including an
explicit normalization producer, may emit actual origins because it observes the births and
losses. A post-hoc aligner over independently supplied masters instead emits correspondence under
a named edit model, cost/tie policy, resource bound, ambiguity, and unmatched residue. That result
does not become historical provenance merely because its trace has the same pair shape; an
explicit promotion must retain the assumption and policy stamp. K6 closes the declared relation
carrier first. F7a distance/edit-script/correspondence is independently useful and does not build
an origin type; F7b normalization/performed-transform origin production may now target the landed
K6 carrier; the landed K6/K7 carriers now leave F7c explicit promotion/materialization integration
independently available. None is a K6 prerequisite.

### K7 — rewrite plans and <code>Materialize</code> (closed by D47)

D47 closes the contract in the
[materialization brief](../briefs/sol-doccer-k7-materialization-contract-20260810_173159.md). A
`RewritePlan` is an ordered output program, not a patch set: it retains one exact source
`OriginBasis`, a `MaterializationTarget`, and a snapshotted sequence of positive `OutputPiece`
declarations. Pieces carry no output offsets. Declaration order fixes the output, and the engine
validates and realizes that supplied program without choosing what the rewrite means.

~~~text
OutputPieceKind
  Copy | OriginMapped | Synthetic

PieceOrigin
  local output atom ordinal -> plan-source OriginAtom

RewritePlan
  exact source OriginBasis + output target + ordered positive pieces

MaterializationResult
  new output TextMaster + exact singleton output OriginBasis
  exact-plan/output-master-stamped positive piece partition
  stage OriginRelation + per-source-slot unused SpanSet
~~~

Frozen semantics:

- `Copy` derives payload and one-to-one origins from one nonempty scalar-bounded span on the exact
  source-basis slot;
- `OriginMapped` supplies a nonempty literal and canonical piece-local origins covering every
  local topology atom;
- `Synthetic` supplies a nonempty literal plus a required nonblank explanation and has no origin;
- one piece cannot mix origin-bearing and synthetic atoms;
- every adjacent piece boundary remains a scalar boundary after concatenation, so a high/low
  surrogate pair cannot fuse two local atoms across pieces;
- realized pieces are positive, ordered, gap-free, and exactly reconstruct the new master; empty
  output has zero pieces but a new empty master and singleton output basis;
- every output atom has origin edge(s) or belongs to one explicitly synthetic piece;
- `UnusedSources` retains the complement of named source atoms as one exact-master `SpanSet` per
  source slot and does not infer semantic deletion;
- an optional singular exact-table `FactReference` is retained opaquely and does not require K5b,
  supply origins, replace synthesis explanation, or cause support-graph execution; and
- a later stage composes only when its source basis is the exact retained prior output basis.

Composition carries K6 origin edges only. Origin-or-synthetic completeness is local to one exact
result stage; synthetic explanations, derivation references, piece partitions, and unused-source
residue do not flatten through `ComposeOrigins`. Cross-stage audit retains the exact result chain.

Overlapping/repeated source reads are valid. Candidate-edit conflicts, ranking, rejected pieces,
recovery, and patch-to-plan compilation remain producer policy; every final plan piece is emitted
once. Automatic compatible-basis substitution, retagging, pass-through identity, and multi-source
slot lifting are deferred.

The source chip has landed the eight D47 public names under `src/doccer/Materialization/`, direct
plan validation and execution, exact reference/UTF-16/material-shape adversaries, a two-stage
composition fixture including a copied synthetic intermediate, delivered-surface smoke, and an
independent 156-plan census over two source atoms and five piece archetypes. The census covers 430
realized piece positions; the measured harness is 2639→2751 with zero warnings. **K7 is closed.**

Insertion and synthesis create positive output material. Unused input is named result residue,
never a zero-width output piece or `SpanBatch` claim. K6/K7 do not reopen K4's inherited nonempty-
claim law.

<code>OffsetMap</code> then becomes a restricted compressed interface for a single-source monotone
alignment. Its <code>Exact | Range | Unmapped</code> point queries do not define general origins.
Byte addressing remains a separate coordinate map.

### K8 — cross-carrier integration demonstrations

Each carrier already lands with the bounded witness required by the cross-cutting tranche gate.
The expansion is complete only when those witnesses are reassembled into bounded,
non-domain-owning cross-carrier examples:

1. pairing over at least two delimiter families with residue;
2. ambiguous candidate token graph with two complete paths, its exact graph/batch stamp, and an
   explicit selection policy;
3. budgeted flat chunk graph using an adapter-supplied measure and cost;
4. fixed bounded macro substitution producing a new master with composed origins;
5. one recursive/document-supplied expansion orchestrated with an explicit depth/resource limit,
   demonstrating that the policy remains outside the kernel.

These are integration demonstrations, not the first validation of their component contracts and
not durable codex-scientiae adapters unless separately promoted.

## 6A. Dependency-split expansion lanes (D41, amended by D42 and D46)

ThermoMapper is mined here for transferable numerical/HPC patterns and useful capabilities, not
for policy. Donor-local implementation gates do not constrain Doccer. Where a donor implementation
is incomplete, the Doccer lane states the stronger contract the lift must satisfy; repair guidance
for ThermoMapper itself lives in that repository's auxiliary review.

### V0–V2 — Boolean vectors and UTF-16 unit masks

D46 closes V0 by replacing D41's provisional single basis-stamped vector with two carriers:

- `BooleanVector` is a basisless immutable finite bit value. Logical length and bits define
  equality; zero/all values are numerical values rather than interval empties. It owns Boolean
  algebra, ordinal-explicit bounded shifts, population/set-bit enumeration, parity, forward
  inclusive prefix parity, adjacent transitions, and the raw Boolean chunk law. Private word
  packing is neither public identity nor a second backend.
- `Utf16UnitMask` stamps a compatible `TextMaster`, exact in-range numeric code-unit window, and an
  equal-length raw vector. It deliberately admits window edges and bits inside surrogate pairs for
  direct use. Equal-window basis checks, typed prefix continuity, exact classifier stamps, and
  material exits belong here rather than in the raw carrier. The explicit name avoids making
  current UTF-16 `TextMaster` semantics look like a generalized material basis.

Classification retains disjoint known-true and unknown-membership masks. Unknown means the event
bit is unknown, not merely unsupported. The lifted scan propagates uncertainty through the suffix
and carries three-state continuity evidence; the raw scan remains complete and residual-free.

The direct exit enumerates every selected code-unit offset without topology. The scalar-safe
harvest exit admits exactly fully selected topology atoms wholly inside the window, retains every
partial selected atom as boundary residue, keeps classifier unknown membership separate, and
normalizes admitted material to `SpanSet`. Evidence-bearing claim emission validates the whole
compatible-builder request before mutation. A harvest result never equates unit, occurrence, or
K4 residual sorts.

V1 has landed the private-word portable value, obvious ordinal scan, typed UTF-16 wrapper,
classifier/residual result, both exits, an independent per-bit oracle, exhaustive
short/multiword/chunk/surrogate laws, and a test-local byte-backed neutrality probe (harness
2324→2536; zero warnings). It stops before a public word layout, generalized basis, A1, packed
`SpanSet`, suppression bitmap, or domain classifier. D42 keeps carrier, scan, harvest, future
packed-region equivalence, and D3 suppression-query equivalence in separate registry rows.

V2 may add word-cascade/SWAR, <code>Vector&lt;T&gt;</code>, carry-less-multiply, parallel, fused, or
architecture-specific paths only for measured operations. Every backend must agree differentially
with V1 across remainder units, chunk boundaries, surrogate edges, residual zones, poisoned tails,
and runtime fallback paths. A layout technique such as <code>MemoryMarshal.Cast</code> supplies no
semantic or portability shortcut.

### A0–A2 — measured backend work and transfer repertoire

A0 records named dense/sparse selection, graph, and path workloads with elapsed-time and allocated
byte baselines. This is Doccer's evidence rule for its own alternate-backend claims, not a gate
borrowed from ThermoMapper.

- **A1:** walk <code>ClaimSelection</code> words using trailing-zero count and clear-lowest-bit,
  preserving ascending ordinals and the existing interface contract. A normal struct/pattern
  walker is sufficient; ThermoMapper's <code>ref struct</code> is a donor pattern, not a required
  type choice.
- **A2:** group admissible path edges by start boundary, retain score plus one best successor, and
  reconstruct the ordinal path once. At one boundary equal-score alternatives have distinct first
  ordinals, so the D37 full-path lexicographic order reduces to that first ordinal locally.

D30's mask/word-boundary oracle and D37's 16,384-problem optimizer oracle remain the semantic
gates. D20's public column boundary and the retained identity of named policy objects do not move.
The per-capability HPC repertoire includes span-first destination kernels,
count-prefix-fill exact allocation, flat/SoA layouts, operation- or worker-owned scratch,
set/edge-once iteration, bounded top-K heaps, stable/mergeable online reductions, structural RNG
fan-out, and a reference backend paired with differential accelerated or incremental paths. It is
not one generic HPC library. Extract a shared primitive only after two admitted consumers agree on
lifetime, layout, semantics, and evidence.

### F7 — correspondence and derived origins

- **F7a distance/correspondence, independent:** exact and thresholded edit distance, edit scripts
  or another correspondence carrier, ambiguity/unmatched residue, and named cost/tie/resource
  policy. This evidence is useful without claiming provenance.
- **F7b performed transforms, after K6:** normalization or another performed transform may emit
  actual K6 origins plus loss/unmapped residue.
- **F7c promotion/integration, after named carriers:** computed correspondence becomes assumed
  origin only through explicit promotion retaining its assumptions; K7 materialization consumes
  promoted or performed-origin evidence.

### F8 — direct comparison, hashes, indexes, and sketches

- **F8a direct comparison/hash substrate, independent:** code-unit/byte hash kernels, Hamming,
  Jaccard/Dice, cosine, edit distance, and normalized-compression-style measures each say whether
  they are exact or heuristic and name their domain, empty/zero convention, direction,
  normalization, bounds, and verification role.
- **F8b rolling/content-defined producers, independent:** prefix/rolling window fingerprints,
  repeated-material prefilters, and boundary collectors name recurrence/window, algorithm/version,
  seed/trigger, byte/code-unit basis, canonical serialization, and exact boundary verification.
- **F8c signatures/candidate indexes:** MinHash, SimHash, locality digests, LSH, and bounded top-K
  stamp feature preprocessing and parameters; they generate candidates, never proof.
- **F8d streaming sketches:** Bloom, Count-Min, and HyperLogLog-like state declares key projection,
  population, error, saturation, and merge semantics; it never masquerades as exact selection.

D1 identity remains separate. F8a/F8b need no K type; current batches/selections can witness F8c/
F8d in memory, later facts can supply another population, and persisted forms wait for F2.

### F9 — statistical features and ranked views

- **F9a counted/online views, independent:** exact histograms/frequencies and Welford-style
  accumulators over a named current population, key projection, grain, smoothing, overflow, and
  merge rule.
- **F9b fitted feature artifacts:** IDF/surprisal, saturation, length normalization,
  co-occurrence/PMI/PPMI/entropy, and dense/sparse embeddings freeze vocabulary/column identity,
  population, window, smoothing, direction, normalization, and OOV/residual policy.
- **F9c ranked queries:** candidate population, exact/approximate score, deterministic tie rule,
  top-K completeness, and any candidate-index verification are explicit.

D8/D10 decide kernel versus adjacent placement one named capability at a time. Most substantial
F8/F9 implementations remain after the current K queue by priority, not type dependency. F9a and
small F8a/F8b contract/current-carrier witnesses may proceed independently under D14.

## 7. Deferred Lean rigor lane

The harness is not on the active implementation path. Its restart conditions, enhanced design, and
lessons from ThermoMapper are preserved in the
[deferred Lean bootstrap brief](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md).
Until a named obligation crosses that brief's burden-of-proof gate, the law registry uses the
cheapest independent evidence that honestly supports the contract.

D29 identifies the K2 exact-to-qualitative inclusion as a genuine obligation but not a present
Lean activation. D31 now exposes the Doccer-specific carrier plumbing through direct composition,
an independent nested oracle, 3,375 per-witness atomic checks, and bounded property laws; D28
already certifies the atomic Allen triads. Reassess the gate before an indexed, compressed,
incremental, or independent pair backend relies on qualitative summaries for a universal
no-false-negative claim, or if the public contract changes the inclusion to equality.

D43 discharges D40's K5a signature-pressure review without activation. K5a freezes only finite
immutable identity and supplied-support values, covered by direct construction, adversarial
validation, and proposal-permutation tests. It exposes no executable rule carrier and makes no
least-fixed-point claim. D44 then reapplies and discharges the K5b gate under a finite data-only
`GroundRule` carrier: the finite universe and positive operator are explicit, and no callback can
inspect an evolving store. Its first saturation surface remains owned by a direct worklist, an
independent repeated-scan/powerset oracle, rule/seed/support permutations, and the stated monotone
least-fixed-point theorem. Reactivate before a changed variable-bearing/callback carrier or an
alternate, parallel, compressed, or incremental backend claims the same fact and complete-support
semantics.

D42 splits D41's V-lane gate without declaring a present activation, and D46 freezes the first
signatures:

- **Raw-vector signature:** D46 fixes basisless length/bit identity, logical tails, raw operations,
  and private packing; reapply if proof pressure can change that signature or a public/alternate
  word layout claims equivalence.
- **UTF-16-mask signature:** D46 fixes compatible-master/exact-unit-window identity, arbitrary
  in-range unit boundaries, typed continuity, classifier stamps, and residual meanings; reapply
  for a generalized common-basis mask or signature-changing proof pressure.
- **Prefix-scan refinement:** V1 remains reference-owned; reapply for each V2 word/SWAR/SIMD,
  carry-less-multiply, chunked, or fused backend. A complete fixed-width linearity certificate may
  own a kernel more cheaply than Lean; random/bounded tests alone do not prove universal equality.
- **Harvest bridge:** reapply if proof can change boundary/residual shape or a fused implementation
  claims universal soundness and completeness.
- **Packed `SpanSet`:** when a bitmap is proposed as interchangeable with the interval-list
  reference over arbitrary admitted masters, presume optimization-pressure activation unless a
  smaller complete certificate or weakened claim closes the gate.
- **D3 suppression bitmap:** when it becomes a second implementation of `Admitted`/
  `Excluded`, presume optimization-pressure activation of the claim that its region result
  equals `Coverage(Q)`/complement for the same exact suppressor selection \(Q\).

A peer vector or bit packing alone still does not activate Lean. The strong trigger appears when
an alternate representation or query backend claims the same existing semantics.

### L0 — bootstrap only after an activation trigger

- select exactly one load-bearing obligation and name the implementation decision it can change;
- keep stable Doccer module paths and theorem IDs while promotion changes ledger status;
- keep trusted model definitions separate from compiling proof obligations;
- compile every registered module and expose only checked declarations through the proved
  aggregate;
- report assumptions as well as apologies;
- connect the theorem to an independent C# reference law or differential fixture.

The first theorem family follows the implementation pressure that actually activates L0. Current
leading candidates are:

- direct-image relation composition is lax generally and exact under injectivity;
- functional origins embed into relation-valued origins and preserve composition;
- evidence-bearing composition respects a separately defined support normalization;
- a concrete V2 scan backend refines the logical prefix/carry specification;
- a packed `SpanSet` representation is extensionally equal to the interval-list reference; or
- D3 bitmap suppression equals `Coverage(Q)`/complement for one exact suppressor selection.

Allen classification and the canonical table deliberately default to exhaustive executable oracles
and published formalization evidence. They do not justify a Lean bootstrap by themselves.

### Candidate theorem families after activation

| C# tranche | Lean/theory obligation |
| --- | --- |
| K1 | \(D_6\) oracle, weak-composition soundness, six-endpoint normal form |
| K2 | exact relation identity/associativity; witness soundness/completeness; Allen-image composition inclusion and its non-converse |
| K2c | forward, one-to-one, noncrossing matching; match-or-residue partition |
| K3 | located semiring laws, strict-chain path bound, nilpotence, finite star |
| K4a | geometric cut-set/partition equivalence under its fixed-basis hypotheses; identity-bearing path/partition preservation; gap/dead-end distinction |
| K4b | D37's nonnegative additive complete-path minimum is covered by a direct DAG recurrence and 16,384-problem enumeration oracle; reactivate before another backend/generalized objective/partial guarantee |
| K4c | D39's family-specific validators, explicit relations, and inclusion-maximal greedy admission are covered by independent bounded oracles; reactivate before an optimum, alternate backend, hierarchy closure/reduction law, or resolution-map composition/equivalence claim |
| K5a | compatible-master fact-key identity, canonical deduplication/order, exact table/occurrence evidence, immutable support, and alternative-support preservation |
| K5b | D44 finite ground-rule monotonicity, fixed-point termination, key-to-final-ordinal freeze, fair-order independence, and complete enabled support |
| K6 | exact tagged-stage identity, functional-origin embedding, ordinary origin composition, disconnected projection, and exact-middle refusal |
| K7 | D47 ordered-program identity, closed copy/origin-mapped/synthetic posture, scalar-safe positive partition, exact reconstruction, origin-or-synthetic coverage, exact result stage, and per-slot unused-source residue |
| V0 raw vector | basisless length/bit identity, ordinary zero/all values, logical tails, Boolean/shift/population/parity semantics, and representation independence |
| V0 UTF-16 mask | compatible-master/exact-unit-window identity, arbitrary in-range unit boundaries, typed continuity, exact classifier stamps, and narrow unknown-membership semantics |
| V prefix scan | forward inclusive prefix/transition inversion, chunk/carry agreement, logical-tail independence, classifier uncertainty refinement, and V2 backend equivalence |
| V harvest bridge | direct unit offsets plus topology-atom span/claim soundness and completeness, separate scalar-boundary/classifier residue, transactional mutation, and producer-evidence preservation |
| packed `SpanSet` | encode/decode and point-membership extensionality, normalization, and advertised Boolean-operation equivalence to the interval-list reference |
| D3 suppression bitmap | equality of `Excluded` with `Coverage(Q)` and `Admitted` with its complement as `SpanSet` values for the same exact suppressor selection |

Standard library facts should be reused rather than renamed as Doccer theorems unless the wrapper
itself is a public contract.

## 8. Optional branches

### O1 — fixed linear ET compilation

Only after K7:

- define a recognizer for the restricted profile;
- make fixed variable/alphabet/plan assumptions explicit;
- treat compilation cost separately from data complexity;
- instrument output births and prove translation into Doccer origin/support semantics;
- fuse stages only when intermediate identity may be forgotten or preserved by proof.

No promise is made for full polyregular ET or document-defined recursive expansion.

### O2 — qualitative constraint networks

Branch from K1 only when uncertain/disjunctive geometry appears:

- proof-bearing algebraic closure;
- tractable-fragment metadata such as ORD-Horn;
- complete solving only for a demonstrated fragment/consumer.

Known concrete geometry continues to use exact joins and validators.

### O3 — operational acceleration and persistence

- K2/K3 semantics are now frozen; F4 indexing begins only after A0 identifies one measured hot
  query and owning carrier.
- D41's A0 baseline precedes claims that A1/A2 or a later index is faster; A1/A2 preserve D30/D37
  and do not expose D20's numeric columns or rewrite evidence-bearing policies.
- F2 portable artifacts wait for an explicit decision about which occurrence, fact, support, plan,
  and origin identities cross process boundaries, and fix the fingerprint algorithm/version and
  canonical UTF-16 byte order before persisting the current host-endian in-process commitment.
- CLI verbs wait for stable carrier wire forms; provisional DLL-reach adapters continue as
  disposable census instruments.
- K5 now supplies a real support/result structure; ECSA-style packed enumeration remains dormant
  until A0 identifies an actual alternative-support enumeration or storage cost.

## 9. Reconciliation with existing roadmap families

| Existing item | New placement |
| --- | --- |
| Provisional DLL-reach adapters | parallel witness/census lane throughout K0-K8 |
| Pairing candidate | K2c, first structural consumer after small query-carrier closure |
| First durable CLI verbs | after stable carriers and wire identity; no longer the expansion critical path |
| Materialize | K7, no longer an isolated discretionary lift |
| F1 OffsetMap | restricted view after K6/K7; may be pressure-tested earlier |
| F2 portable identity / persisted artifacts | after identity choices across K2, K5, K6, and K7; shaped by the first cross-process consumer |
| F3 byte addressing | separate coordinate-map branch after K6 semantics |
| F4 carrier-specific indexes | measured acceleration after K2/K3 reference semantics and A0 evidence |
| F5 agreement scoring | after K4 selection/result shape |
| F6 Markdown succession | bounded witness during K4/K5, durable adapter after the kernel surface stabilizes |
| V0–V2 vectors/masks | D46 closes V0 and V1 as basisless `BooleanVector` plus explicit `Utf16UnitMask`, classifier/continuity, topology-atom harvest, and evidence-bearing claim emission; V2 only after Doccer-measured evidence and its per-backend D42/D46 gate; packed `SpanSet` and suppression equivalence remain separate future obligations |
| A0–A2 measured backend work | independently available under frozen D30/D37 semantics; HPC patterns apply per capability rather than through a common framework |
| F7 correspondence/derived origins | F7a distance/correspondence independent; F7b requires K6; F7c promotion/materialization integration requires its named K6/K7 carriers |
| F8 direct measures/hash/rolling/signature/index/sketch work | F8a/F8b independent; current populations can witness in-memory F8c/F8d; persisted artifacts after F2; always separate from D1 identity |
| F9 statistical feature/ranked views | F9a independent over current populations; fitted/search work post-K by priority; fact/origin recipes wait only for named carriers; D8/D10 decide engine versus adjacent placement |
| F-UCD | independent fact-data lane; unchanged |

D40 restores historical **register** to its native codepoint-address meaning and decomposes the
stale combined column question. F-UCD owns the registers and Block/Script/GeneralCategory atom
classifications; K5a owns canonical fact-value identity; occurrence/support metadata remains
evidence. The **math channel** is unrelated adapter/application design and creates no Doccer
dependency; `math-register` remains only its legacy repository name pending migration.

## 10. Explicit non-goals

The expansion will not:

- create one untyped <code>Compose</code>;
- make document spanners or ET the whole-kernel ontology;
- use output bags as occurrence identity;
- use <code>SpanSet</code> for token streams or partitions;
- equate matching, containment, and parenthood;
- make current Laminarizer an optimizer by implication;
- build a universal parser/grammar DSL before the relational API is witnessed;
- promise arbitrary macro termination, confluence, or complete TeX semantics;
- collapse proof/support provenance into coordinate origins;
- turn <code>OffsetMap</code> into the universal transform carrier;
- hide intermediate masters by default;
- publish a generic qualitative-calculus framework before a second calculus exists;
- publish a generic measurement-unit hierarchy before concrete costed selection requires one;
- publish a universal selection solver before two structural families demonstrate one contract;
- enumerate every path when the candidate graph already preserves the alternatives compactly.

## 11. Immediate next move

K0 is recorded as D25, K1a as D26, the resequencing boundary as D27, K1b as D28, the joint K2
contract freeze as D29, K2a selection closure as D30, K2b exact-pair closure as D31, K2c strict
stack pairing closure as D32, the joint K3/K4a contract as D33, its peer-review correction as D34,
the joint located/graph core as D35, the flat result closure as D36, additive complete-path
selection as D37, the K4c contract as D38, structural-family closure as D39, the post-K4
coherence/K5–K7 sequencing correction as D40, the round-2 expansion adjudication as D41, the
V-lane formal-assurance split as D42, the K5a fact/support contract as D43, and the finite positive
ground-saturation contract as D44. D45 freezes and implements the exact-stage relation-valued K6
origin contract, D46 freezes the V0 basisless-vector/UTF-16-mask contract after its V1
implementation read-ahead, and D47 freezes and implements exact-plan K7 materialization after its
own read-ahead. K2, K3, all K4 lanes, K5a, K5b, portable V1, K6, and K7 are closed at 2751 checks.
K8 cross-carrier integration is now the active default K chip. D41 records
the round-2 capability excavation without changing type edges: A0–A2, F7a, F8a/F8b contract work,
and F9a current-population work remain independently available. V2 follows reference semantics
and measured differential evidence; F7b/F7c and fact/origin-specific feature recipes now have
their named carriers. Most broader F8/F9 implementation remains post-K execution priority rather
than a K8 type dependency.

D37 reapplies the global-optimality Lean trigger and keeps Lean deferred under one closed finite-DAG
recurrence plus exhaustive differential evidence. D39 separately reapplies the K4c structural gate
and keeps Lean deferred under direct finite validators, explicit relations, a non-optimal greedy
reference policy, and bounded differential evidence. Reapply if K3 adopts a compressed/incremental
closure backend, another K4 backend claims equivalence, generalized objectives/carriers land,
partial paths gain a nontrivial guarantee, structural selection promises an optimum, or hierarchy
closure/reduction or resolution-map composition becomes load-bearing. D43 discharges D40's K5a
review without activating Lean because fact/support canonicalization exposes no executable rule
carrier or fixed-point claim. D44 reapplies and defers the K5b gate because finite data-only ground
rules make the positive operator and termination hypotheses structural. Reapply for a wider rule
carrier or alternate/parallel/incremental/compressed saturation semantics. D42 splits
D41's V-lane gate into carrier signature, prefix-scan refinement, harvest, packed `SpanSet`,
and suppression-query obligations. D46 subdivides and closes the raw-vector and UTF-16-wrapper
signatures for V1 without activating Lean. Reapply per V2 backend; presume
activation when a packed region or suppression backend claims arbitrary-input interchangeability,
unless a smaller complete certificate or weaker contract honestly closes the gate. D45 reapplies
and defers the K6 gate because the first surface is an exact finite relation with a direct
Boolean-matrix oracle. Reapply for a second/compressed/functional backend, stage fusion or
intermediate elision, automatic slot lifting, or a novel K7 multi-source composition guarantee.
D46 separately reapplies the raw-vector, wrapper, scan, and harvest gates and defers them under one
portable implementation plus independent finite oracles. Reapply for signature changes, public
word layout, generalized common-basis masks, V2/fused refinement, or topology-bypassing harvest
that claims the same result. D47 reapplies and defers `K7-MATERIALIZE` because ordered
concatenation, closed piece modes, scalar-boundary validation, direct K6 edge translation, and a
bounded independent plan census own the first reference guarantee. Reapply for an alternate,
streaming, fused, incremental, parallel, or compressed materializer; intermediate elision;
automatic slot lifting; persisted identity; or a non-direct global reconstruction theorem.
