#requires -Version 7
<#
  monster-preagg-calib.ps1 — calibration probe for the MONSTER PATH-CLOUD pre-aggregation guard
  (pdfdig-figures.ps1, figure_regions.preagg). One-off eyeball probe; not a test.

  THE CLASS: 2106.06375v1 p5 carries 536,517 vector paths (a density scatter drawn one path per
  marker); hdbscan.exe rectangle-gap is O(n^2), so the page took 79 min while the next-largest page
  in either battery corpus (20,053 paths) finishes in seconds. The guard: above threshold_paths,
  grid-bin path bboxes into CELL-UNION boxes (bin by bbox center, cell box = union of member
  bboxes), cluster the cells, propagate each cell's label back to its member paths, and run the
  whole downstream pipeline (consensus, captions, splits) on the ORIGINAL items unchanged.

  BASELINE (the 79-min run, .runs/20260715_095954-2): p5 = region id3 "Figure 2" (24 paths,
  bbox 189.44,533.41,422.15,680.11) + region id4 "Figure 3" (536,491 paths, consensus_merged,
  bbox 95.39,182.47,516.34,316.41) + 2 noise paths. Inter-figure gap 217pt.

  PHASE A — threshold knob: time hdbscan.exe on id-prefix subsets of the p5 cloud, fit the
  runtime exponent, extrapolate to the full cloud and to candidate thresholds. The knob should sit
  where an UN-aggregated page still costs only tens of seconds (the battery's real 20k page is the
  known-good reference).

  PHASE B — cell_em knob: for each candidate cell size, bin -> cluster cells -> expand labels ->
  score the expanded partition against the baseline membership sets:
    weld        any expanded cluster containing BOTH Fig2 and Fig3 member paths  (disqualifying)
    fig2/fig3   coverage of each baseline region by its best expanded cluster + contamination
    noise fate  where the 2 baseline-noise paths land (welded into a region vs still noise)
    bbox        union bbox of the expanded best clusters vs the baseline region bboxes
  Fidelity wants small cells; the floor is where cell count stops mattering for perf (~10^3).

  ITERATION RECORD
    v1 2026-07-15 — Phase A: k=2.0 measured (10k=1.7s / 20k=5.9s / 40k=26.8s); extrapolation
      reproduces the observed monster (536k -> 4844s ≈ the 79 min) and prices the knob:
      max_points 50000 -> worst unguarded page ~42s, battery max (20,053) ~6s untouched.
    v1 Phase B: cell_em 0.25 / 0.5 / 1.0 / 2.0 ALL yield the identical expanded partition
      (fig2 24/24, fig3 536491/536491, no weld; 2022 / 576 / 197 / 80 cells, hdbscan <=0.3s).
      One baseline-noise stray (id 67, a text-band stroke at y=416) joins the fig3 CLUSTER at
      cell level (EOM at 197-576 points absorbs the remote singleton cell) and id 66 rides in
      via stream chain-union — the SAME weld the baseline had pre-eject: the baseline region
      excludes both because C′ STRAY-EJECT trimmed them (bbox top 416.02 -> 316.41). VERDICT:
      the guard must keep the eject alive at CELL granularity (tree rows = cells, Keys[row] =
      member-key list, region rows deduped) — skipping eject on aggregated pages re-inflates
      the crop by ~100pt. Locked: max_points 50000, cell_em 0.5 (half the eject contact floor
      floor_em 1.0; far under t_far_em 4 / stream_jump_em 6). End-to-end verification = full
      2106.06375v1 lane run diffed against the 79-min baseline figures.jsonl (only expected
      diff: '+preagg' flags on p5 regions), plus the old-vs-new byte-diff gate on both battery
      corpora.
