#requires -Version 7
<#
  probes/inflow-calib.ps1 — T3-lite "in-flow veto" calibration (round-2 SECONDARY work).

  Conjecture: display-math clusters / equation ink live INSIDE the text-column flow (their bboxes are
  substantially covered by WIDE Lane-3 blocks — body/equation lines), while real floats and display
  diagrams live in whitespace the text flows around. For every UNCAPTIONED kind=figure region:

    cov%    fraction of the region bbox area overlapped by WIDE blocks (width >= wide_em)
    nwide   how many wide blocks overlap it
    crop    the region's PNG (for eyeball labeling)

  Run on the target population (voroninski: oracle inline=0, so every uncaptioned region is a
  false positive) AND the negative control (ph-zigzag: real inline diagrams that must NOT trip).

    pwsh -File probes/inflow-calib.ps1
#>
[CmdletBinding()]
param(
    [double] $WideEm = 20.0
)

. "$PSScriptRoot/../src/runs.ps1"

$root = (Resolve-Path (Join-Path $PSScriptRoot '../ingestion')).Path
$sets = @(
    @{ group = 'gauntlet/voroninski';  slugs = @('2008.10579v1', '1506.01437v2', '1309.7669v1', '1209.4785v1', '1602.04426v2') },
    @{ group = 'gauntlet/ph-zigzag'; slugs = @('2210.00916', '2403.08110v4', '2112.02352') }
)

foreach ($set in $sets) {
    foreach ($slug in $set.slugs) {
        $paperDir = Join-Path (Join-Path $root $set.group) $slug
        $pig = @(Get-PigRunDirs $paperDir $slug)[0]
        if (-not $pig) { Write-Warning "no pig run: $slug"; continue }

        $counts = @{}
        foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.letters.jsonl"))) {
            $m = [regex]::Match($line, '"size":\s*([0-9.]+)')
            if ($m.Success) { $s = [math]::Round([double]$m.Groups[1].Value, 1); $counts[$s] = (($counts[$s]) ?? 0) + 1 }
        }
        $bp = [double](($counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key ?? 10.0)
        $widePt = $WideEm * $bp

        $wideByPage = @{}
        foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.blocks.jsonl"))) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $bk = $line | ConvertFrom-Json
            if (-not $bk.bx -or ($bk.bx[2] - $bk.bx[0]) -lt $widePt) { continue }
            $p = [int]$bk.page
            if (-not $wideByPage.ContainsKey($p)) { $wideByPage[$p] = [System.Collections.Generic.List[object]]::new() }
            $wideByPage[$p].Add([double[]]@($bk.bx))
        }
        $cropOf = @{}
        $imgManifest = Join-Path $pig 'images.jsonl'
        if (Test-Path $imgManifest) {
            foreach ($line in [System.IO.File]::ReadLines($imgManifest)) {
                $r = $line | ConvertFrom-Json
                $cropOf[[int]$r.figure_id] = [string]$r.png
            }
        }

        Write-Host ("`n== {0} / {1} ==" -f $set.group, $slug)
        foreach ($line in [System.IO.File]::ReadLines((Join-Path $pig "$slug.figures.jsonl"))) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $f = $line | ConvertFrom-Json
            if ($f.kind -ne 'figure' -or $f.caption) { continue }
            $fx0 = [double]$f.bbox[0]; $fy0 = [double]$f.bbox[1]; $fx1 = [double]$f.bbox[2]; $fy1 = [double]$f.bbox[3]
            $fArea = ($fx1 - $fx0) * ($fy1 - $fy0)
            $cov = 0.0; $nw = 0
            foreach ($wb in @($wideByPage[[int]$f.page])) {
                if ($null -eq $wb) { continue }
                $ix = [math]::Min($fx1, $wb[2]) - [math]::Max($fx0, $wb[0])
                $iy = [math]::Min($fy1, $wb[3]) - [math]::Max($fy0, $wb[1])
                if ($ix -gt 0 -and $iy -gt 0) { $cov += $ix * $iy; $nw++ }
            }
            $covPct = if ($fArea -gt 0) { [math]::Round(100 * $cov / $fArea) } else { 0 }
            Write-Host ("  id={0,-3} pg{1,-3} area={2,7} prov={3,-7} cov={4,3}% nwide={5,2}  {6}" -f `
                $f.id, $f.page, $f.area_em2, $f.provenance, $covPct, $nw, ($cropOf[[int]$f.id] ?? '-'))
        }
    }
}
