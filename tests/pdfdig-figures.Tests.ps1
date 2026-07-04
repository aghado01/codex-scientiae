#requires -Version 7
# Figure-region clustering (src/pdf-converter/pdfdig-figures.ps1): a synthetic paths.jsonl —
# two well-spaced figures + a stray rule on one page, a tiny marker cluster on another —
# exercises the whole path: per-page rectangle-gap clustering via hdbscan.exe, kind tagging,
# noise fallout. Fixture is self-contained (does not depend on the git-ignored inbox corpus).

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
    # Page 2: four tiny boxes forming one small marker cluster (union area well under 200 pt^2).
    foreach ($m in @(@(293, 279), @(296, 279), @(293, 283), @(296, 283))) {
        $rows.Add(('{{"id":{0},"page":2,"bbox":[{1},{2},{3},{4}]}}' -f $id++, $m[0], $m[1], ($m[0] + 2), ($m[1] + 2)))
    }
    $pathsFile = Join-Path $work 'synth.paths.jsonl'
    [IO.File]::WriteAllLines($pathsFile, $rows)

    $result = ConvertTo-FigureRegions -PathsJsonl $pathsFile -PassThru
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

    It 'tags a tiny marker cluster as kind=mark, keeping it (nothing dropped)' {
        $p2 = @($result.Figures | Where-Object { $_.page -eq 2 })
        $p2.Count       | Should -Be 1
        $p2[0].kind     | Should -Be 'mark'
        $p2[0].area     | Should -BeLessThan 200
    }

    It 'emits {slug}.figures.jsonl beside the paths lane' {
        $result.OutPath | Should -Match 'synth\.figures\.jsonl$'
        Test-Path $result.OutPath | Should -BeTrue
    }

    It 'writes well-formed region records (bbox/area/kind/path_ids)' {
        $rec = Get-Content $result.OutPath -TotalCount 1 | ConvertFrom-Json
        $rec.PSObject.Properties.Name | Should -Contain 'bbox'
        $rec.PSObject.Properties.Name | Should -Contain 'area'
        $rec.PSObject.Properties.Name | Should -Contain 'kind'
        $rec.PSObject.Properties.Name | Should -Contain 'path_ids'
        $rec.bbox.Count | Should -Be 4
    }
}
