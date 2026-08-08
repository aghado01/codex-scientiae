#requires -Version 7.0
<#
  src/shared/jso-ops/jsonl-v2.ps1 — pending replacement for the shared JSONL substrate.

  This file is intentionally NOT imported by current production code. The filename is versioned only
  while the replacement is being vetted; its API uses the intended final, unversioned names. Transitional
  behavior belongs in jsonl-v2-compat.ps1, never here.

  SCOPE
  -----
  Primitive JSONL file mechanics only:
    - explicit create / replace / append behavior;
    - UTF-8 without BOM and LF-only records;
    - one strict codec for all streaming reads and validation;
    - cooperating-writer leases and stable-reader views;
    - head, tail, count, ranges, JSON Pointer projection, and indexed random access;
    - canonical `{artifact}.jidx` indexes; and
    - store inspection/finalization and stable snapshots of actively appended JSONL files.

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
    <#
      Return the canonical sidecar path: records.jsonl -> records.jsonl.jidx.

      The suffix is appended, not substituted. Substitution cannot serve a signed single-object
      .json: records.json and records.jsonl in one directory would contend for a single
      records.sig, and a bare sidecar path could not say which subject it belonged to. Appending
      makes the sidecar name its own subject, and matches Write-JsonlStage in ../jsonl.ps1.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Path)

    return "$([System.IO.Path]::GetFullPath($Path)).jidx"
}

function script:Assert-JsonlStreamNoBom {
    param([Parameter(Mandatory)][System.IO.FileStream]$Stream, [Parameter(Mandatory)][string]$Path)

    $position = $Stream.Position
    try {
        $Stream.Position = 0
        if ($Stream.Length -lt 3) { return }
        $b0 = $Stream.ReadByte(); $b1 = $Stream.ReadByte(); $b2 = $Stream.ReadByte()
        if ($b0 -eq 0xEF -and $b1 -eq 0xBB -and $b2 -eq 0xBF) {
            throw "JSONL must be UTF-8 without BOM: $Path"
        }
    } finally { $Stream.Position = $position }
}

function script:Get-JsonlIOException {
    param([Parameter(Mandatory)][System.Exception]$Exception)

    $current = $Exception
    while ($current) {
        if ($current -is [System.IO.IOException]) { return $current }
        $current = $current.InnerException
    }
    return $null
}

function script:Test-JsonlContentionError {
    param([Parameter(Mandatory)][System.Exception]$Exception)

    $io = script:Get-JsonlIOException $Exception
    if (-not $io) { return $false }
    $nativeCode = $io.HResult -band 0xFFFF
    return $nativeCode -in 32, 33
}

function script:Enter-JsonlPathMutex {
    <# Cross-process coordination for cooperating mutations that must outlive a replaceable file handle. #>
    param(
        [Parameter(Mandatory)][string]$Path,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000
    )

    $identity = [System.IO.Path]::GetFullPath($Path)
    if ($IsWindows) { $identity = $identity.ToUpperInvariant() }
    $digest = [System.Security.Cryptography.SHA256]::HashData($script:JsonlUtf8.GetBytes($identity))
    $name = 'CodexScientiae.Jsonl.' + [Convert]::ToHexString($digest)
    $mutex = [System.Threading.Mutex]::new($false, $name)
    $timeout = if ($ContentionAction -eq 'Fail') { 0 } else { $ContentionTimeoutMilliseconds }
    try {
        try { $acquired = $mutex.WaitOne($timeout) }
        catch [System.Threading.AbandonedMutexException] { $acquired = $true }
        if (-not $acquired) {
            if ($ContentionAction -eq 'Fail') { throw "JSONL mutation contention at ${Path}: another operation holds the store" }
            throw "Timed out after $ContentionTimeoutMilliseconds ms waiting for the JSONL mutation lease: $Path"
        }
        return $mutex
    } catch {
        $mutex.Dispose()
        throw
    }
}

function script:Exit-JsonlPathMutex {
    param([AllowNull()][System.Threading.Mutex]$Mutex)

    if ($null -eq $Mutex) { return }
    try { $Mutex.ReleaseMutex() } finally { $Mutex.Dispose() }
}

function script:Open-JsonlWriterLease {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][ValidateSet('Fail', 'Wait')][string]$ContentionAction,
        [Parameter(Mandatory)][int]$ContentionTimeoutMilliseconds,
        [Parameter(Mandatory)][int]$RetryIntervalMilliseconds
    )

    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    while ($true) {
        try {
            return [System.IO.FileStream]::new(
                $Path,
                [System.IO.FileMode]::Open,
                [System.IO.FileAccess]::ReadWrite,
                [System.IO.FileShare]::Read
            )
        } catch {
            if (-not (script:Test-JsonlContentionError $_.Exception)) { throw }
            if ($ContentionAction -eq 'Fail') {
                throw "JSONL writer contention at ${Path}: another writer holds the store"
            }
            if ($timer.ElapsedMilliseconds -ge $ContentionTimeoutMilliseconds) {
                throw "Timed out after $ContentionTimeoutMilliseconds ms waiting for the JSONL writer lease: $Path"
            }
            Start-Sleep -Milliseconds ([math]::Min($RetryIntervalMilliseconds, [math]::Max(1, $ContentionTimeoutMilliseconds - $timer.ElapsedMilliseconds)))
        }
    }
}

