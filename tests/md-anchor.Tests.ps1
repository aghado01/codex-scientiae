#requires -Version 7.0
# src/shared/md-anchor.ps1 — THE heading-slug engine, one definition repo-wide.
#
# These cases came from md-toc.Tests.ps1, which retired with its module. The slug rule is a
# cross-cutting invariant: finalize, md-repair, toc-engine and the latex lane all resolve anchors
# written by each other, so a change here is a corpus-wide link break, not a local edit.

Describe 'Get-MdAnchor — the one slug engine' {
    BeforeAll { . "$PSScriptRoot/../src/shared/md-anchor.ps1" }

    It 'lowercases, strips punctuation, and hyphenates whitespace (GitHub rule)' {
        Get-MdAnchor 'Methods' | Should -Be 'methods'
        Get-MdAnchor '2.1 Local Fields, revisited' | Should -Be '21-local-fields-revisited'
        Get-MdAnchor '  Edge -- case!  ' | Should -Be 'edge----case'
    }
    It 'gives a heading that slugs to nothing a stable, content-derived anchor' {
        # an empty anchor would produce a link that resolves to the top of the document, silently
        Get-MdAnchor '???' | Should -Match '^section-[0-9a-f]{8}$'
        Get-MdAnchor '???' | Should -Be (Get-MdAnchor '???')          # stable across calls
        Get-MdAnchor '???' | Should -Not -Be (Get-MdAnchor '!!!')     # and distinguishes distinct headings
    }
    It 'keeps underscores and digits — they are word characters, not punctuation' {
        # matters for math-bearing headings: $B_1^{...}$ slugs through this rule unchanged
        Get-MdAnchor 'B_1 and K_n' | Should -Be 'b_1-and-k_n'
    }

    It 'is defined ONCE — no module carries a private copy' {
        # the drift this file exists to prevent: two implementations that agree today and diverge later,
        # surfacing as a dead anchor in a shipped document far from whichever edit caused it
        $repo = Split-Path -Parent $PSScriptRoot
        $defs = @(Get-ChildItem -Path (Join-Path $repo 'src') -Recurse -Filter *.ps1 |
            Where-Object { $_.FullName -notmatch 'worktrees' } |
            Where-Object { [System.IO.File]::ReadAllText($_.FullName) -match '(?m)^\s*function\s+Get-MdAnchor\b' })
        $defs.Count | Should -Be 1
        $defs[0].Name | Should -Be 'md-anchor.ps1'
    }
}
