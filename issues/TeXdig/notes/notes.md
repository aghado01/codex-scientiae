## Dependencies

### Installed surface

All unified-latex packages are pinned at `1.8.4`:

- `@unified-latex/unified-latex`
- `unified-latex-util-parse`
- `unified-latex-util-visit`
- `unified-latex-util-match`
- `unified-latex-util-environments`
- `unified-latex-util-print-raw`
- `unified-latex-util-macros`
- `latex-utensils@7.0.0`

## Pipeline order

A sensible initial order is:

1. Discover and decode source files.
2. Build include/resource graph.
3. Parse LaTeX and BibTeX.
4. Index scopes, declarations, labels, citations, and resources.
5. Construct macro environments.
6. Elaborate macros on demand.
7. Lower structural and inline semantic nodes.
8. Resolve labels, references, citations, counters, and bibliography inheritance.
9. Run math normalization and renderability audits.
10. Project Markdown, docstream, refgraph, and evidence artifacts.

The pass model prevents another monolithic converter from gradually emerging.

## What to borrow from the old system

Bring forward the knowledge, not the mechanism:

- Golden conversion cases and batch corpus.
- Reference-macro configuration.
- Math normalization data.
- Recovery evidence and authored patch records.
- Document graph semantics.
- Source archive safety and entrypoint discovery.
- Diagram rendering and renderability audits.
- Cases where the old converter demonstrably recovered difficult papers.

Treat each as an acceptance test for the new implementation. Where the new system diverges, inspect whether the old result captured real semantics or merely happened to look right.

The first milestone should not be Markdown. It should be a source-backed JSON representation that proves:

1. Math nodes are exposed correctly.
2. Macro definitions and invocations are linked.
3. Expansion retains provenance.
4. Citations resolve to parsed BibTeX entries.
5. Every entity can recover its exact original source slice.

Once that substrate is correct, the old conversion quality becomes something you can regain through clean passes rather than another accumulation of rewrites.
