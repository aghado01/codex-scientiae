# Foundation for the figure-clustering Tier-2 lane — oracle-batch harness + XObject (Lane 5) IR

**Status:** ✅ **LANDED 2026-07-05** — commits `30cd08c` (Deliverable 1, harness + oracle sidecar) and
`ad4aa09` (Deliverable 2, Lane 5). Both acceptance criteria met (harness reproduces the recon verdict;
raster-blindness tail shrank with no fragmentation-tail regression). **The main Tier-2 session picks up from
`issues/clustering/tier2-handoff.md`** — live scoreboard + ordered next experiments. Originally SCOPED
2026-07-04. Prerequisite work carved out of the pdfdig Tier-2 plan
(`issues/pdfdig-lane/pdfdig-ps-converter.md` §4c). Two pieces of infrastructure must exist before the
Tier-2 clustering *experiments* (stream-order axis, em-dilation, geometry⊕provenance consensus) can be
honestly iterated. Both are **additive, low-design-risk, and needed regardless** of how the clustering
strategy resolves. Discovered missing / mis-scoped during the recon session
(`issues/clustering/opus-clustering-next-steps.md`).

**Why now (the reordering).** The Tier-2 discipline is *"land a step, re-score the oracle batch, watch the
`+38 / −8` tails collapse."* But recon found (a) the "standing oracle benchmark / `compare.ps1`" **does not
exist as committed tooling** — the numbers were an ad-hoc one-off, the `.runs/*/compare/pig` dirs are empty —
so iteration is currently **unfalsifiable**; and (b) the IR emits 4 lanes (letters/words/blocks/paths) and
figure detection reads `paths.jsonl` only, so `\includegraphics` **bitmaps are invisible** — the `−8`
under-count tail. Build the measurement substrate and cure raster-blindness first; then the clustering
experiments have a gate to answer to.

---

## Deliverable 1 — oracle-batch harness (the standing benchmark)

A committed script (`src/pdf-converter/Compare-FigureCounts.ps1`) that, over a paper set (default: the
10-paper `compendia/ph-zigzag` group), emits a per-paper table + summary. This is the gate every Tier-2
step re-runs.

**Per-paper row:**
- `pig_figures` — count of `kind=='figure'` records in the **newest** `{slug}/.runs/{stamp}/pig/{slug}.figures.jsonl`.
- `pig_images` — sum of the per-page `images` field across the page-stats array in
  `{slug}/.runs/{stamp}/pig/{slug}.pdfdig.json` (the `GetImages()` count; read the key back rather than
  assuming its nesting). Used for mechanism attribution.
- `oracle_figures` — the LaTeX oracle's figure (+ TikZ diagram) count (see source note below).
- `delta = pig_figures − oracle_figures`.
- `mechanism` — attribution: `over → 'fragmentation'`; `under ∧ pig_images>0 → 'raster-blindness'`;
  else `'other/oracle-noise'`.
- `oracle_confidence` — a flag (e.g. `figures_missing` if the tex run exposes it) so low-confidence rows
  are **annotated, not chased** (the "teacher's own soundness is a precondition" discipline applied to the
  benchmark itself — don't overfit to oracle miscounts like 2307's).

**Summary:** mean `|Δ|`, ratio range, counts `{over, under, exact}`.

**Oracle count source.** `latex-ingest.ps1` **already computes** the figure count (`$fc` on `\begin{figure}`,
~line 331) + tables + TikZ diagrams (`tikz-render.ps1` → SVG). That count is **not currently persisted** to an
on-disk artifact (`00README.json` in the tex run carries only the source manifest + compiler). So part of this
deliverable: **persist it** — have the latex lane emit a small `{slug}.oracle-counts.json` sidecar (or add
`figures`/`tables`/`diagrams` to the tex-run readme). **Reuse `latex-ingest`'s existing counter model** — do
not re-derive. Fallback if persisting is too invasive: count `\begin{figure|table}` + standalone TikZ in the
staged source `.tex`; last resort, count image embeds + rendered-TikZ refs in `{slug}-latex.md`.

