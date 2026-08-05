# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); arguments and review evidence
live under [../discussions/](../discussions/). Do not leave completed work in this file.

## Current baseline — 2026-08-05

The executor is packaged under `src/shared/batch-executor/`. Its manifest exposes four commands; its root
module validates and reads four runtime payloads as source data, loads named host files in deterministic
order, and leaks no private helpers. The former flat implementation is now a compatibility facade that
imports the manifest and supplies only `Compile-BatchPlan -> New-BatchPlan`.

The behavioral and teardown gates remain closed: 21 executor, 7 private state-contract, 8 job/plan, and 8
module-surface tests pass, and the complete shared suite is 137 passing tests. The queued multi-item
host-stop witness closes the start/registration race and prevents queued supervisors from unwinding in
serial waves. The repository-wide path-topology suite is also green after BEX-207 removed post-eviction
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

- **BEX-302 — Extract pre-dispatch, execution-resource-free preparation.** Isolate worker/initializer
  validation, ID and mode normalization, process-spec resolution, context/item snapshots, worker-budget
  selection, policy reporting, session configuration, and all process payload serialization. Produce every
  dispatch-ready item before the first `BeginInvoke`; do not absorb plan compilation or dependency-DAG
  semantics.
- **BEX-303 — Bind one lifecycle owner and extract dispatch.** Construct mutable lifecycle state before the
  exported owner's outer `try`; assign partial pool and invocation handles incrementally so exceptional
  teardown always sees them. Preserve one pool, queue, budget, and registry across execution modes.
- **BEX-304 — Extract interruptible await/cancel as one unit.** Preserve 200 ms host-interruption
  checkpoints and the ordering of child-tree kill, immediate direct stop, bounded process-supervisor drain,
  and final batched pipeline stop.
- **BEX-305 — Extract result collection.** Preserve item-local failure containment, diagnostic-stream
  merging, the original caller `Input`, stable index ordering, and the exact public state/result fields.
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
