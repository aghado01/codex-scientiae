The Opus review is valid. I’d adopt all five points, with one refinement around transport placement and one practical qualification around Ctrl+C testing.

## Reconciled decisions

| Review point                              | Disposition | Amendment                                                                                                                                               |
| ----------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Transport is not ordinary private code    | Agree       | Use `payloads/`, not `private/` or generic `workers/`. Payload files are read as text and never dot-sourced.                                            |
| Budget tests conflict with private export | Agree       | Keep `Resolve-BatchWorkerBudget` private and test it with `InModuleScope`. Callers control inputs and receive the resolved budget in execution results. |
| `Compile` is unapproved                   | Agree       | Canonical API becomes `New-BatchPlan`; the compatibility loader supplies `Compile-BatchPlan` as a transitional alias.                                   |
| Teardown tests must precede movement      | Agree       | Add adversarial lifecycle tests before moving source files.                                                                                             |
| Deferred work needs planning canon        | Agree       | Mint `decisions.md`, `roadmap.md`, and `ledger.md`; make the source README a capability/contract document.                                              |

The review’s `$PSScriptRoot` correction is also exactly right: the module root must be captured once in `batch-executor.psm1`, with stable payload paths stored in module-scoped variables.

## Revised source layout

```text
src/shared/
├── batch-executor.ps1                 # transitional compatibility loader
└── batch-executor/
    ├── batch-executor.psd1
    ├── batch-executor.psm1
    ├── README.md                      # capability and contract surface
    ├── public/
    │   ├── New-BatchJob.ps1
    │   ├── New-BatchPlan.ps1
    │   ├── Invoke-BatchPlan.ps1
    │   └── Invoke-BatchExecutor.ps1
    ├── private/
    │   ├── script-definition.ps1
    │   ├── session-state.ps1
    │   ├── process-lifecycle.ps1
    │   ├── worker-budget.ps1
    │   ├── property-access.ps1
    │   └── plan-resolution.ps1
    └── payloads/
        ├── direct-dispatcher.payload.ps1
        ├── process-dispatcher.payload.ps1
        ├── child-bootstrap.payload.ps1
        └── batch-job-worker.ps1
```

The module loader will explicitly read the dispatcher/bootstrap payloads using `ReadAllText`. It will not enumerate and dot-source directories dynamically. The directory boundary therefore enforces the execution-context distinction.

Canonical exports become:

- `New-BatchJob`
- `New-BatchPlan`
- `Invoke-BatchPlan`
- `Invoke-BatchExecutor`

## Revised execution order

1. Planning canon

   Create:
   - `issues/batch-executor/planning/decisions.md`
   - `issues/batch-executor/planning/roadmap.md`
   - `issues/batch-executor/planning/ledger.md`

   The decisions must explicitly retire the Colonel/Gauntlet two-tier framing: there is one greedy scheduler, one shared budget, and a per-job execution mode.

2. Teardown safety net

   Before moving implementation code, add tests for:
   - cancellation killing the child and its descendants;
   - total batch timeout killing the process tree;
   - per-child timeout killing the process tree;
   - stopping the hosting PowerShell pipeline while work is live, proving `finally` leaves no descendants;
   - queued processes remaining unstarted after cancellation.

   A hosting-pipeline stop is the deterministic automated equivalent of Ctrl+C unwind. A literal keyboard Ctrl+C test would be host/console-dependent on Windows, so I would keep that as a manual smoke test rather than a flaky Pester gate.

3. Mechanical module extraction

   Move bodies without restructuring the 489-line lifecycle function. Capture the module root once, load files in an explicit order, and read payload source as data.

4. Public-surface migration
   - Tests import the manifest.
   - Budget unit tests use `InModuleScope`.
   - Tests and documentation adopt `New-BatchPlan`.
   - The compatibility loader imports the module and provides the old `Compile-BatchPlan` alias.
   - Add export/private-visibility and compatibility tests.

5. Verification

   Run focused lifecycle tests, all batch tests, module-surface tests, the path-topology suite, and the complete shared suite.

A clean commit sequence would be:

1. `docs(batch-executor): establish architecture canon`
2. `test(batch-executor): lock down process-tree teardown`
3. `refactor(batch-executor): package executor as shared module`

The deeper phase extraction, adapters, retries, detached execution, typed specification constructors, and dependency DAG remain roadmap work rather than part of this reorganization.
