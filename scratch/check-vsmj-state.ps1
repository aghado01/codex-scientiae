#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1

$cp = 'ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.chunks.jsonl'
$propDir = 'ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.proposals'
Write-Host "Proposals:" (Get-ChildItem $propDir -ErrorAction SilentlyContinue | ForEach-Object Name)

$flagged = Read-Chunks $cp | Where-Object { $_.fidelity -match 'needs|suspect' }
Write-Host "Flagged in stream: $($flagged.Count)"
$flagged | ForEach-Object { "id=$($_.id) fidelity=$($_.fidelity) corr=$($_.corruption_type)" }

Write-Host "`nDeliverables:"
Group-Deliverables (Read-Chunks $cp) | ForEach-Object { "id=$($_.id) issues=$($_.issues -join '+')" }
