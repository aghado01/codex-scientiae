#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\finalize.ps1
. .\src\md-cleanup.ps1

Write-Host "=== Batch summary ===" -ForegroundColor Cyan
Get-BatchSummary -Root 'ingestion/compendia/ph' | Format-Table paper,actionable,pending,stage -AutoSize

$papers = @('WRD2025','DBK2023','1809.10945v1','2204.11080v2','2406.14677v1','2412.02591v2','VSMJ2011')
foreach ($p in $papers) {
    $cp = "ingestion/compendia/ph/$p/.scratch/$p.chunks.jsonl"
    if (-not (Test-Path $cp)) { continue }
    $fin = Invoke-Finalize -ChunksPath $cp
    $md = $fin.body
    $issues = Find-MathClosureIssues -Text ([System.IO.File]::ReadAllText($md, [System.Text.UTF8Encoding]::new($false)))
    Write-Host "$p : pending=$($fin.pending) closure_issues=$($issues.Count)"
}
