# tests/

Pester tests are grouped by the source module or product shell they currently
exercise. The grouping makes module boundaries and future evictions legible; it
does not imply that every embedded capability ultimately belongs to its present
module.

Shared durable fixtures remain under `tests/fixtures/`. `run.ps1` stays at the
test root and discovers `*.Tests.ps1` recursively.

## Running

Restore the locked shared Node payload before running the suite; Node-backed integration tests resolve
only this shelf and never fall back to use-case-local installations:

```pwsh
./brewery/node/restore-node.ps1
```

```pwsh
pwsh -File tests/run.ps1
pwsh -File tests/run.ps1 -Path tests/latex-ingest
pwsh -File tests/run.ps1 -Path tests/shared/masks.Tests.ps1
```

`run.ps1` imports Pester 5 or newer from the portable PowerShell module tree
when available, falls back to the normal module path, exits non-zero on test
failure, and refuses to report success when discovery finds no tests.

For isolated batch jobs, `-ResultPath` enables a Pester-native XML report and creates only its parent
directory. `-ResultFormat`, `-TestSuiteName`, `-OutputVerbosity`, `-FullNameFilter`, `-Tag`, and `-ExcludeTag`
freeze the corresponding Pester configuration. Failed or empty runs throw so both direct CLI processes and
nested batch workers observe failure.

## Module groups

| Directory | Current ownership |
|---|---|
| `audits/` | Repository and deliverable audits, including mathematical rendering |
| `hdbscan/` | HDBSCAN executable and evaluator contracts |
| `infrastructure/` | Repository-wide topology and structural checks |
| `latex-ingest/` | LaTeX ingestion, stores, patches, and rendering integration |
| `math-register/` | Mathematical register normalization |
| `md-postprocess/` | Markdown hygiene and bundle construction |
| `procurement/` | Scholarly discovery and acquisition adapters |
| `reader-mcp/` | Portable deliverable reader MCP |
| `shared/` | Substrate-level primitives such as masks, JSONL, anchors, and sentinels |
| `test-batch/` | Repository Pester discovery adapter, addressing, and isolated execution |
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