function script:Open-JsonlStableReadStream {
    param([Parameter(Mandatory)][string]$Path)

    try {
        return [System.IO.FileStream]::new(
            $Path,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::Read
        )
    } catch {
        if (script:Test-JsonlContentionError $_.Exception) {
            throw "Cannot obtain a stable JSONL view while a writer holds the store: $Path"
        }
        throw
    }
}

function script:Read-JsonlPhysicalRecords {
    <# Yield LF-terminated byte records only. Decoding and JSON validation deliberately happen above this layer. #>
    param(
        [Parameter(Mandatory)][System.IO.FileStream]$Stream,
        [Parameter(Mandatory)][long]$SourceLength,
        [long]$StartingRecordIndex = 0,
        [long]$MaximumRecords = [long]::MaxValue
    )

    $lineBytes = [System.IO.MemoryStream]::new()
    $recordIndex = $StartingRecordIndex
    $recordOffset = $Stream.Position
    $emitted = 0L
    try {
        $buffer = [byte[]]::new(65536)
        while ($Stream.Position -lt $SourceLength -and $emitted -lt $MaximumRecords) {
            $bufferStart = $Stream.Position
            $want = [int][math]::Min($buffer.Length, $SourceLength - $bufferStart)
            $read = $Stream.Read($buffer, 0, $want)
            if ($read -le 0) { break }
            $segmentStart = 0
            for ($i = 0; $i -lt $read; $i++) {
                if ($buffer[$i] -ne 0x0A) { continue }
                $segmentLength = $i - $segmentStart
                if ($segmentLength -gt 0) { $lineBytes.Write($buffer, $segmentStart, $segmentLength) }
                [pscustomobject]@{
                    RecordIndex = $recordIndex
                    ByteOffset  = $recordOffset
                    Bytes       = $lineBytes.ToArray()
                }
                $emitted++
                $recordIndex++
                $lineBytes.SetLength(0)
                $recordOffset = $bufferStart + $i + 1
                $segmentStart = $i + 1
                if ($emitted -ge $MaximumRecords) { return }
            }
            if ($segmentStart -lt $read) { $lineBytes.Write($buffer, $segmentStart, $read - $segmentStart) }
        }
    } finally { $lineBytes.Dispose() }
}

function script:Assert-JsonlIndexMatchesStream {
    param(
        [Parameter(Mandatory)][JsonlIndex]$Index,
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][System.IO.FileStream]$Stream
    )

    $item = [System.IO.FileInfo]::new($Path)
    if ($Index.SourceLength -ne $Stream.Length -or
        $Index.SourceLastWriteUtcTicks -ne $item.LastWriteTimeUtc.Ticks) {
        throw "Stale JSONL index: $($Index.IndexPath) does not describe $Path"
    }
}

function ConvertTo-JsonlLine {
    <# Serialize exactly one JSONL record and prove that its text is strict UTF-8 encodable. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowNull()][object]$Record,
        [ValidateRange(1, 100)][int]$Depth = 32
    )

    $line = ConvertTo-Json -InputObject $Record -Compress -Depth $Depth -WarningAction Stop
    [void]$script:JsonlUtf8.GetByteCount($line)
    return $line
}

function script:Assert-JsonlElementCodepoints {
    param([Parameter(Mandatory)][System.Text.Json.JsonElement]$Element)

    switch ($Element.ValueKind) {
        ([System.Text.Json.JsonValueKind]::Object) {
            foreach ($property in $Element.EnumerateObject()) {
                # JsonProperty.Name returns $null for an escaped lone surrogate instead of throwing.
                $name = $property.Name
                if ($null -eq $name) { throw 'Invalid Unicode scalar sequence in JSON property name' }
                [void]$script:JsonlUtf8.GetByteCount($name)
                script:Assert-JsonlElementCodepoints $property.Value
            }
        }
        ([System.Text.Json.JsonValueKind]::Array) {
            foreach ($item in $Element.EnumerateArray()) {
                script:Assert-JsonlElementCodepoints $item
            }
        }
        ([System.Text.Json.JsonValueKind]::String) { [void]$Element.GetString() }
    }
}

function ConvertFrom-JsonlLine {
    <#
    Parse one JSONL record through the shared Unicode-scalar gate. JsonDocument.Parse alone accepts
    escaped lone surrogates lazily, while ConvertFrom-Json replaces them with U+FFFD; materializing every
    string here prevents that split-brain behavior before any PowerShell conversion occurs.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param(
        [Parameter(Mandatory, Position = 0)][AllowEmptyString()][string]$Line,
        [Parameter(ParameterSetName = 'Hashtable')][switch]$AsHashtable,
        [Parameter(ParameterSetName = 'JsonElement')][switch]$AsJsonElement,
        [Parameter(ParameterSetName = 'RawText')][switch]$AsRawText
    )

    if ([string]::IsNullOrWhiteSpace($Line)) { throw 'Blank JSONL record' }
    $document = [System.Text.Json.JsonDocument]::Parse($Line)
    $isJsonNull = $false
    try {
        script:Assert-JsonlElementCodepoints $document.RootElement
        $isJsonNull = $document.RootElement.ValueKind -eq [System.Text.Json.JsonValueKind]::Null
        if ($AsJsonElement) { return $document.RootElement.Clone() }
    } finally {
        $document.Dispose()
    }

    if ($AsRawText) { return $Line }
    if ($isJsonNull) {
        throw 'Top-level JSON null has no lossless PowerShell pipeline representation; use -AsJsonElement or -AsRawText'
    }
    $record = if ($AsHashtable) {
        ConvertFrom-Json -InputObject $Line -AsHashtable
    } else {
        ConvertFrom-Json -InputObject $Line
    }
    if ($record -is [System.Array]) { Write-Output -NoEnumerate $record }
    else { Write-Output $record }
}

