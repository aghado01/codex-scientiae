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

    It 'is backward-compatible when no xobjects lane sits beside the paths lane' {
        $result.Summary.xobjects        | Should -Be 0
        $result.Summary.xobject_regions | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — Lane 5 (xobject image union)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:w5 = Join-Path ([IO.Path]::GetTempPath()) ("pdfdig-fig5-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:w5 | Out-Null

        # dense 3x3 grid of 6pt boxes (10pt pitch) at an x-offset — one vector figure.
        $grid = {
            param($list, $page, $xoff, [ref]$idref)
            for ($gx = 0; $gx -lt 3; $gx++) { for ($gy = 0; $gy -lt 3; $gy++) {
                $x = $xoff + $gx * 10; $y = $gy * 10
                $list.Add(('{{"id":{0},"page":{1},"bbox":[{2},{3},{4},{5}]}}' -f $idref.Value, $page, $x, $y, ($x + 6), ($y + 6)))
                $idref.Value++
            } }
        }
        $paths = [System.Collections.Generic.List[string]]::new(); $pidref = [ref]0
        & $grid $paths 10 0   $pidref                       # p10: one grid (bitmap overlaps it → mixed merge)
        & $grid $paths 11 0   $pidref                       # p11: two well-separated grids + a far bitmap
        & $grid $paths 11 100 $pidref                       #      (far bitmap → noise → rescued singleton)
        [IO.File]::WriteAllLines((Join-Path $script:w5 'x.paths.jsonl'), $paths)

        # p10 bitmap OVERLAPS the grid (rectangle-gap distance 0 → same cluster, mixed); p11 bitmap far
        # from both grids (→ noise → rescued); p12 bitmap alone on an empty page (→ too-few → singleton).
        # All 200x200pt so density (1 point / 400 em²) < 0.01 floor: they'd be 'sparse' but for the raster
        # bypass — so kind=figure proves the bypass fires.
        $xo = @(
            '{"id":0,"page":10,"bbox":[0,0,200,200],"kind":"image"}',
            '{"id":1,"page":11,"bbox":[400,400,600,600],"kind":"image"}',
            '{"id":2,"page":12,"bbox":[100,100,300,300],"kind":"image"}'
        )
        [IO.File]::WriteAllLines((Join-Path $script:w5 'x.xobjects.jsonl'), $xo)

        $letters = [System.Collections.Generic.List[string]]::new()
        1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
        [IO.File]::WriteAllLines((Join-Path $script:w5 'x.letters.jsonl'), $letters)

        $script:r5 = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:w5 'x.paths.jsonl') -PassThru
        $script:regions5 = @(Get-Content $script:r5.OutPath | ForEach-Object { $_ | ConvertFrom-Json })
    }
    AfterAll { if ($script:w5 -and (Test-Path $script:w5)) { Remove-Item -Recurse -Force $script:w5 } }

    It 'loads the xobjects lane and reports the input count' {
        $script:r5.Summary.xobjects | Should -Be 3
    }

    It 'merges a bitmap overlapping a vector cluster into ONE mixed figure (no double count)' {
        $p10 = @($script:regions5 | Where-Object { $_.page -eq 10 -and $_.kind -eq 'figure' })
        $p10.Count            | Should -Be 1
        $p10[0].provenance    | Should -Be 'mixed'
        $p10[0].xobject_count | Should -Be 1
        $p10[0].path_count    | Should -BeGreaterThan 0
    }

    It 'never loses a bitmap to the noise class (raster-blindness cured)' {
        # whether the far bitmap merges or is rescued, its membership must be accounted for as a figure
        $p11figs = @($script:regions5 | Where-Object { $_.page -eq 11 -and $_.kind -eq 'figure' })
        (($p11figs.xobject_count | Measure-Object -Sum).Sum) | Should -Be 1
    }

    It 'rescues an isolated bitmap as its own singleton figure' {
        $p11xobj = @($script:regions5 | Where-Object { $_.page -eq 11 -and $_.provenance -eq 'xobject' })
        $p11xobj.Count    | Should -Be 1
        $p11xobj[0].flag  | Should -Be 'xobject_singleton'
        $p11xobj[0].kind  | Should -Be 'figure'
    }

    It 'emits a bitmap-only page as an xobject singleton figure (too-few-to-cluster path)' {
        $p12 = @($script:regions5 | Where-Object { $_.page -eq 12 })
        $p12.Count         | Should -Be 1
        $p12[0].kind       | Should -Be 'figure'
        $p12[0].provenance | Should -Be 'xobject'
        $p12[0].flag       | Should -Be 'xobject_singleton'
    }

    It 'bypasses the density gate for a large low-density bitmap (figure, not sparse)' {
        foreach ($f in @($script:regions5 | Where-Object { $_.provenance -eq 'xobject' })) {
            $f.density | Should -BeLessThan 0.01     # would be sparse under the vector-ink gate
            $f.kind    | Should -Be 'figure'          # raster bypass wins
        }
    }

    It 'records clean provenance id arrays ([] not [null]) on pure regions' {
        $pureXobj = @($script:regions5 | Where-Object { $_.provenance -eq 'xobject' })[0]
        $pureXobj.path_ids.Count    | Should -Be 0
        $pureXobj.xobject_ids.Count | Should -Be 1
        $purePath = @($script:regions5 | Where-Object { $_.provenance -eq 'path' })[0]
        $purePath.xobject_ids.Count | Should -Be 0
        $purePath.path_ids.Count    | Should -BeGreaterThan 0
    }

    It 'counts every region carrying a bitmap' {
        $script:r5.Summary.xobject_regions | Should -Be 3
    }
}

