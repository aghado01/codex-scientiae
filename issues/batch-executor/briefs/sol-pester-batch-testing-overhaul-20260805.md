# Pester batch testing overhaul brief

Runstamp 20260805. **Status: complete; BEX-501 through BEX-507 implemented and Phase 5 closed on
2026-08-06.** This brief defines the test-authoring and execution changes that made repository testing a
normal shared-batch-executor workload. The Pester adapter, thin repository shell, and audited physical-file
topology are now the stable composition path.

Inputs:

- [batch-executor architecture decisions](../planning/decisions.md);
- [batch-executor roadmap](../planning/roadmap.md);
- [testing-overhaul workplan](../planning/testing-overhaul-workplan.md);
- [repository Pester runner](../../../tests/run.ps1);
- [repository parallel shell](../../../tests/parallel.ps1);
- [current Pester adapter](../../../src/adapters/public/Get-PesterBatchJob.ps1);
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
caller paths + existing RunDirectory
              |
              v
tests/parallel.ps1 -- composition and failure projection only
              |
              v
Get-PesterBatchJob -> New-BatchPlan -> Invoke-BatchPlan
                                            |
                                            v
tests/run.ps1 -- one exact Pester container per process job
~~~

BEX-505 atomically renamed the then-current `Get-TestBatchJob` file-level planner, its helpers, metadata,
job IDs, diagnostics, tests, and documentation to the Pester-specific `Get-PesterBatchJob`, `pester-batch`,
and `pester-jobs` contract. There is no compatibility alias or one-command submodule: the command remains
part of the shared `adapters` module.

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

BEX-502 froze the operational authoring and semantic review checklist in
[`tests/README.md`](../../../tests/README.md). BEX-505 implements its adapter-side address:
`RunDirectory/pester-jobs/<container-address>/artifacts`, transported to the child as the absolute
`CODEX_TEST_ARTIFACT_ROOT` and declared as a job write beside `pester.xml`. This brief retains the ownership
rationale.

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

BEX-507 closes migration with 45 audited physical files: 35 `Batchable`, 10 `CapabilityGated`, no
`NeedsRefactor`, and no `SerialOnly` residue. The repository contains 471 textual `It` blocks and Pester
observes 484 tests. Ordinary path discovery therefore admits the complete suite; no workload manifest or
serial exclusion layer was required.

## 6. Runner, adapter, executor, and harness boundaries

### Repository runner

`tests/run.ps1` remains the authoritative Pester invocation boundary. It must continue to support the
repository's pinned Pester 5/6 behavior, accept an exact container path, emit native result XML when asked,
and return failure through process exit status. It owns no scheduler, pool, retry policy, run allocation,
or durable result store. BEX-503 additionally freezes one transient child-stdout audit line containing the
resolved path, selected/pass/fail/skip outcomes, duration, and native result location. It is emitted before
empty/failure propagation and does not replace or persist the native result.

### Pester adapter

The corrected `Get-PesterBatchJob` discovers caller-selected physical test files and emits one
`PowerShellProcess` job per file. It consumes an existing absolute `RunDirectory`, uses one pure D19
resolver to derive sibling `pester.xml` and `artifacts/` addresses beneath one
`RunDirectory/pester-jobs/<container>` root, and declares both as writes. Its
`ProcessSpec.Environment` transports the absolute artifact root as `CODEX_TEST_ARTIFACT_ROOT`; planning
pins the runner, Pester manifest, child PowerShell, repository root, and filters while creating nothing.
Stable identity is `pester:<repository-relative-path>#<digest>`.

It does not interpret arbitrary Pester ASTs, own executor resources, merge generic execution results, or
turn `It` names into jobs.

### Shared executor

`New-BatchPlan` and `Invoke-BatchPlan` remain the only queue, worker-budget, lifecycle, cancellation,
failure-containment, and original-order authorities. The overhaul must not add a testing-specific
execution mode.

