# tests/

Pester tests are grouped by the source module or product shell they currently
exercise. The grouping makes module boundaries and future evictions legible; it
does not imply that every embedded capability ultimately belongs to its present
module.

Shared durable fixtures remain under `tests/fixtures/`. `run.ps1` stays at the
test root and discovers `*.Tests.ps1` recursively.

## Running

```pwsh
pwsh -File tests/run.ps1
pwsh -File tests/run.ps1 -Path tests/latex-ingest
pwsh -File tests/run.ps1 -Path tests/shared/masks.Tests.ps1
```

`run.ps1` imports Pester 5 or newer from the portable PowerShell module tree
when available, falls back to the normal module path, exits non-zero on test
failure, and refuses to report success when discovery finds no tests.

## Module groups

| Directory | Current ownership |
|---|---|
| `audits/` | Repository and deliverable audit capabilities |
| `codex-membrane/` | The retiring membrane product shell and capabilities still embedded in it |
| `hdbscan/` | HDBSCAN executable and evaluator contracts |
| `infrastructure/` | Repository-wide topology and structural checks |
| `latex-ingest/` | LaTeX ingestion, stores, patches, and rendering integration |
| `math-register/` | Mathematical register normalization |
| `md-postprocess/` | Markdown hygiene and bundle construction |
| `pdf-converter/` | The eviction-bound PDF-converter model and its experiments |
| `procurement/` | Scholarly discovery and acquisition adapters |
| `reader-mcp/` | Portable deliverable reader MCP |
| `render-check/` | KaTeX render validation capability |
| `shared/` | Substrate-level primitives such as masks, JSONL, anchors, and sentinels |
| `toc-engine/` | Deliverable TOC and manifest rendering |

## Conventions

- One `*.Tests.ps1` file per concern, inside the directory of its current owner.
- Dot-source the module under test in a top-level `BeforeAll` when practical.
- From a module test directory, the repository root is `../..` relative to
  `$PSScriptRoot`; shared fixtures are under `../fixtures`.
- Reproduced bugs and calibration decisions should be named regressions rather
  than unexplained snapshots.
- Tests that move with an evicted product shell are not automatically endorsed
  as future contracts. Primitive assertions may be extracted later on merit.
- Corpus-backed membrane tests use the committed streams under
  `tests/fixtures/chunks/`; see that directory's README for provenance.
