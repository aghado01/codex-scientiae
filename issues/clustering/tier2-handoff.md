# Tier-2 figure-clustering — handoff to the main session

**Status:** foundation LANDED 2026-07-05 (commits `30cd08c` harness, `ad4aa09` Lane 5, + a follow-up that
re-framed the oracle into two populations — see below). This picks up where `foundation-scope.md` ends.
**Consensus milestone-1 LANDED 2026-07-05 (`ea13156`); B-fix (caption gap 4.5em) LANDED (`70b2851`);
V_caption interior split (m2-a) LANDED 2026-07-06 (`e0175a5`); A2 cue-TYPE split LANDED (`5499a16`)** —
scoreboard + ledger below are current: **PRIMARY mean |dFig| 0.7, 7/10 exact, 0 over; SECONDARY 7.9.**
NORTH STAR recorded in `issues/pdfdig-lane/pdfdig-ps-converter.md`: pdfdig converges on the oracle's
finalize/pre-promotion standards (ideal: replicate an oracle run from a bare PDF). Remaining queue,
in rough value order:
(1) caption-diag on 2302 (the A2-exposed hidden miss — one of Figs 1/5 unclaimed);
(2) ~~topological-prior T1~~ ✅ LANDED `242fb92` (SECONDARY 7.9 → 7.2; see POST-T1 update + brief §1);
(3) ~~V_letters elevation~~ **✅ v1 LANDED `a7e394e`** (SECONDARY 7.2 → 6.7; PRIMARY invariant;
    pg17 diamond crops whole again; t_bridge re-calibrated 0.75em — corner labels sit at 0.51–0.55em;
    see `letters-elevation.md` status). **v2 = β₁-with-letters** (letter blocks as vertices in T1's
    proximity graph → positive circuit evidence for text-node diagrams) still queued;
(4) V_caption (b) positive vote / kind promotion (E-items); (5) D text-lane (2210 Figs 1/4);
(6) T2 persistence-band selection; (7) Jaccard provenance view + SymmetrizationRule (m2 proper — still
    gated on IR enrichment: clip-group-id/color/marked-content not yet emitted). SECONDARY residual
    focus after T1: 2205 +14 / 2403 +13 / 2210 +12 over; 2112 −7 / 2307 −6 under.
Out-of-sample check when available: run the gate on compendia/mapper once that catalog has pig runs +
oracle sidecars (every knob was ph-zigzag-calibrated).
Mapper-catalog oracle coverage is 9/10 and will stay there: **2504.09042v1 is a PDF-only arXiv submission**
(no LaTeX source exists; confirmed via codex-arxiv fetch 2026-07-06 — the e-print endpoint serves the PDF
itself, which is how a byte-for-byte PDF copy got mis-staged as its `.tar.gz` on 2026-07-03; bogus tarball
deleted). That paper is **pig/PDF-lane-only** — exclude it from oracle-sidecar expectations and the gate.

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

## Current scoreboard (ph-zigzag) — POST V_caption interior split (2026-07-06, runs 20260706_07xxxx)

