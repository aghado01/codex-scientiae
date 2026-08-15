#requires -Version 7.0
<#
.SYNOPSIS
  Generate procurement MCP registrations for the current checkout.

.DESCRIPTION
  The registration uses the uv executable copied into the project environment. Absolute paths are
  generated from RepositoryRoot because MCP clients may start the process from any working directory.
  Existing unrelated entries in .mcp.json and .codex/config.toml are preserved.
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
$localUv = Join-Path $repoRoot '.venv/Scripts/uv.exe'
$packageUv = Join-Path $repoRoot 'packages/uv/uv.exe'
foreach ($path in @($localUv, $packageUv, (Join-Path $repoRoot 'uv.lock'))) {
    if (-not [System.IO.File]::Exists($path)) { throw "required restored file is missing: $path" }
}
if ((Get-FileHash -LiteralPath $localUv -Algorithm SHA256).Hash -cne
    (Get-FileHash -LiteralPath $packageUv -Algorithm SHA256).Hash) {
    throw 'the project-local uv executable differs from the verified package shelf'
}
$uvVersion = (& $localUv --version | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $uvVersion -notmatch "^uv $([regex]::Escape($pin.version))\s") {
    throw "project-local uv version does not match pin $($pin.version): $uvVersion"
}

if ([string]::IsNullOrWhiteSpace($McpJsonPath)) {
    $McpJsonPath = Join-Path $repoRoot '.mcp.json'
}
if ([string]::IsNullOrWhiteSpace($CodexConfigPath)) {
    $CodexConfigPath = Join-Path $repoRoot '.codex/config.toml'
}

$runtimeArgs = @(
    'run',
    '--project', $repoRoot,
    '--locked',
    '--no-sync',
    '--no-dev',
    '--offline',
    'scientiae-procurement'
)
$runtimeTemp = Join-Path $repoRoot 'artifacts/procurement-mcp/temp'
[System.IO.Directory]::CreateDirectory($runtimeTemp) | Out-Null
$runtimeEnvironment = [ordered]@{
    CODEX_SCIENTIAE_ROOT = $repoRoot
    UV_PROJECT_ENVIRONMENT = (Join-Path $repoRoot '.venv')
    UV_PYTHON_INSTALL_DIR = (Join-Path $repoRoot 'packages/python')
    UV_CACHE_DIR = (Join-Path $repoRoot 'artifacts/uv/cache')
    UV_NO_PROGRESS = '1'
    TEMP = $runtimeTemp
    TMP = $runtimeTemp
    TMPDIR = $runtimeTemp
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
    command = $localUv
    args = $runtimeArgs
    env = $runtimeEnvironment
}
$mcpText = ($mcpDocument | ConvertTo-Json -Depth 20) + [Environment]::NewLine
Write-Utf8Text -Path $McpJsonPath -Text $mcpText

$tomlRuntimeArgs = @($runtimeArgs)
$tomlRuntimeArgs[2] = $repoRoot.Replace('\', '/')
$tomlArgs = ($tomlRuntimeArgs | ForEach-Object { ConvertTo-TomlString $_ }) -join ', '
$tomlEnvironment = ($runtimeEnvironment.GetEnumerator() | ForEach-Object {
        "$($_.Key) = $(ConvertTo-TomlString ([string]$_.Value))"
    }) -join ', '
$tomlBlock = @"
[mcp_servers.scientiae-procurement]
command = $(ConvertTo-TomlString ($localUv.Replace('\', '/')))
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
    uv = $localUv
    uv_version = $uvVersion
    mcp_json = [System.IO.Path]::GetFullPath($McpJsonPath)
    codex_config = [System.IO.Path]::GetFullPath($CodexConfigPath)
    args = $runtimeArgs
}
