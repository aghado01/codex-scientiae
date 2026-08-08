# Batch executor — pytest batchability inventory

This is the admitted semantic inventory for the repository's Python test lane as of 2026-08-08. It applies
the isolation and ownership principles established by the completed Pester overhaul without rewriting that
historical inventory. One physical `test_*.py` file is the job boundary; `unittest.TestCase` methods, pytest
node IDs, parameter rows, and `subTest` contexts remain outcomes inside the file.

**Status: migration and batch admission complete.** The implementation and closure evidence are recorded in
the [pytest workplan](pytest-testing-workplan.md) and [completed-work ledger](ledger.md).

## Current baseline

- The repository has 12 physical `test_*.py` files below `tests/shared/`.
- Direct pytest collects 192 test methods and observes 72 in-method `unittest.subTest` contexts, for 264
  outcomes. Subtests are not separately schedulable jobs.
- Exact-file discovery produces 12 fresh-process jobs without importing test code.
- The suite has no test-order dependency, mutable shared scratch address, committed-fixture regeneration,
  unbounded thread/process cleanup, or sibling-test-module import.
- Capability boundaries are explicit in `test_shell_surface.py` for PowerShell integration and in
  `test_deposit.py` for host permission to create symbolic links.

| Class | Files | Disposition |
|---|---:|---|
| `Batchable` | 10 | Admitted as exact-file, fresh-process jobs. |
| `CapabilityGated` | 2 | Admitted with deterministic PowerShell or symbolic-link capability gating. |
| `NeedsRefactor` | 0 | No repair residue remains. |
| `SerialOnly` | 0 | No shared resource or ordering exception is justified. |
| **Total** | **12** | **192 methods plus 72 in-method subtest contexts; 264 outcomes.** |

## File inventory

| File | Methods / subtests | Current boundary | Class |
|---|---:|---|---|
| `tests/shared/test_append.py` | 15 / 2 | Unique temporary stores; no external capability or cross-file state. | `Batchable` |
| `tests/shared/test_bounded_views.py` | 19 / 0 | Filesystem-heavy cases remain inside unique temporary roots. | `Batchable` |
| `tests/shared/test_byte_equality.py` | 12 / 27 | Golden inputs are read-only; regeneration is outside normal test execution. | `Batchable` |
| `tests/shared/test_cli_surface.py` | 14 / 9 | Versioned framing, the 16-verb capability record, schema-plus-semantic `validate-json`, kind dispatch, and machine-readable CLI failures remain pure Python process-boundary cases. | `Batchable` |
| `tests/shared/test_commit.py` | 17 / 0 | Temporary outputs and bounded mocks use non-test support fixtures. | `Batchable` |
| `tests/shared/test_concurrency.py` | 20 / 2 | Threads and descendants are bounded; coordination scratch is job-local. | `Batchable` |
| `tests/shared/test_deposit.py` | 26 / 27 | Deposits, portable schema and semantic relations, source-generation witnesses, rollback, reparse confinement, forced publication races, and conflicts use temporary roots; two symlink cases skip only when the host denies symlink creation. | `CapabilityGated` |
| `tests/shared/test_jsonl_engine.py` | 9 / 0 | Read-only repository/schema inputs and unique temporary outputs. | `Batchable` |
| `tests/shared/test_pointer_ordering.py` | 16 / 0 | Pure deterministic pointer and ordering behavior. | `Batchable` |
| `tests/shared/test_reader.py` | 18 / 3 | Every mutation is under a unique temporary directory. | `Batchable` |
| `tests/shared/test_registry.py` | 18 / 2 | Unique temporary registries use non-test support fixtures. | `Batchable` |
| `tests/shared/test_shell_surface.py` | 8 / 0 | PowerShell integration consumes `CODEX_TEST_POWERSHELL_PATH` from batch jobs, falls back to `PATH` only for direct pytest, and uses bounded subprocess cleanup. | `CapabilityGated` |

## Admission evidence

`tests/pytest.ps1` invokes one exact file through the pinned interpreter, anchors collection at the
repository root, disables shared cache and bytecode writes, supplies job-local temporary and JSON scratch
roots, writes JUnit, emits `PytestContainerObservation`, and propagates pytest exit semantics. Its focused
gate passed 5/5 and covered pytest exits 0, 1, and 5.

`Get-PytestBatchJob` declares `pytest.xml`, `artifacts/`, and `temp/` beneath
`RunDirectory/pytest-jobs/<container>` and plans 12 unique `pytest:` jobs without creating those addresses.
The multilingual shell gate passed 5/5, including mixed success and pytest-failure/Pester-sibling
containment.

The pre-deposit post-admission parity refresh produced:

| Workers | Jobs | Duration | Native evidence | Outcomes |
|---:|---:|---:|---|---|
| 4 | 11/11 | 17.205 s | 11 JUnit reports | 201 passed; 0 failures, errors, or skips |
| 1 | 11/11 | 33.392 s | 11 JUnit reports | 201 passed; 0 failures, errors, or skips |

Both runs retained only declared XML files, created no new cache or bytecode, left no repository scratch
entries, and left no admission residue.

The final hardening refresh collected 192 physical tests across all 12 files. Its direct `tests/shared` run
passed 190 methods, recorded two genuine Windows symbolic-link capability skips, and passed all 72 subtest
outcomes, for 264 selected outcomes. `test_deposit.py` contributes 26 methods and 27 subtests, or 53 JUnit
outcomes: 24 methods passed, two symlink cases skipped, and all 27 subtests passed. A two-job multilingual
batch gate paired that file with the Pester deposit container at two workers: both jobs succeeded in 9.641
seconds, retaining native reports with 53 pytest outcomes and five Pester outcomes. Its job-local
`json-scratch` was empty. The evidence is under
`artifacts/test-runs/deposit-parity-hardened-20260808`.

## Deferred Pester archaeology

Four historical Pester containers still refer to retired PowerShell JSONL sources:
`encoding-invariants.Tests.ps1`, `jsonl-store-v2.Tests.ps1`, `jsonl-v2-compat.Tests.ps1`, and
`jsonl-v2.Tests.ps1`. Their mapping or retirement is a separate archaeology task. It is not evidence about
the current Python lane and was not a blocker to pytest admission. Preserve any unique PowerShell-front-end
contract before retiring displaced engine tests.

Pytest-xdist, class-level scheduling, and method-level scheduling remain outside this contract. The shared
executor remains the sole scheduler and lifecycle owner.
