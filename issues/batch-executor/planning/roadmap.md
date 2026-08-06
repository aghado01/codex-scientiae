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

BEX-401 is closed. `Get-TestBatchJob` in the shared `adapters` module emits one exact-Pester, isolated process
job per selected test file, derives its native XML result through the D19 address chokepoint, creates nothing
during planning, and leaves compilation and execution to the shared module. Its 7 focused
structural/planning/integration
tests include case filtering, one local failure beside a successful sibling, and zero generic result-store
artifacts. At closure, the complete shared suite is 158/158 and the complete repository suite is 466/466.
That established the first adapter boundary.

BEX-402 is closed. `Get-LatexBatchJob` in that same module maps a caller-selected manifest projection to one
manifest-only latex-ingest process job per source-ready document. It pins the live dependency and explicit
child policy, preserves caller environment transport, assigns all run evidence, lane output, and optional
bundle output through the D19 resolver, and declares those application roots without creating them during
planning. Its 8 focused tests include invalid ownership/source inputs, deterministic cost planning, sibling
failure containment, and a live source-deposit-to-latex-ingest child run. At closure, the complete shared
suite is 158/158 and the complete repository suite is 474/474. Phase 4 now continues with the cross-adapter
thinness gate.

The two planners are public files under `src/adapters/`, backed by grouped private helpers and one manifest;
there is no PowerShell module per planner. The LaTeX planner, helper symbols, metadata, job IDs, address root,
and test filename consistently use `latex-batch` naming. Consolidation revalidation is 15/15 focused adapter,
6/6 infrastructure, and 158/158 shared tests; the full repository run passed 472 tests with 2 dependency-gated
skips (474 total).

## Sequencing rules

1. Preserve the closed teardown gate through every adapter change.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Keep adapters thin: discovery and domain interpretation may emit jobs but never own executor resources.
4. Consume a caller-allocated `RunDirectory`; never allocate run identity or define a durable executor-result
   store inside an adapter.
5. Keep compatibility explicit and temporary; new callers bind to the manifest.
6. Require a separate decision before changing the frozen public execution projection or deferred semantics.

## Phase 4 — Domain adapters

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
