#requires -Version 7.0
<#
  src/shared/jsonl-v2.ps1 — pending replacement for the shared JSONL substrate.

  This file is intentionally NOT imported by current production code. The filename is versioned only
  while the replacement is being vetted; its API uses the intended final, unversioned names. Transitional
  behavior belongs in jsonl-v2-compat.ps1, never here.

  SCOPE
  -----
  Primitive JSONL file mechanics only:
    - explicit create / replace / append behavior;
    - UTF-8 without BOM and LF-only records;
    - strict-by-default streaming reads and validation;
    - head, tail, count, and indexed random access;
    - canonical `{stem}.jidx` indexes; and
    - stable snapshots of actively appended JSONL files.

  Deliberately absent: run layout, stages, provenance stamps, inventories, ledgers, logging policy,
  application naming conventions, and automatic legacy sidecar discovery.

  INDEX FORMAT (JSOI v2, little-endian)
  -------------------------------------
    ASCII `JSOI` | int32 version=2 | int32 lineCount | int64 sourceLength |
    int64 sourceLastWriteUtcTicks | int64[lineCount] line-start offsets

  Source length and last-write time make an index fail loudly after its JSONL changes. This is not a
  content hash; applications requiring provenance-grade verification should layer that policy above
  these primitives.
#>

$script:JsonlUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
$script:JsonlIndexMagic = 'JSOI'
$script:JsonlIndexVersion = 2

class JsonlIndex {
    [string] $IndexPath
    [string] $JsonlPath
    [int]    $Version
    [int]    $LineCount
    [long]   $SourceLength
    [long]   $SourceLastWriteUtcTicks
    [long[]] $Offsets

    [long] GetOffset([int]$RecordIndex) {
        if ($RecordIndex -lt 0 -or $RecordIndex -ge $this.LineCount) {
            throw "Record index $RecordIndex out of range [0, $($this.LineCount - 1)]"
        }
        return $this.Offsets[$RecordIndex]
    }

    [bool] IsCurrent([string]$Path) {
        if (-not [System.IO.File]::Exists($Path)) { return $false }
        $item = [System.IO.FileInfo]::new([System.IO.Path]::GetFullPath($Path))
        return $item.Length -eq $this.SourceLength -and
               $item.LastWriteTimeUtc.Ticks -eq $this.SourceLastWriteUtcTicks
    }
}

function Resolve-JsonlIndexPath {
    <# Return the canonical sidecar path: records.jsonl -> records.jidx. #>
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Path)

    return [System.IO.Path]::ChangeExtension([System.IO.Path]::GetFullPath($Path), '.jidx')
}

