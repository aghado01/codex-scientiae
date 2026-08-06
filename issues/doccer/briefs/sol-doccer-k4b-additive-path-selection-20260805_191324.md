# Doccer D37 K4b — additive minimum-cost complete-path selection

Status before implementation: D36 closes K4a at 1874 checks with one exact candidate graph,
validated ordinal partitions, graph-feasibility residuals, and the deliberately nonsemantic
`FirstOrdinalCompletePath` witness. K4b is now the default sibling lane. This brief freezes its
first objective-bearing executor before source changes.

Inputs:

- [D33 joint K3/K4a and K4 course correction](sol-doccer-k3-k4a-joint-contract-20260805_105443.md);
- [D34 sibling-lane and exact-stamp correction](sol-doccer-k3-k4a-review-adjudication-20260805_151759.md); and
- [D36 K4a result closure](sol-doccer-k4a-results-20260805_184359.md).

## 1. One flat objective, not a universal solver

K4b begins with the one objective form directly witnessed by token and chunk paths:

~~~text
minimize sum(edge cost)
subject to an exact admissible candidate selection
and a complete path from Window.Start to Window.End
ties: lexicographically smallest ordinal sequence
~~~

This is not an arbitrary callback over a completed selection. The caller supplies one cost per
candidate edge; Doccer snapshots those costs once, then executes a boundary-local additive
recurrence whose guarantee is named by the policy type. Partial paths, additive maximization,
fewest-edge selection, lexicographic priority vectors, and whole-path objectives remain different
future contracts.

No `SelectionProblem`/`SelectionResult` universal carrier lands. The types are deliberately
path-specific:

- `AdditivePathPolicy` — exact source graph, required caller name and score unit, immutable edge
  costs, `MinimumAdditiveCost` guarantee, and `LexicographicOrdinal` tie stamp;
- `PathSelectionProblem` — exact source graph, exact admissible `ClaimSelection`, a derived exact
  admissible graph, excluded candidates, the exact policy object, and explicit `CompletePath`
  feasibility;
- `PathSelectionResult` — exact problem/graph/policy stamps, either a source-graph
  `PartitionView` and score or a path-specific residual, plus selected, rejected-admissible, and
  excluded populations; and
- `PathSelectionResidual` — the exact problem plus K4a `SegmentationResidual` evidence computed
  on the derived admissible graph.

`PathSelection.Select(problem)` is the only executor in this chip. The `Select` verb is now
licensed because the caller has supplied a named objective and the result exposes its decisions.

## 2. Exact bases and hard admissibility

`PathSelectionProblem.Create(graph, admissibleCandidates, policy)` requires:

- the exact retained graph object also stamped by the policy;
- an admissible selection on `graph.Source`, not merely a compatible batch; and
- `admissibleCandidates` to be a subset of `graph.Candidates`.

The passed admissible selection is retained exactly. `AdmissibleGraph` is constructed from that
selection and the source graph's exact window so K4a reachability/residual semantics can be reused
without pretending excluded candidates remain feasible. `ExcludedCandidates` is
`graph.Candidates - admissibleCandidates`.

A successful partition remains stamped by the original source graph. The result additionally
checks that every selected ordinal was admissible. A failed result's feasibility evidence is
stamped by `AdmissibleGraph`; its surrounding `PathSelectionResidual` retains the source problem,
so both the problem basis and the graph actually tested for feasibility remain explicit.

Selected, rejected, and excluded candidates satisfy an exact disjoint partition:

~~~text
SelectedCandidates union RejectedCandidates = AdmissibleCandidates
AdmissibleCandidates union ExcludedCandidates = Graph.Candidates
~~~

On failure, selection is empty and every admissible candidate remains rejected/unselected. Source
claims are never deleted or copied into a new occurrence store.

## 3. Cost domain and mechanically checkable score

The first policy uses nonnegative `Int64` edge costs. Nonnegativity matches penalty/cost use cases
and keeps this first contract narrower than signed weights. Policy construction evaluates the
caller function exactly once per graph candidate and retains the resulting value; selection never
re-enters caller code.

Construction rejects a negative edge cost and rejects a cost table whose sum exceeds
`Int64.MaxValue`. Because a complete path contains a subset of nonnegative candidate edges, every
possible path score is then representable. The result score is the checked sum of the retained
costs on `SelectedCandidates`; the required opaque unit string and exact policy object travel with
it. No cross-policy or cross-unit score arithmetic is introduced.

