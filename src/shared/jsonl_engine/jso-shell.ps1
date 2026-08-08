#requires -Version 7.0
<#
  src/shared/jsonl_engine/jso-shell.ps1 — shell surface over the Python JSONL engine.

  A front-end, not an implementation. Every cmdlet here marshals arguments to
  `python -m jsonl_engine` and converts one stream of JSON back. Nothing in this file parses JSONL,
  resolves a JSON Pointer, derives a sidecar path, or knows the JSOI format — those live in the
  engine, and a second copy of them in PowerShell is exactly what this replaces.

  It exists because a query language earns its keep only where expressions arrive as strings from
  outside the process. That is what a prompt is. The engine itself deliberately has no query method:
  in Python a comprehension is clearer and fails loudly on a mistyped key, where a query expression
  returns an empty result.

  Reads are bounded at the last complete record by default, so pointing a cmdlet at a store another
  process is appending to yields whole records rather than a torn final one. -AtSignature reads only
  what the .sig attests to; -Unbounded reads to EOF and is the one that can tear.

    Get-JsonlInfo        physical facts, without parsing
    Get-JsonlCount       number of records
    Get-JsonlHead        first N
    Get-JsonlTail        last N
    Get-JsonlRange       [start, stop)
    Get-JsonlRecord      one record by index
    Select-JsonlPath     project a JSON Pointer from each record
    Find-JsonlRecord     records matching a pointer predicate
    Test-JsonlStore      check a store against its .sig
    Get-JsonlSignature   the .sig itself
    New-JsonlSnapshot    copy the complete-record prefix elsewhere
    Get-JsonlSchema      schemas the engine ships
    Read-JsonDocument    one single-object .json
#>

Set-StrictMode -Version Latest

# Declared before first use: under StrictMode, reading an unset variable is an error rather than
# $null, so the interpreter cache has to exist before the lookup that populates it.
$script:JsonlEnginePython = $null

function script:Resolve-JsonlEnginePython {
    <#
      The interpreter that has jsonl_engine importable: the repository's venv when there is one,
      otherwise whatever `python` resolves to. Cached per session, because resolving it walks the
      tree and the answer does not change mid-session.
    #>
    if ($script:JsonlEnginePython) { return $script:JsonlEnginePython }

    $current = $PSScriptRoot
    while ($current) {
        foreach ($sentinel in @('AGENTS.md', '.git', 'Directory.Build.props')) {
            if (Test-Path -LiteralPath (Join-Path $current $sentinel)) {
                $venv = Join-Path $current '.venv/Scripts/python.exe'
                if (Test-Path -LiteralPath $venv) {
                    $script:JsonlEnginePython = (Resolve-Path -LiteralPath $venv).Path
                    return $script:JsonlEnginePython
                }
                $venv = Join-Path $current '.venv/bin/python'
                if (Test-Path -LiteralPath $venv) {
                    $script:JsonlEnginePython = (Resolve-Path -LiteralPath $venv).Path
                    return $script:JsonlEnginePython
                }
            }
        }
        $parent = Split-Path -Parent $current
        if ($parent -eq $current) { break }
        $current = $parent
    }

    $fallback = Get-Command python -ErrorAction SilentlyContinue
    if (-not $fallback) {
        throw 'No Python interpreter found for jsonl_engine. Expected a repository .venv or python on PATH.'
    }
    $script:JsonlEnginePython = $fallback.Source
    return $script:JsonlEnginePython
}

function script:Invoke-JsonlEngine {
    <#
      Run one engine verb and emit its records as objects.

      The engine writes UTF-8 bytes on stdout regardless of the console code page, so the console
      encoding is pinned for the duration of the call rather than trusted. Without that, SMP math
      and ligatures come back as replacement characters on a default Windows console — the same
      codepoint discipline the rest of this repository holds to.
    #>
    param(
        [Parameter(Mandatory)][string[]]$EngineArgs,
        [switch]$AsHashtable
    )

    $python = script:Resolve-JsonlEnginePython
    $priorOut = [Console]::OutputEncoding
    $priorPS = $OutputEncoding
    try {
        [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
        $OutputEncoding = [System.Text.UTF8Encoding]::new($false)

        $stdout = & $python -m jsonl_engine @EngineArgs 2>&1
        $failed = $LASTEXITCODE -ne 0
    } finally {
        [Console]::OutputEncoding = $priorOut
        $OutputEncoding = $priorPS
    }

    $lines = @($stdout | Where-Object { $_ -and "$_".Trim() })
    if ($failed) {
        # Parse inside the try, throw outside it: a throw raises a RuntimeException, so throwing
        # from within the try would be caught by its own catch and reported as unparseable.
        $detail = if ($lines) { "$($lines[-1])" } else { 'no detail' }
        $parsed = $null
        try { $parsed = $detail | ConvertFrom-Json -ErrorAction Stop } catch { $parsed = $null }

        if ($parsed -and $parsed.PSObject.Properties.Name -contains 'error') {
            throw "jsonl_engine $($EngineArgs[0]): $($parsed.error): $($parsed.message)"
        }
        throw "jsonl_engine $($EngineArgs[0]) failed: $detail"
    }

    foreach ($line in $lines) {
        if ($AsHashtable) { "$line" | ConvertFrom-Json -AsHashtable }
        else { "$line" | ConvertFrom-Json }
    }
}

function script:Add-JsonlViewArgs {
    <# Translate the shared view switches into engine flags. #>
    param([hashtable]$Bound, [string[]]$EngineArgs)
    if ($Bound.ContainsKey('AtSignature') -and $Bound.AtSignature) { $EngineArgs += '--at-signature' }
    if ($Bound.ContainsKey('Unbounded') -and $Bound.Unbounded) { $EngineArgs += '--unbounded' }
    return $EngineArgs
}

function Get-JsonlInfo {
    <# Physical facts about a store: size, records, terminator, which sidecars exist. No parsing. #>
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Path)
    script:Invoke-JsonlEngine -EngineArgs @('info', $Path)
}

