# Tier-2 figure-clustering — handoff to the main session

**Status:** foundation LANDED 2026-07-05 (commits `30cd08c` harness, `ad4aa09` Lane 5, + a follow-up that
re-framed the oracle into two populations — see below). This picks up where `foundation-scope.md` ends.

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

## Current scoreboard (ph-zigzag) — POST subfigure grouping (2026-07-05)

```
paper            cap  fig  dFig  mechanism         uncap inline dInl  img
2111.15058v3      3    4    -1   missed-figure      12     5     7     0
2112.02352        4    4     0   exact              11    17    -6     0
2204.11080v2      6    6     0   exact               8     1     7     5
2205.11338v3      7   13    -6   raster-blindness   18     0    18    31
2210.00916       12   16    -4   missed-figure*     50    23    27     1
2302.12796v2      5    5     0   exact              13     6     7     0
2307.07462v5      8   13    -5   missed-figure       4    10    -6     0   (figures_missing:5)
2403.08110v4      5    6    -1   raster-blindness   19     3    16     3
2501.00322v1     11   10    +1   over-detect        11    13    -2     0
2603.03037v1      8    7    +1   over-detect         1     0     1     9

PRIMARY  captioned figures: 2 over / 5 under / 3 exact, mean |dFig| = 1.9   (was 3.7 pre-grouping)
SECONDARY inline diagrams:  mean |dInl| = 9.7  ← the geometric fragmentation lives HERE (untouched)
```
`cap`=pig captioned regions, `fig`=captioned floats, `uncap`=pig uncaptioned regions,
`inline`=tikz/xy diagrams outside floats, `img`=pig GetImages() bitmaps.
`*` the gate's attribution heuristic (under ∧ img>0 → raster) mislabels 2210's −4 as raster (it has 1 img);
the real cause is 4 missed CAPTIONS (see below) — the attribution needs refining now that over-count is gone.

**Reading it (subfigure grouping LANDED — commit pending):**
- **The over-count tail is ELIMINATED.** 2112 +5→0, 2204 +4→0, 2302 +3→0, 2501 +10→+1, 2403 +6→−1,
  2603 +5→+1. PRIMARY mean |dFig| 3.7 → **1.9**. Merge rule: captioned figures sharing (page, caption
  block_id) collapse to one (the shared float caption is the grouping signal). `flag=subfigure_merged`.
- **Some previous "exact" scores were COINCIDENTAL cancellation.** 2210 was "16=16 exact" only because 12
  real figures + 4 subfigure-duplicates ≈ 16 floats by luck. Grouping removed the 4 duplicates and exposed
  that pig captions only 12 of 16 figures (missing Figures 1, 4, 7, 14 — their captions weren't attached).
  The −4 is now HONEST under-detection, not a regression. Verified: all 4 merges are clean single-caption
  figures (Figure 2/3/5/15), each a real multi-panel figure.
- **The residual PRIMARY error is now almost purely UNDER-count** = missed/unattached captions (2210 −4;
  Fig 1/4/7/14 likely sit in the SECONDARY uncaptioned pool → improving caption reattachment would move them
  to PRIMARY, a two-birds fix) + raster (2205 −6). Bidirectional error is gone.
- **The geometric fragmentation is the SECONDARY population** — 2210's 50 uncaptioned regions vs 23 inline
  diagrams — untouched; next lever = stream-block union-find (below).
- **Do NOT chase** 2307 (`figures_missing:5`, oracle-side low confidence).

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

1. **Subfigure grouping (PRIMARY over-count) — ✅ LANDED 2026-07-05 (commit pending).** Captioned figures
   sharing (page, caption block_id) merge into one region (target = float granularity). Config knob
   `subfigure_grouping_enabled`; `Group-SubfiguresByCaption` / `Merge-FigureGroup` in `pdfdig-figures.ps1`;
   4 Pester tests. PRIMARY mean |dFig| 3.7 → 1.9; over-count tail eliminated. **Follow-on surfaced:** the
   residual is now UNDER-count from missed/unattached captions (2210's Fig 1/4/7/14) — improve caption
   reattachment next (likely moves them out of the SECONDARY uncaptioned pool too). Also refine the gate's
   under-count attribution (currently mislabels missed-caption as raster).

2. **Inline-diagram de-fragmentation** (Option B). Reduce the SECONDARY dInl (2210: 50→~23) — the goal is
   clean WHOLE-diagram crops, so this is a MERGE problem (fewer regions). Levers, measured against the
   SECONDARY column:
   - **Stream-block union-find — FIRST (reachable today, no IR change).** Every path already carries `id`
     (content-stream order); a tikz/xy diagram is ONE contiguous draw-run. Group ids into contiguous runs and
     `union(i,j)` iff same stream-block **AND** spatially co-located (guard against a page-spanning run) — this
     MERGES a shattered diagram's fragments. **Do NOT pack `id` as a degenerate metric axis** `[x0,y0,s,x1,y1,s]`:
     `RectangleGapMetric` is `√(Σ max(0,gapᵢ)²)`, so an added axis is MONOTONE non-decreasing — it can only push
     boxes APART (a separation prior), never re-glue split fragments. Stream order helps only as a co-membership
     OR-merge (union-find), not a coordinate. `UnionFind.cs` already exists in `src/hdbscan/`. Entry: region
     assembly in `ConvertTo-FigureRegions`.
   - **em-anisotropic dilation** — fallback/complement; dilate bboxes by `(Tx,Ty)` per side before clustering
     (also merges, but needs em-calibration and risks bridging distinct diagrams).
   - **geometry ⊕ provenance consensus** — later; needs deeper IR first (clip-group-id / color / marked-content
     NOT emitted; `is_clipping` only boolean). Then union-find + Jaccard + SymmetrizationRule ported from
     ThermoMapper `hashish`/`graphs` INTO `src/hdbscan/` (read-only w.r.t. ThermoMapper). See
     `pdfdig-ps-converter.md` "Ensemble / consensus spine".

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