#>
param(
    [string]   $RunDir = 'D:\aghado01\codex-scientiae\ingestion\gauntlet\kisungyou\2106.06375v1\.runs\20260715_095954-2\pig',
    [string]   $Slug   = '2106.06375v1',
    [int]      $Page   = 5,
    [double]   $BodyPt = 10.9,
    [double[]] $CellEms = @(0.25, 0.5, 1.0, 2.0),
    [int[]]    $RawTimingSizes = @(10000, 20000, 40000),
    [switch]   $SkipRawTiming
)
$ErrorActionPreference = 'Stop'
# pdfdig-figures.ps1 defines Read-PartitionLabels and dot-sources Invoke-Hdbscan; nothing executes.
. (Join-Path $PSScriptRoot '../src/pdf-converter/pdfdig-figures.ps1')

# hdbscan params exactly as the lane runs them (classify-config.json figure_regions)
$cfg = (Get-Content (Join-Path $PSScriptRoot '../src/pdf-converter/stores/classify-config.json') -Raw | ConvertFrom-Json).figure_regions
$hdbBase = @{ DistanceMetric = [string]$cfg.metric; MinPts = [int]$cfg.min_pts; MinClusterSize = [int]$cfg.min_cluster_size }
if (-not [bool]$cfg.allow_single_cluster) { $hdbBase.NoAllowSingleCluster = $true }

$work = Join-Path ([IO.Path]::GetTempPath()) ("preagg-calib-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force -Path $work | Out-Null

function Invoke-TimedHdbscan([string] $PtsFile, [string] $OutDir) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    Invoke-Hdbscan @script:hdbBase -In $PtsFile -OutDir $OutDir | Out-Null
    $sw.Stop()
    $sw.Elapsed.TotalSeconds
}

