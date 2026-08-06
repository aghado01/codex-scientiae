# Doccer joint K3/K4a contract brief — located geometry and identity-bearing flat paths

Runstamp 20260805_105443. Canon at entry: D1–D32; K2 closed; contract harness 1779 checks
green. This is a planning contract freeze, not an engine chip. It executes the joint-design gate
left by the
[D27 sequencing adjudication](sol-doccer-k1b-k4-resequencing-20260804_184200.md) after reading
through K3, K4a, K4b, and K4c as one trajectory rather than accepting their earlier internal chip
boundaries by default.

Inputs:

- [architecture expansion workplan](../planning/architecture-expansion-workplan.md);
- [decision and assurance registry](../planning/decisions.md);
- [deferred Lean rigor gate](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md);
- [formalism audit](../discussions/sol-doccer-formalisms-lean-20260803.md);
- [tokenizer/chunker deep dive](../discussions/sol-doccer-expansion-deep-dive-20260802.md);
- existing [`TextSlice`](../../../src/doccer/Core/TextSlice.cs),
  [`SpanBatch`](../../../src/doccer/Core/SpanBatch.cs), and
  [`LaminarView`](../../../src/doccer/Algebra/LaminarView.cs) contracts.

## 1. Disposition

Keep the macro-order but refine the source chips:

~~~text
D33  joint contract freeze
  -> K3/K4a-core
       LocatedRelation + CandidateRegionGraph + explicit projection
  -> K4a-results
       shared geometry reachability + identity-bearing partition/path results
       + gap/dead-end evidence + bounded witnesses
       |\
       | -> K4b-flat
       |    named flat-path selection problems and executors
       |    (default execution priority)
       |
       -> K4c
            packing, cover, laminar-family, hierarchy, and resolution views
            + their family-specific policies
  -> common selection abstraction only if repeated contracts justify one
~~~

`LocatedRelation` and the minimal `CandidateRegionGraph` projection land in one joint core source
chip. That is the smallest reviewable unit satisfying D27: the pure algebra is not left without its
operational projection witness, and the graph is not allowed to invent a second geometry meaning.
The result layer then lands separately because reachability diagnostics, partition validation,
reference path construction, and adversarial witnesses form a coherent larger surface of their own.

The dependency DAG also drops the former K2b-to-K3 type arrow. Located geometry depends on a
master/window and the graph on K2a's `ClaimSelection`; K2b was completed first by execution order,
not because `LocatedRelation` or the candidate graph consumes `ClaimPairView`.

This is a refinement rather than a reversal. Flat path invariants still precede policy-bearing
flat selection, and K4a's basis/result semantics precede both later lanes. D34 corrects the former
K4b-to-K4c dependency: K4b remains the default execution priority for the active tokenizer/chunker
trajectory, but K4c is an independently available sibling once K4a closes. What changes in D33 is
the meaning of shared reachability and the amount of genericity permitted in K4b.

## 2. Located basis and value identity

### 2.1 Concrete basis

A `LocatedRelation` is stamped by:

~~~text
LocatedBasis = compatible TextMaster coordinate identity + exact TextSpan Window
~~~

The window is part of the algebraic basis, not diagnostic metadata. For a master `M` and validated
window `W`, its boundary carrier is every scalar-valid `TextMaster` boundary in `W`, including both
window endpoints. A located edge is a `TextSpan` contained in `W`; empty extents are admitted.

Binary operations require compatible masters and exactly equal windows. They never silently take
the intersection, union, or hull of two bases. Canonical enumeration is geometry order and duplicate
extents collapse. There is no claim label, occurrence ordinal, producer, cost, or path identity on
this carrier.

“Compatible” is value compatibility in the `TextMaster.IsCompatibleWith` sense, not object
reference identity. This is deliberately weaker than the graph side: occurrence-bearing graph and
result operations retain one exact frozen `SpanBatch` through `ClaimSelection`. The explicit
graph-to-located projection is the one licensed hop from exact occurrence identity to compatible
geometry identity.

No generic `BoundaryBasis` type is introduced. `(TextMaster, Window)` supplies the concrete finite
chain needed by the first implementation. A reusable address hierarchy waits for a second real
coordinate family.

### 2.2 Empty and identity

- `Empty(M,W)` contains no edges.
- `Identity(M,W)` denotes every diagonal extent `[p,p)` for scalar-valid `p` in `W`.
- The public semantics are the complete declared-window diagonal even if an implementation stores
  it implicitly to preserve D12's scale-to-what-is-touched posture.
