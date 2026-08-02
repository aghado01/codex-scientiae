# Doccer Tranche 3b chip brief — group + project with basis stamping (+ rider T2-4)

Runstamp 20260802_011103. Minted by the same piloting session that executed 3a
([fable-doccer-t3a-brief-20260802_005408](fable-doccer-t3a-brief-20260802_005408.md)); executed
in-session immediately. Canon: [planning/decisions.md](../planning/decisions.md) (D1–D20),
[planning/roadmap.md](../planning/roadmap.md); contract surface `src/doccer/README.md`. Harness:
1407 checks green.

## Objective

Land the remaining two lift operations short of materialize (D7): **group** — claims under an
explicit key, and claims onto the master's line grain — and batch-level **project**, both as
**basis-stamped derived views**. This chip also establishes the basis-stamp shape that 3c's gap
cadence will consume for its "window basis" and "boundary policy" declarations (D8).

## Contract sketch (close before implementing)

- **Basis stamping, in-process form**: a derived view answers "over what was I computed" with
  typed references and named policies on the view object itself — the master (coordinate
  space), the source batch, the key or membership policy. String-serialized basis stamps are
  F2's business, not this chip's.
- **`Grouping.ByKey(batch, selector, comparer?)`** — the batch sibling of `EmitRuns`' break-key
  discipline (D4): groups carry the key they grouped on; deterministic contract = groups in
  first-appearance order (interning precedent), ordinals ascending within a group; caller
  comparers honored; key-only grouping must not force the topology (D12).
- **`Projection.Project(batch)`** — claim-major: one `LineRange` per ordinal via the existing
  span-level `TextTopology.Project`, stamped with master + source.
- **`Grouping.ByLine(batch, membership)`** — line-major: total over `LineCount` (claimless
  lines present, empty), each line carrying its extent (the full partition extent, not D15's
  content extent — matching convention ≠ partition grain; say so in the docs) and the ordinals
  of claims it holds under a **named membership policy**: `EveryLineTouched` (occupancy) vs
  `StartLineOnly` (attribution — each claim exactly once, at its start line). Boundary behavior
  is a declared policy, never an implicit choice (D8 discipline, established here).
- **Transpose law** ties the two directions: under `EveryLineTouched`, ordinal `o` lists line
  `i` in its projected range ⟺ line `i` lists ordinal `o`.

Questions to close and record:

1. The basis-stamp shape above — confirm or amend, then record it as the doctrine 3c inherits.
2. Membership policy set — the two named ones, with more only when witnessed.
3. **T2-4 rider**: claim-fact selectors as plain typed delegates (`Func<SpanRecord, TKey>`)
   with a discoverable `ClaimFacts` vocabulary mirroring `AtomFacts` — or promotion to a
   binding record. Decide and record; two parallel fact vocabularies sharing one shape would
   settle the question by precedent.

## Law surface

ByKey: partition (every ordinal exactly once), first-appearance group order, ascending
ordinals, key carried, custom comparer honored, determinism on repeat, empty batch, laziness
(no topology forced). Project: count parity with the batch, agreement with span-level
`Project`, stamps reference-equal to the batch's master and the batch. ByLine: totality over
`LineCount` including claimless and empty final lines, extent = `GetLineExtent`, transpose law
vs `Project` under `EveryLineTouched`, `StartLineOnly` = partition attributed at
`GetLineIndex(span.Start)`, the two policies differing exactly on multi-line claims,
determinism, cross-master hygiene via the stamped references.

## Boundaries

No materialize (stays pending in D7). No density measures (3c). No serialized basis stamps
(F2). No new claim mutation paths — views hold ordinals into the frozen batch, they never copy
or re-resolve claims. Admission test (D10) applies; keep README/planning in agreement; targeted
commits citing this brief; refresh the payload after engine changes.

## Done criteria

Contracts recorded (D-rows), laws green with the new check count stated, README/planning
updated, payload refreshed, report appended below.

---

## Report

Completed 2026-08-02, in-session by the minting agent (same mode as 3a). Harness
**1407 → 1456 checks green**; payload refreshed via `build-doccer.ps1`.

**Contract closures (D21, D22):**

1. **Basis-stamp shape confirmed as sketched**: in-process views stamp typed references and
   named policies on the view object — `Source` batch, `Master` through it, key or
   `Membership`. Views hold ordinals into the frozen batch, never claim copies. Serialized
   stamps deferred to F2, as briefed.
2. **Membership policies**: the two named ones only — `EveryLineTouched` (occupancy) and
   `StartLineOnly` (attribution). Undefined casts refused (D9 discipline). More policies wait
   for witnesses.
3. **T2-4 closed as D22**: selectors stay plain typed delegates; `ClaimFacts` now mirrors
   `AtomFacts` (Kind/Source/RuleId/Priority/Level, tuple composition, caller comparers). Two
   parallel fact vocabularies sharing one shape settle the promotion question by precedent —
   no binding record.

**Implementation notes**: `Grouping.ByKey` handles null keys (absent rule ids) by diverting
them around the dictionary rather than constraining `TKey : notnull` — null is a legitimate
fact value, and the interning precedent (`InternedColumn.NullId`) says so. First-appearance
group order, ascending ordinals, one key evaluation per claim (the `EmitRuns` discipline).
`ByLine` extents are partition extents (`GetLineExtent`), deliberately not D15 content
extents — matching convention ≠ partition grain, stated in the docs.

**Law surface landed** (`GroupingByKeyIsADeterministicPartition`,
`ProjectionAndLineGroupsAreStampedTransposes`, `LineMembershipIsADeclaredPolicy`): keyed
partition totality, first-appearance order, comparer/tuple/null-key behavior, determinism on
repeat, laziness (key-only grouping leaves topology unbuilt); projection/count parity and
agreement with span-level `Project`; line-view totality including claimless and empty final
lines; the transpose law both directions under `EveryLineTouched`; `StartLineOnly` as a
partition attributed at start lines, with the two policies differing exactly on multi-line
claims.

**Files**: `src/doccer/Algebra/Grouping.cs` (new); harness +3 methods; README contracts +
absent list + D-range; decisions.md D7 status, D21, D22, Open-list cleanup; roadmap state +
queue. Tranche 3 remainder: 3c gap cadence, 3d priority lookup — both now unblocked on the
vocabulary this chip established.
