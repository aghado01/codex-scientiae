Cursor's Part B is in. Let me read its report and see what landed:

112/112 per the report, `masks.ps1` untouched, reuses the shared table — all good signs. But I want to look hard at one interaction the test summary makes me uneasy about: the merge gate rejecting unbalanced results vs. Track 2's hotspots. Let me read the gate logic and run the suite:

112 green, but the diff confirms the interaction I was worried about — and it's a real one. Let me demonstrate it concretely:

That's a real bug, and the test missed it. Here's the picture:

## Part B is well-built — except for one deadlock

The good is real: `Get-StructuralImpossibility` reuses the shared `$script:CorruptionSignatures` (no fork), the wiring evaluates the *would-be* result before `Save-Structure` and rejects with the right shape, `masks.ps1` is untouched, and 112 tests pass. The `alignment_outside_env` and `prose_in_formula` gates are correct and conflict with nothing (a merge includes all span members, so the env/label is always complete).

**But including `unbalanced_delimiters` in the structural-impossibility set deadlocks Track 2.** The demonstration above is unambiguous:

1. `Group-MathHotspots` **detects** a partial-balance fragmented formula (it promotes any span where the join is *more* balanced than the parts — `joinRes < sumPartsRes` — not only fully-balanced joins) and dispatches a *"merge_chunks the span"* work-order.
2. The merged join is still unbalanced (`lr=1`) — which is **expected**: the worker fixes the seam *after* merging, because the partner delimiter lives in a sibling chunk and can't be closed before the merge.
3. Part B's merge gate **rejects** that merge as `unbalanced_delimiters`.

So the work-order says "merge," the gate says "can't" — and the worker can't pre-balance either (partner is in a sibling). The repair path for exactly the fragmented formulae that *also* have a delimiter problem — the ones most in need — is dead. The Part B test only exercised a *fully-balanced* join, so it passed without catching this.

## Root cause is my brief

I over-specified: the Part B brief said "a merge result must satisfy `Get-LatexBalance.full`." That conflates a **fixable corruption** with a **structural impossibility**. `unbalanced_delimiters` is the membrane's bread-and-butter flag-and-fix case (`propose_edit` closes it); the merge-then-fix workflow *requires* merging an unbalanced intermediate. The genuine structural impossibilities are the mis-*geometry* ones (`alignment_outside_env`, `prose_in_formula`), which no workflow needs to pass through.

## The fix

Drop `unbalanced_delimiters` from `$script:StructuralImpossibilityTypes` (keep the two geometry checks):

```powershell
$script:StructuralImpossibilityTypes = @('alignment_outside_env', 'prose_in_formula')
```

Nothing weakens: `apply`'s content gate (`Get-CorruptionType`) still refuses to merge an unbalanced *proposal*, so unbalanced content never sneaks into the deliverable — the structural op just stops *deadlocking* on it. Test changes: the two "unbalanced retype/merge → rejected" tests flip to **pass**, and add the missing one — a **partial-balance** fragmented-formula merge must succeed (the case that was never tested).

(If you'd rather keep *some* merge guard, the surgical alternative is to reject a merge only when it *worsens* balance — `joinRes > sumPartsRes` — which still lets every hotspot merge through. I lean toward the clean removal: unbalanced is the content path's job, full stop.)
