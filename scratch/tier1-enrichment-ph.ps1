#requires -Version 7.0
param(
    [switch]$ApplyAuto,
    [string[]]$Papers = @('2204.11080v2','VSMJ2011','1809.10945v1','2412.02591v2','2406.14677v1','WRD2025','DBK2023')
)
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\enrichment.ps1

function Apply-EnrichmentWrap {
    param([string]$ChunksPath, [int]$ChunkId, [string]$Text)
    $find = $Text
    if ($find -notmatch '\$') {
        $r = Add-RepairEdit -ChunksPath $ChunksPath -Id $ChunkId -Find $find -Replace "`$$find`$"
        return $r
    }
    return [pscustomobject]@{ accepted = $false; reason = 'already wrapped or no match' }
}

foreach ($p in $Papers) {
    $cp = "ingestion/compendia/ph/$p/.scratch/$p.chunks.jsonl"
    if (-not (Test-Path -LiteralPath $cp)) { continue }
    $cands = Get-EnrichablesFromChunks @(Read-Chunks $cp)
    $e = Get-EnrichmentCounts $cands
    Write-Host "`n=== $p ===" -ForegroundColor Cyan
    Write-Host "  enrichable=$($e.enrichable) auto=$($e.auto_tier) review=$($e.review_tier) escalate=$($e.escalate_tier)"

    if ($ApplyAuto) {
        $applied = 0; $held = 0
        $auto = @($cands | Where-Object { $_.apply_tier -eq 'auto' -and $_.bucket -eq 'safe-wrap' })
        foreach ($c in $auto) {
            $slice = Get-Slice -ChunksPath $cp -Id ([int]$c.id)
            $content = [string]$slice.content
            if ($content -notmatch [regex]::Escape($c.text)) { $held++; continue }
            $r = Add-RepairEdit -ChunksPath $cp -Id ([int]$c.id) -Find $c.text -Replace "`$$($c.text)`$" -Source 'tier1-auto'
            if ($r.status -eq 'clean') {
                Invoke-RepairApply -ChunksPath $cp | Out-Null
                $applied++
            } else { $held++ }
        }
        Write-Host "  auto-applied: $applied held: $held"
    } else {
        $cands | Group-Object apply_tier | ForEach-Object {
            Write-Host "  tier $($_.Name): $($_.Count)"
            $_.Group | Select-Object -First 3 | ForEach-Object { "    id=$($_.id) [$($_.bucket)] $($_.text)" }
        }
    }
}
