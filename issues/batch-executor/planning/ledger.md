# Batch executor — completed work ledger

Completed roadmap-grain work for the shared batch executor. The ahead-only queue is
[roadmap.md](roadmap.md); current architecture is [decisions.md](decisions.md); design evidence lives under
[../discussions/](../discussions/). This is not a commit changelog: entries record closed capabilities,
contracts, tests, and migration evidence.

| item | closed | contracts | witness |
|---|---|---|---|
| Initial execution kernel — greedy finite queue over a runspace pool; direct runspace and child-PowerShell modes; auto/explicit worker budget; ISS presets and per-runspace initialization; structured item results with stable ordering and failure continuation | 2026-08-04 | D1, D3, D5 | `src/shared/batch-executor.ps1`; executor Pester suite; commit `080bac6` |
| Child-process lifecycle hardening — headless/window/profile/environment/priority/timeout policy; concurrent live-child registry; parent process-tree kill on token cancellation, timeout, and final teardown; child diagnostics and logger correlation | 2026-08-04 | D5, D6 | process-mode tests in `tests/shared/batch-executor.Tests.ps1`; commit `080bac6` |
| Job and plan model — heterogeneous per-job modes under one budget; named/positional entrypoints; runtime dependencies; per-job process specifications; cost-biased dispatch with original-order results; duplicate ID, runtime-profile, process-policy, and declared write-collision validation | 2026-08-04 | D1, D4, D8–D11 | `tests/shared/batch-plan.Tests.ps1` (8 tests); commit `080bac6` |
| Initial batch-executor architecture canon — retired the Colonel/Gauntlet two-tier framing; fixed phase-not-mode decomposition, one-module/two-layer package, payload-source boundary, four-command export surface, mechanical-first sequencing, and teardown-before-move gate | 2026-08-04 | D1–D16 | [independent proposal](../discussions/opus-batch-executor-independent-proposal-20260804.md); [proposal and review](../discussions/sol-batch-executor-module-proposal-20260804.md); this planning set |

## Baseline at canon establishment

- Focused batch suites: 26 passing tests (18 executor, 8 plan).
- Complete shared suite: 119 passing tests.
- Production source consumers: none; the two batch test files are the only current loaders.
- Public loading form: flat script dot-source, pending BEX-201–BEX-205.
- Known lifecycle-test gap: current tests verify direct children but not descendant process trees or
  hosting-pipeline exceptional unwind; BEX-101–BEX-105 are the next gate.
