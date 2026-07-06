# pdfdig-PS — the opendataloader-pdf replacement lane for codex-scientiae

**Status:** LARGELY LANDED (updated 2026-07-03; born as DESIGN 2026-07-02). The end-to-end path
**PDF → multi-lane IR → classified nodes → membrane → finalized markdown** is built, tested (500+
Pester), and validated on 2508.11646 (structure now matches the LaTeX oracle 1:1; math 87% render-
clean with the residue honestly flagged + doled to a gated reasoning-repair loop). The design body
below is the rationale; the dashboard next is the current state + what's left. The deterministic,
VLM-free PDF→IR converter for the membrane's ingestion needs, in PowerShell, driving PdfPig directly.
**Division of concerns (user-decided):** THIS lane (codex, PS) = the *converter* — PDF → membrane IR,
"membrane style." **`Markpig.Pdf` (C#) remains** and shifts to the *PDF-AST tier* — 2-D math-structure
assembly, render-back verification, foreign-AST → `New-MarkdigAst`. Same family, two tiers.
**Motivation:** building against opendataloader's conversion (formula enrichment, hybrid Docling) is
painstaking; its architecture is the inverse of what the corpus needs (VLM-primary, geometry
discarded, ghost placeholder layer, `level` scrambled). The seeds of the better solution exist and are
validated (pdfdig recon + first dig).
**Related:** pdfdig SHAPE.md (MarkPig), `issues/conversion-metric/` (the acceptance harness),
`issues/latex-math-oracle/` (the fidelity net over this lane), `issues/docling-failure-modes/`
(the catalog of what this lane must not reproduce).

**NORTH STAR (user, 2026-07-06, after working ph-zigzag + mapper end-to-end):** pdfdig converges on the
SAME finalize / pre-promotion transpilation standards as the LaTeX oracle — the ideal being that
**pdfdig can replicate an oracle run from a bare PDF**: same deliverable shape, same image register
(PNG, `images/{slug}/`), same math/structure conventions, same gates (`render_check`+lint), so the
oracle stops being a separate product and becomes the *reference implementation* pdfdig is measured
against. The two-population figure gate, crop-vs-render parity, and the conversion-metric harness are
all instruments OF this convergence. Sourceless PDFs are the reason the goal matters ([[mathdig-is-
downstream-not-a-pdf-solver]]: no LaTeX lane exists there — pdfdig has to stand in for it).

---

## Progress dashboard (2026-07-03) — what's landed, what's next

**The lane, end to end.** `src/pdf-converter/` (converter) + `src/pdfdig-adapter.ps1` + membrane:
- **IR substrate** (`pdfdig-ir.ps1`) — envelope + 4 lanes (letters / words / blocks+reading-order /
  paths), all born signals, opinion-free. Deterministic (byte-identical re-runs). → `ir-schema.md`,
  `pdfpig-capability-map.md`.
- **Config stores** (`stores/`) — `font-roles`, `producer-map`, `symbol-map`, `classify-config`, all
  wired + validated; `specimens.jsonl` registry (6 specimens). Rules-as-data; growth loop proven
  (known-font-role 0.03→1.0 via store edits).
- **Classifier** (`pdfdig-classify.ps1`) — order-statistics calibration + typed node stream
  (role/script/heading-tier/formula/marker), bidirectional outline cross-derivation, wrapped-heading
  re-fusion. Heading structure MATCHES the oracle on 2508.11646.
- **Math assembler (1.5-D)** (`math-assembler.ps1`) — recursive size-tier script NESTING
  (`t_{v_{i+1}}`, not the invalid flat `t_{v}_{1}`). Delimiter-balance flags.
- **Membrane dual-lane intake** — `membrane-handoff.md` (LANDED): membrane ingests pig IR OR
  opendataloader through one on-ramp.
- **Gated math repair** — `gated-math-repair.md` (LANDED): flagged residue → `math_evidence`
  geometry transcript → dispatch → reasoning-model repair → `render_check` gate. Promotion of a fix to
  the deterministic tier is HUMAN-gated (the machine surfaces, never promotes).
- **Perf + substrate** — advance-based spacing, lane-gated normalize, dehyphenation; jsonl bulk-write
  + inline `.jidx`; encoding-invariants test suite. 84p warm: IR 148→51s.

**Clustering engine (HDBSCAN) — LANDED (2026-07-03).** The density-clustering capability reserved for the
genuinely-continuous problems (figure-region assembly + a segmentation THIRD-witness — NOT the
quantized-typography classifier spine, which stays order statistics). Built as a standalone C# CLI
(`hdbscan.exe`; code in `src/hdbscan/`, ns `CodexSci.Hdbscan`, published to `bin/hdbscan/` via
`scripts/build-hdbscan.ps1`) that the PS lane invokes as a subprocess. Full state + do-order in
**`issues/hdbscan-cli.md`**: 9 distance metrics (incl. `rectangle-gap` for layout, poincaré/hyperboloid for
hierarchy), 6 sklearn-compatible external evaluators, a trust harness (C# unit + Pester e2e), and
`--cluster-selection-epsilon` (the HDBSCAN/DBSCAN hybrid). **First consumer LANDED — figure-region
detection** (`src/pdf-converter/pdfdig-figures.ps1`): per-page rectangle-gap clustering of Lane-4 path bboxes
→ `{slug}.figures.jsonl` (union bbox + `area` + em²-normalized `kind` figure|mark|degenerate), stray rules →
noise (-1), plus a dendrogram-walk de-fragmentation pass (over-split complex figures re-merge via the
fragment-adjacency elbow → `--cluster-selection-epsilon`). Validated across the 14-paper inbox (2205's
883-path page: 38 fragments → 2 figures; conservative — a no-clear-elbow page is left alone).

**Hand-tuning caveat (the standing discipline).** The figure-lane thresholds in `classify-config.json`
`figure_regions` (`min_region_area_em2`, `defrag_min_elbow_log_gap`, `fragmentation_flag_min_clusters`,
`min_pts`) are CONJECTURES tuned on the current inbox — exactly like the assembler's `size_ratio` (next-step
§2). em²-normalization already makes the mark floor transport across page + font size, and the de-frag elbow
is per-run, but the guard constants themselves want corpus-driven revision. `summary` records
`fragmentation_suspect_pages` / `defragged_pages` and each region's `area` + `area_em2` so drift stays
visible; treat every constant as falsifiable (beware calibration-set overfit).

**Tier-1 density gate + run-layout rewiring + first oracle batch (2026-07-04).** Two engine changes
landed. **(1)** The figure/mark decision moved from union-bbox AREA to ink DENSITY (`paths / area_em2`,
knob `min_region_density`; new kind `sparse` for a big-but-under-inked phantom) — area cannot tell a big
DENSE diagram from a big SPARSE phantom (a few furniture strokes whose union bbox spans a text column),
density can (commit `7539829`). This SUPERSEDED a wrong lever first tried — excluding rule-tagged paths
from clustering — because in this corpus figures ARE largely axis-aligned rules (2111.15058v3: 29% of
Figure 2's ink is `hrule` interval bars), so excluding them shatters real figures; **rules stay in, the
density gate rejects furniture instead.** **(2)** The converter now stages ALL IR under `.runs/{stamp}/pig/`
via the committed orchestrator `Invoke-Pdfdig.ps1` (it was dumping regenerable lanes beside the source —
~19MB `letters.jsonl`/paper leaking into git); membrane `Resolve-PaperSource`/discovery reads the newest
pig run (commit `1bb408b`). **First fresh pig-vs-LaTeX-oracle batch** over the 10-paper ph-zigzag
compendium (`Invoke-Pdfdig` + `compare.ps1` join against `latex_convert` figures+diagrams counts — now the
STANDING benchmark) delivered the verdict: **the raw figure-region count is NOT trustworthy — mean |Δ|
10.5 objects/paper, ratios 0.70–3.88×, BIDIRECTIONAL (6 over, 4 under, 0 exact)**; the density gate demoted
23 phantoms → `sparse` corpus-wide (that part works). Mechanism-attributed via the envelope's per-page
`GetImages()` count: **over-count = FRAGMENTATION** (gap-clustering shatters internally-gappy TikZ; 2210 =
65 regions vs 27 objects), **under-count = RASTER-BLINDNESS** (figure detection reads `paths.jsonl` only,
there is NO images lane, so `\includegraphics` bitmaps are invisible; 2205 = −8 with 31 bitmaps) + oracle
noise (2307's 5 `figures_missing`). No `figure_regions` threshold-tune fixes a bidirectional error — over
and under want opposite corrections. This grounds the revised Tier-2 plan (next-steps §4c).

**v1 must-haves — status against §"v1 must-haves" below:**
1. Column detection — ✅ (RecursiveXYCut, the vendored DLA solved "THE gap"; not built from scratch).
2. All-pages + assembly — ✅. 3. Satellite reattachment — ⚠️ partial (DLA line-grouping; no explicit
second pass yet). 4. Font-tier headings — ✅ (+ outline cross-derivation, beyond the plan).
5. Display-math regions + `$…$` seams — ✅ (1-D + now 1.5-D nesting). 6. Symbol correction — ✅
(store, math scope). 7. Ligatures/NFKC — ✅ (dehyphenation too). 8. Figures — region DETECTION ✅ (vector:
per-page rectangle-gap clustering + em² mark floor + dendrogram de-fragmentation) + density gate; region COUNT ⚠️ bidirectionally unreliable per the oracle batch (fragmentation + raster-blindness), Tier-2 fix §4c; caption reattachment ✅
(geometry finds candidates, the Figure/Table cue selects); image extraction ✅ (MuPDF-WASM region render → PNG under .runs/{stamp}/pig/, tools/pdf-raster + pdfdig-images.ps1).

**Open decisions — RESOLVED:** node shape = flat JSONL per lane w/ back-refs (✅). Conversions land
beside the PDF as `{slug}.*` (✅). Fork = vendored `lib/pdfpig` 0.1.14 (✅). Perf = low-level loops,
interior-swap hatch unused so far (✅, and the encoding-invariants suite guards determinism).

### Next steps — scoped for a future session (priority order)

1. **Delimiter-aware display-equation region assembly** (the deterministic frontier). Today's dominant
   residue is NOT fractions — it's `‖…‖`/`(…)` spans FRACTURED across formula-block lines (honest
   `unbalanced_delimiters`). Group all glyphs of one display equation (2-D region, not line-by-line)
   before assembling, so delimiters stay paired. Shrinks what the reasoning tier gets doled. This is
   the highest-leverage next build.
2. **Cross-specimen validation of the assembler's n=1 knobs.** `size_ratio`/`baseline_tol_frac` were
   tuned on 2508.11646 alone — run the classifier+assembler over the other 5 registry specimens
   (Latin-Modern, cmbright, newtx, office), measure render-clean %, and treat every constant as a
   conjecture (the "beware calibration-set overfit" discipline). Likely surfaces new store gaps.
3. **A/B campaign vs opendataloader** (the acceptance criterion, `issues/conversion-metric/`). Same
   dual-availability papers, both lanes, scored against the LaTeX oracle — the replacement claim as a
   number per lane. Needs the conversion-metric aligner (also unblocks oracle-backed benchmark trials).
4. **Figure lane — region DETECTION LANDED, but the oracle batch proved its COUNT unreliable; deliverables landed, reformulation planned (a/b done, c = the fix).**
   (a) **Caption reattachment — LANDED** (the "+ satellite text" of the original #4). Each `kind=figure`
   region gets its caption: geometry finds candidate Lane-3 blocks (adjacent below / above, overlapping ≥
   `caption_min_overlap_frac`, gap-gated by `caption_max_gap_em`); the caption cue (Figure/Fig/Table N,
   prefix-scanned so "δ Fig. 3" matches, length-capped so mid-sentence "see Figure 3" doesn't) SELECTS
   among them — so an adjacent section heading or body paragraph is NOT mis-attached and a caption-less
   region stays null. On 2508: 11/17 regions captioned (9 of 10 figures; the one miss = Fig 4's 76pt gap),
   zero false attachments. Region carries `caption {block_id, bbox, text, cue, position, gap}`; the
   membrane's caption-relocation lane consumes the link.
   (b) **Image extraction — LANDED (2026-07-04), the figure deliverable.** Rather than PdfPig's `TryGetPng`
   (embedded bitmaps only — half the corpus is all-vector), the pig lane RENDERS each figure region to PNG via
   vendored **MuPDF-WASM** (`tools/pdf-raster/render.mjs`, batched: one WASM load + doc-open per paper), which
   rasterizes vector TikZ AND embedded bitmaps uniformly — source-agnostic, PNG out, no sub-PDF/SVG.
   `src/pdf-converter/pdfdig-images.ps1` (`Export-PdfFigureImages`) → `.runs/{runstamp}/pig/images/imageFile{N}.png`
   + `images.jsonl` manifest (per figure: png, dims, caption, status). **Run convention:** mirrors
   `.runs/{stamp}/tex/`; `-pig`-namespaced so it never collides with Docling `{slug}/imageFileN.png` or the LaTeX
   source extract at `{slug}/{slug}/`; `.runs/` is git-ignored (regenerable staging, `publish` promotes). Verified:
   2508's 17 figures → PNG (a Fig-1 vector diagram renders pixel-perfect). Caveat surfaced: figure DETECTION
   over-includes boxed callouts / framed display-equations (rendered faithfully but not real figures — the
   manifest's null `caption` flags low-confidence, so `publish` can select captioned figures). PdfPig `TryGetPng`
   remains a future NATIVE-resolution path for pure embedded bitmaps (higher fidelity than re-rasterizing).
   (c) **Detection reformulation (Tier-2) — REVISED PLAN (2026-07-04), not yet built; REFINED into an ENSEMBLE spine — read "Ensemble / consensus spine" below as the current architecture, this subsection as its component rationale.**
   > **FOUNDATION CARVE-OUT + 2 CORRECTIONS (2026-07-04 recon — see `issues/clustering/foundation-scope.md`, chipped as a separate task).** Recon of the actual code reordered this plan. **(1) The "standing oracle benchmark / `compare.ps1`" does NOT exist as committed tooling** — the `+38/−8` numbers below were an ad-hoc one-off; `.runs/*/compare/pig` dirs are empty. So a committed harness is prerequisite Step 0, not an assumed given. **(2) Provenance is far THINNER in the current IR than this section assumes:** `paths.jsonl` carries only `id, bbox, is_clipping(bool), is_filled(bool), is_stroked, kinds, line_width, rule, subpaths`. Of the five consensus provenance axes, only **content-stream order (`id`) is richly reachable today**; XObject-id, color-bucket, and marked-content are **not emitted**, and **`is_clipping` is a BOOLEAN, not a clip-group id — it CANNOT seed co-membership classes** (the claim below that it's an "already-in-IR provenance axis available the same way" is **WRONG**). Consequence: the geometry⊕provenance **consensus is gated behind unscheduled IR-emitter work**; the **stream-order axis (iii) is the cheapest fragmentation fix that works NOW** (zero engine change — `RectangleGapMetric` is k-generic) and should be tried before the consensus machinery. **Revised sequence: (0) commit the harness → (1) images/xobjects Lane 5 [cures the `−8` tail] → (2) stream-order axis [cures the `+38` tail, reachable now] → (3) dilation [fallback] → (4) provenance enrichment + consensus [only if 1–3 leave residual fragmentation].** Steps 0–1 are the carved-out foundation (`foundation-scope.md`); 2–4 stay here, each gated on the harness. `UnionFind.cs` already exists in `src/hdbscan/` (de-risks the eventual flat consensus).

   The oracle batch
   (dashboard) proved the raw region count is bidirectionally unreliable and un-tunable by thresholds. The
   fix is **feature engineering of the clustering INPUT, not a new engine** — HDBSCAN + `rectangle-gap`
   stays; we shape better inputs to it. The guiding principle (the reasoning behind every accept/decline
   below): **added dimensions improve separability only when they align with the clustered RELATION.** Here
   the relation is spatial COHESION of deliberately HETEROGENEOUS parts (one frame + dozens of ticks + bars
   + a curve), NOT similarity — co-members do not resemble each other, and identical furniture (every QED
   square, both panels' tick marks) repeats across the page. So **adjacency/provenance** dimensions align
   and help; **appearance** dimensions (area, aspect) anti-align — they pull identical furniture together
   and split a figure's unlike parts, stratifying the very heterogeneity that defines a figure. Three
   changes, each separately measurable against the standing ph-zigzag oracle benchmark (`compare.ps1`):
   - **(i) Images lane (Lane 5), FIRST — cures raster-blindness.** Emit `{slug}.images.jsonl` = PdfPig
     XObject image bboxes + transform matrices (the envelope already COUNTS them via `page.GetImages()`) as
     a NEW lane — NOT injected into `paths.jsonl` (that lane's contract is vector paths; keep it pure).
     `ConvertTo-FigureRegions` unions image bboxes into the per-page point cloud, so a figure that IS one
     big bitmap becomes a first-class point instead of being deduced from its surrounding axes/labels.
   - **(ii) em-calibrated ANISOTROPIC dilation — cures fragmentation; subsumes the "RLSA reformulation" as
     a preprocessing STAGE, not an engine rewrite.** Dilate each bbox by `(Tx, Ty)` per side BEFORE
     clustering, `Tx/Ty` calibrated in em from body font (vertical ≠ horizontal — line-leading ≪ column
     gutters). Under `rectangle-gap`, boxes with gap `< T` then OVERLAP → distance 0 → HDBSCAN merges them
     for free; regions are assembled from the UNDILATED boxes. Dilation+connectivity IS run-length
     smoothing — so occupancy/RLSA becomes a stage, and it de-fangs the (Gemini-correctly-called-hacky)
     epsilon de-frag loop: most intra-figure fragments never separate. The dilation radii ARE the
     principled anisotropy knob (Rung 1 of the embedding ladder), calibrated not magic-guessed — and this
     supersedes Gemini's global-y-stretch suggestion, which was BACKWARDS for our worst case (Figure 4's
     vertically-STACKED panels: stretching y costs their gaps MORE).
   - **(iii) content-stream order as a third box-axis — the co-membership prior.** PDF generators (TikZ)
     draw a figure as a CONTIGUOUS run of ops, so the path `id` (emission order) is nearly a co-membership
     oracle: a figure's strokes are a solid id-block, the footnote rule and QED squares sit elsewhere in
     the stream. Pack a scaled stream index `s` as a degenerate interval → `[x0, y0, s, x1, y1, s]`; the
     k-generic `RectangleGapMetric` (`k = len/2`) consumes it with NO new metric — a soft prior that
     resolves spatially-ambiguous merges by "were these drawn together?". (This is backbone-conditioned
     persistence in miniature: the content stream is the page's temporal backbone. `is_clipping`
     clip-group membership is a second, already-in-IR provenance axis available the same way.)
   **DECLINED (with rationale, so it isn't re-proposed):** a 5D/6D metric enriched with area/aspect —
   breaks `RectangleGapMetric`'s box contract (it parses `[lo₀…lo_{k−1}, hi₀…hi_{k−1}]`, so appended
   scalars misparse the box) AND, worse, size-attraction shatters heterogeneous figures (it would stratify
   a figure by element size); the "two big boxes vs two glyphs at 5pt" asymmetry belongs downstream, where
   the density/em² gates already live. `Vector512` intrinsics are premature — pages top out ~900 paths, the
   O(N²) Prim MST is milliseconds. A graph-prior pre-collapse of INTERSECTING paths is only an N-reduction
   (overlapping boxes are ALREADY distance 0 under `rectangle-gap`, so it cannot reach the gap-separated
   fragments that actually shatter) — optional later, with eyes open that it re-scales `min_cluster_size`
   semantics. The fully-general "engineer a space where Euclidean = co-membership" is Rung 3
   (affinity graph → spectral embedding), still DEFERRED to the SPC/diffusion work; (i)–(iii) are Rung 2.5
   — better inputs to the existing metric, no new engine. **Sequence:** images lane → dilation →
   stream-axis, re-running the oracle batch after EACH so the table (not theory) says which dimension buys
   separability; watch whether the `+38 / −8` tails collapse.

   **Ensemble / consensus spine — the revised architecture (2026-07-04, with ThermoMapper `hashish` + graph
   prior art).** §4c's three fixes are correct but they are *components*; the architecture that composes them
   is **multi-view consensus**, because the two error directions need two VIEWS, not one metric bent to carry
   both. Provenance is RELATIONAL (a shared-tag relation between paths), so its home is distance/graph space,
   not a coordinate axis (the conclusion from the one-hot discussion).
   - **Geometry view** — HDBSCAN(`rectangle-gap`) on bboxes, exactly as today; dilation from §4c(ii) demotes
     to the provenance-ABSENT fallback (hand-made PDFs with no structure). → partition `P_geom`.
   - **Provenance view** — each path's tag-set {XObject-id, clip-group (`is_clipping`), stream-block bucket,
     color-bucket, marked-content / `/Artifact`} as a multi-hot vector; graded similarity by **Jaccard** (or
     IDF-weighted Jaccard). Either HDBSCAN it (→ `P_prov`) or, cheaper, take shared-tag equivalence classes by
     union-find directly. A tag's BINDING strength is gated by RARITY: a tag shared by more than τ of the
     page's paths is furniture (a page-background XObject) and is down-weighted to ~0 — that is IDF, and it is
     the guard against a coarse tag collapsing the whole page.
   - **Consensus** — union-find over paths; `union(i,j)` iff `same-cluster-in-P_geom` **OR**
     (`provenance-linked(i,j)` **AND** `gap(i,j) < T_far`). The geometry-OR is identity; the provenance-OR
     RE-MERGES the fragments geometry split (the `+38` over-count fix — cleaner than a dilation knob because
     it needs no em-calibration); and once the images lane makes a bitmap a first-class point, its provenance
     links it to its label/caption group even with zero strokes (the `−8` under-count fix). `T_far` blocks the
     one real failure mode (a rare-but-page-spanning tag). Default combine-rule is **Inclusive (OR)**; a
     **Mutual (AND)** pass gives a high-precision variant — this is exactly SPCX's `SymmetrizationRule
     {Mutual=min, Inclusive=max, Mean}`. Final regions = union-find components, assembled (bbox/kind) as today.
     Knobs τ / T_far / rule, each scored against the standing oracle batch.

   **ThermoMapper prior art to incorporate — SPCX's graph layer already speaks our `IDistanceMetric`
   (verified: `CoreDistances.Compute<TMetric>` / `Prim.ComputeMutualReachabilityMst<TMetric>` are the same
   struct-generic pattern), so ports are mechanical:**
   - **Jaccard** (`maths/distance/Jaccard.cs`) — binary/multi-hot `1 − |A∩B|/|A∪B|`, empty=identical guard,
     ~8-line core. **ADOPT**: wrap as a `JaccardMetric` struct implementing our interface (the provenance-view
     metric). NB our engine ALREADY has `cosine`, so a cosine-on-multi-hot provenance view is a zero-port
     starting point before Jaccard lands.
   - **Consensus primitives** — `UnionFind` (final labeling), the `SymmetrizationRule` combine (Mutual /
     Inclusive / Mean = AND / OR / weighted), and `Boruvka.AddMinimalBridges(pairDistance, UnionFind)` for
     optional component bridging. **ADOPT the pattern** — small, and it is genuinely new capability for our
     hdbscan: multi-view consensus.
   - **IDF / TF-IDF** (`hashish/idf.cs`, `hashish/tfidf.cs`) — the principled form of the coarse-tag guard
     (down-weight page-wide provenance tags by rarity). **OPTIONAL** refinement; a size-cap τ suffices for v1.
   - **DECLINE at our scale** — `hashish/minhash.cs` + `simhash.cs` + LSH + `bloom`/`hyperloglog`/`countmin`
     are approximate-set + blocking machinery for MILLIONS of items; a page has ≤ ~900 paths so exact Jaccard
     is microseconds — no MinHash/LSH. `Mahalanobis` (needs a covariance) and the geodesic / `Wasserstein`
     metrics are irrelevant to figure layout. (And `graphs/primitives/CoMembership.cs` is an SPC replica-state
     record — spin `Temperature`/`Q`/`G[]` — NOT a generic co-association primitive; don't reach for it.)

   **Net Tier-2 spine:** images lane (raster-blindness) + **(geometry ⊕ provenance-Jaccard) consensus**
   (fragmentation, via union-find + Inclusive/Mutual combine), dilation demoted to the provenance-absent
   fallback, MinHash/LSH declined. Sequence: land each step and re-score the oracle batch (`compare.ps1`).

   **Cross-algorithm abstraction — codex as ThermoMapper's sandbox (2026-07-04, user-directed).** Build the
   consensus at an altitude ABOVE HDBSCAN, because the same abstraction is a pending (unfinished) unification
   in ThermoMapper (SPCX): **HDBSCAN's excess-of-mass selection and SPC's thermal stability are the SAME
   quantity** — cluster PERSISTENCE along a monotone filtration parameter (λ = 1/distance for HDBSCAN,
   temperature T for SPC). The common language is the **merge-tree + its COPHENETIC (ultrametric) distance**
   = the parameter level at which two points first share a cluster. SPCX is half-way there already (a shared
   `Dendrogram` + `ThermalDendrogram` + `HierarchyEom` + `LineagePersistence`); what is missing is the common
   SEMANTICS. So prototype the pig consensus over a thin **`IClusterLineage`** {monotone filtration axis,
   per-node persistence, `CopheneticLevel(i,j)`}: HDBSCAN satisfies it from the dendrogram it ALREADY emits
   (we walk it for de-frag), the provenance view trivially (same-binding-tag → level 0, else ∞, or IDF-graded),
   and SPC's `ThermalDendrogram` later with ZERO change to the consensus code. Consensus then = **combine the
   views' cophenetic ultrametrics** (the `SymmetrizationRule` min/max/mean IS the ultrametric combine) →
   single-linkage the combined matrix → cut — i.e. Fred-Jain evidence accumulation generalized from BINARY
   co-association to GRADED cophenetic levels (strictly richer, algorithm-agnostic). Sits on the
   persistence-as-primitive telos (a merge-tree is 0-dim persistence → the SPC⇄HDBSCAN⇄PH junction). **DISCIPLINE
   / SEQUENCE:** deploy the concrete pig fix FIRST — flat-partition union-find consensus is an acceptable
   milestone-1, oracle-scored — then EARN the lineage/cophenetic abstraction as milestone-2 against the same
   benchmark; only THEN graft the validated abstraction back to ThermoMapper (feedback stays codex →
   ThermoMapper, user-driven). Do NOT build the framework speculatively ahead of a working pig lane. See
   [[thermomapper-concept]], [[backbone-conditioned-persistence]].

   **ThermoMapper porting map — points of interest for spelunking (2026-07-04).** Source root
   `D:\aghado01\ThermoMapper\src` (structure verified to match the `project-snapshots/ThermoMapper` snapshot;
   its graph layer already speaks our `IDistanceMetric`, so ports are mechanical). READ-ONLY reference — copy
   code INTO codex `src/hdbscan/`, never edit ThermoMapper (concurrent agents run there —
   [[multi-agent-repo-concurrency]]); re-verify against live source at port time in case it drifted.
   - **Milestone-1 (provenance view + flat consensus) — PORT:**
     - `maths/distance/Jaccard.cs` — binary/multi-hot `1 − |A∩B|/|A∪B|` (empty=identical guard); wrap the
       ~8-line core as a struct `JaccardMetric : IDistanceMetric`. (`maths/distance/Cosine.cs` = reference;
       we already have `cosine` as a zero-port starting view.)
     - `graphs/primitives/UnionFind.cs` — consensus labeling.
     - `graphs/primitives/EdgeFieldSymmetrization.cs` + `SymmetrizationRule.cs` — the view-combine operator
       (Mutual=min / Inclusive=max / Mean = AND / OR / weighted consensus).
     - `graphs/primitives/mst/Boruvka.cs` (`AddMinimalBridges(pairDistance, UnionFind)`) — optional component
       bridging / reconnection.
     - Parity reference (we already have equivalents): `graphs/primitives/mst/{Prim,CoreDistances}.cs`,
       `graphs/distance/{MetricRegistry,MetricProperties}.cs`.
     - Consensus-labeling prior art (STUDY): `clustering/graphical/spc/partitions/strategies/UnionFindLabeler.cs`
       + `ThresholdCoMembership.cs` — turning graded co-association into a cut.
   - **Milestone-2 (`IClusterLineage` / cophenetic abstraction) — STUDY, then design the shared interface:**
     - `clustering/dendrogram/{Dendrogram,DendrogramNode,DendrogramBuilder}.cs` — the merge-tree data model →
       the `IClusterLineage` shape (birth / death / persistence per node).
     - `clustering/dendrogram/{SingleLinkage,Condensation}.cs` — single-linkage + condensed tree (the
       re-linkage step for a COMBINED cophenetic matrix).
     - `clustering/dendrogram/ThermalDendrogram.cs` — the SPC-side dendrogram (the OTHER implementation the
       interface must cover).
     - `clustering/dendrogram/{LandscapeWalk,PeripheryPolicies}.cs` — dendrogram walk + cut/selection policies
       (cophenetic-level extraction + cut).
     - `clustering/graphical/spc/partitions/hierarchical/{HierarchyEom,LineagePersistence}.cs` — THE CRUX:
       excess-of-mass on the hierarchy + lineage persistence = the HDBSCAN-EOM ≡ SPC-thermal-stability
       unification point.
     - `.../hierarchical/{PartitionHierarchy,PartitionHierarchyDendrogram}.cs` — how SPC's partition hierarchy
       already maps onto the shared `Dendrogram` (the half-built unification). (`MagnetizationPeakDetector`,
       `IPseudoTransitionDetector`, `DenseTStack`, `BlattPartitionStrategy` = SPC thermal-axis machinery,
       reference only.)
   - **Optional refinements — PORT if the batch motivates:**
     - `hashish/idf.cs` + `tfidf.cs` — IDF-weight provenance tags (the principled coarse-tag guard).
     - `hashish/jaccard.cs` — grab-bag Jaccard; check for a CONTAINMENT variant (asymmetric overlap for
       "small element ⊂ a figure's tag-set"). `hashish/measure.cs` = a similarity-abstraction interface pattern.
     - `clustering/evaluation/external/ContingencyTable.cs` (+ `AdjustedRandIndex`, `NormalizedMutualInformation`)
       — quantify how much `P_geom` and `P_prov` AGREE per paper (a diagnostic for whether consensus is even
       needed there; same evaluator family as our `src/hdbscan/Evaluators.cs`).
   - **DECLINE (do not port):** `hashish/{minhash,simhash,bloom,hyperloglog,countmin,ctph,tlsh,ncd,bm25,
     tfidf_search,levenshtein,histogram,seeded}.cs` (approximate-set / fuzzy-hash / text-search scale machinery
     — a page is ≤ ~900 paths); `maths/distance/{Mahalanobis,Canberra,EarthMover,Ncd}.cs` + `geodesic/*` +
     `euclidean/*` (metrics irrelevant to figure layout); `graphs/primitives/CoMembership.cs` (an SPC
     replica-state record `{Temperature, Q, G[], ReplicaIndex}` — NOT a co-association primitive).
5. **cmbright math-role disambiguation** — SF-family papers set math IN the SF fonts, so font-name
   role is ambiguous there (flagged, unsolved; registry: 2210.00916). Needs a geometry/adjacency cue.
6. **Satellite reattachment second pass** (v1 must-have #3 remainder) if a specimen shows the
   footnote-superscript fracture in the pig lane.
7. **Wire the refined benchmark harvest** (`issues/benchmark-harvest.md`): prompt + oracle-reference
   capture in the post-hoc review.

**Restart the live codex-membrane MCP server** to pick up any stage-script edits from this work.

---

## Why this wins before it's clever

The membrane's hardest engineering this month was *reverse-engineering signals opendataloader
destroyed or never emitted*. The PdfPig IR is **born with them**:

| Membrane pain (opendataloader era) | pdfdig IR property that dissolves it |
|---|---|
| Ghost layer (`font=null/12.0` placeholder) + promoter misfires | every glyph carries a REAL font + size — the ghost class cannot exist |
| Heading detection via text regexes / gated geometry | font-size tiering over real typography — the principled promoter the heading thread wanted |
| Math detection via content heuristics after the fact | `role: math` read off TeX font names (CMMI/CMSY/MSBM…) at extraction time |
| Subscript/superscript destroyed (`p1` for `p₁`) | `script: sub|super` from size + baseline delta — validated on real papers |
| Docling `level` scrambled, zoning regexes | body/backmatter anchored on font tiers + (dual-availability) the skeleton oracle |
| VLM formula enrichment, trusted verbatim | deterministic extraction; uncertainty FLAGGED, repaired by the membrane's agent loop |

The membrane's repair loop is the already-built "harnessed agent" tier: pdfdig flags residue instead
of guessing, and flagged chunks land in dispatch exactly like today's corruption classes.

## Identity and shape

- **`src/pdfdig.ps1`** — pure PowerShell, loads the PdfPig fork in-process (`Add-Type` on the
  vendored dlls; PS 7 *is* .NET — no build step, no server, keeps codex single-language).
- **Vendoring:** `tools/pdfdig/` holds the fork assemblies (`UglyToad.PdfPig` 1.7.0-custom-5 from the
  private feed), pinned + provenance-documented — same pattern as `tools/render-check`'s node_modules.
- **MCP surface:** `pdfdig_convert paper|pdf_path` on the membrane server. Emits, beside the PDF:
  - `{slug}.json` — the raw IR (same positional contract opendataloader filled; the membrane's
    `Resolve-Source`/`project-ir` pick it up unchanged in address, extended in schema)
  - *(debug only)* a 1-D preview render — a development read-out, never a deliverable or QA slot
    (see "De novo, not post-hoc": pdfdig does not ship a broken markdown sibling)
  - `{slug}/imageFileN.png` — extracted figures per the corpus images convention (staged; see below)
- **Provenance in-band:** the JSON header records engine version, parameters, and per-page stats —
  conversions are regenerable and deterministic, so re-conversion is version-diffable (SimHash
  fingerprint per output for the cheap tripwire).

## The standalone mission (and what the oracle is NOT)

**pdfdig must stand on its own.** Its mission is reliable conversion coverage over the wild universe
of PDFs — the ocean of cases with no arXiv LaTeX sidecar. The LaTeX oracle is a **development-time
calibration instrument and bug/blind-spot detector** — a crutch to get the engine off the ground —
plus, in the codex workflow, an *optional consensus companion*, strictly nice-to-have. It is never an
architectural dependency: the workflow must be fully functional, and the engine's confidence fully
computable, on a bare PDF.

**pdfdig replaces opendataloader; the oracle does not move; and one slot is RETIRED, not inherited.**
opendataloader's "own markdown" was never architecture — it was **evidence of inadequacy**: if the
converter did its job, that `.md` would BE the deliverable and no IR-based repair workflow would
exist. The membrane's entire post-hoc lane (ignore the converter's markdown, re-emit from the IR) is
compensation for a converter that couldn't finish its job. pdfdig does not ship a confession:

| View | opendataloader era | pdfdig era |
|---|---|---|
| **geometry IR** (the substrate) | opendataloader `{slug}.json` | **pdfdig `{slug}.json`** |
| **converter's markdown** | broken `.md`, ignored by the workflow | **RETIRED** — pdfdig's deliverable is the FINAL markdown, born from the de novo workflow below (a dev preview may exist as a debug read-out, never as an artifact slot) |
| **logical truth** (independent view) | LaTeX oracle (baby mathdig) | LaTeX oracle — *unchanged*, optional |

### De novo, not post-hoc (the workflow inversion)

The membrane's current shape — convert first, repair after — is an opendataloader-era artifact.
pdfdig **in-lines the gap-filling into the primary conversion**: deterministic preprocessing does the
maximal legwork and *computes its own boundary*; the flagged gaps (if any) are worked **upfront,
inside the conversion**, by language-model *reasoning* in the membrane's seeing-agent discipline,
against **pdfdig MCP scaffolding** (the membrane-inherited verbs — slice/propose/gate/apply/audit —
re-aimed at conversion gaps instead of post-hoc corruption). The output of the workflow is the final
markdown; there is no intermediate broken deliverable, and no repair phase after the fact. Given the
wild variety of PDF standards and document quality, some model-in-the-loop is expected — but in-line,
gated, provenance-tagged, and only on the residue the deterministic tier flags.

The membrane's legacy here is twofold: its **framework** (dispatch/propose/gates/leases/audit, run
layout, run-visibility) is inherited as the scaffolding, and its **audit corpus** — every repair it
ever performed post-hoc — is the empirical catalog of gap classes the de novo workflow must handle.
(This is the roadmap's standing clause fulfilled: the in-house extractor "IN-LINES repair instead of
post-hoc fixing; the membrane's audit log = the spec/corpus for it.") Membrane-compatible IR emission
remains as the **transitional** integration — pdfdig IR feeding today's membrane stages — while the
de novo workflow is built; the end state retires the post-hoc lane for pdfdig-converted material.

### The modality compartmentalization (why the oracle is structurally incapable of being a crutch)

*"I see," said the blind man, to his deaf son, as he picked up his hammer, and saw.* pdfdig is the
**blind father** — it operates the geometry modality (glyph, bbox, font, baseline) and holds the
hammer and saw; it cannot read a LaTeX token. mathdig — the symbolic sibling, of which today's LaTeX
oracle is the infant form (**baby mathdig**; it grows up into the `unique(mathjax ∪ katex)` AST) — is
the **deaf son**: it hears and speaks LaTeX, cannot see a glyph. Both perceive the *same authored
substrate* (equation (3) exists prior to either its PDF rendering or its LaTeX source) through
orthogonal, **non-interchangeable** senses.

The consequence is that **"distillation, not delegation" is structural, not disciplinary** — the
oracle *cannot* hand pdfdig an answer, because the answer is encoded in a modality pdfdig has no organ
to receive. Delegation isn't forbidden; it's impossible. What crosses the membrane between them is
only **alignment + verdict** ("we are both looking at equation (3)" · "we agree / we differ") — never
content, because content does not survive the modality boundary. That narrow channel IS the
conversion-metric aligner and the Tier-2 cross-derivation; the alignment is the shared referent, the
only thing both can point at without trading eyes for ears.

Two disciplines follow:

- **Distillation, not delegation (enforced by the above).** When oracle-graded evaluation exposes a
  systematic miss, the fix must be expressed in **PDF-intrinsic terms** — a font-role entry, a
  geometry rule, a threshold, a symbol mapping — added to the stores. The oracle teaches the engine to
  see with its own eyes; it structurally cannot see *for* it. A miss that can only be fixed by
  consulting the sidecar is a recorded limitation, not a workflow branch.
- **Beware calibration-set overfit.** The dual-availability corpus is ~all TeX-origin (pdfTeX
  producers, CM/AMS fonts) — the mission domain is not: Word/publisher pipelines (MathType, Cambria
  Math, OpenType math), InDesign, subset fonts with mangled names, scanned+OCR. The stores must carry
  an explicit **domain axis** (TeX-origin / office / publisher / scanned), unknown cues must degrade
  to *flags, never guesses* (unknown font ⇒ role unknown ⇒ flagged), and coverage growth outside
  TeX-land comes from corpus evidence the oracle cannot supply.
- **Oracle-free health metrics are the deployed confidence signal.** The engine's self-computed
  boundary IS the metric that survives leaving the calibration set: fraction of glyphs with
  known-font-role, fraction of lines confidently ordered, flags per page, store-miss counts. These
  ride in the IR header and the membrane surveys — no sidecar required.

### The development loop (oracle as teacher — offline, source-level, time-boxed)

Distinct from the *ingestion-time* consensus role: at **development time** the oracle is pdfdig's
teacher. Each pdfdig iteration is graded by the conversion metric against the oracle; the per-unit
JSONL diff *between iterations* is the lesson plan (which units regressed/improved, not just a moved
number). The teaching lands ONLY as **source/store changes between iterations** — the teacher teaches
between classes, never whispers during the exam; nothing the oracle says enters a deployed conversion.

- **The teacher's own soundness is a precondition, floored by an independent gate.** The oracle is
  authoritative for *what the math says* (it is the source) but fallible in *how it converted* (this
  session found three converter bugs). The floor under its authority is **KaTeX render-validity** —
  objective, referencing neither pdfdig nor intent.
- **Detection is symmetric even though authority is asymmetric.** A pdfdig↔oracle disagreement is a
  flag for investigation, not an automatic pdfdig-loss. When the oracle is the wrong one, that is
  *also* a finding — it improves baby mathdig. The same cross-derivation that teaches pdfdig to see
  teaches mathdig to speak: **co-maturation**, bidirectional teaching over a shared referent.
- **Graduation criterion.** The teacher leaves when it stops finding new bug *classes* (diminishing
  returns on the sidecar-having subset), and the deployed confidence signal is by then the oracle-free
  health metrics. pdfdig is trained on the sidecar minority precisely to perform on the sidecar-less
  ocean; graduation = both populations report conversion health in the same vocabulary.

### The workflow ladder (every rung's output distinguishable by provenance)

1. **Deterministic extraction** (pdfdig engine): geometry + store-driven mapping; solves the large
   certain majority and *computes its own boundary*.
2. **Gated model proposals** (membrane machinery): flagged residue → dispatch → agent `propose_*` →
   gates → `apply` with audit. Models are allowed — *behind* the gate, on the residue, never in front
   of the extraction.
3. **Human review** (`request_review`): the rare terminal escalation.
0. *(when present)* **LaTeX sidecar**: consensus companion + repair assist (`get_oracle`) — enrichment
   of the above, never a prerequisite for it.

The design goal: **pdfdig preprocessing does the maximum automated legwork, robustly**, so the model
tier sees a short, well-flagged work-list rather than a conversion job.

## Rules as data — the config stores

No cue lives in code. Every mapping the engine consults is a JSON/JSONL store, in the doccer
inventory idiom (provenance-tagged entries, positive/negative examples, loader validation) — so
expanding coverage is a data edit with a test, never a code patch. The stores:

| Store | Contents | Seeds |
|---|---|---|
| `font-roles.jsonl` | font-name → role claims: math markers (`CMMI`,`CMSY`,`CMEX`,`MSBM`,`EUFM`,`RSFS`,`STIX`…), prose families, bold/italic face cues (heading/emphasis signals) | Extractor.cs's hardcoded `MathMarkers` array, generalized |
| `symbol-map.jsonl` | font-aware glyph→target corrections, per font + char: `{font_family, char, unicode, katex}` — the `CMSY k → ‖ / \|` class; target register is canonical KaTeX for math runs | the CMSY/CMMI/CMEX common-glyph seed table |
| `classify-config.json` | the numeric knobs: script size-ratio + baseline deltas, space-gap fraction, baseline tolerance, satellite-reattachment params, column-gutter detection params, display-math region rules, heading-tier rules | Extractor.cs's constants (`0.85`, `1.0`, `2.5`, `0.18`), made explicit and documented |
| `producer-map.jsonl` | Producer-string patterns → origin tags (`pdfTeX`, `XeTeX`, `LuaTeX`, word-processor families) driving TeX-origin behavior | the current three-substring check |

**The growth loop:** when the oracle-graded metric or the repair loop finds a systematic miss, the fix
lands as a store entry with provenance ("motivated by 2508.11646v1 p4, CMEX bracket glyphs") and
examples — reviewable, diffable, testable in isolation. This is `no-magic-string-structural-heuristics`
enforced by architecture: stores map *principled cues* (fonts, geometry, Unicode registers), never
content regexes.

**Shared across tiers:** `Markpig.Pdf` (the C# AST tier) consumes the SAME stores. Config-as-data
shrinks the two-implementation divergence surface to the algorithms; the golden fixtures then guard
only what remains.

## The IR contract (membrane-compatible, strictly richer)

A flat node stream (or shallow page→line tree) carrying the membrane's canonical fields — `page`,
`font`, `font size`, `bounding box`, `content`, `type` — so `project-ir.ps1`'s alias map ingests it
with a schema extension rather than a rewrite, PLUS the born-signals:

```
node { page, line_id, baseline_y, col, type(prose|math|heading-candidate|formula-block|figure|marker),
       content, font, font size, bbox, role, script(normal|sub|super), tex_origin, flags[] }
```

`flags[]` is the no-silent-failure channel: `fractured_math_span`, `suspect_reading_order`,
`unmapped_symbol`, `possible_table_region` — each one a dispatchable work-unit downstream.

## v1 must-haves (what "replacement" actually requires)

Ported semantics from `Extractor.cs` (line grouping, run classification, gap-spaces) are the floor,
not the bar. The gaps between the first dig and a usable converter, in priority order:

1. **Reading order / column detection — THE gap.** Baseline clustering across a two-column page
   merges the columns into one "line." Deterministic fix: per-page x-density histogram → gutter
   detection → column bands → group lines per band → emit bands in reading order. Two-column IEEE is
   the corpus norm; without this there is no replacement.
2. **All-pages iteration + document assembly** (first dig was single-page).
3. **Line grouping with satellite reattachment** — the footnote-superscript fracture found in recon
   (script Δ-threshold 1.0 vs baseline tolerance 2.5 ⇒ raised markers become their own "lines");
   second pass re-attaches small-glyph satellite lines to their host baseline.
4. **Font-tier heading candidates** — per-document size tiering over named fonts (title = unique max;
   section/subsection tiers below; bold-family detection). Emitted as `heading-candidate`, confirmed
   by the membrane (and by the skeleton oracle when source exists).
5. **Display-math regions** — math-role-dominant lines set off from prose (centered/indented,
   surrounded by whitespace) emit as `formula-block` nodes; inline math stays run-level. Best-effort
   1-D assembly with `$…$` seams; **fractures flagged, never smoothed**.
6. **Symbol correction via `symbol-map.jsonl`** — the `‖u‖→kuk` class: font-aware substitution from
   the store (CMSY/CMMI/CMEX core glyphs seeded, corpus-grown), applied at run emission. The full
   solution is the C# AST tier's; the store removes the worst of it now — and both tiers read it.
7. **Ligature expansion + NFKC at emission** — the target register is canonical markdown; `ﬁ→fi` at
   the source beats corpus sweeps later. (SMP round-trip stays non-negotiable.)
8. **Figures:** v1.0 = figure-region markers (image bboxes from PdfPig, placement in flow);
   v1.1 = pixel extraction to `{slug}/imageFileN.png` where PdfPig exposes decodable image data
   (DCT passthrough first, Flate→PNG next). The LaTeX lane's source-rendered SVGs already cover
   dual-availability papers.

## Deferred (and to WHERE)

- **2-D math structure** (fractions, matrices, aligned, commutative diagrams) — pdfdig's OWN geometry
  frontier (the `Markpig.Pdf` AST tier, blind-father modality). **NOT deferred to mathdig** — the symbolic
  sibling has no organ to receive PDF geometry (see "modality compartmentalization" above); delegation across
  the boundary is impossible, not merely discouraged. The honest INTERIM for 2-D content the geometry can't
  yet structure is an **image-crop at oracle parity** — the LaTeX oracle ITSELF renders tikz/xy to SVG images
  (`tikz-render.ps1`), so a cropped region MATCHES the ground truth's representation of a diagram rather than
  falling short of it — plus an explicit flag. Never a promise that a downstream tier will transcribe it.
  See [[mathdig-is-downstream-not-a-pdf-solver]].
- **Render-back verification** — AST tier (its falsifiability gate).
- **Tables** — v1 emits `possible_table_region` flags (ruled-line vector paths + grid-ish bbox
  lattices); serialization comes later. opendataloader's tables arrived shattered anyway — flagged
  honesty beats broken structure.
- **Full symbol-correction coverage** — the AST tier's font-aware layer; the seed table just de-fangs
  the common cases.

## The inflection point — where pdfdig leaves the render pipeline

The a priori wisdom exists, and it lives in renderers. A PDF viewer's pipeline is: parse COS objects →
document structure → **interpret the content stream** (execute the operator program, maintaining
graphics state) → **resolve glyphs** (font program + encoding + ToUnicode → positioned glyphs) →
collect paths/images → **rasterize**. That pipeline is **information-MONOTONE up to the display
list** — every stage adds determinism (references resolved, fonts decoded, positions computed) — and
**strictly LOSSY after it** (rasterization collapses vectors and identities into pixels). The
inflection point is therefore not vague: **pivot at the display list — the last fully-determined,
information-complete representation the render pipeline ever holds.**

That is exactly what PdfPig is: *a renderer truncated at the display list* — it runs the deterministic
front half (stages 1–5) and hands over Letters/paths/images as objects instead of painting them. That
is why it is the right bedrock, and it names the two lanes' relationship exactly: **the VLM lanes read
post-inflection** (pixels) and try to climb back up the lossy cliff; **pdfdig reads at the
inflection** and never descends it. Everything downstream of the pivot is *decompilation* — structure
the producer compiled away (reading order, words, math layout) is reconstructed from the evaluated
program. And for TeX-origin PDFs the decompilation is unusually well-posed, because the forward
compiler's rules are *published*: TeX's math layout algorithm (TeXbook Appendix G — the boxes-and-glue
placement rules for scripts, fractions, limits) is the known forward model the 2-D assembler inverts.

### A priori wisdom mines (catalog before re-deriving)

| Mine | What it already solved | Where it lands here |
|---|---|---|
| Renderers (MuPDF, pdfium, pdf.js, PDFBox) | stages 1–5; the display list itself | already embodied in the PdfPig fork |
| Text extractors atop renderers (`pdftotext -layout`, PDFBox `PDFTextStripper`, pdfminer.six, pdfplumber) | decades of reading-order / word-gap / line-grouping / **column-detection** / dehyphenation heuristics on wild PDFs | seed values + algorithms for `classify-config.json` and the column detector — mine before inventing |
| pdf.js text-layer | glyph→run assembly battle-tested at browser scale on the wild universe | run-coalescing edge cases |
| **MaxTract / the Birmingham line (Baker–Sexton–Sorge)** | deterministic born-digital PDF → symbol layout tree → LaTeX/MathML from font+position — the closest prior art to pdfdig's whole thesis | the 2-D math assembler's literature base (verify details when mining; cite into the specimen registry) |
| INFTY / math-OCR line (Suzuki et al.) | 2-D math structure from *scanned* material | the (deferred) scanned regime, someday |
| TeX itself (TeXbook Appendix G) | the forward model of math layout | the inversion target for TeX-origin 2-D assembly |

The rule: for every jungle problem, **catalog the prior art before deriving from scratch** — the store
entries it seeds get provenance like any specimen-motivated entry ("seeded from pdftotext -layout
gutter heuristic"), keeping borrowed wisdom as inspectable as home-grown.

## The PDF jungle — inductive development discipline

**There is no upfront design that survives the variety.** Not all PDFs are LaTeX-born; standards
proliferate; some carry struct trees, some carry *corrupted* struct trees; some are born digital, some
are scans wearing OCR'd text like a costume. It is impossible to know in advance how every case will
be handled. The method is inductive: **push forward one specimen at a time, catalog each specimen's
properties and challenges, amortize the knowledge into the design — knowing the next specimen may
violate what seemed like givens.** Robustness emerges over an uncertain number of trials. The
architecture's job is to make each trial cheap and each lesson permanent:

- **The specimen registry is a first-class artifact** (`specimens.jsonl`, config-as-data idiom):
  per-PDF record of producer, font families encountered, struct-tree presence/quality, encoding
  pathologies, what worked, what broke, which store entries it motivated. The registry IS the
  curriculum — and the docling-failure-modes brief + membrane-testing bed prove this method already
  works in this repo; pdfdig inherits a practiced discipline, not a hope.
- **The ratchet: every specimen becomes a permanent regression fixture.** When specimen N+1 violates
  a given, the fix must leave specimens 1..N green — the registry doubles as the regression suite,
  runs are cheap to re-execute (runstamped, SimHash-tripwired, per-unit-diffable). *Monotone corpus
  green* is the invariant that turns induction into accumulation instead of oscillation.
- **Givens are conjectures.** Every assumption the engine currently holds (baselines cluster into
  lines, columns have gutters, math lives in math fonts) is a conjecture awaiting its falsifying
  specimen. Assumptions therefore live where violation is *cheap to detect and localize*: as store
  entries and Tier-1-style invariants whose failure flags loudly, never as silent premises buried in
  control flow.
- **Struct trees are witnesses, never the primary.** The ghost-layer saga is the standing lesson:
  trusting a tagged/logical layer wholesale is how opendataloader manufactured 2,066 phantom headings.
  Where a struct tree exists, it enters as *one more fallible claim source* — cross-derived against
  geometry, agreement-scored, useful exactly to the degree it agrees; a corrupted tree is then
  *detected* rather than obeyed.
- **Scanned/OCR is a separate regime, flagged as such.** OCR coordinates are synthetic, OCR "fonts"
  are fabrications, and character identity itself is suspect — the font-role and script cues that
  power born-digital extraction are unreliable there. v1 scopes born-digital; a scanned specimen is
  *classified and flagged out-of-domain*, never silently mangled. The domain taxonomy grows from
  registry evidence, not from an upfront enum.

## Anti-divergence: two implementations, one semantics

The PS lane ports `Extractor.cs`'s classification semantics; `Markpig.Pdf` keeps evolving them. Two
codebases, one contract — held together by **shared golden fixtures**: the same PDF pages produce the
same classified runs (JSON-comparable) from both. When `Markpig.Pdf` matures, the PS lane MAY swap its
interior for the C# dll without changing its contract — the port is a stopgap-with-a-named-successor,
which is the roadmap's standing pattern (opendataloader was a stopgap without one).

## Acceptance (the conversion-metric's first real campaign)

1. **Oracle-graded:** on dual-availability papers, pdfdig-PS output scored by the conversion metric
   against the LaTeX oracle (math token fidelity, structure P/R, coverage).
2. **A/B vs opendataloader:** same papers, same metric — the replacement claim as a number, per lane
   (expect: structure/coverage parity or better immediately; math fidelity better on script/role;
   tables honestly flagged vs badly shattered).
3. **Membrane end-to-end:** preprocess → repair → finalize on pdfdig IR; heading counts vs the `.md`
   preview and (where available) the skeleton; the docling-failure-modes catalog re-run as a
   regression suite — none of those failure classes may reproduce.
4. **Golden cross-derivation** vs `Markpig.Pdf` on shared fixture pages.

## Open decisions

- **Node stream shape:** flat JSONL (membrane-native, `project-ir` almost free) vs page→line nested
  JSON (closer to pdfdig's PageNodes). Leaning flat-with-`line_id` — the membrane flattens anyway,
  and `line_id`/`col`/`baseline_y` preserve what nesting would have said.
- **Where conversions land:** beside the PDF as the raw `{slug}.json` (opendataloader's positional
  contract, regenerate-in-place with in-band versioning) vs runstamped conversion runs. Start
  in-place; revisit if engine iteration wants A/B runs of the *converter* itself.
- **PdfPig fork distribution:** vendored dlls in `tools/pdfdig/` vs NuGet restore from the private
  feed at setup. Vendored favors the portable-env philosophy.
- **Perf posture:** PS per-letter loops are fine for batch ingestion (papers/minute, not
  pages/second); if a hot spot emerges, the interior-swap escape hatch exists by design.
