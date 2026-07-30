---
format: Structural
exported_at: 2026-07-02T02:55:57.7471546Z
exchanges: 5
user_label: Aipithicus
sessions:
  - b7d823db
models:
  - claude-opus-4-8
exclude:
  - thinking
  - synthetic
  - timestamps
  - session-markers
  - exchange-markers
  - tool-calls
  - tool-results
  - subagents
---

# ok i did a run today with the membrane and documented some failure modes, lets dig into this D:\aghado01\codex-scientiae/issues/docling-failure-modes/bpcsr2024-zoning-tables-figure-debris.md

94.6% of geometric promotions (2066/2184) sit on the ghost layer; only 118 across 25 docs touch real named-font text. That makes the gate safe and surgical. Here's the full dig.

## What the data says vs. what the brief assumed

**The three code claims all check out** exactly as written: the References regex is duplicated at [zones.ps1:38](src/zones.ps1:38) and [finalize.ps1:62](src/finalize.ps1:62); `Format-Chunk` has no `table` case ([finalize.ps1:27](src/finalize.ps1:27)); the crumb gate is shape-only ([normalize.ps1:287](src/normalize.ps1:287)). No surprises there.

But inspecting BPCSR2024's actual chunk stream **refutes the brief's headline fix and reveals the four failures share one root.**

### The brief's proposed zoning fix ("use Docling's `level`") does not survive contact with the data

Docling's `level` is scrambled, not hierarchical:

| Real tier | font_size | Docling `level` emitted |
|---|---|---|
| Title (id0) | 23.91 (unique max) | Doctitle |
| Sections I–V, References | 7.97 | **mixed** — "II. Preliminaries"=Doctitle, "I. Introduction"=Subtitle |
| Subsections A./B./C. | 9.96 | **mixed** — "B."/"C."/"E."/"G." also tagged Doctitle |

There are **6 Doctitles**. "The Nth Doctitle opens the body" would select *II. Preliminaries* and **skip the Introduction**. That structural signal is unusable as proposed. The brief's *principle* (read structure, not text) is right; the specific structural field it named is not.

### The real mechanism: one ghost layer feeds three of the four failures

The spurious "headings" (Category, Problem, PPCSR, F-Graph) share a signature that the real headings never have:

- **Real headings**: named font `NimbusRomNo9L-Regu`, Docling-native typing.
- **Spurious headings**: `font = null`, `size = 12.0`, **`heading_source: geometric`** — i.e. **the membrane's own geometric promoter manufactured them** from a metadata-less duplicate text layer. All 23 geometric-promoted headings in BPCSR2024 are ghost-layer chunks — a *perfect* correlation.

So Failure 5's "ghost layer" isn't a peripheral open question to characterize later — **it's the substrate.** The geometric promoter turns it into false headings (feeding Failure 1's noise and stealing Table-I's header cells from Failure 3), and it leaks as figure-label debris (Failure 4). One root, four symptoms.

**Important correction to Failure 5:** the ghost layer is **not droppable as duplication.** In the reference list, entries *alternate* source — [1],[5] come from the named-font stream, [2],[3],[4],[6]–[11] come *only* from the null/12.0 layer. Deleting the ghost layer would delete real references. The fix has to be surgical, keyed on *provenance + geometry*, not deletion.

## Corpus survey — sizing each mode across all 43 preprocessed docs

| Failure mode | fingerprint | docs hit | corpus volume |
|---|---|---|---|
| **F3 — table shatter** | `type:table cell` present | **27 / 43** | **8,076 cells** |
| **F5 — ghost layer** | `font=null & size=12` | **41 / 43** | **5,021 chunks** |
| **F1-noise — geometric over-promotion** | `heading_source:geometric` | **36 / 43** | **2,184 headings** (94.6% on ghost) |
| **F1-acute — Roman-numeral zoning collapse** | body-zone == 0 chunks | **3 / 43** | BPCSR2024, 2508.11646v1, 2310.08970v2 |

This **re-orders the brief's priorities.** The Roman-numeral collapse it opens with is the *narrowest* mode (3 docs). The ghost layer it files last as "open, characterize later" is the *most systemic* (41 docs). And the table serializer is by far the biggest content-recovery win (8k cells, 27 docs).

