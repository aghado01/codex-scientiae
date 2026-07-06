# Tier-2 figure-clustering — handoff to the main session

**Status:** foundation LANDED 2026-07-05 (commits `30cd08c` harness, `ad4aa09` Lane 5, + a follow-up that
re-framed the oracle into two populations — see below). This picks up where `foundation-scope.md` ends.
**Consensus milestone-1 LANDED + measured + circled-back 2026-07-05 (`ea13156`)** — scoreboard and the
re-diagnosed ledger below are current. **B-fix (caption gap 4.0→4.5em, calibrated) LANDED 2026-07-05**;
the residual diagnosis (crop-verified, "Next experiments" §2) re-scoped C: the m2 consensus increment
should lead with **V_caption interior split** (caption inside a region = float separator, negative
evidence) + caption-as-positive-vote (E), then the Jaccard provenance view. Independent quick wins
queued: equation-furniture discrimination; letters-aware crop padding; A2 cue-TYPE split; D text-lane.

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
- **B. Gap-adjacent misses — ✅ FIXED 2026-07-05 (calibrated `caption_max_gap_em` 4.0 → 4.5em).**
  Full-geometry probe corrected the earlier read: 2210 Fig 7 was NEVER C-shaped — its two panels sit at
  gap 45.3pt = 4.16em of the 10.9pt body (the diag's below=−209 belonged to a different region on the
  page); 2403 Fig 5 sits at 43.2pt = 4.32em of a 10pt body. Real captions at 4.16–4.32em vs the nearest
  in-text ref at 5.06em (2205 "of Fig. 11", itself BELOW an already-claimed region) → 4.5 splits the
  margin. Corpus-wide
  attachment diff at 4.5-vs-4.0: EXACTLY the two intended captions appear, none lost, no in-text refs.
  Bonus: Fig 7's two panels share blk1178 → subfigure grouping merges them into one float.
- **C. Block-inside-figure — RE-DIAGNOSED 2026-07-05: a REGION-FORMATION defect, not an attachment one.**
  The full geometry shows captions sitting MID-region because the region welded too much: 2205 pg8 is
  **two floats in one 399pt region** (Fig 7 + Fig 8; Fig 8's caption won the attachment, Fig 7's sits
  interior at 39% height); 2210 pg32 Fig 14's caption sits at 46% height of a 1283 em² near-page region;
  2205 Fig 10's caption sits 8em above its region's bottom. "Lower-band acceptance" cannot fix these —
  attaching to a two-float region yields a two-float crop. The principled fix is **V_caption interior
  SPLIT**: a caption-shaped cue block strictly inside a region is NEGATIVE co-membership evidence — paths
  above vs below it belong to different floats. Third view for the consensus seam (m2), alongside the
  E-item's caption-as-positive-vote.
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
   - **RESIDUAL DIAGNOSIS DONE 2026-07-05 (crop-verified, 2210's 39 uncaptioned vs oracle 23).** Four
     classes, from eyeballing the pig run's own region crops (`images/imageFileN.png`) + the census:
     1. *Real small inline diagrams, correctly detected* — pg13's five ~25 em² regions are five clean
        whole chain-diagram crops (verified: complete `□ ↔ □` diagrams). NOT errors; part of the "+16"
        is the oracle-vs-pig granularity agreeing better than the raw delta suggests.
     2. *Welded caption-interior monsters* — pg32 id46 (1283 em², Fig 14 caption at 46% height); same
        class as 2205 pg8's two-float weld. Fix = the C-item's V_caption interior split (m2).
     3. *Equation furniture leaking into kind=figure* — id29 is a 355×12px strip (overline/underbrace
        rule cluster beside display math). Needs a discrimination signal (aspect + adjacency to a
        formula-block from the classify lane), NOT a size floor (real diagrams are as small).
     4. *Crop bbox misses text nodes* — pg17 ids 26–28 (three same-size diagram skeletons): arrows are
        paths, node labels are LETTERS — the union bbox excludes them, so crops amputate the nodes.
        Crop-quality fix: pad region bboxes with overlapping/adjacent letters-lane glyphs at render
        time (Export-PdfFigureImages), independent of counting.
     The oracle side now renders diagrams (`{slug}.diagrams.jsonl` work-list, 27 records for 2210 with
     full TikZ source) — crop-vs-render pairing is now possible for a per-diagram quality gate.
   - **em-anisotropic dilation** — fallback/complement; dilate bboxes by `(Tx,Ty)` per side before clustering
     (also merges, but needs em-calibration and risks bridging distinct diagrams).
   - **m2 consensus increment — REORDERED by the residual diagnosis: lead with V_caption.** The caption
     view earns entry first because it is BOTH the biggest residual (welded caption-interior monsters)
     and needs no new IR: (a) *interior split* — a caption-shaped cue block strictly inside a region is
     NEGATIVE co-membership evidence (paths above vs below = different floats; fixes 2205 pg8 Fig 7+8,
     2210 pg32 Fig 14); (b) *positive vote* — a caption adjacent to a mark/sparse/degenerate region
     promotes kind (the E-items: 2403 Fig 3, 2205 Fig 12). Note the seam grows a NEGATIVE-evidence
     strength (m1 strengths are {0,1} co-membership; a split is anti-membership — design the
     `SymmetrizationRule`/cophenetic story with signed evidence in mind).
   - **geometry ⊕ provenance consensus (m2, after V_caption)** — needs deeper IR first (clip-group-id /
     color / marked-content NOT emitted; `is_clipping` only boolean). Then union-find + Jaccard +
     SymmetrizationRule ported from ThermoMapper `hashish`/`graphs` INTO `src/hdbscan/` (read-only
     w.r.t. ThermoMapper). See `pdfdig-ps-converter.md` "Ensemble / consensus spine". The seam is already
     in place (`Join-FigureViews` + `consensus.rule` config-as-data).

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
