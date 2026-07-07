# Tier-3 engineering plan — re-minted post-render (2026-07-07)

**Status:** RE-MINTED after thrust-5 shipped. The plan below supersedes the pre-render draft (the
landed work is summarized in §0; the forward thrusts in §2 are re-ordered by a new objective).

## The reframe that forces the re-mint

The pre-render plan optimized **gate deltas**. Thrust 5 landed the finalize weave, so the deliverable
is now a **rendered markdown document**, and that changes the objective function:

> The gate delta was always a *proxy*. The readable corpus is the *target*. A defect now ranks by
> **what a reader sees on the page**, not by which population's count it moves.

Two consequences invert the old priority order:
1. **A missing captioned figure is a hole in the document** — the reader sees a paragraph say "Figure 4
   reports…" with no figure. That is louder than any SECONDARY count. So the PRIMARY residual (text-lane
   + attachment tail), long deferred as "orthogonal to clustering," is now the **top** deliverable defect.
2. **The render is the instrument.** It already caught three defects no gate could (truncated caption,
   caption weld, an empty-glob mirror bug). Every thrust is now measured by *reading the output*, with
   the gate as one lens among several.

Twice-confirmed design law still holds and still governs: **structural priors veto figure-hood
reliably and never assert it** — assertions come from caption/oracle evidence or off-backbone position.

## §0 — What's landed (the record, compressed)

- **Clustering PRIMARY is DONE on both corpora.** ph-zigzag **0.7** (7/10 exact), voroninski **0.48**
  (16/23 exact), **0 over-detections anywhere**, gates bit-stable across a full refresh. Every residual
  under is attributed to a non-clustering cause (below). The Tier-2 arc: 3.7 → 0.7 / 0.48.
- **SECONDARY:** ph-zigzag **5.4**, voroninski **11.65** — driven down by T1 furniture veto, V_letters,
  and the T3-lite in-flow veto; the remainder is formation-level (§2-B/C).
- **The veto ladder** (all post-caption, PRIMARY-invariant): T1 cycle-rank furniture (`242fb92`),
  V_letters evidence bridge + crop union (`a7e394e`/`23ae8eb`), T3-lite in-flow backbone veto (`72e6f0f`).
- **Thrust 5 v1** (`e8d1cf9`): finalize weave through the shared `md-register.ps1`; render-harvest fixes
  — full block `text` (`cae3b61`), adapter caption pre-typing (`be10408`), mirror image-dir carry-up
  (`958dc34`/`76d244a`). Bare PDF → oracle-register deliverable, proven pixel-to-page.
- **Queue tamed** (`958dc34`): gzip-single-file intake (voroninski 23/23 oracle-covered), honest
  `mechanism` labels, mirror links resolve.

## §1 — Where the residuals live NOW (re-measured, per rendered defect)

| residual | rendered-doc symptom | root cause | thrust |
|---|---|---|---|
| **2210 −2, 2302 −1** (PRIMARY unders) | a figure is missing from the page under its own reference | THREE sub-classes, precisely diagnosed 2026-07-07: (a) caption in NO block (Fig 1 — detection miss); (b) only an in-text ref exists (Fig 4); (c) multi-caption geometric contention (Fig 16 — a nearer region took a different caption, the true one is >4.5em away) | **A** |
| voroninski SECONDARY 11.65 | over-cropped / welded diagram regions | 40–70% coverage band: text-WELDED formation + multi-panel plot fragments | **B, C** |
| ph-zigzag 2112 −10 | tikz-cd diagrams absent from the crop set | arrows are FONT GLYPHS; the path lane is empty there — nothing to cluster | **D** |
| Jaccard/symbolic m2 | (no direct symptom yet) | blocked on IR enrichment | **E** |
| docling-lane papers | weave no-ops (no pig run); docling images stay stripped | thrust-5 only wired the pig lane | **F** |

## §2 — Thrusts, re-ordered by deliverable impact

