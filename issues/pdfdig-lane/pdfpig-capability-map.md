# PdfPig capability map — the deep dive under pdfdig-PS

**Status:** RECON COMPLETE (2026-07-02). Empirical survey of PdfPig `0.1.14` (the vendored
`lib/pdfpig` dlls) against the master source clone at `D:\aghado01\packages\PdfPig`, probed on
specimen **2508.11646** (Xin Li, *Memory as Structured Trajectories* — arXiv/pikepdf, two-column
IEEE, Nimbus prose + Computer-Modern math, vector TDA figures). Companion to
`pdfdig-ps-converter.md`; this is the *what-PdfPig-actually-gives-us* substrate the IR design
(`ir-schema.md`) is built on.

**Headline:** the vendored `0.1.14` dlls carry the **full modern surface** — every member the
master source exposes (`TextSequence`, `GlyphRectangleLoose`, `FontDetails`, `RenderingMode`,
`Color`/`StrokeColor`/`FillColor`, marked content, bookmarks, XMP) is present, AND the
`DocumentLayoutAnalysis` package (word extractors, page segmenters, reading-order detectors,
ALTO/PAGE/hOCR exporters) is vendored and works in-process from PS 7.6. **Two of the brief's
"build from scratch" v1 gaps already exist in the box.**

---

## 0. Load & environment (validated)

```powershell
$lib = 'D:\aghado01\codex-scientiae\lib\pdfpig'
foreach ($n in 'UglyToad.PdfPig.Tokens','UglyToad.PdfPig.Core','UglyToad.PdfPig.Tokenization',
               'UglyToad.PdfPig.Fonts','UglyToad.PdfPig','UglyToad.PdfPig.DocumentLayoutAnalysis') {
    Add-Type -Path (Join-Path $lib "$n.dll")
}
$doc = [UglyToad.PdfPig.PdfDocument]::Open($pdfPath)
```

- **Load order matters** — dependencies first (`Tokens` → `Core` → `Tokenization` → `Fonts` →
  `PdfPig` → `DocumentLayoutAnalysis`). `Add-Type -Path` in that order loads clean, no build step.
- PS 7.6 / .NET: confirmed. No server, no NuGet restore at runtime — pure vendored `Add-Type`.
- **Nullable-struct interop trap:** PS **auto-unwraps** `Nullable<T>` returns (e.g.
  `GetBoundingRectangle(): PdfRectangle?`) — you receive `$null` when empty, the **bare struct**
  when present. NEVER test `.HasValue`/`.Value` on the result: the unwrapped `PdfRectangle` has no
  such members, the access silently yields `$null`, and the guard reads as *always false*. Test
  `$null -ne $result` and use the result directly. (This silent-false bit us TWICE — first in
  probe 2, then it manufactured the refuted §5 "bezier returns null" claim.)
- **`out`-param interop trap:** `TryGet*([ref]$x)` binds for `XmpMetadata`/`Bookmarks` (ref-type or
  simple out), but `IPdfImage.TryGetBytesAsMemory(out Memory<byte>)` will **not** bind from PS
  (`Memory<byte>` out param) — must call via a tiny C# shim or use `TryGetPng`/`RawMemory` instead.

---

## 1. The atomic layer — `Page.Letters` (`Letter`)

The spine. Every glyph the content stream drew, post-inflection (see brief §"inflection point").
Per-`Letter` signals, all validated present in `0.1.14`:

