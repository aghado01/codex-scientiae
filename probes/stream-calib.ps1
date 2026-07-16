#requires -Version 7
<#
  probes/stream-calib.ps1 — consensus-m1 calibration probe (issues/clustering/consensus-milestone1-design.md).

  Measures the SPATIAL JUMP between consecutive-id Lane-4 paths ("pen movement" in content-stream order),
  in em units (gap / body_font_pt), classified against the caption ground truth of the newest pig run:

    inside-cap    both paths in the SAME captioned kind=figure region  -> intra-figure pen steps
    across-cap    paths in TWO DIFFERENT captioned figure regions      -> TRUE float-boundary teleports
                  (two captions = two floats: ground truth, not V_geom opinion)
    inside-uncap  same uncaptioned figure region                       -> intra-diagram steps (V_geom opinion)
    across-fig    different regions, both kind=figure, not both cap    -> boundary OR fragmentation (contaminated)
    other         pairs touching mark/sparse/degenerate/noise members

  Decision outputs: an em-threshold sweep (what fraction of inside-cap pairs would a candidate
  stream_jump_em FALSE-split vs what fraction of across-cap teleports it correctly splits), plus the
  page-spanning-path / is_clipping hazard census (does V_stream need a span guard?).

    pwsh -File probes/stream-calib.ps1                       # ph-zigzag corpus aggregate
    pwsh -File probes/stream-calib.ps1 -Papers 2210.00916    # one paper
#>
[CmdletBinding()]
param(
    [string]   $Group = 'gauntlet/ph-zigzag',
    [string[]] $Papers
)

. "$PSScriptRoot/../src/runs.ps1"

