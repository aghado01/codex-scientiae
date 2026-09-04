#requires -Version 7.0
<#
  src/infrastructure/containment.ps1 — where project output may live, and how its addresses are minted.

  One file, four layers, in dependency order:

    path safety        Test-PortableLeaf, Test-PathHasReparsePoint, Test-PathIsDescendant
                       pure predicates over names and paths; no repository knowledge
    artifacts tier     Get-ArtifactsRoot, Resolve-ArtifactDescendantPath, Resolve-ArtifactRunDirectory
                       the ONE resolver for a repository's `artifacts/` directory and containment under it
    run minting        New-StampedRunDir, New-ModuleRunDir, New-TestSuiteRunDir, Get-ModuleRunDirs
                       the minting authority for both runstamped tiers
    scratch            Set-TempEnvironment
                       CDXSCI_TEMP for a parent run; child projection lives in assert-temp.ps1

  Runstamped tiers. Stamp format is `yyyyMMdd_HHmmss` in ISO date order (lexical sort = chronological)
  and carries NO label; the `_NN` suffix is a same-second collision sequence, not a description.

    artifacts/{module}/{stamp}/{slug}/        New-ModuleRunDir     per-module run output
    artifacts/tests/{suite}/{stamp}[_NN]/     New-TestSuiteRunDir  test-batch roots

  Two tiers, kept separate on purpose: a test run is not module output. It spans whatever the batch
  selected and holds results, not product, so it lives under the `tests/` process bucket keyed by
  suite rather than beside the module's own artifacts. There is no `runs/` segment in either: the
  stamp under a module IS the run (owner ruling 2026-08-26).

  Every function that needs the repository takes -RepositoryRoot and defaults to this repository.
  The artifacts tier must already exist (artifacts/README.md is tracked); nothing here invents it.
  Ambient TEMP/TMP/TMPDIR are never a project scratch source.

  Suite naming for tests/batch.ps1 lives in tests/suite-name.ps1.
#>

# ---------------------------------------------------------------------------------------------
# path safety
# ---------------------------------------------------------------------------------------------

function Test-PortableLeaf {
    <# One path segment safe on Windows and POSIX: no reserved device name, no dot or dot-dot,
       no trailing dot or space, no separator or control character. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyString()] [string] $Value
    )

    $pattern = '^(?!(?i:(?:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9]))(?:\.|\z))(?!\.{1,2}\z)(?!.*[ .]\z)[^<>:"/\\|?*\x00-\x1F]+\z'
    return [System.Text.RegularExpressions.Regex]::IsMatch(
        $Value, $pattern, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)
}

function Test-PathHasReparsePoint {
    <# True when any EXISTING component of a path is a symlink, junction, or other reparse point.
       Components that do not exist yet are not evidence either way. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path
    )

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $pathRoot = [System.IO.Path]::GetPathRoot($fullPath)
    $relative = [System.IO.Path]::GetRelativePath($pathRoot, $fullPath)
    $current = $pathRoot
    foreach ($segment in @($relative -split '[\\/]' | Where-Object { $_ -and $_ -ne '.' })) {
        $current = [System.IO.Path]::Combine($current, $segment)
        $item = Get-Item -LiteralPath $current -Force -ErrorAction SilentlyContinue
        if ($null -eq $item) { break }
        if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) { return $true }
    }
    return $false
}

function Test-PathIsDescendant {
    <# Lexical strict-descendant test. The root itself is not its own descendant. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Root,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path
    )

    $relative = [System.IO.Path]::GetRelativePath($Root, $Path)
    $parentPrefix = '..' + [System.IO.Path]::DirectorySeparatorChar
    return $relative -ne '.' -and $relative -ne '..' -and
        -not [System.IO.Path]::IsPathFullyQualified($relative) -and
        -not $relative.StartsWith($parentPrefix, [System.StringComparison]::Ordinal)
}

# ---------------------------------------------------------------------------------------------
# artifacts tier
# ---------------------------------------------------------------------------------------------

function Get-ArtifactsRoot {
    <# The artifacts TIER itself — the directory runs live under, never its parent. Resolved, existing,
       and named directly so callers never append 'artifacts' to a root themselves. #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
            ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..')))
    )

    $repository = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if (-not (Test-Path -LiteralPath $repository -PathType Container)) {
        throw "repository root not found: '$RepositoryRoot'"
    }
    $artifactCandidate = [System.IO.Path]::Combine($repository, 'artifacts')
    if (-not (Test-Path -LiteralPath $artifactCandidate -PathType Container)) {
        throw "repository artifacts root not found: '$artifactCandidate'"
    }
    return (Resolve-Path -LiteralPath $artifactCandidate).Path
}

function Resolve-ArtifactDescendantPath {
    <# A lexical descendant of RepositoryRoot/artifacts whose nearest existing ancestor also
       resolves inside it, so an already-present junction or symlink cannot route the write out. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Value,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role,
        [string] $BasePath = $RepositoryRoot
    )

    $artifactRoot = Get-ArtifactsRoot -RepositoryRoot $RepositoryRoot
    $candidate = if ([System.IO.Path]::IsPathFullyQualified($Value)) {
        [System.IO.Path]::GetFullPath($Value)
    }
    else { [System.IO.Path]::GetFullPath($Value, $BasePath) }
    if (-not (Test-PathIsDescendant -Root $artifactRoot -Path $candidate)) {
        throw "$Role must be a descendant of RepositoryRoot/artifacts: '$Value'"
    }

    $existing = $candidate
    while (-not (Test-Path -LiteralPath $existing)) {
        $parent = [System.IO.Path]::GetDirectoryName($existing)
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $existing) {
            throw "$Role has no existing ancestor: '$Value'"
        }
        $existing = $parent
    }
    $resolvedExisting = (Resolve-Path -LiteralPath $existing).Path
    if ($resolvedExisting -ne $artifactRoot -and
            -not (Test-PathIsDescendant -Root $artifactRoot -Path $resolvedExisting)) {
        throw "$Role resolves outside RepositoryRoot/artifacts: '$Value'"
    }
    return $candidate
}

