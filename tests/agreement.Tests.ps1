#requires -Version 7.0
# Part A — agreement-score dispatch ranking. Intrinsic validation: the mask IoU (Jaccard) edge cases,
# the derivation-pair scoring (disagree ranks above agree, graded math, heading/closure coincidence),
# the store-like-math_dirt contract, and the dispatch RANKING (work-SET unchanged, ascending order,
# determinism, tie-stability). A read-only corpus differential proves totality + non-gating when a
# document is preprocessed; the synthetic tests always run. The score RANKS, it never gates.

BeforeAll {
    . "$PSScriptRoot/../src/serving.ps1"   # fidelity (agreement) + restructure-free; pulls latex + masks + crawl

    $L = 10
    function New-FullMask([int]$n)  { New-Mask -Spans @([pscustomobject]@{ Start = 0; End = $n }) -Length $n }
    function New-EmptyMask([int]$n) { New-Mask -Spans @() -Length $n }

    # write a synthetic per-paper chunk stream into a throwaway root and return the root (UTF-8-no-BOM,
    # the house backbone). Each It uses its own root so the lease side-effect never bleeds across tests.
    $script:Roots = [System.Collections.Generic.List[string]]::new()
    function New-AgreementFixture([object[]]$Chunks) {
        $root    = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-agree-" + [guid]::NewGuid().ToString('N'))
        $scratch = Join-Path $root 'p1/.scratch'
        New-Item -ItemType Directory -Force -Path $scratch | Out-Null
        $cp = Join-Path $scratch 'p1.chunks.jsonl'
        $sb = [System.Text.StringBuilder]::new()
        foreach ($c in $Chunks) { [void]$sb.AppendLine(($c | ConvertTo-Json -Compress -Depth 8)) }
        [System.IO.File]::WriteAllText($cp, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
        $script:Roots.Add($root)
        return $root
    }

    # the synthetic dispatch work-list reused by the ranking tests: file order 0..3 by id, agreements
    # deliberately NOT in file order, with a tie at 0.5 so the stable sort's tie-break is observable.
    $script:WorkChunks = @(
        [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = 'unit zero';  section = 'S'; fidelity = 'needs_review'; agreement = 0.9 }
        [pscustomobject]@{ id = 1; type = 'prose'; page = 1; content = 'unit one';   section = 'S'; fidelity = 'needs_review'; agreement = 0.2 }
        [pscustomobject]@{ id = 2; type = 'prose'; page = 1; content = 'unit two';   section = 'S'; fidelity = 'suspect';      agreement = 0.5 }
        [pscustomobject]@{ id = 3; type = 'prose'; page = 1; content = 'unit three'; section = 'S'; fidelity = 'needs_repair'; agreement = 0.5 }
        [pscustomobject]@{ id = 4; type = 'prose'; page = 1; content = 'faithful a'; section = 'S'; fidelity = 'faithful' }
        [pscustomobject]@{ id = 5; type = 'prose'; page = 1; content = 'faithful b'; section = 'S'; fidelity = 'faithful' }
    )

    # read-only corpus (same anchors corpus.Tests.ps1 uses) — never dispatched against (no lease writes)
    $script:CorpusFiles = @(
        "$PSScriptRoot/../ingestion/compendia/ph/WRD2025/.scratch/WRD2025.chunks.jsonl"
        "$PSScriptRoot/../ingestion/compendia/ph/DBK2023/.scratch/DBK2023.chunks.jsonl"
        "$PSScriptRoot/../ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.chunks.jsonl"
    ) | Where-Object { Test-Path -LiteralPath $_ }
    $script:HasCorpus = $script:CorpusFiles.Count -gt 0
}

AfterAll {
    foreach ($r in $script:Roots) { if (Test-Path -LiteralPath $r) { Remove-Item -LiteralPath $r -Recurse -Force -ErrorAction SilentlyContinue } }
}

Describe 'agreement — mask IoU / Jaccard (intrinsic edge cases)' {
    It 'empty union is defined as 1 (both derivations agree there is nothing)' {
        Get-MaskIoU (New-EmptyMask $L) (New-EmptyMask $L) | Should -Be 1.0
    }
    It 'identical full masks agree completely (IoU 1)' {
        Get-MaskIoU (New-FullMask $L) (New-FullMask $L) | Should -Be 1.0
    }
    It 'disjoint full-vs-empty maximally disagree (IoU 0)' {
        Get-MaskIoU (New-FullMask $L) (New-EmptyMask $L) | Should -Be 0.0
    }
    It 'half overlap is graded (|∩|/|∪| = 5/10)' {
        $a = New-Mask -Spans @([pscustomobject]@{ Start = 0; End = 5 })  -Length $L   # [0,5)
        $b = New-FullMask $L                                                          # [0,10)
        Get-MaskIoU $a $b | Should -Be 0.5
    }
}

Describe 'agreement — derivation pairs (synthetic)' {
    It 'a clean formula has no dispute (score 1)' {
        Get-AgreementScore ([pscustomobject]@{ type = 'formula'; content = '$$ x = y + z $$' }) | Should -Be 1.0
    }
    It 'prose mislabelled as a formula maximally disputes the math pair (score 0)' {
        Get-AgreementScore ([pscustomobject]@{ type = 'formula'; content = 'The quick brown fox jumps over the lazy dog' }) | Should -Be 0.0
    }
    It 'a formula half-leaked into prose is graded strictly between 0 and 1' {
        $s = Get-AgreementScore ([pscustomobject]@{ type = 'formula'; content = '$$x=1$$ which then continues as ordinary descriptive sentence prose' })
        $s | Should -BeGreaterThan 0.0
        $s | Should -BeLessThan 1.0
    }
    It 'a unit whose derivations DISAGREE ranks above one where they agree' {
        $disputed = Get-AgreementScore ([pscustomobject]@{ type = 'formula'; content = 'natural language masquerading as an equation here' })
        $agreed   = Get-AgreementScore ([pscustomobject]@{ type = 'formula'; content = '$$ \alpha + \beta = \gamma $$' })
        $disputed | Should -BeLessThan $agreed
    }
    It 'an un-levelled heading (level_uncertain) ranks above a placed heading' {
        $uncertain = Get-AgreementScore ([pscustomobject]@{ type = 'heading'; content = 'Some Section Title'; section_level = 2; level_uncertain = $true })
        $placed    = Get-AgreementScore ([pscustomobject]@{ type = 'heading'; content = 'Some Section Title'; section_level = 2 })
        $uncertain | Should -BeLessThan $placed
        $uncertain | Should -Be 0.0
        $placed    | Should -Be 1.0
    }
    It 'the score is the MIN over applicable pairs (most-disputed dominates)' {
        # a formula that is math-clean but whose structure spans a line boundary the per-line view misses:
        # math pair ~1, closure pair <1 -> min picks up the closure dispute.
        $s = Get-AgreementScore ([pscustomobject]@{ type = 'formula'; content = "`$`$ a = b +`nc = d `$`$" })
        $s | Should -BeLessThan 1.0
    }
    It 'is deterministic — same input, same score' {
        $c = [pscustomobject]@{ type = 'formula'; content = '$$x=1$$ trailing descriptive prose words here now' }
        (Get-AgreementScore $c) | Should -Be (Get-AgreementScore $c)
    }
    It 'stays in [0,1] and never throws on empty / non-applicable input' {
        Get-AgreementScore ([pscustomobject]@{ type = 'prose'; content = '' })            | Should -Be 1.0
        Get-AgreementScore ([pscustomobject]@{ type = 'prose'; content = 'plain words' }) | Should -Be 1.0
    }
    It 'prose with legit inline $...$ does not dispute the math pair (IoU 1 after inline subtract)' {
        Get-AgreementScore ([pscustomobject]@{ type = 'prose'; content = 'The rate is $\alpha$ per unit.' }) | Should -Be 1.0
    }
    It 'prose with unwrapped math outside $...$ still disputes the math pair' {
        $s = Get-AgreementScore ([pscustomobject]@{ type = 'prose'; content = 'The rate is $\alpha$ and \alpha outside.' })
        $s | Should -BeLessThan 1.0
    }
}

Describe 'agreement — stored like math_dirt (ranks, never gates)' {
    It 'stores the score only when there is dispute (<1.0), as a chunk field' {
        $c = [pscustomobject]@{ type = 'formula'; content = 'prose pretending to be a formula sentence' }
        Set-ChunkAgreement $c | Out-Null
        $c.PSObject.Properties['agreement'] | Should -Not -BeNullOrEmpty
        [double]$c.agreement | Should -BeLessThan 1.0
    }
    It 'CLEARS a stale score when a re-grade returns to full agreement (no lingering sidecar value)' {
        $c = [pscustomobject]@{ type = 'formula'; content = '$$ x = y $$' }
        $c | Add-Member -NotePropertyName agreement -NotePropertyValue 0.3 -Force   # stale low score
        Set-ChunkAgreement $c | Out-Null
        $c.PSObject.Properties['agreement'] | Should -BeNullOrEmpty
    }
    It 'computing agreement does not change the corruption gate (orthogonal to accept/reject)' {
        $c = [pscustomobject]@{ type = 'formula'; content = 'The quick brown fox jumps over the lazy dog' }
        $before = Get-CorruptionType $c
        Set-ChunkAgreement $c | Out-Null
        (Get-CorruptionType $c) | Should -Be $before     # still 'prose_in_formula'
    }
}

Describe 'dispatch — ranking (synthetic fixture)' {
    It 'the dispatched work-SET is unchanged: dispatched ids == actionable ids (order aside)' {
        $root = New-AgreementFixture $script:WorkChunks
        $res  = Invoke-Dispatch -Root $root -BudgetBytes 10000000
        $dispatched = @($res.batch | ForEach-Object { [int]$_.id } | Sort-Object)
        $actionable = @($script:WorkChunks | Where-Object { $_.fidelity -in 'needs_review','needs_repair','suspect' } | ForEach-Object { [int]$_.id } | Sort-Object)
        ($dispatched -join ',') | Should -Be ($actionable -join ',')
    }
    It 'orders candidates by ASCENDING agreement, ties holding document order (stable)' {
        $root = New-AgreementFixture $script:WorkChunks
        $res  = Invoke-Dispatch -Root $root -BudgetBytes 10000000
        # agreements: id0=0.9 id1=0.2 id2=0.5 id3=0.5 -> ascending, 2 before 3 by file order
        (@($res.batch | ForEach-Object { [int]$_.id }) -join ',') | Should -Be '1,2,3,0'
    }
    It 'surfaces the agreement on each dispatched pointer' {
        $root = New-AgreementFixture $script:WorkChunks
        $res  = Invoke-Dispatch -Root $root -BudgetBytes 10000000
        $first = $res.batch[0]
        [double]$first.agreement | Should -Be 0.2
    }
    It 'is deterministic — identical roots dispatch in identical order' {
        $a = Invoke-Dispatch -Root (New-AgreementFixture $script:WorkChunks) -BudgetBytes 10000000
        $b = Invoke-Dispatch -Root (New-AgreementFixture $script:WorkChunks) -BudgetBytes 10000000
        (@($a.batch | ForEach-Object { [int]$_.id }) -join ',') | Should -Be (@($b.batch | ForEach-Object { [int]$_.id }) -join ',')
    }
    It 'with no stored scores, reproduces the OLD document order exactly (absent ⇒ 1.0, stable)' {
        $plain = @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = 'a'; fidelity = 'needs_review' }
            [pscustomobject]@{ id = 1; type = 'prose'; page = 1; content = 'b'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 2; type = 'prose'; page = 1; content = 'c'; fidelity = 'needs_repair' }
        )
        $res = Invoke-Dispatch -Root (New-AgreementFixture $plain) -BudgetBytes 10000000
        (@($res.batch | ForEach-Object { [int]$_.id }) -join ',') | Should -Be '0,1,2'
    }
}

