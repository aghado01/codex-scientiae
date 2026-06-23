# The Ingestion Stack — a geometry-vision swarm for PDF→standard

*Status — 2026-06-23: north-star concept brief, not an implementation. Provenance: the web-fetcher
thread → "codex-membrane is a stopgap **and** a training exercise" → this. DELIBERATELY shape-agnostic.
Every concrete name here — codex-membrane, opendataloader-pdf / Docling, PdfPig, ps.core.pdfdig, the
PowerShell-Core mono-repo — is the **present instance**, not the design. The user is mid-migration off
the mono-repo to a next-gen shape that is TBD; this brief commits to the **invariant concepts** and
treats language / runtime / repo layout as unbound. Read every "today it is X" as "X is replaceable".*

> The PDF already holds the structural ground truth — as geometry. So don't re-perceive it from pixels
> with a VLM; **reason over the geometry with language models**, and run the membrane's **tiered
> orchestrator/worker swarm** as the engine. Extraction and repair collapse into one geometry-native
> act, performed where the disambiguating information still lives instead of reconstructed from its
> shadow afterward.

Concept sources (present instances of durable ideas):
- The separation discipline — orchestrator/worker fan-out, body-blind slices, grading, detectors-as-
  gates, audit/provenance, leasing — currently embodied by codex-membrane.
- The failure taxonomy as a **geometry-signal map**: [`../WORKFLOW.md`](../WORKFLOW.md) (splayed math,
  isolated sub/superscripts, ligatures, PUA hints) — each entry is a geometric fact markdown discards.
- The input-quality ladder fed by the web-fetcher family ([`scihub-fetcher-brief.md`](scihub-fetcher-brief.md)
  and the arXiv `source`/`html` artifacts).

---

## 0. Invariants vs. packaging (the fluid bracket)

| Durable (the design) | Transient (today's instance, will change) |
|---|---|
| Geometry-bearing IR as the substrate | PdfPig as the IR library; .NET as host |
| Language reasoning over geometry, **not** pixels over a VLM | which models; local vs hosted workers |
| Tiered orchestrator → worker swarm with grading + audit | codex-membrane's PowerShell MCP shell |
| Deterministic-first, model-only-on-residue | the exact tier boundaries |
| Detectors as in-loop validity gates | their current post-hoc use |
| A single coalesced "codex-scientiae standard" output | the standard's current markdown shape |
| repo/runtime/layout | mono-repo `ps.core.*`; migrating to TBD |

Everything in the right column is free to move. The left column is the brief.

---

## 1. The bet: geometry-vision over pixel-vision

Mainstream PDF→structured extraction (Docling and kin) increasingly renders the page to pixels and lets
a **VLM** read layout, formulas, tables. The counter-bet:

> A born-digital PDF is a **lossless** structural source. Rendering it to an image and asking a VLM to
> re-read it is a **lossy re-encoding followed by noisy re-perception**. Use the source directly: the
> glyphs, their positions, their fonts, the vector ops — and let a language model reason over *that*.

Why it should win where it matters:
- **Math.** VLMs approximate/hallucinate formulae from pixels. Glyph geometry + the font's `ToUnicode`
  gives the **actual symbols**; the LM reconstructs LaTeX from ground-truth tokens and their 2-D
  relations (super/subscript = baseline offset; fraction = vinculum vector over stacked operands;
  matrix = aligned grid) — far less to invent.
- **Cost / determinism.** Most text is recoverable from geometry with **no model at all** (cheap,
  exact, reproducible). Pixels are expensive tokens and opaque perception. Models adjudicate only the
  residue, and they see geometry, not noise.
- **Fidelity to the failure taxonomy.** Every WORKFLOW.md failure mode is a geometric fact in the IR
  and absent from markdown — so this attacks them at the layer they actually exist.

The cost of the bet — stated honestly: a PDF has **no logical structure** (it is positioned glyphs +
drawing ops). Geometry **under-determines** semantics. You must build the geometry→semantics inference;
that is the hard, open core (§6).

---

## 2. The substrate: a geometry-bearing IR + a "seeing" agent that reads it

A PdfPig-class IR exposes glyph runs with bounding boxes, font name/size, `ToUnicode`, vector graphics
(rules, fills), and render/operator order. The **"seeing agent" sees through this structured projection,
not through an image** — it perceives the page as positioned symbolic content, which is exactly enough
to reason about layout while staying in ground truth. (Vision is retained only as a *last-resort tool*
for genuinely pictorial residue — a photograph, a hand-drawn diagram — not as the primary organ. The
primary–geometry / vision–as-escape hybrid is an open lever, not a commitment.)

---

## 3. The engine: the membrane's tiered separation swarm, transferred

The membrane's mechanics map onto extraction almost verbatim — the same skeleton, a new job (it now
**produces** the unit from geometry instead of **repairing** flattened text):

