# pdfdig-PS — the opendataloader-pdf replacement lane for codex-scientiae

**Status:** LARGELY LANDED (updated 2026-07-03; born as DESIGN 2026-07-02). The end-to-end path
**PDF → multi-lane IR → classified nodes → membrane → finalized markdown** is built, tested (500+
Pester), and validated on 2508.11646 (structure now matches the LaTeX oracle 1:1; math 87% render-
clean with the residue honestly flagged + doled to a gated reasoning-repair loop). The design body
below is the rationale; the dashboard next is the current state + what's left. The deterministic,
VLM-free PDF→IR converter for the membrane's ingestion needs, in PowerShell, driving PdfPig directly.
**Division of concerns (user-decided):** THIS lane (codex, PS) = the *converter* — PDF → membrane IR,
"membrane style." **`Markpig.Pdf` (C#) remains** and shifts to the *PDF-AST tier* — 2-D math-structure
assembly, render-back verification, foreign-AST → `New-MarkdigAst`. Same family, two tiers.
**Motivation:** building against opendataloader's conversion (formula enrichment, hybrid Docling) is
painstaking; its architecture is the inverse of what the corpus needs (VLM-primary, geometry
discarded, ghost placeholder layer, `level` scrambled). The seeds of the better solution exist and are
validated (pdfdig recon + first dig).
**Related:** pdfdig SHAPE.md (MarkPig), `issues/conversion-metric/` (the acceptance harness),
`issues/latex-math-oracle/` (the fidelity net over this lane), `issues/docling-failure-modes/`
(the catalog of what this lane must not reproduce).

---

## Progress dashboard (2026-07-03) — what's landed, what's next

**The lane, end to end.** `src/pdf-converter/` (converter) + `src/pdfdig-adapter.ps1` + membrane:
- **IR substrate** (`pdfdig-ir.ps1`) — envelope + 4 lanes (letters / words / blocks+reading-order /
  paths), all born signals, opinion-free. Deterministic (byte-identical re-runs). → `ir-schema.md`,
  `pdfpig-capability-map.md`.
- **Config stores** (`stores/`) — `font-roles`, `producer-map`, `symbol-map`, `classify-config`, all
  wired + validated; `specimens.jsonl` registry (6 specimens). Rules-as-data; growth loop proven
  (known-font-role 0.03→1.0 via store edits).
- **Classifier** (`pdfdig-classify.ps1`) — order-statistics calibration + typed node stream
  (role/script/heading-tier/formula/marker), bidirectional outline cross-derivation, wrapped-heading
  re-fusion. Heading structure MATCHES the oracle on 2508.11646.
- **Math assembler (1.5-D)** (`math-assembler.ps1`) — recursive size-tier script NESTING
  (`t_{v_{i+1}}`, not the invalid flat `t_{v}_{1}`). Delimiter-balance flags.
- **Membrane dual-lane intake** — `membrane-handoff.md` (LANDED): membrane ingests pig IR OR
  opendataloader through one on-ramp.
- **Gated math repair** — `gated-math-repair.md` (LANDED): flagged residue → `math_evidence`
  geometry transcript → dispatch → reasoning-model repair → `render_check` gate. Promotion of a fix to
  the deterministic tier is HUMAN-gated (the machine surfaces, never promotes).
- **Perf + substrate** — advance-based spacing, lane-gated normalize, dehyphenation; jsonl bulk-write
  + inline `.jidx`; encoding-invariants test suite. 84p warm: IR 148→51s.

**Clustering engine (HDBSCAN) — BUILD IN PROGRESS (2026-07-03).** The density-clustering capability
the earlier design reserved for the two genuinely-continuous problems (figure-region assembly + a
segmentation THIRD-witness — NOT the quantized-typography classifier spine, which stays order
statistics). User is rebuilding the ThermoMapper custom HDBSCAN (ripped out with its frayed wires)
as a **standalone C# CLI executable** (`hdbscan.exe`, mirroring TM's `user-repl`: load CSV/JSONL →
cluster → emit `partition.csv` / `summary.json` / `dendrogram.json` to `--out-dir`), which the PS
lane invokes as a subprocess (not `Add-Type`). New repo dotnet architecture landed this direction:
`Directory.Build.props` (repo-wide net10 / nullable / artifacts→`artifacts/bin/{project}`),
`src/hdbscan/` (the engine — CoreDistances / Prim-MST / DendrogramBuilder / condensation / Metric),
`tests/hdbscan/` (smoke `Program.cs`), `projects/` (build defs; `dotnet publish -o bin/{project}` for
the release the PS workflow consumes). **Audit done — the migration is self-contained (no missing ThermoMapper deps); the reshape is
cosmetic (namespace 5→1, doc-comment de-TM-ification) + the CLI to write.** Full audit + generic CLI
spec + do-order: **`issues/hdbscan-cli.md`**. Open items are the user's call (MSBuild src/projects
wiring A/B; projects/tests csproj). Scoped with Gemini
(`~/.gemini/…/66066885-…/implementation_plan.md`); not yet acted.

