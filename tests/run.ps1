#requires -Version 7.0
<#
  tests/run.ps1 — import Pester (>=5) and run every *.Tests.ps1 recursively under this tree. Runs on Pester 5.x AND
  6.x (the invocation is version-robust — see the container note below).

  Pester >=5 lives in the portable PowerShell module tree, not on the default module path while the
  portable-env integration is degraded, so we import it by explicit path anchored on $env:PORTABLE_ROOT
  (falls back to a normally-installed >=5 if that anchor isn't set). Throws on any test failure, a missing
  path, OR an empty run, so child processes exit non-zero and nested callers can observe the failure.
  This exact-container entrypoint requires CODEX_TEMP under the repository artifacts root. The
  public caller is tests/batch.ps1, including a one-file selection; this script is the child
  entrypoint Get-PesterBatchJob invokes. Ambient TEMP is not a substitute.
#>
[CmdletBinding()]
param(
    [string] $Path = $PSScriptRoot,
    [string] $ResultPath,
    [ValidateSet('NUnitXml', 'NUnit2.5', 'NUnit3', 'JUnitXml')]
    [string] $ResultFormat = 'NUnitXml',
    [ValidateNotNullOrEmpty()] [string] $TestSuiteName = 'Pester',
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [string] $OutputVerbosity = 'Detailed',
    [AllowEmptyCollection()] [string[]] $FullNameFilter = @(),
    [AllowEmptyCollection()] [string[]] $Tag = @(),
    [AllowEmptyCollection()] [string[]] $ExcludeTag = @()
)

$repositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$artifactBoundary = Join-Path $repositoryRoot 'src/logistics/artifact-boundary.ps1'
if (-not (Test-Path -LiteralPath $artifactBoundary -PathType Leaf)) {
    throw "run.ps1: artifact boundary helper not found: '$artifactBoundary'"
}
. $artifactBoundary
$null = Assert-CodexTempEnvironment -RepositoryRoot $repositoryRoot

if (-not (Get-Module Pester | Where-Object { $_.Version -ge [version]'5.0' })) {
    $manifest = $null
    if ($env:PORTABLE_ROOT) {
        $proot = Join-Path $env:PORTABLE_ROOT 'PowerShell\Modules\Pester'
        if (Test-Path -LiteralPath $proot) {
            $v = Get-ChildItem -LiteralPath $proot -Directory |
                 Where-Object { ($_.Name -as [version]) -ge [version]'5.0' } |
                 Sort-Object { [version]$_.Name } -Descending | Select-Object -First 1
            if ($v) { $manifest = Join-Path $v.FullName 'Pester.psd1' }
        }
    }
    if ($manifest) { Import-Module $manifest -Force }
    else { Import-Module Pester -MinimumVersion 5.0 -Force }   # fall back to a v5 on the normal path
}
"Pester $((Get-Module Pester).Version)"

if (-not (Test-Path -LiteralPath $Path)) { throw "run.ps1: test path not found: '$Path'" }
$resolvedTestPath = (Resolve-Path -LiteralPath $Path).Path

# Resolve $Path through an explicit CONTAINER, not $cfg.Run.Path: Run.Path's single-file-vs-directory
# discovery diverged across the Pester 5->6 major (a v6 install was observed finding ZERO tests from a
# bare file path), whereas New-PesterContainer resolves a file OR a directory identically on 5.7.1 and
# 6.0.0 (verified for both file and recursive-directory discovery). Run.Path is cleared so only the container
# runs and a stray *.Tests.ps1 in the caller's cwd can't sneak in.
$cfg = New-PesterConfiguration
$cfg.Run.Container    = New-PesterContainer -Path $resolvedTestPath
$cfg.Run.Path         = @()
$cfg.Run.PassThru     = $true
$cfg.Output.Verbosity = $OutputVerbosity
if ($FullNameFilter.Count -gt 0) { $cfg.Filter.FullName = [string[]]@($FullNameFilter) }
if ($Tag.Count -gt 0) { $cfg.Filter.Tag = [string[]]@($Tag) }
if ($ExcludeTag.Count -gt 0) { $cfg.Filter.ExcludeTag = [string[]]@($ExcludeTag) }
$resolvedResultPath = $null
if (-not [string]::IsNullOrWhiteSpace($ResultPath)) {
    $resolvedResultPath = Resolve-TestHarnessArtifactPath -Value $ResultPath `
        -RepositoryRoot $repositoryRoot -Role 'run.ps1 ResultPath' `
        -BasePath (Get-Location).Path
    $resultDirectory = [System.IO.Path]::GetDirectoryName($resolvedResultPath)
    if (-not [string]::IsNullOrWhiteSpace($resultDirectory)) {
        [void][System.IO.Directory]::CreateDirectory($resultDirectory)
    }
    $cfg.TestResult.Enabled = $true
    $cfg.TestResult.OutputPath = $resolvedResultPath
    $cfg.TestResult.OutputFormat = $ResultFormat
    $cfg.TestResult.OutputEncoding = 'UTF8'
    $cfg.TestResult.TestSuiteName = $TestSuiteName
}
$timer = [System.Diagnostics.Stopwatch]::StartNew()
try { $result = Invoke-Pester -Configuration $cfg }
finally { $timer.Stop() }

# One child-process-safe audit line. This is transient stdout, not a runner-owned result store or logger.
# Pester's native result remains the only durable runner artifact.
$passed = if ($result) { [int]$result.PassedCount } else { 0 }
$failed = if ($result) { [int]$result.FailedCount } else { 0 }
$skipped = if ($result) { [int]$result.SkippedCount } else { 0 }
$observation = [ordered]@{
    container_path = $resolvedTestPath
    # Pester 5 TotalCount includes cases excluded by FullName; outcome counts match the native selected set
    # on both Pester 5 and 6 and therefore own the runner's cross-version empty-run decision.
    selected = $passed + $failed + $skipped
    passed = $passed
    failed = $failed
    skipped = $skipped
    duration_ms = [int64][math]::Round($timer.Elapsed.TotalMilliseconds)
    result_path = $resolvedResultPath
}
# Write directly to child stdout so this transient diagnostic survives a later
# terminating failure without becoming part of the executor's generic output.
[Console]::Out.WriteLine('PesterContainerObservation ' + ($observation | ConvertTo-Json -Compress))

# Zero discovered tests is a discovery/resolution fault (bad path, wrong or corrupt Pester), never a pass.
# Fail LOUD so a "no tests found" can never masquerade as green — the hole the old $cfg.Run.Exit left open
# (it exits non-zero on failures but 0 on an empty run). NB: TotalCount is $null, not 0, when nothing runs.
$total = $observation.selected
if ($total -eq 0) {
    throw "run.ps1: no tests discovered under '$Path' (Pester $((Get-Module Pester).Version)) — refusing to report success"
}
if ($failed -gt 0) {
    throw "run.ps1: $failed of $total test(s) failed"
}
