---
provider: codex
format: Structural
exported_at: 2026-08-05T08:54:44.0024079Z
thread_id: 019fcbd6-1baa-70b3-9629-b828ba6492c5
exchanges: 15
user_label: Aipithicus
models:
  - gpt-5.6-sol
exclude:
  - thinking
  - commentary
  - tool-calls
  - tool-results
  - subagents
  - synthetic
  - timestamps
  - session-markers
  - exchange-markers
---

# speaking of operational primitives in this project, I think i want to adapt a general purpose powershell runspace manager for running batch jobs of things like processing multiple source documents in parallel and running different unit tests in parallel. the runtime discipline and hygiene is still coming together but by design the level of parallelism should preclude collisions between workers. i know i wrote some 'batch' code before, and i also have a somewhat specialized runspace manager in reposnapshot that is for ingesting multiple documents in parallel, but with a more application specific "processor chain" architecture suited to reposnapshot and not codex-scientiae. however, i think reposnapshots runspace manager aka the `colonel` provides a good blueprint for such a thing in this project. the old "batch" code from codex-scientiae is now in the graveyard `D:\aghado01\codex-scientiae-graveyard\src\batch` and the reposnapshot runspace manager is here: `D:\aghado01\utils\reposnapshot\reposnapshot-v3\rs.core.colonel.v2.psm1`

Yes—there is a solid general-purpose primitive here, but I would extract the scheduler from `colonel`, not port `colonel` wholesale.

The public abstraction should be a batch executor; runspaces are an implementation detail:

```text
domain planner → generic batch scheduler → worker adapter
```

- The domain planner discovers, validates, skips, prioritizes, and assigns collision-free job IDs/paths.
- The scheduler owns worker budgeting, greedy dispatch, timeouts, teardown, and structured results.
- The worker adapter decides whether work runs directly in a runspace or in an isolated child `pwsh`.

What to retain:

- From [`colonel`](D:/aghado01/utils/reposnapshot/reposnapshot-v3/rs.core.colonel.v2.psm1:333): pure worker-budget calculation, explicit initial session state, index-stable results, timing/error envelopes, and disciplined cleanup.
- From the [old batch runner](D:/aghado01/codex-scientiae-graveyard/src/batch/ingest-batch.ps1:199): domain-owned planning, longest-first ordering, one-time warmup, per-job logs, and child-process isolation.
- From neither: processor manifests, processor-chain compilation, `_ChainHalt`, or the stateful `RunspaceManager` class. Those belong to RepoSnapshot.

The largest correction to `colonel` is scheduling. It statically divides items round-robin into worker slices at [line 444](D:/aghado01/utils/reposnapshot/reposnapshot-v3/rs.core.colonel.v2.psm1:444). A slow item therefore holds up everything behind it in that slice. The generic engine should submit one invocation per job to a shared runspace pool; the pool then greedily gives the next pending job to whichever runspace becomes free. Submission order can be longest-estimated-first while results remain indexed to the original plan.

I would make every result a structured record resembling:

```powershell
@{
    Id         = 'unique-domain-job-id'
    Index      = 3
    State      = 'Succeeded' # Failed, TimedOut, Cancelled
    Output     = $result
    Errors     = @()
    Warnings   = @()
    StartedUtc = ...
    EndedUtc   = ...
    DurationMs = ...
    LogPath    = ...
}
```

For both initial consumers, child processes remain the correct execution boundary:

- Document ingestion already requires heap/cache/crash isolation, as encoded by the child `pwsh` call in the [graveyard worker dispatch](D:/aghado01/codex-scientiae-graveyard/src/batch/ingest-batch.ps1:233).
- Test suites should not share a PowerShell process. The current runner explicitly calls `exit` at [tests/run.ps1](D:/aghado01/codex-scientiae/tests/run.ps1:54), while suites use script state, module loading, location changes, and Pester process-wide machinery.

