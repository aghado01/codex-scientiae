# So i've been chewing on this project related to converting math-dense pdfs and latex documents into an LLM optimized markdown standard. I'm also using latex paired controls as a sort of development harness for perfecting my pdfdig hybrid algorithmic-mcp approach to a robust PDF converter for when latex side cars aren't available

2 / 2

Thought for 25s

**Yes. This is a coherent and worthwhile research program.**

You are not building “another PDF-to-Markdown converter.” You are building a **principled semantic transduction** from a typesetting medium (PDF) into a minimal, LLM-optimized manuscript envelope, using LaTeX-paired sources as a high-quality oracle harness. That framing is correct and sharp.

### Current architectural consensus (from the full thread)

**Ownership split that must stay clean:**

- **pdfdig** owns the born-signal substrate, geometric/typographic discovery (HDBSCAN + persistence ideas), deterministic claims, competing hypotheses, and the residual evidence packets. It deliberately stops at the confidence boundary.
- **Markpig** owns the formal mathematical language service: core grammar, Math AST, canonical surface serialization, visitors, render profiles (KaTeX/MathJax/LaTeX), equivalence operations, and source maps back to pdfdig atoms.
- The **delivered manuscript** is deliberately minimal: prose by default, math only via $...$ / $$...$$, prose-in-math via \\text{...}, notation-bearing typography retained (\\mathbb, \\mathbf, operators, accents, etc.), standard Markdown structure only where the manuscript grammar requires it. No custom type tags or residual flags inside the manuscript itself.
- Uncertainty lives **out-of-band** in a sparse residual ledger / MCP packets that can be resolved and discarded entry-by-entry.

This is the right separation. It keeps the envelope clean and tokenizable while still giving the agentic layer complete evidence for the hard cases.

### What the gauntlet is currently telling us

The paired LaTeX oracle harness is already doing its most valuable job: **falsifying premature semantic decisions with high locality**.

- Captioned figures are a genuine success case (high precision, almost no over-counting). That subsystem is mature enough to leave alone for now.
- Math is the rate-limiter. Across the 56 pairs you have ~21k formula groups against ~3.9k oracle display blocks (4.5–10× oversegmentation depending on corpus). Roughly half of those groups carry no flag. Inline scripts are routinely detached into their own display formulas because baseline displacement creates separate line IDs; display equations are fragmented across unflagged operators + prose remnants.
- Headings show the same premature-commitment pattern (bidirectional outline matching producing both false positives and total under-detection when everything is demoted as outline_fragment).

These are not primarily recognition failures. They are **boundary and reassociation failures**. The pipeline is deciding “inline vs display vs prose” and “heading vs body” before the 2-D relations (scripts, fraction bars, rows, containment) and the monotone 1-1 assignment constraints are recovered.

That is exactly the kind of failure mode the architecture is designed to surface rather than hide.

### Highest-leverage next moves (parsimonious)

