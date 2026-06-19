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
# Level Row (display-formula row breaks in Get-UnbledFormula): also counts prose inside \text{...} as
# prose — the old Test-MathRow strip-list behaviour, now on the shared mask algebra.
function Get-TextInteriorMask([string]$s) {
    $list = [System.Collections.Generic.List[object]]::new()
    foreach ($m in [regex]::Matches($s, '\\text\s*\{([^{}]*)\}')) {
        $g = $m.Groups[1]
        if ($g.Length -gt 0) { $list.Add([pscustomobject]@{ Start = $g.Index; End = $g.Index + $g.Length }) }
    }
    return (New-Mask -Spans $list.ToArray() -Over $s)
}

function Test-IsMath([string]$s, [ValidateSet('Chunk', 'Row')][string]$Level = 'Chunk') {
    $structure   = Get-MathStructureMask $s
    $proseRegion = Complement-Mask $structure
    if ($Level -eq 'Row') { $proseRegion = Union-Mask $proseRegion (Get-TextInteriorMask $s) }
    $prose = Get-MaskDensity -Text $s -Within $proseRegion -Register $script:RxProseWord
    return ($prose -le 2)
}

# The math-structure OVERLAY as a Mask — the math-by-content derivation the agreement layer consumes.
# Exposed here (beside Test-IsMath, the SAME $script:RxMathStructure it scores) so "is-this-math" has a
# single home and the agreement readout cannot drift from the fidelity grader. Pure; adds no primitive.
function Get-MathStructureMask([string]$s) { return (New-Mask $s $script:RxMathStructure) }

# Inline $...$ spans already wrapped (the SAME pattern normalize uses for math_dirt's dollar overlay).
# Display $$...$$ is part of RxMathStructure but excluded here — prose chunks carry inline $ only.
$script:RxInlineDollar = [regex]'\$[^$\n]+\$'
function Get-InlineMathMask([string]$s) { return (New-Mask $s $script:RxInlineDollar) }

# Mask → body-light issue spans [{start, end}, ...] for the work-order (half-open UTF-16 offsets).
function Get-MaskSpanRecords($Mask) {
    return @($Mask.Spans | ForEach-Object { [pscustomobject]@{ start = [int]$_.Start; end = [int]$_.End } })
}