Thus the runspace pool initially supervises independent child processes. A direct in-runspace backend can be added for small, demonstrably pure operations.

I would place the primitive at `src/core/batch.ps1`, consistent with the project’s existing [core-placement decision](D:/aghado01/codex-scientiae/issues/reboot/src-reorg/reorg-plan.md:13), with:

- `Resolve-BatchWorkerBudget`
- `Invoke-RunspaceBatch`
- internal session-state and lifecycle helpers
- `tests/core/batch.Tests.ps1`

Then keep `Invoke-IngestBatch` and a future `Invoke-TestBatch` as thin domain adapters. They must own unique work/log paths because process isolation alone does not prevent filesystem collisions.

One other boundary: the long-lived arXiv background queue at [src/procurement/arxiv.ps1](D:/aghado01/codex-scientiae/src/procurement/arxiv.ps1:663) is service infrastructure, not a finite batch. I would not force it through this primitive.

No files were changed during this pass.

---

# agreed on the greedy mechanics and separating arvix from this. i have different plans for an async engine that will serve the procurement provider MCPs separately. i think this executor should expose both subprocess executions under runspaces and direct in-runspace execution of scripts, which can borrow some of the runspace initialization  mechanisms from colonel. this new `batch-executor` can live under `shared` for now. lets give it a shot

Implemented the new shared batch executor:

- [batch-executor.ps1](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:413)
- [batch-executor.Tests.ps1](D:/aghado01/codex-scientiae/tests/shared/batch-executor.Tests.ps1:1)

It provides:

- Greedy, one-invocation-per-item runspace scheduling.
- `Runspace` and isolated child-`pwsh` execution modes.
- Uniform `param($Item, $Context, $RunspaceState)` worker contract.
- Bare/Core/Full initial session states and module preloading.
- Once-per-runspace initialization.
- CLIXML transport across subprocess boundaries.
- Stable result ordering and structured per-item diagnostics.
- Cooperative batch timeout and process-tree-killing subprocess timeout.
- Explicit worker budgets without CPU-clamping user-specified I/O workloads.
- Duplicate job-ID rejection.

Verification: all 97 shared-primitives tests pass under Pester 6, including 13 new executor tests. Both new files parse cleanly and pass whitespace checks. Existing unrelated worktree changes were untouched.

---

# and this runspace manager exposes some control over headless/background types of subprocesses? also, what about cancellations?

Headless execution exists, but it is currently policy rather than a rich control surface.

Process mode always launches child `pwsh` with:

- `UseShellExecute = false`
- `CreateNoWindow = true`
- redirected stdin/stdout/stderr
- `-NoLogo -NoProfile -NonInteractive`

See [batch-executor.ps1](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:107). Callers can override the PowerShell executable and working directory, but not yet environment variables, priority, profile loading, window visibility, or stream capture policy.

It is supervised background work, not detached work: `Invoke-BatchExecutor` blocks until every child completes. I would keep detached/fire-and-forget processes out of this executor because they break its completion, result, and cleanup contract.

Cancellation is not yet complete:

- `ProcessTimeoutSeconds` robustly kills the child process tree.
- `WaitTimeoutSeconds` stops direct runspace pipelines cooperatively.
- There is no caller-provided cancellation token, explicit cancel operation, fail-fast cancellation, or reliable Ctrl+C propagation.
- Stopping the outer process-dispatch runspace does not presently guarantee that its child process is killed unless `ProcessTimeoutSeconds` is also configured.

The next addition should be:

```powershell
-CancellationToken [System.Threading.CancellationToken]
```

with these semantics:

- Queued items never start after cancellation.
- Direct workers receive the token as an optional fourth argument and can cooperate.
- Running direct pipelines also receive `PowerShell.Stop()` as a fallback.
- Each child process registers a token callback that calls `Kill($true)`.
- Results use a distinct `Cancelled` state, separate from `TimedOut` and `Failed`.
- `Summary` gains `Cancelled`.
- Cleanup completes before `Invoke-BatchExecutor` returns.

