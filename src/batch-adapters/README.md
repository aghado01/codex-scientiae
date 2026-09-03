# Batch adapters

`batch-adapters` contains the domain planners for the finite-batch executor. Import the canonical module
through `adapters.psd1`. It exports `Get-PesterBatchJob`, `Get-PytestBatchJob`, and
`Get-TeXdigBatchJob` while leaving the executor's four-command public surface unchanged. These are public
files in one module, not one PowerShell module per adapter; no unitary adapter module or compatibility alias
is introduced.

Every planner rejects a `RunDirectory` outside `RepositoryRoot/artifacts` through
`src/logistics/artifact-boundary.ps1`. Child processes receive repository-local `TEMP`, `TMP`, and
`TMPDIR`; the operating-system user temp tree is not a fallback. `tests/batch.ps1` is the public
test-batch caller, including a one-file selection.

A successor LaTeX conversion planner can rejoin this module later under the same job-emission contract
(`New-BatchJob` only; caller owns `New-BatchPlan` / `Invoke-BatchPlan`). The retired latex-ingest adapter
surface lives in the graveyard archive.

## Pester adapter

`Get-PesterBatchJob` accepts caller-selected `*.Tests.ps1` files or directories and an existing absolute
`RunDirectory` below `RepositoryRoot/artifacts`. Directories expand recursively to one
`PowerShellProcess` job per test file. Optional Pester
full-name and tag filters select cases inside each file without loading Pester or suite code in the planning
process.

Planning resolves and freezes:

- a stable `pester:<repository-relative-path>#<digest>` job ID from repository-relative test identity plus
  normalized filters;
- the exact Pester 5-or-newer manifest imported by the child;
- the PowerShell executable, repository working directory, and runner entrypoint;
- a file-size cost hint; and
- one container address beneath `RunDirectory/pester-jobs/`, with a Pester-native `pester.xml` result,
  retained `artifacts/`, and ephemeral `temp/` root.

One private pure resolver owns all run-relative address composition. Planning creates no directories or
files. The job declares the XML, retained artifact, and temporary roots in `Writes`.
`ProcessSpec.Environment` transports `CODEX_TEST_ARTIFACT_ROOT`, a job-local
`CODEX_JSON_SCRATCH_ROOT`, and identical `TEMP`, `TMP`, and `TMPDIR` values. Pester's XML is an explicit
runner-native artifact; retained suite evidence stays below the container artifact root; and the generic
batch execution result remains the in-memory return from `Invoke-BatchPlan`.

`Get-PesterBatchJob` only plans work. The caller imports the batch-executor module separately, passes the
emitted jobs to `New-BatchPlan`, and invokes a valid plan through `Invoke-BatchPlan`. This keeps adapters
composable: independent domain jobs can share one queue without another scheduler or convenience
wrapper taking ownership of execution policy.

The Pester adapter never allocates or joins a run, selects logger sink topology, serializes the generic
execution record, or owns pools, cancellation, retries, and result ordering. Process jobs receive the
executor's `CODEX_BATCH_JOB_ID`; any caller-supplied logging or correlation environment continues through ordinary
process policy.

## Pytest adapter

`Get-PytestBatchJob` accepts caller-selected `test_*.py` files or directories and an existing absolute
`RunDirectory` below `RepositoryRoot/artifacts`. Directory discovery produces one `PowerShellProcess` job
per physical file without
importing pytest or test code. Pytest methods, node IDs, parameter rows, and `unittest.subTest` contexts stay
inside the file job; the adapter does not add method-level scheduling or pytest-xdist.

The planning contract freezes:

- a stable `pytest:<repository-relative-path>#<digest>` ID from exact source identity plus normalized
  framework selectors;
- the repository-local or caller-supplied Python interpreter, repository working directory, and
  `tests/pytest.ps1` runner;
- cache, bytecode, temporary-directory, and JSON-engine scratch policy;
- a file-size cost hint; and
- one container beneath `RunDirectory/pytest-jobs/`, containing `pytest.xml`, `artifacts/`, and `temp/`.

One private resolver owns all three addresses. Planning creates none; each is declared in `Writes`.
`CODEX_TEST_ARTIFACT_ROOT` transports the retained evidence root, while the temporary address contains
pytest/Python scratch and the test-local JSON-engine coordination root. Native JUnit remains the durable
framework result and the generic executor record remains in memory. The resolved child PowerShell is
transported as `CODEX_TEST_POWERSHELL_PATH`; shell-surface tests consume that exact path and use `PATH`
only for direct, non-batch pytest. `Metadata.PowerShellEnvironment` names that transport key.

`tests/pytest.ps1` is the authoritative runner and the job's direct PowerShell entrypoint. It invokes the
pinned interpreter as `python -m pytest`, captures native streams and status, rejects empty runs,
writes JUnit, and emits `PytestContainerObservation`. There is no second Python runner or adapter worker.
Executor timeout and teardown continue to own the PowerShell child and its Python descendant; adding this
adapter does not add a native-process executor mode.

BEX-604 evolved `tests/parallel.ps1` into the one multilingual repository shell; no pytest-only parallel
shell exists. It combines the adapters' domain-neutral jobs into one plan while
keeping framework selectors, observations, job IDs, address roots, and native reports distinct.

## TeXdig adapter

`Get-TeXdigBatchJob` accepts deposited article directories, `article.json` files, or collection
directories (expanded one level to their article children) plus an existing absolute `RunDirectory` below
`RepositoryRoot/artifacts`. One document per job; the job container IS the document container: the census
worker emits its six stores directly at `RunDirectory/texdig-jobs/<slug>-<digest>/`. Temporary and JSON
coordination state uses the distinct declared root `RunDirectory/texdig-temp/<slug>-<digest>/`.

Planning resolves and freezes:

- a stable `texdig:<repository-relative-article-dir>#<digest>` id from the article address plus the
  deposit's frozen `treeSha256` (a re-deposit changes the id; a re-run over the same tree does not);
- the `src/TeXdig/run-census.ps1` worker entrypoint, the pinned node dependency root, and node
  itself (a whole plan refuses before any child spawns when either is absent);
- a tree-byte cost hint; and
- the job container address (`-OutDirectory` to the worker).

The child worker owns the `validate-json` shape check through the jsonl_engine-client seam; planning
only reads the manifest for identity and refuses unreadable ones. Bare-slug convenience stays in the
interactive runner; the adapter is path-based.

## Ownership boundary

The exported commands only interpret domain input and emit `BatchJob` records. Callers compile and invoke
those jobs through `New-BatchPlan` and `Invoke-BatchPlan`. The adapters do not own pools, cancellation,
retries, result ordering, run allocation, logger lifecycle, or durable executor-result storage.
