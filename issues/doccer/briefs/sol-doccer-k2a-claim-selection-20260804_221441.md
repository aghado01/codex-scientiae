# Doccer K2a chip brief — exact-batch occurrence selection

Runstamp 20260804_221441. Canon at entry: D1–D29; K1 closed; joint K2 contract frozen;
contract harness 1577 checks green. This is the first implementation chip in the consecutive
K2a–K2c tranche specified by the
[joint K2 contract](sol-doccer-k2-joint-contract-20260804_214547.md).

## Contract

Land `ClaimSelection` as an immutable occurrence set over the ordinal universe of one exact frozen
`SpanBatch`:

- `None`, `All`, validated ordinal `Create`, and `FromPredicate` construction;
- count, emptiness, validated membership, union, intersection, subtraction, and relative
  complement;
- value equality and hashing over exact basis reference plus extensional membership;
- canonical ascending-ordinal enumeration;
- `Records(ClaimOrder)` as an explicit geometry- or priority-ordered record projection;
- `Coverage()` as an explicit identity-forgetting normalized `SpanSet` projection.

Equal geometry does not merge selection members. Compatible masters and claim-for-claim equal
batches do not make ordinal universes interchangeable. Duplicate ordinals during construction
coalesce, while undefined ordinals and cross-basis binary operations fail without returning a
partial result.

The representation is private and creates no raw-mask, persistence, or wire contract. Ordinals
remain in-process identities; F2 owns durable claim identity.

`FromPredicate` is deliberate vocabulary hygiene: it is ordinary filtering into an occurrence
set. D25's public `Select` name remains reserved for K4's policy-bearing, potentially nonmonotone
choice and its result invariants.

## Shared ordering and population path

K2a must close the unary query seam, not merely add a bare bitset:

- `ClaimSelection.Records` and `SortedSpanLookup` share one internal implementation of
  `ClaimOrder.Geometry` and `ClaimOrder.PriorityThenGeometry`;
- `Grouping.ByKey` and `Grouping.ByLine` accept an exact selection; their batch conveniences use
  `All(batch)` and delegate;
- `GapCadence.Measure(selection, window)` is the reference measurement path. The batch/predicate
  convenience constructs a selection and delegates; `GapCadenceMeasure.Population` retains the
  exact set admitted by the window, while `Ordinals` remains its start-ordered evidence;
- `Suppression.Excluded` and `Admitted` accept a suppressor selection; predicate conveniences
  construct that selection and delegate;
- `SpanSet.FromClaims` follows the same selection-to-`Coverage()` projection.

Key-only grouping and selection algebra must not force the master's lazy fingerprint or topology.
Line grouping is allowed to force topology because it explicitly asks for the line grain.

## Law surface

- exhaustive membership and Boolean checks over all (2^6=64) selections on a six-claim basis;
- every one of the (64^2=4096) ordered selection pairs checked against an independent integer
  mask oracle for union, intersection, subtraction, commutativity, and De Morgan;
- complement involution, identities, annihilation, and deterministic distributivity witnesses;
- a population above 64 claims to exercise a private bitset word boundary;
- exact-basis refusal with the same master and equal claim rows in a separately frozen batch;
- canonical ordinal order versus both explicit `ClaimOrder` projections;
- equal/overlapping occurrence collapse only through `Coverage()`;
- selection/predicate parity for grouping, cadence, suppression, and claim coverage;
- topology laziness and all null/undefined public boundaries.

## Boundaries

K2a does not add `ClaimPairView`, pair edges, `ComposePairs`, middle witnesses, Allen-image
abstraction, pairing, durable IDs, lookup indexes, a public mask, or a wire representation. It does
not change `IntervalJoins.Join`. K2b remains the one terminal-join transition.

No new Lean burden is introduced: the unary finite-set laws have a direct bounded oracle and no
signature-changing exact-versus-lax ambiguity. D29's deferred gate remains attached to K2b's
cross-carrier Allen abstraction and any later optimized pair backend.

## Done criteria

- the public surface and XML contracts compile with no warnings;
- the bounded laws and adversarial integration tests are green;
- D30, README, workplan, roadmap, ledger, joint K2 brief, and this report agree that K2a is closed
  and K2b is active next;
- the verified local payload exposes `ClaimSelection` and passes delivered-assembly plus CLI smoke.

---

## Report

Completed 2026-08-04. Harness **1577 → 1651 checks green**; the verified local payload was
refreshed through `build-doccer.ps1`, whose delivered-assembly smoke now requires
`CodexSci.Doccer.ClaimSelection`. The manifest records commit `05419f3` with a dirty source stamp,
accurately identifying this uncommitted K2a worktree.

`src/doccer/Algebra/ClaimSelection.cs` supplies the value exactly as briefed. Its private multiword
bitset is always masked to the basis count and never exposed. `Create` coalesces duplicates;
`FromPredicate` evaluates its predicate once per basis ordinal; binary operations require reference-equal
batches; equality/hash include that exact basis; enumeration is ascending ordinal even across a
64-bit word boundary.

The ordering seam is single-sourced through the internal `ClaimOrdering` helper now shared by
`SortedSpanLookup` and `ClaimSelection.Records`. Canonical selection enumeration stays ordinal;
geometry and priority are result projections only. `Coverage()` copies selected spans into
`SpanSet` normalization and therefore advertises exactly where occurrence identity is forgotten.

Grouping, cadence, suppression, and `SpanSet.FromClaims` now converge on the selection path.
`GapCadenceMeasure.Population` makes its exact window-admitted set inspectable without replacing
the existing start-ordered ordinal record. The integration witness confirms batch/predicate parity,
selection-only key evaluation, total line grouping, exact source stamps, coverage duality, and the
intended topology-laziness boundary.

The exhaustive bounded suite checks all 64 selection values and all 4,096 ordered operand pairs,
with a separate 70-claim word-boundary witness and adversarial cross-batch cases. No pair carrier,
join change, durable identity, or K2b placeholder leaked into the chip. D30 closes K2a at 1,651
checks; [K2b](../planning/architecture-expansion-workplan.md#k2b-claimpairview) is the active next
implementation.
