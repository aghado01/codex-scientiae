# well now we should review our audits of latex-utensils and unified-latex to identify all of the categories of stored domain knowledge that they have accumulated and implement. I want to know the taxonomy and ontology of what those projects capture so that we aren't wasting their accumulated knolwedge about handling the diversity of latex source out there, analyze the underlying strategies, as well as account for how these things will be represented in TeXdig, beit direct port or mechanical transfer into native TeXdig conventions. what would be the plan for that?

This is the right third lens on the parents. The first audit read them for *defects* (F1–F23), the second for *architecture* (the reconciliation map) — but nobody has yet inventoried them as what they also are: **a decade of accumulated domain knowledge about real-world LaTeX diversity**, much of it earned one bug report at a time. That asset inventory is exactly what shouldn't be lost in the rewrite. Here's the plan, with the seed taxonomy it starts from.

Plan recorded (C-014/N030) and registered as the next active workstream. Here it is in full.

## The study, framed

**Unit of analysis: the knowledge asset** — a named body of domain knowledge, wherever and however encoded. Each gets one row in a disposition matrix: *content · encoding form · authority source · extensibility · consumers · known defects (linked to F-findings) · TeXdig disposition (target home + transfer mode + phase) · census cross-link*. The output is `planning/knowledge-inventory.md`: the taxonomy, a strategy-synthesis chapter, and the full matrix — with register entries minted per disposition so every asset lands in a phase rather than a vibe.

## The seed ontology — two axes

**WHAT (ten knowledge domains)**, seeded from everything the three prior audits already surfaced, to be verified and extended against the snapshot:

