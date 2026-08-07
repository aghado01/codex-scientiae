#requires -Version 7.0
<#
  src/shared/jso-ops/jsonl-v2-compat.ps1 — transitional adapters for jsonl-v2.ps1.

  Nothing imports this file today. It is deliberately separate so legacy naming and sidecar discovery
  can be deleted as one unit after migration. New code should dot-source jsonl-v2.ps1 directly.

  Compatibility currently provided:
    - Read-JsonlRecord, the old indexed-record function name;
    - discovery of the retired `records.jsonl.jidx` sidecar; and
    - read-only loading of JSOI v1 offsets when a legacy sidecar is selected.

  This file never writes the retired sidecar form. New indexes are always `{stem}.jidx` JSOI v2.
#>

. "$PSScriptRoot/jsonl-v2.ps1"

function Resolve-JsonlCompatibleIndexPath {
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Path)

    $full = [System.IO.Path]::GetFullPath($Path)
    $canonical = Resolve-JsonlIndexPath $full
    if ([System.IO.File]::Exists($canonical)) { return $canonical }
    $legacy = "$full.jidx"
    if ([System.IO.File]::Exists($legacy)) { return $legacy }
    return $canonical
}

function script:Read-JsonlV1IndexCompat {
    param(
        [Parameter(Mandatory)][string]$IndexPath,
        [Parameter(Mandatory)][string]$Path
    )

    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $jsonlFull = [System.IO.Path]::GetFullPath($Path)
    $fs = [System.IO.FileStream]::new($indexFull, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
    $br = [System.IO.BinaryReader]::new($fs)
    try {
        if ($fs.Length -lt 12) { throw "Invalid legacy JSONL index length: $($fs.Length)" }
        $magic = [System.Text.Encoding]::ASCII.GetString($br.ReadBytes(4))
        if ($magic -ne 'JSOI') { throw "Invalid legacy JSONL index magic: '$magic'" }
        $version = $br.ReadInt32()
        if ($version -ne 1) { throw "Expected JSOI v1 compatibility index, got version $version" }
        $count = $br.ReadInt32()
        if ($count -lt 0) { throw "Invalid legacy JSONL index record count: $count" }
        $expected = 12L + 8L * $count
        if ($fs.Length -ne $expected) { throw "Invalid legacy JSONL index length: expected $expected, got $($fs.Length)" }
        $offsets = [long[]]::new($count)
        $prior = -1L
        $sourceLength = ([System.IO.FileInfo]::new($jsonlFull)).Length
        for ($i = 0; $i -lt $count; $i++) {
            $offsets[$i] = $br.ReadInt64()
            if ($offsets[$i] -le $prior -or $offsets[$i] -lt 0 -or $offsets[$i] -ge $sourceLength) {
                throw "Invalid legacy JSONL index offset at record $i`: $($offsets[$i])"
            }
            $prior = $offsets[$i]
        }
        if ($count -gt 0 -and $offsets[0] -ne 0) { throw 'Invalid legacy JSONL index: first offset must be zero' }
    } finally {
        $br.Dispose()
        $fs.Dispose()
    }

    return [pscustomobject]@{
        IndexPath = $indexFull
        JsonlPath = $jsonlFull
        Version   = 1
        LineCount = $count
        Offsets   = $offsets
    }
}

function script:Get-JsonlCompatIndexVersion {
    param([Parameter(Mandatory)][string]$IndexPath)

    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $fs = [System.IO.FileStream]::new($indexFull, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
    $br = [System.IO.BinaryReader]::new($fs)
    try {
        if ($fs.Length -lt 8) { throw "Invalid JSONL index length: $($fs.Length)" }
        $magic = [System.Text.Encoding]::ASCII.GetString($br.ReadBytes(4))
        if ($magic -ne 'JSOI') { throw "Invalid JSONL index magic: '$magic'" }
        return $br.ReadInt32()
    } finally {
        $br.Dispose()
        $fs.Dispose()
    }
}

function Read-JsonlRecord {
    <# Compatibility wrapper for the old random-access function name and sidecar convention. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)][int]$At,
        [string]$IndexPath,
        [switch]$AsHashtable
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlCompatibleIndexPath $full }
    if (-not [System.IO.File]::Exists($IndexPath)) {
        return Get-JsonlRecord -Path $full -At $At -IndexPath $IndexPath -AsHashtable:$AsHashtable
    }

    $version = script:Get-JsonlCompatIndexVersion $IndexPath
    if ($version -eq 2) {
        return Get-JsonlRecord -Path $full -At $At -IndexPath $IndexPath -AsHashtable:$AsHashtable
    }
    if ($version -ne 1) { throw "Unsupported JSONL index version: $version" }

    $legacy = script:Read-JsonlV1IndexCompat -IndexPath $IndexPath -Path $full
    if ($At -ge $legacy.LineCount) { throw "Record index $At out of range; legacy index has $($legacy.LineCount) records" }

    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    $fs.Position = $legacy.Offsets[$At]
    $sr = [System.IO.StreamReader]::new($fs, [System.Text.UTF8Encoding]::new($false, $true), $false)
    try {
        $line = $sr.ReadLine()
        if ([string]::IsNullOrWhiteSpace($line)) { throw "Blank JSONL record at index $At in $full" }
        $record = if ($AsHashtable) {
            ConvertFrom-JsonlLine -Line $line -AsHashtable
        } else {
            ConvertFrom-JsonlLine -Line $line
        }
        if ($record -is [System.Array]) { Write-Output -NoEnumerate $record }
        else { Write-Output $record }
    } finally {
        $sr.Dispose()
        $fs.Dispose()
    }
}
