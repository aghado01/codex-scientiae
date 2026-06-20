#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\finalize.ps1

$cp = 'ingestion/compendia/ph/2204.11080v2/.scratch/2204.11080v2.chunks.jsonl'

function Drop-Debris([int]$Id) {
    $s = Get-Slice -ChunksPath $cp -Id $Id
    $old = [string]$s.content
    if ($old.Length -lt 2) { return }
    $r = Add-RepairEdit -ChunksPath $cp -Id $Id -Find $old -Replace ' '
    Write-Host "id $Id : $($r.status)"
    if ($r.status -eq 'clean') { Invoke-RepairApply -ChunksPath $cp | Out-Null }
}

# Duplicate Figure 6 debris row (caption already on id 684)
Drop-Debris 690

# Figure 5 row: keep caption only (matches source md line 882)
$s283 = Get-Slice -ChunksPath $cp -Id 283
$fig5 = 'Figure 5: An example of an up-down cell-wise filtration U built from a given simplex-wise filtration F . For brevity, F does not start and end with empty complexes. The final conversion to $\hat{E}$ is not shown for this example due to page-width constraint. A complete conversion for a smaller example is shown in Figure 6.'
$r5 = Add-RepairProposal -ChunksPath $cp -Id 283 -Content $fig5 -Source 'figure5-caption'
Write-Host "283 fig5 caption: accepted=$($r5.accepted)"
if ($r5.accepted) { Invoke-RepairApply -ChunksPath $cp | Out-Null }

$chunks = [System.Collections.Generic.List[object]]::new()
foreach ($line in [System.IO.File]::ReadLines($cp)) {
    if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
}
foreach ($c in $chunks) {
    if ([int]$c.id -eq 690 -and [string]$c.content -match '^\s$') {
        $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'crumb' -Force
    }
    if ([int]$c.id -eq 283) {
        $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'caption' -Force
        $c | Add-Member -NotePropertyName fidelity -NotePropertyValue 'faithful' -Force
    }
}
Write-JsonlStage -Records $chunks.ToArray() -OutputPath $cp -Stage 'figure-caption-tag' | Out-Null
Invoke-Finalize -ChunksPath $cp | Out-Null

Write-Host "`nFigure regions:" -ForegroundColor Cyan
Select-String -Path 'ingestion/compendia/ph/2204.11080v2/.scratch/2204.11080v2.md' -Pattern 'Figure [56]:|vveeee|eevvee|c0←' | ForEach-Object { "$($_.LineNumber): $($_.Line.Trim())" }