**v1 must-haves — status against §"v1 must-haves" below:**
1. Column detection — ✅ (RecursiveXYCut, the vendored DLA solved "THE gap"; not built from scratch).
2. All-pages + assembly — ✅. 3. Satellite reattachment — ⚠️ partial (DLA line-grouping; no explicit
second pass yet). 4. Font-tier headings — ✅ (+ outline cross-derivation, beyond the plan).
5. Display-math regions + `$…$` seams — ✅ (1-D + now 1.5-D nesting). 6. Symbol correction — ✅
(store, math scope). 7. Ligatures/NFKC — ✅ (dehyphenation too). 8. Figures — ⚠️ v1.0 path markers
only; pixel extraction NOT done (no raster specimen yet).

**Open decisions — RESOLVED:** node shape = flat JSONL per lane w/ back-refs (✅). Conversions land
beside the PDF as `{slug}.*` (✅). Fork = vendored `lib/pdfpig` 0.1.14 (✅). Perf = low-level loops,
interior-swap hatch unused so far (✅, and the encoding-invariants suite guards determinism).

### Next steps — scoped for a future session (priority order)

1. **Delimiter-aware display-equation region assembly** (the deterministic frontier). Today's dominant
   residue is NOT fractions — it's `‖…‖`/`(…)` spans FRACTURED across formula-block lines (honest
   `unbalanced_delimiters`). Group all glyphs of one display equation (2-D region, not line-by-line)
   before assembling, so delimiters stay paired. Shrinks what the reasoning tier gets doled. This is
   the highest-leverage next build.
2. **Cross-specimen validation of the assembler's n=1 knobs.** `size_ratio`/`baseline_tol_frac` were
   tuned on 2508.11646 alone — run the classifier+assembler over the other 5 registry specimens
   (Latin-Modern, cmbright, newtx, office), measure render-clean %, and treat every constant as a
   conjecture (the "beware calibration-set overfit" discipline). Likely surfaces new store gaps.
3. **A/B campaign vs opendataloader** (the acceptance criterion, `issues/conversion-metric/`). Same
   dual-availability papers, both lanes, scored against the LaTeX oracle — the replacement claim as a
   number per lane. Needs the conversion-metric aligner (also unblocks oracle-backed benchmark trials).
4. **Figure/raster lane** — needs a raster-bearing specimen first (the inbox corpus is all vector);
   `TryGetPng` + the `TryGetBytesAsMemory` PS shim. Path-command bbox for bezier figure regions. This
   is the **first consumer of the HDBSCAN CLI** (build-in-progress, above): cluster Lane-4 path bboxes
   + satellite text into figure regions, with stray rules/underlines falling out as the noise class.
5. **cmbright math-role disambiguation** — SF-family papers set math IN the SF fonts, so font-name
   role is ambiguous there (flagged, unsolved; registry: 2210.00916). Needs a geometry/adjacency cue.