For subprocess controls, I’d add environment overrides and perhaps `Headless` versus `InheritedConsole`, while retaining headless as the default. Cancellation should come before building the ingestion and test adapters.

---

# well i dont want one failed job to break a batch, i want the executor to handle gracefully and capture diagnostics. the WIP logger if deployed within a batched process run, will also be helpful when one worker fails. lets harden the implementation details for cancellation and policy-setting / child process specifications. do we need to implement async mechanics here or is that already baked in? can't the parent process be designed to kill its child process rather than dying itself and waiting for children to time out? lets harden what we can here. also, threadsafety needs to be checked at this juncture

Hardened the executor around failure isolation, cancellation, child-process policy, and thread safety.

Key behavior in [batch-executor.ps1](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:494):

- Item failures always use `FailureAction = Continue`. They become `Failed` result records and never cancel siblings.
- Child diagnostics capture exit code, structured errors/warnings, raw stdout/stderr, timing, PID, thread, and runspace identity.
- `CODEX_BATCH_JOB_ID` is injected into child environments for logger correlation.
- The logger integration test confirms a failed worker can persist its own trace while siblings complete successfully.

Cancellation now accepts a caller-owned `CancellationToken`:

- Running children enter a concurrent live-process registry immediately after launch.
- The parent kills each registered process tree with `Kill($true)` on cancellation or timeout.
- Queued children observe cancellation and never start.
- Exceptional teardown and Ctrl+C unwinding use the same cleanup path.
- Direct workers receive the token as their fourth argument for cooperative cancellation, followed by `PowerShell.Stop()` when necessary.
- Results distinguish `Cancelled`, `TimedOut`, and `Failed`.

Child-process policy now exposes:

- PowerShell executable and working directory
- Environment overlay
- Profile loading
- `CreateNoWindow`
- Window style
- Process priority
- Per-child timeout
- Total batch timeout

Environment values are not echoed in the returned policy—only variable names.

Thread-safety discipline is now explicit:

- Process payloads are serialized on the parent thread before dispatch.
- Process launch environment is snapshotted before workers read it.
- Live processes use `ConcurrentDictionary`.
- Ordered results and infrastructure diagnostics are written only by the parent.
- Initialization state remains local to each runspace.
- Direct mode defaults to `SharedReadOnly`; callers can select `PerItemCopy` for isolated CLIXML copies of items and context.

Async mechanics were already baked in: each item uses `BeginInvoke`, and child stdout/stderr use asynchronous reads. The public command remains a synchronous finite-batch join, which preserves straightforward result and cleanup semantics without creating a competing async engine.

Verification:

- 18 focused executor tests pass.
- 120-job concurrent pressure test preserves every index exactly once.
- Concurrent cancellation kills running children and prevents queued children from starting.
- Complete shared suite: 111 tests passed, 0 failed.

---

# also, we do need test and ingestion adapters, or do we want a runspace manager that can run a queue of jobs over the runspaces and execute a caller provided script or entrypoint to a process, ensuring dependencies are available and enabling caller to run potentially arbitrary lists of jobs in parallel (e.g. a bunch of tests, a bunch of documents with latex-ingest, etc)

We want both, in layers.

The executor should become a general queue engine, while test and ingestion adapters should only produce validated job descriptions. They should not each reinvent scheduling.

The current executor is close, but still batch-homogeneous:

- One `ScriptPath`
- One execution mode
- One initialization/dependency profile
- One child-process policy

Items may contain arbitrary data, but they cannot yet select different entrypoints or runtime profiles directly.

The next core refinement should introduce first-class jobs:

```powershell
@{
    Id            = 'latex-BWD1996'
    Kind          = 'PowerShellProcess' # RunspaceScript | PowerShellProcess | NativeProcess
    EntryPoint    = 'src/latex-ingest/worker.ps1'
    Arguments     = @{ ... }
    Input         = $descriptor
    RuntimeProfile = 'latex'
    ProcessSpec   = @{ ... }
    EstimatedCost = 28.4
    Writes        = @('artifacts/latex-ingest/runs/...')
    Metadata      = @{ Domain = 'ingestion' }
}
```

