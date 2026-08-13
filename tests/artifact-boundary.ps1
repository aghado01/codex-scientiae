#requires -Version 7.0

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

function Assert-TestHarnessTempEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $resolved = [System.Collections.Generic.List[string]]::new()
    foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
        $value = [System.Environment]::GetEnvironmentVariable($name, 'Process')
        if ([string]::IsNullOrWhiteSpace($value) -or
                -not [System.IO.Path]::IsPathFullyQualified($value)) {
            throw "test harness requires absolute TEMP, TMP, and TMPDIR paths below RepositoryRoot/artifacts"
        }
        $resolved.Add((Resolve-TestHarnessArtifactPath -Value $value `
                -RepositoryRoot $RepositoryRoot -Role $name))
    }

    $comparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else { [System.StringComparer]::Ordinal }
    if (-not $comparer.Equals($resolved[0], $resolved[1]) -or
            -not $comparer.Equals($resolved[0], $resolved[2])) {
        throw 'test harness requires TEMP, TMP, and TMPDIR to name one job-local directory'
    }
    return $resolved[0]
}