1. **Stage-0 evaluator first** (before more clustering work). Measure what actually tests the thesis:
   - False boundary confidence (how often an unflagged $, $$, #, or paragraph break is contradicted by the oracle).
   - Accepted-unit fidelity (among units emitted without residual flags, what fraction survive canonical comparison).
   - Ambiguity recall (of the units that disagree with the oracle, what fraction retained usable evidence).
   - Residual compression (size of the evidence packet that would need to reach the MCP vs whole-page baseline).
   - Simple math coverage proxy: fraction of oracle display blocks covered by a single pdfdig group or a small flagged competition set.

   This can be built against the existing paired oracles without waiting for a full Math AST.

2. **Narrow 2-D reassociation experiment before the inline/display decision.** Add a lightweight geometric pass (script attachment candidates + fraction-bar candidates + local row clustering) that produces competing groupings _before_ the system commits to delimiters. Feed the competitors into residual packets rather than forcing a single answer. Re-run Stage-0 on the same 56 pairs. This is the cleanest test of whether deterministic coverage can rise while false-confidence falls.
3. **Keep the residual packet schema explicit and small.** Packets for the current pain points should carry atoms + geometry + current best surface + competing hypotheses + hard constraints (must render, delimiter balance, no invented structure) + visual crop when useful. They should be addressable and deletable.

Everything else (full Manuscript IR contract language, dual-RAG address spine, Markpig AST visitors, dual embedding stores) is downstream of proving that the hybrid loop is actually shrinking the hard residual in a measurable way.

### On the dual-RAG idea

It remains a strong downstream payoff, but only once the manuscript spine is solid. Separate prose and math vector spaces joined by stable addresses (section path, host ordinal, neighboring spans, equation labels, source glyph IDs) is the right model. Token masking alone will not give reliable positional alignment across different tokenizers. The address ledger is the real coordination mechanism.

### Bottom line

The project is worth doing **precisely because** it refuses to paper over the epistemic boundary that model-first systems cross. The LaTeX-paired harness is the correct development loop. The current gauntlet results are not a condemnation; they are high-quality negative signal that the math boundary layer is the next critical piece of deterministic machinery.

If you want to stay parsimonious, the next concrete unit of work is the Stage-0 boundary/false-confidence evaluator + a focused reassociation experiment on the existing math groups. That will tell us whether the hybrid approach is progressing or whether we need to adjust the jurisdiction of the unsupervised stages.

Which thread do you want to push on next?

Add to chat

the point of the MCP is to leverage reasoning agents to fill in gaps that i cant solve deterministically or using my hdbscan clustering approach. its all a pipeline to get from pdf to the ideal markdown

Thought for 6s

**Understood. That clarification locks the jurisdiction cleanly.**

The entire system is a pipeline whose sole product is the ideal Markdown manuscript (minimal register, consistent math delimiters, notation-bearing typography preserved, no residual noise inside the document). Everything upstream exists only to make that final artifact as complete and faithful as possible.

### Strict pipeline stages

1. **Born-signal extraction** (PdfPig) Glyphs, fonts, baselines, advances, paths, XObjects, bookmarks, etc. with full provenance.
2. **Document-local discovery** Geometric HDBSCAN + persistent homology ideas for candidate components and stability. Second (symbolic/typographic) HDBSCAN for size/baseline/font regimes. These stages propose structure; they do not decide final semantics.
3. **Deterministic claims** Anything that can be asserted with high confidence from the evidence (simple inline scripts, obvious reading order, clear caption attachment, etc.) is committed. Competing hypotheses are retained only where the evidence is genuinely underdetermined.
4. **Residual packaging (the MCP entry point)** Only the gaps that survive stages 1–3 become MCP packets. Each packet is a compact, evidence-complete reasoning task: the relevant atoms + geometry + candidate groupings + hard constraints (must render, delimiter balance, no invented operators/structure, etc.) + optional visual crop. The agents are never asked to “transcribe the page.” They are asked to resolve a narrowly scoped structural ambiguity that the deterministic + clustering layers could not decide.
5. **Mechanical / render gates** Any proposal that fails linting, rendering, or constraint checks is rejected or returned to the residual ledger.
6. **Final minimal manuscript** Clean Markdown with $...$ / $$...$$ / \\text{...} and the standard structural syntax. Residual ledger is either empty or explicitly retained only for the irreducible cases.

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

well, i need to iron out the markdown spec, i need to lay out the glyph to lexical mapping, i need to define the JSONL chunked IR that both oracle and PDF target because thats my substrate for measuring fidelity in a principled and well contained manner

Thought for 20s

**Good. These three pieces form the real foundation.**

Without them the gauntlet stays coarse and residual packets stay underspecified. Here is a concrete, lean design that stays faithful to the minimal-register philosophy and makes Stage-0 fidelity measurement principled.

---

### 1. Minimal Markdown Manuscript Spec (manuscript-md/0.1)

**Core invariants**

- Prose is the default register.
- Math is entered **only** by delimiters:
  - Inline: $...$
  - Display: $$...$$ (single preferred form)
- Prose inside math: exclusively \\text{...} (plus the usual \\mathrm, \\operatorname when they carry meaning).
- Literal dollar signs in prose are always written \\$. Unescaped $ is exclusively a math delimiter.
- Notation-bearing typography is retained (\\mathbb, \\mathcal, \\mathbf, accents, primes, standard operators, etc.). Pure presentation (absolute sizes, colors, kerning, page layout) is discarded.
- Standard Markdown structure only: ATX headings, paragraphs (blank-line separated), lists, images + captions, pipe tables when recoverable, fenced code, simple emphasis, links.
- No custom type attributes, no residual flags, no extra container syntax inside the manuscript itself.

**Explicitly discarded (the printing quotient)** Page boundaries, headers/footers/page numbers, columns, float placement, hard wraps, discretionary hyphens, absolute coordinates and font metrics.

The manuscript is self-typing via ordinary Markdown + math delimiters. Both the LaTeX oracle and pdfdig must be able to project into this surface (or into residuals when they cannot).

---

### 2. Glyph → Lexical Mapping (PDF side)

PdfPig letters are the atoms:

text

Copy

```
glyph_id, page, bbox, Unicode, font_name, font_size, baseline, advance, rendering_mode, ...
```

**Mapping stages**

1. **Document-local regime discovery** Second HDBSCAN (or equivalent) on size + baseline + font features produces regimes: body, script, display, math-font clusters, unknown.
2. **Deterministic lexical grouping**
   - Adjacent glyphs that share a regime and have normal advances → word / math atom candidates.
   - Script attachment candidates (size drop + baseline shift + horizontal proximity).
   - Fraction-bar and large-operator candidates from geometry + path evidence.
   - Reading-order edges from RecursiveXYCut / unsupervised order + column claims.
3. **Output of this stage** Ordered sequence of **lexical units** (still pre-chunk):
   - text (or math atom surface)
   - list of source glyph_ids
   - regime label
   - local geometry
   - provisional role hints (prose / math / heading-candidate / furniture)

These lexical units are the immediate input to the chunked IR builder. Overs Segmentation currently happens here (detached subscripts, split summations). Strengthening the relation candidates before chunking is the highest-leverage deterministic improvement.

---

### 3. Shared JSONL Chunked IR (the fidelity substrate)

Both the LaTeX oracle and pdfdig emit the **same** JSONL format. Final Markdown is a pure projection of an accepted IR. Residuals live either as status: residual chunks or as parallel residual packets referenced by ID.

**Minimal chunk schema** (one JSON object per line):

JSON

Copy

```
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
- status: accepted + empty (or only informational) flags → counts toward accepted-unit fidelity.
- Any chunk that is residual or carries decision-critical flags is excluded from the accepted score and contributes to residual-size / ambiguity-recall metrics.
- Oracle emits only status: accepted (ground truth).
- Math chunks carry the surface that will become the content inside $...$ or $$...$$. Canonical form is optional for Stage-0 but useful for later AST equivalence.
- Lightweight prev/next/parent links are enough to detect oversegmentation and to reconstruct reading order without turning the IR into a full graph database.

**Stage-0 metrics become straightforward**

- Align the two ordered JSONL streams (by ordinal + content fingerprint + secondary page/bbox).
- Boundary fidelity = agreement on kind transitions and heading depths.
- Accepted-unit fidelity = exact or render-equivalent match rate on chunks both sides marked accepted.
- False-confidence rate = accepted pdfdig chunks that fail to align with oracle.
- Ambiguity recall = fraction of misaligned units that carried residual status or relevant flags.
- Residual compression = total evidence size of residual/competing chunks vs. baseline.

---

### Recommended implementation order

1. Freeze manuscript-md/0.1 (the projection rules).
2. Implement the shared JSONL writer for the LaTeX oracle path first (easier, deterministic).
3. Make pdfdig emit the same JSONL (even if many chunks are currently residual or heavily flagged).
4. Build the Stage-0 aligner + metric suite against the paired JSONL files.
5. Only then harden the glyph → lexical → chunk path (especially 2-D relations) so that more chunks can move from residual → accepted.

This gives you a well-contained, measurable substrate immediately. The Markdown stays clean, the IR stays lean enough for both sides to target, and the residual packets have a clear attachment point (id + flags + source.glyph_ids).

Want me to expand any of the three pieces into a more formal schema document (field-by-field, allowed kind values, normalization rules for canonical, etc.) or start with a small example of oracle vs pdfdig JSONL for one of the existing paired papers?

BASELINE.md

i got a 'baseline' summary writeup of the this stuff as it is now

Thought for 15s

**Got it.** The BASELINE.md is the authoritative current state. We should evolve from it, not redesign in a vacuum.

Here’s how the three priorities map cleanly onto what already exists.

### 1. Markdown Spec → Extract + freeze the current finalize contract

The ideal register is already largely embodied in md-register + finalize + the STANDARDS that both lanes hit. We just need to make it an explicit, versioned contract (manuscript-md/0.1).

Core rules that match both the baseline behavior and your stated preferences:

- Prose is default.
- Math **only** via $...$ (inline) and $$...$$ (display). Finalize already wraps formula groups this way.
- Prose-in-math via \\text{...} (and the usual semantic variants).
- Literal $ in prose becomes \\$.
- Notation-bearing commands retained; pure presentation discarded.
- Structure limited to what finalize already emits: ATX headings, paragraphs, lists, images + captions (via the shared register), pipe tables when recoverable, etc.
- No residual flags or type attributes leak into the final Markdown.

Action: extract the exact invariants from the current finalize/md-register path and write them down as the authoritative projection target. Both texdig and the membrane finalize already aim at this surface; we just make the contract explicit and versioned.

### 2. Glyph → Lexical Mapping → Document + harden the existing classify path

This is already largely implemented:

- letters.jsonl = the true atoms (full geometry, font, baseline, Unicode, render mode, back-refs).
- Classify Stage A does the document-local calibration (body size, tier ladder, math_frac, bold_tail, etc.).
- Stage B decision ladder + math-assembler.ps1 (recursive script assembly) produces the typed nodes (prose / heading-candidate / formula-block) with flags such as needs_2d_assembly.
- Adapter then projects those nodes into membrane chunks, spending the born signals.

The mapping we need is therefore **not a new invention**. It is:

> letters → (regime discovery + relation candidates) → lexical units / runs → typed nodes → membrane chunks

The main hardening needed is exactly what the gauntlet already exposed: stronger 2-D relation candidates (script attachment, fraction bars, local row structure) **before** the formula-group / inline-vs-display decision, so fewer things arrive at the residual stage already oversegmented.

Treat the current decision ladder + math-assembler rules as the baseline mapping and document the precise projection contract.

### 3. Shared JSONL Chunked IR → Evolve the existing membrane .chunks.jsonl

This is the highest-leverage piece.

Right now:

- pdfdig path already ends up with .chunks.jsonl (post-adapter, pre-repair).
- texdig/oracle path does **not** emit a symmetric structured chunk stream; it emits final Markdown + figure counts.
- Measurement is therefore still asymmetric and figure-centric.

**Proposal (evolutionary):**

Make the membrane chunk schema the shared fidelity substrate. Both lanes must emit it.

- pdfdig already does (via adapter → preprocess).
- texdig needs a projector that walks its protected/restored structure (or the final Markdown + source map) and emits the same schema.

Minimal additive fields that make Stage-0 metrics work without breaking the existing repair loop:

JSON

Copy

```
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

- status + flags already partially exist via the repair work-list; just surface them uniformly.
- Oracle emits only status: "accepted".
- Residual / competing chunks (or the existing math-evidence payloads) stay available for the MCP repair loop exactly as today.
- Final Markdown remains a pure projection of the accepted chunks via the existing finalize path.

With both sides emitting this, Stage-0 becomes ordinary stream alignment + filtering:

- Boundary fidelity (kind transitions, heading depth)
- Accepted-unit fidelity (only on status: accepted)
- False-confidence rate
- Ambiguity recall
- Residual compression

This stays fully compatible with the current run layout, flag-driven repair loop, math-evidence briefs, and figure measurement.

### Recommended next concrete steps

1. Freeze manuscript-md/0.1 by extracting the real invariants from finalize + md-register.
2. Inspect the current shape of membrane .chunks.jsonl and write the small additive schema (the fields above).
3. Instrument texdig to emit the same chunk JSONL (even if initially lossy).
4. Build the Stage-0 aligner against paired chunk streams on the existing gauntlet papers.
5. Only then harden the 2-D relation candidates inside classify so more formula groups can move from residual → accepted.

This is the most parsimonious way to get a principled, well-contained fidelity substrate while respecting everything that is already working (especially the figure path and the residual MCP loop).

Want me to draft the precise chunk schema (field-by-field, allowed kind values, how it relates to the current nodes → chunks projection) next, or first extract the Markdown register invariants from the baseline behavior?

architecture-retrospective-20260720.md

there was also this one

Thought for 9s

**Yes — these two documents together give a complete, authoritative picture of the current system.**

The retrospective is especially clarifying. It names the exact next instrument we need:

> **Conversion-metric Stage 0** — align typed units → typed atomic scores → composed coverage × fidelity (math + structure first).

That is precisely what the shared JSONL chunked IR is for.

### Mapping the three priorities onto the live architecture

| Priority                    | Current reality                                                                                          | Recommended evolution                                                                                                       |
| --------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Markdown spec**           | Implicit in finalize + md-register + STANDARDS                                                           | Extract and freeze as explicit versioned contract manuscript-md/0.1                                                         |
| **Glyph → lexical mapping** | Already implemented in pdfdig-ir → classify Stage A/B + math-assembler.ps1                               | Document the projection contract cleanly; harden the 2-D relation candidates that currently produce oversegmentation        |
| **Shared JSONL chunked IR** | Membrane already emits .chunks.jsonl (pdfdig side only). Oracle side has no equivalent structured stream | Evolve the existing chunks schema into the **shared parity substrate** that _both_ texdig and the pdfdig→membrane path emit |

This is evolutionary, not revolutionary. It directly enables the Stage 0 metric the retrospective already lists as the critical path.

### Concrete proposal

**1. Markdown register (manuscript-md/0.1)** Freeze the invariants that finalize + md-register already implement:

- Prose default
- Math only via $...$ / $$...$$
- Prose-in-math via \\text{...}
- Notation-bearing commands retained
- Structure limited to what the current finalize path emits
- No residual flags or custom typing leak into the final Markdown

**2. Glyph → lexical** Treat the existing pipeline as the baseline: letters.jsonl → document-local calibration (order statistics) → decision ladder + recursive script assembly → typed nodes → adapter → chunks.

The main remaining work is strengthening the geometric relation candidates (scripts, fraction bars, local rows) _before_ formula groups are emitted, so fewer things arrive at the residual stage already fragmented.

**3. Shared chunked IR (the Stage 0 substrate)** Elevate / lightly extend the existing membrane .chunks.jsonl so both lanes can emit it.

Minimal additive surface needed:

JSON

Copy

```
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
- Residual / competing chunks continue to feed the existing dispatch → get_slice → propose_edit loop exactly as today (math-evidence payloads still ride the flagged formula chunks).
- Final Markdown remains a pure projection of the accepted chunks.

With both sides emitting this stream, Stage 0 becomes ordinary ordered alignment + filtering:

- Boundary fidelity (kind transitions + heading depth)
- Accepted-unit fidelity (only on status: accepted)
- False-confidence rate
- Ambiguity recall
- Residual compression

This is the cleanest way to turn the retrospective’s “Conversion-metric Stage 0” from a design note into an executable instrument while staying fully compatible with the current run layout, flag-driven repair loop, and figure measurement that is already working.

### Suggested order of work

1. Extract and freeze manuscript-md/0.1 from current finalize behavior.
2. Inspect the live shape of membrane .chunks.jsonl and write the small additive schema.
3. Make texdig emit the same chunk stream.
4. Implement the Stage 0 aligner + metrics on the existing gauntlet pairs.
5. Only then invest in further 2-D relation hardening inside classify.

This keeps everything grounded in the system that already exists and directly advances the parity goal the retrospective identifies as the critical path.

Would you like me to draft the precise evolved chunk schema (field-by-field, allowed kinds, compatibility notes with the current repair loop) next?

ive still got more i need to iron out before i build anything. like, i want to layout the tex, pdf and markdown target spec problems very clear. i need to see all the parts and problems, especially for getting from pdf to markdown, of the end to end solution

Thought for 10s

**Here is the clear problem map.**

The system has **one target** and **two very different source problems**. Everything else is infrastructure for getting from the sources to the target with measurable fidelity.

---

### 1. The Markdown Target Problems (the shared ideal)

This is the contract both lanes must satisfy.

**Core problems to iron out:**

- **What must be preserved** Ordered prose, section hierarchy, mathematical meaning (including notation-bearing typography), figures + captions, tables (when recoverable), equation/figure/table numbers and references, cross-references, footnotes, lists.
- **What may be discarded (the “printing” quotient)** Page boundaries, headers/footers/page numbers, column layout, float placement decisions, hard line wraps, discretionary hyphens, absolute font sizes, margins, exact coordinates, pure decorative rules.
- **Register discipline**
  - Prose is default.
  - Math is entered **only** by $...$ (inline) and $$...$$ (display).
  - Prose inside math only via \\text{...} (and semantic variants).
  - Literal $ in prose must become \\$.
  - No residual flags, confidence scores, or custom type attributes inside the final Markdown.
- **Consistency / self-evidence requirements** Every math span must be renderable under the declared profile (KaTeX strict is the current bar). The delimiters must be unwavering so tokenizers and dual-RAG projections can rely on them. Notation that changes mathematical identity (\\mathbb, \\mathbf, accents, operators, etc.) must be retained; pure presentation must not.
- **Edge cases that still need policy** Equation tags / numbers (\\tag{} vs residual). Complex tables (pipe vs residual vs limited HTML). Multi-line display math that was originally aligned environments. Theorem-like environments (keep as headings + body, or residual?). How much source provenance (if any) is allowed to leak into the final document vs staying in sidecars.

The Markdown target is deliberately minimal. Richer evidence and uncertainty live outside it.

---

### 2. LaTeX → Markdown Problems (the tractable lane)

This is a **parse / transform** problem of a structured language. Most of it is already solved by latex-ingest.ps1.

**Main problem classes:**

| Problem                          | Nature                                                    | Current status                                                                      |
| -------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Author macros                    | Can hide structure and reach inside math                  | EXPAND stage (brace-aware)                                                          |
| Symbolic counters / refs         | \\ref, \\eqref, \\cite, theorem numbers                   | RESOLVE stage                                                                       |
| Math integrity during transforms | Structural changes must not corrupt math                  | PROTECT → RESTORE (math passes through verbatim)                                    |
| Structure mapping                | sections, theorems, lists, abstract, title                | TRANSFORM                                                                           |
| Tables                           | tabular, booktabs, multicolumn, \\bordermatrix            | Partial (simple cases → pipe tables)                                                |
| Diagrams                         | TikZ, xy-pic, included PDFs                               | Encode-first sub-pipeline (TikZ→SVG or tectonic→PDF→PNG) through shared md-register |
| Multi-file / \\input             | Only one level currently resolved                         | Known limitation                                                                    |
| Nested optional-arg macros       | Hard for expansion                                        | Known rough edge                                                                    |
| Non-UTF8 sources                 | Encoding issues                                           | Known rough edge                                                                    |
| Author defects                   | Typos, undefined macros, missing images                   | Handled by durable {slug}-latex.patch.jsonl                                         |
| Editorial vs faithful            | Whether to drop acknowledgements, filter references, etc. | Doctrine: faithful; filtering belongs to later promotion                            |

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

**Current approach:** pdfdig-ir.ps1 multi-lane JSONL (letters, words, blocks, paths, xobjects) + health envelope. **Open problems:** Coverage gaps (orphan letters), unreliable bold flags, complex Type-3 / custom encodings, very large path clouds.

#### 3.2 Document-local calibration & regime discovery

**Problem:** Discover the document’s own typographic regimes without absolute thresholds.

- Body size, heading tiers, script sizes, math fonts, leading, indent
- Which fonts are math vs prose vs decorative

**Current approach:** Order statistics + font-role store + tier ladder (gap-merged). **Open problems:** Noisy tier ladders, math-role ambiguity (e.g. cmbright), documents with weak or missing role signals.

#### 3.3 Reading order & layout structure

**Problem:** Recover logical order from geometric placement (especially multi-column).

**Current approach:** RecursiveXYCut on blocks (explicitly a _claim_ lane) + column-band detection. **Open problems:** Complex layouts, side-by-side figures + text, nested columns, residual suspect_reading_order cases.

#### 3.4 Heading recovery

**Problem:** Recover hierarchy (depth + boundaries) from typography + outline.

**Current approach:** Size/bold tier ladder + bidirectional outline matching + run-in detectors. **Open problems:**

- Premature commitment (body sentences matching title phrases)
- Outline fragments vs printed headings (numbering mismatch)
- Documents with weak or missing outline
- All-caps body-size IEEE-style headings

#### 3.5 Math recovery (the largest residual surface)

This is the central open problem cluster.

| Sub-problem                                                                           | Evidence available                                   | Current status                                    | Residual nature                                  |
| ------------------------------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------- | ------------------------------------------------ |
| Nested scripts (1.5-D)                                                                | Size drop + baseline shift                           | Largely solved by recursive math-assembler.ps1    | Mostly closed                                    |
| Inline vs display boundary                                                            | Geometry, math_frac, width, surrounding prose        | Decision ladder exists                            | Frequent oversegmentation / premature commitment |
| True 2-D structure (fractions, matrices, cases, binomials, limits on large operators) | Paths (fraction bars), spatial arrangement of glyphs | Flagged needs_2d_assembly + math-evidence payload | Core residual for MCP                            |
| Detached subscripts / superscripts                                                    | Baseline displacement creates separate lines         | Common failure mode                               | Residual                                         |
| Formula numbers / tags                                                                | Nearby parentheses or numbers                        | Weak / missing dedicated stage                    | Open                                             |
| Multi-line aligned displays                                                           | Geometry + alignment cues                            | Fragmented                                        | Residual                                         |
| Math vs prose role of individual glyphs                                               | Font role + context                                  | Font-role store helps; still ambiguous cases      | Residual                                         |

**Key design point:** Deterministic assembly goes as far as the 1.5-D regime. Everything that requires true 2-D relational reasoning is supposed to become a compact residual packet (glyph table + spatial sketch + candidate groupings + constraints) for the MCP / reasoning agents.

#### 3.6 Figures, captions, diagrams

**Problem:** Which ink belongs to a figure? How is it captioned? How are subfigures grouped?

**Current approach:** Highly developed — HDBSCAN (rectangle-gap) + consensus + caption cue attachment + veto ladder (furniture, inflow) + stray eject. PRIMARY (captioned) is largely closed on calibration corpora (0 overs). **Open problems:** Raster-blindness (bitmap figures with no path ink), glyph-built diagrams, some attachment edge cases, SECONDARY (uncaptioned / inline) population.

#### 3.7 Tables

**Problem:** Recover logical grid structure from geometry + rulings + text.

**Current status:** Largely deferred / residual. Geometry exists; semantic reconstruction does not.

#### 3.8 Furniture, headers, footers, page numbers

**Problem:** Identify and drop page-level chrome.

**Current approach:** Near-edge + size heuristics + furniture demotion in the figure ladder. **Open problems:** Running headers that look like section titles, complex journal chrome.

#### 3.9 Uncertainty representation & residual packaging

**Problem:** How to represent “I am not sure” so that a reasoning agent can resolve it without being given the whole page.

**Current approach:** Flags on nodes/chunks + math-evidence payloads (glyph table + spatial sketch) + membrane repair loop (dispatch → get_slice → propose_edit → apply). **Open problems:**

- Residual packets are not yet uniformly small and well-constrained
- False-confidence (unflagged wrong decisions) is still high on math boundaries
- No shared chunked IR yet that makes residual size and ambiguity recall measurable against the oracle

#### 3.10 Projection into the Markdown register

**Problem:** Turn the accepted claims + resolved residuals into clean $...$ / $$...$$ Markdown that obeys the target contract.

**Current approach:** Adapter → membrane preprocess → finalize + md-register. **Open problems:** Consistent handling of residual resolutions, equation tags, complex tables, caption relocation policy.

#### 3.11 Measurement / parity against the oracle

**Problem:** Know, unit-by-unit, how close the PDF lane is to the LaTeX oracle.

**Current state:** Strong only on captioned figures (Compare-FigureCounts). **Required next instrument:** Conversion-metric Stage 0 — aligned typed units (the shared chunked IR) so that boundary fidelity, accepted-unit fidelity, false-confidence, and residual compression can be measured on math and structure as well.

---

### Summary view of the PDF → Markdown pipeline

text

Copy

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

DESIGN.md

well im also trying to deconstruct and figure out which pieces i want to keep and potentially reshape architecture. like, what are the necessary problems to solve for pdfdig to be complete up to the measurement IR for math/prose registers, are there stores of rules that i might be able to handle differently using different kinds of unsupervised clustering or perhaps something like tree methods in tandem somehow. there are irreducible stores like the latex lexical mappings, but i feel like i'm missing something. i think pdfpig's extractoin could probably offer more, and i could probably be more creative with my feature engineering/extraction. yes there is this cascade/ladderi motif but how much can i get out of that.

Thought for 20s

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
| 6   | Inline vs display boundary decisions                     | Directly determines $ vs $$ in the IR                                            | Fragile — major source of oversegmentation and false confidence             |
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

- Symbol / glyph → LaTeX command maps (font-aware). Geometry cannot invent that \\mathbb{R} means blackboard-bold R.
- Producer-map and origin cues.
- Small core of caption cue words and similar linguistic conventions.
- Any lexical mapping that is cultural rather than geometric.

These stay as stores. Do not try to “learn” them per document.

**Strong candidates for unsupervised / hierarchical replacement or augmentation**

- **Style-palette / role recovery** (the biggest opportunity). The current size + bold tier ladder is a quantized approximation that works well on clean TeX but degrades on continuous or multi-modal documents. Better formulation (exactly as DESIGN.md §1.3 says): recover the latent style palette of the document (mixture model, hierarchical clustering, or tree methods over size/weight/family/position/recurrence), then assign roles to _configurations_ rather than individual lines via a small relational grammar + witnesses (outline, position, alternation with body). This dissolves many of the special cases in the current decision ladder.
- **Reading order**. Single RecursiveXYCut claim is brittle. A second geometric or baseline-flow witness + explicit disagreement flag is higher leverage than more ladder complexity.
- **Math vs prose isolation beyond font names**. Document-local clustering on geometric + contextual features (local density, alignment, operator-like neighbors, whitespace patterns) can augment the font-role store, especially for non-classic math fonts.
- **Competing 2-D assemblies**. Instead of only emitting needs_2d_assembly, use hierarchical clustering or multi-scale methods on the local glyph + path cloud to propose a _small set of competing groupings_. The residual packet then carries the competitors rather than a single broken surface. This is pure discovery; the agent still adjudicates.

**Policy / fitted ladders** Most of the long decision-order ladders and many thresholds in classify-config are candidates to be thinned. Prefer multi-view discovery → competing hypotheses → typed dominance rules or agent adjudication over deep single-view cascades.

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

> Multi-view unsupervised discovery (regimes, partitions, alignments) → small set of competing hypotheses with evidence → typed dominance or residual packet → agent only on the residual

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

I'm trying to peel away as many rules as possible and looking at the rules I already have in place and wondering how i might be able to do things differently to not need them in some cases. Like if i exploit the pdfpig substrate more. Can we flesh out things i might get from that that i'm not yet, in more detail?

Thought for 35s

**Yes. There is substantial headroom in the PdfPig substrate that you are not yet fully exploiting.**

The current letters.jsonl already captures a good baseline, but PdfPig (and the content stream underneath it) exposes more geometric, metric, and graphics-state signal that can turn several classes of hard-coded rules into discovery or strong geometric evidence.

Here is a concrete inventory, ordered by leverage for peeling rules.

### 1. Richer per-glyph / letter signals (easy wins to project first)

PdfPig’s Letter already gives you more than most people use:

- **StartBaseLine / EndBaseLine** — the actual baseline _segment_, not a single y-value. This is better for rotation, slant, and building precise baseline-flow graphs.
- **GlyphRectangleLoose** — uses the font’s Ascent/Descent instead of the tight ink bbox. More consistent across a font and better for vertical regime detection.
- **PointSize** vs the internal FontSize.
- **TextRenderingMode** (Fill, Stroke, FillThenStroke, Invisible, Clip variants, etc.).
- Separate **FillColor** and **StrokeColor**.
- **TextOrientation** and **TextSequence** (order of ShowText operations).

**FontDetails / IFont (via GetFont())** is the biggest under-used source:

- Ascent, Descent, CapHeight, XHeight
- StemV / StemH
- ItalicAngle
- Flags (serif, script, italic, fixed-pitch, symbolic, etc.)
- FontBBox
- Encoding / ToUnicode map details and completeness
- Font program type (Type1, TrueType, Type0/CID, Type3)

**Why this peels rules:** You can normalize size and baseline _to the font’s own metrics_ (e.g. size / XHeight or size / CapHeight) instead of relying only on body-modal size ratios and absolute thresholds. This makes regime discovery (body / script / display / heading) far more robust across documents and reduces the need for many of the current size-ratio and bold-tail special cases. It also gives a cleaner signal for math isolation when the font-role store is incomplete (cmbright-style cases).

### 2. Path geometry — currently the most under-exploited for math

Your current paths.jsonl keeps bbox + stroked/filled + simple rule tags. PdfPig can give you the full path construction:

- Exact command sequence (m, l, c, v, y, re, h, …)
- All control points and curve types
- Graphics state at paint time (line width, dash pattern, join, cap, colors)

**High-value derived relations:**

- Path–glyph incidence / proximity: “this horizontal rule sits under a run of glyphs at a consistent distance and length” → strong fraction-bar candidate.
- Glyphs enclosed between two parallel horizontal rules → matrix / cases / array candidate.
- Vertical rules + aligned glyphs → possible delimiters or matrix columns.
- Closed rectangular paths containing regularly spaced glyphs.

This is pure geometric evidence. It lets you _generate_ competing 2-D assembly hypotheses instead of only flagging needs_2d_assembly after the fact. The residual packet then carries the actual geometric competitors rather than a broken surface + a flag. That is one of the cleanest ways to shrink residual size and reduce reliance on later rules or agent invention.

### 3. Derived relational and multi-scale features (the real rule-peeling power)

These are computed from the richer substrate and stay firmly in the perception layer:

- **Alignment graphs** Edges between glyphs for: shared baseline (within tight tolerance), shared left/right edge, vertically stacked within size ratio, common x-center, etc. These become the backbone for both reading-order witnesses and 2-D structure candidates.
- **Baseline-flow / trajectory features** Sequence of baseline deltas and orientations along candidate reading orders. Excellent second witness for reading order (and for detecting when RecursiveXYCut is wrong).
- **Local density and whitespace fields** at multiple scales Useful for column detection, figure vs text separation, and math region isolation.
- **Configuration signatures** Vectors of (font-metric-normalized size, weight/flags, family, local density, position relative to body mode, rendering mode consistency, nearby path density). These are the natural input for style-palette recovery / mixture models / hierarchical clustering — exactly the redesign direction in DESIGN.md §1.3. This is how you move from “line-level decision ladder” to “configuration-level role assignment.”
- **Persistence / multi-scale stability** How stable a cluster or alignment is across a range of distance or density parameters. Directly supports the competing-hypotheses approach and gives a natural confidence/margin signal.
- **Spacing anomalies** Large advances, overlapping glyphs, unusually tight or loose character spacing — often diagnostic of math or special layout.

### 4. How this maps to peeling specific rule classes

| Current rule-heavy area            | What richer substrate enables                                                 | Potential reduction in rules |
| ---------------------------------- | ----------------------------------------------------------------------------- | ---------------------------- |
| Size/bold tier ladder for headings | Font-metric-normalized features + configuration signatures + palette recovery | Large                        |
| Math vs prose isolation            | Font metrics + local density + path proximity + rendering mode                | Medium–Large                 |
| Script attachment ratios           | More precise baseline segments + font metrics                                 | Medium                       |
| Fraction / 2-D detection           | Full path commands + path–glyph topology → competing hypotheses               | Large                        |
| Reading order                      | Baseline-flow graphs as second witness                                        | Medium                       |
| Furniture / invisible text         | TextRenderingMode + near-edge + density                                       | Medium                       |
| Some caption / cue rules           | Stronger geometric attachment + density                                       | Small–Medium                 |

The irreducible stores (symbol maps, producer-map, core caption cues) stay. Almost everything else that is currently a long decision ladder or threshold list becomes a candidate for “discover candidates + witnesses + margins → residual only when truly ambiguous.”

### Recommended enrichment order

1. **Immediate (low effort, high return)** Project FontDetails metrics, TextRenderingMode, Fill/StrokeColor, GlyphRectangleLoose, StartBaseLine/EndBaseLine, PointSize into letters.jsonl.
2. **Next** Upgrade paths to carry full command sequences + control points (or a compact topological summary).
3. **Then** Build the derived graphs and configuration features that feed palette recovery and competing 2-D hypotheses.

This stays strictly inside perception. Interpretation still happens downstream with explicit uncertainty. You simply give the discovery and residual stages much better evidence, so fewer rules are required to force decisions.

Would you like me to sketch concrete additional fields for the next version of letters.jsonl and paths.jsonl, or go deeper on how the alignment graph + path–glyph topology would generate competing 2-D math hypotheses?

![](https://www.google.com/s2/favicons?domain=github.com&sz=256)

![](https://www.google.com/s2/favicons?domain=uglytoad.github.io&sz=256)

![](https://www.google.com/s2/favicons?domain=medium.com&sz=256)

119 sources

and speaking of which, the pdfpig substrate offers a variety of different like you say, and i would want to use those in clustering. I haven't written it but i have a secondary HDBSCAN clustering approach in the works for symbolic feature. one of the things im trying to do is delineate all of the features i might be able to use or engineer, and use in clustering to different ends towards the end goal

Thought for 10s

**Yes. Here’s a practical feature catalog** organized for clustering work, especially your secondary (symbolic/typographic) HDBSCAN and multi-view discovery toward the measurement IR.

I group features by the **end they primarily serve**, then list the most useful atomic + engineered signals in each group. You can mix them; many features serve multiple goals.

---

### 1. Style-Palette / Regime Discovery

_(body, script, display, heading configurations, math-font clusters)_ This is the highest-leverage clustering target for peeling the current size/bold ladders.

**Atomic (per glyph)**

- Font-metric-normalized size: size / XHeight, size / CapHeight, size / Ascent, size / body_mode
- Font family / name (hashed or embedded)
- Font Flags (serif, script, italic, symbolic, fixed-pitch)
- StemV / weight proxy
- ItalicAngle + bbox-vs-advance discrepancy (slant proxy)
- TextRenderingMode + Fill/StrokeColor
- PointSize vs internal FontSize

**Engineered / local**

- Configuration signature vector: (normalized size, weight, family embedding, local density, vertical position relative to body mode, rendering-mode consistency)
- Multi-scale local density (glyphs in several ε-balls)
- Recurrence / frequency of the same signature on the page or document

**Natural methods**: HDBSCAN or Gaussian mixture / hierarchical clustering on the configuration vectors. Cluster _configurations_, then assign roles to them via relational grammar + witnesses (outline, position, alternation with body).

---

### 2. Math vs Prose Isolation

_(which glyphs belong to the math register)_

**Atomic**

- Font-role prior (from store) + Font Flags / family
- Unicode category / script (Math Symbol, Letter, Number, etc.)
- Is-operator-like / is-delimiter heuristics (lightweight, from Unicode or small table)
- RenderingMode (stroked operators are common)
- Normalized size relative to body

**Engineered / relational**

- Local density of math-candidate glyphs
- Distance to nearest horizontal path (fraction-bar proximity)
- Alignment strength with neighboring math-like glyphs
- Baseline offset distribution within a small window
- Color / rendering-mode consistency within the local neighborhood

**Natural methods**: Secondary HDBSCAN on the symbolic feature vector, or a joint clustering that mixes typographic + geometric features. Can also be used as a soft prior for the main regime clustering.

---

### 3. 1.5-D Script Attachment & Simple Structure

_(sub/superscripts, limits on operators)_

**Atomic**

- Baseline y (absolute + relative to local median or parent candidate)
- Size ratio to nearest larger glyph above/below
- Horizontal overlap or center-distance to candidate base
- Advance width / size ratio

**Engineered**

- Vertical stack score = f(size ratio, baseline delta, horizontal proximity)
- Shared-x or center-alignment strength
- Nesting depth proxy (recursive size-tier descent already exists; clustering can propose candidates)

**Natural methods**: Local pairwise or small-group clustering / graph edges that become script-attachment candidates. These feed the existing recursive assembler or become competing hypotheses.

---

### 4. Competing 2-D Assemblies

_(fractions, matrices, cases, aligned blocks, radicals)_ This is where full path geometry + relational features pay off most.

**Path features**

- Full command sequence or summary (horizontal rule, vertical rule, closed rect, curve complexity)
- Length, orientation, line width, dash
- Exact control points (for precise topology)

**Path–glyph relational**

- Distance from glyph baseline to nearest horizontal path
- Containment: glyph inside path-bounded region
- Glyphs lying between two parallel horizontal rules
- Vertical alignment of glyphs with vertical rules or delimiters
- Local path density around a glyph or run

**Glyph relational (within candidate region)**

- Horizontal / vertical alignment graphs
- Regular spacing / gridness score
- Multi-scale density or persistence features of the local point cloud

**Natural methods**:

- Hierarchical clustering or HDBSCAN on local glyph + path features inside candidate regions
- Generate a _small set of competing partitions_ (single display, fraction, matrix rows, etc.) rather than a single answer
- Persistence diagrams for scale-stable components

These competing hypotheses become the content of richer residual packets.

---

### 5. Reading-Order & Layout Witnesses

**Features**

- Baseline trajectory (sequence of baseline deltas and orientations)
- Shared-baseline strength along a candidate order
- Left-edge / column-band clustering
- Whitespace corridor features
- Continuity score of a proposed reading order (how well baselines and advances flow)

**Natural methods**: Graph-based or secondary clustering that produces an alternative reading-order claim. Disagreement with RecursiveXYCut becomes a flag + residual, exactly as the constitution wants (witnesses over silent arbitration).

---

### 6. Supporting / Confidence Features

_(useful across clusterings and for the measurement IR)_

- Local density at multiple scales
- Isolation / outlier score of a glyph relative to its cluster
- Stability of cluster membership across a range of HDBSCAN parameters (or distance thresholds) → natural margin / confidence signal
- Rendering-mode and color consistency within a putative region
- Font-metric completeness (missing XHeight/CapHeight is itself a signal)

---

### Practical notes for your secondary HDBSCAN

For the **symbolic/typographic HDBSCAN** you are planning, a strong starting feature vector per glyph (or per small run) is:

text

Copy

```
[
  size / body_mode,
  size / XHeight (or CapHeight),
  baseline_offset_from_local_median,
  advance / size,
  font_family_embedding or hash,
  font_flags_vector,
  stemV_normalized,
  rendering_mode_onehot,
  local_density_ε1, local_density_ε2,
  dist_to_nearest_horizontal_path,
  unicode_category_features,
  is_math_font_prior
]
```

You can run this:

- On all glyphs → regime / palette discovery
- On math-candidate glyphs only → finer internal structure
- With different distance metrics or after a learned embedding if the raw space is awkward

The geometric (path-based) HDBSCAN you already have for figures and the symbolic one become complementary views. Agreement is silent confirmation; disagreement or low-stability clusters become residuals or competing hypotheses.

---

### Suggested prioritization for implementation

1. **Project the easy atomic enrichments** into letters.jsonl (FontDetails metrics, RenderingMode, colors, loose rect, baseline segments).
2. **Define the symbolic feature vector** above and run the secondary HDBSCAN for regime discovery.
3. **Add path–glyph relational features** next — this unlocks the competing 2-D hypothesis generator.
4. **Build the alignment / baseline-flow graphs** as witnesses.
5. Only then decide which remaining ladders can be thinned or removed.

This keeps everything inside perception, gives clustering real signal to work with, and directly improves the quality of the chunks that reach the measurement IR (higher accepted fraction, more informative residuals, lower false-confidence).

Would you like me to turn any of these groups into a more formal feature specification (field names, normalization, distance considerations) for the secondary HDBSCAN, or sketch how the competing 2-D hypotheses would be represented as residual packets?

Big picture, as I'm reassessing and planning to reboot my pdf and tex conversion work in a new dedicated repo, I have been wondering about different decision tree and forests type methods, like isolation forest, random forest and others and how those might be useful in conjunction with clustering given the more complete utilization of my PdfPig IR and such

**Yes — tree and forest methods fit naturally alongside clustering once the PdfPig IR is richer.** They solve different parts of the same problem and can help you peel more rules while staying inside the perception / interpretation separation.

Here’s a practical big-picture view of how they complement each other for the reboot.

### 1. Distinct roles

| Method family                                            | Strength                                                                                                                     | Natural jurisdiction in this system                                                                |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **HDBSCAN / hierarchical / mixture clustering**          | Discovering stable regimes, configurations, and competing partitions (unsupervised structure discovery)                      | Style-palette recovery, math vs prose isolation, 2-D candidate regions, reading-order alternatives |
| **Isolation Forest**                                     | Detecting anomalies / outliers without labels                                                                                | Furniture, rare configurations, low-density glyphs, path outliers, low-confidence residuals        |
| **Random Forest / Extra Trees / Gradient Boosted Trees** | Supervised or semi-supervised scoring, feature importance, learning simple decision boundaries from dual-availability papers | Predicting oracle roles/boundaries, ranking feature usefulness, distilling candidate tier-0 rules  |
| **Single decision trees**                                | Interpretable rules                                                                                                          | Discovering simple, human-readable dominance or veto rules that can later be promoted to code      |

Clustering finds the structure. Trees/forests help decide _how trustworthy_ that structure is, detect the weird cases, and (when oracle labels exist) learn which features actually matter.

### 2. High-value conjunction patterns

**A. Clustering → Isolation Forest (within-cluster anomaly detection)** Run the secondary symbolic HDBSCAN (or palette clustering) first. Then run Isolation Forest _inside_ each major cluster (or on the residual points). This cleanly separates:

- Core members of a regime (high confidence)
- Boundary / low-density members (candidates for residual or competing hypotheses)
- True outliers (furniture, OCR garbage, rare symbols)

This gives you a natural margin signal for the measurement IR without hard thresholds.

**B. Dual-availability papers as a training signal for forests** On papers that have both PDF and LaTeX oracle:

- Extract the rich feature vectors (the ones we catalogued earlier).
- Label glyphs / configurations / boundaries from the oracle (math vs prose, heading vs body, inline vs display, etc.).
- Train a Random Forest (or ExtraTrees) to predict those labels.
- Use:
  - Feature importances → which engineered features are actually carrying signal (guides what to keep in the IR and what to drop).
  - The forest itself as a soft scorer or as a generator of candidate simple rules.
  - Partial dependence / SHAP-style views to understand interactions (size × font flags × local density, etc.).

This is one of the cleanest ways to turn the oracle into a teacher for feature selection and rule discovery, while still keeping the final runtime path free of the model if you want (distill the stable patterns into tier-0 rules or simple witnesses).

**C. Trees as rule proposers, not final deciders** Grow shallow, interpretable trees on the dual-availability data to propose dominance or veto rules (“if outline agrees and size > 1.15× body and not math-heavy → heading candidate”). Then subject those proposed rules to the normal gate discipline. Only promote the ones that survive calibration + transport. This is how the system can _grow more deterministic over time_ (the flywheel in DESIGN.md §6) without you hand-writing every ladder.

**D. Isolation Forest as a global “weirdness” detector** Run it on the full page or document feature space as an early filter for:

- Page furniture
- Nested or rotated text that should be residualized early
- Path outliers that should not enter the main figure clustering

This reduces the load on later stages.

### 3. Where this helps the reboot most

- **Style-palette recovery**: Clustering finds the latent configurations; forests tell you which features discriminate them and can score membership confidence.
- **Math register isolation**: Symbolic HDBSCAN + Isolation Forest on the residuals gives cleaner math vs prose separation with explicit low-confidence tails.
- **2-D residual quality**: Clustering proposes competing assemblies; Isolation Forest or a small forest can rank how geometricly coherent each competitor is.
- **False-confidence reduction**: Outlier scores and forest predictive uncertainty become first-class margin signals that the measurement IR can consume.
- **Rule peeling**: Feature importances + distilled shallow trees give you an empirical basis for deleting or simplifying current ladders instead of guessing.

### 4. Practical stance for the new repo

Keep the core doctrine:

- Clustering and Isolation Forest stay unsupervised / perception-side (or lightly supervised only on dual-availability data for analysis).
- Any forest that predicts semantic labels should be treated as a _teacher_ or _scorer_, not as the final authority in the runtime path unless it is heavily gated and measured.
- Prefer distilling stable patterns into explicit, inspectable rules or witnesses over shipping a black-box forest in the main conversion path.

A clean architecture sketch:

text

Copy

```
Rich PdfPig IR
    ↓
Multi-view clustering (geometric HDBSCAN + symbolic HDBSCAN + palette)
    ↓
Isolation Forest (global + within-cluster) → outlier / margin scores
    ↓
Competing hypotheses + confidence / residual packaging
    ↓
(on dual-availability papers only) Random Forest analysis → feature ranking + candidate rules
    ↓
Measurement IR (typed chunks with status + margins)
```

This combination lets you push much further on discovery while keeping the final decisions either forced (tier-0), residualized, or agent-adjudicated — exactly as the constitution requires.

Would you like me to sketch a concrete experimental plan for the dual-availability papers (what labels to extract from the oracle, what forest setup, how to use the importances), or go deeper on how Isolation Forest scores should appear in the residual packets / measurement IR?

yea i've been thinking about using forests as part of the bridge to the reasoning model's job which is likely evolving into not only residuals but for making semantic decisions. Packaged correctly and with correct epistemic guidance, perhaps somehow this could help as part of the contextual evidence for a given unit task assigned to a model or its subagents. Also, a theme i've noticed in the clustering work is that clusters often have different kinds of outliers, which i believe has shown up already in the headers problem. Please do check me on this if you can but does it make sense?

Thought for 19s

**Yes, both points make sense and fit cleanly.**

### 1. Different kinds of outliers inside clusters

This is a real and useful observation. Clusters (especially regime / palette / heading-candidate clusters) almost never have a single homogeneous “noise” class. Empirically we already see several distinct outlier types in the headings work:

- **Margin / borderline members** — size or weight just over the threshold, still statistically close to body.
- **Mixed-role or run-in lines** — bold prefix + regular tail, or math-heavy lines that happen to be large.
- **Outline-supported but typographically weak** — the classic outline_fragment / numbering mismatch cases that get demoted or over-promoted.
- **Typographically strong but outline-absent or conflicting**.
- **Local density / isolation outliers** — large isolated text that is actually a caption, figure label, or page furniture.
- **Unknown or rare font-role points**.

Treating all of these as one residual bag loses information. Distinguishing the _kind_ of outlier lets you:

- Apply different typed dominance rules or safe defaults.
- Package much more precise evidence briefs for the agent.
- Measure which residual classes are actually hard for the model versus which ones are just poorly typed upstream.

Isolation Forest (global + within-cluster) is a natural tool here. It surfaces continuous isolation scores and can help separate these modes when combined with a few simple post-hoc checks on the same feature vector.

### 2. Forests as epistemic packaging for the reasoning tier

This is a strong, constitutionally compatible direction.

The reasoning tier is already evolving from “only pure residuals” toward more semantic decisions. Forests can sit in the evidence layer of that expansion without becoming the decision maker:

- **Isolation Forest** supplies unsupervised, document-local anomaly / isolation scores and can help type the outliers above.
- **Random Forest / Extra Trees** (trained only on dual-availability papers) can supply:
  - Soft class probabilities or competing-label scores
  - Feature attributions / local explanations (“this point is being pulled toward heading mainly by size + outline agreement; density and math_frac argue against”)
  - Predictive uncertainty

Packaged correctly, these become first-class soft evidence inside the unit-task brief, exactly analogous to how math-evidence already projects geometry into a text form the model can use.

A sketch of the packaging contract:

JSON

Copy

```
{
  "question": "Is this a heading, and at what depth?",
  "unit_features": { ... },
  "cluster": {
    "id": "...",
    "membership_strength": 0.71,
    "outlier_kind": "margin_size_outline_conflict",
    "isolation_score": 0.82
  },
  "forest_evidence": {
    "type": "supervised_rf_dual_availability",
    "trained_on": "N papers, config_hash=...",
    "predicted_labels": {"heading": 0.64, "body": 0.29, "other": 0.07},
    "top_supporting_features": ["size_ratio", "outline_agreement"],
    "top_opposing_features": ["math_frac", "local_density"],
    "epistemic_status": "soft evidence only — not authoritative"
  },
  "geometric_evidence": { ... },
  "constraints": ["must be consistent with outline witness if present", "prefer abstention over false positive"],
  "verifier": "deterministic heading grammar + render/lint"
}
```

Key principles that keep this clean:

- Forests never decide. They only enrich the evidence brief.
- Epistemic status is explicit (“unsupervised isolation score”, “supervised soft prediction trained on dual-availability data”).
- The agent still proposes; the deterministic verifier still gates.
- Consistent agent decisions on a given residual class can later be distilled into better features or tier-0 rules (the flywheel).

This turns the different kinds of outliers from a nuisance into a feature: each type can carry a slightly different evidence package and prompt, which should improve both residual compression and the quality of the semantic decisions the model is asked to make.

The overall shape stays faithful to the constitution: richer perception and discovery upstream, better-typed evidence for the reasoning tier, and no silent resolution of disagreement.

Does this match the direction you were sensing, or do you want to push further on how the outlier typing or the forest evidence should be structured for specific unit tasks (headings vs 2-D math vs inline/display boundary)?

I was kind of thinking of using isolation or random forest \*within clusters labeled by hdbscan\*, symbolic or geometric, as a way of trying to inductively disambiguate or refine the discovery of, for example, headers.

**Yes — that is a clean and productive pattern.**

Using Isolation Forest (or a lightweight forest) _inside_ HDBSCAN clusters is one of the better ways to move from coarse regime discovery to finer, more reliable structure without writing more ladders.

### How the pattern works for headings

1. **Primary clustering (symbolic or joint geometric+symbolic HDBSCAN)** Produces candidate regimes / configurations. One or more of these clusters will contain most of the heading-like material (large size, higher weight, certain fonts, positional recurrence, etc.).
2. **Within-cluster Isolation Forest (or local density + isolation scoring)** Run on the members of the heading-candidate cluster(s) using the same or a refined feature vector. This surfaces the internal structure of the cluster:
   - Core, high-density, low-isolation members → strongest heading candidates.
   - Margin / borderline members → size or weight just across the threshold.
   - Mixed-role or run-in points.
   - Outline-supported but typographically weak points.
   - Local outliers that happened to land in the cluster (captions, figure labels, page numbers, math that is large, etc.).
3. **Inductive refinement** The isolation scores + a few cheap relational checks (outline agreement, position in the page, local density, math_frac, bold-tail ratio, etc.) let you _type_ the members of the cluster instead of treating the whole cluster as uniform. You can then:
   - Promote the core low-isolation members more confidently (or with higher margin).
   - Send the different outlier kinds into more precise residual packets or competing hypotheses.
   - Apply typed dominance rules only where the evidence is strong (e.g., core + outline agreement → accept; high isolation + no outline → residual or demote).

This is inductive in the useful sense: the clustering proposes a hypothesis about a regime; the within-cluster forest tests the coherence of that hypothesis and exposes its internal heterogeneity. You are not forcing a single decision on every member of the cluster.

### Why this is better than the pure ladder for headings

The current heading ladder has to hard-code many of the distinctions above (run-in detection, math-heavy veto, outline fragment handling, etc.). By letting HDBSCAN first group the plausible candidates and then letting Isolation Forest characterize the _kinds_ of members inside that group, many of those distinctions become observable properties of the data rather than special cases in a decision list.

The same pattern generalizes:

- Inside a “math” cluster → refine inline vs display vs operator-heavy vs residual 2-D.
- Inside a large-size cluster → separate true headings from display math, section numbers, captions, etc.
- Inside figure-related clusters → separate clean regions from strays or furniture that leaked in.

### Epistemic status and jurisdiction

This stays cleanly on the perception / discovery side:

- HDBSCAN + within-cluster Isolation Forest are still unsupervised (or only lightly informed by dual-availability analysis).
- They produce typed candidates + scores + outlier kinds.
- Final acceptance, residual packaging, or agent adjudication still follows the normal jurisdiction ladder.
- The forest is not making the semantic decision; it is refining the discovery so the downstream decision (or residual) is better informed.

When you later look at dual-availability papers, you can also train a small supervised forest _on top of_ these within-cluster features to see which isolation patterns actually predict oracle heading status. That becomes analysis and potential rule distillation, not runtime authority.

### Practical sketch for headings

text

Copy

```
Symbolic (or joint) HDBSCAN
    → heading-candidate cluster(s)
        → Isolation Forest inside the cluster
            → core members (low isolation)
            → margin members
            → mixed-role / run-in
            → outline-conflict or outline-only
            → local density outliers
        → typed candidates + scores + evidence
            → dominance rules or residual packets
```

This gives you a much more nuanced view of the “heading” regime than a flat cluster or a long decision ladder, and it directly addresses the multi-type outlier phenomenon you observed.

It is a good direction for the reboot. It keeps the discovery machinery data-driven while still producing the typed, confidence-aware candidates that the measurement IR and the reasoning tier need.

Do you want to pressure-test this pattern on the other major residual classes (especially inline/display math boundaries or 2-D candidates), or refine the feature vector that should be used for the within-cluster Isolation Forest on headings?
