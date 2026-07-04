#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1

$cp = 'ingestion/compendia/ph/2204.11080v2/.scratch/2204.11080v2.chunks.jsonl'
foreach ($id in 684,685,686) {
    Write-Host "`n======== id $id ========" -ForegroundColor Cyan
    $s = @(Get-Slice -ChunksPath $cp -Id $id -Context 2)
    foreach ($r in $s) {
        Write-Host "--- id $($r.id) type=$($r.type) fidelity=$($r.fidelity) corr=$($r.corruption_type) ---"
        Write-Host $r.content
    }
}

# Also check source md nearby for figure/table context
$md = 'ingestion/compendia/ph/2204.11080v2/2204.11080v2.md'
if (Test-Path $md) {
    Write-Host "`n=== source md grep context ===" -ForegroundColor Cyan
    Select-String -Path $md -Pattern 'K K K|vveeee|011100|684|Figure|Table|Algorithm' -Context 2,2 | Select-Object -First 15
}
