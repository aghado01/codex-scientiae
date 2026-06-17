# Mask-algebra fidelity hardening — implementation report

Implements [`.discussion/mask-algebra-fidelity-brief.md`](../.discussion/mask-algebra-fidelity-brief.md)
(the spec) — the **substrate** the re-layering in
[`.discussion/membrane-upgrade-plan.md`](../.discussion/membrane-upgrade-plan.md) puts *under* Tracks 3–4.
Goal: replace the 80/20 regex corruption detectors with **precision by construction** — a coarse
*overlay + complement (subtract)* over explicit *span levels*, validated by intrinsic algebraic laws +
reproduced-bug worked proofs + a differential A/B over the corpus (no labeled should-match corpus, which
the spec rejects as paper-thin supervision).

**Status:** landed and green. New module + four detectors ported atomically behind the shared
`latex.ps1` predicates; the spec's three compatibility contracts verified; a Pester 5 suite (52 tests)
added under `tests/`. `mcp-server.ps1` and the hotspots/dispatch code untouched, per scope.

**Verified:** `pwsh -File tests/run.ps1` → 52 passed / 0 failed; the full dot-source chain
(`serving.ps1` gate-path + `md-cleanup.ps1` scanner-path) loads clean.

---

## Layer 0 — `src/masks.ps1` (new): the closed primitive set

A `Mask` is a **normalized span set**: sorted, disjoint, half-open `[start,end)` UTF-16 offsets + the
length it is taken over. One representation, one enforced invariant; every op returns normal form
(construction merges overlap/adjacency, drops zero-length). Pure, no I/O.

| brief op | function | site |
|---|---|---|
| New-Mask | `New-Mask` (text+regex overlay \| raw spans) | masks.ps1:100 |
| Complement | `Complement-Mask` | masks.ps1:125 |
| Intersect / Union / Sub | `Intersect-Mask` / `Union-Mask` / `Sub-Mask` | masks.ps1:141 / :157 / :164 |
| Density | `Get-MaskDensity` (over `Get-MaskedText`, the apply bridge) | masks.ps1:206 / :191 |
| At-Level | `Split-AtLevel` (SpanLevel: Character/Line/MultiLine) | masks.ps1:228 |
| (pincer substrate) | `Move-Mask` / `Limit-Mask` (offset arithmetic / change-of-basis) | masks.ps1:248 / :254 |

**Discipline honored:** pure + total (defined on empty/full/partial; never throws on valid input —
`propose_edit` re-grades mid-repair, so an unbalanced intermediate is normal input); **codepoint-safe**
(edges snap outward off any surrogate pair — SMP 𝔼/𝕊 is two code units; `Move-OffsetToCodepoint*`);
O(n)/KB-bounded (a mask is a handful of spans; no quadratic growth). Naming note: the set-op verbs match
the spec's algebra names, namespaced `-Mask` (clean under dot-source; trivially renameable).

**Non-goals fence respected:** no SoA/DocPlane/bit-planes, no 64KB LUT, no hex addressing, no BPE, no
rule-table runner, no persisted mask sidecars. The calculus on the strings already held, full stop.

---

## Detector ports (overlay → complement → level)

Both shared predicates were re-expressed **in `latex.ps1`, the one home** — so the three consumers
(chunk grader `fidelity.ps1`, gate `serving.ps1` via `Get-CorruptionType`, assembled scanner
`md-cleanup.ps1` `Find-MathClosureIssues`) updated **atomically** with zero call-site churn.

### prose_in_formula — `Test-IsMath` (latex.ps1:82), overlay `$script:RxMathStructure` (latex.ps1:67)

**Finding (reproduced bug):** old `Test-IsMath` strips `\commands` then counts 4+-letter words ≤ 2.
Environment NAMES (`aligned`/`cases`/`array`) are brace *arguments*, not commands, so they survive the
strip — a legit multi-environment formula counts 6 leaked words → false `prose_in_formula`.

**Change:** prose-word density in the **complement** of a coarse math-structure overlay (`$…$`,
`\begin{…}`/`\end{…}` + name, `\cmd{…}` arg, sub/superscript groups, bare commands). Env names live
*inside* the overlay → masked → never counted. The ≤2 threshold and decision boundary are unchanged;
only *what gets counted* changed. **The false positive is gone by construction.**

**Before/after:** `\begin{aligned}\begin{cases}…\end{cases}\end{aligned} + \begin{array}{cc}…\end{array}`
→ old `False` (prose), new `True` (math).

