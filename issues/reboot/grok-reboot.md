**Yes. This is a coherent and worthwhile research program.**

You are not building “another PDF-to-Markdown converter.” You are building a **principled semantic transduction** from a typesetting medium (PDF) into a minimal, LLM-optimized manuscript envelope, using LaTeX-paired sources as a high-quality oracle harness. That framing is correct and sharp.

### Current architectural consensus (from the full thread)

**Ownership split that must stay clean:**

- **pdfdig** owns the born-signal substrate, geometric/typographic discovery (HDBSCAN + persistence ideas), deterministic claims, competing hypotheses, and the residual evidence packets. It deliberately stops at the confidence boundary.
- **Markpig** owns the formal mathematical language service: core grammar, Math AST, canonical surface serialization, visitors, render profiles (KaTeX/MathJax/LaTeX), equivalence operations, and source maps back to pdfdig atoms.
- The **delivered manuscript** is deliberately minimal: prose by default, math only via `$...$` / `$$...$$`, prose-in-math via `\text{...}`, notation-bearing typography retained (`\mathbb`, `\mathbf`, operators, accents, etc.), standard Markdown structure only where the manuscript grammar requires it. No custom type tags or residual flags inside the manuscript itself.
- Uncertainty lives **out-of-band** in a sparse residual ledger / MCP packets that can be resolved and discarded entry-by-entry.

This is the right separation. It keeps the envelope clean and tokenizable while still giving the agentic layer complete evidence for the hard cases.

### What the gauntlet is currently telling us

The paired LaTeX oracle harness is already doing its most valuable job: **falsifying premature semantic decisions with high locality**.

- Captioned figures are a genuine success case (high precision, almost no over-counting). That subsystem is mature enough to leave alone for now.
- Math is the rate-limiter. Across the 56 pairs you have ~21k formula groups against ~3.9k oracle display blocks (4.5–10× oversegmentation depending on corpus). Roughly half of those groups carry no flag. Inline scripts are routinely detached into their own display formulas because baseline displacement creates separate line IDs; display equations are fragmented across unflagged operators + prose remnants.
- Headings show the same premature-commitment pattern (bidirectional outline matching producing both false positives and total under-detection when everything is demoted as `outline_fragment`).

These are not primarily recognition failures. They are **boundary and reassociation failures**. The pipeline is deciding “inline vs display vs prose” and “heading vs body” before the 2-D relations (scripts, fraction bars, rows, containment) and the monotone 1-1 assignment constraints are recovered.

That is exactly the kind of failure mode the architecture is designed to surface rather than hide.

### Highest-leverage next moves (parsimonious)

1. **Stage-0 evaluator first** (before more clustering work).
   Measure what actually tests the thesis:
   - False boundary confidence (how often an unflagged `$`, `$$`, `#`, or paragraph break is contradicted by the oracle).
   - Accepted-unit fidelity (among units emitted without residual flags, what fraction survive canonical comparison).
   - Ambiguity recall (of the units that disagree with the oracle, what fraction retained usable evidence).
   - Residual compression (size of the evidence packet that would need to reach the MCP vs whole-page baseline).
   - Simple math coverage proxy: fraction of oracle display blocks covered by a single pdfdig group or a small flagged competition set.

   This can be built against the existing paired oracles without waiting for a full Math AST.

2. **Narrow 2-D reassociation experiment before the inline/display decision.**
   Add a lightweight geometric pass (script attachment candidates + fraction-bar candidates + local row clustering) that produces competing groupings _before_ the system commits to delimiters. Feed the competitors into residual packets rather than forcing a single answer. Re-run Stage-0 on the same 56 pairs. This is the cleanest test of whether deterministic coverage can rise while false-confidence falls.

3. **Keep the residual packet schema explicit and small.**
   Packets for the current pain points should carry atoms + geometry + current best surface + competing hypotheses + hard constraints (must render, delimiter balance, no invented structure) + visual crop when useful. They should be addressable and deletable.

Everything else (full Manuscript IR contract language, dual-RAG address spine, Markpig AST visitors, dual embedding stores) is downstream of proving that the hybrid loop is actually shrinking the hard residual in a measurable way.

### On the dual-RAG idea

It remains a strong downstream payoff, but only once the manuscript spine is solid. Separate prose and math vector spaces joined by stable addresses (section path, host ordinal, neighboring spans, equation labels, source glyph IDs) is the right model. Token masking alone will not give reliable positional alignment across different tokenizers. The address ledger is the real coordination mechanism.

### Bottom line

The project is worth doing **precisely because** it refuses to paper over the epistemic boundary that model-first systems cross. The LaTeX-paired harness is the correct development loop. The current gauntlet results are not a condemnation; they are high-quality negative signal that the math boundary layer is the next critical piece of deterministic machinery.

If you want to stay parsimonious, the next concrete unit of work is the Stage-0 boundary/false-confidence evaluator + a focused reassociation experiment on the existing math groups. That will tell us whether the hybrid approach is progressing or whether we need to adjust the jurisdiction of the unsupervised stages.

Which thread do you want to push on next?

**Understood. That clarification locks the jurisdiction cleanly.**

