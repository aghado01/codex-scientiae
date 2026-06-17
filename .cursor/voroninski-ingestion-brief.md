# Brief: finish the Voroninski `full/` papers via the restoration MCP

## What's already done (deterministic floor)

The 8 previously-unworked Voroninski papers under `ingestion/corpora/Voroninski/{slug}/full/` have
been run through the deterministic pipeline. Each now has an enriched, graded chunk stream **plus a
finalized draft** in `{slug}/full/.scratch/` (`{slug}.md` + `references/{slug}.md`). Already applied:

- **structure** — furniture stripped (running heads, repeated panel labels, captions, crumbs); prose
  un-bled from display formulas; citation-run references routed to a sidecar; **collapsed front
  matter recovered** — a letter-format paper with no section headings no longer renders its whole
  body under front matter (`Invoke-Sections` re-establishes the front→body boundary heuristically).
- **content** — display math de-spaced, `\mathbb` stripped, unicode→LaTeX; **inline subscripts /
  superscripts reconstructed** from each paper's own display notation (the "display vocabulary");
  inline math wrapped in `$…$` — now **bracket-balanced**, so a `( … )` is never split across the
  `$` boundary (the wrap-split-parens fix landed in `ConvertTo-InlineMath`); ligatures repaired.
- **grading** — per-chunk fidelity + a closure/structure scanner (`Find-MathClosureIssues` in
  `src/md-cleanup.ps1`) that produces the handoff punch-list.

Slugs: `1404.3811v1 1602.04426v2 1606.04970v3 1611.05985v3 1705.07576v3 1804.02008v2 1807.04261v1 2008.10579v1`.
Start with **1611.05985v3** (cleanest). **1606.04970v3** is over-segmented (spurious headings →
`retype_chunk` to prose). **2008.10579v1** is the densest (most residue).

These `.scratch` drafts were laid down **before** the bracket-balance + front-matter fixes above, so
re-preprocess from raw to pick them up (safe — all 8 are still at `finalized`, none carry applied MCP
repairs; `1611.05985v3` and `2008.10579v1` are already re-run):
`. src/preprocess.ps1; Invoke-Preprocess -JsonPath ingestion/corpora/Voroninski/{slug}/full/{slug}.json -Force`
(the MCP `preprocess` tool's resolver expects `{slug}/{slug}.json`, not the `full/` nesting, so use the
function directly for these). Re-run **before** you start MCP repairs on a paper, never after — `-Force`
re-lays the deterministic floor and would clobber applied edits. Do **not** run `Invoke-Normalize`
twice on already-wrapped chunks.

## Your job — reason the residue, then finish

The deterministic floor is laid; what remains needs judgment. The scanner flags it:

- **inner-product brackets** `\langle … \rangle` and **norms** `\|·\|` that inline extraction dropped
- **genuinely mangled equations** — prose tangled into a subscript/`\substack` (corrupted extraction)
- **over-segmented / spurious headings** — `retype_chunk` to prose

## Use the MCP membrane (manually)

Wire the server per **`src/SETUP.md`** — it **defaults** to the `ingestion/` root, which keeps
`corpora/` in scope. Do **not** pin `-Root` in the MCP config; the default is what reaches these
papers (a narrower root, e.g. `compendia`, hides them). Address papers by slug — the resolver crawls
`**/.scratch/{slug}.chunks.jsonl`, so the `full/.scratch/` drafts are found. The full workflow is in
**`src/PROCEDURE.md`**. Per-paper loop:

1. `get_batch_summary` / `list_documents` — papers + actionable counts.
2. `dispatch` (paper) — a leased bundle of flagged chunks.
3. per flagged chunk: `get_slice` → reason → `propose_edit` (surgical find/replace) **or**
   `retype_chunk` / `split_chunk` / `merge_chunks` (structural) → `apply`.
4. `finalize` (paper) → the deliverable in `.scratch/`.
5. `review_document` (paper) — the ONE holistic read; fix any catches; repeat until clean.

## The "finished" bar (gates promotion)

- `pending == 0` (no flagged chunks left)
- `Find-MathClosureIssues` clean on the finalized `.md` (`. src/md-cleanup.ps1`)
- a clean `review_document` holistic pass

## Promotion — ONLY when finished

Move the finished pair to the corpus convention (match an existing `corpora/VladVoroninski/*.md`):
- body → `corpora/VladVoroninski/{slug}.md`
- refs → `corpora/VladVoroninski/References/{slug}-references.md` (capital `References/`, `-references` suffix)
- flip the body's reference link from `references/{slug}.md` → `../References/{slug}-references.md`

## Hard rules

- **No partial promotion.** The corpus holds finished work only; unfinished stays in `.scratch/`
  (gitignored). This is firm.
- **No `git commit`.** Staging (`git add`) is fine; commits are the user's, gated on end-to-end success.
- **Never regenerate content by hand** — use `get_slice` + `propose_edit` so nothing is fabricated.
- Math standard: subscripts/superscripts are load-bearing (semantics), display centered in `$$`,
  minimalist LaTeX (no `\mathbb`).
