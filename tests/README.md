# tests/

Repository tests are multilingual and grouped by the source module or product shell they currently
exercise. The grouping makes module boundaries and future evictions legible; it does not imply that every
embedded capability ultimately belongs to its present module. Shared durable fixtures remain under
`tests/fixtures/`.

Framework semantics stay separate while their jobs share the batch executor:

| Framework | Physical container | Current direct runner | Batch state |
|---|---|---|---|
| Pester | `*.Tests.ps1` | `tests/run.ps1` | Implemented through `Get-PesterBatchJob` and `tests/parallel.ps1`. |
| pytest | `test_*.py` | `tests/pytest.ps1` | Implemented through `Get-PytestBatchJob` and `tests/parallel.ps1`. |

The [pytest inventory](../issues/batch-executor/planning/pytest-batchability-inventory.md) and
[completed workplan](../issues/batch-executor/planning/pytest-testing-workplan.md) record the admitted lane. The
completed Pester contract below remains authoritative for Pester and is not retroactively generalized into
pytest terminology.

## Adding a Pester test: quick contract

```text
tests/
  <module-or-product>/
    <behavior>.Tests.ps1
  fixtures/                 # durable shared inputs only
  run.ps1                   # sequential and exact-path runner
  parallel.ps1              # file-level batch shell
```

One physical `*.Tests.ps1` file is one batch job and runs in one fresh child PowerShell. `Describe`,
`Context`, `It`, parameters, and tags remain inside that job; they are not separately scheduled. Group a
file under its current source-module or product-shell owner, and split files only at a real fixture,
capability, resource, or cost seam.

For every new or changed test file:

- Make each `It` independent of earlier `It` blocks. Create shared read-only inputs in `BeforeAll`; reset
  mutable inputs in `BeforeEach` or within the test.
- Put ephemeral writes in `$TestDrive`. Put retained evidence only below
  `$env:CODEX_TEST_ARTIFACT_ROOT`; never use a repository-global artifact path, fixed temporary directory,
  fixed port, or common build output.
- Restore environment variables, location, modules, globals, console state, locks, runspaces, and child
  processes on every path, normally with `try`/`finally` or Pester cleanup hooks.
- Preflight optional external capabilities deterministically and skip with a reason when absent. Do not
  download, restore, or build missing dependencies during a test.
- Capture native stdout, stderr, and exit status locally. After asserting an expected nonzero native exit,
  reset `$LASTEXITCODE` so it cannot contaminate the runner result.
- Do not add per-file manifests, sidecars, workload profiles, scheduler locks, or custom batch logic.

At minimum, verify the file through both public entry points (the batch run directory must already exist):

```pwsh
pwsh -File tests/run.ps1 -Path tests/<owner>/<behavior>.Tests.ps1
pwsh -File tests/parallel.ps1 -Framework Pester -Path tests/<owner>/<behavior>.Tests.ps1 `
  -RunDirectory D:/runs/codex-scientiae-tests/new-test -MaxWorkers 1
```

A compliant file selects the expected tests by exact path, reports real failures as nonzero, cleans its
owned state and children, and writes only inside its assigned temporary or artifact boundary. The detailed
contract and review checklist below are authoritative when a case is ambiguous.

## Adding a Python test: quick contract

One physical `test_*.py` file is one batch job. Pytest classes and methods, parameter rows, node
IDs, and `unittest.subTest` contexts remain inside that file; they are not separate jobs. Existing
`unittest.TestCase` files do not need a stylistic rewrite to become batchable.

For every new or changed Python test file:

- Make every test method independent of earlier methods and other test files. Put reusable factories in a
  non-test support module rather than importing a sibling `test_*.py` file.
- Put ephemeral writes in `tmp_path`, `tempfile.TemporaryDirectory`, or another unique temporary root. A
  batch child receives an absolute `CODEX_TEST_ARTIFACT_ROOT` only for retained evidence.
- Treat committed fixtures as read-only. Regeneration is an explicit maintenance operation outside the
  test runner; a missing golden fails.
- Restore environment, working directory, module/global state, mocks, locks, threads, and child processes
  on every path. Joins and subprocess waits require bounds; timeout cleanup terminates descendants.
- Preflight optional tools with a deterministic skip reason. Do not install, restore, or build a missing
  dependency during a test.
- Consume the adapter-provided `CODEX_TEST_POWERSHELL_PATH` for PowerShell integration. Falling back to
  `PATH` is permitted only for direct, non-batch pytest.
- Capture subprocess stdout, stderr, and exit status locally. Do not let expected stderr or a nonzero probe
  contaminate the file runner's result.
- Do not add pytest-xdist, per-file manifests or sidecars, scheduler locks, or custom batch loops.

At minimum, verify Python files through both the native convenience surface and the public batch shell:

```pwsh
.venv/Scripts/python.exe -m pytest -p no:cacheprovider tests/<owner>/test_<behavior>.py
pwsh -File tests/parallel.ps1 -Framework Pytest `
  -PytestPath tests/<owner>/test_<behavior>.py `
  -RunDirectory D:/runs/codex-scientiae-tests/new-python-test -MaxWorkers 1
