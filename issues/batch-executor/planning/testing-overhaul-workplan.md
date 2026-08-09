# Batch executor — Pester testing-overhaul workplan

This is the ticket-level execution plan for making repository Pester tests safely batchable. The design
boundary is defined in the [testing-overhaul brief](../briefs/sol-pester-batch-testing-overhaul-20260805.md);
the ahead-only queue remains [roadmap.md](roadmap.md), implemented architecture remains
[decisions.md](decisions.md), and closed work remains [ledger.md](ledger.md).

**Status: complete; BEX-501 through BEX-507 and Phase 5 closed on 2026-08-06.** The tickets were executed
strictly in sequence.

## Current evidence and baseline

The BEX-501 baseline covered 43 physical `*.Tests.ps1` files and exactly 453 textual `It` lines. It ran
every file by exact path in a fresh child process: 476 tests were selected, 474 passed, 2 were skipped, and
none failed. Its [semantic inventory](testing-batchability-inventory.md) classifies 31 files as
`Batchable`, 3 as `CapabilityGated`, 9 as `NeedsRefactor`, and none as `SerialOnly`. The isolated wall
measurements total 320.387 seconds; the inventory records individual cost, state, capability, write, and
collision evidence rather than treating structural counts as independence proof.

BEX-502 froze the author-facing contract in [`tests/README.md`](../../../tests/README.md) and architecture
decision D23. One exact physical file remains the fresh-process job; retained writes receive one declared,
caller-run-scoped container artifact root through `CODEX_TEST_ARTIFACT_ROOT`; topology below that root is
suite-owned; and semantic review—not Pester AST inference—assigns the four inventory classes.

BEX-503 leaves the physical topology and classifications unchanged while adding three runner-contract
tests and six embedded fixture `It` lines, so the current mechanical count is 43 files and 462 textual `It`
lines. The authoritative repository run now selects 479 tests: 477 pass, 2 are dependency-gated skips, and
none fail. Exact-path Pester 5.7.1/6.0.0 witnesses freeze selection, native-result, exit-status, and transient
observation parity; the complete adapter and infrastructure gates are 20 and 6 passing tests respectively.

BEX-504 retains all 57 positive-control tests across their eight existing containers and splits the 66-test
LaTeX restructuring control once: 60 pure/converter tests remain in `latex-ingest.Tests.ps1`; 6 external
process and run-artifact tests move to `latex-ingest-integration.Tests.ps1`. The post-pilot inventory was
44 files and 462 textual `It` lines: 32 `Batchable`, 4 `CapabilityGated`, 8 `NeedsRefactor`, and no
`SerialOnly`. One-worker/file-parallel parity is 57/57 and 66/66 with native-result, declared-write,
repository-residue,
and process-survivor equality. The authoritative repository gate before BEX-506 selected 479 tests: 477
passed, 2 were dependency-gated skips, and none failed.

The current `Get-PesterBatchJob` adapter chooses the conservative physical-file boundary. BEX-505 completed
its Pester-specific `pester-batch` identity and `pester-jobs` address contract without adding an alias or
unitary module. One resolver owns each container's sibling `pester.xml` and `artifacts/` paths, both are
declared writes, and `ProcessSpec.Environment` carries the latter as `CODEX_TEST_ARTIFACT_ROOT`. Planning
creates neither path. The earlier BEX-403 closure baseline was 474 passed plus 2 dependency-gated skips (476
total); its focused baselines were 17 adapter, 6 infrastructure, and 158 shared passing tests.

BEX-506 added `tests/parallel.ps1` as a replaceable product shell over the canonical module manifests. It
accepts paths plus a mandatory existing caller run, uses no workload profile, invokes the module-qualified
adapter -> plan -> executor chain once, emits one Information summary and the exact in-memory execution
record, then throws after output on any non-success or infrastructure error. Its focused structural,
two-file success, and sibling-failure/CLI witnesses are 3/3. Its new test container is `Batchable`, bringing
the post-BEX-506 inventory to 45 files and 469 textual `It` lines. Complete validation is 23/23 adapter, 6/6
infrastructure, and 158/158 shared tests; the authoritative sequential repository gate selected 482 tests,
with 480 passed, 2 dependency-gated skips, and none failed.