try {
    # ---- load page items (id, bbox) from the paths lane — streaming, no per-line ConvertFrom-Json ----
    $t0 = [System.Diagnostics.Stopwatch]::StartNew()
    $ids = [System.Collections.Generic.List[int]]::new()
    $boxes = [System.Collections.Generic.List[double[]]]::new()
    $pageNeedle = '"page":' + $Page + ','
    $bboxRe = [regex]'"id":(\d+),.*"bbox":\[([^\]]+)\]'
    foreach ($line in [IO.File]::ReadLines((Join-Path $RunDir "$Slug.paths.jsonl"))) {
        if (-not $line.Contains($pageNeedle)) { continue }
        $m = $bboxRe.Match($line)
        if (-not $m.Success) { continue }   # null bbox — the lane skips these too
        $parts = $m.Groups[2].Value.Split(',')
        $ids.Add([int]$m.Groups[1].Value)
        $boxes.Add([double[]]@([double]$parts[0], [double]$parts[1], [double]$parts[2], [double]$parts[3]))
    }
    $n = $ids.Count
    "loaded p$Page`: $n paths in $([math]::Round($t0.Elapsed.TotalSeconds,1))s"

    # ---- baseline membership sets from the 79-min run's figures.jsonl ----
    $fig2 = [System.Collections.Generic.HashSet[int]]::new()
    $fig3 = [System.Collections.Generic.HashSet[int]]::new()
    $fig2Bbox = $null; $fig3Bbox = $null
    foreach ($line in [IO.File]::ReadLines((Join-Path $RunDir "$Slug.figures.jsonl"))) {
        if (-not $line.Contains('"page":' + $Page + ',')) { continue }
        $r = $line | ConvertFrom-Json
        if ($r.kind -ne 'figure') { continue }
        if ([int]$r.path_count -gt 1000) { foreach ($mid in $r.path_ids) { [void]$fig3.Add([int]$mid) }; $fig3Bbox = [double[]]@($r.bbox) }
        else                             { foreach ($mid in $r.path_ids) { [void]$fig2.Add([int]$mid) }; $fig2Bbox = [double[]]@($r.bbox) }
    }
    $noiseIds = [System.Collections.Generic.List[int]]::new()
    foreach ($id in $ids) { if (-not $fig2.Contains($id) -and -not $fig3.Contains($id)) { $noiseIds.Add($id) } }
    "baseline: fig2=$($fig2.Count) fig3=$($fig3.Count) noise=$($noiseIds.Count) (noise ids: $($noiseIds -join ', '))"

    # ---- PHASE A: raw hdbscan timing on id-prefix subsets -> runtime exponent + threshold table ----
    if (-not $SkipRawTiming) {
        ''
        '== PHASE A: raw hdbscan runtime scaling =='
        $sizes = [System.Collections.Generic.List[int]]::new()
        $times = [System.Collections.Generic.List[double]]::new()
        foreach ($sz in $RawTimingSizes) {
            if ($sz -gt $n) { continue }
            $pts = [System.Collections.Generic.List[string]]::new($sz)
            for ($i = 0; $i -lt $sz; $i++) {
                $b = $boxes[$i]
                $pts.Add(('{{"id":{0},"v":[{1},{2},{3},{4}]}}' -f $ids[$i], $b[0], $b[1], $b[2], $b[3]))
            }
            $f = Join-Path $work "raw$sz.jsonl"
            [IO.File]::WriteAllLines($f, $pts)
            $sec = Invoke-TimedHdbscan $f (Join-Path $work "raw$sz.out")
            "  n=$sz  ->  $([math]::Round($sec,1))s"
            $sizes.Add($sz); $times.Add($sec)
        }
        if ($sizes.Count -ge 2) {
            $k = [math]::Log($times[$times.Count - 1] / $times[0]) / [math]::Log($sizes[$sizes.Count - 1] / [double]$sizes[0])
            $c = $times[$times.Count - 1] / [math]::Pow($sizes[$sizes.Count - 1], $k)
            "  fitted exponent k=$([math]::Round($k,2))  (t = c*n^k)"
            foreach ($probe in @(50000, 100000, $n)) {
                "  extrapolated t(n=$probe) = $([math]::Round($c * [math]::Pow($probe, $k), 0))s"
            }
        }
    }

    # ---- PHASE B: grid-bin cells -> cluster -> expand -> score against baseline ----
    ''
    '== PHASE B: cell-size calibration =='
    foreach ($em in $CellEms) {
        $cellPt = $em * $BodyPt
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $cellOf = [System.Collections.Generic.Dictionary[long, int]]::new()
        $aggBox = [System.Collections.Generic.List[double[]]]::new()
        $memberAgg = [int[]]::new($n)
        for ($i = 0; $i -lt $n; $i++) {
            $b = $boxes[$i]
            $cx = [long][math]::Floor((($b[0] + $b[2]) / 2.0) / $cellPt)
            $cy = [long][math]::Floor((($b[1] + $b[3]) / 2.0) / $cellPt)
            $key = ($cx -shl 24) -bor ($cy -band 0xFFFFFF)
            $ai = 0
            if (-not $cellOf.TryGetValue($key, [ref]$ai)) {
                $ai = $aggBox.Count
                $cellOf[$key] = $ai
                $aggBox.Add([double[]]@($b[0], $b[1], $b[2], $b[3]))
            }
            else {
                $u = $aggBox[$ai]
                if ($b[0] -lt $u[0]) { $u[0] = $b[0] }
                if ($b[1] -lt $u[1]) { $u[1] = $b[1] }
                if ($b[2] -gt $u[2]) { $u[2] = $b[2] }
                if ($b[3] -gt $u[3]) { $u[3] = $b[3] }
            }
            $memberAgg[$i] = $ai
        }
        $binSec = $sw.Elapsed.TotalSeconds
        $pts = [System.Collections.Generic.List[string]]::new($aggBox.Count)
        for ($a = 0; $a -lt $aggBox.Count; $a++) {
            $u = $aggBox[$a]
            $pts.Add(('{{"id":{0},"v":[{1},{2},{3},{4}]}}' -f $a, $u[0], $u[1], $u[2], $u[3]))
        }
        $f = Join-Path $work ("cell{0}.jsonl" -f $em)
        [IO.File]::WriteAllLines($f, $pts)
        $outDir = Join-Path $work ("cell{0}.out" -f $em)
        $sec = Invoke-TimedHdbscan $f $outDir
        $aggLabels = Read-PartitionLabels (Join-Path $outDir 'hdbscan_partition.csv')
        if ($aggLabels.Count -ne $aggBox.Count) { throw "cell $em`: labels $($aggLabels.Count) != cells $($aggBox.Count)" }

        # expand + score: per expanded cluster, membership vs the baseline sets
        $stat = @{}   # label -> int[3] (fig2, fig3, noise)
        for ($i = 0; $i -lt $n; $i++) {
            $lab = $aggLabels[$memberAgg[$i]]
            if (-not $stat.ContainsKey($lab)) { $stat[$lab] = [int[]]::new(3) }
            $s = $stat[$lab]
            if ($fig2.Contains($ids[$i])) { $s[0]++ } elseif ($fig3.Contains($ids[$i])) { $s[1]++ } else { $s[2]++ }
        }
        "  cell_em=$em (${cellPt}pt): cells=$($aggBox.Count) bin=$([math]::Round($binSec,1))s hdbscan=$([math]::Round($sec,1))s clusters=$(@($stat.Keys | Where-Object { $_ -ge 0 }).Count)"
        $weld = $false
        foreach ($kv in ($stat.GetEnumerator() | Sort-Object { [int]$_.Key })) {
            $s = $kv.Value
            if ([int]$kv.Key -ge 0 -and $s[0] -gt 0 -and $s[1] -gt 0) { $weld = $true }
            "    label $($kv.Key): fig2=$($s[0]) fig3=$($s[1]) noise=$($s[2])"
        }
        # union bbox of the expanded cluster that best covers each baseline region
        foreach ($which in @(@('fig2', $fig2, $fig2Bbox), @('fig3', $fig3, $fig3Bbox))) {
            $name = $which[0]; $set = $which[1]; $base = $which[2]
            $bestLab = $null; $bestCov = -1
            foreach ($kv in $stat.GetEnumerator()) {
                if ([int]$kv.Key -lt 0) { continue }
                $cov = if ($name -eq 'fig2') { $kv.Value[0] } else { $kv.Value[1] }
                if ($cov -gt $bestCov) { $bestCov = $cov; $bestLab = [int]$kv.Key }
            }
            if ($null -eq $bestLab) { "    $name`: NO covering cluster"; continue }
            $minX = [double]::MaxValue; $minY = [double]::MaxValue; $maxX = [double]::MinValue; $maxY = [double]::MinValue
            for ($i = 0; $i -lt $n; $i++) {
                if ($aggLabels[$memberAgg[$i]] -ne $bestLab) { continue }
                $b = $boxes[$i]
                if ($b[0] -lt $minX) { $minX = $b[0] }; if ($b[1] -lt $minY) { $minY = $b[1] }
                if ($b[2] -gt $maxX) { $maxX = $b[2] }; if ($b[3] -gt $maxY) { $maxY = $b[3] }
            }
            $d = [math]::Max([math]::Max([math]::Abs($minX - $base[0]), [math]::Abs($minY - $base[1])),
                             [math]::Max([math]::Abs($maxX - $base[2]), [math]::Abs($maxY - $base[3])))
            "    $name`: best label $bestLab cov=$bestCov/$($set.Count) bbox=[$([math]::Round($minX,2)),$([math]::Round($minY,2)),$([math]::Round($maxX,2)),$([math]::Round($maxY,2))] maxEdgeDelta=$([math]::Round($d,2))pt"
        }
        "    verdict: $(if ($weld) { 'WELD — disqualified' } else { 'no fig2/fig3 weld' })"
    }
}
finally {
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}
