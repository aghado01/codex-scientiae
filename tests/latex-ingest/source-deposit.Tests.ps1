#requires -Version 7.0

BeforeAll {
    . "$PSScriptRoot/../../src/latex-ingest/source-deposit.ps1"

    function New-TestLatexTarGzip {
        param(
            [Parameter(Mandatory)] [string]$Path,
            [Parameter(Mandatory)] [System.Collections.IDictionary]$Files
        )
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream,
            [System.IO.Compression.CompressionLevel]::Optimal,
            $true
        )
        $writer = [System.Formats.Tar.TarWriter]::new(
            $gzip,
            [System.Formats.Tar.TarEntryFormat]::Pax,
            $true
        )
        try {
            foreach ($pair in $Files.GetEnumerator()) {
                $bytes = if ($pair.Value -is [byte[]]) {
                    $pair.Value
                } else {
                    [System.Text.UTF8Encoding]::new($false).GetBytes([string]$pair.Value)
                }
                $entry = [System.Formats.Tar.PaxTarEntry]::new(
                    [System.Formats.Tar.TarEntryType]::RegularFile,
                    [string]$pair.Key
                )
                $data = [System.IO.MemoryStream]::new($bytes)
                try {
                    $entry.DataStream = $data
                    $writer.WriteEntry($entry)
                } finally {
                    $data.Dispose()
                }
            }
        } finally {
            $writer.Dispose()
            $gzip.Dispose()
            $fileStream.Dispose()
        }
    }

    function New-TestLatexSingleGzip {
        param([Parameter(Mandatory)] [string]$Path, [Parameter(Mandatory)] [byte[]]$Bytes)
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream,
            [System.IO.Compression.CompressionLevel]::Optimal
        )
        try { $gzip.Write($Bytes, 0, $Bytes.Length) }
        finally { $gzip.Dispose(); $fileStream.Dispose() }
    }

    function New-TestDocumentDir {
        param([string]$Slug = '1234.5678v1')
        $root = Join-Path ([System.IO.Path]::GetTempPath()) ("source-deposit-test-" + [guid]::NewGuid().ToString('N'))
        $documentDir = Join-Path $root $Slug
        New-Item -ItemType Directory -Path $documentDir -Force | Out-Null
        return [pscustomobject]@{ root = $root; document_dir = $documentDir; slug = $Slug }
    }

    function Assert-NoSourceDepositTransactionResidue {
        param([Parameter(Mandatory)] [string]$DocumentDir)
        Test-Path (Join-Path $DocumentDir '.source-deposit.lock') | Should -BeFalse
        @(Get-ChildItem -LiteralPath $DocumentDir -Force | Where-Object {
                $_.Name -match '^\..+\.(?:validate|expand|payload)-' -or $_.Name -like '.metadata.*.tmp'
            }).Count | Should -Be 0
    }
}

