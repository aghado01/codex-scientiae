# Doccer D39 K4c — structural-family implementation closure

Status before implementation: [D38](sol-doccer-k4c-structural-contract-20260805_194514.md)
freezes four separate K4c gates after identifying that the legacy `Laminarizer` fused selection,
validation, and parent projection without exact basis or policy evidence. D37 remains the closed
and independent flat-path sibling. Harness baseline: 1914 checks.

## 1. Delivered surfaces

### Structural validators

- `PackingPolicy` and `PackingView` retain an exact selection, basis, declared window, and policy;
  pairwise material disjointness is required while meeting and gaps remain valid; normalized
  coverage and exact window gaps are visible.
- `CoverPolicy` and `CoverView` retain the same stamp shape under a different invariant: selected
  spans must exactly cover the declared window, while overlap, nesting, meeting, and parallel equal
  geometry remain valid.
- `LaminarFamilyPolicy`, `LaminarGroup`, and `LaminarView` validate an exact no-proper-crossing
  family without filtering. Equal geometries group exact ordinal selections; the view contains no
  parent relation.

### Named laminar admission

`LaminarAdmissionPolicy.PriorityThenGeometry` freezes the D2 default as a named exact object:
equal geometry groups use their maximum member priority, followed by start ascending, end
descending, and first ordinal. `Laminarizer.Admit` returns `LaminarAdmissionResult` with the exact
candidate selection, validated accepted family, crossing residue, and policy object.

The guarantee stamp is `InclusionMaximal`. It is deliberately not maximum-cardinality or
maximum-weight. The harness includes the required high-priority middle interval that blocks two
lower-priority compatible intervals, making the distinction executable.

The former `Laminarizer.Extract`/`LaminarNode` tree path is removed. It could not retain an exact
input population on empty/filtered results and inferred nearest parenthood inside admission. K4c
has one selection-backed semantic path instead of preserving an unstamped compatibility fork.

### Explicit hierarchy

`HierarchyPolicy`, `HierarchyEdge`, and `HierarchyView` retain one exact node selection, window,
policy, and canonical explicit edge relation. Construction refuses missing endpoints, self edges,
duplicate pairs, missing derivation labels, and cycles. It retains disconnected nodes, multiple
parents, and explicitly supplied transitive edges; general construction infers nothing from
geometry.

`LaminarHierarchy.NearestContainers` is a separate named projection over an exact `LaminarView`.
It emits immediate strict-container edges only and uses the policy's lowest-ordinal tie when the
nearest parent geometry has multiple occurrences. The result retains the exact source family.

### Resolution layers and maps

`ResolutionLayerPolicy` and `ResolutionView` name one exact occurrence layer without deriving
resolution from claim kind or `SpanLevel` and without importing a structural-family invariant.
The name avoids D2's historical use of “resolution policy” for conflict admission; that concern is
now concretely `LaminarAdmissionPolicy`.

`ResolutionMapPolicy`, `ResolutionEdge`, and `ResolutionMap` retain explicit compatible-master,
equal-window incidence between exact fine and coarse layer objects. Supplied edges require exact
member endpoints and fine-in-coarse containment; geometry never creates an edge. The three
contracts remain distinct:

- many-to-many `Incidence`, including isolated layer members;
- `FunctionalAggregation`, exactly one target per fine member and at least one member per coarse;
  and
- `ExactAggregation`, additionally requiring normalized incident fine material to equal every
  coarse span.

These are same-master structural relations, not cross-master origins.

## 2. Assurance

The contract harness adds:

- all 1024 subsets of the ten nonempty intervals on five boundaries, checked independently for
  pairwise packing, unit-cell total cover, and alternating-endpoint laminarity;
- all 4096 candidate-mask × binary-priority cases on a six-interval basis, checked against an
  independent greedy oracle plus population, validation, and inclusion-maximality laws;
- nearest-container comparison on every valid laminar subset of the five-boundary carrier;
- all 4096 directed non-self edge subsets on four nodes against an independent transitive DAG
  oracle; and
- all 2048 combinations of three-fine/two-coarse exact layer selections and six incidence-edge
  bits against an independent endpoint-membership oracle.

Direct fixtures cover meeting/gap/overlap/parallel distinctions, empty exact stamps, crossing
refusal, maximal-not-maximum admission, same-start/same-end parent chains, equal-geometry parent
ties, multiple-parent diamonds, cycles, transitive edges, compatible distinct masters,
many-to-many incidence, functional surjection, unequal windows, incompatible masters, duplicate
edges, and an envelope-with-a-hole exact-aggregation refusal.

Harness: 1914→1976 checks, no warnings.

## 3. Lean posture and exit

The K4c gate is reapplied and remains deferred. These are direct finite validators, one transparent
greedy reference policy that promises no optimum, explicit DAG/incidence data, and bounded
differential oracles. No alternate backend, generalized carrier, closure/reduction equivalence,
map-composition law, or global optimum lands.

Reactivate before an optimized/incremental structural backend claims equivalence, a global packing
or laminar optimum is public, hierarchy closure/reduction becomes semantic, resolution-map
composition or coverage preservation becomes load-bearing, or a common cross-family selector is
proposed.

D39 closes all four D38 gates and therefore K4c. Packing, cover, laminar validation/admission,
nearest-container projection, explicit multiple-parent DAGs, and resolution incidence/aggregation
are now exact-basis, policy-stamped public surfaces. K5 fact identity and finite positive saturation
are active next; their existing register/value/metadata identity question remains the gate.
