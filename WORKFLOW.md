# Agent Playbook: Extraction Failure Modes & Repair Workflows

> **Canonical workflow = the membrane.** The *how* of repair is the `codex-membrane` MCP server's
> `restoration_procedure` prompt (`src/PROCEDURE.md`): navigate don't scan, slice don't slurp, edit
> don't regenerate — orchestrator (`get_batch_summary`/`dispatch`) fans pointers to workers, each pulls
> its own `get_slice`, fixes with `propose_edit`, and the loop closes `apply` → `finalize` → `publish`.
> This document is the *what*: the extraction-failure taxonomy and repair judgment a worker applies
> **inside** that loop. It is NOT a license to open whole `.md` files or spin up ad-hoc subagent swarms
> (see §5). For ingested papers (`ingestion/` → `compendia/`, `corpora/`) the membrane is the only lane.

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

### 5. Token Economy & Orchestration (membrane model)
The membrane *is* the token discipline — it is body-blind by construction. Honor it; do not revert to
the legacy "swarm of subagents each rewriting a whole page" model (superseded, and sub-agent dispatch is
governed/restricted — confirm before fanning out).
- **Pointers, never bodies.** The orchestrator plans from `get_batch_summary` / `dispatch` — counts and
  work-unit *pointers*, never content. A worker pulls exactly the one unit it was handed (`get_slice`) and
  holds nothing else. "Give me the file" does not exist; that is what keeps context flat across a batch.
- **Diffs, never regenerations.** Repair with `propose_edit` (a surgical find/replace) — send only the
  change, never reproduce a chunk you were shown. `propose_repair` (whole-chunk) is the rare fallback.
- **Stateless between steps.** Nothing is held between iterations; re-ground from a projection
  (`get_batch_summary`) at any time. There is no "closing ceremony" / `killall` — the membrane leases
  work and `release`s abandoned units; `apply` folds clean proposals and holds the rest.