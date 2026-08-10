#requires -Version 7.0
<#
  Rebuild `{CatalogDir}/inventory.jsonl` from direct-child article.json sentinels.

  PowerShell enumerates `{catalog}/{slug}/article.json`. The jsonl_engine `rebuild-inventory`
  verb validates slug/path agreement and inventory-row schema, then publishes the registry.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$CatalogDir,

    [string]$PythonPath = '',

    [ValidateRange(1, 3600)]
    [int]$EngineTimeoutSeconds = 300
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../src/logistics/inventory-catalog.ps1')

$result = Invoke-InventoryRebuild -CatalogDir $CatalogDir `
    -PythonPath $PythonPath `
    -EngineTimeoutSeconds $EngineTimeoutSeconds

$result | ConvertTo-Json -Depth 6
