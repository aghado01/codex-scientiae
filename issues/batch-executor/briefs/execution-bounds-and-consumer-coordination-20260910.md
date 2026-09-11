# Batch executor — PowerShell 7.5 modernization, execution bounds and consumer coordination

Date: 2026-09-10. Status: B0–B4 implemented and qualified on the 7.6.4 host plus a 7.5.5 child; C1–C2 unselected. The user selected a PowerShell 7.5 minimum and modernization of the implementation, while retaining behavioral contracts. C1–C2 are conditional extensions, not prerequisites for ordinary isolated jobs.

Companions: aipithicus-issues `LaTeXAI/briefs/08-development-infrastructure.md` (I1–I4), and science-facility `issues/pwsh-exec/briefs/execution-lifecycle-and-results-20260910.md` (P1–P4). `CDXSCI_ROOT` is the consumer's local checkout setting. Machine locations stay in environment/local configuration.

## 1. Outcome and ownership

A finite process batch must stop within its execution and cleanup budgets, preserve completed siblings and partial diagnostics, and report what was actually stopped. LaTeXAI cannot obtain this solely by adding timers to its caller, and the MCP cannot recover output that a worker has not emitted. Improve the shared executor once and qualify the existing Pester, pytest and inventory consumers with it.

| Owner | Responsibility |
| :--- | :--- |
| LaTeXAI scripts | Local configuration, driver/package selections, workload-specific finite defaults, native Perl reports and conversion semantics |
| CDXSCI adapters and callers | Discover jobs, freeze identity and arguments, assign output/temp addresses and declared writes, interpret framework/article evidence |
| `src/batch-executor/` | One scheduling queue and worker budget, process ownership, execution deadlines, bounded capture/cleanup, stable per-job execution results |
| `pwsh_exec` | One outer invocation, its client/request budget, process containment and stream/result delivery; no CDXSCI import or domain parser |

Keep `New-BatchJob`, `New-BatchPlan`, `Invoke-BatchPlan` and `Invoke-BatchExecutor` as the public entrypoints. Preserve cost-descending dispatch, original-order results, isolated item failures and declared-write validation. Do not add another scheduler, automatic retries, a persistent queue or a framework-specific executor.

The selected baseline is PowerShell **7.5 or newer** for the executor and its batch clients. Controlled newer installations remain the normal runtime; a minimum does not replace or downgrade an exact installation. Compatibility with 7.0/7.2/7.4 is not a design requirement. Modernize any concrete dependency that obstructs this lane rather than retaining a legacy execution path. Raising declarations alone is not completion: B0 selects the internal changes implemented through B1–B3.

## 2. Source baseline and concrete gaps

Inspected CDXSCI `4d7a0beb`. Unrelated deposit/inventory changes were present; refresh source and active ownership before implementation. No historical pass count is a current verification result. The older `issues/batch-executor` planning corpus was archived by `8db60563`; this is a new brief, not a restoration of that ledger. Some test-README links still name the archived paths.

| Source | Observation requiring coordination |
| :--- | :--- |
| [Invoke-BatchExecutor.ps1](../../../src/batch-executor/public/Invoke-BatchExecutor.ps1), [executor-await.ps1](../../../src/batch-executor/private/executor-await.ps1) | `TotalMs` starts before preparation, but `WaitTimeoutSeconds` starts only in await, after preparation, pool opening and submissions. |
| [process-dispatcher.payload.ps1](../../../src/batch-executor/payloads/process-dispatcher.payload.ps1) | The child timer starts after process launch and synchronous stdin transfer. Cancellation/timeout then calls parameterless `WaitForExit()`; stream tasks are consumed with unbounded `GetResult()`. |
| [process-lifecycle.ps1](../../../src/batch-executor/private/process-lifecycle.ps1), [executor-dispatch.ps1](../../../src/batch-executor/private/executor-dispatch.ps1) | Stop requests are submitted together, but `EndStop` and some disposal paths can block. Batched stop submission is useful and should be retained. |
| [executor-collection.ps1](../../../src/batch-executor/private/executor-collection.ps1), [executor-teardown.ps1](../../../src/batch-executor/private/executor-teardown.ps1) | Collection has a synchronous `Stop` fallback; pool close/disposal have no deadline. Final projection requires a closed lifecycle, so an incomplete teardown can throw before consumers receive collected results. |
| [process-dispatcher.payload.ps1](../../../src/batch-executor/payloads/process-dispatcher.payload.ps1) | Dispatcher cleanup removes its registry entry after attempted termination even without confirmed exit. An empty registry alone does not prove cleanup, particularly for descendants. |
| [child-bootstrap.payload.ps1](../../../src/batch-executor/payloads/child-bootstrap.payload.ps1) | PowerShell events are accumulated in `$events` and another output list, then serialized into one final CLIXML marker. The parent also buffers entire stdout/stderr. Ordinary pipeline output is not continuously available to an outer MCP capture. |
| [tests/parallel.ps1](../../../tests/parallel.ps1), [batch-runner.ps1](../../../src/batch-runner.ps1) | Both consume the executor result only after it returns. The inventory caller writes its aggregate at the end; new failure/partial-result contracts must reach these callers. |

