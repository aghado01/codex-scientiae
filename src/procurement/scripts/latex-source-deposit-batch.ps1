#requires -Version 7.0
<#
  On-demand LaTeX source unpack/deposit over a catalog parent.

  Discovers arXiv-shaped archives under -CatalogDir, runs the full New-LatexSourceDeposit ceremony
  (expand, validate, mint article.json), and reports per-slug outcomes. Rebuild inventory.jsonl
  separately with inventory-build.ps1 after deposits succeed.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$CatalogDir,

    [switch]$IncludeExisting,

    [string]$PythonPath = '',

    [ValidateRange(1, 3600)]
    [int]$EngineTimeoutSeconds = 300,

    [string]$MainTex = '',

    [switch]$FailOnError
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'latex-source-batch.ps1')

$batch = Invoke-LatexSourceDepositBatch -CatalogDir $CatalogDir `
    -IncludeExisting:$IncludeExisting `
    -WhatIf:$WhatIfPreference `
    -PythonPath $PythonPath `
    -EngineTimeoutSeconds $EngineTimeoutSeconds `
    -MainTex $MainTex

$batch | ConvertTo-Json -Depth 6
if ($FailOnError -and [int]$batch.FailedCount -gt 0) {
    exit 1
}
