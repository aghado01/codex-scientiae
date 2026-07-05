# LaTeX-oracle image rendering — the xy-pic gap + the PNG-terminal convention

**Status:** LANDED (2026-07-05) with a **doctrine correction** — see below. Surfaced by the two-population
figure-gate work (`issues/clustering/tier2-handoff.md`). Owner lane: `src/latex-ingest.ps1` +
`src/tex-render.ps1` + `src/pdf-raster.ps1` (the LaTeX oracle / `latex_convert`).

## DOCTRINE CORRECTION (user, 2026-07-05) — ENCODE FIRST, image LAST

PNG-terminal applies to things that ARE images. But the diagram class (`xymatrix`, `tikzcd`, many
`tikzpicture`) is **encodable mathematics**, and the corpus is consumed by reasoning models — so the
deliverable register for a diagram is **semantic, KaTeX-renderable LaTeX in the markdown**, not pixels:

- 1-D sequences → inline arrows: `\mathbb{I}(1,3) = 0 \longrightarrow K \longleftarrow K \longrightarrow K \longrightarrow 0`
  (labelled morphisms keep their labels: `\xrightarrow[under]{over}`).
- 2-D routing (squares, triangles, pullbacks) → the core `\begin{array}{...}` primitive with
  `\xrightarrow`/`\downarrow`/`\nearrow` cells. **NOT `\begin{CD}`** — it renders in KaTeX but is
  semantically useless to a model reading the document.
- An image is pushed ONLY for what cannot be encoded faithfully (empirical plots, drawn pictures) — and
  even then it is a flagged STOPGAP carrying a work-list entry, not a settled deliverable.

The ladder (implemented):
1. **Encode (deterministic):** `Convert-XyDiagramSpan` (xy-pic) + `Convert-TikzcdDiagram` (tikzcd) share
   one grid model (rows of {node; arrows}) and one emitter (`Format-DiagramGrid`):
   - **1-D** (single row, r/l arrows) → inline arrows (`\longrightarrow`, `\xrightarrow[under]{over}`).
   - **2-D** (orthogonal r/l/u/d single-step grid) → core `\begin{array}` — verticals as
     `\uparrow`/`\downarrow` with over-label as SUPERSCRIPT beside the arrow, under-label as subscript
     (user convention 2026-07-05).
   tikzcd style options accepted ONLY where an exact KaTeX form exists (hook→`\(x)hookrightarrow`,
   two heads→`\(x)twoheadrightarrow`, maps to→`\(x)mapsto`, dashed→`\dashrightarrow` unlabeled; labels
   via quoted syntax, `'`/`swap`→under; horizontal only — no vertical hook/twohead glyphs in KaTeX).
   Bails (`$null`) on ANY construct beyond that (diagonals, curves/loops/bends, Rightarrow, rotation
   options, styled verticals) — never a guessed encoding.
   (2210.00916: **10 of 37 encode** — 3 linear chains + 7 commutative squares as arrays — and
   **render_check is 977/977 green** on the full deliverable, incl. the `\Bar`→`\bar` alias fix.)
2. **Encode (reasoning agent, NEXT):** everything the deterministic rung bails on lands in
   `.runs/{stamp}/tex/{slug}.diagrams.jsonl` — `{n, kind, status, image, source}` per diagram — the
   work-list an MCP-harness translation pass consumes (prompt architecture per
   `issues/latex-math-oracle/gemini-katex-translation.md`: array primitive, no wrappers, escape hatch).
   The tectonic PNG doubles as the **visual verification oracle** for judging an agent's translation.
3. **Raster fallback (landed):** tectonic (vendored `tools/tex-render/tectonic.exe`) compiles the
   snippet with the author's colors/tikz-styles replayed → PDF → MuPDF (`tools/pdf-raster`) → PNG.
   Handles ALL packages incl. xy-pic; also EPS assets (`Invoke-TexGraphicRender`) and
   `\includegraphics` PDF→PNG (`Copy-LatexFigures` batching through `Invoke-PdfRaster`).
