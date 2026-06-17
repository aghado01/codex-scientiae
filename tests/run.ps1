#requires -Version 7.0
<#
  tests/run.ps1 — import Pester (>=5) and run every *.Tests.ps1 in this folder.

  Pester 5 lives in the portable PowerShell module tree, not on the default module path while the
  portable-env integration is degraded, so we import it by explicit path anchored on $env:PORTABLE_ROOT
  (falls back to a normally-installed v5 if that anchor isn't set). Exits non-zero on any failure.

    pwsh -File tests/run.ps1
    pwsh -File tests/run.ps1 -Path tests/masks.Tests.ps1     # one file
#>
[CmdletBinding()] param([string]$Path = $PSScriptRoot)

if (-not (Get-Module Pester | Where-Object { $_.Version -ge [version]'5.0' })) {
    $manifest = $null
    if ($env:PORTABLE_ROOT) {
        $proot = Join-Path $env:PORTABLE_ROOT 'PowerShell\Modules\Pester'
        if (Test-Path -LiteralPath $proot) {
            $v = Get-ChildItem -LiteralPath $proot -Directory |
                 Where-Object { ($_.Name -as [version]) -ge [version]'5.0' } |
                 Sort-Object { [version]$_.Name } -Descending | Select-Object -First 1
            if ($v) { $manifest = Join-Path $v.FullName 'Pester.psd1' }
        }
    }
    if ($manifest) { Import-Module $manifest -Force }
    else { Import-Module Pester -MinimumVersion 5.0 -Force }   # fall back to a v5 on the normal path
}
"Pester $((Get-Module Pester).Version)"

$cfg = New-PesterConfiguration
$cfg.Run.Path = $Path
$cfg.Run.Exit = $true              # non-zero exit on failure (CI-friendly)
$cfg.Output.Verbosity = 'Detailed'
Invoke-Pester -Configuration $cfg
