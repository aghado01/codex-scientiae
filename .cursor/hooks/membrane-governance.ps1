#requires -Version 7.0
<#
  .cursor/hooks/membrane-governance.ps1 — Cursor adapter for .claude/governance/contract.json

  Advisory-first: logs fires and injects steering text; never blocks unless a rule is mode=enforce.
  Wired from .cursor/hooks.json; -CursorEvent names the Cursor hook surface (not Claude's PreToolUse).

  stdout: Cursor hook JSON only. Logs: .claude/governance/logs/fires.jsonl
#>
param(
    [Parameter(Mandatory)]
    [ValidateSet('beforeShellExecution', 'beforeReadFile', 'preToolUse', 'stop')]
    [string]$CursorEvent
)

$ErrorActionPreference = 'Stop'
$utf8 = [System.Text.UTF8Encoding]::new($false)
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$contractPath = Join-Path $repoRoot '.claude/governance/contract.json'
$logDir = Join-Path $repoRoot '.claude/governance/logs'
$logPath = Join-Path $logDir 'fires.jsonl'

function Write-Diag([string]$m) { [Console]::Error.WriteLine("[membrane-governance] $m") }
function Emit-Cursor([hashtable]$obj) {
    [Console]::Out.WriteLine(($obj | ConvertTo-Json -Compress -Depth 6))
    exit 0
}

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { Emit-Cursor @{ permission = 'allow' } }

try { $payload = $raw | ConvertFrom-Json } catch { Write-Diag 'unparseable hook payload'; Emit-Cursor @{ permission = 'allow' } }

# Map Cursor hook events → contract event + tool/arg extraction
$contractEvent = switch ($CursorEvent) {
    'beforeShellExecution' { 'PreToolUse' }
    'beforeReadFile'       { 'PreToolUse' }
    'preToolUse'           { 'PreToolUse' }
    'stop'                 { 'Stop' }
}

$tool = switch ($CursorEvent) {
    'beforeShellExecution' { 'Shell' }
    'beforeReadFile'       { 'Read' }
    'preToolUse'           { [string]($payload.tool_name ?? '') }
    'stop'                 { '*' }
}

$inp = $payload.tool_input
$arg = switch ($CursorEvent) {
    'beforeShellExecution' { [string]($payload.command ?? $inp.command ?? '') }
    'beforeReadFile'       { [string]($payload.path ?? $payload.file_path ?? $inp.path ?? $inp.file_path ?? '') }
    'preToolUse' {
        switch -Regex ($tool) {
            '^(Shell|PowerShell)$'              { [string]($inp.command ?? '') }
            '^(Read|Write|Edit|StrReplace|Delete)$' { [string]($inp.path ?? $inp.file_path ?? $inp.target_notebook ?? '') }
            default {
                if ($null -eq $inp) { '' }
                else { (($inp.PSObject.Properties | Where-Object { $_.Value -is [string] } | ForEach-Object { $_.Value }) -join ' ') }
            }
        }
    }
    default { '' }
}
$arg = ($arg -replace '\\', '/')

try { $contract = [System.IO.File]::ReadAllText($contractPath, $utf8) | ConvertFrom-Json }
catch { Write-Diag "no readable contract at $contractPath"; Emit-Cursor @{ permission = 'allow' } }
$defaultMode = if ($contract.defaults.mode) { [string]$contract.defaults.mode } else { 'advisory' }

function Convert-GlobToRegex([string]$g) {
    $e = [regex]::Escape($g)
    $e = $e -replace '\\\*\\\*', '.*'
    $e = $e -replace '\\\*', '.*'
    $e = $e -replace '\\\?', '.'
    return "^(?i)$e$"
}
function Test-MatchAlt([string]$value, [string]$alt) {
    if ($alt -eq '*') { return $true }
    foreach ($p in ($alt -split '\|')) {
        if ([string]::IsNullOrWhiteSpace($p)) { continue }
        if ([regex]::IsMatch($value, (Convert-GlobToRegex $p))) { return $true }
    }
    return $false
}
function Test-ToolMatch([string]$tool, [string]$alt) {
    if (Test-MatchAlt $tool $alt) { return $true }
    if ($tool -eq 'Shell' -and (Test-MatchAlt 'Bash' $alt -or Test-MatchAlt 'PowerShell' $alt)) { return $true }
    if ($tool -eq 'StrReplace' -and (Test-MatchAlt 'Write' $alt -or Test-MatchAlt 'Edit' $alt)) { return $true }
    return $false
}

$fired = foreach ($r in $contract.rules) {
    if (([string]$r.event) -ne $contractEvent) { continue }
    if ((Test-ToolMatch $tool ([string]$r.match.tool)) -and (Test-MatchAlt $arg ([string]$r.match.arg))) { $r }
}
$fired = @($fired)
if (-not $fired.Count) {
    switch ($CursorEvent) {
        'stop' { Emit-Cursor @{} }
        default { Emit-Cursor @{ permission = 'allow' } }
    }
}

if (-not (Test-Path -LiteralPath $logDir)) { New-Item -ItemType Directory -Force -Path $logDir | Out-Null }
$ts = (Get-Date).ToString('o')
$argExcerpt = if ($arg.Length -gt 200) { $arg.Substring(0, 200) } else { $arg }
$sb = [System.Text.StringBuilder]::new()
foreach ($r in $fired) {
    $mode = if ($r.mode) { [string]$r.mode } else { $defaultMode }
    $rec = [ordered]@{
        ts = $ts; rule = [string]$r.name; cursor_event = $CursorEvent; contract_event = $contractEvent
        tool = $tool; mode = $mode; outcome = [string]$r.outcome; arg = $argExcerpt
        session = [string]($payload.conversation_id ?? $payload.session_id ?? '')
    }
    [void]$sb.AppendLine(($rec | ConvertTo-Json -Compress))
}
[System.IO.File]::AppendAllText($logPath, $sb.ToString(), $utf8)

$messages = ($fired | ForEach-Object { "[$([string]$_.name)] $([string]$_.message)" }) -join "`n"
$enforce = @($fired | Where-Object { $m = if ($_.mode) { [string]$_.mode } else { $defaultMode }; $m -eq 'enforce' })

if ($CursorEvent -eq 'stop') {
    Emit-Cursor @{ followup_message = $messages }
}

if ($enforce.Count) {
    Emit-Cursor @{ permission = 'deny'; agent_message = $messages; user_message = $messages }
}

Emit-Cursor @{ permission = 'allow'; agent_message = $messages }