| Property | Type | What it carries | pdfdig use |
|---|---|---|---|
| `Value` | string | the Unicode text (ToUnicode-resolved; may be multi-char, e.g. a ligature) | content |
| `StartBaseLine` / `EndBaseLine` | `PdfPoint` | baseline endpoints (origin **bottom-left, y-up**) | line grouping, script Δ, orientation |
| `BoundingBox` | `PdfRectangle` | tight visible glyph box (descenders included) | tight geometry, gap-spaces |
| `GlyphRectangleLoose` | `PdfRectangle` | font-uniform box (uses Ascent/Descent) — same across glyphs of a font | line-height / baseline math without per-glyph jitter |
| `Width` | double | advance width allocated in the content | gap detection |
| `PointSize` | double | **font size in points** — absolute, comparable across page | heading tiers, script size ratio |
| `FontSize` | double | size in PDF units (relative, not points) | (avoid — use PointSize) |
| `FontName` | string? | subset-tagged name, e.g. `ASYHPE+NimbusRomNo9L-Regu` | **role + tier** (§4, §5) |
| `FontDetails` | `FontDetails` | `.Name .IsBold .Weight .IsItalic` | italic reliable; **bold NOT** (§4) |
| `RenderingMode` | enum | Fill/Stroke/FillStroke/Invisible/Clip… | **hidden-text / OCR-layer detection** (Invisible ⇒ flag) |
| `Color` / `StrokeColor` / `FillColor` | `IColor` | glyph paint | color-coded emphasis, link text, watermark cues |
| `TextOrientation` | enum | Horizontal / Rotate90/180/270 / Other | **rotated text** (arXiv sidebar, table headers) |
| `TextSequence` | int | the ShowText op ordinal that drew this glyph | tie-break for reading order within a line; op-stream locality |
| `GetFont()` | `IFont?` | full font program (descriptor, flags, glyph metrics) | deep cues (FontDescriptorFlags: Serif/Script/Italic/AllCap…) when name is opaque |

**Validated on the specimen:** `p₁…p₅`-class sub/superscript recoverable from PointSize+baseline Δ
(recon finding, holds); `TextSequence` 2..1410 on page 2 (dense, monotone-ish per column).

### 1.a Font/size tiering — the born-with-typography thesis, validated on NON-CM prose

Page-1 (title page) `(FontName, PointSize)` census, top tiers by size:

| tier | font · size | n | sample | reading |
|---|---|---|---|---|
| title | `NimbusRomNo9L-Regu · 23.9` | 69 | "Memory as Structured Trajec…" | unique max ⇒ title |
| stamp | `Times-Roman · 20.0` | 42 | "arXiv:2508.11646v1 [q-b…" | **arXiv watermark** — distinct font+rotated; identifiable to suppress |
| authors | `NimbusRomNo9L-Regu · 11.0` | 51 | "Xin Li, Department of Comput…" | author block |
| email | `NimbusMonL-Regu · 11.0` | 16 | "xli48@albany.edu" | **mono font ⇒ code/email register** |
| body | `NimbusRomNo9L-Regu · 10.0` | 2348 | body prose | dominant tier = body baseline |
| emphasis | `NimbusRomNo9L-ReguItal · 10.0` | 304 | italic terms | emphasis |
| heading | `NimbusRomNo9L-Medi · 10.0` | 40 | "Keywords: Cycles as Fund…" | **`-Medi` = bold face = heading/label** |
| math | `CMR10 / CMSY10 / CMMI10 · 10.0` | 8/5/7 | "∈ZZ", "δγHγδ" | **math set in Computer Modern even though prose is Nimbus** |
| abstract | `NimbusRomNo9L-Medi(Ital) · 9.0` | 1767 | "—We propose a topological fr…" | abstract in bold 9pt |

Two load-bearing lessons:
- **Bold is in the font NAME (`-Medi`/`-Bold`), not `FontDetails.IsBold`.** On this specimen
  `IsBold` was **0** across 5556 letters while 40+1767 letters were visually bold via `-Medi`.
  Heading/emphasis detection MUST tier on font-name family+face, not the `IsBold` flag. `IsItalic`
  *was* reliable (706 italic letters flagged). → `font-roles.jsonl` must encode face from the name.
