# Doccer D34 review adjudication — sibling K4 lanes and exact contract seams

Runstamp 20260805_151759. Canon at entry: D1–D33; K2 closed; contract harness 1779 checks
green. D33 was recorded in commit `bc559f6`. This is a planning correction and clarification,
not an engine chip.

Inputs:

- [D33 joint K3/K4a contract](sol-doccer-k3-k4a-joint-contract-20260805_105443.md);
- [peer review of the K3/K4 rescope](../discussions/opus-doccer-k3-k4-rescope-review.md);
- [architecture expansion workplan](../planning/architecture-expansion-workplan.md);
- [decision and assurance registry](../planning/decisions.md);
- [`SpanBatch` and claim ordering](../../../src/doccer/Core/SpanBatch.cs);
- [`ClaimSelection`](../../../src/doccer/Algebra/ClaimSelection.cs),
  [`SpanSet`](../../../src/doccer/Algebra/SpanSet.cs), and
  [`LaminarView`](../../../src/doccer/Algebra/LaminarView.cs).

## 1. Review disposition

The review finds one false dependency arrow, one gate-presentation defect, and several seams that
were implied by landed code but not stated sharply enough.

| Review point | Disposition | Contract consequence |
| --- | --- | --- |
| `K4B --> K4C` confuses execution priority with dependency | accept | K4b and K4c are sibling continuations after K4a; K4b remains the default execution priority |
| first-ordinal selection follows insertion-order ordinals | clarify, no policy change | determinism is promised only on one exact frozen graph/batch basis; rebuilt or reordered batches may choose another path |
| D33 mixes joint-core and K4a-result witnesses | accept | publish two independent chip gates |
| graph and located carriers use different identity strength | accept and make explicit | exact batch identity is forgotten only at the graph-to-located projection |
| `Laminarizer` predates policy, basis, and selection stamps | accept as K4c hygiene debt | split admission, validation, and hierarchy projection under the landed D2/D21/D30 disciplines |
| a shared-boundary predicate is missing | accept with qualification | freeze sort-specific endpoint adjacency, not an unqualified Allen-style `Meets` predicate |

## 2. Corrected dependency and execution order

The type/design dependency is:

~~~text
D34 contract correction
  -> joint K3/K4a-core
       LocatedRelation + CandidateRegionGraph + explicit projection
  -> K4a-results
       reachability, partition/path results, residuals, bounded witnesses
       |\
       | -> K4b-flat selection     default execution priority
       |
       -> K4c structural families independently available
  -> common selection abstraction only after both lanes supply evidence
~~~

Both K4b and K4c consume the flat K4a basis and result semantics. K4c does not consume a K4b type,
executor, or universal selection carrier. K4b remains the default next lane because tokenizer and
chunker path objectives are the active trajectory, not because K4c is blocked on it. The lanes may
proceed in either order or in parallel once K4a closes.

This preserves D33's specialize-before-generalizing decision. A common selection abstraction is
considered only after the flat-path and at least one structural-family implementation demonstrate
the same basis, feasibility, policy, objective, and result shape. Repetition is evidence for an
abstraction, not a dependency manufactured in advance.

## 3. Exact occurrence basis and compatible geometry basis

The projection boundary now states both sides explicitly:

~~~text
CandidateRegionGraph
  Source/Candidates  exact frozen SpanBatch reference through ClaimSelection
  Window             exact TextSpan on Source.Master
  edge identity      claim ordinal

              explicit projection; occurrence identity is forgotten here

LocatedRelation
  Master             TextMaster value compatibility
  Window             exact equal TextSpan
  edge identity      geometry value
~~~

Graph operations and graph/result equality therefore reject a different batch object even when it
contains equal records over a compatible master. Located binary operations accept masters related
by `TextMaster.IsCompatibleWith` when their windows are equal, following the geometry-value
precedent. Two unequal occurrence graphs may consequently project to equal located relations.
Projection is the only identity weakening licensed by this tranche, and it is explicit; no graph operation may
silently substitute compatible-batch value equality for exact source identity.

## 4. Scope of first-ordinal determinism

`FirstOrdinalCompletePath` remains the deliberately nonsemantic reference policy:

~~~text
at each boundary, choose the lowest candidate ordinal
whose end can still reach Window.End
~~~

`SpanBatchBuilder` assigns ordinals in insertion order, and existing claim ordering already uses
ordinal as its final total tie-break. The promise is therefore reproducibility for the exact frozen
candidate graph, not invariance under recollection, insertion reordering, or reconstruction of
equal geometry in another batch. Such a reconstruction creates a different occurrence basis and
may select a different complete path.

This visible arbitrariness is useful: the K4a witness cannot be mistaken for maximal munch,
minimum cost, or a semantic tokenizer policy. K8 must retain or stamp the exact graph/batch and the
named reference policy when replaying the ambiguous-token witness; it must not assert
cross-batch path invariance.

## 5. Separate chip gates

### 5.1 Joint K3/K4a-core gate

The first source chip closes only when it supplies:

- the compatible-master/exact-window `LocatedRelation` basis, empty, full declared-window
  diagonal identity, union, consuming projection, shared-boundary `Seq`, and Boolean consuming
  reachability;
