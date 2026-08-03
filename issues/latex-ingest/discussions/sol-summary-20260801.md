I read all 67 exchanges in [the thread export](D:/aghado01/codex-scientiae/issues/Claude-5f3f3bb4-0568-4b71-9968-ec5a9a9821ba.md) and reconciled them with current `main`.

The durable outcomes are:

- TOC manifests now use verified byte spans, relative links, live author/DOI metadata, payload inventories, and no `char_count`.
- Legacy `md-toc` has since been retired; anchor generation is a shared invariant.
- Reference semantics live in their own LaTeX-domain stage and stores. The full typed docgraph remains a build artifact.
- The manifest’s Subject Index is evidence-derived from what LaTeX ingestion emits—not inferred from bold Markdown. The TOC engine only renders supplied index data.
- Subject-index labels are resolved in memory; final Markdown is consulted only to establish byte positions. Missing emitted headers now warn loudly.
- `reader-mcp` is a separate portable, read-only consumer server with document discovery, manifest inspection, section/span reading, and heading search.
- Run artifacts default to `artifacts/latex-ingest/runs/{runstamp}/{slug}`. Source staging, run output, lane output, and bundle destination remain independently configurable; deterministic unpacked sources can be reused.
- TikZ remains SVG in intermediate representation; bundling converts it to PNG.
- Embedded contents remain opt-in and use ordinary links; byte-address metadata belongs in sidecars.

The major philosophical line is also clear: preserve and route domain evidence before lossy surjection; don’t fabricate semantics later from rendered Markdown. Manifests are navigational/contextual inventories, not scoring or “what to skip” guides.
