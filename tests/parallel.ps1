#requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter(Position = 0)] [ValidateNotNullOrEmpty()]
    [string[]] $Path = @($PSScriptRoot),
    [AllowEmptyCollection()] [string[]] $PesterPath = @(),
    [AllowEmptyCollection()] [string[]] $PytestPath = @(),
    # Caller-owned. Omit it and the run mints artifacts/test-runs/{stamp}[_NN] through the
    # logistics minting authority (src/logistics/run-paths.ps1, New-TestRunDir) and points
    # TEMP/TMP/TMPDIR at {run}/temp so the artifact boundary is satisfied without three manual
    # environment variables. Supply it and nothing about the environment is touched.
    [string] $RunDirectory,
    [ValidateSet('Pester', 'Pytest', 'All')]
    [string] $Framework = 'All',
    [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
        ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))),
    [string] $PesterManifest,
    [string] $PythonPath,
    [string] $PytestConfig,
    [string] $PowerShellPath,
    [AllowEmptyCollection()] [string[]] $FullNameFilter = @(),
    [AllowEmptyCollection()] [string[]] $Tag = @(),
    [AllowEmptyCollection()] [string[]] $ExcludeTag = @(),
    [ValidateSet('NUnitXml', 'NUnit2.5', 'NUnit3', 'JUnitXml')]
    [string] $ResultFormat = 'NUnitXml',
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [string] $OutputVerbosity = 'None',
    [string] $KeywordExpression,
    [string] $MarkerExpression,
    [ValidateSet('Quiet', 'Normal', 'Verbose')]
    [string] $PytestOutputVerbosity = 'Quiet',
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

if ([string]::IsNullOrWhiteSpace($RunDirectory)) {
    # One minting authority for the stamp; this script does not format its own.
    . ([System.IO.Path]::Combine($sourceRoot, 'logistics', 'run-paths.ps1'))
    $RunDirectory = New-TestRunDir -ArtifactsRoot (
        [System.IO.Path]::Combine($RepositoryRoot, 'artifacts'))
    $mintedTemp = Join-Path $RunDirectory 'temp'
    New-Item -ItemType Directory -Force -Path $mintedTemp | Out-Null
    foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
        Set-Item -LiteralPath "env:$name" -Value $mintedTemp
    }
    Write-Information "parallel.ps1: minted run directory $RunDirectory" -InformationAction Continue
}
$adaptersManifest = [System.IO.Path]::Combine($sourceRoot, 'batch-adapters', 'adapters.psd1')
$executorManifest = [System.IO.Path]::Combine(
    $sourceRoot, 'batch-executor', 'batch-executor.psd1')
Import-Module -Name $executorManifest -ErrorAction Stop
Import-Module -Name $adaptersManifest -ErrorAction Stop

$pesterAdapterParameters = @{
    Path = if ($PesterPath.Count -gt 0) { $PesterPath } else { $Path }
    RunDirectory = $RunDirectory
    RepositoryRoot = $RepositoryRoot
    FullNameFilter = $FullNameFilter
    Tag = $Tag
    ExcludeTag = $ExcludeTag
    ResultFormat = $ResultFormat
    OutputVerbosity = $OutputVerbosity
}
if (-not [string]::IsNullOrWhiteSpace($PesterManifest)) {
    $pesterAdapterParameters.PesterManifest = $PesterManifest
}
if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) {
    $pesterAdapterParameters.PowerShellPath = $PowerShellPath
}

$pytestAdapterParameters = @{
    Path = if ($PytestPath.Count -gt 0) { $PytestPath } else { $Path }
    RunDirectory = $RunDirectory
    RepositoryRoot = $RepositoryRoot
    OutputVerbosity = $PytestOutputVerbosity
}
if (-not [string]::IsNullOrWhiteSpace($PythonPath)) {
    $pytestAdapterParameters.PythonPath = $PythonPath
}
if (-not [string]::IsNullOrWhiteSpace($PytestConfig)) {
    $pytestAdapterParameters.PytestConfig = $PytestConfig
}
if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) {
    $pytestAdapterParameters.PowerShellPath = $PowerShellPath
}
if (-not [string]::IsNullOrWhiteSpace($KeywordExpression)) {
    $pytestAdapterParameters.KeywordExpression = $KeywordExpression
}
if (-not [string]::IsNullOrWhiteSpace($MarkerExpression)) {
    $pytestAdapterParameters.MarkerExpression = $MarkerExpression
}

$pesterJobs = if ($Framework -in @('Pester', 'All')) {
    @(adapters\Get-PesterBatchJob @pesterAdapterParameters)
}
else { @() }
$pytestJobs = if ($Framework -in @('Pytest', 'All')) {
    @(adapters\Get-PytestBatchJob @pytestAdapterParameters)
}
else { @() }
$jobs = @($pesterJobs) + @($pytestJobs)
if ($jobs.Count -eq 0) {
    throw "parallel.ps1: framework '$Framework' produced no jobs"
}
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
    'Test batch: framework={0}; total={1}; succeeded={2}; failed={3}; timed-out={4}; cancelled={5}; infrastructure-errors={6}; duration-ms={7}' -f
    $Framework, $summary.Total, $summary.Succeeded, $summary.Failed, $summary.TimedOut,
    $summary.Cancelled, $infrastructureErrors, $execution.Timing.TotalMs)

$execution
if ($summary.Succeeded -ne $summary.Total -or $infrastructureErrors -gt 0) {
    throw ('parallel.ps1: batch did not succeed: failed={0}; timed-out={1}; cancelled={2}; infrastructure-errors={3}' -f
        $summary.Failed, $summary.TimedOut,
        $summary.Cancelled, $infrastructureErrors)
}
