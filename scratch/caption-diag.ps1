#requires -Version 7.0
# Caption-attachment diagnostic. For a paper, find every caption-CUED Lane-3 block (same cue regex the
# lane uses), classify each as CLAIMED (a figure region attached) or UNCLAIMED, and for each unclaimed
# block diagnose WHY no attachment happened: detection miss (no region near it), kind-skip (only a
# mark/sparse region near it — Add-FigureCaptions only captions kind=figure), or an attachment-geometry
# failure (gap too big / overlap too low / block is ABOVE the figure).
param(
    [Parameter(Mandatory)][string]$Slug,
    [string]$Group = 'compendia/ph-zigzag',
    [double]$MaxGapEm = 4.0, [double]$MinOverlap = 0.25
)
$ErrorActionPreference = 'Stop'
$root = 'D:\aghado01\codex-scientiae\ingestion'
$pig = Get-ChildItem (Join-Path $root "$Group/$Slug/.runs/*/pig/$Slug.figures.jsonl") -EA 0 |
    Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
if (-not $pig) { throw "no pig run for $Slug" }
$dir = $pig.Directory.FullName
$figs   = @(Get-Content (Join-Path $dir "$Slug.figures.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
$blocks = @(Get-Content (Join-Path $dir "$Slug.blocks.jsonl")  | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bx })
$letters= @(Get-Content (Join-Path $dir "$Slug.letters.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.size })
$bodyPt = if ($letters) { ($letters | Group-Object { [math]::Round($_.size,1) } | Sort-Object Count -Desc | Select-Object -First 1).Name } else { 10.0 }
$bodyPt = [double]$bodyPt
$maxGap = $MaxGapEm * $bodyPt

$cue = '(Figure|Fig|Table|Tab|Algorithm|Listing)\.?\s*\d'
# caption-cued blocks (prefix-scan first 14 chars, as the lane does)
$capBlocks = @($blocks | Where-Object {
    $t = if ($_.text_preview) { [string]$_.text_preview } else { '' }
    $t.Substring(0, [math]::Min(14, $t.Length)) -match $cue
})
$claimed = @{}
foreach ($f in $figs) { if ($f.caption) { $claimed[[int]$f.caption.block_id] = $true } }

$figsByPage = @{}
foreach ($f in $figs) { $p=[int]$f.page; if (-not $figsByPage.ContainsKey($p)){$figsByPage[$p]=@()}; $figsByPage[$p]+=$f }

Write-Host ("=== {0}  bodyPt={1}  maxGap={2}pt  |  cue-blocks={3}  claimed={4}  unclaimed={5}  figure-regions={6}" -f `
    $Slug, $bodyPt, $maxGap, $capBlocks.Count, ($capBlocks|Where-Object{$claimed[[int]$_.id]}).Count, ($capBlocks|Where-Object{-not $claimed[[int]$_.id]}).Count, ($figs|Where-Object{$_.kind -eq 'figure'}).Count)

foreach ($c in ($capBlocks | Where-Object { -not $claimed[[int]$_.id] } | Sort-Object page)) {
    $cl=$c.bx[0];$cb=$c.bx[1];$cr=$c.bx[2];$ct=$c.bx[3]
    $txt = ($c.text_preview.Substring(0,[math]::Min(26,$c.text_preview.Length)))
    $pageFigs = @($figsByPage[[int]$c.page])
    $diag = 'DETECTION-MISS (no region on page)'
    $best = $null; $bestScore = -1
    foreach ($f in $pageFigs) {
        $fl=$f.bbox[0];$fb=$f.bbox[1];$fr=$f.bbox[2];$ft=$f.bbox[3]; $fw=$fr-$fl
        if ($fw -le 0) { continue }
        $ovl = ([math]::Min($fr,$cr) - [math]::Max($fl,$cl)) / $fw
        $gapBelow = $fb - $ct     # block below figure
        $gapAbove = $cb - $ft     # block above figure
        $near = [math]::Min([math]::Abs($gapBelow),[math]::Abs($gapAbove))
        $score = $ovl - ($near/1000)
        if ($score -gt $bestScore) { $bestScore=$score; $best=@{f=$f;ovl=$ovl;gb=$gapBelow;ga=$gapAbove} }
    }
    if ($best) {
        $f=$best.f
        $reasons=@()
        if ($f.kind -ne 'figure') { $reasons += "KIND-SKIP($($f.kind))" }
        if ($best.ovl -lt $MinOverlap) { $reasons += ("LOW-OVERLAP({0:N2})" -f $best.ovl) }
        $belowOk = ($best.gb -ge -2 -and $best.gb -le $maxGap)
        $aboveOk = ($best.ga -ge -2 -and $best.ga -le $maxGap)
        if (-not $belowOk -and -not $aboveOk) {
            if ($best.gb -gt $maxGap -and $best.ga -gt $maxGap) { $reasons += ("GAP-TOO-BIG(below={0:N0} above={1:N0} > {2:N0})" -f $best.gb,$best.ga,$maxGap) }
            elseif ($best.gb -lt -2 -and $best.ga -lt -2) { $reasons += "BLOCK-INSIDE/OVERLAP-FIG" }
            else { $reasons += ("GAP(below={0:N0} above={1:N0})" -f $best.gb,$best.ga) }
        }
        if (-not $reasons) { $reasons += ("UNEXPECTED(ovl={0:N2} gb={1:N0} ga={2:N0} kind={3})" -f $best.ovl,$best.gb,$best.ga,$f.kind) }
        $diag = ($reasons -join ' + ')
    }
    Write-Host ("  pg{0,-3} blk{1,-5} '{2}'  ->  {3}" -f $c.page, $c.id, $txt, $diag)
}
