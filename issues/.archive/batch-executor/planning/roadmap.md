# Batch executor — roadmap (ahead only)

Living plan for batch-executor work not yet complete. The current architecture contract is
[decisions.md](decisions.md); completed work moves to [ledger.md](ledger.md); the testing tranche has a
[completed Pester workplan](testing-overhaul-workplan.md) and [completed pytest workplan](pytest-testing-workplan.md);
arguments, briefs, and review evidence live under
[../discussions/](../discussions/) and [../briefs/](../briefs/). Do not leave completed work in this file.

## Current baseline — Pester closure 2026-08-06; pytest closure 2026-08-08

The executor is packaged under `src/batch-executor/`. Its manifest exposes four commands; its root
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
validation, compatibility removal, and the Pester testing overhaul. Phases 2 through 5 are closed; this
ahead-only file now contains only deferred semantic candidates.

BEX-401 is closed. The planner introduced there under the then-current `Get-TestBatchJob` name (renamed
`Get-PesterBatchJob` by BEX-505) emits one exact-Pester, isolated process job per selected test file, derives
its native XML result through the D19 address chokepoint, creates nothing during planning, and leaves
compilation and execution to the shared module. Its 7 focused
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

The three planners are public files under `src/batch-adapters/`, backed by grouped private helpers and one
manifest; there is no PowerShell module per planner. Pester, pytest, and LaTeX planner symbols, metadata,
job IDs, address roots, and test filenames retain their framework/domain naming.

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

Testing-overhaul scoping and BEX-501 through BEX-507 are complete. The
[semantic inventory](testing-batchability-inventory.md) covers all 43 physical Pester files and 453 textual
`It` lines. Exact-path fresh-process runs selected 476 tests: 474 passed, 2 were explicitly skipped, and none
failed. Semantic review classifies 31 files as `Batchable`, 3 as `CapabilityGated`, 9 as `NeedsRefactor`,
and none as `SerialOnly`; it also records per-file timing, one direct LaTeX shared-write exposure, and one
conditional HDBSCAN fallback-build hazard. One physical file/container in one fresh child process remains
the default job boundary. The canonical [`tests/README.md`](../../../tests/README.md) authoring contract and
D23 now require exact-path independence, bounded state/resource cleanup, explicit capability outcomes, and
one declared caller-run-scoped artifact root per container while leaving topology below that root suite-owned.
The runner audit leaves the 43-file topology and classifications unchanged, resolves one exact path into one
explicit container, and emits a transient audit observation before failure propagation. Pester 5.7.1 and
6.0.0 witnesses establish equivalent selected outcomes, native XML, empty/failure status, and nested-child
diagnostics without adding scheduling, run, log, retry, or store ownership. The three new contract tests and
six embedded fixture lines bring the post-BEX-503 mechanical count to 462 textual `It` lines; that
authoritative repository gate was 477 passed plus 2 dependency-gated skips (479 total), with 20/20 adapter
and 6/6 infrastructure gates. Automatic `It`-level fan-out remains outside the implemented tranche. The
[brief](../briefs/sol-pester-batch-testing-overhaul-20260805.md) defines ownership; the
[workplan](testing-overhaul-workplan.md) records the completed sequence.

BEX-504 left the eight-file/57-test batch-executor positive control intact: one worker and four workers
produced identical observations and eight native results with no undeclared files or surviving runners;
wall time changed from 46.724 s to 21.394 s (2.184x), with the 21-test process/lifecycle file remaining the
bounded critical path. The 66-test LaTeX control now has one real physical seam: 60 pure/converter tests in
`latex-ingest.Tests.ps1` and 6 capability-gated external-process/run-artifact tests in
`latex-ingest-integration.Tests.ps1`. One worker and two workers preserved 66/66 outcomes and two native
results with no repository-run residue, undeclared files, or surviving descendants; wall time changed from
19.545 s to 10.275 s (1.902x). The integration container accepts an absolute
`CODEX_TEST_ARTIFACT_ROOT` and owns six domain case roots below it; direct runs use `$TestDrive`. The
post-BEX-504 topology/classification was 44 files: 32 `Batchable`, 4 `CapabilityGated`, 8 `NeedsRefactor`,
and no `SerialOnly`; the textual and observed totals remain 462 and 479.

