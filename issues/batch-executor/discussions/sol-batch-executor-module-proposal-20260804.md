## Proposed reorganization

The current [`batch-executor.ps1`](D:/aghado01/codex-scientiae/src/shared/batch-executor.ps1) is 1,457 lines:

- Embedded runspace/process transport: ~356 lines
- `Invoke-BatchExecutor`: 489 lines
- Plan compiler: 271 lines
- Remaining public and private helpers: ~340 lines

I recommend one PowerShell module with two internal layers—plan and execution—not separate modules.

```text
src/shared/
├── batch-executor.ps1                 # compatibility loader
└── batch-executor/
    ├── batch-executor.psd1
    ├── batch-executor.psm1            # deterministic loader/export list
    ├── README.md
    ├── public/
    │   ├── New-BatchJob.ps1
    │   ├── Compile-BatchPlan.ps1
    │   ├── Invoke-BatchPlan.ps1
    │   └── Invoke-BatchExecutor.ps1
    ├── private/
    │   ├── transport.ps1              # dispatcher and child-command bodies
    │   ├── script-definition.ps1
    │   ├── session-state.ps1
    │   ├── process-lifecycle.ps1
    │   ├── worker-budget.ps1
    │   ├── property-access.ps1
    │   └── plan-resolution.ps1
    └── workers/
        └── batch-job-worker.ps1
```

Only these functions should be exported:

- `New-BatchJob`
- `Compile-BatchPlan`
- `Invoke-BatchPlan`
- `Invoke-BatchExecutor`

The remaining helpers become genuinely module-private. That removes the current dot-sourcing behavior where all eleven functions leak into the caller’s session.

## Migration scope

I would make the first reorganization mechanically, without changing behavior:

1. Add the module manifest and deterministic loader.
2. Move existing function bodies unchanged into the corresponding files.
3. Give the module a stable internal worker path instead of relying on ambient `$PSScriptRoot`.
4. Turn the existing `src/shared/batch-executor.ps1` into a compatibility loader.
5. Change the two test files to import the manifest.
6. Add module-surface tests proving:
   - the four public commands are exported;
   - private helpers are not visible;
   - the compatibility loader still works.
7. Run the 26 focused batch tests and the complete shared suite.

I would defer decomposing the 489-line `Invoke-BatchExecutor` itself. Its lifecycle ordering—register child, kill tree, drain supervisor, stop runspace, collect diagnostics, dispose pool—is safety-sensitive. Physical encapsulation should land first; extracting dispatch/wait/collection phases can be a separate, reviewable refactor.

Likewise, this reorganization should not yet add test or ingestion adapters, retries, detached execution, typed process-spec constructors, or a dependency DAG. Those are semantic additions rather than organization work.

## Opus review

Let me check two things in the proposal against the code before commenting.

Checked it against the code. **The shape is right — endorse it.** One module, two internal layers, compat loader, mechanical-first, phases deferred. It matches where the code's own seams are, and the encapsulation argument (eleven functions currently leaking into the caller's session) is a real win I'd underweighted.

Three corrections before step 1, then two additions.

## 1. `private/transport.ps1` is in the wrong directory — this is the one that bites

The transport here-strings contain `$script:` references that execute **in the pooled runspace, not the host**:

```
74:    if ($script:BatchExecutorRunspaceInitialized -ne $true) {
76:        $script:BatchExecutorRunspaceState = ...
82:    $output = @(Invoke-BatchWorkItem $Item $Context $script:BatchExecutorRunspaceState ...)
```

That's the per-runspace one-time-initializer memo. Sol's layout puts transport in `private/` — the directory the deterministic loader dot-sources everything else from. Today the string-vs-source distinction is obvious because it's a here-string; after the move it's a `.ps1` file sitting among files that _are_ meant to be dot-sourced, and the only thing preventing someone from "simplifying" the loader into a `foreach` over `private/*.ps1` is that they happened to notice. If that ever happens, those memo variables collide with host module scope and every pooled runspace shares one initializer state.

Put transport bodies under `workers/` (or a `transport/` sibling), next to `batch-job-worker.ps1`, because that's what they are — payload source, read with `Get-Content -Raw`, never executed in the host. The directory boundary should carry the invariant, not a comment.

## 2. Step 5 breaks an existing test that step 6 then asserts is correct

[tests/shared/batch-executor.Tests.ps1:13](tests/shared/batch-executor.Tests.ps1:13) is `Describe 'Resolve-BatchWorkerBudget'` — three `It` blocks calling it directly. Sol makes it `private/worker-budget.ps1` and step 6 adds a test proving "private helpers are not visible." Those two can't both hold: importing the manifest deletes that Describe block's ability to run.

`InModuleScope batch-executor { }` around that Describe is the fix — keeps the unit coverage, keeps the export surface at four. The alternative (export it) is defensible too, since a caller sizing a batch plausibly wants it, but then step 6's assertion list needs editing. Either way it's a decision, not an oversight to discover at step 7.

## 3. `Compile` is not an approved verb

Confirmed: `(Get-Verb).Verb -contains 'Compile'` → `False`. Today, dot-sourced, nobody notices. The moment it's a manifest export, `Import-Module` warns on every load and PSScriptAnalyzer flags `PSUseApprovedVerbs`. This is a wart the module move _introduces_.

`New-BatchPlan` fits — it returns a new plan object and pairs with `New-BatchJob` — with `Set-Alias Compile-BatchPlan New-BatchPlan` in the compat loader. Or accept the warning deliberately. Just don't let it arrive as a surprise on the first import.

Related, on step 3: the fix for [:1351](src/shared/batch-executor.ps1:1351) needs to be a module-scoped root captured once in the `.psm1` (`$script:BatchExecutorRoot = $PSScriptRoot`), not `$PSScriptRoot` inside `public/Compile-BatchPlan.ps1` — which would resolve to `public/` and break exactly as silently as the current ambient version.

## 4. Pull teardown tests forward

Sol names the lifecycle safety-sensitive, then defers only the _phase extraction_. But the **file move** of `Stop-BatchExecutorChildProcesses` and the process registry happens in step 2, and step 6's tests are module-surface only — exports visible, privates hidden, loader works. None of that would catch an orphaned `pwsh` tree.

The failure mode here is silent: a teardown path that no longer fires leaves stray processes and nothing turns red. Add adversarial teardown tests — Ctrl+C, batch timeout, and exception unwind each leaving zero surviving children — **before** step 2. They're the safety net for this pass _and_ for the phase extraction sol correctly defers, so they get paid for twice.

## 5. The proposal's last paragraph is a roadmap; give it a home

`issues/batch-executor/` now exists with `discussions/` but no `planning/`. Every other lane — doccer, latex-ingest, loggers — has `planning/{decisions,roadmap,ledger}`. Sol's closing paragraph (no adapters, retries, detached execution, typed process-spec constructors, dependency DAG) is already a deferred-work list in prose, and the proposal contains at least four decision-grade calls: one-module-two-layers over separate modules, the four-function export surface, mechanical-first with phases deferred, and the export/private boundary for the budget helper.

Worth minting the canon as part of this chip rather than after — same reason it worked for doccer. And make `batch-executor/README.md` the same _kind_ of document as `src/doccer/README.md`: a capability/contract surface, not a how-to.

One thing worth stating explicitly in the decision record while it's fresh: **the two-tier colonel/gauntlet framing is dead.** What exists is one greedy scheduler with per-job mode and a shared budget. The module layout should never re-introduce that split as a file boundary — which sol's layout correctly doesn't, but nothing currently writes down _why_ that's deliberate.
