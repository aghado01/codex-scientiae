#requires -Version 7.0
<#
  Catalog-root inventory helpers.

  Sweep direct-child article.json sentinels and rebuild inventory.jsonl through the jsonl_engine
  `rebuild-inventory` verb. Enumeration stays in PowerShell; the engine validates rows and publishes
  the registry.
#>

. "$PSScriptRoot/portable-path.ps1"
Import-Module (Join-Path $PSScriptRoot '../jsonl_engine-client/jsonl_engine-client.psd1') `
    -ErrorAction Stop

function Resolve-InventoryCatalogRoot {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$CatalogDir)

    $root = (Resolve-Path -LiteralPath $CatalogDir -ErrorAction Stop).Path
    if (-not [System.IO.Directory]::Exists($root)) {
        throw "catalog directory is not a directory: '$CatalogDir'"
    }
    if (Test-PathHasReparsePoint -Path $root) {
        throw "catalog directory must not traverse a symbolic link or reparse point: '$root'"
    }
    return $root
}

function Get-InventoryArticlePaths {
    <#
    .SYNOPSIS
        List direct-child article.json paths under a catalog root.
    .DESCRIPTION
        Only `{catalog}/{slug}/article.json` participates. Children without a sentinel are ignored;
        a present non-file occupancy of article.json fails.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$CatalogDir)

    $root = Resolve-InventoryCatalogRoot -CatalogDir $CatalogDir
    $paths = [System.Collections.Generic.List[string]]::new()
    foreach ($child in @(Get-ChildItem -LiteralPath $root -Force -Directory | Sort-Object Name)) {
        if (($child.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "catalog child must not be a reparse point: '$($child.FullName)'"
        }
        $article = Join-Path $child.FullName 'article.json'
        $entry = Get-Item -LiteralPath $article -Force -ErrorAction SilentlyContinue
        if ($null -eq $entry) { continue }
        if (-not $entry.PSIsContainer -and
            ($entry.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -eq 0 -and
            [System.IO.File]::Exists($article)) {
            $paths.Add((Resolve-Path -LiteralPath $article).Path)
            continue
        }
        throw "catalog child article.json is not a regular file: '$article'"
    }
    return $paths.ToArray()
}

function Invoke-InventoryRebuild {
    <#
    .SYNOPSIS
        Rebuild `{CatalogDir}/inventory.jsonl` from direct-child article.json sentinels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$CatalogDir,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300
    )

    $root = Resolve-InventoryCatalogRoot -CatalogDir $CatalogDir
    $articlePaths = @(Get-InventoryArticlePaths -CatalogDir $root)
    $staged = jsonl_engine-client\New-JsonlEngineInputFile -InputObject @($articlePaths)
    try {
        $frames = @(jsonl_engine-client\Invoke-JsonlEngineCommand -Verb 'rebuild-inventory' `
                -Argument @(
                    '--catalog-dir', $root
                    '--article-paths-json', $staged.Path
                ) `
                -PythonPath $PythonPath `
                -TimeoutSeconds $EngineTimeoutSeconds)
        if ($frames.Count -ne 1) {
            throw "jsonl engine verb 'rebuild-inventory' returned $($frames.Count) values; expected exactly one"
        }
        return [pscustomobject]$frames[0].value
    } finally {
        if ($staged.IsTemporary -and [System.IO.File]::Exists($staged.Path)) {
            [System.IO.File]::Delete($staged.Path)
        }
    }
}
