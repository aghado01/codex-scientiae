## What I verified

**Harness:** `1577 checks passed` — exactly the roadmap's number.

**The 169-cell table:** I rebuilt it from scratch in a throwaway script that shares nothing with the engine — relations derived from endpoint sign-signatures rather than the engine's cascade, intervals half-open over 6 boundaries:

```
intervals: 15  triples: 3375
cells compared: 169  mismatches: 0  empty: 0  atomic triads witnessed: 409
identity failures: 0  converse-reversal failures: 0  weak-associativity failures (atoms): 0
```

409 triads is D28's stated number to the digit. The literal array is exactly 169 hex cells, so the row-major indexing can't be off-by-count. Identity/converse-reversal/associativity hold over the shipped table for all 2197 atom triples. `AllenCompose` is correct.

**D27's no-half-measure boundary is honored in code**, not just in prose: [IntervalJoins.Join](src/doccer/Algebra/AllenRelation.cs:106) still takes `IReadOnlySet<AllenRelation>`, untouched; only [RelationRequirement](src/doccer/Validation/Validation.cs:22) and `ForbiddenRelation` migrated. That is what D28 promises.

**Canon agreement:** roadmap "D1–D28" ↔ decisions D25–D28 ↔ ledger rows ↔ workplan §11 "joint K2a–K2c contract brief" ↔ roadmap "active next move". README lists `AllenRelationSet`/`AllenCompose` as implemented and the later names explicitly as reservations. All four surfaces agree. All three briefs carry `## Report`.

## Findings

**1. `ComposePairs` has no soundness law against `AllenCompose` — substantive, and cheap to fix now.** D28 calls canonical composition an _upper approximation_; the adjacent-gap counterexample pins why it isn't exact. But that's currently a description, not a claim anyone checks: the K2-CONCRETE-PAIRS assurance row lists exact-basis refusal, extensional identity, associativity, projections, semijoins, join replacement — and no containment obligation. The natural bridge law is that exact `ComposePairs` results are contained in `AllenCompose` of the component relation sets. Without it, "upper approximation" is unfalsifiable, and worse, nothing stops a later optimizer from _implementing_ `ComposePairs` via the canonical table — the exact failure the counterexample was retained to prevent. Belongs in the joint K2 contract brief, and as a line in the K2-CONCRETE-PAIRS evidence column.

**2. The relation-set surface is now double-typed, with no dated owner.** Two public ways to say "a set of Allen relations" coexist until K2b retires the join. That's recorded as a _boundary_ (D27 ¶1) but not as a _debt_ — and the roadmap simultaneously blesses provisional PowerShell adapters reaching into the packaged DLL during the latex-ingest rewrite. Those adapters are exactly the consumers who'd have to pick. Worth one roadmap line naming this the single accepted transient inconsistency with K2b as its sole closure, plus a note that census adapters should avoid `Join` since it's scheduled for retirement-or-projection.

**3. No diagnostic rendering for `AllenRelationSet`.** Nothing is broken — validation messages format single relations. But "expected one of {…}" is the obvious next message, and D26's "no wire form" exclusion leaves it ambiguous whether a diagnostic `ToString`/`DebuggerDisplay` is even permitted. Settle it in one sentence before three sites improvise a formatter. By your own bins this is a _missing example_, recipe-grade, not engine work.

**4. Minor, no action needed now:** enumeration allocates — iterator `GetEnumerator()` plus `IReadOnlyCollection<>` on a readonly struct means boxing on any interface-typed use. Zero impact today (`Contains`/`Converse`/`AllenCompose` are all bit ops). If K2b filters per-pair by enumerating, a struct enumerator is a non-breaking add at that point.

**5. Cosmetic:** both validation records assign the property and _then_ check `IsEmpty` ([Validation.cs:52](src/doccer/Validation/Validation.cs:52), [:95](src/doccer/Validation/Validation.cs:95)), unlike the guard-first checks above them. Harmless, but the file now has two guard styles.

## One thing worth knowing

The ordinal pin at [Program.cs:517](tests/doccer/Program.cs:517) asserts the ordinal _set_ is {0..12} — it does not bind names to ordinals. A swapped declaration would pass it. The actual guard against a reordered enum silently corrupting the table is the D₆ oracle, because it indexes by `(int)relation`. So D28's "the harness does not reuse that representation" is load-bearing twice over: for cell values _and_ for the index binding. If anyone ever proposes reusing the shipped table to speed the oracle up, that's the sentence to point at.

Planning-wise this is tight work — K0→K1a→D27→K1b is a clean sequence, the counterexample is pinned at the right place, and the non-goals list in §10 is doing real work. Finding 1 is the only thing I'd fold in before the K2 brief is written.
