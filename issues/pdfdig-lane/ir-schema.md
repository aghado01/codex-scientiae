# pdfdig generic IR — the JSONL substrate

**Status:** DESIGN (2026-07-02), grounded in `pdfpig-capability-map.md`. This is the *generic,
opinion-free* PDF→IR the whole lane stands on: a faithful, richer-than-needed projection of
everything PdfPig can see, with **no classification cleverness** (no math/heading/prose verdicts,
no column reasoning beyond recording which segmenter said what). Classification, symbol correction,
math assembly, and the de-novo workflow all consume THIS; none of them is baked in here.

**Design axiom (from the capability map):** capture **multiple parallel lanes** — the raw atomic
layer AND the derived structure AND the document lanes — because no single consumer needs all of it
and every consumer needs a *different* subset. The substrate stays neutral; opinions live downstream
where they can be cross-derived and flagged.

---

## Why multi-lane (not a single node stream)

The brief's IR contract (`node { page, line_id, baseline_y, col, type, content, font, size, bbox,
role, script, tex_origin, flags[] }`) is a *classified* stream — it already carries `type`, `role`,
`col`. That is the **output of the converter**, not the substrate under it. The recon showed three
independent claim sources (letter geometry, DLA segmentation, bookmarks) that *disagree* and must be
cross-derived. A substrate that collapses them into one opinionated stream throws away exactly the
signal the de-novo workflow needs. So the generic IR is layered:

```
{slug}.pdfdig.json          ── document envelope: provenance, health, metadata, bookmarks, per-page stats
{slug}.letters.jsonl        ── LANE 1  atomic: one record per Letter, every born signal
{slug}.words.jsonl          ── LANE 2  derived: NN word extraction (page, line, block back-refs)
{slug}.blocks.jsonl         ── LANE 3  derived: segmentation + reading order (which segmenter, params)
{slug}.paths.jsonl          ── LANE 4  vector: paths (rules vs shapes), figure regions
```

All five share the `{slug}` address beside the PDF (brief's positional contract; `project-ir` picks
up the envelope). Lanes are independently regenerable and independently diffable. A consumer that
only wants classified nodes reads letters+blocks; one that only wants the outline reads the envelope.
The **classified node stream the brief specifies is a v1 CONSUMER of these lanes**, emitted by the
classifier phase, not by the extractor — kept as `{slug}.nodes.jsonl` when that phase lands.

> Open decision retained from the brief: flat-vs-nested. Resolved for the *substrate* as **flat
> JSONL per lane with integer cross-refs** (`letter_id`, `word_id`, `block_id`, `line_id`), which is
> membrane-native (`project-ir` flattens anyway) and preserves the hierarchy XYCut/Docstrum give us
> without paying nesting's diff cost. The nesting is reconstructable from the back-refs.

---

## The document envelope — `{slug}.pdfdig.json`

```jsonc
{
  "schema": "pdfdig-ir/1",
  "source": { "pdf": "2508.11646.pdf", "slug": "2508.11646", "bytes": 1234567, "sha256": "…" },
  "engine": { "name": "pdfdig-ps", "version": "0.1.0", "pdfpig": "0.1.14",
              "config_hash": "…", "run_utc": "2026-07-02T…Z" },     // regenerable + version-diffable
  "document": {
    "pages": 18, "version": 1.5, "encrypted": false,
    "producer": "pikepdf 8.15.1", "creator": null, "title": null, "author": null,
    "origin": { "tag": "tex", "cue": "fonts", "producer_verdict": null }, // pikepdf stripped producer; font evidence wins
    "has_struct_tree": false, "has_xmp": true, "has_bookmarks": true
  },
  "bookmarks": [ { "title": "Introduction", "level": 0, "page": 2 },   // LANE 0: independent outline oracle
                 { "title": "From Spiking Dynamics to Topology", "level": 0, "page": 2 }, … ],
  "fonts": [ { "name": "NimbusRomNo9L-Regu", "family": "nimbus", "face": {}, "sizes": [23.9,11,10],
               "letters": 2400, "role_hint": "prose" },              // per-document font census (name-tiering input)
             { "name": "CMSY10", "family": "cm", "role_hint": "math", "letters": 5 }, … ],
  "pages": [ { "n": 1, "w": 612, "h": 792, "rotation": 0, "letters": 4982,
               "words": 800, "blocks": 9, "paths": 0, "images": 0,
               "segmenter": "xycut", "orientations": {"Horizontal": 4982},
               "render_modes": {"Fill": 4982} }, … ],
  "health": {                                                         // §"oracle-free confidence" — ships without any sidecar
    "letters_total": 89000, "known_font_role_frac": 0.998,
    "unmapped_symbol_count": 3, "invisible_letter_frac": 0.0,
    "columns_confident_frac": 0.94, "flags_per_page": 0.4,
    "domain": "tex-origin"
  },
  "flags": [ { "code": "producer_rewritten", "detail": "pikepdf overwrote pdfTeX producer" } ],
  "sig": "simhash:…"                                                  // cheap re-conversion tripwire
}
```

`origin.cue` ∈ `producer | fonts | none`, `health.domain` ∈ `tex-origin | office | publisher |
scanned | unknown` — the capability map's domain axis, so unknown cues degrade to flags not guesses.

## LANE 1 — `{slug}.letters.jsonl` (the atomic spine)

One record per `Letter`, in content order. **No role/script verdicts here** — those are geometry
*measurements*, and the interpretation (is this small-raised glyph a superscript or a footnote
marker?) is the classifier's call. We record the measurements neutrally:

```jsonc
{ "id": 1423, "page": 2, "seq": 337,            // seq = TextSequence (op-stream ordinal)
  "text": "δ",
  "bx": [312.4, 588.1, 318.0, 597.3],           // BoundingBox  [L,B,R,T]  (PDF space, y-up)
  "base": [312.4, 590.2], "ebase": [317.9, 590.2], // Start/End baseline points
  "size": 10.0,                                  // PointSize (absolute)
  "font": "CMMI10", "family": "cm",              // FontName subset-stripped + family tag from font census
  "italic": false, "bold_name": false,           // IsItalic (trusted) + name-derived bold (NOT IsBold flag)
  "wadv": 5.5,                                    // advance Width (gap-space input)
  "render": "Fill",                              // RenderingMode (Invisible ⇒ downstream flag)
  "orient": "Horizontal",                        // TextOrientation
  "color": "#000000",                            // Color (hex; null if default black)
  "block": 5, "line": 71, "word": 812 }          // back-refs into lanes 2/3 (null until derived)
