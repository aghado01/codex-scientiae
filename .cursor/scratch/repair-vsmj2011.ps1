#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\finalize.ps1

$cp = 'ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.chunks.jsonl'

function Try-Edit($id, $find, $replace) {
    $r = Add-RepairEdit -ChunksPath $cp -Id $id -Find $find -Replace $replace
    Write-Host "id $id : $($r.status) $($r.corruption_type) $($r.reason)"
    if ($r.status -eq 'clean') { Invoke-RepairApply -ChunksPath $cp | Out-Null }
    return $r.status -eq 'clean'
}

# id 41: broken P_{\} \text{Pers}
Try-Edit 41 'P_{\} \text{Pers}' 'P_{\text{Pers}}' | Out-Null

# id 44: broken P_{\} \text{ers}
Try-Edit 44 'P_{\} \text{ers}' 'P_{\text{Pers}}' | Out-Null

# id 49: space-shattered Pers
Try-Edit 49 'P e r s ( H_{*} ( S_{6}' 'P_{\text{Pers}}(H_{*}(S_{6}' | Out-Null

# id 118: mangled hat subscripts - read full content first
$s118 = (Get-Slice -ChunksPath $cp -Id 118).content
Write-Host "id 118 len=$($s118.Length)"
Write-Host $s118

# Attempt fix for common pattern \hat{\} h} -> \hat{h}
if ($s118 -match '\\hat\{\\}') {
    Try-Edit 118 '\hat{\} h}' '\hat{h}' | Out-Null
    Try-Edit 118 'g_{\} h]' 'g_h]' | Out-Null
    Try-Edit 118 '[ g_{\} h ]_{\hat{\} A}' '[g_h]_{\hat{A}}' | Out-Null
}

Write-Host "`nRemaining:"
Group-Deliverables (Read-Chunks $cp) | ForEach-Object { "  id $($_.id): $($_.issues -join '+')" }
Invoke-Finalize -ChunksPath $cp | Select-Object paper, pending
Get-BatchSummary -Root 'ingestion/compendia/ph' | Where-Object paper -eq VSMJ2011 | Format-List
