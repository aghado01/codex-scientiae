#requires -Version 7
# Figure-region clustering (src/pdf-converter/pdfdig-figures.ps1): a synthetic paths.jsonl —
# two well-spaced figures + a stray rule on one page, a tiny marker cluster on another, a thin
# degenerate line on a third — plus a letters.jsonl so the em^2 (text-normalized) path is
# exercised. Fixtures are self-contained (do not depend on the git-ignored inbox corpus).

BeforeAll {
    $repo = Split-Path $PSScriptRoot -Parent
    . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')

    $work = Join-Path ([IO.Path]::GetTempPath()) ("pdfdig-fig-tests-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    $rows = [System.Collections.Generic.List[string]]::new()
    $id = 0
    # Page 1: two dense figures (4x3 grids of 6pt boxes, 10pt pitch) at x-offsets 0 and 100.
    foreach ($xoff in @(0, 100)) {
        for ($gx = 0; $gx -lt 4; $gx++) {
            for ($gy = 0; $gy -lt 3; $gy++) {
                $x0 = $xoff + $gx * 10; $y0 = $gy * 10
                $rows.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x0, $y0, ($x0 + 6), ($y0 + 6)))
            }
        }
    }
    # Page 1: one isolated stray rule far above both figures.
    $rows.Add(('{{"id":{0},"page":1,"bbox":[0,300,140,301]}}' -f $id++))
    # Page 2: four tiny boxes forming one small marker cluster (~0.3 em^2 at 10pt body).
    foreach ($m in @(@(293, 279), @(296, 279), @(293, 283), @(296, 283))) {
        $rows.Add(('{{"id":{0},"page":2,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $m[0], $m[1], ($m[0] + 2), ($m[1] + 2)))
    }
    # Page 3: four collinear boxes forming a thin (0.4pt tall) degenerate line cluster.
    foreach ($lx in @(50, 62, 74, 86)) {
        $rows.Add(('{{"id":{0},"page":3,"bbox":[{1},100,{2},100.4]}}' -f $id++, $lx, ($lx + 10)))
    }
    $pathsFile = Join-Path $work 'synth.paths.jsonl'
    [IO.File]::WriteAllLines($pathsFile, $rows)

    # Letters lane so body font size is detected as 10pt (modal size).
    $letters = [System.Collections.Generic.List[string]]::new()
    1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
    1..2  | ForEach-Object { $letters.Add('{"size":23.9}') }   # a couple of title glyphs
    [IO.File]::WriteAllLines((Join-Path $work 'synth.letters.jsonl'), $letters)

    $result = ConvertTo-FigureRegions -PathsJsonl $pathsFile -PassThru

    # Empty input (no clusterable paths) — must write an empty file, not throw.
    $emptyPaths = Join-Path $work 'empty.paths.jsonl'
    [IO.File]::WriteAllLines($emptyPaths, @())
}

AfterAll {
    if ($work -and (Test-Path $work)) { Remove-Item -Recurse -Force $work }
}

Describe 'pdfdig figure-region clustering' {
    It 'separates two well-spaced figures on a page' {
        (@($result.Figures | Where-Object { $_.page -eq 1 -and $_.kind -eq 'figure' })).Count | Should -Be 2
    }

    It 'drops the isolated stray rule as noise (not a region)' {
        $result.Summary.noise_paths | Should -Be 1
    }

    It 'tags a tiny marker cluster as kind=mark below the glyph floor' {
        $p2 = @($result.Figures | Where-Object { $_.page -eq 2 })
        $p2.Count       | Should -Be 1
        $p2[0].kind     | Should -Be 'mark'
        $p2[0].area_em2 | Should -BeLessThan 2.0
    }

    It 'tags a thin collinear cluster as kind=degenerate' {
        $p3 = @($result.Figures | Where-Object { $_.page -eq 3 })
        $p3.Count   | Should -Be 1
        $p3[0].kind | Should -Be 'degenerate'
    }

    It 'detects body font size and records text-normalized area on figures' {
        $result.Summary.body_font_pt | Should -Be 10.0
        $fig = @($result.Figures | Where-Object { $_.kind -eq 'figure' })[0]
        $fig.area_em2 | Should -BeGreaterThan 2.0
    }

    It 'writes well-formed region records (bbox/area/area_em2/kind/path_ids)' {
        $rec = Get-Content $result.OutPath -TotalCount 1 | ConvertFrom-Json
        foreach ($f in 'bbox', 'area', 'area_em2', 'kind', 'path_ids') {
            $rec.PSObject.Properties.Name | Should -Contain $f
        }
        $rec.bbox.Count | Should -Be 4
    }

    It 'writes an empty figures.jsonl for empty input (no throw)' {
        $o = Join-Path $work 'empty.figures.jsonl'
        { ConvertTo-FigureRegions -PathsJsonl $emptyPaths -OutPath $o } | Should -Not -Throw
        Test-Path $o | Should -BeTrue
        (Get-Content $o -Raw) | Should -BeNullOrEmpty
    }
}