**Acceptance.** `Compare-FigureCounts -Group compendia/ph-zigzag` reproduces the recon verdict qualitatively
(bidirectional: ~6 over, ~4 under, 0 exact; mean `|Δ|` ≈ 10). One command, committed, re-runnable, reads the
**newest** pig run per paper (mirror the membrane's newest-wins `Resolve-PaperSource`). UTF-8 no BOM. No
dependency on the stale ad-hoc `.runs/compare` dirs.

---

## Deliverable 2 — XObject image lane (Lane 5) — cures raster-blindness

**(a) IR emitter** (`src/pdf-converter/pdfdig-ir.ps1`) — emit a NEW lane with one record per XObject image:
`{ id, page, bbox:[x0,y0,x1,y1], kind:'image' }` from `page.GetImages()` → `IPdfImage.Bounds` (the placed,
post-transform rectangle — exactly the clustering input; the raw matrix is unnecessary). The envelope already
enumerates `GetImages()` for the count; this adds their geometry.
- **NAMING** — call it **`{slug}.xobjects.jsonl`**, NOT `{slug}.images.jsonl`. The run dir already contains a
  bare `images.jsonl` (the MuPDF **render manifest** from `pdfdig-images.ps1`) and an `images/` PNG dir; keep
  them unambiguous.
- **Do NOT** inject image boxes into `paths.jsonl` — that lane's contract is vector paths; keep it pure
  (explicit instruction from the Tier-2 brief).

**(b) Detection input** (`src/pdf-converter/pdfdig-figures.ps1`, `ConvertTo-FigureRegions`) — union the XObject
bboxes into the per-page point cloud alongside path bboxes, so a figure that IS one big bitmap becomes a
first-class clustered point instead of being deduced from its surrounding axes/labels. Tag each region's member
provenance (`path` vs `xobject`) so downstream can tell.

**(c) Orchestrator** (`Invoke-Pdfdig.ps1`) — stage the new lane like the others (sig/jidx bulk-write); keep
determinism.

**Acceptance.** Re-run Deliverable 1's harness after (a)+(b): the `−8` **raster-blindness tail must shrink**
(2205.11338v3 in particular, 31 bitmaps). Byte-identical re-runs (the existing encoding-invariants suite stays
green). **No regression on the fragmentation `+` tail** — this deliverable only ADDS points; it must not
merge/split existing vector regions.

**Sequencing within the chip:** build **Deliverable 1 first**, capture the baseline table, THEN build
Deliverable 2 and re-run — the harness IS the proof the images lane worked. Commit separately (harness, then
lane) so each is independently revertable.

---

## Explicit NON-goals (these stay in the main Tier-2 session, gated on this harness)

- **Stream-order axis** — `id` (content-stream order) is *already* emitted on every path record; packing it as
  a degenerate third interval `[x0,y0,s,x1,y1,s]` needs zero engine change (`RectangleGapMetric` is k-generic).
  It's a tunable clustering-input experiment → belongs in the main session, measured against this harness.
- **em-anisotropic dilation** — same: a clustering-input preprocessing knob, not foundation.
- **geometry⊕provenance consensus** (union-find + `SymmetrizationRule` + Jaccard). NOTE it needs *further* IR
  work not scoped here: clip-group-id, color-bucket, and marked-content are **NOT currently emitted** —
  `is_clipping` is only a **boolean** flag, so it **cannot** seed co-membership equivalence classes (the Tier-2
  brief's "`is_clipping` … already-in-IR provenance axis" claim is **wrong**). That deeper provenance enrichment
  is deferred until the batch shows stream-order + dilation are insufficient for the fragmentation tail.
- **`IClusterLineage` / cophenetic abstraction, ThermoMapper port** — milestone-2, untouched. `UnionFind.cs`
  already exists in `src/hdbscan/` (de-risks the eventual flat consensus).

## Guardrails

- **Read-only** w.r.t. `D:\aghado01\ThermoMapper` (concurrent agents run there — [[multi-agent-repo-concurrency]]).
- **Restart the live codex-membrane MCP server** after stage-script edits (`pdfdig-ir.ps1` / `Invoke-Pdfdig.ps1`).
- **Tests:** extend Pester in `tests/` for the new lane + harness; keep the encoding-invariants suite green.
- Use the portable **pwsh** env (PORTABLE_ROOT-bootstrapped); this is a `#requires -Version 7.0` PowerShell lane.