The entire system is a pipeline whose sole product is the ideal Markdown manuscript (minimal register, consistent math delimiters, notation-bearing typography preserved, no residual noise inside the document). Everything upstream exists only to make that final artifact as complete and faithful as possible.

### Strict pipeline stages

1. **Born-signal extraction** (PdfPig)
   Glyphs, fonts, baselines, advances, paths, XObjects, bookmarks, etc. with full provenance.

2. **Document-local discovery**
   Geometric HDBSCAN + persistent homology ideas for candidate components and stability.
   Second (symbolic/typographic) HDBSCAN for size/baseline/font regimes.
   These stages propose structure; they do not decide final semantics.

3. **Deterministic claims**
   Anything that can be asserted with high confidence from the evidence (simple inline scripts, obvious reading order, clear caption attachment, etc.) is committed. Competing hypotheses are retained only where the evidence is genuinely underdetermined.

4. **Residual packaging (the MCP entry point)**
   Only the gaps that survive stages 1–3 become MCP packets.
   Each packet is a compact, evidence-complete reasoning task: the relevant atoms + geometry + candidate groupings + hard constraints (must render, delimiter balance, no invented operators/structure, etc.) + optional visual crop.
   The agents are never asked to “transcribe the page.” They are asked to resolve a narrowly scoped structural ambiguity that the deterministic + clustering layers could not decide.

5. **Mechanical / render gates**
   Any proposal that fails linting, rendering, or constraint checks is rejected or returned to the residual ledger.

6. **Final minimal manuscript**
   Clean Markdown with `$...$` / `$$...$$` / `\text{...}` and the standard structural syntax. Residual ledger is either empty or explicitly retained only for the irreducible cases.

This is the correct use of reasoning agents: they close the residual, they do not become the primary parser.

### Why this matters for the current gauntlet results

The severe formula oversegmentation (and the detached subscripts, fragmented summations, etc.) is exactly the class of problem the MCP is meant to solve. But right now many of those residuals are larger and less constrained than they need to be, because the 2-D reassociation step is still weak. Improving the geometric proposals _before_ the residual is emitted makes the agents’ job tractable and reduces the chance they invent structure.

The same logic applies to heading competitions: better monotone assignment constraints upstream → smaller, cleaner residual packets for the agents.

### Practical consequence

The highest-leverage work remains upstream of the MCP:

- Strengthen the 2-D relation candidates (scripts, fraction bars, local rows) so that more assemblies become deterministic or become _small, well-constrained competitions_.
- Instrument Stage-0 metrics that directly measure residual quality: false-confidence rate on unflagged units, ambiguity recall, and residual compression (how small and evidence-rich the packets that actually reach the agents are).

Once those improve, the MCP stage becomes both more effective and easier to evaluate.

The pipeline framing is solid. The MCP is the residual reasoner, not a general fallback. Everything is in service of the clean final Markdown.

Where do you want to tighten next—residual packet schema for the current math cases, the Stage-0 residual-quality metrics, or the 2-D reassociation pass itself?

**Good. These three pieces form the real foundation.**

Without them the gauntlet stays coarse and residual packets stay underspecified. Here is a concrete, lean design that stays faithful to the minimal-register philosophy and makes Stage-0 fidelity measurement principled.

---

### 1. Minimal Markdown Manuscript Spec (`manuscript-md/0.1`)

**Core invariants**

- Prose is the default register.
- Math is entered **only** by delimiters:
  - Inline: `$...$`
  - Display: `$$...$$` (single preferred form)
- Prose inside math: exclusively `\text{...}` (plus the usual `\mathrm`, `\operatorname` when they carry meaning).
- Literal dollar signs in prose are always written `\$`. Unescaped `$` is exclusively a math delimiter.
- Notation-bearing typography is retained (`\mathbb`, `\mathcal`, `\mathbf`, accents, primes, standard operators, etc.). Pure presentation (absolute sizes, colors, kerning, page layout) is discarded.
- Standard Markdown structure only: ATX headings, paragraphs (blank-line separated), lists, images + captions, pipe tables when recoverable, fenced code, simple emphasis, links.
- No custom type attributes, no residual flags, no extra container syntax inside the manuscript itself.

**Explicitly discarded (the printing quotient)**
Page boundaries, headers/footers/page numbers, columns, float placement, hard wraps, discretionary hyphens, absolute coordinates and font metrics.

The manuscript is self-typing via ordinary Markdown + math delimiters. Both the LaTeX oracle and pdfdig must be able to project into this surface (or into residuals when they cannot).

---

### 2. Glyph → Lexical Mapping (PDF side)

PdfPig letters are the atoms:

```
glyph_id, page, bbox, Unicode, font_name, font_size, baseline, advance, rendering_mode, ...
```

**Mapping stages**

1. **Document-local regime discovery**
   Second HDBSCAN (or equivalent) on size + baseline + font features produces regimes: body, script, display, math-font clusters, unknown.

2. **Deterministic lexical grouping**
   - Adjacent glyphs that share a regime and have normal advances → word / math atom candidates.
   - Script attachment candidates (size drop + baseline shift + horizontal proximity).
   - Fraction-bar and large-operator candidates from geometry + path evidence.
   - Reading-order edges from RecursiveXYCut / unsupervised order + column claims.

