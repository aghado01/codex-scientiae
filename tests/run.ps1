#requires -Version 7.0
<#
  tests/run.ps1 — import Pester (>=5) and run every *.Tests.ps1 recursively under this tree. Runs on Pester 5.x AND
  6.x (the invocation is version-robust — see the container note below).

  Pester >=5 lives in the portable PowerShell module tree, not on the default module path while the
  portable-env integration is degraded, so we import it by explicit path anchored on $env:PORTABLE_ROOT
  (falls back to a normally-installed >=5 if that anchor isn't set). Exits non-zero on any test failure,
  a missing path, OR an empty run (zero discovered tests never reports green).

    pwsh -File tests/run.ps1
    pwsh -File tests/run.ps1 -Path tests/latex-ingest       # one module
    pwsh -File tests/run.ps1 -Path tests/shared/masks.Tests.ps1
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

if (-not (Test-Path -LiteralPath $Path)) { throw "run.ps1: test path not found: '$Path'" }

# Resolve $Path through an explicit CONTAINER, not $cfg.Run.Path: Run.Path's single-file-vs-directory
# discovery diverged across the Pester 5->6 major (a v6 install was observed finding ZERO tests from a
# bare file path), whereas New-PesterContainer resolves a file OR a directory identically on 5.7.1 and
# 6.0.0 (verified for both file and recursive-directory discovery). Run.Path is cleared so only the container
# runs and a stray *.Tests.ps1 in the caller's cwd can't sneak in.
$cfg = New-PesterConfiguration
$cfg.Run.Container    = New-PesterContainer -Path $Path
$cfg.Run.Path         = @()
$cfg.Run.PassThru     = $true
$cfg.Output.Verbosity = 'Detailed'
$result = Invoke-Pester -Configuration $cfg

# Zero discovered tests is a discovery/resolution fault (bad path, wrong or corrupt Pester), never a pass.
# Fail LOUD so a "no tests found" can never masquerade as green — the hole the old $cfg.Run.Exit left open
# (it exits non-zero on failures but 0 on an empty run). NB: TotalCount is $null, not 0, when nothing runs.
$total = if ($result) { [int]$result.TotalCount } else { 0 }
if ($total -eq 0) {
    throw "run.ps1: no tests discovered under '$Path' (Pester $((Get-Module Pester).Version)) — refusing to report success"
}
exit ([int]($result.FailedCount -gt 0))   # non-zero exit on any failure (CI-friendly), replaces Run.Exit
