#requires -Version 7.0
<#
.SYNOPSIS
  Restore the pinned uv, Python, project environment, and procurement MCP registrations.

.DESCRIPTION
  pin.json is the uv bootstrap authority. The verified executable is published under packages/uv,
  managed Python is installed under packages/python, and uv synchronizes .venv from uv.lock. All
  download, cache, and temporary paths remain below the repository artifacts tree. Before the
  project sync, restore stops processes that hold this checkout's .venv or the procurement MCP
  console script so Windows can replace those executables.
#>
[CmdletBinding()]
param(
    [switch] $SkipRegistration,
    [switch] $SkipOccupantStop
)

$ErrorActionPreference = 'Stop'
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$artifactsRoot = Join-Path $repoRoot 'artifacts'
$packagesRoot = Join-Path $repoRoot 'packages'
$packageRoot = Join-Path $packagesRoot 'uv'
$pythonRoot = Join-Path $packagesRoot 'python'
$cacheRoot = Join-Path $artifactsRoot 'uv/cache'
$downloadRoot = Join-Path $cacheRoot 'downloads'
$restoreRoot = Join-Path $artifactsRoot 'uv/restore'
$pinPath = Join-Path $PSScriptRoot 'pin.json'
. (Join-Path $PSScriptRoot 'venv-occupants.ps1')

function Assert-Descendant([string] $Path, [string] $Parent, [string] $Label) {
    $full = [System.IO.Path]::GetFullPath($Path)
    $parentFull = [System.IO.Path]::GetFullPath($Parent).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)
    $prefix = $parentFull + [System.IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "$Label must remain below $parentFull`: $full"
    }
}

foreach ($entry in @(
        @($packageRoot, $packagesRoot, 'uv package root'),
        @($pythonRoot, $packagesRoot, 'managed Python root'),
        @($cacheRoot, $artifactsRoot, 'uv cache root'),
        @($downloadRoot, $cacheRoot, 'uv download cache'),
        @($restoreRoot, $artifactsRoot, 'uv restore root')
    )) {
    Assert-Descendant -Path $entry[0] -Parent $entry[1] -Label $entry[2]
}

$pin = Get-Content -LiteralPath $pinPath -Raw | ConvertFrom-Json -AsHashtable
if ($pin.schema -cne 'codex-scientiae/toolchain-pin/1' -or $pin.tool -cne 'uv') {
    throw "unsupported uv pin contract: $pinPath"
}
$pythonVersion = (Get-Content -LiteralPath (Join-Path $repoRoot '.python-version') -Raw).Trim()
if ($pythonVersion -cne $pin.python_version) {
    throw ".python-version ($pythonVersion) differs from uv pin ($($pin.python_version))"
}

if (-not $IsWindows) { throw 'the committed uv bootstrap currently supports Windows only' }
$platformKey = switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    ([System.Runtime.InteropServices.Architecture]::X64) { 'windows-x64' }
    ([System.Runtime.InteropServices.Architecture]::Arm64) { 'windows-arm64' }
    default { throw "unsupported Windows architecture: $_" }
}
if (-not $pin.artifacts.ContainsKey($platformKey)) {
    throw "uv pin has no artifact for $platformKey"
}
$artifact = $pin.artifacts[$platformKey]
if ($artifact.url -notmatch '^https://github\.com/astral-sh/uv/releases/download/') {
    throw "uv artifact URL is outside the declared upstream: $($artifact.url)"
}
if ($artifact.sha256 -notmatch '^[0-9a-f]{64}$') {
    throw "uv artifact digest is malformed for $platformKey"
}

[System.IO.Directory]::CreateDirectory($restoreRoot) | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$runRoot = Join-Path $restoreRoot $stamp
$serial = 1
while ([System.IO.Directory]::Exists($runRoot)) {
    $runRoot = Join-Path $restoreRoot ('{0}_{1:d2}' -f $stamp, $serial)
    $serial++
}
[System.IO.Directory]::CreateDirectory($runRoot) | Out-Null
$runTemp = Join-Path $runRoot 'temp'
$extractRoot = Join-Path $runRoot 'extract'
[System.IO.Directory]::CreateDirectory($runTemp) | Out-Null
[System.IO.Directory]::CreateDirectory($extractRoot) | Out-Null

$environmentNames = @(
    'TEMP', 'TMP', 'TMPDIR', 'UV_CACHE_DIR', 'UV_PYTHON_INSTALL_DIR',
    'UV_PROJECT_ENVIRONMENT', 'UV_NO_PROGRESS'
)
$previousEnvironment = @{}
foreach ($name in $environmentNames) {
    $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
}
$env:TEMP = $runTemp
$env:TMP = $runTemp
$env:TMPDIR = $runTemp
$env:UV_CACHE_DIR = $cacheRoot
$env:UV_PYTHON_INSTALL_DIR = $pythonRoot
$env:UV_PROJECT_ENVIRONMENT = Join-Path $repoRoot '.venv'
$env:UV_NO_PROGRESS = '1'