Then the surface becomes approximately:

```powershell
$plan = Compile-BatchPlan -Job $jobs
$result = Invoke-BatchPlan -Plan $plan -MaxWorkers 6
```

`Compile-BatchPlan` should:

- Validate unique IDs and entrypoints.
- Resolve paths and freeze arguments/environment.
- Validate declared output paths do not collide.
- Order costly jobs first.
- Resolve dependencies before any work starts.
- Partition jobs by compatible runtime profile.
- Reject unsupported profile mixtures rather than silently importing a dependency superset.

That last point matters: direct runspace jobs share their pool’s `InitialSessionState`, so their modules and initialization belong to a runtime profile. Child-process jobs can safely carry per-job dependencies because each gets a clean process.

The adapters then become planners:

- `Get-TestBatchJobs` discovers suites, locates Pester, chooses suite granularity, constructs child-process jobs, and assigns log/result paths.
- `Get-IngestBatchJobs` resolves documents, sniffs source validity, applies skip/force policy, performs shared toolchain warmup, estimates cost, and assigns collision-free artifact paths.
- Optional `Invoke-TestBatch` and `Invoke-IngestBatch` convenience commands simply produce jobs, compile, and invoke.

Jobs from both adapters could be combined into one queue if desired.

Internally, async scheduling is already present through `BeginInvoke`; no new detached-job system is needed. The queue call remains a blocking join with cancellation and complete results.

I would evolve the current executor into this job/plan model before writing the adapters, then implement the two adapters as thin domain layers.

---

# ok lets evolve the job/plan model then

Implemented the evolved job/plan model.

Key surfaces:

- [`New-BatchJob`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:1011) describes either `RunspaceScript` or `PowerShellProcess` work.
- [`Compile-BatchPlan`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:1105) normalizes jobs and rejects:
  - duplicate IDs
  - missing or invalid entrypoints/modules
  - malformed subprocess policies
  - incompatible direct-runspace profiles
  - exact or ancestor/descendant write-set collisions
- [`Invoke-BatchPlan`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:1377) executes heterogeneous jobs through one global greedy worker budget.
- [`batch-job-worker.ps1`](D:/aghado01/codex-scientiae/src/shared/batch-job-worker.ps1:1) is the generic entrypoint adapter for named or positional arguments, initialization scripts, modules, and working directories.

Behavior now includes:

- Expensive jobs dispatch first; results return in original plan order.
- One failure remains local and never breaks siblings.
- Per-job process environment, timeout, executable, working directory, window behavior, profile loading, and priority are supported.
- Cancellation stops direct pipelines immediately and has the parent kill registered child process trees.
- Parallelism remains internally asynchronous through `BeginInvoke`; `Invoke-BatchPlan` is intentionally a finite synchronous join.
- Direct jobs share one declared runtime profile per pool. Process jobs carry isolated process specifications and job-local dependencies.
- Direct shared data remains explicitly `SharedReadOnly`, with `PerItemCopy` available when isolation is required.

Adapters can now remain very thin: test discovery or ingestion discovery simply emits `New-BatchJob` records, including declared outputs and estimated cost.

Verification:

- Batch-plan tests: 8 passed.
- Original executor tests: 18 passed.
- Complete shared suite: 119 passed, 0 failed.
- All touched scripts parse cleanly with no trailing whitespace.

The implementation and tests are currently untracked and uncommitted. The executor file is now fairly substantial; before adding many adapters, physically splitting the kernel and plan compiler into module-private files would be a sensible organizational follow-up.

---

# ok lets commit these changes if not done already in some other blanket commit, then lets scope split/reorg before we move on

The batch executor was already committed in blanket commit `080bac6` (`doccer planning docs`). All four files are clean and tracked on `main`, so I did not create a duplicate commit. Unrelated worktree changes remain untouched.