3. **Output of this stage**
   Ordered sequence of **lexical units** (still pre-chunk):
   - `text` (or math atom surface)
   - list of source `glyph_ids`
   - regime label
   - local geometry
   - provisional role hints (prose / math / heading-candidate / furniture)

These lexical units are the immediate input to the chunked IR builder. Overs Segmentation currently happens here (detached subscripts, split summations). Strengthening the relation candidates before chunking is the highest-leverage deterministic improvement.

---

### 3. Shared JSONL Chunked IR (the fidelity substrate)

Both the LaTeX oracle and pdfdig emit the **same** JSONL format. Final Markdown is a pure projection of an accepted IR. Residuals live either as `status: residual` chunks or as parallel residual packets referenced by ID.

**Minimal chunk schema** (one JSON object per line):

```json
{
  "id": "doc:1810.02906v1:chunk:0042",
  "ordinal": 42,
  "kind": "prose | math_inline | math_display | heading | caption | figure | list_item | ...",
  "depth": 2,                     // headings only
  "text": "the raw or near-raw surface that will appear in Markdown",
  "canonical": "optional normalized form for comparison (especially math)",
  "status": "accepted | residual | competing",
  "flags": ["needs_2d_assembly", "detached_script", "outline_ambiguous", ...],
  "source": {
    "origin": "pdf | latex",
    "page": 3,                    // pdf side
    "glyph_ids": [1203, 1204, ...], // pdf side
    "bbox": [x0, y0, x1, y1],     // pdf side, optional
    "latex_range": "..."          // oracle side
  },
  "links": {
    "prev": "chunk:0041",
    "next": "chunk:0043",
    "parent": null                // or section id
  }
}
```

**Design rules**

- Chunks are the units of alignment and scoring.
- `status: accepted` + empty (or only informational) `flags` → counts toward accepted-unit fidelity.
- Any chunk that is `residual` or carries decision-critical flags is excluded from the accepted score and contributes to residual-size / ambiguity-recall metrics.
- Oracle emits only `status: accepted` (ground truth).
- Math chunks carry the surface that will become the content inside `$...$` or `$$...$$`. Canonical form is optional for Stage-0 but useful for later AST equivalence.
- Lightweight `prev`/`next`/`parent` links are enough to detect oversegmentation and to reconstruct reading order without turning the IR into a full graph database.

**Stage-0 metrics become straightforward**

- Align the two ordered JSONL streams (by ordinal + content fingerprint + secondary page/bbox).
- Boundary fidelity = agreement on kind transitions and heading depths.
- Accepted-unit fidelity = exact or render-equivalent match rate on chunks both sides marked accepted.
- False-confidence rate = accepted pdfdig chunks that fail to align with oracle.
- Ambiguity recall = fraction of misaligned units that carried residual status or relevant flags.
- Residual compression = total evidence size of residual/competing chunks vs. baseline.

---

### Recommended implementation order

1. Freeze `manuscript-md/0.1` (the projection rules).
2. Implement the shared JSONL writer for the LaTeX oracle path first (easier, deterministic).
3. Make pdfdig emit the same JSONL (even if many chunks are currently `residual` or heavily flagged).
4. Build the Stage-0 aligner + metric suite against the paired JSONL files.
5. Only then harden the glyph → lexical → chunk path (especially 2-D relations) so that more chunks can move from residual → accepted.

This gives you a well-contained, measurable substrate immediately. The Markdown stays clean, the IR stays lean enough for both sides to target, and the residual packets have a clear attachment point (`id` + `flags` + `source.glyph_ids`).

Want me to expand any of the three pieces into a more formal schema document (field-by-field, allowed `kind` values, normalization rules for `canonical`, etc.) or start with a small example of oracle vs pdfdig JSONL for one of the existing paired papers?

**Got it.** The BASELINE.md is the authoritative current state. We should evolve from it, not redesign in a vacuum.

Here’s how the three priorities map cleanly onto what already exists.

### 1. Markdown Spec → Extract + freeze the current finalize contract

The ideal register is already largely embodied in `md-register` + finalize + the STANDARDS that both lanes hit. We just need to make it an explicit, versioned contract (`manuscript-md/0.1`).

Core rules that match both the baseline behavior and your stated preferences:

- Prose is default.
- Math **only** via `$...$` (inline) and `$$...$$` (display). Finalize already wraps formula groups this way.
- Prose-in-math via `\text{...}` (and the usual semantic variants).
- Literal `$` in prose becomes `\$`.
- Notation-bearing commands retained; pure presentation discarded.
- Structure limited to what finalize already emits: ATX headings, paragraphs, lists, images + captions (via the shared register), pipe tables when recoverable, etc.
- No residual flags or type attributes leak into the final Markdown.

Action: extract the exact invariants from the current finalize/md-register path and write them down as the authoritative projection target. Both texdig and the membrane finalize already aim at this surface; we just make the contract explicit and versioned.

### 2. Glyph → Lexical Mapping → Document + harden the existing classify path

