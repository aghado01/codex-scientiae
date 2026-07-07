# Tier-3 engineering plan — pushing past the veto era

**Status:** PLAN (2026-07-07), written at the close of the two-corpus round. The gates say the
threshold/veto era is over: PRIMARY is attributed to the last region on both corpora (ph-zigzag 0.7,
voroninski 0.48, zero over-detections anywhere), and every remaining SECONDARY point lives in defects
no post-hoc gate can reach — regions formed wrong, or content the formation never sees. Twice-confirmed
design law carried forward: **structural priors veto figure-hood reliably, and never assert it** —
so Tier-3 pushes the *formation* machinery, keeping assertions for caption/oracle evidence only.

## What the residuals demand (the evidence)

| residual | where it lives | what it needs |
|---|---|---|
| voroninski SECONDARY 11.65 | the 40–70% coverage band: regions text-WELDED at formation (2112 id6 class), multi-panel plot fragments | the metric must know the backbone (T3 full); selection must know persistence (T2) |
| ph-zigzag 2112 dInl −10 | real tikz-cd diagrams pig cannot SEE: their arrows are FONT GLYPHS, not paths — the path lane has nothing to cluster | a new formation modality: glyph-cluster candidates |
| 2210 +12 / 2403 +8 | genuinely fragmented small diagrams (block-severed at >6em pen steps) | T2 persistence-band; possibly conditioned metric |
| PRIMARY unders (D-class) | captions that never became Lane-3 cue blocks | blocks-lane (XYCut/DLA) quality work |
| Jaccard/symbolic m2 | blocked | IR enrichment (clip-group-id / color / marked-content) |

## Thrust 1 — backbone-conditioned metric (full T3): the metric learns the page

The C#-engine move. Today `rectangle-gap` is geometry-blind: ink 2em apart welds whether the gap is
whitespace or a body-text band. T3-lite vetoes the damage post-hoc; full T3 prevents it: a
**`rectangle-gap-conditioned`** metric variant in `src/hdbscan` that reads a per-page BANDS sidecar
(the wide-block backbone T3-lite already computes) and INFLATES gap components that cross a band
(multiplicative penalty, config-as-data). Engineering surface: one new `IDistanceMetric` in the C#
engine + `--bands` input on the CLI + `Invoke-Hdbscan` plumbing + the lane writing the bands file.
Sklearn-pinning discipline: the trust harness gains the variant with unit vectors ([[hdbscan-trust-
harness]] pattern). Predicted: the text-welded class dies at formation; 2112 id6-type mixed regions
stop existing; the in-flow veto's demotion counts DROP (it becomes the audit, not the fix) — that
inversion is the acceptance signal.

## Thrust 2 — T2 persistence-band selection: one selection rule replaces three heuristics

From `hdbscan_dendrogram.json` (already emitted), select components persistent across a dilation band
[a, b] em instead of EOM-stability + `fragmentation_flag_min_clusters` + defrag-elbow. PS-side first
(policy in the lane, engine untouched). Multi-panel plots: panels merge at moderate t and persist →
selected whole; shattered diagrams: fragments knit early → selected merged. Calibration exactly like
stream-calib: birth/death stats of oracle-aligned regions on both corpora. Retires two knobs and the
with/without-defrag ablation becomes the regression test.

## Thrust 3 — glyph-cluster candidates: the modality pig cannot currently see

2112's diagrams are drawn in FONT GLYPHS (xy-pic/tikz-cd arrows are characters); the path lane is
empty there — no veto or merge can fix an empty input. The move is the elevation's second half,
now safe because the backbone exists: **math-role letter clusters OFF the backbone** (not covered by
wide blocks — the exact complement of the in-flow veto) become region CANDIDATES, clustered with the
same machinery, provenance='glyph', crop-rendered like everything else. Gated: candidates must be
off-backbone AND math-role-dominant AND display-positioned — the assertion comes from position
outside the flow, which the T3 bands make computable. Targets: 2112 (−10), xy-pic-heavy corpora
generally; the oracle's diagram work-list gives per-paper ground truth.

## Thrust 4 — substrate for m2/m3: IR enrichment + the provenance view

`pdfdig-ir` emits clip-group-id, color-bucket, and marked-content-id per path (today: only a boolean
`is_clipping`). Then the Jaccard/IDF provenance view enters `Join-FigureViews` as a graded-strength
view, `SymmetrizationRule` ports from ThermoMapper `graphs` (read-only, INTO `src/hdbscan/`), and the
V_caption splitter folds in as SIGNED evidence instead of a post-pass. m3 (cophenetic strengths /
`IClusterLineage`) rides the same seam. This is also the ThermoMapper cross-pollination artery.

## Thrust 5 — close the loop to the deliverable (the north star is the point)

**v1 ✅ LANDED 2026-07-07 (`e8d1cf9`) — the finalize weave, scoped to the RUN-DIR render (publish
deferred; the render IS the measurement instrument, indifferent to detection quality by design).**
Shared primitives codified first, per the convergence doctrine: `src/md-register.ps1` = the ONE
markdown figure register (image line / italic caption / flagged marker), extracted byte-identical
from the oracle's `Copy-LatexFigures` and now called by BOTH lanes (latex suite 62/62 parity);
`pdfdig-images.ps1` rides the shared `Invoke-PdfRaster` shim (one MuPDF mechanism project-wide).
`finalize.ps1 Get-FigureWeave`: captioned crops ride their caption chunks (the placement token
`Move-CaptionsToAnchors` always reserved), uncaptioned crops flush at page boundaries, failures are
flagged markers, PNGs run-local under `{slug}-membrane/`. E2E voroninski 1109.0573v2: 6 captioned
at their prose anchors + 5 page-flushed, 11 PNGs, 0 markers — the oracle register from a bare PDF.
REMAINING in this thrust: publish carries `{slug}-membrane/` up (mirror links); docling-lane images;
fetcher magic-byte sniffing; item-D blocks-lane diagnosis; `mechanism` attribution polish.

## Sequencing + measurement

1 → 2 share calibration work (both need band statistics); do 1 first (2's selection is cleaner on
conditioned formation). 3 needs 1's bands. 4 is independent — can interleave. 5 can start NOW on
current quality and pulls the whole stack toward the north star; it is the highest-visibility item.
Every increment: gate on BOTH corpora + mapper when its sidecars exist; calibrate-before-implement;
crops eyeballed; ablation probes committed under scratch/; PRIMARY invariance is non-negotiable.