function script:Assert-JsonlNoBom {
    param([Parameter(Mandatory)][string]$Path)

    $fs = [System.IO.FileStream]::new(
        $Path,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::Read,
        ([System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete)
    )
    try {
        if ($fs.Length -lt 3) { return }
        $b0 = $fs.ReadByte(); $b1 = $fs.ReadByte(); $b2 = $fs.ReadByte()
        if ($b0 -eq 0xEF -and $b1 -eq 0xBB -and $b2 -eq 0xBF) {
            throw "JSONL must be UTF-8 without BOM: $Path"
        }
    } finally { $fs.Dispose() }
}

function script:ConvertTo-JsonlLine {
    param(
        [Parameter(Mandatory)][AllowNull()][object]$Record,
        [Parameter(Mandatory)][ValidateRange(1, 100)][int]$Depth
    )

    return ConvertTo-Json -InputObject $Record -Compress -Depth $Depth -WarningAction Stop
}

function script:Test-JsonlLine {
    param([AllowNull()][string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    try {
        $doc = [System.Text.Json.JsonDocument]::Parse($Line)
        $doc.Dispose()
        return $true
    } catch { return $false }
}

function script:New-JsonlTempPath {
    param([Parameter(Mandatory)][string]$TargetPath)

    $dir = [System.IO.Path]::GetDirectoryName($TargetPath)
    $leaf = [System.IO.Path]::GetFileName($TargetPath)
    return [System.IO.Path]::Combine($dir, ".$leaf.$([guid]::NewGuid().ToString('N')).tmp")
}

function script:Publish-JsonlTempFile {
    param(
        [Parameter(Mandatory)][string]$TempPath,
        [Parameter(Mandatory)][string]$TargetPath,
        [Parameter(Mandatory)][ValidateSet('Fail', 'Replace')][string]$ExistingFile
    )

    try {
        [System.IO.File]::Move($TempPath, $TargetPath, ($ExistingFile -eq 'Replace'))
    } catch {
        if ([System.IO.File]::Exists($TempPath)) {
            [System.IO.File]::Delete($TempPath)
        }
        throw
    }
}

function Write-Jsonl {
    <#
    .SYNOPSIS
        Publish a complete JSONL file atomically.
    .DESCRIPTION
        Writes beside the destination, then moves the completed file into place. Existing destinations
        fail by default; -ExistingFile Replace is the explicit whole-file replacement policy.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Records,
        [Parameter(Mandatory)][string]$Path,
        [ValidateSet('Fail', 'Replace')][string]$ExistingFile = 'Fail',
        [ValidateRange(1, 100)][int]$Depth = 32
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    $dir = [System.IO.Path]::GetDirectoryName($full)
    [void][System.IO.Directory]::CreateDirectory($dir)
    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($full)) {
        throw "JSONL destination already exists: $full"
    }

    $temp = script:New-JsonlTempPath $full
    $fs = [System.IO.FileStream]::new(
        $temp,
        [System.IO.FileMode]::CreateNew,
        [System.IO.FileAccess]::Write,
        [System.IO.FileShare]::None
    )
    $sw = [System.IO.StreamWriter]::new($fs, $script:JsonlUtf8)
    $sw.NewLine = "`n"
    try {
        foreach ($record in $Records) {
            $sw.WriteLine((script:ConvertTo-JsonlLine -Record $record -Depth $Depth))
        }
    } catch {
        $sw.Dispose()
        if ([System.IO.File]::Exists($temp)) { [System.IO.File]::Delete($temp) }
        throw
    } finally {
        $sw.Dispose()
    }

    script:Publish-JsonlTempFile -TempPath $temp -TargetPath $full -ExistingFile $ExistingFile
    return [pscustomobject]@{ Path = $full; Records = $Records.Count; Bytes = ([System.IO.FileInfo]::new($full)).Length }
}

function Initialize-Jsonl {
    <#
    .SYNOPSIS
        Establish an append target with an explicit existing-file policy.
    .DESCRIPTION
        Fail creates a new file only. Append opens or creates a valid line-boundary target. Truncate is
        explicit destructive replacement. Subsequent records are written by Add-JsonlRecord.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [ValidateSet('Fail', 'Append', 'Truncate')][string]$ExistingFile = 'Fail'
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))

    switch ($ExistingFile) {
        'Fail' {
            $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::Read)
            $fs.Dispose()
        }
        'Truncate' {
            $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::Read)
            $fs.Dispose()
        }
        'Append' {
            if ([System.IO.File]::Exists($full)) {
                script:Assert-JsonlNoBom $full
                $fs = [System.IO.FileStream]::new(
                    $full,
                    [System.IO.FileMode]::Open,
                    [System.IO.FileAccess]::Read,
                    ([System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete)
                )
                try {
                    if ($fs.Length -gt 0) {
                        $fs.Position = $fs.Length - 1
                        if ($fs.ReadByte() -ne 0x0A) {
                            throw "Cannot append: existing JSONL does not end at an LF record boundary: $full"
                        }
                    }
                } finally { $fs.Dispose() }
            } else {
                $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::Read)
                $fs.Dispose()
            }
        }
    }
    return $full
}

