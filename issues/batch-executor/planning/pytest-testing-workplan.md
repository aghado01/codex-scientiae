# Batch executor — pytest admission workplan

This is the completed implementation record for admitting repository pytest files to the shared
finite-batch executor. The completed [Pester overhaul](testing-overhaul-workplan.md) remains historical
evidence; this tranche applies its ownership lessons through a separate framework contract.

Inputs:

- [pytest batchability inventory](pytest-batchability-inventory.md);
- [batch-executor architecture decisions](decisions.md), including implemented D25–D27;
- [completed-work ledger](ledger.md);
- [repository test guidance](../../../tests/README.md); and
- the Python project configuration in [`pyproject.toml`](../../../pyproject.toml).

**Status: complete. BEX-601 through BEX-605 closed on 2026-08-08.**

## Implemented composition

~~~text
caller paths + existing RunDirectory
        |
        v
Get-PytestBatchJob                   discovery, identity, addressing, dependency pinning
        |
        v
New-BatchPlan -> Invoke-BatchPlan    sole queue, budget, cancellation, and result-order owner
        |
        v
tests/pytest.ps1                     exact python -m pytest, JUnit, observation, exit semantics
~~~

One physical repository-relative `test_*.py` file is one `PowerShellProcess` job. Methods, node IDs,
parameter rows, and `unittest.subTest` contexts remain inside it. `tests/pytest.ps1` launches the pinned
interpreter beneath the executor-owned process tree; no second Python runner, pytest-xdist budget, or native
executor job kind was added.

## BEX-601 — Python file-container isolation

**Status: closed.** Golden regeneration was removed from normal tests; shared support stopped importing
sibling test containers; cleanup and coordination scratch became bounded and job-local; and the mixed CLI
surface was split at its PowerShell capability seam. The final topology is 11 files: 10 `Batchable`, one
`CapabilityGated`, zero `NeedsRefactor`, and zero `SerialOnly`. Direct collection is 157 methods plus 36
subtest contexts, or 193 outcomes.

## BEX-602 — Authoritative pytest runner

**Status: closed.** `tests/pytest.ps1` owns one exact `python -m pytest` invocation, repository/config
anchoring, JUnit, cache/bytecode/temp policy, stream/status capture, and framework failure propagation. Its
transient `PytestContainerObservation` records `container_path`, `selected`, `passed`, assertion `failed`,
`errors`, `skipped`, `duration_ms`, `result_path`, `result_present`,
`python_version`, `pytest_version`, and `pytest_exit_code`. The focused gate passed 5/5, including exit codes
0, 1, and 5.

## BEX-603 — Pytest adapter

**Status: closed.** The existing `adapters` module exports `Get-PytestBatchJob`. It discovers unique
repository-contained `test_*.py` files without importing them, emits stable `pytest:` IDs, freezes runner
inputs and environment, and uses one resolver for `RunDirectory/pytest-jobs/<container>/{pytest.xml,
artifacts,temp}`. Planning creates none of those addresses; all are declared writes. No executor public
command or native-process mode was added. The adapter transports its resolved child PowerShell as
`CODEX_TEST_POWERSHELL_PATH`; shell-surface tests use that exact executable and fall back to `PATH` only
during direct, non-batch pytest. Job metadata names the key as `PowerShellEnvironment`.

## BEX-604 — Multilingual repository shell

**Status: closed.** `tests/parallel.ps1` now accepts `-Framework All|Pester|Pytest`, with optional
`-PesterPath` and `-PytestPath`. It obtains jobs from the separate adapters, combines only domain-neutral
job records, and compiles and invokes one plan. Runners, selectors, job IDs, address roots, observations,
and NUnit/JUnit reports remain framework-owned. The 5/5 shell gate covered mixed success and
pytest-failure/Pester-sibling containment. No `parallel-pytest.ps1` or result merger was introduced.

## BEX-605 — Parity and admission closure

**Status: closed for pytest parity and admission.** The repository's 11 jobs completed at both four workers
(20.163 s) and one worker (54.473 s). Each run produced 11 JUnit reports and 193 passing outcomes, with zero
failures, errors, or skips. Only declared XML files were retained; no new pytest cache, Python bytecode, or
repository scratch entries remained. Focused witnesses also established sibling failure containment and
multilingual shell parity.

## Deferred archaeology

Mapping or retiring the four historical Pester JSONL containers is separate follow-up work. It is not part
of BEX-605's completed pytest parity gate and is not a blocker to pytest admission. Any unique
PowerShell-front-end behavior must be identified before that historical coverage is removed.

## Post-closure parity refresh

The JSONL-engine CLI protocol/client tranche expanded `test_cli_surface.py` without changing the physical
11-file job topology. Current direct collection is 163 methods plus 38 subtest contexts, or 201 outcomes.
Fresh one-worker and four-worker batches both completed 11/11 jobs, emitted 11 JUnit reports, retained only
the declared XML files, and reported 201 passes with zero failures, errors, or skips. Durations were
33.392 seconds and 17.205 seconds respectively; cache, bytecode, and repository scratch remained clean.

## Preserved non-goals

The tranche did not add method/class/parameter fan-out, pytest-xdist, automatic selector inference,
per-file sidecars, a universal test-result schema, merged framework reports, dependency installation,
historical timing stores, adaptive scheduling, native non-PowerShell executor entrypoints, or a rewrite of
`unittest.TestCase` assertions into pytest syntax.
