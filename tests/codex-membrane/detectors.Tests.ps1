#requires -Version 7.0
# The rebuilt detectors (latex.ps1 / fidelity.ps1) on fixed inputs — the reproduced bugs are pinned here
# as permanent regressions, and the gibberish calibration (genuine shatter vs wrapped/flattened math) too.

BeforeAll {
    . "$PSScriptRoot/../../src/latex-ingest/latex.ps1"
    . "$PSScriptRoot/../../src/codex-membrane/fidelity.ps1"
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
    # interval notation crosses [] and () on purpose — the combined-class balance must NOT flag it
    It 'does NOT flag valid interval notation: <s>' -ForEach @(
        @{ s = 'x \in [0,1)' }
        @{ s = '[0, \infty) \subset \mathbb{R}' }
        @{ s = '\alpha \in (0, 1]' }
        @{ s = 'f \colon [a,b) \to \mathbb{R}' }
    ) { Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = $s }) | Should -BeNullOrEmpty }
    It 'still flags a real gap even when a valid interval is present (interval tolerated, brace gap caught)' {
        Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = 'x \in [0,1) + \frac{1}{2' }) | Should -Be 'unbalanced_delimiters'
    }
    It 'still flags a genuinely missing/extra literal delimiter: <s>' -ForEach @(
        @{ s = 'x \in [0,1' }           # missing ]
        @{ s = '\alpha + \beta ) \gamma' }  # extra )
    ) { Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = $s }) | Should -Be 'unbalanced_delimiters' }
    It 'flags the U+FFFD replacement char' {
        Get-CorruptionType ([pscustomobject]@{ type = 'prose'; content = "lost $([char]0xFFFD) char" }) | Should -Be 'replacement_char'
    }
}

# ── SOFT detectors — valid-but-wrong tells (the 1611.03935v1 cluster: structurally valid LaTeX the hard
# gate grades faithful). Each fixture is drawn from a real destroyed chunk; each negative from legit math.
Describe 'Soft detector — glyph_name_leak' {
    It 'flags a literal glyph name leak' { Test-GlyphNameLeak 'where glyph[negationslash] holds' | Should -BeTrue }
    It 'passes clean math' { Test-GlyphNameLeak 'where x \neq y' | Should -BeFalse }
}

Describe 'Soft detector — dangling_operator (truncated tail)' {
    It 'flags a row ending on an operator: <s>' -ForEach @(
        @{ s = '\text{such that} \delta_{1} <' }   # chunk 42 tail
        @{ s = 'x \in' }
        @{ s = 'a = b +' }
    ) { Test-DanglingOperator $s | Should -BeTrue }
    It 'passes a complete statement / continuation: <s>' -ForEach @(
        @{ s = 'a = b' }
        @{ s = '\begin{aligned} a &= b \\ c &= d \end{aligned}' }   # last row complete
        @{ s = 'y = \sin' }                                          # \sin is not \in
        @{ s = 'f(x) = x^2' }
    ) { Test-DanglingOperator $s | Should -BeFalse }
}

Describe 'Soft detector — text_sentence_in_math (prose smuggled in \text{})' {
    It 'flags a sentence merged across \text{} blocks: <s>' -ForEach @(
        @{ s = '... \epsilon \text{Further, choose} \delta_{0} \text{such that} \delta_{1} <' }       # chunk 42
        @{ s = '... \text{for a sufficiently large} c_{0} \text{then} P \text{Using standa}' }         # chunk 44
    ) { Test-TextSentenceInMath $s | Should -BeTrue }
    It 'passes short legit \text{} annotations: <s>' -ForEach @(
        @{ s = '\frac{a}{b} & \text{if } x \text{ else } y' }
        @{ s = '\exp\!\left(-d\right) & \text{if } v_i \text{ and } v_j \text{ are neighbors}' }
        @{ s = '1 & \text{if } x > 0 \\ 0 & \text{otherwise}' }
    ) { Test-TextSentenceInMath $s | Should -BeFalse }
}

Describe 'Soft detector — bare_number_row (page number swept into math)' {
    It 'flags a lone-integer alignment row' { Test-BareNumberRow '... \geq \frac{2}{\pi} , \\ & \quad 4' | Should -BeTrue }
    It 'passes a row with real content: <s>' -ForEach @(
        @{ s = '0 & 0' }
        @{ s = 'x = 4' }
        @{ s = '\frac{1}{2} \\ \frac{3}{4}' }
    ) { Test-BareNumberRow $s | Should -BeFalse }
}

Describe 'Soft detector — degenerate_structure (destroyed equation body)' {
    It 'flags a \substack carrying no constraint (PhaseMax LP)' {
        Test-DegenerateStructure '\max_{\substack{s . t . \\ s . t .}} \ \langle \phi , x \rangle' | Should -BeTrue
    }
    It 'passes a real multi-line subscript constraint: <s>' -ForEach @(
        @{ s = '\sum_{\substack{i=1 \\ j=1}} a_{ij}' }       # has a relation + digit
        @{ s = '\sum_{\substack{\alpha \\ \beta}} f' }       # symbol-only stack, no literal text
        @{ s = '\min_{\substack{0 \le k \le n}} f(k)' }
    ) { Test-DegenerateStructure $s | Should -BeFalse }
}

