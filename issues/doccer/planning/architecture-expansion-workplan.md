# Doccer architectural expansion workplan

Living workplan for the many-sorted kernel expansion. This document refines the queue in
[roadmap.md](roadmap.md); the decision canon remains [decisions.md](decisions.md), and completed
work still moves to [ledger.md](ledger.md).

The evidence base is:

- [the compositional-kernel deep dive](../discussions/sol-doccer-expansion-deep-dive-20260802.md);
- [the expansion review](../discussions/grok-doccer-expansion-review-20260802.md);
- [the chunker-factory expansion](../discussions/grok-doccer-chunking-expansion-20260802.md);
- [the formalization audit and Lean inventory](../discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md);
- [the ICDT 2025 ET close read](../discussions/fable-et-framework-close-read-20260803.md);
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
    -> canonical facts and support
    -> origin algebra
    -> rewrite plan and materialize
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
    K3["K3: LocatedRelation"]
    K4A["K4a: structural views"]
    K4B["K4b: explicit selection"]
    K5["K5: facts + support + saturation"]
    K6["K6: origin algebra"]
    K7["K7: rewrite plan + Materialize"]
    W["K8: cross-carrier integration"]
    Q["Optional QSTR networks"]
    ET["Optional LinearET backend"]

    K0 --> K1A
    K1A --> K1B
    K0 --> K2A
    K1A --> K2B
    K2A --> K2B
    K2B --> K2C
    K2A --> K3
    K2B --> K3
    K3 --> K4A
    K4A --> K4B
    K2B --> K5
    K2C --> K5
    K4A --> K5
    K4B --> K6
    K5 --> K6
    K6 --> K7
    K2C --> W
    K4A --> W
    K4B --> W
    K5 --> W
    K7 --> W
    K1B --> Q
    K7 --> ET
~~~

The DAG records type and design dependencies, not completion priority. D27 keeps K1b ahead of K2 in
the execution queue because finishing the small Allen algebra is cheaper than carrying it half
closed; K2b nevertheless depends only on K1a's relation-set filter, not on the composition table.
K3 and K4a retain an arrow because the graph projects to located geometry, but they are co-designed
as one tranche so reachability and carrier identity are settled once. Likewise, origin relations
are mathematically definable before selection or facts, but designing them against real selected
output pieces and the support/origin distinction prevents a formally neat but operationally empty
API. The full adjudication is in the
[K1b–K4 sequencing brief](../briefs/sol-doccer-k1b-k4-resequencing-20260804_184200.md).

## 5. Cross-cutting tranche gate

Every public tranche closes only when all applicable rows are satisfied.

| Gate | Required evidence |
| --- | --- |
| Carrier | Basis, identity, equality, empties, and compatibility are explicit. |
| Operator | Composition and result sort are named; no law is borrowed from another sort. |
| Residual | Unused, rejected, ambiguous, or unmappable input remains visible where meaningful. |
| Policy | Kernel mechanism and caller-supplied judgment are separated. |
| Reference semantics | A simple implementation exists before acceleration. |
| C# contract harness | Positive, boundary, adversarial, and law-oracle cases are green. |
| Lean/theory | A theorem, finite decision certificate, or explicit reason that this is policy rather than algebra is recorded. |
| Witness | At least one bounded adapter recipe demonstrates the operation without donating domain meaning to the kernel. |
| Documentation | Decision canon, README, roadmap, and ledger agree with the landed state. |

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
F_M &= \text{later canonical semantic facts},\\
O_{N,M} &= \text{later output-to-source origin relations}.
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
| <code>ComposeOrigins</code> | basis-checked cross-master relational composition |
| <code>Materialize</code> | realize a supplied output-piece plan as a new master |

Exit gate:

- diagonal empties belong to \(L_M\), not Allen;
- Allen <code>Equal</code> is identity on \(I_M\), never on claim IDs;
- claim-pair identity is the ordinal diagonal on one frozen batch;
- origin identity is the atom diagonal between compatible master bases;
- the formalization audit's corrections are reflected in public contract language;
- the law registry names the assurance medium for each claim and records a concrete reactivation
  trigger wherever Lean is deferred.

### K1 — close the qualitative Allen value layer

Land as two small chips:

1. immutable thirteen-bit <code>AllenRelationSet</code> — **closed as D26 on 2026-08-04**;
2. independently verified canonical composition table — **closed as D28 on 2026-08-04**.

D27 made the second chip a semantic closure rather than a transitional consumer rewrite. D28
lands <code>AllenCompose</code>, the table/oracle boundary, classifier closure, counterexample, and
durable validation filters. K2b still owns the one semantic transition from the terminal raw-list
join to an exact composable pair carrier.

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
- K1b adds no filter-only overload to <code>IntervalJoins.Join</code>; K2b retires it or makes it a
  projection backed by <code>ClaimPairView</code>.

