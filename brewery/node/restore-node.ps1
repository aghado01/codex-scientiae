#requires -Version 7.0
<#
.SYNOPSIS
  Rehydrate the centralized Node dependency payload under packages/node.

.DESCRIPTION
  brewery/node owns the canonical package.json and package-lock.json.
  packages/node is the materialized dependency shelf. npm requires its manifest
  and lock beside node_modules, so this recipe stages exact generated copies and
  runs npm ci against that prefix. npm's download cache is transient and defaults
  to artifacts/node/npm-cache.

  npm ci replaces the destination node_modules tree with the exact locked graph.
#>
[CmdletBinding()]
param(
    [string] $PackageRoot,
    [string] $CacheRoot
)

$ErrorActionPreference = 'Stop'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
if (-not $PackageRoot) { $PackageRoot = Join-Path $repoRoot 'packages/node' }
if (-not $CacheRoot) { $CacheRoot = Join-Path $repoRoot 'artifacts/node/npm-cache' }

$PackageRoot = [System.IO.Path]::GetFullPath($PackageRoot)
$CacheRoot = [System.IO.Path]::GetFullPath($CacheRoot)

$pathRoot = [System.IO.Path]::GetPathRoot($PackageRoot)
$userHome = [System.IO.Path]::GetFullPath([Environment]::GetFolderPath('UserProfile'))
if (($PackageRoot -eq $pathRoot) -or ($PackageRoot -eq $repoRoot) -or ($PackageRoot -eq $userHome)) {
    throw "refusing unsafe Node package root: $PackageRoot"
}

$manifest = Join-Path $PSScriptRoot 'package.json'
$lock = Join-Path $PSScriptRoot 'package-lock.json'
if (-not (Test-Path -LiteralPath $manifest)) { throw "missing canonical manifest: $manifest" }
if (-not (Test-Path -LiteralPath $lock)) { throw "missing canonical lock: $lock" }

$npm = Get-Command npm.cmd -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $npm) { throw 'npm.cmd not found; restore requires the ambient Node/npm toolchain' }

New-Item -ItemType Directory -Force -Path $PackageRoot, $CacheRoot | Out-Null
Copy-Item -LiteralPath $manifest -Destination (Join-Path $PackageRoot 'package.json') -Force
Copy-Item -LiteralPath $lock -Destination (Join-Path $PackageRoot 'package-lock.json') -Force

Write-Host "restoring locked Node packages -> $PackageRoot/node_modules" -ForegroundColor Cyan
& $npm.Source ci --prefix $PackageRoot --cache $CacheRoot --no-audit --no-fund
if ($LASTEXITCODE -ne 0) { throw "npm ci failed ($LASTEXITCODE)" }

& $npm.Source ls --prefix $PackageRoot --depth=0
if ($LASTEXITCODE -ne 0) { throw "npm dependency verification failed ($LASTEXITCODE)" }

$canonicalLockHash = (Get-FileHash -LiteralPath $lock -Algorithm SHA256).Hash
$stagedLockHash = (Get-FileHash -LiteralPath (Join-Path $PackageRoot 'package-lock.json') -Algorithm SHA256).Hash
if ($canonicalLockHash -ne $stagedLockHash) {
    throw 'staged package-lock.json drifted from the canonical brewery lock'
}

[pscustomobject]@{
    recipe_root = $PSScriptRoot
    package_root = $PackageRoot
    node_modules = Join-Path $PackageRoot 'node_modules'
    cache_root = $CacheRoot
    node_version = (& node --version)
    npm_version = (& $npm.Source --version)
    lock_sha256 = $canonicalLockHash
}
