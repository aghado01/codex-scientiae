#requires -Version 7.0
<#
  tests/compare-figure-counts.Tests.ps1 — the standing figure-count oracle benchmark
  (src/pdf-converter/Compare-FigureCounts.ps1) + the shared TWO-POPULATION counter model it reuses from
  src/latex-ingest.ps1 (Get-LatexOracleCounts).

  The benchmark scores two distinct populations a geometry converter sees as "figure regions":
    PRIMARY   captioned pig regions vs \begin{figure} floats  ("did we find the real figures")
    SECONDARY uncaptioned pig regions vs inline tikz/xy diagrams  (the geometric-fragmentation population)

  Self-contained: fabricates a mini paper group with runstamped pig + tex artifacts (captioned and
  uncaptioned figure records, a schema/2 oracle sidecar), so the harness exercises real newest-run-wins
  resolution, mechanism attribution, and the two-population tally without the git-ignored corpus.
#>

BeforeAll {
    $repo = Split-Path $PSScriptRoot -Parent
    . (Join-Path $repo 'src/pdf-converter/Compare-FigureCounts.ps1')   # transitively loads latex-ingest + runs

    # a fabricated paper dir with a pig run (captioned + uncaptioned figure records + envelope) and
    # optionally a schema/2 oracle-counts sidecar in a tex run.
    function New-FakePaper {
        param(
            [string]$GroupDir, [string]$Slug,
            [int]$CaptionedFigs, [int]$UncaptionedFigs, [int]$ImagesTotal,
            [Nullable[int]]$OracleFigures, [Nullable[int]]$OracleInline, [int]$FiguresMissing = 0,
            [string]$Stamp = '20260704_120000'
        )
        $paper = Join-Path $GroupDir $Slug
        $pig = Join-Path $paper ".runs/$Stamp/pig"
        New-Item -ItemType Directory -Force -Path $pig | Out-Null

        $figLines = [System.Collections.Generic.List[string]]::new()
        $id = 0
        for ($i = 0; $i -lt $CaptionedFigs; $i++)   { $figLines.Add(('{{"id":{0},"kind":"figure","caption":{{"text":"Fig {0}"}}}}' -f $id++)) }
        for ($i = 0; $i -lt $UncaptionedFigs; $i++) { $figLines.Add(('{{"id":{0},"kind":"figure","caption":null}}' -f $id++)) }
        $figLines.Add(('{{"id":{0},"kind":"sparse","caption":null}}' -f $id++))   # a non-figure region (ignored)
        [System.IO.File]::WriteAllLines((Join-Path $pig "$Slug.figures.jsonl"), $figLines, [System.Text.UTF8Encoding]::new($false))

        $env = [ordered]@{ pages = @(
            [ordered]@{ n = 1; images = [int][math]::Floor($ImagesTotal / 2) },
            [ordered]@{ n = 2; images = $ImagesTotal - [int][math]::Floor($ImagesTotal / 2) }
        ) }
        [System.IO.File]::WriteAllText((Join-Path $pig "$Slug.pdfdig.json"), ($env | ConvertTo-Json -Depth 5), [System.Text.UTF8Encoding]::new($false))

        if ($null -ne $OracleFigures) {
            $tex = Join-Path $paper ".runs/$Stamp/tex"
            New-Item -ItemType Directory -Force -Path $tex | Out-Null
            $sc = [ordered]@{ schema = 'oracle-counts/2'; slug = $Slug
                              figures = $OracleFigures; inline_diagrams = $OracleInline; figures_missing = $FiguresMissing }
            [System.IO.File]::WriteAllText((Join-Path $tex "$Slug.oracle-counts.json"), ($sc | ConvertTo-Json), [System.Text.UTF8Encoding]::new($false))
        }
    }

    $script:work = Join-Path ([IO.Path]::GetTempPath()) ("cmp-fig-tests-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    $script:root = Join-Path $script:work 'ingestion'
    $script:grp  = Join-Path $script:root 'compendia/testgrp'
    New-Item -ItemType Directory -Force -Path $script:grp | Out-Null

    #                                            cap unc img  oFig oInl miss
    New-FakePaper -GroupDir $script:grp -Slug 'over01'    -CaptionedFigs 5  -UncaptionedFigs 2  -ImagesTotal 0  -OracleFigures 2  -OracleInline 0   # dFig=+3 over-detect
    New-FakePaper -GroupDir $script:grp -Slug 'raster01'  -CaptionedFigs 2  -UncaptionedFigs 0  -ImagesTotal 10 -OracleFigures 8  -OracleInline 0   # dFig=-6 raster-blindness
    New-FakePaper -GroupDir $script:grp -Slug 'missed01'  -CaptionedFigs 3  -UncaptionedFigs 0  -ImagesTotal 0  -OracleFigures 9  -OracleInline 0 -FiguresMissing 4  # dFig=-6 missed-figure, low conf
    New-FakePaper -GroupDir $script:grp -Slug 'diagram01' -CaptionedFigs 16 -UncaptionedFigs 50 -ImagesTotal 1  -OracleFigures 16 -OracleInline 23  # dFig=0 exact (the 2210 shape); dInl=+27

    $script:report = Compare-FigureCounts -Root $script:root -Group 'compendia/testgrp'
    $script:byslug = @{}; foreach ($r in $script:report.Rows) { $script:byslug[$r.slug] = $r }
}

AfterAll {
    if ($script:work -and (Test-Path $script:work)) { Remove-Item -Recurse -Force $script:work }
}

Describe 'Get-LatexOracleCounts (two-population counter model)' {
    It 'separates captioned floats from inline diagrams; counts xy-pic; excludes in-float diagrams' {
        $body = @'
\begin{figure}\includegraphics{a}\caption{A}\end{figure}
\begin{figure}\begin{tikzpicture}\draw (0,0)--(1,1);\end{tikzpicture}\caption{B}\end{figure}
Text with an inline commutative diagram \begin{tikzcd} X \arrow{r} & Y \end{tikzcd} in the proof.
An xy-pic diagram \xymatrix{ A \ar[r] & B } inline as well.
\includegraphics[width=1cm]{c}
'@
        $oc = Get-LatexOracleCounts $body
        $oc.figures         | Should -Be 2    # two \begin{figure} floats — the captioned oracle
        $oc.inline_diagrams | Should -Be 2    # inline tikzcd + inline xymatrix (the in-float tikzpicture is NOT inline)
        $oc.diagrams_total  | Should -Be 3    # tikzpicture + tikzcd + xymatrix
        $oc.images          | Should -Be 2    # \includegraphics a, c
        $oc.oracle_figures  | Should -Be 2    # == figures (captioned floats)
    }

    It 'counts xy-pic diagrams that the old tikz-only regex missed' {
        $body = "prose \xymatrix{ A \ar[r] & B } more \xymatrix{ C \ar[d] & D } end"
        (Get-LatexOracleCounts $body).inline_diagrams | Should -Be 2
    }

    It 'a diagram inside a figure float counts as a figure, not an inline diagram' {
        $body = "\begin{figure}\begin{tikzcd} X & Y \end{tikzcd}\caption{c}\end{figure}"
        $oc = Get-LatexOracleCounts $body
        $oc.figures         | Should -Be 1
        $oc.inline_diagrams | Should -Be 0
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
    It 'splits figure regions by caption presence' {
        $f = Join-Path $script:work 'r.figures.jsonl'
        [System.IO.File]::WriteAllLines($f, @(
            '{"id":0,"kind":"figure","caption":{"text":"Fig 1"}}',
            '{"id":1,"kind":"figure","caption":null}',
            '{"id":2,"kind":"figure","caption":{"text":"Fig 2"}}',
            '{"id":3,"kind":"sparse","caption":null}',
            '{"id":4,"kind":"figure","caption":null}'
        ), [System.Text.UTF8Encoding]::new($false))
        $c = Get-PigFigureCounts $f
        $c.all       | Should -Be 4    # four kind==figure (the sparse is excluded)
        $c.captioned | Should -Be 2
    }
    It 'sums per-page images from the envelope, reading the key back' {
        $e = Join-Path $script:work 'r.pdfdig.json'
        [System.IO.File]::WriteAllText($e, '{"pages":[{"n":1,"images":3},{"n":2,"images":0},{"n":3,"images":28}]}', [System.Text.UTF8Encoding]::new($false))
        Get-PigImageCount $e | Should -Be 31
    }
    It 'returns null when a lane is absent (no throw)' {
        Get-PigFigureCounts (Join-Path $script:work 'nope.figures.jsonl') | Should -Be $null
        Get-PigImageCount   (Join-Path $script:work 'nope.pdfdig.json')   | Should -Be $null
    }
}

Describe 'Compare-FigureCounts — captioned-figure mechanism (PRIMARY)' {
    It 'over-detect when pig finds more captioned regions than figure floats (subfigure/fragmentation)' {
        $script:byslug['over01'].pig_captioned | Should -Be 5
        $script:byslug['over01'].oracle_figures | Should -Be 2
        $script:byslug['over01'].delta     | Should -Be 3
        $script:byslug['over01'].mechanism | Should -Be 'over-detect'
    }
    It 'raster-blindness when captioned regions fall short AND bitmaps are present' {
        $script:byslug['raster01'].delta      | Should -Be -6
        $script:byslug['raster01'].pig_images | Should -Be 10
        $script:byslug['raster01'].mechanism  | Should -Be 'raster-blindness'
    }
    It 'missed-figure when captioned regions fall short with NO bitmaps' {
        $script:byslug['missed01'].delta      | Should -Be -6
        $script:byslug['missed01'].mechanism  | Should -Be 'missed-figure'
        $script:byslug['missed01'].oracle_confidence | Should -Be 'figures_missing:4'
    }
    It 'exact when captioned regions match figure floats (the 2210 shape)' {
        $script:byslug['diagram01'].pig_captioned  | Should -Be 16
        $script:byslug['diagram01'].oracle_figures | Should -Be 16
        $script:byslug['diagram01'].delta          | Should -Be 0
        $script:byslug['diagram01'].mechanism      | Should -Be 'exact'
    }
}

Describe 'Compare-FigureCounts — inline-diagram population (SECONDARY)' {
    It 'measures uncaptioned regions against inline diagrams' {
        # diagram01: 50 uncaptioned pig regions vs 23 inline diagrams → +27 (the fragmentation population)
        $script:byslug['diagram01'].pig_uncaptioned | Should -Be 50
        $script:byslug['diagram01'].oracle_inline   | Should -Be 23
        $script:byslug['diagram01'].inline_delta    | Should -Be 27
    }
}

Describe 'Compare-FigureCounts — summary tally' {
    It 'counts over / under / exact on the captioned-figure metric' {
        $script:report.Summary.over  | Should -Be 1
        $script:report.Summary.under | Should -Be 2
        $script:report.Summary.exact | Should -Be 1
    }
    It 'reports mean |dFig| over scored papers' {
        # |+3| + |-6| + |-6| + |0| = 15 over 4 papers
        $script:report.Summary.mean_abs_delta | Should -Be 3.75
    }
    It 'reports a secondary mean |dInline| for the fragmentation population' {
        # |+2| + |0| + |0| + |+27| = 29 over 4 papers
        $script:report.Summary.inline_mean_abs_delta | Should -Be 7.25
    }
    It 'reads oracle from the schema/2 sidecar when present' {
        $script:byslug['over01'].oracle_src | Should -Be 'sidecar'
    }
}

Describe 'Compare-FigureCounts — oracle resolution ladder' {
    It 'skips a legacy schema/1 sidecar (no inline split) and would recompute from source' {
        $g2 = Join-Path $script:root 'compendia/legacy'
        $paper = Join-Path $g2 'legacypaper'
        $pig = Join-Path $paper '.runs/20260704_120000/pig'
        $tex = Join-Path $paper '.runs/20260704_120000/tex'
        New-Item -ItemType Directory -Force -Path $pig | Out-Null
        New-Item -ItemType Directory -Force -Path $tex | Out-Null
        [System.IO.File]::WriteAllLines((Join-Path $pig 'legacypaper.figures.jsonl'), @('{"id":0,"kind":"figure","caption":{"text":"F"}}'), [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText((Join-Path $pig 'legacypaper.pdfdig.json'), '{"pages":[{"n":1,"images":0}]}', [System.Text.UTF8Encoding]::new($false))
        # schema/1 sidecar (figure_floats, no inline_diagrams) — must be SKIPPED
        [System.IO.File]::WriteAllText((Join-Path $tex 'legacypaper.oracle-counts.json'), '{"schema":"oracle-counts/1","figure_floats":3,"oracle_figures":9}', [System.Text.UTF8Encoding]::new($false))
        # a tiny resolvable source so the fallback has something to read
        [System.IO.File]::WriteAllText((Join-Path $tex 'main.tex'), "\documentclass{article}\begin{document}\begin{figure}\caption{a}\end{figure}\end{document}", [System.Text.UTF8Encoding]::new($false))

        $rep = Compare-FigureCounts -Root $script:root -Group 'compendia/legacy'
        $rep.Rows[0].oracle_src     | Should -Be 'source'   # NOT 'sidecar' — schema/1 was skipped
        $rep.Rows[0].oracle_figures | Should -Be 1          # recomputed: one \begin{figure}
    }

    It 'falls back to the {slug}-latex.md deliverable when no tex run exists' {
        $g3 = Join-Path $script:root 'compendia/mdonly'
        $paper = Join-Path $g3 'mdpaper'
        $pig = Join-Path $paper '.runs/20260704_120000/pig'
        New-Item -ItemType Directory -Force -Path $pig | Out-Null
        [System.IO.File]::WriteAllLines((Join-Path $pig 'mdpaper.figures.jsonl'), @('{"id":0,"kind":"figure","caption":{"text":"F"}}'), [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText((Join-Path $pig 'mdpaper.pdfdig.json'), '{"pages":[{"n":1,"images":0}]}', [System.Text.UTF8Encoding]::new($false))
        $md = "text ![](mdpaper/a.png) more ![](mdpaper/b.png)`n"
        [System.IO.File]::WriteAllText((Join-Path $paper 'mdpaper-latex.md'), $md, [System.Text.UTF8Encoding]::new($false))

        $rep = Compare-FigureCounts -Root $script:root -Group 'compendia/mdonly'
        $rep.Rows[0].oracle_src     | Should -Be 'md'
        $rep.Rows[0].oracle_figures | Should -Be 2
    }
}