function Get-JsonlCount {
    <# Number of records. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [switch]$AtSignature, [switch]$Unbounded
    )
    $a = script:Add-JsonlViewArgs $PSBoundParameters @('count', $Path)
    (script:Invoke-JsonlEngine -EngineArgs $a).count
}

function Get-JsonlHead {
    <# First -Count records. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Position = 1)][int]$Count = 10,
        [switch]$AsHashtable, [switch]$AtSignature, [switch]$Unbounded
    )
    $a = script:Add-JsonlViewArgs $PSBoundParameters @('head', $Path, '-n', "$Count")
    script:Invoke-JsonlEngine -EngineArgs $a -AsHashtable:$AsHashtable
}

function Get-JsonlTail {
    <# Last -Count records. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Position = 1)][int]$Count = 10,
        [switch]$AsHashtable, [switch]$AtSignature, [switch]$Unbounded
    )
    $a = script:Add-JsonlViewArgs $PSBoundParameters @('tail', $Path, '-n', "$Count")
    script:Invoke-JsonlEngine -EngineArgs $a -AsHashtable:$AsHashtable
}

function Get-JsonlRange {
    <# Records in [Start, Stop). Stop defaults to the end. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, Position = 1)][int]$Start,
        [Parameter(Position = 2)][Nullable[int]]$Stop,
        [switch]$AsHashtable, [switch]$AtSignature, [switch]$Unbounded
    )
    $a = @('range', $Path, "$Start")
    if ($null -ne $Stop) { $a += "$Stop" }
    $a = script:Add-JsonlViewArgs $PSBoundParameters $a
    script:Invoke-JsonlEngine -EngineArgs $a -AsHashtable:$AsHashtable
}

function Get-JsonlRecord {
    <# One record by index. Negative indexes count from the end. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, Position = 1)][int]$At,
        [switch]$AsHashtable, [switch]$AtSignature, [switch]$Unbounded
    )
    $a = script:Add-JsonlViewArgs $PSBoundParameters @('get', $Path, "$At")
    script:Invoke-JsonlEngine -EngineArgs $a -AsHashtable:$AsHashtable
}

function Select-JsonlPath {
    <#
      Project one JSON Pointer from each record: '/slug', '/a/0/b', '/a~1b' for a property named
      'a/b'. Records where the pointer does not resolve are skipped rather than emitted as null,
      so "absent" and "null" stay distinguishable over a heterogeneous store.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, Position = 1)][string]$Pointer,
        [switch]$AtSignature, [switch]$Unbounded
    )
    $a = script:Add-JsonlViewArgs $PSBoundParameters @('select', $Path, $Pointer)
    script:Invoke-JsonlEngine -EngineArgs $a
}

function Find-JsonlRecord {
    <#
      Records whose Pointer satisfies a predicate. -Value is a JSON literal, so a string needs its
      quotes: -Value '"beta"'. Typed deliberately — 3 and "3" are different rows.

      .EXAMPLE
        Find-JsonlRecord ./inventory.jsonl /state eq '"source-ready"'
        Find-JsonlRecord ./blocks.jsonl /bbox/3 gt 700 -Limit 5
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, Position = 1)][string]$Pointer,
        [Parameter(Mandatory, Position = 2)]
        [ValidateSet('eq', 'ne', 'gt', 'lt', 'contains', 'exists', 'missing')][string]$Op,
        [Parameter(Position = 3)][string]$Value,
        [int]$Limit = 0,
        [switch]$AsHashtable, [switch]$AtSignature, [switch]$Unbounded
    )
    $a = @('find', $Path, $Pointer, $Op)
    if ($PSBoundParameters.ContainsKey('Value')) { $a += $Value }
    if ($Limit -gt 0) { $a += @('--limit', "$Limit") }
    $a = script:Add-JsonlViewArgs $PSBoundParameters $a
    script:Invoke-JsonlEngine -EngineArgs $a -AsHashtable:$AsHashtable
}

function Test-JsonlStore {
    <# Check a store against its .sig. `verified` is null when the store carries no signature. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [switch]$AtSignature, [switch]$Unbounded
    )
    $a = script:Add-JsonlViewArgs $PSBoundParameters @('verify', $Path)
    script:Invoke-JsonlEngine -EngineArgs $a
}

function Get-JsonlSignature {
    <# The .sig sidecar, including the encoding, codec, and eol the store was written under. #>
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Path)
    script:Invoke-JsonlEngine -EngineArgs @('sig', $Path)
}

function New-JsonlSnapshot {
    <#
      Copy the complete-record prefix of a store to another path, byte for byte.

      For reading a store something else is appending to without racing it. No re-serialization:
      a snapshot that reformatted its input would not match the source's .sig, which is most of
      what a snapshot is for.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, Position = 1)][string]$Destination
    )
    script:Invoke-JsonlEngine -EngineArgs @('snapshot', $Path, $Destination)
}

function Get-JsonlSchema {
    <# Schemas the engine ships, with the identity each declares. #>
    [CmdletBinding()]
    param()
    script:Invoke-JsonlEngine -EngineArgs @('schemas')
}

function Read-JsonDocument {
    <# One single-object .json, read under the engine's declared encoding rules. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [switch]$AsHashtable
    )
    script:Invoke-JsonlEngine -EngineArgs @('json', $Path) -AsHashtable:$AsHashtable
}
