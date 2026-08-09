#requires -Version 7.0

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()] [string] $InventoryPath,
    [AllowEmptyCollection()] [string[]] $Slug = @(),
    [string] $RunDirectory,
    [string] $ArtifactsRoot,
    [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
        ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))),
    [string] $LatexIngestPath,
    [string] $PowerShellPath,
    [System.Collections.IDictionary] $ProcessEnvironment = @{},
    [ValidateRange(0, [int]::MaxValue)] [int] $TimeoutSeconds = 0,
    [switch] $BundleDeliverable,
    [switch] $EnableEmbeddedToc,
    [switch] $DisableTreeToc,
    [switch] $DisableJsonlToc,
    [switch] $FaithfulNumbering,
    [nullable[int]] $MaxWorkers = $null,
    [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
    [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
    [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
    [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
    [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')]
    [string] $PriorityClass = 'Normal'
)

$repository = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
    [System.IO.Path]::GetFullPath($RepositoryRoot)
}
else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
if (-not [System.IO.Directory]::Exists($repository)) {
    throw "latex-batch repository root not found: '$RepositoryRoot'"
}
$repository = (Resolve-Path -LiteralPath $repository).Path

. (Join-Path $PSScriptRoot 'inventory-catalog.ps1')
. (Join-Path $PSScriptRoot '../logistics/run-paths.ps1')
$adaptersManifest = [System.IO.Path]::Combine(
    $PSScriptRoot, '..', 'batch-adapters', 'adapters.psd1')
$executorManifest = [System.IO.Path]::Combine(
    $PSScriptRoot, '..', 'batch-executor', 'batch-executor.psd1')
Import-Module -Name $executorManifest -ErrorAction Stop
Import-Module -Name $adaptersManifest -ErrorAction Stop

if ([string]::IsNullOrWhiteSpace($InventoryPath)) {
    $InventoryPath = [System.IO.Path]::Combine(
        $repository, 'ingestion', 'inventory', 'inventory.jsonl')
}
elseif (-not [System.IO.Path]::IsPathFullyQualified($InventoryPath)) {
    $InventoryPath = [System.IO.Path]::GetFullPath($InventoryPath, $repository)
}
$rows = @(Read-LatexInventoryCatalog -InventoryPath $InventoryPath)
if ($rows.Count -eq 0) { throw "latex-batch inventory contains no document rows: '$InventoryPath'" }

$selected = [System.Collections.Generic.List[object]]::new()
if ($Slug.Count -eq 0) {
    foreach ($row in $rows) { $selected.Add($row) }
}
else {
    $wanted = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    foreach ($value in $Slug) {
        if ([string]::IsNullOrWhiteSpace($value)) { throw 'latex-batch Slug contains an empty value' }
        [void]$wanted.Add($value)
    }
    foreach ($row in $rows) {
        if ($wanted.Contains([string]$row['slug'])) { $selected.Add($row) }
    }
    $found = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $selected) { [void]$found.Add([string]$row['slug']) }
    $missing = @($wanted | Where-Object { -not $found.Contains($_) } | Sort-Object)
    if ($missing.Count -gt 0) {
        throw "latex-batch requested slug(s) absent from inventory: $($missing -join ', ')"
    }
}

if (-not [string]::IsNullOrWhiteSpace($RunDirectory) -and
    -not [string]::IsNullOrWhiteSpace($ArtifactsRoot)) {
    throw 'latex-batch RunDirectory and ArtifactsRoot are mutually exclusive'
}
if ([string]::IsNullOrWhiteSpace($RunDirectory)) {
    $resolvedArtifactsRoot = if ([string]::IsNullOrWhiteSpace($ArtifactsRoot)) {
        [System.IO.Path]::Combine($repository, 'artifacts')
    }
    elseif ([System.IO.Path]::IsPathFullyQualified($ArtifactsRoot)) {
        [System.IO.Path]::GetFullPath($ArtifactsRoot)
    }
    else { [System.IO.Path]::GetFullPath($ArtifactsRoot, $repository) }
    $RunDirectory = New-ModuleRunDir -Module 'latex-batch' -Slug '' `
        -ArtifactsRoot $resolvedArtifactsRoot
}
else {
    if (-not [System.IO.Path]::IsPathFullyQualified($RunDirectory)) {
        $RunDirectory = [System.IO.Path]::GetFullPath($RunDirectory, $repository)
    }
    if (-not [System.IO.Directory]::Exists($RunDirectory)) {
        throw "latex-batch RunDirectory must already exist: '$RunDirectory'"
    }
    $RunDirectory = (Resolve-Path -LiteralPath $RunDirectory).Path
}

$adapterParameters = @{
    InventoryRow      = $selected.ToArray()
    RunDirectory      = $RunDirectory
    RepositoryRoot    = $repository
    InventoryRoot     = [System.IO.Path]::GetDirectoryName(
        [System.IO.Path]::GetFullPath($InventoryPath))
    ProcessEnvironment = $ProcessEnvironment
    TimeoutSeconds    = $TimeoutSeconds
    PriorityClass     = $PriorityClass
}
if (-not [string]::IsNullOrWhiteSpace($LatexIngestPath)) {
    $adapterParameters.LatexIngestPath = $LatexIngestPath
}
if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) {
    $adapterParameters.PowerShellPath = $PowerShellPath
}
foreach ($switchName in @(
        'BundleDeliverable', 'EnableEmbeddedToc', 'DisableTreeToc',
        'DisableJsonlToc', 'FaithfulNumbering')) {
    if ([bool](Get-Variable -Name $switchName -ValueOnly)) {
        $adapterParameters[$switchName] = $true
    }
}

$jobs = @(adapters\Get-LatexBatchJob @adapterParameters)
$compiled = batch-executor\New-BatchPlan -Job $jobs -BasePath $repository
if ($compiled.Errors.Count -gt 0 -or $null -eq $compiled.Plan) {
    throw "latex-batch plan validation failed: $(@($compiled.Errors) -join '; ')"
}
$execution = batch-executor\Invoke-BatchPlan -Plan $compiled `
    -MaxWorkers $MaxWorkers -ReservedCores $ReservedCores `
    -MinItemsPerWorker $MinItemsPerWorker -SerializationDepth $SerializationDepth `
    -WaitTimeoutSeconds $WaitTimeoutSeconds -PriorityClass $PriorityClass
$execution | Add-Member -NotePropertyName InventoryPath -NotePropertyValue `
    ([System.IO.Path]::GetFullPath($InventoryPath))
$execution | Add-Member -NotePropertyName RunDirectory -NotePropertyValue $RunDirectory
$execution | Add-Member -NotePropertyName SelectedSlugs -NotePropertyValue `
    ([string[]]@($selected | ForEach-Object { [string]$_['slug'] }))

$summary = $execution.Summary
$infrastructureErrors = @($execution.Errors).Count
Write-Information -InformationAction Continue -MessageData (
    'LaTeX batch: total={0}; succeeded={1}; failed={2}; timed-out={3}; cancelled={4}; infrastructure-errors={5}; duration-ms={6}; run={7}' -f
    $summary.Total, $summary.Succeeded, $summary.Failed, $summary.TimedOut,
    $summary.Cancelled, $infrastructureErrors, $execution.Timing.TotalMs, $RunDirectory)

$execution
if ($summary.Succeeded -ne $summary.Total -or $infrastructureErrors -gt 0) {
    throw ('latex-batch did not succeed: failed={0}; timed-out={1}; cancelled={2}; infrastructure-errors={3}' -f
        $summary.Failed, $summary.TimedOut, $summary.Cancelled, $infrastructureErrors)
}
