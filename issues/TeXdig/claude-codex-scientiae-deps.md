

# i dont trust this test example, its sythetically creating one example based on some superficial read of probably one article. this isn't useful because no single paper is going to reveal the general mechanisms for processing documents. this is the point of the gauntlet. why dont' we walk through the node tools available that are pinned including all latex-related ones and map out what they do

Good — grounding the regroup in the instruments themselves rather than any one specimen. Let me inventory what's actually pinned first: the manifest, the lock, and what `src/TeXdig` currently imports.
Here's the map, drawn from the pins themselves — [brewery/node/package.json](brewery/node/package.json) is the recipe (14 direct pins, all at exact versions), `restore-node.ps1` materializes them into `packages/node/node_modules`, and [core/loader.ts](src/TeXdig/core/loader.ts) is the single gate through which TeXdig reaches any of it via `createRequire`. Everything below is read off the packages' actual export surfaces, not their README marketing.

## The two parsers — different philosophies, deliberately both pinned

**`@unified-latex/*` 1.8.4** (24 members installed) — a *semantic* LaTeX toolchain: parse to a mutable AST, then progressively enrich it by attaching meaning (arguments, environments, expansions) as knowledge arrives. Positions are best-effort and degrade under reparse — the corpus-confirmed local-frame trap (alignment environments nested in math get re-parsed in local coordinates) lives here.

**`latex-utensils` 7.0.0** — a *positional* single-pass PEG parser: no macro semantics at all, but globally faithful offsets on every node, and a rich typed vocabulary the other parser lacks. Its predicate list is worth reading as a capability inventory: `isVerb`, `isVerbatim`, `isMinted`, `isLstlisting`, `isInlineMath`, `isDisplayMath`, `isMathEnv`, `isMathEnvAligned`, `isDefCommand`, `isLabelCommand`, `isUrlCommand`, `isHrefCommand`, `isSuperscript`, `isSubscript`, `isActiveCharacter`, `isCommandParameter` — plus query tools (`findNodeAt`, `findAllSequences`, `pattern`) and `parsePreamble`. It also ships two siblings: **`bibtexParser`** (.bib AST — entries, `@string`, preamble, value kinds including concat; parses but does not resolve `@string`/`#`/crossref) and **`latexLogParser`** (TeX compile logs — file stack, errors, *page numbers*), the latter completely dormant.

## unified-latex, member by member, by function

