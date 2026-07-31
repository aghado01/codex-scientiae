#requires -Version 7.0
<#
  src/latex-ingest/tex-render.ps1 — unified diagram render: a LaTeX snippet -> PDF (tectonic) -> PNG (MuPDF).

  The PNG-terminal unification of issues/latex-oracle-images.md: extract a diagram env, wrap it in a
  standalone snippet WITH the paper's own preamble replayed (author macros inside diagrams are the
  fidelity trap), compile to a tightly-cropped PDF with tectonic (one self-contained binary that
  auto-fetches packages), then rasterize that PDF to PNG through the already-vendored MuPDF engine
  (tools/pdf-raster). ONE mechanism for every diagram package — tikz, tikz-cd, AND xy-pic — where
  node-tikzjax (TikZ-only WASM) and KaTeX both fail. Per-job fault isolation: a diagram that fails to
  compile is a per-job ok:false result, never an exception, and its caller keeps a flagged marker.

    . ./tex-render.ps1
    Invoke-TexDiagramRender -Jobs @(@{ id='diagram-1'; source='\begin{tikzcd}...' }) -Preamble $pre -OutDir <dir>
#>

. "$PSScriptRoot/../pdf-raster.ps1"   # PDF -> PNG (MuPDF WASM) — the raster half of the pipeline

$script:TexRepoRoot   = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$script:TexPackageDir = Join-Path $script:TexRepoRoot 'packages/tectonic'   # the pinned external tier
$script:TexVendorDir  = Join-Path $script:TexRepoRoot 'tools/tex-render'    # pre-tier vendored location

# Resolution ladder. The PINNED tier wins over PATH deliberately: a system tectonic is of unknown
# version, and letting it silently outrank the pin defeats the point of pinning the external at all.
#   rung 1  packages/tectonic — the pin
#   rung 2  a system install on PATH
#   rung 3  tools/tex-render — pre-tier vendored dir, kept so an older checkout still resolves
function Get-TectonicPath {
    foreach ($exe in 'tectonic.exe', 'tectonic') {
        $p = Join-Path $script:TexPackageDir $exe
        if (Test-Path -LiteralPath $p) { return $p }
    }
    $c = Get-Command tectonic -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($c) { return $c.Source }
    foreach ($exe in 'tectonic.exe', 'tectonic') {
        $p = Join-Path $script:TexVendorDir $exe
        if (Test-Path -LiteralPath $p) { return $p }
    }
    return $null
}

# Both halves must be present: tectonic to compile, MuPDF to rasterize. Absent -> callers fall back to
# the tikzjax SVG path (plain TikZ only) or a flagged marker.
function Test-TexRenderAvailable {
    return [bool]((Get-TectonicPath) -and (Test-PdfRasterAvailable))
}

# tectonic caches the fetched TeX bundle + compiled formats; the default %LocalAppData%\TectonicProject
# path is not reliably creatable in the portable env (format-write fails), so pin the cache to a stable,
# writable dir anchored on the .claude config root. Persistent across runs — the bundle is fetched once.
function Initialize-TectonicCache {
    if ($env:TECTONIC_CACHE_DIR -and (Test-Path -LiteralPath $env:TECTONIC_CACHE_DIR)) { return }
    $anchor = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $env:USERPROFILE '.claude' }
    $cache = Join-Path $anchor 'cache/tectonic'
    New-Item -ItemType Directory -Force -Path $cache | Out-Null
    $env:TECTONIC_CACHE_DIR = $cache
}

# Packages every diagram snippet needs regardless of the paper: the xy-pic + tikz families + core math.
# The author preamble is replayed ON TOP (below) for macro fidelity.
$script:TexBasePackages = @'
\usepackage{amsmath,amssymb,amsfonts,mathtools}
\usepackage{tikz}
\usepackage{tikz-cd}
\usepackage[all,cmtip]{xy}
'@

# Replaying the raw author preamble is a trap: blocking a layout package (fancyhdr, hyperref, …) still
# leaves its stray commands (\fancyhf, \pagestyle{fancy}, \addbibresource, \graphicspath, \newtheorem) in
# the preamble, and each is then an "Undefined control sequence" that fails the whole snippet. So we do the
# opposite — an ALLOWLIST. Author MACROS are already expanded in the diagram source before compile (and a
# \newcommand body can span lines, which a line filter would shred), so they need no replay; what expansion
# CAN'T inline is the by-NAME resources a diagram references — colours, tikz styles, tikz libraries, pgf
# setup. Keep only those (single-line forms — the overwhelmingly common case); drop everything else. A
# diagram that needs a dropped multi-line \tikzset simply fails to a flagged marker (graceful degradation).
$script:TexKeepPreambleRx = '^\\(?:definecolor|colorlet|usetikzlibrary|tikzstyle|tikzset|pgfplotsset|pgfkeys|pgfdeclare[a-zA-Z]*|newlength|setlength|newif)\b'