```

The admitted contract requires exact-file sequential/batch parity, native JUnit, declared
`pytest.xml`/`artifacts`/`temp` addresses, zero cache or bytecode writes, and no surviving descendants. A
green direct file is necessary evidence, not by itself a `Batchable` classification.

## Running

### Pester

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

Every invocation also writes one transient child-stdout line prefixed `PesterContainerObservation`. Its
JSON value contains the resolved `container_path`, `selected`, `passed`, `failed`, `skipped`, `duration_ms`,
and resolved `result_path` (or `null`). The line is emitted before failure propagation so a nested worker can
audit a failed container; it is not a log or generic result store, and the native Pester report remains the
runner's only durable runner-owned artifact. `selected` is the sum of pass/fail/skip outcomes because Pester
5's `TotalCount` can include cases excluded by a full-name filter, unlike Pester 6 and the native result.

### Multilingual batch execution

`parallel.ps1` is the repository-facing multilingual shell. Its mandatory `RunDirectory` must already exist
and belong to the caller; the shell never allocates or timestamps a run. `Framework` explicitly selects
`All`, `Pester`, or `Pytest` and defaults to `All`. `Path` supplies the common selection and defaults to the
repository `tests/` directory; optional `PesterPath` and `PytestPath` override it per framework. There is no
separate workload profile. Architecture decisions [D24 and D27](../issues/batch-executor/planning/decisions.md)
freeze this ownership boundary.

```pwsh
pwsh -File tests/parallel.ps1 -RunDirectory D:/runs/codex-scientiae-tests/run-001
pwsh -File tests/parallel.ps1 -Framework Pytest -PytestPath tests/shared `
  -RunDirectory D:/runs/codex-scientiae-tests/run-002 -MaxWorkers 4
pwsh -File tests/parallel.ps1 -Framework All `
  -PesterPath tests/shared/jsonl-engine-client-module.Tests.ps1 -PytestPath tests/shared/test_reader.py `
  -RunDirectory D:/runs/codex-scientiae-tests/run-003 -MaxWorkers 2
```

The shell imports the canonical `adapters` and `batch-executor` manifests, asks the selected framework
adapters for jobs, concatenates their domain-neutral records, and invokes `New-BatchPlan` and
`Invoke-BatchPlan` once. Pester and pytest keep separate selectors, runners, observations, job IDs,
addresses, and native XML. Both lanes share one worker budget, cancellation path, failure policy, and result
order.

One concise Information-stream line reports total, succeeded, failed, timed-out, cancelled,
infrastructure-error, and duration values. The shell writes the exact in-memory executor record to the
success output stream. If plan validation fails, it throws before execution; if any executed job is not
successful or the executor reports an infrastructure error, it emits the record first and then throws. A
direct `pwsh -File tests/parallel.ps1 ...` invocation therefore exits nonzero without discarding successful
sibling results, native XML, or container artifacts.

BEX-507 admitted its complete 45-file Pester closure snapshot through this ordinary path selection. The
subsequent localized-inventory/latex-batch development container brought that Pester snapshot to 46 files:
36 `Batchable`, 10 `CapabilityGated`, no `NeedsRefactor` or `SerialOnly` residue, 477 textual `It` blocks,
and 490 observed tests. Those are Pester history, not a current multilingual total; the later Python lane is
tracked separately.

