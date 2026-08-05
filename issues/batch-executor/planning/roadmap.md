# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); arguments and review evidence
live under [../discussions/](../discussions/). Do not leave completed work in this file.

## Current baseline — 2026-08-05

The executor is packaged under `src/shared/batch-executor/`. Its manifest exposes four commands; its root
module validates and reads four runtime payloads as source data, loads named host files in deterministic
order, and leaks no private helpers. The former flat implementation is now a compatibility facade that
imports the manifest and supplies only `Compile-BatchPlan -> New-BatchPlan`.

The behavioral and teardown gates remain closed: 21 executor, 7 private state-contract, 5 preparation, 4
lifecycle-owner/dispatch, 2 await/cancel, 3 collection, 8 job/plan, and 8 module-surface tests pass, and the
complete shared suite is 151 passing tests. The queued multi-item host-stop witness closes the
start/registration race and prevents queued supervisors from
unwinding in serial waves. Preparation now completes all caller-graph traversal and serialization before
the pool opens. The repository-wide path-topology suite is also green after BEX-207 removed post-eviction
residue and rebuilt the check around required current inputs. Phase 2 is closed; Phase 3 is active with the
package boundary, public execution projection, and compatibility facade held stable.

## Sequencing rules

1. Preserve the closed teardown gate before and after every lifecycle move.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Separate host implementation from runtime payload source by directory and loading mechanism.
4. Extract the module mechanically before decomposing lifecycle phases.
5. Keep compatibility explicit and temporary; new callers bind to the manifest.
6. Keep domain adapters out until the shared contract and module surface are stable.

## Phase 3 — Internal lifecycle decomposition

- **BEX-306 — Extract teardown and final execution-record assembly.** Keep one lexical outer `try/finally` in
  `Invoke-BatchExecutor`; dispatchers dispose their own process records, the parent tears down children and
  supervising pipelines before the pool, and no private state or handle escapes.
- **BEX-307 — Close Phase 3.** Re-run process-tree, queued host-stop, failure-containment, stable-order,
  mixed-mode, and concurrency-pressure gates; reconcile the README, decisions, ledger, and ahead-only queue.

Accept each internal extraction only when its focused and adversarial gates pass. Keep the package boundary
and public execution projection stable, and require smaller functions to improve reviewability without
obscuring lifecycle order.

## Phase 4 — Domain adapters

- **BEX-401 — Test adapter.** Discover caller-selected test cases or test files and emit batch jobs with
  stable IDs, runtime dependencies, cost hints, working directories, and isolated result/log locations.
- **BEX-402 — Ingestion adapter.** Convert document inventory rows into process or direct jobs with complete
  declared write sets, latex-ingest dependencies, child policy, and run-log correlation.
- **BEX-403 — Validate adapter thinness.** Adapters may discover and interpret domain work but may not own
  pools, child registries, cancellation, retries, or competing result-order rules.

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
- a public worker-budget preview command;
- compatibility-facade removal.