| Domain | What the parents actually accumulated (examples already sighted) |
|---|---|
| **K1 · Lexical/catcode** | `@`-letter and expl3 region semantics; active `~`; `\verb` arbitrary-delimiter trick; ligature trigger sequences |
| **K2 · Core grammar** | parbreak/paragraph model; the two comment models (unified's ownline/sameline is the rich one); argument adjacency; `\[`/`$$` display productions; env begin/end matching strictness; utensils' Preamble/`rest` boundary |
| **K3 · Node-type vocabulary** | utensils' 31-kind taxonomy — verbatim family, math micro-structure (`MatchingDelimiters`, sub/superscript-with-argument), lexical distinctions (`Softbreak`/`Linebreak`, `CommandParameter`); the semantic subtypes (frozen — to declassify) |
| **K4 · Macro semantics** | the xparse argspec language itself; TeX-correct gobbling (single-token mandatory, right-to-left attachment); expansion/substitution semantics (`##` de-doubling, omitted-optional defaults, bounded fixed point); the definition-form vocabulary |
| **K5 · Package dialects** | the 17 ctan records; the `argumentParser` hooks (verbatim-catcode args for listings/minted); **six sub-language grammars** — tikz paths, pgfkeys, xcolor *expressions* plus 22KB of predefined colors, systeme, tabular column-spec, TeX glue; beamer overlay handling |
| **K6 · Math-mode knowledge** | carrier/interior env lists (both, disagreeing — F8); `inMathMode` reparse triggers; the katex-support capability table; the plaintext-operator name lists hiding in lint |
| **K7 · Typography/encoding** | the ligature/Unicode tables (dashes, quotes, guillemets, accent macros via the inputenx harvest); spacing semantics (`\,`→U+2009, `~`→NBSP); the escape family |
| **K8 · Bibliography + side artifacts** | the `.bib` grammar (entry model, `@string`, `#`-concat, crossref-deferred); **biblio-csl's abduction heuristics** — typographic-position→field, the particle/suffix lists, `\bysame` — anglophone bibliographic convention as code; the TeX **log grammar** (error shapes, file-stack, page tracking — hard-won and completely dormant) |
| **K9 · Projection mappings** | to-hast/to-pretext substitution tables (env→HTML, macro→HTML); the streaming-command *lists* (which commands scope); wrap-pars paragraph inference; **dropped-subs** (the deliberate-drop lists — negative knowledge!); break-on-boundaries' sectioning model; vertical-space semantics; author-info frontmatter gathering |
| **K10 · Community norms + meta** | the lint rules as data (obsolete-packages *with replacements*, font-shaping modernization maps); prettier's per-construct conventions; the **harvest machinery as meta-knowledge** (where authority lives: the KaTeX docs table, CTAN `.dtx` files); and both test suites as a curated edge-case corpus |

**HOW (encoding forms)**: grammar production · record literal · generated table · heuristic code · hook (`argumentParser`/`processContent`) · test fixture · harvester script. Assets sit at intersections, and the intersection is diagnostic — the same fact encoded as a grammar union (utensils' `LabelCommand`) versus a record (unified's classification) is the difference between frozen and extensible.

## Strategy analysis

For each domain, the synthesis chapter answers five questions: where is it encoded, **what authority sources it** (TeX-the-program semantics vs kernel convention vs package docs vs empirical typography vs target-capability inventory vs community norm — this axis matters because Law 6's provenance requirement treats them differently), how extensible is the encoding (closed union / open record / pluggable hook), what context gates it (math/text mode, catcode regions), and who consumes it (parse-driving vs transform vs render-hint vs validation — the R19 role split, applied as an analytical lens).

## Disposition vocabulary (each row passes the axis test)

- **Harvest → registry** — mechanical, provenance-stamped TS emission (ctan records, predefined colors, support tables, obsolete-package maps).
- **Grammar port** — `.peggy` sources travel, with frozen semantic unions declassified into records per R6.
- **Re-host** — algorithms re-landed as non-mutating overlays, citing their R-ruling (gobbler, expansion, catcode-as-lexer-mode).
- **Data-extraction** — the interesting one: knowledge currently *trapped in code* gets lifted into declarative form — streaming-command lists, env→HTML maps, dropped-subs lists become records, not ported `if`-chains. This is R6 applied beyond the parser.
- **Demote to enrichment** — biblio-csl abduction, per R24-revised.
- **Oracle/testkit** — the test corpora as differential fixtures; to-mdast defaults as comparison oracle.
- **Drop with reason** — each drop cites its wound.

## Method, sequence, effort

Breadth-first sweep of the **superset snapshot** (byte-addressed manifest already in hand) in shard-group order: utensils `src` → the 11 grammars → 17 ctan packages + their libs → the `util-*` algorithm packages → the three projection pipelines → lint/prettier/cli → the live-clone-only artifacts (support-table JSONs, `scripts/`, licenses). Targeted byte-range reads per asset, journal entries per domain as they close, matrix rows accumulated as we go — the same discipline as the doc-dive, pointed at code. Expected yield: **60–80 asset rows**. Effort: a few focused sessions; it can run before or alongside Phase 1 scaffold since it's design-record work, and it *gates* Phases 3–4 (grammar list, registry facets) more than anything earlier. Census cross-links set implementation *order* within each disposition — but coverage stays exhaustive, because completeness is the entire point of the exercise: the inventory is how we guarantee nothing they learned gets re-learned the hard way.

# This is the authoritative snapshot of the superset now, is this what you are referring to? D:\aipithicus\aipithicus-issues\TeXdig\archaelogy-snapshots\unified-latex-utensils\.snapshot\20260831_115026

Yes, exactly that one — the 2026-08-31 11:50:26 re-cut with the flatter four-group layout: `latex-utensils-src` (22 files), `latex-utensils-tests` (5), `unified-latex-packages` (339), `unified-latex-scripts` (7), across 17 shards. I read its tree manifest earlier in the session and have the full byte-offset index in hand — it's the snapshot I verified the C-007 gap closures against (the `table-generation` harvesters are in it; the latex2e `provides.ts` and ctan aggregate extractions came from its shards s006/s009/s016/s017).

Two known holes to keep in view for the inventory, both already registered: the `support-tables/*.ts` rows are 80-byte import stubs — the actual `katex-support.json` and `ligature-macros.json` data must be read from the live clones at `D:\aghado01\packages\node-latex-deps\` — and the snapshot carries no LICENSE/manifest/README files, so the licensing side also reads from the clones. Everything else the inventory needs is in the payload.

# ok i copied that bit from the source D:\aipithicus\aipithicus-issues\TeXdig\archaelogy-snapshots\unified-latex-utensils\table-generation​ with the files that weren't snapshotted. 