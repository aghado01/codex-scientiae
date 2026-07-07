#requires -Version 7.0
# Interior-cut diagnostic (A2b). For a paper, reproduce Split-CaptionInteriorRegions' candidate
# selection (unclaimed cue-then-SEPARATOR blocks that sit interior to a kind=figure region), then for
# each candidate report the MEMBER Y-DISTRIBUTION around the caption midline: how many path/xobject
# members fall above vs below, and whether the midline cut is DEGENERATE (one side empty → the split
# skips it). This is the confirm-the-hypothesis probe for the "caption at the bottom band of a region
# whose ink is all above it" case (Fig 7). Read-only; touches no engine state.
param(
    [Parameter(Mandatory)][string]$Slug,
    [string]$Group = 'corpora/voroninski'
)
$ErrorActionPreference = 'Stop'
$root = 'D:\aghado01\codex-scientiae\ingestion'
$pig = Get-ChildItem (Join-Path $root "$Group/$Slug/.runs/*/pig/$Slug.figures.jsonl") -EA 0 |
    Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
if (-not $pig) { throw "no pig run for $Slug" }
$dir = $pig.Directory.FullName
Write-Host "run: $($pig.Directory.Parent.Name)"

$figs   = @(Get-Content (Join-Path $dir "$Slug.figures.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
$blocks = @(Get-Content (Join-Path $dir "$Slug.blocks.jsonl")  | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bx })
$paths  = @(Get-Content (Join-Path $dir "$Slug.paths.jsonl")   | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })
$xobjs  = @()
$xp = Join-Path $dir "$Slug.xobjects.jsonl"
if (Test-Path $xp) { $xobjs = @(Get-Content $xp | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox }) }
$letters= @(Get-Content (Join-Path $dir "$Slug.letters.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.size })
$bodyPt = if ($letters) { [double]($letters | Group-Object { [math]::Round($_.size,1) } | Sort-Object Count -Desc | Select-Object -First 1).Name } else { 10.0 }

$pathRec = @{}; foreach ($p in $paths) { $pathRec[[int]$p.id] = $p }
$xobjRec = @{}; foreach ($x in $xobjs) { $xobjRec[[int]$x.id] = $x }

# same shape/style regex as the splitter
$styleRe = '^[^\p{L}]{0,4}(Figure|Fig)\.?\s*\d+\s*([:.])?'
$claimed = @{}; foreach ($f in $figs) { if ($f.caption) { $claimed[[int]$f.caption.block_id] = $true } }

# unclaimed cue-then-SEPARATOR blocks (the split candidates), per page
$capBlocks = @($blocks | Where-Object {
    if ($claimed[[int]$_.id]) { return $false }
    $t = [string]($_.text ?? $_.text_preview ?? '')
    $m = [regex]::Match($t, $styleRe)
    $m.Success -and ([string]$m.Groups[2].Value -ne '')
})
Write-Host ("=== {0}  bodyPt={1}  interior-split candidates (unclaimed cue+sep, interior to a fig region):" -f $Slug, $bodyPt)

$marginPt = 1.0 * $bodyPt   # margin_em default 1em
foreach ($blk in ($capBlocks | Sort-Object page)) {
    $bl=$blk.bx[0];$bb=$blk.bx[1];$br=$blk.bx[2];$bt=$blk.bx[3]
    $pageFigs = @($figs | Where-Object { $_.kind -eq 'figure' -and [int]$_.page -eq [int]$blk.page })
    foreach ($fig in $pageFigs) {
        $figL=$fig.bbox[0];$figB=$fig.bbox[1];$figR=$fig.bbox[2];$figT=$fig.bbox[3]
        # strict interiority (both edges inside by margin) + overlap ≥ 0.25 — the split's own gate
        if ($bt -gt $figT - $marginPt -or $bb -lt $figB + $marginPt) { continue }
        $ovl = [math]::Min($figR,$br) - [math]::Max($figL,$bl)
        $den = [math]::Min($figR-$figL, $br-$bl)
        if ($den -le 0 -or ($ovl/$den) -lt 0.25) { continue }

        # reconstitute members, compute center-y distribution vs caption midline
        $mem = [System.Collections.Generic.List[object]]::new()
        foreach ($pid0 in @($fig.path_ids))   { if ($pathRec.ContainsKey([int]$pid0)) { $mem.Add($pathRec[[int]$pid0]) } }
        foreach ($xid0 in @($fig.xobject_ids)) { if ($xobjRec.ContainsKey([int]$xid0)) { $mem.Add($xobjRec[[int]$xid0]) } }
        $mid = ($bb + $bt) / 2.0
        $above = @($mem | Where-Object { (($_.bbox[1]+$_.bbox[3])/2.0) -gt $mid })
        $below = @($mem | Where-Object { (($_.bbox[1]+$_.bbox[3])/2.0) -le $mid })
        $degenerate = ($above.Count -eq 0 -or $below.Count -eq 0)
        # how far below the caption does any member ink reach? (member bbox bottoms)
        $memBottoms = @($mem | ForEach-Object { [double]$_.bbox[1] })
        $minBottom = if ($memBottoms) { ($memBottoms | Measure-Object -Minimum).Minimum } else { $null }
        # below members: how tall / how much ink? report their y-spans
        $belowSpans = @($below | ForEach-Object { "{0:N0}-{1:N0}" -f $_.bbox[1], $_.bbox[3] })
        Write-Host ("  pg{0} blk{1} fig-id{2}  region=({3:N0},{4:N0})-({5:N0},{6:N0}) cap=({7:N0},{8:N0})-({9:N0},{10:N0})" -f `
            $blk.page, $blk.id, $fig.id, $figL,$figB,$figR,$figT, $bl,$bb,$br,$bt)
        Write-Host ("      mid={0:N1}  members={1} (paths={2} xobj={3})  ABOVE={4} BELOW={5}  DEGENERATE={6}  ovl={7:N2}" -f `
            $mid, $mem.Count, @($fig.path_ids).Count, @($fig.xobject_ids).Count, $above.Count, $below.Count, $degenerate, ($ovl/$den))
        Write-Host ("      region-bottom={0:N0}  cap-bottom={1:N0}  cap-top={2:N0}  interiority-slack(capB - (figB+margin))={3:N1}" -f `
            $figB, $bb, $bt, ($bb - ($figB + $marginPt)))
        if ($below.Count -gt 0 -and $below.Count -le 12) { Write-Host ("      BELOW-member y-spans: {0}" -f ($belowSpans -join ' ')) }
        # gap if we tried to attach the caption BELOW the region (Add-FigureCaptions 'below' gap)
        Write-Host ("      attach-below gap (figB - capT) = {0:N1}  [needs -2..maxGap to attach]" -f ($figB - $bt))
    }
}
