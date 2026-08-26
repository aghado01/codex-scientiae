# Batch executor cancellation and parent-liveness brief — deferred until rebuild

Runstamp 20260805. **Status: deferred.** This brief records the current cancellation mechanics,
the process-boundary gap, and a candidate cooperative child-control design. It is a restart packet
for work after the batch-executor teardown and module rebuild, not authorization to change the
runtime during the present tranche.

Inputs:

- [batch-executor architecture decisions](../planning/decisions.md);
- [batch-executor roadmap](../planning/roadmap.md);
- [module proposal and Opus review](../discussions/sol-batch-executor-module-proposal-20260804.md).

## 1. Disposition

Keep the current forced process-tree cancellation model through teardown and rebuild. Do not add
a child control protocol, heartbeat, lease, Job Object wrapper, inner child runspace, or new public
cancellation policy while source and module boundaries are moving.

The present minimum is:

- preserve the parent-owned process registry and `Kill(entireProcessTree: true)` fallback;
- preserve the 200 ms interruptible parent-wait checkpoints that let PowerShell stop reach
  `finally` promptly;
- preserve the adversarial child/grandchild teardown tests through every file move;
- state plainly that the process child does not currently receive an operative cancellation token;
- keep cooperative child cancellation and parent-liveness detection deferred behind explicit
  reactivation gates in §8.

This is a sequencing decision, not a judgment that cooperative cancellation lacks value.

## 2. Current mechanics

### 2.1 Direct runspace jobs

The caller token reaches the direct dispatcher and the worker. A cooperative worker may inspect or
throw from that token. When the parent observes cancellation or total-batch timeout, it marks the
unfinished invocation and stops the pooled PowerShell pipeline after the appropriate teardown step.

### 2.2 Process jobs

The caller token reaches the parent and the pooled process-supervisor runspace. It does not cross the
OS process boundary. The child bootstrap deserializes the payload and invokes the worker with item,
context, and runspace state; the generic worker's fourth cancellation-token parameter is therefore
null in process mode.

Cancellation is presently preemptive:

~~~text
caller token / total timeout / hosting pipeline stop
                         ↓
parent observes cancellation or enters finally
                         ↓
parent kills every registered child process tree
                         ↓
process supervisor drains bounded diagnostics and publishes terminal state
~~~

The model is robust for uncooperative tools but does not let a cooperative child finish `finally`,
flush buffered logs, write a checkpoint, or remove its own temporary files before termination.

### 2.3 Parent unwind

Catchable infrastructure failures and PowerShell pipeline stop reach the executor's parent-owned
`finally`. The teardown safety gate exposed that an indefinite CLR wait originally delayed this
unwind until child completion; bounded wait slices now give the PowerShell host regular stop
checkpoints. Individual job failures remain result data and do not initiate batch cancellation.

### 2.4 Hard parent termination

A killed, crashed, or power-lost parent cannot run `catch` or `finally`. The current process registry
cannot act after its owning process disappears. This is a different failure class from ordinary
caller cancellation or pipeline unwind and requires OS containment or child-side parent-liveness
detection if it is to be covered.

## 3. Why a linked parent cancellation source is still needed

The executor can observe a caller-owned `CancellationToken` but cannot cancel it. A future
cooperative implementation should create an internal linked `CancellationTokenSource`, pass its
token to direct workers and process supervisors, and cancel it for caller cancellation, total-batch
timeout, or parent infrastructure unwind.

The batch-wide source must not be cancelled for an ordinary item failure. Failure containment is a
standing executor contract; cooperative cancellation must not quietly turn fail-continue into
fail-fast behavior.

Conceptual parent order:

~~~text
try
  execute finite batch with linked token
catch parent infrastructure failure
  record exceptional teardown reason and rethrow
finally
  cancel linked in-process token
  signal cooperative process children if a control channel exists
  wait no longer than the configured cleanup grace
  kill every surviving registered process tree
  stop supervisor/direct pipelines and dispose the pool
~~~

Cancellation initiation belongs in `finally`, not only `catch`, because hosting-pipeline stop and
other PowerShell unwinds are not reliably expressed as ordinary catchable application exceptions.

## 4. Candidate child control channel

A .NET `CancellationToken` is process-local. Cooperative process cancellation therefore needs a
live IPC signal from the parent and a child-local `CancellationTokenSource`.

The preferred candidate is a persistent per-child named pipe rather than a pulse file:

- it supports explicit framed control messages;
- channel EOF provides immediate parent/channel-loss evidence;
- it avoids stale files, polling I/O, timestamp ambiguity, and cleanup races;
- it is available across the target platforms;
- access can be scoped using an unpredictable per-job channel name and platform permissions.

Candidate frames are deliberately small:

- `READY` — child bootstrap has installed its monitor and can begin work;
- `CANCEL <reason>` — cooperative cancellation request;
- `LEASE <sequence>` — optional controller-health renewal;
- `COMPLETE` — child has completed its worker and structured result;
- EOF — control owner disappeared or intentionally closed the channel.

