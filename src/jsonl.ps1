#requires -Version 7.0
<#
  src/jsonl.ps1 — JSONL stage substrate for the IR workflow.

  Lifted and corrected from the jso-jackson archaeology and owned fresh here —
  nothing under .legacy is on the import path. Each pipeline stage emits three
  coordinated artifacts:
    - the JSONL (one record per line),
    - a .jidx byte-offset seek index (JSOI format: 'JSOI' + int32 version(1) +
      int32 lineCount + int64[] line-start offsets, little-endian), and
    - a .sig provenance stamp (source hash + stage + count) so a stage's output can
      be checked stale against its input — the source fingerprint the original
      .jidx never carried.

  Dot-source to use:  . "$PSScriptRoot/jsonl.ps1"
#>

class JsonlIndex {
    [string] $Path
    [int]    $LineCount
    hidden [long[]] $Offsets

    # Byte-scan a JSONL for line-start offsets and write the JSOI index — no parse.
    static [JsonlIndex] Build([string]$JsonlPath, [string]$IndexPath) {
        $bytes = [System.IO.File]::ReadAllBytes($JsonlPath)
        $offsetList = [System.Collections.Generic.List[long]]::new()
        if ($bytes.Length -gt 0) { $offsetList.Add(0L) }
        for ($i = 0; $i -lt $bytes.Length; $i++) {
            if ($bytes[$i] -eq 0x0A -and ($i + 1) -lt $bytes.Length) {
                $offsetList.Add([long]($i + 1))
            }
        }
        $fs = [System.IO.File]::Create($IndexPath)
        $bw = [System.IO.BinaryWriter]::new($fs)
        try {
            $bw.Write([System.Text.Encoding]::ASCII.GetBytes('JSOI'))
            $bw.Write([int]1)
            $bw.Write([int]$offsetList.Count)
            foreach ($o in $offsetList) { $bw.Write([long]$o) }
        } finally { $bw.Dispose(); $fs.Dispose() }
        return [JsonlIndex]::Load($IndexPath)
    }

    static [JsonlIndex] Load([string]$IndexPath) {
        $idx = [JsonlIndex]::new()
        $idx.Path = $IndexPath
        $fs = [System.IO.File]::OpenRead($IndexPath)
        $br = [System.IO.BinaryReader]::new($fs)
        try {
            $magic = [System.Text.Encoding]::ASCII.GetString($br.ReadBytes(4))
            if ($magic -ne 'JSOI') { throw "Invalid .jidx magic: '$magic'" }
            $ver = $br.ReadInt32()
            if ($ver -ne 1) { throw "Unsupported .jidx version: $ver" }
            $idx.LineCount = $br.ReadInt32()
            $idx.Offsets = [long[]]::new($idx.LineCount)
            for ($i = 0; $i -lt $idx.LineCount; $i++) { $idx.Offsets[$i] = $br.ReadInt64() }
        } finally { $br.Dispose(); $fs.Dispose() }
        return $idx
    }

    [long] Offset([int]$Line) {
        if ($Line -lt 0 -or $Line -ge $this.LineCount) {
            throw "Line $Line out of range [0, $($this.LineCount - 1)]"
        }
        return $this.Offsets[$Line]
    }
}

