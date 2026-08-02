# `tex-export` decision record

**Status:** active

**Established:** 2026-07-24

This record separates accepted decisions from questions that are intentionally still open.
Decisions may be revised when implementation evidence warrants it, but changes should preserve the
reasoning and date.

## Accepted decisions

### D001 — Create a clean module

**Decision:** The implementation lives under `src/tex-export`.

**Rationale:** The current exporter goal should not inherit the oracle, gauntlet, corpus-finalization,
or repair-loop responsibilities accumulated by `latex-ingest`.

**Consequence:** `latex-ingest` is not a runtime dependency. Reuse is selective and explicit.

### D002 — The exporter is the product

**Decision:** Producing useful, complete Markdown manuscripts is the immediate goal and an end in
itself.

**Rationale:** The documents are needed for the repository's original context-engineering mission.
Latent-manuscript and ABI learning occurs incidentally through building and examining the exporter.

**Consequence:** General schema research must not block end-to-end export milestones.

### D003 — Use a compiler architecture

**Decision:** Source interpretation is implemented as lexing, parsing, binding, semantic
compilation, and emission.

**Rationale:** The first implementation's ordered regular-expression transformations were opaque,
order-dependent, difficult to test, and capable of silent content loss.

**Consequence:** New manuscript features require syntax and compiler representations. Regular
expressions cannot own nesting or semantics.

### D004 — PowerShell SDK with a C# compiler core

**Decision:** PowerShell is the public SDK and orchestration layer. A native C# library implements
the compiler core.

**Rationale:** PowerShell provides the desired user experience and environment integration; C#
provides stronger tools for state-machine lexing, typed syntax trees, source spans, visitors,
diagnostics, and performance.

**Consequence:** Module and compiler APIs must have an explicit, stable interop boundary.

### D005 — Implement a bounded native LaTeX parser

**Decision:** The compiler implements its own lossless parser for conventional academic LaTeX. It
does not attempt to reproduce arbitrary TeX execution.

**Rationale:** Minimal dependencies and control over the syntax model are valuable, while complete
TeX interpretation would require handling programmable catcodes, arbitrary macro execution, and
other engine behavior outside the manuscript export problem.

**Consequence:** Unsupported dynamic syntax must be diagnosed or delegated to compile assistance.

### D006 — Keep the compiler core free of external runtime packages

**Decision:** The production lexer, parser, semantic compiler, and emitter use the .NET base class
libraries.

**Rationale:** The parser is foundational infrastructure and should remain inspectable, stable, and
easy to run in the PowerShell environment.

**Consequence:** Any proposed third-party runtime dependency requires a new recorded decision.

### D007 — Use Unified LaTeX only for differential testing

**Decision:** Unified LaTeX may generate or compare development fixtures but is not a production
dependency or specification authority.

**Rationale:** An independent PEG-based parser is valuable for detecting blind spots. Depending on
its AST or Markdown conversion would weaken control over the compiler contract and introduce a
Node dependency.

**Consequence:** Routine tests use checked-in neutral fixtures and do not require Unified LaTeX.

### D008 — Deliver a clean bundle

**Decision:** The default export contains `<slug>-latex.md` and its `images/` directory.

**Rationale:** The output is a manuscript deliverable, not a development workspace.

**Consequence:** IR, source maps, TeX products, logs, and temporary render products live elsewhere
or require an explicit diagnostic option.

### D009 — Preserve content rather than printing

**Decision:** Fidelity applies to knowledge-bearing manuscript content and structure, not visual
facsimile.

**Rationale:** LaTeX-to-Markdown is intentionally lossy with respect to typesetting while remaining
capable of a faithful transfer of the latent manuscript.

**Consequence:** Page layout, float placement, font styling, and similar printing choices may be
normalized away.

### D010 — Mathematical register is a hard boundary

**Decision:** Inline and display mathematics are parsed nodes and emitted under consistent
delimiters.

**Rationale:** Mathematical content must not be conflated with prose or subjected to prose cleanup.
The resulting documents must support reliable register masking and later math-AST work.

**Consequence:** The exporter preserves the structure required by the future math specification but
does not wait for that specification to be complete.

### D011 — Use a simple numbered Markdown bibliography

