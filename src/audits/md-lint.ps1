#requires -Version 7.0
<#
  src/md-lint.ps1 — markdown STRUCTURE lint shim over tools/md-lint/md-lint.js (markdownlint).

  The non-math half of the codex standard: heading hierarchy (STANDARDS §5), spacing hygiene (§4), the
  Contents block (§6). Math render-validity is the SEPARATE gate (src/render-check.ps1). PowerShell
  orchestrates; markdownlint (Node) does the linting, against the codex-aligned config
  (tools/md-lint/codex.markdownlint.json — line-length off, since the codex removes hard wraps).

    . ./md-lint.ps1
    Test-MarkdownLint -Path <file.md> [-Config <json>]
#>

$script:MdLintDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'tools/md-lint'
$script:MdLintJs = Join-Path $script:MdLintDir 'md-lint.js'

# node locator inlined (not a shared function) so this file never collides with render-check.ps1's Get-NodePath.
function Test-MarkdownLintAvailable {
    $node = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    return [bool]($node -and (Test-Path (Join-Path $script:MdLintDir 'node_modules/markdownlint')) -and (Test-Path $script:MdLintJs))
}

# Structure-lint a markdown file. Returns { file, total, issues[{line, rule, desc, detail}] }. Throws if Node absent.
function Test-MarkdownLint {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Path,
        [string]$Config
    )
    $node = (Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1)
    if (-not $node) { throw 'md-lint: node not found on PATH; run `npm install` in tools/md-lint' }
    $argv = @($script:MdLintJs, '--file', $Path)
    if ($Config) { $argv += @('--config', $Config) }
    $out = & $node.Source @argv
    if ($LASTEXITCODE -ne 0) { throw "md-lint: md-lint.js failed (exit $LASTEXITCODE): $out" }
    return ($out | ConvertFrom-Json)
}