- exact refusal for unequal windows and compatibility refusal for unrelated masters;
- exact window-preserving `TextSlice` rebase and bounded identity, associativity,
  distributivity, closure, and rebase checks;
- an exact-batch `CandidateRegionGraph` backed by `ClaimSelection`, with validated contained
  nonempty edges and a retained exact window;
- one explicit graph-to-located projection, including a witness that parallel claim ordinals
  collapse only after projection.

No partition, path policy, segmentation residual, token fixture, or chunk fixture is required to
accept this chip.

### 5.2 K4a-result gate

The second source chip closes only when it supplies:

- graph-stamped `ReachabilityView`, `PartitionView`, `SegmentationResult`, and
  `SegmentationResidual`;
- partition validation using the same endpoint-adjacency condition as located `Seq`, plus exact
  window coverage and retained claim ordinals;
- the named `FirstOrdinalCompletePath` reference operation with exact graph/policy stamp;
- distinct coverage-gap and connectivity-dead-end evidence and the coherent empty-window result;
- ambiguous-token and budget-admissible chunk witnesses; and
- agreement with an independently written bounded path oracle.

This gate does not reopen the joint core merely because a result fixture finds a result-layer bug.

## 6. K4c hygiene and decomposition

K4c is independently available after K4a because its immediate debt is carrier hygiene, not the
K4b objective algebra. The current `Laminarizer` predates three landed disciplines and cannot be
promoted unchanged:

- D2: a named deterministic admission policy and policy stamp;
- D21: a source/basis stamp, including meaningful identity for an empty result;
- D30: exact `ClaimSelection` backing rather than a raw filtered record list.

K4c separates four operations that the current helper combines:

1. deterministic greedy admission under a named policy;
2. validation/materialization of a selection-backed laminar family;
3. explicitly requested nearest-proper-container parent projection; and
4. a separate explicit multiple-parent hierarchy DAG.

The greedy default remains deterministic and inclusion-maximal, not maximum-cardinality or
maximum-weight. K4b policy/result obligations may be reused only where the structural code
demonstrates the same contract; K4c is not forced through a path executor.

## 7. Sort-specific shared-boundary adjacency

The K3/K4a sequential condition is frozen as:

~~~text
CanSeq(left, right) := left.End == right.Start
~~~

Located `Seq` and `PartitionView` must share that definition. It deliberately admits diagonal
empty located extents, so it is not the Allen `Meets` atom: Allen classification applies only to
nonempty intervals and rejects empty spans. D34 therefore does not add an unqualified
`TextSpan.Meets` method or alter D17 intersection semantics. `CanSeq` may remain an internal,
located-family predicate unless a broader public consumer justifies exposure.

## 8. Assurance and Lean disposition

D34 introduces no new proof burden and does not activate Lean. It narrows the claims that need
assurance:

- graph identity is exact-batch and located equality is compatible-geometry by construction;
- first-ordinal determinism is a stamped finite policy claim, not a cross-batch invariance theorem;
- `CanSeq` is direct endpoint equality, including the located diagonal;
- the two chip gates each have a bounded independent oracle appropriate to their own result sort;
- K4c's greedy policy needs an executable maximal-not-maximum counterexample, not a proof of an
  optimum it does not claim.

The D33 Lean triggers remain: reconsider only before a compressed or independent closure/path
backend claims equivalence, a generalized map reopens the exact-versus-lax boundary, or K4b/K4c
publishes a load-bearing global optimum or generalized objective algebra.

## 9. Non-goals

D34 does not change the immediate source chip, choose K4c ahead of K4b, make ordinals durable
identifiers, require cross-batch path stability, add a public generic adjacency API, turn Allen
`Meets` into a located operator, retrofit `Laminarizer` now, publish a universal selection carrier,
activate Lean, or change the 1779-check harness baseline.

---

## Report

Completed 2026-08-05 as D34. The peer review corrected one false dependency edge and made five
implicit seams reviewable before code. The architecture now records K4b and K4c as sibling lanes
after K4a, with K4b retained only as the default execution priority. It also freezes the
exact-batch-to-compatible-geometry projection boundary, exact-basis scope of ordinal determinism,
separate core/result chip gates, K4c's D2/D21/D30 hygiene work, and the empty-admitting
sort-specific endpoint predicate.

At D34 close, no engine source or package payload had changed and the contract harness baseline
remained 1779 checks green. Follow-on
[D35](sol-doccer-k3-k4a-core-20260805_182229.md) subsequently closed the first independent gate with
`LocatedRelation`, exact `TextSlice` rebase, the exact-selection `CandidateRegionGraph`, explicit
identity-forgetting projection, and bounded algebra/projection assurance. Harness 1779→1834. The
separate K4a result gate was subsequently closed by
[D36](sol-doccer-k4a-results-20260805_184359.md) with exact-graph result stamps, validated ordinal
partitions, first-ordinal traversal, gap/dead-end evidence, and an independent bounded path oracle.
Harness 1834→1874; K4a is closed and K4b/K4c are active siblings.
Follow-on [D37](sol-doccer-k4b-additive-path-selection-20260805_191324.md) subsequently closed K4b
without changing the sibling dependency: one exact additive complete-path executor, full decision
evidence, and independent optimizer agreement. Harness 1874→1914; K4c is active next.