BEX-507 reclassified the eight remaining `NeedsRefactor` files after isolating capabilities, scratch state,
native-process streams/status, and retained artifacts. The closed inventory is 45 physical files, 471
textual `It` blocks, and 484 observed tests: 35 `Batchable`, 10 `CapabilityGated`, no `NeedsRefactor`, and no
`SerialOnly`. The final Pester 6 sequential gate ran in 111.988 seconds with 484 selected, 482 passed, no
failure, and 2 explicit skips; its only warnings were the two existing unresolved/out-of-root LaTeX inputs.
The complete four-worker gate ran all 45 jobs in 108.007 seconds with 484 selected, 482
passed, 2 explicit skips, no failure/timeout/cancellation/infrastructure error, 45 native XML reports, 143
produced files all beneath declared writes, no missing result, and no surviving worker. The HDBSCAN repair
does not mask a LaTeX collision: its nine assertions were already green, but direct native stderr and an
expected nonzero CLI status polluted the worker protocol. Its local captured-process helper now owns those
streams/status, resets `$LASTEXITCODE`, and keeps retained work under the assigned container artifact root.

Post-closure additions remain subject to the same contract. The 2026-08-06 localized-inventory/latex-batch
development container passed 6/6 by exact path and is `Batchable`, moving the current inventory to 46 files,
490 observed tests, and 477 textual `It` blocks without reopening Phase 5. Its classification and evidence
are recorded in the semantic inventory. The current four-worker gate completed all 46 jobs in 100.255 s
with 488 passes, 2 existing skips, 46 native results, no failed/timed-out/cancelled job or infrastructure
error, all 144 retained files in the declared container shape, and no surviving process.

## Dependency order

~~~text
BEX-403 adapter thinness [closed 2026-08-06]
          |
          v
BEX-501 semantic inventory and timing baseline [closed 2026-08-06]
          |
          v
BEX-502 batchable-container contract [closed 2026-08-06]
          |
          v
BEX-503 runner audit [closed 2026-08-06]
          |
          v
BEX-504 pilot restructuring [closed 2026-08-06]
          |
          v
BEX-505 Pester adapter correction [closed 2026-08-06]
          |
          v
BEX-506 thin parallel shell [closed 2026-08-06]
          |
          v
BEX-507 repository migration and closure [closed 2026-08-06]
~~~

BEX-403 proved both current adapters retain one D19 address owner, complete declared writes, planning purity,
and no scheduler, lifecycle, run, retry, logger, or durable-result ownership. That evidence is an entry gate,
not Phase 5 implementation.

BEX-507 completed the audited repository migration over the established file boundary, runner, adapter,
and product-shell composition path. Phase 5 has no outstanding ticket.

## Cross-cutting invariants

Every ticket preserves these conditions:

1. one physical Pester file/container is the default atomic job;
2. exact test names, tags, and parameter rows select content but do not create automatic jobs;
3. one batch-executor queue and one worker budget own all admitted work;
4. every Pester job executes in a fresh child PowerShell process;
5. `tests/run.ps1` remains the authoritative Pester invocation boundary;
6. adapters only discover, interpret, address, and emit domain-neutral jobs;
7. callers allocate `RunDirectory`; adapters and test shells never allocate run identity;
8. every intended application write is declared and derived through one pure address resolver;
9. generic executor results stay in memory unless separate infrastructure later owns persistence;
10. serial exceptions are temporary, explicit, owned, and excluded from the normal batch set.
11. every admitted container receives one writable artifact root beneath the caller's `RunDirectory` and
    its container address; retained test/application writes stay below that root, while `$TestDrive` remains
    valid for ephemeral fixtures. A repository-global `artifacts/<container>` path alone is not run-safe.
12. topology below the container artifact root remains suite-owned unless pilot evidence justifies a common
    fixture/capability/evidence layer; Phase 5 does not allocate an automatic directory per `It` block.
13. `tests/parallel.ps1` composes public module contracts once and owns only summary/failure projection; it
    does not duplicate discovery, addressing, scheduling, lifecycle, run, logging, or storage policy.

## BEX-501 — Build the semantic batchability inventory

**Status: closed 2026-08-06.** The durable evidence and classification register is
[testing-batchability-inventory.md](testing-batchability-inventory.md).

### Scope

- Inventory every `*.Tests.ps1` file by repository-relative path, test count, dominant fixture/capability,
  setup/cleanup hooks, mutable environment or location use, process/toolchain use, writes, fixed external
  resources, skip behavior, and approximate sequential duration.
- Classify each file as `Batchable`, `CapabilityGated`, `NeedsRefactor`, or `SerialOnly` using the brief.
- Record an owner, reason, and removal condition for each `SerialOnly` exception.
- Measure the two pilots first:
  `tests/batch-executor/batch-executor*.Tests.ps1` and `tests/latex-ingest/latex-ingest.Tests.ps1`.
- Treat the existing mechanical census as a review queue, not as a semantic result.

