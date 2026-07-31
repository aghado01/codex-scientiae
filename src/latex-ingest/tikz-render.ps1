#requires -Version 7.0
<#
  src/latex-ingest/tikz-render.ps1 — TikZ -> SVG shim over tools/tikz-render/tikz-svg.js (node-tikzjax: wasm TeX).

  The LaTeX source is the AUTHORITY for diagrams when it exists — PDF-side image extraction is
  unreliable (opendataloader sometimes misses figures entirely), so TikZ environments render to SVG
  from source rather than waiting on extracted pixels. PowerShell orchestrates; node renders — the
  same harness pattern as render-check. Batch-oriented: one node invocation (one wasm init) renders
  a whole paper's diagrams, with per-job fault isolation.

    . ./tikz-render.ps1
    Invoke-TikzRender -Jobs @(@{ id = 'diagram-1'; source = '\begin{tikzpicture}...' }) -OutDir <dir>
#>

$script:TikzRenderDir = Join-Path ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))) 'tools/tikz-render'
$script:TikzSvgJs = Join-Path $script:TikzRenderDir 'tikz-svg.js'

function Get-TikzNodePath {
    $n = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($n) { return $n.Source }
    return $null
}

# True when node + node-tikzjax + the shim are all present (callers degrade to markers otherwise).
function Test-TikzRenderAvailable {
    return [bool]((Get-TikzNodePath) -and (Test-Path (Join-Path $script:TikzRenderDir 'node_modules/node-tikzjax')) -and (Test-Path $script:TikzSvgJs))
}

# Render a batch of TikZ jobs to SVG files in $OutDir. Each job: id (output name, no extension),
# source (tikz env source), and optionally tikzLibraries / texPackages / preamble. Returns the
# report object { total, ok, results[{id, ok, bytes|error}] }. Throws only on harness failure —
# a diagram that fails to compile is a per-job result, never an exception.
function Invoke-TikzRender {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][object[]]$Jobs,
        [Parameter(Mandatory)][string]$OutDir
    )
    $node = Get-TikzNodePath
    if (-not $node) { throw 'tikz-render: node not found on PATH' }
    if (-not (Test-Path (Join-Path $script:TikzRenderDir 'node_modules/node-tikzjax'))) {
        throw 'tikz-render: node-tikzjax not installed; run `npm install` in tools/tikz-render'
    }
    $u8 = [System.Text.UTF8Encoding]::new($false)
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $jobsPath = Join-Path $OutDir '.tikz-jobs.json'
    [System.IO.File]::WriteAllText($jobsPath, (@{ jobs = $Jobs } | ConvertTo-Json -Depth 6), $u8)
    try {
        $raw = & $node $script:TikzSvgJs $jobsPath $OutDir 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $raw) { throw "tikz-render: renderer failed (exit $LASTEXITCODE)" }
        $report = ($raw -join '') | ConvertFrom-Json

        # Convert produced SVG diagrams to terminal PNG register
        $pyExe = (Get-Command python -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1).Source
        if ($pyExe -and $report.results) {
            foreach ($r in $report.results) {
                if (-not $r.ok) { continue }
                $svgFile = Join-Path $OutDir "$($r.id).svg"
                $pngFile = Join-Path $OutDir "$($r.id).png"
                if (Test-Path -LiteralPath $svgFile -PathType Leaf) {
                    try {
                        $svgPy = $svgFile.Replace('\', '/')
                        $pngPy = $pngFile.Replace('\', '/')
                        $pyCmd = "import cairosvg; b=open('$svgPy', 'rb').read(); cairosvg.svg2png(bytestring=b, write_to='$pngPy')"
                        & $pyExe -c $pyCmd 2>$null
                        if ((Test-Path -LiteralPath $pngFile -PathType Leaf) -and (Get-Item -LiteralPath $pngFile).Length -gt 0) {
                            $r | Add-Member -NotePropertyName png -NotePropertyValue "$($r.id).png" -Force
                            Remove-Item -LiteralPath $svgFile -Force -ErrorAction SilentlyContinue
                        }
                    } catch {}
                }
            }
        }
        return $report
    } finally {
        Remove-Item -LiteralPath $jobsPath -Force -ErrorAction SilentlyContinue
    }
}
