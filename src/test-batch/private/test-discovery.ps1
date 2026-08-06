function Resolve-TestBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "test-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-TestBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory
    )

    if (-not [System.IO.Path]::IsPathFullyQualified($RunDirectory)) {
        throw "test-batch RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    $candidate = [System.IO.Path]::GetFullPath($RunDirectory)
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "test-batch RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Test-TestBatchPathWithinRoot {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $RepositoryRoot
    )

    $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $Path)
    if ([System.IO.Path]::IsPathFullyQualified($relative) -or $relative -eq '..') { return $false }
    $parentPrefix = '..' + [System.IO.Path]::DirectorySeparatorChar
    return -not $relative.StartsWith($parentPrefix, [System.StringComparison]::Ordinal)
}

function Find-TestBatchFile {
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
            throw 'test-batch selection path must not be empty'
        }
        $candidate = if ([System.IO.Path]::IsPathFullyQualified($selection)) {
            [System.IO.Path]::GetFullPath($selection)
        }
        else { [System.IO.Path]::GetFullPath($selection, $RepositoryRoot) }
        if (-not (Test-Path -LiteralPath $candidate)) {
            throw "test-batch selection path not found: '$selection'"
        }
        $resolved = (Resolve-Path -LiteralPath $candidate).Path
        if (-not (Test-TestBatchPathWithinRoot -Path $resolved -RepositoryRoot $RepositoryRoot)) {
            throw "test-batch selection escapes RepositoryRoot: '$selection'"
        }

        if (Test-Path -LiteralPath $resolved -PathType Leaf) {
            if (-not $resolved.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                throw "test-batch selected file is not a *.Tests.ps1 file: '$selection'"
            }
            [void]$seen.Add($resolved)
            continue
        }

        foreach ($file in [System.IO.Directory]::EnumerateFiles(
                $resolved, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories)) {
            $resolvedFile = [System.IO.Path]::GetFullPath($file)
            if (Test-TestBatchPathWithinRoot -Path $resolvedFile -RepositoryRoot $RepositoryRoot) {
                [void]$seen.Add($resolvedFile)
            }
        }
    }

    if ($seen.Count -eq 0) {
        throw 'test-batch selection discovered no *.Tests.ps1 files'
    }
    $files = [string[]]@($seen)
    [System.Array]::Sort($files, $comparison)
    return $files
}

function ConvertTo-TestBatchFilter {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()] [string[]] $Value = @(),
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role
    )

    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::Ordinal)
    foreach ($entry in @($Value)) {
        if ([string]::IsNullOrWhiteSpace($entry)) {
            throw "test-batch $Role filter must not contain an empty value"
        }
        [void]$seen.Add($entry)
    }
    $normalized = [string[]]@($seen)
    [System.Array]::Sort($normalized, [System.StringComparer]::Ordinal)
    return $normalized
}
