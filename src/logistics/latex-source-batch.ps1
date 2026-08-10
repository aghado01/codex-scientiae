#requires -Version 7.0
<#
  Batch LaTeX source deposit over a catalog parent.

  Discovers arXiv-shaped source archives under a catalog root (loose tarballs or per-child
  deposits), normalizes each into `{slug}/{slug}.tar.gz` or `arXiv-{slug}.tar.gz`, then runs
  New-LatexSourceDeposit so validation and article.json minting happen before inventory rebuild.
#>

. "$PSScriptRoot/latex-source.ps1"
. "$PSScriptRoot/portable-path.ps1"

# New-style arXiv id embedded in a tarball leaf: YYMM.NNNNN with optional version suffix.
$script:ArxivSourceSlugPattern = [regex]::new(
    '(?i)(?<slug>\d{4}\.\d{4,5}(?:v\d+)?)',
    [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)

function ConvertFrom-ArxivSourceSlugText {
    <#
    .SYNOPSIS
        Extract a new-style arXiv id slug from free text (filename stem, directory leaf, etc.).
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
    $match = $script:ArxivSourceSlugPattern.Match($Text)
    if (-not $match.Success) { return $null }
    return [string]$match.Groups['slug'].Value
}

function ConvertFrom-ArxivSourceArchiveLeaf {
    <#
    .SYNOPSIS
        Extract an arXiv source slug from a tarball filename.
    .DESCRIPTION
        Tolerates prefixes/suffixes around the id (for example arXiv-{slug}.tar.gz or
        paper_{slug}_src.tar.gz). Returns $null when the leaf is not a .tar.gz or no new-style
        arXiv id is present. Non-arXiv archive naming is intentionally unsupported here.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$FileName)

    $leaf = Split-Path -Leaf $FileName
    if ($leaf -notmatch '(?i)\.tar\.gz$') { return $null }
    $stem = $leaf.Substring(0, $leaf.Length - '.tar.gz'.Length)
    return ConvertFrom-ArxivSourceSlugText -Text $stem
}

