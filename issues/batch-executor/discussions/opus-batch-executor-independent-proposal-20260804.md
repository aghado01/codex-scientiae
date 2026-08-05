Different lane, so let me lay out what's actually there before the opinions.

## Current state

`src/shared/batch-executor.ps1` — **1457 lines, 11 functions, one file**, plus a 60-line `batch-job-worker.ps1`. Tests: `batch-executor.Tests.ps1` (349) and `batch-plan.Tests.ps1` (182).

Two facts that shape everything below:

**The only consumers are those two test files.** Nothing in `src/` binds to it yet. Blast radius of a split is 2 dot-source lines. This is the cheapest moment this refactor will ever be — once the ingestion/gauntlet adapters bind, it isn't.

**The two-tier recon thesis has already been superseded.** The old framing was colonel = in-process pool, gauntlet-batch = process pool — two components. What actually got built is _one_ greedy scheduler where `Runspace` and `Process` are per-job modes sharing a single worker budget, with mixed mode as a first-class case. That's a better design, and it has a direct consequence for the split, below.

## The seams the code already found

The header doc already names the architecture: _"The execution kernel owns scheduling and lifecycle mechanics. The job/plan layer below it normalizes... Domain adapters still own discovery."_ Three layers, stated in prose, not yet realized in files. And inside `Invoke-BatchExecutor` (490 lines), the **stopwatch instrumentation has already discovered the phase decomposition** — `$swPool`, `$swDispatch`, `$swWait`, `$swCollect` bracket exactly the five phases, with ~210 lines of prepare/validate ahead of them and teardown in `finally`. The split lines are literally already annotated by `$timing.*`.

By line range the file is:

| lines     | ~size     | what                                                                                            |
| --------- | --------- | ----------------------------------------------------------------------------------------------- |
| 62–357    | 295 (20%) | two `$script:` here-strings — PowerShell **source-as-data** (direct dispatcher + child command) |
| 358–1010  | 650       | executor kernel — definition/budget/ISS/child-kill/`Invoke-BatchExecutor`                       |
| 1011–1457 | 445       | plan+job model — `New-BatchJob`, `Compile-BatchPlan`, `Invoke-BatchPlan`                        |

## Recommendations, ranked

**1. Split by phase, not by execution mode.** The tempting cut is runspace-file vs process-file. Resist it. The whole value proposition in your own header is that mixed mode shares one greedy budget — splitting by mode either duplicates the scheduler or forces a shared-base shape, and it re-creates the two parallel semantic paths D27 just spent a chip eliminating in doccer. Cut prepare → dispatch → await → collect → teardown; mode stays a parameter each phase reads.

**2. Extract the embedded dispatcher source first — it's nearly free.** 20% of the file is PowerShell source held as string literals that never run in host scope. Moving them to real `.ps1` files bought you highlighting, linting, and independent testability. Consistency bonus: `Get-BatchExecutorScriptDefinition` already enforces _"must begin with a top-level param(...) block"_ ([:380](src/shared/batch-executor.ps1:380)) — dispatchers would enter through the same door as caller workers. Precondition: fail loudly on a missing file, the way `Compile-BatchPlan` already does for `batch-job-worker.ps1`.

**3. Make the plan layer genuinely runspace-blind.** `Compile-BatchPlan` is 270 lines of pure validation/normalization returning a frozen object — no pool dependency, and your tests already split along this line. It's the piece most likely to be reused and most likely to want a C# port later. But it currently _half_-knows about execution: it does `Join-Path $PSScriptRoot 'batch-job-worker.ps1'` and validates `IssPreset ∈ {Bare,Core,Full}`. Those are the two leaks to close during the split — the worker path is an executor concern _injected into_ the plan, not discovered by it. If you fix nothing else about the boundary, fix that one, because it's what decides whether the plan layer is portable.

**4. Cancellation/teardown becomes a component with its own adversarial tests, before anything else moves.** The process registry + `Stop-BatchExecutorChildProcesses` + the `finally` block must be simultaneously correct under Ctrl+C, timeout, and exception unwind. It's the highest-risk code in the file and the one place a split breaks things _silently_ — an orphan-kill that no longer fires because the registry changed scope leaves stray `pwsh` trees and nothing fails red. Test it first, move it second.

**5. Keep `batch-executor.ps1` as a thin facade.** Have it dot-source the components and preserve the current call surface exactly. Both test files then keep passing unchanged through every step, so the split is green the whole way. There's no manifest or `Export-ModuleMember` today — the facade is what stops "dot-source and hope" from becoming "dot-source N files in the right order and hope."

**6. Mint the planning canon while you're splitting.** doccer, latex-ingest, and loggers each have `planning/{decisions,roadmap,ledger}`. This lane — a 1457-line concurrency kernel — has none; it's referenced only from a loggers discussion. The split _is_ a decision sequence worth recording: phase-not-mode, plan-layer independence, dispatchers-as-files, and the "one greedy budget across mixed mode" invariant that must survive the refactor. That last one especially — it's the property most likely to be quietly lost and hardest to notice afterward.
