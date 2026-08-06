#requires -Version 7
# End-to-end regression gate for hdbscan.exe: drives the CLI (via the Invoke-Hdbscan
# wrapper) on labelled/unlabelled fixtures and asserts summary.json's evaluator_scores.
# Pairs with the C# unit harness in tests/hdbscan/Program.cs, which pins the evaluator
# math itself against hand-derived / sklearn-verified values.

BeforeAll {
    $repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $script:HdbscanExecutable = Join-Path $repo 'packages/hdbscan/hdbscan.exe'
    $script:HdbscanExecutableAvailable = Test-Path -LiteralPath $script:HdbscanExecutable -PathType Leaf
    . (Join-Path $repo 'src/hdbscan/Invoke-Hdbscan.ps1')

    $script:HdbscanRetainWork = -not [string]::IsNullOrWhiteSpace(
        $env:CODEX_TEST_ARTIFACT_ROOT)
    if ($script:HdbscanRetainWork -and
        -not [IO.Path]::IsPathFullyQualified($env:CODEX_TEST_ARTIFACT_ROOT)) {
        throw 'CODEX_TEST_ARTIFACT_ROOT must be an absolute path for retained HDBSCAN test evidence'
    }
    $work = if ($script:HdbscanRetainWork) {
        Join-Path ([IO.Path]::GetFullPath($env:CODEX_TEST_ARTIFACT_ROOT)) 'hdbscan-cli'
    }
    else {
        Join-Path ([IO.Path]::GetTempPath()) (
            "hdbscan-tests-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    }
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    # Invoke-Hdbscan intentionally exposes its native CLI. Capture every stream and
    # reset LASTEXITCODE so expected negative probes cannot contaminate the enclosing
    # Pester worker's structured result or process exit status.
    function Invoke-HdbscanTestProcess {
        param(
            [Parameter(Mandatory)] [hashtable] $Parameters,
            [switch] $AllowFailure
        )

        $captured = [System.Collections.Generic.List[object]]::new()
        $failure = $null
        try {
            Invoke-Hdbscan @Parameters *>&1 |
                ForEach-Object { $captured.Add($_) }
        }
        catch { $failure = $_ }

        $exitCode = if ($null -eq $global:LASTEXITCODE) { 0 }
                    else { [int]$global:LASTEXITCODE }
        $global:LASTEXITCODE = 0
        if ($null -ne $failure -and -not $AllowFailure) { throw $failure }

        [pscustomobject]@{
            ExitCode = $exitCode
            Failure = $failure
            Output = $captured.ToArray()
        }
    }

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

    # Banded rectangle-gap fixture (thrust B): two 2x4-box panels whose 2pt inter-panel gap
    # equals every intra-panel gap — plain rectangle-gap sees ONE uniform blob; a 1pt prose
    # band in that gap makes the banded metric split it (2 + lambda*1 crossing cost).
    $panels = [System.Collections.Generic.List[string]]::new()
    foreach ($py in @(0, 6, 12, 18)) {
        foreach ($px in @(0, 7, 14, 21)) {
            $panels.Add(('{{"v":[{0},{1},{2},{3}]}}' -f $px, $py, ($px + 5), ($py + 4)))
        }
    }
    $panelsJsonl = Join-Path $work 'panels.jsonl'
    [IO.File]::WriteAllLines($panelsJsonl, $panels)
    $bandsJsonl = Join-Path $work 'bands.jsonl'
    [IO.File]::WriteAllLines($bandsJsonl, [string[]]@('{"v":[0,10.5,30,11.5]}'))
    $emptyBandsJsonl = Join-Path $work 'bands-empty.jsonl'
    [IO.File]::WriteAllLines($emptyBandsJsonl, [string[]]@())
}

AfterAll {
    $global:LASTEXITCODE = 0
    if (-not $script:HdbscanRetainWork -and $work -and (Test-Path $work)) {
        Remove-Item -Recurse -Force $work
    }
}

Describe 'hdbscan CLI end-to-end' {
    It 'clusters 3 labelled blobs with perfect evaluator scores' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $o = Join-Path $work 'out-labelled'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $labelledCsv; OutDir = $o; LabelColumn = 'species'; MinPts = 3
            RepoRoot = $repo
        } | Out-Null
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
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $o = Join-Path $work 'out-unlabelled'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $unlabelledJsonl; OutDir = $o; MinPts = 3; RepoRoot = $repo
        } | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.result.evaluator_scores | Should -BeNullOrEmpty
        $sum.reference_labels | Should -BeNullOrEmpty
    }

    It 'is deterministic (byte-identical partition across runs)' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $o1 = Join-Path $work 'det1'; $o2 = Join-Path $work 'det2'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $labelledCsv; OutDir = $o1; LabelColumn = 'species'; MinPts = 3
            RepoRoot = $repo
        } | Out-Null
        Invoke-HdbscanTestProcess -Parameters @{
            In = $labelledCsv; OutDir = $o2; LabelColumn = 'species'; MinPts = 3
            RepoRoot = $repo
        } | Out-Null
        (Get-FileHash (Join-Path $o1 'hdbscan_partition.csv')).Hash |
            Should -Be (Get-FileHash (Join-Path $o2 'hdbscan_partition.csv')).Hash
    }

    It 'dispatches a non-euclidean metric (manhattan) end-to-end' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $o = Join-Path $work 'out-manhattan'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $labelledCsv; OutDir = $o; LabelColumn = 'species'
            DistanceMetric = 'manhattan'; MinPts = 3; RepoRoot = $repo
        } | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.hdbscan.metric       | Should -Be 'manhattan'
        $sum.result.cluster_count | Should -Be 3
        $sum.result.evaluator_scores.ari | Should -Be 1
    }

    It 'rectangle-gap segments figures and drops stray rules as noise' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $o = Join-Path $work 'out-rects'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $boxesJsonl; OutDir = $o; DistanceMetric = 'rectangle-gap'
            MinPts = 3; NoAllowSingleCluster = $true; RepoRoot = $repo
        } | Out-Null
        $sum = Get-Content (Join-Path $o 'summary.json') -Raw | ConvertFrom-Json
        $sum.hdbscan.metric       | Should -Be 'rectangle-gap'
        $sum.result.cluster_count | Should -Be 2
        $sum.result.noise_count   | Should -Be 3
    }

    It 'fails loudly on an unknown metric' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        # -LabelColumn species so the CSV parses and dispatch reaches the metric switch
        # (otherwise it would throw earlier on 'alpha' as a feature).
        $o = Join-Path $work 'out-bad'
        $run = Invoke-HdbscanTestProcess -AllowFailure -Parameters @{
            In = $labelledCsv; OutDir = $o; LabelColumn = 'species'
            DistanceMetric = 'not-a-metric'; MinPts = 3; RepoRoot = $repo
        }
        $run.Failure | Should -Not -BeNullOrEmpty
        $run.ExitCode | Should -Not -Be 0
    }

    It 'banded rectangle-gap splits the panel weld its plain sibling cannot see' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $plain = Join-Path $work 'out-panels-plain'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $panelsJsonl; OutDir = $plain; DistanceMetric = 'rectangle-gap'
            MinPts = 3; MinClusterSize = 3; RepoRoot = $repo
        } | Out-Null
        $sumP = Get-Content (Join-Path $plain 'summary.json') -Raw | ConvertFrom-Json
        $sumP.result.cluster_count | Should -Be 1   # geometry-blind: welds across the prose band

        $banded = Join-Path $work 'out-panels-banded'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $panelsJsonl; OutDir = $banded
            DistanceMetric = 'rectangle-gap-banded:lambda=4'; Bands = $bandsJsonl
            MinPts = 3; MinClusterSize = 3; RepoRoot = $repo
        } | Out-Null
        $sumB = Get-Content (Join-Path $banded 'summary.json') -Raw | ConvertFrom-Json
        $sumB.hdbscan.metric       | Should -Be 'rectangle-gap-banded:lambda=4'
        $sumB.result.cluster_count | Should -Be 2   # the band conditions the formation apart
        $sumB.result.noise_count   | Should -Be 0
    }

    It 'banded with an empty bands file degrades exactly to plain rectangle-gap' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $plain = Join-Path $work 'out-panels-degrade-plain'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $panelsJsonl; OutDir = $plain; DistanceMetric = 'rectangle-gap'
            MinPts = 3; MinClusterSize = 3; RepoRoot = $repo
        } | Out-Null
        $o = Join-Path $work 'out-panels-degrade'
        Invoke-HdbscanTestProcess -Parameters @{
            In = $panelsJsonl; OutDir = $o; DistanceMetric = 'rectangle-gap-banded'
            Bands = $emptyBandsJsonl; MinPts = 3; MinClusterSize = 3
            RepoRoot = $repo
        } | Out-Null
        (Get-Content (Join-Path $o 'hdbscan_partition.csv') | Select-Object -Skip 0 | ForEach-Object { ($_ -split ',')[4] }) |
            Should -Be (Get-Content (Join-Path $plain 'hdbscan_partition.csv') | ForEach-Object { ($_ -split ',')[4] })
    }

    It 'banded without --bands fails loudly' {
        if (-not $script:HdbscanExecutableAvailable) {
            Set-ItResult -Skipped -Because "the packaged hdbscan executable is absent at '$script:HdbscanExecutable'; tests never invoke the dotnet build fallback"
            return
        }
        $o = Join-Path $work 'out-panels-nobands'
        $run = Invoke-HdbscanTestProcess -AllowFailure -Parameters @{
            In = $panelsJsonl; OutDir = $o; DistanceMetric = 'rectangle-gap-banded'
            MinPts = 3; RepoRoot = $repo
        }
        $run.Failure | Should -Not -BeNullOrEmpty
        $run.ExitCode | Should -Not -Be 0
    }
}