Describe 'pdfdig figure-region clustering — subfigure grouping' {
    BeforeAll {
        $script:wg = Join-Path ([IO.Path]::GetTempPath()) ('pdfdig-subfig-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:wg | Out-Null

        # Two tight, well-separated figure clusters on page 1 (panels a, b), each 4 paths, both sitting
        # above ONE wide caption block below them → they reattach to the SAME caption and must merge.
        $paths = [System.Collections.Generic.List[string]]::new()
        $id = 0
        foreach ($ox in 100, 300) {                       # panel A at x~100, panel B at x~300 (178pt apart)
            foreach ($c in @(@(0, 0), @(20, 0), @(0, 20), @(20, 20))) {
                $x = $ox + $c[0]; $y = 100 + $c[1]
                $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x, $y, ($x + 2), ($y + 2)))
            }
        }
        [IO.File]::WriteAllLines((Join-Path $script:wg 'g.paths.jsonl'), $paths)

        $letters = [System.Collections.Generic.List[string]]::new()
        1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
        [IO.File]::WriteAllLines((Join-Path $script:wg 'g.letters.jsonl'), $letters)

        # One caption spanning both panels' x-range, sitting just below them (y 80..90; panels bottom 100).
        [IO.File]::WriteAllLines((Join-Path $script:wg 'g.blocks.jsonl'),
            @('{"id":1,"page":1,"bx":[100,80,322,90],"text_preview":"Figure 7: two panels a and b"}'))

        $script:rg = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wg 'g.paths.jsonl') -PassThru
    }
    AfterAll { if ($script:wg -and (Test-Path $script:wg)) { Remove-Item -Recurse -Force $script:wg } }

    It 'merges two subfigures sharing one caption into a single figure' {
        $figs = @($script:rg.Figures | Where-Object { $_.kind -eq 'figure' })
        $figs.Count | Should -Be 1
    }
    It 'flags the merged region and records the grouping in the summary' {
        $merged = @($script:rg.Figures | Where-Object { $_.flag -eq 'subfigure_merged' })
        $merged.Count                        | Should -Be 1
        $merged[0].caption.text              | Should -Match 'Figure 7'
        $merged[0].path_count                | Should -Be 8      # 4 + 4 members concatenated
        @($merged[0].path_ids).Count         | Should -Be 8
        $merged[0].provenance                | Should -Be 'path'
        $script:rg.Summary.subfigure_groups  | Should -Be 1
        $script:rg.Summary.subfigures_merged | Should -Be 1
    }
    It 'keeps id = list index after the merge' {
        $ids = @($script:rg.Figures | ForEach-Object { $_.id })
        $ids | Should -Be (0..($ids.Count - 1))
    }
    It 'does NOT merge figures with distinct or absent captions (main fixture)' {
        # the shared fixture's page-1 figures have a caption vs a rejected heading → no shared block
        $result.Summary.subfigures_merged | Should -Be 0
        $result.Summary.subfigure_groups  | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — consensus m1 (Join-FigureViews unit)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:consCfg = [pscustomobject]@{ enabled = $true; rule = 'inclusive'; stream_jump_em = 6.0; t_far_em = 4.0 }
        # body 10pt → jump 60pt, t_far 40pt
        $script:NewSummary = { [ordered]@{ stream_blocks = 0; consensus_unions = 0; consensus_changed_pages = 0 } }
        # one dense clump: 2x2 boxes of 4pt at 6pt pitch (bbox ~10x10), ids from $id0, drawn in one run
        $script:NewClump = {
            param($x, $y, $id0)
            $o = [System.Collections.Generic.List[object]]::new()
            foreach ($c in @(@(0, 0), @(6, 0), @(0, 6), @(6, 6))) {
                $o.Add(@{ id = $id0; prov = 'path'; bbox = [double[]]@(($x + $c[0]), ($y + $c[1]), ($x + $c[0] + 4), ($y + $c[1] + 4)) })
                $id0++
            }
            , $o
        }
    }

    It 'welds two geometry clusters that share one spatially-coherent draw-run' {
        # clump B starts 28pt from clump A's right edge: same block (28 <= 60), chain union (28 <= 40)
        $items = @((& $NewClump 0 0 0) + (& $NewClump 38 0 4))
        $s = & $NewSummary
        $j = Join-FigureViews $items ([int[]]@(0, 0, 0, 0, 1, 1, 1, 1)) 10.0 $consCfg $s
        (@($j.Labels | Select-Object -Unique)).Count | Should -Be 1
        $j.Changed.Count           | Should -Be 1
        $s.consensus_unions        | Should -Be 1
        $s.stream_blocks           | Should -Be 1
        $s.consensus_changed_pages | Should -Be 1
    }

    It 'T_far guards the union: same draw-run but not co-located stays split' {
        # 50pt step: same block (50 <= 60) but no chain union (50 > 40) and no bbox re-glue (50 > 40)
        $items = @((& $NewClump 0 0 0) + (& $NewClump 60 0 4))
        $s = & $NewSummary
        $j = Join-FigureViews $items ([int[]]@(0, 0, 0, 0, 1, 1, 1, 1)) 10.0 $consCfg $s
        (@($j.Labels | Select-Object -Unique)).Count | Should -Be 2
        $s.consensus_unions | Should -Be 0
        $j.Changed.Count    | Should -Be 0
    }

    It 'splits the stream at a pen teleport (block boundary)' {
        # 90pt step > 60pt jump → two blocks, two components
        $items = @((& $NewClump 0 0 0) + (& $NewClump 100 0 4))
        $s = & $NewSummary
        $j = Join-FigureViews $items ([int[]]@(0, 0, 0, 0, 1, 1, 1, 1)) 10.0 $consCfg $s
        (@($j.Labels | Select-Object -Unique)).Count | Should -Be 2
        $s.stream_blocks    | Should -Be 2
        $s.consensus_unions | Should -Be 0
    }

    It 'rescues chained noise fragments as one component, keeps lone noise as noise' {
        $items = @((& $NewClump 0 0 0))
        $items += @{ id = 4; prov = 'path'; bbox = [double[]]@(300, 300, 306, 306) }   # far lone stray
        $s = & $NewSummary
        $j = Join-FigureViews $items ([int[]]@(-1, -1, -1, -1, -1)) 10.0 $consCfg $s
        $j.Labels[0..3] | Should -Be @(0, 0, 0, 0)     # welded rescue
        $j.Labels[4]    | Should -Be -1                # singleton stays noise
        $s.consensus_unions | Should -Be 3
        $j.Changed.ContainsKey(0) | Should -BeTrue
    }

    It 'gives xobjects no stream evidence (an id-adjacent bitmap must not bridge a teleport)' {
        # two clumps 90pt apart (teleport) with a bitmap sitting midway, id BETWEEN the two runs:
        # if it entered V_stream it would chain both sides (40 <= 40 each); excluded, they stay split
        $items = @((& $NewClump 0 0 0))
        $items += @{ id = 4; prov = 'xobject'; bbox = [double[]]@(50, 0, 60, 10) }
        $items += @((& $NewClump 100 0 5))
        $s = & $NewSummary
        $labels = [int[]]@(0, 0, 0, 0, -1, 1, 1, 1, 1)
        $j = Join-FigureViews $items $labels 10.0 $consCfg $s
        $j.Labels[0] | Should -Not -Be $j.Labels[5]
        $j.Labels[4] | Should -Be -1                   # noise bitmap left for the singleton rescue
        $s.consensus_unions | Should -Be 0
    }

    It 're-glues sub-chains of one run whose bboxes stay co-located' {
        # one run drawn as: clump A, a 42pt hop right (same block, chain severed: 42 > 40), then a
        # back-fill clump overlapping A — the A∪backfill bbox ends 34pt from B, so the re-glue welds all 3
        $items = @((& $NewClump 0 0 0) + (& $NewClump 52 0 4) + (& $NewClump 8 0 8))
        $s = & $NewSummary
        $j = Join-FigureViews $items ([int[]]@(0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0)) 10.0 $consCfg $s
        (@($j.Labels | Select-Object -Unique)).Count | Should -Be 1
        $s.consensus_unions | Should -BeGreaterThan 0
    }

    It 'is the identity when stream evidence agrees with geometry' {
        $items = @((& $NewClump 0 0 0))
        $s = & $NewSummary
        $j = Join-FigureViews $items ([int[]]@(0, 0, 0, 0)) 10.0 $consCfg $s
        $j.Labels | Should -Be @(0, 0, 0, 0)
        $j.Changed.Count    | Should -Be 0
        $s.consensus_unions | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — consensus m1 (integration)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:wc = Join-Path ([IO.Path]::GetTempPath()) ('pdfdig-cons-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:wc | Out-Null

        # Page 1: a "shattered diagram" — two tight 2x2 clumps (3pt boxes, 4pt pitch, ~7x7 bboxes) with a
        # 31pt valley, drawn as ONE contiguous run (ids 0..7) — plus a well-separated dense 3x3 anchor
        # grid (ids 8..16). V_geom splits the clumps (tight cores vs the valley) and each 0.49 em²
        # fragment demotes to kind=mark; the stream chain re-welds them into one 3.15 em² FIGURE —
        # exactly the ledger's E-item shape (post-merge the size floor passes).
        $paths = [System.Collections.Generic.List[string]]::new()
        $id = 0
        foreach ($ox in 0, 38) {
            foreach ($c in @(@(0, 0), @(4, 0), @(0, 4), @(4, 4))) {
                $x = $ox + $c[0]; $y = 100 + $c[1]
                $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x, $y, ($x + 3), ($y + 3)))
            }
        }
        for ($gx = 0; $gx -lt 3; $gx++) { for ($gy = 0; $gy -lt 3; $gy++) {
            $x = 300 + $gx * 10; $y = 300 + $gy * 10
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x, $y, ($x + 6), ($y + 6)))
        } }
        [IO.File]::WriteAllLines((Join-Path $script:wc 'c.paths.jsonl'), $paths)
        $letters = [System.Collections.Generic.List[string]]::new()
        1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
        [IO.File]::WriteAllLines((Join-Path $script:wc 'c.letters.jsonl'), $letters)

        # config clone with consensus disabled — the passthrough control
        $cfgObj = Get-Content (Join-Path $repo 'src/pdf-converter/stores/classify-config.json') -Raw | ConvertFrom-Json
        $cfgObj.figure_regions.consensus.enabled = $false
        $script:cfgOff = Join-Path $script:wc 'config-consensus-off.json'
        [IO.File]::WriteAllText($script:cfgOff, ($cfgObj | ConvertTo-Json -Depth 12), [System.Text.UTF8Encoding]::new($false))

        $script:rOn  = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wc 'c.paths.jsonl') `
                        -OutPath (Join-Path $script:wc 'on.figures.jsonl') -PassThru
        $script:rOff = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wc 'c.paths.jsonl') `
                        -OutPath (Join-Path $script:wc 'off.figures.jsonl') -ConfigPath $script:cfgOff -PassThru
    }
    AfterAll { if ($script:wc -and (Test-Path $script:wc)) { Remove-Item -Recurse -Force $script:wc } }

    It 'merges a stream-coherent shattered diagram into one flagged region' {
        $figs = @($script:rOn.Figures | Where-Object { $_.kind -eq 'figure' })
        $figs.Count | Should -Be 2                       # welded diagram + anchor grid
        $merged = @($figs | Where-Object { $_.flag -eq 'consensus_merged' })
        $merged.Count         | Should -Be 1
        $merged[0].path_count | Should -Be 8
        $script:rOn.Summary.consensus_unions        | Should -BeGreaterThan 0
        $script:rOn.Summary.consensus_changed_pages | Should -Be 1
        $script:rOn.Summary.stream_blocks           | Should -Be 2
    }

    It 'is a pure passthrough when consensus is disabled (fragments stay sub-floor marks)' {
        $figs = @($script:rOff.Figures | Where-Object { $_.kind -eq 'figure' })
        $figs.Count | Should -Be 1                       # anchor grid only
        @($script:rOff.Figures | Where-Object { $_.kind -eq 'mark' }).Count | Should -Be 2   # the fragments
        @($script:rOff.Figures | Where-Object { $_.flag -eq 'consensus_merged' }).Count | Should -Be 0
        $script:rOff.Summary.consensus_unions | Should -Be 0
        $script:rOff.Summary.stream_blocks    | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — V_caption interior split (unit)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:wv = Join-Path ([IO.Path]::GetTempPath()) ('pdfdig-vcap-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:wv | Out-Null

        $script:gatesV = @{ degenEps = 1.0; floorEm = 2.0; fallbackPt2 = 200; minDensity = 0.01 }
        $script:cfgV = [pscustomobject]@{
            caption_min_overlap_frac = 0.25
            caption_split = [pscustomobject]@{ enabled = $true; margin_em = 1.0; max_block_em = 3.5 }
        }
        # path id→record map: ids 0..8 = TOP 3x3 grid (y 118..144), ids 9..17 = BOTTOM 3x3 grid (y 60..86)
        $script:pbV = [System.Collections.Generic.Dictionary[int, object]]::new()
        $id = 0
        foreach ($y0 in 138, 128, 118) { foreach ($x0 in 100, 110, 120) {
            $script:pbV[$id] = @{ id = $id; bbox = [double[]]@($x0, $y0, ($x0 + 6), ($y0 + 6)); prov = 'path' }; $id++ } }
        foreach ($y0 in 80, 70, 60)    { foreach ($x0 in 100, 110, 120) {
            $script:pbV[$id] = @{ id = $id; bbox = [double[]]@($x0, $y0, ($x0 + 6), ($y0 + 6)); prov = 'path' }; $id++ } }
        $script:xbV = [System.Collections.Generic.Dictionary[int, object]]::new()

        # a welded parent (both grids, one region) + a page-2 anchor whose claimed caption teaches the
        # style 'Figure N:' — records carry the lane's shape
        $script:NewParent = {
            param($withCaption)
            $figs = [System.Collections.Generic.List[object]]::new()
            $figs.Add([ordered]@{
                id = 0; page = 1; bbox = @(100.0, 60.0, 126.0, 144.0); area = 2184.0; area_em2 = 21.84; density = 0.82
                path_ids = @(0..17); path_count = 18; xobject_ids = @(); xobject_count = 0
                provenance = 'path'; kind = 'figure'; flag = $null
                caption = if ($withCaption) { [ordered]@{ block_id = 99; bbox = @(100, 40, 180, 48); text = 'Figure 4: parent'; cue = $true; position = 'below'; gap = 12.0 } } else { $null }
            })
            $figs.Add([ordered]@{
                id = 1; page = 2; bbox = @(100.0, 300.0, 126.0, 326.0); area = 676.0; area_em2 = 6.76; density = 1.33
                path_ids = @(); path_count = 0; xobject_ids = @(); xobject_count = 0
                provenance = 'path'; kind = 'figure'; flag = $null
                caption = [ordered]@{ block_id = 50; bbox = @(100, 288, 180, 296); text = 'Figure 9: anchor'; cue = $true; position = 'below'; gap = 4.0 }
            })
            , $figs
        }
        $script:NewSummaryV = { [ordered]@{ regions = 2; figures = 2; marks = 0; sparse = 0; degenerate = 0; captioned_figures = 1; xobject_regions = 0; caption_splits = 0 } }
        $script:WriteBlocks = {
            param($lines, $name)
            $f = Join-Path $script:wv $name
            [IO.File]::WriteAllLines($f, [string[]]$lines)
            $f
        }
    }
    AfterAll { if ($script:wv -and (Test-Path $script:wv)) { Remove-Item -Recurse -Force $script:wv } }

    It 'splits a welded region at a style-matched interior caption' {
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,100,180,108],"text_preview":"Figure 3: interior caption"}') 'b1.jsonl'
        $s = & $NewSummaryV
        $out = Split-CaptionInteriorRegions (& $NewParent $false) $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s
        $p1 = @($out | Where-Object { $_.page -eq 1 })
        $p1.Count | Should -Be 2
        $upper = $p1 | Where-Object { $_.bbox[1] -gt 100 }
        $lower = $p1 | Where-Object { $_.bbox[3] -lt 100 }
        $upper.caption.text | Should -Be 'Figure 3: interior caption'
        $upper.kind         | Should -Be 'figure'
        $upper.flag         | Should -Be 'caption_split'
        $lower.caption      | Should -BeNullOrEmpty
        $lower.path_count   | Should -Be 9
        $s.caption_splits   | Should -Be 1
        $s.figures          | Should -Be 3
        $s.captioned_figures | Should -Be 2
        @($out | ForEach-Object { $_.id }) | Should -Be (0..($out.Count - 1))
    }

    It 'hands the parent pass-1 caption to the bottom remainder' {
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,100,180,108],"text_preview":"Figure 3: interior caption"}') 'b2.jsonl'
        $s = & $NewSummaryV; $s.captioned_figures = 2
        $out = Split-CaptionInteriorRegions (& $NewParent $true) $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s
        $lower = @($out | Where-Object { $_.page -eq 1 -and $_.bbox[3] -lt 100 })[0]
        $lower.caption.text  | Should -Be 'Figure 4: parent'
        $s.captioned_figures | Should -Be 3
    }

    It 'rejects a style-mismatched interior cue block (Fig. vs learned Figure:)' {
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,100,180,108],"text_preview":"Fig. 3 something"}') 'b3.jsonl'
        $s = & $NewSummaryV
        $out = Split-CaptionInteriorRegions (& $NewParent $false) $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s
        @($out).Count     | Should -Be 2
        $s.caption_splits | Should -Be 0
    }

    It 'rejects a tall interior block (in-text paragraph shape)' {
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,90,180,130],"text_preview":"Figure 3: but forty points tall"}') 'b4.jsonl'
        $s = & $NewSummaryV
        (Split-CaptionInteriorRegions (& $NewParent $false) $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s).Count | Should -Be 2
        $s.caption_splits | Should -Be 0
    }

    It 'rejects a bottom-band block (overhang, not a weld)' {
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,62,180,68],"text_preview":"Figure 3: at the bottom edge"}') 'b5.jsonl'
        $s = & $NewSummaryV
        (Split-CaptionInteriorRegions (& $NewParent $false) $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s).Count | Should -Be 2
        $s.caption_splits | Should -Be 0
    }

    It 'gives a separator-signed caption the taller height allowance (long survey captions)' {
        # 60pt-tall block (6em > 3.5em tight cap) WITH the colon signature -> splits; the identical
        # block without a separator keeps the tight cap -> no split
        $cfgSep = [pscustomobject]@{
            caption_min_overlap_frac = 0.25
            caption_split = [pscustomobject]@{ enabled = $true; margin_em = 1.0; max_block_em = 3.5; max_block_sep_em = 9.0 }
        }
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,72,180,132],"text_preview":"Figure 3: a very long multi-line caption"}') 'b7.jsonl'
        $s = & $NewSummaryV
        $out = Split-CaptionInteriorRegions (& $NewParent $false) $blocks $pbV $xbV 10.0 100.0 $cfgSep $gatesV $s
        $s.caption_splits | Should -Be 1
        $blocks2 = & $WriteBlocks @('{"id":8,"page":1,"bx":[100,72,180,132],"text_preview":"Figure 3 shows a lot of prose without a colon"}') 'b8.jsonl'
        $s2 = & $NewSummaryV
        (Split-CaptionInteriorRegions (& $NewParent $false) $blocks2 $pbV $xbV 10.0 100.0 $cfgSep $gatesV $s2).Count | Should -Be 2
        $s2.caption_splits | Should -Be 0
    }

    It 'sees a caption through up to 4 junk prefix glyphs (stray superscripts)' {
        $blocks = & $WriteBlocks @('{"id":9,"page":1,"bx":[100,100,180,108],"text_preview":"> 2 Figure 3: energy landscape"}') 'b9.jsonl'
        $s = & $NewSummaryV
        Split-CaptionInteriorRegions (& $NewParent $false) $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s | Out-Null
        $s.caption_splits | Should -Be 1
    }

    It 'never splits a paper with no claimed captions (no style evidence)' {
        $blocks = & $WriteBlocks @('{"id":7,"page":1,"bx":[100,100,180,108],"text_preview":"Figure 3: interior caption"}') 'b6.jsonl'
        $figs = & $NewParent $false
        $figs[1].caption = $null                      # remove the anchor claim
        $s = & $NewSummaryV; $s.captioned_figures = 0
        (Split-CaptionInteriorRegions $figs $blocks $pbV $xbV 10.0 100.0 $cfgV $gatesV $s).Count | Should -Be 2
        $s.caption_splits | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — V_caption interior split (integration)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:wi = Join-Path ([IO.Path]::GetTempPath()) ('pdfdig-vcapint-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:wi | Out-Null

        # Page 1 reproduces the 2205-pg8 failure shape: TWO stacked 3x3 grids drawn as one run whose
        # nearest corners sit ~35pt apart — V_geom separates them, the m1 stream chain WELDS them across
        # the interior caption — plus a page-2 anchor figure whose caption teaches the 'Figure N:' style.
        # Boxes are emitted y-DESCENDING so the run's chain step between grids is the near corner.
        $paths = [System.Collections.Generic.List[string]]::new()
        $id = 0
        foreach ($y0 in 138, 128, 118) { foreach ($x0 in 100, 110, 120) {
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x0, $y0, ($x0 + 6), ($y0 + 6))) } }
        foreach ($y0 in 80, 70, 60)    { foreach ($x0 in 100, 110, 120) {
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x0, $y0, ($x0 + 6), ($y0 + 6))) } }
        foreach ($y0 in 300, 310, 320) { foreach ($x0 in 100, 110, 120) {
            $paths.Add(('{{"id":{0},"page":2,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x0, $y0, ($x0 + 6), ($y0 + 6))) } }
        [IO.File]::WriteAllLines((Join-Path $script:wi 'v.paths.jsonl'), $paths)
        $letters = [System.Collections.Generic.List[string]]::new()
        1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
        [IO.File]::WriteAllLines((Join-Path $script:wi 'v.letters.jsonl'), $letters)
        [IO.File]::WriteAllLines((Join-Path $script:wi 'v.blocks.jsonl'), @(
            '{"id":7,"page":1,"bx":[100,100,180,108],"text_preview":"Figure 3: interior caption"}'
            '{"id":50,"page":2,"bx":[100,288,180,296],"text_preview":"Figure 9: anchor"}'
        ))

        $script:ri = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wi 'v.paths.jsonl') `
                       -OutPath (Join-Path $script:wi 'on.figures.jsonl') -PassThru

        $cfgObj = Get-Content (Join-Path $repo 'src/pdf-converter/stores/classify-config.json') -Raw | ConvertFrom-Json
        $cfgObj.figure_regions.caption_split.enabled = $false
        $off = Join-Path $script:wi 'cfg-off.json'
        [IO.File]::WriteAllText($off, ($cfgObj | ConvertTo-Json -Depth 12), [System.Text.UTF8Encoding]::new($false))
        $script:riOff = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wi 'v.paths.jsonl') `
                          -OutPath (Join-Path $script:wi 'off.figures.jsonl') -ConfigPath $off -PassThru
    }
    AfterAll { if ($script:wi -and (Test-Path $script:wi)) { Remove-Item -Recurse -Force $script:wi } }

    It 'cuts a stream-welded two-float region at the interior caption end-to-end' {
        $p1 = @($script:ri.Figures | Where-Object { $_.page -eq 1 -and $_.kind -eq 'figure' })
        $p1.Count | Should -Be 2
        $upper = $p1 | Where-Object { $_.bbox[1] -gt 100 }
        $upper.caption.text | Should -Match 'Figure 3'
        $upper.flag         | Should -Be 'caption_split'
        $script:ri.Summary.caption_splits | Should -Be 1
    }

    It 'leaves the weld intact when the splitter is disabled' {
        $p1 = @($script:riOff.Figures | Where-Object { $_.page -eq 1 -and $_.kind -eq 'figure' })
        $p1.Count | Should -Be 1
        $script:riOff.Summary.caption_splits | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — V_letters evidence view (unit)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:consL = [pscustomobject]@{ enabled = $true; rule = 'inclusive'; stream_jump_em = 6.0; t_far_em = 4.0 }
        $script:lcfg  = [pscustomobject]@{ enabled = $true; max_width_em = 4.0; max_letters = 10; t_bridge_em = 0.5 }
        $script:NewSummaryL = { [ordered]@{ stream_blocks = 0; consensus_unions = 0; consensus_changed_pages = 0; letter_blocks = 0; letter_bridges = 0 } }
        $script:LClump = {
            param($x, $y, $id0)
            $o = [System.Collections.Generic.List[object]]::new()
            foreach ($c in @(@(0, 0), @(4, 0), @(0, 4), @(4, 4))) {
                $o.Add(@{ id = $id0; prov = 'path'; bbox = [double[]]@(($x + $c[0]), ($y + $c[1]), ($x + $c[0] + 3), ($y + $c[1] + 3)) })
                $id0++
            }
            , $o
        }
    }

    It 'bridges two components that share one node-label block (>=2 rule)' {
        # A (x 0..7) and B (x 50..57) with an id-teleport anchor between (no stream weld);
        # the label block spans x 10..46 — within 3pt of BOTH clumps (t_bridge 5pt at 10pt body)
        $items = @((& $LClump 0 0 0) + (& $LClump 300 300 4) + (& $LClump 50 0 8))
        $labels = [int[]]@(0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2)
        $blocks = @([pscustomobject]@{ id = 77; page = 1; bx = @(10.0, 1.0, 46.0, 7.0) })
        $s = & $NewSummaryL
        $j = Join-FigureViews $items $labels 10.0 $consL $s $blocks $lcfg
        $j.Labels[0]  | Should -Be $j.Labels[8]        # A and B welded through the label
        $j.Labels[4]  | Should -Not -Be $j.Labels[0]   # the far anchor stays its own component
        $s.letter_bridges | Should -Be 1
        $s.letter_blocks  | Should -Be 1
        $j.LetterIds[[int]$j.Labels[0]] | Should -Contain 77
    }

    It 'attaches membership without union when only ONE component is in reach' {
        $items = @((& $LClump 0 0 0) + (& $LClump 300 300 4))
        $labels = [int[]]@(0, 0, 0, 0, 1, 1, 1, 1)
        $blocks = @([pscustomobject]@{ id = 78; page = 1; bx = @(9.0, 1.0, 30.0, 7.0) })   # near A only
        $s = & $NewSummaryL
        $j = Join-FigureViews $items $labels 10.0 $consL $s $blocks $lcfg
        (@($j.Labels | Select-Object -Unique)).Count | Should -Be 2
        $s.letter_bridges | Should -Be 0
        $s.letter_blocks  | Should -Be 1
        $j.LetterIds[[int]$j.Labels[0]] | Should -Contain 78
    }

    It 'ignores a block out of bridge reach' {
        $items = @((& $LClump 0 0 0))
        $blocks = @([pscustomobject]@{ id = 79; page = 1; bx = @(50.0, 1.0, 80.0, 7.0) })   # 43pt away
        $s = & $NewSummaryL
        $j = Join-FigureViews $items ([int[]]@(0, 0, 0, 0)) 10.0 $consL $s $blocks $lcfg
        $s.letter_blocks | Should -Be 0
        $j.LetterIds.Count | Should -Be 0
    }
}

Describe 'pdfdig figure-region clustering — V_letters (integration)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:wl = Join-Path ([IO.Path]::GetTempPath()) ('pdfdig-lett-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:wl | Out-Null

        # Page 1: clump A (ids 0..3, x 0..7), a FAR anchor grid (ids 4..12 at 300,300 — sits between
        # A and B in DRAW ORDER so the stream teleports and never welds A-B), clump B (ids 13..16,
        # x 50..57). The 3.6em label block id 5 spans the A-B gap: V_geom splits A/B, letters weld them.
        $paths = [System.Collections.Generic.List[string]]::new()
        $id = 0
        foreach ($c in @(@(0, 0), @(4, 0), @(0, 4), @(4, 4))) {
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $c[0], (100 + $c[1]), ($c[0] + 3), (100 + $c[1] + 3))) }
        for ($gx = 0; $gx -lt 3; $gx++) { for ($gy = 0; $gy -lt 3; $gy++) {
            $x = 300 + $gx * 10; $y = 300 + $gy * 10
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x, $y, ($x + 6), ($y + 6))) } }
        foreach ($c in @(@(0, 0), @(4, 0), @(0, 4), @(4, 4))) {
            $x = 50 + $c[0]
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $x, (100 + $c[1]), ($x + 3), (100 + $c[1] + 3))) }
        [IO.File]::WriteAllLines((Join-Path $script:wl 'l.paths.jsonl'), $paths)

        $letters = [System.Collections.Generic.List[string]]::new()
        1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
        1..3  | ForEach-Object { $letters.Add('{"size":10.0,"block":5}') }   # the label block's 3 letters
        [IO.File]::WriteAllLines((Join-Path $script:wl 'l.letters.jsonl'), $letters)
        [IO.File]::WriteAllLines((Join-Path $script:wl 'l.blocks.jsonl'),
            @('{"id":5,"page":1,"bx":[9,101,48,107],"text_preview":"X 0 1"}'))

        $script:rl = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wl 'l.paths.jsonl') -PassThru
    }
    AfterAll { if ($script:wl -and (Test-Path $script:wl)) { Remove-Item -Recurse -Force $script:wl } }

    It 'heals a label-split diagram end-to-end and records the letter membership' {
        $figs = @($script:rl.Figures | Where-Object { $_.kind -eq 'figure' })
        $figs.Count | Should -Be 2                     # welded A+B + the anchor grid
        $welded = @($figs | Where-Object { $_.bbox[2] -lt 100 })[0]
        $welded.path_count | Should -Be 8
        @($welded.letter_block_ids) | Should -Contain 5
        $script:rl.Summary.letter_bridges | Should -Be 1
        $script:rl.Summary.letter_blocks  | Should -Be 1
    }
}

