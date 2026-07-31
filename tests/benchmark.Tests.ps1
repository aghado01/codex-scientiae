#requires -Version 7.0
<#
  tests/benchmark.Tests.ps1 — opportunistic repair-problem harvest (src/pdf-converter/harvest.ps1):
  difficulty tagging + the uniqueness gate (keep novel / keep under-cap / keep different-difficulty /
  skip redundant). The gate is NOT dedup — redundancy is allowed to a cap, and difficulty-diversity
  is kept even at high content similarity.
#>

BeforeAll {
    . "$PSScriptRoot/../src/pdf-converter/harvest.ps1"
    function Sig([string]$s) { Get-ContentSignature $s }
    function Existing([string]$id, [string]$tier, [string]$content) {
        [pscustomobject]@{ id = $id; tier = $tier; signature = (Sig $content) }
    }
}

Describe 'difficulty tagging' {
    It 'scores a short balanced span easy and a deep/unbalanced one harder' {
        $easy = Get-TrialDifficulty ([pscustomobject]@{ content = 'x_{i}'; flags = @() }) $false
        $hard = Get-TrialDifficulty ([pscustomobject]@{ content = "\|t_{v_{i+1}}(t_{v_{k}}\tau _{v_{k}v_{i}}"; flags = @('unbalanced_delimiters','needs_2d_assembly') }) $false
        $easy.tier  | Should -Be 'easy'
        $hard.score | Should -BeGreaterThan $easy.score
        $hard.imbalance | Should -BeGreaterThan 0     # unclosed ( and \|
    }
    It 'records has_oracle as a supervision axis (not difficulty)' {
        (Get-TrialDifficulty ([pscustomobject]@{ content='x'; flags=@() }) $true).has_oracle | Should -BeTrue
    }
}

Describe 'the uniqueness gate' {
    It 'keeps genuinely novel content' {
        $n = Test-TrialNovelty -Signature (Sig 'a b c d e') -Tier 'medium' -Existing @( (Existing 't1' 'medium' 'x y z w q') )
        $n.decision | Should -Be 'keep'
        $n.reason   | Should -Match 'novel'
    }
    It 'allows redundancy UNDER the cap (some redundancy is fine)' {
        $existing = @( (Existing 't1' 'medium' 'a b c d e') )
        $n = Test-TrialNovelty -Signature (Sig 'a b c d e') -Tier 'medium' -Existing $existing -RedundancyCap 2
        $n.decision | Should -Be 'keep'
        $n.reason   | Should -Match 'under redundancy cap'
    }
    It 'skips a near-duplicate once the cap at that tier is full' {
        $existing = @( (Existing 't1' 'medium' 'a b c d e'), (Existing 't2' 'medium' 'a b c d e') )
        $n = Test-TrialNovelty -Signature (Sig 'a b c d e') -Tier 'medium' -Existing $existing -RedundancyCap 2
        $n.decision | Should -Be 'skip'
        $n.reason   | Should -Match 'redundant'
    }
    It 'KEEPS similar content at a DIFFERENT difficulty tier (the valuable case)' {
        $existing = @( (Existing 't1' 'easy' 'a b c d e'), (Existing 't2' 'easy' 'a b c d e') )   # cap full at EASY
        $n = Test-TrialNovelty -Signature (Sig 'a b c d e') -Tier 'hard' -Existing $existing -RedundancyCap 2
        $n.decision | Should -Be 'keep'
        $n.reason   | Should -Match 'different difficulty'
    }
}

Describe 'Export-BenchmarkTrial (assemble + gate + append)' {
    It 'appends a well-posed trial and enforces the cap on repeats' {
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "bench-$([guid]::NewGuid())"
        New-Item -ItemType Directory -Path $tmp | Out-Null
        $lib = Join-Path $tmp 'trials.jsonl'
        try {
            $chunk = [pscustomobject]@{ id = 7; type = 'formula'; content = 'a_{i}+b_{j}'; flags = @('unbalanced_delimiters'); page = 1; bbox = @(0.0,0.0,10.0,10.0) }
            $r1 = Export-BenchmarkTrial -Chunk $chunk -PaperDir $tmp -Slug 'p' -LibraryPath $lib -RedundancyCap 1
            $r1.harvested | Should -BeTrue
            $r1.id | Should -Be 'p-7'
            # same problem again, cap 1 -> skipped
            $r2 = Export-BenchmarkTrial -Chunk $chunk -PaperDir $tmp -Slug 'p' -LibraryPath $lib -RedundancyCap 1
            $r2.harvested | Should -BeFalse
            (Get-Content $lib | Where-Object { $_ }).Count | Should -Be 1
            $t = (Get-Content $lib | Select-Object -First 1) | ConvertFrom-Json
            $t.problem_type | Should -Be 'math_repair'
            $t.ground_truth.gate | Should -Match 'render_check'
            $t.difficulty.tier | Should -Not -BeNullOrEmpty
        } finally { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}
