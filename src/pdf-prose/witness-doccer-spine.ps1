#requires -Version 7.0
# Disposable Doccer witness: admitted Shannon spine → collect/pair/suppress/materialize.
# Not the E2E pipeline and not a kernel verb. See issues/doccer/discussions/grok-doccer-admitted-spine-rocky-training-20260818.md

[CmdletBinding()]
param(
    [string] $JsonlPath = (Join-Path $PSScriptRoot '../../ingestion/staging/macy-cybernetics-1946-1953/1950/shannon-redundancy-of-english.jsonl'),
    [string] $InventoryPath = (Join-Path $PSScriptRoot 'inventories/macy-spine.jsonl'),
    [string] $OutPath,
    [string] $DoccerDll
)

$ErrorActionPreference = 'Stop'
$repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
. (Join-Path $PSScriptRoot 'pdf-prose.ps1')

if (-not $DoccerDll) {
    $DoccerDll = Join-Path $repo 'packages/doccer/CodexSci.Doccer.dll'
}
if (-not [IO.File]::Exists($DoccerDll)) {
    throw "witness-doccer-spine: missing '$DoccerDll' — run brewery/doccer/build-doccer.ps1"
}
if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq 'CodexSci.Doccer' })) {
    Add-Type -Path $DoccerDll
}

$jsonlFull = [IO.Path]::GetFullPath($JsonlPath)
if (-not [IO.File]::Exists($jsonlFull)) { throw "witness-doccer-spine: missing '$jsonlFull'" }
$invFull = [IO.Path]::GetFullPath($InventoryPath)
if (-not [IO.File]::Exists($invFull)) { throw "witness-doccer-spine: missing '$invFull'" }

$admit = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($r in @('body', 'page-marker', 'float-caption', 'float-label')) { [void]$admit.Add($r) }

$parts = [System.Collections.Generic.List[object]]::new()
$floatHoles = 0
$admittedBlocks = 0
$fffc = [string][char]0xFFFC
foreach ($line in [IO.File]::ReadLines($jsonlFull)) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $row = $line | ConvertFrom-Json
    if ($row.kind -eq 'float') {
        $parts.Add([pscustomobject]@{
                Kind     = 'float'
                Text     = $fffc
                Render   = ConvertTo-PdfProseUtf16Escape $fffc
                Specials = @([pscustomobject]@{
                        Kind = 'default'; Decision = 'escape'; Start = 0; End = 1
                        Render = ConvertTo-PdfProseUtf16Escape $fffc
                    })
            })
        $floatHoles++
        continue
    }
    if ($row.kind -ne 'block') { continue }
    if (-not $admit.Contains([string]$row.role)) { continue }
    $parts.Add([pscustomobject]@{
            Kind     = 'block'
            Role     = [string]$row.role
            Text     = ConvertFrom-PdfProseUtf16Escape ([string]$row.textEscaped)
            Render   = [string]$row.textRender
            Specials = @($row.specials)
        })
    $admittedBlocks++
}

$spine = [string]::Join("`n`n", @($parts | ForEach-Object { $_.Text }))
$expected = [string]::Join("`n`n", @($parts | ForEach-Object { $_.Render }))
$master = [CodexSci.Doccer.TextMaster]::new('shannon-redundancy-of-english', 1, $spine)

$rules = [CodexSci.Doccer.PatternRuleLoader]::LoadFile($invFull)
$batch = [CodexSci.Doccer.RegexCollector]::Collect($master, $rules)

$kindCounts = [ordered]@{}
for ($i = 0; $i -lt $batch.Count; $i++) {
    $k = $batch[$i].Kind
    $kindCounts[$k] = 1 + $(if ($kindCounts.Contains($k)) { [int]$kindCounts[$k] } else { 0 })
}

