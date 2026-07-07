# Topological priors for figure-region separability — de-nebulized (design sketch)

**Status:** DESIGN (2026-07-06), from a user idea ("consider a topological prior in the data as a way of
enhancing separability" for the HDBSCAN-based figure lane). This sketch pins the idea to concrete,
falsifiable increments, each measured against the standing gate (`Compare-FigureCounts.ps1`, both
populations) with `compendia/mapper` as the out-of-sample set. Companion to the ensemble/consensus spine
(`consensus-milestone1-design.md`) — topology enters as **priors on the filtration**, not as a new
clustering engine.

## 0. The identification that makes it non-nebulous

Single-linkage over the `rectangle-gap` metric **is** H0 of the *dilation filtration* (Minkowski offset)
of the page's box union: grow every box by radius t; components merge exactly when their rectangle-gap
≤ t. The lane already lives inside this object without naming it:

- the defrag **elbow** = the largest gap in the H0 barcode's death times;
- `stream_jump_em` (6), `t_far_em` (4), `caption_max_gap_em` (4.5) = calibrated **points on the t-axis**;
- HDBSCAN's stability (EOM) = a lifetime measure on the density-distorted version of the same filtration.

So "topological prior" v0 = **make the barcode the first-class object and put the prior on it**: a
figure is an H0 class that persists over a *band* [t_birth ≤ a, t_death ≥ b] of dilation radii —
born early (internal fragments knit at small t), dying late (separated from neighbors until large t).
The prior is the band, calibratable exactly the way `scratch/stream-calib.ps1` calibrated the jump
(inside-caption vs across-caption distributions gave 7.24em min boundary vs 0.63em median internal step —
those ARE birth/death statistics). One object replaces the accumulating threshold zoo, page-adaptively.

## 1. Increment T1 — cycle-rank as the equation-furniture discriminator — ✅ LANDED 2026-07-06 (`242fb92`)

`Set-FurnitureKind` in `pdfdig-figures.ps1`, knobs `figure_regions.furniture_demotion`; post-caption
pass so PRIMARY is invariant by construction. **As landed the rule INVERTED the sketch above** — the
calibration crops (scratch/furniture-calib.ps1) exposed that the most important diagram class,
commutative diagrams with TEXT nodes, has β₁ = 0 in path space (arrows only; the circuit is completed
by LETTERS, which are not in the path cloud). So topology cannot positively identify diagrams here —
instead it positively identifies FURNITURE, with the circuit test as the VETO:

> furniture ⇐ uncaptioned ∧ pure-path ∧ NO areal member (min extent ≤ 4pt each — pure stroke ink)
>            ∧ β₁ = 0 at 2em (any circuit disqualifies — even a box drawn as 4 strokes)
>            ∧ strip-shaped (aspect ≥ 6 OR height ≤ 1.5em).

The shape clause is what spares the two β₁ = 0 danger classes: text-node diagrams (squarish/tall) and
barcode/interval-bar figures (2111's class — all-thin, tall). Measured: **7 demotions corpus-wide,
0 false** — 2210's overline strip, 2403's framed-paragraph border rules + interval-annotation strips,
plus 2 catches OUTSIDE the calibration set (2302: radical-sign bars in body text — the rule
generalized). 2403's one ambiguous interval annotation spared itself via a genuine 2em circuit.
**Gate: SECONDARY |dInl| 7.9 → 7.2** (2302 6→4, 2403 17→13, 2210 13→12); PRIMARY row-identical.
Lesson for T2–T4: on pages, path-space topology is evidence about NON-figures more than about figures;
positive figure evidence needs the letters lane in the complex (that is T3's backbone in another guise).

## 2. Increment T2 — persistence-band region selection (H0 prior proper)

Replace (behind a flag, A/B at the gate) the current per-page HDBSCAN+defrag+consensus-merge cascade's
*selection* step with: compute the H0 dilation barcode per page (single-linkage over rectangle-gap —
already computable from the hdbscan.exe dendrogram with epsilon sweeps, or directly in PS with one
sorted-edges union-find), select classes persistent over [a, b] em. Consensus views (stream, caption)
stay exactly as they are — they modify the filtration's *connectivity*, not the selection.
Expected: the elbow heuristic and `fragmentation_flag_min_clusters` retire; one knob pair (a, b)
with a measured, transportable meaning. Risk: HDBSCAN's density term currently suppresses sparse
bridges; a pure dilation filtration lacks it — may need the mutual-reachability version of the
filtration (that is precisely HDBSCAN's, so T2 may reduce to "replace EOM stability with band-persistence
as the cluster-selection rule" — a smaller, safer change worth trying first).

## 3. Increment T3 — backbone-conditioned filtration (the program-level unification)

The page has a TEXT BACKBONE (columns, reading-order bands — Lane-3 blocks/XYCut already computes it).
Condition the dilation: crossing a column gutter or a body-text band inflates effective distance
(anisotropic/conditioned metric), so figure components persist *relative to the backbone* rather than
absolutely. This is [[backbone-conditioned-persistence]] instantiated on pages — the same primitive as
the neural-manifold flagship (persistence conditioned on a task/structure backbone), which is exactly
why the idea felt load-bearing beyond this lane. Concretely it targets: two figures in adjacent columns
that currently need `t_far` guarding (backbone says "gutter between them → far"), and text-adjacent
furniture (backbone says "inside a text band → not figure material").

## 4. Increment T4 — diffusion rung (embedding-ladder Rung 3, optional)

Diffusion distances (e^{−tλ} on the page graph) expand bottlenecks and contract dense regions — the
generic separability enhancer. Connects to [[spc-diffusion-coupling-plan]] (spectral engine exists in
SPCX; gap = the weighting + t-selection). The topological prior gives the t-selection rule (spectral gap
/ persistence of the partition). This rung only earns entry if T1–T3 leave residual the gate can see.

## Relation to the m2 queue (unchanged, complementary)

Jaccard/provenance view ("symbolic clustering") stays gated on IR enrichment (clip-group-id / color /
marked-content emission in pdfdig-ir; `is_clipping` is only a boolean today). Topological priors are
**orthogonal to provenance**: T1/T2 read geometry the IR already emits — they need no new IR and can land
before m2-proper. When the SymmetrizationRule/cophenetic combine arrives, band-persistence levels are
exactly the cophenetic strengths the seam expects (`IClusterLineage`), so T2 feeds m3 rather than
competing with it.

## Sequencing + measurement

T1 first (small, lands the queued furniture item, uses the crop-classified test set from 2026-07-06);
then T2-as-selection-rule; T3 as its own design pass (touches the metric — highest conceptual value,
highest blast radius); T4 last. Every increment: gate on ph-zigzag, out-of-sample on mapper, crops
eyeballed, knobs recorded in `classify-config.json` `_doc` with their calibration evidence.
