the complete end-to-end walkthrough of the latex-ingest pipeline, detailing every source file, what gets
invoked at each stage, and the architectural rationale behind each step.
──────
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. Entry Point & Staging │
│ src/codex-membrane/mcp-server.ps1 ──► src/latex-ingest/latex-ingest.ps1 │
│ - Resolves source directory $SourceDir (e.g. ingestion/_inbox/{slug}/)                │
    │  - Localizes intermediate build state to $SourceDir/.runs/{stamp}/tex/ via runs.ps1   │
    └───────────────────────────────────────────┬────────────────────────────────────────────┘
                                                │
                                                ▼
    ┌────────────────────────────────────────────────────────────────────────────────────────┐
    │                        2. Source Extraction & Store Loading                            │
    │  - Get-LatexSource: unpacks .tar.gz tarball into .runs/{stamp}/tex/                   │
    │  - Expand-LatexIncludes: flattens \input{...} / \include{...} into memory              │
    │  - latex-math-store.ps1: loads stores (aliases.json, unicode-glyphs.json, etc.)        │
    └───────────────────────────────────────────┬────────────────────────────────────────────┘
                                                │
                                                ▼
    ┌────────────────────────────────────────────────────────────────────────────────────────┐
    │                        3. Mask Algebra & Comment Stripping                             │
    │  src/latex-ingest/latex.ps1 & src/shared/masks.ps1                                     │
    │  - Get-VerbatimCodeMask: protects verbatim / lstlisting code blocks                    │
    │  - Get-TexCommentMask: identifies % comments outside verbatim code                     │
    │  - Remove-TexComments: strips comments in reverse offset order (no swallowed prose)    │
    └───────────────────────────────────────────┬────────────────────────────────────────────┘
                                                │
                                                ▼
    ┌────────────────────────────────────────────────────────────────────────────────────────┐
    │                       4. Macro Expansion & Diagram Transpilation                       │
    │  - Get-LatexMacros: parses \newcommand, \let, \DeclareMathOperator                     │
    │  - Expand-LatexMacros: expands math macros in Get-TexExpandableMask (RegexOptions::None) │
    │  - Convert-XyDiagramSpan & Convert-TikzcdDiagram: transpiles 1D/2D diagrams to KaTeX   │
    │  - Extract-LatexDiagrams: stashes non-encodable TikZ to DiagramStore                   │
    │  - Copy-LatexFigures: copies raster figures to paper directory                         │
    └───────────────────────────────────────────┬────────────────────────────────────────────┘
                                                │
                                                ▼
    ┌────────────────────────────────────────────────────────────────────────────────────────┐
    │                       5. Prose Formatting & Math Register                              │
    │  - ConvertFrom-Latex: reflows hard-wraps, converts theorem envs, unwraps \ensuremath   │
    │  - src/math-register/math-register.ps1: enforces target invariants ($...$, $$...$$) │
│ (jurisdiction.json, operators.json, surjections.json, hygiene.json, lexicon.json) │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
│
▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 6. In-Doc TOC & Tree Sidecar Generation │
│ src/toc-engine/toc-engine.ps1 │
│ - New-DeliverableTreeModel: computes SMP surrogate-safe byte spans [byte_start, end) │
│ - Set-MdContentsBlock: renders in-doc ## Contents block with static schema legend │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
│
▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 7. Deliverable Bundling & Verification │
│ src/md-postprocess/md-bundle.ps1 │
│ - Copy-MdDeliverable: assembles self-contained bundle $markdown_dir/{slug}/ │
│ ├── {slug}.md (manuscript) │
│ ├── {slug}-tree.md (single-doc TOC sidecar via Export-MdTreeSidecar) │
│ ├── {slug}.toc.jsonl (machine TOC sidecar) │
│ └── images/ (raster figures) │
│ - Post-copy verification: checks for broken links and defect sentinels (0xFFFD, @@..@@) │
└────────────────────────────────────────────────────────────────────────────────────────┘
──────

### Step-by-Step Stage Breakdown

#### Stage 1: Orchestration & Staging

• Files Called:
• mcp-server.ps1 (via latex_convert MCP tool) or CLI invocation.
• latex-ingest.ps1 (Invoke-LatexIngest).
• runs.ps1 (Resolve-PaperDir, New-RunDir).
• What Happens & Why: 1. Resolve-PaperDir locates the source directory $SourceDir (defaulting to ingestion/\_inbox/{slug}/ or a custom
path). 2. New-RunDir creates a localized, runstamped directory $SourceDir/.runs/{stamp}/tex/. All intermediate build
state (extracted tarballs, TeX logs) is kept inside .runs/, ensuring the source directory stays clean.

#### Stage 2: Extraction & Ingestion Store Loading

