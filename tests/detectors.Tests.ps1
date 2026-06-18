#requires -Version 7.0
# The rebuilt detectors (latex.ps1 / fidelity.ps1) on fixed inputs — the reproduced bugs are pinned here
# as permanent regressions, and the gibberish calibration (genuine shatter vs wrapped/flattened math) too.

BeforeAll {
    . "$PSScriptRoot/../src/latex.ps1"
    . "$PSScriptRoot/../src/fidelity.ps1"
}

Describe 'Test-IsMath — prose-in-formula by overlay+complement' {
    It 'recognizes a multi-environment formula as math (reproduced bug: env names no longer leak)' {
        Test-IsMath '\begin{aligned}\begin{cases} x &= 1 \\ y &= 2 \end{cases}\end{aligned} + \begin{array}{cc} a & b \\ c & d \end{array}' | Should -BeTrue
    }
    It 'flags genuine prose mislabeled as a formula' {
        Test-IsMath 'This result holds for every continuous bounded function defined over the compact domain' | Should -BeFalse
    }
    It 'recognizes ordinary math: <s>' -ForEach @(
        @{ s = '\frac{d+1}{2} \leq \alpha + \beta' }
        @{ s = '\sum_{i=1}^{n} x_i^2 \in \mathbb{R}' }
        @{ s = 'H(S) = \sum_{i,j} J_{ij}\bigl(1 - \delta_{s_i,s_j}\bigr)' }
    ) { Test-IsMath $s | Should -BeTrue }
}

Describe 'Test-IsMath -Level Row — display-formula row (replaces Test-MathRow strip-list)' {
    It 'matches the legacy strip-list on representative row fixtures' {
        $rows = @(
            '\frac{1}{\hat{K}} \exp\!\left(-\frac{d_{ij}^2}{2a^2}\right) & \text{if } v_i \text{ and } v_j \text{ are neighbors}'
            '0 & 0'
            '\text{This paragraph was duplicated from the body text below and should not stay in the formula.}'
            'The quick brown fox jumps over the lazy dog'
            'x = y + z'
        )
        foreach ($r in $rows) {
            $legacy = (([regex]::Matches(($r -replace '\\[A-Za-z]+', ' '), '[A-Za-z]{4,}')).Count -le 2)
            (Test-IsMath $r -Level Row) | Should -Be $legacy -Because "row: $r"
        }
    }
    It 'flags a \text{...} prose row as non-math' {
        Test-IsMath '\text{This paragraph was duplicated from the body text below.}' -Level Row | Should -BeFalse
    }
    It 'keeps a cases row with short \text fragments as math' {
        Test-IsMath '\frac{a}{b} & \text{if } x \text{ else } y' -Level Row | Should -BeTrue
    }
    It 'Chunk level still masks \text{...} as structure (fidelity path unchanged)' {
        Test-IsMath '\text{This paragraph reads as natural language inside a formula label}' | Should -BeTrue
        Test-IsMath '\text{This paragraph reads as natural language inside a formula label}' -Level Row | Should -BeFalse
    }
}

Describe 'Test-AlignmentOutsideEnv — bare & in the complement of the environment overlay' {
    It 'flags a bare & after a CLOSED env even when an env exists elsewhere (reproduced recall hole)' {
        Test-AlignmentOutsideEnv '$$ \begin{aligned} a &= b \end{aligned} \quad c &= d $$' | Should -BeTrue
    }
    It 'passes & inside an alignment environment' { Test-AlignmentOutsideEnv '\begin{aligned} a &= b \\ c &= d \end{aligned}' | Should -BeFalse }
    It 'flags a bare & with no environment at all' { Test-AlignmentOutsideEnv 'a &= b' | Should -BeTrue }
    It 'passes an unclosed \begin (the open env covers the &) — compatibility-preserving' { Test-AlignmentOutsideEnv '\begin{aligned} a &= b' | Should -BeFalse }
    It 'ignores a literal escaped \&' { Test-AlignmentOutsideEnv 'Jones \& Smith' | Should -BeFalse }
    It 'passes & inside nested environments' { Test-AlignmentOutsideEnv '\begin{aligned}\begin{cases} x &= 1 \end{cases}\end{aligned}' | Should -BeFalse }
}

Describe 'Test-IsGibberish — single-alpha run at Line level, math overlay masked' {
    It 'catches a classic space shatter' { Test-IsGibberish 'a o f i n t o o t' | Should -BeTrue }
    It 'catches a short shatter the old 7-run missed: <label>' -ForEach @(
        @{ label = 'rank'; s = '\ h a s \left ( Z \right ) \ a n d \ r a n k ( Z )' }
        @{ label = 'Alpha'; s = 'A l p h a ( W , \epsilon )' }
    ) { Test-IsGibberish $s | Should -BeTrue }
    It 'ignores single letters inside $...$ (wrapped math)' { Test-IsGibberish 'express that $A * A ( X ) = i z i z * i , X z$ now' | Should -BeFalse }
    It 'ignores flattened subscripts broken by a real word (run of 3)' { Test-IsGibberish 'near latent b k i and d k i as noisy realization' | Should -BeFalse }
    It 'ignores spaced number runs (alpha-only)' { Test-IsGibberish '1 2 3 4 5 6 7 8' | Should -BeFalse }
    It 'ignores normal prose' { Test-IsGibberish 'This is a perfectly ordinary sentence with words' | Should -BeFalse }
}

Describe 'Get-CorruptionType — the merge-gate verdict' {
    It 'returns null (clean) for a well-formed formula' {
        Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = 'E = mc^2' }) | Should -BeNullOrEmpty
    }
    It 'flags an unbalanced formula' {
        Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = '\left( \frac{1}{2}' }) | Should -Be 'unbalanced_delimiters'
    }
    It 'flags the U+FFFD replacement char' {
        Get-CorruptionType ([pscustomobject]@{ type = 'prose'; content = "lost $([char]0xFFFD) char" }) | Should -Be 'replacement_char'
    }
}
