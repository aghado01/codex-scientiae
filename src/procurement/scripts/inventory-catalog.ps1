#requires -Version 7.0
<#
  Catalog-root inventory helpers.

  Sweep direct-child article.json sentinels and publish inventory.jsonl through the jsonl_engine
  `build-inventory` verb. Fold direct-child inventory.jsonl stores through `fold-inventory`.
  An existing inventory.jsonl is refused unless -Force is set.
#>

. "$PSScriptRoot/../../logistics/portable-path.ps1"
Import-Module (Join-Path $PSScriptRoot '../../jsonl_engine-client/jsonl_engine-client.psd1') `
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

function Invoke-InventoryBuild {
    <#
    .SYNOPSIS
        Build `{CatalogDir}/inventory.jsonl` from direct-child article.json sentinels.
    .DESCRIPTION
        Publishes a new inventory when absent. Pass -Force to overwrite an existing inventory.jsonl.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$CatalogDir,
        [switch]$Force,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300
    )

    $root = Resolve-InventoryCatalogRoot -CatalogDir $CatalogDir
    $articlePaths = @(Get-InventoryArticlePaths -CatalogDir $root)
    $staged = jsonl_engine-client\New-JsonlEngineInputFile -InputObject @($articlePaths)
    try {
        $argument = [System.Collections.Generic.List[string]]::new()
        $argument.Add('--catalog-dir')
        $argument.Add($root)
        $argument.Add('--article-paths-json')
        $argument.Add($staged.Path)
        if ($Force) { $argument.Add('--force') }

        $frames = @(jsonl_engine-client\Invoke-JsonlEngineCommand -Verb 'build-inventory' `
                -Argument $argument.ToArray() `
                -PythonPath $PythonPath `
                -TimeoutSeconds $EngineTimeoutSeconds)
        if ($frames.Count -ne 1) {
            throw "jsonl engine verb 'build-inventory' returned $($frames.Count) values; expected exactly one"
        }
        return [pscustomobject]$frames[0].value
    } finally {
        if ($staged.IsTemporary -and [System.IO.File]::Exists($staged.Path)) {
            [System.IO.File]::Delete($staged.Path)
        }
    }
}

function Invoke-InventoryFold {
    <#
    .SYNOPSIS
        Build `{CatalogDir}/inventory.jsonl` from direct-child inventory.jsonl stores.
    .DESCRIPTION
        Publishes a new inventory when absent. Pass -Force to overwrite an existing inventory.jsonl.
        Inner inventories remain the source of truth; children without one are skipped.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$CatalogDir,
        [switch]$Force,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300
    )

    $root = Resolve-InventoryCatalogRoot -CatalogDir $CatalogDir
    $argument = [System.Collections.Generic.List[string]]::new()
    $argument.Add('--catalog-dir')
    $argument.Add($root)
    if ($Force) { $argument.Add('--force') }

    $frames = @(jsonl_engine-client\Invoke-JsonlEngineCommand -Verb 'fold-inventory' `
            -Argument $argument.ToArray() `
            -PythonPath $PythonPath `
            -TimeoutSeconds $EngineTimeoutSeconds)
    if ($frames.Count -ne 1) {
        throw "jsonl engine verb 'fold-inventory' returned $($frames.Count) values; expected exactly one"
    }
    return [pscustomobject]$frames[0].value
}
