#requires -Version 7.0
Set-Location "$PSScriptRoot/.."
. .\src\serving.ps1
. .\src\restructure.ps1
. .\src\finalize.ps1

function Apply-IfClean($cp, $id, $find, $replace) {
    $r = Add-RepairEdit -ChunksPath $cp -Id $id -Find $find -Replace $replace
    Write-Host "id $id : status=$($r.status) type=$($r.corruption_type)"
    if ($r.status -eq 'clean') { Invoke-RepairApply -ChunksPath $cp | Out-Null; return $true }
    return $false
}

# --- 2412.02591v2 ---
$cp2412 = 'ingestion/compendia/ph/2412.02591v2/.scratch/2412.02591v2.chunks.jsonl'
Apply-IfClean $cp2412 77 'B \cup C ] ) =' 'B \cup C ] =' | Out-Null
Apply-IfClean $cp2412 100 '\Big | \, I_{m + n} \, \Big ] , & \Lambda = I_{m + n} . \end{array} \right ]' 'I_{m + n} & \Lambda \end{array} \right ]' | Out-Null
$r129 = Add-RepairProposal -ChunksPath $cp2412 -Id 129 -Content '\text{Theorem 5.4. Matrix } U = 2 \cdot \text{I} - \Lambda \text{ satisfies } D = R \cdot U, \text{ or equivalently, } V = U^{-1}.'
Write-Host "id 129 proposal: accepted=$($r129.accepted) reason=$($r129.reason)"
if ($r129.accepted) { Invoke-RepairApply -ChunksPath $cp2412 | Out-Null }

# --- VSMJ2011 ---
$cpV = 'ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.chunks.jsonl'
foreach ($d in (Group-Deliverables (Read-Chunks $cpV))) {
    $id = [int]$d.id
    $s = Get-Slice -ChunksPath $cpV -Id $id
    Write-Host "`nVSMJ id $id issues=$($d.issues -join '+')"
    Write-Host $s.content.Substring(0, [Math]::Min(300, $s.content.Length))
}

Write-Host "`n--- batch ---"
Get-BatchSummary -Root 'ingestion/compendia/ph' | Format-Table paper, actionable -AutoSize
