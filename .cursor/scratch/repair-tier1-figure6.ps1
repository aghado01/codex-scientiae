#requires -Version 7.0
param([switch]$ApplyAuto)
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\finalize.ps1
. .\src\enrichment.ps1

# --- Tier-1 auto-wrap ---
Write-Host "=== Tier-1 auto enrichment ===" -ForegroundColor Cyan
$papers = @('2204.11080v2','VSMJ2011','1809.10945v1','2412.02591v2','2406.14677v1','WRD2025','DBK2023')
$totalAuto = 0; $totalHeld = 0
foreach ($p in $papers) {
    $cp = "ingestion/compendia/ph/$p/.scratch/$p.chunks.jsonl"
    if (-not (Test-Path -LiteralPath $cp)) { continue }
    if (-not $ApplyAuto) {
        $e = Get-EnrichmentCounts (Get-EnrichablesFromChunks @(Read-Chunks $cp))
        Write-Host "$p : auto=$($e.auto_tier) review=$($e.review_tier) escalate=$($e.escalate_tier)"
        continue
    }
    $auto = @(Get-EnrichablesFromChunks @(Read-Chunks $cp) | Where-Object { $_.apply_tier -eq 'auto' -and $_.bucket -eq 'safe-wrap' })
    $applied = 0; $held = 0
    foreach ($c in $auto) {
        $slice = Get-Slice -ChunksPath $cp -Id ([int]$c.id)
        if ([string]$slice.content -notmatch [regex]::Escape($c.text)) { $held++; continue }
        $r = Add-RepairEdit -ChunksPath $cp -Id ([int]$c.id) -Find $c.text -Replace "`$$($c.text)`$" -Source 'tier1-auto'
        if ($r.status -eq 'clean') { Invoke-RepairApply -ChunksPath $cp | Out-Null; $applied++ } else { $held++ }
    }
    Write-Host "$p : applied=$applied held=$held"
    $totalAuto += $applied; $totalHeld += $held
}
if ($ApplyAuto) { Write-Host "Tier-1 total: applied=$totalAuto held=$totalHeld`n" -ForegroundColor Green }

# --- Figure 6: replace OCR garbage with caption; drop label debris ---
Write-Host "=== Figure 6 repair ===" -ForegroundColor Cyan
$cp = 'ingestion/compendia/ph/2204.11080v2/.scratch/2204.11080v2.chunks.jsonl'
$caption = 'Figure 6: An example of converting a zigzag filtration $\hat{F}$ to a non-zigzag filtration.'

function Clear-Chunk([string]$Path, [int]$Id) {
    $r = Add-RepairProposal -ChunksPath $Path -Id $Id -Content '' -Source 'figure6-drop'
    if ($r.accepted) { Invoke-RepairApply -ChunksPath $Path | Out-Null; return $true }
    Write-Host "  clear id $Id failed: $($r.reason)"
    return $false
}

# id 684: replace gibberish diagram row with clean caption
$r684 = Add-RepairProposal -ChunksPath $cp -Id 684 -Content $caption -Source 'figure6-caption'
Write-Host "684 caption: accepted=$($r684.accepted)"
if ($r684.accepted) { Invoke-RepairApply -ChunksPath $cp | Out-Null }

# ids 685-688: diagram annotation debris (source md confirms caption is standalone at line 1363)
foreach ($id in 685,686,687,688) {
    $s = Get-Slice -ChunksPath $cp -Id $id
    if ([string]$s.fidelity -eq 'unrecoverable' -or [string]$s.content -match 'vveeee|^\^|^\d+ \d+$|↩|↪') {
        Clear-Chunk $cp $id | Out-Null
    }
}

# Re-grade stream: empty chunks -> furniture crumb
$chunks = [System.Collections.Generic.List[object]]::new()
foreach ($line in [System.IO.File]::ReadLines($cp)) {
    if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
}
$changed = $false
foreach ($c in $chunks) {
    if ([int]$c.id -in 684,685,686,687,688) {
        if ([string]$c.content -eq '') {
            $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'crumb' -Force
            $c | Add-Member -NotePropertyName fidelity -NotePropertyValue 'faithful' -Force
            $c.PSObject.Properties.Remove('corruption_type')
            $changed = $true
        } elseif ([int]$c.id -eq 684) {
            $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'caption' -Force
            $c | Add-Member -NotePropertyName fidelity -NotePropertyValue 'faithful' -Force
            $c.PSObject.Properties.Remove('corruption_type')
            $changed = $true
        }
    }
}
if ($changed) {
    Write-JsonlStage -Records $chunks.ToArray() -OutputPath $cp -Stage 'figure6-tag' | Out-Null
}

$fin = Invoke-Finalize -ChunksPath $cp
$sum = Get-BatchSummary -Root 'ingestion/compendia/ph' | Where-Object paper -eq '2204.11080v2'
Write-Host "2204: pending=$($fin.pending) actionable=$($sum.actionable) handoff=$($sum.handoff)"

# Finalize all enriched papers
if ($ApplyAuto) {
    foreach ($p in $papers) {
        $cp2 = "ingestion/compendia/ph/$p/.scratch/$p.chunks.jsonl"
        if (Test-Path $cp2) { Invoke-Finalize -ChunksPath $cp2 | Out-Null }
    }
    Write-Host "`n=== Post-enrichment batch ===" -ForegroundColor Cyan
    Get-BatchSummary -Root 'ingestion/compendia/ph' | Format-Table paper,actionable,handoff -AutoSize
}
