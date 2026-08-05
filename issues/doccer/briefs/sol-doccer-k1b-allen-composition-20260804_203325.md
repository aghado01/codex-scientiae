# Doccer K1b chip brief — canonical Allen composition closure

Runstamp 20260804_203325. Canon at entry: D1–D27; K0 and K1a closed; contract harness 1561
checks green. This is the second and final K1 chip named by the
[architecture expansion workplan](../planning/architecture-expansion-workplan.md), under the
[D27 sequencing boundary](sol-doccer-k1b-k4-resequencing-20260804_184200.md).

## Contract

Close the qualitative Allen value layer without manufacturing a temporary query API:

- add `AllenRelationSet.AllenCompose`, explicitly named for its carrier and canonical qualitative
  upper-approximation semantics;
- ship the 13×13 atomic composition table as 169 literal masks in the frozen D26 atom order, with
  no runtime table generation or public raw-mask surface;
- reconstruct the expected table in the harness through a separate endpoint-predicate encoding on
  \(D_6\): six boundaries, fifteen nonempty intervals, and all \(15^3=3375\) triples;
- close `AllenAlgebra.Relate` against those independent predicates as a JEPD classifier;
- retain the adjacent-gap witness separating canonical composition from exact composition on a
  particular finite carrier;
- migrate the durable `RelationRequirement` and `ForbiddenRelation` filters to
  `AllenRelationSet`, rejecting `None`;
- leave `IntervalJoins.Join` unchanged so K2b performs its one transition to `ClaimPairView`.

Published assurance remains corroborating rather than executable-table input. Liu and Li's
[composition-table generation study](https://arxiv.org/abs/1105.4224) supplies the compact
six-boundary/409-triad normal-form evidence; Ghourabi and Takahashi's
[proof of all 169 compositions](https://arxiv.org/abs/1804.01637) and the
[Archive of Formal Proofs development](https://isa-afp.org/entries/Allen_Calculus.html) supply the
independent formal upper-bound/JEPD account. The shipped table and the C# oracle remain locally
reproducible without loading either source at runtime.

## Law surface

- the thirteen endpoint predicates are jointly exhaustive and pairwise disjoint on every ordered
  pair of nonempty \(D_6\) intervals, every atom occurs, and `Relate` returns the unique predicate;
- the literal table equals the separately reconstructed oracle in all 169 cells, totaling 409
  consistent atomic triads;
- `None` is a two-sided composition annihilator and `Equal` a two-sided identity;
- composition distributes over relation-set unions and reverses under converse;
- all \(13^3=2197\) atomic triples satisfy associativity; additivity lifts this kernel to atom
  unions;
- all 8192 relation-set values participate in deterministic sweeps of the lifted identity,
  annihilation, distributivity, and converse laws;
- `Before AllenCompose Before` is `Before`, yet the four-boundary finite carrier contains no
  nonempty middle interval between \([0,1)\) and \([2,3)\).

## Boundaries

No exact fixed-master relation composition, `ClaimSelection`, `ClaimPairView`, path consistency,
generic qualitative-calculus descriptor, CLI/wire representation, or privileged runtime form for
proof-grouping unions lands here. The private table is implementation data, not a serialization
contract. K1b intentionally makes no filter-only overload for the terminal raw-list join.

## Done criteria

- the public XML contract states canonical rather than finite-master-exact composition;
- production table and test oracle have separate encodings and agree exhaustively;
- D28, assurance registry, workplan, roadmap, ledger, README, and associated K1 briefs agree that
  K1 is closed and joint K2 specification is next;
- the full harness, delivered-assembly smoke test, and delivered CLI smoke test are green;
- the verified local payload and manifest are refreshed.

---

## Report

Completed 2026-08-04 as D28. Harness **1561 → 1577 checks green**; the verified local payload was
refreshed through `build-doccer.ps1`, including the delivered-assembly and CLI smoke checks.

`src/doccer/Algebra/AllenRelationSet.cs` now contains the literal row-major atomic table and the
additive `AllenCompose` lift. The production path never classifies endpoints or generates cells.
The harness independently defines all thirteen endpoint predicates, checks JEPD and classifier
agreement over all 225 ordered \(D_6\) pairs, enumerates 3,375 interval triples, and compares every
one of the 169 reconstructed cells with the shipped table. The resulting 409 atomic triads and all
composition laws match the contract.

`RelationRequirement.AcceptedRelations` and `ForbiddenRelation.ForbiddenRelations` now preserve
the closed relation-set value directly, and both constructors reject `AllenRelationSet.None`.
`IntervalJoins.Join` still accepts its original general filter and returns its original raw list;
there is no transitional overload or parallel composition meaning to remove in the next chip.

The adjacent-gap case remains executable evidence that a canonical cell records possible outer
relations across the interval model, not guaranteed middle witnesses for every pair on one finite
text master. That distinction leaves K2b's exact pair relation well-posed. K1 is now closed; the
next artifact is the joint K2a–K2c contract brief required by D27, followed by K2a.
