#requires -Version 7.0
<#
  src/shared/logger/logger.ps1 — per-run execution trace, as a shared substrate.

  Any codex process gets ONE trace file per run — JSONL, one record per line — and a
  near-silent console: the file records everything, stderr mirrors warn+ only, and stdout is
  never touched (lane scripts emit data there and the MCP servers speak protocol there; a
  logger that writes to stdout corrupts both). Adapted from the ps.core.tooldig loggers —
  RepoLogger's file-first shape, CyberneticLogger's JSONL records — rebuilt on house
  invariants: UTF-8-no-BOM, LF, explicit .NET I/O.

  Record shape (slice with Get-RunLog here, the jsonl_engine-client cmdlets over src/jsonl_engine,
  or the jso-jackson utilities):
    { ts, el, lvl, comp, msg, data? }
  el = ms elapsed since Start-RunLog — the execution trace's clock; comp defaults to the
  module and is overridden per call when a sub-area speaks.

  Sink resolution, first hit wins:
    -LogPath <file>          exactly there
    -RunDir <dir>            trace.jsonl inside a run dir the caller already minted
                             (New-ModuleRunDir in src/logistics/run-paths.ps1)
    $env:CODEX_RUNLOG_DIR    a parent process's run dir; the child lands beside the parent
                             as trace-{module}-{pid}.jsonl — never a shared handle
    (minted)                 artifacts/{module}/logs/{stamp}.jsonl — regenerable tier,
                             gitignored wholesale

  Config: -FileLevel / -ConsoleLevel on Start-RunLog; $env:CODEX_RUNLOG_LEVEL and
  $env:CODEX_RUNLOG_CONSOLE override per run without touching call sites ('off' disables a
  sink). Appends are per-record ([File]::AppendAllText — crash-safe, no handle discipline,
  safe under the multi-agent concurrency this repo actually runs).

  A second Start-RunLog in the same process JOINS the live context, so composed lanes
  (latex-ingest sourcing tex-render) trace into one file; -Force replaces it. Write-RunLog
  before any Start is safe: warn+ still reaches stderr, the file sink is just off — shared
  substrate may log opportunistically without demanding its host started a run.

  Dot-source to use:  src/shared/logger/logger.ps1
#>

$script:RunLogLevels = @{ trace = 0; debug = 1; info = 2; warn = 3; error = 4 }
$script:RunLog = $null          # live context: Path, Module, FileLevel, ConsoleLevel, Clock, Counts
$script:RunLogNoticed = $false  # one-time "not started" stderr notice

# level name -> rank; '' -> fallback (env unset), 'off' -> 99 (sink disabled)
function Resolve-RunLogLevel([string]$Name, [int]$Fallback) {
    if ([string]::IsNullOrWhiteSpace($Name)) { return $Fallback }
    $n = $Name.Trim().ToLowerInvariant()
    if ($n -eq 'off') { return 99 }
    if ($script:RunLogLevels.ContainsKey($n)) { return $script:RunLogLevels[$n] }
    return $Fallback
}

# stderr only — split out so tests can capture/mock the mirror without touching the file sink
function Write-RunLogConsole([string]$Level, [string]$Component, [string]$Message) {
    $tag = $Level.ToUpperInvariant().PadRight(5)
    $c = if ($Component) { "[$Component] " } else { '' }
    [Console]::Error.WriteLine("$tag $c$Message")
}

function Start-RunLog {
    <#
    .SYNOPSIS  Open the per-run trace sink; returns the log path.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Module,
        [string] $RunDir = '',
        [string] $LogPath = '',
        [ValidateSet('trace', 'debug', 'info', 'warn', 'error', 'off')] [string] $FileLevel = 'trace',
        [ValidateSet('trace', 'debug', 'info', 'warn', 'error', 'off')] [string] $ConsoleLevel = 'warn',
        [System.Collections.IDictionary] $Data,
        [switch] $Export,   # export the log's dir as CODEX_RUNLOG_DIR so spawned children join this run
        [switch] $Force
    )
    if ($script:RunLog -and -not $Force) {
        Write-RunLog -Level debug -Component $Module -Message "joined live run log (started by $($script:RunLog.Module))"
        return $script:RunLog.Path
    }

    $path = $LogPath
    if (-not $path) {
        $dir = $RunDir
        if (-not $dir -and $env:CODEX_RUNLOG_DIR) { $dir = $env:CODEX_RUNLOG_DIR }
        if ($dir) {
            $path = Join-Path $dir 'trace.jsonl'
            # taken = another process owns it (runs are immutable-new, so a fresh run dir never
            # collides with itself) — land beside it, never share the file
            if (Test-Path -LiteralPath $path) { $path = Join-Path $dir "trace-$Module-$PID.jsonl" }
        } else {
            # mirrors Get-ArtifactsRoot (src/logistics/run-paths.ps1), which is now crawler-free and
            # importable if this duplicate is no longer worth keeping. Depth is from src/shared/logger/.
            $logsRoot = Join-Path ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))) 'artifacts' $Module 'logs'
            $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
            $path = Join-Path $logsRoot "$stamp.jsonl"
            $n = 1
            while (Test-Path -LiteralPath $path) { $n++; $path = Join-Path $logsRoot "$stamp-$n.jsonl" }
        }
    }
    $dirName = [System.IO.Path]::GetDirectoryName($path)
    if ($dirName -and -not (Test-Path -LiteralPath $dirName)) {
        New-Item -ItemType Directory -Force -Path $dirName | Out-Null
    }

    $script:RunLog = @{
        Path         = $path
        Module       = $Module
        FileLevel    = Resolve-RunLogLevel $env:CODEX_RUNLOG_LEVEL (Resolve-RunLogLevel $FileLevel 0)
        ConsoleLevel = Resolve-RunLogLevel $env:CODEX_RUNLOG_CONSOLE (Resolve-RunLogLevel $ConsoleLevel 3)
        Clock        = [System.Diagnostics.Stopwatch]::StartNew()
        Counts       = @{ trace = 0; debug = 0; info = 0; warn = 0; error = 0 }
    }
    if ($Export) { $env:CODEX_RUNLOG_DIR = $dirName }

    $start = [ordered]@{ module = $Module; pid = $PID }
    if ($Data) { foreach ($k in $Data.Keys) { $start[$k] = $Data[$k] } }
    Write-RunLog -Level info -Message 'run start' -Data $start
    return $path
}

