# Codex baseline — technical reference for the pdfdig + texdig system

**Status:** extraction reference (2026-07-20), taken from codex-scientiae at `25585eb`. Purpose:
a reconstruction-grade record of the system being rebooted — process, architecture, control flow,
contracts — sufficient, together with the ported `stores/`, `src/pdfdig/`, `src/probes/` and
`gauntlet/`, to re-implement the converters in the reboot languages. Where a constant or guard is
not restated here, the authority is `stores/classify-config.json` (whose `_doc` strings are
themselves specification-grade, with calibration provenance) and the probe headers (iteration
records). Codex paths cited where only codex holds the source.

---

## §1 System overview

```
                        codex-scientiae converter system — 2026-07-20
════════════════════════════════════════════════════════════════════════════════════════════

 ACQUISITION            INTAKE A: LaTeX source (texdig)          INTAKE B: PDF (pdfdig)
 codex-arxiv /          {slug}.tar.gz  (beside paper dir)        {slug}.pdf
 codex-scholar MCP           │                                        │
 (search→fetch→inbox)        ▼                                        ▼
                     ┌───────────────────┐               ┌─────────────────────────────┐
                     │ latex-ingest.ps1  │               │ Invoke-Pdfdig.ps1           │
                     │ (one entry point) │               │ (one runstamp, 4 steps)     │
                     └────────┬──────────┘               └──────────────┬──────────────┘
                              │                                         │
  STORES (rules-as-data)      ▼                                         ▼
  ┌────────────────────┐  .runs/{stamp}/tex/                 .runs/{stamp}/pig/
  │ font-roles.jsonl   │  unpacked source                    1  pdfdig-ir       envelope + 5 lanes
  │ producer-map.jsonl │      │                              2  pdfdig-classify nodes + calibration
  │ symbol-map.jsonl   │  EXPAND macros                      3  pdfdig-figures  figures.jsonl
  │ classify-config    │  RESOLVE cite/ref/eqref             4  pdfdig-images   images/*.png
  │ specimens.jsonl    │  PROTECT math spans                 +  pig-run.json manifest
  └─────────┬──────────┘  TRANSFORM structure                           │
            │ feeds 1–3   RESTORE math                                  ▼
            └───────────►     │                              pdfdig-adapter.ps1
                              ▼                              (spend born signals)
                   {slug}-latex.md   (BESIDE source)                    │
                   {slug}.oracle-counts.json ──────────┐                ▼
                   {slug}-latex.patch.jsonl            │     membrane preprocess (lane=pdfdig)
                              │                        │     project-ir→headings→collapse→zones
                              │                        │     →sections→normalize→fidelity→repair
                              │                        │     ⇒ .runs/{stamp}/{slug}.chunks.jsonl
                              │                        │                │
                              │                        │     dispatch → get_slice → propose_edit
                              │                        │     → apply   (flags are the work-list;
                              │                        │      math-evidence briefs ride flagged
                              │                        │      formula chunks)
                              │                        │                │
                              │                        │                ▼
                              │                        │     finalize.ps1  (caption relocation at
                              │                        │      emission; pig-crop weave via
                              │                        │      md-register ← SHARED with texdig)
                              │                        │                │
                              ▼                        │                ▼
                   render_check + markdown_lint        │     {slug}-membrane.md → publish
                   (validity gates, both lanes)        │      → compendia/{topic}/{slug}.md
                                                       ▼                │
                                    ┌───────────────────────────────┐   │ figures.jsonl
                                    │ Compare-FigureCounts.ps1      │◄──┘ (newest pig run)
                                    │ PRIMARY  captioned vs floats  │
                                    │ SECONDARY uncaptioned vs      │
                                    │           inline diagrams     │
                                    │ + mechanism attribution       │
                                    └───────────────┬───────────────┘
                                                    ▼
                                    GAUNTLET battery (gauntlet/CHARTER.md)
                                    calibration  ph-zigzag(10) voroninski(23)
                                    transport    mapper(10) kisungyou(23)
                                    stress       spc(8, PDF-only, oracle-free)
                                    offline harness  probes/banded-ablation.ps1
                                    batch grinder    ingest-batch.ps1 (greedy pool)
════════════════════════════════════════════════════════════════════════════════════════════
```

