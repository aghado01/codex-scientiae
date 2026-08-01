#requires -Version 7.0
# The KaTeX render-validity gate (src/render-check.ps1 over tools/render-check). "Renders clean under KaTeX"
# is the objective math standard (STANDARDS §1); these pin that the gate accepts well-formed math and rejects
# the corruption classes the membrane heuristics approximate. Skips cleanly when node/katex aren't installed.

BeforeAll {
    . "$PSScriptRoot/../../src/render-check.ps1"
    $script:available = Test-RenderCheckAvailable
}

Describe 'render-check — KaTeX render-validity gate' {
    It 'is available (node + pinned katex installed in tools/render-check)' {
        if (-not $script:available) { Set-ItResult -Skipped -Because 'node/katex not installed (npm install in tools/render-check)'; return }
        $script:available | Should -BeTrue
    }

    It 'accepts well-formed math (display + inline)' {
        if (-not $script:available) { Set-ItResult -Skipped; return }
        $r = Test-MathRenders -Spans @(
            @{ content = '\frac{1}{2} + \sum_{i=1}^n x_i'; display = $true }
            @{ content = 'x \in \mathbb{R}^n'; display = $false }
            @{ content = '\begin{aligned} a &= b \\ c &= d \end{aligned}'; display = $true }
        )
        $r.ok | Should -Be 3
        $r.failed | Should -Be 0
    }

    It 'rejects an undefined control sequence (the macro-expansion / glyph_name_leak class)' {
        if (-not $script:available) { Set-ItResult -Skipped; return }
        $r = Test-MathRenders -Spans @(@{ content = '\eps + \norm{x}'; display = $false })
        $r.failed | Should -Be 1
        $r.failures[0].error | Should -Match 'Undefined control sequence'
    }

    It 'rejects unbalanced delimiters (the unbalanced_delimiters class)' {
        if (-not $script:available) { Set-ItResult -Skipped; return }
        (Test-MathRenders -Spans @(@{ content = '\left( \frac{1}{2}'; display = $true })).failed | Should -Be 1
    }

    It 'rejects a bare alignment & outside an environment (the alignment_outside_env class)' {
        if (-not $script:available) { Set-ItResult -Skipped; return }
        (Test-MathRenders -Spans @(@{ content = 'a &= b'; display = $true })).failed | Should -Be 1
    }

    It 'accepts nested $ inside \text{} (verified NOT a defect — renders as math)' {
        if (-not $script:available) { Set-ItResult -Skipped; return }
        (Test-MathRenders -Spans @(@{ content = '\phi z \text{ where $z$ is the leading eigenvector}'; display = $true })).failed | Should -Be 0
    }

    It 'the LaTeX oracle renders clean at the STRICT bar' {
        $oracle = "$PSScriptRoot/../../ingestion/_inbox/1611.03935/1611.03935.latex.md"
        if (-not $script:available -or -not (Test-Path $oracle)) { Set-ItResult -Skipped -Because 'oracle or node absent'; return }
        $r = Test-MathRenders -Path $oracle -Strict
        $r.failed | Should -Be 0
        $r.total | Should -BeGreaterThan 100
    }
}