function Test-JsonlLine {
    [CmdletBinding()]
    param([AllowNull()][string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    try {
        $null = ConvertFrom-JsonlLine -Line $Line -AsJsonElement
        return $true
    } catch { return $false }
}

function script:ConvertFrom-JsonlBytes {
    param([Parameter(Mandatory)][byte[]]$Bytes)

    try { return $script:JsonlUtf8.GetString($Bytes) }
    catch { throw "Invalid UTF-8 JSONL record: $($_.Exception.Message)" }
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

    $mutex = $null
    try {
        $mutex = script:Enter-JsonlPathMutex -Path $TargetPath
        [System.IO.File]::Move($TempPath, $TargetPath, ($ExistingFile -eq 'Replace'))
    } catch {
        if ([System.IO.File]::Exists($TempPath)) { [System.IO.File]::Delete($TempPath) }
        throw
    } finally { script:Exit-JsonlPathMutex $mutex }
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
        [Parameter(Mandatory)][AllowNull()][AllowEmptyCollection()][object[]]$Records,
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

    $recordList = [object[]]::new(1)
    if (-not [object]::ReferenceEquals($null, $Records)) { $recordList = $Records }
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
        foreach ($record in $recordList) {
            $sw.WriteLine((ConvertTo-JsonlLine -Record $record -Depth $Depth))
        }
    } catch {
        $sw.Dispose()
        if ([System.IO.File]::Exists($temp)) { [System.IO.File]::Delete($temp) }
        throw
    } finally {
        $sw.Dispose()
    }

    script:Publish-JsonlTempFile -TempPath $temp -TargetPath $full -ExistingFile $ExistingFile
    return [pscustomobject]@{ Path = $full; Records = $recordList.Count; Bytes = ([System.IO.FileInfo]::new($full)).Length }
}

function Write-JsonlLines {
    <# Atomically publish already-serialized records after validating every line through the shared codec. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$Lines,
        [Parameter(Mandatory)][string]$Path,
        [ValidateSet('Fail', 'Replace')][string]$ExistingFile = 'Fail',
        [switch]$FlushToDisk
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($full)) {
        throw "JSONL destination already exists: $full"
    }

    $temp = script:New-JsonlTempPath $full
    $fs = [System.IO.FileStream]::new($temp, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    $sw = [System.IO.StreamWriter]::new($fs, $script:JsonlUtf8)
    $sw.NewLine = "`n"
    $count = 0
    try {
        foreach ($line in $Lines) {
            if ($null -eq $line) { throw 'A serialized JSONL record cannot be null text' }
            if ($line.Contains("`n") -or $line.Contains("`r")) { throw 'A serialized JSONL record cannot contain a literal CR or LF' }
            $null = ConvertFrom-JsonlLine -Line $line -AsJsonElement
            $sw.WriteLine($line)
            $count++
        }
        if ($FlushToDisk) {
            $sw.Flush()
            $fs.Flush($true)
        }
    } catch {
        $sw.Dispose()
        if ([System.IO.File]::Exists($temp)) { [System.IO.File]::Delete($temp) }
        throw
    } finally { $sw.Dispose() }

    script:Publish-JsonlTempFile -TempPath $temp -TargetPath $full -ExistingFile $ExistingFile
    return [pscustomobject]@{ Path = $full; Records = $count; Bytes = ([System.IO.FileInfo]::new($full)).Length }
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
        [ValidateSet('Fail', 'Append', 'Truncate')][string]$ExistingFile = 'Fail',
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000,
        [ValidateRange(1, 1000)][int]$RetryIntervalMilliseconds = 25
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    try { switch ($ExistingFile) {
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
                $fs = script:Open-JsonlWriterLease -Path $full -ContentionAction $ContentionAction `
                    -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds `
                    -RetryIntervalMilliseconds $RetryIntervalMilliseconds
                try {
                    script:Assert-JsonlStreamNoBom -Stream $fs -Path $full
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
    } } finally { script:Exit-JsonlPathMutex $mutex }
    return $full
}

function Add-JsonlRecords {
    <# Serialize a batch before acquiring one exclusive writer lease, then append it at an LF boundary. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][AllowNull()][AllowEmptyCollection()][object[]]$Records,
        [ValidateRange(1, 100)][int]$Depth = 32,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000,
        [ValidateRange(1, 1000)][int]$RetryIntervalMilliseconds = 25,
        [switch]$FlushToDisk
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL append target does not exist: $full" }

    # Nothing is mutated unless every record first serializes and encodes successfully.
    $recordList = [object[]]::new(1)
    if (-not [object]::ReferenceEquals($null, $Records)) { $recordList = $Records }
    $encoded = [System.Collections.Generic.List[byte[]]]::new()
    $totalBytes = 0L
    foreach ($record in $recordList) {
        $bytes = $script:JsonlUtf8.GetBytes((ConvertTo-JsonlLine -Record $record -Depth $Depth) + "`n")
        $encoded.Add($bytes)
        $totalBytes += $bytes.Length
    }
    if ($encoded.Count -eq 0) {
        return [pscustomobject]@{ Path = $full; RecordsAppended = 0; BytesAppended = 0L }
    }

    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    $fs = $null
    try {
        $fs = script:Open-JsonlWriterLease -Path $full -ContentionAction $ContentionAction `
            -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds -RetryIntervalMilliseconds $RetryIntervalMilliseconds
        if ($fs.Length -gt 0) {
            $fs.Position = $fs.Length - 1
            if ($fs.ReadByte() -ne 0x0A) {
                throw "Cannot append: existing JSONL does not end at an LF record boundary: $full"
            }
        }
        $fs.Position = $fs.Length
        foreach ($bytes in $encoded) { $fs.Write($bytes, 0, $bytes.Length) }
        if ($FlushToDisk) { $fs.Flush($true) }
    } finally {
        if ($fs) { $fs.Dispose() }
        script:Exit-JsonlPathMutex $mutex
    }
    return [pscustomobject]@{ Path = $full; RecordsAppended = $encoded.Count; BytesAppended = $totalBytes }
}

function Add-JsonlRecord {
    <# Append exactly one compact JSON value plus LF. The destination must already exist. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][AllowNull()][object]$Record,
        [ValidateRange(1, 100)][int]$Depth = 32,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000,
        [ValidateRange(1, 1000)][int]$RetryIntervalMilliseconds = 25,
        [switch]$FlushToDisk
    )

    Add-JsonlRecords -Path $Path -Records (, $Record) -Depth $Depth -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds -RetryIntervalMilliseconds $RetryIntervalMilliseconds `
        -FlushToDisk:$FlushToDisk | Out-Null
}

function Read-Jsonl {
    <# Stream a stable physical-record slice through the shared strict codec. #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [ValidateSet('Stop', 'Skip')][string]$MalformedAction = 'Stop',
        [ValidateSet('Stop', 'Skip')][string]$TailAction = 'Stop',
        [ValidateRange(0, [int]::MaxValue)][int]$Start = 0,
        [ValidateRange(0, [int]::MaxValue)][int]$Count = [int]::MaxValue,
        [string]$IndexPath,
        [Parameter(ParameterSetName = 'Hashtable')][switch]$AsHashtable,
        [Parameter(ParameterSetName = 'JsonElement')][switch]$AsJsonElement,
        [Parameter(ParameterSetName = 'RawText')][switch]$AsRawText,
        [switch]$IncludeMetadata
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }

    # FileShare.Read makes this a stable view. Use New-JsonlSnapshot for an active append target.
    $fs = script:Open-JsonlStableReadStream $full
    try {
        script:Assert-JsonlStreamNoBom -Stream $fs -Path $full
        $sourceLength = $fs.Length
        $hasIncompleteTail = $false
        if ($sourceLength -gt 0) {
            $fs.Position = $sourceLength - 1
            $hasIncompleteTail = $fs.ReadByte() -ne 0x0A
        }
        if ($hasIncompleteTail) {
            $message = "Incomplete final JSONL record (missing LF terminator): $full"
            if ($TailAction -eq 'Stop') { throw $message }
            Write-Warning $message
        }
        if ($Count -eq 0) { return }

        $startingRecordIndex = 0L
        $fs.Position = 0
        if ($Start -gt 0 -and [System.IO.File]::Exists($IndexPath)) {
            $index = Read-JsonlIndex -IndexPath $IndexPath
            script:Assert-JsonlIndexMatchesStream -Index $index -Path $full -Stream $fs
            if ($Start -ge $index.LineCount) { return }
            $startingRecordIndex = $Start
            $fs.Position = $index.GetOffset($Start)
        }
        $maximumPhysical = if ($startingRecordIndex -eq $Start) {
            [long]$Count
        } else {
            [math]::Min([long]::MaxValue, ([long]$Start + [long]$Count))
        }

        foreach ($physical in script:Read-JsonlPhysicalRecords -Stream $fs -SourceLength $sourceLength `
            -StartingRecordIndex $startingRecordIndex -MaximumRecords $maximumPhysical) {
            if ($physical.RecordIndex -lt $Start) { continue }
            try {
                if ($physical.Bytes.Length -gt 0 -and $physical.Bytes[$physical.Bytes.Length - 1] -eq 0x0D) {
                    throw 'CRLF record terminator is not permitted; JSONL records must use LF only'
                }
                $line = script:ConvertFrom-JsonlBytes $physical.Bytes
                $convert = @{ Line = $line }
                if ($AsHashtable) { $convert.AsHashtable = $true }
                elseif ($AsJsonElement) { $convert.AsJsonElement = $true }
                elseif ($AsRawText) { $convert.AsRawText = $true }
                $record = ConvertFrom-JsonlLine @convert
                if ($IncludeMetadata) {
                    [pscustomobject]@{ RecordIndex = $physical.RecordIndex; ByteOffset = $physical.ByteOffset; Value = $record }
                } elseif ($record -is [System.Array]) {
                    Write-Output -NoEnumerate $record
                } else {
                    Write-Output $record
                }
            } catch {
                $lineNumber = $physical.RecordIndex + 1
                $message = "Malformed JSONL at $full line $lineNumber`: $($_.Exception.Message)"
                if ($MalformedAction -eq 'Stop') { throw $message }
                Write-Warning $message
            }
        }
    } finally {
        $fs.Dispose()
    }
}

function Test-Jsonl {
    <# Validate the stable store through the shared UTF-8, line-ending, and JSON scalar codec. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [switch]$IncludeValid
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }

    $fs = script:Open-JsonlStableReadStream $full
    try {
        try { script:Assert-JsonlStreamNoBom -Stream $fs -Path $full }
        catch {
            return [pscustomobject]@{ Line = 0; RecordIndex = $null; ByteOffset = 0L; IsValid = $false; Error = $_.Exception.Message }
        }
        $sourceLength = $fs.Length
        $fs.Position = 0
        $completeCount = 0L
        foreach ($physical in script:Read-JsonlPhysicalRecords -Stream $fs -SourceLength $sourceLength) {
            $completeCount++
            $errorText = $null
            try {
                if ($physical.Bytes.Length -gt 0 -and $physical.Bytes[$physical.Bytes.Length - 1] -eq 0x0D) {
                    throw 'CRLF record terminator is not permitted; JSONL records must use LF only'
                }
                $line = script:ConvertFrom-JsonlBytes $physical.Bytes
                $null = ConvertFrom-JsonlLine -Line $line -AsJsonElement
            } catch { $errorText = $_.Exception.Message }
            $valid = $null -eq $errorText
            if ($valid) {
                if ($IncludeValid) {
                    [pscustomobject]@{ Line = $physical.RecordIndex + 1; RecordIndex = $physical.RecordIndex; ByteOffset = $physical.ByteOffset; IsValid = $true; Error = $null }
                }
            } else {
                [pscustomobject]@{ Line = $physical.RecordIndex + 1; RecordIndex = $physical.RecordIndex; ByteOffset = $physical.ByteOffset; IsValid = $false; Error = $errorText }
            }
        }

        if ($sourceLength -gt 0) {
            $fs.Position = $sourceLength - 1
            if ($fs.ReadByte() -ne 0x0A) {
                [pscustomobject]@{
                    Line = $completeCount + 1; RecordIndex = $completeCount; ByteOffset = $null
                    IsValid = $false; Error = 'Incomplete final JSONL record (missing LF terminator)'
                }
            }
        }
    } finally {
        $fs.Dispose()
    }
}

