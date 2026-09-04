#requires -Version 7.0
<#
  src/logistics/containment.ps1 — artifacts-tier containment and CODEX_TEMP.

  Sibling of run-paths.ps1 (minting). This file owns descendant checks, resolution of paths under
  a workspace `artifacts/` directory, and `Set-CodexTempEnvironment`. Ambient TEMP/TMP/TMPDIR are
  not a project scratch source.

  Child-process projection of CODEX_TEMP onto TEMP/TMP/TMPDIR lives in assert-codex-temp.ps1.
  Suite naming for tests/batch.ps1 lives in tests/suite-name.ps1.
#>

function Test-PathIsDescendant {
    param(
        [Parameter(Mandatory)] [string] $Root,
        [Parameter(Mandatory)] [string] $Path
    )

    $relative = [System.IO.Path]::GetRelativePath($Root, $Path)
    $parentPrefix = '..' + [System.IO.Path]::DirectorySeparatorChar
    return $relative -ne '.' -and $relative -ne '..' -and
        -not [System.IO.Path]::IsPathFullyQualified($relative) -and
        -not $relative.StartsWith($parentPrefix, [System.StringComparison]::Ordinal)
}

function Get-RepositoryArtifactsRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
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
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Value,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role,
        [string] $BasePath = $RepositoryRoot
    )

    $artifactRoot = Get-RepositoryArtifactsRoot -RepositoryRoot $RepositoryRoot
    $candidate = if ([System.IO.Path]::IsPathFullyQualified($Value)) {
        [System.IO.Path]::GetFullPath($Value)
    }
    else { [System.IO.Path]::GetFullPath($Value, $BasePath) }
    if (-not (Test-PathIsDescendant -Root $artifactRoot -Path $candidate)) {
        throw "$Role must be a descendant of RepositoryRoot/artifacts: '$Value'"
    }

    # Resolve the nearest existing ancestor as well as the lexical address. This rejects an already
    # present junction or symbolic-link route that leaves the repository artifact boundary.
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

function Set-CodexTempEnvironment {
    <# Set CODEX_TEMP to a job-local tree under artifacts/. Ambient TEMP/TMP/TMPDIR are not read
       and are not written. A CODEX_TEMP already absolute and under artifacts/ is left alone. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $artifactRoot = Get-RepositoryArtifactsRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-ArtifactRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
    $value = [System.Environment]::GetEnvironmentVariable('CODEX_TEMP', 'Process')
    if (-not [string]::IsNullOrWhiteSpace($value) -and
            [System.IO.Path]::IsPathFullyQualified($value)) {
        $full = [System.IO.Path]::GetFullPath($value)
        if (Test-PathIsDescendant -Root $artifactRoot -Path $full) {
            return $full
        }
    }

    $owned = Join-Path $run 'temp'
    New-Item -ItemType Directory -Force -Path $owned | Out-Null
    Set-Item -LiteralPath 'env:CODEX_TEMP' -Value $owned
    return $owned
}
