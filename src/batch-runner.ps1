#requires -Version 7.5
<#
  src/batch-runner.ps1 — house caller for inventory-tree engine batches.

  Resolves the Codex Scientiae root from -RepositoryRoot or process-scope
  CDXSCI_ROOT (no drive-letter fallback). Defaults -Path to
  {root}/supellex/gauntlet, which is a folded catalog: the planner reads that
  directory's inventory.jsonl. A child catalog's inventory.jsonl is used when
  -Path names that child.

  Mints artifacts/{engine}/{stamp}/ through New-ModuleRunDir. The engine is the
  process that produced the output. The selected inventory is recorded on the
  run, not in the path: -Slug on New-ModuleRunDir is an article identity, and a
  batch is not one article. Does not preflight the engine runtime. The engine
  launcher owns that, then calls this script.
#>

[CmdletBinding()]
param(
    [string] $RepositoryRoot = '',
    [string[]] $Path = @(),
    [Parameter(Mandatory)] [ValidatePattern('^[a-z][a-z0-9-]{0,31}$')] [string] $Engine,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EngineRoot,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Worker,
    [System.Collections.IDictionary] $WorkerParameter = @{},
    [System.Collections.IDictionary] $ExperimentSpecification = @{schema='codex-scientiae/acquisition/1'},
    [switch] $RequireQualification,
    [string] $RunDirectory = '',
    [string] $PowerShellPath = '',
    [nullable[int]] $MaxWorkers = $null,
    [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
    [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
    [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
    [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
    [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
    [ValidateRange(0, [int]::MaxValue)] [int] $ExecutionTimeoutSeconds = 0,
    [ValidateRange(0, [int]::MaxValue)] [int] $CleanupTimeoutSeconds = 30,
    [switch] $FailOnArticleFailure
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$startedUtc = [datetime]::UtcNow
$utf8 = [System.Text.UTF8Encoding]::new($false)

if ($PSVersionTable.PSVersion -lt [version]'7.5') {
    throw "batch-runner requires PowerShell 7.5 or newer; host is $($PSVersionTable.PSVersion)"
}

$repositoryInput = if (-not [string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot
}
else {
    [System.Environment]::GetEnvironmentVariable('CDXSCI_ROOT', 'Process')
}
if ([string]::IsNullOrWhiteSpace($repositoryInput) -or
        -not [System.IO.Path]::IsPathFullyQualified($repositoryInput) -or
        -not (Test-Path -LiteralPath $repositoryInput -PathType Container)) {
    throw 'RepositoryRoot or process-scope CDXSCI_ROOT must name an existing absolute directory'
}
$repositoryRoot = (Resolve-Path -LiteralPath $repositoryInput).Path

$containment = Join-Path $PSScriptRoot 'infrastructure/containment.ps1'
$executorManifest = Join-Path $PSScriptRoot 'batch-executor/batch-executor.psd1'
$adapterManifest = Join-Path $PSScriptRoot 'batch-adapters/adapters.psd1'
foreach ($required in @($containment, $executorManifest, $adapterManifest)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "batch-runner prerequisite not found: '$required'"
    }
}
. $containment
Import-Module $executorManifest -Force
Import-Module $adapterManifest -Force
Import-Module (Join-Path $PSScriptRoot 'inventory-records/inventory-records.psm1') -Force

[string[]] $selectedPaths = @(
    if ($null -ne $Path -and @($Path).Count -gt 0) { $Path }
    else { , (Join-Path $repositoryRoot 'supellex/gauntlet') }
)
if ($selectedPaths.Count -eq 0) { throw 'batch-runner produced no inventory paths' }

if ([string]::IsNullOrWhiteSpace($RunDirectory)) {
    $RunDirectory = New-ModuleRunDir -Module $Engine -RepositoryRoot $repositoryRoot
    Write-Information -InformationAction Continue -MessageData (
        'Inventory batch root: engine={0}; run={1}' -f $Engine, $RunDirectory)
}
else {
    $RunDirectory = Resolve-ArtifactRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $repositoryRoot
}
$null = Set-TempEnvironment -RunDirectory $RunDirectory -RepositoryRoot $repositoryRoot

$plan = @{
    Path = $selectedPaths
    RunDirectory = $RunDirectory
    RepositoryRoot = $repositoryRoot
    Engine = $Engine
    EngineRoot = $EngineRoot
    Worker = $Worker
    WorkerParameter = $WorkerParameter
}
if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) { $plan.PowerShellPath = $PowerShellPath }

$jobs = @(Get-InventoryBatchJob @plan)
if ($jobs.Count -eq 0) { throw 'The inventory adapter produced no jobs' }
$experiment = Write-InventoryExperiment -RunDirectory $RunDirectory -Jobs $jobs `
    -WorkerParameters $WorkerParameter -Specification $ExperimentSpecification -SelectedPaths $selectedPaths `
    -Policy @{
        requireQualification=[bool]$RequireQualification; maxWorkers=$MaxWorkers; reservedCores=$ReservedCores
        processTimeoutSeconds=$ProcessTimeoutSeconds; executionTimeoutSeconds=$ExecutionTimeoutSeconds
        waitTimeoutSeconds=$WaitTimeoutSeconds; cleanupTimeoutSeconds=$CleanupTimeoutSeconds
    }
$jobs = @(Get-InventoryBatchJob @plan -ExperimentSha256 $experiment.sha256)
$compiled = New-BatchPlan -Job $jobs -BasePath $EngineRoot
if ($compiled.Errors.Count -gt 0 -or $null -eq $compiled.Plan) {
    throw "Inventory batch plan is invalid: $(@($compiled.Errors) -join '; ')"
}

$invoke = @{
    Plan = $compiled
    ReservedCores = $ReservedCores
    MinItemsPerWorker = $MinItemsPerWorker
    SerializationDepth = $SerializationDepth
    ProcessTimeoutSeconds = $ProcessTimeoutSeconds
    WaitTimeoutSeconds = $WaitTimeoutSeconds
    ExecutionTimeoutSeconds = $ExecutionTimeoutSeconds
    CleanupTimeoutSeconds = $CleanupTimeoutSeconds
}
if ($null -ne $MaxWorkers) { $invoke.MaxWorkers = $MaxWorkers }
$execution = Invoke-BatchPlan @invoke
$executorEvidence = [ordered]@{
    schema = 'codex-scientiae/executor-execution/0.1'
    summary = $execution.Summary
    cleanup = $execution.Cleanup
    runtime = $execution.Runtime
    errors = @($execution.Errors)
    warnings = @($execution.Warnings)
    results = @(
        foreach ($result in @($execution.Results)) {
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
[System.IO.File]::WriteAllText(
    (Join-Path $RunDirectory 'executor-execution.json'),
    (($executorEvidence | ConvertTo-Json -Depth 8) + "`n"),
    $utf8)

$aggregate = Write-InventoryBatch -RunDirectory $RunDirectory -Execution $execution -StartedUtc $startedUtc
$record = $aggregate.Record
Write-Output (
    'Inventory batch: engine={0}; articles={1}; ok={2}; failed={3}; missing={4}; invalid={5}; batch={6}' -f
    $Engine, $record.coverage.expected, $record.coverage.complete, $record.coverage.failed,
    $record.coverage.missing, $record.coverage.invalid, $RunDirectory)
if (@($execution.Errors).Count -gt 0 -or
        $null -eq $execution.Cleanup -or $execution.Cleanup.State -ne 'Confirmed') {
    throw "Inventory batch executor reported infrastructure errors; see '$RunDirectory/batch.json'"
}
if ($FailOnArticleFailure -and ($record.status -ne 'complete' -or ($RequireQualification -and $record.qualification.status -ne 'pass'))) {
    throw "Inventory batch gate failed: status=$($record.status); qualification=$($record.qualification.status); see '$RunDirectory/batch.json'"
}
