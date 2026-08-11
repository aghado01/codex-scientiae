# Tracing guards backwards: placeholder restoration is store-driven, and nothing checks the text

**Status:** investigation + proposed fix
**Date:** 2026-07-31
**Touches:** `src/latex-ingest/latex-ingest.ps1`, `src/md-postprocess/md-bundle.ps1`
**Companion to:** `refs-consolidation-20260731.md` (same rot, different seam)

---

## 1. Method

Forward scanning for code that "looks like repair" has no ground truth — it produces a list to
eyeball, and it cannot see the defect that actually bit us (a field computed by a callee and
overwritten by its caller is a data-flow fact, invisible to any line-level pattern).

The tractable method is **abductive and backwards**: start at a late-stage check or fix, and ask
what it is defending against. The guard's existence is the observation; the upstream condition is
the hypothesis. Then the decisive question is counterfactual:

> If the pipeline addressed this upstream, would this check still be necessary?

### 1.1 The discriminator is STAGE, not origin

A first cut said: internal causes belong upstream, external ones (malformed author input) justify
late defense. **That is wrong.** Malformed source is a property of the *source* — knowable the
moment it is parsed. Detecting it in emitted markdown means the defect was carried through the
entire pipeline before anyone noticed, and every intermediate stage operated on known-bad input.

The real discriminator is: **at what stage does this fact first become knowable?** Detection belongs
there. Anything downstream of that point is either redundant or a backstop for a state that should
be impossible — and a backstop should say so, rather than being the primary detector.

So there are two dispositions, not three:

- **detected at the earliest knowable stage** — correct
- **detected later than it was knowable** — misplaced, regardless of whether the cause is internal
  or external

---

## 2. Worked example: the placeholder sentinel

**Observation.** `md-bundle.ps1` counts surviving `@@[A-Z]+\d+@@` markers in the shipped markdown
and reports them as a defect sentinel.

**What is it defending against?** The converter protects fragile spans (math, pseudocode, verbatim,
figure slots) by swapping them for placeholders, then restores them later. A surviving placeholder
means a restore did not happen.

**When is that knowable?** At the restore boundary — immediately. The store knows what it created.

**Verdict:** misplaced. And the situation is worse than misplacement, because the restores cannot
detect their own failure at all.

### 2.1 All five families restore in the wrong direction

| family | created | restored | how |
|---|---|---|---|
| `ALG` | 311, 319 | 331 | `foreach ($id in $script:AlgStore.Keys) { $T = $T.Replace($id, …) }` |
| `VERB` | 346 | 334 | `foreach ($id in $script:VerbStore.Keys) { $T = $T.Replace($id, …) }` |
| `LMATH`/`LDISP` | 900 | 1088–1097 | bounded 8-pass regex loop over the text, store lookup per hit |
| `FIGSLOT` | 1920 | ~1954 | `foreach ($j in $pdfJobs) { $Markdown.Replace($j.ph, …) }` |
| `EPSSLOT` | 1935 | ~1970 | `foreach ($j in $epsJobs) { $Markdown.Replace($j.ph, …) }` |

Every one is **store-driven**: iterate what was stored, substitute it into the text. That
establishes "every stored item was written out."

The invariant that actually matters is **text-driven**: *no placeholder remains in the text.*

Those are different statements, and store-driven restoration is structurally silent about the
difference. A placeholder present in the text but absent from its store is never visited, never
replaced, and never reported. That is exactly the leak the downstream sentinel counts — which makes
the sentinel the **only text-driven check in the entire pipeline**, sitting at the very end.

### 2.2 The additional silent exits

Beyond the shared direction error, each family has its own:

- **`LMATH`/`LDISP`** — the loop is bounded at 8 passes, and its per-hit fallback is
  `else { $m.Value }`. Nesting deeper than 8, or a placeholder missing from the store, exits with
  the text unrestored and returns as if successful. **The function already knows it failed**: its own
  loop condition `$Text -match '@@L(?:MATH|DISP)\d+@@'` is evaluated on exit and is still true. The
  information exists at the moment of failure and is discarded, then reconstructed downstream by
  counting damage in the shipped output.
- **`FIGSLOT`/`EPSSLOT`** — the restore loops sit inside conditional blocks gated on the render
  harness. If the guard is false or the harness fails, no substitution runs at all and every slot
  placeholder survives.

---

## 3. Fix

Small, uniform, and it moves detection to the stage where the fact is knowable.

1. **Assert the text-driven invariant at each restore boundary.** After a family's restore, the text
   must contain none of that family's placeholders. If it does, that is a converter bug — throw, or
   record it into the run's result so the failure names *which store leaked*, not merely that
   something did.
2. **Remove the bounded-pass silent exit.** If `Restore-LatexMath` exhausts its passes with
   placeholders remaining, it has failed; say so rather than returning.
3. **Demote the md-bundle sentinel to a backstop.** Keep the count — a backstop that never fires is
   cheap — but it stops being the mechanism that discovers the problem, and its firing becomes
   evidence of a bug in step 1 rather than routine hygiene.

This converts a silent corpus defect into a loud converter failure, which is the whole point: a
leaked placeholder in a shipped document is unrecoverable without re-conversion, while the same
condition at the restore boundary is a stack trace.

---

## 4. Next candidates for the same trace

Guards worth putting the counterfactual to, in rough order of expected yield:

- `Get-LatexSubjectIndex`'s `if ($at -lt 0) { continue }` — skips an object whose emitted header
  cannot be found. What rewrites a bold run-in header after emission? If nothing does, this is a
  dead guard (category 3: the cause was already fixed, so the check is permanently false and
  indistinguishable from a live one). Added 2026-07-31, so it is a fresh specimen of writing a
  defensive skip instead of asking why the lookup could fail.
- The `md-bundle` `assets_missing` / `broken` reporting — a referenced image absent at the
  destination is knowable when the link is rewritten, not after the bundle is assembled.
- `render_check` failures generally — a math span that will not render under KaTeX is knowable when
  the span is lowered into the register, not after the document ships.
- `Convert-ImageLinks`' idempotence note ("a path already under `images/` never re-matches") — an
  idempotence guard usually means the function is called at an unclear point in the order.

---

## 5. What the mechanical sweep found, so it is not redone

A forward syntactic scan was tried first and is recorded here for its reach, which is small:

- `$body` mutations in latex-ingest classified by what their pattern targets: **51 source-directed
  (transformation), 0 output-directed (repair), 25 ambiguous.** The body pipeline is healthier than
  the raw count of ~70 mutations suggests.
- `src/audits/md-cleanup.ps1` — the most repair-named file in the tree (`Repair-Ligatures`,
  `Repair-SplitEquations`) — has **zero callers**. Hand-run docling-era utility, in no pipeline.
- The `Build-LabelMaps` overwrite documented in the companion brief was **invisible to all of it**,
  being a cross-function data-flow fact.

Conclusion: syntactic scanning is not the instrument. Backward tracing from guards is, and pinned
invariants (companion brief, step 1) are what make dead or contradictory derivations fall out
without having to spot them by eye.
