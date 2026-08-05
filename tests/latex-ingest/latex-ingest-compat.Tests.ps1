#requires -Version 7.0

BeforeAll {
    . "$PSScriptRoot/../../src/latex-ingest/latex-ingest-compat.ps1"

    function New-CompatSingleGzip {
        param([Parameter(Mandatory)] [string]$Path, [Parameter(Mandatory)] [string]$Tex)
        $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes($Tex)
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream, [System.IO.Compression.CompressionLevel]::Optimal)
        try { $gzip.Write($bytes, 0, $bytes.Length) }
        finally { $gzip.Dispose(); $fileStream.Dispose() }
    }
}

Describe 'latex-ingest compatibility shim isolation and migration' {
    BeforeEach {
        $script:root = Join-Path ([System.IO.Path]::GetTempPath()) ("latex-compat-" + [guid]::NewGuid().ToString('N'))
        $script:out = Join-Path $script:root 'out'
        $script:run = Join-Path $script:root 'run'
        New-Item -ItemType Directory -Path $script:root, $script:out | Out-Null
    }

    AfterEach {
        Remove-Item -LiteralPath $script:root -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'keeps retired helper names and legacy directory inference out of the production file' {
        $core = Get-Content "$PSScriptRoot/../../src/latex-ingest/latex-ingest.ps1" -Raw
        $core | Should -Not -Match 'function\s+Expand-ArxivSourceTarball'
        $core | Should -Not -Match 'function\s+Find-LatexMain'
        $core | Should -Not -Match 'function\s+Resolve-LatexInputs'
        Get-Command Expand-ArxivSourceTarball | Should -Not -BeNullOrEmpty
        Get-Command Invoke-ArxivLatexToMarkdownLegacy | Should -Not -BeNullOrEmpty
    }

    It 'standardizes a compatible archive-backed legacy call before invoking production conversion' {
        $archive = Join-Path $script:root 'p.tar.gz'
        New-CompatSingleGzip -Path $archive -Tex '\documentclass{article}\begin{document}\section{S}Body.\end{document}'

        $result = Invoke-ArxivLatexToMarkdownLegacy -TarGz $archive -Slug 'p' `
            -OutDir $script:out -RunDir $script:run
        $result.source_mode | Should -Be 'manifest'
        Test-Path (Join-Path $script:root 'metadata.json') | Should -BeTrue
        Test-Path (Join-Path $script:root 'p-tex/main.tex') | Should -BeTrue
        Test-Path (Join-Path $script:root 'p-latex') | Should -BeFalse
        Test-Path (Join-Path $script:out 'p-latex.md') | Should -BeTrue
        @(Get-ChildItem (Join-Path $script:root 'p-tex') -File | Where-Object { $_.Extension -in '.json', '.jsonl' }).Count |
            Should -Be 0
    }

    It 'can explicitly reuse a legacy source tree without teaching the production entrypoint that layout' {
        $legacy = Join-Path $script:root 'q-latex'
        New-Item -ItemType Directory -Path $legacy | Out-Null
        [System.IO.File]::WriteAllText(
            (Join-Path $legacy 'main.tex'),
            '\documentclass{article}\begin{document}\section{Legacy}Body.\end{document}',
            [System.Text.UTF8Encoding]::new($false)
        )

        $result = Invoke-ArxivLatexToMarkdownLegacy -TarGz (Join-Path $script:root 'q.tar.gz') `
            -Slug 'q' -OutDir $script:out -RunDir $script:run -ReuseSource -WarningAction SilentlyContinue
        $result.source_mode | Should -Be 'compat-legacy-reused'
        $result.tex | Should -Be $legacy
        Test-Path (Join-Path $script:root 'metadata.json') | Should -BeFalse
        Test-Path (Join-Path $script:root 'q-tex') | Should -BeFalse
    }

    It 'uses the .NET extractor for an explicit legacy source-work override' {
        $archive = Join-Path $script:root 'r.tar.gz'
        $customSource = Join-Path $script:root 'custom/source'
        New-CompatSingleGzip -Path $archive -Tex '\documentclass{article}\begin{document}\section{Custom}Body.\end{document}'

        $result = Invoke-ArxivLatexToMarkdownLegacy -TarGz $archive -Slug 'r' -SourceWorkDir $customSource `
            -OutDir $script:out -RunDir $script:run -WarningAction SilentlyContinue
        $result.source_mode | Should -Be 'compat-explicit-extracted'
        Test-Path (Join-Path $customSource 'main.tex') | Should -BeTrue
        Test-Path (Join-Path $script:root 'metadata.json') | Should -BeFalse
    }
}