function New-JsonlIndex {
    <# Index LF-terminated physical row starts only; decoding and JSON validation are intentionally out of scope. #>
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

    $sourceMutex = script:Enter-JsonlPathMutex -Path $full
    try {
    $offsets = [System.Collections.Generic.List[long]]::new()
    # This share mode refuses an active writer and keeps the captured source stable for the full scan.
    $fs = script:Open-JsonlStableReadStream $full
    try {
        $sourceLength = $fs.Length
        $sourceTicks = ([System.IO.FileInfo]::new($full)).LastWriteTimeUtc.Ticks
        $buffer = [byte[]]::new(65536)
        $position = 0L
        $rowStart = 0L
        while ($position -lt $sourceLength) {
            $want = [int][math]::Min($buffer.Length, $sourceLength - $position)
            $read = $fs.Read($buffer, 0, $want)
            if ($read -le 0) { break }
            $search = 0
            while ($search -lt $read) {
                $hit = [Array]::IndexOf($buffer, [byte]0x0A, $search, $read - $search)
                if ($hit -lt 0) { break }
                $offsets.Add($rowStart)
                $rowStart = $position + $hit + 1
                $search = $hit + 1
            }
            $position += $read
        }
        if ($offsets.Count -gt [int]::MaxValue) { throw 'JSONL index exceeds the JSOI v2 record-count limit' }
    } finally { $fs.Dispose() }

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
    } finally { script:Exit-JsonlPathMutex $sourceMutex }
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
    <# O(1) with a current canonical index; otherwise count complete LF-terminated physical records. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [string]$IndexPath,
        [switch]$IgnoreIndex
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $fs = script:Open-JsonlStableReadStream $full
    try {
        if (-not $IgnoreIndex -and [System.IO.File]::Exists($IndexPath)) {
            $index = Read-JsonlIndex -IndexPath $IndexPath
            script:Assert-JsonlIndexMatchesStream -Index $index -Path $full -Stream $fs
            return $index.LineCount
        }

        $count = 0L
        $buffer = [byte[]]::new(65536)
        while (($read = $fs.Read($buffer, 0, $buffer.Length)) -gt 0) {
            for ($i = 0; $i -lt $read; $i++) { if ($buffer[$i] -eq 0x0A) { $count++ } }
        }
        return $count
    } finally { $fs.Dispose() }
}