The JSONL-engine PowerShell client subsequently added one `CapabilityGated` container. Pytest adapter
coverage and deposit activation add two more `CapabilityGated` containers with five tests each; multilingual
shell evolution adds two observed cases and two nested-fixture-only textual `It` lines, and the topology
container adds one composition case. The current semantic inventory is therefore 49 files: 36 `Batchable`,
13 `CapabilityGated`, 510 textual `It` blocks, and 521 observed tests. The deposit container's focused direct
gate passed 5/5.

### Pytest

Restore the repository Python environment before testing; test execution does not install dependencies:

```pwsh
.venv/Scripts/python.exe -m pip install -r requirements.txt
.venv/Scripts/python.exe -m pip install -e .
```

Run the complete or exact-file direct suite with the pinned environment interpreter:

```pwsh
.venv/Scripts/python.exe -m pytest -p no:cacheprovider
.venv/Scripts/python.exe -m pytest -p no:cacheprovider tests/shared/test_reader.py
```

The cache provider is disabled because repository `.pytest_cache` is a shared write and is not test
evidence. The batch runner also disables bytecode and gives pytest temporary state and JSON-engine
coordination scratch a job-local `temp/` address.

`tests/pytest.ps1` is the authoritative one-file runner and `Get-PytestBatchJob` is the discovery and
addressing owner. Each batch job uses this address:

```text
<RunDirectory>/pytest-jobs/<container-address>/
    pytest.xml
    artifacts/
    temp/
```

`PytestContainerObservation` reports `container_path`, `selected`, `passed`, assertion `failed`, `errors`,
`skipped`, `duration_ms`, result path/presence, Python and pytest versions, and pytest exit code before
failure propagation. `selected` is the durable outcome count: the current direct collection is 192 methods,
while pytest's JUnit and observation report 264 outcomes after adding 72 subtest outcomes. Native JUnit
remains authoritative durable evidence; the shell does not merge it with Pester NUnit.

The earlier post-admission parity witness completed 11/11 jobs at both four workers (17.205 seconds) and
one worker (33.392 seconds). The final hardening refresh keeps the lane at 12 files. Its direct shared-suite
gate passed 190 methods with two genuine symbolic-link capability skips and passed 72 subtests, yielding 264
selected outcomes. `test_deposit.py` contributes 26 methods plus 27 subtests, or 53 outcomes: 24 methods
passed and two symlink cases skipped. A two-worker multilingual gate paired it with the five-test Pester
deposit container: both jobs succeeded in 9.641 seconds, retained their separate native reports, and left
the pytest job-local `json-scratch` empty under
`artifacts/test-runs/deposit-parity-hardened-20260808`.

## Batchable Pester-container contract

This is the canonical BEX-502 authoring and review contract. The supporting
[design brief](../issues/batch-executor/briefs/sol-pester-batch-testing-overhaul-20260805.md) explains the
ownership boundary, and the Pester closure classifications remain in the
[semantic inventory](../issues/batch-executor/planning/testing-batchability-inventory.md).

The atomic schedulable unit is one physical repository-relative `*.Tests.ps1` file, invoked by exact path
through `tests/run.ps1` in one fresh child PowerShell process. `Describe`, `Context`, `It`, `-TestCases`,
full-name filters, and tags select content inside that container; they do not create independent jobs or
prove that selected content is independently schedulable. One file may contain several Describes when they
share a legitimate fixture, but it must satisfy the whole contract below.

### Identity and selection

- The physical file runs successfully by exact path without another test file running first or modifying a
  prerequisite for it.
- Discovery does not silently expand to sibling files. `BeforeDiscovery` may inspect immutable capability
  inputs but does not write, restore dependencies, launch workers, or mutate shared state.
- An `It` selected by full name or tag does not consume output produced only by an earlier `It`. Shared
  immutable setup belongs in a hook or helper, not in an assertion that happens to run first.
- Parameter rows remain rows inside the same job. A large expanded count alone is not a reason to shard the
  file.

### Setup, mutable state, and cleanup

- Top-level code, `BeforeAll`, `BeforeEach`, and discovery are repeatable in a fresh process. They do not
  assume state left by a prior container invocation.
- Environment variables, current location, module/global state, console replacement, runspace resources,
  locks, and other mutable host state are restored with `finally`, `AfterEach`, or `AfterAll` as appropriate.
- Every child process and descendant has bounded cleanup on success, assertion failure, setup failure, and
  host interruption. No process survives its container.