# modal letter size = body font (same estimator as pdfdig-figures.ps1 Get-BodyFontSize, inlined so this
# probe stays standalone)
function Get-BodyPt([string] $LettersJsonl) {
    if (-not (Test-Path -LiteralPath $LettersJsonl)) { return $null }
    $counts = @{}
    foreach ($line in [System.IO.File]::ReadLines($LettersJsonl)) {
        $m = [regex]::Match($line, '"size":\s*([0-9.]+)')
        if ($m.Success) {
            $s = [math]::Round([double]$m.Groups[1].Value, 1)
            $counts[$s] = (($counts[$s]) ?? 0) + 1
        }
    }
    if ($counts.Count -eq 0) { return $null }
    ($counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
}

# rectangle-gap between two [x0,y0,x1,y1] boxes — same form as the engine's RectangleGapMetric
function Get-RectGap([double[]] $a, [double[]] $b) {
    $gx = [math]::Max($b[0] - $a[2], $a[0] - $b[2]); if ($gx -lt 0) { $gx = 0 }
    $gy = [math]::Max($b[1] - $a[3], $a[1] - $b[3]); if ($gy -lt 0) { $gy = 0 }
    [math]::Sqrt($gx * $gx + $gy * $gy)
}

$root     = (Resolve-Path (Join-Path $PSScriptRoot '../ingestion')).Path
$groupDir = Join-Path $root $Group
$paperDirs =
    if ($Papers) { $Papers | ForEach-Object { Join-Path $groupDir $_ } }
    else         { Get-ChildItem -LiteralPath $groupDir -Directory | Sort-Object Name | ForEach-Object FullName }

# per-class gap samples (em) pooled over the corpus
$samples = @{}   # class -> List[double]
foreach ($k in 'inside-cap', 'across-cap', 'inside-uncap', 'across-fig', 'other') {
    $samples[$k] = [System.Collections.Generic.List[double]]::new()
}
$spanTotal = 0; $spanClip = 0; $pathTotal = 0; $clipTotal = 0
$perPaper = [System.Collections.Generic.List[object]]::new()

foreach ($paperDir in $paperDirs) {
    $slug = Split-Path -Leaf $paperDir
    $pigDirs = @(Get-PigRunDirs $paperDir $slug)
    if (-not $pigDirs.Count) { Write-Warning "no pig run: $slug"; continue }
    $pig = $pigDirs[0]

    $bodyPt = Get-BodyPt (Join-Path $pig "$slug.letters.jsonl")
    if (-not $bodyPt) { Write-Warning "no body font: $slug"; continue }

    # page dims for the span census
    $envObj = [System.IO.File]::ReadAllText((Join-Path $pig "$slug.pdfdig.json"), [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
    $pageW = @{}; $pageH = @{}
    foreach ($p in @($envObj.pages)) { $pageW[[int]$p.n] = [double]$p.w; $pageH[[int]$p.n] = [double]$p.h }

    # region membership: path_id -> figures.jsonl record index; kind/captioned per record
    $regOf = [System.Collections.Generic.Dictionary[int, int]]::new()
    $regKind = [System.Collections.Generic.List[string]]::new()
    $regCap  = [System.Collections.Generic.List[bool]]::new()
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.figures.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $r = $line | ConvertFrom-Json
        $idx = $regKind.Count
        $regKind.Add([string]$r.kind)
        $regCap.Add([bool]$r.caption)
        foreach ($pid0 in @($r.path_ids)) { $regOf[[int]$pid0] = $idx }
    }

    # paths, per page, id-sorted (emission IS id order; keep only usable bboxes, as the lane consumer does)
    $byPage = [System.Collections.Generic.Dictionary[int, object]]::new()
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.paths.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $p = $line | ConvertFrom-Json
        $pathTotal++
        if ($p.is_clipping) { $clipTotal++ }
        if (-not $p.bbox) { continue }
        $bx = [double[]]@($p.bbox)
        $pg = [int]$p.page
        $w = $bx[2] - $bx[0]; $h = $bx[3] - $bx[1]
        if ($pageW.ContainsKey($pg) -and $w -ge 0.8 * $pageW[$pg] -and $h -ge 0.8 * $pageH[$pg]) {
            $spanTotal++
            if ($p.is_clipping) { $spanClip++ }
        }
        if (-not $byPage.ContainsKey($pg)) { $byPage[$pg] = [System.Collections.Generic.List[object]]::new() }
        $byPage[$pg].Add(@{ id = [int]$p.id; bx = $bx })
    }

    $nInsideCap = 0; $nAcrossCap = 0
    foreach ($pg in $byPage.Keys) {
        $list = $byPage[$pg]
        # id order == emission order; re-sort defensively. @(...) so a single-path page stays an array
        # (a lone hashtable would int-index to null)
        $arr = @($list.ToArray() | Sort-Object { $_.id })
        for ($i = 1; $i -lt $arr.Count; $i++) {
            $a = $arr[$i - 1]; $b = $arr[$i]
            $gapEm = (Get-RectGap $a.bx $b.bx) / $bodyPt
            $ra = if ($regOf.ContainsKey($a.id)) { $regOf[$a.id] } else { -1 }
            $rb = if ($regOf.ContainsKey($b.id)) { $regOf[$b.id] } else { -1 }
            $class =
                if ($ra -ge 0 -and $ra -eq $rb) {
                    if ($regKind[$ra] -ne 'figure') { 'other' }
                    elseif ($regCap[$ra]) { 'inside-cap' } else { 'inside-uncap' }
                }
                elseif ($ra -ge 0 -and $rb -ge 0 -and $regKind[$ra] -eq 'figure' -and $regKind[$rb] -eq 'figure') {
                    if ($regCap[$ra] -and $regCap[$rb]) { 'across-cap' } else { 'across-fig' }
                }
                else { 'other' }
            $samples[$class].Add($gapEm)
            if ($class -eq 'inside-cap') { $nInsideCap++ } elseif ($class -eq 'across-cap') { $nAcrossCap++ }
        }
    }
    $perPaper.Add([ordered]@{ slug = $slug; body_pt = $bodyPt; inside_cap_pairs = $nInsideCap; across_cap_pairs = $nAcrossCap })
}

# ---- report ------------------------------------------------------------------------------------------
function Get-Quantiles([System.Collections.Generic.List[double]] $xs) {
    if ($xs.Count -eq 0) { return $null }
    $s = $xs.ToArray(); [Array]::Sort($s)
    $q = { param($p) $s[[math]::Min($s.Length - 1, [int][math]::Floor($p * $s.Length))] }
    [ordered]@{
        n = $s.Length; min = [math]::Round($s[0], 2)
        p50 = [math]::Round((& $q 0.50), 2); p90 = [math]::Round((& $q 0.90), 2)
        p95 = [math]::Round((& $q 0.95), 2); p99 = [math]::Round((& $q 0.99), 2)
        max = [math]::Round($s[-1], 2)
    }
}

Write-Host "`n== consecutive-id spatial gaps (em), by caption-ground-truth class =="
foreach ($k in 'inside-cap', 'across-cap', 'inside-uncap', 'across-fig', 'other') {
    $qs = Get-Quantiles $samples[$k]
    if ($null -eq $qs) { Write-Host ("{0,-13} (no samples)" -f $k); continue }
    Write-Host ("{0,-13} n={1,-6} min={2,-6} p50={3,-6} p90={4,-6} p95={5,-6} p99={6,-6} max={7}" -f `
        $k, $qs.n, $qs.min, $qs.p50, $qs.p90, $qs.p95, $qs.p99, $qs.max)
    if ($qs.n -le 30) {
        $raw = $samples[$k].ToArray(); [Array]::Sort($raw)
        Write-Host ("              raw: {0}" -f (($raw | ForEach-Object { [math]::Round($_, 1) }) -join ', '))
    }
}

Write-Host "`n== threshold sweep: candidate em cut vs (inside-cap FALSE-split rate | across-cap caught rate) =="
$insideArr = $samples['inside-cap'].ToArray()
$acrossArr = $samples['across-cap'].ToArray()
foreach ($t in 1.0, 1.5, 2.0, 3.0, 4.0, 6.0, 8.0, 12.0, 16.0, 24.0) {
    $falseSplit = 0; foreach ($g in $insideArr) { if ($g -gt $t) { $falseSplit++ } }
    $caught = 0;     foreach ($g in $acrossArr) { if ($g -gt $t) { $caught++ } }
    $fsPct = if ($insideArr.Length) { [math]::Round(100.0 * $falseSplit / $insideArr.Length, 2) } else { $null }
    $cPct  = if ($acrossArr.Length) { [math]::Round(100.0 * $caught / $acrossArr.Length, 2) } else { $null }
    Write-Host ("  jump > {0,4}em : false-split {1,6}% of inside-cap   catches {2,6}% of across-cap" -f $t, $fsPct, $cPct)
}

Write-Host "`n== page-spanning-path hazard census (bbox >= 0.8 x page on BOTH axes) =="
Write-Host ("  paths total {0}   is_clipping {1} ({2}%)   page-spanning {3}   of which clipping {4}" -f `
    $pathTotal, $clipTotal, [math]::Round(100.0 * $clipTotal / [math]::Max(1, $pathTotal), 1), $spanTotal, $spanClip)

Write-Host "`n== per-paper pair counts =="
foreach ($pp in $perPaper) {
    Write-Host ("  {0,-16} body {1,4}pt   inside-cap {2,-6} across-cap {3}" -f $pp.slug, $pp.body_pt, $pp.inside_cap_pairs, $pp.across_cap_pairs)
}
Write-Host ''
