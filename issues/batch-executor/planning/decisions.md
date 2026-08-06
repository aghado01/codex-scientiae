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

### D2 — Scheduling cuts follow lifecycle phase, not execution mode — implemented

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
vocabulary. The initial package extraction was mechanical and deliberately preceded the separately gated
`Invoke-BatchExecutor` lifecycle decomposition.

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

`New-BatchPlan` replaces the unapproved `Compile-BatchPlan` verb. D22 retired the transitional loader and
its legacy alias after a zero-caller inventory. `Resolve-BatchWorkerBudget` remains private: callers state
worker policy through executor parameters and inspect the resolved budget in the returned execution record.
Its unit tests run inside module scope. If a real caller later needs preflight sizing, promote a separately
reviewed command with an approved verb.

### D15 — The flat script becomes a transitional compatibility loader — superseded by D22

BEX-201–BEX-206 temporarily made `src/shared/batch-executor.ps1` import the canonical manifest and supply
only the `Compile-BatchPlan` alias. It never became a second implementation or wildcard dot-source hub.
D22 records the required caller inventory, explicit removal, and permanent canonical load boundary.

### D16 — The source README is a contract surface, not a tutorial — implemented

The module README records capabilities, state/result vocabulary, job and plan contracts, cancellation and
thread-safety rules, subprocess ownership, public commands, and non-goals. Examples may witness contracts,
but procedural how-to material does not replace architecture statements.

### D17 — Preparation is write-once; one lifecycle record owns execution resources — implemented

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
`Resolve-BatchExecutorPreparation` realizes the write-once half of the contract. Dispatch publishes the
pool from inside its construction helper and uses an owner-visible pending-pipeline slot through
`BeginInvoke`; successful submissions become typed invocation records and launch failures become owned
item results. A failed dispatch-side disposal retains its pending slot and prevents entry to `Dispatched`.
Await/cancel consumes only frozen preparation policy, records one typed wait outcome, and applies the same
200 ms host-interruption checkpoints to the main wait and one batch-wide process drain. Collection fills
the original result indexes, preserves caller input identity, contains normalization failures, and leaves
disposal to teardown.

The exported function retains one lexical `try/finally`. Teardown kills children, stops supervisors,
disposes and clears pipelines, then closes and clears the pool before `Closed`. Final execution-record
assembly requires that closed state and is the only nonempty-execution lifecycle-to-public projection
boundary. Legal transitions enforce their required owner artifacts. A handle is cleared only after
disposal returns successfully; failed release is diagnosed, retained, and cannot claim `Closed`.

### D18 — Lifecycle decomposition preserves the public execution projection — implemented

The completed decomposition does not add or rename public result, execution, policy, summary, or timing
fields. In particular, `Input` remains the original caller object and the existing `WaitMs` timing name is
preserved. Preparation and lifecycle records, pool/pipeline/async handles, registry entries, and internal
phase names never escape. Any new public timing such as preparation or teardown duration requires a
separate contract decision. `DispatchMs` is explicitly submission-only: preparation and serialization
remain included in `TotalMs` but do not receive separate public timing fields.

## Adapter and infrastructure handoff

### D19 — Adapters consume caller-resolved run addressing without owning run infrastructure — accepted

Domain adapters accept an existing, caller-allocated absolute `RunDirectory`. They do not mint a runstamp,
choose a top-level artifact root, join or allocate a run, or infer a run identity from a path. This preserves
infrastructure D3 while its canonical run-context shape remains open in infrastructure Q1. Phase 4 therefore
does not freeze a provisional `{ Id, Root }` object. A future run-context wrapper may supply its resolved run
directory without changing adapter planning semantics.

All adapter-owned per-job artifact addressing passes through one private, pure resolver. Planning derives
collision-free descendants beneath `RunDirectory` but does not create them; workers may create only the
adapter-owned destinations declared by their job. Every intended application write is represented in
`Writes`, and a structural witness rejects competing path-composition sites in the adapter.