This is already largely implemented:

- `letters.jsonl` = the true atoms (full geometry, font, baseline, Unicode, render mode, back-refs).
- Classify Stage A does the document-local calibration (body size, tier ladder, math_frac, bold_tail, etc.).
- Stage B decision ladder + `math-assembler.ps1` (recursive script assembly) produces the typed nodes (prose / heading-candidate / formula-block) with flags such as `needs_2d_assembly`.
- Adapter then projects those nodes into membrane chunks, spending the born signals.

The mapping we need is therefore **not a new invention**. It is:

> letters → (regime discovery + relation candidates) → lexical units / runs → typed nodes → membrane chunks

The main hardening needed is exactly what the gauntlet already exposed: stronger 2-D relation candidates (script attachment, fraction bars, local row structure) **before** the formula-group / inline-vs-display decision, so fewer things arrive at the residual stage already oversegmented.

Treat the current decision ladder + math-assembler rules as the baseline mapping and document the precise projection contract.

### 3. Shared JSONL Chunked IR → Evolve the existing membrane `.chunks.jsonl`

This is the highest-leverage piece.

Right now:

- pdfdig path already ends up with `.chunks.jsonl` (post-adapter, pre-repair).
- texdig/oracle path does **not** emit a symmetric structured chunk stream; it emits final Markdown + figure counts.
- Measurement is therefore still asymmetric and figure-centric.

**Proposal (evolutionary):**

Make the membrane chunk schema the shared fidelity substrate. Both lanes must emit it.

- pdfdig already does (via adapter → preprocess).
- texdig needs a projector that walks its protected/restored structure (or the final Markdown + source map) and emits the same schema.

Minimal additive fields that make Stage-0 metrics work without breaking the existing repair loop:

```json
{
  "id": "...",
  "ordinal": 42,
  "kind": "prose | math_inline | math_display | heading | caption | figure | ...",
  "depth": null,
  "text": "surface that will appear in the Markdown",
  "canonical": null,               // optional normalized form, especially for math
  "status": "accepted | residual | competing",
  "flags": ["needs_2d_assembly", "detached_script", ...],
  "source": {
    "origin": "pdf | latex",
    "page": 3,
    "glyph_ids": [...],            // pdf side
    "bbox": [...],                 // optional
    "latex_range": "..."           // oracle side
  },
  "links": { "prev": "...", "next": "...", "parent": null }
}
```

- `status` + `flags` already partially exist via the repair work-list; just surface them uniformly.
- Oracle emits only `status: "accepted"`.
- Residual / competing chunks (or the existing math-evidence payloads) stay available for the MCP repair loop exactly as today.
- Final Markdown remains a pure projection of the accepted chunks via the existing finalize path.

With both sides emitting this, Stage-0 becomes ordinary stream alignment + filtering:

- Boundary fidelity (kind transitions, heading depth)
- Accepted-unit fidelity (only on `status: accepted`)
- False-confidence rate
- Ambiguity recall
- Residual compression

This stays fully compatible with the current run layout, flag-driven repair loop, math-evidence briefs, and figure measurement.

### Recommended next concrete steps

1. Freeze `manuscript-md/0.1` by extracting the real invariants from finalize + md-register.
2. Inspect the current shape of membrane `.chunks.jsonl` and write the small additive schema (the fields above).
3. Instrument texdig to emit the same chunk JSONL (even if initially lossy).
4. Build the Stage-0 aligner against paired chunk streams on the existing gauntlet papers.
5. Only then harden the 2-D relation candidates inside classify so more formula groups can move from residual → accepted.

This is the most parsimonious way to get a principled, well-contained fidelity substrate while respecting everything that is already working (especially the figure path and the residual MCP loop).

Want me to draft the precise chunk schema (field-by-field, allowed `kind` values, how it relates to the current nodes → chunks projection) next, or first extract the Markdown register invariants from the baseline behavior?

**Yes — these two documents together give a complete, authoritative picture of the current system.**

The retrospective is especially clarifying. It names the exact next instrument we need:

> **Conversion-metric Stage 0** — align typed units → typed atomic scores → composed coverage × fidelity (math + structure first).

That is precisely what the shared JSONL chunked IR is for.

### Mapping the three priorities onto the live architecture

| Priority                    | Current reality                                                                                            | Recommended evolution                                                                                                       |
| --------------------------- | ---------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Markdown spec**           | Implicit in finalize + `md-register` + STANDARDS                                                           | Extract and freeze as explicit versioned contract `manuscript-md/0.1`                                                       |
| **Glyph → lexical mapping** | Already implemented in `pdfdig-ir` → classify Stage A/B + `math-assembler.ps1`                             | Document the projection contract cleanly; harden the 2-D relation candidates that currently produce oversegmentation        |
| **Shared JSONL chunked IR** | Membrane already emits `.chunks.jsonl` (pdfdig side only). Oracle side has no equivalent structured stream | Evolve the existing chunks schema into the **shared parity substrate** that _both_ texdig and the pdfdig→membrane path emit |

This is evolutionary, not revolutionary. It directly enables the Stage 0 metric the retrospective already lists as the critical path.

### Concrete proposal

