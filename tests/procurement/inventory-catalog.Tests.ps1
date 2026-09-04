#requires -Version 7.0

BeforeDiscovery {
    $repository = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $candidate = Join-Path $repository '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($candidate)) {
        $candidate = Join-Path $repository '.venv/bin/python'
    }
    $script:InventoryPythonAvailable = [System.IO.File]::Exists($candidate)
}

BeforeAll {
    $script:RepositoryRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $script:Python = Join-Path $script:RepositoryRoot '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($script:Python)) {
        $script:Python = Join-Path $script:RepositoryRoot '.venv/bin/python'
    }
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false, $true)

    . (Join-Path $script:RepositoryRoot 'src/procurement/scripts/inventory-catalog.ps1')
    . (Join-Path $script:RepositoryRoot 'src/procurement/scripts/latex-source-batch.ps1')

    function Write-InventoryTestArticle {
        param(
            [Parameter(Mandatory)][string]$CatalogDir,
            [Parameter(Mandatory)][string]$Slug
        )
        $documentDir = Join-Path $CatalogDir $Slug
        [void][System.IO.Directory]::CreateDirectory($documentDir)
        $article = @{
            schema           = 'codex-scientiae/article/0.1'
            state            = 'source-ready'
            slug             = $Slug
            initialized_utc  = '2026-08-07T00:00:00Z'
            title            = 'Quantum Chaos'
            authors          = @('Author')
            abstract         = 'Abstract...'
            identifiers      = @{
                arxiv           = ($Slug -replace 'v\d+$', '')
                arxiv_versioned = $Slug
                doi             = $null
            }
            categories       = @('cs.CL')
            primary_category = 'cs.CL'
            published        = $null
            updated          = $null
            evidence         = @{
                provider_metadata     = @()
                latex_source          = @{
                    entrypoint   = 'main.tex'
                    selection    = 'single-candidate'
                    declarations = @{
                        title_tex   = $null
                        authors_tex = @()
                        doi         = $null
                    }
                }
                package_control_files = @()
            }
            source_forms     = @(
                @{
                    role         = 'latex-source-archive'
                    path         = "$Slug.tar.gz"
                    format       = 'application/gzip'
                    bytes        = 1
                    sha256       = ('0' * 64)
                    archive_kind = 'tar+gzip'
                }
                @{
                    role                 = 'latex-source-tree'
                    path                 = "$Slug-tex"
                    format               = 'application/x-latex-source-tree'
                    derived_from         = "$Slug.tar.gz"
                    entrypoint           = 'main.tex'
                    entrypoint_selection = 'single-candidate'
                    files                = 1
                    tex_files            = 1
                    sha256               = ('1' * 64)
                }
            )
            validation       = @{
                status         = 'valid'
                validated_utc  = '2026-08-07T00:00:00Z'
                publication    = 'published-new-tree'
                checks         = @(
                    @{
                        name         = 'gzip-readable'
                        outcome      = 'passed'
                        archive_kind = 'tar+gzip'
                    }
                )
            }
        }
        $path = Join-Path $documentDir 'article.json'
        [System.IO.File]::WriteAllText(
            $path,
            (($article | ConvertTo-Json -Depth 20 -Compress) + "`n"),
            $script:Utf8)
        return $path
    }
}

Describe 'ConvertFrom-ArxivSourceArchiveLeaf' {
    It 'extracts a slug from prefixed and suffixed tarball names' {
        ConvertFrom-ArxivSourceArchiveLeaf -FileName 'arXiv-1105.4224v1.tar.gz' |
            Should -Be '1105.4224v1'
        ConvertFrom-ArxivSourceArchiveLeaf -FileName 'paper_2506.07658v3_src.tar.gz' |
            Should -Be '2506.07658v3'
        ConvertFrom-ArxivSourceArchiveLeaf -FileName '1105.4224v1.tar.gz' |
            Should -Be '1105.4224v1'
    }

    It 'returns null for non-arXiv or non-tarball leaves' {
        ConvertFrom-ArxivSourceArchiveLeaf -FileName 'notes.tar.gz' | Should -BeNullOrEmpty
        ConvertFrom-ArxivSourceArchiveLeaf -FileName 'arXiv-1105.4224v1.zip' | Should -BeNullOrEmpty
    }
}