- Diagonal extents are algebraic identity objects. They are never manufactured as `SpanClaim`
  tokens; `SpanBatch` continues to reject empty claims.

Using the whole parent master as the identity after a slice rebase would break the exact rebase law.
The exact window stamp is therefore load-bearing.

## 3. Located operators and rebase

The K3 reference surface supplies:

- union on one exact located basis;
- shared-boundary `Seq`;
- the consuming projection `Start < End`;
- reflexive-transitive geometry reachability: declared-window identity plus the finite closure of
  consuming edges;
- exact `TextSlice` rebase.

For relations `A` and `B` on the same basis:

\[
A\mathbin{\mathrm{Seq}}B
=
\{(i,k)\mid\exists j.\ (i,j)\in A\land(j,k)\in B\}.
\]

The shared-boundary predicate is the located-family condition
`CanSeq(left,right) := left.End == right.Start`. `LocatedRelation.Seq` and the later
`PartitionView` reuse it. It admits diagonal empty located extents and therefore is not the Allen
`Meets` atom, which is defined only for nonempty intervals; no unqualified `TextSpan.Meets` API is
implied.

`Seq` is associative, distributes over union, and has the declared-window diagonal identity.
Strictly consuming edges are acyclic on the finite boundary chain; their closure is a bounded union
of powers. Adding an arbitrary subset of diagonal edges does not change Boolean reachability beyond
the declared identity, although such edges would matter to later provenance/path enumeration and
therefore remain absent from ordinary claims.

`TextSlice` maps both relation edges and the declared window. Child-to-parent rebase is total and
commutes exactly with union, `Seq`, and reachability. Parent-to-child is partial and loud unless the
relation's whole window lies within the slice. K3 does not add a generic collapsing or range-valued
map API merely to exhibit the known lax law. That law remains in the assurance ledger for F1/K6:

\[
f_*(R\mathbin{\mathrm{Seq}}S)
\subseteq
f_*R\mathbin{\mathrm{Seq}}f_*S,
\]

with equality under injectivity.

## 4. Candidate graph and the projection boundary

A `CandidateRegionGraph` owns:

~~~text
Source       exact frozen SpanBatch, through ClaimSelection
Candidates   exact ClaimSelection on Source
Window       validated TextSpan on Source.Master
Edges        selected nonempty claim ordinals, Start -> End
~~~

Every selected claim must lie wholly within the window. Failure is loud; graph construction does
not clip, silently filter, or expand the window. Parallel ordinals with equal geometry remain
different edges. An empty window admits only the empty candidate selection.

The graph exposes one explicit identity-forgetting projection to `LocatedRelation` on the same
master/window. Equal geometries collapse at exactly that call. Projection is not graph equality and
cannot recover path alternatives.

Graph construction and graph/result operations remain reference-strict on the exact source batch;
two graphs built from different batch objects are different bases even if their records and masters
are value-compatible. Their located projections may nevertheless compare equal when master values,
windows, and projected geometry agree. Projection makes that weakening explicit rather than
allowing compatible-batch substitution inside an occurrence-bearing operation.

For example, claims `#0:[0,1)`, `#1:[0,1)`, and `#2:[1,2)` give two identity-bearing graph paths,
`#0,#2` and `#1,#2`. Their located projection has only the edges `(0,1)` and `(1,2)`, and its
closure has only one `(0,2)` reachability fact. Any design asking the located result to identify
which graph path was used has already crossed the identity-forgetting boundary incorrectly.

## 5. One geometry reachability, two result sorts

D27's phrase “reachability is implemented once” now means:

- the graph projects to `LocatedRelation`;
- the K3 closure is the sole Boolean geometry-reachability implementation;
- `ReachabilityView` is graph/window-stamped and delegates its boundary facts to that closure;
- identity-bearing path construction traverses graph ordinals while consulting geometry
  reachability as its viability oracle.

It does **not** mean that geometry reachability and an occurrence-bearing path are one carrier or
one result. The former answers whether endpoints connect; the latter records which claims form one
path.

The K4a result layer contains:

- `ReachabilityView` — source graph/window plus the one projected geometry closure and derived
  forward/backward boundary diagnostics;
- `PartitionView` — source graph plus an ordered claim-ordinal path, validating meeting adjacency,
  disjointness, and exact window coverage;
- `SegmentationResult` — the result of the named reference path operation, containing either a
  valid partition or graph-specific failure evidence;
- `SegmentationResidual` — coverage gaps and connectivity failure evidence.

