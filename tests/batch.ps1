#requires -Version 7.5
<#
  tests/batch.ps1 — the house-convention caller over tests/parallel.ps1.

  parallel.ps1 is contractually thin (see tests/batch-adapters/parallel.Tests.ps1, "owns only
  public adapter-plan-executor composition and console summary projection"): it may not mint a run
  directory, name the artifacts tier, touch the environment, or loop. `RunDirectory` is mandatory
  there because owning it is the CALLER's job by design.

  This script is that caller. It mints artifacts/tests/{suite}/{stamp}[_NN] through the infrastructure
  minting authority, sets CDXSCI_TEMP to a job-local tree unless it is already conformant, and
  forwards everything else to parallel.ps1 untouched. Ambient TEMP/TMP/TMPDIR are not read.
  Pass -RunDirectory to own the root yourself — that path is resolved against the repository
  root, must already exist under artifacts/, and is rejected before any temp directory is created.

  Every other parameter is forwarded verbatim through $args, so `-PythonPath`, `-MaxWorkers`,
  `-Tag`, and the rest behave exactly as they do on parallel.ps1.

  This script is deliberately NOT advanced — no [CmdletBinding()] and no [Parameter()] attribute,
  either of which would make it one. An advanced script rejects unknown named parameters outright,
  and ValueFromRemainingArguments only ever collects positional leftovers, so neither form can pass
  `-MaxWorkers 4` through to parallel.ps1. A plain param block puts them in $args, which can.
  Parameters below are positional in declaration order, so $Path stays first.
#>

param(
    [string[]] $Path = @(),
    [string[]] $PesterPath = @(),
    [string[]] $PytestPath = @(),
    [ValidateSet('Pester', 'Pytest', 'All')] [string] $Framework = 'All',
    [string] $RunDirectory,
    [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
        ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')))
)

$ErrorActionPreference = 'Stop'

. ([System.IO.Path]::Combine($RepositoryRoot, 'src', 'infrastructure', 'containment.ps1'))
. ([System.IO.Path]::Combine($PSScriptRoot, 'suite-name.ps1'))

$defaultPath = @($PSScriptRoot)
$effectivePath = if ($Path.Count -gt 0) { $Path } else { $defaultPath }

if ([string]::IsNullOrWhiteSpace($RunDirectory)) {
    # Only the lanes this run will dispatch: an unused lane falls back to the tests root, which
    # would make every single-suite batch look mixed.
    $selected = @()
    if ($Framework -in @('Pester', 'All')) {
        $selected += if ($PesterPath.Count -gt 0) { $PesterPath } else { $effectivePath }
    }
    if ($Framework -in @('Pytest', 'All')) {
        $selected += if ($PytestPath.Count -gt 0) { $PytestPath } else { $effectivePath }
    }
    $suite = Resolve-TestSuiteName -TestsRoot $PSScriptRoot -RepositoryRoot $RepositoryRoot `
        -SelectedPath $selected
    $RunDirectory = New-TestSuiteRunDir -Suite $suite -RepositoryRoot $RepositoryRoot
    Write-Information -InformationAction Continue -MessageData (
        'Test batch root: suite={0}; run={1}' -f $suite, $RunDirectory)
}
else {
    $RunDirectory = Resolve-ArtifactRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
}

$null = Set-TempEnvironment -RunDirectory $RunDirectory -RepositoryRoot $RepositoryRoot

$forwarded = @{
    RunDirectory = $RunDirectory
    RepositoryRoot = $RepositoryRoot
    Framework = $Framework
    Path = $effectivePath
}
if ($PesterPath.Count -gt 0) { $forwarded.PesterPath = $PesterPath }
if ($PytestPath.Count -gt 0) { $forwarded.PytestPath = $PytestPath }

function Write-BatchExecutorConsumerEvidence {
    param($Execution, [string] $RunDirectory)
    if ($null -eq $Execution -or [string]::IsNullOrWhiteSpace($RunDirectory)) { return }
    $path = Join-Path $RunDirectory 'executor-execution.json'
    $view = [ordered]@{
        schema = 'codex-scientiae/executor-execution/0.1'
        summary = $Execution.Summary
        cleanup = $Execution.Cleanup
        runtime = $Execution.Runtime
        errors = @($Execution.Errors)
        warnings = @($Execution.Warnings)
        results = @(
            foreach ($result in @($Execution.Results)) {
                [ordered]@{
                    id = $result.Id
                    index = $result.Index
                    state = $result.State
                    observation = $result.Observation
                    capture = $result.Capture
                    exitCode = $result.ExitCode
                    errors = @($result.Errors)
                }
            }
        )
    }
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText(
        $path, (($view | ConvertTo-Json -Depth 8) + [Environment]::NewLine), $utf8)
}

try {
    $execution = & ([System.IO.Path]::Combine($PSScriptRoot, 'parallel.ps1')) @forwarded @args
    Write-BatchExecutorConsumerEvidence -Execution $execution -RunDirectory $RunDirectory
    $execution
}
catch {
    $failed = $_.TargetObject
    if ($null -eq $failed) { $failed = $_.Exception.InnerException }
    if ($null -ne $failed -and $failed.PSObject.Properties['Summary']) {
        Write-BatchExecutorConsumerEvidence -Execution $failed -RunDirectory $RunDirectory
    }
    elseif ($null -ne $_.TargetObject -and $_.TargetObject.PSObject.Properties['Summary']) {
        Write-BatchExecutorConsumerEvidence -Execution $_.TargetObject -RunDirectory $RunDirectory
    }
    throw
}
