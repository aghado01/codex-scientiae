# Docling failure-mode characterization: zoning collapse, table shattering, figure-text bleed

**Status:** ROOT-CAUSED + TIER-1 FIX VERIFIED (2026-07-01) — source-vs-IR comparison + corpus survey done; root cause
confirmed **in opendataloader-pdf's own source** (which supersedes this brief's first grounding-pass attribution — see
below); the geometric-promoter gate is landed in `headings.ps1` (commit 382e527) and verified against the virgin
`ingestion/compendia/membrane-testing` bed (see **Verification** at the bottom).
See the **Grounding pass** section for the mechanism, the survey numbers, and resolutions of the open questions. The
original characterization below stands, with two corrections it makes: the converter is opendataloader-pdf (not raw
Docling), and the brief's proposed zoning fix (Docling's `level`) is refuted by the data.
**Origin:** hand-finalizing `ingestion/compendia/fresh/BPCSR2024` (2026-07-01) — see memory `bp-csr-graphs-primitive`
**Engine:** `src/zones.ps1`, `src/finalize.ps1`, `src/normalize.ps1` (membrane); upstream: Docling's PDF→JSON conversion
**Related:** `no-magic-string-structural-heuristics` (memory — the principle this brief is testing itself against),
`pdf-conversion-stack-roadmap` (memory — pdfdig as the eventual Docling replacement), `ingestion-heading-overpromotion`
(memory — the sibling heading-defect class, opposite direction, fixed post-hoc rather than in-engine),
`gate-blind-spots-valid-but-wrong.md` (sibling brief — same "membrane-clean ≠ clean deliverable" finding, different layer)

---

## Why this brief exists