## Recommended reorganization

The current [`batch-executor.ps1`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1) is 1,457 lines:

- Embedded runspace/process transport: ~356 lines
- `Invoke-BatchExecutor`: 489 lines
- Plan compiler: 271 lines
- Remaining public and private helpers: ~340 lines

I recommend one PowerShell module with two internal layers—plan and execution—not separate modules.

```text
src/shared/
├── batch-executor.ps1                 # compatibility loader
└── batch-executor/
    ├── batch-executor.psd1
    ├── batch-executor.psm1            # deterministic loader/export list
    ├── README.md
    ├── public/
    │   ├── New-BatchJob.ps1
    │   ├── Compile-BatchPlan.ps1
    │   ├── Invoke-BatchPlan.ps1
    │   └── Invoke-BatchExecutor.ps1
    ├── private/
    │   ├── transport.ps1              # dispatcher and child-command bodies
    │   ├── script-definition.ps1
    │   ├── session-state.ps1
    │   ├── process-lifecycle.ps1
    │   ├── worker-budget.ps1
    │   ├── property-access.ps1
    │   └── plan-resolution.ps1
    └── workers/
        └── batch-job-worker.ps1
```

Only these functions should be exported:

- `New-BatchJob`
- `Compile-BatchPlan`
- `Invoke-BatchPlan`
- `Invoke-BatchExecutor`

The remaining helpers become genuinely module-private. That removes the current dot-sourcing behavior where all eleven functions leak into the caller’s session.

## Migration scope

I would make the first reorganization mechanically, without changing behavior:

1. Add the module manifest and deterministic loader.
2. Move existing function bodies unchanged into the corresponding files.
3. Give the module a stable internal worker path instead of relying on ambient `$PSScriptRoot`.
4. Turn the existing `src/shared/batch-executor.ps1` into a compatibility loader.
5. Change the two test files to import the manifest.
6. Add module-surface tests proving:
   - the four public commands are exported;
   - private helpers are not visible;
   - the compatibility loader still works.
7. Run the 26 focused batch tests and the complete shared suite.

I would defer decomposing the 489-line `Invoke-BatchExecutor` itself. Its lifecycle ordering—register child, kill tree, drain supervisor, stop runspace, collect diagnostics, dispose pool—is safety-sensitive. Physical encapsulation should land first; extracting dispatch/wait/collection phases can be a separate, reviewable refactor.

Likewise, this reorganization should not yet add test or ingestion adapters, retries, detached execution, typed process-spec constructors, or a dependency DAG. Those are semantic additions rather than organization work.

---

# ok i've created an issues folder for `batch-executor` and just appended a review of this plan with some valid points in `D:\aghado01\codex-scientiae\issues\batch-executor\discussions\sol-batch-executor-module-proposal-20260804.md` to you're above proposal, see opus review starting on line 64

The Opus review is valid. I’d adopt all five points, with one refinement around transport placement and one practical qualification around Ctrl+C testing.

## Reconciled decisions

| Review point | Disposition | Amendment |
|---|---|---|
| Transport is not ordinary private code | Agree | Use `payloads/`, not `private/` or generic `workers/`. Payload files are read as text and never dot-sourced. |
| Budget tests conflict with private export | Agree | Keep `Resolve-BatchWorkerBudget` private and test it with `InModuleScope`. Callers control inputs and receive the resolved budget in execution results. |
| `Compile` is unapproved | Agree | Canonical API becomes `New-BatchPlan`; the compatibility loader supplies `Compile-BatchPlan` as a transitional alias. |
| Teardown tests must precede movement | Agree | Add adversarial lifecycle tests before moving source files. |
| Deferred work needs planning canon | Agree | Mint `decisions.md`, `roadmap.md`, and `ledger.md`; make the source README a capability/contract document. |