`BatchJob.Id` is the adapter's stable job-correlation identity. Process execution injects
`CODEX_BATCH_JOB_ID` and `CODEX_BATCH_EXECUTION_MODE=Process` and otherwise preserves caller-supplied
environment values unless explicitly overridden. That is process transport, not a completed logger or
cross-workflow correlation schema. Direct jobs correlate through their job record and context. Adapters must
not invent another run, task, event, or log-correlation vocabulary while infrastructure Q1 and LOGJ-305 are
open.

The executor's returned execution record remains the result boundary. An adapter does not serialize it or
define a generic durable job/result store. A runner-native or application-native report or log may be an
explicit job artifact when its schema, location, and complete write set belong to that application contract.
Any provisional handoff label belongs in plan/job metadata and planning documentation, never in an invented
marker file.

The Phase 4 coordination contract is:

| concern | batch-adapter contract | infrastructure handoff |
|---|---|---|
| Run allocation | Caller supplies an existing resolved `RunDirectory`; adapter never allocates or stamps it. | Infrastructure D3; Q1 and LOGJ-302 define the eventual shared run context and allocation/join API. |
| Per-job addressing | One pure resolver derives unique descendants; jobs declare every intended application write; planning creates none. | A future run context may replace only the resolver's input binding, not adapter path policy. |
| Job correlation | Use `BatchJob.Id`; preserve caller correlation inputs; treat process environment variables as transport only. | Q1 and LOGJ-305 define cross-workflow run/task/event correlation. |
| Logging | Pass caller-resolved addresses and policy inputs; do not implement logger lifecycle or sink semantics. | LOGJ-301–LOGJ-304 own wrappers, run joining, shared append mechanics, and degradation. |
| Durable executor results | None; return the in-memory execution record. Explicit application-native artifacts remain declared application writes. | Infrastructure D23 and LOGJ-401–LOGJ-407 govern any future store kind; persistent batch result stores remain deferred. |

This handoff is based on the
[K3/K4 coordination review](../discussions/opus-k3k4-comments-20260804.md) and the infrastructure
[decisions](../../infrastructure/planning/decisions.md),
[open questions](../../infrastructure/planning/open-questions.md), and
[roadmap](../../infrastructure/planning/roadmap.md). Batch Phase 4 does not wait for the entire infrastructure
roadmap, but it must not preempt those unresolved contracts.

### D20 — The test adapter maps one Pester file to one isolated process job — implemented

The repository test adapter is `Get-TestBatchJob`, exported by the shared `adapters` module alongside
`Get-LatexBatchJob`; neither command expands the batch executor's four-command surface. Directories are
discovered recursively as `*.Tests.ps1` files without loading Pester or suite code in the planning process.
Each unique file becomes
one `PowerShellProcess` job because Pester configuration, module loading, script state, location, and runner
termination behavior are process-wide concerns. Caller full-name and tag filters select cases inside each
file rather than creating a shared discovery host or one process per case.

Planning pins the exact Pester 5-or-newer manifest, child PowerShell, repository working directory, and
runner entrypoint. Stable job identity derives from the repository-relative file plus normalized filters; a
file-size hint affects dispatch order only. One D19 resolver assigns a unique Pester-native XML result path,
which is the adapter's sole declared write. Planning creates no run artifacts. The caller separately compiles
and invokes the emitted jobs through the shared module, and generic results remain in the in-memory execution
record.

The repository runner accepts the frozen filters and native result address. It throws when discovery is
empty or tests fail, which preserves a nonzero direct-process exit while also propagating failure through the
generic nested job worker. A failed test file remains one failed item and does not suppress sibling suites.

### D21 — The LaTeX adapter maps one source-ready manifest to one isolated process job — implemented

The repository LaTeX adapter is `Get-LatexBatchJob`, also exported by the shared `adapters` module. Its
`latex-batch` name identifies it as latex-ingest's batch planner without giving every planner a unitary
PowerShell module. It accepts document-inventory rows plus an existing absolute `RunDirectory`. Because
the parent inventory-row schema remains provisional under infrastructure Q8, the caller names the property
containing the manifest address; `metadata_path` is only the default projection for today's source-deposit
records. Relative manifest addresses are scoped to an explicit `InventoryRoot`, and absolute addresses must
remain inside it. This does not freeze a catalog identity, hierarchy, or materialization schema.

