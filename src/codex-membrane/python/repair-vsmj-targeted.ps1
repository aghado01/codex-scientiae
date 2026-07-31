#requires -Version 7.0
$Repo = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae"
Set-Location $Repo
. "$Repo/src/serving.ps1"
. "$Repo/src/restructure.ps1"
. "$Repo/src/finalize.ps1"

$cp = "ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.chunks.jsonl"
$np = "ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.nodes.jsonl"

# Clear stale staged proposals first
$propDir = "ingestion/compendia/ph/VSMJ2011/.scratch/VSMJ2011.proposals"
if (Test-Path $propDir) { Remove-Item "$propDir/*.json" -Force }

$fixes = @{
    11 = @{
        find = '\text{persistent} \left \{\begin{array}{l}{{\ a b s{l u t e}}} \\{{r e l a t i v e}} \end{array} \right \} \left \{\begin{array}{l}{{h o m o l o g y}} \\{{c o h o m o l o g y}} \end{array} \right \}'
        replace = '\text{persistent} \left \{\begin{array}{l}{\text{absolute}} \\{\text{relative}} \end{array} \right \} \left \{\begin{array}{l}{\text{homology}} \\{\text{cohomology}} \end{array} \right \}'
    }
    41 = @{
        find = 'P_{\} \text{Pers}'
        replace = 'P_{\text{Pers}}'
    }
    44 = @{
        find = 'P_{\} \text{ers}'
        replace = 'P_{\text{Pers}}'
    }
    46 = @{
        find = @'
\begin{aligned}
H_{*} ( \emptyset ) & \colon \quad H_{*} ( X_{1} ) \quad \to \dots \ \to H_{*} ( X_{n - 1} ) \quad \to H_{*} ( X_{n} ) \\ H^{*} ( \emptyset ) & \colon \quad H^{*} ( X_{1} ) \quad \to \dots \ \to H^{*} ( X_{n - 1} ) \quad \to H^{*} ( X_{n} ) \\ H_{*} ( X_{\infty} , \emptyset ) & \colon \quad H_{*} ( X_{n} ) \to H_{*} ( X_{n} , X_{1} ) \to \dots \ \to H_{*} ( X_{n} , X_{n - 1} ) \\ H^{*} ( X_{\infty} , \emptyset ) & \colon \quad H^{*} ( X_{n} ) \leftarrow H^{*} ( X_{n} , X_{1} ) \leftarrow \dots \ \to H^{*} ( X_{n} , X_{n - 1} ) \\
'@
        replace = @'
\begin{aligned}
H_{*} ( \emptyset ) & \colon \quad H_{*} ( X_{1} ) \quad \to \dots \ \to H_{*} ( X_{n - 1} ) \quad \to H_{*} ( X_{n} ) \\ H^{*} ( \emptyset ) & \colon \quad H^{*} ( X_{1} ) \quad \to \dots \ \to H^{*} ( X_{n - 1} ) \quad \to H^{*} ( X_{n} ) \\ H_{*} ( X_{\infty} , \emptyset ) & \colon \quad H_{*} ( X_{n} ) \to H_{*} ( X_{n} , X_{1} ) \to \dots \ \to H_{*} ( X_{n} , X_{n - 1} ) \\ H^{*} ( X_{\infty} , \emptyset ) & \colon \quad H^{*} ( X_{n} ) \leftarrow H^{*} ( X_{n} , X_{1} ) \leftarrow \dots \ \leftarrow H^{*} ( X_{n} , X_{n - 1} )
\end{aligned}
'@
    }
    49 = @{
        find = 'P e r s ( H_{*} ( S_{6} , S ) )'
        replace = '\text{Pers} ( H_{*} ( S_{6} , S ) )'
    }
    54 = @{
        find = @'
\begin{array}{r l r}{Pers ( H_{k} ( \mathcal{X} ) )} &{=} &{Pers ( H^{k} ( \mathcal{X} ) ) ,} \\{Pers ( H_{k} ( X_{\infty} , \mathcal{X} ) )} &{=} &{Pers ( H^{k} ( X_{\infty} , \mathcal{X} ) ) .} \\{\log a n d \, c o h o m o l a g u h a v e \, i d e n t i c a l \, h a r c o d e s} \end{array}
'@
        replace = @'
\begin{array}{r l r}{Pers ( H_{k} ( \mathcal{X} ) )} &{=} &{Pers ( H^{k} ( \mathcal{X} ) ) ,} \\{Pers ( H_{k} ( X_{\infty} , \mathcal{X} ) )} &{=} &{Pers ( H^{k} ( X_{\infty} , \mathcal{X} ) ) .} \end{array}
'@
    }
    61 = @{
        find = 'P_{\} \text{Pers} = P_{\} \text{Pers}_{0} \cup P_{\} \text{Pers}_{\infty} , \\'
        replace = 'P_{\text{Pers}} = P_{\text{Pers}}_{0} \cup P_{\text{Pers}}_{\infty} , \\'
    }
    102 = @{
        find = ' \\ \intertext{o n d a r y a n d c o b o u n d y a r p s i n d e u c h i n d e f r o w a n t u r a l w a y T h u s}'
        replace = ''
    }
    118 = @{
        find = '\langle \hat{\rho}_{\hat{\} h} \rangle_{\hat{\} A} & = M [ g_{\} h ]_{\hat{\} A}'
        replace = '\langle \hat{\rho}_{\hat{h}} \rangle_{\hat{A}} & = M [ g, h ]_{\hat{A}}'
    }
}

$applied = 0; $held = 0; $fail = 0
foreach ($id in ($fixes.Keys | Sort-Object)) {
    $chunk = (Get-Slice $cp -Id $id) | Where-Object { [int]$_.id -eq $id } | Select-Object -First 1
    if (-not $chunk) { Write-Host "MISSING $id"; continue }
    $f = $fixes[$id]
    $r = Add-RepairEdit -ChunksPath $cp -Id $id -Find $f.find -Replace $f.replace
    if ($r.accepted) {
        if ($r.status -eq 'clean') { $applied++ } else { $held++ }
        Write-Host "id=$id $($r.status) ct=$($r.corruption_type)"
        if ($r.status -ne 'clean') {
            # stack fix for id=118: truncate intertext tail
            if ($id -eq 118) {
                $content = [string]$r.content
                $idx = $content.IndexOf(' \, \cdot \, \cdot')
                if ($idx -gt 0) {
                    $trimmed = $content.Substring(0, $idx) + "`n\end{aligned}"
                    $r2 = Add-RepairEdit -ChunksPath $cp -Id $id -Find $content -Replace $trimmed
                    Write-Host "  id=118 stack: $($r2.status)"
                    if ($r2.status -eq 'clean') { $applied++; $held-- }
                }
            }
        }
    } else {
        $fail++
        Write-Host "FAIL id=${id}: $($r.reason)"
    }
}

Invoke-RepairApply -ChunksPath $cp -NodesPath $np
$summary = Get-IrSummary $cp
Write-Host "`nApplied=$applied Held=$held Fail=$fail Remaining=$($summary.flagged)"

# Show any still flagged
Read-Chunks $cp | Where-Object { $_.fidelity -in 'needs_review','needs_repair','suspect' } | ForEach-Object {
    Write-Host "REMAIN id=$($_.id) ct=$($_.corruption_type): $($_.content.Substring(0,[Math]::Min(120,$_.content.Length)))"
}
