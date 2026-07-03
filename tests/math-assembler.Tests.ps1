#requires -Version 7.0
<#
  tests/math-assembler.Tests.ps1 — the 1.5-D nested-script assembler (src/pdf-converter/math-assembler.ps1).

  The core invariant: a glyph's script that itself carries a script NESTS (t_{v_{i+1}}), never the
  KaTeX-invalid flat double-subscript (t_{v}_{1}) the per-glyph flat call produced.
#>

BeforeAll {
    . "$PSScriptRoot/../src/pdf-converter/math-assembler.ps1"

    # build a positioned glyph the assembler consumes
    function G([string]$t, [double]$x, [double]$y, [double]$sz, [string]$font = 'CMMI10') {
        [pscustomobject]@{ text=$t; bx=@($x, ($y-2), ($x+3), ($y+$sz)); base=@($x, $y); size=$sz; font=$font }
    }
}

Describe 'recursive script nesting' {
    It 'nests a subscript-of-a-subscript (t_{v_{i+1}})' {
        # sizes 10 / 7 / 5 on stepping-down baselines — the CM script ladder
        $g = @( (G 't' 0 100 10), (G 'v' 4 98.5 7), (G 'i' 7 97.5 5), (G '+' 9 97.5 5), (G '1' 12 97.5 5) )
        ConvertTo-NestedMath -Letters $g | Should -Be 't_{v_{i+1}}'
    }

    It 'never emits a flat double-subscript' {
        $g = @( (G 't' 0 100 10), (G 'u' 4 98.5 7), (G '1' 7 97.5 5) )
        $out = ConvertTo-NestedMath -Letters $g
        $out | Should -Not -Match '\}_\{'   # no "}_{" — the invalid flat chain
        $out | Should -Be 't_{u_{1}}'
    }

    It 'handles a superscript (x^{2})' {
        $g = @( (G 'x' 0 100 10), (G '2' 4 103 7) )   # 2 sits ABOVE the baseline
        ConvertTo-NestedMath -Letters $g | Should -Be 'x^{2}'
    }

    It 'keeps same-size same-baseline glyphs on the base line (no spurious scripts)' {
        $g = @( (G 'a' 0 100 10), (G 'b' 4 100 10), (G 'c' 8 100 10) )
        ConvertTo-NestedMath -Letters $g | Should -Be 'abc'
    }

    It 'is deterministic on x-tied glyphs (stable sort)' {
        $g1 = @( (G 'a' 5 100 10), (G 'b' 5 100 10) )
        $g2 = @( (G 'a' 5 100 10), (G 'b' 5 100 10) )
        (ConvertTo-NestedMath -Letters $g1) | Should -Be (ConvertTo-NestedMath -Letters $g2)
    }

    It 'applies the symbol-correction hook (‖ -> \|)' {
        $fn = { param($t,$f) if ($t -eq '‖') { '\|' } else { $null } }
        $g = @( (G '‖' 0 100 10 'CMSY10'), (G 'x' 4 100 10) )
        ConvertTo-NestedMath -Letters $g -SymbolFn $fn | Should -Be '\|x'
    }
}

Describe 'delimiter balance' {
    It 'reports zero for a balanced span' {
        Measure-DelimiterBalance 'x_{i}(a+b)[c]' | Should -Be 0
    }
    It 'reports a positive net for an unclosed opener' {
        Measure-DelimiterBalance '(t_{i}+d' | Should -BeGreaterThan 0
    }
    It 'ignores the structural braces the assembler emits' {
        Measure-DelimiterBalance 't_{v_{i+1}}' | Should -Be 0
    }
}
