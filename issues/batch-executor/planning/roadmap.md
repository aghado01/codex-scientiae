# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); the testing tranche has a
[detailed workplan](testing-overhaul-workplan.md); arguments, briefs, and review evidence live under
[../discussions/](../discussions/) and [../briefs/](../briefs/). Do not leave completed work in this file.

## Current baseline — 2026-08-06

The executor is packaged under `src/shared/batch-executor/`. Its manifest exposes four commands; its root
module validates and reads four runtime payloads as source data, loads named host files in deterministic
order, and leaks no private helpers. The manifest is the sole supported load path; BEX-208 removed the
zero-caller flat compatibility facade and `Compile-BatchPlan` alias.

The behavioral and teardown gates remain closed: 21 executor, 8 private state-contract, 5 preparation, 6
lifecycle-owner/dispatch, 2 await/cancel, 3 collection, 4 teardown/assembly, 8 job/plan, and 8
module-surface tests pass, and the complete shared suite is 158 passing tests. The queued multi-item
host-stop witness closes the start/registration race and prevents queued supervisors from
unwinding in serial waves. Preparation now completes all caller-graph traversal and serialization before
the pool opens. The repository-wide path-topology suite is also green after BEX-207 removed post-eviction
residue and rebuilt the check around required current inputs. Phases 2 through 4 are closed; the package
boundary and public execution projection remained stable through lifecycle decomposition, adapter
validation, and compatibility removal. Phase 5 is now the ahead queue.

BEX-401 is closed. `Get-TestBatchJob` in the shared `adapters` module emits one exact-Pester, isolated process
job per selected test file, derives its native XML result through the D19 address chokepoint, creates nothing
during planning, and leaves compilation and execution to the shared module. Its 7 focused
structural/planning/integration tests include case filtering, one local failure beside a successful sibling,
and zero generic result-store
artifacts. At closure, the complete shared suite is 158/158 and the complete repository suite is 466/466.
That established the first adapter boundary.

BEX-402 is closed. `Get-LatexBatchJob` in that same module maps a caller-selected manifest projection to one
manifest-only latex-ingest process job per source-ready document. It pins the live dependency and explicit
child policy, preserves caller environment transport, assigns all run evidence, lane output, and optional
bundle output through the D19 resolver, and declares those application roots without creating them during
planning. Its 8 focused tests include invalid ownership/source inputs, deterministic cost planning, sibling
failure containment, and a live source-deposit-to-latex-ingest child run. At closure, the complete shared
suite is 158/158 and the complete repository suite is 474/474. That left cross-adapter thinness as the final
Phase 4 gate.

The two planners are public files under `src/adapters/`, backed by grouped private helpers and one manifest;
there is no PowerShell module per planner. The LaTeX planner, helper symbols, metadata, job IDs, address root,
and test filename consistently use `latex-batch` naming.

BEX-403 is closed. A cross-adapter AST gate proves production adapters call the executor only through
`New-BatchJob`; expose no execution-owner inputs; own no scheduler, private PowerShell host, process
lifecycle, cancellation, or parallel pipeline; and keep run allocation, retry, logger lifecycle, and durable
result machinery out of planner hosts. The existing single-resolver witnesses and strengthened runtime tests
also prove planning leaves the complete caller run untouched, every worker destination maps to a declared
write beneath that run, every produced file is covered by those writes, and generic execution results remain
in memory. Closure revalidation is 17/17 focused adapter, 6/6 infrastructure, and 158/158 shared tests; the
full repository run passed 474 tests with 2 dependency-gated skips (476 total). Phase 4 is closed.

BEX-208 is closed. Repository and active sibling-project code inventory found no live facade caller; only
the compatibility test consumed the legacy path or alias. The flat script is deleted, the equivalence test
is now an absence witness, and the manifest-backed four-command module remains behaviorally unchanged.
Revalidation is 8/8 module-surface, 8/8 batch-plan, 17/17 adapter, 6/6 infrastructure, and 158/158 shared;
the full repository run passed 474 tests with 2 dependency-gated skips (476 total).

Testing-overhaul scoping and BEX-501 are complete. The
[semantic inventory](testing-batchability-inventory.md) covers all 43 physical Pester files and 453 textual
`It` lines. Exact-path fresh-process runs selected 476 tests: 474 passed, 2 were explicitly skipped, and none
failed. Semantic review classifies 31 files as `Batchable`, 3 as `CapabilityGated`, 9 as `NeedsRefactor`,
and none as `SerialOnly`; it also records per-file timing, one direct LaTeX shared-write exposure, and one
conditional HDBSCAN fallback-build hazard. One physical
file/container in one fresh child process remains the default job boundary, and automatic `It`-level fan-out
is outside Phase 5. The [brief](../briefs/sol-pester-batch-testing-overhaul-20260805.md) defines ownership;
the [workplan](testing-overhaul-workplan.md) now proceeds with BEX-502 as the sole next ticket.

## Sequencing rules

1. Preserve the closed teardown gate through every adapter change.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Keep adapters thin: discovery and domain interpretation may emit jobs but never own executor resources.
4. Consume a caller-allocated `RunDirectory`; never allocate run identity or define a durable executor-result
   store inside an adapter.
5. Require a separate decision before changing the frozen public execution projection or deferred semantics.

## Phase 5 — Batch-ready Pester testing

Detailed scope, dependencies, and exit gates are in the
[testing-overhaul workplan](testing-overhaul-workplan.md).

- **BEX-502 — Freeze the batchable-container contract.** Codify exact-path, fresh-process, state/resource,
  capability, failure-containment, and a caller-run-scoped artifact root per container without imposing
  automatic `It`-level subdirectories.
- **BEX-503 — Harden the authoritative runner boundary.** Prove exact-container Pester 5/6 parity, native
  results, empty-run rejection, and nonzero failure propagation without adding scheduling or run ownership.
- **BEX-504 — Refactor and benchmark representative suites.** Validate the batch-executor files as a positive
  control and split the LaTeX-ingest suite only at real fixture, resource, capability, or cost seams.
- **BEX-505 — Correct the Pester adapter contract.** Atomically rename the planner to `Get-PesterBatchJob`,
  adopt `pester-batch`/`pester-jobs` naming, and retain one shared `adapters` module with no compatibility alias.
- **BEX-506 — Add a thin repository parallel-test shell.** Compose adapter, plan, and executor behind
  `tests/parallel.ps1` while rejecting duplicate scheduling, lifecycle, run, log, retry, and store ownership.
- **BEX-507 — Migrate and close.** Admit audited suites, keep owned serial exceptions explicit, add structural
  checks, prove sequential/parallel outcome parity, and reconcile architecture and user documentation.

Automatic `It`-block or parameter-row partitioning remains outside Phase 5 and requires separate evidence
and a new decision.

## Deferred semantic candidates

These are not implied by the module refactor and require separate decisions:

- retry and backoff policy;
- cooperative process-child cancellation, cleanup grace, parent-liveness lease, and hard-parent-death
  containment, scoped by the
  [deferred cancellation brief](../briefs/sol-batch-executor-cancellation-parent-liveness-deferred-20260805.md);
- detached or durable background execution;
- typed runtime-profile and process-spec constructors;
- dependency DAG or phase-barrier scheduling;
- fairness or priority classes beyond cost-biased queue order;
- persistent job/result stores and resume semantics;
- native non-PowerShell process entrypoints;
- a C# plan-model port;
- a public worker-budget preview command.