Not included: empty spans, claim identity, path consistency, generic QSTR descriptors, or
Ghourabi's proof-grouping unions as privileged runtime values.

### K2 — close the claim query algebra

D27 treats K2a, K2b, and K2c as one vertically specified tranche that lands in consecutive,
reviewable chips. D29 closes their common basis, identity, projection, ordering, residue,
reference-composition, and exact-to-qualitative abstraction contracts; D30 lands K2a against that
contract. Joint specification does not mean one monolithic commit.

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

#### K2b: <code>ClaimPairView</code>

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
exists. `AllenImage` is contract notation and a test oracle; it becomes public surface only if the
K2b implementation brief identifies a concrete diagnostic or consumer.

K2b exit gate:

- exact middle-basis acceptance and cross-basis refusals;
- extensional equality with the independent nested relation oracle;
- ordinal-diagonal identity, associativity, converse, projection, and semijoin laws;
- duplicate outer-pair collapse plus complete, ascending middle witnesses;
- per-witness atomic containment and union-level Allen-image inclusion;
- the adjacent-gap non-converse remains executable;
- `IntervalJoins.Join` has one semantic implementation path through `ClaimPairView`.

#### K2c: pairing as the first structural consumer

Pairing remains the strongest witnessed missing mechanism, but it lands after the small
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

### K3 — located-relation algebra

K3 and K4a are one design tranche, even if they land in separate commits. Add a basis-stamped,
geometry-only <code>LocatedRelation</code> over \(L_M\), including diagonal identity extents. It is a
set of located geometry: duplicate extents collapse, and it carries no claim labels or occurrence
references.

Core:

- empty relation and declared-window diagonal identity;
- union and shared-boundary <code>Seq</code>;
- reachability and consuming closure;
- injective rebase.

Exit gate:

- <code>Seq</code> is associative and distributes over union;
- the diagonal is its identity;
- strict consuming edges are acyclic/nilpotent on a finite chain;
- consuming star is a bounded finite union of powers;
- zero-length identity edges are algebraic objects, not token claims;
- equal geometry has one located edge regardless of how many claims project to it;
- <code>TextSlice</code> rebase commutes exactly with <code>Seq</code>;
- collapsing or range-valued maps receive only the lax inclusion law.

Do not call this a full Boolean relation algebra: ordinary converse leaves the upper-triangular
carrier.

### K4 — structural views before optimizers

#### K4a: flat candidate graph and partition results

Co-designed with K3, start with the smallest identity-bearing sequential core:

- <code>CandidateRegionGraph</code>;
- <code>ReachabilityView</code>;
- <code>PartitionView</code>;
- <code>SegmentationResult</code>;
- <code>SelectionResidual</code>.

The graph uses one concrete <code>TextMaster</code>, one validated window, and a
<code>ClaimSelection</code> of nonempty candidate claim ordinals as parallel edges from
<code>Start</code> to <code>End</code>. It owns occurrence identity and exposes an explicit projection
to geometry-only <code>LocatedRelation</code>. Do not introduce a generic address/boundary hierarchy
while this concrete basis suffices.

The graph is already the packed representation of all alternative paths. The reference tranche
provides reachability and one explicitly named deterministic path result; it does not enumerate
every complete path. Geometry reachability has one reference meaning shared with K3 rather than a
second graph-specific implementation.

Each result declares its source graph/window and validates its own invariant.

Required distinctions:

- partition: ordered, disjoint, gap-free, total cover;
- <code>EnvelopeOf</code>: convex hull;
- <code>ExactCoverageOf</code>: actual covered material.

<code>SpanSet</code> cannot represent partitions because it deliberately merges meeting spans and
forgets claim identity.

An empty window has the coherent zero-edge identity partition. Distinguish a coverage gap from a
connectivity dead end: both block a complete path, but they are different residual evidence.
The tranche closes with both an ambiguous token graph and a budgeted flat chunk graph, so the
located algebra and result residues are pressure-tested before K4b adds optimizers.

#### K4b: named selection execution

Only after result invariants exist, add:

~~~text
SelectionProblem
  candidate basis
  hard admissibility predicates
  externally supplied objective
  deterministic tie policy

SelectionResult
  selected IDs
  rejected alternatives
  residuals / conflicts
  score and policy stamp
~~~

The engine executes but never invents the objective. Inclusion-maximal, maximum-cardinality,
maximum-weight, and lexicographic priority remain different contracts. The current Laminarizer
stays D2's deterministic greedy policy.

