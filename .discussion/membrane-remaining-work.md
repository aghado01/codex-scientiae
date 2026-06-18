# Brief — remaining membrane work (post-pincer backlog)

The pincer policy is **complete**: agreement **RANKS** (Part A), difference **DISPATCHES** (the spine),
contradiction **GATES** (Part B, incl. the merge/split *worsens* guards). This consolidates everything
deferred across the arc into one prioritized handoff, so a fresh session / Cursor can pick up cold. Live
status is [`membrane-upgrade-plan.md`](membrane-upgrade-plan.md) §Re-layering; per-feature design is in the
sibling briefs ([`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md),
[`pincer-policy-brief.md`](pincer-policy-brief.md), [`composite-work-orders-brief.md`](composite-work-orders-brief.md)).

## Landed (don't re-do)
Substrate `masks.ps1` + 4 mask-algebra detectors · Part A `agreement` (fidelity.ps1) + stable-sort dispatch ·
spine: `Get-ChunkIssues` + `Group-Deliverables` + `playbook.ps1` + `New-WorkOrder` on `get_slice` · Part B
geometry-impossibility gate + merge/split worsens-guards (restructure.ps1), all reusing the one shared
`$script:CorruptionSignatures` table. **Full suite: 115 green.**

## Remaining work (prioritized)

1. **Localized spans — the difference-localization** *(biggest lever)*. Upgrade work-order issues from
   chunk-level `{type, diagnostic}` to span-localized `{type, spans, diagnostic}` — "wrap the math at
   offsets [a,b)", not "this chunk has unwrapped math." The mask difference `Sub(math-structure, inline-$…$)`
   localizes the un-wrapped math; each residual span is a precise repair target. Closes the
   detect→localize→fix→reconcile loop. *Scope:* `Get-ChunkIssues` emits per-issue spans (reuse `masks.ps1`);
   `New-WorkOrder` carries them; worker wraps each. **Keep chunk-level granularity** (spans are hints, not
   new work-units); body-light; lazy. Pairs with #2/#3 (shared inline-math mask).

2. **Agreement math-pair refinement** *(safe subset, quick)*. In `Get-AgreementScore`'s prose branch,
   `Sub` the inline-`$…$` mask before the IoU so legit inline-math prose scores 1, not 0 (today the math pair
   pins any prose-with-inline-math to max-dispute). *Scope:* one spot in `fidelity.ps1`; expose
   `Get-InlineMathMask` beside `Get-MathStructureMask` in `latex.ps1` (one home); add a test. Does **not**
   touch the frozen `math_dirt`. Low risk.

3. **`math_dirt` prose-context refinement** *(moves the frozen value — lockstep)*. Subtract a prose-context
   overlay (`α-helix`, unit glyphs, isolated symbols) from the `math_dirt` residual to cut false un-wrapped
   flags. *Scope:* `normalize.ps1`; **moves the frozen `math_dirt` value → MUST update the hotspot consumer
   (`Group-MathHotspots` `math_dirt ≥ 2`) in lockstep + re-verify the frozen-contract test.** Higher risk
   than #2; pairs with #1/#2.

4. **`Test-MathRow` consolidation**. Fold `Test-MathRow` (`normalize.ps1`, via `Get-UnbledFormula`) into the
   hardened `Test-IsMath` — the last un-consolidated "is-this-math" derivation, still on the old strip-list
   (the exact drift the effort set out to kill). Lives in the un-bleed/vocab subsystem; verify that path.

5. **Playbook-as-data: complete + de-duplicate**. Recipes now live in **both** `PROCEDURE.md` (prose) and
   `playbook.ps1` (data) — a drift surface. Pick a single source (generate one from the other, or a check
   that they match) and fill any missing entries. Low risk.

6. **Split-guard regression test** *(from this session's fix)*. Add: a clean split of an already-unbalanced
   chunk **passes** (imbalance falls in one half, doesn't worsen); an orphaning split still **rejects**. The
   worsens-fix changed the split guard from absolute to relative and is currently unit-untested. Trivial.

7. **`gibberish` `MinRun` re-calibration**. `Test-IsGibberish MinRun=4` is calibrated on the 3 preprocessed
   docs; re-validate (re-run the corpus A/B) when the other docs get a chunk stream. Data-dependent.

8. **Deferred tail (long-horizon)**. **OffsetMap** — byte-exact source coords; seeded by `masks.ps1`
   `Move-Mask`/`Limit-Mask`; lets `propose_edit` anchor against source not finalized output. **Hooks** (batch
   governor) **+ constitution** prose — Layer-2 governance (the reach-past defense + the orchestrator↔worker
   compact). `inventory.jsonl` stays **retired** as a validation matrix (validation is intrinsic now).

## Sequencing
#6 and #2 are quick/safe — do anytime. **#1 is the main lever** (completes difference-dispatch; pairs with
#2/#3 on the shared masks). #3 needs the lockstep-with-hotspots discipline. #4/#5/#7 are independent
cleanups. #8 is the tail.

## Discipline (carries to all of it)
Frozen single-type gate · body-light dispatch · chunk-level deliverable granularity · reuse the shared table
/ `masks.ps1` (no fork, no drift) · codepoint safety (UTF-8-no-BOM, surrogate-safe offsets) · no rule-engine ·
lazy / no sidecars · behavior-preserving-or-better, guarded by the differential A/B + the 115-test suite.