function Get-JsonlRecord {
    <# Read one 0-based physical record through Read-Jsonl's stable, centralized codec. #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)][int]$At,
        [string]$IndexPath,
        [Parameter(ParameterSetName = 'Hashtable')][switch]$AsHashtable,
        [Parameter(ParameterSetName = 'JsonElement')][switch]$AsJsonElement,
        [Parameter(ParameterSetName = 'RawText')][switch]$AsRawText
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $read = @{ Path = $full; Start = $At; Count = 1; IndexPath = $IndexPath; IncludeMetadata = $true }
    if ($AsHashtable) { $read.AsHashtable = $true }
    elseif ($AsJsonElement) { $read.AsJsonElement = $true }
    elseif ($AsRawText) { $read.AsRawText = $true }
    $result = @(Read-Jsonl @read)
    if ($result.Count -eq 0) {
        $total = Get-JsonlRecordCount -Path $full -IndexPath $IndexPath
        throw "Record index $At out of range; file has $total records"
    }
    $record = $result[0].Value
    if ($record -is [System.Array]) { Write-Output -NoEnumerate $record }
    else { Write-Output $record }
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

function Get-JsonlStoreInfo {
    <# Inspect physical store state without decoding UTF-8 or parsing JSON; safe against an active append boundary. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [string]$IndexPath
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.File]::Exists($full)) { throw "JSONL file not found: $full" }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)

    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $fs = [System.IO.FileStream]::new($full, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    try {
        $sourceLength = $fs.Length
        $sourceItem = [System.IO.FileInfo]::new($full)
        $sourceTicks = $sourceItem.LastWriteTimeUtc.Ticks
        $completeRecords = 0L
        $hasCarriageReturn = $false
        $prefix = [byte[]]::new(3)
        $prefixCount = 0
        $lastByte = -1
        $position = 0L
        $buffer = [byte[]]::new(65536)
        while ($position -lt $sourceLength) {
            $want = [int][math]::Min($buffer.Length, $sourceLength - $position)
            $read = $fs.Read($buffer, 0, $want)
            if ($read -le 0) { break }
            for ($i = 0; $i -lt $read; $i++) {
                $value = $buffer[$i]
                if ($prefixCount -lt 3) { $prefix[$prefixCount] = $value; $prefixCount++ }
                if ($value -eq 0x0A) { $completeRecords++ }
                elseif ($value -eq 0x0D) { $hasCarriageReturn = $true }
                $lastByte = $value
            }
            $position += $read
        }
        $hasBom = $prefixCount -eq 3 -and $prefix[0] -eq 0xEF -and $prefix[1] -eq 0xBB -and $prefix[2] -eq 0xBF
        $hasIncompleteTail = $sourceLength -gt 0 -and $lastByte -ne 0x0A
    } finally { $fs.Dispose() }

    $indexStatus = 'Missing'
    $indexError = $null
    if ([System.IO.File]::Exists($indexFull)) {
        try {
            $index = Read-JsonlIndex -IndexPath $indexFull
            $indexStatus = if ($index.SourceLength -eq $sourceLength -and
                $index.SourceLastWriteUtcTicks -eq $sourceTicks) { 'Current' } else { 'Stale' }
        } catch {
            $indexStatus = 'Invalid'
            $indexError = $_.Exception.Message
        }
    }

    $state = if ($sourceLength -eq 0) { 'Empty' } elseif ($hasIncompleteTail) { 'IncompleteTail' } else { 'Complete' }
    return [pscustomobject]@{
        Path                 = $full
        State                = $state
        Bytes                = $sourceLength
        CompleteRecordCount  = $completeRecords
        HasIncompleteTail    = $hasIncompleteTail
        HasUtf8Bom           = $hasBom
        HasCarriageReturn    = $hasCarriageReturn
        LastWriteTimeUtc     = [datetime]::new($sourceTicks, [System.DateTimeKind]::Utc)
        IndexPath            = $indexFull
        IndexStatus          = $indexStatus
        IndexError           = $indexError
    }
}

