#requires -Version 7
<#
.SYNOPSIS
  Verify and publish the Doccer engine payload to packages/doccer.

.DESCRIPTION
  First-party engine source lives under src/doccer. This brewery recipe places all
  compilation intermediates under artifacts through Directory.Build.props, runs the
  dependency-free contract harness, and publishes the reusable assembly plus thin CLI
  into packages/doccer.
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
$stagingDir = Join-Path $repo 'artifacts/publish/doccer'
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
    if ($LASTEXITCODE -ne 0) { throw "Doccer contract harness failed ($LASTEXITCODE)." }
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

Write-Host "Doccer payload refreshed at $packageDir" -ForegroundColor Green
