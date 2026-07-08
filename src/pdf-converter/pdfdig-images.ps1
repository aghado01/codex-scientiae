#requires -Version 7
<#
.SYNOPSIS
  Render each detected figure region to a PNG deliverable (pig-lane image extraction).

.DESCRIPTION
  A CONSUMER of {slug}.figures.jsonl: for every kind=figure region it renders the page region to a
  PNG via the SHARED raster shim (src/pdf-raster.ps1 -> tools/pdf-raster/render.mjs, the same MuPDF
  mechanism the LaTeX oracle lane uses) — one batched call per paper. This rasterizes whatever is drawn in the region, so it covers vector (TikZ) figures AND
  embedded bitmaps uniformly, and never emits a sub-PDF/SVG.

  Outputs follow the pig-lane run convention (mirrors .runs/{stamp}/tex/): everything lands under
  {paperDir}/.runs/{runstamp}/pig/ — PNGs in images/imageFile{N}.png, an images.jsonl manifest
  linking each figure to its PNG (id, figure_id, page, bbox, png, dims, status, caption). A fresh
  runstamp per call keeps dev re-runs from clobbering (newest-wins); pass -RunStamp to align with an
  existing run. .runs/ is git-ignored — these are regenerable staging that publish promotes.

  Every figure is accounted for in the manifest (status ok|failed with a reason) — nothing is
  silently dropped.
#>

. "$PSScriptRoot/../pdf-raster.ps1"   # the shared PDF->PNG shim (Invoke-PdfRaster / Test-PdfRasterAvailable)

# Crop-rect base for one figure region: the painted-ink extent (visible_bbox, emitted by the formation
# lane when unpainted clip masks inflated the union — issues/clustering/crop-bbox-inflation.md class a)
# INTERSECTED with the geometric bbox. Intersection is the key: visible_bbox TIGHTENS the crop to ink,
# but must never RE-EXPAND past a deliberate bbox trim — A2b pulls 1701 Fig 7's bbox bottom up to its
# caption top, while the class-(b) white FILL (id49, is_filled yet page-colored) reaches below it and
# the paint signal cannot exclude it; clamping paint to the final bbox keeps A2b's trim. No visible_bbox
# (or a degenerate/disjoint intersection) ⇒ the geometric bbox, unchanged. Returns a fresh [double[4]].
function Get-FigureCropBbox($Bbox, $VisibleBbox) {
    $geo = [double[]]@($Bbox)
    if (-not $VisibleBbox) { return $geo }
    $v = [double[]]@($VisibleBbox)
    $bb = [double[]]@(
        [math]::Max($geo[0], $v[0]), [math]::Max($geo[1], $v[1]),
        [math]::Min($geo[2], $v[2]), [math]::Min($geo[3], $v[3]))
    if ($bb[0] -ge $bb[2] -or $bb[1] -ge $bb[3]) { return $geo }   # degenerate/disjoint ⇒ geometric bbox
    $bb
}

