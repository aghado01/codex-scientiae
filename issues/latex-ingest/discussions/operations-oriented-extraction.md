# ok. yeah there are alot of things buried i think i the presumptive evictees that are 'use-case' shaped that i'd rather recapture as 'operation-shaped'

Exactly. I think that should become the governing extraction rule:

A capability is worth recapturing when its contract can be stated independently of the product that first needed it.

For example:

- “Validate mathematical Markdown rendering” — not “membrane render-check.”
- “Rasterize a PDF page or region” — not “pdf-converter image helper.”
- “Compile a TeX fragment” — not “latex-ingest diagram fallback.”
- “Resolve a run address” — not “membrane run lookup.”
- “Read/write indexed JSONL” — not “chunk-stream storage.”
- “Bundle Markdown with referenced assets” — not “latex deliverable export.”

The clean separation is:

- Operation: inputs, outputs, failure semantics, and report schema.
- Workflow adapter: when the operation runs and where its artifacts go.
- Policy/store: project-specific rules or mappings supplied to the operation.
- Engine/payload: KaTeX, MuPDF, Tectonic, or another external dependency.
- Product shell: coordinates operations but owns none of their reusable mechanics.

Importantly, extraction should preserve the operation’s idea—not automatically its implementation. If the buried implementation carries bad assumptions, global state, product-specific addressing, or weak error handling, we can write down the contract and rebuild it cleanly instead of transplanting the contamination.

`math-render` is a good reference specimen: membrane no longer owns it, latex-ingest merely consumes it, KaTeX is replaceable engine detail, and a future PDF workflow can produce the same audit schema under its own run. That is the shape I’d use while carving through the evictees.
