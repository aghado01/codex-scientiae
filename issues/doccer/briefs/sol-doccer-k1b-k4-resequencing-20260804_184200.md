# Doccer K1b–K4 sequencing brief — close algebras without transitional surfaces

Runstamp 20260804_184200. Canon at entry: D1–D26; K0 and K1a closed; contract harness 1561 checks
green. This is a planning adjudication, not an engine chip. Canonical current truth lives in the
[decision canon](../planning/decisions.md),
[architecture workplan](../planning/architecture-expansion-workplan.md), and
[roadmap](../planning/roadmap.md).

## 1. Disposition

Keep the architectural trajectory but revise the chip boundaries:

~~~text
K1b semantic Allen closure
    -> joint K2 contract design
    -> K2a selection + population integrations
    -> K2b exact pair view + terminal-join transition
    -> K2c pairing witness
    -> joint K3/K4a located relation + candidate graph
         |-> K4b explicit flat-path selection (default priority)
         `-> K4c hierarchy, packing, cover, and resolution
    -> shared selection abstraction only after both lanes supply evidence
~~~

K1b remains next as a completion priority. Its table is not a type dependency of K2: K2b needs
K1a's already-landed `AllenRelationSet` for exact relation filtering. This distinction allows the
Allen algebra to close cleanly without manufacturing a temporary query surface.

## 2. Why the former chip boundaries would cause churn

### 2.1 The terminal join should change once

The current `IntervalJoins.Join` accepts a general relation set and returns a terminal raw list.
Changing only its filter to `AllenRelationSet` in K1b would immediately be followed by K2b changing
the result into a basis-stamped, composable `ClaimPairView`. K1b therefore migrates durable
validation filters, while K2b becomes the one semantic transition for the join. Any retained
compatibility method must project from `ClaimPairView`; it may not keep an independent nested-loop
meaning.

### 2.2 A bare claim bitset would not close the query seam

`ClaimSelection` is valuable only if stable set-valued consumers can read it. K2a therefore lands
predicate selection and `Coverage()` together with selection-aware grouping, cadence, and
suppression. Convenience predicate overloads may delegate to this carrier.

Selection equality remains pure membership on one exact frozen batch. Canonical enumeration is
ascending ordinal. Existing lookup answers have an independent `ClaimOrder` policy; geometry- and
priority-ordered record projections remain explicit and do not alter set equality. An ordered
lookup must not be mechanically replaced by an unordered selection result.

### 2.3 Exact pairs and pairing must share one design

K2b freezes the ordinal diagonal identity, exact basis checks, projections, semijoins, converse,
and extensional `ComposePairs`. Middle ordinals may be reported transparently, but a packed witness
representation receives no associativity or bracket-independence claim before K5 defines support
normalization.

K2c then proves the carrier vocabulary against the strongest witnessed missing mechanism:
`PairingResult.MatchEdges` is a `ClaimPairView`; unary residue is selection-backed; mismatches keep
pair evidence. Pairing remains matching only—never repair, containment, or parenthood.

### 2.4 Located geometry must not absorb occurrence identity

The formal located carrier is a set over \(L_M\). It therefore collapses duplicate geometry and
carries no candidate labels. The candidate graph is a different carrier: it owns a
`ClaimSelection` basis and preserves parallel claim-ordinal edges over equal geometry.

K3 and K4a are consequently one design tranche. `CandidateRegionGraph` explicitly projects to
geometry-only `LocatedRelation`; Boolean geometry reachability is implemented once, while graph
paths separately retain claim ordinals; and the ambiguous-token and budget-admissible-chunk
witnesses prevent the pure algebra from becoming operationally empty. D33 subsequently makes the
algebra plus minimal graph projection one core source chip and the result layer a second chip.

## 3. Revised tranche gates

| Tranche | Must land | Must not land |
|---|---|---|
| K1b | `AllenCompose`; independent table and \(D_6\) oracle; JEPD/classifier closure; adjacent-gap counterexample; validation filters use `AllenRelationSet` | `IntervalJoins` filter-only retrofit; path consistency; generic QSTR framework |
| K2a | pure basis-stamped selection; ascending-ordinal enumeration; explicit ordered projections; coverage; stable population integrations | persisted IDs; order as set identity; indiscriminate lookup signature rewrites |
| K2b | exact pair carrier; ordinal diagonal identity; projection, semijoin, converse, `ComposePairs`; one terminal-join semantic path | packed-support algebra; Allen weak composition as a substitute for exact joins |
| K2c | pairing match edges, policy stamp, and complete identity-bearing residue over at least two delimiter families | repair; inferred parenthood; domain delimiter semantics |
| K3/K4a | geometry-only located relation; identity-bearing candidate graph; one geometry-reachability implementation; ordinal-bearing partition/path and gap/dead-end results; token and budget-admissible chunk witnesses | labels on `LocatedRelation`; generic boundary hierarchy/map; optimizer or path enumeration |
| K4b | objective-structured flat-path policies after result invariants; exact basis/objective/tie/result stamps | arbitrary-objective universal solver; implied optimality; cross-batch path invariance |
| K4c | sibling structural-family lane after K4a; selection/basis/policy-stamped packing, cover, laminar, hierarchy, and resolution views; common types only after demonstrated repetition with K4b | dependency on a K4b path executor; unstamped legacy `Laminarizer`; hierarchy inferred from containment alone |

## 4. Witness placement

The cross-cutting witness gate applies when each carrier lands:

- K2c witnesses K2 with pairing and residue;
- K3/K4a witnesses flat structure with ambiguous token and budget-admissible chunk graphs;
- K6/K7 witnesses origins/materialization with bounded macro substitution.

K8 becomes a final integration suite across those already-witnessed carriers. It does not defer
the first operational pressure test until the end of the expansion.

## 5. Non-goals

This adjudication does not move K2 ahead of K1b, combine all K2 work into one unreviewable commit,
make the runtime a pipeline, activate Lean, pull K5 ahead of fact identity, or change the K6-before-
K7 origin/materialization order. It changes sequencing ownership where an intermediate API would
otherwise be written only to be replaced.

---

## Report

Completed 2026-08-04 as D27. The architecture workplan, roadmap, decision canon, ledger, engine
README handoff, and K1a brief now agree on the revised boundaries. No engine source or package
payload changed; the contract harness baseline remains 1561 checks green.

Follow-on: [K1b](sol-doccer-k1b-allen-composition-20260804_203325.md) subsequently closed as D28
with the narrowed boundary intact: durable validation filters migrated, while
`IntervalJoins.Join` remained unchanged for K2b. K1 is closed at 1577 harness checks.

The required [joint K2 contract](sol-doccer-k2-joint-contract-20260804_214547.md) subsequently
closed as D29. It freezes reference `ComposePairs`, the one-way Allen-image bridge, the
terminal-join transition, and pairing residue without activating Lean or merging the three K2
implementation chips.

[K2a](sol-doccer-k2a-claim-selection-20260804_221441.md) then landed the exact-batch selection
value and stable population integrations as D30, preserving the consecutive-chip boundary and
leaving K2b as the one join transition. Harness 1577→1651.

[K2b](sol-doccer-k2b-claim-pair-view-20260805_022512.md) then performed that transition as D31:
the exact pair carrier, direct composition, complete middle witnesses, executable Allen bridge,
and compatibility join projection landed together without packed support or a qualitative edge
generator. Harness 1651→1733; K2c remains consecutive and active next.

[K2c](sol-doccer-k2c-pairing-result-20260805_093203.md) then closed the consecutive tranche as
D32: exact selections stamp roles, a named policy stamps compatibility, and strict top-only stack
execution returns pair-carrier matches plus complete selection/pair residue. Two delimiter
families and all 5,461 bounded two-key words are green; harness 1733→1779. K2 is closed and the
joint K3/K4a design is active next, preserving the resequenced boundary.

The required [joint K3/K4a contract](sol-doccer-k3-k4a-joint-contract-20260805_105443.md)
subsequently closed as D33 after reading ahead through K4c. It retained this brief's macro-order but
corrected two underspecified phrases before source work: “one reachability implementation” now
means one identity-forgetting geometry closure plus a distinct ordinal-bearing path result, and
“explicit selection” begins with objective-structured flat paths rather than a universal solver
over structural families not yet defined. The joint core is active next; harness remains 1779.

[D34 peer-review adjudication](sol-doccer-k3-k4a-review-adjudication-20260805_151759.md) then
corrected the remaining arrow-category error: K4b and K4c are sibling continuations after K4a,
because K4c consumes no K4b type or executor. K4b remains the default execution priority only for
the active tokenizer/chunker trajectory. D34 also makes the exact-batch/compatible-geometry seam,
ordinal stability scope, separate core/result gates, Laminarizer hygiene, and sort-specific
empty-admitting `CanSeq` condition explicit. Follow-on
[D35](sol-doccer-k3-k4a-core-20260805_182229.md) then closed the immediate joint core with the
located algebra, exact-selection graph, explicit projection, and bounded assurance; harness
1779→1834. [D36](sol-doccer-k4a-results-20260805_184359.md) subsequently closed the separate K4a
result layer with exact-graph values and bounded path-oracle agreement; harness 1834→1874. K4b and
K4c are active sibling continuations.
