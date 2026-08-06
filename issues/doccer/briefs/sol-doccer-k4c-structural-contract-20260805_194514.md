# Doccer D38 K4c — structural-family contract and chip gates

Status before implementation: D37 closes K4b at 1914 checks. K4c is its independent sibling over
the exact K4a occurrence basis. The roadmap names packing, cover, laminar, hierarchy, and
resolution surfaces, but does not yet freeze their complete APIs or distinguish validation from
admission and projection closely enough for source work.

Inputs:

- [D34 K3/K4a review adjudication](sol-doccer-k3-k4a-review-adjudication-20260805_151759.md);
- [D37 K4b additive path closure](sol-doccer-k4b-additive-path-selection-20260805_191324.md);
- [architecture expansion workplan](../planning/architecture-expansion-workplan.md); and
- the existing unstamped [`Laminarizer`](../../../src/doccer/Algebra/LaminarView.cs).

## 1. Course correction and segmentation

K4c is not one generic selector. It closes through four distinct structural gates:

~~~text
K4c1 validators
  PackingView      disjoint exact selection inside a window; gaps allowed
  CoverView        exact total window cover; overlaps allowed
  LaminarView      exact no-crossing selection; nesting/disjointness allowed

K4c2 admission
  Laminarizer.Admit
  named greedy policy + accepted family + crossing residue

K4c3 parenthood
  LaminarHierarchy.NearestContainers under an explicit policy
  HierarchyView over explicitly supplied DAG edges, including multiple parents

K4c4 resolution
  ResolutionView   named exact occurrence layer
  ResolutionMap    explicit same-master incidence or aggregation relation
~~~

These gates may land consecutively in one source tranche, but their types and invariants remain
separate. None consumes `PathSelectionProblem`, `PathSelectionResult`, or the K4b recurrence. No
universal `SelectionProblem`, `StructuralView`, or common policy interface is extracted merely to
remove repeated `Name` properties.

The legacy `Laminarizer.Extract` surface is not preserved as a second semantic path. It currently
fuses predicate filtering, equal-geometry grouping, greedy admission, validation, and nearest-parent
inference while retaining neither an exact input selection nor a policy/basis stamp. K4c replaces
that path with the separated operations below.

## 2. Exact structural validators

Every validator receives and retains one exact `ClaimSelection`, an exact declared `TextSpan`
window on its basis master, and its family-specific named policy object. Every selected span must
be contained by that window. Empty selections and empty windows retain the same exact basis and
policy stamps as nonempty views.

### 2.1 Packing

`PackingView.Create(selection, window, policy)` accepts exactly when every two selected occurrence
spans are disjoint. Meeting spans and material gaps are valid. Crossing spans, containment, and
parallel equal-geometry occurrences are invalid because each pair shares material. It retains:

- `Selection`, `Basis`, `Master`, `Window`, and the exact `PackingPolicy` object;
- normalized identity-forgetting `Coverage`; and
- exact material `Gaps` inside the declared window.

It performs validation only; it neither deletes conflicts nor chooses a packing.

### 2.2 Cover

`CoverView.Create(selection, window, policy)` accepts exactly when the selected spans are contained
by and collectively cover every position of the declared window. Overlap, nesting, parallel equal
geometry, and meeting are allowed. An overlap-heavy family whose summed lengths exceed the window
still fails if any material gap remains. Only the empty selection covers an empty window.

`CoverView` retains the exact input and policy plus normalized coverage. It is not a partition:
ordinal identity and overlap remain in `Selection`, and it does not promise ordering or unique
membership.

### 2.3 Laminar family

`LaminarView.Create(selection, window, policy)` validates the selection without filtering it.
Every two selected spans must avoid proper crossing; disjoint, meeting, nested, and equal geometry
are valid. Equal geometries are exposed as `LaminarGroup` values whose `Members` remain exact
ordinal selections on the source basis. Groups are ordered by start ascending, end descending,
then first ordinal. The view retains exact selection/window/policy stamps and normalized coverage.

The validator contains no parent edges. Laminar containment makes a nearest geometry definable,
but parenthood is still a separate named projection and equal-geometry occurrences require an
explicit tie policy.

## 3. Named greedy laminar admission

`LaminarAdmissionPolicy.PriorityThenGeometry(name, familyPolicy)` freezes the existing D2 default:

1. group equal geometry and use the maximum member priority;
2. group priority descending;
3. start ascending, end descending, then first ordinal; and
4. admit a group exactly when it crosses no already admitted group.

`Laminarizer.Admit(candidates, window, policy)` returns `LaminarAdmissionResult` retaining the exact
candidate selection and policy object, a validated `LaminarView` over the admitted occurrences,
and an exact crossing-residue selection. Accepted and residue are disjoint and their union is the
input candidate selection. Equal-geometry groups are admitted or rejected whole.

