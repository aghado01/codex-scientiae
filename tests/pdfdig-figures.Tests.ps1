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
    # Page 4: three small marks scattered across the column — <= min_pts so grouped as one region,
    # but their union bbox spans the page while holding almost no ink: a SPARSE phantom the density
    # gate must reject (kind=sparse, not figure). Rule tags are irrelevant — the gate is rule-
    # agnostic (rules STAY in clustering; density decides), which is the ph-zigzag over-count fix.
    $rows.Add(('{{"id":{0},"page":4,"bbox":[57,90,63,96]}}'    -f $id++))
    $rows.Add(('{{"id":{0},"page":4,"bbox":[300,300,306,306]}}' -f $id++))
    $rows.Add(('{{"id":{0},"page":4,"bbox":[547,538,553,544]}}' -f $id++))
    $pathsFile = Join-Path $work 'synth.paths.jsonl'
    [IO.File]::WriteAllLines($pathsFile, $rows)

    # Letters lane so body font size is detected as 10pt (modal size).
    $letters = [System.Collections.Generic.List[string]]::new()
    1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
    1..2  | ForEach-Object { $letters.Add('{"size":23.9}') }   # a couple of title glyphs
    [IO.File]::WriteAllLines((Join-Path $work 'synth.letters.jsonl'), $letters)

    # Blocks lane: a cue-matched caption below figure A (x<50); a bare heading below figure B (x>90).
    $blocks = @(
        '{"id":1,"page":1,"bx":[0,-15,40,-5],"text_preview":"Figure 1: the alpha figure"}'
        '{"id":2,"page":1,"bx":[100,-15,140,-5],"text_preview":"3. Results and discussion"}'
    )
    [IO.File]::WriteAllLines((Join-Path $work 'synth.blocks.jsonl'), $blocks)

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

    It 'density-gates a large sparse region as kind=sparse (not figure)' {
        $p4 = @($result.Figures | Where-Object { $_.page -eq 4 })
        $p4.Count              | Should -Be 1
        $p4[0].kind            | Should -Be 'sparse'
        $result.Summary.sparse | Should -Be 1
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

    It 'Find-FragmentElbow locates the fragment-adjacency elbow' {
        # 6 leaves, 3 fragments {0,1}{2,3}{4,5}; inter-fragment merges at d=2 (frag0↔frag1)
        # and d=20 (frag01↔frag2). Elbow = geo-mean of the gap = sqrt(2*20) ≈ 6.32.
        $dend = Join-Path $work 'synth.dendrogram.json'
        @'
{"leaf_count":6,"cost_axis":"d","merges":[
{"left_child":0,"right_child":1,"distance":0.5,"size":2,"lambda":2.0},
{"left_child":2,"right_child":3,"distance":0.5,"size":2,"lambda":2.0},
{"left_child":4,"right_child":5,"distance":0.5,"size":2,"lambda":2.0},
{"left_child":6,"right_child":7,"distance":2.0,"size":4,"lambda":0.5},
{"left_child":9,"right_child":8,"distance":20.0,"size":6,"lambda":0.05}
]}
'@ | Set-Content $dend -Encoding utf8
        $labels = [int[]]@(0, 0, 1, 1, 2, 2)
        $elbow = Find-FragmentElbow $dend $labels 1.0
        $elbow | Should -BeGreaterThan 6.0
        $elbow | Should -BeLessThan 6.7
        # a stricter gap requirement finds no clear elbow → null (leave a continuum alone)
        Find-FragmentElbow $dend $labels 3.0 | Should -BeNullOrEmpty
    }

    It 'reattaches a cue-matched caption below a figure and rejects a bare heading' {
        $figs = @($result.Figures | Where-Object { $_.page -eq 1 -and $_.kind -eq 'figure' })
        $figA = $figs | Where-Object { $_.bbox[0] -lt 50 } | Select-Object -First 1     # has "Figure 1:" below
        $figB = $figs | Where-Object { $_.bbox[0] -gt 90 } | Select-Object -First 1     # has only a heading below
        $figA.caption          | Should -Not -BeNullOrEmpty
        $figA.caption.text     | Should -Match 'Figure 1'
        $figA.caption.cue      | Should -BeTrue
        $figA.caption.position | Should -Be 'below'
        $figB.caption          | Should -BeNullOrEmpty
        $result.Summary.captioned_figures | Should -Be 1
    }
}