These are source observations of gaps in a strict bound and partial-evidence contract, not reports of newly reproduced hangs. Existing cancellation, timeout, host-stop and lifecycle tests remain valuable regression coverage.

## 3. B0 — Modern runtime and internal implementation

Source proposal: aipithicus-issues `LaTeXAI/notes/gemini-pwsh-modernization.md`, preserved as a discussion record. The following source-reviewed decisions govern implementation; its zero-overhead, blanket performance and automatic JSON-rewrite claims are not accepted measurements.

### Baseline and client closure

Update `PowerShellVersion` in `batch-executor.psd1` and `batch-adapters/adapters.psd1`, module `#requires` declarations, `src/batch-runner.ps1`, the batch/test launchers and framework worker entrypoints, and their affected test fixtures/documentation to 7.5. Replace the inventory caller's major-version-only guard with the same full-version floor. LaTeXAI's migrated scripts, profile and worker entrypoints follow this policy through I1. Preserve independent APIs in unrelated shared utilities; a lower declared minimum there is not itself an obsolete-runtime dependency.

Validate both the executing host and every selected child PowerShell installation. A 7.6 MCP host can still be configured to spawn an older child through `ProcessSpec.PowerShellPath`. Perform any necessary child-version probe once per distinct executable identity under a bounded preflight, before workload code, and validate the child bootstrap before it uses modern APIs. Do not infer the child version from the parent's `$PSVersionTable`, a filename, or a successful module parse. Direct-runspace payloads whose bodies are registered as functions require the host/module gate too; copying a `#requires` comment into a function body is not enforcement.

