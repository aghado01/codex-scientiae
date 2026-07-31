#requires -Version 7.0
param(
    [Parameter(Mandatory)][string]$ChunksPath,
    [string]$NodesPath
)
$Repo = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae"
Set-Location $Repo
. "$Repo/src/serving.ps1"
. "$Repo/src/restructure.ps1"
if (-not $NodesPath) { $NodesPath = $ChunksPath -replace '\.chunks\.jsonl$', '.nodes.jsonl' }

function Wrap-Spans([string]$Content, $Spans) {
    $r = $Content
    foreach ($sp in ($Spans | Sort-Object { [int]$_.start } -Descending)) {
        $s = [int]$sp.start; $e = [int]$sp.end
        if ($s -ge 0 -and $e -le $r.Length -and $s -lt $e) {
            $t = $r.Substring($s, $e - $s)
            $rep = if ($t -eq '?' -and $r -match 'complex') { '$\Delta$' }
                   elseif ($t -match '^[\u0394\u03b4\u2206]$' -or $t -eq 'Δ') { '$\Delta$' }
                   else { "`$$t`$" }
            $r = $r.Substring(0, $s) + $rep + $r.Substring($e)
        }
    }
    return $r
}

function Fix-Content([string]$Content, $Recipes) {
    foreach ($cr in $Recipes) {
        switch ($cr.type) {
            'unwrapped_math' { $Content = Wrap-Spans $Content @($cr.spans) }
            'intertext' {
                $i = $Content.IndexOf('\intertext')
                if ($i -gt 0) {
                    $Content = $Content.Substring(0, $i).TrimEnd()
                    $b = Get-LatexBalance $Content
                    if (-not (Get-LatexBalance $Content).full) {
                        if ($b.paren -gt 0) { $Content += ')' * $b.paren }
                        if ($b.brace -gt 0) { $Content += '}' * $b.brace }
                        if ($b.brack -gt 0) { $Content += ']' * $b.brack }
                    }
                }
            }
            'gibberish' {
                $m = [regex]::Match($Content, '(?:\b\w\s){5,}')
                if ($m.Success -and $m.Index -gt 0) {
                    $h = $Content.Substring(0, $m.Index).TrimEnd()
                    if ($h.Length -ge ($Content.Length * 0.25)) { $Content = $h }
                }
            }
            'unbalanced_delimiters' {
                $b = Get-LatexBalance $Content
                if ($b.paren -gt 0) { $Content += ')' * $b.paren }
                if ($b.brace -gt 0) { $Content += '}' * $b.brace }
                if ($b.brack -gt 0) { $Content += ']' * $b.brack }
                if ($b.lr -gt 0) { $Content += '\right.' * $b.lr }
            }
            'alignment_outside_env' {
                if ($Content -match '&' -and $Content -notmatch '\\begin\{') {
                    $Content = "\begin{aligned}`n$Content`n\end{aligned}"
                }
            }
            'unclosed_environment' {
                if ($Content -match '\\begin\{(\w+)\}' -and $Content -notmatch '\\end\{\1\}') {
                    $env = $Matches[1]
                    $Content = $Content.TrimEnd() + "`n\end{$env}"
                }
            }
            'ligature_residue' {
                $Content = $Content -replace 'ﬁ', 'fi' -replace 'ﬂ', 'fl' -replace 'ﬃ', 'ffi'
            }
        }
    }
    return $Content
}

$applied = 0; $held = 0; $skip = 0; $merge = 0
foreach ($d in (Group-Deliverables (Read-Chunks $ChunksPath))) {
    $wo = if ($d.work_order) { $d.work_order } else { $d }
    $id = [int]$wo.id
    $span = @($wo.span)
    $recipes = @($wo.recipes)

    foreach ($sr in ($recipes | Where-Object { $_.structural })) {
        if ($sr.type -eq 'fragmented_formula' -and $span.Count -ge 2) {
            $ids = @($span | ForEach-Object { [int]$_ })
            $mr = Merge-Chunks -ChunksPath $ChunksPath -Ids $ids -NodesPath $NodesPath
            if ($mr.ok) {
                $merge++
                $id = [int]$mr.new_id
                $span = @($id)
                Write-Host "MERGED $($ids -join ',') -> $id"
            } else {
                Write-Host "MERGE FAIL $($ids -join ','): $($mr.reason)"
            }
        }
        if ($sr.type -eq 'prose_in_formula') {
            $rt = Set-ChunkType -ChunksPath $ChunksPath -Id $id -NewType prose -NodesPath $NodesPath
            if ($rt.ok) { Write-Host "RETYPED $id -> prose" }
        }
    }

    $toId = if ($span.Count -ge 2) { [int]$span[-1] } else { -1 }
    $slice = if ($toId -ge 0) { Get-Slice -ChunksPath $ChunksPath -Id $id -ToId $toId }
             else { Get-Slice -ChunksPath $ChunksPath -Id $id }
    $t = $slice | Where-Object { [int]$_.id -eq $id } | Select-Object -First 1
    if (-not $t) { $skip++; continue }

    $contentRecipes = @($t.work_order.recipes | Where-Object { -not $_.structural })
    $newContent = Fix-Content ([string]$t.content) $contentRecipes

    if ($newContent -eq [string]$t.content) { $skip++; continue }

    $types = ($contentRecipes.type | Select-Object -Unique) -join ','
    $r = Add-RepairEdit -ChunksPath $ChunksPath -Id $id -Find ([string]$t.content) -Replace $newContent
    if ($r.accepted) {
        if ($r.status -eq 'clean') { $applied++ } else { $held++ }
        Write-Host "id=$id $($r.status) $types"
    } else {
        $skip++
        Write-Host "FAIL id=$id $($r.reason)"
    }
}

Invoke-RepairApply -ChunksPath $ChunksPath -NodesPath $NodesPath
$summary = Get-IrSummary $ChunksPath
Write-Host "`n=== RESULT ==="
Write-Host "Applied: $applied, Held: $held, Skipped: $skip, Merges: $merge"
Write-Host "Remaining flagged: $($summary.flagged), unrecoverable: $($summary.unrecoverable)"
Write-Host "Hotspots: $($summary.hotspots)"