function Add-JsonlRecord {
    <# Append exactly one compact JSON value plus LF. The destination must already exist. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][AllowNull()][object]$Record,
        [ValidateRange(1, 100)][int]$Depth = 32
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL append target does not exist: $full" }
    $line = script:ConvertTo-JsonlLine -Record $Record -Depth $Depth
    $bytes = $script:JsonlUtf8.GetBytes($line + "`n")
    $fs = [System.IO.FileStream]::new(
        $full,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::Read
    )
    try {
        if ($fs.Length -gt 0) {
            $fs.Position = $fs.Length - 1
            if ($fs.ReadByte() -ne 0x0A) {
                throw "Cannot append: existing JSONL does not end at an LF record boundary: $full"
            }
        }
        $fs.Position = $fs.Length
        $fs.Write($bytes, 0, $bytes.Length)
    } finally {
        $fs.Dispose()
    }
}

function Read-Jsonl {
    <#
    .SYNOPSIS
        Stream JSONL records. Malformed or blank lines stop by default; Skip is explicit and visible.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [ValidateSet('Stop', 'Skip')][string]$MalformedAction = 'Stop',
        [switch]$AsHashtable
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    script:Assert-JsonlNoBom $full

    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    $sr = [System.IO.StreamReader]::new($fs, $script:JsonlUtf8, $false)
    $lineNumber = 0
    try {
        while ($null -ne ($line = $sr.ReadLine())) {
            $lineNumber++
            try {
                if ([string]::IsNullOrWhiteSpace($line)) { throw 'blank line' }
                $record = if ($AsHashtable) { $line | ConvertFrom-Json -AsHashtable } else { $line | ConvertFrom-Json }
                if ($record -is [System.Array]) { Write-Output -NoEnumerate $record }
                else { Write-Output $record }
            } catch {
                $message = "Malformed JSONL at $full line $lineNumber`: $($_.Exception.Message)"
                if ($MalformedAction -eq 'Stop') { throw $message }
                Write-Warning $message
            }
        }
    } finally {
        $sr.Dispose()
        $fs.Dispose()
    }
}

function Test-Jsonl {
    <# Emit one diagnostic row per invalid physical line; emit valid rows only with -IncludeValid. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [switch]$IncludeValid
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }

    try { script:Assert-JsonlNoBom $full }
    catch {
        return [pscustomobject]@{ Line = 0; RecordIndex = $null; IsValid = $false; Error = $_.Exception.Message }
    }

    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    $sr = [System.IO.StreamReader]::new($fs, $script:JsonlUtf8, $false)
    $lineNumber = 0
    try {
        while ($null -ne ($line = $sr.ReadLine())) {
            $lineNumber++
            $valid = script:Test-JsonlLine $line
            if ($valid) {
                if ($IncludeValid) {
                    [pscustomobject]@{ Line = $lineNumber; RecordIndex = $lineNumber - 1; IsValid = $true; Error = $null }
                }
            } else {
                $errorText = if ([string]::IsNullOrWhiteSpace($line)) { 'Blank line' } else {
                    try { $null = $line | ConvertFrom-Json; 'Invalid JSON' } catch { $_.Exception.Message }
                }
                [pscustomobject]@{ Line = $lineNumber; RecordIndex = $lineNumber - 1; IsValid = $false; Error = $errorText }
            }
        }
    } finally {
        $sr.Dispose()
        $fs.Dispose()
    }
}