### Thin repository shell

`tests/parallel.ps1` accepts caller-selected paths (defaulting to `tests/`) and a mandatory existing absolute
`RunDirectory`; path selection proved sufficient, so there is no workload-profile abstraction. It also
passes through repository/Pester/filter/result inputs and bounded public executor policy. The shell imports
the canonical adapter and executor manifests, then calls module-qualified `Get-PesterBatchJob`,
`New-BatchPlan`, and `Invoke-BatchPlan` exactly once each.

It writes one concise Information summary and emits the exact in-memory executor record. A non-successful
job or infrastructure error causes a throw only after that record is emitted, preserving sibling evidence
while making direct `pwsh -File` use nonzero. The shell owns no scheduler, pool, process registry,
cancellation protocol, retry loop, run allocation or timestamp convention, logger lifecycle, durable store,
result ordering, or Pester address composition.

## 7. Pilot strategy

Use two deliberately different pilots:

- **Positive control:** `tests/shared/batch-executor*.Tests.ps1`, which already has several physical files
  around a cohesive package and exercises process/lifecycle behavior.
- **Restructuring control:** the former 66-test `tests/latex-ingest/latex-ingest.Tests.ps1`. BEX-504 retained
  60 pure/converter tests there and moved 6 external-process/run-artifact tests to
  `tests/latex-ingest/latex-ingest-integration.Tests.ps1`, the one fixture/capability/cost seam supported by
  the evidence.

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
[semantic inventory and timing baseline](../planning/testing-batchability-inventory.md). BEX-502 then froze
the canonical [authoring and review contract](../../../tests/README.md) and D23. BEX-503 then hardened the
exact-container runner boundary across Pester 5.7.1 and 6.0.0, including native results, empty/failure
status, and child-safe observations, without acquiring batch ownership. BEX-504 then preserved exact
sequential/parallel semantics for both controls, left the eight-file batch-executor topology intact, and
split the LaTeX control once to isolate capability-gated external processes and container-owned writes.
Finally, BEX-505 replaced the provisional generic test-adapter naming and XML-only address with the
Pester-specific command, stable identity, single resolver, paired native-result/artifact writes, and child
artifact-root transport. BEX-506 then added the thin `tests/parallel.ps1` product shell over the three
module-qualified public calls, with caller-owned path/run selection, exact execution-record output, and
post-output nonzero failure projection. Closure validation is 3/3 focused shell, 23/23 complete adapter,
6/6 infrastructure, and 158/158 shared tests; the complete sequential repository gate selected 482 tests,
with 480 passed, 2 dependency-gated skips, and no failures.

BEX-507 then repaired and reclassified all eight remaining suites, added the cross-tree topology witness,
and admitted all 45 files. The final Pester 6 sequential gate completed in 111.988 seconds with 484
selected, 482 passed, no failure, and 2 explicit skips; its only warnings were the two existing
unresolved/out-of-root LaTeX inputs. The four-worker repository gate completed 45/45 jobs in 108.007 seconds
with 484 selected, 482 passed, 2 explicit skips, no failed/timed-out/cancelled job or infrastructure error,
45 native `pester.xml` reports, 143 produced files all covered by declared `Writes`, no missing result, and
no surviving worker. The apparent HDBSCAN batch failure was not a LaTeX/HDBSCAN shared-path collision: all nine
Pester assertions passed, but direct native stderr and an intentionally nonzero final CLI probe leaked into
the worker protocol. A container-local captured-process helper now owns those streams and statuses, resets
`$LASTEXITCODE`, and retains batch evidence only below
`pester-jobs/<container>/artifacts/hdbscan-cli`; its sequential 9/9 and singleton-executor witnesses pass,
with the latter retaining 36 artifacts. No LaTeX/HDBSCAN shared-path collision remains. The
[workplan](../planning/testing-overhaul-workplan.md), inventory, decisions, roadmap, and ledger record the
closed Phase 5 state.