## §2 Shared substrate contracts

- **Run layout:** all regenerable IR under `{paperDir}/.runs/{yyyyMMdd_HHmmss}/{tex|pig}/`
  (git-ignored, location-agnostic pattern). Newest-run-wins; pin as `{slug}@{stamp}`;
  same-second collisions bump a numeric suffix on the stamp. Only finished deliverables sit
  beside the source (`{slug}-latex.md`, oracle sidecars, patch files).
- **JSONL discipline** (`src/jsonl.ps1` → `Write-JsonlStage`): UTF-8-no-BOM, SMP-safe, emits
  `.jidx` (seek index) + `.sig` sidecars; every write self-registers in the paper inventory.
  U+FFFD is flagged, never replaced; ligatures pass through the substrate verbatim.
- **Addressing:** ingestion-root-relative, grouping-aware (`gauntlet/ph-zigzag/{slug}`);
  ambiguous bare slugs ERROR listing candidates.
- **Config identity:** `classify-config.json` is hashed (`config_hash`) into both the IR
  envelope and the classify envelope — conversions are version-diffable.

## §3 pdfdig (codex `src/pdf-converter/`, ported to `src/pdfdig/`)

### 3.1 Orchestrator — `Invoke-Pdfdig.ps1`

`Invoke-Pdfdig -PdfPath [-Pages] [-Dpi 150] [-SkipImages]`: mints ONE pig run dir, runs steps
1–4 against it, writes `pig-run.json` manifest (schema `pig-run/1`) recording per-step counts —
the manifest doubles as a per-mechanism census (every figure-lane pass has a counter).

### 3.2 Step 1 — IR emitter (`pdfdig-ir.ps1`, spec: codex `issues/pdfdig-lane/ir-schema.md`)

Opinion-free projection of PdfPig into an envelope + 5 flat JSONL lanes with integer cross-refs
(`letter→word/line/block` back-refs; hierarchy reconstructable, diff-friendly):

| artifact | content |
|---|---|
| `{slug}.pdfdig.json` | envelope: source (pdf, bytes, sha256), engine (version, pdfpig, config_hash), document (pages, version, producer/creator, **origin {tag, cue ∈ producer\|fonts\|none, producer_verdict}**), bookmarks (LANE 0: title/level/page), font census (name, family, sizes, letters, **role_hint** from font-roles store), per-page stats (w/h, letters/words/blocks/paths/images, segmenter, orientations, render_modes), **health** (letters_total, known_font_role_frac, unmapped_symbol_count, invisible_letter_frac, columns_confident_frac, flags_per_page, domain ∈ tex-origin\|office\|publisher\|scanned\|unknown), flags, sig |
| `{slug}.letters.jsonl` | one per Letter: id, page, seq (op-stream ordinal), text (ToUnicode verbatim), bx [L,B,R,T y-up], base/ebase (baseline pts), size, font (subset-stripped) + family (store), italic (IsItalic trusted), **bold_name** (name-derived — IsBold flag unreliable), wadv, render mode, orient, color, block/line/word back-refs |
| `{slug}.words.jsonl` | NearestNeighbourWordExtractor: id, page, text, bx, font, letters[], block/line, reading_order |
| `{slug}.blocks.jsonl` | RecursiveXYCut — **a CLAIM lane**: id, page, bx, segmenter + params_hash, reading_order, lines[] (id, bx, text, words[], modal_font, modal_size), **column_band** (left-edge clustering; null ⇒ downstream `suspect_reading_order`), text |
| `{slug}.paths.jsonl` | vector lane: id, page, is_clipping/is_filled/is_stroked, line_width, subpaths, kinds, bbox + bbox_source (api \| commands fallback), rule ∈ hrule\|vrule\|null (thin non-bezier, `rules.max_thickness_pt`/`min_length_pt`) |
| `{slug}.xobjects.jsonl` | LANE 5: placed bitmap rectangles (id, page, bbox) — the raster-blindness fix input |

