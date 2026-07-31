#requires -Version 7.0
param(
    [Parameter(Mandatory)][string]$ChunksPath,
    [switch]$DryRun,
    [switch]$ListOnly
)
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
if (-not (Test-Path "$Root/src/serving.ps1")) { $Root = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae" }
. "$Root/src/serving.ps1"
. "$Root/src/restructure.ps1"

$NodesPath = $ChunksPath -replace '\.chunks\.jsonl$', '.nodes.jsonl'
$stats = [ordered]@{ applied = 0; held = 0; structural = 0; edits = 0; skipped = 0 }

function Wrap-UnwrappedSpans([string]$Content, $Spans) {
    if (-not $Spans -or $Spans.Count -eq 0) { return $Content }
    $sorted = @($Spans | Sort-Object { [int]$_.start } -Descending)
    $result = $Content
    foreach ($sp in $sorted) {
        $s = [int]$sp.start; $e = [int]$sp.end
        if ($s -lt 0 -or $e -gt $result.Length -or $s -ge $e) { continue }
        $token = $result.Substring($s, $e - $s)
        # Context-aware: lone ? in delta-complex prose → \Delta
        $replacement = if ($token -eq '?' -and $result -match 'complex') { '$\Delta$' }
                       elseif ($token -match '^\s*\?\s*$' -and $result -match 'complex') { '$\Delta$' }
                       else { "`$$token`$" }
        $result = $result.Substring(0, $s) + $replacement + $result.Substring($e)
    }
    return $result
}

function Repair-Intertext([string]$Content) {
    $i = $Content.IndexOf('\intertext')
    if ($i -gt 0) { return $Content.Substring(0, $i).TrimEnd() }
    return $Content
}

function Repair-Gibberish([string]$Content) {
    $m = [regex]::Match($Content, '(?:\b\w\s){5,}')
    if ($m.Success -and $m.Index -gt 0) {
        $head = $Content.Substring(0, $m.Index).TrimEnd()
        if ($head.Length -ge ($Content.Length * 0.3)) { return $head }
    }
    return $Content
}

function Repair-Unbalanced([string]$Content, [string]$Diagnostic) {
    $b = Get-LatexBalance $Content
    $r = $Content
    if ($b.paren -gt 0) { $r += ')' * $b.paren }
    elseif ($b.paren -lt 0) { $r = $r.TrimEnd(')') }
    if ($b.brace -gt 0) { $r += '}' * $b.brace }
    elseif ($b.brace -lt 0) { $r = $r.TrimEnd('}') }
    if ($b.brack -gt 0) { $r += ']' * $b.brack }
    elseif ($b.brack -lt 0) { $r = $r.TrimEnd(']') }
    if ($b.lr -gt 0) { $r += '\right.' * $b.lr }
    elseif ($b.lr -lt 0) { $r = $r -replace '\\right\.?\s*$', '' }
    return $r
}

function Repair-Alignment([string]$Content) {
    if ($Content -match '\\begin\{aligned\}') { return $Content }
    if ($Content -match '&' -and $Content -notmatch '\\begin\{') {
        return "\begin{aligned}`n$Content`n\end{aligned}"
    }
    return $Content
}

function Apply-Deliverable($ChunksPath, $NodesPath, $Del, [ref]$Stats) {
    $wo = $Del.work_order
    if (-not $wo) { $wo = $Del }
    $anchorId = [int]$wo.id
    $spanIds = @($wo.span)
    $recipes = @($wo.recipes)
    if ($ListOnly) {
        $issueTypes = ($recipes | ForEach-Object { $_.type }) -join ','
        Write-Host "ID=$anchorId span=$($spanIds -join '-') issues=$issueTypes"
        return
    }

    # Structural: merge fragmented_formula spans
    $structural = @($recipes | Where-Object { $_.structural })
    foreach ($sr in $structural) {
        if ($sr.type -eq 'fragmented_formula' -and $spanIds.Count -ge 2) {
            $ids = @($spanIds | ForEach-Object { [int]$_ })
            $r = Merge-Chunks -ChunksPath $ChunksPath -Ids $ids -NodesPath $NodesPath
            if ($r.ok) {
                $Stats.Value.structural++
                Write-Host "  MERGED $($ids -join ',') -> id $($r.new_id)"
                $anchorId = [int]$r.new_id
                $spanIds = @($anchorId)
            } else {
                Write-Host "  MERGE FAILED $($ids -join ','): $($r.reason)"
            }
        }
        if ($sr.type -eq 'prose_in_formula') {
            $r = Set-ChunkType -ChunksPath $ChunksPath -Id $anchorId -NewType prose -NodesPath $NodesPath
            if ($r.ok) { $Stats.Value.structural++; Write-Host "  RETYPED $anchorId -> prose" }
        }
    }

    # Re-ground after structural
    $slice = if ($spanIds.Count -ge 2) {
        Get-Slice -ChunksPath $ChunksPath -Id $anchorId -ToId ($spanIds[-1])
    } else {
        Get-Slice -ChunksPath $ChunksPath -Id $anchorId
    }
    $target = $slice | Where-Object { [int]$_.id -eq $anchorId } | Select-Object -First 1
    if (-not $target) { $Stats.Value.skipped++; return }

    $content = [string]$target.content
    $wo2 = $target.work_order
    if (-not $wo2) { $wo2 = $wo }
    $contentRecipes = @($wo2.recipes | Where-Object { -not $_.structural })

    foreach ($cr in $contentRecipes) {
        switch ($cr.type) {
            'unwrapped_math' {
                $content = Wrap-UnwrappedSpans $content @($cr.spans)
            }
            'intertext' {
                $content = Repair-Intertext $content
            }
            'gibberish' {
                $content = Repair-Gibberish $content
            }
            'unbalanced_delimiters' {
                $content = Repair-Unbalanced $content $cr.diagnostic
            }
            'alignment_outside_env' {
                $content = Repair-Alignment $content
            }
            'unclosed_environment' {
                if ($content -match '\\begin\{(\w+)\}' -and $content -notmatch '\\end\{\1\}') {
                    $env = $Matches[1]
                    $content = $content.TrimEnd() + "`n\end{$env}"
                }
            }
            'ligature_residue' {
                $content = $content -replace 'ﬁ', 'fi' -replace 'ﬂ', 'fl' -replace 'ﬃ', 'ffi'
            }
            'replacement_char' {
                # skip — needs manual review
            }
            default { }
        }
    }

    if ($content -eq [string]$target.content) {
        $Stats.Value.skipped++
        return
    }

    if ($DryRun) {
        Write-Host "  WOULD EDIT id=$anchorId len=$($content.Length) was=$($target.content.Length)"
        return
    }

    $find = [string]$target.content
    $r = Add-RepairProposal -ChunksPath $ChunksPath -Id $anchorId -Content $content -Source 'batch-repair'
    if ($r.accepted) {
        $Stats.Value.edits++
        Write-Host "  STAGED id=$anchorId clean"
    } else {
        # try surgical edit if wholesale fails
        $er = Add-RepairEdit -ChunksPath $ChunksPath -Id $anchorId -Find $find -Replace $content -Source 'batch-repair'
        if ($er.accepted) {
            $Stats.Value.edits++
            Write-Host "  EDIT id=$anchorId status=$($er.status)"
        } else {
            Write-Host "  FAIL id=$anchorId: $($r.reason) / $($er.reason)"
            $Stats.Value.skipped++
        }
    }
}

# Main
$chunks = Read-Chunks $ChunksPath
$dels = Group-Deliverables $chunks
Write-Host "Paper: $(Split-Path (Split-Path $ChunksPath -Parent) -Parent | Split-Path -Leaf)"
Write-Host "Deliverables: $($dels.Count)"
foreach ($d in $dels) {
    Apply-Deliverable $ChunksPath $NodesPath $d ([ref]$stats)
}

if (-not $ListOnly -and -not $DryRun) {
    Invoke-RepairApply -ChunksPath $ChunksPath -NodesPath $NodesPath
    $summary = Get-IrSummary $ChunksPath
    Write-Host "`n=== SUMMARY ==="
    Write-Host "Edits staged/applied: $($stats.edits), structural: $($stats.structural), skipped: $($stats.skipped)"
    Write-Host "Remaining flagged: $($summary.flagged)"
    $stats
}
