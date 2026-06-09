# Agent Operations Hub: codex-scientiae

Welcome to the agent operations hub for the `codex-scientiae` corpus. The primary goal of this repository is to build a robust, structurally rigorous knowledge corpus optimized for LLM ingestion. 

When converting, auditing, or repairing academic texts—especially those rich in advanced mathematics—document ingestion is a fundamentally fuzzy problem. Agents must be aware of common extraction failure modes and adopt an adaptive, context-aware approach to structural repair. 

To achieve this, agent workflows are governed by three core documents. You must adhere to the standards and workflows defined in these linked files.

---

## 1. Structural Requirements
**Reference Document:** `STANDARDS.md`

LLMs do not read visual pixels or HTML layouts; they read text tokens. All document structures must be optimized for semantic clarity and token efficiency. You must strictly adhere to the formatting rules defined in `STANDARDS.md` [file:5].

**Key directives include:**
- **Strict LaTeX Encapsulation:** Using `\( ... \)` for inline math and `\[ ... \]` for block math to prevent parsing collisions [file:5]. 
- **Pure Syntax:** Avoiding web-renderer specific macros (e.g., `\color`, `\vspace`) in favor of pure semantic LaTeX [file:5].
- **Integration:** Incorporating floating equation numbers directly into math blocks using `\tag{}` [file:5].
- **Data Structuring:** Converting raw tabular data into standard Markdown pipe `|` tables with correctly encapsulated math [file:5].
- **Hygiene:** Removing arbitrary OCR hard wraps to maintain the semantic flow of prose [file:5].

## 2. Adaptive Repair Strategies
**Reference Document:** `WORKFLOW.md`

Extraction pipelines (like Docling) frequently fail on complex layouts. Agents must not rely on brute-force regex but rather semantic reconstruction. Detailed strategies for handling these failures are outlined in `WORKFLOW.md` [file:6].

**Key directives include:**
- **Active Enrichment:** Using contextual cue words to identify and wrap raw Unicode variables that OCR failed to encapsulate [file:6].
- **Holistic Reconstruction:** Rebuilding shattered math blocks (like piecewise functions) entirely from scratch using surrounding prose as a guide [file:6].
- **Multi-Channel Consensus:** Cross-referencing different extraction pipelines (e.g., using pure Java extraction for prose and Docling for math) to build the most accurate final document [file:6].
- **Swarm Efficiency:** Ensuring lightweight agent configurations and executing "Closing Ceremonies" to prevent 429 rate limits and zombie subagents [file:6].

## 3. The Execution Protocol
**Reference Document:** `CHECKLIST.md`

Before finalizing any document repair, subagents must systematically audit their output against the `CHECKLIST.md` protocol [file:4].

**Key validation steps include:**
- Confirming heading hierarchy and spacing [file:4].
- Validating the encapsulation of all inline and block math [file:4].
- Removing duplicated prose common in OCR extraction [file:4].
- Cleaning up typographic ligatures and reattaching orphaned sub/superscripts [file:4].
- Executing a final linter pass to catch structural anomalies [file:4].

---
*Note: The correct strategy will always be corpus and document-dependent. Remain adaptive, prioritize semantic accuracy over visual formatting, and strictly follow the formatting rules outlined in the linked standards.*