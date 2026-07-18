# Tier-3 engineering plan — re-minted post-render (2026-07-07)

> **FORWARD PLANNING HAS MOVED to the dated frontier-brief convention: see
> [frontier-20260715.md](frontier-20260715.md) (latest).** This file remains the historical log of
> the A/B/C thrusts — every increment's calibration, verdict, and commit record lives here and stays put.

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
| **2210 −2, 2302 −1** (PRIMARY unders) | a figure is missing from the page under its own reference | RE-VERIFIED against the current run 2026-07-07: 2210 −2 is Fig 1 + Fig 4, **both A3 item-D** (caption never became a Lane-3 block). The old "(c) Fig 16 contention" **EVAPORATED** — Fig 16 (`1 Figure 16:`) now pairs correctly (region above caption, gap 23.6pt); the stale handoff ids were from a pre-refresh run. 2302 −1 is A3 too (its 5 unclaimed cue-blocks are all Algorithm/Table furniture). | **A3** |
| **voroninski 1705 −1 → 0, 1701 −2** (PRIMARY unders) | a figure's plot renders WELDED with its caption mid-image, or missing | caption-interior WELD: the caption sits vertically INSIDE a kind=figure region (BLOCK-INSIDE), so it never attaches. 1705 Fig 1 = 0-claims chicken-and-egg (no style learnable). **1705 ✅ RECOVERED** (A2a no-style bootstrap); **1701 Figs 7/15 ✅ RECOVERED** (A2b bottom-band attach+trim — degenerate below-empty, not a weld). Voroninski PRIMARY 0.35, 18/23 exact, 0 over. | **A2** |
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
  (`probes/prefix-tail-probe.ps1`): every real leading-glyph caption (`∼ Figure 10:`, `1 Figure 16:`,
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
- **A2 — attachment tail — ⏳ PARTIAL 2026-07-07: literal premise EVAPORATED, real defect found + one recovered.**
  The plan's "multi-caption contention → per-page assignment" targeted 2210 Fig 16 — but the current run
  pairs Fig 16 correctly (verified: region above caption, gap 23.6pt; the handoff's `id51/id52` were stale
  pre-refresh ids). **caption-diag across every under-paper found ZERO genuine contention** (each under is
  either A3 undetected or Algorithm/Table furniture correctly excluded). The ACTUAL live attachment-tail
  defect is a different class — **caption-interior WELD** (BLOCK-INSIDE): a "Figure N:" caption sits
  vertically inside a kind=figure region, so it never attaches. This is the LANDED V_caption interior split
  (§0), but two gaps blocked it:
  - **✅ A2a no-style BOOTSTRAP — LANDED (`pdfdig-figures.ps1` `Split-CaptionInteriorRegions`).** A paper
    whose ONLY caption IS the weld it needs has 0 pass-1 claims → no style learnable → the split bailed
    (chicken-and-egg). **1705.07576v3 Figure 1** ("A plot of g(θ)": its 44 plot paths sit ABOVE the caption;
    the region only dips below on 2 degenerate bitmap points). Fix: when styles empty, split ONLY from a
    self-evident cue-then-SEPARATOR caption ("Figure 1:"). Calibrated (`probes/caption-bootstrap-calib.ps1`)
    to fire on EXACTLY 1705 reg7 corpus-wide, 0 false; ph-zigzag has no 0-claim papers → byte-identical.
    **Voroninski PRIMARY 0.48 → 0.43 (17/23 exact, 0 over); ph-zigzag 0.7/5.4 invariant.** Crop eyeballed:
    clean whole plot + caption. Config knob `caption_split.bootstrap_no_style` (default on).
  - **✅ A2b bottom-band attach + crop-trim — LANDED 2026-07-07 (`Split-CaptionInteriorRegions`).** The
    premise ("style/overlap guards don't fire") was FALSIFIED: for 1701 Figs 7/15 the style, height,
    interiority AND overlap guards all PASS — the split fails because the midline cut is **degenerate with
    BELOW empty** (every path/xobject member's center sits above the caption). These are not welds: the
    caption is a bottom-band **below-caption** the region bbox merely OVERSHOOTS. Fig 7's plot ink floors
    at y518 while **6 clip paths** (ids 47/48/50/54/100/115, `is_clipping=true`, unpainted) span down to
    y399 past the caption top 495 — and so does a whole-region **painted** fill (id49, `is_filled=true`,
    y399→728). It is id49, not the clips, that pins that floor: being *filled* it survives any paint- or
    clip-based member-drop, so the fix is a color-agnostic caption-top CLAMP (not member removal), and
    de-inflating this class corpus-wide waits on IR color (§2-E-rider,
    `issues/clustering/crop-bbox-inflation.md`). Fig 15 is one oversized xobject placement padding past its diagram. Add-FigureCaptions misses it
    (overshoot → negative below-gap −96/−53) and the split finds nothing to cut, so the caption falls
    through both passes. FIX: when a degenerate below-empty interior caption is the only candidate (no weld
    cut made), attach it to the whole region as its below-caption AND pull the crop bbox bottom UP to the
    caption top — the crop stops welding the caption (and, for Fig 15, a trailing body line) into the
    figure; area/em²/density recomputed, kind stays figure. Calibrated (`probes/bottom-band-calib.ps1`,
    33 papers both corpora): fires on EXACTLY 1701 Fig 7 + Fig 15, **0 false attachments, 0 trim hazards**;
    ph-zigzag has 0 firings → byte-identical. **Voroninski PRIMARY 0.43 → 0.35 (18/23 exact, 0 over),
    1701 −2 → 0 (16/16); SECONDARY 11.65 → 11.57; ph-zigzag 0.7/5.4 invariant.** Crops eyeballed: Fig 7
    clean 2×2 grid; Fig 15 body-line gone, diagram intact (a faint 1-line caption sliver remains — blk430
    "Figure 15: lower)." is a Lane-3 mis-assembled fragment whose bbox undersizes the caption's first line;
    trimming higher would risk the "Lower mirror" label — left as A3-class block-detection noise). Config
    knob `caption_split.bottom_band_attach` (default on); unit tests + knob-off test in
    `tests/pdfdig-figures.Tests.ps1`. The per-page bipartite ASSIGNMENT idea stays shelved (no contention).
  - Per-page bipartite ASSIGNMENT (the plan's original idea) stays **shelved** — no contention exists in
    either corpus to justify it; revisit only if a future run surfaces a genuine two-region caption fight.
- **A3 — item-D block detection (the hard tail).** Captions that never became a "Figure N"-prefixed
  Lane-3 block at all (2210 Fig 1). XYCut/DLA quality — the deepest, least certain; do it last and only
  what the render proves is worth it.
- **A3-0 — ✅ PROBED 2026-07-18 (chip `scratch/a3-probe.ps1`; full census in
  [a3-0-probe-brief.md](a3-0-probe-brief.md) §Probe report): the "DLA surgery" fear was WRONG —
  all 3/3 captions survive letters+words INTACT and die at ONE guard: the attachment cue test over
  the block-head 14 chars.** Two Lane-3 shapes: 2210 = per-word block fragmentation (caption rows
  shattered into 5/13 single-word blocks — `Figure` and `1:`/`4:` in SEPARATE blocks, so no block
  carries cue+digit); 2302 Fig 5 = superscript pollution (mini-lines `i+1 i+1 ′` prepend in block
  text order → cue at char 10, digit outside the window). All OTHER guards pass (gaps 3.1/2.6/0.6
  em vs 4.5 ceiling; overlap; kind). Premise corrections: Fig 4 "in-text-ref-only" was stale-WRONG;
  Fig 1 "no block" imprecise (five blocks); 2302's miss = Figure 5 (its "Figure 1" is an
  empty-caption \parpic — correctly outside PRIMARY). Cue census: every in-text ref is mid-block →
  block/line-start anchoring keeps them out; all 3 captions carry cue-then-SEPARATOR. **Predeclared
  rule clause 1 FIRES → A3 = bounded caption rescue in Add-FigureCaptions candidate generation:
  (a) per-LINE cue test (2302 class), (b) same-row cue stitch for digit-less cue blocks (2210
  class), both under existing style/geometry/separator/in-text-ref guards. Acceptance: 2210 −2→0 +
  2302 −1→0 target assertions, zero new claims, zero PRIMARY overs, both corpora.** Bonus
  consistency: post-rescue 2302 regions 14+15 share the caption → subfigure-group into ONE float =
  the oracle's Figure 5 exactly.
- **A3-1 — ✅ LANDED + GATED 2026-07-18 (the bounded rescue; acceptance PASSED IN FULL).**
  `Get-CaptionCueMatch` (effective-head cue: slides past LEADING sub-body mini-lines only — a
  wrapped in-text ref after full-size prose is structurally unreachable) + `Get-CaptionRowStitches`
  (bare-cue-word block recruits same-row neighbors at word-spacing gaps ≤ 0.75em into a composite
  that must complete cue-then-digit, then faces the unchanged geometry gates; representative
  block_id = cue block for subfigure grouping, block_ids = all members for the V_letters strip).
  Knobs `caption_line_cue`/`caption_row_stitch` default ON (+ `caption_stitch_gap_em` 0.75,
  `caption_head_min_size_frac` 0.9); banded-ablation pins them OFF (recorded baselines predate A3).
  Suite 80/80 (5 new: both classes, both guards, knobs-off contrast byte-identical). Full 33-paper
  calibration regen + gate: **2210 16/16 EXACT (−2→0), 2302 5/5 EXACT (−1→0), zero new claims,
  zero PRIMARY overs; ph-zigzag PRIMARY 0.7→0.4 (9/10 exact — sole residual = 2307 oracle-noise),
  voroninski 0.35 row-identical. SECONDARY improves both: 5.4→4.8, (live) 10.52→9.78** — the full
  regen also landed C′+dehyph on every run, converging the live gate onto the offline instrument.
  **The A-thrust is COMPLETE: every remaining PRIMARY under on the calibration battery is
  attributed oracle-noise or raster-blindness — no caption-attachment class remains.**

### B. Backbone-conditioned metric (full T3) — the deep SECONDARY move
`rectangle-gap` is geometry-blind: 2em of whitespace and 2em of body-text band weld identically.
T3-lite vetoes the damage post-hoc; full T3 prevents it — a `rectangle-gap-conditioned` `IDistanceMetric`
in `src/hdbscan` reading a per-page BANDS sidecar (the backbone T3-lite already computes) and inflating
gap components that cross a band. Surface: one C# metric + `--bands` CLI input + `Invoke-Hdbscan`
plumbing + the lane writing bands; trust-harness unit vectors ([[hdbscan-trust-harness]]).
**Acceptance signal (unchanged, and elegant): the in-flow veto's demotion count DROPS — it inverts from
fix to audit.** In the render: fewer over-cropped welds.
- **B-0 calibration — ✅ DONE 2026-07-10 (`probes/band-weld-calib.ps1`): premise CONFIRMED, design locked.**
  Fire-set: **189/492** figure regions cross ≥1 interior prose band (both corpora, newest runs), incl. two
  CAPTIONED paragraph-welds — 1608.02165v1 p8 id7 / p9 id8 (a stray member welded across a full paragraph
  into a real figure, 167/254 members below → a paragraph of body text rides the crop) — and the known
  control 2112 id6 (56% cover, under T3-lite's 0.7 cut). Acceptance baseline: **201 inflow demotions**
  corpus-wide. **BACKBONE LOCKED at NODE level, not T3-lite's blocks**: bands = individual wide
  (≥ `wide_block_em`) PROSE/heading-candidate node bboxes. Block-level fails BOTH ways (measured, probe
  header has the iteration record): excluding any formula-node owner loses 1608 p9 (a majority-prose
  paragraph with one embedded display line); majority-by-node-count barely filters (consecutive formula
  lines merge into ONE group node, undercounting math). Node bands need no composition threshold at all.
  **METRIC FORM: `gap′ = gap_y + λ·(prose-cover of the vertical gap interval)`**, counting only bands that
  horizontally overlap BOTH boxes (2-col safety) — continuous, so the GUARD population node bands surfaced
  (captioned subfigure/consensus-merged regions with a ~1em interior subcaption row: 2204 p12 id14,
  2501 p12 id16, 2008 p8 id5 / p12 id10, 2603 p8 id7 / p11 id10, 2006 p11 id7) stays merged at λ·1em while
  1608's 11.5em paragraph splits at λ·10em — a ~10× target/guard margin; scale anchors from stream-calib
  (intra-figure steps p50 0.63em, float-boundary teleports min 7.24em). Sidecar must filter degenerate
  zero-height nodes. **CAUTION: B is the FIRST change on the formation path itself — PRIMARY invariance is
  empirical, not structural → opt-in config knob, gate BOTH corpora before it defaults on.**
- **B-1/2/3 — ✅ LANDED 2026-07-10: engine + CLI + lane wiring, knob default OFF (inert).**
  `BandedRectangleGapMetric` (`src/hdbscan/Metric.cs`) + `--bands` / spec `rectangle-gap-banded[:lambda=N]`
  (CLI, fails loud without bands or off dim-4) + `Invoke-Hdbscan -Bands` + lane (`pdfdig-figures.ps1`):
  prose-node bands built pre-loop, `p{page}.bands.jsonl` sidecar, `figure_regions.banded_metric` knob
  (enabled/lambda/band_min_width_em), `summary.banded_pages`, defrag re-run inherits bands via the args
  copy. Verified: 8 C# unit vectors, 3 CLI e2e (the behavioral pair: same 16-box page welds plain /
  splits banded), 2 lane integration tests (prose band splits, formula + narrow lines do NOT band);
  figures suite 72/72, hdbscan 9/9. (WATCH from B-3, still standing: consensus V_stream can re-weld a
  banded split when the cross-band chain step is < `stream_jump_em` 6em.)
- **B-4 — ✅ MEASURED 2026-07-10 (`probes/banded-ablation.ps1`, offline re-cluster both corpora): knob
  STAYS OFF; the metric's payoff is gated on C.** Method: baseline variant reproduces the recorded gate
  EXACTLY row-for-row (ph-zigzag 0.7/5.6, voroninski 0.35/11.74 — the plan's quoted 5.4/11.57 were stale
  run-states; sentinel counts byte-stable), so banded-vs-baseline isolates the knob. At λ=2:
  **PRIMARY INVARIANT on both corpora (0.7 7/10 + 0.35 18/23, 0 over — the non-negotiable holds)**;
  guards hold (one mild wobble: 2008 p8 capH 480→510, eyeball on next full regen); but **SECONDARY
  drifts adverse (5.6→5.8, 11.74→12.0 — splits create more uncaptioned survivors than the veto eats),
  inflow RISES (21→26, 180→191)** — the acceptance prediction "inflow drops" was WRONG in direction: the
  mechanism is **split-feeds-veto** (banding splits mixed welds so T3-lite catches the equation halves),
  prevention and audit are teammates, not a handoff. **And the render-visible targets are IMMUNE: 1608
  p8/p9 + 2112 id6 unmoved — proven structural by a single-page probe: at λ=20 (~1600pt inflation) 1608
  p8 still yields 1 cluster / 0 noise with both strays (a path AND an xobject above y450) absorbed.**
  ROOT CAUSE: `allow_single_cluster` EOM selects the ROOT on lone-blob pages and the root absorbs every
  non-noise point regardless of distance — **the monster-weld class is a cluster-SELECTION defect, no
  finite λ can eject the stray**. VERDICT: B lands as substrate (safe, tested, inert); its corpus payoff
  arrives with **C (T2 persistence-band selection)** — a point attached only at extreme distance falls
  outside the persistence band → noise — exactly the "C is cleaner on conditioned formation" dependency,
  now with a measured defect class waiting for it. Re-evaluate the λ sweep AFTER C.

### C. T2 persistence-band selection — one rule replaces three heuristics
From `hdbscan_dendrogram.json` (already emitted), select components persistent across a dilation band
[a,b] em instead of EOM-stability + `fragmentation_flag_min_clusters` + defrag-elbow. PS-side first.
Calibrate like `stream-calib` (birth/death stats of oracle-aligned regions). Retires two knobs;
the defrag ablation becomes its regression test. In the render: multi-panel plots crop whole.
- **C-0 calibration — ✅ MEASURED 2026-07-10 (`probes/persistence-band-calib.ps1`, 443 regions both
  corpora, both metrics): the GLOBAL band is FALSIFIED — C is RESCOPED to C′ below.** Captioned
  (oracle-aligned) regions: assembly p50 2.6 / p99 25.9 / max 29.5em vs death min **0.7** / p10 3.5em —
  genuine (jacc≈1) figures assemble as late as ~17em (2205 p7 id13, 1506 p31 id109) while other genuine
  figures DIE at 0.7–1.1em (2008 p11 id9; the 883-member 2603 p8 subfigure block) → a ≥ 17 ∧ b < 0.7 is
  a > b: **no corpus-wide [a,b] exists; infeasible even within the subfig-merged guard class alone
  (asm max 8.6 vs die min 0.8)**. Second falsification: **banding inflates the WRONG side** — banded λ=2
  pushes captioned assembly p99 25.9→37.7 while min-death stays 0.7 (tight deaths are figure-to-FIGURE
  adjacencies with no prose between; late assemblies are the cross-band welds whose internal gaps banding
  inflates) — the "B widens C's band" composition story is dead at the global level. Root insight: pages
  vary in scale ~10×, which is WHY selection is density-relative; a fixed absolute band re-introduces the
  global-threshold species the knob history (elbow, t_far, stream-jump) evolved away from. Caveat noted:
  the very top a-side rows are caption_split artifacts (jacc 0.25–0.5 — split products aren't dendrogram
  nodes); the genuine 17em cases stand. The one true fixed anchor the probe DID surface: the B-4 monster
  signature is a RELATIVE jump — 1608 p8 blob internal scale ~1em, stray attach 24.7em (banded 40.9);
  p9 9.9em; 2112 25.3em — which motivates C′:
- **C′ (rescope) — per-cluster relative STRAY EJECT (post-selection trim).** Walk each selected cluster's
  dendrogram top (LCA of its members): while the current merge's far side holds ≤ tail_max cluster
  members AND the merge distance ≥ gap_k × the larger child's own assembly (the within-cluster
  defrag-elbow idiom: relative log-gap, a PROVEN statistic species), eject the far members to noise.
  Veto-shaped (trims membership, never asserts — the design law); guards safe by construction
  (multi-panel panels are never tiny → tail_max spares them); per-cluster scale-relative (transports
  across pages); PS-side from the same dendrogram; does NOT retire the defrag/frag knobs (that dream
  died with the band). λ re-sweep RE-AIMED, not dead: banding raises stray-attach distances (24.7→40.9)
  → SHARPENS C′'s relative jump; measure C′ plain first, then C′×λ. Ladder: **C′-0** eject-statistic
  calibration (fire-set must catch 1608 p8/p9; false-positive census = small legitimate satellites,
  colorbars/legends, attaching late-and-small) → **C′-1** implement behind `figure_regions.stray_eject`
  knob default OFF → **C′-2** unit + integration tests → **C′-3** ablation gate both corpora + λ sweep.
- **C′-0 — ✅ STATISTIC LOCKED 2026-07-10 (`probes/stray-eject-calib.ps1`, 522 figure-owning clusters,
  three iterations — the full v1→v2→v3 record lives in the probe header).** v1 (near-child ratio)
  FAILED: strays attach as a LADDER, so each step reads locally modest (1608 p8 ratio 2.2, no fire)
  while trivial junk fired at 6–64×. v2 (raw spine ln-gap elbow) FAILED both ways: single-linkage
  CHAINS dense blobs (1608 p8 = 166 thin rungs of 169 — a fat-split "core top" barely exists), and
  ln-gaps between sub-glyph distances (0.001→0.01em) out-compete the real boundary — subfig clusters
  "ejected" 62/38/24 members from cuts landing in contact-scale noise. **v3 (LOCKED): clamp the spine
  distance sequence at contact scale (`floor_em` 1.0) before the ln-gap scan** — phantom cuts collapse
  (clamped-flat sequences have no gaps), real boundaries survive. At `min_log_gap` 1.0 (the defrag
  convention, ln): **1608 p8 ejects exactly 2 (the path+xobject stray pair, lnGap 2.43), p9 exactly 4
  (2.07); 2112 stays by chain-uniformity (0); ZERO dissolutions; 71 clusters shed 173 members
  corpus-wide.** FP census 11 captioned non-monster rows: 8 are caption_split RAW clusters (welds the
  splitter cuts anyway — ejecting their 17–46em strays helps or is neutral; one IS 1701 p4 reg4, the
  crop-bbox-inflation region, shedding its 46.6em strays), 3 are large figures shedding one far member
  (colorbar-risk class → C′-3 crop eyeball). tail_max = min_cluster_size−1 structural; knobs =
  min_log_gap 1.0 + floor_em 1.0 only.
- **C′-1/2/3 — ✅ LANDED + GATED 2026-07-10, knob OFF pending crop eyeball only.** Implementation:
  `Get-StrayEjectRows` (pure spine-elbow) + `Invoke-RegionStrayEject` behind `figure_regions.stray_eject`;
  75/75 figures suite (the B-4 defect in miniature: knob-off absorbs a 29em stray, knob-on ejects exactly
  it; a uniform areal chain never ejects). **PLACEMENT DISCOVERY (gate round 1): label-level ejection
  regressed PRIMARY (0.35→0.43) — in caption_split welds the far "strays" can be a TINY REAL FIGURE
  (≤ tail_max paths, too small to ever cluster alone) that the splitter rescues; geometry cannot tell it
  from a stray, but pipeline ORDER can.** Round 2 (post-caption region trim, captioned keep caption+kind
  per the A2b family, uncaptioned re-gate): **PRIMARY exactly restored both corpora (0.35 18/23 + 0.7
  7/10, 0 over); 1608 p8 capH 398→151, p9 169→69 (the paragraph leaves the crop); all guards byte-stable;
  SECONDARY improves BOTH corpora — voroninski 11.74→9.96, ph-zigzag 5.6→5.3 (better than label-level);
  176 ejects / 76 clusters ≈ the calibration census.** λ RE-SWEEP CLOSED: banded λ=2 + eject measured
  WORSE than eject alone (10.3/5.7 vs 9.96/5.3) — banding's extra ejects don't convert; **B stays parked
  (knob off), C′ alone carries the monster-weld class.** Remaining before default-on: crop-eyeball the
  1608 wins + the 11-row FP list (1506 p31/p32, 1509 p26 …) on a knob-on regen.
- **C′-4 — ✅ CLOSED, DEFAULT-ON 2026-07-15 (crop eyeball; the knob flip ships in this commit).**
  Census re-run (`probes/stray-eject-calib.ps1`, post-gauntlet-move paths) reproduced C′-0 exactly:
  71 clusters / 173 members @ ln-gap 1.0, sentinels byte-identical (p8 ejects 2 @ lnGap 2.43, p9
  ejects 4 @ 2.07, 2112 p8 stays @ 0, 1608 p7 stays @ 0.33), zero dissolutions. The complete 11-row
  FP census: 1506.01437v2 p31 reg109 (e5) + p32 reg111 (e2), 1109.4499v1 p5 reg4 (e4), 1701.08493v2
  p4 reg4 (e2) + p14 reg17 (e2), 1705.07576v3 p11 reg7 (e2), 1807.04261v1 p10 reg13 (e2), 2210.00916
  p32 reg45 (e2), 1109.0573v2 p17 reg13 (e1), 1509.05064v1 p26 reg97 (e1), 1812.04176v1 p10 reg10
  (e1). Knob-on `Invoke-Pdfdig` regen of all 10 manifest papers, stamps `20260715_062456`–`064034`.
  **Verdicts 13/13 PASS, zero figure-ink loss.** Targets: p8 crop 399→152pt (running head, §3
  heading, full paragraph and §3.1 heading all leave; 4 heatmap panels + colorbars + titles intact),
  p9 171→71pt (5 welded body lines leave; both panels + legend markers intact). FP rows: **8/11
  crops pixel-identical** — the region-level post-caption placement (the C′-3 discovery) voids those
  cluster-level census rows, their far strays living in the other split product; **3/11 tighten with
  nothing lost** (1506 p31 331→163pt tall, 1506 p32 369×215→264×174, 1509 p26 367×215→263×173): the
  "colorbar-risk" class was bbox inflation over dead whitespace — no satellites existed to lose.
  Live gate post-regen: PRIMARY row-exact both corpora (0.35 18/23 + 0.7 7/10, 0 over); SECONDARY
  voroninski 10.52 live (converging on the offline 9.96 as knob-on runs replace pre-landing ones).
  Hardening that rode the flip: the knob-off B-4 regression test and banded-ablation.ps1 now PIN
  their knobs explicitly (a store-default flip must never change what 'baseline'/'off' means; suite
  75/75), and `pig-run.json` carries `stray_ejects`/`stray_eject_clusters` provenance. **Named
  observation (not a blocker): tight crops expose the pre-existing letters-lane clipping** — axis
  titles/y-labels are wide letter blocks outside the path-ink union (V_letters attaches ≤4em only),
  so 1608 p9 + the three tightened rows clip them at the new edges (they rode the stray-inflated
  bbox before). Candidate: crop-bbox letter padding in the E1/`visible_bbox` family. C′ is COMPLETE;
  B stays parked; the monster-weld class is carried.

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
- **E-rider — crop-bbox de-inflation (A2b follow-up, scoped `issues/clustering/crop-bbox-inflation.md`).**
  Invisible geometry inflates a region's crop rect past its visible ink. Split into (a) UNPAINTED-path
  inflation — detectable NOW (`is_stroked ∨ is_filled`), a crop-only `visible_bbox` in the render lane,
  PRIMARY-invariant, but only **1 region corpus-wide** (1701 id4, +1.3em) so it is a low-urgency rider,
  not a thrust; and (b) white/background-FILL inflation (1701 Fig 7's id49 whole-region white fill) — the
  severe case, needs this thrust's **color-bucket** to tell a background fill from a black panel, and is
  already covered for the captioned case by A2b's color-agnostic caption-top trim. Once color lands, (b)
  folds into `visible_bbox` and A2b's bbox trim could revert to attach-only. Probe: `probes/clip-inflation-probe.ps1`.

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
