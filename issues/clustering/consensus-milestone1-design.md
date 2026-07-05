# Consensus milestone-1 — stream-block view + OR-combine (design)

**Status:** DESIGN (2026-07-05), pre-implementation. The first increment of the ensemble/consensus spine
(`issues/pdfdig-lane/pdfdig-ps-converter.md` §"Ensemble / consensus spine"), deliberately minimal but built
around the SEAM milestone-2 slots into (Jaccard provenance view, `SymmetrizationRule`, `IClusterLineage`
cophenetic combine) so no rewrite is needed later. Scored against the standing gate
(`Compare-FigureCounts.ps1`), BOTH populations; the caption findings ledger
(`tier2-handoff.md`) lists which PRIMARY misses are predicted to self-heal — re-diagnose after landing.

## Shape

A **VIEW** = a per-page function over clustering items → co-membership evidence. Milestone-1 has two:

- **V_geom** — today's HDBSCAN(`rectangle-gap`) partition (labels per item). Unchanged.
- **V_stream** — contiguous content-stream draw-runs over Lane-4 paths.

**Combine (m1) = INCLUSIVE OR with a spatial guard**, as one union-find pass over the page's items:
`union(i,j)` iff `same-cluster-in-V_geom(i,j)` **OR** (`same-stream-block(i,j)` **AND** `gap(i,j) ≤ T_far`).
Final regions = union-find components → assembled by the EXISTING `$addRegion` (bbox/kind/density gates,
caption reattachment, subfigure grouping all run downstream, unchanged).

PS-side implementation is fine (≤ ~900 items/page; policy lives in the lane, engine stays a black box —
mirror `UnionFind.cs`'s path-compression pattern or port it, either is minutes).

## The splitter — a design fact discovered while drafting

**Per-page path ids are CONTIGUOUS by construction.** `id` is document-sequential emission order, and a
page's paths occupy one solid id range (letters/words live in other lanes; only bbox-null paths make small
holes). Consequence: **id-GAP splitting cannot work** — two figures drawn back-to-back on one page are
id-adjacent (…150 | 151…), no gap exists. The correct splitter is the **SPATIAL JUMP between consecutive
ids**: a TikZ/xy diagram is one contiguous run in stream order AND space; between two figures the "pen
teleports". So:

> V_stream blocks = split the page's id-sorted paths wherever the rectangle-gap between consecutive
> members exceeds `stream_jump_em` (em-calibrated). A block = one draw-run that stayed spatially coherent.

`T_far` then guards the union step against the one real failure mode: a rare page-spanning draw-run
(background/watermark/furniture drawn in one pass) must not weld distant regions. T_far carries the
separation load; the geometry view supplies separation everywhere else.

**XObjects are EXCLUDED from V_stream at m1** — their ids are a separate lane's sequence (id-space
collision), and bitmap↔caption provenance linking is milestone-2 material. Lane 5 already makes them
first-class geometry points; they simply don't get stream evidence yet.

## The seam (what m2/m3 slot into)

- A view's output normalizes to **co-membership classes with a strength**. m1 strengths are binary {0,1};
  m2's Jaccard/IDF provenance view yields graded strengths; m3 lifts strengths to cophenetic levels
  (`IClusterLineage` — see `pdfdig-ps-converter.md` §"Cross-algorithm abstraction").
- The combine rule is **named config-as-data**: `consensus.rule = 'inclusive'` at m1; `'mutual'`/`'mean'`
  arrive with the `SymmetrizationRule` port (ThermoMapper `graphs/primitives`, read-only source —
  [[multi-agent-repo-concurrency]]).
- Placement: a distinct **`Join-FigureViews`** step in `ConvertTo-FigureRegions` between clustering and
  region assembly — NOT inline label surgery — so views and combine are independently swappable.

## Knobs (config `figure_regions.consensus`)

`enabled`, `stream_jump_em` (calibrate from corpus histograms: consecutive-id spatial gaps INSIDE known
figures vs ACROSS figure boundaries — measure first, don't guess), `t_far_em`, `rule` (`'inclusive'`).
All conjectures, falsifiable against the gate ([[pig-figure-embedding-ladder]] discipline).

## Predicted effects (the gate decides, both populations)

- **SECONDARY dInl collapses toward the oracle** (2210: 50 uncaptioned → ~23): a shattered commutative
  diagram is one draw-run — this is the population the whole milestone targets (clean whole-diagram crops,
  Option B's deliverable).
- **PRIMARY under-count may partially self-heal**: fuller merged bboxes close caption gaps (ledger items
  B/C). Re-run `scratch/caption-diag.ps1` on 2210/2205/2403 after landing; survivors are real.
- **The epsilon de-frag loop becomes largely vestigial** — keep behind its flag, run the gate with/without,
  retire it only when the table says it adds nothing.
- New summary counters: `consensus_unions`, `stream_blocks`, pages where consensus changed the partition —
  drift stays visible.

## Non-goals at m1 (each earns entry only if the gate says m1 left residual)

Jaccard/IDF provenance view; clip-group-id / color-bucket / marked-content IR enrichment (NOT emitted today
— `is_clipping` is a boolean, cannot seed classes); `SymmetrizationRule`/`Boruvka` ports; cophenetic combine
/ `IClusterLineage`; em-anisotropic dilation (stays the provenance-absent fallback); ThermoMapper grafting
(milestone-2+, user-driven, codex→ThermoMapper direction only).