```
paper            cap  fig  dFig  mechanism         uncap inline dInl  img
2111.15058v3      4    4     0   exact              13     5     8     0
2112.02352        4    4     0   exact              10    17    -7     0
2204.11080v2      6    6     0   exact               6     1     5     5
2205.11338v3     13   13     0   EXACT (was -2)     14     0    14    31  ← both welds cut (Figs 7/8, Fig 10)
2210.00916       14   16    -2   D only (ledger)    36    23    13     1  ← Fig 7 (B-fix) + Fig 14 (split) recovered
2302.12796v2      5    5     0   exact              12     6     6     0
2307.07462v5      9   13    -4   oracle-noise        4    10    -6     0   (figures_missing:5; +1 from an UNLEDGERED weld)
2403.08110v4      6    6     0   EXACT (was -1)     20     3    17     3  ← B-fix (gap 4.5em)
2501.00322v1     11   10    +1   table-cue seam?    10    13    -3     0
2603.03037v1      9    7    +2   TABLE-CUE SEAM      0     0     0     9

PRIMARY  captioned figures: 2 over / 2 under / 6 EXACT, mean |dFig| = 0.9   (3.7 → 1.9 → 1.5 → 1.3 → 0.9)
SECONDARY inline diagrams:  mean |dInl| = 7.9   (9.7 → 9.1 → 8.3 → 8.1 → 7.9)
Remaining PRIMARY misses fully attributed: A2 accounting seam (2501 +1 / 2603 +2 — table-cued regions vs
FIGURE-float oracle), ledger D text-lane (2210 −2, Figs 1/4), oracle noise (2307 — not chased).

**POST-A2 UPDATE (2026-07-06, `5499a16`, same runs re-scored — cue-TYPE split):** PRIMARY mean |dFig|
= **0.7, 7/10 EXACT, 0 over**. 2603 +2 → 0 and 2501 +1 → 0 as predicted (their extras were table-cued);
**2302 exposed as a hidden −1** — its old "exact 5=5" counted Table 1 against a missed figure caption
(coincidental cancellation, the 2210-16=16 phenomenon again; Figures 2/3/4/6 captioned, one of Figs 1/5
unclaimed → run `scratch/caption-diag.ps1 -Slug 2302.12796v2` as the next diagnostic). Table-cued regions
now sit in the `tab` column, outside both populations.

**POST-T1 UPDATE (2026-07-06, `242fb92`, runs 20260706_21xxxx — cycle-rank furniture demotion):**
**SECONDARY mean |dInl| = 7.2** (9.7 → 9.1 → 8.3 → 8.1 → 7.9 → 7.2); PRIMARY row-identical (0.7,
7/10 exact — demotion is post-caption, PRIMARY-invariant by construction). 7 demotions corpus-wide,
0 false (2210 overline strip; 2403 framed-box rules + annotation strips; 2302 radical-sign bars ×2 —
generalized past the calibration set). Design inversion recorded in `topological-prior.md` §1: text-node
commutative diagrams have β₁=0 in path space, so topology VETOES furniture rather than detecting
diagrams. Remaining SECONDARY residual is now dominated by 2205 (+14, its 31 bitmaps' vector
companions?), 2403 (+13), 2210 (+12 fragments) on the over side and 2112 (−7)/2307 (−6) under-detection.
Splitter corpus verify: 5 splits, all genuine, 0 false — incl. 2307 pg17 (Figure 6 + Figure 7), a weld no
prior diagnostic had surfaced.
m1 ablations (scratch/consensus-ablation.ps1): consensus-off reproduces the pre-m1 table EXACTLY (9.1);
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

## OUT-OF-SAMPLE — corpora/voroninski (2026-07-06, 23 papers, first oracle+pig runs ever on it)

```
PRIMARY  mean |dFig| = 0.7 — IDENTICAL to ph-zigzag — 14/23 exact, 0 over, 9 under (all raster-
         attributed; these are MATLAB-plot papers — 1608.02165v1 carries 1,430 placed bitmaps).
         Every calibrated knob transported to a 2011–2020 matrix-analysis corpus unchanged.
SECONDARY mean |dInl| = 19.57 — the stress finding. Oracle inline=0 on EVERY paper (phase retrieval
         has no tikz/xy); pig emits 2–66 uncaptioned regions each (2008.10579v1: 66). On ph-zigzag
         the uncaptioned pool was mostly real diagrams; HERE it is display-math clusters, plot
         fragments, algorithm boxes — the population the queued FORMULA-BLOCK-ADJACENCY
         discrimination exists for. T1 caught 11 regions corpus-wide (strict by design; correct but
         insufficient coverage for this corpus type). V_letters bridges: 0 (no diagrams — correct).
