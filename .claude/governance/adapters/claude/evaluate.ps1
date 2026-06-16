#requires -Version 7.0
<#
  .claude/governance/adapters/claude/evaluate.ps1 — Claude Code reference adapter (runtime half).

  Wired into a Claude harness by compile.ps1. On each matched tool call Claude pipes the hook payload
  (JSON) to this script's stdin. We:
    1. resolve the rule(s) in contract.json whose event+tool+arg match this call,
    2. append one fire record per match to logs/fires.jsonl (the deny-rate instrument),
    3. emit a single hook-decision JSON on stdout — an advisory nudge (mode=advisory) or a permission
       deny (mode=enforce). Default mode is advisory, so this never blocks until you flip a rule.

  Stream discipline (STANDARDS.md §7): stdout carries ONLY the one decision object; the durable log goes
  to a file via .NET I/O; any diagnostics go to stderr. Nothing else may touch stdout.
#>

$ErrorActionPreference = 'Stop'
$utf8 = [System.Text.UTF8Encoding]::new($false)
$here = $PSScriptRoot
$govRoot = Split-Path -Parent (Split-Path -Parent $here)   # .claude/governance
$contractPath = Join-Path $govRoot 'contract.json'
$logDir = Join-Path $govRoot 'logs'
$logPath = Join-Path $logDir 'fires.jsonl'

function Write-Diag([string]$m) { [Console]::Error.WriteLine("[governance] $m") }

# --- read the hook payload (fail open: a parse problem must never wedge the agent) ---
$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { Write-Diag 'unparseable hook payload'; exit 0 }

$event = if ($payload.hook_event_name) { [string]$payload.hook_event_name } else { '' }
$tool  = if ($payload.tool_name) { [string]$payload.tool_name } else { '' }
$inp   = $payload.tool_input

# the single argument each matcher tests, per tool family
function Get-Arg($t, $i) {
    switch -Regex ($t) {
        '^(Bash|PowerShell)$'              { return [string]$i.command }
        '^(Read|Write|Edit|NotebookEdit)$' { return [string]($i.file_path ?? $i.notebook_path) }
        default {
            if ($null -eq $i) { return '' }
            return (($i.PSObject.Properties | Where-Object { $_.Value -is [string] } | ForEach-Object { $_.Value }) -join ' ')
        }
    }
}
$arg = (Get-Arg $tool $inp) -replace '\\', '/'

# --- load the contract ---
try { $contract = [System.IO.File]::ReadAllText($contractPath, $utf8) | ConvertFrom-Json }
catch { Write-Diag "no readable contract at $contractPath"; exit 0 }
$defaultMode = if ($contract.defaults.mode) { [string]$contract.defaults.mode } else { 'advisory' }

# glob -> regex. Permissive (* and ** both -> .*): over-match is acceptable for advisory logging;
# tighten a rule's arg pattern before flipping it to enforce.
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

# --- resolve matching rules for this event ---
$fired = foreach ($r in $contract.rules) {
    if (([string]$r.event) -ne $event) { continue }
    if ((Test-MatchAlt $tool ([string]$r.match.tool)) -and (Test-MatchAlt $arg ([string]$r.match.arg))) { $r }
}
$fired = @($fired)
if (-not $fired.Count) { exit 0 }

# --- log every fire (durable; .NET I/O; UTF-8 no-BOM; explicit LF; never stdout) ---
if (-not (Test-Path -LiteralPath $logDir)) { New-Item -ItemType Directory -Force -Path $logDir | Out-Null }
$ts = (Get-Date).ToString('o')
$argExcerpt = if ($arg.Length -gt 200) { $arg.Substring(0, 200) } else { $arg }
$sb = [System.Text.StringBuilder]::new()
foreach ($r in $fired) {
    $mode = if ($r.mode) { [string]$r.mode } else { $defaultMode }
    $rec = [ordered]@{ ts = $ts; rule = [string]$r.name; event = $event; tool = $tool; mode = $mode
                       outcome = [string]$r.outcome; arg = $argExcerpt; session = [string]$payload.session_id }
    [void]$sb.AppendLine(($rec | ConvertTo-Json -Compress))
}
[System.IO.File]::AppendAllText($logPath, $sb.ToString(), $utf8)

# --- decide: strongest outcome wins; enforce beats advisory ---
$messages = ($fired | ForEach-Object { "[$([string]$_.name)] $([string]$_.message)" }) -join "`n"
$enforce  = @($fired | Where-Object { $m = if ($_.mode) { [string]$_.mode } else { $defaultMode }; $m -eq 'enforce' })

# ---- emission boundary -------------------------------------------------------------------------
# These key names track the Claude Code hook output contract. If your installed version differs,
# this is the ONE place to adjust (see README "Caveats"). Deny: permissionDecision=deny. Advisory:
# allow + inject the nudge via additionalContext / systemMessage. Unknown keys are ignored by Claude.
if ($event -eq 'PreToolUse' -and $enforce.Count) {
    $out = @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny'; permissionDecisionReason = $messages } }
} else {
    $out = @{ continue = $true; suppressOutput = $true; systemMessage = $messages
              hookSpecificOutput = @{ hookEventName = $event; additionalContext = $messages } }
}
[Console]::Out.WriteLine(($out | ConvertTo-Json -Depth 6 -Compress))
exit 0
