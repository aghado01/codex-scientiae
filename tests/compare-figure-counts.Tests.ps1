#requires -Version 7.0
<#
  tests/compare-figure-counts.Tests.ps1 — the standing figure-count oracle benchmark
  (src/pdf-converter/Compare-FigureCounts.ps1) + the shared oracle counter model it reuses from
  src/latex-ingest.ps1 (Get-LatexOracleCounts).

  Self-contained: fabricates a mini paper group with runstamped pig + tex artifacts, so the harness
  exercises real newest-run-wins resolution, mechanism attribution, and the summary tally without any
  dependency on the git-ignored corpus.
#>

BeforeAll {
    $repo = Split-Path $PSScriptRoot -Parent
    . (Join-Path $repo 'src/pdf-converter/Compare-FigureCounts.ps1')   # transitively loads latex-ingest + runs

    # a fabricated paper dir under a group root, with a pig run (figures + envelope) and optionally a
    # tex run (oracle-counts sidecar). Returns nothing; builds the on-disk layout the harness reads.
    function New-FakePaper {
        param(
            [string]$GroupDir, [string]$Slug,
            [int]$FigureRegions, [int]$OtherRegions, [int]$ImagesTotal,
            [Nullable[int]]$OracleFigures, [int]$FiguresMissing = 0,
            [string]$Stamp = '20260704_120000'
        )
        $paper = Join-Path $GroupDir $Slug
        $pig = Join-Path $paper ".runs/$Stamp/pig"
        New-Item -ItemType Directory -Force -Path $pig | Out-Null

        $figLines = [System.Collections.Generic.List[string]]::new()
        for ($i = 0; $i -lt $FigureRegions; $i++) { $figLines.Add(('{{"id":{0},"kind":"figure"}}' -f $i)) }
        for ($i = 0; $i -lt $OtherRegions;  $i++) { $figLines.Add(('{{"id":{0},"kind":"sparse"}}' -f ($FigureRegions + $i))) }
        [System.IO.File]::WriteAllLines((Join-Path $pig "$Slug.figures.jsonl"), $figLines, [System.Text.UTF8Encoding]::new($false))

        # envelope with a pages array carrying the per-page images (GetImages()) count — split across 2 pages
        $env = [ordered]@{ pages = @(
            [ordered]@{ n = 1; images = [int][math]::Floor($ImagesTotal / 2) },
            [ordered]@{ n = 2; images = $ImagesTotal - [int][math]::Floor($ImagesTotal / 2) }
        ) }
        [System.IO.File]::WriteAllText((Join-Path $pig "$Slug.pdfdig.json"), ($env | ConvertTo-Json -Depth 5), [System.Text.UTF8Encoding]::new($false))

        if ($null -ne $OracleFigures) {
            $tex = Join-Path $paper ".runs/$Stamp/tex"
            New-Item -ItemType Directory -Force -Path $tex | Out-Null
            $sc = [ordered]@{ schema = 'oracle-counts/1'; slug = $Slug; oracle_figures = $OracleFigures; figures_missing = $FiguresMissing }
            [System.IO.File]::WriteAllText((Join-Path $tex "$Slug.oracle-counts.json"), ($sc | ConvertTo-Json), [System.Text.UTF8Encoding]::new($false))
        }
    }

    $script:work = Join-Path ([IO.Path]::GetTempPath()) ("cmp-fig-tests-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    $script:root = Join-Path $script:work 'ingestion'
    $script:grp  = Join-Path $script:root 'compendia/testgrp'
    New-Item -ItemType Directory -Force -Path $script:grp | Out-Null

    New-FakePaper -GroupDir $script:grp -Slug 'over01'  -FigureRegions 5 -OtherRegions 2 -ImagesTotal 0  -OracleFigures 2   # Δ=+3 fragmentation
    New-FakePaper -GroupDir $script:grp -Slug 'under01' -FigureRegions 2 -OtherRegions 0 -ImagesTotal 10 -OracleFigures 8   # Δ=-6 raster-blindness
    New-FakePaper -GroupDir $script:grp -Slug 'exact01' -FigureRegions 4 -OtherRegions 1 -ImagesTotal 1  -OracleFigures 4   # Δ=0 exact
    New-FakePaper -GroupDir $script:grp -Slug 'noisy01' -FigureRegions 3 -OtherRegions 0 -ImagesTotal 0  -OracleFigures 9 -FiguresMissing 4  # Δ=-6, no images → other/oracle-noise, low confidence

    $script:report = Compare-FigureCounts -Root $script:root -Group 'compendia/testgrp'
    $script:byslug = @{}; foreach ($r in $script:report.Rows) { $script:byslug[$r.slug] = $r }
}

AfterAll {
    if ($script:work -and (Test-Path $script:work)) { Remove-Item -Recurse -Force $script:work }
}

Describe 'Get-LatexOracleCounts (shared counter model)' {
    It 'counts drawn objects = includegraphics + tikz, floats kept for reference' {
        $body = @'
\begin{figure}\includegraphics{a}\caption{A}\end{figure}
\begin{figure}\begin{tikzpicture}\draw (0,0)--(1,1);\end{tikzpicture}\caption{B}\end{figure}
\begin{tikzcd} X \arrow{r} & Y \end{tikzcd}
\includegraphics[width=2cm]{c}
\begin{table}\begin{tabular}{c}q\end{tabular}\end{table}
'@
        $oc = Get-LatexOracleCounts $body
        $oc.images        | Should -Be 2        # \includegraphics a, c
        $oc.diagrams      | Should -Be 2        # tikzpicture + tikzcd
        $oc.figure_floats | Should -Be 2        # two \begin{figure}
        $oc.tables        | Should -Be 1
        $oc.oracle_figures| Should -Be 4        # images + diagrams (NOT floats)
    }

    It 'a figure float wrapping a tikz counts as one object, not two (float granularity is wrong)' {
        $body = "\begin{figure}\begin{tikzpicture}\draw (0,0)--(1,0);\end{tikzpicture}\end{figure}"
        (Get-LatexOracleCounts $body).oracle_figures | Should -Be 1   # 0 includegraphics + 1 tikz
    }
}

Describe 'Get-MissingIncludegraphics (oracle-confidence scan)' {
    It 'flags includegraphics whose target is absent from the staged tree' {
        $wd = Join-Path $script:work 'texwd'
        New-Item -ItemType Directory -Force -Path $wd | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $wd 'present.pdf'), '%PDF')
        $body = '\includegraphics{present}\includegraphics{gone}\includegraphics[scale=1]{sub/alsogone}'
        Get-MissingIncludegraphics $body $wd | Should -Be 2
    }
}