function Complete-JsonlStore {
    <# Validate a quiescent store and optionally publish its canonical seek index; the source is never changed. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [switch]$BuildIndex,
        [string]$IndexPath,
        [ValidateSet('Fail', 'Replace')][string]$ExistingIndex = 'Fail'
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    # Hold a read lease across validation, optional indexing, and final inspection so no writer can enter between phases.
    $lease = script:Open-JsonlStableReadStream $full
    try {
        $diagnostics = @(Test-Jsonl -Path $full)
        if ($diagnostics.Count -gt 0) {
            $first = $diagnostics[0]
            throw "Cannot complete JSONL store; validation failed at line $($first.Line): $($first.Error)"
        }
        if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
        $index = if ($BuildIndex) {
            New-JsonlIndex -Path $full -IndexPath $IndexPath -ExistingFile $ExistingIndex
        } else { $null }
        $info = Get-JsonlStoreInfo -Path $full -IndexPath $IndexPath
        return [pscustomobject]@{
            Path          = $info.Path
            IsValid       = $true
            RecordCount   = $info.CompleteRecordCount
            Bytes         = $info.Bytes
            IndexPath     = if ($index) { $index.IndexPath } else { $info.IndexPath }
            IndexStatus   = $info.IndexStatus
        }
    } finally { $lease.Dispose() }
}

function Get-JsonlRange {
    <# Discoverable range wrapper over Read-Jsonl's 0-based physical slicing. #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)][int]$Start,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)][int]$Count,
        [string]$IndexPath,
        [ValidateSet('Stop', 'Skip')][string]$MalformedAction = 'Stop',
        [ValidateSet('Stop', 'Skip')][string]$TailAction = 'Stop',
        [Parameter(ParameterSetName = 'Hashtable')][switch]$AsHashtable,
        [Parameter(ParameterSetName = 'JsonElement')][switch]$AsJsonElement,
        [Parameter(ParameterSetName = 'RawText')][switch]$AsRawText,
        [switch]$IncludeMetadata
    )

    $read = @{
        Path = $Path; Start = $Start; Count = $Count; IndexPath = $IndexPath
        MalformedAction = $MalformedAction; TailAction = $TailAction; IncludeMetadata = $IncludeMetadata
    }
    if ($AsHashtable) { $read.AsHashtable = $true }
    elseif ($AsJsonElement) { $read.AsJsonElement = $true }
    elseif ($AsRawText) { $read.AsRawText = $true }
    Read-Jsonl @read
}

