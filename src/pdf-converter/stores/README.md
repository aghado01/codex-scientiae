# pdfdig config stores — rules as data

No cue lives in code. Every mapping the engine consults is a store here, in the doccer
inventory idiom: provenance-tagged entries, examples where they earn their keep, loader
validation on import (`Import-PdfDigStores` throws on a malformed line — a bad entry is a
test failure, not a silent skip).

**The growth loop:** when the oracle-graded metric, the repair loop, or a specimen finds a
systematic miss, the fix lands HERE as an entry with provenance ("motivated by 2508.11646
p4, CMEX bracket glyphs") — reviewable, diffable, testable in isolation. Never a code patch,
never a content regex. Stores map *principled cues* only: fonts, geometry, Unicode registers.

**Shared across tiers:** `Markpig.Pdf` (the C# AST tier) consumes these SAME stores.

## font-roles.jsonl

Font-name → role claims. One JSON object per line:

| field | meaning |
|---|---|
| `pattern` | name fragment to match against the subset-stripped font name |
| `match` | `prefix` \| `substring` (case-insensitive; longest matching pattern wins) |
| `role` | `math` \| `prose` |
| `family` | short family tag (`cm`, `ams`, `nimbus`, `stix`, …) |
| `face` | optional `{bold, italic}` — heading/emphasis cues |
| `domain` | origin domains this cue belongs to (`tex-origin`, `office`, `publisher`) |
| `notes`, `provenance` | why this entry exists and where it came from |
| `examples` | optional `{pos:[], neg:[]}` real font names seen |

A font matching NO entry ⇒ role `unknown` ⇒ the letter is emitted prose-shaped but the run
carries `unknown_font_role` — flags, never guesses.

## symbol-map.jsonl

Font-aware glyph→target corrections applied at run emission. Fields: `font_family`
(family tag from font-roles, or `*` for font-independent normalizations), `char`,
`unicode` (replacement text), `katex` (canonical KaTeX for math runs, optional), `scope`
(`math` \| `prose` \| `*`), `notes`, `provenance`. The `CMSY k → ‖` class lives here;
so does ligature expansion (`ﬁ→fi`, `font_family:"*"`, scope prose) — canonical-register
normalization at the source beats corpus sweeps later. SMP codepoints round-trip untouched;
U+FFFD is *flagged* (`unmapped_symbol`), never replaced.

## classify-config.json

The numeric knobs, made explicit. Each section carries a `_doc` key documenting semantics
and provenance of the values (Extractor.cs constants where ported). The engine hashes this
file into the IR header (`config_hash`) so conversions are version-diffable.

## producer-map.jsonl

Producer-string patterns → origin tags. Fields: `pattern` (substring, case-insensitive),
`origin` (`pdftex`, `xetex`, `luatex`, `dvips`, `word`, `indesign`, `rewriter`, …), `tex`
(true/false/null — null = inconclusive), `notes`, `provenance`.

**Rewriter lesson (specimen 2508.11646):** arXiv post-processes PDFs through pikepdf, which
overwrites Producer — the string alone cannot carry TeX-origin. When the producer verdict is
null, the engine falls back to *font evidence*: any letters matching a font-roles entry with
domain `tex-origin` ⇒ `tex_origin: true, cue: "fonts"`. The cue ships in the IR header so
downstream always knows which sense produced the verdict.

## Who consumes what

| Store | Substrate (`pdfdig-ir.ps1`) | Classifier (`pdfdig-classify.ps1`) |
|---|---|---|
| `font-roles.jsonl` | family/role census, origin font-evidence | role per run (math/prose/mono; unknown ⇒ flag) |
| `producer-map.jsonl` | origin ladder (producer > creator > fonts) | inherits verdict from the IR envelope |
| `classify-config.json` | columns + rules knobs, `config_hash` | script/heading/display-math/furniture knobs |
| `symbol-map.jsonl` | — (substrate stays byte-faithful) | glyph corrections (math) + ligatures (prose) at node emission |

## specimens.jsonl (one level up)

The specimen registry — per-PDF record of producer, fonts encountered, pathologies, what
worked, what broke, which store entries it motivated. The registry IS the curriculum and
doubles as the regression suite: every specimen stays green as the engine grows.