```

Notes:
- `family` and `bold_name` are the ONLY interpreted fields, and both are *store lookups*
  (`font-roles.jsonl`), not code heuristics — a font matching no store entry ⇒ `family:"unknown"`,
  and a per-letter presence in the envelope `flags` as `unknown_font_role`. Everything else is a
  raw PdfPig read-out.
- Ligatures: `text` carries PdfPig's ToUnicode value verbatim (may be `ﬁ`); NFKC/expansion is a
  *classifier/emission* concern (store-driven), NOT applied to the substrate — the substrate is
  faithful to what the PDF encoded, U+FFFD included (flagged, never silently replaced). SMP
  round-trip verified at write time (UTF-8-no-BOM via the `jsonl.ps1` substrate).

## LANE 2 — `{slug}.words.jsonl` (NN word extraction)

```jsonc
{ "id": 812, "page": 2, "text": "delta-homology",
  "bx": [312.4, 588.1, 361.0, 597.3], "font": "NimbusRomNo9L-ReguItal",
  "orient": "Horizontal", "letters": [1420,1421,…,1433],   // letter_id refs
  "block": 5, "line": 71, "reading_order": 71 }
```

`NearestNeighbourWordExtractor` (the DLA default that handled gap-spaces + within-word merge on the
specimen). Words are a *convenience lane* — the atomic layer is authoritative; words are the
battle-tested grouping we don't want to re-derive.

## LANE 3 — `{slug}.blocks.jsonl` (segmentation + reading order — a CLAIM lane)

```jsonc
{ "id": 5, "page": 2, "bx": [312, 592, 563, 719],
  "segmenter": "xycut", "params_hash": "…",       // WHICH claim source + its config
  "reading_order": 5,
  "lines": [ { "id": 71, "bx": [...], "text": "The rest of this paper is organized as follows. Section",
               "words": [812,813,…], "modal_font": "NimbusRomNo9L-Regu", "modal_size": 10.0 } ],
  "column_band": 1,                                // derived from block x-extent clustering (0=left,1=right)
  "text": "The rest of this paper…" }
