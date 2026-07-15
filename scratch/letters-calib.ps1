#requires -Version 7
<#
  scratch/letters-calib.ps1 — V_letters selector calibration (letters-elevation design).

  Question: can "diagram-participant letter blocks" be separated from body-text blocks by SIZE +
  PATH-ENTANGLEMENT alone? For each Lane-3 block, measure width_em + letter count + distance to the
  nearest path bbox on its page, labeled by where the block sits:

    in-fig    block center inside a CAPTIONED kind=figure region bbox   (trusted diagram/figure interior)
    in-unc    block center inside an uncaptioned kind=figure region     (diagram interior, V_geom opinion)
    body      everything else

  Output: per-class distributions of width_em / letters / nearest-path-gap, plus the body-block
  false-pass rate for candidate size cuts (the bridge guard then rides on path proximity).

    pwsh -File scratch/letters-calib.ps1
#>
[CmdletBinding()]
param(
    [string]   $Group = 'gauntlet/ph-zigzag',
    [string[]] $Papers = @('2210.00916', '2403.08110v4', '2111.15058v3')
)

. "$PSScriptRoot/../src/runs.ps1"

function Get-RectGap([double[]] $a, [double[]] $b) {
    $gx = [math]::Max($b[0] - $a[2], $a[0] - $b[2]); if ($gx -lt 0) { $gx = 0 }
    $gy = [math]::Max($b[1] - $a[3], $a[1] - $b[3]); if ($gy -lt 0) { $gy = 0 }
    [math]::Sqrt($gx * $gx + $gy * $gy)
}
function Get-Quantiles([System.Collections.Generic.List[double]] $xs) {
    if ($xs.Count -eq 0) { return $null }
    $s = $xs.ToArray(); [Array]::Sort($s)
    $q = { param($p) $s[[math]::Min($s.Length - 1, [int][math]::Floor($p * $s.Length))] }
    [ordered]@{ n = $s.Length; p10 = [math]::Round((& $q 0.10), 2); p50 = [math]::Round((& $q 0.50), 2)
                p90 = [math]::Round((& $q 0.90), 2); p95 = [math]::Round((& $q 0.95), 2) }
}

$root = (Resolve-Path (Join-Path $PSScriptRoot '../ingestion')).Path
$stats = @{}   # class -> @{ width; letters; gap }
foreach ($k in 'in-fig', 'in-unc', 'body') {
    $stats[$k] = @{ width = [System.Collections.Generic.List[double]]::new()
                    letters = [System.Collections.Generic.List[double]]::new()
                    gap = [System.Collections.Generic.List[double]]::new() }
}
$bodySmall = 0; $bodySmallNearPath = 0; $bodyTotal = 0

foreach ($slug in $Papers) {
    $paperDir = Join-Path (Join-Path $root $Group) $slug
    $pig = @(Get-PigRunDirs $paperDir $slug)[0]
    if (-not $pig) { Write-Warning "no pig run: $slug"; continue }

    $counts = @{}
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.letters.jsonl"))) {
        $m = [regex]::Match($line, '"size":\s*([0-9.]+)')
        if ($m.Success) { $s = [math]::Round([double]$m.Groups[1].Value, 1); $counts[$s] = (($counts[$s]) ?? 0) + 1 }
    }
    $bp = [double](($counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key ?? 10.0)

    # letters per block (block backref)
    $lettersOf = @{}
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.letters.jsonl"))) {
        $m = [regex]::Match($line, '"block":\s*(\d+)')
        if ($m.Success) { $b = [int]$m.Groups[1].Value; $lettersOf[$b] = (($lettersOf[$b]) ?? 0) + 1 }
    }
    # regions by page
    $figsByPage = @{}
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.figures.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $f = $line | ConvertFrom-Json
        if ($f.kind -ne 'figure') { continue }
        $p = [int]$f.page
        if (-not $figsByPage.ContainsKey($p)) { $figsByPage[$p] = [System.Collections.Generic.List[object]]::new() }
        $figsByPage[$p].Add($f)
    }
    # paths by page
    $pathsByPage = @{}
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.paths.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $p = $line | ConvertFrom-Json
        if (-not $p.bbox) { continue }
        $pg = [int]$p.page
        if (-not $pathsByPage.ContainsKey($pg)) { $pathsByPage[$pg] = [System.Collections.Generic.List[object]]::new() }
        $pathsByPage[$pg].Add([double[]]@($p.bbox))
    }

    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.blocks.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $bk = $line | ConvertFrom-Json
        if (-not $bk.bx) { continue }
        $pg = [int]$bk.page
        $bx = [double[]]@($bk.bx)
        $cx = ($bx[0] + $bx[2]) / 2.0; $cy = ($bx[1] + $bx[3]) / 2.0
        $class = 'body'
        foreach ($f in @($figsByPage[$pg])) {
            if ($null -eq $f) { continue }
            if ($cx -ge $f.bbox[0] -and $cx -le $f.bbox[2] -and $cy -ge $f.bbox[1] -and $cy -le $f.bbox[3]) {
                $class = if ($f.caption) { 'in-fig' } else { 'in-unc' }
                break
            }
        }
        $wEm = ($bx[2] - $bx[0]) / $bp
        $nl  = [double](($lettersOf[[int]$bk.id]) ?? 0)
        $gap = [double]::MaxValue
        foreach ($pb in @($pathsByPage[$pg])) {
            if ($null -eq $pb) { continue }
            $g = Get-RectGap $bx $pb
            if ($g -lt $gap) { $gap = $g }
            if ($gap -eq 0) { break }
        }
        $gapEm = if ($gap -eq [double]::MaxValue) { 99 } else { $gap / $bp }
        $stats[$class].width.Add($wEm)
        $stats[$class].letters.Add($nl)
        $stats[$class].gap.Add($gapEm)
        if ($class -eq 'body') {
            $bodyTotal++
            if ($wEm -le 5.0 -and $nl -le 12) {
                $bodySmall++
                if ($gapEm -le 1.5) { $bodySmallNearPath++ }
            }
        }
    }
}

Write-Host "`n== block feature distributions by placement class =="
foreach ($k in 'in-fig', 'in-unc', 'body') {
    $qw = Get-Quantiles $stats[$k].width
    $ql = Get-Quantiles $stats[$k].letters
    $qg = Get-Quantiles $stats[$k].gap
    if ($null -eq $qw) { Write-Host ("{0,-7} (no samples)" -f $k); continue }
    Write-Host ("{0,-7} n={1,-5} width_em p10/p50/p90/p95 = {2}/{3}/{4}/{5}   letters = {6}/{7}/{8}/{9}   nearest-path-gap_em = {10}/{11}/{12}/{13}" -f `
        $k, $qw.n, $qw.p10, $qw.p50, $qw.p90, $qw.p95, $ql.p10, $ql.p50, $ql.p90, $ql.p95, $qg.p10, $qg.p50, $qg.p90, $qg.p95)
}
Write-Host ("`nbody blocks: {0} total; {1} pass the SIZE cut (w<=5em, letters<=12); {2} ALSO sit within 1.5em of a path (the ones only the bridge guard must reject)" -f `
    $bodyTotal, $bodySmall, $bodySmallNearPath)