`SelectionResidual` is reserved for K4b. K4a has not executed a caller objective and must not spend
selection terminology on graph feasibility diagnostics.

## 6. Reference path and failure semantics

K4a supplies one deliberately narrow reference operation, not a general `Select`:

~~~text
FirstOrdinalCompletePath
  at the current boundary, choose the lowest candidate ordinal
  whose end can still reach Window.End
~~~

The name and result stamp expose the policy. Because candidate edges consume and the reachability
oracle certifies the suffix, the operation terminates and returns a complete path whenever one
exists. It promises neither maximal munch, minimum cost, maximum confidence, nor semantic
preference. K4b may retain this operation as its baseline; it must not silently reinterpret it as an
optimizer.

Ordinals are assigned in batch insertion order. Determinism therefore means reproducibility on the
one exact frozen graph/batch basis named by the result, consistent with ordinal's existing role as
the final total tie-break. Recollecting equal geometry in another order creates a different
occurrence basis and may select another complete path; neither K4a nor K8 promises invariance across
that change.

An empty window has the coherent zero-edge partition. Its located reachability contains the one
window-point identity extent, while its graph path contains no claim edge. These are compatible
identities on different carriers.

Failure evidence keeps two independent facts:

- a **coverage gap** is material in the window absent from the exact union of every candidate edge;
- a **connectivity dead end** is a reachable boundary or branch that cannot continue through
  meeting candidate edges to the window end.

For `[0,4)`, candidates `[0,1)` and `[2,4)` expose a coverage gap `[1,2)`. Candidates `[0,2)` and
`[1,4)` cover the window geometrically but still dead-end after boundary `2`; overlap is not path
adjacency. Both forms may be present in one graph. A complete path implies total candidate coverage,
but a graph with a complete path may still retain dead alternative branches in its reachability
diagnostics.

`EnvelopeOf` remains the convex hull and `ExactCoverageOf` the normalized material union. Neither
is a partition: `SpanSet` merges meeting spans and forgets claim ordinals, while `PartitionView`
retains the ordered identity-bearing cuts.

## 7. Separate chip gates and bounded witnesses

### 7.1 Joint K3/K4a-core exit

The first source chip closes with:

- the compatible-master/exact-window located basis, identity, union, `CanSeq`-based `Seq`,
  consuming closure, compatible/equal-window refusal, and exact `TextSlice` rebase;
- a bounded matrix/reference oracle for located identity, associativity, distributivity,
  consuming closure, and rebase laws, retaining the non-injective counterexample for the deferred
  lax boundary;
- the exact-batch candidate graph, contained nonempty candidate validation, explicit located
  projection, and a case where parallel claim edges collapse geometrically.

Partition/path results and their fixtures are not part of this chip's acceptance gate.

### 7.2 K4a-result exit

The second source chip closes with:

- graph-stamped `ReachabilityView`, `PartitionView`, `SegmentationResult`, and
  `SegmentationResidual`, with partition adjacency reusing `CanSeq`;
- an ambiguous token graph with at least two complete identity-bearing paths;
- a **budget-admissible** flat chunk candidate graph whose edges were admitted by an external
  budget rule, without costs or an objective entering the graph;
- separate coverage-gap, connectivity-dead-end, and empty-window cases;
- agreement between the named reference path and an independently written bounded path oracle.

The budget witness deliberately does not claim “best budgeted chunking.” K4a proves the graph can
carry admissible chunk alternatives. Cost stamps, breakpoint objectives, and preferred paths belong
to K4b.

## 8. K4b course correction — specialize before generalizing

The former outline put a universal `SelectionProblem` before packing, cover, and laminar result
families existed. That would either require a brute-force solver over arbitrary subsets or hide
family-specific feasibility inside opaque delegates. It would also promise that path, packing, and
hierarchy objectives share an execution algebra before the code had demonstrated that fact.

K4b therefore begins with the flat candidate-graph family. Its contract must name:

- the exact source graph and admissible candidate basis;
- the objective's compositional form, not merely an arbitrary whole-result callback;
- complete versus explicitly partial path feasibility;
- deterministic tie behavior;
- selected and rejected ordinals, score/unit/policy stamps, conflicts, and residuals;
- the exact guarantee: deterministic feasible path, additive minimum/maximum, lexicographic path,
  or another separately named contract.

Tokenizer and chunker policies may share the graph while using different objective contracts.
“Inclusion-maximal,” “maximum-cardinality,” “maximum-weight,” and “lexicographic priority” remain
different promises.

