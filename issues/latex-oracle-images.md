# LaTeX-oracle image rendering — the xy-pic gap + the PNG-terminal convention

**Status:** DESIGN (2026-07-05), not started. Surfaced by the two-population figure-gate work
(`issues/clustering/tier2-handoff.md`). Owner lane: `src/latex-ingest.ps1` + `src/tikz-render.ps1`
(the LaTeX oracle / `latex_convert`). Independent of the clustering work — parallel track.

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