# Facing-aware recipe: Unicode LEFT « / RIGHT » are labels, not open/close.
# Run both conventions; keep the one with more matches and fewer faults (document-local).
function Invoke-GuillemetPair([string] $OpenKind, [string] $CloseKind, [string] $Convention) {
    $o = [System.Collections.Generic.List[int]]::new()
    $c = [System.Collections.Generic.List[int]]::new()
    for ($i = 0; $i -lt $batch.Count; $i++) {
        $k = $batch[$i].Kind
        if ($k -eq $OpenKind) { $o.Add($i) }
        elseif ($k -eq $CloseKind) { $c.Add($i) }
    }
    $os = [CodexSci.Doccer.ClaimSelection]::Create($batch, $o)
    $cs = [CodexSci.Doccer.ClaimSelection]::Create($batch, $c)
    $pol = [CodexSci.Doccer.PairingPolicy]::ByKey[string]($Convention, [Func[CodexSci.Doccer.SpanRecord, string]] { param($r) 'g' })
    $pr = [CodexSci.Doccer.Pairing]::Pair($os, $cs, $pol)
    [pscustomobject]@{
        convention = $Convention
        opens      = $os
        closes     = $cs
        result     = $pr
        matches    = $pr.MatchEdges.Count
        faults     = $pr.Faults.UnclosedOpens.Count + $pr.Faults.DanglingCloses.Count + $pr.Faults.MismatchedPairs.Count
    }
}
$french = Invoke-GuillemetPair 'guillemet-open' 'guillemet-close' 'french-ab-bb'
$german = Invoke-GuillemetPair 'guillemet-close' 'guillemet-open' 'german-bb-ab'
$chosen = if ($german.matches -gt $french.matches -or
    ($german.matches -eq $french.matches -and $german.faults -lt $french.faults)) { $german } else { $french }
$opens = $chosen.opens
$closes = $chosen.closes
$paired = $chosen.result
$quoteConvention = $chosen.convention

$markers = [CodexSci.Doccer.ClaimSelection]::FromPredicate($batch, [Func[CodexSci.Doccer.SpanRecord, bool]] {
        param($r) $r.Kind -eq 'page-marker'
    })
$admittedBody = [CodexSci.Doccer.Suppression]::Admitted($markers)

$speakers = [CodexSci.Doccer.ClaimSelection]::FromPredicate($batch, [Func[CodexSci.Doccer.SpanRecord, bool]] {
        param($r) $r.Kind -eq 'speaker-start'
    }).Records([CodexSci.Doccer.ClaimOrder]::Geometry)
$turnZones = [System.Collections.Generic.List[object]]::new()
for ($i = 0; $i -lt $speakers.Count; $i++) {
    $start = $speakers[$i].Span.Start
    $end = if ($i + 1 -lt $speakers.Count) { $speakers[$i + 1].Span.Start } else { $master.Length }
    $name = $master.Text.Substring($speakers[$i].Span.Start, $speakers[$i].Span.Length)
    $preview = $master.Text.Substring($start, [Math]::Min(72, $end - $start)) -replace '\s+', ' '
    $turnZones.Add([pscustomobject]@{
            index = $i
            name  = $name
            start = $start
            end   = $end
            preview = $preview
        })
}

function Get-AtomOrdinal([int] $Start) {
    $lo = 0
    $hi = $master.Topology.AtomCount - 1
    $atoms = $master.Topology.Atoms
    while ($lo -le $hi) {
        $mid = [int](($lo + $hi) / 2)
        $s = $atoms[$mid].Span.Start
        if ($s -eq $Start) { return $mid }
        if ($s -lt $Start) { $lo = $mid + 1 } else { $hi = $mid - 1 }
    }
    throw "witness-doccer-spine: no topology atom starts at $Start"
}

$pieces = [System.Collections.Generic.List[CodexSci.Doccer.OutputPiece]]::new()
$offsetMap = [System.Collections.Generic.List[object]]::new()
$maskOrds = [System.Collections.Generic.List[int]]::new()
$specialCount = 0
$script:dst = 0

function Add-CopySpan([int] $Start, [int] $End, [string] $Reason) {
    if ($End -le $Start) { return }
    $len = $End - $Start
    $script:pieces.Add([CodexSci.Doccer.OutputPiece]::Copy(0, [CodexSci.Doccer.TextSpan]::new($Start, $End)))
    $script:offsetMap.Add([pscustomobject]@{
            op = 'Identity'; srcStart = $Start; srcEnd = $End
            dstStart = $script:dst; dstEnd = $script:dst + $len
            reason = $Reason; literal = $null
        })
    $script:dst += $len
}

function Add-MappedSpan([string] $Literal, [int] $Start, [int] $End, [string] $Reason) {
    $origins = [System.Collections.Generic.List[CodexSci.Doccer.PieceOrigin]]::new()
    $outAtoms = ([CodexSci.Doccer.TextMaster]::new('piece', 0, $Literal)).Topology.AtomCount
    $src = [CodexSci.Doccer.OriginAtom]::new(0, (Get-AtomOrdinal $Start))
    for ($o = 0; $o -lt $outAtoms; $o++) {
        $origins.Add([CodexSci.Doccer.PieceOrigin]::new($o, $src))
    }
    $script:pieces.Add([CodexSci.Doccer.OutputPiece]::OriginMapped($Literal, $origins))
    $op = if ($Literal.Length -gt ($End - $Start)) { 'Expand' } elseif ($Literal.Length -lt ($End - $Start)) { 'Contract' } else { 'Identity' }
    $script:offsetMap.Add([pscustomobject]@{
            op = $op; srcStart = $Start; srcEnd = $End
            dstStart = $script:dst; dstEnd = $script:dst + $Literal.Length
            reason = $Reason; literal = $Literal
        })
    $script:dst += $Literal.Length
}

