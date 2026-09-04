# Batch adapters

`batch-adapters` contains the domain planners for the finite-batch executor. Import the canonical module
through `adapters.psd1`. It exports `Get-GauntletBatchJob`, `Get-PesterBatchJob`, and
`Get-PytestBatchJob` while leaving the executor's four-command public surface unchanged. These are public
files in one module, not one PowerShell module per adapter; no unitary adapter module or compatibility alias
is introduced.

Every planner rejects a `RunDirectory` outside `RepositoryRoot/artifacts` through
`Resolve-ArtifactRunDirectory` in `src/infrastructure/containment.ps1`. Child processes receive
`CDXSCI_TEMP` under that run, and `TEMP`/`TMP`/`TMPDIR` are projected from it so OS temp APIs cannot
follow the ambient user temp tree. `tests/batch.ps1` is the public test-batch caller, including a
one-file selection; suite naming lives in `tests/suite-name.ps1`.

Every planner obeys the same job-emission contract (`New-BatchJob` only; caller owns `New-BatchPlan` /
`Invoke-BatchPlan`). The retired latex-ingest adapter and the in-repository TeXdig census adapter live in the
graveyard archive; corpus runs of external engines go through the gauntlet adapter below.

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
- the PowerShell executable, repository working directory, runner entrypoint, and the child's
  infrastructure helpers (`assert-temp.ps1` and sibling `containment.ps1`);
- a file-size cost hint; and
- one container address beneath `RunDirectory/pester-jobs/`, with a Pester-native `pester.xml` result,
  retained `artifacts/`, and ephemeral `temp/` root.

One private pure resolver owns all run-relative address composition. Planning creates no directories or
files. The job declares the XML, retained artifact, and temporary roots in `Writes`.
`ProcessSpec.Environment` transports `CDXSCI_TEST_ARTIFACT_ROOT`, a job-local
`CDXSCI_JSON_SCRATCH_ROOT`, `CDXSCI_TEMP`, and `TEMP`/`TMP`/`TMPDIR` projected from `CDXSCI_TEMP`. Pester's XML is an explicit
runner-native artifact; retained suite evidence stays below the container artifact root; and the generic
batch execution result remains the in-memory return from `Invoke-BatchPlan`.

`Get-PesterBatchJob` only plans work. The caller imports the batch-executor module separately, passes the
emitted jobs to `New-BatchPlan`, and invokes a valid plan through `Invoke-BatchPlan`. This keeps adapters
composable: independent domain jobs can share one queue without another scheduler or convenience
wrapper taking ownership of execution policy.

The Pester adapter never allocates or joins a run, selects logger sink topology, serializes the generic
execution record, or owns pools, cancellation, retries, and result ordering. Process jobs receive the
executor's `CDXSCI_BATCH_JOB_ID`; any caller-supplied logging or correlation environment continues through ordinary
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
`CDXSCI_TEST_ARTIFACT_ROOT` transports the retained evidence root. `CDXSCI_TEMP` is the job ephemeral
root; pytest/Python scratch and JSON-engine coordination live under it. Native JUnit remains the durable
framework result and the generic executor record remains in memory. The resolved child PowerShell is
transported as `CDXSCI_TEST_POWERSHELL_PATH`; shell-surface tests consume that exact path and use `PATH`
only for direct, non-batch pytest. `Metadata.PowerShellEnvironment` names that transport key.

`tests/pytest.ps1` is the authoritative runner and the job's direct PowerShell entrypoint. It invokes the
pinned interpreter as `python -m pytest`, captures native streams and status, rejects empty runs,
writes JUnit, and emits `PytestContainerObservation`. There is no second Python runner or adapter worker.
Executor timeout and teardown continue to own the PowerShell child and its Python descendant; adding this
adapter does not add a native-process executor mode.

