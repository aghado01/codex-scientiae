#requires -Version 7.0
<#
  Build `{CatalogDir}/inventory.jsonl` from direct-child inventory.jsonl stores.

  The jsonl_engine `fold-inventory` verb reads each child inventory, relocates leaf-relative
  paths one hop up, and publishes the parent registry. Pass -Force to overwrite an existing
  inventory.jsonl.
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

$result = Invoke-InventoryFold -CatalogDir $CatalogDir `
    -Force:$Force `
    -PythonPath $PythonPath `
    -EngineTimeoutSeconds $EngineTimeoutSeconds

$result | ConvertTo-Json -Depth 6
