# Membrane Batch Scaling (L5) — design

> Status: **design / concept.** Specifies a **new runspace manager owned in `src/`** — a sibling of
> `serving.ps1` / `preprocess.ps1` / etc. It **lifts patterns** from reposnapshot's `colonel`
> (`rs.core.colonel.v2.psm1`), a **pattern donor, not a dependency** — with codex-scientiae-specific
> changes and enhancements. No cross-project runtime deps; pure PowerShell, dot-sourced via
> `$PSScriptRoot`, matching the membrane's conventions. Not built this pass.

## Stance

The reposnapshot colonel **is not wired in and does nothing here** — it was written for reposnapshot's
processor-chain, not the membrane. We lift its *shape*, adapt it, enhance it, and **own a new component
in `codex-scientiae/src/`** (working name `src/colonel.ps1`; a boring functional name like
`runspaces.ps1` / `batch.ps1` is equally fine — author's call). The lineage is honoured; the code is
ours.

## What we lift from the colonel (the shape)

- **Mechanism/policy split** — the manager is *dumb*: provision, budget, dispatch, collect, tear down,
  and decide **nothing**. The seeing agent is the brain (which papers, what order, triage, escalation).
- **The pipeline:** a *pure* budget function → a compile/plan step → an invoke/run step → a thin
  manager holder. (Colonel: `Resolve-WorkerBudget` · `Compile-Plan` · `Invoke-Plan` · `RunspaceManager`.)
- **ISS presets** (`Bare`/`Core`/`Full`) for worker isolation/provisioning — pre-load exactly what a
  worker needs into every runspace.
- **Budget as a pure, auditable function** — returns threads **+ policy + inputs**, no side effects.
- **Index-stable collection** (workers write disjoint indices), **`ConcurrentBag` errors**, and a
  **timed/budgeted result envelope** (`Results` · `Errors` · `Budget` · `Timing`).
- **Never-hang teardown** — bounded per-worker wait → forcible `Stop()` → `EndInvoke` → pool dispose.
- **Runspace-boundary discipline** — fully-qualified .NET types in worker scriptblocks, no module-scope
  capture, args serialized as plain hashtables.
- **Bootstrap layering** — raw `[PowerShell]::Create()` to read/validate before the ISS exists; serial
  ISS build (not thread-safe); then pooled execution.

## What we change / enhance for codex-scientiae

1. **Unit = `{slug}`, not arbitrary item.** Runspace assignment is **per paper**; the batch is the set
   of papers under the (scoped) ingestion root. Cross-`{slug}` work is **disjoint by file path**
   (verified below), so it is race-free *by construction*, not by locking.
2. **Greedy-per-item dispatch, not static round-robin slicing.** The colonel pre-slices items into N
   buckets (a slow paper strands its bucket). Instead, dispatch **one job per `{slug}`** to a bounded
   `(1, N)` `RunspacePool` and let the pool schedule greedily as slots free — handles uneven paper
   sizes, no straggler. Keep `Resolve-WorkerBudget` to compute N (clamp `MaxWorkers`/`cores-reserved`,
   grade by `MinItemsPerWorker`), drop the manual slice.
3. **Two pools, two purposes** (the membrane reframe):
   - **Deterministic-stage pool (in-process, colonel-native).** `preprocess` is *already a processor
     chain* (`project-ir → headings → collapse → zones → sections → normalize → fidelity → repair`) —
     it maps onto the plan model 1:1 (stages = processors, **papers = items**). The pool parallelizes
     `preprocess`/`finalize`/`survey` across the batch. **This is the immediate win.**
   - **Agent-repair fan-out (NOT runspace work).** A runspace can't run a model. Repair parallelism is
     the seeing agent + its sub-agents as **clients of the one HTTP membrane**; the manager at most
     provisions/isolates the client runspaces.
4. **Ride the membrane's existing discipline (the colonel had none).** No reinvented coordination: the
   manager sits on top of **leases + per-id proposals + `apply`** as ground truth. Crash-reclaim is
   trivial — a dead runspace owns a whole `{slug}`, so reclaim = `release` that paper's leases (no
   per-lease session tagging).
5. **Two-tier feedback** (colonel + PSOne):
   - **durable / end-of-run:** the colonel's `{Results, Errors, Budget, Timing}` envelope.
   - **live / mid-run:** a PSOne-style `[hashtable]::Synchronized(@{…})` per worker — `Status`/`Error`/
     progress the host reads **without blocking** the worker, plus an `Enabled` cooperative-cancel flag
     workers check at `{slug}` boundaries (never mid-paper — protects `.scratch/`). Ephemeral, no disk.