Finalizing BPCSR2024 by hand surfaced four failures that never showed up in `get_hotspots`/`get_enrichables`
— they're invisible to the fidelity gate because they're not per-chunk content corruption, they're
**document-structure** corruption (zoning, serialization, reading-order). The instinct was to patch the two
regexes that caused it. That instinct was pushed back on, correctly: patching `Test-BodyStartHeading` to
accept Roman numerals fixes *this* paper's shape and says nothing about the next venue's convention (lettered
appendices, `§`-prefixed sections, all-caps-no-punctuation headers, two-line titles). Regex-on-rendered-text is
the same class of fragility the corpus already has a name for and a standing rule against
(`no-magic-string-structural-heuristics`: "use principled signals (typography, IR node structure) ... do it
right or don't"). This brief is the "characterize before you patch" pass that principle calls for.

---

## Failure 1 — zone state machine never leaves `frontmatter`

`zones.ps1` is a sequential state machine; only a `heading`-typed chunk can move `$zone` forward, gated by:

```powershell
function Test-BodyStartHeading([string]$content) {
    return ($content -match '^\s*\d+(\.\d+)*\.?\s+[A-Za-z]') -or ($content -match '(?i)^\s*introduction\s*$')
}
function Test-BackmatterHeading([string]$content) {
    return $content -match '(?i)^\s*(\d+\.?\s+)?(references|bibliography)\s*$'
}
```

BPCSR2024 (IEEE HPEC/PPoPP style) numbers sections with **Roman numerals** ("I.", "II.", "III."), so `\d+`
never matches. It also has a common two-column-IEEE typesetting artifact: the section title's drop-cap first
letter is set at a different font size than the rest of the word, and Docling extracts it as a separate text
run with an injected space — `"I. I NTRODUCTION"`, `"II. P RELIMINARIES"`, `"R EFERENCES"`. The bare-word
fallback (`^\s*introduction\s*$`) fails too, on both the numeral prefix and the injected space.

Result: `$zone` never advances past `'frontmatter'` for any of the 679 chunks, References included.

**Downstream blast radius (this is the part worth dwelling on):** `finalize.ps1`'s per-chunk render path only
calls `Format-Chunk` (which applies heading-level `#`, `$$`-fences, etc.) for chunks that make it into
`$bodyC`. Chunks stuck in `frontmatter` are dumped via `[string]$c.content` with zero formatting
(`finalize.ps1:81`). So the zoning bug doesn't just mis-file content into the wrong bucket — it **silently
strips all structural formatting** from the entire document. A heading-detection miss and a markdown-rendering
miss look identical from here, but they're not: the render bug fires for every chunk in the wrongly-zoned
region, whether or not it's a heading.

## Failure 2 — an independent, identical bug inside `finalize.ps1` itself

Separately from #1: `finalize.ps1:62` has its own References-heading match —
`$c.content -match '^\s*references\s*$'` — for bibliography-sidecar routing. Same drop-cap-space problem, same
failure. This means fixing `zones.ps1` alone would not have fixed bibliography routing; the same text-shape
assumption is duplicated in a second place with no shared source of truth. **This is the strongest argument in
this brief for "stop patching the regex" — there isn't one regex, there are (at least) two independent copies
of the same fragile assumption, and nothing enforces they be edited together.**

## Failure 3 — `Format-Chunk` has no table case (a missing feature, not a heuristic failure)

```powershell
switch ([string]$c.type) {
    'heading' { ... }
    'formula' { ... }
    default   { [string]$c.content }
}
```

Verified directly: Docling's own chunk stream for Tables I–V in BPCSR2024 **does** carry real structure —
`type:"table"` → `"table row"` → `"table cell"`, each cell with a precise bbox that groups cleanly into rows
and columns (this is exactly how the 5 tables got reconstructed by hand: bbox-sort, no guessing). The
information needed to emit a correct markdown table survives intake intact. `Format-Chunk` was simply never
built to consume it — every table cell falls through to `default` and becomes its own disconnected paragraph.

This one is qualitatively different from #1/#2: it's not a brittle heuristic that breaks on a new shape, it's
an **absent code path** against data that's already in the right shape. Lower risk to build, unambiguous
payoff (every table in every future paper), no judgment calls about text patterns.

## Failure 4 — Docling reads figure-embedded text as flowing prose

Confirmed by inspecting the actual chunk types, not inferred from the rendered output:

```
id39 "(edges per second) Throughput 810 8"          type: prose
id41 "110 1 210 2 310 3"                             type: prose, font_size 12.0, font: null
id42 "BP-CSR Vector of PMAs 410 4 510 5 Batch Size"  type: prose, font_size 4.981
id44 "F-Graph"                                       type: prose, font_size 4.981
```

Docling's layout model doesn't recognize chart axis-ticks, legend entries (Fig. 2/3), or diagram-internal
array/vertex labels (Fig. 4/5) as non-body figure content — it segments them as ordinary paragraphs and places
them in reading order right where the figure sits. Unlike Failure 3, this happens **upstream of the membrane
entirely** — it's not a gap in `zones.ps1`/`finalize.ps1`, it's Docling's own PDF layout analysis producing
wrong `type` tags on figure-internal text in the first place.

There **is** an existing furniture filter aimed at this (`Get-FurnitureKind`, `normalize.ps1:280`):

```powershell
if ($t -match '^(Figure|Fig\.?|Table|Tab\.?)\s*\d+\s*[:.]') { return 'caption' }
if ($t -match '^\([a-z]\)\s')                                { return 'figure_label' }
if len-in-text-elements <= 4 -and $t -notmatch '[A-Za-z]{2,}' { return 'crumb' }
```

It under-catches this shape by design: `crumb` requires ≤4 glyphs *and* no 2+-letter run, which was built for
isolated OCR artifacts (`"=2"`, a stray page number). Legend text like `"BP-CSR Vector of PMAs"` or
`"F-Graph"` contains real multi-letter system-name words, so it reads as legitimate prose to a **shape-only**
classifier — the filter has no notion of "this chunk's bbox sits inside a Figure's bbox," only "does this
string look like a caption/label/crumb." Widening the crumb pattern would be the same regex-whack-a-mole the
zoning bug already demonstrates the cost of.

## Failure 5 (open, not yet attributed) — reference-list duplication

Distinct mechanism, evidenced directly in the raw JSON: for the same bibliography entries, **two parallel
paragraph nodes** exist side by side:

```
font: "NimbusRomNo9L-Regu", size: 7.97   ← matches the visible small-print bibliography column
font: null,                 size: 12.0   ← generic/default metadata, complete re-rendering of the same text
```

Reads like two different underlying text sources for the same page region (a tagged-PDF accessibility/
`ActualText` layer alongside the geometric content stream?) emitted without dedup. Not characterized well
enough yet to root-cause — flagging as open rather than guessing.

---

## The actual question this brief is for

Failures 1/2/4 share a shape: a **string-pattern classifier reading Docling's rendered text**, trying to
recover structure (section boundaries, figure-vs-body) that Docling's *own* structural output already encodes
more reliably one layer down:

- Docling already emits `type: "heading"` with a `level` (`Doctitle`/`Subtitle`) — the zone boundary doesn't
  need to parse the heading's *text* for a numeral shape at all. A structural signal is available: e.g. "the
  Nth `Doctitle`-level heading in reading order opens the body," or simply the ordinal position of headings
  relative to the title candidate — no dependency on Arabic vs. Roman vs. lettered numbering, and no
  vulnerability to the drop-cap space artifact, because it never reads the numeral.
- Docling already emits bounding boxes for figures/images (`"source": "imageFile*.png"` nodes carry their own
  bbox). Figure-debris detection could key off **geometric containment** (a prose chunk's bbox falling inside
  or heavily overlapping a sibling figure's bbox) instead of judging the chunk's text shape at all. This is the
  same move: stop reading the string, read the structure that's already sitting next to it.

Failure 3 doesn't fit this pattern — it's not a heuristic to replace, it's a table-aware serializer that
doesn't exist yet and should be built against the structure Docling already provides correctly.

Failure 5 needs its own characterization pass before it fits anywhere.

None of this is one-off to BPCSR2024. Roman-numeral IEEE-style section numbering, drop-cap headings, and
chart-heavy figures are common across the venues this corpus ingests from (HPEC/PPoPP/SOSP-style systems
papers especially) — this is exactly the kind of thing worth surveying across the other ~42 preprocessed
documents before deciding where to spend effort: how many papers hit the Roman-numeral zoning failure, how
many have tables that would benefit from #3, how many have figure-debris leaking past the crumb filter. That
survey is cheap (structural query, no repair work) and should settle whether this is "fix 2 regexes + build 1
serializer" or a genuinely bigger investment.

---

## Open questions for discussion

- Zoning: replace the text-pattern gate with a structure-derived one (heading ordinal / level), or keep the
  regex but widen it (Roman numerals, tolerate injected whitespace) as a stopgap while the structural version
  gets designed? The stopgap is cheap and immediately unblocks other Roman-numeral papers sitting in `fresh/`
  or `ingestion/` — is that worth doing now even if it's superseded later?
- Should the zones.ps1 / finalize.ps1 duplicate-regex problem (Failure 2) be resolved by having finalize *read
  the zone* (single source of truth) instead of re-detecting the References heading itself? That seems like
  the correct fix regardless of what replaces the regex.
- Failure 3 (table serialization): build now against current Docling table/row/cell output, independent of the
  zoning question — agree this is low-risk and worth doing on its own?
- Failure 4: is bbox-containment against figure images actually reliable in Docling's output (need to check
  how consistently image bboxes are emitted relative to their caption/legend text), or does this need the
  pdfdig replacement to do properly (per `pdf-conversion-stack-roadmap` — geometry-primary vs Docling's
  layout-model-primary segmentation)?
- Failure 5: worth a dedicated dig into whether the dual font-layer (7.97pt-named vs 12.0pt-null) is systemic
  across other ingested papers, before deciding if it's a Docling quirk, a specific PDF producer's artifact
  (this PDF's `creation date`/producer metadata could narrow it), or something else entirely.
- Scope of the survey: worth running before any fix lands, to size how many papers each failure mode actually
  touches — do we want that as a `corpus-audit.ps1` extension (it already does drift-detection sweeps per
  `corpus-convention-parity` memory) or a standalone one-off script?

---

# Grounding pass — source-vs-IR comparison + corpus survey (2026-07-01)

Follow-up dig: verified every code claim above, then compared the **raw converter output** — `BPCSR2024.json`
(the node model the membrane ingests) and its sibling `BPCSR2024.md` (the converter's *own* markdown export,
untouched by the membrane) — against the membrane IR (`.scratch/BPCSR2024.chunks.jsonl`), and ran the corpus
survey across all 43 preprocessed docs. Headline: the four failures are **not four problems** — they share one
root, and two of them are the membrane *destroying* structure the converter already got right.

## Attribution correction

The converter feeding this is **opendataloader-pdf** (memory `opendataloader-pdf-recon`), not raw Docling. Its
JSON is a recursive `kids` tree — every node carries
`type, pdfua_tag, id, level, page number, bounding box, heading level, font, font size, text color, content` —
not the `DoclingDocument` `texts/tables/body` schema. opendataloader wraps Docling as its hybrid backend
(these conversions run `hybrid_mode = "full"`). Filename kept for continuity. **opendataloader-pdf is fixed
upstream — mined for insight, never modified**; all fixes land in the membrane, and `pdfdig` (roadmap) is the
eventual replacement for the conversion layer.

## The shared root cause: an unenriched-Docling placeholder layer + a membrane promoter that feeds on it

*(Corrected same-day by reading opendataloader-pdf's source. This pass first attributed the ghost layer to a
tagged-PDF ActualText/accessibility layer in the source PDF — that theory is **refuted**; the layer is a converter
fusion-seam artifact. The observational signature and all survey numbers below are unchanged.)*

The IR carries **two provenance classes of text node**; opendataloader emits both without serializing which is which:

- **enriched layer** (bbox-matched to real extraction): `font: NimbusRomNo9L-*`, real `font size`, `text color: "[0.0]"`.
- **ghost layer** (Docling-backend, enrichment-unmatched): **`font: null`, `font size: 12.0`, `text color: null`** —
  a clean 3-field signature. (`pdfua_tag` is uselessly uniform — `"P"` on all 393 paragraphs — so it is *not* the
  discriminator; the metadata-absence triple is.)

The verified chain, from opendataloader's code: `hybrid_mode=full` routes **all** pages through Docling
(`HybridDocumentProcessor`); `DoclingSchemaTransformer` stamps every Docling element with a **hardcoded
`font=null / size=12.0` placeholder**; `enrichBackendResults`/`enrichSingleTextNode` then swaps in real PDFBox
`TextChunk` metadata wherever a bbox-overlapping, not-yet-consumed Java chunk exists. **`font=null` survivors are
the elements that lost that enrichment match** — recorded internally as `"ocr-fallback"`, a provenance the JSON
serializer does not emit. So `font=null` is a *fusion-seam provenance marker* ("Docling saw this; the geometric
layer didn't"), and is often the **better** extraction. The placeholder's `12.0` clearing the promoter's contrast
test (`12.0 ≥ real ~10pt body × 1.15`) is the exact arithmetic behind every phantom heading.

In BPCSR2024's 393 source paragraphs: **294 enriched, 99 ghost.** The two layers are **complementary, not duplicate** —
e.g. in the references the enriched layer keeps the `[1]…[2]` numbers but runs entries together, while the ghost
layer splits each entry onto its own line but drops the number. This is why Failure 5's references are incoherent: the
membrane kept some entries from each layer. **Consequence: the ghost layer is NOT safe to blanket-drop** — for references
it is the only per-entry-separated copy.

## What the source got right that the IR breaks (the decisive table)

| Signal | Source JSON (`kids`) | Source markdown (`BPCSR2024.md`) | Membrane IR (`chunks.jsonl`) |
|---|---|---|---|
| Headings | **22** (`type: heading`) | **22** (`#` lines) | **45** — 22 native + **23 phantom** |
| Table I taxonomy | 1 `table` node | proper **`\|Category\|Problem\|`** pipe table | **shattered**; "Category"/"Problem"/… promoted to *headings* |
| Tables total | 5 `table` nodes | 45 pipe-table lines | 235 `table cell` + 40 `table row`, **no serializer** |
| Node census | 429 = 393 para + 22 heading + 6 image + 5 table + 3 list | 927 lines, 8 `[Page N]` markers | 679 chunks |

- The **23 phantom headings are 100% membrane-manufactured** (`heading_source: geometric`); every one sits on the ghost
  layer (`font=null`). The source and its own markdown contain no such headings — Docling's `level` field is *also*
  scrambled (6 `Doctitle`, "II. Preliminaries"=Doctitle but "I. Introduction"=Subtitle), so **the brief's "Nth Doctitle
  opens the body" fix would skip the Introduction.** `level` is not usable; `heading_source`/`font`-presence is.
- The **table shatter is 100% a membrane intake defect** — opendataloader's own markdown proves the 5 table nodes
  serialize to clean pipe tables. The membrane flattens them to cells and has no `table` case in `Format-Chunk`.
- Only the **ghost/dual-layer itself is a genuine source defect** — present in the JSON *and* opendataloader's markdown
  (neither dedups the references). Table integrity, by contrast, opendataloader's markdown preserves and the membrane loses.

**Net: opendataloader's markdown export is strictly better than the membrane's JSON intake for tables and heading counts.**
The membrane uses the JSON (not the md) because it needs `font`/`bbox`/`size` for math/script repair — but in gaining
geometry it dropped the converter's table serialization and re-introduced the phantom-heading problem via its own promoter.

## Corpus survey — sizing each failure mode across 43 preprocessed docs

| Failure mode | fingerprint | docs hit | corpus volume |
|---|---|---|---|
| **F3 — table shatter** | `type:table cell` present | **27 / 43** | **8,076 cells** |
| **F5 — ghost (Docling-unenriched) layer** | `font=null ∧ size=12 ∧ color=null` | **41 / 43** | **5,021 chunks** |
| **F1-noise — geometric over-promotion** | `heading_source:geometric` | **36 / 43** | **2,184 headings** — 2,066 (94.6%) on ghost, 118 on named-font (25 docs) |
| **F1-acute — Roman-numeral zoning collapse** | body-zone == 0 chunks | **3 / 43** | BPCSR2024, 2508.11646v1, 2310.08970v2 (all 3 = the only Roman-numeral docs) |

This **re-orders the brief's own priorities**: the Roman-numeral collapse it opens with is the *narrowest* mode (3 docs);
the ghost layer it files last as "open, characterize later" is the *most systemic* (41 docs) and is the shared root; and
the table serializer is the biggest content-recovery win (8k cells / 27 docs). (Secondary signal for later: a few large
docs — 2408.06958v3 @ 4% body, 1606.04970v3 @ 3% — aren't fully stuck but have suspiciously low body-zone %, hinting at a
milder non-Roman zoning failure not chased here.)

## Resolutions of the open questions

1. **Zoning — structure vs. widen-regex?** Neither as framed. Docling's `level` is scrambled (refuted above). The
   structural replacement should key on **font-size tiering among named-font, source-native headings** (per-paper
   relative: title = unique max; sections/subsections cluster below), which only becomes clean *after* the geometric
   promoter is gated. Until then, the stopgap regex is fine but needs **three** fixes, not one: Roman numerals, the
   injected drop-cap space (`I. I NTRODUCTION` — confirmed an opendataloader artifact, present in its own markdown), and
   `R EFERENCES`. Cheap, unblocks exactly the 3 acute docs.
2. **Failure 2 (dup regex) → finalize reads the zone?** Yes, unconditionally correct — single source of truth regardless
   of what replaces the detector.
3. **Failure 3 (table serializer) build now?** Yes — highest ROI, lowest risk, and we now have opendataloader's own
   markdown pipe tables as a **reference oracle** for the expected output. One coupling: the geometric promoter *steals
   table header cells* into phantom headings, so gate the promoter first (or in the same change) or the serializer emits
   headerless tables.
4. **Failure 4 (bbox containment reliable?)** Data-wise yes — bbox present on 639/679 chunks (94%). Note font-provenance
   and geometry do *different* jobs: the `font=null` triple identifies the ghost layer; **bbox-in-image** tells you which
   ghost chunks are figure-debris vs. real (numberless) references — both are `font=null`, so font alone over-drops.
5. **Failure 5 root-cause / systemic?** Answered: systemic (41/43), and it is the **Docling-backend enrichment seam**
   (`font=null ∧ size=12 ∧ color=null` = the hardcoded placeholder on elements that failed the bbox enrichment-match —
   see the corrected root-cause section above). It manifests as per-entry source inconsistency, not wholesale
   duplication, and the two layers are complementary — so the reconciliation is a *merge* (prefer enriched-layer
   numbering + ghost-layer entry splitting), not a drop.

## The single highest-leverage fix, and the data-supported priority order

**Gate geometric heading-promotion on the ghost signature** — never promote a `font=null` (ActualText) node to `heading`.
This removes 2,066 phantom headings corpus-wide (94.6% of all geometric promotions), preserves the 118 named-font
promotions that might be legitimate, and is a *principled typographic* gate ("a heading is set in a real font"), exactly
what `no-magic-string-structural-heuristics` and the `ingestion-heading-overpromotion` thread call for.

Priority by ROI/risk (data-supported, differs from the brief's ordering):
1. **Gate the geometric promoter on `font!=null`** — systemic root, low risk, also un-steals F3's table headers and removes the figure-debris-as-headings slice of F4.
2. **Table serializer (F3)** — biggest content recovery (8,076 cells / 27 docs); validate output against opendataloader's own markdown pipe tables.
3. **finalize-reads-zone (F2)** — trivial correctness/dedup, do regardless.
4. **Roman-numeral zoning stopgap (F1-acute)** — 3 docs; font-tier structural replacement later.
5. **bbox-containment for residual figure-prose (F4)** and **reference two-layer merge (F5)** — lower volume, need geometry + merge logic.

*Survey per-doc numbers saved to `%TEMP%/bpcsr_survey.json` at time of writing (disposable).*

---

# Verification — Tier-1 promoter gate (2026-07-01, `membrane-testing` bed)

The fix landed in `headings.ps1`'s promotion loop (commit 382e527): `if (-not $n.font) { continue }` — a node with
no measured typography cannot pass a typographic contrast test; its `12.0` is the converter placeholder, not a size.

Verified on `ingestion/compendia/membrane-testing/` — virgin copies of the ph-temp docs (no `.scratch`), originals
untouched. Gated (new) runs vs. the ph-temp pre-gate baselines, with opendataloader's own `{slug}.md` as the
heading oracle:

| Doc | Headings: baseline → gated | Null-font phantoms removed | Native vs `.md` oracle | Zoning |
|---|---|---|---|---|
| 2112.10906v4 | 19 → 19 | 0 (already clean) | **18 = 18** | healthy (body: 185) |
| 2408.16741v2 | 82 → **41** | **41** | **39 = 39** | healthy (body: 367) |
| 2508.11646v1 (Roman-numeral) | 97 → **28** | **69** | **28 = 28** | still 100% frontmatter |

- **Native heading sets match the converter's own markdown exactly on all three docs.** The only extras are 3
  named-font geometric promotions: two author/affiliation lines (2408.16741v2, `CMR12 @ 11.96pt`, zoned frontmatter
  anyway) and one bold `Proposition 2.1 …` head (2112.10906v4, `SFBX1095` — typographically real; whether theorem
  heads should be headings is a standards question, not a defect).
- **Secondary win:** phantom headings had been breaking `collapse`'s paragraph merging — gated runs produce fewer,
  better-merged chunks (529→501, 307→291).
- **Confirmed independence:** 2508.11646v1 now has a perfect heading set but still zones 100% frontmatter — the
  Roman-numeral zoning stopgap (priority #4) is untouched by this fix, as predicted.
- **Residual watch-item:** a doc whose text is wholly unenriched (scan-like, everything `font=null`) with no
  converter-native headings would now get zero headings and silently zone-collapse. Cheap telemetry: flag
  `native headings == 0 ∧ gated promotions > 0` for review.