Flat tokenizer and chunker witnesses come from the same candidate graph:

- tokenizer: complete path with lexical edge labels and explicit trivia/recovery policy;
- chunker: complete or partial path with adapter-supplied budget and breakpoint costs.

#### K4c: additional structural families, hierarchy, and resolution

After flat views are stable:

- add <code>PackingView</code> for disjoint selections with gaps;
- add <code>CoverView</code> for declared overlap;
- adapt current <code>LaminarView</code> to claim selections;
- derive a nearest-container parent only under an explicit policy inside a laminar family;
- permit explicit multiple-parent hierarchy DAGs;
- keep basis, resolution, kind, and budget unit separate;
- introduce resolution incidence/aggregation maps without calling same-master membership
  cross-master origin.

Do not promote document-oriented <code>SpanLevel</code> into the universal grain or resolution
type.

### K5 — occurrences, canonical facts, support, and saturation

This lane can proceed beside K4 after K2 stabilizes.

~~~text
ClaimOccurrenceTable   observed evidence rows
CanonicalFactTable     one identity per semantic fact key
SupportHypergraph      rule application + ordered premise IDs
SemiringView           optional quotient/evaluation
~~~

The blocking contract is fact identity:

~~~text
FactKey = geometry + kind + adapter-defined value identity
~~~

The open register/value/metadata design blocks this general fact store, but it does not block
K1-K4. Do not freeze a span-only fact key that macro expansion immediately outgrows.

After identity closes, add finite positive worklist saturation.

Exit gate:

- rules are monotone and inflationary over a finite canonical fact universe;
- fair evaluation order yields the same least fixed point;
- repeated derivations add support, not duplicate semantic facts;
- every derived fact has a sound support edge;
- rule ID, ordered premise IDs, parameters, and originating occurrence IDs remain available;
- semiring provenance is derived and may quotient proof structure;
- negation, winner selection, and stage ordering remain explicit orchestration boundaries.

Start with host-language rule combinators. A serializable grammar/rule IR waits for at least two
adapters demonstrating repeated structure.

### K6 — origin algebra before materialization

Origin is a basis-stamped relation, not a generalized <code>OffsetMap</code>:

\[
O_{N,M}\subseteq Atoms(N)\times TaggedAtoms(M_1+\cdots+M_k).
\]

Direction is fixed: output material to tagged source material.

Required semantics:

- an output atom may have zero, one, or several source origins;
- generated material carries an explicit synthetic/plan explanation rather than a fabricated
  source offset;
- span projection may return disconnected source regions and never silently substitutes a hull;
- deletion is plan/change residue or explicit absence, not a fictitious reverse origin;
- copy origin, transformation origin, causal derivation, and claim support are different types.

Exit gate:

- compatible relational identity and associativity;
- functional origins embed in relation-valued origins;
- the embedding preserves identity and composition;
- composition requires the identical tagged middle master/basis;
- <code>TextSlice</code> supplies the injective functional special case;
- birth-event instrumentation from a future NSST backend is only one origin producer.

### K7 — rewrite plans and <code>Materialize</code>

Close D7's final lift only with origins and residue present.

~~~text
OutputPiece
  supplied literal or source-copy instruction
  output extent after assembly
  declared source origins
  optional support/derivation reference

MaterializationResult
  immutable output master
  ordered piece view
  stage origin relation
  residuals
  plan/run identity
~~~

The engine validates and realizes a supplied plan; it does not decide what the rewrite means.

Exit gate:

- pieces form an ordered, gap-free partition of the output master;
- output equals their exact concatenation;
- copied content remains literal source material;
- transformed or synthetic content is explicitly supplied;
- every output atom has declared origins or a synthetic explanation;
- conflicts and unused pieces are refused or reported under a named policy;
- the source remains immutable;
- derivation answers why; origin answers where;
- repeated materializations compose origins through retained intermediate masters.

<code>OffsetMap</code> then becomes a restricted compressed interface for a single-source monotone
alignment. Its <code>Exact | Range | Unmapped</code> point queries do not define general origins.
Byte addressing remains a separate coordinate map.

### K8 — cross-carrier integration demonstrations

Each carrier already lands with the bounded witness required by the cross-cutting tranche gate.
The expansion is complete only when those witnesses are reassembled into bounded,
non-domain-owning cross-carrier examples:

1. pairing over at least two delimiter families with residue;
2. ambiguous candidate token graph with two complete paths and an explicit selection policy;
3. budgeted flat chunk graph using an adapter-supplied measure and cost;
4. fixed bounded macro substitution producing a new master with composed origins;
5. one recursive/document-supplied expansion orchestrated with an explicit depth/resource limit,
   demonstrating that the policy remains outside the kernel.

