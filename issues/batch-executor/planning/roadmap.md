# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); arguments and review evidence
live under [../discussions/](../discussions/). Do not leave completed work in this file.

## Current baseline — 2026-08-05

The executor is packaged under `src/shared/batch-executor/`. Its manifest exposes four commands; its root
module validates and reads four runtime payloads as source data, loads named host files in deterministic
order, and leaks no private helpers. The former flat implementation is now a compatibility facade that
imports the manifest and supplies only `Compile-BatchPlan -> New-BatchPlan`.

The behavioral and teardown gates remain closed: 21 executor, 8 private state-contract, 5 preparation, 6
lifecycle-owner/dispatch, 2 await/cancel, 3 collection, 4 teardown/assembly, 8 job/plan, and 8
module-surface tests pass, and the complete shared suite is 158 passing tests. The queued multi-item
host-stop witness closes the start/registration race and prevents queued supervisors from
unwinding in serial waves. Preparation now completes all caller-graph traversal and serialization before
the pool opens. The repository-wide path-topology suite is also green after BEX-207 removed post-eviction
residue and rebuilt the check around required current inputs. Phases 2 and 3 are closed; the package
boundary, public execution projection, and compatibility facade remained stable through lifecycle
decomposition. Phase 4 is now the ahead queue.

## Sequencing rules

1. Preserve the closed teardown gate through every adapter change.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Keep adapters thin: discovery and domain interpretation may emit jobs but never own executor resources.
4. Consume a caller-allocated `RunDirectory`; never allocate run identity or define a durable executor-result
   store inside an adapter.
5. Keep compatibility explicit and temporary; new callers bind to the manifest.
6. Require a separate decision before changing the frozen public execution projection or deferred semantics.

## Phase 4 — Domain adapters

- **BEX-401 — Test adapter.** Accept caller-selected test cases or test files and an existing absolute
  `RunDirectory`; emit batch jobs with stable IDs, runtime dependencies, cost hints, and working directories.
  Derive every collision-free per-job runner-artifact address through one private pure resolver, declare
  every intended application write in `Writes`, and keep generic executor results in memory. Preserve
  caller-supplied logging and correlation inputs without selecting a logger sink topology. Do not allocate a
  run or invent a durable result schema. Add a structural witness that rejects competing path composition.
- **BEX-402 — Ingestion adapter.** Convert document inventory rows plus a caller-resolved `RunDirectory` into
  process or direct jobs with complete declared write sets, latex-ingest dependencies, child policy, and
  preserved caller correlation inputs. Reuse the D19 addressing handoff; do not implement logger lifecycle,
  run allocation, or generic result persistence.
- **BEX-403 — Validate adapter thinness.** Prove adapters may discover and interpret domain work but do not
  own pools, child registries, cancellation, retries, competing result-order rules, run allocation, logger
  lifecycle, or durable executor-result stores. Prove per-job path composition has one resolver and every
  intended application write is declared.

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
