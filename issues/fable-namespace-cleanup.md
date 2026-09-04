the tree currently has fourteen distinct CODEX_ variable names across 40 files, dominated by three.

Variable	Occurrences
CODEX_TEMP	82
CODEX_JSON_SCRATCH_ROOT	37
CODEX_TEST_ARTIFACT_ROOT	36
eleven others (runlog, procurement, batch, root, fixtures)	5 to 11 each

Change env variables prefix to `CDXSCI_` e.g. CDXSCI_TEMP, CDXSCI_BATCH_JOB_ID, CDXSCI_ROOT etc 

For signatures maybe simply remove "...CODEX...` e.g. Assert-CodexTempEnvironment -> Assert-TempEnvironment 