Describe 'pdfdig figure-region clustering — T1 furniture demotion (unit)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:cfgF = [pscustomobject]@{
            furniture_demotion = [pscustomobject]@{
                enabled = $true; cycle_radius_em = 2.0; areal_min_extent_pt = 4.0
                min_aspect = 6.0; max_height_em = 1.5; max_members = 200
            }
        }
        # region factory: a kind=figure record over the given path ids
        $script:NewFig = {
            param($ids, $bbox, $caption)
            $r = [ordered]@{
                id = 0; page = 1; bbox = $bbox; area = 100.0; area_em2 = 10.0; density = 0.5
                path_ids = @($ids); path_count = @($ids).Count; xobject_ids = @(); xobject_count = 0
                provenance = 'path'; kind = 'figure'; flag = $null; caption = $caption
            }
            $figs = [System.Collections.Generic.List[object]]::new(); $figs.Add($r); , $figs
        }
        $script:NewSummaryF = { [ordered]@{ figures = 1; furniture = 0 } }
        # path-record map builder from bbox arrays
        $script:NewRec = {
            param($bxs)
            $m = [System.Collections.Generic.Dictionary[int, object]]::new()
            for ($i = 0; $i -lt $bxs.Count; $i++) { $m[$i] = @{ id = $i; bbox = [double[]]$bxs[$i]; prov = 'path' } }
            , $m
        }
    }

    It 'demotes an acyclic all-thin high-aspect strip (the overline/underbrace class)' {
        # three thin hrules in a row, region 350x8pt (aspect 44), no circuits
        $rec = & $NewRec @(@(0, 0, 110, 1.5), @(120, 4, 230, 5.5), @(240, 0, 350, 1.5))
        $figs = & $NewFig @(0, 1, 2) @(0.0, 0.0, 350.0, 8.0) $null
        $s = & $NewSummaryF
        Set-FurnitureKind $figs $rec 10.0 $cfgF $s
        $figs[0].kind | Should -Be 'furniture'
        $s.furniture  | Should -Be 1
        $s.figures    | Should -Be 0
    }

    It 'spares a box drawn as four strokes (the circuit saves it)' {
        # 40x40 square outline as 4 thin strokes touching at corners -> cycle rank 1; aspect ~1 but
        # force the shape clause via height <= 1.5em? no — make it strip-EXEMPT-proof: wide flat box
        $rec = & $NewRec @(
            @(0, 0, 40, 1),      # bottom
            @(0, 9, 40, 10),     # top
            @(0, 0, 1, 10),      # left
            @(39, 0, 40, 10)     # right — closes the circuit
        )
        $figs = & $NewFig @(0, 1, 2, 3) @(0.0, 0.0, 40.0, 10.0) $null   # h=10pt=1em <= 1.5em: strip-shaped
        $s = & $NewSummaryF
        Set-FurnitureKind $figs $rec 10.0 $cfgF $s
        $figs[0].kind | Should -Be 'figure'
        $s.furniture  | Should -Be 0
    }

    It 'spares a region containing any areal member (boxes/blobs disqualify)' {
        $rec = & $NewRec @(@(0, 0, 110, 1.5), @(120, 0, 130, 10))   # rule + a 10x10 blob
        $figs = & $NewFig @(0, 1) @(0.0, 0.0, 130.0, 10.0) $null
        $s = & $NewSummaryF
        Set-FurnitureKind $figs $rec 10.0 $cfgF $s
        $figs[0].kind | Should -Be 'figure'
    }

    It 'spares squarish/tall thin regions (text-node diagrams, barcode figures)' {
        # two thin arrows 30pt apart vertically: aspect < 6 and h > 1.5em -> not strip-shaped
        $rec = & $NewRec @(@(0, 0, 60, 1.5), @(0, 40, 60, 41.5))
        $figs = & $NewFig @(0, 1) @(0.0, 0.0, 60.0, 41.5) $null
        $s = & $NewSummaryF
        Set-FurnitureKind $figs $rec 10.0 $cfgF $s
        $figs[0].kind | Should -Be 'figure'
    }

    It 'v2: the strip test runs on the letters-AUGMENTED bbox (diagram labels de-strip it)' {
        # two thin parallel arrows (h 1.1em: a strip, acyclic alone) with node labels ABOVE and BELOW:
        # letters-augmented bbox is 3em tall / aspect 1.7 -> not a strip -> spared; without letters demoted
        $rec = & $NewRec @(@(10, 10, 40, 11), @(10, 0, 40, 1))
        $mkFig = {
            param($letters)
            $figs = & $NewFig @(0, 1) @(0.0, 0.0, 50.0, 11.0) $null
            $figs[0].letter_block_ids = $letters
            , $figs
        }
        $blockBx = [System.Collections.Generic.Dictionary[int, object]]::new()
        $blockBx[70] = @(20.0, 14.0, 30.0, 20.0)    # label above
        $blockBx[71] = @(20.0, -9.0, 30.0, -3.0)    # label below
        $s1 = & $NewSummaryF
        $f1 = & $mkFig @()
        Set-FurnitureKind $f1 $rec 10.0 $cfgF $s1 $blockBx
        $f1[0].kind | Should -Be 'furniture'        # no letters: acyclic 1.1em strip
        $s2 = & $NewSummaryF
        $f2 = & $mkFig @(70, 71)
        Set-FurnitureKind $f2 $rec 10.0 $cfgF $s2 $blockBx
        $f2[0].kind | Should -Be 'figure'           # augmented bbox 29pt tall, aspect 1.7: not a strip
        $s2.furniture | Should -Be 0
    }

    It 'v2: an accent strip stays furniture — its in-row glyphs do not de-strip it' {
        # overbar row + glyph blocks in the SAME band: augmented bbox is still wide/flat (aspect >= 6)
        $rec = & $NewRec @(@(0, 10, 110, 11.5), @(120, 10, 230, 11.5), @(240, 10, 350, 11.5))
        $figs = & $NewFig @(0, 1, 2) @(0.0, 10.0, 350.0, 11.5) $null
        $figs[0].letter_block_ids = @(80, 81)
        $blockBx = [System.Collections.Generic.Dictionary[int, object]]::new()
        $blockBx[80] = @(20.0, 0.0, 90.0, 9.0)      # glyphs under the first overbar
        $blockBx[81] = @(140.0, 0.0, 210.0, 9.0)
        $s = & $NewSummaryF
        Set-FurnitureKind $figs $rec 10.0 $cfgF $s $blockBx
        $figs[0].kind | Should -Be 'furniture'      # augmented 350x11.5: aspect 30, still a strip
    }

    It 'never touches a captioned region (PRIMARY invariant)' {
        $rec = & $NewRec @(@(0, 0, 110, 1.5), @(120, 4, 230, 5.5), @(240, 0, 350, 1.5))
        $cap = [ordered]@{ block_id = 9; text = 'Figure 1: bars'; cue = $true }
        $figs = & $NewFig @(0, 1, 2) @(0.0, 0.0, 350.0, 8.0) $cap
        $s = & $NewSummaryF
        Set-FurnitureKind $figs $rec 10.0 $cfgF $s
        $figs[0].kind | Should -Be 'figure'
    }
}

