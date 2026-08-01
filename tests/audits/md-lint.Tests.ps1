#requires -Version 7.0
# The markdown STRUCTURE gate (src/audits/md-lint.ps1 over tools/md-lint, markdownlint). The non-math half of the
# standard (heading hierarchy §5, spacing §4). Skips cleanly when node/markdownlint aren't installed.

BeforeAll {
    . "$PSScriptRoot/../../src/audits/md-lint.ps1"
    $script:avail = Test-MarkdownLintAvailable
}

Describe 'md-lint — markdown structure gate' {
    It 'is available (node + markdownlint in tools/md-lint)' {
        if (-not $script:avail) { Set-ItResult -Skipped -Because 'node/markdownlint not installed (npm install in tools/md-lint)'; return }
        $script:avail | Should -BeTrue
    }

    It 'passes a clean codex-style document' {
        if (-not $script:avail) { Set-ItResult -Skipped; return }
        $f = Join-Path $TestDrive 'clean.md'
        "# Title`n`n## Section`n`nSome prose with `$x = 1`$ inline math." | Set-Content -LiteralPath $f -Encoding utf8
        (Test-MarkdownLint -Path $f).total | Should -Be 0
    }

    It 'flags a heading not followed by a blank line (MD022 — the bug the linter caught in latex-ingest)' {
        if (-not $script:avail) { Set-ItResult -Skipped; return }
        $f = Join-Path $TestDrive 'md022.md'
        "# Title`n`n## Section`nText immediately below, no blank line." | Set-Content -LiteralPath $f -Encoding utf8
        $r = Test-MarkdownLint -Path $f
        $r.total | Should -BeGreaterThan 0
        (@($r.issues).rule -join ' ') | Should -Match 'MD022'
    }

    It 'flags multiple consecutive blank lines (MD012)' {
        if (-not $script:avail) { Set-ItResult -Skipped; return }
        $f = Join-Path $TestDrive 'md012.md'
        "# Title`n`n## Section`n`nText.`n`n`n`nMore." | Set-Content -LiteralPath $f -Encoding utf8
        (@((Test-MarkdownLint -Path $f).issues).rule -join ' ') | Should -Match 'MD012'
    }

    It 'the LaTeX oracle is markdown-clean' {
        $oracle = "$PSScriptRoot/../../ingestion/_inbox/1611.03935/1611.03935.latex.md"
        if (-not $script:avail -or -not (Test-Path $oracle)) { Set-ItResult -Skipped -Because 'oracle or node absent'; return }
        (Test-MarkdownLint -Path $oracle).total | Should -Be 0
    }
}
