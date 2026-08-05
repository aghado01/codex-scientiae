# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); arguments and review evidence
live under [../discussions/](../discussions/). Do not leave completed work in this file.

## Current baseline — 2026-08-04

Commit `080bac6` introduced `src/shared/batch-executor.ps1`, `batch-job-worker.ps1`, and their two Pester
suites as part of a larger blanket commit. The implementation provides one greedy runspace pool with
per-job direct/process mode, structured failure containment, parent-owned child-process cancellation,
plan compilation, cost-biased dispatch, original-order results, dependency and process-policy validation,
and declared write-set collision checks.

The current focused baseline is 26 passing batch tests: 18 executor tests and 8 job/plan tests. The shared
suite baseline is 119 passing tests. No production source consumer imports the executor yet; only the two
batch test files dot-source it. This is the low-risk window for packaging and public-surface correction.

## Sequencing rules

1. Lock down teardown before moving lifecycle code.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Separate host implementation from runtime payload source by directory and loading mechanism.
4. Extract the module mechanically before decomposing lifecycle phases.
5. Keep compatibility explicit and temporary; new callers bind to the manifest.
6. Keep domain adapters out until the shared contract and module surface are stable.

## Phase 1 — Teardown safety gate

- **BEX-101 — Establish a process-tree fixture.** Add a worker that records its child PowerShell PID,
  launches a long-lived grandchild, records the descendant PID, and remains alive long enough for the
  parent teardown path to act. Assertions must poll boundedly and verify both processes are gone.
- **BEX-102 — Prove token cancellation kills trees and suppresses queued launches.** Extend the existing
  cancellation witness from child-only checks to child-plus-descendant checks while preserving its bound
  that no more than `MaxWorkers` children start.
- **BEX-103 — Prove total-batch timeout kills trees.** Exercise `WaitTimeoutSeconds` with a longer child
  timeout, verify the item state and diagnostics, and assert zero surviving descendants.
- **BEX-104 — Prove per-child timeout kills trees.** Strengthen the existing `ProcessTimeoutSeconds` test
  to record and verify child and descendant termination.
- **BEX-105 — Prove hosting-pipeline stop runs exceptional teardown.** Invoke the executor in a separate
  PowerShell pipeline, wait until its child tree is live, stop the hosting pipeline, and verify the
  executor's `finally` leaves no descendants. Record literal console Ctrl+C as a manual Windows smoke,
  not a nondeterministic automated gate.

Exit gate: all lifecycle tests pass repeatedly, every created PID is absent after bounded teardown, no test
relies on natural child timeout, and the original 26 focused tests remain green.

## Phase 2 — Mechanical module extraction

- **BEX-201 — Create the deterministic module package.** Add `src/shared/batch-executor/` with manifest,
  root module, explicit ordered host-file loading, and module-scoped root/payload paths. Do not use wildcard
  dot-sourcing.
- **BEX-202 — Extract runtime payloads as source data.** Move direct dispatcher, process dispatcher, child
  bootstrap, and generic job worker under `payloads/`. Parse and read payloads as text; never execute them
  in host module scope. Missing or malformed payloads fail at import or plan construction with a precise
  path diagnostic.
- **BEX-203 — Separate public and private host functions mechanically.** Move function bodies without
  changing lifecycle sequencing. Keep `Invoke-BatchExecutor` intact during this phase.
- **BEX-204 — Correct and lock the public surface.** Export `New-BatchJob`, `New-BatchPlan`,
  `Invoke-BatchPlan`, and `Invoke-BatchExecutor`. Keep worker-budget resolution private and move its unit
  coverage into `InModuleScope`.
- **BEX-205 — Install the compatibility facade.** Replace the flat implementation with a manifest import
  and transitional `Compile-BatchPlan -> New-BatchPlan` alias. Add canonical-import, private-visibility,
  approved-verb, repeat-import, and facade compatibility tests.
- **BEX-206 — Publish the capability contract.** Add the module README covering job/plan schemas,
  execution modes, lifecycle states, cancellation, data isolation, result ordering, subprocess policy,
  logging correlation, and non-goals.

Exit gate: focused batch, module-surface, teardown, path-topology, and complete shared suites pass; importing
the manifest emits no unapproved-verb warning; no private helper leaks into caller scope; the compatibility
facade remains behaviorally equivalent.

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

This phase is not authorized merely by completing module extraction. Begin only when the package boundary
is stable and the smaller functions materially improve reviewability without obscuring lifecycle order.

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
- detached or durable background execution;
- typed runtime-profile and process-spec constructors;
- dependency DAG or phase-barrier scheduling;
- fairness or priority classes beyond cost-biased queue order;
- persistent job/result stores and resume semantics;
- native non-PowerShell process entrypoints;
- a C# plan-model port;
- a public worker-budget preview command;
- compatibility-facade removal.
