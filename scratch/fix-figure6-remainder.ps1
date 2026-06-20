#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\finalize.ps1

$cp = 'ingestion/compendia/ph/2204.11080v2/.scratch/2204.11080v2.chunks.jsonl'

Write-Host "Handoff chunks:" -ForegroundColor Cyan
Read-Chunks $cp | Where-Object { $_.fidelity -eq 'unrecoverable' } | ForEach-Object {
    Write-Host "id=$($_.id) preview=$($_.content.Substring(0,[Math]::Min(100,$_.content.Length)))"
}

foreach ($c in (Read-Chunks $cp | Where-Object { $_.fidelity -eq 'unrecoverable' })) {
    $id = [int]$c.id
    $old = [string]$c.content
    $r = Add-RepairEdit -ChunksPath $cp -Id $id -Find $old -Replace ' '
    Write-Host "id $id edit: status=$($r.status)"
    if ($r.status -eq 'clean') { Invoke-RepairApply -ChunksPath $cp | Out-Null }
}

# Tag cleared debris as crumbs
$chunks = [System.Collections.Generic.List[object]]::new()
foreach ($line in [System.IO.File]::ReadLines($cp)) {
    if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
}
foreach ($c in $chunks) {
    if ([string]$c.content -match '^\s$' -and [int]$c.id -in 685,686,687,688) {
        $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'crumb' -Force
        $c | Add-Member -NotePropertyName fidelity -NotePropertyValue 'faithful' -Force
        $c.PSObject.Properties.Remove('corruption_type')
    }
}
Write-JsonlStage -Records $chunks.ToArray() -OutputPath $cp -Stage 'figure6-crumb' | Out-Null

Invoke-Finalize -ChunksPath $cp | Out-Null
Get-BatchSummary -Root 'ingestion/compendia/ph' | Where-Object paper -eq '2204.11080v2' | Format-List

# Show Figure 6 region in finalized md
Write-Host "`nFigure 6 region:" -ForegroundColor Cyan
$md = Get-Content 'ingestion/compendia/ph/2204.11080v2/.scratch/2204.11080v2.md'
$idx = ($md | Select-String -Pattern 'Figure 6' | Select-Object -First 1).LineNumber
if ($idx) { $md[([Math]::Max(0,$idx-5))..([Math]::Min($md.Count-1,$idx+3))] }
