# Tier-2 figure-clustering — handoff to the main session

**Status:** foundation LANDED 2026-07-05 (commits `30cd08c` harness, `ad4aa09` Lane 5, + a follow-up that
re-framed the oracle into two populations — see below). This picks up where `foundation-scope.md` ends.
**Consensus milestone-1 LANDED + measured + circled-back 2026-07-05 (`ea13156`)** — scoreboard and the
re-diagnosed ledger below are current; next highest-yield step = the C-fix (caption in the region's
lower band, WITH shape guard), then the 2210-residual diagnosis under "Next experiments" §2.

**The big correction (2026-07-05):** the original "fragmentation over-count tail" was largely a **measurement
artifact**. The oracle counted `\includegraphics + tikz` as one number, which (a) conflated captioned figures
with **inline commutative diagrams** (tikz-cd / xy-pic — the mathematical content of a zigzag/category-theory
paper, inline like display equations, not captioned figures) and (b) **silently missed all xy-pic**. Once you
separate the two populations, pig's real-figure detection is already good and 2210's headline "+38" is 0.

---

## What's on disk now — use these, don't rebuild

- **The gate (standing benchmark).** `src/pdf-converter/Compare-FigureCounts.ps1`:
  ```
  pwsh -File src/pdf-converter/Compare-FigureCounts.ps1            # ph-zigzag by default
  pwsh -File src/pdf-converter/Compare-FigureCounts.ps1 -Json      # machine-readable
  ```
  Reads the **newest** pig run per paper. It now scores **two populations**:
  - **PRIMARY** — pig **captioned** regions vs `\begin{figure}` floats ("did we find the real figures").
  - **SECONDARY** — pig **uncaptioned** regions vs **inline diagrams** (tikz/xy outside floats).
- **Oracle counts.** `Get-LatexOracleCounts` in `latex-ingest.ps1` (the ONE counter model) returns `figures`
  (captioned floats — PRIMARY), `inline_diagrams` (tikz-cd + **xy-pic** outside floats), `images`,
  `diagrams_total`. Persisted as `{slug}.oracle-counts.json` (schema/2) in the tex run; the harness falls
  back to the staged source, so it works today without re-running `latex_convert`.
- **Lane 5.** `{slug}.xobjects.jsonl` (bitmaps). Figure regions carry `provenance` (path|xobject|mixed),
  `caption` (the figure/diagram discriminator), `path_ids`, `xobject_ids`.
- **Pig runs on disk.** All 10 ph-zigzag papers have baseline + Lane-5 runs under `{slug}/.runs/`
  (git-ignored, newest = Lane 5). No re-batch is needed for the two-population re-score — the `caption` field
  was already emitted.

---

## Current scoreboard (ph-zigzag) — POST consensus milestone-1 (2026-07-05, runs 20260705_09xxxx)

```
paper            cap  fig  dFig  mechanism         uncap inline dInl  img
2111.15058v3      4    4     0   exact              13     5     8     0   (dInl 6→8: rescued fragments)
2112.02352        4    4     0   exact              10    17    -7     0
2204.11080v2      6    6     0   exact               6     1     5     5
2205.11338v3     11   13    -2   block-inside(C)    15     0    15    31
2210.00916       12   16    -4   D+B/C (ledger)     39    23    16     1   (dInl 27→16: the m1 target)
2302.12796v2      5    5     0   exact              12     6     6     0
2307.07462v5      8   13    -5   oracle-noise        5    10    -5     0   (figures_missing:5)
2403.08110v4      5    6    -1   gap-adjacent(B)    21     3    18     3
2501.00322v1     11   10    +1   table-cue seam?    10    13    -3     0
2603.03037v1      9    7    +2   TABLE-CUE SEAM      0     0     0     9

PRIMARY  captioned figures: 2 over / 4 under / 4 exact, mean |dFig| = 1.5   (row-identical: consensus is PRIMARY-neutral)
SECONDARY inline diagrams:  mean |dInl| = 8.3   (9.1 → 8.3)
Ablations (scratch/consensus-ablation.ps1): consensus-off reproduces the pre-m1 table EXACTLY (9.1);
defrag-off degrades to 9.3 (2111 +6 / 2205 +6 / 2307 +8) → the epsilon de-frag loop is NOT vestigial —
elbow merges cover geometry fragmentation that stream evidence can't (different draw-runs, one figure). KEEP.
```

