#requires -Version 7.0
# The composite work-order spine (MVP) — inventory → group by deliverable → compose → resolve. Intrinsic
# validation of each piece, plus a differential proving the dispatch enrichment is ADDITIVE: the frozen
# single-type gate is untouched, the dispatched deliverable SET is unchanged, and the work-order is
# body-light. A read-only corpus pass proves the gate/inventory share-table contract over real data and
# skips cleanly when nothing is preprocessed; the synthetic tests always run.

BeforeAll {
    . "$PSScriptRoot/../src/serving.ps1"   # composer + grouping + slice/dispatch; pulls fidelity + playbook + jsonl

    $FB1 = [char]0xFB01   # ﬁ ligature (U+FB01)
    $FB2 = [char]0xFB02   # ﬂ ligature (U+FB02)

    # the seven corruption signatures the gate cascades through, in table order — the inventory's
    # corruption kinds (excludes the needs_review kinds the gate routes around).
    $script:CorruptionKinds = @('intertext','replacement_char','gibberish','ligature_residue','alignment_outside_env','prose_in_formula','unbalanced_delimiters')

    # write a synthetic per-paper chunk stream (+ .jidx) into a throwaway root via the real stage writer,
    # so get_slice's seek and apply's re-grade run against a genuine fixture. Each It uses its own root so
    # lease/proposal side-effects never bleed across tests. UTF-8-no-BOM is the house backbone.
    $script:Roots = [System.Collections.Generic.List[string]]::new()
    function New-SpineFixture([object[]]$Chunks, [string]$Paper = 'p') {
        $root    = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-spine-" + [guid]::NewGuid().ToString('N'))
        $scratch = Join-Path $root "$Paper/.scratch"
        New-Item -ItemType Directory -Force -Path $scratch | Out-Null
        $cp = Join-Path $scratch "$Paper.chunks.jsonl"
        [void](Write-JsonlStage -Records $Chunks -OutputPath $cp -Stage 'fidelity')
        $script:Roots.Add($root)
        return [pscustomobject]@{ root = $root; cp = $cp; paper = $Paper }
    }

    # read-only corpus (same anchors the other suites use) — never dispatched against (no lease writes)
    $script:CorpusFiles = @(
        "$PSScriptRoot/../ingestion/compendia/ph/WRD2025/.scratch/WRD2025.chunks.jsonl"
        "$PSScriptRoot/../ingestion/compendia/ph/DBK2023/.scratch/DBK2023.chunks.jsonl"
        "$PSScriptRoot/../ingestion/gauntlet/voroninski/1109.4499v1/.scratch/1109.4499v1.chunks.jsonl"
    ) | Where-Object { Test-Path -LiteralPath $_ }
    $script:HasCorpus = $script:CorpusFiles.Count -gt 0
}

AfterAll {
    foreach ($r in $script:Roots) { if (Test-Path -LiteralPath $r) { Remove-Item -LiteralPath $r -Recurse -Force -ErrorAction SilentlyContinue } }
}