Planning requires a source-ready `codex-scientiae/document-metadata/0.1` manifest with one safe slug and one
identified LaTeX archive/source-tree pair. It derives cost from the archive size and stable job identity from
the scoped manifest address, source-tree fingerprint, and output-affecting switches. The exact
latex-ingest script and its SHA-256, adapter worker, child PowerShell, repository working directory, process
environment, timeout, hidden/profile-free process policy, and priority are fixed before plan compilation.
The worker invokes only the manifest-backed production entrypoint; it never imports the compatibility layer
or initializes a source deposit.

One process owns one document because latex-ingest uses script-scoped conversion state and document-local
rendering toolchains. One D19 resolver assigns collision-free descendants beneath the caller's run directory
for application run evidence, lane output, and an optional deliverable bundle. Those roots are the complete
declared write set, and planning creates none of them. The adapter copies caller environment values without
choosing logger topology; executor-injected job correlation remains authoritative. Generic execution results
remain in memory, and one failed document cannot suppress a sibling.

### D22 — The canonical manifest is the sole load path — implemented

A 2026-08-06 inventory found no production consumer of `src/shared/batch-executor.ps1` or
`Compile-BatchPlan` in the tracked repository or active sibling-project code. The only executable consumer
was the facade's own equivalence test; historical discussions and ledger witnesses are not callers.

BEX-208 therefore deletes the flat script and legacy alias. The manifest-backed module is the only supported
load surface, `New-BatchPlan` is the only plan constructor, and a module-surface witness requires both the
legacy path and command to remain absent. This changes no canonical export, plan/execution contract, adapter,
or runtime behavior.

### D23 — One physical Pester container owns one run-scoped artifact root — accepted

BEX-502 freezes the repository's batchable-container authoring contract in
[`tests/README.md`](../../../tests/README.md). One repository-relative `*.Tests.ps1` file remains the atomic
job and runs by exact path in one fresh child PowerShell process. Pester full names, tags, Describes,
parameter rows, and discovery metadata select content inside that job; they neither prove independence nor
create smaller schedulable units. A selected test cannot require another file or an earlier `It` to produce
its fixture.

Ephemeral scratch belongs in `$TestDrive`. Every retained test/application write belongs to the caller's run
and exact container invocation. The corrected Pester adapter will derive
`RunDirectory/pester-jobs/<container-address>/artifacts`, declare that root alongside the native
`pester.xml` write, and transport its absolute path as `CODEX_TEST_ARTIFACT_ROOT`. Planning creates neither
path. Tests may choose meaningful fixture, capability, audit, output, or evidence structure below the
container root; no infrastructure layer allocates directories per `It`, row, or tag. A repository-global
artifact root, timestamp allocator, fixed build output, or user-machine path is not an admissible fallback.

Capabilities are explicit immutable fixtures or toolchains. Their absence becomes a deterministic Pester
skip with a reason; a test does not restore, build, or download an undeclared fallback into shared state.
Mutable host state and child resources are restored on every path. Exact-path sequential and batch
invocations retain the same selection, skip/fail status, native result, and nonzero failure behavior; sibling
continuation remains executor-owned.

Files are reviewed semantically as `Batchable`, `CapabilityGated`, `NeedsRefactor`, or temporary
`SerialOnly`. Serial exceptions require a centralized owner, reason, removal condition, and exclusion from
the normal batch set; Phase 5 adds no locks, phase barriers, AST classifier, per-file sidecars, or executor
mode. The current `Get-TestBatchJob` still implements D20's provisional XML-only address until BEX-505; D23
freezes the target author/adapter boundary without changing current runtime behavior.

## Deliberate non-goals of the current executor

The current executor does not add retry policy, detached execution, durable queues, typed process-spec
constructors, dependency DAG scheduling, or a second async engine, and it does not port the plan model to
C#. The initial domain-adapter tranche closed separately through BEX-401–BEX-403; neither its closure nor
the completed lifecycle decomposition authorizes these deferred semantics.
