#requires -Version 7.0
<#
  src/restructure.ps1 — structural membrane ops: retype / split / merge.

  These change the chunk SET (split/merge renumber ids + rebuild the .jidx), so unlike the
  content write-side they can't be per-id staged proposals merged at commit. They apply to
  the stream immediately and are meant as a SERIAL re-segmentation phase that precedes the
  parallel content-repair phase: fix structure, then fix content.

  Each op renumbers ids positionally, re-grades ONLY the affected chunks (so existing
  needs_review / needs_repair grades on untouched chunks survive), and appends a before/after
  record to a .structure-audit sidecar. They refuse while content proposals are staged
  (commit or discard them first) so ids never drift under pending edits.

    . ./restructure.ps1
    Set-ChunkType  -ChunksPath <c.jsonl> -Id <n> -NewType <type>           [-NodesPath <n.jsonl>]
    Split-Chunk    -ChunksPath <c.jsonl> -Id <n> -Before <unique marker>   [-NodesPath <n.jsonl>]
    Merge-Chunks   -ChunksPath <c.jsonl> -Ids <contiguous ids>             [-NodesPath <n.jsonl>]
#>

. "$PSScriptRoot/jsonl.ps1"
. "$PSScriptRoot/fidelity.ps1"

# load the stream, refusing if content proposals are pending (id drift guard)
function Read-StructChunks([string]$ChunksPath) {
    $propDir = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals'
    if ((Test-Path -LiteralPath $propDir) -and @(Get-ChildItem -LiteralPath $propDir -Filter '*.json' -File -ErrorAction SilentlyContinue).Count) {
        throw 'staged content proposals exist -- commit or discard them before restructuring'
    }
    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }
    return , $chunks
}

# renumber positionally, re-grade the affected chunks, write + rebuild + audit
function Save-Structure($Chunks, $Affected, [string]$ChunksPath, [string]$NodesPath, $AuditRec) {
    for ($i = 0; $i -lt $Chunks.Count; $i++) { $Chunks[$i] | Add-Member -NotePropertyName id -NotePropertyValue $i -Force }
    foreach ($c in $Affected) {
        $ct = Get-CorruptionType $c
        $c | Add-Member -NotePropertyName fidelity -NotePropertyValue $(if ($ct) { 'suspect' } else { 'faithful' }) -Force
        if ($ct) { $c | Add-Member -NotePropertyName corruption_type -NotePropertyValue $ct -Force }
        else { $c.PSObject.Properties.Remove('corruption_type') }
        Set-ChunkAgreement $c | Out-Null   # re-derive the ranking score so split/merge can't strand a stale one
    }
    $manifest = Write-JsonlStage -Records $Chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'restructure'
    $auditPath = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.structure-audit.jsonl'
    [System.IO.File]::AppendAllText($auditPath, (($AuditRec | ConvertTo-Json -Compress -Depth 8) + "`n"), [System.Text.UTF8Encoding]::new($false))
    return $manifest
}

function Find-ChunkIndex($Chunks, [int]$Id) {
    for ($i = 0; $i -lt $Chunks.Count; $i++) { if ([int]$Chunks[$i].id -eq $Id) { return $i } }
    return -1
}

# Part B — reject a structural op when the would-be result chunk(s) trip a structural impossibility.
# Mirrors Add-RepairProposal's accepted=$false; reason; diagnostic shape (structural ops use ok=$false).
function Test-StructImpossibility($Chunks, [int]$Id = -1, [int[]]$Ids = $null) {
    foreach ($c in $Chunks) {
        $imp = Get-StructuralImpossibility $c
        if ($imp) {
            $rej = [ordered]@{ ok = $false; reason = $imp.reason; diagnostic = $imp.diagnostic }
            if ($Ids) { $rej['ids'] = $Ids } elseif ($Id -ge 0) { $rej['id'] = $Id }
            return [pscustomobject]$rej
        }
    }
    return $null
}

