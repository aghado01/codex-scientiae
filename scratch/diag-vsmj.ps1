#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\fidelity.ps1

$cp = 'ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.chunks.jsonl'
foreach ($id in 41,44,49,118) {
    $s = Get-Slice -ChunksPath $cp -Id $id
    $issues = Get-ChunkIssues $s
    Write-Host "`nid $id fidelity=$($s.fidelity) type=$($s.type)"
    foreach ($i in $issues) { Write-Host "  issue $($i.type): $($i.diagnostic)" }
    $ct = Get-CorruptionType $s
    Write-Host "  gate: $ct"
}