**1. Markdown register (`manuscript-md/0.1`)**
Freeze the invariants that finalize + md-register already implement:

- Prose default
- Math only via `$...$` / `$$...$$`
- Prose-in-math via `\text{...}`
- Notation-bearing commands retained
- Structure limited to what the current finalize path emits
- No residual flags or custom typing leak into the final Markdown

**2. Glyph → lexical**
Treat the existing pipeline as the baseline:
`letters.jsonl` → document-local calibration (order statistics) → decision ladder + recursive script assembly → typed nodes → adapter → chunks.

The main remaining work is strengthening the geometric relation candidates (scripts, fraction bars, local rows) _before_ formula groups are emitted, so fewer things arrive at the residual stage already fragmented.

**3. Shared chunked IR (the Stage 0 substrate)**
Elevate / lightly extend the existing membrane `.chunks.jsonl` so both lanes can emit it.

Minimal additive surface needed:

```json
{
  "id": "...",
  "ordinal": 42,
  "kind": "prose | math_inline | math_display | heading | caption | figure | ...",
  "depth": null,
  "text": "...",
  "canonical": null,
  "status": "accepted | residual | competing",
  "flags": ["needs_2d_assembly", "detached_script", ...],
  "source": {
    "origin": "pdf | latex",
    "page": ...,
    "glyph_ids": [...],
    "bbox": [...],
    "latex_range": "..."
  }
}
```

- pdfdig path already almost produces this.
- texdig needs a projector that emits the same schema from its protected/restored structure (or from the final Markdown + source map).
- Residual / competing chunks continue to feed the existing dispatch → `get_slice` → `propose_edit` loop exactly as today (math-evidence payloads still ride the flagged formula chunks).
- Final Markdown remains a pure projection of the `accepted` chunks.

With both sides emitting this stream, Stage 0 becomes ordinary ordered alignment + filtering:

- Boundary fidelity (kind transitions + heading depth)
- Accepted-unit fidelity (only on `status: accepted`)
- False-confidence rate
- Ambiguity recall
- Residual compression

This is the cleanest way to turn the retrospective’s “Conversion-metric Stage 0” from a design note into an executable instrument while staying fully compatible with the current run layout, flag-driven repair loop, and figure measurement that is already working.

### Suggested order of work

1. Extract and freeze `manuscript-md/0.1` from current finalize behavior.
2. Inspect the live shape of membrane `.chunks.jsonl` and write the small additive schema.
3. Make texdig emit the same chunk stream.
4. Implement the Stage 0 aligner + metrics on the existing gauntlet pairs.
5. Only then invest in further 2-D relation hardening inside classify.

This keeps everything grounded in the system that already exists and directly advances the parity goal the retrospective identifies as the critical path.

Would you like me to draft the precise evolved chunk schema (field-by-field, allowed kinds, compatibility notes with the current repair loop) next?

**Here is the clear problem map.**

The system has **one target** and **two very different source problems**. Everything else is infrastructure for getting from the sources to the target with measurable fidelity.

---

### 1. The Markdown Target Problems (the shared ideal)

This is the contract both lanes must satisfy.

**Core problems to iron out:**

- **What must be preserved**
  Ordered prose, section hierarchy, mathematical meaning (including notation-bearing typography), figures + captions, tables (when recoverable), equation/figure/table numbers and references, cross-references, footnotes, lists.

- **What may be discarded (the “printing” quotient)**
  Page boundaries, headers/footers/page numbers, column layout, float placement decisions, hard line wraps, discretionary hyphens, absolute font sizes, margins, exact coordinates, pure decorative rules.

- **Register discipline**
  - Prose is default.
  - Math is entered **only** by `$...$` (inline) and `$$...$$` (display).
  - Prose inside math only via `\text{...}` (and semantic variants).
  - Literal `$` in prose must become `\$`.
  - No residual flags, confidence scores, or custom type attributes inside the final Markdown.

- **Consistency / self-evidence requirements**
  Every math span must be renderable under the declared profile (KaTeX strict is the current bar).
  The delimiters must be unwavering so tokenizers and dual-RAG projections can rely on them.
  Notation that changes mathematical identity (`\mathbb`, `\mathbf`, accents, operators, etc.) must be retained; pure presentation must not.

- **Edge cases that still need policy**
  Equation tags / numbers (`\tag{}` vs residual).
  Complex tables (pipe vs residual vs limited HTML).
  Multi-line display math that was originally aligned environments.
  Theorem-like environments (keep as headings + body, or residual?).
  How much source provenance (if any) is allowed to leak into the final document vs staying in sidecars.

The Markdown target is deliberately minimal. Richer evidence and uncertainty live outside it.

---

### 2. LaTeX → Markdown Problems (the tractable lane)

This is a **parse / transform** problem of a structured language. Most of it is already solved by `latex-ingest.ps1`.

**Main problem classes:**