function Write-RunLog {
    <#
    .SYNOPSIS  One trace record. File sink gets everything >= FileLevel; stderr mirrors >= ConsoleLevel.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Message,
        [ValidateSet('trace', 'debug', 'info', 'warn', 'error')] [string] $Level = 'info',
        [string] $Component = '',
        [System.Collections.IDictionary] $Data
    )
    $ctx = $script:RunLog
    $lvl = $script:RunLogLevels[$Level]
    if (-not $ctx) {
        # not started: file sink off, but a warn/error must never vanish
        if (-not $script:RunLogNoticed) {
            $script:RunLogNoticed = $true
            [Console]::Error.WriteLine('run log not started - file sink off (warn+ still mirrors here)')
        }
        if ($lvl -ge 3) { Write-RunLogConsole $Level $Component $Message }
        return
    }
    $ctx.Counts[$Level]++
    $comp = if ($Component) { $Component } else { $ctx.Module }
    if ($lvl -ge $ctx.FileLevel) {
        $rec = [ordered]@{
            ts   = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss.fffzzz'
            el   = $ctx.Clock.ElapsedMilliseconds
            lvl  = $Level
            comp = $comp
            msg  = $Message
        }
        if ($Data) { $rec['data'] = $Data }
        $json = $rec | ConvertTo-Json -Compress -Depth 8
        [System.IO.File]::AppendAllText($ctx.Path, $json + "`n", [System.Text.UTF8Encoding]::new($false))
    }
    if ($lvl -ge $ctx.ConsoleLevel) { Write-RunLogConsole $Level $comp $Message }
}

function Measure-RunStep {
    <#
    .SYNOPSIS  Timed scope: step start at trace, step end at debug with ms; an exception logs
               error (ok=false, duration kept) and RETHROWS — the trace observes, never swallows.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Name,
        [Parameter(Mandatory, Position = 1)] [scriptblock] $Script,
        [string] $Component = ''
    )
    Write-RunLog -Level trace -Component $Component -Message "step start: $Name"
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $result = & $Script
        Write-RunLog -Level debug -Component $Component -Message "step end: $Name" -Data @{ step = $Name; ms = $sw.ElapsedMilliseconds; ok = $true }
        return $result
    } catch {
        Write-RunLog -Level error -Component $Component -Message "step failed: $Name - $($_.Exception.Message)" -Data @{ step = $Name; ms = $sw.ElapsedMilliseconds; ok = $false }
        throw
    }
}

function Stop-RunLog {
    <#
    .SYNOPSIS  Final record (total ms + warn/error counts), close the context; returns the path.
    #>
    [CmdletBinding()]
    param([System.Collections.IDictionary] $Data)
    $ctx = $script:RunLog
    if (-not $ctx) { return $null }
    $summary = [ordered]@{ ms = $ctx.Clock.ElapsedMilliseconds; warn = $ctx.Counts['warn']; error = $ctx.Counts['error'] }
    if ($Data) { foreach ($k in $Data.Keys) { $summary[$k] = $Data[$k] } }
    Write-RunLog -Level info -Message 'run end' -Data $summary
    $script:RunLog = $null
    return $ctx.Path
}

function Get-RunLog {
    <#
    .SYNOPSIS  Parse a trace back to objects; -MinLevel / -Component slice it.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [ValidateSet('trace', 'debug', 'info', 'warn', 'error')] [string] $MinLevel = 'trace',
        [string] $Component = ''
    )
    $min = $script:RunLogLevels[$MinLevel]
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $r = $line | ConvertFrom-Json
        if ($script:RunLogLevels[$r.lvl] -lt $min) { continue }
        if ($Component -and $r.comp -ne $Component) { continue }
        $out.Add($r)
    }
    return $out
}