Describe 'inventory — Get-ChunkIssues reports ALL issues; the gate stays frozen' {
    It 'a chunk with N issues yields all N (multi-issue, not first-match)' {
        $c = [pscustomobject]@{ type = 'formula'; content = ('\left( ' + $FB1 + ' x') }   # unbalanced + ligature
        $issues = @(Get-ChunkIssues $c)
        $issues.Count | Should -Be 2
        @($issues | ForEach-Object { $_.type }) | Should -Contain 'ligature_residue'
        @($issues | ForEach-Object { $_.type }) | Should -Contain 'unbalanced_delimiters'
    }
    It 'the single-type gate returns its one verdict unchanged on that same chunk (frozen)' {
        $c = [pscustomobject]@{ type = 'formula'; content = ('\left( ' + $FB1 + ' x') }
        Get-CorruptionType $c | Should -Be 'ligature_residue'   # first signature in table order
    }
    It 'a clean chunk yields an empty inventory' {
        @(Get-ChunkIssues ([pscustomobject]@{ type = 'formula'; content = '$$ x = y $$' })).Count | Should -Be 0
    }
    It 'the unbalanced issue carries the seam diagnostic naming the open delimiter' {
        $c = [pscustomobject]@{ type = 'formula'; content = 'a + ( b' }   # one unclosed bare paren
        $u = @(Get-ChunkIssues $c | Where-Object { $_.type -eq 'unbalanced_delimiters' })[0]
        $u.diagnostic | Should -Match 'paren=1'
    }
    It 'folds in the needs_review kinds the gate routes around: <label>' -ForEach @(
        @{ label = 'heading_level_unknown'; chunk = [pscustomobject]@{ type = 'heading'; content = 'A Title'; level_uncertain = $true }; expect = 'heading_level_unknown' }
        @{ label = 'unwrapped_math';        chunk = [pscustomobject]@{ type = 'prose';   content = 'plain words'; math_dirt = 3 };       expect = 'unwrapped_math' }
    ) { @(Get-ChunkIssues $chunk | ForEach-Object { $_.type }) | Should -Contain $expect }
    It 'a needs_review kind pools WITH a corruption signature in one inventory (the multi-issue win)' {
        # an un-levelled heading that ALSO carries ligature residue — single-type fidelity would surface
        # only one; the inventory surfaces both for one work-order.
        $c = [pscustomobject]@{ type = 'heading'; content = ('Sec' + $FB1 + 'on'); level_uncertain = $true }
        $kinds = @(Get-ChunkIssues $c | ForEach-Object { $_.type })
        $kinds | Should -Contain 'ligature_residue'
        $kinds | Should -Contain 'heading_level_unknown'
    }
}

Describe 'inventory — shared table, no drift from the gate' {
    It 'the gate verdict is exactly the first corruption-signature the inventory reports: <name>' -ForEach @(
        @{ name = 'clean';      chunk = [pscustomobject]@{ type = 'formula'; content = 'E = mc^2' } }
        @{ name = 'unbalanced'; chunk = [pscustomobject]@{ type = 'formula'; content = '\left( \frac{1}{2}' } }
        @{ name = 'intertext';  chunk = [pscustomobject]@{ type = 'formula'; content = 'a = b \intertext{junk} a = b' } }
        @{ name = 'prose';      chunk = [pscustomobject]@{ type = 'formula'; content = 'The quick brown fox jumps over the lazy dog' } }
    ) {
        $gate = Get-CorruptionType $chunk
        $firstSig = @(Get-ChunkIssues $chunk | Where-Object { $_.type -in $script:CorruptionKinds })
        $firstInv = if ($firstSig.Count) { $firstSig[0].type } else { $null }
        $gate | Should -Be $firstInv
    }
}

Describe 'grouping — Group-Deliverables buckets issues by the deliverable that ships' {
    It 'a default deliverable is the chunk; faithful chunks are excluded' {
        $chunks = @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = '\left( a'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'prose';   page = 1; content = 'clean';    fidelity = 'faithful' }
        )
        $d = @(Group-Deliverables $chunks)
        $d.Count | Should -Be 1
        $d[0].id | Should -Be 0
        $d[0].deliverable | Should -Be 'chunk'
    }
    It 'a span deliverable pools its members'' issues under one work-order' {
        # three fragments that balance only joined; a member also carries a ligature
        $chunks = @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = 'x =';               fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = '\left( \frac{1}{2}'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = ('+ y \right) ' + $FB2); fidelity = 'suspect' }
        )
        $d = @(Group-Deliverables $chunks)
        $d.Count | Should -Be 1                       # one span deliverable, not three chunk deliverables
        $d[0].deliverable | Should -Be 'fragmented_formula'
        @($d[0].span) | Should -Be @(0, 1, 2)
        @($d[0].issues) | Should -Contain 'fragmented_formula'   # the merge frame
        @($d[0].issues) | Should -Contain 'ligature_residue'     # a member's own issue, pooled in
    }
}

