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