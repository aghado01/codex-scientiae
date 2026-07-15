#requires -Version 7.0
<#
  scratch/enrichment-surfacer-probe.ps1 — MEASUREMENT probe, not production.

  Compares .md deliverable surfacing (2026-06-19 baseline) vs Tier-1 chunk-substrate surfacing
  (prose, non-reference, faithful, math_dirt<2). Production surfacer: src/enrichment.ps1.
#>

. "$PSScriptRoot/../src/serving.ps1"

$papers = @(
    @{ slug = 'WRD2025';    md = "$PSScriptRoot/../ingestion/compendia/ph/WRD2025/.scratch/WRD2025.md";    chunks = "$PSScriptRoot/../ingestion/compendia/ph/WRD2025/.scratch/WRD2025.chunks.jsonl" }
    @{ slug = 'DBK2023';    md = "$PSScriptRoot/../ingestion/compendia/ph/DBK2023/.scratch/DBK2023.md";    chunks = "$PSScriptRoot/../ingestion/compendia/ph/DBK2023/.scratch/DBK2023.chunks.jsonl" }
    @{ slug = '1109.4499v1'; md = "$PSScriptRoot/../ingestion/gauntlet/voroninski/1109.4499v1/.scratch/1109.4499v1.md"; chunks = "$PSScriptRoot/../ingestion/gauntlet/voroninski/1109.4499v1/.scratch/1109.4499v1.chunks.jsonl" }
    @{ slug = '2008.10579v1'; md = "$PSScriptRoot/../ingestion/gauntlet/voroninski/2008.10579v1/.scratch/2008.10579v1.md"; chunks = "$PSScriptRoot/../ingestion/gauntlet/voroninski/2008.10579v1/.scratch/2008.10579v1.chunks.jsonl" }
) | Where-Object { Test-Path -LiteralPath $_.chunks }

$rxMath = [regex]'\$\$[\s\S]*?\$\$|\$[^$\n]+\$'
$rxMd   = [regex]'!?\[[^\]]*\]\([^)]*\)|`[^`]*`'
$break  = '.;:'

function Get-MdCandidates([string]$Text) {
    $out  = [System.Collections.Generic.List[object]]::new()
    $p1    = Get-MaskedText -Text $Text -Mask (New-Mask $Text $rxMath)
    $prose = Get-MaskedText -Text $p1   -Mask (New-Mask $p1   $rxMd)
    foreach ($line in ($prose -split "`n")) {
        $toks = [regex]::Matches($line, '[A-Za-z]+|\d+|\S') | ForEach-Object { $_.Value }
        $run = [System.Collections.Generic.List[string]]::new()
        $flush = {
            if ($run.Count -ge 2) {
                $hasOp = $false; $hasFuncApp = $false; $lossy = $false
                for ($i = 0; $i -lt $run.Count; $i++) {
                    if (($script:MathFunc -contains $run[$i]) -or ($run[$i].Length -eq 1 -and '=<>^_/*+'.Contains($run[$i]))) { $hasOp = $true }
                    if ($i -gt 0 -and ($run[$i] -eq '(') -and ($run[$i - 1] -match '^[A-Za-z]$')) { $hasFuncApp = $true }
                    if ($i -gt 0 -and (Test-EnrichmentValueAtom $run[$i]) -and (Test-EnrichmentValueAtom $run[$i - 1])) { $lossy = $true }
                }
                if ($hasOp -or $hasFuncApp) {
                    $bucket = if ($lossy) { 'lossy' } else { 'safe-wrap' }
                    $out.Add([pscustomobject]@{ text = ($run -join ' '); bucket = $bucket })
                }
            }
            $run.Clear()
        }
        foreach ($t in $toks) {
            if ((Test-MathGlyphToken $t) -and -not $break.Contains($t)) { $run.Add($t) }
            else { & $flush }
        }
        & $flush
    }
    return $out.ToArray()
}

function Format-Row($slug, $cands) {
    $safe = @($cands | Where-Object { $_.bucket -eq 'safe-wrap' })
    $loss = @($cands | Where-Object { $_.bucket -eq 'lossy' })
    [pscustomobject]@{ slug = $slug; safe_wrap = $safe.Count; lossy = $loss.Count; total = $cands.Count }
}

function Show-Totals($rows, [string]$label) {
    $safe = ($rows | Measure-Object -Property safe_wrap -Sum).Sum
    $loss = ($rows | Measure-Object -Property lossy -Sum).Sum
    $tot  = $safe + $loss
    ""
    "=== $label ==="
    $rows | Format-Table slug, safe_wrap, lossy, total -AutoSize
    "TOTAL  safe-wrap=$safe  lossy=$loss  (n=$tot)"
    if ($tot -gt 0) { "ratio  safe-wrap={0:P0}  lossy={1:P0}" -f ($safe / $tot), ($loss / $tot) }
}

$mdRows = [System.Collections.Generic.List[object]]::new()
$chunkRows = [System.Collections.Generic.List[object]]::new()
$sampSafe = [System.Collections.Generic.List[string]]::new()
$sampLossy = [System.Collections.Generic.List[string]]::new()

foreach ($p in $papers) {
    if (Test-Path -LiteralPath $p.md) {
        $mdC = Get-MdCandidates ([System.IO.File]::ReadAllText($p.md, [System.Text.UTF8Encoding]::new($false)))
        $mdRows.Add((Format-Row $p.slug $mdC))
    }
    $chunkC = Get-EnrichablesFromChunks @(Read-Chunks $p.chunks)
    $chunkRows.Add((Format-Row $p.slug $chunkC))
    foreach ($s in ($chunkC | Where-Object { $_.bucket -eq 'safe-wrap' } | Select-Object -ExpandProperty text -Unique | Select-Object -First 3)) {
        if ($sampSafe.Count -lt 12) { $sampSafe.Add($s) }
    }
    foreach ($s in ($chunkC | Where-Object { $_.bucket -eq 'lossy' } | Select-Object -ExpandProperty text -Unique | Select-Object -First 3)) {
        if ($sampLossy.Count -lt 12) { $sampLossy.Add($s) }
    }
}

Show-Totals $mdRows 'DELIVERABLE .md (2026-06-19 baseline — markdown masked)'
Show-Totals $chunkRows 'CHUNK SUBSTRATE (Tier 1 — prose chunks, faithful, math_dirt<2)'

$mdTot = ($mdRows | Measure-Object -Property total -Sum).Sum
$chTot = ($chunkRows | Measure-Object -Property total -Sum).Sum
""
"delta  md=$mdTot  chunks=$chTot  (chunks - md = $($chTot - $mdTot))"

$e = Get-EnrichmentCounts (Get-EnrichablesFromChunks @($papers | ForEach-Object { Read-Chunks $_.chunks } | ForEach-Object { $_ }))
""
"apply_tier (chunk substrate, all papers): auto=$($e.auto_tier) review=$($e.review_tier) escalate=$($e.escalate_tier)"
""
"--- sample CHUNK safe-wrap ---"; $sampSafe | Select-Object -Unique | ForEach-Object { "  $_" }
"--- sample CHUNK lossy ---";     $sampLossy | Select-Object -Unique | ForEach-Object { "  $_" }