The review’s `$PSScriptRoot` correction is also exactly right: the module root must be captured once in `batch-executor.psm1`, with stable payload paths stored in module-scoped variables.

## Revised source layout

```text
src/shared/
├── batch-executor.ps1                 # transitional compatibility loader
└── batch-executor/
    ├── batch-executor.psd1
    ├── batch-executor.psm1
    ├── README.md                      # capability and contract surface
    ├── public/
    │   ├── New-BatchJob.ps1
    │   ├── New-BatchPlan.ps1
    │   ├── Invoke-BatchPlan.ps1
    │   └── Invoke-BatchExecutor.ps1
    ├── private/
    │   ├── script-definition.ps1
    │   ├── session-state.ps1
    │   ├── process-lifecycle.ps1
    │   ├── worker-budget.ps1
    │   ├── property-access.ps1
    │   └── plan-resolution.ps1
    └── payloads/
        ├── direct-dispatcher.payload.ps1
        ├── process-dispatcher.payload.ps1
        ├── child-bootstrap.payload.ps1
        └── batch-job-worker.ps1
```

The module loader will explicitly read the dispatcher/bootstrap payloads using `ReadAllText`. It will not enumerate and dot-source directories dynamically. The directory boundary therefore enforces the execution-context distinction.

Canonical exports become:

- `New-BatchJob`
- `New-BatchPlan`
- `Invoke-BatchPlan`
- `Invoke-BatchExecutor`

## Revised execution order

1. Planning canon

   Create:

   - `issues/batch-executor/planning/decisions.md`
   - `issues/batch-executor/planning/roadmap.md`
   - `issues/batch-executor/planning/ledger.md`

   The decisions must explicitly retire the Colonel/Gauntlet two-tier framing: there is one greedy scheduler, one shared budget, and a per-job execution mode.

2. Teardown safety net

   Before moving implementation code, add tests for:

   - cancellation killing the child and its descendants;
   - total batch timeout killing the process tree;
   - per-child timeout killing the process tree;
   - stopping the hosting PowerShell pipeline while work is live, proving `finally` leaves no descendants;
   - queued processes remaining unstarted after cancellation.

   A hosting-pipeline stop is the deterministic automated equivalent of Ctrl+C unwind. A literal keyboard Ctrl+C test would be host/console-dependent on Windows, so I would keep that as a manual smoke test rather than a flaky Pester gate.

3. Mechanical module extraction

   Move bodies without restructuring the 489-line lifecycle function. Capture the module root once, load files in an explicit order, and read payload source as data.

4. Public-surface migration

   - Tests import the manifest.
   - Budget unit tests use `InModuleScope`.
   - Tests and documentation adopt `New-BatchPlan`.
   - The compatibility loader imports the module and provides the old `Compile-BatchPlan` alias.
   - Add export/private-visibility and compatibility tests.

5. Verification

   Run focused lifecycle tests, all batch tests, module-surface tests, the path-topology suite, and the complete shared suite.

A clean commit sequence would be:

1. `docs(batch-executor): establish architecture canon`
2. `test(batch-executor): lock down process-tree teardown`
3. `refactor(batch-executor): package executor as shared module`

The deeper phase extraction, adapters, retries, detached execution, typed specification constructors, and dependency DAG remain roadmap work rather than part of this reorganization.

---

# ok lets write up the planning canon, commit, implement teardown safety net, commit

Completed both requested commits on `main`:

- `c586cfc` — `docs(batch-executor): establish architecture canon`
- `fed291c` — `fix(batch-executor): guarantee process-tree teardown`

The safety tests uncovered and fixed a real defect: hosting-pipeline stop was blocked by an indefinite CLR wait, delaying teardown until the child naturally exited. The executor now checks at 200 ms intervals, allowing PowerShell stop/Ctrl+C unwind to reach parent-owned cleanup promptly.

Coverage now proves termination of children and descendants under:

- caller cancellation, including queued-launch suppression;
- per-child timeout;
- total-batch timeout;
- hosting-pipeline stop and exceptional unwind.