Oracle lane (22/23 first-contact conversions): figures_missing on 5 papers (graphics absent from
tarballs); 1805.08855v2 = 4 tikz diagrams fell to markers (unrendered — oracle-ladder edge case);
1404.3811v1 = INTAKE GAP: a gzip'd SINGLE-FILE submission named .tar.gz (magic 1F 8B, FNAME flag) —
tar fails; hand-staged for the gate; the fetcher family should sniff magic bytes (codex-arxiv lane).
Follow-ups: caption-diag the 9 unders (1608/1701/1807/2006 first); the SECONDARY residual here is
the concrete work-list for equation/plot-fragment discrimination (math-evidence lane adjacency).
```

## Caption-attachment findings ledger (2026-07-05) — PRESERVE for the post-consensus circle-back

Probe: `scratch/caption-diag.ps1 -Slug <slug>` (committed; replicates the lane's cue-match, classifies every
cue-block CLAIMED/UNCLAIMED with a per-miss why). Items sorted by the criterion **"would this fix survive the
consensus landing?"** → *instrument* (fix now — it judges the consensus) / *plausibly-subsumed* (do NOT
micro-fix — consensus replaces region formation; re-diagnose after milestone-1) / *orthogonal* (queue
independently; no clustering change can help).

- **A. Overlap-denominator bug — ✅ FIXED (instrument).** `ovl/figW` rejected short "Fig. N" captions fully
  under wide figures (2205 Figs 6/8/12/13; 2111 Fig 3). Now `ovl/min(figW, blockW)` — only narrower-than-figure
  blocks change behavior; cue+gap gates still exclude in-text refs (verified: no false attachments corpus-wide).
- **A2. Table-cue gate seam — ✅ FIXED 2026-07-06 (`5499a16`).** Captions store `cue_word`; the gate
  classifies (cue_word, text-prefix fallback for old runs) and scores figure-cued vs figure floats,
  excluding table/algorithm-cued from BOTH populations. 2603 and 2501 exact as predicted; bonus: exposed
  2302's hidden −1 (Table 1 had been masking a missed figure caption — new caption-diag target).
  Still open from the original note: the `mechanism` attribution refinement (`under ∧ img>0 → raster`
  mislabels caption-miss papers) — cosmetic, low priority.
- **B. Gap-adjacent misses — ✅ FIXED 2026-07-05 (calibrated `caption_max_gap_em` 4.0 → 4.5em).**
  Full-geometry probe corrected the earlier read: 2210 Fig 7 was NEVER C-shaped — its two panels sit at
  gap 45.3pt = 4.16em of the 10.9pt body (the diag's below=−209 belonged to a different region on the
  page); 2403 Fig 5 sits at 43.2pt = 4.32em of a 10pt body. Real captions at 4.16–4.32em vs the nearest
  in-text ref at 5.06em (2205 "of Fig. 11", itself BELOW an already-claimed region) → 4.5 splits the
  margin. Corpus-wide
  attachment diff at 4.5-vs-4.0: EXACTLY the two intended captions appear, none lost, no in-text refs.
  Bonus: Fig 7's two panels share blk1178 → subfigure grouping merges them into one float.
- **C. Block-inside-figure — ✅ FIXED 2026-07-06 (`e0175a5`, V_caption interior split m2-a).**
  `Split-CaptionInteriorRegions` (guards: shape + LEARNED per-document caption style + strict
  interiority) cut all four ledger cases (2205 Figs 7/8 + Fig 10; 2210 Fig 14) **plus an unledgered
  2307 pg17 weld (Figure 6 + Figure 7)** — 5 corpus splits, zero false positives; 2205 went EXACT.
  Original re-diagnosis kept below for the record:
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
   - **m2 V_caption: (a) interior split — ✅ LANDED 2026-07-06 (`e0175a5`).** `Split-CaptionInteriorRegions`
     in `pdfdig-figures.ps1`, knobs `figure_regions.caption_split` (margin 1em, max block 3.5em, style
     learned from the paper's own pass-1 claims). PRIMARY 1.3 → 0.9 (6/10 exact), SECONDARY 8.1 → 7.9.
     **(b) positive vote — still queued**: a caption adjacent to a mark/sparse/degenerate region promotes
     kind (the E-items: 2403 Fig 3, 2205 Fig 12). Note for the m2 combine design: the seam now has a
     de-facto NEGATIVE-evidence pass (split) living downstream of the union-find — when the
     `SymmetrizationRule`/cophenetic story arrives, fold it in as signed evidence rather than a post-pass.
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
