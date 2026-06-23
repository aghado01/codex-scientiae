# Document Repair Checklist

> **This is a quality rubric, not an editing procedure.** It defines the bar a finished deliverable must
> meet. The *how* is the membrane (`restoration_procedure` / `src/PROCEDURE.md`): you do NOT open the
> `.md` and edit it directly — you work the chunk stream (`get_slice` → `propose_edit` → `apply`), then
> `finalize`/`publish`. Heading hygiene and the in-doc `## Contents` (§1) are landed post-promotion with
> the `repair_headings` / `update_doc_contents` tools, not by hand. Read each item below as "what the
> repaired chunk / promoted document must satisfy," and reach it through the tools.

The items below are the per-deliverable audit. Each maps to a membrane signature or recipe.

### 1. Heading Hygiene
- [ ] Keep a single `H1` (`#`) title at the very top of the file.
- [ ] Ensure all major sections use `H2` (`##`).
- [ ] Ensure subsections follow a logical hierarchy (`###`, `####`).
- [ ] Verify there are no skipped heading levels (e.g., jumping from `##` directly to `####`).

### 2. Line-Break & Spacing Cleanup
- [ ] Remove arbitrary hard line breaks (`\n`) injected by OCR within paragraphs.
- [ ] Ensure distinct paragraphs are separated by exactly one blank line (`\n\n`).
- [ ] Verify that no line breaks interrupt a single mathematical formula or inline equation.

### 3. Math Encapsulation & Cleanup
- [ ] Scan for raw, unformatted mathematical variables in prose (e.g., p, q, x) and wrap them in standard inline delimiters: `\( ... \)`.
- [ ] Ensure all standalone math blocks are fenced with standard block delimiters on their own lines: `\[ ... \]`.
- [ ] Reconstruct shattered or splayed math (like piecewise functions) entirely into proper LaTeX environments (e.g., `\begin{cases} ... \end{cases}`).
- [ ] Map isolated or raw OCR math text (e.g., "inf", "sup", "lim") back to proper LaTeX commands.

### 4. Equation Numbering Integration
- [ ] Check for floating equation numbers (e.g., an isolated `(1)` or `(2)`).
- [ ] Move these isolated numbers into the corresponding LaTeX math block using `\tag{X}`.

### 5. Duplicate Text Removal
- [ ] Detect and delete duplicated prose (often caused by an extraction pipeline outputting an image/math block followed by a plain text duplicate).
- [ ] Ensure only one definitive copy of each sentence or equation remains.

### 6. OCR Glyph & Ligature Cleanup
- [ ] Replace OCR-generated typographic ligatures (e.g., `ﬁ`, `ﬂ`, `ﬃ`) with their distinct ASCII letter equivalents (e.g., `fi`, `fl`, `ffi`).
- [ ] Cross-reference standalone superscripts/subscripts (e.g., an isolated `-1`) and reattach them contextually to their correct base expression.

### 7. Tables & Figures
- [ ] Convert any raw text or HTML tabular data into standard Markdown pipe `|` tables.
- [ ] Verify that math inside table cells is correctly wrapped in `\( ... \)`.
- [ ] Ensure every retained image reference has an associated, concise caption starting with "Figure X:".

### 8. Final Lint Pass
- [ ] Run a Markdown linter or validation script to catch broken internal links, structural anomalies, and unclosed `\(` or `\[` math brackets.

---
*Generated for the codex-scientiae corpus. Ensures structural rigor for LLM ingestion.*