#requires -Version 7.0
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
    [string] $RunDirectory = '',
    [string] $PowerShellPath = '',
    [nullable[int]] $MaxWorkers = $null,
    [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
    [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
    [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
    [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
    [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
    [switch] $FailOnArticleFailure
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$startedUtc = [datetime]::UtcNow
$utf8 = [System.Text.UTF8Encoding]::new($false)

if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw 'batch-runner requires PowerShell 7 or newer'
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
}
if ($null -ne $MaxWorkers) { $invoke.MaxWorkers = $MaxWorkers }
$execution = Invoke-BatchPlan @invoke

$rows = [System.Collections.Generic.List[object]]::new()
$totals = [ordered]@{}
$receiptOk = 0
$receiptFailed = 0
$receiptMissing = 0
for ($index = 0; $index -lt $jobs.Count; $index++) {
    $job = $jobs[$index]
    $result = $execution.Results[$index]
    $receipt = $null
    if (Test-Path -LiteralPath $job.Metadata.ReceiptPath -PathType Leaf) {
        try {
            $receipt = Get-Content -LiteralPath $job.Metadata.ReceiptPath -Raw | ConvertFrom-Json
        }
        catch {
            $result.Errors += "could not read receipt: $($_.Exception.Message)"
        }
    }
    $receiptStatus = if ($null -eq $receipt) { 'missing' } else { [string]$receipt.status }
    if ($receiptStatus -eq 'ok') { $receiptOk++ }
    elseif ($receiptStatus -eq 'failed') { $receiptFailed++ }
    else { $receiptMissing++ }
    $counts = if ($null -ne $receipt -and $receipt.PSObject.Properties['counts']) {
        $receipt.counts
    }
    else { [pscustomobject]@{} }
    foreach ($property in $counts.PSObject.Properties) {
        if ($property.Value -isnot [ValueType]) { continue }
        if (-not $totals.Contains($property.Name)) { $totals[$property.Name] = 0L }
        $totals[$property.Name] = [long]$totals[$property.Name] + [long]$property.Value
    }
    $rows.Add([pscustomobject][ordered]@{
            schema = 'codex-scientiae/inventory-summary/0.1'
            id = $job.Id
            engine = $Engine
            article = [ordered]@{
                slug = $job.Metadata.Slug
                repositoryRelativePath = $job.Metadata.RepositoryRelativePath
                treeSha256 = $job.Metadata.TreeSha256
            }
            executorState = $result.State
            executorExitCode = $result.ExitCode
            status = $receiptStatus
            counts = $counts
            errors = @($result.Errors)
            warnings = @($result.Warnings)
        })
}

$summaryPath = Join-Path $RunDirectory 'inventory-summary.jsonl'
$summaryLines = @($rows | ForEach-Object { $_ | ConvertTo-Json -Depth 12 -Compress })
[System.IO.File]::WriteAllText($summaryPath, (($summaryLines -join "`n") + "`n"), $utf8)
$endedUtc = [datetime]::UtcNow
$runRecord = [ordered]@{
    schema = 'codex-scientiae/inventory-run/0.1'
    engine = $Engine
    startedUtc = $startedUtc.ToString('o')
    endedUtc = $endedUtc.ToString('o')
    durationMs = [math]::Round(($endedUtc - $startedUtc).TotalMilliseconds, 2)
    runDirectory = $RunDirectory
    selectedPaths = @($selectedPaths)
    jobs = $jobs.Count
    receipts = [ordered]@{ ok = $receiptOk; failed = $receiptFailed; missing = $receiptMissing }
    executor = [ordered]@{
        summary = $execution.Summary
        errors = @($execution.Errors)
        warnings = @($execution.Warnings)
    }
    totals = $totals
}
[System.IO.File]::WriteAllText(
    (Join-Path $RunDirectory 'run.json'),
    (($runRecord | ConvertTo-Json -Depth 16) + "`n"),
    $utf8)

if (@($execution.Errors).Count -gt 0) {
    throw "Inventory batch executor reported infrastructure errors: $(@($execution.Errors) -join '; ')"
}
Write-Output (
    "Inventory batch: engine={0}; articles={1}; ok={2}; failed={3}; missing={4}; run={5}" -f
    $Engine, $jobs.Count, $receiptOk, $receiptFailed, $receiptMissing, $RunDirectory)
if ($FailOnArticleFailure -and ($receiptFailed + $receiptMissing -gt 0)) { exit 1 }