Describe 'standalone LaTeX source-deposit initialization' {
    BeforeEach {
        $script:deposit = New-TestDocumentDir
    }

    AfterEach {
        if ($script:deposit -and (Test-Path -LiteralPath $script:deposit.root)) {
            Remove-Item -LiteralPath $script:deposit.root -Recurse -Force
        }
    }

    It 'normalizes an alias, publishes the stable tree, and writes metadata.json as the final success sentinel' {
        $slug = $deposit.slug
        $alias = Join-Path $deposit.document_dir "arXiv-$slug.tar.gz"
        New-TestLatexTarGzip -Path $alias -Files ([ordered]@{
                'paper.tex'    = '\documentclass{article}\title{Deposited {Paper}}\author{Ada}\begin{document}Body.\end{document}'
                '00README.json' = '{"stamp":[{"filename":"paper.tex"}]}'
                'figures/a.txt' = 'asset'
            })

        $result = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir
        $result.status | Should -Be 'initialized'
        Test-Path (Join-Path $deposit.document_dir "$slug.tar.gz") | Should -BeTrue
        Test-Path $alias | Should -BeFalse
        Test-Path (Join-Path $deposit.document_dir "$slug-tex/paper.tex") | Should -BeTrue
        Test-Path (Join-Path $deposit.document_dir "$slug-tex/00README.json") | Should -BeTrue
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeTrue

        $manifest = Read-SourceDepositJson (Join-Path $deposit.document_dir 'metadata.json')
        (Test-ExistingSourceDeposit -Manifest $manifest `
                -ManifestPath (Join-Path $deposit.document_dir 'metadata.json') `
                -DocumentDir $deposit.document_dir -Slug $slug).status |
            Should -Be 'already-initialized'
        $manifest.schema | Should -Be 'codex-scientiae/document-metadata/0.1'
        $manifest.state | Should -Be 'source-ready'
        $manifest.evidence.latex_source.entrypoint | Should -Be 'paper.tex'
        $manifest.evidence.latex_source.declarations.title_tex | Should -Be 'Deposited {Paper}'
        @($manifest.evidence.package_control_files).Count | Should -Be 1
        $manifest.evidence.package_control_files[0].path | Should -Be '00README.json'
        $manifest.document.title | Should -BeNullOrEmpty
        Assert-NoSourceDepositTransactionResidue $deposit.document_dir
    }

    It 'uses optional provider metadata without making it a prerequisite for source-ready' {
        $slug = $deposit.slug
        New-TestLatexTarGzip -Path (Join-Path $deposit.document_dir "$slug.tar.gz") -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\title{Embedded}\begin{document}Body.\end{document}'
            })
        $provider = [ordered]@{
            id = '1234.5678'; idv = $slug; title = 'Provider title'; authors = @('A. Author', 'B. Author')
            abstract = 'Abstract'; categories = @('cs.AI'); primary_category = 'cs.AI'
            published = '2026-01-01T00:00:00Z'; updated = '2026-01-02T00:00:00Z'; doi = '10.1/example'
            fetched_at = '2026-08-04T00:00:00Z'; fetched_by = 'test-procurement/1'
        }
        [System.IO.File]::WriteAllText(
            (Join-Path $deposit.document_dir "$slug.arxiv.json"),
            (ConvertTo-Json $provider -Depth 8),
            [System.Text.UTF8Encoding]::new($false)
        )

        $result = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir
        $result.manifest.document.title | Should -Be 'Provider title'
        @($result.manifest.document.authors).Count | Should -Be 2
        $result.manifest.document.identifiers.arxiv_versioned | Should -Be $slug
        @($result.manifest.evidence.provider_metadata).Count | Should -Be 1
        $result.manifest.evidence.latex_source.declarations.title_tex | Should -Be 'Embedded'
    }

    It 'anchors scoped relative paths to the deposit rather than the repository or ambient working directory' {
        $slug = $deposit.slug
        New-TestLatexTarGzip -Path (Join-Path $deposit.document_dir "$slug.tar.gz") -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Local.\end{document}'
            })
        $provider = [ordered]@{ id = '1234.5678'; idv = $slug; title = 'Locality'; authors = @() }
        [System.IO.File]::WriteAllText(
            (Join-Path $deposit.document_dir "$slug.arxiv.json"),
            (ConvertTo-Json $provider -Depth 4),
            [System.Text.UTF8Encoding]::new($false)
        )

        Push-Location $deposit.root
        try {
            $result = Initialize-LatexSourceDeposit -DocumentDir $slug `
                -ArchivePath "$slug.tar.gz" -ProviderMetadataPath "$slug.arxiv.json"
        } finally {
            Pop-Location
        }
        $result.status | Should -Be 'initialized'
        $result.manifest.document.title | Should -Be 'Locality'
        $result.metadata_path | Should -Be (Join-Path $deposit.document_dir 'metadata.json')

        $guardSlug = 'guarded-inputs'
        $guardDocument = Join-Path $deposit.root $guardSlug
        [void][System.IO.Directory]::CreateDirectory($guardDocument)
        $guardArchive = Join-Path $guardDocument "$guardSlug.tar.gz"
        New-TestLatexTarGzip -Path $guardArchive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Guarded.\end{document}'
            })
        $guardProvider = Join-Path $guardDocument "$guardSlug.arxiv.json"
        [System.IO.File]::WriteAllText(
            $guardProvider,
            (ConvertTo-Json ([ordered]@{ idv = $guardSlug; authors = @() })),
            [System.Text.UTF8Encoding]::new($false)
        )
        $guardPdf = Join-Path $guardDocument "$guardSlug.pdf"
        [System.IO.File]::WriteAllBytes($guardPdf, [byte[]](0x25, 0x50, 0x44, 0x46))

        $script:GuardedSourceDepositPath = $guardArchive
        Mock Test-PathHasReparsePoint {
            param([string]$Path)
            return Test-LatexPathsEqual -Left $Path -Right $script:GuardedSourceDepositPath
        }
        { Resolve-SourceDepositArchive -DocumentDir $guardDocument -Slug $guardSlug } |
            Should -Throw '*source archive must not traverse a symbolic link or reparse point*'

        $script:GuardedSourceDepositPath = $guardProvider
        { Resolve-SourceDepositProviderMetadata -DocumentDir $guardDocument -Slug $guardSlug } |
            Should -Throw '*provider metadata must not traverse a symbolic link or reparse point*'

        $script:GuardedSourceDepositPath = $guardPdf
        { Initialize-LatexSourceDeposit -DocumentDir $guardDocument } |
            Should -Throw '*PDF source must not traverse a symbolic link or reparse point*'
        Test-Path (Join-Path $guardDocument "$guardSlug-tex") | Should -BeFalse
        Test-Path (Join-Path $guardDocument 'metadata.json') | Should -BeFalse
        Assert-NoSourceDepositTransactionResidue $guardDocument
    }

    It 'is idempotent and validates rather than rewriting an existing sentinel' {
        $slug = $deposit.slug
        New-TestLatexTarGzip -Path (Join-Path $deposit.document_dir "$slug.tar.gz") -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Body.\end{document}'
            })
        $first = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir
        $manifestPath = Join-Path $deposit.document_dir 'metadata.json'
        $beforeHash = (Get-FileHash $manifestPath -Algorithm SHA256).Hash
        $beforeWrite = (Get-Item $manifestPath).LastWriteTimeUtc

        $second = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir
        $second.status | Should -Be 'already-initialized'
        (Get-FileHash $manifestPath -Algorithm SHA256).Hash | Should -Be $beforeHash
        (Get-Item $manifestPath).LastWriteTimeUtc | Should -Be $beforeWrite
        $second.source_path | Should -Be $first.source_path
    }

    It 'recovers a matching published tree after a pre-sentinel interruption' {
        $slug = $deposit.slug
        $archive = Join-Path $deposit.document_dir "$slug.tar.gz"
        $source = Join-Path $deposit.document_dir "$slug-tex"
        New-TestLatexTarGzip -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Body.\end{document}'
            })
        Expand-LatexSourceArchive -ArchivePath $archive -DestinationPath $source | Out-Null

        $result = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir
        $result.status | Should -Be 'initialized'
        $result.manifest.validation.publication | Should -Be 'recovered-existing-tree'
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeTrue
    }

    It 'refuses a conflicting existing tree and leaves it untouched without a sentinel' {
        $slug = $deposit.slug
        $archive = Join-Path $deposit.document_dir "$slug.tar.gz"
        $source = Join-Path $deposit.document_dir "$slug-tex"
        New-TestLatexTarGzip -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Archive body.\end{document}'
            })
        New-Item -ItemType Directory -Path $source | Out-Null
        [System.IO.File]::WriteAllText(
            (Join-Path $source 'main.tex'),
            '\documentclass{article}\begin{document}Different body.\end{document}',
            [System.Text.UTF8Encoding]::new($false)
        )

        { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir } | Should -Throw '*differs from the validated archive*'
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
        (Get-Content (Join-Path $source 'main.tex') -Raw) | Should -Match 'Different body'

        Remove-Item -LiteralPath $source -Recurse -Force
        $rootTarget = Join-Path $deposit.root 'root-reparse-target'
        [void][System.IO.Directory]::CreateDirectory($rootTarget)
        [System.IO.File]::WriteAllText(
            (Join-Path $rootTarget 'main.tex'),
            '\documentclass{article}\begin{document}Archive body.\end{document}',
            [System.Text.UTF8Encoding]::new($false)
        )
        $directoryLinkType = if ([System.OperatingSystem]::IsWindows()) { 'Junction' } else { 'SymbolicLink' }
        [void](New-Item -ItemType $directoryLinkType -Path $source -Target $rootTarget -ErrorAction Stop)
        try {
            { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir } |
                Should -Throw '*source tree contains a reparse point*'
            Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
        } finally {
            Remove-Item -LiteralPath $source -Force
        }

        [System.IO.Directory]::Move($rootTarget, $source)
        $descendantTarget = Join-Path $deposit.root 'descendant-reparse-target'
        [void][System.IO.Directory]::CreateDirectory($descendantTarget)
        [System.IO.File]::WriteAllText(
            (Join-Path $descendantTarget 'asset.txt'),
            'external asset',
            [System.Text.UTF8Encoding]::new($false)
        )
        $descendantLink = Join-Path $source 'linked-assets'
        [void](New-Item -ItemType $directoryLinkType -Path $descendantLink `
                -Target $descendantTarget -ErrorAction Stop)
        try {
            { Get-LatexSourceTreeFingerprint -RootPath $source } |
                Should -Throw '*source tree contains a reparse point*'
            { Test-LatexSourceTree -RootPath $source -Slug $slug } |
                Should -Throw '*source tree contains a reparse point*'
        } finally {
            Remove-Item -LiteralPath $descendantLink -Force
        }

        Assert-NoSourceDepositTransactionResidue $deposit.document_dir
    }

    It 'leaves no sentinel or partial tree when source validation fails' {
        $slug = $deposit.slug
        $alias = Join-Path $deposit.document_dir "arXiv-$slug.tar.gz"
        New-TestLatexTarGzip -Path $alias -Files ([ordered]@{ 'notes.txt' = 'not LaTeX source' })

        { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir } | Should -Throw '*no .tex source*'
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
        Test-Path (Join-Path $deposit.document_dir "$slug-tex") | Should -BeFalse
        Test-Path $alias | Should -BeTrue
        Test-Path (Join-Path $deposit.document_dir "$slug.tar.gz") | Should -BeFalse
        Assert-NoSourceDepositTransactionResidue $deposit.document_dir
    }

    It 'requires an explicit entrypoint when multiple non-conventional documents are present' {
        $slug = $deposit.slug
        $archive = Join-Path $deposit.document_dir "$slug.tar.gz"
        New-TestLatexTarGzip -Path $archive -Files ([ordered]@{
                'a.tex' = '\documentclass{article}\begin{document}A\end{document}'
                'b.tex' = '\documentclass{article}\begin{document}B\end{document}'
            })

        { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir } | Should -Throw '*ambiguous LaTeX entrypoint*'
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
        $result = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir -MainTex 'b.tex'
        $result.manifest.evidence.latex_source.entrypoint | Should -Be 'b.tex'
        $result.manifest.evidence.latex_source.selection | Should -Be 'explicit'
    }

    It 'rejects traversal members before publication' {
        $slug = $deposit.slug
        $archive = Join-Path $deposit.document_dir "$slug.tar.gz"
        New-TestLatexTarGzip -Path $archive -Files ([ordered]@{
                '../escape.tex' = '\documentclass{article}\begin{document}Escape\end{document}'
            })

        { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir } | Should -Throw '*escapes its root*'
        Test-Path (Join-Path $deposit.root 'escape.tex') | Should -BeFalse
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
        Assert-NoSourceDepositTransactionResidue $deposit.document_dir
    }

    It 'rejects invalid UTF-8 LaTeX without publishing a sentinel' {
        $slug = $deposit.slug
        $prefix = [System.Text.Encoding]::ASCII.GetBytes('\documentclass{article}\begin{document}')
        $suffix = [System.Text.Encoding]::ASCII.GetBytes('\end{document}')
        $bytes = [byte[]]::new($prefix.Length + 2 + $suffix.Length)
        [Array]::Copy($prefix, 0, $bytes, 0, $prefix.Length)
        $bytes[$prefix.Length] = 0xC3; $bytes[$prefix.Length + 1] = 0x28
        [Array]::Copy($suffix, 0, $bytes, $prefix.Length + 2, $suffix.Length)
        New-TestLatexTarGzip -Path (Join-Path $deposit.document_dir "$slug.tar.gz") -Files ([ordered]@{
                'main.tex' = $bytes
            })

        { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir } | Should -Throw '*not valid UTF-8*'
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
        Test-Path (Join-Path $deposit.document_dir "$slug-tex") | Should -BeFalse
    }

    It 'accepts the arXiv single-TeX gzip shape without pretending it is a tar archive' {
        $slug = $deposit.slug
        $archive = Join-Path $deposit.document_dir "$slug.tar.gz"
        $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes(
            '\documentclass{article}\title{Single}\begin{document}Body.\end{document}'
        )
        New-TestLatexSingleGzip -Path $archive -Bytes $bytes

        $result = Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir
        Test-Path (Join-Path $result.source_path 'main.tex') | Should -BeTrue
        ($result.manifest.source_forms | Where-Object role -eq 'latex-source-archive').archive_kind |
            Should -Be 'single-tex+gzip'
    }

    It 'makes lock contention visible instead of running two deposit writers concurrently' {
        $held = Enter-SourceDepositLock -DocumentDir $deposit.document_dir
        try {
            { Initialize-LatexSourceDeposit -DocumentDir $deposit.document_dir -LockTimeoutSeconds 0 } |
                Should -Throw '*timed out waiting for the source-deposit lock*'
        } finally {
            Exit-SourceDepositLock $held
        }
        $reacquired = Enter-SourceDepositLock -DocumentDir $deposit.document_dir -TimeoutSeconds 0
        Exit-SourceDepositLock $reacquired
        Test-Path (Join-Path $deposit.document_dir 'metadata.json') | Should -BeFalse
    }
}
