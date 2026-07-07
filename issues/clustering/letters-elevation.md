# Elevating letters to the point cloud — V_letters (design, calibrated)

**Status:** DESIGN + CALIBRATION DONE (2026-07-06), implementation queued. From the user question
"is it possible to elevate proverbial letters to said cloud" — the substrate change T1's landing
lesson pointed at (`topological-prior.md` §1: text-node diagrams have β₁ = 0 in path space because
their circuits are completed by LETTERS). Third elevation in the lane's history: paths (born),
xobjects (Lane 5, the raster-blindness cure), now letters — but selectively, and at the EVIDENCE
tier, not the point tier.

## Why (four birds)

1. **Crop amputation** (crop-verified residual class): region bboxes exclude node labels — pg17's
   diamonds render arrows without their `X` corners. Letters as members fix the crop bbox.
2. **β₁ restoration** (the T1 lesson): with letter nodes as vertices, text-node commutative diagrams
   close circuits — POSITIVE diagram evidence becomes computable (feeds T2 selection and future kind
   decisions; today topology can only veto furniture).
3. **Fragment healing**: two arrow-groups separated by a central label are two V_geom components; the
   label is the bridge. Part of 2210's +12 / 2403's +13 SECONDARY residual is exactly this shape.
4. **Missing structure**: some diagram connective tissue IS letters — pg13's `↔` chain connectors are
   single-glyph blocks, invisible to region formation today.

## Anatomy (probed 2026-07-06 on 2210 pg13/pg17)

Diagram-participant text lives in TINY DEDICATED Lane-3 blocks: every pyramid node is its own
3-letter, ~1.1em-wide block (`'2 X 0'`, `'(1)'`); interval labels ≤ 4.2em; `↔` connectors are
single-glyph blocks. Body text lives in 32–37em blocks. The granularity is right at the BLOCK level
(no per-letter machinery needed).

## Selector (calibrated, scratch/letters-calib.ps1, 3 papers / 2894 blocks)

| class  | n    | width_em p50/p95 | letters p50/p95 | nearest-path-gap_em p50/p90/p95 |
|--------|------|------------------|-----------------|--------------------------------|
| in-fig (captioned region interior) | 191 | 0.76 / 3.11 | 2 / 9 | **0 / 0.15 / 0.39** |
| in-unc (uncaptioned region interior) | 252 | 1.28 / 10.98 | 4 / 34 | 0.06 / 0.46 / 0.47 |
| body   | 2451 | 2.63 / 47.4 | 6 / 327 | **0.5 (p10!) / 33.6 (p50)** |

Figure-participant blocks sit ON the ink (p95 gap 0.39em); body blocks are far (median 33.6em).
**Selector: block width ≤ ~4em ∧ letters ≤ ~10 ∧ nearest-path-gap ≤ 0.5em.** The residual false
candidates (~180 small body fragments within 1.5em of a path — inline math beside radical bars,
text near footnote rules; fewer at 0.5em) are neutralized by the BRIDGE RULE, not the selector:
evidence fires only when ≥ 2 distinct path components sit within reach of one block — a lone surd
stroke next to a body fragment has nothing to bridge, and any accidental 2-path weld still faces
the kind gates + T1 furniture veto downstream.

## Design decision — EVIDENCE tier, not point tier

Selected letter blocks do NOT enter the HDBSCAN cloud (V_geom): body pages carry small blocks too
(`'For'`, `'B ∈'` fragments), and letter points would distort the density landscape the whole lane
is calibrated on. Instead **V_letters is a consensus view** (the seam built for exactly this):

- **Bridge unions** (in/after `Join-FigureViews`, same union-find): for each selected block, union
  the path components within `t_bridge` (0.5em) of it — with the ≥2-components rule above.
- **Membership**: regions gain `letter_block_ids`; the splitting/attached block boxes union into the
  CROP bbox (`Export-PdfFigureImages`), subsuming the queued "letters-aware crop padding" item.
- **Kind formulas untouched at v1** (open tension, decide by measurement): letter members counting
  as ink would inflate density and could promote phantoms; letters-as-bbox-only deflates density on
  healed regions (merged area grows without path count). v1 ships bbox-only + unchanged gates —
  the m1 precedent (consensus merges) survived the same deflation; the gate arbitrates.
- **β₁-with-letters** (v2): add selected blocks as vertices in T1's proximity graph — positive
  circuit evidence for text-node diagrams; recalibrate the furniture veto with the new column.

## Relation to T3

The selector IS the backbone classifier inverted: body letters (big blocks, path-far) = the text
backbone; stray letters (small, path-entangled) = figure material. Implementing V_letters builds
T3's substrate for free.

## Measurement

Gate both populations (expect SECONDARY drop via fragment healing; PRIMARY must stay invariant —
bridge only touches uncaptioned formation pre-caption... verify), crop QA on pg17/pg13 (nodes
restored), the T1 calibration table gains a β₁-with-letters column, out-of-sample on mapper.
