# `tex-export`

**Status:** design baseline

**Established:** 2026-07-24

**Implementation target:** `src/tex-export`

## Purpose

`tex-export` is a standalone LaTeX-to-Markdown exporter for academic manuscripts. It accepts a
LaTeX project, compiles its knowledge-bearing content into a canonical Markdown manuscript, and
delivers a clean, relocatable bundle suitable for direct use in context engineering.

The exporter is an end in its own right. Its implementation will also expose useful evidence about
the eventual latent-manuscript and mathematical-register specifications, but those research
questions do not define a separate prerequisite project.

## Immediate outcome

The public operation produces:

```text
<target-root>/<slug>/
├── <slug>-latex.md
└── images/
```

The target bundle contains the manuscript and the assets it references. Compiler intermediates,
temporary TeX products, diagnostic traces, experimental IRs, and development-loop state do not
belong in the default deliverable.

The first reference export is:

```text
D:\aghado01\codex-scientiae\ingestion\_inbox\2607.16621
```

Its successful export must include the complete front matter, abstract, manuscript body,
appendices, external listings, citations, numbered reference list, and applicable figures or
diagrams.

## Project boundaries

`tex-export` is:

- a new module with its own public contract;
- a parser and compiler, not a sequence of semantic regular-expression rewrites;
- a first-class PowerShell SDK backed by a native .NET compiler core;
- focused on producing a useful Markdown manuscript end to end;
- developed incrementally against representative fixtures.

`tex-export` is not:

- a rename, fork, or direct continuation of `src/latex-ingest`;
- the old LaTeX-oracle or gauntlet development loop;
- a corpus publishing or finalization workflow;
- a visual facsimile generator;
- a complete implementation of the TeX engine;
- the final shared manuscript ABI or native Markdown math AST.

The old implementation remains evidence. Individual algorithms, renderers, and fixtures may be
adapted after review, but `tex-export` does not dot-source or otherwise depend on
`src/latex-ingest`.

## Design documents

- [Emerging specification](specification.md) defines the product and manuscript contract.
- [Architecture](architecture.md) defines the PowerShell SDK and native compiler design.
- [Decision record](decisions.md) distinguishes settled choices from open questions.
- [Implementation plan](implementation-plan.md) gives the end-to-end development sequence.
- [Prior-art evidence synthesis](evidence-synthesis.md) derives provisional math-register and
  manuscript-envelope requirements from the earlier converter code and issue corpus.

## Guiding criterion

For every active, knowledge-bearing source construct, the compiler must do one of the following:

1. emit a canonical Markdown representation;
2. externalize it as a referenced asset;
3. report that it could not compile the construct.

Silent loss is never an accepted conversion policy.
