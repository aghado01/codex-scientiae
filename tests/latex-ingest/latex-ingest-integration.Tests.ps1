#requires -Version 7.0

# External-process and retained-write seam extracted from latex-ingest.Tests.ps1 by BEX-504. The physical
# container owns one suite layout below CODEX_TEST_ARTIFACT_ROOT when the adapter supplies it; direct runs
# use Pester's ephemeral TestDrive instead.
BeforeAll {
    . "$PSScriptRoot/../../src/latex-ingest/latex-ingest.ps1"

    function New-LatexIngestIntegrationRoot {
        param(
            [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Name,
            [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$EphemeralRoot
        )

        $base = if (-not [string]::IsNullOrWhiteSpace($env:CODEX_TEST_ARTIFACT_ROOT)) {
            if (-not [System.IO.Path]::IsPathFullyQualified($env:CODEX_TEST_ARTIFACT_ROOT)) {
                throw 'CODEX_TEST_ARTIFACT_ROOT must be an absolute path'
            }
            [System.IO.Path]::GetFullPath($env:CODEX_TEST_ARTIFACT_ROOT)
        }
        else {
            [System.IO.Path]::Combine(
                [System.IO.Path]::GetFullPath($EphemeralRoot), 'latex-ingest-integration')
        }
        $root = [System.IO.Path]::Combine($base, $Name)
        if ([System.IO.Directory]::Exists($root)) {
            throw "latex-ingest integration case root already exists: '$root'"
        }
        [void][System.IO.Directory]::CreateDirectory($root)
        return $root
    }

    function New-LatexIngestTestArchive {
        param(
            [Parameter(Mandatory)] [string]$Path,
            [Parameter(Mandatory)] [System.Collections.IDictionary]$Files
        )
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream, [System.IO.Compression.CompressionLevel]::Optimal, $true)
        $writer = [System.Formats.Tar.TarWriter]::new(
            $gzip, [System.Formats.Tar.TarEntryFormat]::Pax, $true)
        try {
            foreach ($pair in $Files.GetEnumerator()) {
                $bytes = if ($pair.Value -is [byte[]]) { $pair.Value } else {
                    [System.Text.UTF8Encoding]::new($false).GetBytes([string]$pair.Value)
                }
                $entry = [System.Formats.Tar.PaxTarEntry]::new(
                    [System.Formats.Tar.TarEntryType]::RegularFile, [string]$pair.Key)
                $data = [System.IO.MemoryStream]::new($bytes)
                try { $entry.DataStream = $data; $writer.WriteEntry($entry) }
                finally { $data.Dispose() }
            }
        }
        finally {
            $writer.Dispose(); $gzip.Dispose(); $fileStream.Dispose()
        }
    }

    function Get-RepositoryLatexIngestRunEntry {
        $runRoot = Join-Path $PSScriptRoot '../../artifacts/latex-ingest/runs'
        if (Test-Path -LiteralPath $runRoot -PathType Container) {
            Get-ChildItem -LiteralPath $runRoot -Recurse -Force |
                ForEach-Object FullName |
                Sort-Object
        }
    }

    $script:MathRenderAvailable = Test-MathRenderAvailable
    $script:TikzRenderAvailable = Test-TikzRenderAvailable
    $script:RepositoryRunEntriesBefore = @(Get-RepositoryLatexIngestRunEntry)
}

AfterAll {
    # No test in this container may fall through to latex-ingest's repository-global default allocator.
    @(Get-RepositoryLatexIngestRunEntry) | Should -Be $script:RepositoryRunEntriesBefore
}

Describe 'latex-ingest manifest execution and run addressing' {
    It 'consumes metadata-backed source without mutation and retains figures under its container root' {
        if (-not $script:MathRenderAvailable) {
            Set-ItResult -Skipped -Because 'the shared Node and KaTeX math-render capability is absent'
            return
        }
        $root = New-LatexIngestIntegrationRoot -Name 'figures-e2e' -EphemeralRoot $TestDrive
        $out = Join-Path $root 'out'
        $run = Join-Path $root 'runs/default'
        New-Item -ItemType Directory -Force -Path $out | Out-Null
        $archive = Join-Path $root 'p.tar.gz'
        New-LatexIngestTestArchive -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}\section{Setup}Fig: \includegraphics{figs/arch}\end{document}'
                'figs/arch.png' = [byte[]](137, 80, 78, 71)
            })
        $initialized = Initialize-LatexSourceDeposit -DocumentDir $root -Slug 'p'
        $sourceHash = (Get-LatexSourceTreeFingerprint -RootPath $initialized.source_path).sha256
        $shelf = Join-Path $root 'shelf'
        $r = Invoke-ArxivLatexToMarkdown -MetadataPath $initialized.metadata_path -OutDir $out `
            -DeliverableDir $shelf -RunDir $run
        $r.figures | Should -Be 1
        $r.audits.math_render.schema | Should -Be 'math-render-audit/1'
        $r.audits.math_render.clean | Should -BeTrue
        Test-Path -LiteralPath $r.audits.math_render.report_path | Should -BeTrue
        $r.deliverable.clean | Should -BeTrue
        Test-Path (Join-Path $shelf 'p/p.md') | Should -BeTrue
        Test-Path (Join-Path $shelf 'p/images/arch.png') | Should -BeTrue
        Test-Path (Join-Path $shelf 'p/p-tree.md') | Should -BeTrue
        Test-Path (Join-Path $shelf 'p/p.toc.jsonl') | Should -BeTrue
        $mdOut = Get-Content (Join-Path $out 'p-latex.md') -Raw
        $mdOut | Should -Match ([regex]::Escape('![figure: arch](p/arch.png)'))
        $mdOut | Should -Not -Match '(?m)^## Contents\s*$'
        $r.sections | Should -Be 1

        $out2 = Join-Path $root 'out2'
        $run2 = Join-Path $root 'runs/embedded-toc'
        New-Item -ItemType Directory -Force -Path $out2 | Out-Null
        $null = Invoke-ArxivLatexToMarkdown -MetadataPath $initialized.metadata_path -OutDir $out2 `
            -RunDir $run2 -EnableEmbeddedToc
        (Get-Content (Join-Path $out2 'p-latex.md') -Raw) |
            Should -Match '(?s)## Contents\n\n- \[Setup\]\(#setup\)\n\n## Setup'
        Test-Path (Join-Path $out 'p/arch.png') | Should -BeTrue
        $r.tex | Should -Be (Join-Path $root 'p-tex')
        Test-Path (Join-Path $r.tex 'main.tex') | Should -BeTrue
        (Get-LatexSourceTreeFingerprint -RootPath $r.tex).sha256 | Should -Be $sourceHash
        $r.source_mode | Should -Be 'manifest'
        Test-Path (Join-Path $root '.runs') | Should -BeFalse
    }

    It 'allocates distinct runs beneath an explicitly container-owned artifacts tier' {
        if (-not $script:MathRenderAvailable) {
            Set-ItResult -Skipped -Because 'the shared Node and KaTeX math-render capability is absent'
            return
        }
        $root = New-LatexIngestIntegrationRoot -Name 'allocated-runs' -EphemeralRoot $TestDrive
        $out = Join-Path $root 'out'
        $artifacts = Join-Path $root 'artifacts'
        New-Item -ItemType Directory -Force -Path $out | Out-Null
        $archive = Join-Path $root 'q.tar.gz'
        New-LatexIngestTestArchive -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}\section{S}Body.\end{document}'
            })
        $initialized = Initialize-LatexSourceDeposit -DocumentDir $root -Slug 'q'
        $manifestHash = (Get-FileHash $initialized.metadata_path -Algorithm SHA256).Hash
        $sourceHash = (Get-LatexSourceTreeFingerprint -RootPath $initialized.source_path).sha256

        $r1 = Invoke-ArxivLatexToMarkdown -MetadataPath $initialized.metadata_path -OutDir $out `
            -ArtifactsRoot $artifacts
        $staged = Join-Path $root 'q-tex'
        Test-Path (Join-Path $staged 'main.tex') | Should -BeTrue
        $runs = Join-Path $artifacts 'latex-ingest/runs'
        Test-Path $runs | Should -BeTrue
        @(Get-ChildItem $runs -Directory).Count | Should -Be 1
        @(Get-ChildItem $runs -Recurse -Filter 'q.oracle-counts.json').Count | Should -Be 1
        $mathAudits = @(Get-ChildItem $runs -Recurse -Filter 'math-render.json')
        $mathAudits.Count | Should -Be 1
        (Get-Content $mathAudits[0].FullName -Raw | ConvertFrom-Json).status | Should -Be 'pass'
        $r1.audits.math_render.report_path | Should -Be $mathAudits[0].FullName
        @(Get-ChildItem $staged -Filter '*.oracle-counts.json').Count | Should -Be 0

        $null = Invoke-ArxivLatexToMarkdown -MetadataPath $initialized.metadata_path -OutDir $out `
            -ArtifactsRoot $artifacts
        @(Get-ChildItem $runs -Directory).Count | Should -BeGreaterThan 1
        (Get-FileHash $initialized.metadata_path -Algorithm SHA256).Hash | Should -Be $manifestHash
        (Get-LatexSourceTreeFingerprint -RootPath $staged).sha256 | Should -Be $sourceHash
        @(Get-ChildItem $staged -File | Where-Object { $_.Extension -in '.json', '.jsonl' }).Count |
            Should -Be 0
        @(Get-ChildItem $runs -Recurse -Filter 'q.docstream.jsonl').Count | Should -BeGreaterThan 0
    }

    It 'keeps source, run evidence, lane output, and shelf at independent explicit destinations' {
        if (-not $script:MathRenderAvailable) {
            Set-ItResult -Skipped -Because 'the shared Node and KaTeX math-render capability is absent'
            return
        }
        $root = New-LatexIngestIntegrationRoot -Name 'explicit-layout' -EphemeralRoot $TestDrive
        $runDir = Join-Path $root 'elsewhere/runs/custom'
        $out = Join-Path $root 'elsewhere/lane'
        $shelf = Join-Path $root 'elsewhere/shelf'
        New-Item -ItemType Directory -Force -Path $out, $shelf | Out-Null
        $archive = Join-Path $root 'z.tar.gz'
        New-LatexIngestTestArchive -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}\section{S}Body.\end{document}'
            })
        $initialized = Initialize-LatexSourceDeposit -DocumentDir $root -Slug 'z'

        $r = Invoke-ArxivLatexToMarkdown -MetadataPath $initialized.metadata_path `
            -OutDir $out -DeliverableDir $shelf -RunDir $runDir
        $r.tex | Should -Be ([System.IO.Path]::GetFullPath($initialized.source_path))
        Test-Path (Join-Path $initialized.source_path 'main.tex') | Should -BeTrue
        Test-Path (Join-Path $runDir 'z.oracle-counts.json') | Should -BeTrue
        Test-Path (Join-Path $runDir 'audits/math-render.json') | Should -BeTrue
        Test-Path (Join-Path $out 'z-latex.md') | Should -BeTrue
        Test-Path (Join-Path $shelf 'z/z.md') | Should -BeTrue
        Test-Path (Join-Path $root 'artifacts') | Should -BeFalse
    }
}

Describe 'latex-ingest external diagram rendering' {
    It 'renders a tikzpicture and a tikzcd to real SVGs from the centralized payload' {
        if (-not $script:TikzRenderAvailable) {
            Set-ItResult -Skipped -Because 'Node and the shared node-tikzjax payload are absent'
            return
        }
        $out = New-LatexIngestIntegrationRoot -Name 'tikz-render' -EphemeralRoot $TestDrive
        $rep = Invoke-TikzRender -OutDir $out -Jobs @(
            @{ id = 'a'; source = '\begin{tikzpicture}\draw[->] (0,0) -- (1,1) node[right] {$x_i$};\end{tikzpicture}' }
            @{ id = 'b'; source = '\begin{tikzcd}A \arrow[r] & B\end{tikzcd}'; texPackages = @{ 'tikz-cd' = '' } })
        $rep.ok | Should -Be 2
        (Get-Content (Join-Path $out 'a.svg') -Raw) | Should -BeLike '<svg*'
    }

    It 'contains one diagram compile failure and retains the successful sibling' {
        if (-not $script:TikzRenderAvailable) {
            Set-ItResult -Skipped -Because 'Node and the shared node-tikzjax payload are absent'
            return
        }
        $out = New-LatexIngestIntegrationRoot -Name 'tikz-failure' -EphemeralRoot $TestDrive
        $rep = Invoke-TikzRender -OutDir $out -Jobs @(
            @{ id = 'bad'; source = '\begin{tikzpicture}\undefinedcmd\end{tikzpicture}' }
            @{ id = 'good'; source = '\begin{tikzpicture}\draw (0,0) -- (1,0);\end{tikzpicture}' })
        $rep.ok | Should -Be 1
        @($rep.results | Where-Object id -eq 'bad')[0].ok | Should -BeFalse
        Test-Path (Join-Path $out 'good.svg') | Should -BeTrue
    }
}

Describe 'latex-ingest math-render oracle smoke gate' {
    It 'converts representative diagrams, nested math, and counters with no KaTeX failures' {
        if (-not $script:MathRenderAvailable) {
            Set-ItResult -Skipped -Because 'the shared Node and KaTeX math-render capability is absent'
            return
        }
        $tex = @'
\documentclass{article}\title{Kitchen Sink}
\newcommand{\I}{\mathbb{I}}
\begin{document}
\section{Diagrams}
Linear: $\xymatrix{ 0 \ar[r] & K \ar[r]^{\text{id}} & 0 }$.
A commutative square:
\begin{tikzcd} A \arrow[r, "f"] & B \\ C \arrow[r, "g"] \arrow[u, "p"] & D \arrow[u, "q"] \end{tikzcd}
Nested: define $S = \{x : \text{property $P(x)$ holds}\}$.
Indicator $\mathds{1}_A$ and $\I(1,3)$.
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $root = New-LatexIngestIntegrationRoot -Name 'math-smoke' -EphemeralRoot $TestDrive
        $inputPath = Join-Path $root 'smoke.md'
        [System.IO.File]::WriteAllText(
            $inputPath, $out, [System.Text.UTF8Encoding]::new($false))
        $report = Invoke-MathRenderAudit -Path $inputPath
        $report.failed | Should -Be 0
    }
}