• Files Called:
• latex-ingest.ps1 (Get-LatexSource, Expand-LatexIncludes).
• latex-math-store.ps1.
• What Happens & Why: 1. Get-LatexSource extracts the raw .tar.gz LaTeX archive into $SourceDir/.runs/{stamp}/tex/. 2. Expand-LatexIncludes recursively resolves \input{...} and \include{...} commands, combining multi-file TeX
manuscripts into a single, unified in-memory TeX string. 3. latex-math-store.ps1 loads source operational stores from stores:
• aliases.json: Operational TeX command alias surjections.
• unicode-glyphs.json: Unicode codepoint to TeX command mappings.
• furniture.json: TeX layout/font stripping patterns.
• evidence.json: TeX evidence markers (\operatorname, \parbox).

#### Stage 3: Mask Algebra & TeX Comment Stripping

• Files Called:
• latex.ps1 (Get-VerbatimCodeMask, Get-TexCommentMask, Get-TexExpandableMask).
• masks.ps1.
• What Happens & Why: 1. Get-VerbatimCodeMask identifies code environments (verbatim, lstlisting, minted, \verb|...|). 2. Get-TexCommentMask creates a mask of all % comments outside verbatim code. 3. Remove-TexComments strips comments span-by-span in reverse offset order, ensuring commented % lines are
removed cleanly without splitting paragraphs or swallowing prose.

#### Stage 4: Macro Expansion, Diagram Transpilation & Figures

• Files Called:
• latex-ingest.ps1 (Get-LatexMacros, Expand-LatexMacros, Convert-XyDiagramSpan, Convert-TikzcdDiagram, Extract-
LatexDiagrams, Copy-LatexFigures).
• What Happens & Why: 1. Get-LatexMacros parses \newcommand, \let, \DeclareMathOperator, \DeclarePairedDelimiter into an ordinal case-
sensitive $macros dictionary.
      2. Expand-LatexMacros evaluates against Get-TexExpandableMask with explicit RegexOptions::None case sensitivity.
      This allows TeX math macros (\Vect, \eps) to expand inside $…$ and $$…$$ while leaving verbatim code blocks
untouched and avoiding case collisions (\Vect vs \vect). 3. Convert-XyDiagramSpan & Convert-TikzcdDiagram transpile 1D/2D commutative diagrams (\xymatrix,
\begin{tikzcd}) into native KaTeX (\xmapsto, \begin{array}). 4. Extract-LatexDiagrams stashes complex non-encodable TikZ diagrams into DiagramStore with unique diagram
markers. 5. Copy-LatexFigures extracts raster images (.png, .jpg, .svg) from the tarball into the paper directory and
rewrites relative image links.

#### Stage 5: Prose Formatting & Math Register Processing

• Files Called:
• latex-ingest.ps1 (ConvertFrom-Latex).
• math-register.ps1.
• What Happens & Why: 1. ConvertFrom-Latex reflows TeX hard-wraps into continuous flowing paragraphs (STANDARDS §4), resolves text-
mode accents (M\'{e}moli → Mémoli), unwraps \ensuremath wrappers, and converts theorem environments
(\newtheorem) to numbered blockquotes with resolved \ref{...} labels. 2. math-register.ps1 processes inline (...) and block (

    ...

) math spans through the target math register stores (stores):

- jurisdiction.json: Prose protection (\text{...}).
- operators.json: Operator lowerings (\operatorname → \mathrm).
- surjections.json: Normative 1-to-1 command surjections (backslash ge → backslash geq).
- hygiene.json: Target presentation furniture stripping (textcolor, vspace).
- lexicon.json: Canonical symbol dictionary (α → backslash alpha).

#### Stage 6: Table of Contents & Section Indexing

• Files Called:
• toc-engine.ps1 (New-DeliverableTreeModel, Set-MdContentsBlock).
• in-doc-contents.template.md.
• What Happens & Why: 1. New-DeliverableTreeModel scans H2+ headings outside code fences, excluding self-referential ## Contents
headings, and computes SMP surrogate-pair safe closed byte spans [byte_start, byte_end), byte_width, and
char_count. 2. Set-MdContentsBlock renders and inserts/refreshes the in-doc ## Contents section inside the manuscript,
formatted with the static schema legend row:
`section row metadata: section_link | level | byte_start | byte_end | byte_width (B) | char_count (chars)`

#### Stage 7: Deliverable Bundling & Verification

• Files Called:
• md-bundle.ps1 (Copy-MdDeliverable).
• toc-engine.ps1 (Export-MdTreeSidecar).
• What Happens & Why: 1. Copy-MdDeliverable constructs the self-contained deliverable bundle directory at $markdown_dir/{slug}/:
• {slug}.md: The main Markdown manuscript.
• {slug}-tree.md: The single-document Tree TOC sidecar manifest rendered via Export-MdTreeSidecar using
src/toc-engine/templates/single-doc-tree.template.md.
• {slug}.toc.jsonl: Machine-readable byte-spanned TOC sidecar.
• images/: Subdirectory containing all copied raster figure assets. 2. Copy-MdDeliverable performs destination audit verification: checks that all relative image links resolve and
counts defect sentinels (0xFFFD destroyed codepoints, @@LMATH0@@ leaked protection markers). Returns a
structured audit result object.
