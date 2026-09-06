# Inventory-batch discovery helpers.

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

function Resolve-InventoryBatchArticleDirectoryFromRecord {
    <# First-order inventory rows keep article-relative source_forms paths and
       live at {catalog}/{slug}/. Folded rows relocate those paths one hop, so
       the article directory is the parent of the latex-source-tree path. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Record,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $CatalogDirectory
    )

    $slug = if ($Record.PSObject.Properties['slug']) { [string]$Record.slug } else { '' }
    if ([string]::IsNullOrWhiteSpace($slug)) {
        throw "inventory-batch inventory row has no slug under '$CatalogDirectory'"
    }

    $direct = [System.IO.Path]::Combine($CatalogDirectory, $slug)
    $directArticle = [System.IO.Path]::Combine($direct, 'article.json')
    if (Test-Path -LiteralPath $directArticle -PathType Leaf) {
        return (Resolve-Path -LiteralPath $direct).Path
    }

    $treePath = ''
    if ($Record.PSObject.Properties['source_forms']) {
        foreach ($form in @($Record.source_forms)) {
            if ($null -ne $form -and $form.PSObject.Properties['role'] -and
                    [string]$form.role -eq 'latex-source-tree' -and
                    $form.PSObject.Properties['path'] -and $form.path) {
                $treePath = ([string]$form.path) -replace '\\', '/'
                break
            }
        }
    }
    $slash = $treePath.LastIndexOf('/')
    if ($slash -lt 1) {
        throw "inventory-batch could not locate article directory for slug '$slug' under '$CatalogDirectory'"
    }

    $candidate = $CatalogDirectory
    foreach ($segment in @($treePath.Substring(0, $slash) -split '/')) {
        if ([string]::IsNullOrWhiteSpace($segment) -or $segment -eq '.' -or $segment -eq '..') {
            throw "inventory-batch inventory row '$slug' has a non-confined tree path under '$CatalogDirectory'"
        }
        $candidate = [System.IO.Path]::Combine($candidate, $segment)
    }
    $articleJson = [System.IO.Path]::Combine($candidate, 'article.json')
    if (-not (Test-Path -LiteralPath $articleJson -PathType Leaf)) {
        throw "inventory-batch inventory row '$slug' does not resolve to article.json under '$CatalogDirectory'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Expand-InventoryBatchStore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $CatalogDirectory,
        [string] $PythonPath
    )

    $range = @{
        Path = $InventoryPath
        Start = 0
    }
    if (-not [string]::IsNullOrWhiteSpace($PythonPath)) {
        $range.PythonPath = $PythonPath
    }

    $records = @(jsonl_engine-client\Get-JsonlRange @range)
    $found = [System.Collections.Generic.List[string]]::new()
    foreach ($record in $records) {
        if ($null -eq $record) { continue }
        if ($record.PSObject.Properties['__type__'] -and [string]$record.__type__ -eq 'header') {
            continue
        }
        $found.Add((Resolve-InventoryBatchArticleDirectoryFromRecord -Record $record `
                    -CatalogDirectory $CatalogDirectory))
    }
    if ($found.Count -eq 0) {
        throw "inventory-batch inventory contains no articles: '$InventoryPath'"
    }
    return $found
}

function Find-InventoryBatchArticle {
    <# Expand caller-selected paths to deposited article directories.

       A Path entry may be an article directory, an article.json file, an
       inventory.jsonl file, or a catalog directory that holds inventory.jsonl
       (first-order or folded). Catalog directories without inventory.jsonl
       are refused: the inventory is the population, not a directory walk. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [string] $PythonPath
    )

    $found = [System.Collections.Generic.List[string]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($entry in $Path) {
        $absolute = if ([System.IO.Path]::IsPathFullyQualified($entry)) {
            [System.IO.Path]::GetFullPath($entry)
        }
        else { [System.IO.Path]::GetFullPath($entry, $RepositoryRoot) }

        if (Test-Path -LiteralPath $absolute -PathType Leaf) {
            $file = Get-Item -LiteralPath $absolute
            if ($file.Name -eq 'article.json') {
                if ($seen.Add($file.Directory.FullName)) { $found.Add($file.Directory.FullName) }
                continue
            }
            if ($file.Name -eq 'inventory.jsonl') {
                $fromStore = @(Expand-InventoryBatchStore -InventoryPath $file.FullName `
                        -CatalogDirectory $file.Directory.FullName -PythonPath $PythonPath)
                foreach ($articleDirectory in $fromStore) {
                    if ($seen.Add($articleDirectory)) { $found.Add($articleDirectory) }
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
            if ($seen.Add($directory)) { $found.Add($directory) }
            continue
        }

        $inventoryPath = [System.IO.Path]::Combine($directory, 'inventory.jsonl')
        if (-not (Test-Path -LiteralPath $inventoryPath -PathType Leaf)) {
            throw "inventory-batch catalog has no inventory.jsonl: '$entry'"
        }
        $fromStore = @(Expand-InventoryBatchStore -InventoryPath $inventoryPath `
                -CatalogDirectory $directory -PythonPath $PythonPath)
        foreach ($articleDirectory in $fromStore) {
            if ($seen.Add($articleDirectory)) { $found.Add($articleDirectory) }
        }
    }

    foreach ($articleDirectory in $found) {
        if (-not (Test-PathIsDescendant -Root $RepositoryRoot -Path $articleDirectory)) {
            throw "inventory-batch article selection escapes RepositoryRoot: '$articleDirectory'"
        }
    }

    return $found
}

function Get-InventoryBatchManifestRecord {
    <# Planning-time read of the deposit manifest: identity (slug, tree
       fingerprint) and a tree-size cost hint. Deposit validity is the
       ingestion transaction's business; planning refuses a manifest it
       cannot read or a deposit with no latex-source-tree sha256. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $ArticleDirectory
    )

    $articleJson = [System.IO.Path]::Combine($ArticleDirectory, 'article.json')
    $article = $null
    try {
        $article = Get-Content -LiteralPath $articleJson -Raw | ConvertFrom-Json
    }
    catch {
        throw "inventory-batch could not read article.json in '$ArticleDirectory': $($_.Exception.Message)"
    }

    $slug = if ($article.PSObject.Properties['slug'] -and $article.slug) {
        [string]$article.slug
    }
    else { [System.IO.Path]::GetFileName($ArticleDirectory) }

    $treeSha256 = ''
    $treePath = ''
    if ($article.PSObject.Properties['source_forms']) {
        foreach ($form in @($article.source_forms)) {
            if ($null -ne $form -and $form.PSObject.Properties['role'] -and
                [string]$form.role -eq 'latex-source-tree') {
                if ($form.PSObject.Properties['sha256']) { $treeSha256 = [string]$form.sha256 }
                if ($form.PSObject.Properties['path']) { $treePath = [string]$form.path }
                break
            }
        }
    }
    if ([string]::IsNullOrWhiteSpace($treeSha256)) {
        throw "inventory-batch article '$ArticleDirectory' has no latex-source-tree sha256"
    }

    $treeBytes = 0L
    $treeDirectory = ''
    if ($treePath -ne '') {
        $candidate = [System.IO.Path]::Combine($ArticleDirectory, $treePath)
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            $treeDirectory = $candidate
            foreach ($file in [System.IO.Directory]::EnumerateFiles(
                    $treeDirectory, '*', [System.IO.SearchOption]::AllDirectories)) {
                $treeBytes += [System.IO.FileInfo]::new($file).Length
            }
        }
    }

    return [pscustomobject]@{
        ArticleDirectory = $ArticleDirectory
        Slug = $slug
        TreeSha256 = $treeSha256
        TreeDirectory = $treeDirectory
        TreeBytes = $treeBytes
    }
}
