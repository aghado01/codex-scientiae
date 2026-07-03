# Codex Scientiae: Structural & Formatting Standards

This document defines the strict output formatting requirements for the codex-scientiae corpus. LLMs do not read visual pixels or HTML layouts; they read text tokens. All document structures must be optimized for semantic clarity and token efficiency.

### 1. The Math Encoding Standard

Use standard dollar-sign LaTeX delimiters, which render correctly in VS Code, Typora, Obsidian, GitHub, and are understood natively by LLMs trained on ArXiv/Jupyter data.

- **Inline Math**: Must be wrapped in `$...$` (e.g., `$x$`, `$J_{ij}$`).
- **Block Math**: Must be fenced with `$$` on their own lines.
- **Pure Syntax Only**: Do NOT use web-renderer specific injection macros like KaTeX's `\color`, custom spacing tweaks (`\vspace`), or layout stylings. LLMs natively understand pure LaTeX; these pure structures maximize token efficiency.

### 2. Equation Numbering

Pipeline extraction often detaches equation numbers, outputting `(1)` on a separate line as plain text.

- **Requirement**: Incorporate these directly into the reconstructed block using `\tag{1}` rather than leaving them floating.
- **Example**:
  ```latex
  $$
  H(S) = \sum_{i,j} J_{ij}\bigl(1 - \delta_{s_i,s_j}\bigr) \tag{1}
  $$
  ```

### 3. Data Table Formatting

When structural tabular data is encountered, do not leave it as raw text or HTML.

- **Markdown Tables**: Convert tables into standard Markdown format using pipe `|` delimiters.
- **Math in Tables**: Ensure any mathematical expressions, variables, or Greek letters within table cells are correctly encapsulated with inline `$...$` delimiters.

### 4. Prose and Spacing Hygiene

- **Remove Hard Wraps**: Actively remove excessive hard line breaks (`\n`) within paragraphs. OCR often injects hard wraps at the end of every visual line, which severs semantic token sequences for LLMs.
- **Paragraphs**: Separate distinct paragraphs with a single blank line (`\n\n`).
- **Mathematical Continuity**: Never allow a line break to split a single mathematical formula or inline equation.

### 5. Sections Header Convention

This should be enforced after OCR and prose repair because some OCR/Docling processing mistakes will insert spurious header sections

- **Top-level H1 `#` is reserved for document's title** or a textbook's chapter name, etc, at the very top
- **H2 `##` for every major section in the document** - E.g. `##` for Introduction/Abstract/Results/Conclusions/References/etc in papers and for chapter top-level in text books
- **H3 `###` for every minor- or sub-section above** - E.g. `###` for Subsections of the above `##` sections , which reflects nesting relationships and flow of the document accurately
- **H4 `####` for any nested sections contained by minor/sub sections above**

### 6. CONTENTS sections

After repairing and standardizing markdown header sections for a document, add a `## Contents` section immediately below the title/authors block (H2, consistent with §5 — H1 is reserved for the document title only). The section lists every major and minor heading as a hierarchical anchor-link list, with the References entry pointing to the sidecar file.

### 7. Daemon/Library Stream Discipline (src/)

Daemon/library code in `src/` targets streams explicitly at the .NET level (`[Console]::Error` for logs, the owned stdout writer for protocol frames pinned to UTF-8); no `Write-Host`/`Write-Output`/`Out-*` for diagnostics; tool results are return values, never host writes.

### 8. Published Compendium Layout (the `publish` contract)

When a finalized deliverable is promoted into a `compendia/{topic}/` collection (by the membrane's `publish` tool, never by hand), the on-disk layout is fixed:

- **Body**: `compendia/{topic}/{slug}.md` — H1 title, the `## Contents` block (§6), then sections.
- **References sidecar**: `compendia/{topic}/references/{slug}.md`, linked from the Contents block.
- **Figures (nested)**: `compendia/{topic}/images/{slug}/imageFileN.png`. In-doc image links use the `images/{slug}/…` path. (Older papers using the flat `{slug}/…` form are legacy outliers being migrated.)
- **Index**: `compendia/{topic}/_CONTENTS.md` carries one `## [title]({slug}.md)` block per paper, with the Contents entries re-anchored to `{slug}.md#…`. Ordering is **human thematic curation** — `publish` upserts a paper's block in place (or appends a new one for repositioning) and never re-sorts.

All file I/O is UTF-8 without BOM (§ stream discipline), so SMP math, accents, and ligatures round-trip.

### 9. Ingestion Lane Output Naming (inbox slug root)

While a paper is staged under `ingestion/_inbox/{slug}/`, each converter lane writes its finalized markdown to the slug root, tagged by lane so the lanes sit side-by-side for cross-examination:

- **Docling** (the base drop, beside the JSON IR): bare `{slug}.md` — the opendataloader default, *not* suffixed.
- **LaTeX** (`latex-ingest.ps1` / `latex_convert`): `{slug}-latex.md`.
- **Membrane** (`finalize`): the authoritative copy stays in the run dir (`.runs/{stamp}/{slug}.md`); a convenience mirror is copied up to `{slug}-membrane.md`.

Promotion (§8) is the only step that writes a bare `{slug}.md`, and it does so at the *destination* (`compendia/{topic}/`). It shares the basename with the inbox docling drop but never the location — the two are not to be conflated.
