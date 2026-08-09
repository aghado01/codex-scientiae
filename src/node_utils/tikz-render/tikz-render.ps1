#requires -Version 7.0
<#
  src/tikz-render/tikz-render.ps1 — TikZ -> SVG operation backed by the colocated tikz-svg.js
  worker (node-tikzjax: wasm TeX).

  The LaTeX source is the AUTHORITY for diagrams when it exists — PDF-side image extraction is
  unreliable (opendataloader sometimes misses figures entirely), so TikZ environments render to SVG
  from source rather than waiting on extracted pixels. PowerShell orchestrates; node renders — the
  same harness pattern as the math-render audit. Batch-oriented: one node invocation (one wasm init) renders
  a whole paper's diagrams, with per-job fault isolation.

    . ./src/tikz-render/tikz-render.ps1
    Invoke-TikzRender -Jobs @(@{ id = 'diagram-1'; source = '\begin{tikzpicture}...' }) -OutDir <dir>
#>

$script:TikzRenderRepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$script:TikzRenderDir = $PSScriptRoot
$script:TikzSvgJs = Join-Path $script:TikzRenderDir 'tikz-svg.js'
$script:TikzRenderNodeModules = Join-Path $script:TikzRenderRepoRoot 'packages/node/node_modules'

function Resolve-TikzRenderNodeModules([string]$NodeModulesPath = '') {
    if ([string]::IsNullOrWhiteSpace($NodeModulesPath)) { return $script:TikzRenderNodeModules }
    return [System.IO.Path]::GetFullPath($NodeModulesPath)
}

function Get-TikzNodePath {
    $n = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($n) { return $n.Source }
    return $null
}

# True when node + node-tikzjax + the shim are all present (callers degrade to markers otherwise).
function Test-TikzRenderAvailable {
    [CmdletBinding()] param([string]$NodeModulesPath = '')
    $modules = Resolve-TikzRenderNodeModules $NodeModulesPath
    return [bool]((Get-TikzNodePath) -and
        [System.IO.File]::Exists((Join-Path $modules 'node-tikzjax/package.json')) -and
        [System.IO.File]::Exists($script:TikzSvgJs))
}

# Render a batch of TikZ jobs to SVG files in $OutDir. Each job: id (output name, no extension),
# source (tikz env source), and optionally tikzLibraries / texPackages / preamble. Returns the
# report object { total, ok, results[{id, ok, bytes|error}] }. Throws only on harness failure —
# a diagram that fails to compile is a per-job result, never an exception.
function Invoke-TikzRender {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][object[]]$Jobs,
        [Parameter(Mandatory)][string]$OutDir,
        [string]$NodeModulesPath = ''
    )
    $node = Get-TikzNodePath
    $modules = Resolve-TikzRenderNodeModules $NodeModulesPath
    $tikzjaxDir = Join-Path $modules 'node-tikzjax'
    if (-not $node) { throw 'tikz-render: node not found on PATH; restore the shared Node payload with brewery/node/restore-node.ps1' }
    if (-not [System.IO.File]::Exists((Join-Path $tikzjaxDir 'package.json'))) {
        throw "tikz-render: node-tikzjax not found under '$modules'; restore the shared Node payload with brewery/node/restore-node.ps1"
    }
    if (-not [System.IO.File]::Exists($script:TikzSvgJs)) { throw "tikz-render: render harness not found: '$script:TikzSvgJs'" }
    $u8 = [System.Text.UTF8Encoding]::new($false)
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $jobsPath = Join-Path $OutDir '.tikz-jobs.json'
    [System.IO.File]::WriteAllText($jobsPath, (@{ jobs = $Jobs } | ConvertTo-Json -Depth 6), $u8)
    try {
        $raw = & $node $script:TikzSvgJs $jobsPath $OutDir --tikzjax $tikzjaxDir 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $raw) { throw "tikz-render: renderer failed (exit $LASTEXITCODE)" }
        # SVG is this rung's TERMINAL output, and it stays that way. The deliverable wants PNG, but the
        # SVG->PNG conversion belongs to BUNDLING (Copy-MdBundle in md-postprocess/md-bundle.ps1, which
        # converts and rewrites the markdown link), not here: this renders the IR that lands under
        # .runs/, and an IR stage that deletes its own output to satisfy a downstream format leaves
        # nothing to re-bundle from. Converting here also duplicates the bundler and drags a third
        # raster path (python/cairosvg) into a node+wasm lane.
        return ($raw -join '') | ConvertFrom-Json
    } finally {
        Remove-Item -LiteralPath $jobsPath -Force -ErrorAction SilentlyContinue
    }
}