<details><summary>Pre-consensus scoreboard (subfigure grouping + caption denominator, superseded)</summary>

```
paper            cap  fig  dFig  mechanism         uncap inline dInl  img
2111.15058v3      4    4     0   exact              11     5     6     0
2112.02352        4    4     0   exact              11    17    -6     0
2204.11080v2      6    6     0   exact               8     1     7     5
2205.11338v3     11   13    -2   block-inside(C)    14     0    14    31
2210.00916       12   16    -4   D+B+C (see ledger) 50    23    27     1
2302.12796v2      5    5     0   exact              13     6     7     0
2307.07462v5      8   13    -5   oracle-noise        4    10    -6     0   (figures_missing:5)
2403.08110v4      5    6    -1   gap-adjacent(B)    19     3    16     3
2501.00322v1     11   10    +1   table-cue seam?    11    13    -2     0
2603.03037v1      9    7    +2   TABLE-CUE SEAM      0     0     0     9

PRIMARY  captioned figures: 2 over / 4 under / 4 exact, mean |dFig| = 1.5   (3.7 → 1.9 → 1.5)
SECONDARY inline diagrams:  mean |dInl| = 9.1  ← the geometric fragmentation lives HERE (untouched)
```
</details>
`cap`=pig captioned regions, `fig`=captioned floats, `uncap`=pig uncaptioned regions,
`inline`=tikz/xy diagrams outside floats, `img`=pig GetImages() bitmaps.

**Reading it (both PRIMARY fixes LANDED: subfigure grouping `aa54303` + caption min-width denominator):**
- **Over-count tail eliminated by grouping** (2112 +5→0, 2204 +4→0, 2302 +3→0, 2501 +10→+1, 2403 +6→−1);
  **caption-recovery by the denominator fix** (2111 −1→0 exact; 2205 −6→−2, Figs 6/8/12/13 recovered).
  The two-birds effect confirmed: SECONDARY also improved (9.7→9.1) as recovered captions left the
  uncaptioned pool (2205 uncap 18→14, 2603 1→0).
- **2210's "16=16 exact" was COINCIDENTAL cancellation** (12 real + 4 subfigure-duplicates ≈ 16 floats by
  luck); grouping exposed 4 missed captions (Figures 1/4/7/14) — honest under-detection, not a regression.
- **2603's +2 is a GATE seam, not detection error**: the two extra captioned regions are Table 2 + Table 3
  (verified). Cue words rightly include Table, but PRIMARY scores ALL captioned regions vs FIGURE floats
  only. Fix = cue-TYPE split (see ledger, instrument tier); 2603 is actually exact; 2501's +1 likely same.
- **Do NOT chase** 2307 (`figures_missing:5`, oracle-side low confidence).

---

## Caption-attachment findings ledger (2026-07-05) — PRESERVE for the post-consensus circle-back

Probe: `scratch/caption-diag.ps1 -Slug <slug>` (committed; replicates the lane's cue-match, classifies every
cue-block CLAIMED/UNCLAIMED with a per-miss why). Items sorted by the criterion **"would this fix survive the
consensus landing?"** → *instrument* (fix now — it judges the consensus) / *plausibly-subsumed* (do NOT
micro-fix — consensus replaces region formation; re-diagnose after milestone-1) / *orthogonal* (queue
independently; no clustering change can help).

- **A. Overlap-denominator bug — ✅ FIXED (instrument).** `ovl/figW` rejected short "Fig. N" captions fully
  under wide figures (2205 Figs 6/8/12/13; 2111 Fig 3). Now `ovl/min(figW, blockW)` — only narrower-than-figure
  blocks change behavior; cue+gap gates still exclude in-text refs (verified: no false attachments corpus-wide).
- **A2. Table-cue gate seam — OPEN (instrument, small).** The caption record stores `cue=$true` (boolean), not
  WHICH cue word matched. Store the matched word class (figure|table|algorithm), then the gate scores
  figure-cued regions vs figure floats (and table-cued vs oracle `tables`, already counted). Explains 2603 +2
  (verified Table 2/3) and probably 2501 +1. Also refine the gate's `mechanism` attribution (currently
  `under ∧ img>0 → raster` mislabels caption-miss papers).