### Exit gate

Every current test file has an evidence-backed classification; high-cost and high-collision-risk files are
visible; no file is admitted merely because discovery produced test names.

## BEX-502 — Freeze the batchable Pester-container contract

**Status: closed 2026-08-06.** The canonical authoring/review surface is
[`tests/README.md`](../../../tests/README.md); [D23](decisions.md) records the architecture boundary.

### Scope

- Convert the brief's identity, setup/state, writes/resources, capability/cost, and failure-containment
  rules into repository test-authoring guidance and review checks.
- Define exact-path execution, fresh-process isolation, native result, and exit-status parity.
- Define the minimum write boundary as caller run -> Pester container address -> container artifact root;
  distinguish ephemeral `$TestDrive` fixtures from retained evidence without prematurely standardizing the
  hierarchy beneath that root.
- Define when a physical file must be split and what qualifies as a real seam: fixture, resource,
  capability, or cost.
- Define `CapabilityGated` and temporary `SerialOnly` behavior without introducing scheduler locks.
- State that discovery metadata and full names are not an independence contract.

### Exit gate

The authoring contract is precise enough to classify a new file without scheduler knowledge, and it does
not require Pester-internal AST interpretation or a new executor semantic.

## BEX-503 — Harden the runner and add an observational audit boundary

**Status: closed 2026-08-06.** The authoritative runner now resolves one exact path into one explicit
Pester container and emits one transient, child-stdout observation before propagating an empty or failed
run. Focused witnesses cover Pester 5.7.1 and 6.0.0 plus the live nested batch path; native XML remains the
only durable runner artifact and the runner owns no batch infrastructure.

### Scope

- Verify `tests/run.ps1` accepts one exact physical container without discovering unintended siblings.
- Preserve the pinned Pester 5/6 compatibility path and current cross-version path behavior.
- Preserve native XML output, empty-run rejection, nonzero failure propagation, and child-process-safe
  diagnostics.
- Add only the observations needed to audit a container: resolved path, selected/pass/fail/skip counts,
  duration, and native result location.
- Prove the runner owns no scheduling, run allocation, retry, generic result persistence, or log lifecycle.

### Exit gate

The same exact-container invocation is authoritative in sequential and batch modes, with equivalent
selection/outcome semantics and no expansion of runner ownership.

## BEX-504 — Refactor and benchmark representative suites

**Status: closed 2026-08-06.** The positive control required no source split. The restructuring control now
has one external-integration seam, explicit capability skips with reasons, no default repository-run write,
and one suite-owned artifact layout. Sequential and parallel executions produced identical observations and
native XML with no missing/undeclared evidence, shared residue, or surviving descendant.

### Scope

- Run the batch-executor shared files as the positive control and document fresh-process independence.
- Use the LaTeX-ingest suite as the restructuring control; split it only where fixture, external capability,
  mutable resource, or cost boundaries warrant physical containers.
- Remove cross-file ordering assumptions, shared write collisions, leaked environment/location changes,
  and unbounded process cleanup in the pilots.
- Give every retained pilot write an explicit container artifact root; in particular, stop direct LaTeX
  tests from falling back to repository-global run allocation and prove they leave no shared run residue.
- Compare sequential and file-parallel outcomes, native results, wall time, setup cost, evidence paths, and
  process survivors.
- Feed any newly discovered contract gap back into BEX-502 before expanding migration.

### Exit gate

Both pilots satisfy semantic parity and failure containment; the parallel result has no write or resource
race; timing evidence supports the selected file topology or records a bounded follow-up split.

## BEX-505 — Correct and harden the Pester adapter

**Status: closed 2026-08-06.** The shared module exports `Get-PesterBatchJob` with `pester-batch` identity,
stable `pester:<repository-relative-path>#<digest>` IDs, and no compatibility alias. One resolver owns the
native-result and artifact addresses, both are declared writes, child transport is explicit, and planning
remains pure.

### Scope

- Atomically rename the then-current `Get-TestBatchJob` to `Get-PesterBatchJob` throughout its public file,
  manifest, root module, private helpers, tests, README, metadata, job IDs, and diagnostics.
- Rename adapter identity/addressing to `pester-batch` and `pester-jobs`.
- Keep the command in the single shared `adapters` module; add no compatibility alias or unitary submodule.
- Emit exactly one `PowerShellProcess` job per selected physical file and pin the runner, Pester manifest,
  child PowerShell, repository root, filters, native result path, and D23 container artifact root.
- Derive both paths through the one `pester-jobs` address resolver, declare them as writes, and transport the
  artifact root to the child as `CODEX_TEST_ARTIFACT_ROOT` without creating it during planning.