- **Math lives in CM/AMS fonts regardless of the prose family.** A Nimbus-prose paper still sets
  `∈`, `δ`, `γ` in `CMSY10`/`CMMI10`. The font-name → math-role map (Extractor.cs's `MathMarkers`)
  generalizes cleanly and is the principled (not content-regex) math cue.

---

## 2. Layout scaffolding — `DocumentLayoutAnalysis` (the surprise: already in the box)

Vendored `UglyToad.PdfPig.DocumentLayoutAnalysis.dll` gives a whole geometry-analysis stack the
brief assumed pdfdig would build. All instantiated & run in-process from PS 7.6:

| Stage | Type(s) | Result on specimen p2 (two-column) |
|---|---|---|
| Word assembly | `NearestNeighbourWordExtractor`, `DefaultWordExtractor` | 926 words, gap-spaces + within-word merge handled |
| Page segmentation | `RecursiveXYCut`, `DocstrumBoundingBoxes`, `DefaultPageSegmenter` | **XYCut: 13 blocks, gutter cleanly cut** (all w≈251, left-col x=49 / right-col x=312). Docstrum: 9 blocks but **merged across the gutter** (full-width x=49–563) |
| Reading order | `UnsupervisedReadingOrderDetector`, `RenderingReadingOrderDetector`, `DefaultReadingOrderDetector` | linearized blocks sensibly; section head "II. FROM SPIKING…" landed as its own ordered block |
| Hierarchy | `TextBlock` → `TextLine` → `Word` → `Letter` | block[5]: 14 lines / 127 words; each level exposes `BoundingBox`, `.Text`, `.FontName`, down to letters |
| Export | `AltoXmlTextExporter`, `PageXmlTextExporter`, `HOcrTextExporter`, `SvgTextExporter` | standard layout formats for free (ALTO/PAGE/hOCR are OCR-interchange; PAGE even has a `MathsRegion` type) |
| Classifiers/utils | `DecorationTextBlockClassifier`, `DuplicateOverlappingTextProcessor`, `KdTree`, `NearestNeighbours`, `Clustering`, `Distances` | dedup of double-struck/shadow text; spatial indexing primitives |

**The decisive finding: `RecursiveXYCut` solves "THE gap" (column detection) for Manhattan-layout
academic PDFs out of the box.** The brief's v1 §1 ("baseline clustering merges the columns… without
this there is no replacement") is answered by choosing the right *existing* segmenter — XYCut cuts
the gutter where the naive baseline-cluster (and Docstrum) merge it.

**But it is a witness, not gospel** (brief's standing rule). Docstrum gutter-merged the *same* page;
segmenter choice is specimen-dependent, and XYCut has its own failure modes (it assumes recursive
rectangular whitespace — breaks on floats/spanning figures/rotated blocks). The IR captures the
segmentation as a *claim lane* (which segmenter, what params) to be cross-derived against the
letter-geometry, never as the primary truth.

Options tuning (all `IDlaOptions`-derived, so config-as-data ready): `DocstrumBoundingBoxes` exposes
`WithinLineMultiplier=3.0`, `BetweenLineMultiplier=1.3`, `AngleTolerance`, etc.; `RecursiveXYCut`
exposes `MinimumWidth`, `DominantFontWidth/Height` funcs. These are exactly the `classify-config.json`
knobs — seeded from a battle-tested library rather than invented.

---

## 3. Document-level structure & metadata

| Source | API | On specimen | pdfdig use |
|---|---|---|---|
| **Bookmarks / outline** | `doc.TryGetBookmarks(out Bookmarks, allowContainerNode)` → `.Roots` (`DocumentBookmarkNode.Title` + `.Destination` page) | **8 roots with real section titles** ("Introduction", "From Spiking Dynamics to Topology", …) | **independent heading/section oracle** — no geometry needed; cross-derive vs font-tier headings |
| Info dict | `doc.Information` (`.Producer .Creator .Title .Author .CreationDate`…) | Producer = `pikepdf 8.15.1` | origin tag — **but see rewriter lesson** |
| XMP | `doc.TryGetXmpMetadata(out XmpMetadata)` → `.GetXDocument()` / `.GetXmlBytes()` | XMP present, contains only `pikepdf` | secondary metadata; **original pdfTeX producer was stripped** |
| Struct tree / tagging | `page.GetMarkedContents()` → `MarkedContentElement` (`.Tag .ActualText .AlternateDescription .ExpandedForm .Language .IsArtifact`, nested `.Children`) | **0 elements** — untagged PDF | when present: fallible claim source (ActualText for ligatures/math, artifact = running head/footer to drop); here: absent |
| Optional content | `page.GetOptionalContents()` (OCG layers) | — | layer-aware extraction later |
| Version / encryption | `doc.Version`, `doc.IsEncrypted`, `doc.NumberOfPages` | 18 pages | provenance header |
| Forms | `doc.TryGetForm(out AcroForm)` | — | out of scope (forms) |

**Rewriter lesson, confirmed empirically:** arXiv post-processes through **pikepdf**, which
overwrites `Producer` *and* the XMP — the string carries `pikepdf 8.15.1`, **not** `pdfTeX`. The
origin verdict therefore CANNOT rest on the producer string alone. Fallback (per brief §producer-map)
= **font evidence**: this PDF is unmistakably TeX-origin (CMR/CMSY/CMMI fonts, NimbusRomNo9L =
the URW/TeX Times clone). The `tex_origin` verdict ships with a `cue` field (`producer` | `fonts` |
`none`) so downstream knows which sense produced it.

---

## 4. Reliability ledger (per-signal, for the "givens are conjectures" discipline)

| Signal | Reliability | Caveat / falsifying regime |
|---|---|---|
| `PointSize`, baseline geometry | **high** | synthetic on scanned/OCR PDFs (fabricated coords) |
| `FontName` (subset-stripped) | **high** for role/tier | mangled/duplicate subset names in some office pipelines; fully-embedded-no-name edge |
| Math-role from CM/AMS font markers | **high** on TeX-origin | Word/MathType (Cambria Math, STIX, OpenType-math) uses different names ⇒ `symbol-map`/`font-roles` domain axis |
| `FontDetails.IsItalic` | **medium-high** | present & correct here |
| `FontDetails.IsBold` | **LOW** | 0 on this specimen despite bold headings; bold is name-encoded (`-Medi`) — do not trust the flag |
| XYCut column cut | **high on Manhattan two-col** | breaks on spanning floats/figures, rotated blocks, non-rectangular whitespace |
| Docstrum blocks | medium | gutter-merged here; better on single-column / irregular spacing |
| Reading order (Unsupervised) | medium-high | heuristic; verify against column bands + `TextSequence` |
| Bookmarks outline | **high when present** | optional; absent on many PDFs; titles may differ from on-page heading text |
| Marked-content / struct tree | witness-only | absent here; when present may be *corrupted* (ghost-layer saga) — cross-derive, never obey |
| `RenderingMode == Invisible` | high signal | OCR text-over-image layer ⇒ classify scanned/hybrid, flag out-of-domain |
| Vector paths (rules + figures) | **high** — bbox for ALL path kinds | earlier "bezier returns null" claim REFUTED (§5): it was the PS nullable-unwrap trap, not the API |
| Raster images | untested | no raster images in inbox corpus (all vector); `TryGetBytesAsMemory` needs a shim from PS |

---

## 5. Vector paths & images — `Page.Paths` (`PdfPath`), `Page.GetImages()` (`IPdfImage`)

**Paths.** Populated where figures live (specimen: 0 on prose pages 1–2, 12 on p3, 30 on p4).
`PdfPath : List<PdfSubpath>` with `IsFilled/IsStroked/IsClipping`, `FillColor/StrokeColor`,
`LineWidth`, `LineDashPattern`. Each `PdfSubpath` is a command list: `Move`, `Line`,
`CubicBezierCurve`, `Rectangle`, `Close` (via `.Commands`).

- **`GetBoundingRectangle()` returns a real bbox for ALL path kinds** — line/rect rules AND
  bezier-only figure curves (verified: 42/42 paths on specimen p3+p4 yield `PdfRectangle`).
  An earlier probe concluded "bezier-only returns null in 0.1.14" — **REFUTED**: that blank was the
  PS nullable-unwrap trap (§0) masquerading as a null return, a false finding manufactured by the
  instrument. Corrected 2026-07-02; the emitter keeps a manual command-point bbox
  (`bbox_source:"commands"`) only as a genuine-null fallback and tags which source produced each box.
- **Rules** (fraction bars, table gridlines, hlines): thin-bbox test (`H≤2 ∧ W>20` = hrule) over
  non-bezier paths works — specimen yields 14 hrules + 7 vrules across 18 pages.
- → v1 IR: per-path `{is_clipping,is_filled,is_stroked,line_width,subpaths,kinds,bbox,bbox_source,rule}`.
  Rule-vs-shape refinement and table-lattice detection are v1.1 (brief defers tables/figures anyway).

**Images.** `IPdfImage` (`WidthInSamples/HeightInSamples`, `BitsPerComponent`, `ColorSpaceDetails`,
`RawMemory`, `TryGetPng(out byte[])`, `TryGetBytesAsMemory(out Memory<byte>)`, `IsImageMask`,
`MaskImage`). **Untested** — the inbox corpus is entirely vector-math papers with zero raster images.
`TryGetPng` is the extraction path (DCT/JPEG passthrough excepted — use `RawMemory` there);
`TryGetBytesAsMemory` won't bind from PS and needs a C# shim. Deferred to v1.1 per brief; **needs a
raster-bearing specimen** before we trust the pixel-extraction path.

---

## 6. Consequences for the plan (what this recon changes)

1. **Column detection is not a from-scratch build** — adopt `RecursiveXYCut` as the primary
   segmenter for two-column academic PDFs, keep the naive baseline-cluster + Docstrum as
   cross-checks. Reframes brief v1 §1 from "build" to "select + verify + config-tune."
2. **Bookmarks are a free heading oracle** — add to §3's claim lanes; cross-derive against font-tier
   headings AND (when present) the LaTeX skeleton oracle. Three witnesses, agreement-scored.
3. **The generic IR must be multi-lane** — capture the raw atomic layer (letters, all signals)
   *and* the DLA-derived structure (words/lines/blocks/reading-order) *and* the document lanes
   (bookmarks/metadata/paths). Classification stays a later phase; the substrate stays opinion-free
   and richer than any single consumer needs. This is the `ir-schema.md` design.
4. **`IsBold` is a trap; math-in-CM generalizes; pikepdf strips producer** — three concrete store
   seeds/rules (`font-roles` face-from-name, `font-roles` CM-family math, `producer-map` +
   font-evidence fallback) with provenance "2508.11646, recon 2026-07-02."
5. **Interop gotchas to encode once** in the loader helper: nullable-struct `.HasValue` guard,
   `out Memory<byte>` needs a shim, dependency-ordered `Add-Type`.

## 7. Registry seed (specimen 2508.11646)

producer=`pikepdf 8.15.1` (rewriter; true origin=pdfTeX by font evidence) · fonts={NimbusRomNo9L
Regu/Medi/Ital, NimbusMonL, Times-Roman, CMR10/CMSY10/CMMI10} · struct-tree=absent ·
bookmarks=8 · layout=two-column (XYCut clean, Docstrum merged) · images=0 raster / vector TDA figures
p3+ (bezier, no bbox via API) · pathologies={IsBold≡0, producer-stripped, arXiv-stamp as Times-20
rotated} · lessons=§6. First permanent regression fixture once the emitter lands.