| Problem                          | Nature                                                    | Current status                                                                        |
| -------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Author macros                    | Can hide structure and reach inside math                  | EXPAND stage (brace-aware)                                                            |
| Symbolic counters / refs         | `\ref`, `\eqref`, `\cite`, theorem numbers                | RESOLVE stage                                                                         |
| Math integrity during transforms | Structural changes must not corrupt math                  | PROTECT → RESTORE (math passes through verbatim)                                      |
| Structure mapping                | sections, theorems, lists, abstract, title                | TRANSFORM                                                                             |
| Tables                           | `tabular`, booktabs, multicolumn, `\bordermatrix`         | Partial (simple cases → pipe tables)                                                  |
| Diagrams                         | TikZ, xy-pic, included PDFs                               | Encode-first sub-pipeline (TikZ→SVG or tectonic→PDF→PNG) through shared `md-register` |
| Multi-file / `\input`            | Only one level currently resolved                         | Known limitation                                                                      |
| Nested optional-arg macros       | Hard for expansion                                        | Known rough edge                                                                      |
| Non-UTF8 sources                 | Encoding issues                                           | Known rough edge                                                                      |
| Author defects                   | Typos, undefined macros, missing images                   | Handled by durable `{slug}-latex.patch.jsonl`                                         |
| Editorial vs faithful            | Whether to drop acknowledgements, filter references, etc. | Doctrine: faithful; filtering belongs to later promotion                              |

**Key property:** When the LaTeX source exists, math is almost free — it is already in the desired register. The main residual work is structural fidelity and diagram rendering.

The LaTeX output is both a deliverable **and** the per-document ground truth for the PDF lane.

---

### 3. PDF → Markdown Problems (the hard inverse problem)

This is a **reconstruction under uncertainty** problem. The PDF is a print projection; the original structure has been compiled away.

Here is the full end-to-end problem inventory, stage by stage.

#### 3.1 Substrate / Born-signal extraction

**Problem:** Recover everything the PDF still knows, opinion-free.

- Glyphs with Unicode, font, size, baseline, advance, rendering mode, color, orientation
- Vector paths (including rules that may be fraction bars or axes)
- XObjects / placed images
- Bookmarks / outline
- Producer / creator / font census (origin detection)
- Invisible text, broken Unicode maps, Type-3 fonts, etc.

**Current approach:** `pdfdig-ir.ps1` multi-lane JSONL (letters, words, blocks, paths, xobjects) + health envelope.
**Open problems:** Coverage gaps (orphan letters), unreliable bold flags, complex Type-3 / custom encodings, very large path clouds.

#### 3.2 Document-local calibration & regime discovery

**Problem:** Discover the document’s own typographic regimes without absolute thresholds.

- Body size, heading tiers, script sizes, math fonts, leading, indent
- Which fonts are math vs prose vs decorative

**Current approach:** Order statistics + font-role store + tier ladder (gap-merged).
**Open problems:** Noisy tier ladders, math-role ambiguity (e.g. cmbright), documents with weak or missing role signals.

#### 3.3 Reading order & layout structure

**Problem:** Recover logical order from geometric placement (especially multi-column).

**Current approach:** RecursiveXYCut on blocks (explicitly a _claim_ lane) + column-band detection.
**Open problems:** Complex layouts, side-by-side figures + text, nested columns, residual `suspect_reading_order` cases.

#### 3.4 Heading recovery

**Problem:** Recover hierarchy (depth + boundaries) from typography + outline.

**Current approach:** Size/bold tier ladder + bidirectional outline matching + run-in detectors.
**Open problems:**

- Premature commitment (body sentences matching title phrases)
- Outline fragments vs printed headings (numbering mismatch)
- Documents with weak or missing outline
- All-caps body-size IEEE-style headings

#### 3.5 Math recovery (the largest residual surface)

This is the central open problem cluster.

| Sub-problem                                                                           | Evidence available                                   | Current status                                      | Residual nature                                  |
| ------------------------------------------------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------ |
| Nested scripts (1.5-D)                                                                | Size drop + baseline shift                           | Largely solved by recursive `math-assembler.ps1`    | Mostly closed                                    |
| Inline vs display boundary                                                            | Geometry, math_frac, width, surrounding prose        | Decision ladder exists                              | Frequent oversegmentation / premature commitment |
| True 2-D structure (fractions, matrices, cases, binomials, limits on large operators) | Paths (fraction bars), spatial arrangement of glyphs | Flagged `needs_2d_assembly` + math-evidence payload | Core residual for MCP                            |
| Detached subscripts / superscripts                                                    | Baseline displacement creates separate lines         | Common failure mode                                 | Residual                                         |
| Formula numbers / tags                                                                | Nearby parentheses or numbers                        | Weak / missing dedicated stage                      | Open                                             |
| Multi-line aligned displays                                                           | Geometry + alignment cues                            | Fragmented                                          | Residual                                         |
| Math vs prose role of individual glyphs                                               | Font role + context                                  | Font-role store helps; still ambiguous cases        | Residual                                         |

**Key design point:** Deterministic assembly goes as far as the 1.5-D regime. Everything that requires true 2-D relational reasoning is supposed to become a compact residual packet (glyph table + spatial sketch + candidate groupings + constraints) for the MCP / reasoning agents.

#### 3.6 Figures, captions, diagrams

**Problem:** Which ink belongs to a figure? How is it captioned? How are subfigures grouped?