BEX-505 is closed. `Get-PesterBatchJob` is the sole Pester planner export from the shared `adapters` module;
there is no compatibility alias or unitary submodule. It emits one job per selected physical file with
stable `pester:<repository-relative-path>#<digest>` identity. One resolver owns
`RunDirectory/pester-jobs/<container>/pester.xml` and its sibling `artifacts/` root; both addresses are
declared in `Writes`, and `ProcessSpec.Environment` transports the absolute artifact root as
`CODEX_TEST_ARTIFACT_ROOT`. Planning creates neither address. BEX-506 composes that boundary without
acquiring adapter or executor ownership.

BEX-506 is closed. `tests/parallel.ps1` imports the canonical adapter and executor manifests, accepts
caller-selected paths plus a mandatory existing `RunDirectory`, and calls module-qualified
`Get-PesterBatchJob` -> `New-BatchPlan` -> `Invoke-BatchPlan` exactly once. Path selection proved sufficient,
so it adds no workload profile. The shell emits one concise Information summary and the exact in-memory
execution record, then throws after output when a job is non-successful or infrastructure errors exist;
direct `pwsh -File` use is therefore nonzero without losing sibling evidence. Its 3/3 focused witnesses
cover ownership structure, two-file success with native/container artifacts, sibling failure, real CLI
status, and process cleanup. D24 rejects scheduler, lifecycle, run, logger, retry, store, ordering, and
address ownership in the shell. Its `Batchable` test container brings the post-BEX-506 inventory to 45 files
and 469 textual `It` lines. Closure validation is 3/3 focused shell, 23/23 complete adapter, 6/6
infrastructure, and 158/158 shared tests. The complete sequential repository gate selected 482 tests: 480
passed, 2 were dependency-gated skips, and none failed.

BEX-507 and Phase 5 are closed. The eight remaining suites now isolate external capabilities, fixture
state, native-process status/streams, and retained writes. The final inventory is 45 physical files and 471
textual `It` blocks: 35 `Batchable`, 10 `CapabilityGated`, 0 `NeedsRefactor`, and 0 `SerialOnly`, with 484
observed tests. The final Pester 6 sequential run completed in 111.988 seconds with 482 passes, 2 explicit
skips, and no failure. A four-worker full-repository run completed all 45 jobs in 108.007 seconds with 482
passes, 2 explicit skips, no failed/timed-out/cancelled job or infrastructure error, 45 native results, 143
produced files all covered by declared writes, no missing result, and no surviving worker. The HDBSCAN symptom
was native stderr plus a deliberately nonzero final CLI status leaking past nine passing assertions, not a
LaTeX/HDBSCAN shared-path collision; local capture/status ownership and the assigned
`artifacts/hdbscan-cli` subtree repair that boundary. Completed Phase 5 implementation and evidence live in
the [ledger](ledger.md), [inventory](testing-batchability-inventory.md), and workplan, leaving no active
Pester-overhaul item in this ahead-only roadmap.

## Sequencing rules

1. Preserve the closed teardown gate through every adapter change.
2. Preserve one scheduler and one budget; never split implementation by execution mode.
3. Keep adapters thin: discovery and domain interpretation may emit jobs but never own executor resources.
4. Consume a caller-allocated `RunDirectory`; never allocate run identity or define a durable executor-result
   store inside an adapter.
5. Require a separate decision before changing the frozen public execution projection or deferred semantics.
6. Preserve the complete exact-file admission gate; any future finer-grained scheduling requires separate
   evidence and a new decision.
7. Keep Pester and pytest selection, runner, observation, and native-result semantics framework-owned when
   their jobs share one plan.

## Deferred semantic candidates

- Map or retire the four historical Pester JSONL containers after identifying any unique
  PowerShell-front-end coverage. This archaeology is separate from the completed pytest admission.

These are not implied by the module refactor and require separate decisions:

- automatic `It`-block or parameter-row partitioning;
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
