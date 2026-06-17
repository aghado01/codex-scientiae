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

. "$PSScriptRoot/masks.ps1"   # the mask algebra the math-vs-prose / alignment predicates are built from

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

# ── shared math-structure predicates — built by construction on the mask algebra ──────────────────
# One home for the checks several layers need, so independent derivations of the same property can't
# drift apart: the chunk-level fidelity grader (Get-CorruptionType), the assembled closure scanner
# (Find-MathClosureIssues), and the normalize fixer (Repair-MathAlignment) all read from here. The mask
# algebra REPLACES the predicate's shared-home role (it is not a second home beside it): precision lives
# in the set operation (complement / subtract), not in a brittle strip-list.

# The math-structure OVERLAY (coarse, high-recall). Each alternative grabs one kind of structure; the
# union is the overlay, and the PROSE signal is natural-language density in its COMPLEMENT. The env NAME
# (aligned/cases/array) lives inside \begin{...} and \cmd{...}, so it is masked here and never reaches
# the prose count — the reproduced "multi-environment formula called prose" false positive is gone by
# CONSTRUCTION, not because anyone remembered to strip those names.
$script:RxMathStructure = [regex]::new(
    '\$\$[\s\S]*?\$\$' +               # display math
    '|\$[^$\n]+\$' +                   # inline math
    '|\\(?:begin|end)\s*\{[^{}]*\}' +  # environment delimiter + its NAME
    '|\\[A-Za-z]+\s*\{[^{}]*\}' +      # \cmd{...} : command + braced argument (\frac{...}, \text{...})
    '|[_^]\s*\{[^{}]*\}' +             # sub/superscript group  x^{...}  _{...}
    '|\\[A-Za-z]+'                     # bare command / sizing-delimiter run (\alpha \sum \left \\)
)
$script:RxProseWord = [regex]'[A-Za-z]{4,}'   # a 4+-letter run reads as a natural-language word

# Is this span math, not prose? (MultiLine: the whole chunk is one extent.) Density of prose words in
# the COMPLEMENT of the math-structure overlay — more than a couple of natural-language words left over
# means it is prose. Balance alone can't tell (prose has no delimiters and reads "balanced"). Threshold
# (<=2) and decision boundary are unchanged from the strip-list version; only WHAT gets counted changed
# — env names, command names and braced arguments are now masked by the overlay, so they can't leak.
function Test-IsMath([string]$s) {
    $structure  = New-Mask $s $script:RxMathStructure
    $prose      = Get-MaskDensity -Text $s -Within (Complement-Mask $structure) -Register $script:RxProseWord
    return ($prose -le 2)
}

# Environment COVERAGE spans (\begin{...}...\end{...}), by a nesting stack like Get-LatexBalance's scan:
# each \begin opens, each \end closes the innermost; an unclosed \begin covers to end-of-string (an open
# environment still contains a trailing &, so we don't flag it — preserves the old \begin-present pass).
# Name-agnostic (count-based), so nested aligned/cases coalesce into one covered extent on union.
function Get-EnvironmentSpans([string]$s) {
    $spans = [System.Collections.Generic.List[object]]::new()
    $stack = [System.Collections.Generic.Stack[int]]::new()
    foreach ($m in [regex]::Matches($s, '\\(begin|end)\s*\{[^{}]*\}')) {
        if ($m.Groups[1].Value -eq 'begin') { $stack.Push($m.Index) }
        elseif ($stack.Count -gt 0) { $spans.Add([pscustomobject]@{ Start = $stack.Pop(); End = $m.Index + $m.Length }) }
    }
    while ($stack.Count -gt 0) { $spans.Add([pscustomobject]@{ Start = $stack.Pop(); End = $s.Length }) }
    return , $spans.ToArray()   # comma-wrap so an empty result stays an array, not $null
}

# Alignment tab (&) outside an alignment environment is a hard KaTeX/MathJax parse error. The bare-& mask
# minus the environment overlay is the set of &'s no \begin{...}...\end{...} span covers — flagged even
# when another environment exists elsewhere in the chunk (the old whole-chunk "\begin present?" test
# missed that; this fixes the recall hole, level-local by construction). \\ is a legal line break
# (untouched); \& is a literal ampersand (excluded by the negative lookbehind). This is the *detector*;
# Repair-MathAlignment in normalize.ps1 is the matching *fixer* and consumes this same predicate.
function Test-AlignmentOutsideEnv([string]$math) {
    $env     = New-Mask -Spans (Get-EnvironmentSpans $math) -Over $math
    $bareAmp = New-Mask $math '(?<!\\)&'
    return (-not (Test-MaskEmpty (Sub-Mask $bareAmp $env)))
}
