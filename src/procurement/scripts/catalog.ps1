#requires -Version 7.0
<#
  Catalog-parent helpers for procurement.

  Library (dot-source): inventory build/fold and LaTeX deposit-batch discovery.
  CLI: -Build, -Fold, or -DepositBatch with -CatalogDir.

  Deposit ceremony lives in latex-source.ps1. This file sources it.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Library')]
param(
    [Parameter(ParameterSetName = 'Build')]
    [switch] $Build,

    [Parameter(ParameterSetName = 'Fold')]
    [switch] $Fold,

    [Parameter(ParameterSetName = 'DepositBatch')]
    [switch] $DepositBatch,

    [Parameter(Mandatory, ParameterSetName = 'Build')]
    [Parameter(Mandatory, ParameterSetName = 'Fold')]
    [Parameter(Mandatory, ParameterSetName = 'DepositBatch')]
    [ValidateNotNullOrEmpty()]
    [string] $CatalogDir,

    [Parameter(ParameterSetName = 'Build')]
    [Parameter(ParameterSetName = 'Fold')]
    [switch] $Force,

    [Parameter(ParameterSetName = 'DepositBatch')]
    [switch] $IncludeExisting,

    [Parameter(ParameterSetName = 'DepositBatch')]
    [string] $MainTex = '',

    [Parameter(ParameterSetName = 'DepositBatch')]
    [switch] $FailOnError,

    [Parameter(ParameterSetName = 'Build')]
    [Parameter(ParameterSetName = 'Fold')]
    [Parameter(ParameterSetName = 'DepositBatch')]
    [string] $PythonPath = '',

    [Parameter(ParameterSetName = 'Build')]
    [Parameter(ParameterSetName = 'Fold')]
    [Parameter(ParameterSetName = 'DepositBatch')]
    [ValidateRange(1, 3600)]
    [int] $EngineTimeoutSeconds = 300
)

. "$PSScriptRoot/latex-source.ps1"

function Resolve-ProcurementCatalogRoot {
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

    $root = Resolve-ProcurementCatalogRoot -CatalogDir $CatalogDir
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

    $root = Resolve-ProcurementCatalogRoot -CatalogDir $CatalogDir
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

    $root = Resolve-ProcurementCatalogRoot -CatalogDir $CatalogDir
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

    $root = Resolve-ProcurementCatalogRoot -CatalogDir $CatalogDir
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
            Slug        = $slug
            ArchivePath = $file.FullName
            DocumentDir = $documentDir
            Origin      = 'loose-archive'
            HasArticle  = $hasArticle
            ArticlePath = $articlePath
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
            Slug        = $hit.Slug
            ArchivePath = $hit.ArchivePath
            DocumentDir = $child.FullName
            Origin      = 'child-archive'
            HasArticle  = $hasArticle
            ArticlePath = $articlePath
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

    $root = Resolve-ProcurementCatalogRoot -CatalogDir $CatalogDir
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
        CatalogDir     = $root
        CandidateCount = $results.Count
        Results        = $results.ToArray()
        FailedCount    = @($results | Where-Object { $_.Status -eq 'failed' }).Count
    }
}

if ($PSCmdlet.ParameterSetName -ne 'Library') {
    $ErrorActionPreference = 'Stop'
    switch ($PSCmdlet.ParameterSetName) {
        'Build' {
            Invoke-InventoryBuild -CatalogDir $CatalogDir `
                -Force:$Force `
                -PythonPath $PythonPath `
                -EngineTimeoutSeconds $EngineTimeoutSeconds |
                ConvertTo-Json -Depth 6
        }
        'Fold' {
            Invoke-InventoryFold -CatalogDir $CatalogDir `
                -Force:$Force `
                -PythonPath $PythonPath `
                -EngineTimeoutSeconds $EngineTimeoutSeconds |
                ConvertTo-Json -Depth 6
        }
        'DepositBatch' {
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
        }
    }
}