$base = 0
for ($pi = 0; $pi -lt $parts.Count; $pi++) {
    if ($pi -gt 0) {
        Add-CopySpan $base ($base + 2) 'joiner'
        $base += 2
    }
    $part = $parts[$pi]
    $cursor = 0
    foreach ($sp in @($part.Specials)) {
        if ($null -eq $sp) { continue }
        $script:specialCount++
        $abs0 = $base + [int]$sp.Start
        $abs1 = $base + [int]$sp.End
        if ([int]$sp.Start -gt $cursor) { Add-CopySpan ($base + $cursor) $abs0 'copy' }
        for ($u = $abs0; $u -lt $abs1; $u++) { $maskOrds.Add($u) }
        switch ([string]$sp.Decision) {
            'elide' {
                $offsetMap.Add([pscustomobject]@{
                        op = 'Delete'; srcStart = $abs0; srcEnd = $abs1
                        dstStart = $script:dst; dstEnd = $script:dst
                        reason = "$($sp.Kind)/elide"; literal = $null
                    })
            }
            'keep' { Add-CopySpan $abs0 $abs1 "$($sp.Kind)/keep" }
            default { Add-MappedSpan ([string]$sp.Render) $abs0 $abs1 "$($sp.Kind)/$($sp.Decision)" }
        }
        $cursor = [int]$sp.End
    }
    if ($cursor -lt $part.Text.Length) { Add-CopySpan ($base + $cursor) ($base + $part.Text.Length) 'copy' }
    $base += $part.Text.Length
}

$slots = [System.Collections.Generic.List[CodexSci.Doccer.OriginSlot]]::new()
$slots.Add([CodexSci.Doccer.OriginSlot]::new('spine', $master))
$sourceBasis = [CodexSci.Doccer.OriginBasis]::Create($slots)
$target = [CodexSci.Doccer.MaterializationTarget]::new('shannon-redundancy-of-english', 2, 'render')
$plan = [CodexSci.Doccer.RewritePlan]::Create($sourceBasis, $target, $pieces)
$mat = [CodexSci.Doccer.RewriteMaterialization]::Materialize($plan)
$renderMatch = $mat.OutputMaster.Text -ceq $expected
if ($maskOrds.Count -gt 0) {
    $maskVec = [CodexSci.Doccer.BooleanVector]::Create($master.Length, $maskOrds)
}
else {
    $maskVec = [CodexSci.Doccer.BooleanVector]::None($master.Length)
}
$mask = [CodexSci.Doccer.Utf16UnitMask]::new($master, $master.Extent, $maskVec)
$harvest = $mask.HarvestScalarSpans()

$opCounts = [ordered]@{}
foreach ($row in $offsetMap) {
    $opCounts[$row.op] = 1 + $(if ($opCounts.Contains($row.op)) { [int]$opCounts[$row.op] } else { 0 })
}

function Resolve-SpineForward([int] $Src) {
    foreach ($seg in $offsetMap) {
        if ($Src -lt $seg.srcStart -or $Src -ge $seg.srcEnd) { continue }
        switch ($seg.op) {
            'Identity' {
                return [pscustomobject]@{
                    status = 'Exact'; src = $Src
                    dst = $seg.dstStart + ($Src - $seg.srcStart)
                    dstRange = $null; reason = $seg.reason
                }
            }
            'Delete' {
                return [pscustomobject]@{
                    status = 'Unmapped'; src = $Src
                    dst = $null; dstRange = $null; reason = $seg.reason
                }
            }
            default {
                return [pscustomobject]@{
                    status = 'Range'; src = $Src
                    dst = $null
                    dstRange = @($seg.dstStart, $seg.dstEnd)
                    reason = $seg.reason
                }
            }
        }
    }
    [pscustomobject]@{ status = 'Unmapped'; src = $Src; dst = $null; dstRange = $null; reason = 'outside' }
}

