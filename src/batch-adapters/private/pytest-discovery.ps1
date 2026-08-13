# Pytest adapter discovery helpers.

function Resolve-PytestBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "pytest-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-PytestBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    Resolve-BatchAdapterRunDirectory -Adapter 'pytest-batch' -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
}

function Test-PytestBatchPathWithinRoot {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $RepositoryRoot
    )

    $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $Path)
    if ([System.IO.Path]::IsPathFullyQualified($relative) -or $relative -eq '..') { return $false }
    $parentPrefix = '..' + [System.IO.Path]::DirectorySeparatorChar
    return -not $relative.StartsWith($parentPrefix, [System.StringComparison]::Ordinal)
}

function Test-PytestBatchFileName {
    param([Parameter(Mandatory)] [string] $Path)

    $comparison = if ($IsWindows) {
        [System.StringComparison]::OrdinalIgnoreCase
    }
    else { [System.StringComparison]::Ordinal }
    $name = [System.IO.Path]::GetFileName($Path)
    return $name.StartsWith('test_', $comparison) -and $name.EndsWith('.py', $comparison)
}

function Find-PytestBatchFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $comparison = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else { [System.StringComparer]::Ordinal }
    $seen = [System.Collections.Generic.HashSet[string]]::new($comparison)

    foreach ($selection in $Path) {
        if ([string]::IsNullOrWhiteSpace($selection)) {
            throw 'pytest-batch selection path must not be empty'
        }
        $candidate = if ([System.IO.Path]::IsPathFullyQualified($selection)) {
            [System.IO.Path]::GetFullPath($selection)
        }
        else { [System.IO.Path]::GetFullPath($selection, $RepositoryRoot) }
        if (-not (Test-Path -LiteralPath $candidate)) {
            throw "pytest-batch selection path not found: '$selection'"
        }
        $resolved = (Resolve-Path -LiteralPath $candidate).Path
        if (-not (Test-PytestBatchPathWithinRoot -Path $resolved -RepositoryRoot $RepositoryRoot)) {
            throw "pytest-batch selection escapes RepositoryRoot: '$selection'"
        }

        if (Test-Path -LiteralPath $resolved -PathType Leaf) {
            if (-not (Test-PytestBatchFileName -Path $resolved)) {
                throw "pytest-batch selected file is not a test_*.py file: '$selection'"
            }
            [void]$seen.Add($resolved)
            continue
        }

        foreach ($file in [System.IO.Directory]::EnumerateFiles(
                $resolved, 'test_*.py', [System.IO.SearchOption]::AllDirectories)) {
            $resolvedFile = [System.IO.Path]::GetFullPath($file)
            if ((Test-PytestBatchPathWithinRoot -Path $resolvedFile -RepositoryRoot $RepositoryRoot) -and
                    (Test-PytestBatchFileName -Path $resolvedFile)) {
                [void]$seen.Add($resolvedFile)
            }
        }
    }

    if ($seen.Count -eq 0) {
        throw 'pytest-batch selection discovered no test_*.py files'
    }
    $files = [string[]]@($seen)
    [System.Array]::Sort($files, $comparison)
    return $files
}

function ConvertTo-PytestBatchExpression {
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [string] $Value,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role
    )

    if ($null -eq $Value) { return $null }
    $normalized = $Value.Trim()
    if ([string]::IsNullOrWhiteSpace($normalized)) {
        throw "pytest-batch $Role expression must not be empty"
    }
    return $normalized
}
