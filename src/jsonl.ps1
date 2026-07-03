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

  ENCODING + DETERMINISM INVARIANTS (enforced by tests/encoding-invariants.Tests.ps1 — run it
  after ANY change here): UTF-8-no-BOM everywhere; SMP/ligature/U+FFFD codepoints round-trip
  byte-exact; the Newtonsoft fast path and ConvertTo-Json produce IDENTICAL bytes (PS7's cmdlet
  = Newtonsoft + StringEscapeHandling.Default — NOT EscapeHtml); .jidx offsets are exact over
  multibyte content; same records written twice = identical .jsonl AND .jidx bytes. The known
  poison: PIPELINE-emitted values are PSObject-wrapped and must never be stored into records
  (if-expressions, @() over collections, and hashtable members are safe — tested).
#>

class JsonlIndex {
    [string] $Path
    [int]    $LineCount
    hidden [long[]] $Offsets

    # Write line-start offsets as a JSOI index file.
    static [void] WriteIndex([string]$IndexPath, [System.Collections.Generic.List[long]]$Offsets) {
        $fs = [System.IO.File]::Create($IndexPath)
        $bw = [System.IO.BinaryWriter]::new($fs)
        try {
            $bw.Write([System.Text.Encoding]::ASCII.GetBytes('JSOI'))
            $bw.Write([int]1)
            $bw.Write([int]$Offsets.Count)
            foreach ($o in $Offsets) { $bw.Write([long]$o) }
        } finally { $bw.Dispose(); $fs.Dispose() }
    }

    # Byte-scan a JSONL for line-start offsets and write the JSOI index — no parse.
    # ([Array]::IndexOf hops newline-to-newline natively; a per-byte PS loop cost 17.5s on a
    # 33MB lane. Write-JsonlStage doesn't come through here — it accumulates offsets while
    # writing; this stays for indexing files produced elsewhere.)
    static [JsonlIndex] Build([string]$JsonlPath, [string]$IndexPath) {
        $bytes = [System.IO.File]::ReadAllBytes($JsonlPath)
        $offsetList = [System.Collections.Generic.List[long]]::new()
        if ($bytes.Length -gt 0) { $offsetList.Add(0L) }
        $i = [Array]::IndexOf($bytes, [byte]0x0A)
        while ($i -ge 0 -and ($i + 1) -lt $bytes.Length) {
            $offsetList.Add([long]($i + 1))
            $i = [Array]::IndexOf($bytes, [byte]0x0A, $i + 1)
        }
        [JsonlIndex]::WriteIndex($IndexPath, $offsetList)
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

$script:NsjSettings = $null
$script:NsjFallbacks = 0      # records that dropped from the Newtonsoft fast path to the cmdlet
$script:NsjLastError = $null  # last fast-path failure message (diagnostic)

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

    # Newtonsoft direct for dictionary records — byte-identical to ConvertTo-Json (PS7's cmdlet is
    # Newtonsoft-backed with StringEscapeHandling.Default: control chars escaped, <>&' LITERAL —
    # EscapeHtml was tried first and diverged on math glyphs; full-lane byte parity verified on the
    # 84p bench) minus ~160k cmdlet invocations per document. PSCustomObject records keep the
    # cmdlet path: Newtonsoft would serialize the PSObject wrapper, not the properties.
    if ($null -eq $script:NsjSettings -and ('Newtonsoft.Json.JsonConvert' -as [type])) {
        $script:NsjSettings = [Newtonsoft.Json.JsonSerializerSettings]::new()
        $script:NsjSettings.StringEscapeHandling = [Newtonsoft.Json.StringEscapeHandling]::Default
        $script:NsjSettings.Formatting = [Newtonsoft.Json.Formatting]::None
    }

    # line-start offsets accumulate DURING the write (GetByteCount per line) — the writer knows
    # every length; re-scanning the finished file per-byte cost 17.5s on a 33MB lane
    $offsets = [System.Collections.Generic.List[long]]::new()
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $fbBefore = $script:NsjFallbacks
    $sw = [System.IO.StreamWriter]::new($OutputPath, $false, $utf8)
    try {
        $nlBytes = [long]$utf8.GetByteCount($sw.NewLine)
        $pos = 0L
        foreach ($r in $Records) {
            $json = $null
            if ($null -ne $script:NsjSettings -and $r -is [System.Collections.IDictionary]) {
                # per-record fallback: a PSObject-wrapped value hiding in a dictionary makes
                # Newtonsoft reflect the wrapper (self-referencing loop) — that record drops to
                # the cmdlet path instead of failing the stage
                try { $json = [Newtonsoft.Json.JsonConvert]::SerializeObject($r, $script:NsjSettings) }
                catch { $json = $null; $script:NsjFallbacks++; $script:NsjLastError = $_.Exception.Message }
            }
            if ($null -eq $json) { $json = $r | ConvertTo-Json -Compress -Depth $Depth }
            $offsets.Add($pos)
            $pos += [long]$utf8.GetByteCount($json) + $nlBytes
            $sw.WriteLine($json)
        }
    } finally { $sw.Dispose() }

    # loud, attributed telemetry: a fallback means some record carried a PSObject-wrapped value
    # (classic source: `$hash.Keys | Sort-Object` — pipeline output is wrapped). The output is
    # still correct, but the emitting stage should unwrap at the source. Tested by
    # tests/encoding-invariants.Tests.ps1.
    $fbDelta = $script:NsjFallbacks - $fbBefore
    if ($fbDelta -gt 0) {
        Write-Warning "Write-JsonlStage[$Stage -> $(Split-Path -Leaf $OutputPath)]: $fbDelta record(s) fell back from the Newtonsoft fast path (PSObject-wrapped value in a dictionary record; last error: $script:NsjLastError)"
    }

    $jidxPath = "$OutputPath.jidx"
    [JsonlIndex]::WriteIndex($jidxPath, $offsets)

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