function New-JsonlIndex {
    <# Build a bounded-memory JSOI v2 seek index. The source must remain unchanged during the scan. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [string]$IndexPath,
        [ValidateSet('Fail', 'Replace')][string]$ExistingFile = 'Fail'
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($indexFull))
    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($indexFull)) {
        throw "JSONL index destination already exists: $indexFull"
    }

    $before = [System.IO.FileInfo]::new($full)
    $sourceLength = $before.Length
    $sourceTicks = $before.LastWriteTimeUtc.Ticks
    $offsets = [System.Collections.Generic.List[long]]::new()
    if ($sourceLength -gt 0) { $offsets.Add(0L) }

    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    try {
        $buffer = [byte[]]::new(65536)
        $position = 0L
        while ($position -lt $sourceLength) {
            $want = [int][math]::Min($buffer.Length, $sourceLength - $position)
            $read = $fs.Read($buffer, 0, $want)
            if ($read -le 0) { break }
            $search = 0
            while ($search -lt $read) {
                $hit = [Array]::IndexOf($buffer, [byte]0x0A, $search, $read - $search)
                if ($hit -lt 0) { break }
                $next = $position + $hit + 1
                if ($next -lt $sourceLength) { $offsets.Add($next) }
                $search = $hit + 1
            }
            $position += $read
        }
    } finally { $fs.Dispose() }

    $after = [System.IO.FileInfo]::new($full)
    if ($after.Length -ne $sourceLength -or $after.LastWriteTimeUtc.Ticks -ne $sourceTicks) {
        throw "Cannot index JSONL that changed during the scan: $full"
    }

    $temp = script:New-JsonlTempPath $indexFull
    $idxFs = [System.IO.FileStream]::new($temp, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    $bw = [System.IO.BinaryWriter]::new($idxFs)
    try {
        $bw.Write([System.Text.Encoding]::ASCII.GetBytes($script:JsonlIndexMagic))
        $bw.Write([int]$script:JsonlIndexVersion)
        $bw.Write([int]$offsets.Count)
        $bw.Write([long]$sourceLength)
        $bw.Write([long]$sourceTicks)
        foreach ($offset in $offsets) { $bw.Write([long]$offset) }
    } catch {
        $bw.Dispose()
        if ([System.IO.File]::Exists($temp)) { [System.IO.File]::Delete($temp) }
        throw
    } finally { $bw.Dispose() }

    script:Publish-JsonlTempFile -TempPath $temp -TargetPath $indexFull -ExistingFile $ExistingFile
    return Read-JsonlIndex -IndexPath $indexFull -Path $full
}

function Read-JsonlIndex {
    <# Load and structurally validate a JSOI v2 index; -Path also verifies source freshness. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$IndexPath,
        [string]$Path
    )

    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    if (-not [System.IO.File]::Exists($indexFull)) { throw "JSONL index not found: $indexFull" }

    $fs = [System.IO.FileStream]::new($indexFull, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
    $br = [System.IO.BinaryReader]::new($fs)
    try {
        if ($fs.Length -lt 28) { throw "Invalid JSONL index length: $($fs.Length)" }
        $magic = [System.Text.Encoding]::ASCII.GetString($br.ReadBytes(4))
        if ($magic -ne $script:JsonlIndexMagic) { throw "Invalid JSONL index magic: '$magic'" }
        $version = $br.ReadInt32()
        if ($version -ne $script:JsonlIndexVersion) { throw "Unsupported JSONL index version: $version" }
        $count = $br.ReadInt32()
        if ($count -lt 0) { throw "Invalid JSONL index record count: $count" }
        $sourceLength = $br.ReadInt64()
        $sourceTicks = $br.ReadInt64()
        $expectedLength = 28L + 8L * $count
        if ($fs.Length -ne $expectedLength) { throw "Invalid JSONL index length: expected $expectedLength, got $($fs.Length)" }

        $offsets = [long[]]::new($count)
        $prior = -1L
        for ($i = 0; $i -lt $count; $i++) {
            $offsets[$i] = $br.ReadInt64()
            if ($offsets[$i] -le $prior -or $offsets[$i] -lt 0 -or $offsets[$i] -ge $sourceLength) {
                throw "Invalid JSONL index offset at record $i`: $($offsets[$i])"
            }
            $prior = $offsets[$i]
        }
        if ($count -gt 0 -and $offsets[0] -ne 0) { throw 'Invalid JSONL index: first offset must be zero' }
    } finally {
        $br.Dispose()
        $fs.Dispose()
    }

    $index = [JsonlIndex]::new()
    $index.IndexPath = $indexFull
    $index.JsonlPath = if ($Path) { [System.IO.Path]::GetFullPath($Path) } else { '' }
    $index.Version = $version
    $index.LineCount = $count
    $index.SourceLength = $sourceLength
    $index.SourceLastWriteUtcTicks = $sourceTicks
    $index.Offsets = $offsets

    if ($Path -and -not $index.IsCurrent($index.JsonlPath)) {
        throw "Stale JSONL index: $indexFull does not describe $($index.JsonlPath)"
    }
    return $index
}

