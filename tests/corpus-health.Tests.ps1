#requires -Version 7.0
# Published-corpus health regressions. Unlike corpus.Tests.ps1 (which A/B-tests the chunk-stream
# detectors), this asserts over the promoted .md BODIES under compendia/ codices/ corpora/ via the
# read-only auditor in src/corpus-audit.ps1. The HARD tier mirrors publish.ps1's defect sentinels; the
# quality tier pins the 2026-06-23 normalization (ligatures, mangled URL separators) at zero so it
# cannot silently come back. ADVISORY classes (broken image links, single-column tables) are tracked
# debt in HOUSEKEEPING.md, NOT asserted here.

BeforeAll {
    . "$PSScriptRoot/../src/corpus-audit.ps1"
    $script:health = Get-CorpusHealth -RepoRoot (Split-Path -Parent $PSScriptRoot)
    $script:t = $script:health.totals
}

Describe 'corpus HARD invariants — no holed or mis-encoded document may ship' {
    It 'scans the published corpus (sanity: found files)' {
        $script:health.files_scanned | Should -BeGreaterThan 0
    }
    It 'no FILL_ME_IN placeholder survives in the corpus' {
        $script:t.fill_me_in | Should -Be 0
    }
    It 'no U+FFFD replacement char survives in the corpus' {
        $script:t.u_fffd | Should -Be 0
    }
    It 'no .md file carries a UTF-8 BOM (STANDARDS §8 is UTF-8 no-BOM)' {
        $script:t.bom | Should -Be 0
    }
}

Describe 'corpus QUALITY invariants — normalized 2026-06-23, pinned so they cannot regress' {
    It 'no literal typographic ligatures (U+FB00-06)' {
        $script:t.ligatures | Should -Be 0
    }
    It 'no mangled URL scheme separators (https:/// , https: // , ...)' {
        $script:t.url_mangled | Should -Be 0
    }
}
