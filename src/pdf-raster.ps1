#requires -Version 7.0
<#
  src/pdf-raster.ps1 — PDF -> PNG shim over tools/pdf-raster/render.mjs (MuPDF WASM).

  PNG is the TERMINAL image register for the whole project (issues/latex-oracle-images.md): the pig lane
  already rasterizes figure regions to PNG through this same engine, and the LaTeX oracle lane joins it
  here — \includegraphics PDF assets and per-diagram compiled PDFs (tectonic -> PDF) both land as PNG via
  one raster mechanism. PowerShell orchestrates; node renders — the same harness pattern as tikz-render /
  render-check. Batch-oriented: one node invocation (one wasm init) rasterizes a whole paper's PDFs, each
  job carrying its own source path (render.mjs caches opened docs by path), with per-job fault isolation.

  CAVEAT: this MuPDF build has NO SVG or EPS/PostScript document handler — PDF (+ raster images) only.
  SVG intermediates and EPS assets must reach PDF first (tectonic) before they can be rasterized here.

    . ./pdf-raster.ps1
    Invoke-PdfRaster -Jobs @(@{ pdf = 'a.pdf'; out = 'a.png' }, @{ pdf = 'b.pdf'; page = 0; out = 'b.png' })
#>

$script:PdfRasterDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'tools/pdf-raster'
$script:PdfRasterMjs = Join-Path $script:PdfRasterDir 'render.mjs'

function Get-RasterNodePath {
    $n = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($n) { return $n.Source }
    return $null
}

# True when node + mupdf + the shim are all present (callers degrade to plain links / markers otherwise).
function Test-PdfRasterAvailable {
    return [bool]((Get-RasterNodePath) -and (Test-Path (Join-Path $script:PdfRasterDir 'node_modules/mupdf')) -and (Test-Path $script:PdfRasterMjs))
}

# Rasterize a batch of PDF jobs to PNG. Each job: pdf (source path), out (png path), optionally page
# (0-based, default 0) and bbox ([left,bottom,right,top] PDF points, default whole page). Returns the
# results array [{ out, ok, bytes, w, h } | { out, ok:false, error }]. Throws only on harness failure —
# a PDF that fails to rasterize is a per-job ok:false result, never an exception.
function Invoke-PdfRaster {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][object[]]$Jobs,
        [int]$Dpi = 200,
        [string]$WorkDir
    )
    $node = Get-RasterNodePath
    if (-not $node) { throw 'pdf-raster: node not found on PATH' }
    if (-not (Test-Path (Join-Path $script:PdfRasterDir 'node_modules/mupdf'))) {
        throw 'pdf-raster: mupdf not installed; run `npm install` in tools/pdf-raster'
    }
    $u8 = [System.Text.UTF8Encoding]::new($false)
    if (-not $WorkDir) { $WorkDir = [System.IO.Path]::GetTempPath() }
    New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
    $jobsPath = Join-Path $WorkDir ('.raster-jobs-' + [guid]::NewGuid().ToString('N') + '.json')
    # PIPE the jobs (not `ConvertTo-Json @($Jobs) -AsArray`, which double-wraps an existing array into
    # [[{...}]] and hands render.mjs an array where a job belongs) — one flat array of job objects.
    [System.IO.File]::WriteAllText($jobsPath, ($Jobs | ConvertTo-Json -Depth 6 -AsArray), $u8)
    try {
        $raw = & $node $script:PdfRasterMjs --jobs $jobsPath --dpi $Dpi 2>$null
        if (-not $raw) { throw "pdf-raster: renderer produced no output (exit $LASTEXITCODE)" }
        return ($raw -join '') | ConvertFrom-Json
    } finally {
        Remove-Item -LiteralPath $jobsPath -Force -ErrorAction SilentlyContinue
    }
}
