# Pester adapter discovery helpers.

function Resolve-PesterBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "pester-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-PesterBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    Resolve-BatchAdapterRunDirectory -Adapter 'pester-batch' -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
}

function Test-PesterBatchPathWithinRoot {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $RepositoryRoot
    )

    $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $Path)
    if ([System.IO.Path]::IsPathFullyQualified($relative) -or $relative -eq '..') { return $false }
    $parentPrefix = '..' + [System.IO.Path]::DirectorySeparatorChar
    return -not $relative.StartsWith($parentPrefix, [System.StringComparison]::Ordinal)
}

function Find-PesterBatchFile {
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
            throw 'pester-batch selection path must not be empty'
        }
        $candidate = if ([System.IO.Path]::IsPathFullyQualified($selection)) {
            [System.IO.Path]::GetFullPath($selection)
        }
        else { [System.IO.Path]::GetFullPath($selection, $RepositoryRoot) }
        if (-not (Test-Path -LiteralPath $candidate)) {
            throw "pester-batch selection path not found: '$selection'"
        }
        $resolved = (Resolve-Path -LiteralPath $candidate).Path
        if (-not (Test-PesterBatchPathWithinRoot -Path $resolved -RepositoryRoot $RepositoryRoot)) {
            throw "pester-batch selection escapes RepositoryRoot: '$selection'"
        }

        if (Test-Path -LiteralPath $resolved -PathType Leaf) {
            if (-not $resolved.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                throw "pester-batch selected file is not a *.Tests.ps1 file: '$selection'"
            }
            [void]$seen.Add($resolved)
            continue
        }

        foreach ($file in [System.IO.Directory]::EnumerateFiles(
                $resolved, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories)) {
            $resolvedFile = [System.IO.Path]::GetFullPath($file)
            if (Test-PesterBatchPathWithinRoot -Path $resolvedFile -RepositoryRoot $RepositoryRoot) {
                [void]$seen.Add($resolvedFile)
            }
        }
    }

    if ($seen.Count -eq 0) {
        throw 'pester-batch selection discovered no *.Tests.ps1 files'
    }
    $files = [string[]]@($seen)
    [System.Array]::Sort($files, $comparison)
    return $files
}

function ConvertTo-PesterBatchFilter {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()] [string[]] $Value = @(),
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role
    )

    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::Ordinal)
    foreach ($entry in @($Value)) {
        if ([string]::IsNullOrWhiteSpace($entry)) {
            throw "pester-batch $Role filter must not contain an empty value"
        }
        [void]$seen.Add($entry)
    }
    $normalized = [string[]]@($seen)
    [System.Array]::Sort($normalized, [System.StringComparer]::Ordinal)
    return $normalized
}
