#requires -Version 7.0

BeforeDiscovery {
    $repository = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $candidate = Join-Path $repository '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($candidate)) {
        $candidate = Join-Path $repository '.venv/bin/python'
    }
    $script:LatexDepositPythonAvailable = [System.IO.File]::Exists($candidate)
}

BeforeAll {
    $script:RepositoryRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $script:Python = Join-Path $script:RepositoryRoot '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($script:Python)) {
        $script:Python = Join-Path $script:RepositoryRoot '.venv/bin/python'
    }
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false, $true)

    . (Join-Path $script:RepositoryRoot 'src/logistics/latex-source-deposit.ps1')

    function New-LatexDepositTestDirectory {
        param(
            [Parameter(Mandatory)] [string] $Root,
            [Parameter(Mandatory)] [string] $Slug
        )

        $documentDirectory = Join-Path $Root $Slug
        [void][System.IO.Directory]::CreateDirectory($documentDirectory)
        return [pscustomobject]@{
            Slug              = $Slug
            DocumentDirectory = $documentDirectory
            ArchivePath       = Join-Path $documentDirectory "$Slug.tar.gz"
            ArticlePath       = Join-Path $documentDirectory 'article.json'
        }
    }

    function New-LatexDepositTarGzip {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [Parameter(Mandatory)] [System.Collections.IDictionary] $Files
        )

        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream,
            [System.IO.Compression.CompressionLevel]::Optimal,
            $true)
        $writer = [System.Formats.Tar.TarWriter]::new(
            $gzip,
            [System.Formats.Tar.TarEntryFormat]::Pax,
            $true)
        try {
            foreach ($pair in $Files.GetEnumerator()) {
                $bytes = if ($pair.Value -is [byte[]]) {
                    $pair.Value
                }
                else {
                    $script:Utf8.GetBytes([string]$pair.Value)
                }
                $entry = [System.Formats.Tar.PaxTarEntry]::new(
                    [System.Formats.Tar.TarEntryType]::RegularFile,
                    [string]$pair.Key)
                $data = [System.IO.MemoryStream]::new($bytes)
                try {
                    $entry.DataStream = $data
                    $writer.WriteEntry($entry)
                }
                finally {
                    $data.Dispose()
                }
            }
        }
        finally {
            $writer.Dispose()
            $gzip.Dispose()
            $fileStream.Dispose()
        }
    }

    function New-LatexDepositSingleGzip {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [Parameter(Mandatory)] [string] $Text
        )

        $bytes = $script:Utf8.GetBytes($Text)
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream,
            [System.IO.Compression.CompressionLevel]::Optimal)
        try {
            $gzip.Write($bytes, 0, $bytes.Length)
        }
        finally {
            $gzip.Dispose()
            $fileStream.Dispose()
        }
    }

    function Read-LatexDepositJson {
        param([Parameter(Mandatory)] [string] $Path)

        return [System.IO.File]::ReadAllText($Path, $script:Utf8) |
            ConvertFrom-Json -Depth 100 -ErrorAction Stop
    }

    function Assert-NoLatexDepositTransactionResidue {
        param([Parameter(Mandatory)] [string] $DocumentDirectory)

        [System.IO.File]::Exists((Join-Path $DocumentDirectory '.source-deposit.lock')) |
            Should -BeFalse
        @(Get-ChildItem -LiteralPath $DocumentDirectory -Force |
                Where-Object Name -Match '^\..+-tex\.validate-|^article\.json\..+\.tmp$').Count |
            Should -Be 0
    }
}

