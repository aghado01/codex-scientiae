#requires -Version 7.0
# (A) Get-EnvironmentBalance + the unclosed_environment signature, and (B) the repair excision env-guard.
# Regression cover for the Voroninski first-light finding: an \end carried off with a degenerate \intertext
# tail left a brace-balanced-but-open \begin{aligned} that slipped flagged=0 and broke the math parser.

BeforeAll {
    . "$PSScriptRoot/../src/latex.ps1"
    . "$PSScriptRoot/../src/fidelity.ps1"
    . "$PSScriptRoot/../src/playbook.ps1"
}

Describe 'Get-EnvironmentBalance — \begin/\end closure invariant' {
    It 'passes a balanced environment' {
        (Get-EnvironmentBalance '\begin{aligned} a &= b \\ c &= d \end{aligned}').balanced | Should -BeTrue
    }
    It 'passes content with no environments' {
        (Get-EnvironmentBalance 'plain prose, an inline $x_0$, no environments').balanced | Should -BeTrue
    }
    It 'passes matched nesting' {
        (Get-EnvironmentBalance '\begin{cases}\begin{aligned}a\end{aligned}\end{cases}').balanced | Should -BeTrue
    }
    It 'flags an unclosed \begin (the excised-\end bug)' {
        $b = Get-EnvironmentBalance '\begin{aligned} a &= b \\ c &= d'
        $b.balanced  | Should -BeFalse
        $b.fault.kind | Should -Be 'unclosed_begin'
        $b.fault.name | Should -Be 'aligned'
    }
    It 'flags a dangling \end' {
        $b = Get-EnvironmentBalance 'a = b \end{aligned}'
        $b.balanced  | Should -BeFalse
        $b.fault.kind | Should -Be 'dangling_end'
    }
    It 'flags a mismatched close' {
        (Get-EnvironmentBalance '\begin{aligned} x \end{array}').balanced | Should -BeFalse
    }
}

Describe 'unclosed_environment signature — brace-balanced yet environment-open' {
    It 'fires exactly where Get-LatexBalance reports full delimiter balance' {
        $content = '\begin{aligned} \|x\|^2 &\leq 1'
        (Get-LatexBalance $content).full | Should -BeTrue          # braces balanced -> the delimiter gate is blind
        Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = $content }) | Should -Be 'unclosed_environment'
    }
    It 'does not fire on a closed environment' {
        $content = '\begin{aligned} \|x\|^2 &\leq 1 \end{aligned}'
        Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = $content }) | Should -BeNullOrEmpty
    }
    It 'localizes the span from the orphaned \begin to end' {
        $spans = @(Get-IssueSpans 'unclosed_environment' 'formula' '  \begin{aligned} a &= b')
        $spans.Count    | Should -Be 1
        $spans[0].start | Should -Be 2
    }
    It 'has a paired recipe (the coverage invariant in action)' {
        (Get-RepairRecipe 'unclosed_environment').fix | Should -Not -BeNullOrEmpty
    }
}

Describe 'repair excision env-guard (B) — excision must not orphan an environment' {
    BeforeAll { . "$PSScriptRoot/../src/repair.ps1" }

    It 'would-excise head is detected open when the \end is in the \intertext tail' {
        # \end sits AFTER \intertext, i.e. inside the tail the old gate would have excised.
        $content = '\begin{aligned} a &= b \\ \intertext{garbage garbage} c &= d \end{aligned}'
        $head = $content.Substring(0, (Get-CorruptionOnset $content))
        (Get-LatexBalance $head).braceBalanced  | Should -BeTrue    # old gate: would excise
        (Get-EnvironmentBalance $head).balanced  | Should -BeFalse   # new guard: blocks it
    }
    It 'still permits excision when the head closes its own environment' {
        $content = '\begin{aligned} a &= b \end{aligned} \intertext{garbage} a a a a a'
        $head = $content.Substring(0, (Get-CorruptionOnset $content))
        (Get-EnvironmentBalance $head).balanced | Should -BeTrue
    }
}
