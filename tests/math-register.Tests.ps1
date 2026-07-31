#requires -Version 7.0
# ConvertTo-RegisterMath (src/math-register.ps1) — the span-level canonicalizer both lanes serialize
# through (math-register spec §4–§5). Coverage: \operatorname lowering (P4), alias surjection with
# boundary safety, §4.2 furniture, \text masking, glyph -> control sequence, retention guarantees
# (§4.1/§8.1 — alphabet macros NEVER touched), and idempotency (§C determinism).

BeforeAll {
    . "$PSScriptRoot/../src/math-register/math-register.ps1"
}

Describe 'alias surjection (§4.3) — one concept, one spelling' {
    It 'canonicalizes the spec rows' {
        ConvertTo-RegisterMath 'a \ge b' | Should -Be 'a \geq b'
        ConvertTo-RegisterMath 'a \geqslant b \le c \leqslant d' | Should -Be 'a \geq b \leq c \leq d'
        ConvertTo-RegisterMath 'a \ne b' | Should -Be 'a \neq b'
        ConvertTo-RegisterMath 'f: A \rightarrow B' | Should -Be 'f: A \to B'
        ConvertTo-RegisterMath '\dfrac{1}{2} + \tfrac{1}{2}' | Should -Be '\frac{1}{2} + \frac{1}{2}'
    }
    It 'canonical forms are fixed points; sibling commands are never clipped' {
        ConvertTo-RegisterMath 'a \geq b \to c' | Should -Be 'a \geq b \to c'          # already canonical
        ConvertTo-RegisterMath 'x \gets y' | Should -Be 'x \gets y'                    # \ge must not fire inside \gets
        ConvertTo-RegisterMath 'A \longrightarrow B' | Should -Be 'A \longrightarrow B' # long arrows are a distinct concept
        ConvertTo-RegisterMath '\left( x \right)' | Should -Be '\left( x \right)'      # \le must not fire inside \left
    }
}

Describe '\operatorname lowering (P4/§4.3) — input evidence, \mathrm target' {
    It 'lowers both plain and starred forms' {
        ConvertTo-RegisterMath '\operatorname{Hom}(A,B)' | Should -Be '\mathrm{Hom}(A,B)'
        ConvertTo-RegisterMath '\operatorname*{colim}_{n} F' | Should -Be '\mathrm{colim}_{n} F'
    }
    It 'a nested-brace operator name is left alone, never guessed' {
        ConvertTo-RegisterMath '\operatorname{ess\,{sup}}' | Should -Be '\operatorname{ess\,{sup}}'
    }
}

Describe 'furniture removal (§4.2)' {
    It 'drops renderer injection, keeping the payload' {
        ConvertTo-RegisterMath '\textcolor{red}{x+y}' | Should -Be '{x+y}'
        ConvertTo-RegisterMath '\color{blue} x' | Should -Be ' x'
    }
    It 'drops manual spacing and visual kerning' {
        ConvertTo-RegisterMath 'a \hspace{1em} b \vspace*{2pt} c' | Should -Be 'a b c'
        ConvertTo-RegisterMath 'n\!\log n' | Should -Be 'n\log n'
    }
    It 'collapses redundant grouping' {
        ConvertTo-RegisterMath 'x^{{n}} + \frac{{a}}{b}' | Should -Be 'x^{n} + \frac{a}{b}'
    }
    It 'strips \displaystyle in INLINE position only' {
        ConvertTo-RegisterMath -Latex '\displaystyle \sum_i x_i' -Inline | Should -Be '\sum_i x_i'
        ConvertTo-RegisterMath '\displaystyle \sum_i x_i' | Should -Be '\displaystyle \sum_i x_i'
    }
    It 'leaves the §8.3 open items untouched — no rule, no code' {
        ConvertTo-RegisterMath '\int f(x)\,dx' | Should -Be '\int f(x)\,dx'
        ConvertTo-RegisterMath 'a \quad b' | Should -Be 'a \quad b'
    }
}

Describe 'retention (§4.1/§8.1) — notation survives unconditionally' {
    It 'never touches alphabet macros' {
        ConvertTo-RegisterMath '\mathbb{R}^n, \mathcal{F}_t, \mathfrak{g}' | Should -Be '\mathbb{R}^n, \mathcal{F}_t, \mathfrak{g}'
    }
    It 'never touches accents, scripts, or grammar-bearing grouping' {
        ConvertTo-RegisterMath '\hat{x}_i^2 + \sqrt{\bar{y}}' | Should -Be '\hat{x}_i^2 + \sqrt{\bar{y}}'
    }
}

Describe '\text masking (§3) — prose is out of jurisdiction' {
    It 'does not rewrite command-lookalikes or glyphs inside \text' {
        ConvertTo-RegisterMath 'x \text{ for α and \ge } y \ge z' | Should -Be 'x \text{ for α and \ge } y \geq z'
    }
}

Describe 'glyph -> control sequence (§5)' {
    It 'spells non-ASCII math symbols as commands, ASCII stays literal' {
        ConvertTo-RegisterMath ('x ' + [char]0x2264 + ' ' + [char]0x03A9) | Should -Be 'x \leq \Omega'
    }
    It 'guards command/letter fusion with a space only where needed' {
        ConvertTo-RegisterMath ([char]0x039B + 'x') | Should -Be '\Lambda x'
        ConvertTo-RegisterMath ('(' + [char]0x03A9 + ')') | Should -Be '(\Omega)'
    }
    It 'preserves display newlines (unlike Convert-MathToLatex, which is single-line only)' {
        $in = "\begin{aligned}`na &= " + [char]0x03B2 + "`nb &= c`n\end{aligned}"
        ConvertTo-RegisterMath $in | Should -Be "\begin{aligned}`na &= \beta`nb &= c`n\end{aligned}"
    }
}

Describe 'idempotency — canonical form is a fixed point (§C determinism)' {
    It 'applying twice equals applying once, across every rule family' {
        $cases = @(
            'a \ge b \text{ where } \operatorname{Hom}(A,B) \ne 0'
            '\textcolor{red}{x}\! + \dfrac{{a}}{b} \rightarrow ' + [char]0x03A9
            '\mathbb{E}[X] \leqslant \operatorname*{sup}_n X_n'
        )
        foreach ($c in $cases) {
            $once = ConvertTo-RegisterMath $c
            ConvertTo-RegisterMath $once | Should -BeExactly $once
        }
    }
}

Describe 'surjection-store invariants (§4.4) — enforced on the data itself' {
    It 'fixed point: no canonical form is a member of any entry' {
        foreach ($a in $script:MathAliases) { $script:MathAliasMap.ContainsKey($a.canonical) | Should -BeFalse }
    }
    It 'disjointness: member sets never overlap' {
        $all = @($script:MathAliases | ForEach-Object { $_.members }) | ForEach-Object { $_ }
        ($all | Group-Object | Where-Object Count -gt 1) | Should -BeNullOrEmpty
    }
}
