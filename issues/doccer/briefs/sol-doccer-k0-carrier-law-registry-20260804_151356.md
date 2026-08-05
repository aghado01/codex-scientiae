# Doccer K0 chip brief — carrier and law registry

Runstamp 20260804_151356. This is the first bounded chip from the
[architectural expansion workplan](../planning/architecture-expansion-workplan.md). Canon at entry:
D1–D24; contract harness: 1500 checks green.

## Purpose

Close the architectural vocabulary before adding another value type. The literature synthesis
showed that several superficially similar identities and compositions live on different carriers;
leaving that distinction implicit would let K1 or K2 accidentally donate one sort's laws to
another.

## Contract

K0 records, without adding engine types:

- valid master boundaries (`P`), located extents including diagonal empties (`L`), nonempty Allen
  intervals (`I`), identity-bearing claim occurrences (`C`), later canonical facts (`F`), and later
  cross-master origins (`O`) as distinct carriers;
- Allen `Equal` as geometric identity only, claim identity as an ordinal on one exact frozen
  batch, and future origin identity as an atom diagonal between compatible master bases;
- the sort-specific names `AllenCompose`, `ConcreteCompose`, `Seq`, `ComposePairs`, `Saturate`,
  `Select`, `ComposeOrigins`, and `Materialize`, with no unqualified public `Compose`;
- one assurance owner, landing gate, and concrete Lean reactivation condition for every reserved
  operation family through K7, while keeping policy contracts such as `Select` explicitly
  non-algebraic.

The canonical registry lives in [decisions.md](../planning/decisions.md), not in this runstamped
brief. The public summary lives in [the engine README](../../../src/doccer/README.md).

## Boundaries

No `AllenRelationSet`, table representation, new CLI surface, Lean harness, or speculative generic
relation framework lands in K0. K1 remains two code chips: the immutable thirteen-bit value layer,
then the independently encoded table and separate \(D_6\) oracle. Replacing ad hoc hash sets in
joins and validation follows the green value contract rather than being mixed into its definition.

## Done criteria

- D25 records the carriers, identities, reserved operation names, and assurance registry.
- README, architecture workplan, roadmap, and ledger agree that K0 is closed and K1 is next.
- The existing contract harness remains green; no check-count increase is expected for a
  definition-only chip.

---

## Report

Completed 2026-08-04. D25 and its assurance registry are canonical; the engine README now states
the carrier boundary without claiming later operations are implemented. The roadmap and workplan
name `AllenRelationSet` as the active next chip, and the ledger records K0 as definition-only.

No engine source or package payload changed. The contract harness remains **1500 checks green**.