4. **Flagged marker:** a diagram that fails everything keeps `*[diagram N — kind, not rendered]*` —
   never a silent drop, never KaTeX-invalid leakage.

The same encode-first target governs the **pdfdig lane**: geometry/HDBSCAN consensus → spatial topology
JSON (nodes + morphisms) → reasoning agent reconstructs `\begin{array}` — same register, no LaTeX crutch.

## Gap — xy-pic diagrams are counted but never rendered

`tikz-render.ps1` (node-tikzjax) handles `tikzpicture|tikzcd` only. xy-pic (`\xymatrix`, `\begin{xy}`)
is invisible to it: **2210.00916 has 11 xymatrix commutative diagrams missing from its `-latex.md`
deliverable** — the ground truth silently drops them. The two-population oracle **count** already includes
xy (`Get-LatexOracleCounts` → `inline_diagrams`), so counting is fixed; **rendering** is the remaining gap.
tikzjax cannot do xy-pic (it is a TikZ-targeted WASM TeX), so a real (La)TeX compile path is required.
ph-zigzag is category-theory-adjacent — xy-pic density is high in exactly this corpus.

## Requirement (user, 2026-07-05) — PNG is the TERMINAL image format

**Every image the LaTeX lane extracts or renders ultimately lands as PNG.** SVG is acceptable only as an
intermediate; the deliverable/corpus register is PNG. Applies to all three image populations:

1. **tikz / tikz-cd renders** — today's SVG deliverable becomes an SVG *intermediate* + a PNG rasterize step.
2. **xy-pic renders** (new capability, this brief).
3. **`\includegraphics` assets** copied from the source tarball — arXiv sources are frequently PDF/EPS;
   those need PDF/EPS→PNG conversion at extraction/promotion. (PNG/JPG pass through; decide JPG
   passthrough-vs-convert when inventorying.)

Why PNG-terminal: parity with the pig lane (MuPDF-WASM → PNG — the "image-crop at oracle parity" claim
becomes literal when both lanes emit the same register), one corpus images convention
([[corpus-convention-parity]]: `images/{slug}/`, lowercase), one raster QA path, and universal
markdown-viewer compatibility.

## Implementation sketch (options, not commitments)

- **Preferred unification:** extract the diagram env → compile a standalone snippet (`standalone` class or
  `preview` package, WITH the paper's own preamble/macros replayed — author macros inside diagrams are the
  fidelity trap) → PDF → render PNG via the **already-vendored MuPDF-WASM** (`tools/pdf-raster/render.mjs`,
  same engine the pig lane uses). One raster engine everywhere; works identically for tikz AND xy.
- **THE dependency decision: the LaTeX compiler.** Options: portable TeX Live (check the portable env
  first — [[claude-code-store-install-broke-bootstrap]] caveat: don't assume the env is intact); or
  **tectonic** (single self-contained binary, auto-fetches packages — attractive for the vendored-tools
  philosophy). tikzjax stays as the zero-dependency fallback for plain tikz.
- **SVG intermediates** (existing tikzjax output): rasterize via resvg (single binary) or sharp; verify
  whether the vendored MuPDF build accepts SVG input before adding a new tool.
- **Failure posture:** a diagram that fails to compile gets a **stable marker + flag** in the md (never
  silently dropped — the current xy behavior is exactly the silent drop this fixes). Same no-silent-failure
  channel as the pig lane.
- Renders stage under `.runs/{stamp}/tex/` (runstamped, regenerable); promotion writes PNG per the corpus
  images convention. UTF-8-no-BOM manifests; deterministic re-runs.

## Acceptance

1. 2210.00916 `-latex.md` carries its 11 xymatrix diagrams as PNG links; `render_check` + `markdown_lint`
   green.
2. Corpus inventory: enumerate `\includegraphics` asset formats across ph-zigzag; every promoted image is
   PNG (converted where the source was PDF/EPS/SVG).
3. The two-population gate is unaffected (counting already includes xy) — but the SECONDARY population's
   *crop-quality* comparison becomes possible: pig's diagram crops vs the oracle's rendered diagrams, same
   format, same referent.
