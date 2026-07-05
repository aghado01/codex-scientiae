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

## Current scoreboard (ph-zigzag)

```
paper            cap  fig  dFig  mechanism         uncap inline dInl  img
2111.15058v3      3    4    -1   missed-figure      12     5     7     0
2112.02352        9    4    +5   over-detect        11    17    -6     0
2204.11080v2     10    6    +4   over-detect         8     1     7     5
2205.11338v3     11   13    -2   raster-blindness   18     0    18    31
2210.00916       16   16     0   exact              50    23    27     1
2302.12796v2      8    5    +3   over-detect        13     6     7     0
2307.07462v5     12   13    -1   missed-figure       4    10    -6     0   (figures_missing:5)
2403.08110v4     12    6    +6   over-detect        19     3    16     3
2501.00322v1     20   10   +10   over-detect        11    13    -2     0
2603.03037v1     12    7    +5   over-detect         1     0     1     9

PRIMARY  captioned figures: 6 over / 3 under / 1 exact, mean |dFig| = 3.7   (was 10.5 conflated)
SECONDARY inline diagrams:  mean |dInl| = 9.7  ← the geometric fragmentation lives HERE
```
`cap`=pig captioned regions, `fig`=captioned floats, `uncap`=pig uncaptioned regions,
`inline`=tikz/xy diagrams outside floats, `img`=pig GetImages() bitmaps.

**Reading it:**
- **Real-figure detection is largely solved** (mean |dFig| 3.7; 2210 exact 16=16; 2205/2307/2111 within ±2).
- **The remaining PRIMARY over-count is SUBFIGURE multiplicity, not TikZ fragmentation.** 2501 (+10; 13
  `\includegraphics` in 10 floats), 2403 (+6; 13 in 6), 2112/2603/2204: a float with N subfigures →
  pig detects N captioned regions. Different problem, different fix (subfigure grouping).
- **The geometric fragmentation is the SECONDARY population** — 2210's 50 uncaptioned regions vs 23 inline
  diagrams (each commutative diagram shattered into ~2). These are inline math, and it's a **policy question
  whether they should be "figures" at all.**
- **Do NOT chase** 2307 (`figures_missing:5`, oracle-side low confidence).

---

## The fork that reframes everything — decide FIRST

**What is a "figure"?** The caption is the discriminator, and pig already has it.

- **Option A — figures = captioned only.** Filter uncaptioned regions out of the figure lane. The benchmark
  is then the PRIMARY column and it's *nearly solved* (mean 3.7, driven by subfigures). The inline diagrams
  become a non-goal (they're math, transcribed by the LaTeX/math lane, not "figures"). **Simplest, and the
  data says it's most of the win.**
- **Option B — two region classes.** Emit `figure` (captioned) and `inline-diagram` (uncaptioned tikz/xy
  cluster) as distinct kinds, each scored against its own oracle population. Keeps the diagrams as
  addressable regions (useful if downstream wants to crop/render them) but signs you up to fix their
  fragmentation.

Everything below is conditional on this choice.

## Next experiments, in order, each measured against the gate

1. **Subfigure grouping (PRIMARY over-count, both options).** A `\begin{figure}` with N `\includegraphics` /
   subfigures currently yields N captioned regions. Decide the target (1 figure, or N subfigures) and group
   by shared caption / subcaption cue + tight spatial adjacency. Entry: `Add-FigureCaptions` +
   region assembly in `pdfdig-figures.ps1`. This is what moves 2501/2403 toward 0.

2. **[Option B only] Inline-diagram de-fragmentation.** Reduce the SECONDARY dInl (2210: 50→~23). The
   levers, each zero/low engine change, measured against the SECONDARY column:
   - **Stream-order axis** — every path already carries `id` (content-stream order); pack it as a degenerate
     third interval `[x0,y0,s, x1,y1,s]` (`RectangleGapMetric` is k-generic). A diagram's arrows/nodes are
     emitted consecutively, so stream adjacency re-glues them. Entry: point emission in `ConvertTo-FigureRegions`.
   - **em-anisotropic dilation** — dilate bboxes by `(Tx,Ty)` per side before clustering.
   - **geometry ⊕ provenance consensus** — needs deeper IR first (clip-group-id / color / marked-content NOT
     emitted; `is_clipping` only boolean). Then union-find + Jaccard + SymmetrizationRule ported from
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
