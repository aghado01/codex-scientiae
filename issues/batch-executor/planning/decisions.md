# Batch executor — architecture decisions

Living architecture canon for the shared finite-batch executor and its job/plan model. Correct this
document when the current design changes. Preserve a superseded decision by naming its replacement rather
than leaving two apparently active rules.

The originating design evidence is the
[independent module proposal](../discussions/opus-batch-executor-independent-proposal-20260804.md) and the
[module proposal with review](../discussions/sol-batch-executor-module-proposal-20260804.md). Work still
ahead lives in [roadmap.md](roadmap.md); completed roadmap-grain work moves to
[ledger.md](ledger.md). The `src/shared/batch-executor/README.md` is the runtime capability and
contract surface and must agree with this canon.

Status vocabulary: **implemented** describes the current tested substrate; **accepted** is a binding
architecture decision not yet fully realized; **provisional** is deliberately open to evidence before
callers depend on it.

## Scheduler and execution model

### D1 — One greedy scheduler owns one shared worker budget — implemented

The old two-tier Colonel/Gauntlet framing is retired. There is not one runspace scheduler and a second
process scheduler. One finite queue is submitted to one runspace pool, and each job selects `Runspace` or
`Process` execution. Mixed jobs compete within the same global worker budget; the next free pooled
runspace supervises the next queued job. File boundaries must never recreate mode-specific schedulers or
duplicate worker-budget policy.

### D2 — Scheduling cuts follow lifecycle phase, not execution mode — accepted

Internal decomposition follows prepare/validate, dispatch, await/cancel, collect, and teardown. Execution
mode remains data consumed by those phases. Runspace-specific and process-specific launch mechanics may
be private helpers or runtime payloads, but they do not own queues, result ordering, or separate budgets.

### D3 — Internal asynchrony serves a finite synchronous join — implemented

`BeginInvoke` queues all item pipelines asynchronously and the pool schedules them greedily.
`Invoke-BatchExecutor` and `Invoke-BatchPlan` remain synchronous finite-batch joins. The executor does not
create detached jobs, a durable background registry, or a second asynchronous-engine contract. A separate
procurement-provider async engine may exist, but it is not this component.

### D4 — Cost affects dispatch order; caller order defines result identity — implemented

Compiled plans dispatch higher estimated-cost jobs first to reduce long-tail idle time. Returned results
are restored to original plan order and carry their dispatch index separately. Cost is a scheduling hint,
not identity, priority authorization, or a promise of duration.

## Failure, cancellation, and process ownership

### D5 — Item failure is result data and never aborts siblings — implemented

The executor continues after worker exceptions, nonzero child exits, diagnostic-stream errors, and
per-child timeouts. Each item receives a structured terminal state, output, diagnostics, timing, execution
identity, and child stdout/stderr where applicable. Infrastructure errors remain batch-level diagnostics;
they do not erase item results already obtained.

### D6 — The parent owns every child process tree — implemented

Live child processes are registered in a parent-owned concurrent registry immediately after start. Caller
cancellation, total-batch timeout, per-child timeout, hosting-pipeline unwind, and exceptional teardown
terminate the child process tree rather than terminating the parent and waiting for descendants to time
out. Dispatchers remove and dispose their own process records; parent teardown kills registered trees
before supervising pipelines and the pool are stopped. Each dispatcher is also the final owner of any
process it started: its `finally` block kills a still-live tree before removing and disposing the process
record. This closes both sides of the start/registration race when parent teardown cannot observe the
child or has already swept the registry. Child waits use short interpreter checkpoints so a supervising
pipeline stop can reach dispatcher-owned `finally` teardown promptly. Parent teardown submits stop
requests to all unfinished supervising pipelines before awaiting any one stop, so queued work cannot run
in serial waves during unwind.

Direct runspace cancellation is cooperative until the parent stops the pipeline. Process cancellation is
preemptive at the process-tree boundary: the actual child currently receives no operative cross-process
cancellation token. A short diagnostic-drain allowance applies only to process supervisors after their
child trees have been killed. Cooperative child cancellation and parent-liveness mechanics are deferred in
the [cancellation brief](../briefs/sol-batch-executor-cancellation-parent-liveness-deferred-20260805.md).

### D7 — Teardown behavior is an architectural gate, not incidental cleanup — implemented

Before lifecycle code moves between files, adversarial tests must prove zero surviving child or grandchild
processes after token cancellation, total-batch timeout, per-child timeout, and hosting-pipeline stop/unwind.
The automated hosting-pipeline-stop test is the deterministic Ctrl+C-equivalent gate; literal console
Ctrl+C remains a manual Windows smoke test unless a stable console-control harness is established.

## Job, plan, and data contracts

### D8 — Domain adapters discover work; the shared plan validates execution — implemented

Test and ingestion adapters enumerate domain work and emit domain-neutral job records. They do not own
runspace pools, process registries, cancellation, retries, or result ordering. The shared plan validates
correlation IDs, entrypoints, declared dependencies, runtime-profile compatibility, process policy,
working directories, and declared write sets before any worker starts.

### D9 — Direct jobs share one runspace profile per pool — implemented

One `InitialSessionState` defines a runspace pool. Direct jobs in one plan therefore share one named
runtime profile, ISS preset, module preload set, and per-runspace initializer. Plans requesting multiple
direct profiles are rejected rather than silently unioning dependencies. Process jobs carry job-local
dependencies and per-job process specifications.

### D10 — Shared direct data is read-only by contract unless copied — implemented

