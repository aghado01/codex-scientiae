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

# ── shared math-structure predicates ──────────────────────────────────────────
# One home for the checks several layers need, so independent derivations of the same property can't
# drift apart: the chunk-level fidelity grader (Get-CorruptionType), the assembled closure scanner
# (Find-MathClosureIssues), and the normalize fixer (Repair-MathAlignment) all read from here.

# Alignment tab (&) outside an alignment environment is a hard KaTeX/MathJax parse error. \\ alone is a
# legal display line break (untouched); \& is a literal ampersand (untouched). This is the *detector*;
# Repair-MathAlignment in normalize.ps1 is the matching *fixer* and consumes this same predicate.
function Test-AlignmentOutsideEnv([string]$math) {
    return ($math -match '(?<!\\)&' -and $math -notmatch '\\begin\s*\{')
}

# Is this span math, not prose? \text{...}/\operatorname{...} carry intentional natural-language labels
# (find, minimize, such that) inside legitimate math — feasibility programs, aligned derivations — so
# strip them whole before counting; then command names; more than a couple of 4+ letter words left
# means it's natural language. Balance alone can't tell (prose has no delimiters and reads "balanced").
function Test-IsMath([string]$s) {
    $t = $s -replace '\\(?:text|operatorname|mathrm|mbox|textrm|textbf|textit)\s*\{[^{}]*\}', ' '
    $t = $t -replace '\\[A-Za-z]+', ' '
    return (([regex]::Matches($t, '[A-Za-z]{4,}')).Count -le 2)
}