Describe 'pdfdig figure-region clustering — T3-lite in-flow veto (unit)' {
    BeforeAll {
        $repo = Split-Path $PSScriptRoot -Parent
        . (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')
        $script:cfgI = [pscustomobject]@{ inflow_demotion = [pscustomobject]@{ enabled = $true; wide_block_em = 20.0; min_cover = 0.7 } }
        $script:NewFigI = {
            param($bbox, $caption)
            $r = [ordered]@{
                id = 0; page = 1; bbox = $bbox; area = 100.0; area_em2 = 10.0; density = 0.5
                path_ids = @(0); path_count = 1; xobject_ids = @(); xobject_count = 0
                letter_block_ids = @(); provenance = 'path'; kind = 'figure'; flag = $null; caption = $caption
            }
            $figs = [System.Collections.Generic.List[object]]::new(); $figs.Add($r); , $figs
        }
        $script:NewSummaryI = { [ordered]@{ figures = 1; inflow = 0 } }
    }

    It 'demotes a region fully covered by backbone lines (display-math ink)' {
        $wide = @{ 1 = [System.Collections.Generic.List[object]]::new() }
        $wide[1].Add([double[]]@(0, 0, 400, 30))     # one wide line band covering the region
        $figs = & $NewFigI @(50.0, 5.0, 350.0, 25.0) $null
        $s = & $NewSummaryI
        Set-InflowKind $figs $wide $cfgI $s
        $figs[0].kind | Should -Be 'inflow'
        $s.inflow  | Should -Be 1
        $s.figures | Should -Be 0
    }

    It 'spares a region in whitespace (low coverage)' {
        $wide = @{ 1 = [System.Collections.Generic.List[object]]::new() }
        $wide[1].Add([double[]]@(0, 0, 400, 10))     # backbone line clips only the region bottom
        $figs = & $NewFigI @(50.0, 5.0, 350.0, 105.0) $null
        $s = & $NewSummaryI
        Set-InflowKind $figs $wide $cfgI $s
        $figs[0].kind | Should -Be 'figure'
        $s.inflow | Should -Be 0
    }

    It 'never touches a captioned region (PRIMARY invariant)' {
        $wide = @{ 1 = [System.Collections.Generic.List[object]]::new() }
        $wide[1].Add([double[]]@(0, 0, 400, 30))
        $cap = [ordered]@{ block_id = 9; text = 'Figure 1: bars'; cue = $true }
        $figs = & $NewFigI @(50.0, 5.0, 350.0, 25.0) $cap
        $s = & $NewSummaryI
        Set-InflowKind $figs $wide $cfgI $s
        $figs[0].kind | Should -Be 'figure'
    }

    It 'ignores pages with no backbone blocks' {
        $figs = & $NewFigI @(50.0, 5.0, 350.0, 25.0) $null
        $s = & $NewSummaryI
        Set-InflowKind $figs @{} $cfgI $s
        $figs[0].kind | Should -Be 'figure'
    }
}

Describe 'pdfdig figure-region clustering — narrow-caption overlap denominator' {
    BeforeAll {
        $script:wn = Join-Path ([IO.Path]::GetTempPath()) ('pdfdig-capfix-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $script:wn | Out-Null
        # One WIDE figure (8 boxes in a row, union ~370pt wide) + a NARROW "Fig. 9" caption (19pt wide)
        # fully inside its x-span, just below — the 2205 miss class: ovl/figW ≈ 0.05 (old gate rejects),
        # ovl/min(figW, capW) = 1.0 (fixed gate attaches).
        $paths = [System.Collections.Generic.List[string]]::new()
        $id = 0
        foreach ($k in 0..7) {
            $x = $k * 50
            $paths.Add(('{{"id":{0},"page":1,"bbox":[{1},100,{2},110]}}' -f $id++, $x, ($x + 10)))
        }
        [IO.File]::WriteAllLines((Join-Path $script:wn 'n.paths.jsonl'), $paths)
        $letters = [System.Collections.Generic.List[string]]::new()
        1..40 | ForEach-Object { $letters.Add('{"size":10.0}') }
        [IO.File]::WriteAllLines((Join-Path $script:wn 'n.letters.jsonl'), $letters)
        [IO.File]::WriteAllLines((Join-Path $script:wn 'n.blocks.jsonl'),
            @('{"id":1,"page":1,"bx":[150,80,169,90],"text_preview":"Fig. 9"}'))
        $script:rn = ConvertTo-FigureRegions -PathsJsonl (Join-Path $script:wn 'n.paths.jsonl') -PassThru
    }
    AfterAll { if ($script:wn -and (Test-Path $script:wn)) { Remove-Item -Recurse -Force $script:wn } }

    It 'attaches a narrow caption fully under a wide figure' {
        $fig = @($script:rn.Figures | Where-Object { $_.kind -eq 'figure' })[0]
        $fig.caption      | Should -Not -BeNullOrEmpty
        $fig.caption.text | Should -Match 'Fig\. 9'
        $script:rn.Summary.captioned_figures | Should -Be 1
    }
}
