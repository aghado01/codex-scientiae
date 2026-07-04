#requires -Version 7
# End-to-end regression gate for hdbscan.exe: drives the CLI (via the Invoke-Hdbscan
# wrapper) on labelled/unlabelled fixtures and asserts summary.json's evaluator_scores.
# Pairs with the C# unit harness in tests/hdbscan/Program.cs, which pins the evaluator
# math itself against hand-derived / sklearn-verified values.

BeforeAll {
    $repo = Split-Path $PSScriptRoot -Parent
    . (Join-Path $repo 'src/hdbscan/Invoke-Hdbscan.ps1')

    $work = Join-Path ([IO.Path]::GetTempPath()) ("hdbscan-tests-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    # Three cleanly-separated 2-D blobs with a species label → labelled CSV.
    $rng = [System.Random]::new(20260703)
    $centers = @(@(0.0, 0.0, 'alpha'), @(20.0, 0.0, 'beta'), @(10.0, 20.0, 'gamma'))
    $csv = [System.Collections.Generic.List[string]]::new()
    $csv.Add('x,y,species')
    foreach ($c in $centers) {
        for ($i = 0; $i -lt 8; $i++) {
            $x = [double]$c[0] + ($rng.NextDouble() - 0.5)
            $y = [double]$c[1] + ($rng.NextDouble() - 0.5)
            $csv.Add(('{0},{1},{2}' -f $x, $y, $c[2]))
        }
    }
    $labelledCsv = Join-Path $work 'blobs.csv'
    [IO.File]::WriteAllLines($labelledCsv, $csv)

    # Same points, no labels → JSONL.
    $jsonl = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $csv[1..($csv.Count - 1)]) {
        $p = $line.Split(',')
        $jsonl.Add(('{{"v":[{0},{1}]}}' -f $p[0], $p[1]))
    }
    $unlabelledJsonl = Join-Path $work 'blobs.jsonl'
    [IO.File]::WriteAllLines($unlabelledJsonl, $jsonl)

    # Rectangle-gap fixture: two dense box-figures + 3 isolated stray rules (v = [x0,y0,x1,y1]).
    $rects = [System.Collections.Generic.List[string]]::new()
    foreach ($xoff in @(0, 100)) {
        for ($gx = 0; $gx -lt 4; $gx++) {
            for ($gy = 0; $gy -lt 3; $gy++) {
                $x0 = $xoff + $gx * 10; $y0 = $gy * 10
                $rects.Add(('{{"v":[{0},{1},{2},{3}]}}' -f $x0, $y0, ($x0 + 6), ($y0 + 6)))
            }
        }
    }
    $rects.Add('{"v":[0,300,140,301]}')
    $rects.Add('{"v":[0,-100,140,-99]}')
    $rects.Add('{"v":[400,0,410,6]}')
    $boxesJsonl = Join-Path $work 'boxes.jsonl'
    [IO.File]::WriteAllLines($boxesJsonl, $rects)
}

AfterAll {
    if ($work -and (Test-Path $work)) { Remove-Item -Recurse -Force $work }
}

Describe 'hdbscan CLI end-to-end' {
    It 'clusters 3 labelled blobs with perfect evaluator scores' {
        $o = Join-Path $work 'out-labelled'
        Invoke-Hdbscan -In $labelledCsv -OutDir $o -LabelColumn species -MinPts 3 | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.result.cluster_count | Should -Be 3
        $sum.result.noise_count | Should -Be 0
        $sum.result.evaluator_scores.ari          | Should -Be 1
        $sum.result.evaluator_scores.nmi          | Should -Be 1
        $sum.result.evaluator_scores.homogeneity  | Should -Be 1
        $sum.result.evaluator_scores.completeness | Should -Be 1
        $sum.result.evaluator_scores.v_measure    | Should -Be 1
        $sum.result.evaluator_scores.purity       | Should -Be 1
        $sum.reference_labels | Should -Be 'label-column:species'
    }

    It 'omits evaluator_scores for unlabelled input' {
        $o = Join-Path $work 'out-unlabelled'
        Invoke-Hdbscan -In $unlabelledJsonl -OutDir $o -MinPts 3 | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.result.evaluator_scores | Should -BeNullOrEmpty
        $sum.reference_labels | Should -BeNullOrEmpty
    }

    It 'is deterministic (byte-identical partition across runs)' {
        $o1 = Join-Path $work 'det1'; $o2 = Join-Path $work 'det2'
        Invoke-Hdbscan -In $labelledCsv -OutDir $o1 -LabelColumn species -MinPts 3 | Out-Null
        Invoke-Hdbscan -In $labelledCsv -OutDir $o2 -LabelColumn species -MinPts 3 | Out-Null
        (Get-FileHash (Join-Path $o1 'hdbscan_partition.csv')).Hash |
            Should -Be (Get-FileHash (Join-Path $o2 'hdbscan_partition.csv')).Hash
    }

    It 'dispatches a non-euclidean metric (manhattan) end-to-end' {
        $o = Join-Path $work 'out-manhattan'
        Invoke-Hdbscan -In $labelledCsv -OutDir $o -LabelColumn species -DistanceMetric manhattan -MinPts 3 | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.hdbscan.metric       | Should -Be 'manhattan'
        $sum.result.cluster_count | Should -Be 3
        $sum.result.evaluator_scores.ari | Should -Be 1
    }

    It 'rectangle-gap segments figures and drops stray rules as noise' {
        $o = Join-Path $work 'out-rects'
        Invoke-Hdbscan -In $boxesJsonl -OutDir $o -DistanceMetric rectangle-gap -MinPts 3 -NoAllowSingleCluster | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.hdbscan.metric       | Should -Be 'rectangle-gap'
        $sum.result.cluster_count | Should -Be 2
        $sum.result.noise_count   | Should -Be 3
    }

    It 'fails loudly on an unknown metric' {
        # -LabelColumn species so the CSV parses and dispatch reaches the metric switch
        # (otherwise it would throw earlier on 'alpha' as a feature).
        $o = Join-Path $work 'out-bad'
        { Invoke-Hdbscan -In $labelledCsv -OutDir $o -LabelColumn species -DistanceMetric not-a-metric -MinPts 3 } |
            Should -Throw
    }
}