6. **Satellite reattachment second pass** (v1 must-have #3 remainder) if a specimen shows the
   footnote-superscript fracture in the pig lane.
7. **Wire the refined benchmark harvest** (`issues/benchmark-harvest.md`): prompt + oracle-reference
   capture in the post-hoc review.

**Restart the live codex-membrane MCP server** to pick up any stage-script edits from this work.

---

## Why this wins before it's clever

The membrane's hardest engineering this month was *reverse-engineering signals opendataloader
destroyed or never emitted*. The PdfPig IR is **born with them**:

| Membrane pain (opendataloader era) | pdfdig IR property that dissolves it |
|---|---|
| Ghost layer (`font=null/12.0` placeholder) + promoter misfires | every glyph carries a REAL font + size — the ghost class cannot exist |
| Heading detection via text regexes / gated geometry | font-size tiering over real typography — the principled promoter the heading thread wanted |
| Math detection via content heuristics after the fact | `role: math` read off TeX font names (CMMI/CMSY/MSBM…) at extraction time |
| Subscript/superscript destroyed (`p1` for `p₁`) | `script: sub|super` from size + baseline delta — validated on real papers |
| Docling `level` scrambled, zoning regexes | body/backmatter anchored on font tiers + (dual-availability) the skeleton oracle |
| VLM formula enrichment, trusted verbatim | deterministic extraction; uncertainty FLAGGED, repaired by the membrane's agent loop |

The membrane's repair loop is the already-built "harnessed agent" tier: pdfdig flags residue instead
of guessing, and flagged chunks land in dispatch exactly like today's corruption classes.

## Identity and shape

- **`src/pdfdig.ps1`** — pure PowerShell, loads the PdfPig fork in-process (`Add-Type` on the
  vendored dlls; PS 7 *is* .NET — no build step, no server, keeps codex single-language).
- **Vendoring:** `tools/pdfdig/` holds the fork assemblies (`UglyToad.PdfPig` 1.7.0-custom-5 from the
  private feed), pinned + provenance-documented — same pattern as `tools/render-check`'s node_modules.
- **MCP surface:** `pdfdig_convert paper|pdf_path` on the membrane server. Emits, beside the PDF:
  - `{slug}.json` — the raw IR (same positional contract opendataloader filled; the membrane's
    `Resolve-Source`/`project-ir` pick it up unchanged in address, extended in schema)
  - *(debug only)* a 1-D preview render — a development read-out, never a deliverable or QA slot
    (see "De novo, not post-hoc": pdfdig does not ship a broken markdown sibling)
  - `{slug}/imageFileN.png` — extracted figures per the corpus images convention (staged; see below)
- **Provenance in-band:** the JSON header records engine version, parameters, and per-page stats —
  conversions are regenerable and deterministic, so re-conversion is version-diffable (SimHash
  fingerprint per output for the cheap tripwire).

## The standalone mission (and what the oracle is NOT)

**pdfdig must stand on its own.** Its mission is reliable conversion coverage over the wild universe
of PDFs — the ocean of cases with no arXiv LaTeX sidecar. The LaTeX oracle is a **development-time
calibration instrument and bug/blind-spot detector** — a crutch to get the engine off the ground —
plus, in the codex workflow, an *optional consensus companion*, strictly nice-to-have. It is never an
architectural dependency: the workflow must be fully functional, and the engine's confidence fully
computable, on a bare PDF.

**pdfdig replaces opendataloader; the oracle does not move; and one slot is RETIRED, not inherited.**
opendataloader's "own markdown" was never architecture — it was **evidence of inadequacy**: if the
converter did its job, that `.md` would BE the deliverable and no IR-based repair workflow would
exist. The membrane's entire post-hoc lane (ignore the converter's markdown, re-emit from the IR) is
compensation for a converter that couldn't finish its job. pdfdig does not ship a confession:

| View | opendataloader era | pdfdig era |
|---|---|---|
| **geometry IR** (the substrate) | opendataloader `{slug}.json` | **pdfdig `{slug}.json`** |
| **converter's markdown** | broken `.md`, ignored by the workflow | **RETIRED** — pdfdig's deliverable is the FINAL markdown, born from the de novo workflow below (a dev preview may exist as a debug read-out, never as an artifact slot) |
| **logical truth** (independent view) | LaTeX oracle (baby mathdig) | LaTeX oracle — *unchanged*, optional |