These are integration demonstrations, not the first validation of their component contracts and
not durable codex-scientiae adapters unless separately promoted.

## 7. Deferred Lean rigor lane

The harness is not on the active implementation path. Its restart conditions, enhanced design, and
lessons from ThermoMapper are preserved in the
[deferred Lean bootstrap brief](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md).
Until a named obligation crosses that brief's burden-of-proof gate, the law registry uses the
cheapest independent evidence that honestly supports the contract.

D29 identifies the K2 exact-to-qualitative inclusion as a genuine obligation but not a present
Lean activation. The reference proof is a direct middle-witness chase, D28 already certifies the
atomic Allen triads, and K2b can expose the Doccer-specific carrier plumbing through reference and
property tests. Reassess the gate before an indexed, compressed, incremental, or independent pair
backend relies on qualitative summaries for a universal no-false-negative claim, or if the public
contract changes the inclusion to equality.

### L0 — bootstrap only after an activation trigger

- select exactly one load-bearing obligation and name the implementation decision it can change;
- keep stable Doccer module paths and theorem IDs while promotion changes ledger status;
- keep trusted model definitions separate from compiling proof obligations;
- compile every registered module and expose only checked declarations through the proved
  aggregate;
- report assumptions as well as apologies;
- connect the theorem to an independent C# reference law or differential fixture.

Candidate first theorem family, if generalized mapping or origin work supplies the trigger:

- direct-image relation composition is lax generally and exact under injectivity;
- functional origins embed into relation-valued origins and preserve composition;
- evidence-bearing composition respects a separately defined support normalization.

Allen classification and the canonical table deliberately default to exhaustive executable oracles
and published formalization evidence. They do not justify a Lean bootstrap by themselves.

### Candidate theorem families after activation

| C# tranche | Lean/theory obligation |
| --- | --- |
| K1 | \(D_6\) oracle, weak-composition soundness, six-endpoint normal form |
| K2 | exact relation identity/associativity; witness soundness/completeness; Allen-image composition inclusion and its non-converse |
| K2c | forward, one-to-one, noncrossing matching; match-or-residue partition |
| K3 | located semiring laws, strict-chain path bound, nilpotence, finite star |
| K4 | cut-set/partition equivalence, path/partition preservation, greedy maximal-not-maximum |
| K5 | finite monotone fixed-point termination and rule-order independence |
| K6-K7 | functional-origin embedding, origin composition, output-piece partition and reconstruction |

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

- F4 indexing begins only after K2/K3 semantics freeze.
- F2 persistence waits for an explicit decision about which occurrence, fact, support, plan, and
  origin identities cross process boundaries.
- CLI verbs wait for stable carrier wire forms; provisional DLL-reach adapters continue as
  disposable census instruments.
- ECSA-style packed enumeration is considered only after K5 has a real support/result structure.

## 9. Reconciliation with existing roadmap families

| Existing item | New placement |
| --- | --- |
| Provisional DLL-reach adapters | parallel witness/census lane throughout K0-K8 |
| Pairing candidate | K2c, first structural consumer after small query-carrier closure |
| First durable CLI verbs | after stable carriers and wire identity; no longer the expansion critical path |
| Materialize | K7, no longer an isolated discretionary lift |
| F1 OffsetMap | restricted view after K6/K7; may be pressure-tested earlier |
| F2 persistence | after identity choices across K2, K5, K6, and K7 |
| F3 byte addressing | separate coordinate-map branch after K6 semantics |
| F4 indexed joins | acceleration after K2/K3 reference semantics |
| F5 agreement scoring | after K4 selection/result shape |
| F6 Markdown succession | bounded witness during K4/K5, durable adapter after the kernel surface stabilizes |
| F-UCD | independent fact-data lane; unchanged |

The open register/value/metadata question blocks K5's general fact identity. It does **not** block
Allen relation sets, claim selections, exact pair relations, pairing, located composition, or flat
structural views.

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
- enumerate every path when the candidate graph already preserves the alternatives compactly.

## 11. Immediate next move

K0 is recorded as D25, K1a as D26, the resequencing boundary as D27, K1b as D28, the joint K2
contract freeze as D29, and K2a selection closure as D30. The next implementation chip is K2b:
land the exact pair carrier, direct reference `ComposePairs`, executable Allen-image bridge, and
the one terminal-join transition. K2c follows with pairing and complete residue. Do not insert an
unrelated tranche between these chips.

The D29 bridge did not activate Lean. Apply the deferred gate only if implementation pressure
changes its direction, basis hypotheses, public abstraction, or assurance burden as described in
the K2 contract brief.