`SharedReadOnly` is the direct-runspace default: caller items, context, and nested values must not be
mutated concurrently. `PerItemCopy` uses CLIXML snapshots when isolation is more important than type
fidelity and serialization cost. Process jobs always cross a CLIXML boundary. Parent-side normalization
and serialization complete before the pool opens and before the first `BeginInvoke`; dispatch never
traverses caller-owned object graphs.

### D11 — Collision freedom is declared and checked, not inferred from arbitrary code — implemented

Jobs declare intended write paths. Plan compilation rejects exact and ancestor/descendant overlap unless
the caller explicitly accepts collision responsibility. This check cannot detect undeclared writes;
adapters remain responsible for complete write declarations and collision-free domain planning.

## Module and source organization

### D12 — One module contains plan and execution as internal layers — implemented

The executor becomes one `batch-executor` module, not separate plan, runspace, and process modules. The
module boundary hides implementation helpers while preserving the single scheduler and shared policy
vocabulary. The first extraction is mechanical; the safety-sensitive `Invoke-BatchExecutor` lifecycle is
not decomposed in the same change.

### D13 — Runtime payload source is data and lives outside dot-sourced code — implemented

Direct dispatcher, process dispatcher, child bootstrap, and generic job-worker source live under a
dedicated `payloads/` directory. The module reads dispatcher/bootstrap files as text and never dot-sources
them in host module scope. A deterministic explicit loader dot-sources only named host implementation
files. Directory placement carries this invariant; wildcard loading is forbidden.

The module root is captured once by `batch-executor.psm1` in module scope. Worker and payload paths derive
from that captured root, never from `$PSScriptRoot` inside a file under `public/` or `private/`.

### D14 — The canonical public surface contains four commands — implemented

The module exports:

- `New-BatchJob`
- `New-BatchPlan`
- `Invoke-BatchPlan`
- `Invoke-BatchExecutor`

`New-BatchPlan` replaces the unapproved `Compile-BatchPlan` verb. The transitional compatibility loader
provides `Compile-BatchPlan` as an alias. `Resolve-BatchWorkerBudget` remains private: callers state worker
policy through executor parameters and inspect the resolved budget in the returned execution record. Its
unit tests run inside module scope. If a real caller later needs preflight sizing, promote a separately
reviewed command with an approved verb.

### D15 — The flat script becomes a transitional compatibility loader — implemented

`src/shared/batch-executor.ps1` imports the canonical manifest and supplies only explicitly approved legacy
aliases. New callers import the manifest. Compatibility removal requires a caller inventory and an
explicit roadmap item; the facade does not become a second implementation or a wildcard dot-source hub.

### D16 — The source README is a contract surface, not a tutorial — implemented

The module README records capabilities, state/result vocabulary, job and plan contracts, cancellation and
thread-safety rules, subprocess ownership, public commands, and non-goals. Examples may witness contracts,
but procedural how-to material does not replace architecture statements.

### D17 — Preparation is write-once; one lifecycle record owns execution resources — accepted

Phase boundaries exchange private, type-tagged `PSCustomObject` records rather than PowerShell classes.
This preserves warning-free `Import-Module -Force` behavior while making shapes testable. An
`ExecutionPreparation` contains ordered `PreparedItem` records, normalized policy and budget, worker and
session configuration, cancellation/wait inputs, and dispatch-ready direct data or process payloads. It
owns no runspace pool, `PowerShell` pipeline, async handle, live `Process`, process registry, result array,
or infrastructure-error collection. Preparation records are write-once by convention after construction.
Preparation is all-or-nothing: any validation, normalization, or serialization failure occurs before pool
creation, so no earlier item starts from a partially prepared batch.

One mutable `LifecycleState`, created by `Invoke-BatchExecutor` before the outer execution `try`, is the
only owner of the pool, invocation records, ordered result array, child-process registry, infrastructure
diagnostics, timing, wait outcome, and completion flags. Its legal phase path is `Prepared -> Dispatching
-> Dispatched -> Awaiting -> Awaited -> Collecting -> Collected -> TearingDown -> Closed`; exceptional
unwind may enter `TearingDown` from any earlier phase. Runtime payloads may borrow only the child registry,
never the lifecycle record. An invocation has one terminal override (`Cancelled` or `TimedOut`), not
independent competing booleans.

Each prepared item retains the original caller input solely for result identity. Direct dispatch data is
either the shared reference or its prepared CLIXML copy. A process item retains only its resolved process
specification and prepared payload XML for dispatch; it never carries direct dispatch graphs.
`Resolve-BatchExecutorPreparation` implements the write-once half of the contract. BEX-303 binds dispatch
to the lifecycle owner: the pool is published immediately after construction, a pending-pipeline slot
covers construction through `BeginInvoke`, each successful submission is then registered as a typed
invocation, and an item-local launch failure is materialized directly in the owned result array. Await,
collection, and teardown are migrated incrementally by the remaining Phase 3 items.

### D18 — Phase 3 freezes the public execution projection — accepted

Lifecycle decomposition does not add or rename public result, execution, policy, summary, or timing
fields. In particular, `Input` remains the original caller object and the existing `WaitMs` timing name is
preserved. Preparation and lifecycle records, pool/pipeline/async handles, registry entries, and internal
phase names never escape. Any new public timing such as preparation or teardown duration requires a
separate contract decision. After BEX-302, `DispatchMs` is explicitly submission-only: preparation and
serialization remain included in `TotalMs` but do not receive a new public timing field during Phase 3.

## Deliberate non-goals of the module-extraction tranche

The module extraction does not add domain adapters, retry policy, detached execution, durable queues,
typed process-spec constructors, dependency DAG scheduling, or a second async engine. It also does not
port the plan model to C# or extract the internal prepare/dispatch/await/collect phases. Those are separate
roadmap decisions requiring their own evidence and tests.
