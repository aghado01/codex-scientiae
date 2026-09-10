#requires -Version 7.5
<#
  Compiles BatchExecutor.Native (net9.0-windows) into artifacts/batch-executor/bin/,
  then releases the DLL to packages/batch-executor/.
#>
[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')] [string] $Configuration = 'Release'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$recipeRoot = $PSScriptRoot
$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $recipeRoot '../..'))
$csproj = Join-Path $recipeRoot 'BatchExecutor.Native.csproj'
if (-not (Test-Path -LiteralPath $csproj -PathType Leaf)) {
    throw "batch-executor native recipe not found: '$csproj'"
}

$dotnet = Get-Command dotnet -ErrorAction Stop
& $dotnet.Source build $csproj -c $Configuration
if ($LASTEXITCODE -ne 0) {
    throw "dotnet build failed for BatchExecutor.Native ($Configuration)"
}

$built = Join-Path $repositoryRoot (
    "artifacts/batch-executor/bin/BatchExecutor.Native/$Configuration/net9.0-windows/BatchExecutor.Native.dll")
if (-not (Test-Path -LiteralPath $built -PathType Leaf)) {
    throw "batch-executor native build did not produce '$built'"
}

$packages = Join-Path $repositoryRoot 'packages/batch-executor'
[void][System.IO.Directory]::CreateDirectory($packages)
Copy-Item -LiteralPath $built -Destination (Join-Path $packages 'BatchExecutor.Native.dll') -Force
$pdb = [System.IO.Path]::ChangeExtension($built, '.pdb')
if (Test-Path -LiteralPath $pdb -PathType Leaf) {
    Copy-Item -LiteralPath $pdb -Destination (Join-Path $packages 'BatchExecutor.Native.pdb') -Force
}

Write-Output $packages