Describe 'composition — New-WorkOrder pools, orders structural-before-content, stays body-light' {
    It 'pools every issue with its recipe fragment' {
        $c = [pscustomobject]@{ id = 0; type = 'formula'; content = ('\left( ' + $FB1 + ' x') }
        $wo = New-WorkOrder -Kind 'chunk' -Id 0 -Members @($c)
        @($wo.recipes | ForEach-Object { $_.type }) | Should -Contain 'unbalanced_delimiters'
        ($wo.recipes | Where-Object { $_.type -eq 'unbalanced_delimiters' }).fix | Should -Not -BeNullOrEmpty
    }
    It 'orders structural issues before content issues (the restructure-first rule)' {
        # a formula that reads as prose (prose_in_formula, structural) AND has a ligature (content).
        # inventory order is ligature(#4) then prose_in_formula(#6); the composer must FLIP it.
        $c = [pscustomobject]@{ id = 0; type = 'formula'; content = ('the lazy brown fox ' + $FB1 + ' jumps over many fences') }
        $wo = New-WorkOrder -Kind 'chunk' -Id 0 -Members @($c)
        $order = @($wo.recipes | ForEach-Object { $_.type })
        $order.IndexOf('prose_in_formula') | Should -BeLessThan $order.IndexOf('ligature_residue')
        $wo.recipes[0].structural | Should -BeTrue
    }
    It 'a span work-order leads with the merge instruction (the deliverable-level structural frame)' {
        $members = @(
            [pscustomobject]@{ id = 0; type = 'formula'; content = 'x =' }
            [pscustomobject]@{ id = 1; type = 'formula'; content = '\left( a' }
        )
        $wo = New-WorkOrder -Kind 'fragmented_formula' -Id 0 -Span @(0, 1) -Members $members
        $wo.recipes[0].type | Should -Be 'fragmented_formula'
        $wo.recipes[0].structural | Should -BeTrue
    }
    It 'is body-light: no chunk body leaks into the work-order, and it has no content field' {
        $c = [pscustomobject]@{ id = 0; type = 'formula'; content = ('\left( BODYSENTINEL ' + $FB1) }
        $wo = New-WorkOrder -Kind 'chunk' -Id 0 -Members @($c)
        ($wo | ConvertTo-Json -Depth 12 -Compress).Contains('BODYSENTINEL') | Should -BeFalse
        $wo.PSObject.Properties['content'] | Should -BeNullOrEmpty
        $wo.recipes | ForEach-Object { $_.PSObject.Properties['content'] | Should -BeNullOrEmpty }
    }
    It 'an issue with no data-fied recipe still lists (fix empty), the prose playbook the fallback' {
        Get-RepairRecipe 'no_such_type' | Should -BeNullOrEmpty
        # every kind the inventory can emit DOES have a recipe today (the map mirrors PROCEDURE.md)
        foreach ($k in (@($script:CorruptionKinds) + @('fragmented_formula','heading_level_unknown','unwrapped_math'))) {
            Get-RepairRecipe $k | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'resolve — a multi-issue chunk converges in ONE work-order' {
    It 'two issues, one combined fix: stages clean and apply merges (no second dispatch)' {
        $f = New-SpineFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = ('\left( ' + $FB1 + ' x'); fidelity = 'suspect' }
        )
        # the deliverable carries TWO issues; the single-type gate names only the first
        @(Get-ChunkIssues (Read-JsonlRecord -Path $f.cp -At 0)).Count | Should -Be 2
        # a PARTIAL fix (only the ligature) still trips the gate — the "N re-dispatches" failure mode
        (Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = '\left( fi x' })) | Should -Be 'unbalanced_delimiters'
        # working the WHOLE order in one pass: fix both, stage, apply -> converged to faithful
        (Add-RepairProposal -ChunksPath $f.cp -Id 0 -Content '( a + b )').accepted | Should -BeTrue
        Invoke-RepairApply -ChunksPath $f.cp | Out-Null
        (@(Read-Chunks $f.cp)[0]).fidelity | Should -Be 'faithful'
    }
}

