# Condensed concepts

Heterogeneous sources are abduced via surjective canonicalization to a latent manuscript envelope containing orthogonal math and prose registers/streams/channels/modes (preferred nomenclature TBD), interleaved in the reading-order sequence, and from which one may "demux" for dual-sector embedding and cross-link for RAG

The envelope instance is a typed DAG. Classic ASTs are spanning-tree projections of that DAG for hierarchical visitation; reading order is a further linear projection. Sub-addresses
emerge from the combination of positional and kind information over the spine of the graph, not on the tree-as-ontology.

An envelope instance is a typed DAG whose edge set includes dominance, reading-order constraints, and reference relations; Markdown inline links, footnote lists, and citation pointers are the concrete syntax for those reference edges, so cross-component structure is part of the graph spec—not an afterthought on a tree projection.

MarkPig is a low-overhead Markdown flavor whose parse yields a typed manuscript DAG (spine, streams, ref edges, closed composite subgraphs). Structure and validation live in that latent graph and in MathDig—not in overt container tags—so the same document stays model- and human-readable while supporting figure–caption units, section composites, interleaved prose/math visitors, and dual-sector RAG.

Figure composites are closed subgraphs that nest: sub-figures are the same schema inside a parent body, with captions segmented per closure; visitors recurse on those sub-sub-graphs along the interior spine, demuxing prose/math and raster/MathDig bodies at every depth—without turning the author-facing document into nested HTML containers.

Deterministically parse LaTeX math into substance vs typesetting furniture; use furniture as evidence to build a KaTeX-stable MathDig form; strip furniture; lift document structure (including figures/captions/refs) into the MarkPig DAG so conversion is a surjection onto the envelope—not a lossy text dump and not an HTML-tag expansion.

If removing it can change the mathematical parse (different MathDig tree or different KaTeX-stable atom graph), it is encoded notation.
If removing it only changes spacing, size level, or decoration while the same MathDig tree remains, it is typesetting furniture.

Furniture = pure typesetting (discardable presentation).
Encoded notation = structure that is the math (including superscripts, subscripts, and other script schemata).
The invariant math stream is exactly the encoded-notation projection—lexically KaTeX-stable, structurally `MathDig` or at least an approximation of it—after furniture has been used as evidence and removed.

Across LaTeX standards, glyphs, and author dialects, map every math span into a preferred KaTeX-stable lexicon by expanding macros, resolving glyphs to control sequences, and coalescing aliases under evidence (e.g. operator-spacing → \operatorname / built-ins, upright identifiers → \mathrm), then strip typesetting furniture so the math channel is lexically invariant before MathDig and MarkPig see it.

Math register output: KaTeX-stable lexicon with \mathrm as the upright-name pole.
\operatorname: parse-time evidence for stem + Op-class intent; stripped from output after MathDig is formulated.

Macros are expanded fully into flat, correctly grouped and delimited KaTeX-valid blocks that faithfully express the math; the math register contains only that post-expansion lexicon (e.g. upright names as \mathrm), never source macros or evidence-only forms like \operatorname.