The empty window has the complete zero-edge path with score zero. An infeasible nonempty problem
has no score.

## 4. Reference recurrence and guarantee

Candidate edges are strictly consuming, so their endpoints form a finite DAG. Production computes
one memoized suffix plan per visited boundary:

~~~text
Best(Window.End) = (0, empty path)
Best(b) = minimum over admissible e with e.Start = b
          of (cost(e) + Best(e.End), e.Ordinal prepended)
~~~

Missing suffixes are infeasible. Scores compare first; equal scores compare full ordinal sequences
lexicographically. The recurrence therefore returns the global minimum additive-cost complete path
under the exact admissible basis, not merely a greedy local choice. It never materializes all paths
in production.

`FirstOrdinalCompletePath` remains K4a's cost-free baseline. K4b may choose different geometry on
the same graph and must not reinterpret that difference as a K4a bug.

## 5. Assurance and Lean gate reapplication

The public global-minimum claim fires the D33/D34 burden trigger, so this chip explicitly reapplies
the Lean gate. Lean remains deferred for this first executor because:

- the implementation is the direct finite DAG recurrence above, not an optimized backend standing
  beside a separate public reference implementation;
- the objective algebra is one closed nonnegative additive `Int64` form, not a generalized
  semiring or arbitrary whole-path callback; and
- an independent test oracle enumerates every complete path and compares score plus tie outcome
  for all 128 admissible subsets crossed with all 128 binary cost assignments on a seven-edge
  basis (16,384 optimization problems).

Direct fixtures additionally cover an objective that defeats K4a's first-ordinal baseline,
equal-score lexicographic ties, parallel occurrences, hard exclusion forcing an alternative,
failure residuals, empty windows, exact stamp refusals, one-shot cost evaluation, negative costs,
and score-domain overflow.

Reactivate Lean before a second/optimized backend claims equivalence, signed or generalized score
algebra becomes shared infrastructure, partial-path semantics add a nontrivial completeness or
approximation guarantee, or cross-family selection reuse makes the recurrence load-bearing beyond
this exact DAG contract.

## 6. Non-goals

D37 does not add a universal optimizer, arbitrary subset feasibility, partial paths, recovery
semantics, coverage rewards, maximum weight, vector or floating scores, automatic unit conversion,
semantic token/chunk policy, persistent policy identity, production path enumeration, K4c
packing/cover/laminar/hierarchy types, or Lean code.

## 7. Implementation report

Completed 2026-08-05 as D37. Added the path-specific
[`PathSelection`](../../../src/doccer/Algebra/PathSelection.cs) surface:
`AdditivePathPolicy`, `PathSelectionProblem`, `PathSelectionResult`,
`PathSelectionResidual`, and their exact guarantee/tie/feasibility stamps. Production uses the
descending-boundary dynamic program specified above and rechecks the returned score from the
policy's frozen costs.

The contract harness adds one-shot policy evaluation and cost-domain refusals; exact graph,
batch, admissibility, and policy-object refusals; an ambiguous token objective that defeats the
K4a baseline; explicitly labeled token, token-with-trivia, trivia, and recovery candidates;
full-path lexicographic and parallel ties; hard exclusion; separate gap and
full-coverage dead-end residuals; a size-admitted chunk graph with independent breakpoint costs;
and the zero-edge/zero-score empty window. The independent all-path oracle agrees on every one of
the 16,384 admissibility-mask × binary-cost-table problems. Harness 1874→1914 with no warnings.

The global-optimum burden trigger was reapplied and did not activate Lean under the bounded
reference posture in section 5. K4b is closed. K4c structural-family hygiene is active next and
retains no dependency on the path executor. Future partial, signed/vector, maximizing, or alternate
tie contracts remain separately gated additions rather than implied features of D37.

Follow-on [D38–D39](sol-doccer-k4c-structural-results-20260805_201030.md) subsequently closed the
independent structural sibling with family-specific validators and policies, explicit/nearest
hierarchy, and resolution incidence/aggregation. Harness 1914→1976; K5 is active next.

Follow-on [D40](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) makes the
graph stamp coherent with `CandidateRegionGraph.Equals`: a policy snapshotted on an equal graph
definition over the same exact batch can form a problem, while the supplied policy and problem
objects remain exact evidence stamps and compatible-but-distinct batches remain refused. Harness
remains 1976.
