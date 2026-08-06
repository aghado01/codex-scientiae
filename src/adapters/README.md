# Batch adapters

`adapters` contains the domain planners for the shared finite-batch executor. It exports two commands while
leaving the executor's four-command public surface unchanged: `Get-PesterBatchJob` for repository Pester
work and `Get-LatexBatchJob` for manifest-backed latex-ingest work. These are public files in one module,
not one PowerShell module per adapter; the Pester command has no compatibility alias.

## Pester adapter

`Get-PesterBatchJob` accepts caller-selected `*.Tests.ps1` files or directories and an existing absolute
`RunDirectory`. Directories expand recursively to one `PowerShellProcess` job per test file. Optional Pester
full-name and tag filters select cases inside each file without loading Pester or suite code in the planning
process.

Planning resolves and freezes:

- a stable `pester:<repository-relative-path>#<digest>` job ID from repository-relative test identity plus
  normalized filters;
- the exact Pester 5-or-newer manifest imported by the child;
- the PowerShell executable, repository working directory, and runner entrypoint;
- a file-size cost hint; and
- one container address beneath `RunDirectory/pester-jobs/`, with a Pester-native `pester.xml` result and
  sibling `artifacts/` root.

One private pure resolver owns all run-relative address composition. Planning creates no directories or
files. The job declares both the XML path and container artifact root in `Writes`, and its
`ProcessSpec.Environment` transports the absolute artifact root to the child as
`CODEX_TEST_ARTIFACT_ROOT`. Pester's XML is an explicit runner-native artifact; retained suite evidence
stays below the container artifact root; and the generic batch execution result remains the in-memory
return from `Invoke-BatchPlan`.

`Get-PesterBatchJob` only plans work. The caller imports the batch-executor module separately, passes the
emitted jobs to `New-BatchPlan`, and invokes a valid plan through `Invoke-BatchPlan`. This keeps adapters
composable: test and LaTeX jobs can share one queue without another scheduler or convenience
wrapper taking ownership of execution policy.

The Pester adapter never allocates or joins a run, selects logger sink topology, serializes the generic
execution record, or owns pools, cancellation, retries, and result ordering. Process jobs receive the
executor's `CODEX_BATCH_JOB_ID`; any caller-supplied logging or correlation environment continues through ordinary
process policy.

## LaTeX adapter

`Get-LatexBatchJob` accepts caller-selected document-inventory rows and an existing absolute
`RunDirectory`. It resolves each row to one source-ready `codex-scientiae/document-metadata/0.1` manifest
and emits one isolated latex-ingest process job per document. The exact latex-ingest script, its SHA-256,
the child PowerShell, output-affecting switches, environment, timeout, priority, and original inventory row
are frozen into each job.

Stable identity derives from the inventory-relative manifest, source-tree fingerprint, and output options.
One private resolver owns all paths beneath `RunDirectory/latex-jobs/`: application evidence, lane output,
and an optional deliverable root. The job declares every such root in `Writes`, and planning creates none.
The private worker invokes only latex-ingest's manifest-backed production entrypoint.

## Ownership boundary

Both commands only interpret domain input and emit `BatchJob` records. Callers compile and invoke those jobs
through `New-BatchPlan` and `Invoke-BatchPlan`. The adapters do not own pools, cancellation, retries, result
ordering, run allocation, logger lifecycle, or durable executor-result storage.
