#requires -Version 7.0
# src/shared/md-sentinels.ps1 — the ONE defect-sentinel catalogue.
#
# These marks say a document was DAMAGED in conversion: a destroyed codepoint, a protection marker that
# outlived its pass, a human placeholder that shipped. The retired publisher and md-bundle.ps1 each
# carried a partial private copy — the publisher missed the leaked-placeholder pattern entirely — so
# the union lives here and every gate counts the same things.

Describe 'md-sentinels — shared defect catalogue' {
    BeforeAll { . "$PSScriptRoot/../../src/shared/md-sentinels.ps1" }

    It 'counts every sentinel, including the one that must be a REGEX not a literal' {
        $bad = "ok " + [char]0xFFFD + " @@LMATH0@@ FILL_ME_IN and " + [char]0xFFFD
        Get-MdSentinelCount $bad 'U+FFFD' | Should -Be 2
        Get-MdSentinelCount $bad 'placeholder' | Should -Be 1   # @@LMATH0@@ — literal matching would miss it
        Get-MdSentinelCount $bad 'FILL_ME_IN' | Should -Be 1
    }

    It 'reports per-text counts across named fields, omitting sentinels that did not fire' {
        $d = @(Get-MdDefectCounts -Texts ([ordered]@{ body = ("x" + [char]0xFFFD); references = 'FILL_ME_IN' }))
        $d.Count | Should -Be 2                                  # placeholder never fired -> absent
        ($d | Where-Object label -eq 'U+FFFD').counts['body'] | Should -Be 1
        ($d | Where-Object label -eq 'U+FFFD').counts['references'] | Should -Be 0
        ($d | Where-Object label -eq 'FILL_ME_IN').total | Should -Be 1
    }

    It 'a clean document yields an EMPTY result — the same answer inlined or assigned' {
        # the bug this pins: a unary-comma wrapper kept the List intact through assignment but left it a
        # single object when inlined, so @(f()).Count said 1 for a clean document while $r = f();
        # @($r).Count said 0 — and a gate reads it inlined.
        @(Get-MdDefectCounts -Texts ([ordered]@{ body = 'all good' })).Count | Should -Be 0
        $r = Get-MdDefectCounts -Texts ([ordered]@{ body = 'all good' })
        @($r).Count | Should -Be 0
        @(Get-MdDefectCounts -Texts ([ordered]@{ body = ''; references = $null })).Count | Should -Be 0
    }

    It 'is the ONLY sentinel table — no module carries a private copy' {
        $repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
        $copies = @(Get-ChildItem -Path (Join-Path $repo 'src') -Recurse -Filter *.ps1 |
            Where-Object { $_.FullName -notmatch 'worktrees' -and $_.Name -ne 'md-sentinels.ps1' } |
            Where-Object { [System.IO.File]::ReadAllText($_.FullName) -match 'FILL_ME_IN''\s*;\s*Label|DefectSentinels\s*=\s*@\(' })
        $copies.Count | Should -Be 0
    }
}
