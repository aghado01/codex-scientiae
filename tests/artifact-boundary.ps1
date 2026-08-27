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

function Set-TestHarnessTempEnvironment {
    <# The harness owns the temp convention rather than half-deferring to ambient state. The
       boundary admits exactly one thing — a temp tree under artifacts/ — so an ambient value that
       is already conformant was set deliberately and is left alone; anything else (unset, the
       system temp, a path outside the boundary) is replaced with {RunDirectory}/temp instead of
       failing three checks deep in a child process. Returns the directory now in force. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $artifactRoot = Get-TestHarnessArtifactRoot -RepositoryRoot $RepositoryRoot
    $conformant = $true
    $seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
        $value = [System.Environment]::GetEnvironmentVariable($name, 'Process')
        if ([string]::IsNullOrWhiteSpace($value) -or
                -not [System.IO.Path]::IsPathFullyQualified($value)) {
            $conformant = $false
            break
        }
        $full = [System.IO.Path]::GetFullPath($value)
        if (-not (Test-TestHarnessDescendantPath -Root $artifactRoot -Path $full)) {
            $conformant = $false
            break
        }
        [void]$seen.Add($full)
    }
    # Three variables naming three different directories is not a deliberate setting.
    if ($conformant -and $seen.Count -eq 1) { return @($seen)[0] }

    $owned = Join-Path ([System.IO.Path]::GetFullPath($RunDirectory)) 'temp'
    New-Item -ItemType Directory -Force -Path $owned | Out-Null
    foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
        Set-Item -LiteralPath "env:$name" -Value $owned
    }
    return $owned
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
