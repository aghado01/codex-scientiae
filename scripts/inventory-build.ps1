#requires -Version 7.0
<#
  Build `{CatalogDir}/inventory.jsonl` from direct-child article.json sentinels.

  PowerShell enumerates `{catalog}/{slug}/article.json`. The jsonl_engine `build-inventory`
  verb validates slug/path agreement and inventory-row schema, then publishes the registry.
  Pass -Force to overwrite an existing inventory.jsonl.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$CatalogDir,

    [switch]$Force,

    [string]$PythonPath = '',

    [ValidateRange(1, 3600)]
    [int]$EngineTimeoutSeconds = 300
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../src/logistics/inventory-catalog.ps1')

$result = Invoke-InventoryBuild -CatalogDir $CatalogDir `
    -Force:$Force `
    -PythonPath $PythonPath `
    -EngineTimeoutSeconds $EngineTimeoutSeconds

$result | ConvertTo-Json -Depth 6