$succeeded = $false
try {
    [System.IO.Directory]::CreateDirectory($downloadRoot) | Out-Null
    $archivePath = Join-Path $downloadRoot $artifact.archive
    $archiveCurrent = $false
    if ([System.IO.File]::Exists($archivePath)) {
        $archiveCurrent = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).
            Hash.ToLowerInvariant() -ceq $artifact.sha256
    }
    if (-not $archiveCurrent) {
        $downloadPath = Join-Path $runRoot $artifact.archive
        Invoke-WebRequest -Uri $artifact.url -OutFile $downloadPath
        $archiveHash = (Get-FileHash -LiteralPath $downloadPath -Algorithm SHA256).
            Hash.ToLowerInvariant()
        if ($archiveHash -cne $artifact.sha256) {
            throw "uv archive digest mismatch: expected $($artifact.sha256), observed $archiveHash"
        }
        $pendingArchive = "$archivePath.pending"
        if ([System.IO.File]::Exists($pendingArchive)) {
            [System.IO.File]::Delete($pendingArchive)
        }
        [System.IO.File]::Copy($downloadPath, $pendingArchive, $false)
        [System.IO.File]::Move($pendingArchive, $archivePath, $true)
    }

    [System.IO.Compression.ZipFile]::ExtractToDirectory($archivePath, $extractRoot)
    $uvCandidates = @(Get-ChildItem -LiteralPath $extractRoot -Filter uv.exe -File -Recurse)
    if ($uvCandidates.Count -ne 1) {
        throw "uv archive must contain exactly one uv.exe; found $($uvCandidates.Count)"
    }

    [System.IO.Directory]::CreateDirectory($packageRoot) | Out-Null
    $packageUv = Join-Path $packageRoot 'uv.exe'
    $pendingUv = Join-Path $packageRoot 'uv.exe.pending'
    if ([System.IO.File]::Exists($pendingUv)) {
        [System.IO.File]::Delete($pendingUv)
    }
    [System.IO.File]::Copy($uvCandidates[0].FullName, $pendingUv, $false)
    if ((Get-FileHash -LiteralPath $pendingUv -Algorithm SHA256).Hash -cne
        (Get-FileHash -LiteralPath $uvCandidates[0].FullName -Algorithm SHA256).Hash) {
        throw 'published uv executable differs from the verified archive member'
    }
    [System.IO.File]::Move($pendingUv, $packageUv, $true)

    $uvVersion = (& $packageUv --version | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or $uvVersion -notmatch "^uv $([regex]::Escape($pin.version))\s") {
        throw "restored uv version does not match pin $($pin.version): $uvVersion"
    }

    & $packageUv python install $pythonVersion
    if ($LASTEXITCODE -ne 0) { throw "uv python install failed ($LASTEXITCODE)" }
    if (-not $SkipOccupantStop) {
        Stop-ProjectVenvOccupants -RepositoryRoot $repoRoot
    }
    & $packageUv sync --project $repoRoot --locked --managed-python --python $pythonVersion `
        --no-install-project
    if ($LASTEXITCODE -ne 0) { throw "uv dependency sync failed ($LASTEXITCODE)" }
    & $packageUv sync --project $repoRoot --locked --managed-python --python $pythonVersion `
        --no-build-isolation
    if ($LASTEXITCODE -ne 0) { throw "uv project sync failed ($LASTEXITCODE)" }

    $legacyEnvironmentUv = Join-Path $repoRoot '.venv/Scripts/uv.exe'
    Assert-Descendant -Path $legacyEnvironmentUv -Parent $repoRoot `
        -Label 'legacy environment uv executable'
    if ([System.IO.File]::Exists($legacyEnvironmentUv)) {
        [System.IO.File]::Delete($legacyEnvironmentUv)
    }

    & $packageUv run --project $repoRoot --locked --no-sync --no-dev --offline `
        python (Join-Path $PSScriptRoot 'verify-install.py')
    if ($LASTEXITCODE -ne 0) { throw "procurement MCP install verification failed ($LASTEXITCODE)" }

    if (-not $SkipRegistration) {
        & (Join-Path $PSScriptRoot 'write-mcp-registration.ps1') -RepositoryRoot $repoRoot
        if ($LASTEXITCODE -ne 0) { throw "MCP registration generation failed ($LASTEXITCODE)" }
    }

    $succeeded = $true
    [pscustomobject]@{
        pin = $pinPath
        uv = $packageUv
        uv_version = $uvVersion
        python_version = $pythonVersion
        environment = Join-Path $repoRoot '.venv'
        managed_python_root = $pythonRoot
        cache_root = $cacheRoot
    }
}
finally {
    foreach ($name in $environmentNames) {
        [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name], 'Process')
    }
    if ($succeeded -and [System.IO.Directory]::Exists($runRoot)) {
        Assert-Descendant -Path $runRoot -Parent $restoreRoot -Label 'successful restore scratch'
        Remove-Item -LiteralPath $runRoot -Recurse -Force
    }
    elseif (-not $succeeded) {
        Write-Warning "uv restore failed; retained bounded evidence at $runRoot"
    }
}
