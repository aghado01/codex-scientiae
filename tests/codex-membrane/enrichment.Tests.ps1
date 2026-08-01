#requires -Version 7.0

BeforeAll {
    . "$PSScriptRoot/../../src/enrichment.ps1"
}

Describe 'enrichment surfacer — Tier 1 chunk substrate' {
    It 'is idempotent on already-wrapped math (no candidate inside $…$)' {
        $cands = Get-EnrichmentCandidatesFromText 'We require $O(s \log n)$ measurements and $m < n$.'
        $cands.Count | Should -Be 0
    }

    It 'lossy bucket never gets auto or review apply_tier' {
        $cands = Get-EnrichmentCandidatesFromText 'The term F i+1 appears with e i nearby.'
        $lossy = @($cands | Where-Object { $_.bucket -eq 'lossy' })
        $lossy.Count | Should -BeGreaterThan 0
        $lossy.apply_tier | Should -Not -Contain 'auto'
        $lossy.apply_tier | Should -Not -Contain 'review'
        $lossy.apply_tier | Should -Contain 'escalate'
    }

    It 'classifies bulletproof O(…) as auto tier' {
        $cands = Get-EnrichmentCandidatesFromText 'Recovery needs O ( s log n ) generic measurements.'
        ($cands | Where-Object { $_.apply_tier -eq 'auto' }).Count | Should -BeGreaterThan 0
    }

    It 'classifies complete relation n = 25 as auto tier' {
        $cands = Get-EnrichmentCandidatesFromText 'Let n = 25 and d = 2 for the experiment.'
        ($cands | Where-Object { $_.text -match 'n = 25' -and $_.apply_tier -eq 'auto' }).Count | Should -BeGreaterThan 0
    }

    It 'does not surface a bare citation year in prose chunk routing' {
        $chunk = [pscustomobject]@{
            type = 'prose'; content = 'See Smith et al. 2020 for background.'
            fidelity = 'faithful'; id = 1; page = 1
        }
        (Get-EnrichablesFromChunks @($chunk)).Count | Should -Be 0
    }

    It 'skips reference chunks by construction' {
        $chunk = [pscustomobject]@{
            type = 'prose'; content = 'Recovery needs O ( s log n ) measurements.'
            fidelity = 'faithful'; is_reference = $true; id = 1; page = 99
        }
        (Get-EnrichablesFromChunks @($chunk)).Count | Should -Be 0
    }

    It 'skips needs_review unwrapped_math chunks (repair path)' {
        $chunk = [pscustomobject]@{
            type = 'prose'; content = 'Rate α outside any span plus O ( n ) bound.'
            fidelity = 'needs_review'; math_dirt = 3; id = 2; page = 2
        }
        (Get-EnrichablesFromChunks @($chunk)).Count | Should -Be 0
    }
}