Describe 'dispatch / slice — the work-order is ADDITIVE enrichment (differential)' {
    BeforeAll {
        $script:Mix = @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = ('\left( ' + $FB1 + ' x'); section = 'S'; fidelity = 'suspect' }      # 2 issues
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'x =';                fidelity = 'suspect'; section = 'S' }           # span member
            [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = '\left( \frac{1}{2}'; fidelity = 'suspect'; section = 'S' }           # span member
            [pscustomobject]@{ id = 3; type = 'formula'; page = 1; content = '+ y \right)';        fidelity = 'suspect'; section = 'S' }           # span member
            [pscustomobject]@{ id = 4; type = 'prose';   page = 1; content = 'clean prose';        fidelity = 'faithful'; section = 'S' }
        )
    }
    It 'the dispatched deliverable SET equals Group-Deliverables (no new work-set)' {
        $f = New-SpineFixture $script:Mix
        $disp = Invoke-Dispatch -Root $f.root -BudgetBytes 100000000
        $dispIds = @($disp.batch | ForEach-Object { [int]$_.id } | Sort-Object)
        $grpIds  = @(Group-Deliverables (Read-Chunks $f.cp) | ForEach-Object { [int]$_.id } | Sort-Object)
        ($dispIds -join ',') | Should -Be ($grpIds -join ',')
    }
    It 'each dispatch pointer gains an additive issues profile and stays body-light (no content)' {
        $f = New-SpineFixture $script:Mix
        $disp = Invoke-Dispatch -Root $f.root -BudgetBytes 100000000
        $p0 = $disp.batch | Where-Object { [int]$_.id -eq 0 } | Select-Object -First 1
        @($p0.issues) | Should -Contain 'ligature_residue'
        @($p0.issues) | Should -Contain 'unbalanced_delimiters'
        $disp.batch | ForEach-Object { $_.PSObject.Properties['content'] | Should -BeNullOrEmpty }
    }
    It 'get_slice returns the composed work_order on the anchor, body-light, content still on the record' {
        $f = New-SpineFixture $script:Mix
        $slice = @(Get-Slice -ChunksPath $f.cp -Id 0)
        $anchor = $slice | Where-Object { [int]$_.id -eq 0 } | Select-Object -First 1
        $anchor.work_order | Should -Not -BeNullOrEmpty
        @($anchor.work_order.issues) | Should -Contain 'unbalanced_delimiters'
        ($anchor.work_order | ConvertTo-Json -Depth 12 -Compress).Contains('\left(') | Should -BeFalse  # body-light
        $anchor.content | Should -Match 'left'                                                            # body still on the record
    }
    It 'a span slice (id..to_id) returns a fragmented_formula work_order leading with the merge frame' {
        $f = New-SpineFixture $script:Mix
        $slice = @(Get-Slice -ChunksPath $f.cp -Id 1 -ToId 3)
        $wo = ($slice | Where-Object { [int]$_.id -eq 1 } | Select-Object -First 1).work_order
        $wo.deliverable | Should -Be 'fragmented_formula'
        $wo.recipes[0].type | Should -Be 'fragmented_formula'
    }
}

Describe 'corpus differential — gate/inventory share-table + totality (read-only; skips without corpus)' {
    It 'the gate verdict equals the first inventory corruption-signature for EVERY corpus chunk (no drift)' {
        if (-not $script:HasCorpus) { Set-ItResult -Skipped -Because 'no document preprocessed to the chunk stage'; return }
        $all = [System.Collections.Generic.List[object]]::new()
        foreach ($f in $script:CorpusFiles) { foreach ($ln in [System.IO.File]::ReadLines($f)) { if ($ln.Trim()) { $all.Add(($ln | ConvertFrom-Json)) } } }
        $drift = 0; $threw = 0
        foreach ($c in $all) {
            try {
                $gate = Get-CorruptionType $c
                $sig  = @(Get-ChunkIssues $c | Where-Object { $_.type -in $script:CorruptionKinds })
                $firstInv = if ($sig.Count) { $sig[0].type } else { $null }
                if ($gate -ne $firstInv) { $drift++ }
            } catch { $threw++ }
        }
        $drift | Should -Be 0
        $threw | Should -Be 0
    }
}
