#requires -Version 7.0
<#
  tests/suite-name.ps1 — tests/{owner} suite naming for tests/batch.ps1.

  One distinct owner names the run. A batch spanning several owners, or a selection that is not
  owner-scoped, is `mixed` rather than claiming a suite it does not have.
#>

function Resolve-TestSuiteName {
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
