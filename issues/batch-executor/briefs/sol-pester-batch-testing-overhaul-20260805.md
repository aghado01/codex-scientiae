# Pester batch testing overhaul brief

Runstamp 20260805. **Status: scoped; not implemented.** This brief defines the test-authoring and
execution changes required before repository testing can use the shared batch executor as a normal
parallel path. It does not close any Phase 5 ticket or change the current test adapter.

Inputs:

- [batch-executor architecture decisions](../planning/decisions.md);
- [batch-executor roadmap](../planning/roadmap.md);
- [testing-overhaul workplan](../planning/testing-overhaul-workplan.md);
- [repository Pester runner](../../../tests/run.ps1);
- [current Pester adapter](../../../src/adapters/public/Get-TestBatchJob.ps1);
- ThermoMapper precedents: [host](../../../../ThermoMapper/src/test-harness/Program.cs),
  [discovery](../../../../ThermoMapper/src/test-harness/TestDiscovery.cs), and
  [fact runner](../../../../ThermoMapper/src/test-harness/FactRunner.cs).

## 1. Disposition

Do not build automatic `It`-level fan-out over the repository's current Pester files. The suite was not
authored as a collection of independently schedulable facts, and discovery metadata alone cannot prove
that setup, state, filesystem use, environment changes, or external tools are independent.

The default schedulable unit is one physical `*.Tests.ps1` file, executed as one Pester container in a
fresh child process. Oversized or coupled files should be split along real fixture, resource, capability,
or cost seams before they are parallelized.

~~~text
test authors and suite topology
              |
              v
tests/run.ps1 -- one exact Pester container
              |
              v
Get-PesterBatchJob -- domain planning only
              |
              v
New-BatchPlan / Invoke-BatchPlan -- one queue, budget, and lifecycle owner
              |
              v
tests/parallel.ps1 -- thin repository-facing shell
~~~

The existing `Get-TestBatchJob` remains the conservative file-level planner while this work is underway.
When its contract is corrected, the command, filenames, helpers, metadata, address root, tests, and
documentation should change atomically to `Get-PesterBatchJob`, `pester-batch`, and `pester-jobs`. There
should be no compatibility alias and no one-command submodule: it remains part of the shared `adapters`
module.

## 2. Why suite topology moves first

The initial mechanical census, before the BEX-403 structural gate was added, found:

| signal | count |
|---|---:|
| `*.Tests.ps1` files | 42 |
| textual `Describe` blocks | 130 |
| textual `It` blocks | 451 |
| files using `BeforeAll` | 42 |
| files using `BeforeEach` | 6 |
| files using `AfterAll` | 8 |
| files using `BeforeDiscovery` | 1 |
| files with environment-state markers | 6 |
| files with process/toolchain markers | 11 |
| files with write primitives | 21 |
| files using `$TestDrive` | 18 |
| files using `InModuleScope` | 9 |
| files with skip mechanics | 4 |

BEX-403 subsequently added one structural test file with two `It` blocks, making the closure baseline 43
files and approximately 453 textual `It` blocks. The remaining counts above are the original routing
snapshot; they should be regenerated semantically under BEX-501 rather than adjusted by substring matching.

These are text-search routing signals, not a semantic independence proof. They show why treating 451
textual `It` blocks as 451 safe jobs would be an unsupported assumption.

Pester discovery can expose paths and expanded test names, but discovery or top-level code may itself do
work. Re-running a complete file for each selected test also repeats `BeforeAll`, module loading, and other
container setup. Full names, tags, and parameter rows are useful selection surfaces; they are not an
automatic sharding contract.

## 3. ThermoMapper precedent: what transfers

ThermoMapper's fact harness establishes three useful principles:

1. discover exact test identities before execution;
2. map each identity to an exact child-process invocation;
3. isolate failure and diagnostics so one failed item does not erase its siblings.

Its implementation ownership does not transfer. The Pester path must not import a second scheduler,
`Parallel.ForEachAsync` worker pool, worker-budget policy, process registry, cancellation implementation,
run allocator, timestamp convention, build orchestrator, per-run log store, manifest, or summary store.
Those concerns either already belong to batch-executor/infrastructure or remain explicitly deferred.

## 4. Batchable Pester-container contract

A file may be classified `Batchable` only when all of the following hold:

- **Identity and selection:** its physical repository-relative path identifies the atomic container; an
  exact-path run neither depends on another test container running first nor silently expands to siblings.
- **Setup and state:** discovery, top-level code, `BeforeAll`, `BeforeEach`, and cleanup are repeatable in a
  fresh process; mutable state is container-local or restored.
- **Writes and external resources:** ephemeral fixtures may use `$TestDrive`; every retained test or
  application write uses a container artifact root beneath the caller's run and the container address. A
  repository-global `artifacts/<container>` path is not sufficient because concurrent runs would still
  share it. The file does not depend on shared mutable services, fixed ports, or global configuration
  without isolation. Layout below the container root remains suite-owned unless pilot evidence supports a
  common seam; no directory is allocated automatically per `It` block.