# Math-structure extent minus already-wrapped inline $...$ — the difference-localization for unwrapped math.
function Get-UnwrappedMathStructureMask([string]$s) {
    return (Sub-Mask (Get-MathStructureMask $s) (Get-InlineMathMask $s))
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

# Environment CLOSURE balance — the \begin{...}/\end{...} invariant Get-LatexBalance cannot see. That
# scanner counts braces/brackets/parens/\left\right; the {aligned} of \begin{aligned} is itself brace-
# balanced, so an environment whose \end was carried off with a degenerate tail scores .full=true and
# slips the delimiter gate, then breaks the math parser downstream. This is the name-aware nesting check:
# each \begin pushes its name, each \end must close the innermost matching name. Returns balanced + the
# first fault { kind, name, index } (kind: unclosed_begin | dangling_end | mismatched_end) for the seam
# diagnostic and the repair span. Empty when there are no \begin/\end tokens (the common case) — cheap,
# and fires only where environment syntax is actually present and broken.
function Get-EnvironmentBalance([string]$s) {
    $stack = [System.Collections.Generic.Stack[object]]::new()
    $fault = $null
    foreach ($m in [regex]::Matches($s, '\\(begin|end)\s*\{([^{}]*)\}')) {
        $name = $m.Groups[2].Value.Trim()
        if ($m.Groups[1].Value -eq 'begin') {
            $stack.Push([pscustomobject]@{ name = $name; index = $m.Index })
        }
        elseif ($stack.Count -eq 0) {
            if (-not $fault) { $fault = [pscustomobject]@{ kind = 'dangling_end'; name = $name; index = $m.Index } }
        }
        elseif ($stack.Peek().name -ne $name) {
            if (-not $fault) { $fault = [pscustomobject]@{ kind = 'mismatched_end'; name = $name; index = $m.Index } }
            [void]$stack.Pop()
        }
        else { [void]$stack.Pop() }
    }
    if (-not $fault -and $stack.Count -gt 0) {
        $open = @($stack.ToArray())[-1]   # bottom of the stack = the earliest \begin still unclosed
        $fault = [pscustomobject]@{ kind = 'unclosed_begin'; name = $open.name; index = $open.index }
    }
    return [pscustomobject]@{ balanced = (-not $fault); fault = $fault }
}

# Repair hint for an unclosed/dangling/mismatched environment: from the orphaned \begin (or dangling \end)
# the balance fault names, to end-of-chunk — where the missing \end{<name>} is added (or the stray removed).
function Get-UnclosedEnvironmentSpans([string]$content) {
    if (-not $content) { return @() }
    $bal = Get-EnvironmentBalance $content
    if ($bal.balanced) { return @() }
    return @([pscustomobject]@{ start = [int]$bal.fault.index; end = $content.Length })
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

# Same Sub(bareAmp, env) geometry as Test-AlignmentOutsideEnv — difference-localization for work-order spans.
function Get-AlignmentOutsideEnvSpans([string]$math) {
    $env     = New-Mask -Spans (Get-EnvironmentSpans $math) -Over $math
    $bareAmp = New-Mask $math '(?<!\\)&'
    return (Get-MaskSpanRecords (Sub-Mask $bareAmp $env))
}

# Prose-word hits outside the math-structure overlay — the SAME register Test-IsMath scores.
function Get-ProseInFormulaSpans([string]$s) {
    $structure = Get-MathStructureMask $s
    $proseRegion = Complement-Mask $structure
    return (Get-MaskSpanRecords (Get-MaskDensity -Text $s -Within $proseRegion -Register $script:RxProseWord -AsSpans))
}

# Repair hint from the first open/extra delimiter named in Get-LatexBalance's seam diagnostic.
function Get-UnbalancedDelimiterSpans([string]$content) {
    if (-not $content) { return @() }
    $b = Get-LatexBalance $content
    $start = 0
    if ($b.lr -ne 0) {
        $pat = if ($b.lr -gt 0) { '\\left\b' } else { '\\right\b' }
        $m = [regex]::Match($content, $pat); if ($m.Success) { $start = $m.Index }
    }
    elseif ($b.paren -ne 0) {
        $pat = if ($b.paren -gt 0) { '(?<!\\)\(' } else { '(?<!\\)\)' }
        $m = [regex]::Match($content, $pat); if ($m.Success) { $start = $m.Index }
    }
    elseif ($b.brace -ne 0) {
        $pat = if ($b.brace -gt 0) { '(?<!\\)\{' } else { '(?<!\\)\}' }
        $m = [regex]::Match($content, $pat); if ($m.Success) { $start = $m.Index }
    }
    elseif ($b.brack -ne 0) {
        $pat = if ($b.brack -gt 0) { '(?<!\\)\[' } else { '(?<!\\)\]' }
        $m = [regex]::Match($content, $pat); if ($m.Success) { $start = $m.Index }
    }
    return @([pscustomobject]@{ start = [int]$start; end = $content.Length })
}

function Get-IntertextSpans([string]$content) {
    $i = $content.IndexOf('\intertext')
    if ($i -lt 0) { return @() }
    return @([pscustomobject]@{ start = $i; end = $content.Length })
}

function Get-ReplacementCharSpans([string]$content) {
    $fffd = [char]0xFFFD
    $list = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $content.Length; $i++) {
        if ($content[$i] -eq $fffd) { $list.Add([pscustomobject]@{ start = $i; end = $i + 1 }) }
    }
    return $list.ToArray()
}

function Get-LigatureSpans([string]$content) {
    return (Get-MaskSpanRecords (New-Mask $content '[ﬀ-ﬄ]'))
}
