#requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter(Position = 0)] [ValidateNotNullOrEmpty()]
    [string[]] $Path = @($PSScriptRoot),
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
    [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
        ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))),
    [string] $PesterManifest,
    [string] $PowerShellPath,
    [AllowEmptyCollection()] [string[]] $FullNameFilter = @(),
    [AllowEmptyCollection()] [string[]] $Tag = @(),
    [AllowEmptyCollection()] [string[]] $ExcludeTag = @(),
    [ValidateSet('NUnitXml', 'NUnit2.5', 'NUnit3', 'JUnitXml')]
    [string] $ResultFormat = 'NUnitXml',
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [string] $OutputVerbosity = 'None',
    [nullable[int]] $MaxWorkers = $null,
    [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
    [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
    [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
    [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
    [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
    [System.Collections.IDictionary] $ProcessEnvironment = @{},
    [bool] $CreateNoWindow = $true,
    [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')]
    [string] $WindowStyle = 'Hidden',
    [switch] $LoadProfile,
    [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')]
    [string] $PriorityClass = 'Normal'
)

$sourceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../src'))
$adaptersManifest = [System.IO.Path]::Combine($sourceRoot, 'adapters', 'adapters.psd1')
$executorManifest = [System.IO.Path]::Combine(
    $sourceRoot, 'shared', 'batch-executor', 'batch-executor.psd1')
Import-Module -Name $executorManifest -ErrorAction Stop
Import-Module -Name $adaptersManifest -ErrorAction Stop

$adapterParameters = @{
    Path = $Path
    RunDirectory = $RunDirectory
    RepositoryRoot = $RepositoryRoot
    FullNameFilter = $FullNameFilter
    Tag = $Tag
    ExcludeTag = $ExcludeTag
    ResultFormat = $ResultFormat
    OutputVerbosity = $OutputVerbosity
}
if (-not [string]::IsNullOrWhiteSpace($PesterManifest)) {
    $adapterParameters.PesterManifest = $PesterManifest
}
if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) {
    $adapterParameters.PowerShellPath = $PowerShellPath
}

$jobs = @(adapters\Get-PesterBatchJob @adapterParameters)
$compiled = batch-executor\New-BatchPlan -Job $jobs -BasePath $jobs[0].WorkingDirectory
if ($compiled.Errors.Count -gt 0 -or $null -eq $compiled.Plan) {
    throw "parallel.ps1: plan validation failed: $(@($compiled.Errors) -join '; ')"
}

$execution = batch-executor\Invoke-BatchPlan -Plan $compiled `
    -MaxWorkers $MaxWorkers -ReservedCores $ReservedCores `
    -MinItemsPerWorker $MinItemsPerWorker -SerializationDepth $SerializationDepth `
    -ProcessTimeoutSeconds $ProcessTimeoutSeconds -WaitTimeoutSeconds $WaitTimeoutSeconds `
    -ProcessEnvironment $ProcessEnvironment -CreateNoWindow $CreateNoWindow `
    -WindowStyle $WindowStyle -LoadProfile:$LoadProfile -PriorityClass $PriorityClass

$summary = $execution.Summary
$infrastructureErrors = @($execution.Errors).Count
Write-Information -InformationAction Continue -MessageData (
    'Pester batch: total={0}; succeeded={1}; failed={2}; timed-out={3}; cancelled={4}; infrastructure-errors={5}; duration-ms={6}' -f
    $summary.Total, $summary.Succeeded, $summary.Failed, $summary.TimedOut,
    $summary.Cancelled, $infrastructureErrors, $execution.Timing.TotalMs)

$execution
if ($summary.Succeeded -ne $summary.Total -or $infrastructureErrors -gt 0) {
    throw ('parallel.ps1: batch did not succeed: failed={0}; timed-out={1}; cancelled={2}; infrastructure-errors={3}' -f
        $summary.Failed, $summary.TimedOut,
        $summary.Cancelled, $infrastructureErrors)
}