Record resolved executable identity, PowerShell version and .NET framework description in local run evidence. [Microsoft's runtime mapping](https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle) places PowerShell 7.5 on .NET 9 and 7.6 on .NET 10. The inspected MCP bundle's file metadata reports 7.6.4 and its runtime configuration specifies .NET 10.0.10; no executable was launched to establish this. APIs used by this implementation must be available at the 7.5 minimum, even when development uses 7.6. Do not add runtime branches solely to support older LTS releases.

### Affordances and source corrections

| Affordance | Application and limit |
| :--- | :--- |
| Task-based process completion | Use [Process.WaitForExitAsync](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.waitforexitasync?view=net-9.0) with deadline/caller cancellation in B1. It cancels the wait; B2 still owns termination and confirmed cleanup. It is available below the selected floor, not a 7.5-exclusive API. |
| SDK task invocation | Prefer [PowerShell.InvokeAsync](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.powershell.invokeasync?view=powershellsdk-7.4.0) and the SDK stop task where they simplify the current APM handles. Close input collections, own output buffers, and observe every completion. Keep the public synchronous batch result. |
| Linked cancellation and task deadlines | [CancelAfter](https://learn.microsoft.com/en-us/dotnet/api/system.threading.cancellationtokensource.cancelafter?view=net-9.0) and [Task.WaitAsync](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.task.waitasync?view=net-9.0) support B1's timed waits. Neither cancels an arbitrary underlying operation. Keep caller cancellation, execution expiry and cleanup expiry distinguishable; dispose owned token sources and registrations. These primitives predate 7.5. |
| Completion composition | Use task completion signals and [WhenAll](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.task.whenall?view=net-9.0), with an incremental completion path when B3 needs it. The existing await loop does not serialize worker execution or impose a fixed 200 ms completion delay; workers already run concurrently. A failed task must remain an item result rather than abort successful siblings. |
| Bounded event transfer | A private .NET helper may use [bounded channels](https://learn.microsoft.com/en-us/dotnet/api/system.threading.channels.boundedchannelfullmode?view=net-9.0) for B3. Bound bytes/frame sizes as well as item count. Awaiting capacity needs cancellation; dropping diagnostic/result events is not an acceptable implicit overflow policy. |
| `clean { }` | Available since 7.3 and useful for resources spanning pipeline `begin/process/end`. It handles pipeline stop and discards success-stream output; it does not establish cleanup after OS process termination. Preserve the current lexical `try/finally` lifecycle owner unless a concrete pipeline helper benefits from `clean`. Never publish the final batch result from it. [Semantics](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7.5). |
| Object-array `+=` | The real 7.5 optimization in [PR 23901](https://github.com/PowerShell/PowerShell/pull/23901) reduces overhead, but [the 7.5.0 implementation](https://raw.githubusercontent.com/PowerShell/PowerShell/v7.5.0/src/System.Management.Automation/engine/runtime/Operations/ArrayOps.cs) still calls `Array.Resize` for scalar append. It is not a capacity-backed growable array or an amortized O(1) append guarantee. Retain preallocated result slots and useful typed lists; allow simple bounded collectors where measured/readable. Do not attribute local costs to AMSI/Defender without evidence. |
| JSON handling | The [7.5 source](https://raw.githubusercontent.com/PowerShell/PowerShell/v7.5.0/src/Microsoft.PowerShell.Commands.Utility/commands/utility/WebCmdlet/JsonObject.cs) still uses Newtonsoft.Json. No automatic System.Text.Json/source-generation migration or 2–3x speed claim follows from the floor. Preserve CLIXML's object semantics across the process boundary; changing transport framing does not authorize replacing it with JSON. |
| Timestamp-string preservation | [ConvertFrom-Json -DateKind String](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.5) is a 7.5 addition. Use it where the receipt/inventory contract calls for strings to round-trip; explicitly parse timestamps only for calculations. Audit reader expectations before changing existing conversions. |

Retain the existing queue, mixed execution modes, data-isolation policies and result ordering. `ForEach-Object -Parallel` can run code that launches processes, but it does not supply these executor contracts; switching to it would require rebuilding the ownership/planning layer. It is not the modernization selected here. Nor is the present engine presumed maximally efficient just because it uses typed lists and preallocated arrays.

### Host-aware asynchronous implementation

A PowerShell call to `.GetAwaiter().GetResult()` still blocks the calling thread. The note's proposed one-line replacement can lose the interpreter checkpoints deliberately preserved by the existing waits. Move event-driven coordination into a small private .NET helper where necessary, with a host-aware stop bridge and owned cancellation; do not merely wrap blocking PowerShell in `Task.Run`. Keep any remaining host checkpoint centralized and explain its purpose rather than promising zero polling everywhere. A compiled helper must target the minimum runtime and have repository-owned source/build inputs; avoid compiling it separately for every job and include its loading/build cost in measurements.

Do not run arbitrary PowerShell scriptblock delegates on callback/thread-pool threads. The [SDK callback documentation](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.powershell.begininvoke?view=powershellsdk-7.4.0) explicitly warns that such a callback may have no default runspace. Use .NET callbacks for signals/data transfer and the owning PowerShell context for script execution. `PSDataCollection` is an output buffer, not an automatic memory bound. Exceptions, partial output and cleanup ownership must survive the change from APM handles to tasks.

Retain monotonic deadlines alongside timer tokens. Preserve zero's existing unlimited meaning where supported instead of passing zero to `CancelAfter`; handle supported timer ranges and simultaneous cancellation/timeout deterministically. Re-arming a timer at each phase must not restart the full budget. `TimeProvider`-aware task waits can support deterministic deadline tests in the private helper, while real-process tests still establish actual containment and host-stop behavior.

### B0 acceptance

- Host/child runtime admission agrees at 7.5+, rejects an older selection before workload side effects, and records the actual selected runtime. Qualification covers a 7.5 installation and the normal controlled 7.6 installation; missing floor coverage is disclosed, not replaced by a 7.6-only pass.
- Public names, argument rules, input/reference isolation, original-order results, skips/native outcomes, stream distinctions and item-failure isolation remain equivalent. B1–B3's separately specified policy/transport additions remain explicit contract changes; the modernization itself must not smuggle in new domain semantics.
- Update internal shape/AST assertions that specifically name `AsyncResult`, `WaitAny`, `EndInvoke` or fixed polling fields when those details change. Preserve behavioral cancellation/cleanup tests and extend thin-adapter checks to newer execution APIs such as `InvokeAsync`/`StopAsync`, so modernization does not move scheduling into an adapter.
- Compare the old internals and modern internals under the same controlled runtime before attributing gains to the refactor. Separately compare runtime versions using identical code. Use no-op/short and representative native jobs, one and multiple workers, output pressure, cancellation and repeated runs; report wall time, measured CPU, allocation/peak memory and responsiveness. No zero-overhead or minimum speedup assertion is adopted.

## 4. B1 — Deadline scopes and admission

Add an explicit executor-duration budget and a cleanup allowance, provisionally named `ExecutionTimeoutSeconds` and `CleanupTimeoutSeconds`, threaded through both invocation entrypoints and resolved policy. Keep the existing await-only meaning of `WaitTimeoutSeconds`; do not silently redefine it. Routine project callers select the executor-duration budget. If both execution and await limits are supplied, the earlier applicable deadline wins. Review the final public parameter/record changes together before implementation.

The executor budget begins at executor admission and includes preparation, pool opening, submission, waiting and collection. A job's process budget begins before its launch attempt and includes stdin transfer, initialization and worker execution; queue residence is separately observable and remains subject to the batch deadline. Retain `ProcessSpec.TimeoutSeconds` over the invocation's `ProcessTimeoutSeconds` default. Record requested/effective limits and the phase and deadline that caused a stop. Workload defaults belong to callers; the reusable library need not impose a LaTeXAI-specific duration on unrelated consumers.

Use monotonic elapsed time within each owning process. Do not reset a full allowance at each phase, or multiply a cleanup allowance by the number of jobs. At a batch stop, close admission, stop active work together, and spend one bounded batch cleanup allowance. Per-job cleanup while siblings continue also needs a bound. Preparation and caller work are distinct: inventory discovery, `New-BatchPlan`, preflight and final receipt aggregation outside executor admission remain under the project/MCP envelope.

Replace blocking setup, stdin, wait, drain and stop operations with supervised operations that can observe the remaining allowance. A cancellation token or a timeout around a blocking call is not proof that the call stopped. Identify unavoidable uninterruptible operations and their containing process owner. Strict forced-stop guarantees apply to qualified `PowerShellProcess` execution; direct `RunspaceScript` remains cooperative unless separately isolated. Do not claim hard cancellation for arbitrary in-process code or silently convert its mode.

Record whether each planned job was submitted, started, completed or never started. Preserve existing terminal states where adequate and add explicit start/stop-reason observations; absent process identity must not imply a completed job. Keep one result slot per planned job, including pending jobs at cancellation. Report preparation, queue, child lifetime, capture and cleanup timings only at witnessed boundaries, alongside existing phase timing; nested durations are not CPU time.

## 5. B2 — Process ownership and truthful cleanup

Maintain the single lifecycle owner and publish handles before control can unwind. Preserve the start/registration race checks and batched pipeline-stop ordering. Qualify containment for the worker and native descendants when cancellation intersects startup, when the immediate worker exits first, and when outer supervision stops the executor host. A sweep of current worker PIDs and `Kill(true)` calls is insufficient evidence by itself.

Select and test an OS-supported containment mechanism for the supported Windows runtime, including nested ownership under the MCP supervisor. Establish ownership before workload code can create unowned descendants. Keep natural exit, termination requested, confirmed exit, drain completion and cleanup failure as separate observations. Preserve process identity/handle evidence until the owner has confirmed release; removing a dictionary entry must not manufacture successful teardown. Never terminate unrelated processes by executable name or broad PID enumeration.

Bound post-kill waits, task drainage, `EndStop`, pool close and disposal paths. Enter `Closed` only after confirmed release. If cleanup cannot be confirmed within the allowance, return or durably expose an explicit incomplete-cleanup outcome and the already collected job results through a documented failure contract. Do not call the lifecycle closed, detach forgotten handles, or block forever merely to produce a nominally successful record. The containing host's owner must have enough identity/evidence to complete or report recovery. Keep any recovery inside the owned process boundary; this is not a background job service.

The current child receives no operative cross-process cancellation token. Keep parent-enforced cancellation as the initial mechanism; a serialized token is not a cancellation channel. Cooperative child IPC is optional only if a demonstrated consumer needs graceful finalization. Hard-parent-death containment is part of the joined MCP/CDXSCI qualification if the outer MCP can forcibly terminate the executor host. Test it explicitly; a normal PowerShell host-stop test does not establish that result.

## 6. B3 — Bounded transport and partial evidence

Capture at both boundaries: worker-to-executor and executor-to-caller. Changing only the parent's `ReadToEndAsync` does not make the child's `$events = @(... *>&1)` incremental. Replace whole-job event accumulation with a bounded incremental transport, preserving structured success objects and distinct error/warning/diagnostic streams. Use an owner-created control channel for protocol events/final objects, keeping arbitrary raw stdout/stderr separate. Bound frame size and retained object count/serialized bytes as well as text streams; serialization depth alone is not a size limit.

Expose small inline results plus references to optional caller-owned durable evidence. Stream partial data to those destinations during execution. Adapters reserve collision-free evidence paths in their job addressing and declare the writes; the executor must not guess a repository/global artifact root or collect the whole inherited environment. Reuse existing serialization/logging primitives where their contracts fit. Keep domain XML/TAP/JUnit and article receipts under their existing owners rather than copying them into a second report hierarchy.

Define finite memory and durable-output limits with byte counts, truncation and capture-completeness observations. Keep draining or stop explicitly at a limit, so a full pipe cannot deadlock a worker. A descendant holding a pipe open after its parent exits must consume only the remaining drain allowance. Preserve raw bytes when display decoding is lossy. Treat protocol failure, capture failure and native failure separately; none can be hidden by a zero exit code.

Version producer/consumer transport together. Preserve intentional `exit` callers with an explicitly identified native-exit result path; retain the distinction from a valid structured result. A malformed or truncated protocol record is not the legitimate no-record fallback. Do not scan arbitrary output for a marker and silently reinterpret a user's marker-like line as control data. Keep small structured `Output` values usable by existing callers; large output requires an explicit artifact/limit policy rather than silent truncation of a semantic return value.

On interruption, retain partial streams, completed siblings, planned-job identity and cleanup observations even if a final success envelope cannot be produced. A forced host kill cannot reliably execute `finally`, so failure evidence must not depend on end-of-run flushing. The exception/result contract must carry partial execution evidence without embedding live handles or falsely reporting completion.

## 7. B4 — Consumer migration and joined qualification

Update the public result projection and exact-shape tests intentionally. Required additions cover deadline cause/effective policy, observed start state, capture completeness/artifact identity and cleanup outcome. Review how empty batches, item failures, cancellation and infrastructure exceptions project before changing the schema. Keep successful siblings and original plan ordering. Do not infer framework/article success from executor success.

Thread the selected limits and capture addresses through `tests/batch.ps1` / `tests/parallel.ps1`, the Pester/pytest adapters, `src/batch-runner.ps1` and the inventory adapter. Keep the test shell thin. Ensure callers can emit/persist partial executor evidence before signalling failure, including incomplete teardown; normal post-return aggregation is not sufficient on that path. Record the planned selection before dispatch so a missing terminal record is visibly incomplete. Preserve framework-native reports, inventory receipt identities, and the distinct meanings of job counts and article/test outcomes.

LaTeXAI I1 can independently finish migrating tracked scripts and local configuration against the existing shared interfaces, adopting the selected 7.5 floor locally without waiting for B0–B4 or MCP implementation. Coordinate moved paths and profile reloads with active consumers; reserve new execution parameters, output contracts and native-process helpers for I3 integration. I2 can develop the TAP adapter against isolated jobs, but its final interrupted-output qualification and I3's end-to-end closure depend on B0–B4. No shared TAP adapter, native Perl job kind or executor framework discovery is required for the initial one-driver-per-job implementation.

The MCP stays independent of CDXSCI. Join their tests through a bounded fixture batch launched by the supported MCP, with an outer budget that leaves time for executor cleanup and caller finalization. Correlate invocation, plan, job and artifact identities using existing records. Confirm that an outer timeout/cancellation retains evidence and contains descendants; do not mark either component's end-to-end claim complete solely from its unit tests. Changing the client request timeout remains the MCP/client workstream.

## 8. Conditional adapter extensions

| Slice | Trigger and ownership |
| :--- | :--- |
| C1 — Coalesced jobs | Select only when I4 measurements show meaningful wrapper overhead. Grouping belongs in the adapter; retain one executor job per chunk, individual member identities/results, fresh Perl per member, per-member and chunk budgets, and explicit interrupted/not-started members. The inventory caller currently assumes one job/one article receipt, so change its mapping and aggregation together. Keep job and article totals separate, preserve individual retry selection, and do not add automatic replay. Pester/pytest remain file-isolated unless their own evidence supports a separate change. |
| C2 — External ephemeral storage | Select only after an I/O/storage experiment warrants it. Extend `src/infrastructure/containment.ps1` and adapter addressing deliberately: an explicit ephemeral-root input, resolved containment, unique job addresses, declared writes, environment projection and owned cleanup. Current workers derive `CDXSCI_TEMP` and `TEMP`/`TMP`/`TMPDIR` from their assigned run, so an ambient variable is not this feature. Durable results stay in the admitted artifact run. Machine locations remain local data with the `CDXSCI` prefix. No junction workaround or host provisioning inside the executor. |

Neither extension requires changing the executor's cost-descending queue. Measured costs can already populate `EstimatedCost`; `MinItemsPerWorker` adjusts concurrency rather than bundling. Resolve current write collisions by grouping or ordered phases. An exclusive-resource scheduler, resident Perl engine and persistent PowerShell workers remain separate proposals requiring concrete consumers and evidence.

## 9. Implementation sequence and acceptance

| Slice | Initial status | Completion evidence |
| :--- | :--- | :--- |
| B0 | Implemented; 7.5 child + 7.6 host qualified | Consistent 7.5 admission, native helper, preserved contracts. Pipeline APM retained after InvokeAsync deadlock. No comparative perf report. |
| B1 | Implemented | Explicit budget scopes, admission/start observations and bounded phase operations |
| B2 | Implemented; MCP host-kill fixture not run | Job-object ownership, worker-exits-first, bounded cleanup, incomplete-cleanup projection |
| B3 | Implemented | Control-pipe protocol, bounded streams/objects, native-exit vs malformed, partial evidence fields |
| B4 | Consumers migrated; MCP join remaining | Pester/pytest/inventory callers persist executor-execution.json; TAP/MCP join not in this chip |
| C1–C2 | Conditional, unselected | I4 measurement trigger and the relevant adapter/containment qualification |

Establish B0's admission contract, settle the B1–B3 policy/transport/result contract together, then implement the modern internals in small reviewable changes and migrate consumers in B4. The header bump alone cannot close B0. Use the actual configured PowerShell runtime and the repository-owned `tests/batch.ps1` workflow from [tests/README.md](../../../tests/README.md); its default framework selection is `All`. Focus first on the named lifecycle/await/teardown/collection and batch-plan containers, then adapter and caller tests, then the admitted full executor/adapter selection. Tests of a broken executor need an independently bounded outer process watchdog so the test harness is not relying solely on the executor under test for teardown. All fixtures must own and clean up only their processes.

Required cases include:

- A hung job with a native descendant times out while a completed sibling remains successful; queued work does not start after cancellation.
- Cancellation races registration, pool opening and submission; every acquired handle retains an owner. Include a worker that exits before its descendant, and a descendant that holds inherited pipes open.
- Slow/blocked stdin, large simultaneous stdout/stderr and large structured output are bounded. Partial PowerShell pipeline output survives timeout, `throw` and explicit `exit`, not just direct console writes.
- Kill/drain/stop/disposal failure reports incomplete cleanup within the allowance and retains earlier results. Repeated cleanup is idempotent; no PID-reuse or unrelated-process termination.
- Empty/one/many results, out-of-order completion, native-exit fallback, malformed protocol, Unicode and marker-like user output preserve result semantics.
- Pester, pytest, inventory and initial TAP consumers retain their native outcomes, skips, identities and output ownership. Job success does not excuse missing domain evidence.
- The joined MCP fixture covers normal completion, worker timeout, batch timeout, outer timeout/cancellation, forced executor-host termination and subsequent MCP reuse, with no surviving owned descendants or lost pre-stop evidence.

Record actual limits, workload/runtime revisions, observed elapsed/resource data and remaining unsupported cases. Use broad timing bounds only for hang detection; do not encode a throughput promise as a flaky test. Do not change shared module files or reload consumers while active runs still use them.

## Follow-up report

Date: 2026-09-10. Chip: execution-bounds-and-consumer-coordination.

### Delivered

- B0: 7.5 floor on executor, adapters, `batch-runner`, test launchers, framework workers. Host `#requires` plus one bounded child probe per distinct `PowerShellPath`. `Runtime` records executable, PS version, framework.
- B1: `ExecutionTimeoutSeconds` (admission clock), `WaitTimeoutSeconds` (await-only), `CleanupTimeoutSeconds` (default 30). Earlier deadline wins. Never-started jobs kept in original-order slots.
- B2: Windows job object, `CREATE_SUSPENDED` then assign then resume. Registry removal only after `ConfirmedRelease`. Incomplete cleanup projects results without `Closed`.
- B3: Named-pipe control protocol (CLIXML frames). Raw stdout/stderr separate. Native-exit vs malformed vs ok. Capture completeness/truncation/lossy flags.
- B4: Result `Observation`/`Capture`; execution `Cleanup`/`Runtime`. `tests/batch.ps1` and `src/batch-runner.ps1` persist `executor-execution.json` before signalling failure.

### Qualification

- Host: PowerShell 7.6.4 / .NET 10.0.10.
- Child floor: PowerShell 7.5.5 probed and used as `PowerShellPath`.
- `tests/batch.ps1 -Framework Pester -PesterPath tests/batch-executor`: 10/10 files succeeded.
- `tests/batch.ps1 -Framework Pester -PesterPath tests/batch-adapters`: 5/5 files succeeded.
- Joined MCP fixture `tests/batch-executor/test_pwsh_exec_join.py` with `PWSH_EXEC_ROOT`: 4/4 against `invocation.run` (normal identity correlation, worker timeout with sibling, outer timeout + descendant containment + `result.json`, cancel then reuse).

### Remaining / unsupported

- Pooled pipelines keep `BeginInvoke`/`BeginStop`. `InvokeAsync().GetResult()` deadlocked on the owning thread with `IsCompleted` true. Process waits use `WaitForExitAsync`.
- `RunspacePool.Close`/`Dispose` remain uninterruptible owner-thread operations after children are terminated.
- Live Grok `pwsh_exec` MCP was not registered in the join session; the fixture calls `invocation.run` directly. TAP/LaTeXAI profile path remains that workstream.
- C1–C2 unselected.
- No old-vs-new wall-time/CPU/allocation comparison report (brief forbade adopting a speedup claim).
- Descendant-holds-pipes-open dedicated case not isolated beyond job-object drain bounds.

### Defaults

- `CleanupTimeoutSeconds` = 30 (0 = unlimited).
- Capture: 8 MiB stdout, 8 MiB stderr, 16 MiB protocol, 1 MiB frame.