Describe 'Soft detector — hallucinated_subexpr (self-cancelling X - X)' {
    It 'flags k_{i} - k_{i}' { Test-HallucinatedSubexpr '\log | k_{i} - k_{i} - i |' | Should -BeTrue }
    It 'passes distinct or trivial subexpressions: <s>' -ForEach @(
        @{ s = 'a_{i} - a_{j}' }   # distinct subscripts
        @{ s = 'x - x' }           # single-char, below the >=2 guard
        @{ s = 'p_{1} - p_{2}' }
    ) { Test-HallucinatedSubexpr $s | Should -BeFalse }
}

Describe 'Severity band — soft signals route to needs_review, never the hard gate' {
    It 'the hard gate (Get-CorruptionType) ignores a soft-only chunk' {
        Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = 'x \in' }) | Should -BeNullOrEmpty
    }
    It 'Get-SoftReviewType picks up the soft tell' {
        Get-SoftReviewType ([pscustomobject]@{ type = 'formula'; content = 'x \in' }) | Should -Be 'dangling_operator'
    }
    It 'the hard gate still fires on a hard defect, and soft does not steal it' {
        $c = [pscustomobject]@{ type = 'formula'; content = '\left( \frac{1}{2}' }
        Get-CorruptionType $c | Should -Be 'unbalanced_delimiters'
    }
    It 'a soft-only formula is faithful to the hard gate but flagged by the inventory' {
        $c = [pscustomobject]@{ type = 'formula'; content = '\max_{\substack{s.t. \\ s.t.}} \langle \phi, x \rangle' }
        Get-CorruptionType $c | Should -BeNullOrEmpty
        @(Get-ChunkIssues $c | ForEach-Object { $_.type }) | Should -Contain 'degenerate_structure'
    }
    It 'Get-ChunkIssues surfaces BOTH a hard and a soft issue on one chunk' {
        # an unbalanced formula that also dangles on an operator: gate=hard, inventory carries both
        $c = [pscustomobject]@{ type = 'formula'; content = '\left( a +' }
        $types = @(Get-ChunkIssues $c | ForEach-Object { $_.type })
        $types | Should -Contain 'unbalanced_delimiters'
        $types | Should -Contain 'dangling_operator'
    }
}

# ── CROSS-CHUNK detector — prose_seam_merge: a formula's \text{} prose duplicating the adjacent paragraph
# (chunk 36 forward / chunk 49 backward in 1611.03935v1). A pass over the ordered list sets the stored field.
Describe 'Cross-chunk detector — prose_seam_merge (Set-SeamMergeFlags)' {
    It 'flags a formula whose \text{} tail duplicates the NEXT prose chunk (forward merge)' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'formula'; content = '\Bigl( \dots \Bigr) \\ \text{we will take} \delta_{1} < K .' }
            [pscustomobject]@{ id = 2; type = 'prose';   content = 'Later, we will take $\delta_1 < K$. Second, we show that ...' }
        )
        Set-SeamMergeFlags $chunks
        $chunks[0].seam_merge | Should -Not -BeNullOrEmpty
        $chunks[1].PSObject.Properties['seam_merge'] | Should -BeNullOrEmpty
    }
    It 'flags a formula whose \text{} head duplicates the PREVIOUS prose chunk (backward dup)' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'prose';   content = 'take $x_0=e_1$ and $x_1=\cos\theta e_1+\sin\theta e_2$. The expected value is' }
            [pscustomobject]@{ id = 2; type = 'formula'; content = '\begin{aligned} e_1 \text{and} x_1 & = \dots \text{The expected value is} \\ & \quad \mathbb{E} \dots \end{aligned}' }
        )
        Set-SeamMergeFlags $chunks
        $chunks[1].seam_merge | Should -Not -BeNullOrEmpty
    }
    It 'does NOT flag legit short \text{} annotations against an unrelated neighbour' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'formula'; content = '\frac{a}{b} & \text{if } x \text{ else } y' }
            [pscustomobject]@{ id = 2; type = 'prose';   content = 'We now turn to the proof of the main theorem.' }
        )
        Set-SeamMergeFlags $chunks
        $chunks[0].PSObject.Properties['seam_merge'] | Should -BeNullOrEmpty
    }
    It 'does NOT flag when the neighbour is another formula (no prose source)' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'formula'; content = '\dots \text{we will take} \delta_{1} < K' }
            [pscustomobject]@{ id = 2; type = 'formula'; content = 'we will take \delta_1 \cdot something' }
        )
        Set-SeamMergeFlags $chunks
        $chunks[0].PSObject.Properties['seam_merge'] | Should -BeNullOrEmpty
    }
    It 'recomputes — a stale seam_merge clears when the duplication is gone' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'formula'; content = '\langle a, b \rangle = 0'; seam_merge = [pscustomobject]@{ start = 0; end = 5 } }
            [pscustomobject]@{ id = 2; type = 'prose';   content = 'An unrelated paragraph follows here.' }
        )
        Set-SeamMergeFlags $chunks
        $chunks[0].PSObject.Properties['seam_merge'] | Should -BeNullOrEmpty
    }
    It 'the inventory surfaces prose_seam_merge from the stored field with its span' {
        $c = [pscustomobject]@{ type = 'formula'; content = 'x = y \text{merged}'; seam_merge = [pscustomobject]@{ start = 6; end = 19 } }
        $iss = @(Get-ChunkIssues $c | Where-Object { $_.type -eq 'prose_seam_merge' })
        $iss.Count | Should -Be 1
        $iss[0].spans[0].start | Should -Be 6
    }
}