function Write-JsonlStage {
    <#
    .SYNOPSIS  Emit a stage's records as JSONL plus coordinated .jidx and .sig sidecars.
    .OUTPUTS   [pscustomobject] @{ Jsonl; Jidx; Sig; Records }
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Records,
        [Parameter(Mandatory)] [string]   $OutputPath,
        [string] $SourcePath,
        [string] $Stage,
        [int]    $Depth = 12
    )
    $dir = [System.IO.Path]::GetDirectoryName($OutputPath)
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    $sw = [System.IO.StreamWriter]::new($OutputPath, $false, [System.Text.UTF8Encoding]::new($false))
    try {
        foreach ($r in $Records) { $sw.WriteLine(($r | ConvertTo-Json -Compress -Depth $Depth)) }
    } finally { $sw.Dispose() }

    $jidxPath = "$OutputPath.jidx"
    [void][JsonlIndex]::Build($OutputPath, $jidxPath)

    $sig = [ordered]@{
        stage   = $Stage
        records = $Records.Count
        output  = [System.IO.Path]::GetFileName($OutputPath)
    }
    if ($SourcePath -and (Test-Path -LiteralPath $SourcePath)) {
        $sig['source'] = [System.IO.Path]::GetFileName($SourcePath)
        $sig['source_sha256'] = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    $sigPath = "$OutputPath.sig"
    [System.IO.File]::WriteAllText($sigPath, ($sig | ConvertTo-Json), [System.Text.UTF8Encoding]::new($false))

    # inventory: every durable artifact self-registers here — the cross-cutting "decorator"
    # realised via the single write-chokepoint. Best-effort: the artifact is ground truth, the
    # inventory a convenience window onto the in-play objects (one per scratch dir).
    try {
        $invPath = Join-Path ([System.IO.Path]::GetDirectoryName($OutputPath)) 'inventory.json'
        $inv = if (Test-Path -LiteralPath $invPath) { [System.IO.File]::ReadAllText($invPath, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json -AsHashtable } else { @{} }
        $inv[[System.IO.Path]::GetFileName($OutputPath)] = @{
            stage   = $Stage
            records = $Records.Count
            bytes   = (Get-Item -LiteralPath $OutputPath).Length
            source  = if ($SourcePath) { [System.IO.Path]::GetFileName($SourcePath) } else { $null }
        }
        [System.IO.File]::WriteAllText($invPath, ($inv | ConvertTo-Json -Depth 6), [System.Text.UTF8Encoding]::new($false))
    } catch { }

    return [pscustomobject]@{ Jsonl = $OutputPath; Jidx = $jidxPath; Sig = $sigPath; Records = $Records.Count }
}

function Read-JsonlRecord {
    <# Seek to record $At via the .jidx and return it parsed — O(1) random access. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [int]    $At,
        [string] $IndexPath = "$Path.jidx"
    )
    $idx = [JsonlIndex]::Load($IndexPath)
    $fs = [System.IO.File]::OpenRead($Path)
    $sr = [System.IO.StreamReader]::new($fs, [System.Text.UTF8Encoding]::new($false))
    try {
        [void]$fs.Seek($idx.Offset($At), [System.IO.SeekOrigin]::Begin)
        $sr.DiscardBufferedData()
        $line = $sr.ReadLine()
    } finally { $sr.Dispose() }
    return ($line | ConvertFrom-Json)
}

function Get-JsonlSchema {
    <#
    .SYNOPSIS  Single-pass schema probe: per top-level key, the types seen and the
               share of records carrying it. Discovers the keys to walk without
               assuming them — a missing expected key shows as a coverage gap.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)] [string] $Path)

    $total = 0
    $count = @{}
    $types = @{}
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $total++
        $obj = $line | ConvertFrom-Json
        foreach ($p in $obj.PSObject.Properties) {
            $k = $p.Name
            if (-not $count.ContainsKey($k)) { $count[$k] = 0 }
            $count[$k]++
            $tn = if ($null -eq $p.Value) { 'null' } else { $p.Value.GetType().Name }
            if (-not $types.ContainsKey($k)) { $types[$k] = @{} }
            if (-not $types[$k].ContainsKey($tn)) { $types[$k][$tn] = 0 }
            $types[$k][$tn]++
        }
    }
    foreach ($k in ($count.Keys | Sort-Object)) {
        [pscustomobject]@{
            Key      = $k
            Coverage = if ($total) { [math]::Round(100.0 * $count[$k] / $total, 1) } else { 0.0 }
            Types    = (($types[$k].Keys | Sort-Object) -join ',')
        }
    }
}

# --- ledger: per-document milestone record (process position, written by the stages) ---
# A terse anti-amnesic ledger — not a verbose log. The process logs its own milestones as it
# passes them; the last line is "where we are", the whole file is "how we got here". One file
# per document, so fan-out never contends. Chunks stay ground truth; the ledger is the cheap
# process-position projection.

function Add-LedgerEntry([string]$ChunksPath, [string]$Stage, [hashtable]$Extra = @{}) {
    $rec = [ordered]@{ stage = $Stage }
    foreach ($k in $Extra.Keys) { $rec[$k] = $Extra[$k] }
    $ledger = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.ledger.jsonl'
    [System.IO.File]::AppendAllText($ledger, (($rec | ConvertTo-Json -Compress -Depth 6) + "`n"), [System.Text.UTF8Encoding]::new($false))
}

function Get-LedgerStage([string]$ChunksPath) {
    $ledger = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.ledger.jsonl'
    if (-not (Test-Path -LiteralPath $ledger)) { return $null }
    $last = [System.IO.File]::ReadLines($ledger) | Where-Object { $_ } | Select-Object -Last 1
    if ($last) { return ($last | ConvertFrom-Json) }
    return $null
}

# the in-play artifacts registered alongside this document (the other window onto progress)
function Get-Inventory([string]$ChunksPath) {
    $invPath = Join-Path ([System.IO.Path]::GetDirectoryName($ChunksPath)) 'inventory.json'
    if (Test-Path -LiteralPath $invPath) { return [System.IO.File]::ReadAllText($invPath, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json }
    return $null
}