function Resolve-ArtifactRunDirectory {
    <# Absolute existing directory under RepositoryRoot/artifacts. A relative value is resolved
       against RepositoryRoot, not the process working directory. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $resolved = Resolve-ArtifactDescendantPath -Value $RunDirectory `
        -RepositoryRoot $RepositoryRoot -Role 'RunDirectory' -BasePath $RepositoryRoot
    if (-not (Test-Path -LiteralPath $resolved -PathType Container)) {
        throw "RunDirectory must be an existing directory under RepositoryRoot/artifacts: '$RunDirectory'"
    }
    return (Resolve-Path -LiteralPath $resolved).Path
}

# ---------------------------------------------------------------------------------------------
# run minting
# ---------------------------------------------------------------------------------------------

function New-StampedRunDir {
    <# One stamped leaf under a tier root, with the shared `_NN` same-second collision sequence.
       The tier-specific minters below are the public doors; call this directly only for a new tier. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $TierRoot,
        [AllowEmptyString()] [string] $Slug = ''
    )

    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $stampDir = Join-Path $TierRoot $stamp
    $n = 0
    while (Test-Path -LiteralPath $stampDir) {
        $n++
        if ($n -gt 99) { throw "New-StampedRunDir: exhausted _NN suffixes for stamp '$stamp'" }
        $stampDir = Join-Path $TierRoot ('{0}_{1:D2}' -f $stamp, $n)
    }
    $dir = if ([string]::IsNullOrWhiteSpace($Slug)) { $stampDir } else { Join-Path $stampDir $Slug }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    return $dir
}

function New-ModuleRunDir {
    <# {artifacts}/{module}/{stamp}/{slug}/ — per-module run output, created fresh. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Module,
        [AllowEmptyString()] [string] $Slug = '',
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
            ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..')))
    )

    $tierRoot = Join-Path (Get-ArtifactsRoot -RepositoryRoot $RepositoryRoot) $Module
    return New-StampedRunDir -TierRoot $tierRoot -Slug $Slug
}

function New-TestSuiteRunDir {
    <# {artifacts}/tests/{suite}/{stamp}[_NN]/ — test-batch roots, keyed by the suite the batch
       selected. A batch spanning more than one suite is honestly named `mixed` rather than given a
       suite it does not have. tests/batch.ps1 calls this when the caller omits -RunDirectory. #>
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [string] $Suite = '',
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
            ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..')))
    )

    $leaf = if ([string]::IsNullOrWhiteSpace($Suite)) { 'mixed' } else { $Suite }
    $tierRoot = Join-Path (Get-ArtifactsRoot -RepositoryRoot $RepositoryRoot) 'tests' $leaf
    return New-StampedRunDir -TierRoot $tierRoot
}

function Get-ModuleRunDirs {
    <# Newest-first run dirs for one slug under a module, stamp-descending. Harnesses read
       newest-run-wins. Enumerated on output; callers collect with @(...). #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Module,
        [AllowEmptyString()] [string] $Slug = '',
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot =
            ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..')))
    )

    $out = [System.Collections.Generic.List[string]]::new()
    $runsRoot = Join-Path (Get-ArtifactsRoot -RepositoryRoot $RepositoryRoot) $Module
    if ([System.IO.Directory]::Exists($runsRoot)) {
        foreach ($d in ([System.IO.Directory]::EnumerateDirectories($runsRoot) | Sort-Object -Descending)) {
            $slugDir = if ([string]::IsNullOrWhiteSpace($Slug)) { $d } else { Join-Path $d $Slug }
            if ([System.IO.Directory]::Exists($slugDir)) { $out.Add($slugDir) }
        }
    }
    return $out.ToArray()
}

# ---------------------------------------------------------------------------------------------
# scratch
# ---------------------------------------------------------------------------------------------

function Set-TempEnvironment {
    <# Set CDXSCI_TEMP to a job-local tree under artifacts/. Ambient TEMP/TMP/TMPDIR are not read
       and are not written. A CDXSCI_TEMP already absolute and under artifacts/ is left alone. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $artifactRoot = Get-ArtifactsRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-ArtifactRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
    $value = [System.Environment]::GetEnvironmentVariable('CDXSCI_TEMP', 'Process')
    if (-not [string]::IsNullOrWhiteSpace($value) -and
            [System.IO.Path]::IsPathFullyQualified($value)) {
        $full = [System.IO.Path]::GetFullPath($value)
        if (Test-PathIsDescendant -Root $artifactRoot -Path $full) {
            return $full
        }
    }

    $owned = Join-Path $run 'temp'
    New-Item -ItemType Directory -Force -Path $owned | Out-Null
    Set-Item -LiteralPath 'env:CDXSCI_TEMP' -Value $owned
    return $owned
}
