#requires -Version 7
<#
.SYNOPSIS
  Verify and publish the Doccer engine payload to packages/doccer.

.DESCRIPTION
  First-party engine source lives under src/doccer. This brewery recipe places all
  compilation intermediates and publish staging under artifacts/doccer (bin and obj via
  Directory.Build.props, publish below), runs the dependency-free contract harness, and
  releases the reusable assembly plus thin CLI to packages/doccer. artifacts/ is working
  output only — the delivered payload lives in packages/.
#>
[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')]
    [string] $Configuration = 'Release',
    [string] $Runtime = 'win-x64',
    [switch] $SelfContained,
    [switch] $SkipTests
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$testsProject = Join-Path $PSScriptRoot 'Doccer.Tests.csproj'
$cliProject = Join-Path $PSScriptRoot 'Doccer.Cli.csproj'
$packageDir = Join-Path $repo 'packages/doccer'
# Publish staging is a stage of doccer's own build, so it lives with doccer's other build
# output under artifacts/doccer — never a top-level artifacts/publish bucket. Nothing is
# delivered from artifacts: the payload is released to packages/doccer below.
$stagingDir = Join-Path $repo 'artifacts/doccer/publish'
$packagesRoot = [IO.Path]::GetFullPath((Join-Path $repo 'packages'))
$artifactsRoot = [IO.Path]::GetFullPath((Join-Path $repo 'artifacts'))

if ([IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($packageDir)) -ne $packagesRoot) {
    throw "Refusing unsafe package target: $packageDir"
}
if (-not [IO.Path]::GetFullPath($stagingDir).StartsWith($artifactsRoot + [IO.Path]::DirectorySeparatorChar)) {
    throw "Refusing unsafe staging target: $stagingDir"
}

$harnessChecks = $null
if (-not $SkipTests) {
    $harnessOutput = & dotnet run --project $testsProject -c $Configuration
    if ($LASTEXITCODE -ne 0) { throw "Doccer contract harness failed ($LASTEXITCODE)." }
    $harnessOutput | Write-Host
    $harnessMatch = [regex]::Match(($harnessOutput -join "`n"), 'harness: (\d+) checks passed')
    if ($harnessMatch.Success) { $harnessChecks = [int]$harnessMatch.Groups[1].Value }
}

if (Test-Path -LiteralPath $stagingDir) {
    Remove-Item -LiteralPath $stagingDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null

$publishArgs = @(
    'publish', $cliProject
    '-c', $Configuration
    '-r', $Runtime
    ($SelfContained ? '--self-contained' : '--no-self-contained')
    '-p:PublishSingleFile=false'
    '-o', $stagingDir
)

& dotnet @publishArgs
if ($LASTEXITCODE -ne 0) { throw "Doccer publish failed ($LASTEXITCODE)." }

$assembly = Join-Path $stagingDir 'CodexSci.Doccer.dll'
$executable = Join-Path $stagingDir 'doccer.exe'
if (-not (Test-Path -LiteralPath $assembly) -or -not (Test-Path -LiteralPath $executable)) {
    throw 'Publish succeeded but the expected Doccer library and CLI payloads were not both found.'
}

if (Test-Path -LiteralPath $packageDir) {
    Remove-Item -LiteralPath $packageDir -Recurse -Force
}
Move-Item -LiteralPath $stagingDir -Destination $packageDir

# Smoke-test the DELIVERED payload, not the build output: load the packaged assembly, assert the
# public surface consumers bind against, and run the packaged CLI once. Runs in a child process
# so the loaded DLL is never locked by this session. The manifest is written only after this
# passes — a package without doccer.manifest.json is an unverified package.
$smokeScript = @'
param([string] $PackageDir)
$ErrorActionPreference = 'Stop'
$assembly = [System.Reflection.Assembly]::LoadFrom((Join-Path $PackageDir 'CodexSci.Doccer.dll'))
$expectedTypes = @(
    'CodexSci.Doccer.TextMaster'
    'CodexSci.Doccer.TextSpan'
    'CodexSci.Doccer.TextTopology'
    'CodexSci.Doccer.SpanBatch'
    'CodexSci.Doccer.SpanBatchBuilder'
    'CodexSci.Doccer.ClaimSelection'
    'CodexSci.Doccer.ClaimPairView'
    'CodexSci.Doccer.ClaimPairWitnessView'
    'CodexSci.Doccer.PairingPolicy'
    'CodexSci.Doccer.PairingResult'
    'CodexSci.Doccer.PairingFaults'
    'CodexSci.Doccer.Pairing'
    'CodexSci.Doccer.SortedSpanLookup'
    'CodexSci.Doccer.SpanSet'
    'CodexSci.Doccer.LocatedRelation'
    'CodexSci.Doccer.CandidateRegionGraph'
    'CodexSci.Doccer.ReachabilityView'
    'CodexSci.Doccer.PartitionView'
    'CodexSci.Doccer.SegmentationPolicy'
    'CodexSci.Doccer.SegmentationResult'
    'CodexSci.Doccer.SegmentationResidual'
    'CodexSci.Doccer.Segmentation'
    'CodexSci.Doccer.PathSelectionGuarantee'
    'CodexSci.Doccer.PathTieBreak'
    'CodexSci.Doccer.PathFeasibility'
    'CodexSci.Doccer.AdditivePathPolicy'
    'CodexSci.Doccer.PathSelectionProblem'
    'CodexSci.Doccer.PathSelectionResidual'
    'CodexSci.Doccer.PathSelectionResult'
    'CodexSci.Doccer.PathSelection'
    'CodexSci.Doccer.PackingPolicy'
    'CodexSci.Doccer.PackingView'
    'CodexSci.Doccer.CoverPolicy'
    'CodexSci.Doccer.CoverView'
    'CodexSci.Doccer.LaminarCrossingRule'
    'CodexSci.Doccer.LaminarFamilyPolicy'
    'CodexSci.Doccer.LaminarGroup'
    'CodexSci.Doccer.LaminarView'
    'CodexSci.Doccer.LaminarAdmissionOrder'
    'CodexSci.Doccer.LaminarAdmissionGuarantee'
    'CodexSci.Doccer.LaminarAdmissionPolicy'
    'CodexSci.Doccer.LaminarAdmissionResult'
    'CodexSci.Doccer.Laminarizer'
    'CodexSci.Doccer.HierarchyConstruction'
    'CodexSci.Doccer.HierarchyTieBreak'
    'CodexSci.Doccer.HierarchyPolicy'
    'CodexSci.Doccer.HierarchyEdge'
    'CodexSci.Doccer.HierarchyView'
    'CodexSci.Doccer.LaminarHierarchy'
    'CodexSci.Doccer.ResolutionLayerPolicy'
    'CodexSci.Doccer.ResolutionView'
    'CodexSci.Doccer.ResolutionMapContract'
    'CodexSci.Doccer.ResolutionMapPolicy'
    'CodexSci.Doccer.ResolutionEdge'
    'CodexSci.Doccer.ResolutionMap'
    'CodexSci.Doccer.RegexCollector'
    'CodexSci.Doccer.PatternRule'
    'CodexSci.Doccer.ExecutionScope'
    'CodexSci.Doccer.PatternRuleLoader'
    'CodexSci.Doccer.AllenAlgebra'
    'CodexSci.Doccer.IntervalJoins'
    'CodexSci.Doccer.Suppression'
    'CodexSci.Doccer.DoccerValidation'
)
foreach ($typeName in $expectedTypes) {
    if ($null -eq $assembly.GetType($typeName, $false)) {
        throw "Packaged assembly is missing expected public type $typeName."
    }
}
$lookup = $assembly.GetType('CodexSci.Doccer.SortedSpanLookup', $true)
if ($null -eq $lookup.GetMethod('FindContaining')) {
    throw 'Packaged SortedSpanLookup is missing FindContaining.'
}
$pairView = $assembly.GetType('CodexSci.Doccer.ClaimPairView', $true)
if ($null -eq $pairView.GetMethod('ComposePairs') -or
    $null -eq $pairView.GetMethod('GroupMiddleWitnesses')) {
    throw 'Packaged ClaimPairView is missing its exact composition surface.'
}
$pairing = $assembly.GetType('CodexSci.Doccer.Pairing', $true)
$pairingResult = $assembly.GetType('CodexSci.Doccer.PairingResult', $true)
if ($null -eq $pairing.GetMethod('Pair') -or
    $null -eq $pairingResult.GetMethod('PairedRegions')) {
    throw 'Packaged pairing surface is incomplete.'
}
$segmentation = $assembly.GetType('CodexSci.Doccer.Segmentation', $true)
$reachability = $assembly.GetType('CodexSci.Doccer.ReachabilityView', $true)
$partition = $assembly.GetType('CodexSci.Doccer.PartitionView', $true)
if ($null -eq $segmentation.GetMethod('FirstOrdinalCompletePath') -or
    $null -eq $reachability.GetMethod('Create') -or
    $null -eq $partition.GetMethod('Create')) {
    throw 'Packaged K4a segmentation surface is incomplete.'
}
$pathPolicy = $assembly.GetType('CodexSci.Doccer.AdditivePathPolicy', $true)
$pathProblem = $assembly.GetType('CodexSci.Doccer.PathSelectionProblem', $true)
$pathSelection = $assembly.GetType('CodexSci.Doccer.PathSelection', $true)
if ($null -eq $pathPolicy.GetMethod('Create') -or
    $null -eq $pathProblem.GetMethod('Create') -or
    $null -eq $pathSelection.GetMethod('Select')) {
    throw 'Packaged K4b path-selection surface is incomplete.'
}
$packing = $assembly.GetType('CodexSci.Doccer.PackingView', $true)
$cover = $assembly.GetType('CodexSci.Doccer.CoverView', $true)
$laminar = $assembly.GetType('CodexSci.Doccer.LaminarView', $true)
$laminarizer = $assembly.GetType('CodexSci.Doccer.Laminarizer', $true)
$hierarchy = $assembly.GetType('CodexSci.Doccer.HierarchyView', $true)
$laminarHierarchy = $assembly.GetType('CodexSci.Doccer.LaminarHierarchy', $true)
$resolution = $assembly.GetType('CodexSci.Doccer.ResolutionView', $true)
$resolutionMap = $assembly.GetType('CodexSci.Doccer.ResolutionMap', $true)
if ($null -eq $packing.GetMethod('Create') -or
    $null -eq $cover.GetMethod('Create') -or
    $null -eq $laminar.GetMethod('Create') -or
    $null -eq $laminarizer.GetMethod('Admit') -or
    $null -eq $hierarchy.GetMethod('Create') -or
    $null -eq $laminarHierarchy.GetMethod('NearestContainers') -or
    $null -eq $resolution.GetMethod('Create') -or
    $null -eq $resolutionMap.GetMethod('Create')) {
    throw 'Packaged K4c structural-family surface is incomplete.'
}
$relation = & (Join-Path $PackageDir 'doccer.exe') relate 0 5 5 9
if ($LASTEXITCODE -ne 0 -or $relation -ne 'Meets') {
    throw "Packaged CLI failed its smoke run (exit $LASTEXITCODE, output '$relation')."
}
'@
$smokePath = Join-Path ([IO.Path]::GetTempPath()) "doccer-smoke-$([guid]::NewGuid().ToString('N')).ps1"
Set-Content -LiteralPath $smokePath -Value $smokeScript -Encoding utf8
try {
    & pwsh -NoProfile -File $smokePath -PackageDir $packageDir
    if ($LASTEXITCODE -ne 0) { throw "Doccer package smoke test failed ($LASTEXITCODE)." }
}
finally {
    Remove-Item -LiteralPath $smokePath -Force -ErrorAction SilentlyContinue
}

# The manifest answers "what source revision does this payload represent?" — the question a
# selectively refreshed package otherwise cannot answer.
$sourceCommit = (& git -C $repo rev-parse HEAD).Trim()
$sourceDirty = [bool](& git -C $repo status --porcelain -- src/doccer brewery/doccer tests/doccer)
$targetFramework = [regex]::Match(
    (Get-Content -LiteralPath (Join-Path $repo 'Directory.Build.props') -Raw),
    '<TargetFramework>([^<]+)</TargetFramework>').Groups[1].Value
$manifest = [ordered]@{
    name             = 'doccer'
    schemaVersion    = 1
    sourceCommit     = $sourceCommit
    sourceDirty      = $sourceDirty
    buildTimestampUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    configuration    = $Configuration
    runtime          = $Runtime
    targetFramework  = $targetFramework
    selfContained    = [bool]$SelfContained
    harnessChecks    = $harnessChecks
    assemblySha256   = (Get-FileHash -LiteralPath (Join-Path $packageDir 'CodexSci.Doccer.dll') -Algorithm SHA256).Hash
}
$manifestPath = Join-Path $packageDir 'doccer.manifest.json'
[IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json), [Text.UTF8Encoding]::new($false))

Write-Host "Doccer payload refreshed at $packageDir" -ForegroundColor Green
Write-Host "  commit $sourceCommit$(if ($sourceDirty) { ' (dirty)' }); harness checks: $($harnessChecks ?? 'skipped')" -ForegroundColor Green