- **B. Gap-adjacent misses — SURVIVED the circle-back (real, 2026-07-05).** 2403 Fig 5 unchanged (gap 43
  vs 40 limit). 2210 Fig 7 MUTATED into C-shape: the consensus-merged region now extends past its caption
  (below=−209) with the next region 60 above — so B's live population is just 2403 Fig 5. The fix is still
  NOT a bare `caption_max_gap_em` bump (guardrail below); pair any relaxation with a caption-SHAPE guard.
- **C. Block-inside-figure — SURVIVED the circle-back (real, the DOMINANT miss class).** 2210 Figs 7/14;
  2205 Figs 7/10: region bbox extends over the caption. The fix is "accept a caption within the region's
  lower band" — BUT with a shape guard: the in-text ref "of Fig. 11. While…" (2205 pg11) sits at
  above=−377, i.e. DEEP inside a region — a naive lower-band acceptance would false-attach it. Lower-band
  = within ~2em of the region's bottom edge, plus cue-then-separator/short-block shape.
- **D. Lane-3 block-detection misses — ORTHOGONAL (unchanged).** 2210 Figs 1/4: caption text never became
  a cue-prefixed block at all (still absent from the cue-block census post-consensus). Text-lane work.
- **E. Kind-skip — SURVIVED; the "post-merge density rescues it" half was FALSIFIED.** 2403 Fig 3 still
  sparse, 2205 Fig 12 still degenerate after consensus. The remaining half of the design stands: "a
  caption vouches for this region" as a VIEW VOTE (kind promotion by caption evidence) — now m2 material
  with a concrete two-paper test set.
- **Guardrail (why A was safe alone and B/C are not):** the cue regex matches IN-TEXT references ("Figure 2
  illustrates…", "of Fig. 11. While…" — still failing correctly on gap/kind post-consensus, verified in the
  2026-07-05 circle-back). Any gap/overlap/inside relaxation must pair with a caption-SHAPE guard
  (cue-then-colon / short-block heuristic).
- **Circle-back COMPLETE (2026-07-05):** gate re-run (PRIMARY row-identical; SECONDARY 9.1→8.3),
  caption-diag re-run on 2210/2205/2403. B/C/E survivors are real; targeted fixes queued: C-fix (lower-band
  + shape guard) covers 4 of the 7 open misses and is the highest-yield instrument next step; A2 (cue-TYPE
  split) and D (text-lane) unchanged in the queue.

---

## The fork — RESOLVED 2026-07-05 → Option B (no downstream genie)

**What is a "figure"?** The caption is the discriminator, and pig already has it. **Decision: Option B** —
emit `figure` (captioned) and `inline-diagram` (uncaptioned tikz/xy cluster) as distinct kinds, each scored
against its own oracle population, both crop-rendered.

