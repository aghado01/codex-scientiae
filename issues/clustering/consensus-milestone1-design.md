# Consensus milestone-1 — stream-block view + OR-combine (design)

**Status:** LANDED 2026-07-05 (`ea13156` implementation + calibration; measured results + ablations in
the section at the end). The first increment of the ensemble/consensus spine
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

---

## As landed + measured (2026-07-05, `ea13156`)

**Calibration (scratch/stream-calib.ps1, committed).** Consecutive-id gaps in em, classed by the caption
ground truth: TRUE float-boundary teleports (pairs straddling two captioned regions) min **7.24em** /
p50 26em (11 samples, raw: 7.2 11.5 15.9 19.2 23.8 26.1 26.8 34.3 37.6 37.8 43.3); intra-figure steps
p50 0.63em / p95 7.9em; intra-uncaptioned p50 0.91em. **Zero page-spanning paths corpus-wide** (the
watermark/background hazard is absent here — no span guard needed). → `stream_jump_em 6.0` (catches
100% of observed boundaries), `t_far_em 4.0` (~45% under the boundary minimum).

**One implementation deviation.** The literal all-pairs `gap(i,j) ≤ T_far` union is O(n²)-hostile on
thousand-path draw-runs (2603's dense figures, one page = 23k paths). As landed: consecutive pairs
≤ t_far chain-union, then sub-chains re-glue to fixpoint on **block-scoped union-bbox proximity**
(≤ t_far). Same granularity where it matters — near sub-runs re-glue, distant sub-runs stay apart.

**Gate (both populations) + ablations (scratch/consensus-ablation.ps1, committed):**

| variant | mean dFig | mean dInl |
|---|---|---|
| consensus-off (reproduces the pre-m1 table EXACTLY — clean attribution) | 1.5 | 9.1 |
| **consensus m1** | **1.5** | **8.3** |
| consensus on, defrag off | 1.5 | 9.3 |

**Predictions scored:**
- *SECONDARY collapses toward the oracle* — PARTIAL. 9.1 → 8.3 mean; the target paper 2210 went
  50 → 39 uncaptioned (dInl 27 → 16), not to ~23. Residual question for the next lever: what are
  2210's remaining 16 extra regions (fragments split at >6em pen steps? rescued furniture?).
  2111/2403 dInl rose ~2 each — noise-RESCUED fragments becoming visible regions (new evidence,
  not necessarily wrong; needs the same per-region diagnosis).
- *PRIMARY may partially self-heal* — DID NOT HAPPEN. dFig row-identical to pre-m1 (consensus is
  PRIMARY-neutral; no regression either). Ledger items B/C/E all SURVIVED the reshaped regions —
  re-diagnosed and reclassified as REAL in `tier2-handoff.md`'s ledger.
- *Epsilon de-frag becomes vestigial* — **FALSIFIED, keep defrag.** defrag-off degrades SECONDARY
  to 9.3, worse than no consensus at all on 2111 (+6), 2205 (+6), 2307 (+8): the dendrogram-elbow
  pass merges geometry fragmentation that stream evidence does not cover (different draw-runs, same
  figure). The two mechanisms are complementary, not redundant.
- Counters landed (`stream_blocks`, `consensus_unions`, `consensus_changed_pages`, per-region
  `flag=consensus_merged`) and flow through to `pig-run.json`.