function Get-ReplayPreamble {
    param([string]$Preamble)
    if (-not $Preamble) { return '' }
    $out = [System.Collections.Generic.List[string]]::new()
    foreach ($line in ($Preamble -split '\r?\n')) {
        $t = $line.Trim()
        if ($t -match $script:TexKeepPreambleRx) { $out.Add($t) }
    }
    return ($out -join "`n")
}

# A cropped, self-contained document for one diagram. `standalone` crops the page to the diagram's bounding
# box (border=2pt), so the rendered PDF IS the diagram — MuPDF then rasterizes the whole (single) page.
function Build-StandaloneSnippet {
    param([string]$Source, [string]$Preamble = '', [string]$TikzLibraries = '')
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine('\documentclass[border=2pt]{standalone}')
    [void]$sb.AppendLine($script:TexBasePackages)
    if ($TikzLibraries) { [void]$sb.AppendLine('\usetikzlibrary{' + $TikzLibraries + '}') }
    $replay = Get-ReplayPreamble $Preamble
    if ($replay) { [void]$sb.AppendLine($replay) }
    [void]$sb.AppendLine('\begin{document}')
    [void]$sb.AppendLine($Source)
    [void]$sb.AppendLine('\end{document}')
    return $sb.ToString()
}

# Compile each job's snippet to PDF (tectonic), then rasterize every produced PDF to PNG in one MuPDF call.
# PNGs land as <OutDir>/<id>.png. Returns { total, ok, results[{ id, ok, png|error }] }. Compile/raster
# intermediates live in a scratch subdir that is removed on the way out (regenerable — only PNGs persist).
function Invoke-TexDiagramRender {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][object[]]$Jobs,
        [string]$Preamble = '',
        [string]$TikzLibraries = '',
        [Parameter(Mandatory)][string]$OutDir,
        [int]$Dpi = 200
    )
    $tectonic = Get-TectonicPath
    if (-not $tectonic) { throw 'tex-render: tectonic not found (PATH or tools/tex-render)' }
    Initialize-TectonicCache
    $u8 = [System.Text.UTF8Encoding]::new($false)
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $compileDir = Join-Path $OutDir '.texc'
    New-Item -ItemType Directory -Force -Path $compileDir | Out-Null

    $results    = [System.Collections.Generic.List[object]]::new()
    $rasterJobs = [System.Collections.Generic.List[object]]::new()
    foreach ($job in $Jobs) {
        $id      = [string]$job.id
        $texPath = Join-Path $compileDir "$id.tex"
        $pdfPath = Join-Path $compileDir "$id.pdf"
        $logPath = Join-Path $compileDir "$id.tec.log"
        [System.IO.File]::WriteAllText($texPath, (Build-StandaloneSnippet $job.source $Preamble $TikzLibraries), $u8)
        # tectonic v2 subcommand form; --outdir keeps the PDF beside the source. All streams -> the captured
        # log; the exit code plus the PDF's presence are the truth. One process per diagram = fault isolation.
        # Retry once: on a COLD cache the first compile of a diagram can fail transiently (a concurrent font
        # fetch / format-cache write racing the process); the retry lands once those are on disk.
        $exit = 1
        for ($attempt = 0; $attempt -lt 2; $attempt++) {
            & $tectonic -X compile $texPath --outdir $compileDir *> $logPath
            $exit = $LASTEXITCODE
            if ($exit -eq 0 -and (Test-Path -LiteralPath $pdfPath)) { break }
        }
        if ($exit -eq 0 -and (Test-Path -LiteralPath $pdfPath)) {
            $rasterJobs.Add([pscustomobject]@{ id = $id; pdf = $pdfPath; out = (Join-Path $OutDir "$id.png") })
        } else {
            $err = if (Test-Path -LiteralPath $logPath) { ((Get-Content -LiteralPath $logPath -Raw) -replace '\s+', ' ').Trim() } else { '' }
            if ($err.Length -gt 300) { $err = $err.Substring($err.Length - 300) }   # tail of the log holds the error
            $results.Add([pscustomobject]@{ id = $id; ok = $false; error = "tectonic exit ${exit}: $err" })
        }
    }

    if ($rasterJobs.Count -gt 0) {
        $ok = @{}
        try {
            $res = Invoke-PdfRaster -Jobs @($rasterJobs | ForEach-Object { @{ pdf = $_.pdf; out = $_.out } }) -Dpi $Dpi -WorkDir $compileDir
            foreach ($r in @($res)) { $ok[$r.out] = $r }
        } catch { Write-Verbose "tex-render raster failed: $($_.Exception.Message)" }
        foreach ($rj in $rasterJobs) {
            $r = $ok[$rj.out]
            if ($r -and $r.ok) { $results.Add([pscustomobject]@{ id = $rj.id; ok = $true; png = "$($rj.id).png"; bytes = $r.bytes; w = $r.w; h = $r.h }) }
            else { $results.Add([pscustomobject]@{ id = $rj.id; ok = $false; error = "raster failed: $(if ($r) { $r.error } else { 'no result' })" }) }
        }
    }

    Remove-Item -LiteralPath $compileDir -Recurse -Force -ErrorAction SilentlyContinue
    return [pscustomobject]@{ total = $Jobs.Count; ok = @($results | Where-Object { $_.ok }).Count; results = $results }
}