*(A secondary signal worth a later look: a few large docs — 2408.06958v3 at 4% body, 1606.04970v3 at 3% — aren't fully stuck but have suspiciously low body-zone %, hinting at a milder non-Roman zoning failure. Not chased here.)*

## Answers to the brief's open questions

1. **Zoning — structure vs. widen-regex?** Neither as framed. Docling's `level` is scrambled (shown above), so the structural replacement should key on **font-tier clustering among named-font headings** (per-paper relative), *after* the ghost promoter is gated. Until then, yes to the stopgap regex — but it needs three fixes, not one: Roman numerals, the injected drop-cap space (`I. I NTRODUCTION`), and `R EFERENCES`. Cheap, unblocks exactly 3 docs.

2. **Failure 2 (dup regex) → finalize reads the zone?** Yes, unconditionally correct. Single source of truth regardless of what replaces the detector.

3. **Failure 3 (table serializer) build now?** Yes — highest ROI (8,076 cells / 27 docs), lowest risk. **One coupling to respect:** the geometric promoter *steals table header cells* into headings (Table-I's "Category"/"Problem" became ghost headings), so gate the promoter *first* or the serializer emits headerless tables.

4. **Failure 4 (bbox containment reliable?)** Data-wise yes — bbox present on 94% of chunks. But note font-provenance and geometry do **different** jobs: `font=null/12.0` identifies the ghost layer; **bbox-in-image** tells you *which* ghost chunks are figure-debris (vs. real references, which are also ghost). You need both — font alone over-drops.

5. **Failure 5 root-cause / systemic?** Now answered: systemic (41/43), and the mechanism is null-font-metadata content the geometric promoter and crumb filter can't distinguish from real text. The dual-font-layer is real but manifests as per-entry source inconsistency, not wholesale duplication.

## The single highest-leverage fix the survey surfaced

**Gate geometric heading-promotion on the ghost signature** (suppress when `font == null`). This removes 2,066 false headings corpus-wide (94.6% of all geometric promotions), preserves the 118 named-font ones that might be legitimate, and is a *principled typographic* gate — "a heading is set in a real font" — exactly what `no-magic-string-structural-heuristics` prescribes. It simultaneously cleans F1-noise, un-steals F3's headers, and removes the figure-debris-as-headings slice of F4. It also directly advances the `ingestion-heading-overpromotion` thread.

**Data-supported priority order:** (1) gate the geometric promoter [systemic root, low risk], (2) table serializer [biggest content win], (3) finalize-reads-zone [F2, trivial correctness], (4) Roman-numeral stopgap [3 acute docs], (5) bbox-containment for residual figure-prose [F4].

---

Survey data is saved at `%TEMP%\bpcsr_survey.json` if you want the per-doc numbers.

Want me to **fold this into the brief** (it materially revises Failures 1 and 5 and re-sizes the priorities) and **update the `docling-failure-modes-brief` memory** (which currently says "survey-first, discussion pending")? Or keep digging — e.g. confirm whether the stolen table headers also exist as `table cell` (dual representation), or characterize that low-body-% secondary zoning signal?

---

# lets fold into brief, but i think its worth looking at the raw docling markdown output and comparing that with what we see in the IR, might shed some light on these questions

Done — the grounding pass is folded into all three places:

- **The brief** ([bpcsr2024-zoning-tables-figure-debris.md](issues/docling-failure-modes/bpcsr2024-zoning-tables-figure-debris.md)): status line updated + a new **"Grounding pass"** section with the attribution correction, the shared-root mechanism, the source-vs-IR table, the corpus survey, and point-by-point resolutions of the original open questions. The original characterization is preserved as-written.
- **The `docling-failure-modes-brief` memory** + **MEMORY.md index** — updated from "discussion pending, survey-first" to the grounded conclusion.

**The one-paragraph version of what the raw-markdown comparison bought us:** it turned four loosely-related failures into one root with a clear owner. Comparing `BPCSR2024.md` (the converter's own export) against the IR showed the converter emits **22 headings and clean `|Category|Problem|` pipe tables** — and the membrane turns that into **45 headings (23 phantom) and 235 shattered cells.** So Failures 1-noise and 3 are the membrane *destroying* correct structure, not the converter being broken. The `.json` inspection then handed us the exact discriminator the membrane is ignoring: the ghost layer is the tagged-PDF ActualText layer with a clean **`font=null ∧ size=12 ∧ color=null`** signature (`pdfua_tag` is uniformly `"P"`, so it's *not* the tell — I checked). And it corrected the brief on two counts: the converter is **opendataloader-pdf**, not raw Docling, and Docling's `level` is too scrambled to base zoning on.

**What's left is a build decision, not more analysis.** The data-supported #1 is gating the geometric promoter on `font!=null` — one surgical change, kills 2,066 phantom headings corpus-wide, and it's a prerequisite for a clean table serializer (#2). 

Do you want me to **scope/implement the promoter gate** (find the geometric-promotion code path, add the `font!=null` guard, verify against BPCSR2024 + the 2 other Roman-numeral docs), keep this as characterization for now, or chip the table serializer off as a separate follow-up task?

---

# well for further investigation, i have the opendataloader-pdf source code here "D:\aghado01\packages\opendataloader-pdf" , its a bit of a beast but the through line is the java triage and whatever path leads to the json IR + plus the capabilities it exposes with docling backend when the hybrid server is running. my conversions toggle hybrid_mode = "full" which i do for consistency in the docling outputs. im suspecting that a more complete membrane doesn't ignore docling's output and incorporates some tools for comparing pieces of the docling output against the IR. This kind of consensus strategy is how i was donig it before I was incorrectly advised with extremely (false) confidence that we only needed the IR. I still suspect that you are making your conclusions based on tunnel vision and perhaps missing root causes. lets dig into opendataloader-pdf's internals and then scope the geometric-promotion idea

**Verified.** The arithmetic is exactly as predicted — this is now a confirmed root cause, not a hypothesis:

- Real body text (named-font prose): modal size **10pt**, weight 25,305 — utterly dominant.
- Docling-unenriched prose: **all exactly 12.0pt**, single bucket.
- Gate threshold: 10 × 1.15 = **11.50pt**. Placeholder 12.0 ≥ 11.50 → **True**.

Every short, letter-bearing, Docling-unenriched element trips `$bigger`. The 2,066 phantom headings corpus-wide are **an arithmetic collision between one converter's hardcoded placeholder (12.0) and the real body size (~10pt)** — nothing to do with tagged-PDF layers.

## I had it wrong — here's the correction

My earlier "ghost layer = tagged-PDF ActualText" root cause was **wrong**, and you were right to push. The chain, from the actual code:

1. `hybrid-mode full` → **all** pages to Docling (`HybridDocumentProcessor` line 273).
2. Docling elements built with hardcoded `font=null, size=12.0` (`DoclingSchemaTransformer` lines 314/332).
3. `enrichBackendResults`/`enrichSingleTextNode` (lines 1171–1236) swaps in real Java `TextChunk`s (fonts + `StreamInfo`) **where a bbox-overlapping, not-yet-consumed Java chunk exists** (`usedJavaIndices`, line 1189).
4. **`font=null` survivors = Docling elements that lost the enrichment match** — no overlapping Java chunk. Recorded internally as `"ocr-fallback"` (line 1205).

So `font=null` is a **fusion-seam provenance marker** ("Docling saw this; the geometric layer didn't"), often the *better* extraction (the cleanly-split references were the `font=null` ones). Filtering it out — my original instinct — discards exactly Docling's unique contribution. The `12.0` placeholder is the incidental detail that makes the membrane's promoter *also* misfire on those same elements.

And crucially: opendataloader **computes** the provenance (`recordTextSource` → `stream`/`ocr`/`ocr-fallback` in `ElementMetadata`) but **does not serialize it** to the default JSON. The membrane is flying blind with only `font=null` as a proxy — which is the core of your consensus point.

## Scoping the geometric-promotion fix

**Tier 1 — stop the harm (membrane, `headings.ps1`, one guard):**

Add to the top of the promotion loop (after line 78):
```powershell
if (-not $n.font) { continue }   # no real font ⇒ Docling placeholder (size=12.0), not measured typography
```
Justification is now *correct and principled*, matching the file's own docstring ("typography is the ground truth here"): a `font=null` node has **no measured typography** — its 12.0 is a converter placeholder, so the size-ratio premise is void. `$face` already can't fire on null font (line 28), so this only removes the `$bigger` false-positives.

**Safety (why this loses nothing real):**
- The promoter only touches `type=paragraph` nodes (line 78). Docling's *real* headings are already `type=heading` (`section_header` → `SemanticHeading`), so they're **untouched by the gate regardless**.
- Real headings sit in the text flow where Java chunks exist → they get enriched → `font=named` → gate passes anyway.
- Keeps the 118 named-font promotions (real typographic signal); kills the 2,066 placeholder-driven ones.

**Tier 2 — capture the value (your consensus architecture):** the gate stops harm but ignores Docling's correct structure. The real fix is provenance-aware consensus, and there's a clean lever:
- **Cheapest, highest-leverage: make opendataloader serialize the provenance it already computes.** Add `source`/`text_source` to the JSON serializer (it's in `ElementMetadata` already). Then the membrane has a real "Docling-sourced vs stream-sourced" flag instead of the `font=null` proxy — enabling consensus decisions everywhere: trust Docling's structure/reading-order for backend elements, apply geometric heuristics only to stream elements, and use Docling's table grid (which its own markdown renders correctly) instead of the shattered cells.

This reframes the whole brief: the membrane shouldn't *ignore* Docling and re-derive structure geometrically — it should **reconcile** the two views, which is exactly how you were doing it before the "IR-only" advice.

---

Two decisions for you:

1. **Tier-1 gate now?** I can make the one-line `headings.ps1` change and re-verify against BPCSR2024 + the 2 other Roman-numeral docs. (Membrane-side, low risk, PowerShell — not a dotnet delegation case.)
2. **Tier-2 provenance-emit:** worth me digging into opendataloader's JSON serializer (`SerializerUtil`/`JsonWriter`) to scope emitting `text_source` into the `kids` output? That's the enabler for real consensus and it's a Java change you'd likely route to Copilot — I'd write the scope/spec.

And I should **correct the brief** — the folded-in "tagged-PDF ActualText" attribution is now wrong. Want me to fix that in the same pass?

---

# im not talking about modifying opendataloader. I'm pointing you to it to understand how the code works so that we have a clearer idea of the failure modes. opendataloader-pdf is what gets us to PDF->markdown+json IR using the docling backend of opendataloader-pdf.  the membrane is what takes us post-docling to final polished markdowns. no where at any point did i say we are going to modify opendataloader-pdf. im just mining from insights

Got it — clear correction, and it lands. opendataloader-pdf is **fixed upstream**: PDF → (markdown + JSON IR) via its Docling backend. The **membrane is the only thing we touch**, post-Docling → polished markdown. The opendataloader dig was to understand the failure modes, not to change it. So scratch my "make opendataloader emit provenance" idea — that's an upstream modification, off the table.

Re-casting everything membrane-side with that constraint:

**The signals the membrane has to work with are exactly what opendataloader already writes per doc** — nothing more:
- `BPCSR2024.json` — the geometry-rich `kids` IR (what the membrane consumes today).
- `BPCSR2024.md` — opendataloader's own markdown (Docling's structural rendering: the correct pipe tables, exactly the 22 real headings, reading order).
- Within the JSON, `font=null ∧ size=12.0` is a **stable, understood proxy** for "Docling-sourced, enrichment-unmatched." We can't rename it, but now we know *why* it's reliable, so the membrane can trust it.

**Tier 1 (the geometric-promotion fix) is unchanged by your correction** — it was already pure membrane. The `headings.ps1` guard `if (-not $n.font) { continue }` stands: it keys on the `font=null` proxy opendataloader already emits, and the verified 12.0-vs-10pt arithmetic is the justification. Nothing about it depended on touching opendataloader.

**Tier 2 (consensus) — re-read correctly, this is what you were describing all along:** the "two views to compare" are **both opendataloader artifacts already sitting on disk** — its `.md` (structure: headings, tables, reading order) and its `.json` (geometry: font, bbox, sizes for math/scripts). The membrane reads only the JSON and re-derives structure geometrically (shattering tables the `.md` got right, promoting headings the `.md` doesn't contain). The consensus membrane **ingests the `.md` as a second view and reconciles**: markdown for *structure*, JSON for *geometry* — neither is complete alone, which is precisely why you were doing consensus before the "IR-only" advice steered you off it. The `font=null` proxy and the `.md` heading/table set are two independent checks on the same over-promotion/shatter defects.

So the corrected failure-mode framing is simply: **the membrane discards half of what opendataloader already produced (the markdown) and then mis-reconstructs it from the JSON alone.**

Two next steps, both membrane-only:

1. **Implement the Tier-1 `headings.ps1` gate now** and re-verify against BPCSR2024 + the 2 other Roman-numeral docs.
2. **Scope Tier-2 concretely** — read `src/project-ir.ps1` (the intake) to find where the `.md` view plugs in for heading/table reconciliation.

Want me to do the Tier-1 change, look at the intake for Tier-2, or both? And I still owe the brief a correction — the folded-in "tagged-PDF ActualText" root cause is now superseded by the verified placeholder-12.0 mechanism.

---

# lets do tier 1 and then follow up with tier-2 scoping

Intake fully mapped. `preprocess.ps1` runs an 8-stage on-ramp — `project-ir → headings → collapse → zones → sections → normalize → fidelity → repair` — entirely off the **JSON**. The `.md` sibling (`$slug.md`, right next to `$slug.json`) is available at every stage but never read. That's the whole Tier-2 opening.

## Tier-2 scope: reconcile opendataloader's `.md` against the JSON IR

**The intake defect, precisely:** `project-ir.ps1`'s `Add-IrNodes` recursively flattens **every** typed node into one ordered list — a `table` node, its `table row`s, and its `table cell`s all become sibling flat records. Containment is destroyed at the very first stage, so nothing downstream can reassemble the grid (→ the 8,076-cell shatter). Meanwhile the `.md` carries that grid already assembled.

**The `.md` as an oracle — it's selectively authoritative** (from what we verified):

| Structure | `.md` quality | Use as oracle? |
|---|---|---|
| Headings | exactly Docling's `section_header` set (22, correct) | **Yes** — independent check on heading nodes |
| Tables | clean pipe grids | **Yes** — the assembled structure the IR lost |
| References | both layers, run-together | **No** — IR/geometry is no worse |
| Math / sub-superscript / fonts | absent (markdown drops geometry) | **No** — JSON is the only source |

So it's genuinely **consensus, not replacement**: `.md` for *structure* (headings, tables), JSON for *geometry* (math, scripts, placement). Neither alone is complete — which is the architecture you had before the "IR-only" advice.

**The crux is alignment** — mapping an `.md` block to its IR node(s). Three signals are available and mutually reinforcing: the `.md`'s `[Page N]` markers ↔ the node `page` field; document reading-order (both are ordered); and normalized content-string matching (`.md` heading text ↔ node `content`). This is the part worth de-risking before anything mutating touches it.

**Phased design:**

- **Phase 1 — `Compare-MarkdownIR`, a read-only audit tool** (this is literally your "tools for comparing pieces of the docling output against the IR"). Parse `.md` → structural skeleton (headings, tables, page markers); parse the chunk stream → the same skeleton; diff them. Output: headings in IR-not-`.md` (over-promotion suspects), headings in `.md`-not-IR (missed), and `.md` tables sitting where the IR has loose cells (shatter sites). Zero mutation, immediately useful as QA, doubles as the **regression check for the Tier-1 fix** (heading count should now equal the `.md`'s), and it validates the alignment logic before Phase 2 depends on it.
- **Phase 2 — consumption.** (a) Table serializer emits from the aligned `.md` pipe grid (solves Failure 3 using Docling's own correct rendering, JSON supplies bbox/page for placement). (b) `.md` heading set as a second, independent guard on the intake — belt-and-suspenders with the Tier-1 font gate.

**Decisions for you:**
1. **Phase 1 first, or straight to the table serializer (Phase 2a)?** I'd do Phase 1 — de-risks alignment, and it's the "comparison tool" you described.
2. **Where does it live** — a new `src/md-ir-reconcile.ps1` (surfaced via an MCP tool + a survey mode), or fold the survey side into the existing `corpus-audit.ps1`?
3. **Tables:** consume the `.md` pipe grid (simple, Docling already solved it) vs. reassemble from the flat JSON cells via bbox (the brief's original geometry-native idea, harder). The `.md` route now looks clearly better.

One loose end I still owe: the **brief correction**. The folded-in "tagged-PDF ActualText layer" root cause is now superseded — I should replace it with the verified chain (hybrid `full` → Docling placeholder 12.0 → enrichment bbox-match seam → the `headings.ps1` ratio misfire), and record that the Tier-1 gate landed + verified. Want me to fix the brief now, or bundle it once we've picked a Phase-1 direction?