No universal `SelectionProblem`/`SelectionResult` carrier is promised yet. K4c is not downstream of
this path contract; it may reuse policy and result obligations only where its independent structural
implementation demonstrates the same shape. A common abstraction is extracted only after at least
two families demonstrate the same basis, feasibility, objective, and result shape; it is acceptable
if they never do.

## 9. K4c sibling consequences

K4c depends on the flat K4a basis/result semantics but not on K4b's path-selection types or
executor. It is an independently available sibling after K4a; K4b is merely the default execution
priority. K4c adds validators and views for packing, cover, laminar families, explicit hierarchy,
and resolution incidence.

The current `Laminarizer` is not itself that view contract: it predates D2 policy stamps, D21 basis
stamps, and D30 selection backing, and it combines greedy admission, laminarity, equal-geometry
grouping, and nearest-container parent construction. Migration separates:

1. a named deterministic greedy admission policy;
2. a selection-backed laminar-family validator/view;
3. an explicitly requested nearest-proper-container parent projection;
4. a separate explicit multiple-parent hierarchy DAG.

This separation is why K4c should not move ahead of flat K4a result semantics. It is also why K4c
does not need to wait for K4b and why K4b must not pretend its first path executor is already the
universal selection engine.

## 10. Assurance and Lean disposition

K3/K4a do not activate Lean:

- the reference relation is direct finite set/matrix semantics;
- its laws are standard finite relation algebra with bounded exhaustive and independent C# oracles;
- the exact-versus-lax mapping boundary is already settled by injectivity and an executable
  non-injective counterexample;
- graph projection and path identity are separated by construction rather than an unproved
  equivalence claim;
- the reference path promises determinism and completeness when geometry reachability exists, not
  optimality or invariance under reconstruction of a different occurrence basis.

Reapply the burden gate during either sibling's contract if K4b or K4c proposes a public global
optimum, equivalence between a reference and optimized executor, or a generalized objective
algebra. Policy choice by itself remains outside theorem work.

## 11. Non-goals

This contract does not add labels or provenance to `LocatedRelation`, enumerate every graph path,
turn zero-length edges into claims, introduce a generic boundary hierarchy, add a generalized map,
choose tokenizer/chunker meaning, build a universal optimizer, infer hierarchy from containment,
activate Lean, or implement engine source.

---

## Report

Completed 2026-08-05 as D33. The read-ahead retained the K3/K4 macro-order but corrected two
load-bearing ambiguities before source work: geometry reachability is shared without erasing graph
path identity, and selection generality follows demonstrated result families rather than preceding
them. The architecture workplan, roadmap, decision/assurance canon, ledger, D27 brief, deferred Lean
notes, and engine README now point to the same joint-core then result-layer sequence.

Amended 2026-08-05 by
[D34](sol-doccer-k3-k4a-review-adjudication-20260805_151759.md) after peer review. K4b and K4c are
sibling continuations after K4a, with K4b retained only as the default execution priority. D34 also
makes the exact-batch/compatible-geometry seam and ordinal stability scope explicit, splits the
core/result gates above, records K4c's policy/basis/selection hygiene debt, and distinguishes
empty-admitting `CanSeq` from Allen `Meets`.

At D33/D34 close, no engine source or package payload had changed and the contract harness baseline
remained 1779 checks green. Follow-on
[D35](sol-doccer-k3-k4a-core-20260805_182229.md) subsequently implemented the joint core:
`LocatedRelation`, the exact-selection `CandidateRegionGraph`, exact `TextSlice` rebase, explicit
identity-forgetting projection, and bounded algebra/projection assurance. Harness 1779→1834. The
separate K4a result chip was subsequently closed by
[D36](sol-doccer-k4a-results-20260805_184359.md): exact-graph reachability and partition/result
values, first-ordinal traversal, distinct gap/dead-end evidence, and the independent bounded path
oracle. Harness 1834→1874; K4a is closed and K4b/K4c are active siblings.
Follow-on [D37](sol-doccer-k4b-additive-path-selection-20260805_191324.md) subsequently closed K4b
with the first objective-shaped path executor and no universal selection carrier. Harness
1874→1914; K4c is active next.

Follow-on [D38–D39](sol-doccer-k4c-structural-results-20260805_201030.md) subsequently closed K4c
without introducing that carrier: exact family validators, inclusion-maximal laminar admission,
explicit/nearest hierarchy, and resolution incidence/aggregation. Harness 1914→1976; K5 is next.
