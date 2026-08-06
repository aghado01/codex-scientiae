# Batch executor

`batch-executor` is a synchronous finite-batch engine. One greedy runspace pool owns one worker
budget and one queue; each item executes either directly in a pooled runspace or in a child
PowerShell supervised by a pooled runspace. Execution mode does not create a second scheduler.

Import the canonical module through `batch-executor.psd1`. The sibling
`../batch-executor.ps1` file is a transitional dot-source facade for legacy callers and adds only
the `Compile-BatchPlan` alias for `New-BatchPlan`.

## Public commands

| Command | Contract |
|---|---|
| `New-BatchJob` | Creates a domain-neutral job description. |
| `New-BatchPlan` | Resolves and validates every job before work starts; returns `{ Plan, Errors, Warnings }`. |
| `Invoke-BatchPlan` | Runs a valid compiled plan and restores results to original plan order. |
| `Invoke-BatchExecutor` | Lower-level finite-batch execution over an item array and worker script. |

All other functions are private. `Resolve-BatchWorkerBudget` is intentionally not a preview API;
the resolved budget is present in every execution record.

## Companion adapters

The separate [`test-batch`](../../test-batch/README.md) module exports `Get-TestBatchJob`. It discovers
repository Pester files and emits isolated process jobs without changing this module's public surface or
owning execution. Callers compile and invoke those jobs through `New-BatchPlan` and `Invoke-BatchPlan`.

## Job contract

`New-BatchJob` returns a `CodexScientiae.BatchJob` record with these fields:

| Field | Meaning |
|---|---|
| `Id` | Required case-insensitive correlation identity; duplicate plan IDs are rejected. |
| `Kind` | `RunspaceScript` or `PowerShellProcess`. |
| `EntryPoint` | PowerShell script invoked by the generic worker. |
| `ArgumentMode` | Derived as `Named`, `Positional`, or `None`; named and positional arguments are mutually exclusive. |
| `Parameters` / `ArgumentList` | Entrypoint arguments. |
| `RuntimeProfile` | Named direct-runspace profile, default `default`. One plan may use only one direct profile. |
| `ProcessSpec` | Optional per-child overrides described below. |
| `EstimatedCost` | Finite non-negative scheduling hint. Higher cost dispatches first; it does not change result identity. |
| `Writes` | Declared output paths. Exact or ancestor/descendant collisions are rejected unless explicitly accepted. |
| `ModulePath` | Job-local module dependencies. |
| `InitializationScriptPath` | Optional job initializer. |
| `WorkingDirectory` | Job working directory, resolved during plan construction. |
| `Metadata` | Domain-owned metadata carried with the normalized job. |

Adapters may discover domain work and populate these records. They do not own pools, child
registries, cancellation, retries, or result ordering.

## Plan contract

`New-BatchPlan` validates paths and PowerShell syntax, module availability, argument shape,
runtime-profile compatibility, child policy, unique IDs, and declared write sets before any
worker starts. Invalid input produces `Plan = $null` and accumulated errors; execution never
starts with a partially valid queue.

The optional runspace profile contains `Name`, `IssPreset` (`Bare`, `Core`, or `Full`),
`ModulePath`, `InitializationScriptPath`, and `Context`. A valid `CodexScientiae.BatchPlan`
contains jobs in caller order and a separate cost-descending dispatch order. `Invoke-BatchPlan`
returns results in caller order and records the actual queue position as `DispatchIndex`.

The generic job worker accepts:

```powershell
param($Item, $Context, $RunspaceState, $CancellationToken)
```

It imports job dependencies, runs the optional job initializer, changes to the declared working
directory, and invokes the entrypoint with named, positional, or no arguments.

## Execution and result contract

`Invoke-BatchExecutor` queues one asynchronous pipeline per item into one runspace pool and then
joins the finite batch synchronously. Item failure is result data and does not abort siblings.
Infrastructure failures are reported at batch level without erasing collected item results.

Each result contains `Id`, `Index`, `Input`, `State`, `Output`, `Errors`, `Warnings`,
`Information`, queue/start/end timing, duration, runspace/thread/process identity, exit code, and
captured child stdout/stderr. Terminal states are:

| State | Meaning |
|---|---|
| `Succeeded` | Worker completed without item errors. |
| `Failed` | Worker, child, or result collection reported an item failure. |
| `TimedOut` | Per-child or total-batch timeout terminated the item. |
| `Cancelled` | Caller cancellation or hosting-pipeline unwind stopped the item. |

