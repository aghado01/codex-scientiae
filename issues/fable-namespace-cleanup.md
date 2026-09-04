# Fable namespace cleanup

Done 2026-09-04.

- Env prefix `CODEX_` → `CDXSCI_`. `CODEX_SCIENTIAE_ROOT` → `CDXSCI_ROOT`.
- Signatures: `Set-CodexTempEnvironment` → `Set-TempEnvironment`; `Assert-CodexTempEnvironment` → `Assert-TempEnvironment`.
- Helper file: `assert-codex-temp.ps1` → `assert-temp.ps1`.
- Left alone: Codex CLI (`.codex/`, `~/.Codex`, `-CodexConfigPath`); PowerShell type names `CodexScientiae.*`; historical `issues/grok-*`.

---

the tree currently has fourteen distinct CODEX_ variable names across 40 files, dominated by three.

Variable	Occurrences
CODEX_TEMP	82
CODEX_JSON_SCRATCH_ROOT	37
CODEX_TEST_ARTIFACT_ROOT	36
eleven others (runlog, procurement, batch, root, fixtures)	5 to 11 each

Change env variables prefix to `CDXSCI_` e.g. CDXSCI_TEMP, CDXSCI_BATCH_JOB_ID, CDXSCI_ROOT etc 

For signatures maybe simply remove "...CODEX...` e.g. Assert-CodexTempEnvironment -> Assert-TempEnvironment 