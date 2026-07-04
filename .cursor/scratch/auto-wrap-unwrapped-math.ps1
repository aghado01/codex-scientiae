#requires -Version 7.0
# Auto-wrap unwrapped_math spans from work_order (right-to-left to preserve offsets).
. "$PSScriptRoot/../src/serving.ps1"

function Wrap-UnwrappedMathSpans([string]$Content, $Spans) {
    $sorted = @($Spans | Sort-Object { [int]$_.start } -Descending)
    $result = $Content
    foreach ($sp in $sorted) {
        $s = [int]$sp.start; $e = [int]$sp.end
        if ($s -lt 0 -or $e -gt $result.Length -or $s -ge $e) { continue }
        $inner = $result.Substring($s, $e - $s)
        if ($inner.StartsWith('$') -and $inner.EndsWith('$')) { continue }
        $result = $result.Substring(0, $s) + '$' + $inner + '$' + $result.Substring($e)
    }
    return $result
}

function Repair-UnwrappedMathOnly {
    param([string]$ChunksPath)
    $fixed = 0; $failed = @()
    foreach ($d in (Group-Deliverables (Read-Chunks $ChunksPath))) {
        $issues = @($d.issues | Where-Object { $_ -ne 'fragmented_formula' })
        if ($issues.Count -ne 1 -or $issues[0] -ne 'unwrapped_math') { continue }
        $id = [int]$d.id
        $slice = Get-Slice -ChunksPath $ChunksPath -Id $id
        $recipe = @($slice.work_order.recipes | Where-Object { $_.type -eq 'unwrapped_math' } | Select-Object -First 1)
        if (-not $recipe -or -not $recipe.spans.Count) { continue }
        $new = Wrap-UnwrappedMathSpans ([string]$slice.content) $recipe.spans
        if ($new -eq [string]$slice.content) { continue }
        $r = Add-RepairProposal -ChunksPath $ChunksPath -Id $id -Content $new -Source 'auto-wrap'
        if ($r.accepted) {
            Invoke-RepairApply -ChunksPath $ChunksPath | Out-Null
            $fixed++
        } else {
            $failed += [pscustomobject]@{ id = $id; reason = $r.reason }
        }
    }
    [pscustomobject]@{ fixed = $fixed; failed = $failed }
}

param([string[]]$Papers)
if (-not $Papers) { $Papers = @('2412.02591v2', 'VSMJ2011') }
foreach ($p in $Papers) {
    $cp = "ingestion/compendia/ph/$p/.scratch/$p.chunks.jsonl"
    if (-not (Test-Path -LiteralPath $cp)) { Write-Warning "skip $p"; continue }
    Write-Host "=== $p ===" -ForegroundColor Cyan
    $r = Repair-UnwrappedMathOnly -ChunksPath $cp
    Write-Host "  auto-wrapped: $($r.fixed), failed: $($r.failed.Count)"
    if ($r.failed.Count) { $r.failed | Format-Table -AutoSize }
}