- **Capability and cost:** missing dependencies become explicit skip/capability outcomes, not accidental
  worker failures; unusually expensive setup is visible during inventory and scheduling review.
- **Failure containment:** a local assertion or setup failure produces a nonzero job result while unrelated
  files continue and retain their own native results.

The initial overhaul adds no lock manager. A file that needs cross-job locks, ordering, or phase barriers
is `NeedsRefactor` or temporarily `SerialOnly`, with an owner and reason.

## 5. Migration classifications

| class | meaning | required action |
|---|---|---|
| `Batchable` | Safe as one fresh-process Pester container. | Admit to the normal batch workload. |
| `CapabilityGated` | Safe when an explicitly declared dependency is available. | Preserve deterministic skip/capability behavior. |
| `NeedsRefactor` | Coupled topology, shared state, collisions, or excessive setup prevents safe batching. | Split or isolate at a real seam, then re-audit. |
| `SerialOnly` | Temporary exception where refactoring is not yet justified. | Record owner, reason, and removal condition; run outside the batch set. |

This classification may start in the workplan inventory. A centralized workload declaration should be
introduced only if the pilots prove that source topology and caller path selection cannot express the
needed sets. Do not create per-file sidecars, manifests, or modules.

## 6. Runner, adapter, executor, and harness boundaries

### Repository runner

`tests/run.ps1` remains the authoritative Pester invocation boundary. It must continue to support the
repository's pinned Pester 5/6 behavior, accept an exact container path, emit native result XML when asked,
and return failure through process exit status. It owns no scheduler, pool, retry policy, run allocation,
or durable result store.

### Pester adapter

The corrected `Get-PesterBatchJob` discovers caller-selected physical test files and emits one
`PowerShellProcess` job per file. It consumes an existing absolute `RunDirectory`, uses one pure D19
resolver beneath `pester-jobs`, declares its Pester XML write, pins the runner/Pester/child PowerShell, and
creates nothing while planning.

It does not interpret arbitrary Pester ASTs, own executor resources, merge generic execution results, or
turn `It` names into jobs.

### Shared executor

`New-BatchPlan` and `Invoke-BatchPlan` remain the only queue, worker-budget, lifecycle, cancellation,
failure-containment, and original-order authorities. The overhaul must not add a testing-specific
execution mode.

### Thin repository shell

A later `tests/parallel.ps1` may accept selected paths or a small workload profile plus a caller-allocated
absolute `RunDirectory`, invoke the adapter and executor, present the execution summary, and exit nonzero
when any job fails. It must not allocate runs or own a pool, process registry, retry loop, cancellation
protocol, result ordering, logger lifecycle, or durable run store.

## 7. Pilot strategy

Use two deliberately different pilots:

- **Positive control:** `tests/shared/batch-executor*.Tests.ps1`, which already has several physical files
  around a cohesive package and exercises process/lifecycle behavior.
- **Restructuring control:** `tests/latex-ingest/latex-ingest.Tests.ps1`, which should expose whether a large
  suite needs real fixture or capability seams before batching.

For each pilot, compare authoritative sequential execution with file-parallel execution: selected tests,
pass/fail/skip outcomes, exit status, native XML, wall time, per-container setup cost, output paths, and
surviving child processes. Performance is evidence for topology and scheduling choices, not permission to
weaken semantic parity.

## 8. Exit gates

The overhaul closes only when:

1. every admitted file has a documented and audited classification;
2. each batchable file passes independently in a fresh process;
3. sequential and parallel runs have equivalent selection and pass/fail/skip outcomes;
4. one failed file does not suppress sibling execution or evidence;
5. concurrent runs have no write collision, environment leak, fixed-resource race, or surviving child;
6. one executor queue, budget, cancellation path, and result order remain authoritative;
7. neither adapter nor shell allocates runs, owns logging/retry infrastructure, or persists generic results;
8. pilot timings justify the chosen file boundaries or identify the next source split;
9. focused adapter/executor, infrastructure, complete shared, and complete repository gates are green;
10. decisions, roadmap, ledger, adapter README, and test instructions agree.

## 9. Non-goals

This tranche does not include:

- automatic `It`-block or parameter-row slicing, including static AST inference;
- locks, exclusive groups, dependency DAGs, phase barriers, or adaptive historical scheduling;
- a port of ThermoMapper's scheduler, run store, logging, manifest, or build orchestration;
- a universal test hierarchy or a C# replacement for the PowerShell adapter;
- per-file configuration sidecars or unitary modules;
- merged/durable generic execution reports, resume semantics, or run allocation;
- broad stylistic rewrites of otherwise independent assertions.

## 10. Handoff

BEX-403 closed on 2026-08-06: the existing adapters are thin, D19 addressing has one owner per adapter,
planning leaves the caller run untouched, and produced application artifacts are covered by declared
writes. BEX-501 subsequently closed the 43-file
[semantic inventory and timing baseline](../planning/testing-batchability-inventory.md). Phase 5 now resumes
at the contract freeze, followed by runner audit, source restructuring, adapter correction, thin-shell
composition, and repository migration as specified in the
[workplan](../planning/testing-overhaul-workplan.md).