### De novo, not post-hoc (the workflow inversion)

The membrane's current shape — convert first, repair after — is an opendataloader-era artifact.
pdfdig **in-lines the gap-filling into the primary conversion**: deterministic preprocessing does the
maximal legwork and *computes its own boundary*; the flagged gaps (if any) are worked **upfront,
inside the conversion**, by language-model *reasoning* in the membrane's seeing-agent discipline,
against **pdfdig MCP scaffolding** (the membrane-inherited verbs — slice/propose/gate/apply/audit —
re-aimed at conversion gaps instead of post-hoc corruption). The output of the workflow is the final
markdown; there is no intermediate broken deliverable, and no repair phase after the fact. Given the
wild variety of PDF standards and document quality, some model-in-the-loop is expected — but in-line,
gated, provenance-tagged, and only on the residue the deterministic tier flags.

The membrane's legacy here is twofold: its **framework** (dispatch/propose/gates/leases/audit, run
layout, run-visibility) is inherited as the scaffolding, and its **audit corpus** — every repair it
ever performed post-hoc — is the empirical catalog of gap classes the de novo workflow must handle.
(This is the roadmap's standing clause fulfilled: the in-house extractor "IN-LINES repair instead of
post-hoc fixing; the membrane's audit log = the spec/corpus for it.") Membrane-compatible IR emission
remains as the **transitional** integration — pdfdig IR feeding today's membrane stages — while the
de novo workflow is built; the end state retires the post-hoc lane for pdfdig-converted material.

### The modality compartmentalization (why the oracle is structurally incapable of being a crutch)

*"I see," said the blind man, to his deaf son, as he picked up his hammer, and saw.* pdfdig is the
**blind father** — it operates the geometry modality (glyph, bbox, font, baseline) and holds the
hammer and saw; it cannot read a LaTeX token. mathdig — the symbolic sibling, of which today's LaTeX
oracle is the infant form (**baby mathdig**; it grows up into the `unique(mathjax ∪ katex)` AST) — is
the **deaf son**: it hears and speaks LaTeX, cannot see a glyph. Both perceive the *same authored
substrate* (equation (3) exists prior to either its PDF rendering or its LaTeX source) through
orthogonal, **non-interchangeable** senses.

The consequence is that **"distillation, not delegation" is structural, not disciplinary** — the
oracle *cannot* hand pdfdig an answer, because the answer is encoded in a modality pdfdig has no organ
to receive. Delegation isn't forbidden; it's impossible. What crosses the membrane between them is
only **alignment + verdict** ("we are both looking at equation (3)" · "we agree / we differ") — never
content, because content does not survive the modality boundary. That narrow channel IS the
conversion-metric aligner and the Tier-2 cross-derivation; the alignment is the shared referent, the
only thing both can point at without trading eyes for ears.

Two disciplines follow:

- **Distillation, not delegation (enforced by the above).** When oracle-graded evaluation exposes a
  systematic miss, the fix must be expressed in **PDF-intrinsic terms** — a font-role entry, a
  geometry rule, a threshold, a symbol mapping — added to the stores. The oracle teaches the engine to
  see with its own eyes; it structurally cannot see *for* it. A miss that can only be fixed by
  consulting the sidecar is a recorded limitation, not a workflow branch.
- **Beware calibration-set overfit.** The dual-availability corpus is ~all TeX-origin (pdfTeX
  producers, CM/AMS fonts) — the mission domain is not: Word/publisher pipelines (MathType, Cambria
  Math, OpenType math), InDesign, subset fonts with mangled names, scanned+OCR. The stores must carry
  an explicit **domain axis** (TeX-origin / office / publisher / scanned), unknown cues must degrade
  to *flags, never guesses* (unknown font ⇒ role unknown ⇒ flagged), and coverage growth outside
  TeX-land comes from corpus evidence the oracle cannot supply.
- **Oracle-free health metrics are the deployed confidence signal.** The engine's self-computed
  boundary IS the metric that survives leaving the calibration set: fraction of glyphs with
  known-font-role, fraction of lines confidently ordered, flags per page, store-miss counts. These
  ride in the IR header and the membrane surveys — no sidecar required.

### The development loop (oracle as teacher — offline, source-level, time-boxed)

Distinct from the *ingestion-time* consensus role: at **development time** the oracle is pdfdig's
teacher. Each pdfdig iteration is graded by the conversion metric against the oracle; the per-unit
JSONL diff *between iterations* is the lesson plan (which units regressed/improved, not just a moved
number). The teaching lands ONLY as **source/store changes between iterations** — the teacher teaches
between classes, never whispers during the exam; nothing the oracle says enters a deployed conversion.

- **The teacher's own soundness is a precondition, floored by an independent gate.** The oracle is
  authoritative for *what the math says* (it is the source) but fallible in *how it converted* (this
  session found three converter bugs). The floor under its authority is **KaTeX render-validity** —
  objective, referencing neither pdfdig nor intent.
- **Detection is symmetric even though authority is asymmetric.** A pdfdig↔oracle disagreement is a
  flag for investigation, not an automatic pdfdig-loss. When the oracle is the wrong one, that is
  *also* a finding — it improves baby mathdig. The same cross-derivation that teaches pdfdig to see
  teaches mathdig to speak: **co-maturation**, bidirectional teaching over a shared referent.
- **Graduation criterion.** The teacher leaves when it stops finding new bug *classes* (diminishing
  returns on the sidecar-having subset), and the deployed confidence signal is by then the oracle-free
  health metrics. pdfdig is trained on the sidecar minority precisely to perform on the sidecar-less
  ocean; graduation = both populations report conversion health in the same vocabulary.

### The workflow ladder (every rung's output distinguishable by provenance)

1. **Deterministic extraction** (pdfdig engine): geometry + store-driven mapping; solves the large
   certain majority and *computes its own boundary*.
2. **Gated model proposals** (membrane machinery): flagged residue → dispatch → agent `propose_*` →
   gates → `apply` with audit. Models are allowed — *behind* the gate, on the residue, never in front
   of the extraction.
3. **Human review** (`request_review`): the rare terminal escalation.
0. *(when present)* **LaTeX sidecar**: consensus companion + repair assist (`get_oracle`) — enrichment
   of the above, never a prerequisite for it.

The design goal: **pdfdig preprocessing does the maximum automated legwork, robustly**, so the model
tier sees a short, well-flagged work-list rather than a conversion job.

## Rules as data — the config stores

No cue lives in code. Every mapping the engine consults is a JSON/JSONL store, in the doccer
inventory idiom (provenance-tagged entries, positive/negative examples, loader validation) — so
expanding coverage is a data edit with a test, never a code patch. The stores:

| Store | Contents | Seeds |
|---|---|---|
| `font-roles.jsonl` | font-name → role claims: math markers (`CMMI`,`CMSY`,`CMEX`,`MSBM`,`EUFM`,`RSFS`,`STIX`…), prose families, bold/italic face cues (heading/emphasis signals) | Extractor.cs's hardcoded `MathMarkers` array, generalized |
| `symbol-map.jsonl` | font-aware glyph→target corrections, per font + char: `{font_family, char, unicode, katex}` — the `CMSY k → ‖ / \|` class; target register is canonical KaTeX for math runs | the CMSY/CMMI/CMEX common-glyph seed table |
| `classify-config.json` | the numeric knobs: script size-ratio + baseline deltas, space-gap fraction, baseline tolerance, satellite-reattachment params, column-gutter detection params, display-math region rules, heading-tier rules | Extractor.cs's constants (`0.85`, `1.0`, `2.5`, `0.18`), made explicit and documented |
| `producer-map.jsonl` | Producer-string patterns → origin tags (`pdfTeX`, `XeTeX`, `LuaTeX`, word-processor families) driving TeX-origin behavior | the current three-substring check |

**The growth loop:** when the oracle-graded metric or the repair loop finds a systematic miss, the fix
lands as a store entry with provenance ("motivated by 2508.11646v1 p4, CMEX bracket glyphs") and
examples — reviewable, diffable, testable in isolation. This is `no-magic-string-structural-heuristics`
enforced by architecture: stores map *principled cues* (fonts, geometry, Unicode registers), never
content regexes.

**Shared across tiers:** `Markpig.Pdf` (the C# AST tier) consumes the SAME stores. Config-as-data
shrinks the two-implementation divergence surface to the algorithms; the golden fixtures then guard
only what remains.

## The IR contract (membrane-compatible, strictly richer)

A flat node stream (or shallow page→line tree) carrying the membrane's canonical fields — `page`,
`font`, `font size`, `bounding box`, `content`, `type` — so `project-ir.ps1`'s alias map ingests it
with a schema extension rather than a rewrite, PLUS the born-signals:

```
node { page, line_id, baseline_y, col, type(prose|math|heading-candidate|formula-block|figure|marker),
       content, font, font size, bbox, role, script(normal|sub|super), tex_origin, flags[] }
```

`flags[]` is the no-silent-failure channel: `fractured_math_span`, `suspect_reading_order`,
`unmapped_symbol`, `possible_table_region` — each one a dispatchable work-unit downstream.

## v1 must-haves (what "replacement" actually requires)

Ported semantics from `Extractor.cs` (line grouping, run classification, gap-spaces) are the floor,
not the bar. The gaps between the first dig and a usable converter, in priority order:

1. **Reading order / column detection — THE gap.** Baseline clustering across a two-column page
   merges the columns into one "line." Deterministic fix: per-page x-density histogram → gutter
   detection → column bands → group lines per band → emit bands in reading order. Two-column IEEE is
   the corpus norm; without this there is no replacement.
2. **All-pages iteration + document assembly** (first dig was single-page).
3. **Line grouping with satellite reattachment** — the footnote-superscript fracture found in recon
   (script Δ-threshold 1.0 vs baseline tolerance 2.5 ⇒ raised markers become their own "lines");
   second pass re-attaches small-glyph satellite lines to their host baseline.
4. **Font-tier heading candidates** — per-document size tiering over named fonts (title = unique max;
   section/subsection tiers below; bold-family detection). Emitted as `heading-candidate`, confirmed
   by the membrane (and by the skeleton oracle when source exists).
5. **Display-math regions** — math-role-dominant lines set off from prose (centered/indented,
   surrounded by whitespace) emit as `formula-block` nodes; inline math stays run-level. Best-effort
   1-D assembly with `$…$` seams; **fractures flagged, never smoothed**.
6. **Symbol correction via `symbol-map.jsonl`** — the `‖u‖→kuk` class: font-aware substitution from
   the store (CMSY/CMMI/CMEX core glyphs seeded, corpus-grown), applied at run emission. The full
   solution is the C# AST tier's; the store removes the worst of it now — and both tiers read it.
7. **Ligature expansion + NFKC at emission** — the target register is canonical markdown; `ﬁ→fi` at
   the source beats corpus sweeps later. (SMP round-trip stays non-negotiable.)
8. **Figures:** v1.0 = figure-region markers (image bboxes from PdfPig, placement in flow);
   v1.1 = pixel extraction to `{slug}/imageFileN.png` where PdfPig exposes decodable image data
   (DCT passthrough first, Flate→PNG next). The LaTeX lane's source-rendered SVGs already cover
   dual-availability papers.

## Deferred (and to WHERE)

- **2-D math structure** (fractions, matrices, aligned) — `Markpig.Pdf` AST tier + mathdig; the
  membrane's repair loop + LaTeX oracle carry math fidelity meanwhile.
- **Render-back verification** — AST tier (its falsifiability gate).
- **Tables** — v1 emits `possible_table_region` flags (ruled-line vector paths + grid-ish bbox
  lattices); serialization comes later. opendataloader's tables arrived shattered anyway — flagged
  honesty beats broken structure.
- **Full symbol-correction coverage** — the AST tier's font-aware layer; the seed table just de-fangs
  the common cases.

## The inflection point — where pdfdig leaves the render pipeline

The a priori wisdom exists, and it lives in renderers. A PDF viewer's pipeline is: parse COS objects →
document structure → **interpret the content stream** (execute the operator program, maintaining
graphics state) → **resolve glyphs** (font program + encoding + ToUnicode → positioned glyphs) →
collect paths/images → **rasterize**. That pipeline is **information-MONOTONE up to the display
list** — every stage adds determinism (references resolved, fonts decoded, positions computed) — and
**strictly LOSSY after it** (rasterization collapses vectors and identities into pixels). The
inflection point is therefore not vague: **pivot at the display list — the last fully-determined,
information-complete representation the render pipeline ever holds.**

That is exactly what PdfPig is: *a renderer truncated at the display list* — it runs the deterministic
front half (stages 1–5) and hands over Letters/paths/images as objects instead of painting them. That
is why it is the right bedrock, and it names the two lanes' relationship exactly: **the VLM lanes read
post-inflection** (pixels) and try to climb back up the lossy cliff; **pdfdig reads at the
inflection** and never descends it. Everything downstream of the pivot is *decompilation* — structure
the producer compiled away (reading order, words, math layout) is reconstructed from the evaluated
program. And for TeX-origin PDFs the decompilation is unusually well-posed, because the forward
compiler's rules are *published*: TeX's math layout algorithm (TeXbook Appendix G — the boxes-and-glue
placement rules for scripts, fractions, limits) is the known forward model the 2-D assembler inverts.

### A priori wisdom mines (catalog before re-deriving)

| Mine | What it already solved | Where it lands here |
|---|---|---|
| Renderers (MuPDF, pdfium, pdf.js, PDFBox) | stages 1–5; the display list itself | already embodied in the PdfPig fork |
| Text extractors atop renderers (`pdftotext -layout`, PDFBox `PDFTextStripper`, pdfminer.six, pdfplumber) | decades of reading-order / word-gap / line-grouping / **column-detection** / dehyphenation heuristics on wild PDFs | seed values + algorithms for `classify-config.json` and the column detector — mine before inventing |
| pdf.js text-layer | glyph→run assembly battle-tested at browser scale on the wild universe | run-coalescing edge cases |
| **MaxTract / the Birmingham line (Baker–Sexton–Sorge)** | deterministic born-digital PDF → symbol layout tree → LaTeX/MathML from font+position — the closest prior art to pdfdig's whole thesis | the 2-D math assembler's literature base (verify details when mining; cite into the specimen registry) |
| INFTY / math-OCR line (Suzuki et al.) | 2-D math structure from *scanned* material | the (deferred) scanned regime, someday |
| TeX itself (TeXbook Appendix G) | the forward model of math layout | the inversion target for TeX-origin 2-D assembly |

The rule: for every jungle problem, **catalog the prior art before deriving from scratch** — the store
entries it seeds get provenance like any specimen-motivated entry ("seeded from pdftotext -layout
gutter heuristic"), keeping borrowed wisdom as inspectable as home-grown.

## The PDF jungle — inductive development discipline

**There is no upfront design that survives the variety.** Not all PDFs are LaTeX-born; standards
proliferate; some carry struct trees, some carry *corrupted* struct trees; some are born digital, some
are scans wearing OCR'd text like a costume. It is impossible to know in advance how every case will
be handled. The method is inductive: **push forward one specimen at a time, catalog each specimen's
properties and challenges, amortize the knowledge into the design — knowing the next specimen may
violate what seemed like givens.** Robustness emerges over an uncertain number of trials. The
architecture's job is to make each trial cheap and each lesson permanent:

- **The specimen registry is a first-class artifact** (`specimens.jsonl`, config-as-data idiom):
  per-PDF record of producer, font families encountered, struct-tree presence/quality, encoding
  pathologies, what worked, what broke, which store entries it motivated. The registry IS the
  curriculum — and the docling-failure-modes brief + membrane-testing bed prove this method already
  works in this repo; pdfdig inherits a practiced discipline, not a hope.
- **The ratchet: every specimen becomes a permanent regression fixture.** When specimen N+1 violates
  a given, the fix must leave specimens 1..N green — the registry doubles as the regression suite,
  runs are cheap to re-execute (runstamped, SimHash-tripwired, per-unit-diffable). *Monotone corpus
  green* is the invariant that turns induction into accumulation instead of oscillation.
- **Givens are conjectures.** Every assumption the engine currently holds (baselines cluster into
  lines, columns have gutters, math lives in math fonts) is a conjecture awaiting its falsifying
  specimen. Assumptions therefore live where violation is *cheap to detect and localize*: as store
  entries and Tier-1-style invariants whose failure flags loudly, never as silent premises buried in
  control flow.
- **Struct trees are witnesses, never the primary.** The ghost-layer saga is the standing lesson:
  trusting a tagged/logical layer wholesale is how opendataloader manufactured 2,066 phantom headings.
  Where a struct tree exists, it enters as *one more fallible claim source* — cross-derived against
  geometry, agreement-scored, useful exactly to the degree it agrees; a corrupted tree is then
  *detected* rather than obeyed.
- **Scanned/OCR is a separate regime, flagged as such.** OCR coordinates are synthetic, OCR "fonts"
  are fabrications, and character identity itself is suspect — the font-role and script cues that
  power born-digital extraction are unreliable there. v1 scopes born-digital; a scanned specimen is
  *classified and flagged out-of-domain*, never silently mangled. The domain taxonomy grows from
  registry evidence, not from an upfront enum.

## Anti-divergence: two implementations, one semantics

The PS lane ports `Extractor.cs`'s classification semantics; `Markpig.Pdf` keeps evolving them. Two
codebases, one contract — held together by **shared golden fixtures**: the same PDF pages produce the
same classified runs (JSON-comparable) from both. When `Markpig.Pdf` matures, the PS lane MAY swap its
interior for the C# dll without changing its contract — the port is a stopgap-with-a-named-successor,
which is the roadmap's standing pattern (opendataloader was a stopgap without one).

## Acceptance (the conversion-metric's first real campaign)

1. **Oracle-graded:** on dual-availability papers, pdfdig-PS output scored by the conversion metric
   against the LaTeX oracle (math token fidelity, structure P/R, coverage).
2. **A/B vs opendataloader:** same papers, same metric — the replacement claim as a number, per lane
   (expect: structure/coverage parity or better immediately; math fidelity better on script/role;
   tables honestly flagged vs badly shattered).
3. **Membrane end-to-end:** preprocess → repair → finalize on pdfdig IR; heading counts vs the `.md`
   preview and (where available) the skeleton; the docling-failure-modes catalog re-run as a
   regression suite — none of those failure classes may reproduce.
4. **Golden cross-derivation** vs `Markpig.Pdf` on shared fixture pages.

## Open decisions

- **Node stream shape:** flat JSONL (membrane-native, `project-ir` almost free) vs page→line nested
  JSON (closer to pdfdig's PageNodes). Leaning flat-with-`line_id` — the membrane flattens anyway,
  and `line_id`/`col`/`baseline_y` preserve what nesting would have said.
- **Where conversions land:** beside the PDF as the raw `{slug}.json` (opendataloader's positional
  contract, regenerate-in-place with in-band versioning) vs runstamped conversion runs. Start
  in-place; revisit if engine iteration wants A/B runs of the *converter* itself.
- **PdfPig fork distribution:** vendored dlls in `tools/pdfdig/` vs NuGet restore from the private
  feed at setup. Vendored favors the portable-env philosophy.
- **Perf posture:** PS per-letter loops are fine for batch ingestion (papers/minute, not
  pages/second); if a hot spot emerges, the interior-swap escape hatch exists by design.
