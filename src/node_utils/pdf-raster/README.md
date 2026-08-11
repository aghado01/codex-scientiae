# pdf-raster

Shared raster primitive: render a PDF page or clip-region to **PNG** via MuPDF (WASM).
The external MuPDF payload is declared with the reusable Node dependencies under `brewery/node` and
materialized under `packages/node`; the first-party wrapper and worker are colocated here.

## Why

MuPDF (WASM) rasterizes *whatever is drawn* on a PDF page or region, so one mechanism covers vector
**and** raster content, outputs PNG, and never emits a sub-PDF/SVG. The colocated `pdf-raster.ps1`
wrapper exposes this worker through `Invoke-PdfRaster`; callers own their output layout.

Callers use this as a PNG terminal for PDF pages and clip regions (including diagram PDFs from
tectonic). NOTE: this build has **no SVG or EPS document handler** — only PDF (+ raster images).
Drive it through `Invoke-PdfRaster`; layout and orchestration stay with the caller.

## Usage

```
# single region
node render.mjs --mupdf ../../packages/node/node_modules/mupdf --pdf in.pdf --out fig.png --page 2 --bbox 115,515,234,623 --dpi 150

# batch — one WASM load + one doc open for all a paper's figures (the fast path)
node render.mjs --mupdf ../../packages/node/node_modules/mupdf --pdf in.pdf --jobs jobs.json --dpi 150
```

Normal PowerShell callers should use `Invoke-PdfRaster`; the direct JavaScript form above exposes the
worker contract and therefore requires the dependency package directory explicitly.

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