**Current approach:** Highly developed — HDBSCAN (rectangle-gap) + consensus + caption cue attachment + veto ladder (furniture, inflow) + stray eject. PRIMARY (captioned) is largely closed on calibration corpora (0 overs).
**Open problems:** Raster-blindness (bitmap figures with no path ink), glyph-built diagrams, some attachment edge cases, SECONDARY (uncaptioned / inline) population.

#### 3.7 Tables

**Problem:** Recover logical grid structure from geometry + rulings + text.

**Current status:** Largely deferred / residual. Geometry exists; semantic reconstruction does not.

#### 3.8 Furniture, headers, footers, page numbers

**Problem:** Identify and drop page-level chrome.

**Current approach:** Near-edge + size heuristics + furniture demotion in the figure ladder.
**Open problems:** Running headers that look like section titles, complex journal chrome.

#### 3.9 Uncertainty representation & residual packaging

**Problem:** How to represent “I am not sure” so that a reasoning agent can resolve it without being given the whole page.

**Current approach:** Flags on nodes/chunks + math-evidence payloads (glyph table + spatial sketch) + membrane repair loop (dispatch → get_slice → propose_edit → apply).
**Open problems:**

- Residual packets are not yet uniformly small and well-constrained
- False-confidence (unflagged wrong decisions) is still high on math boundaries
- No shared chunked IR yet that makes residual size and ambiguity recall measurable against the oracle

#### 3.10 Projection into the Markdown register

**Problem:** Turn the accepted claims + resolved residuals into clean `$...$` / `$$...$$` Markdown that obeys the target contract.

**Current approach:** Adapter → membrane preprocess → finalize + md-register.
**Open problems:** Consistent handling of residual resolutions, equation tags, complex tables, caption relocation policy.

#### 3.11 Measurement / parity against the oracle

**Problem:** Know, unit-by-unit, how close the PDF lane is to the LaTeX oracle.

**Current state:** Strong only on captioned figures (`Compare-FigureCounts`).
**Required next instrument:** Conversion-metric Stage 0 — aligned typed units (the shared chunked IR) so that boundary fidelity, accepted-unit fidelity, false-confidence, and residual compression can be measured on math and structure as well.

---

### Summary view of the PDF → Markdown pipeline

```
PDF
 → Born signals (letters, paths, xobjects, outline)     [mostly solved]
 → Document-local regimes + reading order               [mostly solved]
 → Deterministic claims (headings, 1.5-D math, simple structure)
 → Residual packets (true 2-D math, hard boundaries, tables, ambiguous headings)
 → MCP / reasoning agents (only on residuals)
 → Mechanical + render gates
 → Clean Markdown (shared register)
```

The architecture is already correct in shape. The remaining hard work is concentrated in:

1. Making the residual packets for math (and headings) smaller and better constrained.
2. Building the shared chunked IR so that Stage 0 can measure progress on those residuals against the oracle.
3. Freezing the Markdown target contract so both lanes know exactly what “done” looks like.

This is the full problem inventory. You can now decide which specifications need to be written first (Markdown target, residual packet contract, Stage-0 alignment rules, glyph→lexical projection rules, etc.) with full visibility into the end-to-end shape.

**Here’s a clean deconstruction focused on what is actually necessary.**

The goal is a solid **measurement IR** (the shared typed chunk stream for prose + math registers). Everything else is secondary until that exists and can be scored against the oracle.

---

### 1. Necessary problems for pdfdig to reach the measurement IR

These are the problems that _must_ be solved (or honestly residualized with good evidence) before Stage-0 parity measurement on the registers becomes meaningful:

| #   | Necessary Problem                                        | Why it is required for the measurement IR                                        | Current status                                                              |
| --- | -------------------------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| 1   | Faithful substrate                                       | Everything downstream is only as good as the atoms                               | Strong (letters + geometry + paths + outline + health)                      |
| 2   | Document-local regime / style-palette recovery           | Needed to separate body / script / display / heading configurations              | Partial (order-statistics ladder). DESIGN.md already points at the redesign |
| 3   | Reading-order claims with uncertainty                    | Without it the chunk stream has no reliable order                                | Partial (RecursiveXYCut is a single unwitnessed claim)                      |
| 4   | Math vs prose isolation                                  | The fundamental register boundary                                                | Strong for classic TeX fonts; weaker on SF / unknown fonts                  |
| 5   | Glyph → lexical surface + 1.5-D scripts                  | Needed so math chunks have a usable surface string                               | Strong (math-assembler)                                                     |
| 6   | Inline vs display boundary decisions                     | Directly determines `$` vs `$$` in the IR                                        | Fragile — major source of oversegmentation and false confidence             |
| 7   | 2-D math residual packaging                              | Fractions, matrices, aligned blocks, etc. cannot be solved deterministically yet | Flagged + math-evidence, but packets not yet uniformly small/constrained    |
| 8   | Heading / section hierarchy (or residual)                | Required for structural parity                                                   | Partial — premature commitment and outline mismatch still common            |
| 9   | Projection into typed, flagged, provenance-linked chunks | This _is_ the measurement IR                                                     | Exists on pdfdig side; not yet symmetric with oracle                        |
| 10  | Uniform uncertainty / margin emission                    | So Stage-0 can compute false-confidence and residual compression                 | Pattern exists; not yet uniform                                             |