6. **One HTTP membrane, many runspace clients → light serverside discipline.** Because cross-`{slug}`
   is write-disjoint, **no global write lock is needed.** It reduces to two invariants (below).
7. **Match membrane conventions.** Pure PowerShell, dot-sourced, `$PSScriptRoot`; adapt the colonel's
   `class`/`enum`/`using namespace` to the membrane's style (or keep, if a 7.x feature is justified —
   note that `mcp-server.ps1` is `#requires -Version 7.0`).

## The model (the whole thing)

```
Seeing agent (brain) — batch purview, policy, triage, escalation
   │ deploys (independently)
   ├─ sub-agents ─ ride INSIDE a {slug}, on the per-id proposal surface
   │
src/colonel (dumb runspace manager) — assigns ONE runspace per {slug},
   │   greedy when workers < papers; budgets purely; never-hang teardown
   │ each runspace is a CLIENT of …
   │
ONE HTTP membrane — single coordination point; state is per-{slug}
   │
.scratch/{slug}/… — durable ground truth (leases + per-id proposals + ledger)
```

## Lifecycle / phasing — the pool is a phase tool, not the job

**The runspace pool's lifetime ≠ the job's lifetime.** The pool opens, grinds the parallelizable
*deterministic* work, and **closes before the job is done** — what follows (follow-up + final review)
is partly model-driven and lives outside the pool. The colonel stays dumb and phase-scoped; the seeing
agent owns the multi-phase lifecycle and its ordering.

The pool may open/close **more than once** per job (one parallel phase per parallelizable deterministic
stage), with model-driven phases between:

```
startup ceremony (global discovery handshake)
  → [pool: preprocess across batch]            (deterministic, greedy; pool closes)
  → repair                                      (agent + sub-agent fan-out, lease-serialized per {slug})
  → per-unit closing ceremony  (×N, STAGGERED)  (each {slug}, as it finishes greedily:)
        [pool: finalize] + review_document → resolve/escalate until pending == 0
  → global batch closing ceremony               (the JOIN — begins strictly after all units closed)
```

**Closing is two-tiered and strictly ordered:**
- **Per-unit closing** (each `{slug}`): follow-up (repair resolution) + final review (`finalize` →
  `review_document` → `pending == 0` / escalations recorded). Resolves **per unit**, staggered in the
  greedy loop — a unit reaches its own closing as it finishes, not at a shared barrier.
- **Global closing** (the batch): begins **strictly after every** per-unit closing has resolved. The
  join / final `get_batch_summary` reporting the batch done.

Consequences: the L4 `finish-clean` gate is **two gates** (per-unit `pending==0` *and* the global join),
not one end-of-job check; and the startup/closing ceremonies are symmetric — one global startup at the
front, `{N staggered per-unit closings → one global closing}` at the back. All expressible in existing
tools (`finalize`, `review_document`, `get_summary.pending`, `get_batch_summary`, the per-`{slug}` ledger).

## Two concurrency boundaries (each already handled)

- **Cross-`{slug}` (runspace boundary):** disjoint file paths → race-free without locking.
- **Within-`{slug}` (chunk-id boundary):** one proposal file per id, leases mark in-flight, `apply`
  folds clean + clears merged leases. The existing MCP discipline; sub-agents in a `{slug}` don't collide.

## Two parallelism axes (orthogonal, compose without interference)

- **Runspaces = the membrane's discipline** — mechanism-level, per-`{slug}`, the colonel's job. Bounds file scope.
- **Sub-agent fan-out = the seeing agent's discipline** — policy-level, independent, operates *within* a
  runspace's `{slug}`-provenance under the per-id machinery. (Note: Claude-side `NO SUB-AGENT DISPATCH`
  bites only this axis; the deterministic runspace pool is unaffected — it spawns no agents.)

**Why they compose — congruence + information hiding.** The runspace partition and the tool/artifact
partition are **two congruent views of the one `{slug}` boundary**:
- *Interface* (what a sub-agent sees): paper-addressed tools + `{slug}`-partitioned artifacts + per-id
  proposals/leases.
- *Implementation* (hidden): the runspace's structural path-confinement.