```

**This is explicitly a claim lane, not truth** (capability map §2, §4): it records what a *particular*
segmenter said, tagged with which one. v1 runs XYCut as primary; the envelope's
`health.columns_confident_frac` measures agreement between segmenters / band-consistency so the
de-novo workflow knows where to look. Re-running with Docstrum writes a parallel `blocks` variant for
cross-derivation — segmenter disagreement is a *flag*, per the "struct trees are witnesses" rule
applied to layout.

## LANE 4 — `{slug}.paths.jsonl` (vector)

```jsonc
{ "id": 3, "page": 4, "is_clipping": false, "is_filled": true, "is_stroked": true, "line_width": 0.4,
  "subpaths": 2, "kinds": ["cubicbeziercurve"],      // command census (move/close elided)
  "bbox": [220.1, 540.0, 268.9, 588.2],              // GetBoundingRectangle (all path kinds — §5 corrected)
  "bbox_source": "api",                               // "api" | "commands" (genuine-null fallback) | null
  "rule": null }                                      // "hrule"|"vrule" when thin non-bezier; else null (v1.1 refines)
```

`GetBoundingRectangle()` covers all path kinds (the earlier bezier-null reading was the PS
nullable-unwrap trap — capability map §5); the conservative command-point bbox remains as a
genuine-null fallback, and `bbox_source` tags which source produced each box. Images get a parallel
lane when a raster-bearing specimen arrives (untested — §5).

---

## What the substrate deliberately does NOT do

Per the brief's de-novo / distillation discipline, the generic IR withholds every *opinion* so they
can be formed downstream with provenance and flags:

- **No `role: math|prose|heading` verdict** — that's the classifier reading lane-1 `family` +
  lane-3 tiers + envelope bookmarks, cross-derived.
- **No `script: sub|super`** — lane 1 records `size`+`base` deltas; the sub/super *call* (vs
  footnote marker vs stray) is classification.
- **No symbol correction / ligature expansion** — substrate is faithful to the PDF's codepoints;
  correction is store-driven emission.
- **No `$…$` seams / math assembly** — 1-D preview and 2-D assembly are later bricks (C# AST tier).
- **No column *decision*** — lane 3 records claims; the resolved reading order is a consumer.

This keeps the substrate falsifiable and re-runnable, and means a substrate bug (wrong bbox, dropped
glyph) is distinguishable from a classification bug (wrong role) — they live in different files.

## Emission mechanics (reuse the repo substrate)

- Write via `src/jsonl.ps1`'s `Write-JsonlStage` → gets `.jidx` + `.sig` sidecars, UTF-8-no-BOM,
  SMP-safe, for free. The envelope is a single JSON (its own `.sig`).
- `project-ir.ps1`'s alias map already resolves `page/font/font size/bounding box/content` — lane-1
  records use those canonical spellings (or extend the alias map by one entry) so the membrane
  ingests pdfdig IR with a schema *extension*, not a rewrite (brief §IR contract).
- Config-as-data (`classify-config.json`) is loaded but, for the substrate pass, only the DLA
  segmenter/word-extractor option knobs are consulted — no classification thresholds fire yet.

## Build order (this is the "start slow" increment)

1. **Loader + envelope + LANE 1** — open, per-page letters with all signals, font census, origin
   verdict (font-evidence fallback), bookmarks, health metrics. Run on 2508.11646, eyeball.
2. **LANE 2 + 3** — NN words + XYCut blocks/lines/reading-order + column bands + back-refs.
3. **LANE 4** — paths with bezier-fallback bbox.
4. **Registry + regression** — `specimens.jsonl` entry; the emitted lanes become the golden fixture.

Only after the substrate is trustworthy does the classifier phase (the brief's `type`/`role`/`script`
node stream) get built on top — and the config stores (§brief) get seeded from what the substrate
reveals.