**Decision:** The initial bibliography is a numbered Markdown reference list with in-document
numeric citations.

**Rationale:** This retains the information required for reading and context engineering without
reproducing journal-specific bibliography typography.

**Consequence:** Rich citation rendering and navigable anchors are later extensions.

### D012 — Defer the historical gauntlet loop

**Decision:** The prior gauntlet orchestration is not part of initial `tex-export` development.

**Rationale:** The new module first needs coherent compiler units and one complete vertical export.

**Consequence:** Valuable gauntlet cases are promoted selectively into focused fixtures.

### D013 — Do not freeze the future ABI

**Decision:** The compiler uses a typed internal manuscript model, but does not initially define or
emit the final cross-converter JSONL ABI.

**Rationale:** The model should be learned from actual compilation requirements.

**Consequence:** Development inspection may expose the model, but the clean bundle does not contain
it and downstream consumers must not yet depend on its serialization.

## Open questions

### O001 — Supported input forms

Determine the first stable parameter sets for:

- project directory;
- main `.tex` file;
- `.tar.gz` and other archives;
- explicit versus automatic slug selection.

### O002 — Build and distribution

Determine:

- the compiler target framework compatible with the supported portable PowerShell runtime;
- whether source checkouts build on demand or bootstrap explicitly;
- packaged module placement for the compiler assembly;
- whether build artifacts are committed, packaged, or always regenerated.

Runtime C# compilation during module import is currently disfavored.

### O003 — Compile-assistance policy

Define:

- supported TeX engines;
- BibTeX and Biber selection;
- sandboxing, shell-escape, timeout, and network rules;
- whether export can proceed without compile assistance;
- the exact interface for fixture substitutes.

### O004 — Markdown profile

Determine the precise combination of Markdown conventions, including:

- heading anchors;
- footnotes;
- definition and theorem blocks;
- table extensions or HTML;
- attributes and identifiers;
- equation, figure, and reference links.

### O005 — Image policy

Determine:

- terminal image formats;
- deterministic asset naming;
- vector preservation versus raster derivatives;
- crop, rotation, and page-selection handling;
- representation of multi-panel figures;
- image-caption and alt-text conventions.

Earlier corpus rules do not settle these choices automatically.

### O006 — Unsupported syntax

Define when an unknown construct:

- is known to be nonprinting and may be ignored;
- may be preserved as a deliberate Markdown extension;
- makes the export incomplete;
- requires compile assistance;
- requires a new parser or semantic feature.

Raw-TeX leakage is not the default answer.

### O007 — Macro support boundary

Determine the supported declarative subset of:

- `\newcommand`, `\renewcommand`, and `\providecommand`;
- `\def` and related primitives;
- custom environments;
- package-defined signatures;
- `\makeatletter` and expl3 naming;
- catcode changes and conditional execution.

### O008 — Bundle promotion and overwrite behavior

Define:

- atomic staging and promotion;
- behavior when the target slug already exists;
- whether warnings permit promotion;
- whether an incomplete candidate is retained outside the target bundle;
- cleanup and recovery guarantees.

### O009 — Bibliography links

Determine the canonical anchor and link convention for citations and references without coupling
the manuscript to one Markdown renderer.

### O010 — Provenance and diagnostics

Determine how much source provenance is retained in memory, exposed by SDK result objects, and
optionally serialized for development without contaminating the manuscript bundle.

### O011 — Navigation and addressability

Determine:

- whether semantic nodes receive stable document-local identities;
- whether compiler spans use UTF-16 offsets, Unicode scalar offsets, UTF-8 byte offsets, or an
  explicit combination at each boundary;
- how emitter spans map semantic nodes into the Markdown serialization;
- whether a hierarchical table of contents is emitted in the manuscript, exposed through the SDK,
  or offered as an optional sidecar;
- which index a future reader surface consumes for random access.

The section tree remains the semantic hierarchy. Tables of contents and byte indexes are derived
views and must not become competing document models.

## Decision discipline

An open question should be resolved using the smallest representative fixtures that reveal the
tradeoff. Once selected, the convention must be:

1. recorded here;
2. represented explicitly in compiler types or policy;
3. covered by a focused test;
4. exercised in at least one end-to-end export where applicable.
