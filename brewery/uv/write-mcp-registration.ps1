#requires -Version 7.0
<#
.SYNOPSIS
  Generate procurement MCP registrations for the current checkout.

.DESCRIPTION
  The registration uses the standalone uv executable restored under packages/uv. Project-owned paths
  remain relative to the repository root, matching project-local MCP configuration semantics. Existing
  unrelated entries in .mcp.json and .codex/config.toml are preserved.
#>
[CmdletBinding()]
param(
    [string] $RepositoryRoot,
    [string] $McpJsonPath,
    [string] $CodexConfigPath
)

$ErrorActionPreference = 'Stop'

function ConvertTo-TomlString([string] $Value) {
    return '"' + $Value.Replace('\', '\\').Replace('"', '\"') + '"'
}

function Write-Utf8Text([string] $Path, [string] $Text) {
    $parent = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetFullPath($Path))
    if ($parent) { [System.IO.Directory]::CreateDirectory($parent) | Out-Null }
    $normalized = $Text.Replace("`r`n", "`n").Replace("`r", "`n")
    [System.IO.File]::WriteAllText(
        [System.IO.Path]::GetFullPath($Path),
        $normalized,
        [System.Text.UTF8Encoding]::new($false))
}

$repoRoot = if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
}
else {
    [System.IO.Path]::GetFullPath($RepositoryRoot)
}
if (-not [System.IO.Directory]::Exists($repoRoot)) {
    throw "repository root is not a directory: $repoRoot"
}

$pinPath = Join-Path $PSScriptRoot 'pin.json'
$pin = Get-Content -LiteralPath $pinPath -Raw | ConvertFrom-Json -AsHashtable
$packageUv = Join-Path $repoRoot 'packages/uv/uv.exe'
foreach ($path in @($packageUv, (Join-Path $repoRoot 'uv.lock'))) {
    if (-not [System.IO.File]::Exists($path)) { throw "required restored file is missing: $path" }
}
$uvVersion = (& $packageUv --version | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $uvVersion -notmatch "^uv $([regex]::Escape($pin.version))\s") {
    throw "standalone uv version does not match pin $($pin.version): $uvVersion"
}

if ([string]::IsNullOrWhiteSpace($McpJsonPath)) {
    $McpJsonPath = Join-Path $repoRoot '.mcp.json'
}
if ([string]::IsNullOrWhiteSpace($CodexConfigPath)) {
    $CodexConfigPath = Join-Path $repoRoot '.codex/config.toml'
}

$runtimeUv = './packages/uv/uv.exe'
$runtimeArgs = @(
    'run',
    '--project', '.',
    '--locked',
    '--no-sync',
    '--no-dev',
    '--offline',
    'scientiae-procurement'
)
$runtimeTemp = Join-Path $repoRoot 'artifacts/procurement-mcp/temp'
[System.IO.Directory]::CreateDirectory($runtimeTemp) | Out-Null
$runtimeEnvironment = [ordered]@{
    CODEX_SCIENTIAE_ROOT = '.'
    UV_PROJECT_ENVIRONMENT = './.venv'
    UV_PYTHON_INSTALL_DIR = './packages/python'
    UV_CACHE_DIR = './artifacts/uv/cache'
    UV_NO_PROGRESS = '1'
    TEMP = './artifacts/procurement-mcp/temp'
    TMP = './artifacts/procurement-mcp/temp'
    TMPDIR = './artifacts/procurement-mcp/temp'
    VIRTUAL_ENV = ''
    PYTHONHOME = ''
    PYTHONPATH = ''
}

$mcpDocument = if ([System.IO.File]::Exists($McpJsonPath)) {
    Get-Content -LiteralPath $McpJsonPath -Raw | ConvertFrom-Json -AsHashtable
}
else {
    [ordered]@{}
}
if (-not $mcpDocument.ContainsKey('mcpServers')) {
    $mcpDocument['mcpServers'] = [ordered]@{}
}
$mcpDocument['mcpServers']['scientiae-procurement'] = [ordered]@{
    command = $runtimeUv
    args = $runtimeArgs
    env = $runtimeEnvironment
}
$mcpText = ($mcpDocument | ConvertTo-Json -Depth 20) + [Environment]::NewLine
Write-Utf8Text -Path $McpJsonPath -Text $mcpText

$tomlArgs = ($runtimeArgs | ForEach-Object { ConvertTo-TomlString $_ }) -join ', '
$tomlEnvironment = ($runtimeEnvironment.GetEnumerator() | ForEach-Object {
        "$($_.Key) = $(ConvertTo-TomlString ([string]$_.Value))"
    }) -join ', '
$tomlBlock = @"
[mcp_servers.scientiae-procurement]
command = $(ConvertTo-TomlString $runtimeUv)
args = [$tomlArgs]
env = { $tomlEnvironment }
"@
$codexText = if ([System.IO.File]::Exists($CodexConfigPath)) {
    Get-Content -LiteralPath $CodexConfigPath -Raw
}
else {
    ''
}
$sectionPattern = '(?ms)^\[mcp_servers\.scientiae-procurement\]\r?\n.*?(?=^\[|\z)'
if ([regex]::IsMatch($codexText, $sectionPattern)) {
    $codexText = [regex]::Replace($codexText, $sectionPattern, $tomlBlock.TrimEnd() + [Environment]::NewLine)
}
else {
    if ($codexText.Length -gt 0 -and -not $codexText.EndsWith("`n")) {
        $codexText += [Environment]::NewLine
    }
    if ($codexText.Length -gt 0) { $codexText += [Environment]::NewLine }
    $codexText += $tomlBlock.TrimEnd() + [Environment]::NewLine
}
Write-Utf8Text -Path $CodexConfigPath -Text $codexText

[pscustomobject]@{
    repository_root = $repoRoot
    uv = $packageUv
    runtime_command = $runtimeUv
    uv_version = $uvVersion
    mcp_json = [System.IO.Path]::GetFullPath($McpJsonPath)
    codex_config = [System.IO.Path]::GetFullPath($CodexConfigPath)
    args = $runtimeArgs
}
