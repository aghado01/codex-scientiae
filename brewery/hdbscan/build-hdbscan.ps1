#requires -Version 7
<#
.SYNOPSIS
  Verify and publish the hdbscan clustering tool to packages/hdbscan.

.DESCRIPTION
  First-party engine source lives under src/hdbscan. This brewery recipe places all
  compilation intermediates and publish staging under artifacts/hdbscan (bin and obj via
  Directory.Build.props, publish below), runs the C# smoke harness, and releases the
  invocable exe to packages/hdbscan. artifacts/ is working output only — the delivered
  payload lives in packages/.

  Default is a framework-dependent single-file exe: the portable PDenv carries the .NET 10
  runtime, so this stays lean. Pass -SelfContained when the exe must run outside PDenv
  (bundles the runtime; larger, no runtime dependency).

  Not trimmed: the CLI uses reflection-based System.Text.Json. If trimming/AOT is ever
  wanted, add a JsonSerializerContext source-gen first, then -p:PublishTrimmed=true.

.EXAMPLE
  ./brewery/hdbscan/build-hdbscan.ps1                 # framework-dependent → packages/hdbscan
.EXAMPLE
  ./brewery/hdbscan/build-hdbscan.ps1 -SelfContained  # self-contained (travels outside PDenv)
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
# Both csprojs sit in this recipe directory, so name the one to publish explicitly — a
# first-match glob would be a coin toss between the CLI and its test project.
$cliProject = Join-Path $PSScriptRoot 'Hdbscan.csproj'
$testsProject = Join-Path $PSScriptRoot 'hdbscan.tests.csproj'
$packageDir = Join-Path $repo 'packages/hdbscan'
# Publish staging is a stage of hdbscan's own build, so it lives with hdbscan's other build
# output under artifacts/hdbscan — never a top-level artifacts/publish bucket. Nothing is
# delivered from artifacts: the payload is released to packages/hdbscan below.
$stagingDir = Join-Path $repo 'artifacts/hdbscan/publish'
$packagesRoot = [IO.Path]::GetFullPath((Join-Path $repo 'packages'))
$artifactsRoot = [IO.Path]::GetFullPath((Join-Path $repo 'artifacts'))

if ([IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($packageDir)) -ne $packagesRoot) {
    throw "Refusing unsafe package target: $packageDir"
}
if (-not [IO.Path]::GetFullPath($stagingDir).StartsWith($artifactsRoot + [IO.Path]::DirectorySeparatorChar)) {
    throw "Refusing unsafe staging target: $stagingDir"
}

if (-not $SkipTests) {
    & dotnet run --project $testsProject -c $Configuration
    if ($LASTEXITCODE -ne 0) { throw "hdbscan smoke harness failed ($LASTEXITCODE)." }
}

if (Test-Path -LiteralPath $stagingDir) {
    Remove-Item -LiteralPath $stagingDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null

$publishArgs = @(
    'publish', $cliProject
    '-c', $Configuration
    '-r', $Runtime
    ($SelfContained ? '--self-contained' : '--no-self-contained')   # bare switches; the space form '--self-contained false' misparses to true
    '-p:PublishSingleFile=true'
    '-o', $stagingDir
)
if ($SelfContained) {
    $publishArgs += '-p:IncludeNativeLibrariesForSelfExtract=true'
    $publishArgs += '-p:EnableCompressionInSingleFile=true'
}

& dotnet @publishArgs
if ($LASTEXITCODE -ne 0) { throw "hdbscan publish failed ($LASTEXITCODE)." }

$executable = Join-Path $stagingDir 'hdbscan.exe'
if (-not (Test-Path -LiteralPath $executable)) {
    throw 'Publish succeeded but hdbscan.exe was not found in staging — check AssemblyName.'
}

if (Test-Path -LiteralPath $packageDir) {
    Remove-Item -LiteralPath $packageDir -Recurse -Force
}
Move-Item -LiteralPath $stagingDir -Destination $packageDir

Write-Host "hdbscan payload refreshed at $packageDir" -ForegroundColor Green
