# Agent Operations & Standards

This document codifies the operational standards for agents working on the `codex-scientiae` corpus. The primary goal of this repository is to build a robust, structurally rigorous knowledge corpus optimized for LLM ingestion. 

When converting, auditing, or repairing academic texts (especially those rich in advanced mathematics), agents must be aware of common extraction failure modes and adopt an adaptive, context-aware approach to structural repair. The correct strategy will always be corpus and document dependent.

## 1. The Math Encoding Standard: `gfm+tex_math_dollars`
LLMs do not read visual pixels or HTML tables; they read text tokens. To preserve the two-dimensional spatial hierarchy of advanced mathematics (like nested integrals, matrices, and piecewise functions), **math must be encoded using raw LaTeX syntax**.

- **Inline Math**: Must be wrapped in single dollars: `$x$`
- **Block Math**: Must be fenced with double dollars: `$$ \int f(x) dx $$`
- **Pure Syntax**: Do NOT use web-renderer specific injection macros (like KaTeX's `\htmlClass` or color stylings). LLMs natively understand pure LaTeX (as trained on ArXiv/Jupyter data) and these pure structures maximize token efficiency.

## 2. Active Inline Math Enrichment
Depending on the source document and ingestion settings, extraction pipelines (e.g., Docling) may occasionally fail to encapsulate inline mathematics. In such failure modes, they might output raw Unicode text for variables instead of correctly delimiting them.

**Agent Responsibility**: When such omissions occur, you must actively enrich and encapsulate the inline math. 
- Look for unformatted raw variables in paragraphs (e.g., $p$, $q$, $\omega$, $\sigma_x$) and wrap them in single `$` delimiters.
- **Use Contextual Targeting**: To prevent false positives (like wrapping the "p" in "page" or standard acronyms), rely on surrounding cue words such as "probability $p$", "parameter $q$", or adjacent mathematical operators (`$p$ <`, `$q$ \ge`).

## 3. Reconstructing Splayed Math Blocks
Advanced math relies on vertical spatial hierarchy. Depending on the complexity of the document layout, OCR pipelines may occasionally panic when confronted with structures like `\begin{cases}` blocks or nested bounds. This can result in the math being flattened into fragmented, left-to-right Unicode text (e.g., isolated `inf`, `sup`, and disconnected piecewise braces ``).

**Agent Responsibility**: If you encounter these "splayed" or shattered math blocks:
- Do not attempt to fix them with lazy regex over raw text.
- Reconstruct the block entirely into a compliant LaTeX environment (e.g., `\begin{cases} ... \end{cases}`) wrapped in `$$`.
- **Use Surrounding Prose**: It is critical to use surrounding expository prose to aid in repair and enrichment. Contextual cues in the text allow you to accurately determine the original structural intent of what is broken.

## 4. Multi-Channel Consensus Repair
Document ingestion is a fundamentally fuzzy problem. Depending on the ingestion strategy, agents may work on a single extraction channel (e.g., purely refining Docling output) or have access to multiple parallel channels (e.g., JSON IR sidecars, Docling-based exports, pure Java extraction). **Do not blindly assume one single workflow applies to all documents.** 

**Common Extraction Quirks & Example Strategies:**
- **Docling Math Strengths vs. Flaws**: Docling is generally strong at extracting LaTeX math, but watch out for known failure modes like duplicating text between math blocks as `\intertext{...}` followed by the plaintext of the exact same prose. If working purely in Docling, focus on cleaning these redundancies and rebuilding broken brackets.
- **Prose Backbone Integration (Example Multi-Channel Workflow)**: When both Java and Docling extracts are available, you might find Docling's extraction of raw expository prose is weaker or more error-prone than the pure Java extraction. In these specific cases, a highly effective workflow is to use the Java text as the core "backbone" of the document, and manually lift/repair Docling's math blocks into that backbone.
- **Glyph Disambiguation**: In multi-channel scenarios, even when Java extraction gets the math wrong (e.g., falling back to raw Unicode glyphs), those glyphs are often incredibly useful for validating against Docling's LaTeX output. You can cross-reference technically incorrect Java glyphs to disambiguate what Docling was attempting to render.
- **Private Use Area (PUA) & Blank Lines**: Often, math extraction will leave blank lines or boxes which are actually PUA characters placed by the typesetter to indicate structural roles (e.g., grouping, delimiter scope). Treat these as semantic hints rather than noise.
- **Standalone Sub/Superscripts**: Extraction often drops limits (`\sum`, `\int`) or exponents onto their own lines (e.g. an isolated `-1` is usually `^{-1}`). Re-integrate them contextually into the preceding block.
- **Ligature and Translation Errors**: Regardless of the pipeline, always be on the lookout for OCR-specific translation errors, such as literal Unicode typographic ligatures being output instead of distinct letters (e.g., the `ffi` ligature replacing `f f i`).

**Agent Responsibility**: Remain adaptive. The examples above are just variations of workflows, not absolute rules. Assess the strengths, weaknesses, and availability of the extraction artifacts for your specific task, and choose the repair strategy that makes the most sense for that exact context.

## 5. Token Economy & Swarm Efficiency
When managing large batches of document repair across swarms of subagents, overhead reduction is critical.
- **Minimalist Agent Configurations**: Do not equip subagents with unnecessary tools (e.g., global file search, artifacts, or broad MCP servers) if they are only assigned a single-page rewrite task. This massively reduces context bloat and eliminates rate limits (429s).
- **Worker Hygiene & Closing Ceremony**: Between large batches, ensure all workers successfully terminate. Perform a "Closing Ceremony" by actively validating output file counts and issuing a `kill_all` command to purge any stalled or orphaned zombie subagents. This maintains a clean workspace.

## 6. Document Repair Checklist

A reusable checklist for OCR‑artifact cleanup and markdown hygiene is provided in [checklist.md](file:///c:/Users/azrie/PDenv/UserGithub/codex-scientiae/checklist.md).