**Not necessary for the first solid measurement IR** (can stay residual or later lanes):

- Full semantic tables
- Complex multi-column edge cases
- Equation number / tag recovery
- Full cross-reference resolution
- Glyph-built diagrams / raster-blind figures beyond the current PRIMARY

If the ten items above are solid, you can already measure coverage × fidelity on the math and prose registers. That is the completeness bar for this stage of the reboot.

---

### 2. Stores taxonomy — what is irreducible vs. reshapeable

**Truly irreducible (world knowledge / encoding facts)**

- Symbol / glyph → LaTeX command maps (font-aware). Geometry cannot invent that `\mathbb{R}` means blackboard-bold R.
- Producer-map and origin cues.
- Small core of caption cue words and similar linguistic conventions.
- Any lexical mapping that is cultural rather than geometric.

These stay as stores. Do not try to “learn” them per document.

**Strong candidates for unsupervised / hierarchical replacement or augmentation**

- **Style-palette / role recovery** (the biggest opportunity).
  The current size + bold tier ladder is a quantized approximation that works well on clean TeX but degrades on continuous or multi-modal documents.
  Better formulation (exactly as DESIGN.md §1.3 says): recover the latent style palette of the document (mixture model, hierarchical clustering, or tree methods over size/weight/family/position/recurrence), then assign roles to _configurations_ rather than individual lines via a small relational grammar + witnesses (outline, position, alternation with body).
  This dissolves many of the special cases in the current decision ladder.

- **Reading order**.
  Single RecursiveXYCut claim is brittle. A second geometric or baseline-flow witness + explicit disagreement flag is higher leverage than more ladder complexity.

- **Math vs prose isolation beyond font names**.
  Document-local clustering on geometric + contextual features (local density, alignment, operator-like neighbors, whitespace patterns) can augment the font-role store, especially for non-classic math fonts.

- **Competing 2-D assemblies**.
  Instead of only emitting `needs_2d_assembly`, use hierarchical clustering or multi-scale methods on the local glyph + path cloud to propose a _small set of competing groupings_. The residual packet then carries the competitors rather than a single broken surface. This is pure discovery; the agent still adjudicates.

**Policy / fitted ladders**
Most of the long decision-order ladders and many thresholds in `classify-config` are candidates to be thinned. Prefer multi-view discovery → competing hypotheses → typed dominance rules or agent adjudication over deep single-view cascades.

---

### 3. PdfPig + feature engineering headroom

You are probably under-using the substrate. Richer derived features that stay inside perception:

- Local density and whitespace descriptors
- Alignment graphs (shared baselines, shared x-coordinates, vertical alignment of operators)
- Path–glyph interaction features (glyph sitting on a thin rule = strong fraction-bar candidate)
- Multi-scale neighborhood statistics
- Stability of groupings across parameter ranges (the persistent-homology idea you already like)
- More detailed font descriptor and rendering-mode signals when available
- Baseline flow / continuity features for reading-order witnesses

These can feed both the palette recovery and the competing-hypothesis generators without violating “perception ≠ interpretation.”

---

### 4. How much life is left in the cascade / ladder motif?

Quite a bit for **forced tier-0 decisions with clear margins**, almost none for ambiguous or continuous cases.

Useful remaining roles for ladders:

- Typed dominance rules when two witnesses disagree (outline vs typography, etc.)
- Fast, deterministic filters with large margins (obvious furniture, obvious page numbers)
- Final projection rules once regimes are known

Poor remaining roles:

- Long ordered decision lists that try to resolve every edge case by priority
- Treating the ladder as the primary way to discover structure rather than to adjudicate already-discovered candidates

The healthy pattern going forward is:

> Multi-view unsupervised discovery (regimes, partitions, alignments)
> → small set of competing hypotheses with evidence
> → typed dominance or residual packet
> → agent only on the residual

This is more robust and directly improves the quality of the measurement IR (higher accepted fraction, lower false-confidence, smaller residuals).

---

### Bottom line for the reboot

**Keep** the multi-lane substrate, flag-as-currency, 1.5-D assembler, math-evidence briefs, figure veto ladder, em-normalization, irreducible stores, and the overall perception/interpretation separation.

**Reshape** role identification into palette + configuration recovery, add witnesses for reading order, make residual packaging first-class (competing hypotheses), and emit uniform margins so the measurement IR can score confidence properly.

**Explore aggressively** with hierarchical / mixture / multi-scale methods and richer PdfPig-derived features _inside the discovery stages_. Do not let them make final semantic decisions.

The necessary surface to reach a useful measurement IR is smaller and more focused than the full eventual system. Solving the ten problems in the first table cleanly is the right completeness target for this phase.

Would you like to go deeper next on one of these:

- A concrete sketch of the style-palette recovery formulation,
- The residual packet shape for 2-D math under the competing-hypotheses model,
- Or the minimal fields the measurement IR must have so Stage-0 can actually be implemented?
