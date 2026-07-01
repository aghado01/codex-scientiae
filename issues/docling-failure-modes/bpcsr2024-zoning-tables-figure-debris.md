# Docling failure-mode characterization: zoning collapse, table shattering, figure-text bleed

**Status:** findings only — no fix landed; discussing the right level of intervention
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