function Resolve-LatexSourceBatchCatalogRoot {
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

function Get-LatexSourceBatchCandidates {
    <#
    .SYNOPSIS
        Discover deposit candidates under a catalog root.
    .DESCRIPTION
        Collects:
        - loose `*.tar.gz` files directly under the catalog whose names embed an arXiv slug
        - direct child directories that already contain a recognizable source archive

        Existing article.json deposits are omitted unless -IncludeExisting is set.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$CatalogDir,
        [switch]$IncludeExisting
    )

    $root = Resolve-LatexSourceBatchCatalogRoot -CatalogDir $CatalogDir
    $bySlug = [System.Collections.Generic.Dictionary[string, object]]::new(
        [System.StringComparer]::Ordinal)

    foreach ($file in @(Get-ChildItem -LiteralPath $root -Force -File -Filter '*.tar.gz' |
            Sort-Object Name)) {
        if (($file.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "catalog archive must not be a reparse point: '$($file.FullName)'"
        }
        $slug = ConvertFrom-ArxivSourceArchiveLeaf -FileName $file.Name
        if (-not $slug) {
            Write-Warning "skipping non-arXiv-shaped catalog archive '$($file.Name)'"
            continue
        }
        $documentDir = Join-Path $root $slug
        $articlePath = Join-Path $documentDir 'article.json'
        $hasArticle = [System.IO.File]::Exists($articlePath)
        if ($hasArticle -and -not $IncludeExisting) { continue }
        if ($bySlug.ContainsKey($slug)) {
            throw ("duplicate arXiv source slug '$slug' under catalog '$root': " +
                "'$($bySlug[$slug].ArchivePath)' and '$($file.FullName)'")
        }
        $bySlug[$slug] = [pscustomobject]@{
            Slug         = $slug
            ArchivePath  = $file.FullName
            DocumentDir  = $documentDir
            Origin       = 'loose-archive'
            HasArticle   = $hasArticle
            ArticlePath  = $articlePath
        }
    }

    foreach ($child in @(Get-ChildItem -LiteralPath $root -Force -Directory | Sort-Object Name)) {
        if (($child.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "catalog child must not be a reparse point: '$($child.FullName)'"
        }
        $archives = @(Get-ChildItem -LiteralPath $child.FullName -Force -File -Filter '*.tar.gz' |
                Where-Object { ($_.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -eq 0 } |
                Sort-Object Name)
        if ($archives.Count -eq 0) { continue }

        $slugFromDir = ConvertFrom-ArxivSourceSlugText -Text $child.Name
        $matched = [System.Collections.Generic.List[object]]::new()
        foreach ($archive in $archives) {
            $slugFromArchive = ConvertFrom-ArxivSourceArchiveLeaf -FileName $archive.Name
            if (-not $slugFromArchive) { continue }
            if ($slugFromDir -and $slugFromArchive -ne $slugFromDir) {
                throw ("archive slug '$slugFromArchive' disagrees with directory slug " +
                    "'$slugFromDir': '$($archive.FullName)'")
            }
            $matched.Add([pscustomobject]@{
                    Slug        = $slugFromArchive
                    ArchivePath = $archive.FullName
                })
        }
        if ($matched.Count -eq 0) { continue }
        if ($matched.Count -gt 1) {
            $names = @($matched | ForEach-Object { Split-Path -Leaf $_.ArchivePath }) -join ', '
            throw "catalog child '$($child.Name)' has multiple arXiv-shaped archives: $names"
        }
        $hit = $matched[0]
        $articlePath = Join-Path $child.FullName 'article.json'
        $hasArticle = [System.IO.File]::Exists($articlePath)
        if ($hasArticle -and -not $IncludeExisting) { continue }
        if ($bySlug.ContainsKey($hit.Slug)) {
            $prior = $bySlug[$hit.Slug]
            if (-not [string]::Equals(
                    [System.IO.Path]::GetFullPath($prior.ArchivePath),
                    [System.IO.Path]::GetFullPath($hit.ArchivePath),
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                throw ("duplicate arXiv source slug '$($hit.Slug)' under catalog '$root': " +
                    "'$($prior.ArchivePath)' and '$($hit.ArchivePath)'")
            }
            continue
        }
        $bySlug[$hit.Slug] = [pscustomobject]@{
            Slug         = $hit.Slug
            ArchivePath  = $hit.ArchivePath
            DocumentDir  = $child.FullName
            Origin       = 'child-archive'
            HasArticle   = $hasArticle
            ArticlePath  = $articlePath
        }
    }

    return @($bySlug.Values | Sort-Object Slug)
}

function Initialize-LatexSourceBatchArchivePlacement {
    <#
    .SYNOPSIS
        Ensure a candidate archive lives under `{slug}/` with an accepted deposit leaf name.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)]$Candidate)

    $documentDir = [string]$Candidate.DocumentDir
    $slug = [string]$Candidate.Slug
    $archive = [System.IO.Path]::GetFullPath([string]$Candidate.ArchivePath)
    [void][System.IO.Directory]::CreateDirectory($documentDir)

    $canonical = Join-Path $documentDir "$slug.tar.gz"
    $alias = Join-Path $documentDir "arXiv-$slug.tar.gz"
    if ([System.IO.File]::Exists($canonical) -and
        [string]::Equals(
            [System.IO.Path]::GetFullPath($canonical),
            $archive,
            [System.StringComparison]::OrdinalIgnoreCase)) {
        return $canonical
    }
    if ([System.IO.File]::Exists($alias) -and
        [string]::Equals(
            [System.IO.Path]::GetFullPath($alias),
            $archive,
            [System.StringComparison]::OrdinalIgnoreCase)) {
        return $alias
    }

    $target = if ([System.IO.File]::Exists($canonical)) { $alias } else { $canonical }
    if ([System.IO.File]::Exists($target) -and
        -not [string]::Equals(
            [System.IO.Path]::GetFullPath($target),
            $archive,
            [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "refusing to overwrite existing source archive '$target' while placing '$archive'"
    }

    if (-not [string]::Equals(
            [System.IO.Path]::GetFullPath($archive),
            [System.IO.Path]::GetFullPath($target),
            [System.StringComparison]::OrdinalIgnoreCase)) {
        [System.IO.File]::Move($archive, $target)
    }
    return [System.IO.Path]::GetFullPath($target)
}

function Invoke-LatexSourceDepositBatch {
    <#
    .SYNOPSIS
        Unpack/validate/deposit every arXiv-shaped source archive under a catalog root.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$CatalogDir,
        [switch]$IncludeExisting,
        [switch]$WhatIf,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300,
        [string]$MainTex = ''
    )

    $root = Resolve-LatexSourceBatchCatalogRoot -CatalogDir $CatalogDir
    $candidates = @(Get-LatexSourceBatchCandidates -CatalogDir $root -IncludeExisting:$IncludeExisting)
    $results = [System.Collections.Generic.List[object]]::new()

    foreach ($candidate in $candidates) {
        if ($WhatIf) {
            $results.Add([pscustomobject]@{
                    Slug        = $candidate.Slug
                    Status      = 'what-if'
                    DocumentDir = $candidate.DocumentDir
                    ArchivePath = $candidate.ArchivePath
                    Origin      = $candidate.Origin
                    HasArticle  = $candidate.HasArticle
                })
            continue
        }

        try {
            $placed = Initialize-LatexSourceBatchArchivePlacement -Candidate $candidate
            $depositArgs = @{
                DocumentDir          = $candidate.DocumentDir
                Slug                 = $candidate.Slug
                ArchivePath          = $placed
                EngineTimeoutSeconds = $EngineTimeoutSeconds
            }
            if ($PythonPath) { $depositArgs.PythonPath = $PythonPath }
            if ($MainTex) { $depositArgs.MainTex = $MainTex }
            $deposit = New-LatexSourceDeposit @depositArgs
            $results.Add([pscustomobject]@{
                    Slug         = $candidate.Slug
                    Status       = [string]$deposit.Status
                    Skipped      = [bool]$deposit.Skipped
                    DocumentDir  = $candidate.DocumentDir
                    ArchivePath  = $placed
                    ManifestPath = [string]$deposit.ManifestPath
                    Publication  = [string]$deposit.Publication
                    Origin       = $candidate.Origin
                })
        } catch {
            $results.Add([pscustomobject]@{
                    Slug        = $candidate.Slug
                    Status      = 'failed'
                    DocumentDir = $candidate.DocumentDir
                    ArchivePath = $candidate.ArchivePath
                    Origin      = $candidate.Origin
                    Error       = $_.Exception.Message
                })
        }
    }

    return [pscustomobject]@{
        CatalogDir   = $root
        CandidateCount = $results.Count
        Results      = $results.ToArray()
        FailedCount  = @($results | Where-Object { $_.Status -eq 'failed' }).Count
    }
}