A sub-agent programs against the interface and is **oblivious to runspaces**; because the interface
*mirrors* the implementation's partition, the supervisor delegates a sub-agent into a runspace domain
just by **assigning it a paper** — its tool-scoped behaviour automatically respects the runspace's
file-scope. Consequences: (1) the orthogonality has a *reason* — both axes are projections of the same
partition, so they can't disagree; (2) delegation is leak-free ("sub-agent, work paper X"); (3) the
parallelism implementation is **substitutable** (runspaces → processes → HTTP-shared-daemon → serial)
behind the stable tool/artifact contract.

**Caveat (→ L4).** Paper-addressed tools resolve globally by name (`Resolve-Paper` crawls the whole
root), so a sub-agent *can* address a paper outside its domain — congruence is upheld by delegation
discipline + the deterministic pool's structural confinement, not a hard tool-layer sandbox. But
**collision-safety holds regardless**: per-id proposals + leases serialize within a `{slug}`, so a
strayed sub-agent contends/duplicates at worst, never corrupts. Hard per-sub-agent confinement (a
session bound to `paper=X`) is an optional **L4 governance hook**, not a correctness requirement.

## Hygiene invariants (what the disjointness depends on — not excused by it)

1. **One runspace per `{slug}`** (colonel-enforced). Also keeps the lone read-modify-write safe:
   `Set-LeasedIds` overwrites `{slug}.leases.json` whole, so lease mutation must stay serialized to the
   owning runspace. Two runspaces on one paper = the lost-update bug.
2. **No global mutable artifact** (verified true today). Any future batch-level index/manifest/cache
   becomes the first shared-write point and must coordinate explicitly (per-`{slug}` shards or a lock).
   Keep this a deliberate decision, not an accident.

## Verified write-disjointness (turning the belief into fact)

Every file write in `src/` is path-derived from a per-paper input; there is **no global mutable artifact**:

| Write site | Target | Scope |
|---|---|---|
| finalize.ps1:90-91 | `{slug}.md`, `references/{slug}.md` | per-`{slug}` |
| jsonl.ps1:87/105/119/189 | `{slug}.chunks.jsonl` + `.sig`, `inventory.json`, `{slug}.ledger.jsonl` | per-`{slug}` |
| serving.ps1:71 | `{slug}.leases.json` | per-`{slug}` |
| serving.ps1:164/200/255/430 | proposals `{propDir}/{id}.json` | per-`{slug}`, **per-id** |
| serving.ps1:441 / restructure.ps1:48 | review-requests, structure-audit jsonl | per-`{slug}` |
| md-cleanup.ps1:136 | the deliverable being cleaned | per-`{slug}` |

Only the stdout protocol channel (mcp-server.ps1:197) is process-shared — not file state.

## Component sketch (shape, not implementation)

```
# src/colonel.ps1  (dot-sourced sibling; pure PS)
Resolve-WorkerBudget -PaperCount <n> [-MaxWorkers <n>] [-ReservedCores 2] [-MinPerWorker 1]
    -> @{ Workers; Policy; Inputs }                       # pure

New-StagePlan -Stages <ordered stage fns> [-IssPreset Core] [-Modules @()]
    -> @{ Iss; Stages }                                   # provision once (deterministic pool)

Invoke-Batch -Papers <slug[]> -Plan <plan> [-MaxWorkers] [-WaitTimeoutMs]
    -> @{ Results(by slug); Errors; Budget; Timing; Live(synchronized hash) }
    # greedy: one job per {slug} to a (1,N) pool; cooperative-cancel via Live.Enabled;
    # reclaim a dead worker's {slug} via membrane `release`.

New-RunspaceManager -Plan <plan> [knobs] -> [object] with .Run($papers) / .Status()
```

## Boundaries / non-goals

- **Design only this pass** (consistent with the L5 deferral in the architecture doc).
- **Runspaces run PowerShell, not models** — the pool parallelizes the *deterministic* stages; repair
  stays agent-level and lease-serialized.
- **No reinvented coordination** — leases/proposals/`apply` remain ground truth; the manager rides them.

## Relationship to the other docs

- L5 row of [membrane-architecture.md](membrane-architecture.md) — this is its detail.
- Pattern provenance: reposnapshot `colonel` (donor) + PSOneTools clipboard-listener (the live-feedback
  tier) — both lifted-and-owned, not depended on.
- Mechanism/policy split = the same seam as the governator (rules vs executor) in
  [membrane-governance-design.md](membrane-governance-design.md) and CCP's "strict core, fluent shell."
