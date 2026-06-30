#requires -Version 7.0
<#
  src/render-check.ps1 — KaTeX render-validity shim over tools/render-check/katex-check.js.

  "Renders clean under KaTeX" is the objective math standard (STANDARDS.md §1): the strict bar implies the
  span renders on GitHub's MathJax. PowerShell orchestrates; KaTeX (Node) does the rendering. The membrane and
  the LaTeX oracle call Test-MathRenders; "render success" is a first-class benchmark dimension and a gate.

    . ./render-check.ps1
    Test-MathRenders -Path <file.md> [-Strict]
    Test-MathRenders -Spans @(@{ content = '\frac{1}{2}'; display = $true }) [-Strict]
#>

$script:RenderCheckDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'tools/render-check'
$script:KatexCheckJs = Join-Path $script:RenderCheckDir 'katex-check.js'

function Get-NodePath {
    $n = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($n) { return $n.Source }
    return $null
}

# True when Node + the pinned katex + the tool are all present (tests/gates skip cleanly otherwise).
function Test-RenderCheckAvailable {
    return [bool]((Get-NodePath) -and (Test-Path (Join-Path $script:RenderCheckDir 'node_modules/katex')) -and (Test-Path $script:KatexCheckJs))
}

# Render-validate the math of a markdown file (-Path) or an explicit span set (-Spans). Returns the report
# object { total, ok, failed, failures[{id,kind,error,snippet}], strict, source }. Throws if Node is absent.
function Test-MathRenders {
    [CmdletBinding(DefaultParameterSetName = 'File')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'File')][string]$Path,
        [Parameter(Mandatory, ParameterSetName = 'Spans')][object[]]$Spans,
        [switch]$Strict
    )
    $node = Get-NodePath
    if (-not $node) { throw 'render-check: node not found on PATH; run `npm install` in tools/render-check and ensure node is available' }
    $u8 = [System.Text.UTF8Encoding]::new($false)
    $argv = @($script:KatexCheckJs)
    $tmp = $null
    try {
        if ($PSCmdlet.ParameterSetName -eq 'File') {
            $argv += @('--file', $Path)
        }
        else {
            $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "rendercheck-$([guid]::NewGuid().ToString('N')).json"
            $json = @($Spans) | ConvertTo-Json -Depth 6 -AsArray
            [System.IO.File]::WriteAllText($tmp, $json, $u8)
            $argv += @('--spans', $tmp)
        }
        if ($Strict) { $argv += '--strict' }
        $out = & $node @argv
        if ($LASTEXITCODE -ne 0) { throw "render-check: katex-check.js failed (exit $LASTEXITCODE): $out" }
        return ($out | ConvertFrom-Json)
    }
    finally {
        if ($tmp -and (Test-Path -LiteralPath $tmp)) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
    }
}
