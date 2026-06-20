#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1

$cp = 'ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.chunks.jsonl'
foreach ($id in 41,44,49,118) {
    Write-Host "`n======== id $id ========"
    $s = Get-Slice -ChunksPath $cp -Id $id
    foreach ($r in $s.work_order.recipes) { Write-Host "  $($r.type): $($r.diagnostic)" }
    Write-Host $s.content
}
