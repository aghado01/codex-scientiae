# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); arguments and review evidence
live under [../discussions/](../discussions/). Do not leave completed work in this file.

## Current baseline — 2026-08-05

The executor is packaged under `src/shared/batch-executor/`. Its manifest exposes four commands; its root
module validates and reads four runtime payloads as source data, loads named host files in deterministic
order, and leaks no private helpers. The former flat implementation is now a compatibility facade that
imports the manifest and supplies only `Compile-BatchPlan -> New-BatchPlan`.

The behavioral and teardown gates remain closed: 20 executor, 8 job/plan, and 8 module-surface tests pass,
and the complete shared suite is 129 passing tests. The repository-wide path-topology suite is also green
after BEX-207 removed post-eviction residue and rebuilt the check around required current inputs. Phase 2
is closed; Phase 3 may begin with the package boundary and compatibility facade held stable.

## Sequencing rules

1. Preserve the closed teardown gate before and after every lifecycle move.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Separate host implementation from runtime payload source by directory and loading mechanism.
4. Extract the module mechanically before decomposing lifecycle phases.
5. Keep compatibility explicit and temporary; new callers bind to the manifest.
6. Keep domain adapters out until the shared contract and module surface are stable.

## Phase 3 — Internal lifecycle decomposition

- **BEX-301 — Freeze phase-state contracts.** Define the private data passed between prepare/validate,
  dispatch, await/cancel, collect, and teardown without exposing mutable process ownership to callers.
- **BEX-302 — Extract pure preparation first.** Isolate ID/mode/spec normalization, dependency resolution,
  context snapshots, worker-budget selection, and policy reporting. Preserve parent-thread traversal of
  caller-owned objects.
- **BEX-303 — Extract dispatch and collection around one owner.** Keep the parent registry, runspace pool,
  and teardown ordering under one lifecycle owner. Do not create mode-specific schedulers.
- **BEX-304 — Re-run adversarial teardown and stress gates after every phase move.** A phase extraction is
  incomplete if process-tree, failure-containment, stable-order, or concurrency-pressure witnesses regress.

This phase is now authorized by the closed Phase 2 gate. Keep the package boundary stable, and accept each
internal extraction only when the smaller functions materially improve reviewability without obscuring
lifecycle order.

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