### A. Text-lane + attachment — the PRIMARY-visible residual (NEW top priority)
The old plan filed this under "blocks-lane quality work, defer." The render promotes it: a missing
figure is the most visible defect in the document, and this session **diagnosed it to three precise
sub-classes** (§1), which splits into three independently-shippable fixes:
- **A1 — caption-shape prefix alignment — ✅ LANDED 2026-07-07, premise FALSIFIED (hygiene only).**
  The plan assumed a "cue-matched but rejected-by-prefix" figure tail. **Measured empty on BOTH corpora**
  (`scratch/prefix-tail-probe.ps1`): every real leading-glyph caption (`∼ Figure 10:`, `1 Figure 16:`,
  the 7 ph-zigzag / 1 voroninski `≤4-junk` cases) is ALREADY claimed — the attachment cue's *unanchored
  14-char scan* was always lenient. The only non-plain UNclaimed blocks (2205 "of Fig. 11. While…",
  2403 "In Figure 3 (b)…") are IN-TEXT REFERENCES that must stay rejected — widening to grab them is a
  false-attachment regression, not a recovery. **TRAP AVOIDED:** the "unify all three to one anchored
  prefix" prose would REGRESS PRIMARY — 4 of ph-zigzag's 6 "far" captions have letter-y / >4-glyph
  prefixes that only the unanchored scan catches; anchoring drops them. The select-scan (attachment,
  `caption-diag`) and the shape-test (splitter `$styleRe`, gate `$classRe`) are *intentionally different
  idioms* and must stay so. What landed: the dormant gate-fallback `$classRe` aligned `[^\p{L}\d]{0,2}`
  → the splitter's canonical `[^\p{L}]{0,4}` (admits leading digits; legacy-run correctness only — current
  runs carry `cue_word`), + a regression test (`1 Table 5:` now classifies as a table). Gate bit-stable
  (0.7/5.4, 0.48/11.65). **2210 Fig 16's `1 Figure 16:` is NOT an A1 case — it's cue-matched already; its
  block is orphaned by GEOMETRY (A2), not prefix.**
- **A2 — multi-caption contention (attachment).** When two regions on a page contend for captions,
  attachment is greedy-nearest and can orphan a caption whose true region is just past the gap
  (2210 Fig 16). Make attachment a per-page ASSIGNMENT (each caption to its best unclaimed region,
  each region its best caption) rather than independent nearest-picks. Bounded, no new IR.
- **A3 — item-D block detection (the hard tail).** Captions that never became a "Figure N"-prefixed
  Lane-3 block at all (2210 Fig 1). XYCut/DLA quality — the deepest, least certain; do it last and only
  what the render proves is worth it.

### B. Backbone-conditioned metric (full T3) — the deep SECONDARY move
`rectangle-gap` is geometry-blind: 2em of whitespace and 2em of body-text band weld identically.
T3-lite vetoes the damage post-hoc; full T3 prevents it — a `rectangle-gap-conditioned` `IDistanceMetric`
in `src/hdbscan` reading a per-page BANDS sidecar (the backbone T3-lite already computes) and inflating
gap components that cross a band. Surface: one C# metric + `--bands` CLI input + `Invoke-Hdbscan`
plumbing + the lane writing bands; trust-harness unit vectors ([[hdbscan-trust-harness]]).
**Acceptance signal (unchanged, and elegant): the in-flow veto's demotion count DROPS — it inverts from
fix to audit.** In the render: fewer over-cropped welds.

### C. T2 persistence-band selection — one rule replaces three heuristics
From `hdbscan_dendrogram.json` (already emitted), select components persistent across a dilation band
[a,b] em instead of EOM-stability + `fragmentation_flag_min_clusters` + defrag-elbow. PS-side first.
Calibrate like `stream-calib` (birth/death stats of oracle-aligned regions). Retires two knobs;
the defrag ablation becomes its regression test. In the render: multi-panel plots crop whole.

### D. Glyph-cluster candidates — the modality pig cannot see (2112)
tikz-cd/xy-pic arrows are font glyphs; the path lane is empty, so no veto/merge helps. The elevation's
second half, now safe because the backbone exists: **math-role letter clusters OFF the backbone**
(the exact complement of the in-flow veto) become region CANDIDATES, `provenance='glyph'`, crop-rendered.
Assertion from display-position outside the flow (the T3 bands make it computable). Needs B's bands.

### E. Substrate — IR enrichment → m2 Jaccard/provenance
`pdfdig-ir` emits clip-group-id / color-bucket / marked-content-id per path (today only a boolean
`is_clipping`). Then the Jaccard/IDF provenance view enters `Join-FigureViews` as graded-strength,
`SymmetrizationRule` ports from ThermoMapper `graphs` (read-only, INTO `src/hdbscan/`), the V_caption
splitter folds in as SIGNED evidence. m3 (cophenetic / `IClusterLineage`) rides the same seam. The
ThermoMapper cross-pollination artery. Independent — interleaves anywhere.

### F. Thrust-5 remainder — widen the deliverable
Docling-lane images (weave currently no-ops without a pig run); publish carrying `{slug}-membrane/`
into `compendia/`; `mechanism`-attribution polish is done. Lower urgency than A but high visibility.

## §3 — Sequencing + measurement

**A1 → A2 first** (cheapest, highest deliverable-visibility, no new IR — recovers real figures a reader
misses). **B before C, D** (both need bands; C's selection is cleaner on conditioned formation, D needs
the bands outright). **E interleaves** (independent substrate). **A3 and F** as the render proves them
worth it. Every increment: **read the rendered output first**, then gate BOTH corpora (+ mapper when its
sidecars exist), calibrate-before-implement, eyeball crops, commit ablation probes under `scratch/`,
**PRIMARY invariance non-negotiable**. Cost note: a full-corpus pig refresh is ~34 min (raster tail) —
refresh the two corpora on independent cadences, not always-both.
