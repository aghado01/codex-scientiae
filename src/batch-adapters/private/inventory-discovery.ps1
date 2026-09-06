# Inventory-batch discovery helpers.
#
# inventory.jsonl is built by the jsonl engine to be trusted downstream: every
# row is the deposited article record, with source paths relocated one hop per
# fold. Planning reads rows directly (one JSON object per line, header row
# skipped) and takes the row as the article manifest. article.json is opened
# only for the single-article Path forms, where no row carries the record.

function Resolve-InventoryBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "inventory-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-InventoryBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    Resolve-BatchAdapterRunDirectory -Adapter 'inventory-batch' -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
}

function Get-InventoryBatchSourceForm {
    <# The source_forms entry with the given role, or $null. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Record,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role
    )

    if (-not $Record.PSObject.Properties['source_forms']) { return $null }
    foreach ($form in @($Record.source_forms)) {
        if ($null -ne $form -and $form.PSObject.Properties['role'] -and
                [string]$form.role -eq $Role) {
            return $form
        }
    }
    return $null
}

function Resolve-InventoryBatchArticleFromRecord {
    <# Resolve a row to the deposit it describes. First-order rows keep
       article-relative paths and live at {catalog}/{slug}/. Folded rows
       relocate those paths one hop per fold, so the article directory is
       the parent of the latex-source-tree path. Either way the tree is the
       canonical {slug}-tex leaf inside the article directory. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Record,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $CatalogDirectory
    )

    $slug = if ($Record.PSObject.Properties['slug']) { [string]$Record.slug } else { '' }
    if ([string]::IsNullOrWhiteSpace($slug)) {
        throw "inventory-batch inventory row has no slug under '$CatalogDirectory'"
    }

    $form = Get-InventoryBatchSourceForm -Record $Record -Role 'latex-source-tree'
    $treePath = if ($null -ne $form -and $form.PSObject.Properties['path'] -and $form.path) {
        ([string]$form.path) -replace '\\', '/'
    }
    else { '' }
    if ([string]::IsNullOrWhiteSpace($treePath)) {
        throw "inventory-batch inventory row '$slug' has no latex-source-tree path under '$CatalogDirectory'"
    }

    $segments = @($treePath -split '/')
    foreach ($segment in $segments) {
        if ([string]::IsNullOrWhiteSpace($segment) -or $segment -eq '.' -or $segment -eq '..') {
            throw "inventory-batch inventory row '$slug' has a non-confined tree path under '$CatalogDirectory'"
        }
    }
    $articleDirectory = $CatalogDirectory
    if ($segments.Count -eq 1) {
        $articleDirectory = [System.IO.Path]::Combine($articleDirectory, $slug)
    }
    else {
        foreach ($segment in $segments[0..($segments.Count - 2)]) {
            $articleDirectory = [System.IO.Path]::Combine($articleDirectory, $segment)
        }
    }
    if (-not (Test-Path -LiteralPath $articleDirectory -PathType Container)) {
        throw "inventory-batch inventory row '$slug' does not resolve to a deposit under '$CatalogDirectory'"
    }

    return [pscustomobject]@{
        ArticleDirectory = (Resolve-Path -LiteralPath $articleDirectory).Path
        Record = $Record
        Source = 'inventory'
    }
}

function Read-InventoryBatchStore {
    <# Trusted read of inventory.jsonl: one JSON object per line, the header
       row skipped. No jsonl engine, no index; the store was built to be read
       this way. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryPath
    )

    $records = [System.Collections.Generic.List[object]]::new()
    $lineNumber = 0
    foreach ($line in [System.IO.File]::ReadLines($InventoryPath)) {
        $lineNumber++
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $record = $null
        try { $record = $line | ConvertFrom-Json }
        catch {
            throw "inventory-batch could not parse '$InventoryPath' line ${lineNumber}: $($_.Exception.Message)"
        }
        if ($null -eq $record) { continue }
        if ($record.PSObject.Properties['__type__'] -and [string]$record.__type__ -eq 'header') {
            continue
        }
        $records.Add($record)
    }
    if ($records.Count -eq 0) {
        throw "inventory-batch inventory contains no articles: '$InventoryPath'"
    }
    return $records
}