function Set-ChunkType {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath, [Parameter(Mandatory)][int]$Id,
        [Parameter(Mandatory)][string]$NewType, [string]$NodesPath
    )
    $chunks = Read-StructChunks $ChunksPath
    $i = Find-ChunkIndex $chunks $Id
    if ($i -lt 0) { return [pscustomobject]@{ ok = $false; reason = "chunk $Id not found" } }
    $old = [string]$chunks[$i].type
    $wouldBe = [pscustomobject]@{ type = $NewType; content = [string]$chunks[$i].content }
    $reject = Test-StructImpossibility @($wouldBe) -Id $Id
    if ($reject) { return $reject }
    $chunks[$i] | Add-Member -NotePropertyName type -NotePropertyValue $NewType -Force
    [void](Save-Structure $chunks @($chunks[$i]) $ChunksPath $NodesPath ([ordered]@{ op = 'retype'; id = $Id; from = $old; to = $NewType }))
    [pscustomobject]@{ ok = $true; op = 'retype'; id = $Id; from = $old; to = $NewType; fidelity = [string]$chunks[$i].fidelity }
}

function Split-Chunk {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath, [Parameter(Mandatory)][int]$Id,
        [Parameter(Mandatory)][string]$Before, [string]$NodesPath
    )
    $chunks = Read-StructChunks $ChunksPath
    $pos = Find-ChunkIndex $chunks $Id
    if ($pos -lt 0) { return [pscustomobject]@{ ok = $false; reason = "chunk $Id not found" } }
    $first = $chunks[$pos]
    $content = [string]$first.content
    $at = $content.IndexOf($Before)
    if ($at -le 0) { return [pscustomobject]@{ ok = $false; reason = 'split marker not found, or at the very start' } }
    if ($content.IndexOf($Before, $at + $Before.Length) -ge 0) { return [pscustomobject]@{ ok = $false; reason = 'split marker not unique -- narrow it' } }

    $second = ($first | ConvertTo-Json -Depth 14 -Compress | ConvertFrom-Json)   # deep clone for the second half
    $first  | Add-Member -NotePropertyName content -NotePropertyValue ($content.Substring(0, $at).TrimEnd()) -Force
    $second | Add-Member -NotePropertyName content -NotePropertyValue ($content.Substring($at)) -Force
    $chunkType = [string]$first.type
    $reject = Test-StructImpossibility @(
        [pscustomobject]@{ type = $chunkType; content = [string]$first.content }
        [pscustomobject]@{ type = $chunkType; content = [string]$second.content }
    ) -Id $Id
    if ($reject) { return $reject }
    $chunks.Insert($pos + 1, $second)

    [void](Save-Structure $chunks @($first, $second) $ChunksPath $NodesPath ([ordered]@{ op = 'split'; id = $Id; before = $Before }))
    [pscustomobject]@{ ok = $true; op = 'split'; original_id = $Id; new_ids = @([int]$first.id, [int]$second.id); note = 'ids renumbered -- re-orient' }
}

function Merge-Chunks {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath, [Parameter(Mandatory)][int[]]$Ids, [string]$NodesPath
    )
    if ($Ids.Count -lt 2) { return [pscustomobject]@{ ok = $false; reason = 'need >= 2 ids to merge' } }
    $sorted = @($Ids | Sort-Object)
    for ($k = 1; $k -lt $sorted.Count; $k++) { if ($sorted[$k] -ne $sorted[$k - 1] + 1) { return [pscustomobject]@{ ok = $false; reason = 'ids must be contiguous' } } }
    $chunks = Read-StructChunks $ChunksPath
    $leadPos = Find-ChunkIndex $chunks $sorted[0]
    $tailPos = Find-ChunkIndex $chunks $sorted[-1]
    if ($leadPos -lt 0 -or $tailPos -lt 0 -or ($tailPos - $leadPos) -ne ($sorted.Count - 1)) { return [pscustomobject]@{ ok = $false; reason = 'ids not all found as a contiguous run' } }

    $lead = $chunks[$leadPos]
    $merged = (($leadPos..$tailPos) | ForEach-Object { [string]$chunks[$_].content }) -join ' '
    $wouldBe = [pscustomobject]@{ type = [string]$lead.type; content = $merged }
    $reject = Test-StructImpossibility @($wouldBe) -Ids $sorted
    if ($reject) { return $reject }
    $lead | Add-Member -NotePropertyName content -NotePropertyValue $merged -Force
    for ($j = $tailPos; $j -gt $leadPos; $j--) { $chunks.RemoveAt($j) }

    [void](Save-Structure $chunks @($lead) $ChunksPath $NodesPath ([ordered]@{ op = 'merge'; ids = $sorted; into = $sorted[0] }))
    [pscustomobject]@{ ok = $true; op = 'merge'; merged_ids = $sorted; new_id = [int]$lead.id; note = 'ids renumbered -- re-orient' }
}