The guarantee is deterministic **inclusion-maximality**, not maximum cardinality, maximum weight,
or an approximation ratio. Every rejected geometry crosses a retained geometry, so no rejected
group can be added to the result. The required negative certificate ranks one crossing middle span
above two mutually compatible outer spans: greedy retains one although a two-group laminar family
exists.

## 4. Explicit hierarchy and nearest-container projection

`HierarchyView.Create(nodes, window, policy, edges)` retains an exact node selection and explicitly
supplied directed `HierarchyEdge(childOrdinal, parentOrdinal, derivation)` values. It validates:

- both endpoints belong to the exact node selection;
- self edges and duplicate child/parent pairs are refused;
- every derivation label is present; and
- the complete directed relation is acyclic.

Disconnected nodes, multiple parents, and explicitly supplied transitive edges are retained.
General hierarchy construction does not infer edges from containment and does not require a
laminar node family.

`LaminarHierarchy.NearestContainers(family, policy)` is the one containment-derived projection.
For every non-root occurrence it chooses the nearest strict container geometry in the exact
laminar family; when several occurrences share that parent geometry, the named policy's
lowest-ordinal tie rule chooses one. It returns only immediate edges, retains the exact laminar
source and policy stamp, and never claims occurrence-level uniqueness without that tie rule.

## 5. Resolution layers and same-master incidence

`ResolutionView.Create(selection, window, layerPolicy)` gives one exact occurrence population a
named `ResolutionLayerPolicy` stamp. It imposes no packing, cover, partition, or laminar invariant;
callers retain those separately when applicable. The name is not derived from claim `Kind` or
`SpanLevel`, and no budget unit enters this carrier.

`ResolutionMap.Create(fine, coarse, policy, edges)` retains both exact layer objects and explicit
`ResolutionEdge(fineOrdinal, coarseOrdinal)` incidence. The layer masters must be compatible and
their declared windows equal. Every endpoint must belong to its layer, every fine span must be
contained by its coarse span, and duplicate edges are refused. No edge is inferred from geometry.

Three named map contracts remain distinct:

- `Incidence`: an explicit many-to-many relation; isolated members are allowed;
- `FunctionalAggregation`: every fine member has exactly one coarse target and every coarse member
  receives at least one fine member; and
- `ExactAggregation`: functional aggregation plus the incident fine material exactly covers each
  coarse occurrence span.

Exact aggregation compares normalized material, not envelopes or summed lengths. These are
same-master structural relations, not K6 cross-master origins. No map composition, transitive
closure, or refinement-lattice law lands.

## 6. Assurance and Lean posture

Construction-time checks are paired with independent bounded oracles:

- all 1,024 subsets of the ten nonempty intervals on five boundaries for packing, total cover, and
  laminar validation;
- all 4,096 candidate-mask × binary-priority problems on a six-interval basis for greedy admission,
  plus population and inclusion-maximality laws and the maximal-not-maximum certificate;
- nearest-container comparison over every valid bounded laminar family;
- all 4,096 directed non-self edge subsets on four nodes against an independent DAG oracle; and
- bounded fine/coarse selection and incidence masks plus direct functional/exact-aggregation
  adversaries.

Direct cases cover empty exact stamps, meeting/gap/overlap/equal-geometry distinctions, outside-
window and exact-basis refusal, multiple-parent diamonds, cycles, explicit transitive edges,
many-to-many incidence, incompatible masters, and envelope-with-a-hole aggregation failure.

Lean remains deferred. The validators are finite definitions, greedy admission claims no optimum,
hierarchy edges are explicit, and no alternate backend claims equivalence. Reapply before a global
packing/laminar optimum, optimized or incremental backend, generalized structural carrier,
transitive reduction/closure equivalence, resolution-map composition law, or coverage-preserving
aggregation theorem becomes load-bearing.

## 7. Non-goals and exit gate

K4c adds no universal selection carrier, K4b dependency, optimal laminarizer, inferred general
parenthood, hierarchy closure/reduction, `SpanLevel`-as-resolution, generic boundary basis,
measurement/budget abstraction, cross-master origin, persistence, wire identity, or Lean code.

K4c closes only when all four gates above are implemented, independently tested, present in the
delivered-assembly smoke surface, and reflected in the canon/roadmap/README. Until then the active
sub-gate must be named rather than calling the whole lane complete.

---

## Report

Follow-on [D39](sol-doccer-k4c-structural-results-20260805_201030.md) closes all four gates with the
separate validators, named inclusion-maximal admission, explicit/nearest hierarchy surfaces, and
resolution incidence/aggregation maps specified above. Independent bounded oracles and direct
adversaries raise the harness from 1914 to 1976 checks. K4c is closed; K5 is active next.

Follow-on [D40](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) uses K4c's
explicit multiple-parent diamond as K5b's bounded saturation witness: two ancestor paths must yield
one canonical fact with two support edges under rule-order permutations. K5a/K5b and K6 are sibling
lanes toward K7. Harness remains 1976.
