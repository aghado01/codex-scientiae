#requires -Version 7.0
<#
  src/audits/md-lint.ps1 — markdown STRUCTURE lint shim over tools/md-lint/md-lint.js (markdownlint).

  The non-math half of the codex standard: heading hierarchy (STANDARDS §5), spacing hygiene (§4), the
  Contents block (§6). Mathematical rendering is the SEPARATE audit (src/audits/math-render). PowerShell
  orchestrates; markdownlint (Node) does the linting, against the codex-aligned config
  (tools/md-lint/codex.markdownlint.json — line-length off, since the codex removes hard wraps).

    . ./md-lint.ps1
    Test-MarkdownLint -Path <file.md> [-Config <json>]
#>

$script:MdLintRepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$script:MdLintDir = Join-Path $script:MdLintRepoRoot 'tools/md-lint'
$script:MdLintJs = Join-Path $script:MdLintDir 'md-lint.js'
$script:MdLintNodeModules = Join-Path $script:MdLintRepoRoot 'packages/node/node_modules'

function Resolve-MarkdownLintNodeModules([string]$NodeModulesPath = '') {
    if ([string]::IsNullOrWhiteSpace($NodeModulesPath)) { return $script:MdLintNodeModules }
    return [System.IO.Path]::GetFullPath($NodeModulesPath)
}

# The node locator stays local to this capability; audit modules must not create shared global helpers.
function Test-MarkdownLintAvailable {
    [CmdletBinding()] param([string]$NodeModulesPath = '')
    $node = Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    $modules = Resolve-MarkdownLintNodeModules $NodeModulesPath
    return [bool]($node -and
        [System.IO.File]::Exists((Join-Path $modules 'markdownlint/package.json')) -and
        [System.IO.File]::Exists($script:MdLintJs))
}

# Structure-lint a markdown file. Returns { file, total, issues[{line, rule, desc, detail}] }.
# Missing toolchain/payload or a harness failure throws because no trustworthy report was produced.
function Test-MarkdownLint {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Path,
        [string]$Config,
        [string]$NodeModulesPath = ''
    )
    $node = (Get-Command node -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1)
    $modules = Resolve-MarkdownLintNodeModules $NodeModulesPath
    $markdownlintDir = Join-Path $modules 'markdownlint'
    if (-not $node) { throw 'md-lint: node not found on PATH; restore the shared Node payload with brewery/node/restore-node.ps1' }
    if (-not [System.IO.File]::Exists((Join-Path $markdownlintDir 'package.json'))) {
        throw "md-lint: markdownlint not found under '$modules'; restore the shared Node payload with brewery/node/restore-node.ps1"
    }
    if (-not [System.IO.File]::Exists($script:MdLintJs)) { throw "md-lint: audit harness not found: '$script:MdLintJs'" }
    $argv = @($script:MdLintJs, '--markdownlint', $markdownlintDir, '--file', $Path)
    if ($Config) { $argv += @('--config', $Config) }
    $out = & $node.Source @argv
    if ($LASTEXITCODE -ne 0) { throw "md-lint: md-lint.js failed (exit $LASTEXITCODE): $out" }
    return ($out | ConvertFrom-Json)
}