**Parsing entries** (`util-parse`) — not one parser but a family: `parseMinimal` (raw tape, no macro knowledge — the census's first pass), `parse`/`getParser(options)` (full parse; options inject macro/environment *signatures*, which is how the configured channel feeds document-summoned packages in), `parseMath`/`parseMathMinimal` (math-mode entry), and unified plugins for staged enrichment (`unifiedLatexProcessAtLetterAndExplMacros`, `…MacrosAndEnvironmentsWithMathReparse`, `…ReparseMath`).

**Meaning tier** — the part that decides what a name is:

| member | what it actually does |
|---|---|
| `util-macros` | `listNewcommands` (name + xparse signature + body from `\newcommand`/xparse forms), `createMacroExpander`, `expandMacros`, `expandMacrosExcludingDefinitions`, `parseMacroSubstitutions` — the expansion toolkit, already probe-verified corpus-wide (converges, defaults applied) |
| `util-arguments` | `attachMacroArgs`, `gobbleArguments`, `gobbleSingleArgument`, `getArgsContent` — given a **signature**, consume following tokens as that macro's arguments. This is the hull machine |
| `util-argspec` | parses xparse signature strings (`O{default} m s`) into a typed `ArgSpecAst` |
| `util-environments` | `processEnvironment(s)` — turns matched `\begin`/`\end` plus a signature into an environment *object* with attached args and body |
| `util-catcode` | `findExpl3AndAtLetterRegionsInArray`, `reparseMacroNames` — detect `\makeatletter`/expl3 regions and re-lex `@`-names correctly (the corpus catcode-arbitration class has a dedicated instrument) |
| `unified-latex-ctan` | the dialect records: `macroInfo` + `environmentInfo` for exactly **17 packages** — amsart, beamer, cleveref, exam, geometry, hyperref, latex2e, listings, makeidx, mathtools, minted, multicol, nicematrix, systeme, tikz, xcolor, xparse. **Absent: amsmath, amsthm, graphicx, natbib, url, xy, algorithm-family** — precisely the gauntlet gap-queue frequency leaders. The configured-gap curation queue exists because these records don't |

**Structure/query tier**: `util-visit` (traversal with CONTINUE/SKIP/EXIT), `util-match` (node predicates: `macro`, `environment`, `math`, `parbreak`, `group`, `whitespace`…), `util-scan` (Trie/`prefixMatch`/`scan` over token streams), `util-split` (`splitOnMacro`/`splitOnCondition` — rows on `\\`, cells on `&`), `util-align` (`parseAlignEnvironment` — alignment-environment interiors into structured rows/cells: the instrument aimed at the local-frame class), `util-replace` (including `replaceStreamingCommand` — converts streaming commands like `\bfseries` into scoped wrappers), `util-trim`, `util-comments`, `util-pgfkeys` (key=value argument language).

**Grammar layer** (`util-pegjs`) — the PEG grammars themselves, individually exposed: `LatexPegParser`, `AlignEnvironmentPegParser`, `ArgSpecPegParser`, `TabularPegParser`, `TikzPegParser`, `XColorPegParser`, `PgfkeysPegParser`, `SystemePegParser`, `MacroSubstitutionPegParser`, `GluePegParser`, and — notable — a **`LigaturesPegParser`**: a grammar for TeX's typographic ligatures (` `` `, `''`, `--`, `---`…), i.e. the typographic-surjection layer exists as a pinned instrument.

**Serialization tier**: `util-print-raw` (AST → raw LaTeX, no formatting — the loader's comment already scopes it to derived content only), `util-to-string` (pretty compiler), `builder` (AST constructors `m`, `env`, `arg`…), `prettier` plugin, `util-render-info` (attach/strip render hints), and the `unified-latex` umbrella (`processLatexToAstViaUnified`).

## The validation/render instruments

| pin | what it is |
|---|---|
| `katex` 0.18.1 | math parse/render with `throwOnError` and a controlled `macros` dictionary — the render_check floor for the math register |
| `node-tikzjax` 1.0.5 | a real small TeX engine compiled to WASM with TikZ/pgf preloaded, emitting SVG — the one place *execution* exists in the stack, quarantined to zone validation |
| `markdownlint` 0.41.1 | CommonMark linter — the markdown-envelope gate |
| `mupdf` 1.28.0 | MuPDF.js, a full WASM PDF engine: structured text with per-glyph geometry, outlines, page rendering. Pinned, fully dormant in TeXdig |
| `typescript` 7.0.2 + `@types/node` | pinned as the dev-time checker — currently unwired (no tsconfig anywhere; Node 26 strips annotations without checking them) |

## What's actually reached today vs. dormant

`loader.ts` loads exactly seven surfaces: **parse, visit, match, macros, ctan, print-raw, latex-utensils** (its `latexParser` as the census backfill instrument, `bibtexParser` for .bib). Everything else — `util-arguments`, `util-argspec`, `util-environments`, `util-catcode`, `util-align`, `util-replace`/`scan`/`split`/`trim`/`comments`, `util-pgfkeys`, every individual PEG grammar including Ligatures, `builder`, `to-string`, katex, tikzjax, mupdf, markdownlint, typescript — is pinned and dormant.

Held against the wrongness we just looked at, the map says something on its own: environments-as-objects, signature-driven argument hulls, streaming-command scoping, alignment-interior structure, and the ligature surjection all have dedicated, already-pinned instruments that nothing loads. Say which rows you want to walk through in depth — I can open any of these up export-by-export, with its actual behavior on real input rather than its description.
