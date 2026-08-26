# `tex-export` implementation plan

**Status:** proposed sequence

**Established:** 2026-07-24

The plan keeps an executable vertical path through the compiler. Each milestone should leave the
module in a coherent, testable state rather than creating disconnected IR experiments.

## Milestone 0 — Module and build skeleton

Create:

- `TexExport.psd1` and `TexExport.psm1`;
- the public/private PowerShell layout;
- `TexExport.Compiler.csproj`;
- deterministic build and test entry points;
- compiler assembly loading through the module;
- a minimal `Export-TexDocument` command;
- typed request, result, and diagnostic objects.

Acceptance:

- the module imports in the repository's portable PowerShell environment;
- a C# compiler method can be invoked through the public command;
- SDK output is an object and contains no presentation-only console text;
- a temporary bundle can be staged and removed by a test.

## Milestone 1 — Lossless syntax frontend

Implement:

- immutable source text and spans;
- lexer tokens and trivia;
- comments, commands, groups, optional groups, and environments;
- inline and display math boundaries;
- verbatim lexer modes;
- parser recovery and stable diagnostics;
- a generic lossless syntax tree;
- a syntax visitor.

Acceptance:

- nested arguments and environments parse without regular-expression nesting;
- comments and verbatim commands cannot become active syntax;
- malformed groups and math boundaries produce positioned diagnostics;
- unknown commands remain in the tree;
- token text can reconstruct the parsed source for supported lexical modes.

## Milestone 2 — Minimal manuscript compiler

Implement enough binding and semantic compilation for:

- `\documentclass` and document boundaries;
- title and abstract;
- paragraphs;
- section hierarchy;
- inline and display math;
- basic emphasis and links;
- ordered and unordered lists;
- ordered mixed-register inline children;
- a Markdown writer.

Acceptance:

- a multi-file-free academic fixture compiles to readable Markdown;
- one paragraph can alternate text, citations or links, and multiple inline formulas without
  flattening their node identities;
- math survives as parsed register nodes;
- Markdown is produced from manuscript nodes rather than syntax-string cleanup;
- no compiler IR appears in the bundle.

## Milestone 3 — Project system and source closure

Implement:

- deterministic main-file selection;
- parsed `\input` and `\include`;
- cycle and missing-file diagnostics;
- per-file source spans;
- external verbatim and listing input;
- archive extraction adapter;
- isolated work directories.

Acceptance:

- includes resolve relative to the including file;
- commands inside comments and verbatim regions are never expanded;
- arbitrary include depth is supported subject to cycle detection and resource limits;
- all source dependencies are represented in the compilation result.

## Milestone 4 — References vertical slice

Implement:

- citation syntax and key retention;
- inline `thebibliography`;
- parsed `.bbl` intake;
- compile-assistance interfaces for BibTeX and Biber;
- bibliography ordering and numeric citation resolution;
- numbered Markdown reference emission;
- unresolved-citation diagnostics.

Acceptance:

- every supported citation resolves to a stable number;
- the full reference list is emitted under `## References`;
- missing or unsupported bibliography inputs cannot yield silent `[?]` output;
- the `2607.16621` bibliography and citations are complete.

## Milestone 5 — Figures and assets

Implement:

- `\includegraphics` and graphics-path resolution;
- figures, captions, labels, and panel relationships;
- collision-safe relative asset naming;
- direct image-copy and conversion adapters;
- TikZ and other diagram-rendering adapters;
- an encode-first seam for mathematical diagrams;
- bundle asset validation.

Acceptance:

- every active image reference maps to one emitted asset or one positioned error;
- all Markdown image links resolve inside the bundle;
- a multi-panel fixture retains all panels and captions;
- empirical plots in the reference manuscript are exported.

## Milestone 6 — Complete manuscript structures

Add focused compiler support for:

- authors, affiliations, correspondence, and other front matter;
- appendices;
- labels, counters, and cross-references;
- footnotes;
- theorem and proof families;
- algorithms and pseudocode;
- tables and span-aware fallback conventions;
- acknowledgements and supplemental sections.

Acceptance:

- each construct has a syntax representation, semantic node, Markdown convention, and test;
- unsupported variants produce diagnostics instead of disappearing;
- the reference manuscript compiles without raw structural LaTeX.

## Milestone 7 — Validation and usable export

Implement:

- Markdown structural validation;
- math-register validation;
- asset-link closure;
- citation/reference closure;
- per-kind source coverage and unsupported-node accounting;
- atomic bundle promotion;
- concise SDK statistics;
- documentation for installation and use.

Acceptance:

- `2607.16621` produces a clean bundle suitable for immediate context use;
- the SDK reports success only when required closure checks pass;
- every active knowledge-bearing source construct is compiled, externalized, or represented by an
  explicit diagnostic;
- target output contains only the Markdown manuscript and referenced assets;
- failures identify source files and spans.

## Milestone 8 — Coverage expansion

After the first complete export:

- select representative manuscripts rather than restoring the old gauntlet loop wholesale;
- promote each new failure into a minimized fixture;
- extend command and environment signatures;
- record new Markdown conventions in the decision log;
- use Unified LaTeX selectively for differential parsing;
- study the accumulated manuscript model and exports for future ABI work.

This milestone is continuous. It does not redefine the exporter as an audit or repair framework.
