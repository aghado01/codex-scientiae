# Agent Playbook: Extraction Failure Modes & Repair Workflows

Document ingestion is a fundamentally fuzzy problem. When converting, auditing, or repairing academic texts via pipelines like Docling, agents must be aware of common extraction failure modes and adopt an adaptive, context-aware approach to structural repair.

### 1. Active Inline Math Enrichment
Extraction pipelines occasionally fail to encapsulate inline mathematics, outputting raw Unicode text for variables instead of correctly delimiting them.
- **Agent Responsibility**: Actively enrich and encapsulate the inline math. Look for unformatted raw variables in paragraphs (e.g., p, q, x) and wrap them.
- **Use Contextual Targeting**: To prevent false positives (like wrapping the "p" in the word "page"), rely on surrounding cue words such as "probability \(p\)", "parameter \(q\)", or adjacent mathematical operators.

### 2. Reconstructing Splayed Math Blocks
Advanced math relies on vertical spatial hierarchy. OCR pipelines may panic when confronted with structures like `cases` blocks or nested bounds, resulting in the math being flattened into fragmented, left-to-right Unicode text (e.g., isolated inf, sup, and disconnected piecewise braces).
- **No Lazy Regex**: If you encounter shattered math blocks, do not attempt to fix them with lazy regex over raw text. 
- **Holistic Reconstruction**: Reconstruct the block entirely into a compliant LaTeX environment (e.g., `\begin{cases} ... \end{cases}`).
- **Contextual Deduction**: Use surrounding expository prose to deduce the original structural intent of what is broken.

### 3. Multi-Channel Consensus Repair
Agents may have access to parallel channels (JSON IR sidecars, Docling-based exports, pure Java extraction). Do not assume one single workflow applies to all documents.
- **Prose Backbone Integration**: If Docling's extraction of raw expository prose is error-prone but its math is strong, use the Java extraction text as the core backbone of the document and manually lift/repair Docling's LaTeX blocks into it.
- **Glyph Disambiguation**: Cross-reference technically incorrect Java glyphs (raw Unicode) to disambiguate what Docling was attempting to render in complex math blocks.

### 4. Resolving Common OCR Quirks
- **Standalone Sub/Superscripts**: Re-integrate isolated limits or exponents (e.g., an isolated `-1` line) contextually into the preceding math block.
- **Private Use Area (PUA) Elements**: Treat PUA blank lines or boxes placed by the typesetter as semantic hints for structural roles (e.g., grouping, delimiter scope) rather than noise.
- **Ligature Errors**: Be on the lookout for OCR translation errors, such as literal Unicode typographic ligatures being output instead of distinct letters (e.g., the `ffi` ligature replacing `f f i`).

### 5. Token Economy & Swarm Efficiency
When managing large batches of document repair across swarms of subagents, overhead reduction is critical.
- **Minimalist Agent Configurations**: Do not equip subagents with unnecessary tools (e.g., global file search or broad MCP servers) if they are only assigned a single-page rewrite task. This massively reduces context bloat and prevents 429 rate limits.
- **Worker Hygiene (Closing Ceremony)**: Between large batches, ensure all workers successfully terminate. Perform a "Closing Ceremony" by actively validating output file counts and issuing a `killall` command to purge any stalled or orphaned zombie subagents.