function script:Resolve-JsonlPointerElement {
    param(
        [Parameter(Mandatory)][System.Text.Json.JsonElement]$Element,
        [Parameter(Mandatory)][AllowEmptyString()][string]$Pointer
    )

    if ($Pointer.Length -eq 0) { return [pscustomobject]@{ Found = $true; Element = $Element } }
    if (-not $Pointer.StartsWith('/')) { throw "JSON Pointer must be empty or begin with '/': $Pointer" }
    $current = $Element
    foreach ($encodedSegment in $Pointer.Substring(1).Split('/')) {
        if ($encodedSegment -match '~(?![01])') { throw "Invalid JSON Pointer escape in segment '$encodedSegment'" }
        $segment = $encodedSegment.Replace('~1', '/').Replace('~0', '~')
        if ($current.ValueKind -eq [System.Text.Json.JsonValueKind]::Object) {
            $found = $false
            foreach ($property in $current.EnumerateObject()) {
                if ($property.NameEquals($segment)) {
                    $current = $property.Value
                    $found = $true
                    break
                }
            }
            if (-not $found) { return [pscustomobject]@{ Found = $false; Element = $null } }
        } elseif ($current.ValueKind -eq [System.Text.Json.JsonValueKind]::Array) {
            if ($segment -notmatch '^(0|[1-9][0-9]*)$') { return [pscustomobject]@{ Found = $false; Element = $null } }
            $arrayIndex = 0
            if (-not [int]::TryParse($segment, [ref]$arrayIndex) -or $arrayIndex -ge $current.GetArrayLength()) {
                return [pscustomobject]@{ Found = $false; Element = $null }
            }
            $cursor = 0
            foreach ($item in $current.EnumerateArray()) {
                if ($cursor -eq $arrayIndex) { $current = $item; break }
                $cursor++
            }
        } else {
            return [pscustomobject]@{ Found = $false; Element = $null }
        }
    }
    return [pscustomobject]@{ Found = $true; Element = $current }
}

function script:New-JsonlConditionPlan {
    param([Parameter(Mandatory)][hashtable[]]$Condition)

    $plan = [System.Collections.Generic.List[object]]::new()
    foreach ($item in $Condition) {
        if (-not $item.ContainsKey('Pointer') -or [string]::IsNullOrWhiteSpace([string]$item.Pointer)) {
            throw 'Each JSONL condition requires an RFC 6901 Pointer'
        }
        $operators = @(@('Exists', 'Equals', 'In', 'Matches') | Where-Object { $item.ContainsKey($_) })
        if ($operators.Count -ne 1) {
            throw "Condition '$($item.Pointer)' requires exactly one of Exists, Equals, In, or Matches"
        }
        $operation = $operators[0]
        $entry = [ordered]@{ Pointer = [string]$item.Pointer; Operation = $operation }
        switch ($operation) {
            'Exists' { $entry.Expected = [bool]$item.Exists }
            'Matches' { $entry.Pattern = [regex]::new([string]$item.Matches) }
            'Equals' {
                $entry.Expected = ConvertFrom-JsonlLine -Line (ConvertTo-JsonlLine -Record $item.Equals) -AsJsonElement
            }
            'In' {
                $values = [object[]]::new(1)
                if (-not [object]::ReferenceEquals($null, $item.In)) { $values = $item.In }
                $expected = [System.Collections.Generic.List[System.Text.Json.JsonElement]]::new()
                foreach ($value in $values) {
                    $expected.Add((ConvertFrom-JsonlLine -Line (ConvertTo-JsonlLine -Record $value) -AsJsonElement))
                }
                $entry.Expected = $expected
            }
        }
        $plan.Add([pscustomobject]$entry)
    }
    return $plan
}

function script:Test-JsonlConditionPlan {
    param(
        [Parameter(Mandatory)][System.Text.Json.JsonElement]$Element,
        [Parameter(Mandatory)][object[]]$Plan,
        [ValidateSet('All', 'Any')][string]$Mode = 'All'
    )

    $matched = 0
    foreach ($condition in $Plan) {
        $selection = script:Resolve-JsonlPointerElement -Element $Element -Pointer $condition.Pointer
        $hit = switch ($condition.Operation) {
            'Exists' { $selection.Found -eq $condition.Expected; break }
            'Equals' {
                $selection.Found -and [System.Text.Json.JsonElement]::DeepEquals($selection.Element, $condition.Expected)
                break
            }
            'In' {
                $inSet = $false
                if ($selection.Found) {
                    foreach ($expected in $condition.Expected) {
                        if ([System.Text.Json.JsonElement]::DeepEquals($selection.Element, $expected)) { $inSet = $true; break }
                    }
                }
                $inSet
                break
            }
            'Matches' {
                $selection.Found -and
                    $selection.Element.ValueKind -eq [System.Text.Json.JsonValueKind]::String -and
                    $condition.Pattern.IsMatch($selection.Element.GetString())
                break
            }
        }
        if ($hit) { $matched++ }
        if ($Mode -eq 'Any' -and $hit) { return $true }
        if ($Mode -eq 'All' -and -not $hit) { return $false }
    }
    if ($Mode -eq 'Any') { return $matched -gt 0 }
    return $matched -eq $Plan.Count
}

