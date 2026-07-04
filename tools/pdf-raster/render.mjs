// pig-lane raster tool — render PDF page(s) or clip-region(s) to PNG via MuPDF (WASM).
//
//   single:  node render.mjs --pdf <in.pdf> --out <out.png> [--page N] [--bbox x0,y0,x1,y1] [--dpi D]
//   batch:   node render.mjs --pdf <in.pdf> --jobs <jobs.json> [--dpi D]
//
// A batch --jobs file is a JSON array of { "page": N, "bbox": [x0,y0,x1,y1]|null, "out": "<path>" };
// batch opens the WASM + document once and renders every job (the fast path for a paper's figures).
// --page is 0-based. --bbox is PDF points (y-up, PdfPig [left,bottom,right,top]); omit to render the
// whole page. Rasterizes whatever is drawn in the region — vector TikZ AND embedded bitmaps alike.
// Prints one JSON results array to stdout: [{out, ok, bytes, w, h} | {out, ok:false, error}].
// Exit 0 (results printed, even if some jobs failed), 2 usage.
import * as mupdf from "mupdf"
import fs from "node:fs"

function argOf(name, def) {
    const i = process.argv.indexOf("--" + name)
    return (i >= 0 && i + 1 < process.argv.length) ? process.argv[i + 1] : def
}

const pdfPath  = argOf("pdf")
const dpi      = parseFloat(argOf("dpi", "150"))
const jobsPath = argOf("jobs", null)
const scale    = dpi / 72

if (!pdfPath) {
    process.stderr.write("usage: --pdf <p> (--jobs <json> | --out <png> [--page N] [--bbox x0,y0,x1,y1]) [--dpi D]\n")
    process.exit(2)
}

let jobs
if (jobsPath) {
    jobs = JSON.parse(fs.readFileSync(jobsPath, "utf8"))
} else {
    const out = argOf("out")
    if (!out) { process.stderr.write("need --out (single) or --jobs (batch)\n"); process.exit(2) }
    const bbox = argOf("bbox", null)
    jobs = [{ page: parseInt(argOf("page", "0"), 10), bbox: bbox ? bbox.split(",").map(Number) : null, out }]
}

const doc = mupdf.Document.openDocument(fs.readFileSync(pdfPath), "application/pdf")
const ctm = mupdf.Matrix.scale(scale, scale)

function renderOne(job) {
    const page = doc.loadPage(job.page)
    let pix
    if (job.bbox) {
        const [rx0, ry0, rx1, ry1] = job.bbox
        const b = page.getBounds()                 // mupdf page space
        // Device space is y-down (top-left origin); PDF bbox is y-up. Map + scale to a clip rect.
        const clip = [(rx0 - b[0]) * scale, (b[3] - ry1) * scale, (rx1 - b[0]) * scale, (b[3] - ry0) * scale]
        pix = new mupdf.Pixmap(mupdf.ColorSpace.DeviceRGB, clip, false)
        pix.clear(255)
        const dev = new mupdf.DrawDevice(mupdf.Matrix.identity, pix)
        page.run(dev, ctm)                          // ctm applied to page content; the pixmap clip captures the region
        dev.close()
    } else {
        pix = page.toPixmap(ctm, mupdf.ColorSpace.DeviceRGB, false, false)
    }
    const png = pix.asPNG()
    fs.writeFileSync(job.out, Buffer.from(png))
    return { out: job.out, ok: true, bytes: png.length, w: pix.getWidth?.() ?? null, h: pix.getHeight?.() ?? null }
}

const results = []
for (const job of jobs) {
    try { results.push(renderOne(job)) }
    catch (e) { results.push({ out: job.out, ok: false, error: String(e?.message ?? e) }) }
}
process.stdout.write(JSON.stringify(results) + "\n")