Verification:

- Executor suite: 20 passed
- Combined batch suites: 28 passed
- Complete shared suite: 121 passed
- Batch-executor scope is clean

The separate topology suite remains red from unrelated renovation drift involving missing retired paths and configuration files; none of its failures involve batch-executor changes.

[`decisions.md`](D:/aghado01/codex-scientiae/issues/batch-executor/planning/decisions.md) · [`roadmap.md`](D:/aghado01/codex-scientiae/issues/batch-executor/planning/roadmap.md) · [`ledger.md`](D:/aghado01/codex-scientiae/issues/batch-executor/planning/ledger.md)

::git-commit{cwd="D:\aghado01\codex-scientiae"}

---

# i thought we had cancellation tokens for the children

We have cancellation tokens, but only inside the parent process:

- Direct runspace jobs receive the caller’s token and can cancel cooperatively in [`batch-executor.ps1`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:63).
- Process-job supervisor runspaces also receive that token and use it to terminate the registered child tree.
- The actual child PowerShell does not receive a functional token. Its bootstrap invokes the worker with only item, context, and state at [`batch-executor.ps1`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:317). Consequently, the fourth parameter in [`batch-job-worker.ps1`](D:/aghado01/codex-scientiae/src/shared/batch-job-worker.ps1:1) is null in process mode.

A .NET `CancellationToken` is in-process state and cannot simply be serialized into another process. Currently process cancellation is preemptive:

```text
caller token → parent/supervisor → Kill(process tree)
```

That is why the host-stop fix mattered: without an interruptible parent wait, the parent never reached the tree-kill path promptly.

The API currently makes this distinction too easy to miss. If we want children to clean up, flush logs, or checkpoint before termination, we need an explicit cooperative IPC path:

```text
parent cancellation
        ↓
persistent named pipe/control channel
        ↓
child-local CancellationTokenSource.Cancel()
        ↓
bounded grace period
        ↓
Kill(process tree) if still alive
```

I’d make this a configurable child policy:

- `ImmediateKill` — current robust default.
- `CooperativeThenKill` — signal the child, allow a short grace period, then forcibly kill the tree.

The forced fallback must remain, because arbitrary scripts and external tools may ignore cancellation. But yes: if by “tokens for the children” you meant tokens usable inside the child worker, that is not currently implemented.

---

# can't we catch parent failures and issue cancellations to children in the exception

Yes. For any catchable parent failure, we can and should initiate cooperative cancellation before forcibly killing children.

The current executor already handles parent unwind in [`finally`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1:977), but it goes directly to process-tree termination. A better two-stage sequence is:

```powershell
$batchCts = [CancellationTokenSource]::CreateLinkedTokenSource($CancellationToken)

try {
    # Pass $batchCts.Token to direct workers and process supervisors.
}
catch {
    $teardownReason = 'parent infrastructure failure'
    throw
}
finally {
    $batchCts.Cancel()                  # direct workers and supervisors
    Send-BatchChildCancellation         # actual child processes via IPC
    Wait-BatchChildGracePeriod
    Stop-BatchExecutorChildProcesses    # kill non-cooperative survivors
    $batchCts.Dispose()
}
```

Important distinctions:

- The executor cannot cancel the caller-owned token; it needs an internal linked `CancellationTokenSource`.
- The cancellation belongs in `finally`, not only `catch`. PowerShell stop/Ctrl+C and some pipeline unwinds may bypass ordinary catch handling while still running `finally`.
- An individual job failure must remain result data and must not cancel the batch. Only caller cancellation, batch timeout, or parent infrastructure unwind activates batch-wide cancellation.
- The actual child process still needs an IPC signal. A `CancellationToken` cannot cross process boundaries by itself.

The simplest cooperative child protocol could reuse redirected stdin:

1. Send the initial payload as a framed message instead of `ReadToEnd()`.
2. Keep stdin open.
3. Parent sends a `CANCEL` control frame on unwind.
4. Child owns a local `CancellationTokenSource` and passes its token to the worker.
5. Parent waits a bounded grace period, then calls `Kill($true)` on survivors.

That would let child scripts run `finally`, flush logs, and checkpoint, while preserving forced tree termination for uncooperative scripts.

One unavoidable limitation remains: a hard parent-process crash or external termination cannot execute `catch` or `finally`. Covering that case requires OS containment—on Windows, typically a Job Object configured with kill-on-close—or child-side parent-death monitoring.

---

# well i guess a timeout fallback is necessary, but what about children checking a pulse? worth anything?

A child-observed pulse is useful, but primarily as orphan/hung-parent protection—not as the normal cancellation mechanism.

I’d model it as a lease over the same persistent control channel:

```text
Parent control channel
├── CANCEL                 explicit cooperative cancellation
├── periodic LEASE renewal proof that controller is healthy
└── EOF                    parent process/channel disappeared

Child cancellation triggers
├── CANCEL received
├── control-channel EOF
├── lease expires
└── child’s own timeout
```

Recommended hierarchy:

1. Explicit `CANCEL` for ordinary cancellation and catchable parent unwind.
2. Channel EOF for immediate parent-death detection.
3. Optional heartbeat lease for a living-but-hung parent.
4. Child-local cancellation token and bounded cleanup grace.
5. Parent kills non-cooperative child trees after the grace period.
6. OS containment, such as Windows Job Object kill-on-close, for catastrophic parent death.

A pulse is more valuable cross-platform or when detecting controller hangs matters. On Windows, a kill-on-close Job Object is stronger protection against hard parent termination; a pulse still helps distinguish “process alive” from “batch controller functioning.”

I would avoid pulse files. A named pipe is better because it supports control frames, has immediate EOF semantics, avoids stale filesystem state, and can carry lease renewals. Use a monotonic deadline rather than wall-clock timestamps—for example, renew every 2 seconds and expire after 15–30 seconds to tolerate scheduling pauses, sleep/resume, debugging, and CPU pressure.

One implementation consequence: the child currently runs its worker synchronously, so nothing inside that process remains available to monitor a pulse. Cooperative cancellation would require the child bootstrap to:

- run the worker asynchronously in an inner runspace;
- keep the bootstrap thread monitoring the control pipe;
- cancel a child-local token when control is lost;
- collect output during the grace period;
- forcibly stop its worker and descendants if cleanup exceeds the deadline.

So yes, the pulse is worthwhile—but I’d first implement persistent control-channel cancellation plus EOF. Add lease expiry as a policy option once we explicitly want hung-parent detection; it should not be mandatory for every batch.

---

# ok lets write a brief on cancellation-related mechanics for later, and only address the minimum necessary at this juncture. i want to wait until after teardown and rebuild is complete

Created the deferred cancellation brief:

[`sol-batch-executor-cancellation-parent-liveness-deferred-20260805.md`](D:/aghado01/codex-scientiae/issues/batch-executor/briefs/sol-batch-executor-cancellation-parent-liveness-deferred-20260805.md)

It records:

- current direct versus process cancellation behavior;
- linked parent cancellation-source design;
- cooperative child IPC and cleanup grace;
- channel EOF and optional heartbeat leases;
- hard parent-death containment;
- mandatory forced-kill fallback;
- reactivation gates after teardown/rebuild;
- future adversarial test requirements.

I made only minimal canon adjustments in [`decisions.md`](D:/aghado01/codex-scientiae/issues/batch-executor/planning/decisions.md) and [`roadmap.md`](D:/aghado01/codex-scientiae/issues/batch-executor/planning/roadmap.md). No runtime or test code changed, and these documentation changes remain uncommitted.

---

# ok please export thread using jso-jackson/codex-export to the batch-export issue discussion folder, then commit all of your changes including the export

---

# not c:\tmp. use codex-scientiae/.codex/chat-export