- Preserve D19 planning purity, complete write declarations, stable IDs, collision rejection, and
  failure-containment tests.
- Add structural witnesses rejecting competing Pester address composition and executor-resource ownership.

### Exit gate

The former generic names remain only in explicit transition history, not live code or current-contract
documentation. File-level behavior and the public executor surface remain unchanged; focused adapter and
shared gates are green.

## BEX-506 — Compose a thin repository parallel-test shell

**Status: closed 2026-08-06.** `tests/parallel.ps1` is a thin product shell over canonical adapter and
executor manifests. Its 3/3 focused structural/runtime, 23/23 complete adapter, 6/6 infrastructure, and
158/158 shared witnesses pass; the complete sequential repository gate is 480 passed plus 2
dependency-gated skips from 482 selected.

### Scope

- Add `tests/parallel.ps1` as a product-facing composition shell.
- Accept caller-selected paths (default `tests/`) plus a mandatory existing absolute `RunDirectory`;
  BEX-504 showed path selection is sufficient, so add no workload profile.
- Pass through repository root, Pester manifest/child PowerShell, Pester filters/results, and bounded public
  executor budget/process policy inputs.
- Import canonical manifests and call module-qualified `Get-PesterBatchJob`, `New-BatchPlan`, and
  `Invoke-BatchPlan` exactly once each.
- Print one concise Information summary, emit the exact in-memory execution record, and throw after output
  when any job is non-successful or infrastructure errors exist so `pwsh -File` is nonzero.
- Preserve individual native Pester result paths, container artifacts, sibling evidence, and process cleanup.
- Add structural tests that reject a private pool/scheduler, process registry, cancellation protocol, retry
  loop, run allocator, timestamp convention, logger owner, result-order implementation, or durable store.

### Exit gate

The shell is replaceable composition over public module contracts: removing it would not remove any
scheduler, lifecycle, or domain-planning capability. Structural witnesses reject duplicate owners, and
runtime witnesses prove two-file success plus failed-batch evidence and real CLI nonzero behavior.

## BEX-507 — Migrate the repository and close the overhaul

**Status: closed 2026-08-06.** All 45 audited files are admitted through ordinary path selection; no serial
exception, sidecar, workload profile, scheduler mode, or shared-path collision remains.

### Scope

- Refactor remaining `NeedsRefactor` suites in risk/cost order and reclassify them.
- Admit all `Batchable` and available `CapabilityGated` files to the normal batch workload.
- Keep any justified `SerialOnly` residue explicit with owner/removal condition and run it through the
  authoritative runner outside the batch set.
- Add structural/topology checks for one adapters module, canonical Pester naming, no sidecar sprawl, one
  runner boundary, one executor composition path, and no hidden scheduler/store.
- Re-run focused adapter/executor, infrastructure, complete shared, authoritative sequential repository,
  and complete parallel repository gates.
- Reconcile decisions, adapter/test documentation, roadmap, and ledger only after implementation evidence
  exists.

### Exit gate

Sequential and parallel selections/outcomes agree; local failures retain sibling evidence; there are no
collisions, leaked state, or surviving children; the full testing workload is either admitted or explicitly
accounted for; Phase 5 implementation has moved from the roadmap to the ledger.

Closure evidence begins with the final Pester 6 sequential gate: 484 selected / 482 passed / 0 failed / 2
skipped in 111.988 seconds. Parallel evidence is 45/45 successful four-worker jobs with the same outcomes,
45 native results, 143 produced files with zero outside declared `Writes`, zero missing results, and zero
surviving workers. The final inventory is 35 `Batchable`, 10 `CapabilityGated`, 0 `NeedsRefactor`, and 0
`SerialOnly`. A focused HDBSCAN exact-path run is 9/9; its singleton executor job succeeds with exit status
zero, no executor error, and 36 retained artifacts beneath
`pester-jobs/<container>/artifacts/hdbscan-cli`. That witness distinguishes the repaired child-stream/status
protocol from the already-disproved LaTeX/HDBSCAN path-collision hypothesis.

## Deferred questions

The overhaul deliberately leaves these for separate evidence and decisions:

- automatic `It`-block or parameter-row slicing;
- persistence of exact test identities across Pester versions;
- resource locks, exclusive groups, dependency DAGs, and phase barriers;
- historical timing stores and adaptive scheduling;
- a cross-framework test hierarchy or C# adapter port;
- direct integration with ThermoMapper's .NET/xUnit workload;
- durable merged reports, run manifests, resume, and shared run allocation.
