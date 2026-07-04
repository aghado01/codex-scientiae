#requires -Version 7
<#
.SYNOPSIS
  Render each detected figure region to a PNG deliverable (pig-lane image extraction).

.DESCRIPTION
  A CONSUMER of {slug}.figures.jsonl: for every kind=figure region it renders the page region to a
  PNG via the vendored MuPDF (WASM) tool (tools/pdf-raster/render.mjs) — one batched node call per
  paper. This rasterizes whatever is drawn in the region, so it covers vector (TikZ) figures AND
  embedded bitmaps uniformly, and never emits a sub-PDF/SVG.

  Outputs follow the pig-lane run convention (mirrors .runs/{stamp}/tex/): everything lands under
  {paperDir}/.runs/{runstamp}/pig/ — PNGs in images/imageFile{N}.png, an images.jsonl manifest
  linking each figure to its PNG (id, figure_id, page, bbox, png, dims, status, caption). A fresh
  runstamp per call keeps dev re-runs from clobbering (newest-wins); pass -RunStamp to align with an
  existing run. .runs/ is git-ignored — these are regenerable staging that publish promotes.

  Every figure is accounted for in the manifest (status ok|failed with a reason) — nothing is
  silently dropped.
#>

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

    $renderTool = Join-Path $PSScriptRoot '../../tools/pdf-raster/render.mjs'
    if (-not (Test-Path $renderTool)) { throw "render tool not found: $renderTool" }

    $pigDir = Join-Path $paperDir ".runs/$RunStamp/pig"
    $imgDir = Join-Path $pigDir 'images'
    New-Item -ItemType Directory -Force -Path $imgDir | Out-Null

    $figs = @(Get-Content $FiguresJsonl | Where-Object { $_.Trim() } |
        ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.kind -eq 'figure' })

    # Render jobs: mupdf page is 0-based, figures.jsonl page is 1-based (PdfPig).
    $jobs = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $figs.Count; $i++) {
        $jobs.Add([ordered]@{ page = [int]$figs[$i].page - 1; bbox = $figs[$i].bbox; out = (Join-Path $imgDir "imageFile$i.png") })
    }

    $summary  = [ordered]@{ figures = $figs.Count; rendered = 0; failed = 0; dpi = $Dpi; run = $pigDir }
    $manifest = [System.Collections.Generic.List[object]]::new()

    if ($figs.Count -gt 0) {
        $jobsFile = Join-Path $pigDir '_render-jobs.json'
        [System.IO.File]::WriteAllText($jobsFile, ($jobs | ConvertTo-Json -Depth 5 -AsArray), [System.Text.UTF8Encoding]::new($false))
        $errFile = [IO.Path]::GetTempFileName()
        $resJson = & node $renderTool --pdf $PdfPath --jobs $jobsFile --dpi $Dpi 2>$errFile
        Remove-Item $jobsFile -Force -ErrorAction SilentlyContinue
        if (-not $resJson) { $e = (Get-Content $errFile -Raw); Remove-Item $errFile -Force -EA SilentlyContinue; throw "render tool produced no output: $e" }
        Remove-Item $errFile -Force -ErrorAction SilentlyContinue

        $byOut = @{}; foreach ($r in ($resJson | ConvertFrom-Json)) { $byOut[$r.out] = $r }
        for ($i = 0; $i -lt $figs.Count; $i++) {
            $f = $figs[$i]; $r = $byOut[$jobs[$i].out]
            $ok = [bool]($r -and $r.ok)
            if ($ok) { $summary.rendered++ } else { $summary.failed++ }
            $manifest.Add([ordered]@{
                id = $i; figure_id = $f.id; page = $f.page; bbox = $f.bbox
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
