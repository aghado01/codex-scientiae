# Gauntlet adapter discovery helpers.

function Resolve-GauntletBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "gauntlet-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-GauntletBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    Resolve-BatchAdapterRunDirectory -Adapter 'gauntlet-batch' -RunDirectory $RunDirectory `
        -RepositoryRoot $RepositoryRoot
}

function Find-GauntletBatchArticle {
    <# Expand caller-selected paths to deposited article directories: an
       article dir (holds article.json), an article.json file, or a collection
       dir expanded ONE level to its article children. The adapter is
       path-based and every article must sit inside RepositoryRoot, because
       the job id is minted from the repository-relative address. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
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
            if ($file.Name -ne 'article.json') {
                throw "gauntlet-batch input file is not article.json: '$entry'"
            }
            if ($seen.Add($file.Directory.FullName)) { $found.Add($file.Directory.FullName) }
            continue
        }
        if (-not (Test-Path -LiteralPath $absolute -PathType Container)) {
            throw "gauntlet-batch input path not found: '$entry'"
        }

        $directory = (Resolve-Path -LiteralPath $absolute).Path
        if (Test-Path -LiteralPath ([System.IO.Path]::Combine($directory, 'article.json')) -PathType Leaf) {
            if ($seen.Add($directory)) { $found.Add($directory) }
            continue
        }

        $children = [System.Collections.Generic.List[string]]::new()
        foreach ($child in [System.IO.Directory]::EnumerateDirectories($directory)) {
            if (Test-Path -LiteralPath ([System.IO.Path]::Combine($child, 'article.json')) -PathType Leaf) {
                $children.Add($child)
            }
        }
        if ($children.Count -eq 0) {
            throw "gauntlet-batch found no deposited articles under: '$entry'"
        }
        $children.Sort([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($child in $children) {
            if ($seen.Add($child)) { $found.Add($child) }
        }
    }

    foreach ($articleDirectory in $found) {
        if (-not (Test-PathIsDescendant -Root $RepositoryRoot -Path $articleDirectory)) {
            throw "gauntlet-batch article selection escapes RepositoryRoot: '$articleDirectory'"
        }
    }

    return $found
}

function Get-GauntletBatchManifestRecord {
    <# Planning-time read of the deposit manifest: identity (slug, tree
       fingerprint) and a tree-size cost hint. Deposit validity is the
       ingestion transaction's business; planning only refuses manifests it
       cannot read. #>
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
        throw "gauntlet-batch could not read article.json in '$ArticleDirectory': $($_.Exception.Message)"
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