function Get-JsonlRecordCount {
    <# O(1) with a current canonical index; streaming physical-line count otherwise. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [string]$IndexPath,
        [switch]$IgnoreIndex
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    if (-not $IgnoreIndex -and [System.IO.File]::Exists($IndexPath)) {
        return (Read-JsonlIndex -IndexPath $IndexPath -Path $full).LineCount
    }

    $count = 0
    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    $sr = [System.IO.StreamReader]::new($fs, $script:JsonlUtf8, $false)
    try { while ($null -ne $sr.ReadLine()) { $count++ } }
    finally { $sr.Dispose(); $fs.Dispose() }
    return $count
}

function Get-JsonlRecord {
    <# Read one 0-based physical record, using the canonical index when present. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)][int]$At,
        [string]$IndexPath,
        [switch]$AsHashtable
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    script:Assert-JsonlNoBom $full
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $index = if ([System.IO.File]::Exists($IndexPath)) { Read-JsonlIndex -IndexPath $IndexPath -Path $full } else { $null }

    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    if ($index) {
        if ($At -ge $index.LineCount) { $fs.Dispose(); throw "Record index $At out of range; file has $($index.LineCount) records" }
        $fs.Position = $index.GetOffset($At)
    }
    $sr = [System.IO.StreamReader]::new($fs, $script:JsonlUtf8, $false)
    try {
        if ($index) { $line = $sr.ReadLine() }
        else {
            $i = 0
            $line = $null
            while ($null -ne ($candidate = $sr.ReadLine())) {
                if ($i -eq $At) { $line = $candidate; break }
                $i++
            }
            if ($null -eq $line) { throw "Record index $At out of range; file has $i records" }
        }
        if ([string]::IsNullOrWhiteSpace($line)) { throw "Blank JSONL record at index $At in $full" }
        $record = if ($AsHashtable) { $line | ConvertFrom-Json -AsHashtable } else { $line | ConvertFrom-Json }
        if ($record -is [System.Array]) { Write-Output -NoEnumerate $record }
        else { Write-Output $record }
    } finally { $sr.Dispose(); $fs.Dispose() }
}

function Get-JsonlHead {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [ValidateRange(0, [int]::MaxValue)][int]$Count = 10,
        [switch]$AsHashtable
    )

    if ($Count -eq 0) { return }
    Read-Jsonl -Path $Path -AsHashtable:$AsHashtable | Select-Object -First $Count
}

function Get-JsonlTail {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [ValidateRange(0, [int]::MaxValue)][int]$Count = 10,
        [string]$IndexPath,
        [switch]$AsHashtable
    )

    if ($Count -eq 0) { return }
    $total = Get-JsonlRecordCount -Path $Path -IndexPath $IndexPath
    $start = [math]::Max(0, $total - $Count)
    for ($i = $start; $i -lt $total; $i++) {
        Get-JsonlRecord -Path $Path -At $i -IndexPath $IndexPath -AsHashtable:$AsHashtable
    }
}

