# pdfdig → membrane handoff — the dual-lane IR intake

**Status:** LANDED (transitional integration, 2026-07-03). The membrane now accepts **two IR
intake dialects** through one on-ramp, so pdfdig-converted papers flow through today's
preprocess → repair → finalize stages while the de-novo workflow (pdfdig-ps-converter.md
§"De novo, not post-hoc") is still being built. This is the brief's explicit transitional clause:
"Membrane-compatible IR emission remains as the transitional integration — pdfdig IR feeding
today's membrane stages — while the de novo workflow is built."

## The two lanes (positional contract, one paper dir)

Both live in `{paper}/` beside the PDF and share the membrane's slug addressing:

| Lane | Raw the membrane resolves | Sibling artifacts | Origin |
|---|---|---|---|
| `opendataloader` | `{slug}.json` | — | docling-era converter (VLM-primary, geometry discarded) |
| `pdfdig` | `{slug}.pdfdig.json` (envelope) | `{slug}.nodes.jsonl` (classified run-nodes), `{slug}.classify.json` (calibration + cross-derivation), `{slug}.letters/words/blocks/paths.jsonl` (substrate lanes) | in-house deterministic PdfPig lane |

**Selection.** `Resolve-PaperSource -Lane auto|opendataloader|pdfdig` (runs.ps1). `auto` (default)
prefers opendataloader while it remains the established baseline, else falls to pdfdig. The
`preprocess` MCP tool exposes `lane`; `list_documents` reports each paper's available `lanes[]`.
`preprocess` also sniffs the path suffix: a `{slug}.pdfdig.json` argument selects the pig lane
regardless.

## What the adapter spends (src/pdfdig-adapter.ps1)

pdfdig emits **run-level** typed nodes; the membrane's stages consume **line/shard-level** nodes
that `Invoke-Collapse` agglomerates. `Invoke-ProjectPdfDigNodes` bridges them, and in doing so
*spends the born signals* so downstream never reverse-engineers what opendataloader destroyed:

| pdfdig node | → membrane node | consequence |
|---|---|---|
| `heading-candidate` line | `type: heading` (pre-promoted) + `heading_level` from outline | **`Invoke-HeadingRecovery` is SKIPPED** on this lane — it exists to undo docling's scrambled `level`; here headings are born correct (typography tier + PDF-outline cross-derivation) |
| `formula-block` group | ONE `type: formula` node (group lines joined) | finalize wraps `$$…$$`; stacked groups keep `needs_2d_assembly` — 2-D assembly is the deferred C# AST tier |
| `prose`/`mono` line | `type: paragraph` with inline `$…$` seams, `_{}`/`^{}` from geometric scripts | inline math survives — the class opendataloader always flattened (`p1` for `p₁`) |
| `marker` line | **dropped + counted** | page furniture identified by born signals (orientation, margins) at the adapter, not re-detected downstream |

Ligatures + symbol-map corrections arrive already applied (classifier, store-driven — the
substrate stays byte-faithful below). U+FFFD and `flags[]` ride through untouched.

## What the agent is told (preprocess result)

The `preprocess` result echoes `ir_lane`, and on the pdfdig lane adds `lane_notes` spelling out the
semantic differences so the repair agent reasons correctly:

- headings are **pre-typed** (recovery skipped); tier/outline provenance is in the `.classify.json`
  sidecar.
- inline math carries `$`-seams with geometric sub/superscripts; formula chunks are grouped
  display-math lines with 2-D assembly pending.
- page furniture was **already dropped** at the adapter.
- ligatures + symbol corrections **already applied**.
- **node `flags[]` are the converter's own uncertainty markers, not detected corruption** — they
  are dispatchable work-units (`fractured_math_span`, `unmapped_symbol`, `needs_2d_assembly`,
  `suspect_reading_order`, `unknown_font_role`), the honest-residue channel the de-novo workflow
  will consume in-line.

## Shared fixes this surfaced (help both lanes)

- **`zones.ps1` Roman-numeral body start.** IEEE numbering ("I. INTRODUCTION") wasn't a
  body-start heading — frontmatter swallowed the whole paper. Now Arabic/Roman/bare-Introduction
  all open the body. This was a latent opendataloader bug too (the 2508.11646 zoning failure on
  record); the pig lane just made it unmissable.

## Validation (2508.11646, the born-two-column specimen)

preprocess on the pig lane: 846 chunks (533 prose, 60 heading, 253 formula), zones
frontmatter(11)→body(502, opens at "I. INTRODUCTION")→backmatter(333, opens at REFERENCES), title
picked, inline `$…$` intact through normalize/fidelity, 773/846 chunks graded faithful. Full repo
test suite green including the encoding invariants.

## Known follow-ups (membrane-tier semantics, NOT handoff blockers)

- title line-wrap: the two physical title lines land as two heading chunks (a `heading` merge for
  wrapped same-tier frontmatter lines would fix both lanes).
- subsection over-promotion: `-Medi` run-in headings ("Chain Complex:") promote at the bold-body
  tier; the outline knows their true depth — a tier-vs-outline reconciliation is the refinement.
- formula-block content is 1-D (`\delta_{\gamma}`); 2-D structure stays flagged for the AST tier.

## Determinism note

The adapter's per-line/per-formula flag sets use `SortedSet[string]`, not `HashSet` — HashSet
enumeration order is nondeterministic and (a) breaks the byte-stable-lane contract and (b) poisons
`Write-JsonlStage`'s Newtonsoft fast path via PSObject wrapping. Enforced by
tests/encoding-invariants.Tests.ps1.