- Cleanup does not depend on assertions completing. Material temporary roots use hooks or `finally`, rather
  than a trailing removal statement that a failed assertion can bypass.

### Writes and container artifacts

`$TestDrive` is the default for ephemeral fixtures and scratch data that need not survive Pester. A retained
native report or application artifact belongs to the caller's run and the exact container invocation.

The frozen batch address is conceptually:

~~~text
<RunDirectory>/pester-jobs/<container-address>/
    pester.xml
    artifacts/
        <suite-owned layout>
~~~

The adapter provides the absolute `artifacts/` path to the child as `CODEX_TEST_ARTIFACT_ROOT` and
declares that root as a job write. Planning creates nothing; execution may create the assigned root. A suite
that retains evidence validates this value as an absolute path and writes only beneath it. It does not fall
back to repository-global `artifacts/`, a timestamp allocator, its source tree, the current directory, or a
fixed user-machine path. Direct callers that want retained evidence set the same environment value before
calling `tests/run.ps1`; otherwise the suite keeps scratch work in `$TestDrive`.

The container is the minimum isolation boundary. Topology below its artifact root remains suite-owned:
fixture, capability, output, audit, or evidence subdirectories may be introduced when they express real
domain structure. Phase 5 does not manufacture a directory per `It`, parameter row, or tag. A suite is
responsible for preventing collisions among its own writes below the container root.

The BEX-504 LaTeX integration pilot is the first concrete realization: it uses `$TestDrive` when the
environment value is absent and six meaningful case roots directly below an absolute
`CODEX_TEST_ARTIFACT_ROOT` when supplied. That case layout belongs to the suite and is evidence for this
pilot, not a required repository-wide hierarchy.

The HDBSCAN CLI suite is a second concrete layout: retained input/output and process evidence stay below
`CODEX_TEST_ARTIFACT_ROOT/hdbscan-cli`. It does not share a retained path with LaTeX; both layouts remain
owned by their independently addressed Pester containers.

Read-only shared inputs are allowed when they are immutable for the duration of the run. Fixed mutable
services, ports, build outputs, package caches, source trees, and repository artifact roots are not safe
write boundaries. A test specifically exercising a build must redirect all build/intermediate output below
its container root or remain outside the batchable set.

### Capabilities and cost

- A capability is a named immutable fixture or external executable/toolchain required by the container.
  Probe it before dependent setup or assertions run.
- Absence produces a deterministic Pester skip with a useful reason, not `CommandNotFound`, an opportunistic
  restore/build/download, or an unrelated assertion failure. Available capability execution must still obey
  the container write boundary.
- If only part of a file needs the capability, split at that capability seam when gating the whole file would
  hide otherwise portable tests. Pure contract checks should not disappear with an integration toolchain.
- Expensive setup, repeated child launches, large immutable scans, and process pressure are recorded during
  review. Split only when fixture, resource, capability, or cost evidence identifies a real seam; do not
  split mechanically by `It` count or file size.

### Outcomes and failure containment

- Sequential and batch invocation use the same exact path, filters, Pester manifest behavior, and native
  result format. Skips remain skips; failed assertions or setup produce a nonzero process/job result; zero
  selected tests is an error.
- The suite does not call `exit` to reinterpret Pester status, suppress native result creation, or turn a
  failed assertion into success.
- A helper that invokes a native program captures stdout, stderr, and status locally. When nonzero status is
  an expected assertion input, it resets `$LASTEXITCODE` after capture so native diagnostics or the last
  probed status cannot contaminate the runner/worker protocol.
- Failure and cleanup are local to the container. The batch executor, not the suite, continues siblings and
  retains their independently addressed native results.

### Classification and review checklist

Review a new or changed physical file without scheduler knowledge and record the result in the centralized
inventory or migration record. Do not create per-file manifests or sidecars.