function Expand-InventoryBatchStore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $CatalogDirectory
    )

    $found = [System.Collections.Generic.List[object]]::new()
    foreach ($record in @(Read-InventoryBatchStore -InventoryPath $InventoryPath)) {
        $found.Add((Resolve-InventoryBatchArticleFromRecord -Record $record `
                    -CatalogDirectory $CatalogDirectory))
    }
    return $found
}

function Read-InventoryBatchArticleManifest {
    <# The single-article Path forms carry no row; article.json is the record. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $ArticleDirectory
    )

    $articleJson = [System.IO.Path]::Combine($ArticleDirectory, 'article.json')
    $record = $null
    try {
        $record = Get-Content -LiteralPath $articleJson -Raw | ConvertFrom-Json
    }
    catch {
        throw "inventory-batch could not read article.json in '$ArticleDirectory': $($_.Exception.Message)"
    }
    return [pscustomobject]@{
        ArticleDirectory = $ArticleDirectory
        Record = $record
        Source = 'article.json'
    }
}

function Find-InventoryBatchArticle {
    <# Expand caller-selected paths to deposited articles, each paired with
       its record. A Path entry may be an article directory, an article.json
       file, an inventory.jsonl file, or a catalog directory that holds
       inventory.jsonl (first-order or folded). Catalog directories without
       inventory.jsonl are refused: the inventory is the population, not a
       directory walk. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $found = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $Path) {
        $absolute = if ([System.IO.Path]::IsPathFullyQualified($entry)) {
            [System.IO.Path]::GetFullPath($entry)
        }
        else { [System.IO.Path]::GetFullPath($entry, $RepositoryRoot) }

        if (Test-Path -LiteralPath $absolute -PathType Leaf) {
            $file = Get-Item -LiteralPath $absolute
            if ($file.Name -eq 'article.json') {
                if ($seen.Add($file.Directory.FullName)) {
                    $found.Add((Read-InventoryBatchArticleManifest -ArticleDirectory $file.Directory.FullName))
                }
                continue
            }
            if ($file.Name -eq 'inventory.jsonl') {
                foreach ($selection in @(Expand-InventoryBatchStore -InventoryPath $file.FullName `
                            -CatalogDirectory $file.Directory.FullName)) {
                    if ($seen.Add($selection.ArticleDirectory)) { $found.Add($selection) }
                }
                continue
            }
            throw "inventory-batch input file is not article.json or inventory.jsonl: '$entry'"
        }

        if (-not (Test-Path -LiteralPath $absolute -PathType Container)) {
            throw "inventory-batch input path not found: '$entry'"
        }
        $directory = (Resolve-Path -LiteralPath $absolute).Path
        if (Test-Path -LiteralPath ([System.IO.Path]::Combine($directory, 'article.json')) -PathType Leaf) {
            if ($seen.Add($directory)) {
                $found.Add((Read-InventoryBatchArticleManifest -ArticleDirectory $directory))
            }
            continue
        }
        $inventoryPath = [System.IO.Path]::Combine($directory, 'inventory.jsonl')
        if (-not (Test-Path -LiteralPath $inventoryPath -PathType Leaf)) {
            throw "inventory-batch catalog has no inventory.jsonl: '$entry'"
        }
        foreach ($selection in @(Expand-InventoryBatchStore -InventoryPath $inventoryPath `
                    -CatalogDirectory $directory)) {
            if ($seen.Add($selection.ArticleDirectory)) { $found.Add($selection) }
        }
    }

    foreach ($selection in $found) {
        if (-not (Test-PathIsDescendant -Root $RepositoryRoot -Path $selection.ArticleDirectory)) {
            throw "inventory-batch article selection escapes RepositoryRoot: '$($selection.ArticleDirectory)'"
        }
    }
    return $found
}

function Get-InventoryBatchManifestRecord {
    <# Planning-time manifest from the trusted record: identity (slug, tree
       fingerprint), the tree directory and entrypoint the worker is handed,
       and a cost hint from the row's archive byte count. Deposit validity is
       the ingestion transaction's business; planning refuses only what it
       cannot hand on: no tree sha256, no entrypoint, or a tree directory
       that is not on disk. It walks nothing. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $ArticleDirectory,
        [Parameter(Mandatory)] $Record
    )

    $slug = if ($Record.PSObject.Properties['slug'] -and $Record.slug) {
        [string]$Record.slug
    }
    else { [System.IO.Path]::GetFileName($ArticleDirectory) }

    $tree = Get-InventoryBatchSourceForm -Record $Record -Role 'latex-source-tree'
    $treeSha256 = if ($null -ne $tree -and $tree.PSObject.Properties['sha256']) { [string]$tree.sha256 } else { '' }
    if ([string]::IsNullOrWhiteSpace($treeSha256)) {
        throw "inventory-batch article '$ArticleDirectory' has no latex-source-tree sha256"
    }
    $entrypoint = if ($tree.PSObject.Properties['entrypoint']) { [string]$tree.entrypoint } else { '' }
    if ([string]::IsNullOrWhiteSpace($entrypoint)) {
        throw "inventory-batch article '$ArticleDirectory' has no latex-source-tree entrypoint"
    }

    $treePath = if ($tree.PSObject.Properties['path'] -and $tree.path) {
        ([string]$tree.path) -replace '\\', '/'
    }
    else { '' }
    $treeLeaf = if ($treePath -ne '') { $treePath.Substring($treePath.LastIndexOf('/') + 1) } else { "$slug-tex" }
    $treeDirectory = [System.IO.Path]::Combine($ArticleDirectory, $treeLeaf)
    if (-not (Test-Path -LiteralPath $treeDirectory -PathType Container)) {
        throw "inventory-batch article '$ArticleDirectory' has no latex-source-tree directory '$treeLeaf'"
    }

    $archive = Get-InventoryBatchSourceForm -Record $Record -Role 'latex-source-archive'
    $costHint = 0.0
    if ($null -ne $archive -and $archive.PSObject.Properties['bytes'] -and $archive.bytes) {
        $costHint = [double]$archive.bytes
    }
    elseif ($tree.PSObject.Properties['files'] -and $tree.files) {
        $costHint = [double]$tree.files
    }

    return [pscustomobject]@{
        ArticleDirectory = $ArticleDirectory
        Slug = $slug
        TreeSha256 = $treeSha256
        TreeDirectory = (Resolve-Path -LiteralPath $treeDirectory).Path
        Entrypoint = $entrypoint
        CostHint = $costHint
    }
}