### alignment_outside_env — `Test-AlignmentOutsideEnv` (latex.ps1:109), `Get-EnvironmentSpans` (latex.ps1:92)

**Finding (recall hole):** old returns flagged iff (unescaped `&`) AND (no `\begin{` *anywhere* in the
chunk) — so a bare `&` in a region no environment covers is missed whenever any environment exists
elsewhere in the chunk.

**Change:** `Sub-Mask(bare-&, environment-overlay)` non-empty. Environment coverage is a nesting-stack
scan (`Get-EnvironmentSpans`, mirrors `Get-LatexBalance`'s discipline): each `\begin` opens, each `\end`
closes the innermost; an **unclosed `\begin` covers to end-of-string** (an open env still contains a
trailing `&`, so it is not flagged — this preserves the old "\begin present → pass" on unclosed input).

**Before/after:** `$$ \begin{aligned} a &= b \end{aligned} \quad c &= d $$` → old `False` (miss), new
`True` (the `&` after the closed env is caught). Compat cases unchanged: unclosed `\begin`, literal `\&`,
nested envs all `False` old==new.

### unwrapped_math / math_dirt — `normalize.ps1:400`

**Finding:** `math_dirt` was already an *unnamed* overlay-and-complement (`MathLatexRx` count outside the
`$…$` spans). It is a **frozen shared-signal contract** — feeds the hotspots/dispatch `math_dirt ≥ 2` gate
(`serving.ps1` `Group-MathHotspots`, `fidelity.ps1`).

**Change:** re-expressed as the named algebra
`Density(MathLatexRx, Complement($…$_mask))` — **value-identical** to the old blank-and-count
(`MathLatexRx` matches single glyphs, so blank width is irrelevant). Proven 0 mismatch over 1304 chunks +
0 stored-value mismatch, so the `≥2` gate cannot move.

**Deliberately deferred:** the spec's further refinement — also subtracting a *prose-context* overlay
(`α-helix`, unit glyphs, isolated symbols) — would *change* the frozen value and so requires updating the
hotspot/dispatch consumers in lockstep + re-verifying hotspots. Out of scope for a contract-preserving
detector pass; it is a one-line `Sub` when the policy layer is built. (Escalated per the non-goals rule.)

### gibberish — `Test-IsGibberish` (fidelity.ps1:41)

**Change:** Line-level (`Split-AtLevel`) longest run of **consecutive single-ALPHABETIC tokens**, with the
`$…$` math overlay masked first. Two construction fixes over the old whole-content `(?:\b\w\s+){6,}`:
alpha-only (number runs `1 2 3 …` stop false-firing — old `\w` counted digits); the *run*, not a 7-long
minimum (catches short shatters the old missed). `MinRun=4` calibrated against the corpus A/B.

**Calibration (why the run, not a window):** a windowed density can't separate genuine shatter from the
false positives — `b k i and d k i` (flattened subscripts, 6 singles/8 tokens, run **3**) looks identical
to `A l p h a ( W ,` (genuine, run **5**). The consecutive-run length is the separator; masking `$…$`
additionally drops single-letter runs that are legit *wrapped* math (`$… i z i z * i …$`).

---

## Validation (intrinsic + differential, never supervisory)

- **Algebraic laws** (over 100 random masks each): `Complement∘Complement=id`, `Sub A A=∅`,
  `Union A (¬A)=full`, `Intersect A (¬A)=∅`, both De Morgan, normalize idempotent, ∩/∪ idempotent, Sub
  identities. Plus totality (empty/full/reversed/out-of-range/overlap/adjacent), codepoint safety
  (SMP/surrogate snap, U+FFFD round-trip), and the **pincer** coincidence (Line-level masks lifted back ==
  the whole-string mask).
- **Reproduced-bug worked proofs:** the two before/after flips above, pinned as `It` regressions.
- **Differential A/B** over the preprocessed corpus (1522 chunks / 3 docs), `Get-CorruptionType` old vs
  new per chunk: **1518 identical**, 0 reject→accept, 0 type-change, **4 accept→reject — all `gibberish`**
  (genuine single-letter-run degradation old missed: shattered `has/and/rank`, `Alpha`, `Tri`, and a
  destructured 2×2 matrix `x y y z`). `prose_in_formula` and `alignment_outside_env` produced **0 gate
  flips on the corpus** — decision-identical everywhere, while fixing the reproduced bugs. Net:
  match-or-reduce false flags, never increase misses.

---

## Compatibility — the three seam contracts (spec §Compatibility)

- **(a) merge-gate + fixed point.** Per-chunk accept/reject preserved (above). detector∘normalize fixed
  point: 211/211 clean formula chunks stay clean after `apply`'s
  `Repair-MathAlignment∘Convert-MathToLatex∘Optimize-MathContent` (0 oscillation); the alignment fixer
  resolves the new recall flag (`True→False`).
- **(b) cross-derivation atomic.** Predicates have one definition (`latex.ps1`); all three consumers load
  it. The scanner (`Find-MathClosureIssues`) now flags the recall hole end-to-end — gate and scanner agree.
- **(c) frozen shared signals.** `math_dirt` byte-identical (proof above); `Get-LatexBalance` untouched;
  `Group-MathHotspots` unaffected.

---

## Test infrastructure (new) — `tests/`, Pester 5

The ad-hoc dev probes were consolidated into a Pester 5 suite (one `*.Tests.ps1` per concern, module
dot-sourced in a top-level `BeforeAll`; reproduced bugs + calibration pinned as named `It`s):

- `masks.Tests.ps1` (18) — algebra laws / totality / codepoint / pincer.
- `detectors.Tests.ps1` (19) — `Test-IsMath` / `Test-AlignmentOutsideEnv` / `Test-IsGibberish` /
  `Get-CorruptionType` on fixed inputs.
- `normalize.Tests.ps1` (6) — `Optimize-MathContent` (idempotency/tag/balance), `math_dirt` identity,
  `Invoke-MarkdownCleanup` idempotency. *(folds in `compendia/clustering/tmp/test_optimize_math.ps1` +
  `test_md_idempotent.ps1`.)*
- `corpus.Tests.ps1` (7) — `Group-MathHotspots` synthetic + the corpus A/B compatibility checks (skip
  cleanly with `Set-ItResult -Skipped` when nothing is preprocessed).
- `run.ps1` / `README.md` — runner + convention.

**Env note (portable-integration degraded):** the PowerShell tool currently runs the *system* pwsh
(`$PSHOME` under Program Files), whose module path only surfaces the ancient Pester **3.4.0**. Pester
**5.7.1** lives in the portable tree; `run.ps1` imports it by explicit path anchored on
`$env:PORTABLE_ROOT/PowerShell/Modules/Pester`. `scratch/` remains the home for assert-nothing dumps
(`test-formulas`/`test-hotspots`/`test-dispatch`).

---

## Deferred / open (carried into the next pass)

1. **Prose-context refinement of `unwrapped_math`** — changes the frozen `math_dirt`; needs the hotspot
   consumers updated in lockstep + re-verified. One `Sub` when the policy layer lands.
2. **Pincer *policy* readouts** — agreement-score dispatch ranking + the impossibility-gate rejection op
   (plan's merged Tracks 3+4). The *substrate* (offset arithmetic + the coincidence law) is in place; the
   spec says do **not** build these on the old predicates. This is now unblocked.
3. **`Test-MathRow`** (`normalize.ps1`, used by `Get-UnbledFormula`) — a separate row-level math/prose
   heuristic, still the old strip-list. Out of the brief's four detectors; candidate to delegate to
   `Test-IsMath` later (touches the un-bleed/vocab subsystem, so scoped out here).
4. **Corpus breadth** — A/B ran over the 3 preprocessed docs; the other 19 have no chunk stream yet.

---

## Roadmap delta (updates `membrane-upgrade-plan.md` §Re-layering)

- **Substrate (was "in flight") → LANDED.** The mask algebra + SpanLevel + the pincer coincidence are the
  critical-path substrate, now real and validated.
- **Policy (merged Tracks 3+4) → UNBLOCKED, not started.** agreement-score (the pincer's agreement
  readout) and the impossibility gate (its contradiction readout) can now be built *on these primitives*
  rather than the old predicates.
- **Tail:** `OffsetMap` is effectively seeded by `Move-Mask`/`Limit-Mask` (the change-of-basis). No
  persisted sidecars introduced, consistent with the retired `inventory.jsonl`-as-validation-matrix call.

---

## Net files touched

**Source (4):** `src/masks.ps1` (new), `src/latex.ps1` (Test-IsMath / Test-AlignmentOutsideEnv re-expressed
+ `Get-EnvironmentSpans` + overlay regex + dot-source masks), `src/fidelity.ps1` (`Test-IsGibberish` +
gate swap), `src/normalize.ps1` (`math_dirt` as named `Complement`/`Density`).
**Tests (6):** `tests/{masks,detectors,normalize,corpus}.Tests.ps1`, `tests/run.ps1`, `tests/README.md`.
**This report:** `.claude/mask-algebra-fidelity-report.md`.
