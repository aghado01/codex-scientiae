#requires -Version 7.0
<#
  src/logistics/assert-codex-temp.ps1 — child-process CODEX_TEMP projection.

  tests/run.ps1 calls this so Pester TestDrive and GetTempPath cannot follow the ambient OS temp
  tree. It is not part of containment.ps1: Set-CodexTempEnvironment owns the parent-run value;
  this assert is a child-entry check that can be retired independently.
#>

. "$PSScriptRoot/containment.ps1"

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
    $resolved = Resolve-ArtifactDescendantPath -Value $value `
        -RepositoryRoot $RepositoryRoot -Role 'CODEX_TEMP'
    foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
        Set-Item -LiteralPath "env:$name" -Value $resolved
    }
    return $resolved
}
