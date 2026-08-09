#requires -Version 7.0
<#
  src/math-channel/math-render/math-render.ps1 — engine-backed audit of mathematical Markdown.

  The capability boundary is "does the emitted mathematical register render?", not KaTeX and not
  any one ingestion lane. KaTeX is the current audit engine, supplied explicitly from the shared
  packages/node payload. LaTeX ingestion uses this audit today; a future PDF conversion workflow can
  consume the same report contract without depending on latex-ingest.

    . ./math-render.ps1
    Invoke-MathRenderAudit -Path <file.md> [-Strict] [-OutputPath <report.json>]
    Invoke-MathRenderAudit -Spans @(@{ content = '\frac{1}{2}'; display = $true }) [-Strict]
#>

$script:MathRenderRepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$script:MathRenderJs = Join-Path $PSScriptRoot 'katex-check.js'
$script:MathRenderNodeModules = Join-Path $script:MathRenderRepoRoot 'packages/node/node_modules'
$script:MathRenderUtf8 = [System.Text.UTF8Encoding]::new($false)

function Get-MathRenderNodePath {
    $node = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($node) { return $node.Source }
    return $null
}

function Resolve-MathRenderNodeModules([string]$NodeModulesPath = '') {
    if ([string]::IsNullOrWhiteSpace($NodeModulesPath)) { return $script:MathRenderNodeModules }
    return [System.IO.Path]::GetFullPath($NodeModulesPath)
}

function Test-MathRenderAvailable {
    [CmdletBinding()] param([string]$NodeModulesPath = '')
    $modules = Resolve-MathRenderNodeModules $NodeModulesPath
    return [bool]((Get-MathRenderNodePath) -and
        [System.IO.File]::Exists($script:MathRenderJs) -and
        [System.IO.File]::Exists((Join-Path $modules 'katex/package.json')))
}

# Audit a Markdown file or explicit span set. A mathematical render failure is DATA in the returned
# report, not a process failure; unavailable dependencies and malformed input throw. When OutputPath is
# supplied, the same report is persisted as UTF-8 without BOM. The caller owns that artifact address.
function Invoke-MathRenderAudit {
    [CmdletBinding(DefaultParameterSetName = 'File')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'File')][string]$Path,
        [Parameter(Mandatory, ParameterSetName = 'Spans')][object[]]$Spans,
        [switch]$Strict,
        [string]$OutputPath = '',
        [string]$NodeModulesPath = ''
    )

    $node = Get-MathRenderNodePath
    $modules = Resolve-MathRenderNodeModules $NodeModulesPath
    $katexDir = Join-Path $modules 'katex'
    if (-not $node) {
        throw 'math-render: node not found on PATH; restore the shared Node payload with brewery/node/restore-node.ps1'
    }
    if (-not [System.IO.File]::Exists($script:MathRenderJs)) {
        throw "math-render: audit engine not found: '$script:MathRenderJs'"
    }
    if (-not [System.IO.File]::Exists((Join-Path $katexDir 'package.json'))) {
        throw "math-render: KaTeX not found under '$modules'; restore the shared Node payload with brewery/node/restore-node.ps1"
    }

    $argv = @($script:MathRenderJs, '--katex', $katexDir)
    $scratchPath = $null
    try {
        if ($PSCmdlet.ParameterSetName -eq 'File') {
            try { $inputPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path }
            catch { throw "math-render: Markdown input not found: '$Path'" }
            if (-not [System.IO.File]::Exists($inputPath)) { throw "math-render: Markdown input is not a file: '$inputPath'" }
            $argv += @('--file', $inputPath)
        }
        else {
            # Explicit-span calls need a bridge file for the Node process. Even this short-lived input
            # belongs under artifacts/, never the system temp directory or the source tree.
            $scratchDir = Join-Path $script:MathRenderRepoRoot 'artifacts/math-render/scratch'
            New-Item -ItemType Directory -Force -Path $scratchDir | Out-Null
            $scratchPath = Join-Path $scratchDir "spans-$([guid]::NewGuid().ToString('N')).json"
            $json = @($Spans) | ConvertTo-Json -Depth 8 -AsArray
            [System.IO.File]::WriteAllText($scratchPath, $json, $script:MathRenderUtf8)
            $argv += @('--spans', $scratchPath)
        }
        if ($Strict) { $argv += '--strict' }

        $output = & $node @argv
        $exitCode = $LASTEXITCODE
        if ($exitCode -ne 0) { throw "math-render: katex-check.js failed (exit $exitCode): $output" }
        $report = $output | ConvertFrom-Json
        if ($PSCmdlet.ParameterSetName -eq 'Spans') { $report.source = 'spans' }

        if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
            $reportPath = [System.IO.Path]::GetFullPath($OutputPath)
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $reportPath) | Out-Null
            [System.IO.File]::WriteAllText($reportPath, (($report | ConvertTo-Json -Depth 8) + "`n"), $script:MathRenderUtf8)
            $report | Add-Member -NotePropertyName report_path -NotePropertyValue $reportPath
        }
        return $report
    }
    finally {
        if ($scratchPath -and [System.IO.File]::Exists($scratchPath)) {
            Remove-Item -LiteralPath $scratchPath -Force -ErrorAction SilentlyContinue
        }
    }
}
