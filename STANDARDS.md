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