The protocol must close the cancellation-before-connect race: the parent creates the endpoint before
process launch, passes an unguessable endpoint identity, and does not consider the child ready until
the monitor acknowledges `READY`. Cancellation already requested at handshake time is delivered
before worker execution.

## 5. Candidate child runtime shape

The current bootstrap runs the worker synchronously, leaving no child thread available to monitor a
control channel. A cooperative implementation would need to change that runtime shape:

1. bootstrap connects to the control channel and owns a local `CancellationTokenSource`;
2. worker runs asynchronously in an inner runspace or another explicitly owned execution context;
3. bootstrap monitors worker completion, control frames, EOF, and any local timeout;
4. `CANCEL`, EOF, or lease expiry cancels the child-local token;
5. cooperative cleanup receives a bounded grace period;
6. bootstrap stops its worker and terminates its descendants if the grace expires;
7. the parent independently kills any surviving process tree.

The control monitor is runtime infrastructure and must not consume a slot from the plan's shared
worker budget. Stream capture and the existing structured result marker must remain unambiguous if
the worker moves into an inner runspace.

## 6. Pulse and lease semantics

A child-observed pulse is useful for detecting a living-but-unhealthy controller. It is not the
ordinary cancellation command and is not sufficient process containment by itself.

If activated, model the pulse as a renewable lease over the control channel:

~~~text
explicit CANCEL  → cancel immediately
channel EOF      → parent/channel death; cancel immediately
lease expiry     → controller no longer making progress; cancel locally
local timeout    → cancel locally
~~~

Use monotonic elapsed time and sequence numbers, not wall-clock timestamps. Renewal and expiry must
be far enough apart to tolerate scheduling pressure, runtime pauses, sleep/resume, and debugging.
Illustrative values are a 2-second renewal and a 15–30-second expiry; real defaults require stress
evidence and may remain disabled initially.

A simple parent-PID check is a useful fallback but must pair PID with process start identity to avoid
PID-reuse mistakes. It detects death, not a hung controller. A named-pipe EOF is normally faster and
less ambiguous.

## 7. Forced containment remains non-negotiable

Cooperative cancellation is an opportunity for cleanup, not an assurance that cleanup happens.
Arbitrary scripts, native subprocesses, blocked runtimes, and hostile or defective workers may ignore
the token. Every cooperative policy therefore ends in a hard deadline and tree kill.

Potential future process policy:

- `ImmediateKill` — current behavior and safest initial default;
- `CooperativeThenKill` — signal, wait a bounded grace, then kill survivors;
- `CancellationGraceSeconds` — explicit finite cleanup allowance;
- parent-liveness policy — `ChannelLoss`, optionally extended with `LeaseExpiry`;
- lease interval/expiry — internal policy until workload evidence justifies public controls.

For catastrophic parent death on Windows, a Job Object configured with kill-on-close is stronger than
a heartbeat because the OS owns enforcement. Cross-platform process groups, cgroups, or child-side
parent monitoring require separate evaluation. OS containment and cooperative cleanup are complementary:
the former guarantees termination, while the latter permits graceful release when the parent is alive
long enough to request it.

## 8. Reactivation gates

Do not activate this design merely because the module extraction completes. Revisit it when all of the
following are true:

1. the batch-executor module teardown/rebuild is complete and its public/payload boundaries are stable;
2. current cancellation, timeout, pipeline-stop, failure-containment, and process-tree tests remain green;
3. at least one real adapter demonstrates a cleanup need that immediate kill damages—such as run-log
   flushing, checkpoint publication, temporary-work cleanup, or resumable document ingestion;
4. the target platform set is known well enough to choose control-channel and OS-containment contracts;
5. the child result/diagnostic protocol can accommodate cancellation handshake and cleanup outcomes
   without corrupting stdout or conflating cancellation with failure.

## 9. Future adversarial test matrix

The later implementation is incomplete without tests for:

- explicit cancellation reaching the child-local token and executing worker cleanup;
- cooperative completion within grace versus forced kill after grace;
- cancellation requested before child handshake;
- control-channel EOF after catchable and catastrophic parent termination;
- lease expiry when the controller is alive but no longer renewing;
- no false expiry under CPU pressure and bounded scheduling pauses;
- child and grandchild termination for cooperative and uncooperative workers;
- parent death before registry publication and during payload/control writes;
- individual job failure leaving sibling leases and tokens untouched;
- structured cancellation diagnostics and log/checkpoint flush behavior;
- Windows Job Object kill-on-close, if adopted, with no surviving descendants.

## 10. Non-goals now

The current tranche does not:

- change `ImmediateKill` behavior;
- expose new cancellation or heartbeat parameters;
- keep child stdin open or introduce a framing protocol;
- add a named-pipe server, heartbeat timer, or parent-PID monitor;
- run process workers in an additional child runspace;
- add a detached job registry, retry engine, or durable queue;
- claim hard-parent-death containment beyond the existing managed unwind paths.

Until reactivation, this brief is design memory. The teardown tests and parent-owned kill fallback are
the operative contract.
