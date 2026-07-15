#requires -Version 7
<#
  scratch/furniture-calib.ps1 — topological-prior T1 calibration probe (issues/clustering/topological-prior.md).

  For every UNCAPTIONED kind=figure region in a paper's newest pig run, compute the candidate
  furniture-vs-diagram features and print them beside the region's crop path (for eyeball labeling):

    k          member (path) count
    thin%      members rule-tagged OR with min-extent <= 2pt (stroke-thin)
    areal%     members with BOTH extents > 4pt (2-D ink: boxes, blobs, filled heads)
    b1@r       cycle rank |E|-|V|+|C| of the member proximity graph at radius r em
               (edges = member pairs with rectangle-gap <= r); diagrams have circuits,
               overline/underbrace furniture is topologically trivial
    aspect     region bbox max/min extent ratio
    h_em       region bbox height in em

    pwsh -File scratch/furniture-calib.ps1 -Papers 2210.00916,2403.08110v4   # (via -Command for arrays)
#>
[CmdletBinding()]
param(
    [string]   $Group = 'gauntlet/ph-zigzag',
    [string[]] $Papers = @('2210.00916', '2403.08110v4', '2111.15058v3'),
    [int]      $MaxMembers = 200
)

. "$PSScriptRoot/../src/runs.ps1"

function Get-RectGap([double[]] $a, [double[]] $b) {
    $gx = [math]::Max($b[0] - $a[2], $a[0] - $b[2]); if ($gx -lt 0) { $gx = 0 }
    $gy = [math]::Max($b[1] - $a[3], $a[1] - $b[3]); if ($gy -lt 0) { $gy = 0 }
    [math]::Sqrt($gx * $gx + $gy * $gy)
}

$root = (Resolve-Path (Join-Path $PSScriptRoot '../ingestion')).Path

foreach ($slug in $Papers) {
    $paperDir = Join-Path (Join-Path $root $Group) $slug
    $pig = @(Get-PigRunDirs $paperDir $slug)[0]
    if (-not $pig) { Write-Warning "no pig run: $slug"; continue }

    # body pt (modal letter size)
    $counts = @{}
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.letters.jsonl"))) {
        $m = [regex]::Match($line, '"size":\s*([0-9.]+)')
        if ($m.Success) { $s = [math]::Round([double]$m.Groups[1].Value, 1); $counts[$s] = (($counts[$s]) ?? 0) + 1 }
    }
    $bp = [double](($counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key ?? 10.0)

    $pathRec = [System.Collections.Generic.Dictionary[int, object]]::new()
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.paths.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $p = $line | ConvertFrom-Json
        if ($p.bbox) { $pathRec[[int]$p.id] = $p }
    }
    $cropOf = @{}
    $imgManifest = Join-Path $pig 'images.jsonl'
    if (Test-Path $imgManifest) {
        foreach ($line in [System.IO.File]::ReadLines($imgManifest)) {
            $r = $line | ConvertFrom-Json
            $cropOf[[int]$r.figure_id] = [string]$r.png
        }
    }

    Write-Host ("`n== {0}  (body {1}pt) ==" -f $slug, $bp)
    Write-Host ("{0,4} {1,4} {2,8} {3,4} {4,6} {5,7} {6,6} {7,6} {8,7} {9,6}  {10}" -f `
        'id', 'pg', 'area_em2', 'k', 'thin%', 'areal%', 'b1@1', 'b1@2', 'aspect', 'h_em', 'crop')
    foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.figures.jsonl"))) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $f = $line | ConvertFrom-Json
        if ($f.kind -ne 'figure' -or $f.caption -or $f.xobject_count -gt 0) { continue }
        $ids = @($f.path_ids)
        $k = $ids.Count
        if ($k -eq 0 -or $k -gt $MaxMembers) { continue }
        $bx = [object[]]::new($k)
        $thin = 0; $areal = 0
        for ($i = 0; $i -lt $k; $i++) {
            $p = $pathRec[[int]$ids[$i]]
            $b = [double[]]@($p.bbox); $bx[$i] = $b
            $w = $b[2] - $b[0]; $h = $b[3] - $b[1]
            if ($p.rule -or [math]::Min($w, $h) -le 2.0) { $thin++ }
            if ([math]::Min($w, $h) -gt 4.0) { $areal++ }
        }
        # cycle rank at r em: b1 = E - (V - C)
        $b1 = @{}
        foreach ($rEm in 1.0, 2.0) {
            $rPt = $rEm * $bp
            $parent = [int[]]::new($k); for ($i = 0; $i -lt $k; $i++) { $parent[$i] = $i }
            $E = 0; $comps = $k
            for ($i = 0; $i -lt $k; $i++) {
                for ($j = $i + 1; $j -lt $k; $j++) {
                    if ((Get-RectGap $bx[$i] $bx[$j]) -le $rPt) {
                        $E++
                        $ri = $i; while ($parent[$ri] -ne $ri) { $parent[$ri] = $parent[$parent[$ri]]; $ri = $parent[$ri] }
                        $rj = $j; while ($parent[$rj] -ne $rj) { $parent[$rj] = $parent[$parent[$rj]]; $rj = $parent[$rj] }
                        if ($ri -ne $rj) { $parent[$rj] = $ri; $comps-- }
                    }
                }
            }
            $b1[$rEm] = $E - ($k - $comps)
        }
        $w = $f.bbox[2] - $f.bbox[0]; $h = $f.bbox[3] - $f.bbox[1]
        $aspect = if ([math]::Min($w, $h) -gt 0) { [math]::Round([math]::Max($w, $h) / [math]::Min($w, $h), 1) } else { 999 }
        Write-Host ("{0,4} {1,4} {2,8} {3,4} {4,6} {5,7} {6,6} {7,6} {8,7} {9,6}  {10}" -f `
            $f.id, $f.page, $f.area_em2, $k, [math]::Round(100 * $thin / $k), [math]::Round(100 * $areal / $k), `
            $b1[1.0], $b1[2.0], $aspect, [math]::Round($h / $bp, 1), ($cropOf[[int]$f.id] ?? '-'))
    }
}