function Export-PdfFigureImages {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $PdfPath,
        [string] $FiguresJsonl,                         # default {slug}.figures.jsonl beside the PDF
        [string] $RunStamp,                             # default new yyyyMMdd_HHmmss
        [int]    $Dpi = 150,
        [switch] $PassThru
    )

    if (-not (Test-Path $PdfPath)) { throw "pdf not found: $PdfPath" }
    $paperDir = Split-Path $PdfPath -Parent
    $slug     = [IO.Path]::GetFileNameWithoutExtension($PdfPath)
    if (-not $FiguresJsonl) { $FiguresJsonl = Join-Path $paperDir "$slug.figures.jsonl" }
    if (-not (Test-Path $FiguresJsonl)) { throw "figures lane not found: $FiguresJsonl (run ConvertTo-FigureRegions first)" }
    if (-not $RunStamp) { $RunStamp = Get-Date -Format 'yyyyMMdd_HHmmss' }

    if (-not (Test-PdfRasterAvailable)) { throw 'pdf-raster unavailable (node + tools/pdf-raster/node_modules/mupdf required)' }

    $pigDir = Join-Path $paperDir ".runs/$RunStamp/pig"
    $imgDir = Join-Path $pigDir 'images'
    New-Item -ItemType Directory -Force -Path $imgDir | Out-Null

    $figs = @(Get-Content $FiguresJsonl | Where-Object { $_.Trim() } |
        ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.kind -eq 'figure' })

    # V_letters crop union (letters-elevation.md): a region's attached letter blocks (node labels,
    # connectors — text the path-only bbox amputates) expand the CROP rect. The region record's own
    # bbox stays geometric; only the render rect grows.
    $blockBx = $null
    $blocksJsonl = $FiguresJsonl -replace '\.figures\.jsonl$', '.blocks.jsonl'
    if ((Test-Path $blocksJsonl) -and ($figs | Where-Object { @($_.letter_block_ids).Count -gt 0 } | Select-Object -First 1)) {
        $blockBx = @{}
        foreach ($line in [System.IO.File]::ReadLines($blocksJsonl)) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $bk = $line | ConvertFrom-Json
            if ($bk.bx) { $blockBx[[int]$bk.id] = $bk.bx }
        }
    }

    # Render jobs: mupdf page is 0-based, figures.jsonl page is 1-based (PdfPig). Rasterization rides
    # the SHARED shim (src/pdf-raster.ps1, Invoke-PdfRaster) — the one MuPDF mechanism the LaTeX oracle
    # lane also uses (PNG-terminal register, issues/latex-oracle-images.md).
    $jobs = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $figs.Count; $i++) {
        # Painted-ink crop base (visible_bbox ∩ bbox), then grow by attached letter blocks as before.
        $bb = Get-FigureCropBbox $figs[$i].bbox $figs[$i].visible_bbox
        if ($blockBx) {
            foreach ($lb in @($figs[$i].letter_block_ids)) {
                if ($null -eq $lb) { continue }
                $x = $blockBx[[int]$lb]
                if (-not $x) { continue }
                if ($x[0] -lt $bb[0]) { $bb[0] = [double]$x[0] }
                if ($x[1] -lt $bb[1]) { $bb[1] = [double]$x[1] }
                if ($x[2] -gt $bb[2]) { $bb[2] = [double]$x[2] }
                if ($x[3] -gt $bb[3]) { $bb[3] = [double]$x[3] }
            }
        }
        $jobs.Add(@{ pdf = $PdfPath; page = [int]$figs[$i].page - 1; bbox = $bb; out = (Join-Path $imgDir "imageFile$i.png") })
    }

    $summary  = [ordered]@{ figures = $figs.Count; rendered = 0; failed = 0; dpi = $Dpi; run = $pigDir }
    $manifest = [System.Collections.Generic.List[object]]::new()

    if ($figs.Count -gt 0) {
        $res = Invoke-PdfRaster -Jobs $jobs.ToArray() -Dpi $Dpi -WorkDir $pigDir
        $byOut = @{}; foreach ($r in @($res)) { $byOut[$r.out] = $r }
        for ($i = 0; $i -lt $figs.Count; $i++) {
            $f = $figs[$i]; $r = $byOut[$jobs[$i].out]
            $ok = [bool]($r -and $r.ok)
            if ($ok) { $summary.rendered++ } else { $summary.failed++ }
            $manifest.Add([ordered]@{
                id = $i; figure_id = $f.id; page = $f.page; bbox = $jobs[$i].bbox   # the RENDERED rect (letter-expanded)
                png    = $(if ($ok) { "images/imageFile$i.png" } else { $null })
                width  = $(if ($ok) { $r.w } else { $null })
                height = $(if ($ok) { $r.h } else { $null })
                status = $(if ($ok) { 'ok' } else { 'failed' })
                error  = $(if ($ok) { $null } elseif ($r) { $r.error } else { 'no render result' })
                caption = $(if ($f.caption) { $f.caption.text } else { $null })
            })
        }
    }

    $manifestPath = Join-Path $pigDir 'images.jsonl'
    $lines = [string[]]@($manifest | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 5 })
    [System.IO.File]::WriteAllLines($manifestPath, $lines, [System.Text.UTF8Encoding]::new($false))

    Write-Verbose ("images: {0}/{1} rendered ({2} failed) @ {3}dpi -> {4}" -f `
        $summary.rendered, $summary.figures, $summary.failed, $Dpi, $pigDir)

    if ($PassThru) {
        [pscustomobject]@{ RunDir = $pigDir; Manifest = $manifestPath; Summary = [pscustomobject]$summary; Images = $manifest }
    }
}
