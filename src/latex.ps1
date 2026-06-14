#requires -Version 7.0
<#
  src/latex.ps1 — LaTeX structural primitives.

  Get-LatexBalance: single-pass delimiter-balance scanner. Counts {} [] () depth and
  \left..\right pairing (incl \bigl/\bigr sizing), skipping escaped literals (\{ \( ...)
  and command names so sizing delimiters and literal braces don't corrupt the count —
  the context-aware scan that makes paren/bracket balance reliable where naive counting
  is not. Ported from the structural lexer in ps.core.psdig/PSLinter
  (PSDetectStructuralLexingErrors), which does the same outside-string/comment scan for
  PowerShell.

  Returns: full (all classes + \left\right balanced, none ever negative), braceBalanced,
  and the signed per-class residuals (brace/brack/paren/lr) for seam diagnostics.
#>

function Get-LatexBalance([string]$s) {
    $brace = 0; $brack = 0; $paren = 0; $lr = 0; $neg = $false
    $i = 0; $n = $s.Length
    while ($i -lt $n) {
        $ch = $s[$i]
        if ($ch -eq '\') {
            if ($i + 1 -lt $n) {
                $nx = $s[$i + 1]
                if ('{}[]()'.Contains($nx)) { $i += 2; continue }   # escaped literal delimiter
                $j = $i + 1; while ($j -lt $n -and [char]::IsLetter($s[$j])) { $j++ }
                $cmd = $s.Substring($i + 1, $j - ($i + 1))
                if ($cmd -match '^(left|bigl|Bigl|biggl|Biggl)$') {
                    $lr++; $k = $j; while ($k -lt $n -and $s[$k] -eq ' ') { $k++ }
                    if ($k -lt $n -and '([{.|<'.Contains($s[$k])) { $i = $k + 1 } else { $i = $j }; continue
                }
                if ($cmd -match '^(right|bigr|Bigr|biggr|Biggr)$') {
                    $lr--; $k = $j; while ($k -lt $n -and $s[$k] -eq ' ') { $k++ }
                    if ($k -lt $n -and ')]}.|>'.Contains($s[$k])) { $i = $k + 1 } else { $i = $j }; continue
                }
                $i = $j; continue   # other command: skip its name (its {} args still count)
            } else { $i++; continue }
        }
        switch -CaseSensitive ($ch) {
            '{' { $brace++ } '}' { $brace--; if ($brace -lt 0) { $neg = $true } }
            '[' { $brack++ } ']' { $brack--; if ($brack -lt 0) { $neg = $true } }
            '(' { $paren++ } ')' { $paren--; if ($paren -lt 0) { $neg = $true } }
        }
        $i++
    }
    [pscustomobject]@{
        full          = ($brace -eq 0 -and $brack -eq 0 -and $paren -eq 0 -and $lr -eq 0 -and -not $neg)
        braceBalanced = ($brace -eq 0)
        brace = $brace; brack = $brack; paren = $paren; lr = $lr; everNegative = $neg
    }
}