Describe 'LaTeX source deposit through the JSONL engine' {
    BeforeEach {
        $script:PriorJsonScratch =
            [System.Environment]::GetEnvironmentVariable('CODEX_JSON_SCRATCH_ROOT')
        $script:JsonScratch = Join-Path $TestDrive 'json-engine-scratch'
        [void][System.IO.Directory]::CreateDirectory($script:JsonScratch)
        $env:CODEX_JSON_SCRATCH_ROOT = $script:JsonScratch
    }

    AfterEach {
        if ($null -eq $script:PriorJsonScratch) {
            Remove-Item Env:CODEX_JSON_SCRATCH_ROOT -ErrorAction SilentlyContinue
        }
        else {
            $env:CODEX_JSON_SCRATCH_ROOT = $script:PriorJsonScratch
        }
    }

    It 'publishes one flat article and returns the exact engine article with provider and PDF evidence' `
            -Skip:(-not $script:LatexDepositPythonAvailable) {
        $deposit = New-LatexDepositTestDirectory -Root $TestDrive -Slug '2501.00001v1'
        New-LatexDepositTarGzip -Path $deposit.ArchivePath -Files ([ordered]@{
                'paper.tex' = '\documentclass{article}\title{Embedded title}\author{Ada}\begin{document}Body.\end{document}'
                '00README.json' = '{"stamp":[{"filename":"paper.tex"}]}'
            })

        $providerPath = Join-Path $deposit.DocumentDirectory "$($deposit.Slug).arxiv.json"
        $provider = [ordered]@{
            id = '2501.00001'
            idv = $deposit.Slug
            title = 'Provider title 日本語'
            authors = @('Ada Lovelace')
            abstract = 'Provider abstract'
            categories = @('cs.AI')
            primary_category = 'cs.AI'
            published = '2026-01-01T00:00:00Z'
            updated = '2026-01-02T00:00:00Z'
            doi = '10.1/example'
            fetched_at = '2026-08-08T00:00:00Z'
            fetched_by = 'deposit-test/1'
        }
        [System.IO.File]::WriteAllText(
            $providerPath,
            (ConvertTo-Json -InputObject $provider -Depth 10),
            $script:Utf8)
        $pdfPath = Join-Path $deposit.DocumentDirectory "$($deposit.Slug).pdf"
        [System.IO.File]::WriteAllBytes(
            $pdfPath,
            [System.Text.Encoding]::ASCII.GetBytes("%PDF-1.4`n% test`n"))

        $results = @(New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                -PythonPath $script:Python)

        $results.Count | Should -Be 1
        $result = $results[0]
        $result.Status | Should -Be 'deposited'
        $result.Skipped | Should -BeFalse
        $result.ManifestPath | Should -Be $deposit.ArticlePath
        @($result.EngineOutput.Keys) | Should -Be @(
            'status', 'created', 'article_path', 'archive_path', 'source_path', 'article')
        $result.EngineOutput.created | Should -BeTrue
        $result.EngineOutput.article_path | Should -Be $deposit.ArticlePath

        $article = Read-LatexDepositJson -Path $deposit.ArticlePath
        $article.PSObject.Properties.Name | Should -Be @(
            'schema', 'state', 'slug', 'initialized_utc', 'title', 'authors', 'abstract',
            'identifiers', 'categories', 'primary_category', 'published', 'updated',
            'evidence', 'source_forms', 'validation')
        $article.schema | Should -Be 'codex-scientiae/article/0.1'
        $article.state | Should -Be 'source-ready'
        $article.PSObject.Properties.Name | Should -Not -Contain 'document'
        $article.title | Should -Be 'Provider title 日本語'
        @($article.authors) | Should -Be @('Ada Lovelace')
        @($article.categories) | Should -Be @('cs.AI')
        $article.identifiers.arxiv_versioned | Should -Be $deposit.Slug
        ($result.EngineOutput.article | ConvertTo-Json -Depth 100 -Compress) |
            Should -Be ($article | ConvertTo-Json -Depth 100 -Compress)

        $providerEvidence = @($article.evidence.provider_metadata)
        $providerEvidence.Count | Should -Be 1
        $providerEvidence[0].path | Should -Be "$($deposit.Slug).arxiv.json"
        $providerEvidence[0].bytes | Should -Be ([System.IO.FileInfo]::new($providerPath).Length)
        $providerEvidence[0].sha256 | Should -Be `
            ((Get-FileHash -LiteralPath $providerPath -Algorithm SHA256).Hash.ToLowerInvariant())
        @($article.evidence.package_control_files).Count | Should -Be 1

        $sourceForms = @($article.source_forms)
        $sourceForms.Count | Should -Be 3
        $archiveForm = @($sourceForms | Where-Object role -EQ 'latex-source-archive')
        $pdfForm = @($sourceForms | Where-Object role -EQ 'pdf-source')
        $archiveForm.Count | Should -Be 1
        $pdfForm.Count | Should -Be 1
        $archiveForm[0].sha256 | Should -Be `
            ((Get-FileHash -LiteralPath $deposit.ArchivePath -Algorithm SHA256).Hash.ToLowerInvariant())
        $pdfForm[0].sha256 | Should -Be `
            ((Get-FileHash -LiteralPath $pdfPath -Algorithm SHA256).Hash.ToLowerInvariant())

        $bytes = [System.IO.File]::ReadAllBytes($deposit.ArticlePath)
        $bytes[-1] | Should -Be 10
        $bytes | Should -Not -Contain 13
        ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and
            $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) | Should -BeFalse
        @(Get-ChildItem -LiteralPath $script:JsonScratch `
                -Filter 'codex-jsonl-engine-input-*.json' -File).Count | Should -Be 0
        Assert-NoLatexDepositTransactionResidue -DocumentDirectory $deposit.DocumentDirectory
    }

    It 'validates an idempotent second call through Python without changing article bytes or time' `
            -Skip:(-not $script:LatexDepositPythonAvailable) {
        $deposit = New-LatexDepositTestDirectory -Root $TestDrive -Slug '2501.00002v1'
        New-LatexDepositTarGzip -Path $deposit.ArchivePath -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Body.\end{document}'
            })

        $first = New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
            -PythonPath $script:Python
        $before = [System.IO.File]::ReadAllBytes($deposit.ArticlePath)
        [System.IO.File]::SetLastWriteTimeUtc(
            $deposit.ArticlePath,
            [datetime]::new(2020, 1, 2, 3, 4, 5, [DateTimeKind]::Utc))
        $markedWriteTime = [System.IO.File]::GetLastWriteTimeUtc($deposit.ArticlePath)

        $secondResults = @(New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                -PythonPath $script:Python)

        $secondResults.Count | Should -Be 1
        $second = $secondResults[0]
        $first.Status | Should -Be 'deposited'
        $second.Status | Should -Be 'already-deposited'
        $second.Skipped | Should -BeTrue
        $second.EngineOutput.created | Should -BeFalse
        $second.Publication | Should -Be 'published-new-tree'
        [System.IO.File]::ReadAllBytes($deposit.ArticlePath) | Should -Be $before
        [System.IO.File]::GetLastWriteTimeUtc($deposit.ArticlePath) | Should -Be $markedWriteTime
        ($second.EngineOutput.article | ConvertTo-Json -Depth 100 -Compress) |
            Should -Be ($first.EngineOutput.article | ConvertTo-Json -Depth 100 -Compress)
        @(Get-ChildItem -LiteralPath $script:JsonScratch `
                -Filter 'codex-jsonl-engine-input-*.json' -File).Count | Should -Be 0
        Assert-NoLatexDepositTransactionResidue -DocumentDirectory $deposit.DocumentDirectory
    }

    It 'records member confinement as not applicable for a single-TeX gzip payload' `
            -Skip:(-not $script:LatexDepositPythonAvailable) {
        $deposit = New-LatexDepositTestDirectory -Root $TestDrive -Slug '2501.00003v1'
        New-LatexDepositSingleGzip -Path $deposit.ArchivePath -Text `
            '\documentclass{article}\begin{document}Single payload.\end{document}'

        $result = New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
            -PythonPath $script:Python
        $check = @($result.EngineOutput.article.validation.checks |
                Where-Object name -EQ 'archive-members-confined')

        $check.Count | Should -Be 1
        $check[0].outcome | Should -Be 'not-applicable'
        $check[0].reason | Should -Be 'single-payload gzip archive has no members to confine'
        $check[0].archive_kind | Should -Be 'single-tex+gzip'
        @($result.EngineOutput.article.evidence.provider_metadata).Count | Should -Be 0
        @($result.EngineOutput.article.authors).Count | Should -Be 0
        @(Get-ChildItem -LiteralPath $script:JsonScratch `
                -Filter 'codex-jsonl-engine-input-*.json' -File).Count | Should -Be 0
        Assert-NoLatexDepositTransactionResidue -DocumentDirectory $deposit.DocumentDirectory
    }

    It 'records explicit entrypoint selection as not applicable and retains a caller-owned findings file' `
            -Skip:(-not $script:LatexDepositPythonAvailable) {
        $deposit = New-LatexDepositTestDirectory -Root $TestDrive -Slug '2501.00004v1'
        New-LatexDepositTarGzip -Path $deposit.ArchivePath -Files ([ordered]@{
                'a.tex' = '\documentclass{article}\begin{document}A.\end{document}'
                'b.tex' = '\documentclass{article}\begin{document}B.\end{document}'
            })
        { New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                -MainTex 'b.tex' -FindingsPath $deposit.ArticlePath `
                -PythonPath $script:Python } |
            Should -Throw '*FindingsPath must be outside the document deposit*'
        [System.IO.File]::Exists($deposit.ArticlePath) | Should -BeFalse

        $junction = Join-Path $TestDrive 'document-alias'
        $junctionCreated = $false
        try {
            [void](New-Item -ItemType Junction -Path $junction `
                    -Target $deposit.DocumentDirectory -ErrorAction Stop)
            $junctionCreated = $true
        }
        catch { $junctionCreated = $false }
        if ($junctionCreated) {
            try {
                { New-LatexSourceDeposit -DocumentDir $junction -Slug $deposit.Slug `
                        -MainTex 'b.tex' -PythonPath $script:Python } |
                    Should -Throw '*document deposit must not traverse a symbolic link or reparse point*'
                { New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                        -MainTex 'b.tex' -FindingsPath (Join-Path $junction 'article.json') `
                        -PythonPath $script:Python } |
                    Should -Throw '*symbolic link or reparse point*'
                [System.IO.File]::Exists($deposit.ArticlePath) | Should -BeFalse
            }
            finally { Remove-Item -LiteralPath $junction -Force }
        }

        $sourceTree = Join-Path $deposit.DocumentDirectory "$($deposit.Slug)-tex"
        $rootReparseTarget = Join-Path $TestDrive 'source-root-reparse-target'
        [void][System.IO.Directory]::CreateDirectory($rootReparseTarget)
        [System.IO.File]::WriteAllText(
            (Join-Path $rootReparseTarget 'a.tex'),
            '\documentclass{article}\begin{document}A.\end{document}',
            $script:Utf8)
        [System.IO.File]::WriteAllText(
            (Join-Path $rootReparseTarget 'b.tex'),
            '\documentclass{article}\begin{document}B.\end{document}',
            $script:Utf8)
        $directoryLinkType = if ([System.OperatingSystem]::IsWindows()) { 'Junction' } else { 'SymbolicLink' }
        [void](New-Item -ItemType $directoryLinkType -Path $sourceTree `
                -Target $rootReparseTarget -ErrorAction Stop)
        try {
            { New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                    -MainTex 'b.tex' -PythonPath $script:Python } |
                Should -Throw '*source tree contains a reparse point*'
            [System.IO.File]::Exists($deposit.ArticlePath) | Should -BeFalse
        }
        finally {
            Remove-Item -LiteralPath $sourceTree -Force
            Remove-Item -LiteralPath $rootReparseTarget -Recurse -Force
        }

        $savedScratch = $env:CODEX_JSON_SCRATCH_ROOT
        try {
            $env:CODEX_JSON_SCRATCH_ROOT = $sourceTree
            { New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                    -MainTex 'b.tex' -PythonPath $script:Python } |
                Should -Throw '*FindingsPath must be outside the document deposit*'
        }
        finally { $env:CODEX_JSON_SCRATCH_ROOT = $savedScratch }
        [System.IO.File]::Exists($deposit.ArticlePath) | Should -BeFalse
        @(Get-ChildItem -LiteralPath $sourceTree -Filter 'codex-jsonl-engine-input-*.json' `
                -File -ErrorAction SilentlyContinue).Count | Should -Be 0

        $findingsPath = Join-Path $TestDrive 'owned findings 日本語.json'

        $result = New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
            -MainTex 'b.tex' -FindingsPath $findingsPath -PythonPath $script:Python
        $check = @($result.EngineOutput.article.validation.checks |
                Where-Object name -EQ 'entrypoint-unambiguous')

        $result.EngineOutput.article.evidence.latex_source.entrypoint | Should -Be 'b.tex'
        $result.EngineOutput.article.evidence.latex_source.selection | Should -Be 'explicit'
        $check.Count | Should -Be 1
        $check[0].outcome | Should -Be 'not-applicable'
        $check[0].reason | Should -Be `
            'entrypoint named explicitly; the ambiguity scan did not run'
        [System.IO.File]::Exists($findingsPath) | Should -BeTrue
        $findings = Read-LatexDepositJson -Path $findingsPath
        @($findings.checks).Count | Should -Be 7
        @($findings.package_control_files).Count | Should -Be 0
        [System.IO.File]::ReadAllBytes($findingsPath)[-1] | Should -Be 10

        $articleBeforeReparse = [System.IO.File]::ReadAllBytes($deposit.ArticlePath)
        $descendantTarget = Join-Path $TestDrive 'source-descendant-reparse-target'
        [void][System.IO.Directory]::CreateDirectory($descendantTarget)
        [System.IO.File]::WriteAllText(
            (Join-Path $descendantTarget 'asset.txt'),
            'external asset',
            $script:Utf8)
        $descendantLink = Join-Path $sourceTree 'linked-assets'
        [void](New-Item -ItemType $directoryLinkType -Path $descendantLink `
                -Target $descendantTarget -ErrorAction Stop)
        try {
            { New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                    -MainTex 'b.tex' -PythonPath $script:Python } |
                Should -Throw '*source tree contains a reparse point*'
            [System.IO.File]::ReadAllBytes($deposit.ArticlePath) |
                Should -Be $articleBeforeReparse
        }
        finally { Remove-Item -LiteralPath $descendantLink -Force }

        $pdfGuardDeposit = New-LatexDepositTestDirectory -Root $TestDrive -Slug '2501.00004v2'
        New-LatexDepositTarGzip -Path $pdfGuardDeposit.ArchivePath -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}PDF guard.\end{document}'
            })
        $pdfGuardPath = Join-Path $pdfGuardDeposit.DocumentDirectory "$($pdfGuardDeposit.Slug).pdf"
        [System.IO.File]::WriteAllBytes(
            $pdfGuardPath,
            [System.Text.Encoding]::ASCII.GetBytes("%PDF-1.4`n"))
        $script:GuardedLatexDepositPdf = $pdfGuardPath
        Mock Test-PathHasReparsePoint {
            param([string]$Path)
            return Test-LatexPathsEqual -Left $Path -Right $script:GuardedLatexDepositPdf
        }
        { New-LatexSourceDeposit -DocumentDir $pdfGuardDeposit.DocumentDirectory `
                -PythonPath $script:Python } |
            Should -Throw '*PDF source must not traverse a symbolic link or reparse point*'
        [System.IO.File]::Exists($pdfGuardDeposit.ArticlePath) | Should -BeFalse
        [System.IO.Directory]::Exists((Join-Path $pdfGuardDeposit.DocumentDirectory `
                    "$($pdfGuardDeposit.Slug)-tex")) | Should -BeFalse
        Assert-NoLatexDepositTransactionResidue `
            -DocumentDirectory $pdfGuardDeposit.DocumentDirectory
        Assert-NoLatexDepositTransactionResidue -DocumentDirectory $deposit.DocumentDirectory
    }

    It 'refuses provider drift in Python without overwriting the existing article' `
            -Skip:(-not $script:LatexDepositPythonAvailable) {
        $deposit = New-LatexDepositTestDirectory -Root $TestDrive -Slug '2501.00005v1'
        New-LatexDepositTarGzip -Path $deposit.ArchivePath -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}Body.\end{document}'
            })
        $providerPath = Join-Path $deposit.DocumentDirectory "$($deposit.Slug).arxiv.json"
        $provider = [ordered]@{
            id = '2501.00005'
            idv = $deposit.Slug
            title = 'Original title'
            authors = @('Author')
            categories = @('cs.AI')
        }
        [System.IO.File]::WriteAllText(
            $providerPath,
            (ConvertTo-Json -InputObject $provider -Depth 10),
            $script:Utf8)
        New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
            -PythonPath $script:Python | Out-Null
        $before = [System.IO.File]::ReadAllBytes($deposit.ArticlePath)
        [System.IO.File]::SetLastWriteTimeUtc(
            $deposit.ArticlePath,
            [datetime]::new(2020, 2, 3, 4, 5, 6, [DateTimeKind]::Utc))
        $markedWriteTime = [System.IO.File]::GetLastWriteTimeUtc($deposit.ArticlePath)

        $provider.title = 'Changed title'
        [System.IO.File]::WriteAllText(
            $providerPath,
            (ConvertTo-Json -InputObject $provider -Depth 10),
            $script:Utf8)

        { New-LatexSourceDeposit -DocumentDir $deposit.DocumentDirectory `
                -PythonPath $script:Python } |
            Should -Throw '*DepositConflict*conflicts with the requested deposit at $/title*'

        [System.IO.File]::ReadAllBytes($deposit.ArticlePath) | Should -Be $before
        [System.IO.File]::GetLastWriteTimeUtc($deposit.ArticlePath) | Should -Be $markedWriteTime
        (Read-LatexDepositJson -Path $deposit.ArticlePath).title | Should -Be 'Original title'
        @(Get-ChildItem -LiteralPath $script:JsonScratch `
                -Filter 'codex-jsonl-engine-input-*.json' -File).Count | Should -Be 0
        Assert-NoLatexDepositTransactionResidue -DocumentDirectory $deposit.DocumentDirectory
    }
}