Origin ladder: producer-map match → creator → font-domain evidence (any letters matching a
`tex-origin` store entry ⇒ `tex_origin:true, cue:"fonts"`); the deciding cue always ships.
Substrate withholds ALL opinions: no role/script/column verdicts, no symbol correction, no seams.

### 3.3 Step 2 — classifier (`pdfdig-classify.ps1` → `{slug}.nodes.jsonl` + `{slug}.classify.json`)

**Stage A — calibration (order statistics, zero clustering):**
- `body_size` = modal letter size among prose-role letters (fallback: all letters).
- Per-line stats over block lines: modal size, modal baseline, n, bold_frac, math_frac
  (font-role=math), rot_frac, **bold_tail** (glyphs after last bold — run-in detector input).
- **Tier ladder:** distinct line modal sizes ≥ body × `headings.min_size_ratio_over_body`
  (1.04) and > body, rotated lines excluded; sorted desc and **gap-merged into bands**
  (adjacent sizes ≤ `tier_merge_gap_pt` 0.25 share a band — office jitter); bold-at-body is
  the last tier; > `max_tiers_before_flag` (8) bands ⇒ doc flag `tier_ladder_noisy`.
- Modal leading = modal 0.5pt-binned consecutive baseline gap (0 < g < 4×body);
  indent register = modal line-vs-block left offset > 1.0pt.
- Outline prep: bookmarks → normalized keys (number-stripped) with stable `ref` indices
  (wrapped-heading fragments re-fuse by ref in the adapter).

**Stage B — typed emission.** Blocks sorted by (page, reading_order) composite key; per line, a
fixed decision ladder (first match wins):

1. `rot_frac > 0.5` → **marker** + `rotated_text`.
2. near-edge (baseline within `furniture.margin_frac` 0.06 of page top/bottom) ∧ size ≤ body+0.1
   → **marker** + `page_furniture`.
3. heading candidacy: tier-size match OR bold-body (`bold_frac ≥ 0.6` ∧ size ≥ body−0.1 ∧ not
   tier-size), **minus run-in** (`bold_tail ≥ run_in_min_tail` 3 ∧ bold_tail < n — bold prefix
   with regular tail = paragraph lead, blocks BOTH promotion paths), **minus math-heavy**
   (`math_frac ≥ 0.5` ∨ no `[A-Za-z]{2,}` word), ∧ n ≤ `max_line_letters` 200 →
   **heading-candidate** (tier = ladder index or bold-body tier). Outline witness runs BOTH
   directions: confirms candidates (`heading_confirmed_outline`) AND proposes headings
   typography can't see (body-size all-caps IEEE style → `heading_from_outline`, tier=null,
   level from outline). Bidirectional contains-match on normalized keys, page ±1; reverse-only
   match (line ⊂ title, ≥8 chars) = `outline_fragment` (re-fused or demoted in adapter).
4. `math_frac ≥ display_math.min_math_frac` (0.55) ∧ line/block width ≤ 0.92 →
   **formula-block**; consecutive formula lines with baseline gap < `stack_gap_factor` (1.8) ×
   size share a formula group + flag `needs_2d_assembly`.
5. else **prose**.

Emission (`Emit-PdfDigLine`): lines → run-level nodes with membrane-canonical fields (page /
content / font / 'font size' / 'bounding box') + type/role/script/tier/outline_level/flags[].
Runs segmented by font-role; script sub/super from `script.*` (size ratio ≤ 0.85, baseline
±1.0pt) with **nested** assembly via `math-assembler.ps1` (recursive size-tier descent,
`size_ratio` 0.78, `baseline_tol_frac` 0.12 — inverts TeX's 10/7/5 ladder so `t_{v_{i+1}}`
assembles instead of flat-invalid `t_{v}_{1}`; delimiter balance measured, non-zero ⇒ flag).
Symbol-map corrections (math scope, font-aware) + ligature expansion (prose) fire HERE only.
Orphan letters (no line back-ref) group by baseline proximity (`line_grouping.baseline_tolerance_pt`
2.5) → prose lines flagged `orphan_letters, suspect_reading_order`; >5% orphans ⇒ doc flag
`substrate_coverage_gap`. Doc flags also: `math_role_ambiguous_sf` (cmbright),
`outline_headings_unmatched`. `classify.json` carries calibration + node_types + health
(bookmarks matched, symbol corrections, ligature expansions, orphan lines).