# Rasterize vector \includegraphics assets that MuPDF cannot open directly — EPS/PS (this build has no
# PostScript handler). Each is wrapped in a graphicx `standalone` doc so tectonic converts it to a cropped
# PDF (tectonic's bundled graphics path handles EPS), which MuPDF then rasterizes to PNG. PDF assets do NOT
# belong here — MuPDF opens those directly (Invoke-PdfRaster). Each asset: @{ src (path); out (png path) }.
# Returns results[{ src, out, ok, error? }]. Per-asset fault isolation; intermediates are cleaned up.
function Invoke-TexGraphicRender {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][object[]]$Assets,
        [Parameter(Mandatory)][string]$OutDir,
        [int]$Dpi = 200
    )
    $tectonic = Get-TectonicPath
    if (-not $tectonic) { throw 'tex-render: tectonic not found (PATH or tools/tex-render)' }
    Initialize-TectonicCache
    $u8 = [System.Text.UTF8Encoding]::new($false)
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $compileDir = Join-Path $OutDir '.texg'
    New-Item -ItemType Directory -Force -Path $compileDir | Out-Null

    $results    = [System.Collections.Generic.List[object]]::new()
    $rasterJobs = [System.Collections.Generic.List[object]]::new()
    $i = 0
    foreach ($a in $Assets) {
        $i++; $id = "graphic-$i"
        # graphicx reads by absolute path (forward-slashed for TeX); standalone crops to the artwork's bbox.
        # Drop the extension: an explicit `.eps` makes graphicx try to EMBED it (fails under xetex); with no
        # extension graphicx auto-detects + converts EPS -> PDF via tectonic's bundled rule. (Verified.)
        $src = (([System.IO.Path]::GetFullPath($a.src)) -replace '\\', '/') -replace '\.[^./]+$', ''
        $tex = "\documentclass[border=0pt]{standalone}`n\usepackage{graphicx}`n\begin{document}`n\includegraphics{$src}`n\end{document}"
        $tf = Join-Path $compileDir "$id.tex"; [System.IO.File]::WriteAllText($tf, $tex, $u8)
        $pdf = Join-Path $compileDir "$id.pdf"; $logPath = Join-Path $compileDir "$id.tec.log"
        $exit = 1
        for ($attempt = 0; $attempt -lt 2; $attempt++) {
            & $tectonic -X compile $tf --outdir $compileDir *> $logPath
            $exit = $LASTEXITCODE
            if ($exit -eq 0 -and (Test-Path -LiteralPath $pdf)) { break }
        }
        if ($exit -eq 0 -and (Test-Path -LiteralPath $pdf)) { $rasterJobs.Add([pscustomobject]@{ src = $a.src; pdf = $pdf; out = $a.out }) }
        else { $results.Add([pscustomobject]@{ src = $a.src; out = $a.out; ok = $false; error = "tectonic exit $exit" }) }
    }
    if ($rasterJobs.Count -gt 0) {
        $ok = @{}
        try {
            $res = Invoke-PdfRaster -Jobs @($rasterJobs | ForEach-Object { @{ pdf = $_.pdf; out = $_.out } }) -Dpi $Dpi -WorkDir $compileDir
            foreach ($r in @($res)) { $ok[$r.out] = $r }
        } catch { Write-Verbose "tex-graphic raster failed: $($_.Exception.Message)" }
        foreach ($rj in $rasterJobs) {
            $r = $ok[$rj.out]
            if ($r -and $r.ok) { $results.Add([pscustomobject]@{ src = $rj.src; out = $rj.out; ok = $true }) }
            else { $results.Add([pscustomobject]@{ src = $rj.src; out = $rj.out; ok = $false; error = "raster failed: $(if ($r) { $r.error } else { 'no result' })" }) }
        }
    }
    Remove-Item -LiteralPath $compileDir -Recurse -Force -ErrorAction SilentlyContinue
    return $results
}
