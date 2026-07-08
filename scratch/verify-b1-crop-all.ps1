#requires -Version 7.0
# B1 rendered-crop delta over EVERY affected paper (crop-bbox-inflation class a). For each paper that
# has a region gaining visible_bbox, re-run the formation lane, then for each such region replicate the
# images-lane pipeline BOTH ways — OLD = letter-grow(bbox), NEW = letter-grow(Get-FigureCropBbox(bbox,
# visible_bbox)) — and report the actual per-edge crop delta the rasterizer would use. Proves no painted
# ink / node label is clipped. Read-only; no node / no raster.
$ErrorActionPreference = 'Stop'
. 'D:\aghado01\codex-scientiae\src\pdf-converter\pdfdig-figures.ps1'   # ConvertTo-FigureRegions
. 'D:\aghado01\codex-scientiae\src\pdf-converter\pdfdig-images.ps1'    # Get-FigureCropBbox

$papers = @(
    'D:\aghado01\codex-scientiae\ingestion\corpora\voroninski\1506.01437v2'
    'D:\aghado01\codex-scientiae\ingestion\corpora\voroninski\1701.08493v2'
)
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('b1crop-' + [Guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$dpi = 150.0

foreach ($pd in $papers) {
    $slug = Split-Path $pd -Leaf
    $pig = Get-ChildItem (Join-Path $pd ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
        Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
    $pigDir = $pig.Directory.FullName
    $out = Join-Path $tmp "$slug.figures.jsonl"
    ConvertTo-FigureRegions -PathsJsonl (Join-Path $pigDir "$slug.paths.jsonl") -OutPath $out 2>$null | Out-Null
    $blks = @{}; foreach ($b in (Get-Content (Join-Path $pigDir "$slug.blocks.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })) { $blks[[int]$b.id] = $b }
    $grow = {
        param($base, $ids)
        $bb = [double[]]@($base)
        foreach ($lb in @($ids)) { if ($null -eq $lb -or -not $blks.ContainsKey([int]$lb)) { continue }
            $x = $blks[[int]$lb].bx
            if ($x[0] -lt $bb[0]) { $bb[0]=[double]$x[0] }; if ($x[1] -lt $bb[1]) { $bb[1]=[double]$x[1] }
            if ($x[2] -gt $bb[2]) { $bb[2]=[double]$x[2] }; if ($x[3] -gt $bb[3]) { $bb[3]=[double]$x[3] } }
        $bb
    }
    foreach ($f in (@(Get-Content $out | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json }) | Where-Object { $_.PSObject.Properties.Name -contains 'visible_bbox' })) {
        $old = & $grow $f.bbox $f.letter_block_ids
        $new = & $grow (Get-FigureCropBbox $f.bbox $f.visible_bbox) $f.letter_block_ids
        $dpx = for ($k=0;$k -lt 4;$k++){ [math]::Round(($new[$k]-$old[$k])/72.0*$dpi,1) }
        $maxpx = ($dpx | ForEach-Object { [math]::Abs($_) } | Measure-Object -Max).Maximum
        $capPrev = if ($f.caption) { ($f.caption.text -replace '\s+',' ').Substring(0,[math]::Min(46,$f.caption.text.Length)) } else { '(uncaptioned)' }
        Write-Host ("{0} id{1} p{2} '{3}...'" -f $slug,$f.id,$f.page,$capPrev)
        Write-Host ("   OLD=[{0}]  NEW=[{1}]" -f (($old|%{[math]::Round($_,2)}) -join ','), (($new|%{[math]::Round($_,2)}) -join ','))
        Write-Host ("   delta px@{0}dpi=[L{1} B{2} R{3} T{4}]  max|delta|={5}px" -f $dpi,$dpx[0],$dpx[1],$dpx[2],$dpx[3],$maxpx)
    }
}
Remove-Item -Recurse -Force $tmp -EA 0
