#requires -Version 7
<#
  scratch/caption-bootstrap-calib.ps1 — V_caption interior-split NO-STYLE BOOTSTRAP calibration.

  Split-CaptionInteriorRegions bails when a paper has 0 pass-1 claimed captions (styles empty), so a
  figure whose ONLY caption is the interior weld it needs (1705.07576v3 Figure 1: the plot's 44 paths
  sit above the caption, the region only dips below it on 2 degenerate bitmap points) is never split.

  BOOTSTRAP: when no per-paper style is learnable, accept a split ONLY from a self-evident cue-then-
  SEPARATOR interior caption ("Figure 1:" / "Figure 1.") — the separator is the discriminator in-text
  prose lacks (the sep-relaxation already trusts it). This probe replicates that fire condition against
  the EXISTING runs (no converter re-run) so the corpus-wide fire-set can be eyeballed for false splits
  BEFORE the guard is relaxed. Reports, per group:
    - eligible papers (0 pass-1 claimed captions)
    - FIRE rows: an interior separator-caption strictly inside a kind=figure region with overlap>=frac

    pwsh -File scratch/caption-bootstrap-calib.ps1
#>
[CmdletBinding()] param(
    [double]$MarginEm = 1.0, [double]$MinOverlap = 0.25, [double]$MaxBlockSepEm = 9.0
)
. "$PSScriptRoot/../src/runs.ps1"
$root = (Resolve-Path (Join-Path $PSScriptRoot '../ingestion')).Path
# canonical caption-shape prefix + REQUIRED separator group ([:.]) for the bootstrap
$styleRe = [regex]'^[^\p{L}]{0,4}(Figure|Fig)\.?\s*\d+\s*([:.])'

foreach ($group in @('compendia/ph-zigzag', 'corpora/voroninski')) {
    Write-Host ("`n================ {0} ================" -f $group)
    $papers = Get-ChildItem (Join-Path $root $group) -Directory -EA 0 | Sort-Object Name
    foreach ($pd in $papers) {
        $slug = $pd.Name
        $pig = @(Get-PigRunDirs $pd.FullName $slug)[0]
        if (-not $pig) { continue }
        $fj = Join-Path $pig "$slug.figures.jsonl"; $bj = Join-Path $pig "$slug.blocks.jsonl"
        if (-not (Test-Path $fj) -or -not (Test-Path $bj)) { continue }
        $figs = @(Get-Content $fj | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
        $nClaim = @($figs | Where-Object { $_.caption }).Count
        if ($nClaim -gt 0) { continue }                     # not bootstrap-eligible (existing path unchanged)
        # body font = modal letter size
        $counts = @{}
        foreach ($l in [System.IO.File]::ReadLines((Join-Path $pig "$slug.letters.jsonl"))) {
            $m = [regex]::Match($l, '"size":\s*([0-9.]+)'); if ($m.Success) { $s = [math]::Round([double]$m.Groups[1].Value, 1); $counts[$s] = (($counts[$s]) ?? 0) + 1 }
        }
        $bp = [double](($counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key ?? 10.0)
        $marginPt = $MarginEm * $bp; $maxHPt = $MaxBlockSepEm * $bp
        # separator-caption candidate blocks per page
        $sepBlocks = [System.Collections.Generic.List[object]]::new()
        foreach ($l in [System.IO.File]::ReadLines($bj)) {
            if ([string]::IsNullOrWhiteSpace($l)) { continue }
            $b = $l | ConvertFrom-Json; if (-not $b.bx) { continue }
            $t = [string]($b.text ?? $b.text_preview ?? ''); if ($t.Length -eq 0) { continue }
            if (-not $styleRe.IsMatch($t)) { continue }
            if (($b.bx[3] - $b.bx[1]) -gt $maxHPt) { continue }
            $sepBlocks.Add($b)
        }
        $fired = 0
        Write-Host ("  {0,-14} eligible (0 claims)  bodyPt={1}  sep-blocks={2}  figure-regions={3}" -f $slug, $bp, $sepBlocks.Count, @($figs | Where-Object { $_.kind -eq 'figure' }).Count)
        foreach ($fig in ($figs | Where-Object { $_.kind -eq 'figure' })) {
            $figL = [double]$fig.bbox[0]; $figB = [double]$fig.bbox[1]; $figR = [double]$fig.bbox[2]; $figT = [double]$fig.bbox[3]
            foreach ($b in $sepBlocks) {
                if ([int]$b.page -ne [int]$fig.page) { continue }
                if ($b.bx[3] -gt $figT - $marginPt -or $b.bx[1] -lt $figB + $marginPt) { continue }   # strictly interior
                $ovl = [math]::Min($figR, [double]$b.bx[2]) - [math]::Max($figL, [double]$b.bx[0])
                $den = [math]::Min($figR - $figL, [double]$b.bx[2] - [double]$b.bx[0])
                if ($den -le 0 -or ($ovl / $den) -lt $MinOverlap) { continue }
                $fired++
                $pos = [math]::Round(100 * ($b.bx[1] - $figB) / ($figT - $figB))
                $captxt = [string]($b.text ?? $b.text_preview ?? '')
                Write-Host ("    FIRE pg{0,-3} reg{1,-3}({2}) x cap-blk{3,-5} ovl={4:N2} interiorPos={5}%  '{6}'" -f `
                    $b.page, $fig.id, $fig.kind, $b.id, ($ovl / $den), $pos, $captxt.Substring(0, [math]::Min(30, $captxt.Length)))
            }
        }
        if ($fired -eq 0) { Write-Host "    (no fire)" }
    }
}