Describe 'Get-LatexSourceBatchCandidates' {
    It 'discovers loose and child archives and skips existing articles by default' {
        $catalog = Join-Path $TestDrive 'catalog-candidates'
        [void][System.IO.Directory]::CreateDirectory($catalog)

        $loose = Join-Path $catalog 'arXiv-1105.4224v1.tar.gz'
        [System.IO.File]::WriteAllBytes($loose, [byte[]](0x1f, 0x8b, 0x00))

        $childSlug = '2506.07658v3'
        $childDir = Join-Path $catalog $childSlug
        [void][System.IO.Directory]::CreateDirectory($childDir)
        $childArchive = Join-Path $childDir "arXiv-$childSlug.tar.gz"
        [System.IO.File]::WriteAllBytes($childArchive, [byte[]](0x1f, 0x8b, 0x00))

        $existingSlug = '1804.01637v1'
        $existingDir = Join-Path $catalog $existingSlug
        [void][System.IO.Directory]::CreateDirectory($existingDir)
        [System.IO.File]::WriteAllBytes(
            (Join-Path $existingDir "arXiv-$existingSlug.tar.gz"),
            [byte[]](0x1f, 0x8b, 0x00))
        [System.IO.File]::WriteAllText(
            (Join-Path $existingDir 'article.json'),
            "{`"slug`":`"$existingSlug`"}`n",
            $script:Utf8)

        $found = @(Get-LatexSourceBatchCandidates -CatalogDir $catalog)
        $found.Slug | Should -Be @('1105.4224v1', '2506.07658v3')

        $withExisting = @(Get-LatexSourceBatchCandidates -CatalogDir $catalog -IncludeExisting)
        $withExisting.Slug | Should -Be @('1105.4224v1', '1804.01637v1', '2506.07658v3')
    }

    It 'places a loose archive under the slug directory with a deposit-accepted name' {
        $catalog = Join-Path $TestDrive 'catalog-place'
        [void][System.IO.Directory]::CreateDirectory($catalog)
        $loose = Join-Path $catalog 'paper_1105.4224v1_src.tar.gz'
        [System.IO.File]::WriteAllBytes($loose, [byte[]](0x1f, 0x8b, 0x00))

        $candidate = @(Get-LatexSourceBatchCandidates -CatalogDir $catalog)[0]
        $placed = Initialize-LatexSourceBatchArchivePlacement -Candidate $candidate
        $placed | Should -Be (Join-Path $catalog '1105.4224v1/1105.4224v1.tar.gz')
        [System.IO.File]::Exists($placed) | Should -BeTrue
        [System.IO.File]::Exists($loose) | Should -BeFalse
    }
}

Describe 'Invoke-InventoryBuild' {
    It 'builds inventory.jsonl from direct-child article.json sentinels' -Skip:(-not $script:InventoryPythonAvailable) {
        $catalog = Join-Path $TestDrive 'catalog-build'
        [void][System.IO.Directory]::CreateDirectory($catalog)
        Write-InventoryTestArticle -CatalogDir $catalog -Slug 'b.0001v1' | Out-Null
        Write-InventoryTestArticle -CatalogDir $catalog -Slug 'a.0001v1' | Out-Null
        [void][System.IO.Directory]::CreateDirectory((Join-Path $catalog 'no-article'))

        $result = Invoke-InventoryBuild -CatalogDir $catalog -PythonPath $script:Python
        $result.article_count | Should -Be 2
        $result.slugs | Should -Be @('a.0001v1', 'b.0001v1')
        [System.IO.File]::Exists($result.inventory_path) | Should -BeTrue
    }

    It 'refuses an existing inventory without -Force and overwrites with -Force' -Skip:(-not $script:InventoryPythonAvailable) {
        $catalog = Join-Path $TestDrive 'catalog-force'
        [void][System.IO.Directory]::CreateDirectory($catalog)
        Write-InventoryTestArticle -CatalogDir $catalog -Slug 'a.0001v1' | Out-Null

        $first = Invoke-InventoryBuild -CatalogDir $catalog -PythonPath $script:Python
        $first.article_count | Should -Be 1

        { Invoke-InventoryBuild -CatalogDir $catalog -PythonPath $script:Python } |
            Should -Throw -ExpectedMessage '*already exists*'

        Write-InventoryTestArticle -CatalogDir $catalog -Slug 'b.0001v1' | Out-Null
        $second = Invoke-InventoryBuild -CatalogDir $catalog -Force -PythonPath $script:Python
        $second.article_count | Should -Be 2
        $second.slugs | Should -Be @('a.0001v1', 'b.0001v1')
    }
}

Describe 'procurement CLI wrappers' {
    It 'resolve logistics libraries from src/procurement/scripts' {
        $scriptsDir = Join-Path $script:RepositoryRoot 'src/procurement/scripts'
        foreach ($name in @(
                'inventory-catalog.ps1',
                'latex-source-batch.ps1'
            )) {
            [System.IO.File]::Exists((Join-Path $scriptsDir $name)) | Should -BeTrue
        }

        $missing = Join-Path $TestDrive 'missing-catalog'
        foreach ($name in @(
                'inventory-build.ps1',
                'inventory-fold.ps1',
                'latex-source-deposit-batch.ps1'
            )) {
            $err = $null
            try {
                & (Join-Path $scriptsDir $name) -CatalogDir $missing
            }
            catch {
                $err = $_
            }
            $err | Should -Not -BeNullOrEmpty
            "$err" | Should -Not -Match 'inventory-catalog\.ps1|latex-source-batch\.ps1'
        }
    }
}