BEX-604 evolved `tests/parallel.ps1` into the one multilingual repository shell; no pytest-only parallel
shell exists. It combines the adapters' domain-neutral jobs into one plan while
keeping framework selectors, observations, job IDs, address roots, and native reports distinct.

## Gauntlet adapter

`Get-GauntletBatchJob` plans corpus runs for an engine that lives in **another repository**. It accepts
deposited article directories, `article.json` files, or collection directories (expanded one level to their
article children) under this repository, an existing absolute `RunDirectory` below `RepositoryRoot/artifacts`,
an `Engine` label, the engine's `EngineRoot`, and the `Worker` child entrypoint the engine supplies. One
document per job; the job container IS the document container: the worker emits whatever it emits at
`RunDirectory/gauntlet-jobs/<slug>-<digest>/`, with ephemeral state under
`RunDirectory/gauntlet-temp/<slug>-<digest>/`.

| Owner | Owns |
| --- | --- |
| codex-scientiae | the corpus (`supellex/gauntlet`), this planner, the batch executor, run minting under `artifacts/gauntlet/{stamp}/{engine}/`, `CDXSCI_TEMP`, and the receipt contract |
| the engine repository | `EngineRoot`, the `Worker` (a `.ps1` below `EngineRoot`, conventionally in a gitignored `private/` tree), its runtime, and every file it writes inside the job container |

Planning resolves and freezes:

- a stable `gauntlet:<engine>:<repository-relative-article-dir>#<digest>` id from the engine label, the article
  address, and the deposit's frozen `treeSha256` (a re-deposit changes the id; a re-run over the same tree
  does not; two engines over one deposit never share a container);
- `EngineRoot` (absolute, existing, disjoint from `RepositoryRoot`) as the child working directory and
  `Worker` (absolute, existing `.ps1` below `EngineRoot`) as the child entrypoint;
- the frozen named parameters `Article`, `OutDirectory`, and `EngineRoot`, plus any caller-supplied
  `WorkerParameter` entries that do not shadow those three;
- a tree-byte cost hint; and
- the job container and temp addresses, declared in `Writes`.

The planner resolves **no engine runtime**: not node, not perl, not a dependency root. Preflight of the
engine belongs to the engine-side launcher before it asks for a plan. `ProcessSpec.Environment` transports
`CDXSCI_TEMP`, a job-local `CDXSCI_JSON_SCRATCH_ROOT`, and `TEMP`/`TMP`/`TMPDIR` projected from
`CDXSCI_TEMP`; the executor adds `CDXSCI_BATCH_JOB_ID`.

### Worker contract

The worker is a PowerShell 7 script taking `-Article` (deposit directory), `-OutDirectory` (the job
container, not yet created), and `-EngineRoot`, plus whatever `WorkerParameter` names the caller froze. It
creates `OutDirectory` itself, writes only below `OutDirectory` and `CDXSCI_TEMP`, and exits non-zero on
failure. The child bootstrap treats **any error record** in the merged stream as failure, so a worker that
spawns a native process must route that process's stderr to a file inside the job container rather than
letting it flow into the PowerShell error stream.

On success the worker leaves `receipt.json` at the top of `OutDirectory` with schema
`codex-scientiae/gauntlet-receipt/0.1`: `engine`, `engineVersion`, `engineCommit`, `article` (`slug`,
`treeSha256`, `directory`), `status` (`ok` or `failed`), `startedUtc`, `endedUtc`, `durationMs`, `stores`
(file names it emitted), and `counts` (a flat map of numeric measurements). The receipt is the only thing
codex-scientiae reads back; the run caller folds receipts into a run summary and never opens the engine's
own stores. `Metadata.ReceiptPath` names the expected location.

## Ownership boundary

The exported commands only interpret domain input and emit `BatchJob` records. Callers compile and invoke
those jobs through `New-BatchPlan` and `Invoke-BatchPlan`. The adapters do not own pools, cancellation,
retries, result ordering, run allocation, logger lifecycle, or durable executor-result storage.