**Why B, not A.** Option A ("filter uncaptioned out — they're math, handled downstream") assumes a downstream
that transcribes them. On the SOURCELESS-PDF mission there is none: no LaTeX lane, and **mathdig cannot see
PDF geometry** — it is a downstream markdown-native math AST, modally incapable of receiving glyphs/paths (see
[[mathdig-is-downstream-not-a-pdf-solver]] + the brief's blind-father/deaf-son section). Under A a commutative
diagram in a bare PDF dissolves into scattered glyphs/paths — structure-loss, the Lane-5 failure reintroduced
for vectors. So diagrams MUST be detected as regions and cropped by pdfdig itself.

**The interim is not a deferral.** `inline-diagram` → image-crop is **oracle PARITY**: the LaTeX oracle itself
renders tikz/xy to SVG images (`tikz-render.ps1`), so a cropped PNG MATCHES the ground truth's own
representation of a diagram. Structured 2-D transcription, if ever, is pdfdig's OWN geometry frontier
(`Markpig.Pdf`), never a mathdig handoff. So the SECONDARY de-frag is concrete conversion quality NOW:
50 shattered pieces → 23 clean whole-diagram crops (the crop granularity IS the deliverable).

## Next experiments, in order, each measured against the gate

1. **Subfigure grouping (PRIMARY over-count) — ✅ LANDED 2026-07-05 (`aa54303`).** Captioned figures
   sharing (page, caption block_id) merge into one region (target = float granularity). Config knob
   `subfigure_grouping_enabled`; `Group-SubfiguresByCaption` / `Merge-FigureGroup` in `pdfdig-figures.ps1`;
   4 Pester tests. PRIMARY mean |dFig| 3.7 → 1.9; over-count tail eliminated.
   **1b. Caption overlap denominator — ✅ LANDED 2026-07-05.** `ovl/min(figW, blockW)`; PRIMARY 1.9 → 1.5,
   4 exact. The remaining caption issues are deliberately NOT micro-fixed — see the findings ledger above
   (B/C/E await the consensus re-diagnosis; A2 + D are queued instrument/text-lane work).

2. **Inline-diagram de-fragmentation** (Option B). Reduce the SECONDARY dInl — the goal is clean
   WHOLE-diagram crops, so this is a MERGE problem (fewer regions). Levers, measured against the
   SECONDARY column:
   - **Stream-block union-find — ✅ LANDED 2026-07-05 (`ea13156`, consensus milestone-1).**
     `Join-FigureViews` in `pdfdig-figures.ps1`, knobs `figure_regions.consensus` (calibrated by
     `scratch/stream-calib.ps1`: jump 6em / t_far 4em), ablation scorer `scratch/consensus-ablation.ps1`.
     SECONDARY 9.1 → 8.3; 2210 dInl 27 → 16 (50 → 39 uncaptioned regions). PRIMARY untouched (1.5,
     row-identical). Defrag proved NOT vestigial (ablation: 9.3 without it) — both stay on.
     Full results: `consensus-milestone1-design.md` §"As landed + measured".
   - **NEXT DIAGNOSIS before the next lever:** what are 2210's remaining 16 extra uncaptioned regions
     (and 2111's +2 rescued fragments)? Candidates: fragments split at >6em pen steps (raster-return
     jumps sever blocks — the m1 mechanism can't heal across blocks), rescued furniture, or genuinely
     separate sub-diagrams the oracle counts as one. Per-region eyeball vs the `-latex.md` diagrams —
     the answer picks between the two levers below.
   - **em-anisotropic dilation** — fallback/complement; dilate bboxes by `(Tx,Ty)` per side before clustering
     (also merges, but needs em-calibration and risks bridging distinct diagrams).
   - **geometry ⊕ provenance consensus (m2)** — needs deeper IR first (clip-group-id / color / marked-content
     NOT emitted; `is_clipping` only boolean). Then union-find + Jaccard + SymmetrizationRule ported from
     ThermoMapper `hashish`/`graphs` INTO `src/hdbscan/` (read-only w.r.t. ThermoMapper). See
     `pdfdig-ps-converter.md` "Ensemble / consensus spine". The seam is already in place (`Join-FigureViews`
     + `consensus.rule` config-as-data). E-fix (caption as a kind-promoting VIEW VOTE) rides in here.

3. **`IClusterLineage` / cophenetic abstraction** — milestone-2, unchanged (`opus-clustering-next-steps.md`).

## Separate, non-clustering fixes surfaced by this analysis

- **xy-pic rendering gap.** `latex-ingest.ps1`'s `tikz-render` only handles `tikzpicture|tikzcd`, so xy-pic
  (`\xymatrix` / `\begin{xy}`) diagrams are NOT rendered to SVG in the `-latex.md` either (2210 has 11 missing
  from its oracle deliverable). Add an xy-pic → SVG path, or at least a stable marker. Transcription quality,
  independent of clustering.

## Discipline / guardrails carried forward

- **Re-run the gate after EACH step; commit each separately.**
- **Restart the live codex-membrane MCP server** after editing `pdfdig-ir.ps1` / `Invoke-Pdfdig.ps1` /
  `latex-ingest.ps1`.
- **Read-only w.r.t. `D:\aghado01\ThermoMapper`** — port INTO `src/hdbscan/`.
- Keep the Pester suites green: `tests/compare-figure-counts.Tests.ps1` (two-population),
  `tests/pdfdig-figures.Tests.ps1` (Lane-5 block), `tests/encoding-invariants.Tests.ps1`.
- The caption field IS the figure/diagram discriminator — the whole reframe rides on it. If caption
  reattachment regresses, the PRIMARY/SECONDARY split degrades. See `Add-FigureCaptions`.
