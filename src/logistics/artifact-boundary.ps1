#requires -Version 7.0
<#
  src/logistics/artifact-boundary.ps1 — repository artifacts containment.

  Sibling of run-paths.ps1 (minting). This file owns descendant checks, run-directory
  resolution against the repository root, and `CODEX_TEMP`. Ambient TEMP/TMP/TMPDIR are
  not a project scratch source. Isolated children may receive those names projected from
  `CODEX_TEMP` so OS temp APIs cannot leak.

  tests/batch.ps1 is the public test-batch caller, including a one-file selection.
  tests/run.ps1 and tests/pytest.ps1 are child entrypoints; they load this helper from src.
  batch-adapters consume the same descendant check rather than duplicating it.
#>

function Test-TestHarnessDescendantPath {
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

function Get-TestHarnessArtifactRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $repository = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if (-not (Test-Path -LiteralPath $repository -PathType Container)) {
        throw "test harness repository root not found: '$RepositoryRoot'"
    }
    $artifactCandidate = [System.IO.Path]::Combine($repository, 'artifacts')
    if (-not (Test-Path -LiteralPath $artifactCandidate -PathType Container)) {
        throw "test harness repository artifacts root not found: '$artifactCandidate'"
    }
    return (Resolve-Path -LiteralPath $artifactCandidate).Path
}

function Resolve-TestHarnessArtifactPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Value,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role,
        [string] $BasePath = $RepositoryRoot
    )

    $artifactRoot = Get-TestHarnessArtifactRoot -RepositoryRoot $RepositoryRoot
    $candidate = if ([System.IO.Path]::IsPathFullyQualified($Value)) {
        [System.IO.Path]::GetFullPath($Value)
    }
    else { [System.IO.Path]::GetFullPath($Value, $BasePath) }
    if (-not (Test-TestHarnessDescendantPath -Root $artifactRoot -Path $candidate)) {
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
            -not (Test-TestHarnessDescendantPath -Root $artifactRoot -Path $resolvedExisting)) {
        throw "$Role resolves outside RepositoryRoot/artifacts: '$Value'"
    }
    return $candidate
}

function Resolve-TestHarnessRunDirectory {
    <# Absolute existing directory under RepositoryRoot/artifacts. A relative value is resolved
       against RepositoryRoot, not the process working directory. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $resolved = Resolve-TestHarnessArtifactPath -Value $RunDirectory `
        -RepositoryRoot $RepositoryRoot -Role 'RunDirectory' -BasePath $RepositoryRoot
    if (-not (Test-Path -LiteralPath $resolved -PathType Container)) {
        throw "RunDirectory must be an existing directory under RepositoryRoot/artifacts: '$RunDirectory'"
    }
    return (Resolve-Path -LiteralPath $resolved).Path
}

function Resolve-TestSuiteName {
    <# The tests/{owner} segment a batch selected — the same grouping tests/README requires a file
       to be filed under. One distinct owner names the run; a batch spanning several, or one whose
       selection is not owner-scoped, is `mixed` rather than claiming a suite it does not have. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $TestsRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [AllowEmptyCollection()] [string[]] $SelectedPath = @()
    )

    $resolvedTestsRoot = [System.IO.Path]::GetFullPath($TestsRoot)
    $owners = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($candidate in $SelectedPath) {
        if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
        $full = if ([System.IO.Path]::IsPathFullyQualified($candidate)) {
            [System.IO.Path]::GetFullPath($candidate)
        }
        else { [System.IO.Path]::GetFullPath($candidate, $RepositoryRoot) }

        $relative = [System.IO.Path]::GetRelativePath($resolvedTestsRoot, $full)
        # The tests root itself, or anything outside it, is not owner-scoped.
        if ($relative -eq '.' -or $relative.StartsWith('..')) { [void]$owners.Add('*'); continue }
        $segments = @($relative -split '[\\/]' | Where-Object { $_ })
        if ($segments.Count -eq 0) { [void]$owners.Add('*'); continue }
        # tests/{owner} is the suite whether the batch selected the directory or a file inside it.
        # A file sitting DIRECTLY in tests/ (tests/parallel.ps1) has no owner directory above it.
        if ($segments.Count -eq 1 -and [System.IO.Path]::HasExtension($segments[0])) {
            [void]$owners.Add('*')
            continue
        }
        [void]$owners.Add($segments[0])
    }

    if ($owners.Count -eq 1 -and -not $owners.Contains('*')) { return @($owners)[0] }
    return 'mixed'
}

function Set-CodexTempEnvironment {
    <# Set CODEX_TEMP to a job-local tree under artifacts/. Ambient TEMP/TMP/TMPDIR are not read
       and are not written. A CODEX_TEMP already absolute and under artifacts/ is left alone. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $artifactRoot = Get-TestHarnessArtifactRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-TestHarnessRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
    $value = [System.Environment]::GetEnvironmentVariable('CODEX_TEMP', 'Process')
    if (-not [string]::IsNullOrWhiteSpace($value) -and
            [System.IO.Path]::IsPathFullyQualified($value)) {
        $full = [System.IO.Path]::GetFullPath($value)
        if (Test-TestHarnessDescendantPath -Root $artifactRoot -Path $full) {
            return $full
        }
    }

    $owned = Join-Path $run 'temp'
    New-Item -ItemType Directory -Force -Path $owned | Out-Null
    Set-Item -LiteralPath 'env:CODEX_TEMP' -Value $owned
    return $owned
}

function Assert-CodexTempEnvironment {
    <# Require CODEX_TEMP under artifacts/. Project it onto TEMP/TMP/TMPDIR for this process so
       Pester TestDrive and GetTempPath cannot follow the ambient OS temp tree. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $value = [System.Environment]::GetEnvironmentVariable('CODEX_TEMP', 'Process')
    if ([string]::IsNullOrWhiteSpace($value) -or
            -not [System.IO.Path]::IsPathFullyQualified($value)) {
        throw 'CODEX_TEMP must be an absolute path under RepositoryRoot/artifacts'
    }
    $resolved = Resolve-TestHarnessArtifactPath -Value $value `
        -RepositoryRoot $RepositoryRoot -Role 'CODEX_TEMP'
    foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
        Set-Item -LiteralPath "env:$name" -Value $resolved
    }
    return $resolved
}