The execution record also contains batch `Errors`, budget warnings, resolved `Budget`, effective
`Policy`, phase `Timing`, and a state-count `Summary`. `Timing.DispatchMs` measures pipeline construction
and submission only. Pre-dispatch validation and serialization remain included in `Timing.TotalMs`; Phase
3 does not add a separate preparation timing field.

## Internal lifecycle boundary

Lifecycle decomposition is private and does not change that public projection. Preparation produces
ordered, dispatch-ready item records and contains no pool, pipeline, async handle, live process, process
registry, result array, or infrastructure-error collection. One mutable lifecycle record owns all such
execution resources under the exported function's single outer `try/finally`.

The internal phase path is prepare, dispatch, await/cancel, collect, and teardown. Execution mode remains
item data inside those phases; it does not create another queue or resource owner. Runtime payloads borrow
only the child-process registry. Private records and handles never appear in the returned execution
record, and the completed decomposition preserves public names including `Input` and `Timing.WaitMs`. Dispatch
publishes a newly constructed pool from inside its construction helper before configuration/open, keeps the
pipeline currently being bound or submitted in an owner-visible pending slot, and registers each successful
`BeginInvoke` immediately. A failed dispatch-side disposal retains the pending slot and blocks `Dispatched`,
so exceptional unwind can always reach every acquired handle.

Await/cancel consumes only the preparation's frozen token, total timeout, 200 ms host-interruption slice,
and process-drain allowance. Both the main wait and batch-wide process drain use the interruption slice.
The phase records one typed wait outcome before collection begins and retains the parent-owned child-tree
and batched pipeline-stop order.

Collection materializes invocation envelopes into the original index slots, merges pipeline and worker
diagnostics, preserves the caller's original `Input` reference, and verifies that every result slot is
filled before entering `Collected`. It does not dispose execution resources; teardown remains the owner.

The exported function retains the sole lexical `try/finally`. Its teardown operation kills child trees,
stops supervisors, clears disposed pipeline handles, then closes and clears the shared pool before entering
`Closed`. Only a closed nonempty lifecycle can be projected into the public execution record; the empty
preparation fast path remains execution-resource-free.
Failed handle disposal is recorded and the handle remains owner-visible; such a lifecycle cannot claim
`Closed` or be projected as a successful execution record.

## Cancellation and ownership

The caller may provide a `CancellationToken`; `WaitTimeoutSeconds` bounds the whole join and
`ProcessTimeoutSeconds` supplies a default per-child limit. Direct-runspace cancellation is
cooperative until the parent stops the supervising pipeline. Child-process cancellation is
preemptive at the process-tree boundary.

The parent registers every live child immediately after start. Token cancellation, per-child
timeout, total-batch timeout, hosting-pipeline stop, and exceptional teardown kill registered
process trees before supervising pipelines and the pool are disposed. The current child process
does not receive an operative cross-process cancellation token.

## Data isolation

Direct jobs in one pool share one `InitialSessionState`. `SharedReadOnly` passes caller objects by
reference and requires callers not to mutate item, context, or nested values concurrently.
`PerItemCopy` creates CLIXML snapshots of item and context before dispatch, trading type fidelity
and serialization cost for isolation. Process jobs always cross a CLIXML boundary. Parent-side
normalization, environment copying, process-spec resolution, direct-copy materialization, and process
payload serialization all finish before the pool opens and before the first `BeginInvoke`. Dispatch does
not traverse caller-owned object graphs.

## Child-process and logging policy

A process specification may override `PowerShellPath`, `WorkingDirectory`, `TimeoutSeconds`,
`CreateNoWindow`, `WindowStyle`, `LoadProfile`, `PriorityClass`, and `Environment`. Job overrides
are resolved over invocation defaults. Environment entries with `$null` values remove inherited
variables in the child.

Every child receives `CODEX_BATCH_JOB_ID` and `CODEX_BATCH_EXECUTION_MODE=Process`. Existing
`CODEX_RUNLOG_*` variables are inherited unless overridden, allowing child-local logs to correlate
with the parent run without sharing file handles.

## Non-goals

This module does not provide retries or backoff, detached or durable background work, persistent
queues or resume, dependency-DAG scheduling, multiple competing schedulers, native non-PowerShell
child entrypoints, domain discovery, or a public worker-budget preview. Cooperative process-child
cancellation, parent-liveness leases, and hard-parent-death containment remain deferred designs.