function Find-JsonlRecord {
    <# Exact streaming lookup API. It scans today and can adopt secondary indexes without changing callers. #>
    [CmdletBinding(DefaultParameterSetName = 'Condition')]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, ParameterSetName = 'Condition')][hashtable[]]$Condition,
        [Parameter(Mandatory, ParameterSetName = 'Equals')]
        [Parameter(Mandatory, ParameterSetName = 'In')][string]$Pointer,
        [Parameter(Mandatory, ParameterSetName = 'Equals')][AllowNull()][object]$Equals,
        [Parameter(Mandatory, ParameterSetName = 'In')][AllowNull()][object[]]$In,
        [ValidateSet('All', 'Any')][string]$Mode = 'All',
        [ValidateRange(1, [int]::MaxValue)][int]$First = [int]::MaxValue,
        [switch]$AsHashtable,
        [switch]$AsJsonElement,
        [switch]$AsRawText,
        [switch]$IncludeMetadata
    )

    $outputModeCount = [int][bool]$AsHashtable + [int][bool]$AsJsonElement + [int][bool]$AsRawText
    if ($outputModeCount -gt 1) {
        throw 'Choose at most one of -AsHashtable, -AsJsonElement, or -AsRawText'
    }
    if ($PSCmdlet.ParameterSetName -eq 'Equals') {
        $Condition = @(@{ Pointer = $Pointer; Equals = $Equals })
    } elseif ($PSCmdlet.ParameterSetName -eq 'In') {
        $values = [object[]]::new(1)
        if (-not [object]::ReferenceEquals($null, $In)) { $values = $In }
        $Condition = @(@{ Pointer = $Pointer; In = $values })
    }
    $plan = @(script:New-JsonlConditionPlan -Condition $Condition)
    $found = 0
    foreach ($row in Read-Jsonl -Path $Path -AsJsonElement -IncludeMetadata) {
        if (-not (script:Test-JsonlConditionPlan -Element $row.Value -Plan $plan -Mode $Mode)) { continue }
        $raw = $row.Value.GetRawText()
        $value = if ($AsJsonElement) { $row.Value.Clone() }
            elseif ($AsRawText) { $raw }
            elseif ($AsHashtable) { ConvertFrom-JsonlLine -Line $raw -AsHashtable }
            else { ConvertFrom-JsonlLine -Line $raw }
        if ($IncludeMetadata) {
            [pscustomobject]@{ RecordIndex = $row.RecordIndex; ByteOffset = $row.ByteOffset; Value = $value }
        } elseif ($value -is [System.Array]) {
            Write-Output -NoEnumerate $value
        } else { Write-Output $value }
        $found++
        if ($found -ge $First) { return }
    }
}

function Select-JsonlPath {
    <# Stream one RFC 6901 JSON Pointer projection per physical record, with source identity retained. #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Path,
        [Parameter(Mandatory, Position = 1)][AllowEmptyString()][string]$Pointer,
        [ValidateRange(0, [int]::MaxValue)][int]$Start = 0,
        [ValidateRange(0, [int]::MaxValue)][int]$Count = [int]::MaxValue,
        [string]$IndexPath,
        [switch]$IncludeMissing,
        [Parameter(ParameterSetName = 'Hashtable')][switch]$AsHashtable,
        [Parameter(ParameterSetName = 'JsonElement')][switch]$AsJsonElement,
        [Parameter(ParameterSetName = 'RawJson')][switch]$AsRawJson
    )

    foreach ($row in Read-Jsonl -Path $Path -Start $Start -Count $Count -IndexPath $IndexPath -AsJsonElement -IncludeMetadata) {
        $selection = script:Resolve-JsonlPointerElement -Element $row.Value -Pointer $Pointer
        if (-not $selection.Found -and -not $IncludeMissing) { continue }
        $value = $null
        if ($selection.Found) {
            if ($AsJsonElement) { $value = $selection.Element.Clone() }
            elseif ($AsRawJson) { $value = $selection.Element.GetRawText() }
            else {
                $convert = @{ Line = $selection.Element.GetRawText() }
                if ($AsHashtable) { $convert.AsHashtable = $true }
                $value = ConvertFrom-JsonlLine @convert
            }
        }
        [pscustomobject]@{
            RecordIndex = $row.RecordIndex
            ByteOffset  = $row.ByteOffset
            Pointer     = $Pointer
            Found       = $selection.Found
            Value       = $value
        }
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
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($destFull))
    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($destFull)) { throw "Snapshot destination already exists: $destFull" }
    $canonicalIndex = Resolve-JsonlIndexPath $destFull
    if ($BuildIndex -and $ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($canonicalIndex)) {
        throw "Snapshot index destination already exists: $canonicalIndex"
    }

    $temp = script:New-JsonlTempPath $destFull
    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $srcFs = [System.IO.FileStream]::new($sourceFull, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    try { script:Assert-JsonlStreamNoBom -Stream $srcFs -Path $sourceFull }
    catch { $srcFs.Dispose(); throw }
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
                try { $line = $script:JsonlUtf8.GetString($recordBytes, 0, $recordLength) }
                catch { throw "Invalid UTF-8 JSONL record at $sourceFull line ${lineNumber}: $($_.Exception.Message)" }
                try { $null = ConvertFrom-JsonlLine -Line $line -AsJsonElement }
                catch { throw "Malformed JSONL at $sourceFull line $lineNumber`: $($_.Exception.Message)" }
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
