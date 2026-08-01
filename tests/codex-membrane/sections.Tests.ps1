#requires -Version 7.0
# Test-IsCitationLine — the heading-less citation-run gate in sections.ps1. Pins the reproduced bug where
# an in-body parenthesized enumeration ((1)…(N)) in 2105.03629v2 §2.4 ("...point out the fundamental
# differences of the computational aspect:") was mistaken for a bibliography and force-zoned to
# back-matter, dragging six body items into the references sidecar. The (N)/year guard is the fix:
# only bracketed [N] is an unambiguous reference; (N) and bare "N." must each carry a (year).

BeforeAll {
    . "$PSScriptRoot/../../src/codex-membrane/sections.ps1"
}

Describe 'Test-IsCitationLine — bibliography line vs in-body (N) enumeration' {

    It 'rejects an in-body (N) enumeration item — the reproduced bug: <label>' -ForEach @(
        @{ label = '(1)'; s = '(1) Instead of p -chains we define the p cochains C p ( K i ) , which are the collection of linear maps C p ( K i )' }
        @{ label = '(3)'; s = '(3) The resulting standard coboundary matrix is the transpose of the boundary matrix.' }
        @{ label = '(4)'; s = '(4) Persistent cohomology is computed by applying Algorithm 1 to d and extracting persistent cohomology pairs.' }
        @{ label = '(6)'; s = '(6) A cohomology representative of a persistence cohomology pair is a cochain, i.e., a linear map.' }
    ) { Test-IsCitationLine $s | Should -BeFalse -Because "an enumerated body item carries no (year): $label" }

    It 'accepts a bracketed [N] reference — unambiguous, no year required: <label>' -ForEach @(
        @{ label = '[1]';  s = '[1] Ulrich Bauer. Ripser: efficient computation of Vietoris-Rips persistence barcodes. JACT, 5:391-423, 2021.' }
        @{ label = '[20]'; s = '[20] Giovanni Petri, Martina Scolamiero, Irene Donato, and Francesco Vaccarino. PloS one, 8(6):e66506, 2013.' }
    ) { Test-IsCitationLine $s | Should -BeTrue }

    It 'accepts a genuine (N) reference that carries a (year)' {
        Test-IsCitationLine '(1) Ulrich Bauer. Ripser. Journal of Applied and Computational Topology (2021).' | Should -BeTrue
    }

    It 'accepts a genuine bare "N." reference that carries a (year)' {
        Test-IsCitationLine '1. Edelsbrunner, Letscher, and Zomorodian. Topological persistence and simplification (2002).' | Should -BeTrue
    }

    It 'rejects a bare "N." procedure step with no (year) — existing guard, kept' {
        Test-IsCitationLine '1. Reduce the coboundary matrix and extract the contributing simplices.' | Should -BeFalse
    }
}
