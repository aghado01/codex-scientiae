# The Restoration Membrane

> Draft. A pure-PowerShell MCP server that turns Docling / opendataloader JSON IR exports into a
> repaired, agent-servable corpus — clean markdown bodies + reference sidecars, per `STANDARDS.md`.

This directory is the whole system. No external dependencies beyond **PowerShell 7+** and .NET regex;
every file dot-sources its siblings via `$PSScriptRoot`, so the server is self-contained.

To wire it up, see **[SETUP.md](SETUP.md)**. For the agent workflow once it's running, see
**[PROCEDURE.md](PROCEDURE.md)**.

## The shape

```
raw {slug}.json                                          deliverable
  │  Invoke-Preprocess (8 deterministic stages)            ▲  finalize
  ▼                                                        │
.runs/{stamp}/{slug}.chunks.jsonl  ──►  membrane tools  ──►  {slug}.md + references/{slug}.md
   (graded chunk stream)                 (the MCP)             (corpus markdown, LaTeX-consistent)
```

The **preprocess** pipeline is deterministic and does everything it can without a model:
`project-ir → headings → collapse → zones → sections → normalize → fidelity → repair`. It lands an
enriched, graded chunk stream in a fresh runstamped directory (`.runs/{yyyyMMdd_HHmmss}/`) **beside
the source** (source-tracked by position, fan-out friendly). Runs are append-only — **every
preprocess pass creates a NEW run** and never touches a prior one (preprocess starts a workflow; the
read/repair tools continue one). Resolution is newest-run-wins, or pin any run explicitly as
`{paper}@{runstamp}`. The **membrane** is the MCP surface a seeing agent drives to resolve
what's left; **finalize** assembles the corpus deliverable.

## The membrane's discipline

- **Navigate → slice → edit → proofread.** Most tools return metadata + pointers; content comes back
  only where content *is* the point (`get_slice`, `get_audit`, `review_document`). The orchestrator
  stays body-blind — it reasons over the work-list, not the prose.
- **Artifacts are ground truth.** The server is RPC over stdio; state lives in the run-dir
  artifacts, not the process. An amnesic agent re-grounds from `get_batch_summary` and resumes.
- **Three windows on a document:** the **ledger** (`*.ledger.jsonl`, milestones — verbs), the
  **inventory** (`inventory.json`, in-play artifacts — nouns), the **audit** (`*-audit.jsonl`,
  events). All auto-maintained.
- **Anti-clobber by construction.** Repairs are per-chunk proposals, leased before work, folded into
  the stream only when clean (`apply`). Nothing is mutated silently; `content_raw` keeps every
  pre-image.

## Tools (21)

| Family | Tools |
|---|---|
| **On-ramp** | `list_documents` (survey the ingestion root), `preprocess` (run the pipeline → a fresh `.runs/{stamp}/`) |
| **Inspect** (pointers) | `get_summary`, `get_hotspots`, `get_batch_summary`, `get_inventory`, `get_audit`, `search` |
| **Slice** (content) | `get_slice` (scoped, staged-aware) |
| **Repair — content** | `propose_edit` (surgical find/replace), `propose_repair` (wholesale), `apply`, `release` |
| **Repair — structure** | `retype_chunk`, `split_chunk`, `merge_chunks` (immediate, audited) |
| **Escalate** | `mark_unrecoverable`, `request_review` |
| **Orchestrate** | `dispatch` (budget-bounded leased work bundle) |
| **Deliver** | `finalize` (→ corpus markdown), `review_document` (the one holistic proofread) |

## What the deterministic pipeline handles

- **Typographic heading recovery** — promotes mis-typed body text to headings by font contrast;
  demotes running heads and repeated panel/figure labels to furniture.
- **Math** — de-spaces tokenized LaTeX (`\frac { d + 1 } { 2 }` → `\frac{d+1}{2}`), strips font-only
  macros (`\mathbb`), wraps inline math (glyph-run detection off Unicode property classes), and
  converts unicode → LaTeX so inline and display math are consistent.
- **Furniture** — figure/table captions, subfigure labels, OCR crumbs tagged out of the body.
- **Zones & sections** — frontmatter / body / backmatter; numbered + font-calibrated heading levels;
  the bibliography region split into the references sidecar.
- **Fidelity grading** — corruption signatures (intertext, gibberish, unbalanced delimiters, …) flag
  the bounded work-list the agent resolves.

## Status

Draft / functional. Validated end-to-end over the wire on struct-tree and non-struct-tree papers.
Known next piece: **table handling** — table cells currently leak as prose/headings and need the
agent's structural ops; deterministic table-awareness is the proper fix.