Describe 'pig lane readers' {
    It 'counts only kind==figure regions' {
        $f = Join-Path $script:work 'r.figures.jsonl'
        [System.IO.File]::WriteAllLines($f, @(
            '{"id":0,"kind":"figure"}','{"id":1,"kind":"sparse"}','{"id":2,"kind":"figure"}','{"id":3,"kind":"mark"}'
        ), [System.Text.UTF8Encoding]::new($false))
        Get-PigFigureCount $f | Should -Be 2
    }
    It 'sums per-page images from the envelope, reading the key back' {
        $e = Join-Path $script:work 'r.pdfdig.json'
        [System.IO.File]::WriteAllText($e, '{"pages":[{"n":1,"images":3},{"n":2,"images":0},{"n":3,"images":28}]}', [System.Text.UTF8Encoding]::new($false))
        Get-PigImageCount $e | Should -Be 31
    }
    It 'returns null when a lane is absent (no throw)' {
        Get-PigFigureCount (Join-Path $script:work 'nope.figures.jsonl') | Should -Be $null
        Get-PigImageCount  (Join-Path $script:work 'nope.pdfdig.json')   | Should -Be $null
    }
}

Describe 'Compare-FigureCounts — per-paper mechanism attribution' {
    It 'attributes an over-count to fragmentation' {
        $script:byslug['over01'].delta     | Should -Be 3
        $script:byslug['over01'].mechanism | Should -Be 'fragmentation'
    }
    It 'attributes an under-count WITH images to raster-blindness' {
        $script:byslug['under01'].delta      | Should -Be -6
        $script:byslug['under01'].pig_images | Should -Be 10
        $script:byslug['under01'].mechanism  | Should -Be 'raster-blindness'
    }
    It 'labels a zero delta as exact' {
        $script:byslug['exact01'].delta     | Should -Be 0
        $script:byslug['exact01'].mechanism | Should -Be 'exact'
    }
    It 'an under-count with NO images is oracle-noise, not raster-blindness' {
        $script:byslug['noisy01'].mechanism         | Should -Be 'other/oracle-noise'
        $script:byslug['noisy01'].oracle_confidence | Should -Be 'figures_missing:4'
    }
    It 'reads oracle from the sidecar when present' {
        $script:byslug['over01'].oracle_src     | Should -Be 'sidecar'
        $script:byslug['over01'].oracle_figures | Should -Be 2
    }
}

Describe 'Compare-FigureCounts — summary tally' {
    It 'counts over / under / exact bidirectionally' {
        $script:report.Summary.over  | Should -Be 1
        $script:report.Summary.under | Should -Be 2
        $script:report.Summary.exact | Should -Be 1
    }
    It 'reports mean |Δ| over scored papers' {
        # |+3| + |-6| + |0| + |-6| = 15 over 4 papers
        $script:report.Summary.mean_abs_delta | Should -Be 3.75
    }
    It 'reports a ratio range' {
        $script:report.Summary.ratio_min | Should -BeLessOrEqual $script:report.Summary.ratio_max
    }
}

Describe 'Compare-FigureCounts — oracle resolution ladder' {
    It 'falls back to the {slug}-latex.md deliverable when no tex run exists' {
        $g2 = Join-Path $script:root 'compendia/mdonly'
        $paper = Join-Path $g2 'mdpaper'
        $pig = Join-Path $paper '.runs/20260704_120000/pig'
        New-Item -ItemType Directory -Force -Path $pig | Out-Null
        [System.IO.File]::WriteAllLines((Join-Path $pig 'mdpaper.figures.jsonl'), @('{"id":0,"kind":"figure"}'), [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText((Join-Path $pig 'mdpaper.pdfdig.json'), '{"pages":[{"n":1,"images":0}]}', [System.Text.UTF8Encoding]::new($false))
        # md with 2 image embeds + 1 unrendered tikz marker => oracle 3
        $md = "text ![](mdpaper/a.png) more ![](mdpaper/diagram-1.svg)`n`n*[diagram 2 — TikZ source, not rendered]*`n"
        [System.IO.File]::WriteAllText((Join-Path $paper 'mdpaper-latex.md'), $md, [System.Text.UTF8Encoding]::new($false))

        $rep = Compare-FigureCounts -Root $script:root -Group 'compendia/mdonly'
        $row = $rep.Rows[0]
        $row.oracle_src     | Should -Be 'md'
        $row.oracle_figures | Should -Be 3
    }
}
