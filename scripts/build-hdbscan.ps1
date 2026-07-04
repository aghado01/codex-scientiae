#requires -Version 7
<#
.SYNOPSIS
  Publish the hdbscan clustering tool to bin/hdbscan/ as an invocable exe.

.DESCRIPTION
  Repo build-release convention (one build-<tool>.ps1 per C# tool under scripts/). Dev
  builds land in artifacts/ (via Directory.Build.props); RELEASE binaries — the exes the
  PowerShell lanes shell out to — land in bin/<project>/, which is already git-ignored.
  Default is a framework-dependent single-file exe: the portable PDenv carries the .NET 10
  runtime, so this stays lean. Pass -SelfContained when the exe must run outside PDenv
  (bundles the runtime; larger, no runtime dependency).

  Not trimmed: the CLI uses reflection-based System.Text.Json. If trimming/AOT is ever
  wanted, add a JsonSerializerContext source-gen first, then -p:PublishTrimmed=true.

.EXAMPLE
  ./scripts/build-hdbscan.ps1                    # framework-dependent hdbscan.exe → bin/hdbscan/
.EXAMPLE
  ./scripts/build-hdbscan.ps1 -SelfContained     # self-contained (travels outside PDenv)
.EXAMPLE
  ./scripts/build-hdbscan.ps1 -Rid win-x64
#>
[CmdletBinding()]
param(
    [string] $Project = 'hdbscan',
    [string] $Configuration = 'Release',
    [string] $Rid = 'win-x64',
    [switch] $SelfContained,
    [string] $OutDir
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent   # scripts/ → repo root

$projDir = Join-Path $root "projects/$Project"
if (-not (Test-Path $projDir)) { throw "no project dir: projects/$Project" }
$csproj = Get-ChildItem -Path $projDir -Filter '*.csproj' -File | Select-Object -First 1
if (-not $csproj) { throw "no .csproj under projects/$Project" }

if (-not $OutDir) { $OutDir = Join-Path $root "bin/$Project" }

$dotnetArgs = @(
    'publish', $csproj.FullName
    '-c', $Configuration
    '-r', $Rid
    ($SelfContained ? '--self-contained' : '--no-self-contained')   # bare switches; the space form '--self-contained false' misparses to true
    '-p:PublishSingleFile=true'
    '-o', $OutDir
)
if ($SelfContained) {
    $dotnetArgs += '-p:IncludeNativeLibrariesForSelfExtract=true'
    $dotnetArgs += '-p:EnableCompressionInSingleFile=true'
}

Write-Host "publishing $($csproj.Name) ($($SelfContained ? 'self-contained' : 'framework-dependent'), $Rid) → $OutDir" -ForegroundColor Cyan
& dotnet @dotnetArgs
if ($LASTEXITCODE -ne 0) { throw "dotnet publish failed ($LASTEXITCODE)" }

$exe = Join-Path $OutDir "$Project.exe"
if (Test-Path $exe) {
    Write-Host "ok → $exe" -ForegroundColor Green
} else {
    Write-Warning "publish reported success but $exe was not found — check AssemblyName."
}