### 3.4 Step 3 — figure regions (`pdfdig-figures.ps1` → `{slug}.figures.jsonl`)

Execution order (each pass a config block, absent = disabled; constants + calibration
provenance in `classify-config.json figure_regions._doc*` — spec-grade, do not paraphrase):

1. **Load** paths (ALL, rules included — figures ARE largely axis-aligned rules) + xobjects,
   provenance-tagged `path|xobject`; `bodyPt` from letters lane → em normalization
   (`area_em2 = area/body²`; fallback `min_region_area_pt2`).
2. **Preagg guard** (`preagg`): page > 50k points ⇒ grid-bin path bboxes by center into 0.5em
   cell-union boxes (xobjects stay singleton); cells cluster, labels propagate to original
   items; regions flagged `+preagg`. (O(n²) metric: 536k pts = 79 min, 576 cells = 0.3 s.)
3. **Per-page HDBSCAN** via `Invoke-Hdbscan` → `hdbscan.exe` (C# engine, black box):
   metric `rectangle-gap` = √(max(0,gx)²+max(0,gy)²) over box gaps; min_pts 3,
   min_cluster_size 3, allow_single_cluster; ≤min_pts paths ⇒ one region `too_few_to_cluster`;
   noise (−1) reported never forced. Dendrogram captured per page (for defrag + eject).
4. **Defrag elbow** (`defrag_enabled`): page > 8 regions ⇒ find largest log-gap in distinct-
   subcluster merge distances; gap ≥ 1.0 ⇒ re-run with `--cluster-selection-epsilon` at elbow.
5. **Consensus m1** (`consensus`, `Join-FigureViews`): OR-combine V_geom (partition) with
   V_stream (content-stream draw-runs: id-sorted paths split at consecutive rectangle-gap >
   `stream_jump_em` 6.0; within-block chain-union at `t_far_em` 4.0). **V_letters** rides this
   pass: small letter blocks (≤4em wide, ≤10 letters, ≥1 letter) attach as EVIDENCE (never
   cluster points) when within `t_bridge_em` 0.75 of ink; ≥2 components reached by one block ⇒
   bridge-union (heals label-split diagrams). Flags `consensus_merged`.
6. **Region records** (`New-FigureRegionRecord`): union bbox + **visible bbox** (painted
   members only: xobject ∨ stroked ∨ filled — clip-mask de-inflation), area, area_em2, density,
   member path_ids/xobject ids, letter_block_ids. **Kind gate:** degenerate (< 1.0pt extent) →
   mark (< 2.0 em²) → sparse (density < 0.01 paths/em²) → figure. Nothing dropped, all tagged.
7. **Caption attachment** (`Add-FigureCaptions`): candidates by geometry (below-first,
   above-fallback; horizontal overlap ≥ 0.25 of NARROWER width; gap ≤ 4.5 em); SELECTED by cue
   (`caption_cue_words` prefix in block head ~14 chars); cue TYPE recorded (figure vs
   table/algorithm — the gate's population split). A3 rescues (`caption_line_cue`: effective-
   head slide past sub-body mini-lines; `caption_row_stitch`: bare-cue block recruits same-row
   neighbors at word gaps, first recruit must start with a digit). Caption = {block_id(s),
   bbox, text, cue, position, gap}.
8. **Interior split** (`caption_split`, V_caption): cue-block strictly inside a region =
   negative co-membership evidence ⇒ split members at block midline (style-guard learned from
   this paper's own pass-1 captions; no-style bootstrap; bottom-band attach+trim variant).
9. **Subfigure grouping**: regions sharing one caption (page, block_id) merge — the float's
   single caption is the ground-truth grouping signal. Flag `subfigure_merged`.
10. **C′ stray eject** (`stray_eject`, POST-caption — label-level placement regressed PRIMARY):
    walk each selected cluster's dendrogram spine from members' LCA into larger child; thin far
    sides (≤ min_cluster_size−1) = rungs; clamp distances at `floor_em` 1.0 contact scale; eject
    rungs above the largest ln-gap ≥ 1.0. Captioned regions keep caption+kind (trim only).
11. **Furniture demotion** (`furniture_demotion`, T1): uncaptioned pure-stroke (no member with
    extent > 4pt) ∧ cycle rank b1=0 at 2em ∧ strip-shaped (aspect ≥ 6 ∨ height ≤ 1.5em) ⇒
    kind=furniture. Runs LAST-but-one; captioned never touched (PRIMARY invariant by
    construction).
12. **Inflow demotion** (`inflow_demotion`, T3-lite backbone veto): uncaptioned region covered
    ≥ 0.7 by wide (≥20em) Lane-3 blocks ⇒ kind=inflow (equation ink lives in-flow; floats live
    in whitespace).
13. Parked: `banded_metric` (full T3, backbone-conditioned distance — OFF by B-4 verdict).

### 3.5 Step 4 — images (`pdfdig-images.ps1`)

MuPDF-WASM (node, vendored) rasters each kind=figure region crop (visible bbox) at Dpi →
`images/imageFile{N}.png` + `images.jsonl` in the same pig run.

### 3.6 Stores (root `stores/`, shared contract with the C# tier)

Schemas + admission discipline in `stores/README.md` (ported). Growth loop: systematic misses
land as provenance-tagged entries motivated by specimens, never code patches or content regexes.
`specimens.jsonl` = per-PDF pathology registry, doubles as regression curriculum.

## §4 texdig (codex `src/latex-ingest.ps1`, ported flat — destination `src/texdig/`)

**Entry:** `Invoke-ArxivLatexToMarkdown -TarGz -Slug -OutDir` (membrane tool `latex_convert`;
grouping-aware; writes beside the source). In-house — NO pandoc/latexml.

**Phase order (the architecture):**
1. **EXPAND** — `\newcommand`/`\def` expansion to KaTeX primitives, brace-aware (ordinal
   dictionaries — case-insensitive tables collide `\Vect`/`\vect`); one `\input` level resolved.
2. **RESOLVE** — `\cite`/`\ref`/`\eqref` + theorem/equation/figure counters → literal numbers.
3. **PROTECT** — math spans lifted out, env-aware: alignment environments wrapped
   `\begin{aligned}` so `&`/`\\` remain valid under KaTeX.
4. **TRANSFORM** — title/authors/abstract; sections → `#`-ladder; theorem environments; lists;
   `tabular` → GitHub table (booktabs/multicolumn stripped, cells split on unescaped `&`);
   `\bordermatrix` → ruled array; hard-wraps reflowed to flowing prose; references recovered
   (biblatex + inline bibliographies) and emitted inline (FAITHFUL: acks kept, refs never
   sidecar'd — editorial filtering is promotion's job).
5. **RESTORE** — protected math re-inserted verbatim (`$…$`/`$$…$$` ARE the register).

**Diagram sub-pipeline** (encode-first doctrine — semantic KaTeX where possible, PNG last
resort): TikZ → SVG (tikzjax) → tectonic snippet → PDF → PNG (universal, incl. xy-pic) →
`\includegraphics` PDF assets → PNG (MuPDF-WASM); ALL emission through `md-register.ps1` (image
line, italic caption, flagged marker — the ONE register, shared with membrane finalize).

**Patch lane:** `{slug}-latex.patch.jsonl` — curated errata ops (`define_macro` /
`source_replace` / `output_replace`) re-applied on every regen, staleness-guarded (fails loud).

**Outputs:** `{slug}-latex.md` beside source; `.runs/{stamp}/tex/` staging (persisted for
math-bank/skeleton consumers); **`{slug}.oracle-counts.json`** (schema/2): figure floats +
rendered diagram count (PRIMARY population), inline-diagram count (SECONDARY), `figures_missing`
(referenced-but-absent includegraphics → oracle-confidence annotation).

## §5 Membrane handoff (codex `src/*.ps1` flat; migration map in CONVENTIONS §5)

- **Adapter** (`pdfdig-adapter.ps1`, `Invoke-ProjectPdfDigNodes`): run-level pig nodes →
  membrane line dialect, SPENDING born signals: heading-candidate → pre-typed `heading`
  (heading recovery SKIPPED on this lane), formula group → ONE `formula` node (finalize wraps
  `$$`), prose runs → `paragraph` with `$…$` seams + `_{}`/`^{}` from geometric script calls,
  marker → DROPPED and counted; outline fragments re-fused by ref; flags ride through; nothing
  silently lost (summary counts every input node).
- **Preprocess** (8 stages) → chunk stream + sidecars in a NEW run; repair loop = dispatch →
  get_slice → propose_edit → apply (work-order spine; inventory on demand). Flagged formula
  chunks carry **math-evidence** payloads (best-effort LaTeX + why suspect + glyph table +
  2-D spatial sketch — the modality bridge; model proposes, render_check gates).
- **Finalize:** chunks → `{slug}-membrane.md` per STANDARDS (H1, Contents, `##`+ ladder, `$$`
  fences, references sidecar); caption relocation at EMISSION only (persisted stream untouched;
  figure captions move to first in-text reference anchor); figure weave pulls newest pig-run
  crops through md-register. **Publish** promotes bare `{slug}.md` to `compendia/{topic}/`.
- **Gates:** `render_check` (KaTeX, strict mode = the bar), `markdown_lint` (codex-aligned
  markdownlint config). Validity only — valid-but-wrong is `review_document`'s jurisdiction
  (the one sanctioned holistic read).

## §6 Measurement (`Compare-FigureCounts.ps1` — ported to `src/pdfdig/`)

Per paper in a group: `pig_figures` = kind=figure records in NEWEST pig run, **split by caption
cue type** — figure-cued → PRIMARY; table/algorithm-cued excluded from BOTH populations;
uncaptioned → SECONDARY. `oracle_figures` from the fallback chain: sidecar → staged tex source
(float + tikz count, `Get-LatexOracleCounts` — the SAME code that writes sidecars; one counter
model) → md scan (image embeds + unrendered-tikz + not-found markers). **Mechanism attribution:**
over → `fragmentation`; under ∧ pig_images>0 → `raster-blindness`; Δ=0 → `exact`; else
`other/oracle-noise`. **Oracle confidence:** `figures_missing:N` rows annotated, never chased.
Summary: mean |Δ|, ratio range, {over, under, exact}. Design laws: zero-over invariant;
PRIMARY untouchable by any knob not gate-licensed; object-level acceptance for assertion work.
Operations: gauntlet CHARTER (roles, accession, membership contract) + the increment loop
(DESIGN.md §5). Offline knob harness: `probes/banded-ablation.ps1` (re-cluster + gate +
sentinels, knobs pinned both sides). State at extraction: ph-zigzag PRIMARY 0.4 (9/10 exact),
voroninski 0.35 (18/23), 0 over anywhere; kisungyou transport 1.0 untouched.

## §7 Reconstruction inventory & fidelity bounds

**Sufficient set (all already in this repo):** this document + `docs/DESIGN.md` +
`stores/*` (with `_doc` provenance) + `src/pdfdig/*` + `src/probes/*` (headers = iteration
records) + `gauntlet/` (CHARTER + battery + sidecars) + `tests/*`.

**Where this document compresses (source remains authority):** exact regex forms (caption cues,
outline normalization, furniture patterns); the full guard order inside `Add-FigureCaptions` /
`Split-CaptionInteriorRegions`; `Emit-PdfDigLine` run-segmentation edge cases; texdig's ~40
TRANSFORM sub-rules (tabular/theorem/list edge cases); membrane stage internals (zones/sections/
normalize heuristics — docling-era, mostly NOT carried into the reboot per DESIGN §7). Codex
history (`issues/clustering/tier3-engineering-plan.md`, dated frontiers) holds the full
decision record with per-thrust evidence.
