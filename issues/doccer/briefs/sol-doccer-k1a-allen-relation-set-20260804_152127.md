# Doccer K1a chip brief — immutable Allen relation-set value

Runstamp 20260804_152127. Canon at entry: D1–D25; K0 closed; contract harness 1500 checks green.
This is the first of the two K1 chips named by the
[architectural expansion workplan](../planning/architecture-expansion-workplan.md).

## Contract

Land `AllenRelationSet` as an immutable Boolean value over exactly the thirteen `AllenRelation`
atoms:

- `None`, `All`, `Equal`, and validated singleton construction;
- validated construction from an atom sequence, with duplicates collapsed;
- membership, count, emptiness, subset, union, intersection, and complement;
- converse lifted pointwise from the existing atom inverse;
- value equality, hashing, and deterministic enumeration in Allen enum order.

The enum ordinals are made explicit as the internal bit index. The thirteen-bit representation
remains private: K1a creates no raw-mask, persistence, or wire-format contract.

## Law surface

- all \(2^{13}=8192\) values remain inside the thirteen-atom universe;
- Boolean identities, complement involution, commutativity, distributivity, and subset semantics;
- converse involution, cardinality preservation, complement compatibility, and union distribution;
- singleton converse agrees with argument reversal of `AllenAlgebra.Relate` on every pair of
  nonempty intervals in the six-boundary finite model;
- undefined enum casts fail at every public atom-taking boundary.

The implementation is checked against an element-wise test oracle rather than by exposing or
reusing its internal mask.

## Boundaries

No `AllenCompose`, canonical table, \(D_6\) triad generator, exact master-relative composition,
path consistency, generic qualitative-calculus descriptor, CLI wire form, or consumer migration
lands in K1a. The later [D27 sequencing adjudication](sol-doccer-k1b-k4-resequencing-20260804_184200.md)
assigned durable validation-filter migration to K1b and the terminal join's semantic replacement
to K2b. In particular, `ToString` is not a wire contract.

## Done criteria

- the value and its public XML contract compile without warnings;
- exhaustive finite value/converse tests and adversarial construction tests are green;
- D26, README, workplan, roadmap, ledger, and this report agree on the K1a/K1b boundary;
- the verified payload is refreshed after the full harness passes.

---

## Report

Completed 2026-08-04. Harness **1500 → 1561 checks green**; the verified local payload was
refreshed through `build-doccer.ps1`, including its delivered-assembly and CLI smoke checks.

`src/doccer/Algebra/AllenRelationSet.cs` now supplies the table-free value exactly as briefed. The
readonly struct stores a private `ushort`, admits bits only through validated `AllenRelation`
values, treats the default struct as `None`, and exposes no raw representation. Existing enum
ordinals were made explicit at 0–12 so the internal map cannot drift silently. Construction
collapses duplicates; enumeration is ordinal and deterministic; equality and hashing are value
semantics.

The harness checks constants, validation failures, duplication, order, equality/hash, membership,
and subset behavior directly. An independent element-wise oracle exercises every one of the 8192
values for complement and identity laws and places every value in both operand positions for the
binary Boolean laws. Converse is checked on all 8192 values and against classifier argument
reversal for all 225 ordered pairs of the 15 nonempty intervals on six boundaries.

D26 and the public README record only this value surface. `AllenCompose`, the canonical table, the
independent \(D_6\) triad oracle, the adjacent-gap counterexample, JEPD closure, and durable
validation-filter migration remain K1b. Per the later
[D27 sequencing adjudication](sol-doccer-k1b-k4-resequencing-20260804_184200.md),
`IntervalJoins.Join` transitions only when K2b supplies `ClaimPairView`; no provisional
composition, consumer overload, or wire contract leaked into K1a.

Follow-on: [K1b](sol-doccer-k1b-allen-composition-20260804_203325.md) subsequently landed the
composition/table/oracle and validation-filter work as D28 without changing that join boundary.
K1 is closed at 1577 harness checks.