Describe 'agreement — corpus differential (read-only; skips without a preprocessed document)' {
    It 'every score is total and in [0,1]; computing it is deterministic and non-gating' {
        if (-not $script:HasCorpus) { Set-ItResult -Skipped -Because 'no document preprocessed to the chunk stage'; return }
        $all = [System.Collections.Generic.List[object]]::new()
        foreach ($f in $script:CorpusFiles) { foreach ($ln in [System.IO.File]::ReadLines($f)) { if ($ln.Trim()) { $all.Add(($ln | ConvertFrom-Json)) } } }
        $outOfRange = 0; $nonDeterministic = 0; $gateMoved = 0
        foreach ($c in $all) {
            $s = Get-AgreementScore $c
            if ($s -lt 0.0 -or $s -gt 1.0) { $outOfRange++ }
            if ($s -ne (Get-AgreementScore $c)) { $nonDeterministic++ }
            $before = Get-CorruptionType $c
            Set-ChunkAgreement $c | Out-Null            # the exact preprocess-time mutation
            if ((Get-CorruptionType $c) -ne $before) { $gateMoved++ }   # ranking must not move the gate
        }
        $outOfRange       | Should -Be 0
        $nonDeterministic | Should -Be 0
        $gateMoved        | Should -Be 0
    }
}