function New-JsonlSnapshot {
    <#
    .SYNOPSIS
        Normalize a stable snapshot of a possibly active JSONL source.
    .DESCRIPTION
        Opens the source with read/write/delete sharing, writes UTF-8-no-BOM/LF, rejects malformed
        interior records, and either drops or rejects an incomplete final record. The source is untouched.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$SourcePath,
        [Parameter(Mandatory)][string]$DestinationPath,
        [ValidateSet('DropIncomplete', 'Stop')][string]$TailPolicy = 'DropIncomplete',
        [ValidateSet('Fail', 'Replace')][string]$ExistingFile = 'Fail',
        [switch]$BuildIndex
    )

    $sourceFull = [System.IO.Path]::GetFullPath($SourcePath)
    $destFull = [System.IO.Path]::GetFullPath($DestinationPath)
    if (-not [System.IO.File]::Exists($sourceFull)) { throw "JSONL source not found: $sourceFull" }
    if ($sourceFull.Equals($destFull, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Snapshot source and destination must differ' }
    script:Assert-JsonlNoBom $sourceFull
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($destFull))
    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($destFull)) { throw "Snapshot destination already exists: $destFull" }
    $canonicalIndex = Resolve-JsonlIndexPath $destFull
    if ($BuildIndex -and $ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($canonicalIndex)) {
        throw "Snapshot index destination already exists: $canonicalIndex"
    }

    $temp = script:New-JsonlTempPath $destFull
    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $srcFs = [System.IO.FileStream]::new($sourceFull, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    $sourceLength = $srcFs.Length
    $dstFs = [System.IO.FileStream]::new($temp, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    $sw = [System.IO.StreamWriter]::new($dstFs, $script:JsonlUtf8)
    $sw.NewLine = "`n"
    $lineBytes = [System.IO.MemoryStream]::new()
    $lineNumber = 0
    $records = 0
    $tailDropped = $false
    $failure = $null
    try {
        $buffer = [byte[]]::new(65536)
        $position = 0L
        while ($position -lt $sourceLength) {
            $want = [int][math]::Min($buffer.Length, $sourceLength - $position)
            $read = $srcFs.Read($buffer, 0, $want)
            if ($read -le 0) { throw "JSONL source ended before its captured snapshot boundary: $sourceFull" }

            $segmentStart = 0
            for ($i = 0; $i -lt $read; $i++) {
                if ($buffer[$i] -ne 0x0A) { continue }
                $segmentLength = $i - $segmentStart
                if ($segmentLength -gt 0) { $lineBytes.Write($buffer, $segmentStart, $segmentLength) }

                $lineNumber++
                $recordBytes = $lineBytes.ToArray()
                $recordLength = $recordBytes.Length
                if ($recordLength -gt 0 -and $recordBytes[$recordLength - 1] -eq 0x0D) { $recordLength-- }
                $line = $script:JsonlUtf8.GetString($recordBytes, 0, $recordLength)
                if (-not (script:Test-JsonlLine $line)) { throw "Malformed JSONL at $sourceFull line $lineNumber" }
                $sw.WriteLine($line)
                $records++
                $lineBytes.SetLength(0)
                $segmentStart = $i + 1
            }
            if ($segmentStart -lt $read) { $lineBytes.Write($buffer, $segmentStart, $read - $segmentStart) }
            $position += $read
        }

        if ($lineBytes.Length -gt 0) {
            $lineNumber++
            if ($TailPolicy -eq 'DropIncomplete') {
                $tailDropped = $true
            } else {
                throw "Malformed JSONL tail at $sourceFull line $lineNumber"
            }
        }
    } catch {
        $failure = $_
    } finally {
        $sw.Dispose()
        $lineBytes.Dispose()
        $srcFs.Dispose()
    }
    if ($failure) {
        if ([System.IO.File]::Exists($temp)) { [System.IO.File]::Delete($temp) }
        throw $failure
    }

    script:Publish-JsonlTempFile -TempPath $temp -TargetPath $destFull -ExistingFile $ExistingFile
    $index = if ($BuildIndex) {
        New-JsonlIndex -Path $destFull -IndexPath $canonicalIndex -ExistingFile $ExistingFile
    } else { $null }

    return [pscustomobject]@{
        SourcePath   = $sourceFull
        SnapshotPath = $destFull
        IndexPath    = if ($index) { $index.IndexPath } else { $null }
        RecordCount  = $records
        TailDropped  = $tailDropped
    }
}
