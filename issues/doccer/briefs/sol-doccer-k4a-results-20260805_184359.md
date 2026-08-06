# Doccer D36 K4a results — stamped reachability and exact ordinal partitions

Status before implementation: D35 has closed the joint K3/K4a located-algebra and candidate-graph
core with 1834 contract checks green. This brief freezes the second, independently gated K4a chip
defined by D33 and corrected by D34. It does not reopen the landed core.

Inputs:

- [D33 joint K3/K4a contract](sol-doccer-k3-k4a-joint-contract-20260805_105443.md);
- [D34 peer-review adjudication](sol-doccer-k3-k4a-review-adjudication-20260805_151759.md); and
- [D35 joint core](sol-doccer-k3-k4a-core-20260805_182229.md).

## 1. Frozen public result surface

The result layer adds these values in `CodexSci.Doccer`:

- `ReachabilityView.Create(CandidateRegionGraph)` retains the exact graph object, projects it once
  through `ToLocatedRelation().Reachability()`, and derives forward, backward, and dead-end
  diagnostics without recovering claim identity from geometry;
- `PartitionView.Create(CandidateRegionGraph, IEnumerable<int>)` retains the exact graph and an
  ordered immutable ordinal path, rejecting foreign, repeated, nonmeeting, partial, or
  window-misaligned paths;
- `SegmentationPolicy.FirstOrdinalCompletePath` is the exact named result stamp, not a generic
  policy or objective abstraction;
- `SegmentationResult` contains either one valid `PartitionView` or one
  `SegmentationResidual`, plus the exact graph, reachability view, and policy stamp; and
- `SegmentationResidual` contains normalized coverage gaps and graph-identity-bearing
  connectivity evidence.

`LocatedRelation.Seq` and `PartitionView` share one internal predicate:

~~~text
CanSeq(left, right) := left.End == right.Start
~~~

This remains a located-family implementation detail. It admits diagonal located extents and is not
Allen `Meets`.

## 2. Reachability and residual semantics

`ReachabilityView.Closure` is exactly the one landed K3 Boolean geometry closure. Its boundary
views are scalar-valid boundaries in ascending offset order:

- forward reachable means `Window.Start` reaches the boundary;
- backward reachable means the boundary reaches `Window.End`;
- a dead-end candidate is an exact selected graph ordinal whose start is forward reachable but
  whose end cannot reach `Window.End`; and
- dead-end boundaries are the distinct ascending ends of those candidates.

This retains dead alternative branches even when another complete path exists. It does not call a
failed graph a residual merely because such an alternative exists.

For a failed reference traversal, `SegmentationResidual` reports independently:

- coverage gaps as
  `SpanSet.Create(master, [window]).Subtract(graph.Candidates.Coverage())`; and
- the reachability view's dead-end boundaries and exact-basis dead-end candidate selection.

Thus `[0,1)` plus `[2,4)` in `[0,4)` has a material gap, while `[0,2)` plus `[1,4)` has full
material coverage but a connectivity dead end at `2`. The empty window has neither kind of
failure.

## 3. Partition invariant

A nonempty partition is an ordered list of distinct graph candidate ordinals such that:

1. its first span begins at `Window.Start`;
2. every adjacent pair satisfies the shared `CanSeq` predicate; and
3. its last span ends at `Window.End`.

Because graph edges are nonempty, these conditions imply an ordered, disjoint, gap-free exact
cover of the window. The empty window admits exactly the zero-edge partition; a nonempty window
does not.

Partition identity is graph-reference identity plus the ordinal sequence. Compatible masters,
equal claim records in another batch, or equal projected geometry do not weaken the stamp.

## 4. Named reference operation

`Segmentation.FirstOrdinalCompletePath(graph)` performs no path enumeration. At the current
boundary it scans the graph's canonical ascending ordinal population and chooses the first edge
whose start is current and whose end can still reach `Window.End` in the geometry closure. The
edge consumes text, so the cursor advances. A complete path is returned whenever one exists;
otherwise the operation returns the graph-specific residual.

The result promises reproducibility only on that exact frozen graph/batch. It does not promise
maximal munch, shortest path, minimum cost, maximum confidence, or invariance after recollection
in another insertion order.

## 5. Assurance gate

The chip is accepted only with:

- exact graph and policy stamp checks plus partition construction refusals;
- empty-window, coverage-gap, full-coverage dead-end, and complete-path-with-dead-branch cases;
- parallel-edge and ambiguous-token paths that retain ordinals;
- a chunk graph whose candidates were admitted by an external length budget, with no budget,
  score, or objective on the graph/result types; and
- an independent bounded test oracle which enumerates complete ordinal paths and compares the
  lexicographically first path with the production traversal for every subset of a fixed graph
  basis. The same suite independently checks closure reachability and diagnostic projections.

Production exposes neither all-path enumeration nor a generic solver. `SelectionResidual`,
objective structure, costs, score units, preferred/rejected alternatives, and `Select` remain K4b.
Packing, cover, laminar-family, hierarchy, and resolution views remain the sibling K4c lane.

## 6. Implementation report

Completed 2026-08-05 as D36. Added
[`ReachabilityView`](../../../src/doccer/Algebra/ReachabilityView.cs),
[`PartitionView`](../../../src/doccer/Algebra/PartitionView.cs), and the
[`Segmentation`](../../../src/doccer/Algebra/Segmentation.cs) policy/result/residual surface. One
internal [`LocatedSemantics`](../../../src/doccer/Algebra/LocatedSemantics.cs) primitive now owns
endpoint-equality adjacency for both located `Seq` and partition validation.

The contract harness adds exact stamp and construction-refusal checks; parallel and ambiguous-token
paths; external budget admission; gap, full-coverage dead-end, successful-dead-alternative, and
empty-window cases; and an independent oracle over all 128 subsets of a seven-edge graph. The
oracle enumerates complete ordinal paths rather than reproducing the production traversal, while
separate DFS, code-unit material scans, and dead-branch projections check reachability and
residual diagnostics. Harness 1834→1874 with no warnings.

K4a is closed. K4b flat-path objective execution and K4c structural-family hygiene are active
sibling continuations; K4b remains the default execution priority. No K4b objective/cost/selection
surface, K4c carrier migration, production all-path API, or Lean code landed in this chip.

Follow-on [D37](sol-doccer-k4b-additive-path-selection-20260805_191324.md) subsequently closed K4b
with one exact nonnegative-additive complete-path executor, decision/residual evidence, and a
16,384-problem independent optimizer oracle. Harness 1874→1914; K4c is active next.

[D38–D39](sol-doccer-k4c-structural-results-20260805_201030.md) subsequently closed the independent
K4c lane with exact structural validators, named laminar admission, explicit/nearest hierarchy, and
resolution incidence/aggregation. Harness 1914→1976; K5 is active next.

[D40](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) subsequently clarifies
the D36 stamp: `CandidateRegionGraph.Equals`—same exact source-batch reference, window, and
candidate ordinals—is graph-basis compatibility. Results retain their supplied graph objects, but
partition equality and cross-view checks no longer invent a second wrapper-reference identity.
Harness remains 1976.