| Review question | Required evidence |
|---|---|
| Does exact-path execution select only this file and require no earlier container? | One fresh-process exact-path run plus source review. |
| Can any selected `It` depend on a prior `It`? | No assertion-produced fixture or ordering edge. |
| Are discovery and setup repeatable and side-effect bounded? | Hooks/top-level code inspected; mutable state restored. |
| Are all processes, runspaces, locks, locations, modules, globals, and environment changes cleaned on every path? | `finally`/hook ownership is visible and bounded. |
| Are ephemeral writes confined to `$TestDrive` or another unique temporary root? | Every scratch address has one container-local owner. |
| Are retained writes confined to `CODEX_TEST_ARTIFACT_ROOT`? | No repository-global/default/fixed destination; intended roots are declared by the job. |
| Are shared inputs read-only and fixed resources absent or isolated? | No mutable service, fixed port, common build output, or package restore race. |
| Are missing capabilities explicit and deterministic? | Named preflight and skip reason; no implicit fallback acquisition. |
| Is unusual setup/runtime/process cost visible? | Inventory evidence and a justified physical-file seam or decision to retain it. |
| Does a local failure remain nonzero while native evidence and sibling jobs survive? | Authoritative runner and executor containment witnesses. |

Classify the file from that evidence:

- `Batchable`: every check passes with no optional external capability.
- `CapabilityGated`: every isolation check passes and a named capability has deterministic availability/skip
  behavior.
- `NeedsRefactor`: setup, ordering, state, writes, capability behavior, failure handling, or file topology
  violates the contract.
- `SerialOnly`: a temporary exceptional file needs unavoidable ordering or a fixed mutable resource and is
  not yet worth refactoring. Record its owner, reason, removal condition, and exclusion from normal batch
  discovery; run it by exact path through `tests/run.ps1`, without adding scheduler locks.

Static discovery names, substring searches, and Pester ASTs may route review but cannot establish any of
these classifications. No classification requires a new executor mode, dependency graph, resource lock, or
per-test scheduler.

## Batchable pytest-container contract

This is the current BEX-601 authoring and review checklist.

| Review question | Required evidence |
|---|---|
| Does an exact `test_*.py` path collect only that file? | One fresh-process exact-file run; no sibling test-module import. |
| Are methods and subtests order-independent? | No fixture or mutation produced only by an earlier outcome. |
| Are global state, mocks, threads, locks, and children bounded? | Context/finally cleanup plus bounded joins and descendant termination. |
| Are committed fixtures read-only? | Missing inputs fail; regeneration has a separate explicit utility. |
| Are temporary writes container-local? | Runner-supplied `temp/`; no repository cache, bytecode, or shared engine scratch. |
| Are retained writes explicitly owned? | Only beneath `CODEX_TEST_ARTIFACT_ROOT`, with the root declared by the job. |
| Are optional executables deterministic capabilities? | Exact preflight and reasoned pytest skip; no ambient build/install fallback. |
| Do direct and nested outcomes agree? | Same method collection and selected/pass/fail/error/skip outcome counts, JUnit, observation, and nonzero failure status. |
| Does one failed file preserve siblings? | Executor evidence retains every sibling JUnit/artifact result and no descendant process. |

Use the same four classification names as Pester. Framework syntax changes the evidence mechanism, not the
meaning of `Batchable`, `CapabilityGated`, `NeedsRefactor`, or `SerialOnly`.

## Module groups

| Directory | Current ownership |
|---|---|
| `adapters/` | Pester, pytest, and LaTeX batch planning, addressing, and isolated execution. |
| `audits/` | Repository and deliverable audits, including mathematical rendering |
| `hdbscan/` | HDBSCAN executable and evaluator contracts |
| `infrastructure/` | Repository-wide topology and structural checks |
| `latex-ingest/` | LaTeX ingestion, stores, patches, and rendering integration |
| `math-register/` | Mathematical register normalization |
| `md-postprocess/` | Markdown hygiene and bundle construction |
| `procurement/` | Scholarly discovery and acquisition adapters |
| `reader-mcp/` | Portable deliverable reader MCP |
| `shared/` | Substrate-level primitives such as masks, JSONL, anchors, and sentinels |
| `toc-engine/` | Deliverable TOC and manifest rendering |

## Conventions

- One `*.Tests.ps1` or `test_*.py` file per concern, inside the directory of its current owner.
- In Pester, dot-source the module under test in a top-level `BeforeAll` when practical.
- In Python, import the installed package name; do not create a second source-tree import identity or import
  helpers from another test container.
- From a module test directory, the repository root is `../..` relative to
  `$PSScriptRoot`; shared fixtures are under `../fixtures`.
- Reproduced bugs and calibration decisions should be named regressions rather
  than unexplained snapshots.
- Tests that move with an evicted product shell are not automatically endorsed
  as future contracts. Primitive assertions may be extracted later on merit.