$probes = [System.Collections.Generic.List[object]]::new()
function Add-MapProbe([string] $Name, [string] $Expect, $Got) {
    $probes.Add([pscustomobject]@{
            name = $Name; expect = $Expect; got = $Got
            ok = $Got.status -eq $Expect
        })
}
$copyHit = $offsetMap | Where-Object { $_.op -eq 'Identity' -and ($_.srcEnd - $_.srcStart) -gt 8 } | Select-Object -First 1
if ($copyHit) { Add-MapProbe 'identity-interior' 'Exact' (Resolve-SpineForward ($copyHit.srcStart + 3)) }
$lig = $offsetMap | Where-Object { $_.reason -eq 'ligature/expand' } | Select-Object -First 1
if ($lig) { Add-MapProbe 'ligature-expand' 'Range' (Resolve-SpineForward $lig.srcStart) }
$hole = $offsetMap | Where-Object { $_.literal -eq '\uFFFC' } | Select-Object -First 1
if ($hole) { Add-MapProbe 'float-hole-escape' 'Range' (Resolve-SpineForward $hole.srcStart) }
$esc = $offsetMap | Where-Object { $_.reason -eq 'default/escape' -and $_.literal -ne '\uFFFC' } | Select-Object -First 1
if ($esc) { Add-MapProbe 'default-escape' 'Range' (Resolve-SpineForward $esc.srcStart) }
$keep = $offsetMap | Where-Object { $_.reason -match '/keep$' } | Select-Object -First 1
if ($keep) { Add-MapProbe 'letter-keep' 'Exact' (Resolve-SpineForward $keep.srcStart) }

$report = [ordered]@{
    source            = $jsonlFull
    inventory         = $invFull
    admittedBlocks    = $admittedBlocks
    floatHoles        = $floatHoles
    spineChars        = $master.Length
    spineAtoms        = $master.Topology.AtomCount
    claims            = $batch.Count
    kindCounts        = $kindCounts
    pairing           = [ordered]@{
        convention = $quoteConvention
        frenchMatches = $french.matches
        frenchFaults  = $french.faults
        germanMatches = $german.matches
        germanFaults  = $german.faults
        opens     = $opens.Count
        closes    = $closes.Count
        matches   = $paired.MatchEdges.Count
        unclosed  = $paired.Faults.UnclosedOpens.Count
        dangling  = $paired.Faults.DanglingCloses.Count
        mismatched = $paired.Faults.MismatchedPairs.Count
        balanced  = ($opens.Count -eq $closes.Count) -and
            ($paired.Faults.UnclosedOpens.Count -eq 0) -and
            ($paired.Faults.DanglingCloses.Count -eq 0) -and
            ($paired.Faults.MismatchedPairs.Count -eq 0)
    }
    bodyAfterSuppress = $admittedBody.Coverage
    speakerStarts     = $speakers.Count
    turnZones         = $turnZones.Count
    turns             = @($turnZones)
    specialsPs        = $specialCount
    harvestAdmitted   = $harvest.AdmittedSpans.Count
    harvestBoundary   = $harvest.BoundaryResidual.Population
    renderMatch       = $renderMatch
    renderChars       = $mat.OutputMaster.Text.Length
    expectedChars     = $expected.Length
    planPieces        = $plan.Count
    unusedSourceSpans = $mat.UnusedSources[0].Count
    unusedSourceCover = $mat.UnusedSources[0].Coverage
    offsetMapOps      = $opCounts
    offsetMapSamples  = @(
        $offsetMap | Where-Object { $_.op -ne 'Identity' } | Select-Object -First 24
    )
    offsetMapProbes   = @($probes)
    offsetMapDstLen   = $script:dst
}

if (-not $OutPath) {
    $OutPath = Join-Path (Split-Path $jsonlFull -Parent) 'doccer-spine-witness.json'
}
$outFull = [IO.Path]::GetFullPath($OutPath)
$dir = [IO.Path]::GetDirectoryName($outFull)
if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
$utf8 = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($outFull, ($report | ConvertTo-Json -Depth 6), $utf8)

Write-Output ("spine={0} claims={1} convention={2} matches={3} faults={4} turns={5} renderMatch={6} mapProbes={7}" -f `
        $master.Length, $batch.Count, $quoteConvention, $paired.MatchEdges.Count, `
        ($paired.Faults.UnclosedOpens.Count + $paired.Faults.DanglingCloses.Count), `
        $turnZones.Count, $renderMatch, (($probes | Where-Object ok).Count.ToString() + '/' + $probes.Count))
Write-Output "wrote $outFull"
[pscustomobject]$report
