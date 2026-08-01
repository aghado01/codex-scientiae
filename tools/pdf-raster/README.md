# pdf-raster

Pig-lane raster tool: render a PDF page or clip-region to **PNG** via MuPDF (WASM).
The external MuPDF payload is now declared with the reusable Node dependencies under `brewery/node`
and materialized under `packages/node`; the first-party raster harness will move under `src`
independently of that payload.

## Why

The pig figure lane detects figure *regions* (`{slug}.figures.jsonl`), but the vendored PdfPig can only
extract *embedded bitmaps* — it cannot rasterize vector (TikZ) figures, which most of the corpus uses.
MuPDF (WASM) rasterizes *whatever is drawn* in a region, so one mechanism covers vector **and** raster
figures, is source-agnostic (works on the bare PDF, the mission), outputs PNG, and never emits a
sub-PDF/SVG. `src/pdf-converter/pdfdig-images.ps1` drives it into the `.runs/{stamp}/pig/` convention.

The **LaTeX oracle lane** shares this engine (PNG is the terminal image register for both lanes): it
converts `\includegraphics` PDF assets to PNG and rasterizes per-diagram compiled PDFs (tectonic →
PDF → here). NOTE: this build has **no SVG or EPS document handler** — only PDF (+ raster images).
`src/latex-ingest/latex-ingest.ps1` (via `Invoke-PdfRaster`) drives it for the oracle.

## Usage

```
# single region
node render.mjs --pdf in.pdf --out fig.png --page 2 --bbox 115,515,234,623 --dpi 150

# batch — one WASM load + one doc open for all a paper's figures (the fast path)
node render.mjs --pdf in.pdf --jobs jobs.json --dpi 150
```

- `--page` is **0-based** (PdfPig pages are 1-based — subtract 1).
- `--bbox` is PDF points, y-up, PdfPig `[left, bottom, right, top]`; omit to render the whole page.
- `--jobs` file: `[{ "pdf": "<path>"?, "page": N, "bbox": [x0,y0,x1,y1] | null, "out": "<path>" }, …]`.
  Each job may carry its own `pdf` (opened once, cached by path) so one run converts a whole paper's
  separate figure PDFs / per-diagram compiled PDFs; omit it to use the top-level `--pdf`. `--pdf` is
  optional when every job specifies its own.
- stdout: one JSON results array — `[{out, ok, bytes, w, h} | {out, ok:false, error}]`.
- Exit 0 (results printed even if some jobs failed), 2 usage.

## Dependency

`mupdf` — the WASM MuPDF build (Artifex). Pure WASM, no per-platform native binaries. Restore it with
`brewery/node/restore-node.ps1`; it is not owned or versioned by this first-party harness.
