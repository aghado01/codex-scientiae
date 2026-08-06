# Test batch adapter

`test-batch` is the repository Pester discovery adapter for the shared finite-batch executor. It is a
separate module so domain discovery does not expand the executor's four-command public surface.

## Public command

`Get-TestBatchJob` accepts caller-selected `*.Tests.ps1` files or directories and an existing absolute
`RunDirectory`. Directories expand recursively to one `PowerShellProcess` job per test file. Optional Pester
full-name and tag filters select cases inside each file without loading Pester or suite code in the planning
process.

Planning resolves and freezes:

- a stable job ID from repository-relative test identity plus normalized filters;
- the exact Pester 5-or-newer manifest imported by the child;
- the PowerShell executable, repository working directory, and runner entrypoint;
- a file-size cost hint; and
- one Pester-native XML result path beneath `RunDirectory/test-jobs/`.

One private pure resolver owns all run-relative address composition. Planning creates no directories or
files. The worker may create the unique result directory, and the job declares its XML result path in
`Writes`. Pester's XML is an explicit runner-native artifact; the generic batch execution result remains the
in-memory return from `Invoke-BatchPlan`.

`Get-TestBatchJob` only plans work. The caller imports the batch-executor module separately, passes the
emitted jobs to `New-BatchPlan`, and invokes a valid plan through `Invoke-BatchPlan`. This keeps adapters
composable: test and future ingestion jobs can share one queue without another scheduler or convenience
wrapper taking ownership of execution policy.

The adapter never allocates or joins a run, selects logger sink topology, serializes the generic execution
record, or owns pools, cancellation, retries, and result ordering. Process jobs receive the executor's
`CODEX_BATCH_JOB_ID`; any caller-supplied logging or correlation environment continues through ordinary
process policy.