| Membrane mechanic (today, repair) | Transferred (extraction) |
|---|---|
| orchestrator fans body-light work-unit pointers | fans **geometry-light region pointers** (a formula span, a table region, a reading-order question) |
| worker pulls one slice, holds nothing else | worker pulls one **region**, reasons from its geometry |
| repair via surgical diff, never regenerate | **resolve** the region: geometry (+ LM if ambiguous) → standard output |
| grading: faithful / needs_review / unrecoverable | per-region **confidence**; escalate the genuinely ambiguous |
| detectors (delimiter balance, env closure) post-hoc | the **same detectors as in-loop validity gates** |
| audit trail of every change | audit trail of every **extraction decision** |
| leasing / release / stateless between steps | unchanged — scale + resumability for free |

The decisive collapse: **extraction ≡ repair**, in-lined. The worker that resolves a formula region is
*doing the repair* while it still has the coordinates — there is no degraded intermediate to fix later.

Workers are **substrate-agnostic** (model-agnostic, gated by governance; local models are the intended
worker tier per the standing direction). The swarm is the *architecture*, not a provider.

---

## 4. The tiers (deterministic-first, model-on-residue)

- **T0 — deterministic geometric text.** Glyph runs → words → lines → blocks by geometry; `ToUnicode`
  → real Unicode; obvious reading order. Most of the document, no model, exact.
- **T1 — structural inference.** Block roles (heading/body/caption/footnote), column flow / reading
  order, list & section structure. Light model or heuristic; detectors gate.
- **T2 — enrichment swarm.** The hard residue, one scoped unit per worker: **math** (region geometry →
  LaTeX), **tables** (ruling vectors + alignment clustering → cell grid; LM adjudicates spans/headers),
  **figures**. This is the tier that replaces Docling's VLM formula/table enrichment — geometry+LM-
  natively. Vision tool only here, only as escape.
- **T3 — coalesce + audit.** Serialize to the one codex-scientiae standard; emit the decision/provenance
  log (§7).

T0/T1/T2 are the "faithful / needs_review / enrichment" lanes you already run, re-cast as a forward
pipeline rather than a post-hoc cleanup.

---

## 5. Worked replacements for the VLM enrichment

- **Formula.** *Was:* VLM reads rendered image → LaTeX (noisy). *Now:* the region's glyphs (positions,
  sizes, math fonts) parsed into a 2-D structure, handed to an LM that emits LaTeX from **known symbols**.
  Detector: delimiter balance / environment closure (already in the membrane) gates the result.
- **Table.** *Was:* VLM segments the table image. *Now:* vector ruling lines + text x/y alignment →
  candidate cell grid; LM adjudicates merged cells / header inference. Detector: rectangularity /
  row-consistency gate.

---

## 6. The research core — "PDF rendering concepts TBD"

The genuine open prize, named plainly (this is the "not easy / in infancy" part):
- **Invert the renderer's forward model.** A renderer maps glyphs+ops→layout deterministically;
  recovering logical structure is inverting that. Formalizing it enough to generalize is the crux.
- **Hard layout:** multi-column, floats, marginalia, rotated/var-baseline text, running heads.
- **Hard math:** nested radicals, large operators with limits, multi-line aligned displays, matrices —
  geometry helps but the 2-D parse before the LM is non-trivial.
- **LM-in-loop discipline:** determinism, cost, caching, when geometry is "ambiguous enough" to spend a
  model call, and the vision-escalation policy.
- **Born-digital boundary:** this engine assumes a real text/geometry layer. **Scanned/image-only PDFs
  still need OCR/vision** — out of scope for the geometry path; route them elsewhere.

---

## 7. The stopgap manufactures its own spec

codex-membrane's audit/repair log **is the labeled corpus + spec** for the inference layer and the in-
loop models: every fix is "geometry-situation X mis-handled as Y, correct = Z." Actionable *now*, cheaply,
while the stopgap runs: **retain PDF provenance (page, bbox) through the current pipeline** even though
unused today (Docling already carries coordinates) — so the accumulating repair record becomes
**geometry-linked** training/eval data the future extractor consumes natively. This is what makes the
"training exercise" literal rather than aspirational.

---

## 8. The input-quality ladder (why the fetcher family matters here)

Extraction difficulty is set at acquisition. Prefer the richest available source; the geometry-swarm is
the engine for the **PDF rung**, not the only rung:

1. **LaTeX source** (arXiv `source` artifact) — the authored math itself; often **skip extraction
   entirely**, parse the `.tex`. Richest.
2. **Native HTML / MathML** (arXiv `html` artifact) — structure + math already marked up.
3. **Born-digital PDF** — the geometry-vision swarm (this brief).
4. **Scanned PDF** — OCR/vision required; different lane (§6).

The web-fetcher family's job is to pull the **highest rung available** for each paper, so the heavy
geometry engine is reserved for when nothing better exists. (This is why the arXiv fetcher now stages
`source`/`html`, not just `pdf`.)

---

## 9. Discipline carried over — don't collapse to a monolith

"In-line the repair" changes the **substrate** (geometry, not degraded text) and the **timing** (assist
during extraction, not after). It must **not** dissolve the membrane's separation: keep staged units,
per-unit grading, body-blind/scoped model calls, detectors-as-gates, leasing, and the audit trail. The
value was never only the repair playbook — it was the auditable, resumable, scoped *architecture*. Same
skeleton; richer nervous system.
