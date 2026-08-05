#requires -Version 7.0
<#
  Transitional compatibility loader for callers that still dot-source the former flat implementation.
  New callers should import ./batch-executor/batch-executor.psd1 and use New-BatchPlan.
#>

Import-Module -Name (Join-Path $PSScriptRoot 'batch-executor/batch-executor.psd1') `
    -Force -ErrorAction Stop
Set-Alias -Name Compile-BatchPlan -Value New-BatchPlan
