#requires -Version 7.0
<#
  src/latex-ingest.ps1 — arXiv LaTeX source -> codex-scientiae markdown, end to end.

  The tractable top rung of the transcription stack: for arXiv papers we stage the LaTeX `source` artifact,
  and LaTeX is already structured — so unlike the PDF geometry problem, this is a parse/transform, and the
  MATH PASSES THROUGH as primitive LaTeX ($...$ / $$...$$ ARE the codex standard), sidestepping the membrane's
  math-repair problem. Because LaTeX is the AUTHORITATIVE source, the output is a fidelity GROUND TRUTH for
  measuring lossy PDF->IR conversions against (see src/conversion-metric.ps1).

  Architecture mirrors the membrane's principled approach:
    EXPAND macros (\newcommand reach inside math) -> RESOLVE numbering (\cite/\ref/\eqref, theorem/eq labels)
    -> PROTECT math spans (env-aware: alignment envs wrap in \begin{aligned} so &/\\ are valid)
    -> TRANSFORM structure (title/sections/theorems/lists/refs) -> RESTORE math.
  In-house (no pandoc/latexml dependency). Known rough edges: tables, deeply-nested optional-arg macros,
  multi-file submissions beyond one \input level, non-UTF8 sources.

  Entry point: Invoke-ArxivLatexToMarkdown -TarGz <source.tar.gz> -Slug <name> -OutDir <dir>
#>

. "$PSScriptRoot/runs.ps1"          # the run layout: tarballs unpack into {tar-dir}/.runs/{stamp}/tex like every other intermediate
. "$PSScriptRoot/tikz-render.ps1"   # source-authoritative diagrams: TikZ -> SVG via node-tikzjax (graceful when absent)

# --- brace-aware primitives -------------------------------------------------------------------------
function Get-LatexBracedArg {
    param([string]$Text, [int]$OpenBraceIndex)
    $depth = 0
    for ($i = $OpenBraceIndex; $i -lt $Text.Length; $i++) {
        $c = $Text[$i]
        if ($c -eq '{') { $depth++ } elseif ($c -eq '}') { $depth--; if ($depth -eq 0) { return $Text.Substring($OpenBraceIndex + 1, $i - $OpenBraceIndex - 1) } }
    }
    return $null
}
function Get-BraceGroupEnd {
    param([string]$T, [int]$Open)   # index just past the matching close brace, or -1
    $d = 0; for ($j = $Open; $j -lt $T.Length; $j++) { if ($T[$j] -eq '{') { $d++ } elseif ($T[$j] -eq '}') { $d--; if ($d -eq 0) { return $j + 1 } } }
    return -1
}
function Get-LatexCommandArg {
    param([string]$Text, [string]$Command)   # e.g. '\title'
    $m = [regex]::Match($Text, [regex]::Escape($Command) + '\s*\{')
    if (-not $m.Success) { return $null }
    return Get-LatexBracedArg $Text ($m.Index + $m.Length - 1)
}
function Replace-BracedCommand {
    param([string]$T, [string]$Cmd, [scriptblock]$Fmt)   # replace every \Cmd{...} with &Fmt($arg)
    while ($true) {
        $m = [regex]::Match($T, [regex]::Escape($Cmd) + '\s*\{')
        if (-not $m.Success) { break }
        $open = $m.Index + $m.Length - 1; $end = Get-BraceGroupEnd $T $open
        if ($end -lt 0) { break }
        $arg = $T.Substring($open + 1, $end - $open - 2)
        $T = $T.Substring(0, $m.Index) + (& $Fmt $arg) + $T.Substring($end)
    }
    return $T
}
function Convert-BorderMatrix {
    param([string]$T)   # plain-TeX \bordermatrix (KaTeX-unsupported) -> ruled array; brace-aware (bodies hold \frac{}{})
    while ($true) {
        $m = [regex]::Match($T, '\\bordermatrix\s*\{')
        if (-not $m.Success) { break }
        $open = $m.Index + $m.Length - 1; $end = Get-BraceGroupEnd $T $open
        if ($end -lt 0) { break }
        $inner = $T.Substring($open + 1, $end - $open - 2)
        $rows = @(($inner -split '\\cr') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
        if ($rows.Count) {
            $rows[0] = $rows[0] -replace '^\s*~\s*', ' '                 # top-left corner cell -> empty
            $spec = 'c|' + ('c' * ([regex]::Matches($rows[0], '&').Count))
            $data = if ($rows.Count -gt 1) { ($rows[1..($rows.Count - 1)] -join ' \\ ') + ' \\ ' } else { '' }
            $out = "\begin{array}{$spec} " + $rows[0] + " \\ \hline " + $data + "\end{array}"
        } else { $out = '' }
        $T = $T.Substring(0, $m.Index) + $out + $T.Substring($end)
    }
    return $T
}

function Convert-Tabular {
    param([string]$Spec, [string]$Body)   # basic {tabular} -> GitHub markdown table (data tables; image grids are handled separately)
    $Body = $Body -replace '\\(?:hline|toprule|midrule|bottomrule)\b', '' -replace '\\cline\{[^}]*\}', ''
    $Body = [regex]::Replace($Body, '\\multicolumn\{\d+\}\{[^}]*\}\{([^{}]*)\}', '$1')
    $s = $Spec -replace '\|', '' -replace '[@<>]\{[^}]*\}', '' -replace '[pmb]\{[^}]*\}', 'X'
    $ncol = ($s -replace '[^clrX]', '').Length
    if ($ncol -lt 1) { $ncol = 1 }
    $rows = @([regex]::Split($Body, '\\\\') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
    if (-not $rows.Count) { return '' }
    $out = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $rows.Count; $i++) {
        $cells = @([regex]::Split($rows[$i], '(?<!\\)&') | ForEach-Object { $_.Trim() -replace '\\&', '&' })
        while ($cells.Count -lt $ncol) { $cells += '' }
        $out.Add('| ' + (($cells[0..($ncol - 1)]) -join ' | ') + ' |')
        if ($i -eq 0) { $out.Add('| ' + ((1..$ncol | ForEach-Object { '---' }) -join ' | ') + ' |') }
    }
    return "`n`n" + ($out -join "`n") + "`n`n"
}

# --- algorithmic (algpseudocode) -> fenced pseudocode. The \State/\If/\While furniture is not markdown, so
# render it as a titled ```text``` block with keywords + indentation and the (simple) inline math flattened to
# unicode. Parallel arrays not a hashtable: PS hash keys are case-insensitive so \delta/\Delta would collide;
# substituted with -creplace since LaTeX command case is significant. ---------------------------------------
$script:AlgKeys = @('gets', 'leftarrow', 'to', 'rightarrow', 'Rightarrow', 'mapsto', 'leq', 'le', 'geq', 'ge', 'neq', 'ne', 'times', 'cdot', 'div', 'cdots', 'ldots', 'dots', 'vdots', 'ddots', 'in', 'notin', 'subseteq', 'subset', 'supseteq', 'cup', 'cap', 'emptyset', 'varnothing', 'setminus', 'infty', 'pm', 'approx', 'equiv', 'land', 'wedge', 'lor', 'vee', 'neg', 'lnot', 'forall', 'exists', 'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'varepsilon', 'lambda', 'mu', 'sigma', 'tau', 'phi', 'omega', 'Delta', 'Sigma', 'Omega', 'Lambda', 'Phi', 'langle', 'rangle', 'lceil', 'rceil', 'lfloor', 'rfloor', 'backslash')
$script:AlgVals = @('←', '←', '→', '→', '⇒', '↦', '≤', '≤', '≥', '≥', '≠', '≠', '×', '·', '÷', '⋯', '…', '…', '⋮', '⋱', '∈', '∉', '⊆', '⊂', '⊇', '∪', '∩', '∅', '∅', '∖', '∞', '±', '≈', '≡', '∧', '∧', '∨', '∨', '¬', '¬', '∀', '∃', 'α', 'β', 'γ', 'δ', 'ε', 'ε', 'λ', 'μ', 'σ', 'τ', 'φ', 'ω', 'Δ', 'Σ', 'Ω', 'Λ', 'Φ', '⟨', '⟩', '⌈', '⌉', '⌊', '⌋', '∖')
function Flatten-AlgText {
    param([string]$s)
    if (-not $s) { return '' }
    for ($i = 0; $i -lt 4; $i++) { $s = [regex]::Replace($s, '\\(?:text|textrm|textnormal|mathrm|mathbf|textbf|textit|textsl|textsc|emph|mathcal|mathbb|mathit|mathsf|mathtt|operatorname\*?)\s*\{([^{}]*)\}', '$1') }
    for ($i = 0; $i -lt $script:AlgKeys.Count; $i++) { $s = $s -creplace ('\\' + $script:AlgKeys[$i] + '(?![a-zA-Z])'), $script:AlgVals[$i] }
    $s = $s -replace '\\left', '' -replace '\\right', ''
    $s = $s -replace '\\\{', '{' -replace '\\\}', '}' -replace '\\,|\\;|\\:|\\!', ' ' -replace '\\ ', ' '
    $s = $s -replace '\$', '' -replace '~', ' '
    $s = [regex]::Replace($s, ' *([←→⇒↦≤≥≠×·÷∈∉∪∩∖]) *', ' $1 ')
    $s = [regex]::Replace($s, '[ \t]{2,}', ' ')
    return $s.Trim()
}
function Get-AlgCond {
    param($Line, $Cmd)
    $m = [regex]::Match($Line, [regex]::Escape($Cmd) + '\s*\{')
    if (-not $m.Success) { return (Flatten-AlgText ($Line -replace ('^' + [regex]::Escape($Cmd) + '\s*'), '')) }
    $a = Get-LatexBracedArg $Line ($m.Index + $m.Length - 1)
    return (Flatten-AlgText $(if ($null -ne $a) { $a } else { '' }))
}
function Get-AlgFn {
    param($Line, $Cmd)
    $m = [regex]::Match($Line, [regex]::Escape($Cmd) + '\s*\{'); if (-not $m.Success) { return '' }
    $o1 = $m.Index + $m.Length - 1; $name = Get-LatexBracedArg $Line $o1; $e1 = Get-BraceGroupEnd $Line $o1
    $args = ''; if ($e1 -ge 0) { $rest = $Line.Substring($e1); $m2 = [regex]::Match($rest, '^\s*\{'); if ($m2.Success) { $args = Get-LatexBracedArg $rest ($m2.Index + $m2.Length - 1) } }
    return (Flatten-AlgText $name) + '(' + (Flatten-AlgText $args) + ')'
}
function Format-Algorithmic {
    param([string]$Body, [bool]$Ordered = $false)
    # Emission is a NESTED MARKDOWN LIST, not a code fence: algorithmic renders in the PDF as numbered,
    # indented lines with bold keywords and live math — never monospace — so a fence would misstate the
    # source presentation AND kill math rendering. $Ordered mirrors the source's own choice: \begin{algorithmic}[1]
    # asks for line numbers (ordered list), bare algorithmic renders unnumbered (bullets). Math rides
    # through as @@LMATHn@@ placeholders (protection precedes this) and is restored $-delimited, so
    # subscripts/wrappers render exactly as in body prose — one expression, one token stream.
    $Body = $Body -replace '\\label\{[^{}]*\}', '' -replace '(?m)^\s*%.*$', ''
    $cmds = 'Statex|State|Require|Ensure|Return|ElsIf|Else|EndIf|If|EndWhile|While|ForAll|EndFor|For|EndProcedure|Procedure|EndFunction|Function|Repeat|Until|EndLoop|Loop'
    $Body = [regex]::Replace($Body, "\\($cmds)(?![a-zA-Z])", "`n`$0")
    $lines = ($Body -split "`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
    $indent = if ($Ordered) { '   ' } else { '  ' }   # child must reach the parent marker's content column (3 for '1. ', 2 for '- ')
    $marker = if ($Ordered) { '1. ' } else { '- ' }
    $depth = 0; $out = New-Object System.Collections.Generic.List[string]
    foreach ($raw in $lines) {
        $ln = $raw; $comment = ''
        $cm = [regex]::Match($ln, '\\Comment\s*\{')
        if ($cm.Success) { $o = $cm.Index + $cm.Length - 1; $a = Get-LatexBracedArg $ln $o; $e = Get-BraceGroupEnd $ln $o; if ($null -ne $a -and $e -ge 0) { $comment = Flatten-AlgText $a; $ln = ($ln.Substring(0, $cm.Index) + $ln.Substring($e)).Trim() } }
        $d = $depth; $next = $depth; $text = $null
        switch -regex ($ln) {
            '^\\Statex\b' { $text = Flatten-AlgText ($ln -replace '^\\Statex\s*', ''); break }
            '^\\State\b' { $text = Flatten-AlgText ($ln -replace '^\\State\s*', ''); break }
            '^\\Require\b' { $text = '**Require:** ' + (Flatten-AlgText ($ln -replace '^\\Require\s*', '')); break }
            '^\\Ensure\b' { $text = '**Ensure:** ' + (Flatten-AlgText ($ln -replace '^\\Ensure\s*', '')); break }
            '^\\Return\b' { $text = '**return** ' + (Flatten-AlgText ($ln -replace '^\\Return\s*', '')); break }
            '^\\ElsIf\b' { $d = [Math]::Max(0, $depth - 1); $text = '**else if** ' + (Get-AlgCond $ln '\ElsIf') + ' **then**'; break }
            '^\\Else\b' { $d = [Math]::Max(0, $depth - 1); $text = '**else**'; break }
            '^\\EndIf\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**end if**'; break }
            '^\\If\b' { $text = '**if** ' + (Get-AlgCond $ln '\If') + ' **then**'; $next = $depth + 1; break }
            '^\\EndWhile\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**end while**'; break }
            '^\\While\b' { $text = '**while** ' + (Get-AlgCond $ln '\While') + ' **do**'; $next = $depth + 1; break }
            '^\\ForAll\b' { $text = '**for all** ' + (Get-AlgCond $ln '\ForAll') + ' **do**'; $next = $depth + 1; break }
            '^\\EndFor\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**end for**'; break }
            '^\\For\b' { $text = '**for** ' + (Get-AlgCond $ln '\For') + ' **do**'; $next = $depth + 1; break }
            '^\\Repeat\b' { $text = '**repeat**'; $next = $depth + 1; break }
            '^\\Until\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**until** ' + (Get-AlgCond $ln '\Until'); break }
            '^\\Loop\b' { $text = '**loop**'; $next = $depth + 1; break }
            '^\\EndLoop\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**end loop**'; break }
            '^\\EndFunction\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**end function**'; break }
            '^\\Function\b' { $text = '**function** ' + (Get-AlgFn $ln '\Function'); $next = $depth + 1; break }
            '^\\EndProcedure\b' { $depth = [Math]::Max(0, $depth - 1); $d = $depth; $next = $depth; $text = '**end procedure**'; break }
            '^\\Procedure\b' { $text = '**procedure** ' + (Get-AlgFn $ln '\Procedure'); $next = $depth + 1; break }
            default { $text = Flatten-AlgText $ln }
        }
        if ($null -eq $text) { $text = '' }
        $content = $text.Trim()
        if ($content -eq '' -and $comment -ne '' -and $out.Count -gt 0) {
            $out[$out.Count - 1] = $out[$out.Count - 1].TrimEnd() + ' ▷ *' + $comment + '*'
        } elseif ($content -ne '' -or $comment -ne '') {
            if ($comment) { $content = ($content + ' ▷ *' + $comment + '*').Trim() }
            $out.Add(($indent * $d) + $marker + $content)
        }
        $depth = $next
    }
    return ($out -join "`n")
}
$script:AlgStore = @{}
$script:AlgStoreIdx = 0
function Convert-Algorithms {
    param([string]$T)
    # stash each rendered algorithm as a placeholder and restore AFTER all text passes — the dedent
    # pass would otherwise strip the nested-list indentation that encodes pseudocode depth.
    $script:AlgStore = @{}; $script:AlgStoreIdx = 0; $script:algCounter = 0
    $T = [regex]::Replace($T, '(?s)\\begin\{algorithm\*?\}(?:\[[^\]]*\])?(.*?)\\end\{algorithm\*?\}', {
            param($m)
            $script:algCounter++
            $inner = $m.Groups[1].Value; $cap = ''
            $cm = [regex]::Match($inner, '\\caption\s*\{')
            if ($cm.Success) {
                $o = $cm.Index + $cm.Length - 1
                $a = Get-LatexBracedArg $inner $o; $e = Get-BraceGroupEnd $inner $o
                if ($null -ne $a -and $e -ge 0) { $cap = (Flatten-AlgText $a); $inner = $inner.Substring(0, $cm.Index) + $inner.Substring($e) }
            }
            $list = ''
            $bm = [regex]::Match($inner, '(?s)\\begin\{algorithmic\}(?:\[([^\]]*)\])?(.*?)\\end\{algorithmic\}')
            if ($bm.Success) {
                $list = Format-Algorithmic $bm.Groups[2].Value ($bm.Groups[1].Success -and $bm.Groups[1].Value.Trim() -ne '')
                $inner = $inner.Remove($bm.Index, $bm.Length)
            }
            $title = if ($cap) { "**Algorithm $($script:algCounter): $cap**" } else { "**Algorithm $($script:algCounter)**" }
            $id = "@@ALG$($script:AlgStoreIdx)@@"; $script:AlgStoreIdx++
            $script:AlgStore[$id] = $title + $(if ($list) { "`n`n$list" } else { '' })
            # float content that is NOT the caption/algorithmic (enumerate-style pseudocode, prose) stays
            # INLINE so the downstream passes convert it — it used to be discarded wholesale with the float.
            "`n`n$id`n`n" + $inner.Trim() + "`n`n"
        })
    $T = [regex]::Replace($T, '(?s)\\begin\{algorithmic\}(?:\[([^\]]*)\])?(.*?)\\end\{algorithmic\}', {
            param($m)
            $id = "@@ALG$($script:AlgStoreIdx)@@"; $script:AlgStoreIdx++
            $script:AlgStore[$id] = Format-Algorithmic $m.Groups[2].Value ($m.Groups[1].Success -and $m.Groups[1].Value.Trim() -ne '')
            "`n`n$id`n`n"
        })
    return $T
}
function Restore-Algorithms {
    param([string]$T)
    # Algorithm blocks were captured with math already protected, so the stashed lists still hold
    # @@LMATHn@@ placeholders — and the body-level Restore-LatexMath ran before this (it must: the
    # dedent pass would shred list indentation if blocks were restored first). Restore math INSIDE
    # each stashed block here, so pseudocode carries its $-delimited math live.
    foreach ($id in $script:AlgStore.Keys) { $T = $T.Replace($id, (Restore-LatexMath $script:AlgStore[$id])) }
    # verbatim-family fences were stashed BEFORE comment-strip/macros/math-protection: byte-verbatim,
    # no placeholders inside by construction — plain swap.
    foreach ($id in $script:VerbStore.Keys) { $T = $T.Replace($id, $script:VerbStore[$id]) }
    return $T
}

# --- verbatim-family code: the ONLY constructs the PDF really presents as monospace blocks, so the ONLY
# ones that become markdown code fences (fence-only-if-monospace). Stashed from the RAW source before
# comment-stripping, macro expansion, and math protection — inside code, `%` is not a comment and `$` is
# not a math delimiter (a PowerShell listing's $env:PATH must survive byte-verbatim). Language tag comes
# from the source's own declaration (lstlisting language= / minted {lang}), else 'text'. ----------------
$script:VerbStore = @{}
$script:VerbStoreIdx = 0
function Add-VerbBlock([string]$Lang, [string]$Code) {
    $id = "@@VERB$($script:VerbStoreIdx)@@"; $script:VerbStoreIdx++
    $code = $Code -replace '^\r?\n', '' -replace '\r?\n[ \t]*$', ''
    $script:VerbStore[$id] = '```' + $Lang.ToLowerInvariant() + "`n" + $code + "`n" + '```'
    return "`n`n$id`n`n"
}
function Protect-VerbatimBlocks {
    param([string]$Text)
    $script:VerbStore = @{}; $script:VerbStoreIdx = 0
    $SL = [System.Text.RegularExpressions.RegexOptions]::Singleline
    $Text = [regex]::Replace($Text, '\\begin\{lstlisting\}(?:\[([^\]]*)\])?(.*?)\\end\{lstlisting\}', {
            param($m) $lm = [regex]::Match($m.Groups[1].Value, 'language\s*=\s*(?:\[[^\]]*\])?\s*([A-Za-z][A-Za-z0-9+#]*)')
            Add-VerbBlock $(if ($lm.Success) { $lm.Groups[1].Value } else { 'text' }) $m.Groups[2].Value }, $SL)
    $Text = [regex]::Replace($Text, '\\begin\{minted\}(?:\[[^\]]*\])?\{([^{}]+)\}(.*?)\\end\{minted\}', {
            param($m) Add-VerbBlock $m.Groups[1].Value $m.Groups[2].Value }, $SL)
    $Text = [regex]::Replace($Text, '\\begin\{(verbatim|Verbatim|alltt)\*?\}(?:\[[^\]]*\])?(.*?)\\end\{\1\*?\}', {
            param($m) Add-VerbBlock 'text' $m.Groups[2].Value }, $SL)
    return $Text
}

# --- macro expansion: the key to faithful math. arXiv papers define many \newcommand macros used INSIDE
# math; KaTeX cannot render \R, \eps, \norm{} without the definitions. Parse the preamble definitions and
# expand them in the body to a fixed point (macros reference macros), yielding primitive LaTeX. ----------
function Get-LatexMacros {
    param([string]$Tex)
    $macros = [ordered]@{}
    $rx = [regex]'\\(?:newcommand|renewcommand|providecommand)\s*\{?\s*\\([A-Za-z]+|.)\s*\}?\s*(?:\[(\d+)\])?\s*(?:\[([^\]]*)\])?\s*\{'
    foreach ($m in $rx.Matches($Tex)) {
        $name = $m.Groups[1].Value
        $nargs = if ($m.Groups[2].Success) { [int]$m.Groups[2].Value } else { 0 }
        $opt = if ($m.Groups[3].Success) { $m.Groups[3].Value } else { $null }
        $body = Get-LatexBracedArg $Tex ($m.Index + $m.Length - 1)
        if ($null -ne $body) { $macros[$name] = [pscustomobject]@{ nargs = $nargs; opt = $opt; body = $body } }
    }
    foreach ($m in ([regex]'\\DeclareMathOperator\*?\s*\{?\s*\\([A-Za-z]+)\s*\}?\s*\{').Matches($Tex)) {   # braces around the operator name are optional
        $name = $m.Groups[1].Value; $body = Get-LatexBracedArg $Tex ($m.Index + $m.Length - 1)
        if ($null -ne $body) { $macros[$name] = [pscustomobject]@{ nargs = 0; opt = $null; body = "\operatorname{$body}" } }
    }
    return $macros
}
function Expand-LatexMacros {
    param([string]$Text, $Macros, [int]$MaxPasses = 10)
    if (-not $Macros -or $Macros.Count -eq 0) { return $Text }
    for ($pass = 0; $pass -lt $MaxPasses; $pass++) {
        $changed = $false
        foreach ($name in @($Macros.Keys)) {
            $def = $Macros[$name]
            $pat = if ($name -match '^[A-Za-z]+$') { '\\' + [regex]::Escape($name) + '(?![A-Za-z])' } else { '\\' + [regex]::Escape($name) }
            $sb = [System.Text.StringBuilder]::new(); $pos = 0
            foreach ($m in ([regex]$pat).Matches($Text)) {
                if ($m.Index -lt $pos) { continue }
                [void]$sb.Append($Text.Substring($pos, $m.Index - $pos))
                $cur = $m.Index + $m.Length; $args = @(); $ok = $true
                if ($null -ne $def.opt) {   # optional [..] arg (use default if absent)
                    $sk = $cur; while ($sk -lt $Text.Length -and $Text[$sk] -eq ' ') { $sk++ }
                    if ($sk -lt $Text.Length -and $Text[$sk] -eq '[') { $cl = $Text.IndexOf(']', $sk); if ($cl -ge 0) { $args += $Text.Substring($sk + 1, $cl - $sk - 1); $cur = $cl + 1 } else { $args += $def.opt } } else { $args += $def.opt }
                }
                while ($args.Count -lt $def.nargs) {   # mandatory args (brace group, \cmd, or single char)
                    while ($cur -lt $Text.Length -and $Text[$cur] -eq ' ') { $cur++ }
                    if ($cur -lt $Text.Length -and $Text[$cur] -eq '{') { $a = Get-LatexBracedArg $Text $cur; if ($null -eq $a) { $ok = $false; break }; $args += $a; $cur = Get-BraceGroupEnd $Text $cur }
                    elseif ($cur -lt $Text.Length -and $Text[$cur] -eq '\') { $e = $cur + 1; while ($e -lt $Text.Length -and [char]::IsLetter($Text[$e])) { $e++ }; $args += $Text.Substring($cur, $e - $cur); $cur = $e }
                    elseif ($cur -lt $Text.Length) { $args += [string]$Text[$cur]; $cur++ } else { $ok = $false; break }
                }
                if (-not $ok) { [void]$sb.Append($Text.Substring($m.Index, $m.Length)); $pos = $m.Index + $m.Length; continue }
                $exp = $def.body; for ($k = $def.nargs; $k -ge 1; $k--) { $exp = $exp.Replace("#$k", [string]$args[$k - 1]) }
                [void]$sb.Append($exp); $pos = $cur; $changed = $true
            }
            [void]$sb.Append($Text.Substring($pos)); $Text = $sb.ToString()
        }
        if (-not $changed) { break }
    }
    return $Text
}

# --- cross-reference numbering: label -> number maps, so \cite/\ref/\eqref resolve to the SAME numbers a
# PDF render shows (the ground truth must match the rendered paper for a fair comparison). ---------------
function Build-LabelMaps {
    param([string]$Body)
    $thm = @{}; $eq = @{}; $tc = 0; $ec = 0   # theorem-family share one counter; numbered eq envs another
    foreach ($m in ([regex]'\\begin\{(theorem|lemma|corollary|proposition|equation|align|gather|multline|eqnarray|alignat)(\*?)\}').Matches($Body)) {
        $env = $m.Groups[1].Value; $star = $m.Groups[2].Value -eq '*'
        $endIdx = $Body.IndexOf('\end{' + $env, $m.Index); $seg = if ($endIdx -ge 0) { $Body.Substring($m.Index, $endIdx - $m.Index) } else { '' }
        $lbl = [regex]::Match($seg, '\\label\{([^{}]+)\}')
        if ($env -in 'theorem', 'lemma', 'corollary', 'proposition') { $tc++; if ($lbl.Success) { $thm[$lbl.Groups[1].Value] = $tc } }
        elseif (-not $star) { $ec++; if ($lbl.Success) { $eq[$lbl.Groups[1].Value] = $ec } }
    }
    return @{ thm = $thm; eq = $eq }
}
function Build-CiteMap {
    param([string]$Bbl)   # \bibitem order = citation number (\bibliographystyle{plain} renders these)
    $map = @{}; $i = 0
    if ($Bbl) { foreach ($m in ([regex]'\\bibitem(?:\[[^\]]*\])?\s*\{([^{}]+)\}').Matches($Bbl)) { $i++; $map[$m.Groups[1].Value] = $i } }
    return $map
}
function Resolve-Refs {
    param([string]$T, $Maps, $CiteMap)
    # consume natbib optional pre/post-notes (\citep[see][p. 7]{key}) — else the [..] brackets leak and read as broken reference links
    $T = [regex]::Replace($T, '\\cite[a-z]*(?:\[[^\]]*\])?(?:\[[^\]]*\])?\s*\{([^{}]+)\}', { param($m) '[' + (($m.Groups[1].Value -split '\s*,\s*' | ForEach-Object { if ($CiteMap.ContainsKey($_)) { $CiteMap[$_] } else { '?' } }) -join ', ') + ']' })
    $T = [regex]::Replace($T, '\\eqref\{([^{}]+)\}', { param($m) $k = $m.Groups[1].Value; if ($Maps.eq.ContainsKey($k)) { "($($Maps.eq[$k]))" } else { '(?)' } })
    $T = [regex]::Replace($T, '\\(?:ref|autoref|cref)\{([^{}]+)\}', { param($m) $k = $m.Groups[1].Value; if ($Maps.thm.ContainsKey($k)) { "$($Maps.thm[$k])" } elseif ($Maps.eq.ContainsKey($k)) { "$($Maps.eq[$k])" } else { '?' } })
    return $T
}

# --- math protection (env-aware): alignment envs wrap in aligned/gathered so the &/\\ stay valid -------
$script:LtxMathStore = @{}
$script:LtxMathIdx = 0
function Store-Math {
    param([string]$Content, [bool]$Display)
    $id = "@@LMATH$($script:LtxMathIdx)@@"; $script:LtxMathIdx++
    # display fenced on its own lines; inline collapses source line-breaks so a span never crosses a blank line
    $script:LtxMathStore[$id] = if ($Display) { "`n`$`$`n$($Content.Trim())`n`$`$`n" } else { '$' + (($Content -replace '\s*\r?\n\s*', ' ').Trim()) + '$' }
    return $id
}
function Protect-LatexMath {
    param([string]$Text)
    $script:LtxMathStore = @{}; $script:LtxMathIdx = 0
    $SL = [System.Text.RegularExpressions.RegexOptions]::Singleline
    foreach ($e in 'align', 'alignat', 'flalign', 'eqnarray', 'split', 'multline') {
        $Text = [regex]::Replace($Text, "\\begin\{$e\*?\}(.*?)\\end\{$e\*?\}", { param($m) Store-Math ("\begin{aligned}`n" + $m.Groups[1].Value.Trim() + "`n\end{aligned}") $true }, $SL)
    }
    $Text = [regex]::Replace($Text, "\\begin\{gather\*?\}(.*?)\\end\{gather\*?\}", { param($m) Store-Math ("\begin{gathered}`n" + $m.Groups[1].Value.Trim() + "`n\end{gathered}") $true }, $SL)
    $Text = [regex]::Replace($Text, "\\begin\{(equation|displaymath|math)\*?\}(.*?)\\end\{\1\*?\}", { param($m) Store-Math ($m.Groups[2].Value.Trim()) $true }, $SL)
    $Text = [regex]::Replace($Text, '\\\[(.*?)\\\]', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $true }, $SL)
    $Text = [regex]::Replace($Text, '(?<=(?:^|[^\\])(?:\\\\)*)\$\$(.*?)\$\$', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $true }, $SL)
    $Text = [regex]::Replace($Text, '\\\((.*?)\\\)', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $false }, $SL)
    $Text = [regex]::Replace($Text, '(?<=(?:^|[^\\])(?:\\\\)*)\$(.+?)(?<!\\)\$', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $false }, $SL)
    return $Text
}
function Restore-LatexMath {
    param([string]$Text)
    # iterate to a fixed point: a stored span can contain another placeholder (nested $..$ around a display
    # placeholder), and hashtable key order is arbitrary — a single ordered pass can re-introduce an already-
    # processed placeholder and leak it. Re-run until none remain (bounded by nesting depth).
    for ($pass = 0; $pass -lt 8 -and ($Text -match '@@LMATH\d+@@'); $pass++) {
        $Text = [regex]::Replace($Text, '@@LMATH\d+@@', { param($m) if ($script:LtxMathStore.Contains($m.Value)) { $script:LtxMathStore[$m.Value] } else { $m.Value } })
    }
    return $Text
}

# --- inline text-command cleanup, accents, old-style {\em ..} (used in body + bib text) ----------------
function Convert-LatexInline {
    param([string]$T)
    $T = $T -replace '\\(?:textbf|textsc)\{([^{}]*)\}', '**$1**'
    $T = $T -replace '\\(?:emph|textit|textsl)\{([^{}]*)\}', '*$1*'
    $T = $T -replace '\\texttt\{([^{}]*)\}', '`$1`'
    $T = $T -replace '\\(?:textrm|textnormal|mbox|text)\{([^{}]*)\}', '$1'
    $T = $T -replace '\\(?:newblock|noindent|maketitle|centering)\b', ''
    $T = $T -replace '\\&', '&' -replace '\\%', '%' -replace '\\_', '_' -replace '\\#', '#' -replace '\\\$', '$'
    $T = $T -replace '~', ' ' -replace '\\,|\\;|\\:|\\!', ' ' -replace '``|''''', '"'
    return $T.Trim()
}
$script:AccentMap = @{ "\'e" = 'é'; "\`e" = 'è'; '\"e' = 'ë'; '\^e' = 'ê'; "\'a" = 'á'; "\`a" = 'à'; '\"a' = 'ä'; "\'o" = 'ó'; '\"o' = 'ö'; "\'i" = 'í'; '\"u' = 'ü'; "\'u" = 'ú'; "\'c" = 'ç'; '\~n' = 'ñ' }
function Apply-Accents {
    param([string]$T)
    foreach ($k in $script:AccentMap.Keys) { $T = $T.Replace($k, $script:AccentMap[$k]) }
    $T = [regex]::Replace($T, "\\([``'^""~])\{([a-zA-Z])\}", { param($m) $key = '\' + $m.Groups[1].Value + $m.Groups[2].Value; if ($script:AccentMap.ContainsKey($key)) { $script:AccentMap[$key] } else { $m.Groups[2].Value } })
    return $T
}

# --- the core transform: LaTeX -> markdown ----------------------------------------------------------
function ConvertFrom-Latex {
    param([string]$Tex, [string]$Bbl)
    $Tex = Protect-VerbatimBlocks $Tex                                         # code is code: stash before % -stripping and $ -protection
    $Tex = [regex]::Replace($Tex, '(?m)(?<!\\)%.*$', '')                       # strip comments
    $macros = Get-LatexMacros $Tex
    $title = Get-LatexCommandArg $Tex '\title'
    $bm = [regex]::Match($Tex, '\\begin\{document\}(.*)\\end\{document\}', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $body = if ($bm.Success) { $bm.Groups[1].Value } else { $Tex }

    # fallback for manually-typeset titles (no \title{}): first {\Large..}/{\LARGE..}/{\huge..} block in the frontmatter
    if (-not $title) {
        $lm = [regex]::Match($body, '\{\s*\\(?:Large|LARGE|huge|Huge)\b')
        if ($lm.Success) {
            $g = Get-LatexBracedArg $body $lm.Index
            if ($g) { $title = (($g -replace '\\(?:Large|LARGE|huge|Huge|large|Huge|textbf|textsc|textit|textsl|emph|bf|it|sc|em|mathbf|mathrm|textnormal|centering|newline)\b', '' -replace '\\\\', ' ' -replace '[{}]', '') -replace '\s+', ' ').Trim() }
        }
    }

    # excluded content never renders in the PDF, so it must not pollute the ground-truth markdown: the
    # `comment` environment (comment package) and \iffalse..\fi conditional blocks are dropped wholesale.
    $body = [regex]::Replace($body, '(?s)\\begin\{comment\}.*?\\end\{comment\}', '')
    $body = [regex]::Replace($body, '(?s)\\iffalse\b.*?\\fi\b', '')

    # old-style $$display$$ -> \[..\] up front: display and inline math otherwise share the `$` delimiter, so
    # the regex parser conflates them and one mis-pair cascades through every downstream `$` (swallowing prose).
    $body = [regex]::Replace($body, '(?s)(?<=(?:^|[^\\])(?:\\\\)*)\$\$(.*?)\$\$', '\[$1\]')

    # TikZ pictures: STASH the source and drop a numbered marker in the flow. The source is the
    # AUTHORITY for diagrams (PDF-side image extraction is unreliable) — Invoke-ArxivLatexToMarkdown
    # renders each stashed env to SVG via node-tikzjax and swaps the marker for a live image link;
    # where the renderer is absent or a diagram fails to compile, the addressable marker stays.
    # Preamble hints (tikz libraries + tikz-adjacent packages) are captured for the renderer.
    $pre = $Tex.Substring(0, [Math]::Max(0, $Tex.IndexOf('\begin{document}')))
    # dedupe, and drop the externalization libraries: they are build-time caching (shell-escape),
    # absent from the wasm texmf tree, and one bad library in the shared list poisons EVERY job
    $script:TikzLibs = (@([regex]::Matches($pre, '\\usetikzlibrary\{([^{}]+)\}') |
            ForEach-Object { $_.Groups[1].Value -split '\s*,\s*' } |
            Where-Object { $_ -and $_ -notin 'external', 'pgfplots.external' } |
            Select-Object -Unique) -join ',')
    $script:TikzPkgs = @{}
    foreach ($p in 'tikz-cd', 'pgfplots', 'amssymb', 'amsmath') {
        if ([regex]::IsMatch($pre, '\\usepackage(?:\[[^\]]*\])?\{[^{}]*' + [regex]::Escape($p) + '[^{}]*\}')) { $script:TikzPkgs[$p] = '' }
    }
    # custom colors defined in the preamble (\definecolor/\colorlet) are load-bearing for node fills —
    # carry them into the renderer's preamble or every diagram using them fails to compile
    $script:TikzPre = (@([regex]::Matches($pre, '\\(?:definecolor|colorlet)\{[^{}]+\}(?:\{[^{}]+\})?\{[^{}]+\}') |
            ForEach-Object { $_.Value }) -join "`n")
    $script:tikzCounter = 0
    $script:TikzStore = [System.Collections.Generic.List[object]]::new()
    $body = [regex]::Replace($body, '(?s)\\begin\{(tikzpicture|tikzcd)\}.*?\\end\{\1\}', {
            param($m) $script:tikzCounter++
            $script:TikzStore.Add([pscustomobject]@{ n = $script:tikzCounter; env = $m.Groups[1].Value; source = $m.Value })
            "`n`n*[diagram $($script:tikzCounter) — TikZ source, not rendered]*`n`n" })

    # figure-grid tabulars (cells are \includegraphics) are not renderable tables, and their inline-$ caption
    # cells can swallow the whole grid into a spurious math span — collapse them to a figure marker up front.
    $body = [regex]::Replace($body, '(?s)\\begin\{tabular\}(?:\[[^\]]*\])?\s*\{([^}]*)\}((?:(?!\\end\{tabular\}).)*?)\\end\{tabular\}', {
            param($m) if ($m.Groups[2].Value -match '\\includegraphics') { "`n`n*[figure]*`n`n" } else { Convert-Tabular $m.Groups[1].Value $m.Groups[2].Value } })

    # nicematrix envs are unsupported by KaTeX (STANDARDS §1): map to the stock math matrices (prefix kept:
    # b->bmatrix, p->pmatrix, …) and drop the [first-row/col,code-for-…] option block. Labels survive as
    # ordinary first row/column entries.
    $body = $body -replace '\\begin\{([bpBvV]?)NiceMatrix\}\s*(?:\[[^\]]*\])?', '\begin{${1}matrix}'
    $body = $body -replace '\\end\{([bpBvV]?)NiceMatrix\}', '\end{${1}matrix}'

    # KaTeX ships \xrightarrow / \xleftarrow but not the amsmath \xlong… variants
    $body = $body -replace '\\xlong(right|left)arrow', '\x$1arrow'
    $body = $body -replace '\\lefteqn\b', ''                                   # KaTeX-unsupported; drop, keep its {group}
    $body = Convert-BorderMatrix $body                                         # \bordermatrix -> ruled array

    $body = Expand-LatexMacros $body $macros                                   # macros (incl inside math)
    # accents/single-arg ops written without braces around a (now-expanded) macro arg break KaTeX
    # (e.g. source \underline\IK -> \underline \mathbb{K}); re-brace the argument.
    $body = $body -replace '\\(underline|overline|widehat|widetilde|widecheck|hat|bar|tilde|vec|check|breve|acute|grave|dot|ddot|mathring)\s+(\\[A-Za-z]+\{[^{}]*\})', '\$1{$2}'
    $maps = Build-LabelMaps $body; $citeMap = Build-CiteMap $Bbl
    $body = Resolve-Refs $body $maps $citeMap                                  # \cite/\eqref/\ref -> numbers
    $body = $body -replace '\\label\{[^{}]*\}', ''                            # strip labels (text + soon-math)

    # Protect math BEFORE the algorithm/theorem/text passes. Position is load-bearing for TOKENIZATION
    # CONSISTENCY: algorithm-internal math ($x_i$, \mathbf, \gets) must reach the store INTACT so the
    # pseudocode fences carry the same $-delimited, macro-expanded KaTeX-primitive tokens as body math —
    # Flatten-AlgText then only ever sees scaffold prose (placeholders carry the math past it), never
    # math. One expression, one token stream, wherever it appears.
    $body = Protect-LatexMath $body

    $body = Convert-Algorithms $body                                          # algpseudocode -> fenced pseudocode

    # theorem family (shared counter) + proof, numbered to match the rendered paper
    $script:thmCounter = 0
    $body = [regex]::Replace($body, '\\begin\{(theorem|lemma|corollary|proposition)\}(?:\s*\[([^\]]*)\])?', {
            param($m) $script:thmCounter++; $lab = (Get-Culture).TextInfo.ToTitleCase($m.Groups[1].Value)
            $note = if ($m.Groups[2].Success) { " ($($m.Groups[2].Value))" } else { '' }; "`n`n**$lab $script:thmCounter$note.** " })
    $body = [regex]::Replace($body, '\\begin\{proof\}(?:\s*\[([^\]]*)\])?', { param($m) $t = if ($m.Groups[1].Success) { $m.Groups[1].Value } else { 'Proof' }; "`n`n*$t.* " })
    $body = $body -replace '\\end\{(theorem|lemma|corollary|proposition|proof)\}', ''

    # other theorem-like environments: surface as bold labels rather than leaking raw \begin{..}. Left
    # UNNUMBERED on purpose — their counters aren't tracked in Build-LabelMaps, so fabricating a number
    # would risk disagreeing with the rendered paper (worse than an honest unnumbered label).
    $script:thmLike = 'definition|defn|remark|example|note|claim|observation|notation|conjecture|assumption|fact|property|question|construction|convention|resultx|result'
    $body = [regex]::Replace($body, "\\begin\{($script:thmLike)\}(?:\s*\[([^\]]*)\])?", {
            param($m) $raw = $m.Groups[1].Value
            $lab = if ($raw -in 'resultx', 'result') { 'Result' } elseif ($raw -eq 'defn') { 'Definition' } else { (Get-Culture).TextInfo.ToTitleCase($raw) }
            $note = if ($m.Groups[2].Success) { " ($($m.Groups[2].Value))" } else { '' }; "`n`n**$lab$note.** " })
    $body = $body -replace "\\end\{($script:thmLike)\}", ''

    # custom \newtheorem environments (short names like cor/prop) surfaced via their DECLARED display name;
    # the fixed-name families above are already handled, this covers whatever the preamble additionally defines.
    $thmMap = @{}
    foreach ($nt in [regex]::Matches($Tex, '\\newtheorem\*?\s*\{([^{}]+)\}(?:\[[^\]]*\])?\s*\{([^{}]+)\}')) { $thmMap[$nt.Groups[1].Value] = $nt.Groups[2].Value }
    if ($thmMap.Count) {
        $ntNames = (($thmMap.Keys | Sort-Object { $_.Length } -Descending | ForEach-Object { [regex]::Escape($_) }) -join '|')
        $body = [regex]::Replace($body, "\\begin\{($ntNames)\}(?:\s*\[([^\]]*)\])?", { param($m) $disp = $thmMap[$m.Groups[1].Value]; $note = if ($m.Groups[2].Success) { " ($($m.Groups[2].Value))" } else { '' }; "`n`n**$disp$note.** " })
        $body = [regex]::Replace($body, "\\end\{($ntNames)\}", '')
    }

    # tcolorbox callouts: surface the box title (title= key, usually last in the option list) as a bold
    # label and keep the body prose; drop the wrapper rather than leaking \begin{tcolorbox}[...] verbatim.
    $body = [regex]::Replace($body, '\\begin\{tcolorbox\}(?:\[([^\]]*)\])?', {
            param($m) $tm = [regex]::Match($m.Groups[1].Value, 'title\s*=\s*\{?(.+?)\}?\s*$')
            if ($tm.Success) { "`n`n**$($tm.Groups[1].Value.Trim())**`n`n" } else { "`n`n" } })
    $body = $body -replace '\\end\{tcolorbox\}', "`n`n"

    $body = Replace-BracedCommand $body '\abstract' { param($a) "`n## Abstract`n`n$a`n" }
    $body = Replace-BracedCommand $body '\footnote' { param($a) " ($($a.Trim()))" }

    $body = $body -replace '(?s)\\begin\{abstract\}(.*?)\\end\{abstract\}', "`n## Abstract`n`n`$1`n"
    $body = $body -replace '\\(?:sub){0,2}section\*?\s*\{([^{}]*)\}', { $h = '#' * (2 + ([regex]::Matches($_.Value, 'sub')).Count); "`n`n$h $($_.Groups[1].Value)`n`n" }   # blank lines around headings (MD022)
    $body = $body -replace '\\paragraph\*?\s*\{([^{}]*)\}', '**$1** '
    $body = $body -replace '\\includegraphics(?:\[[^\]]*\])?\{([^{}]+)\}', "`n![](`$1)`n"   # escape `$1: double-quoted, PS would else interpolate it away
    $body = [regex]::Replace($body, '\\caption\{([^{}]*)\}', { param($m) $c = $m.Groups[1].Value.Trim(); if ($c) { "`n`n*$c*`n" } else { '' } })   # trim: no space inside emphasis (MD037)
    $body = $body -replace '\\(?:begin|end)\{(?:figure|table|center|wrapfigure)\*?\}(?:\[[^\]]*\])?', ''
    $body = $body -replace '\\(?:begin|end)\{(?:flushleft|flushright|appendices|subequations|quote|quotation)\}', ''   # structural wrappers, keep content
    $body = $body -replace '\\begin\{minipage\}(?:\[[^\]]*\])?\{[^}]*\}', '' -replace '\\end\{minipage\}', ''
    $body = $body -replace '\\begin\{subfigure\}(?:\[[^\]]*\])?(?:\{[^}]*\})?', '' -replace '\\end\{subfigure\}', ''   # keep panel content, drop wrapper
    $body = $body -replace '\\begin\{(?:itemize|enumerate|description)\}', "`n`n" -replace '\\end\{(?:itemize|enumerate|description)\}', "`n`n"   # blank lines around lists (MD032)
    $body = $body -replace '\\item\s*', "`n- "
    $body = $body -replace '\\(?:textbf|textsc)\{([^{}]*)\}', '**$1**'
    $body = $body -replace '\\(?:emph|textit|textsl)\{([^{}]*)\}', '*$1*'
    $body = $body -replace '\\texttt\{([^{}]*)\}', '`$1`'
    $body = $body -replace '\\(?:textrm|textnormal|mbox|text|underline)\{([^{}]*)\}', '$1'
    $body = $body -replace '\\(?:textcolor|colorbox)\{[^{}]*\}\{([^{}]*)\}', '$1' -replace '\\color\{[^{}]*\}', ''   # drop colour styling, keep text
    $body = $body -replace '\\hyperlink\{(https?://[^{}]*)\}\{[^{}]*\}', '<$1>' -replace '\\(?:hyperlink|hypertarget)\{[^{}]*\}\{([^{}]*)\}', '$1'
    $body = $body -replace '\\href\{([^{}]*)\}\{([^{}]*)\}', '[$2]($1)' -replace '\\url\{([^{}]*)\}', '<$1>'   # links, angle-bracketed (MD034)
    $body = $body -replace '\\bibliographystyle\s*\{[^{}]*\}', '' -replace '\\bibliography\s*\{[^{}]*\}', ''
    $body = $body -replace '\\(?:maketitle|tableofcontents|newpage|clearpage|noindent|centering|bigskip|medskip|smallskip|vfill|hfill|par)\b', ''
    $body = $body -replace '\\(?:vspace|hspace)\*?\{[^{}]*\}', ''
    $body = $body -replace '\\&', '&' -replace '\\%', '%' -replace '\\_', '_' -replace '\\#', '#' -replace '\\\$', '$'
    $body = $body -replace '~', ' ' -replace '\\,|\\;|\\:|\\!|\\ ', ' ' -replace '``|''''', '"'

    $body = Restore-LatexMath $body
    # \textsc has no KaTeX equivalent; prose occurrences already became **bold** above, so any survivor is
    # math-mode small-caps (algorithm pseudocode) — map the control word to \text, preserving its brace group.
    $body = $body -replace '\\textsc(?=\s*\{)', '\text'
    $body = $body -replace '\t', ' '                                          # hard tabs -> space (MD010)
    $body = [regex]::Replace($body, '[ \t]+\r?\n', "`n")
    $body = [regex]::Replace($body, '(?m)^[ \t]+', '')                        # dedent: source indentation is meaningless in md and reads as spurious indented-code blocks
    $body = [regex]::Replace($body, '\n{3,}', "`n`n")
    $body = Restore-Algorithms $body                                          # swap fenced pseudocode back in (keeps its own indentation)

    $h1 = if ($title) { '# ' + (Convert-LatexInline $title) } else { '# (untitled)' }
    return ($h1 + "`n`n" + $body.Trim() + "`n")
}

# --- references from the .bbl (numbered to match \cite resolution) ----------------------------------
function Get-LatexReferences {
    param([string]$Bbl, $CiteMap)
    if (-not $Bbl) { return $null }
    $items = [regex]::Split($Bbl, '\\bibitem') | Select-Object -Skip 1
    if (-not $items.Count) { return $null }
    $lines = foreach ($it in $items) {
        $key = ([regex]::Match($it, '^\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}')).Groups[1].Value
        $num = if ($CiteMap -and $CiteMap.ContainsKey($key)) { $CiteMap[$key] } else { '?' }
        $txt = ($it -replace '^\s*(?:\[[^\]]*\])?\s*\{[^}]+\}', '')
        $txt = (Protect-LatexMath $txt)
        $txt = Apply-Accents $txt
        $txt = [regex]::Replace($txt, '\{\\(?:em|it|sl)\s+([^{}]*)\}', '*$1*')
        $txt = $txt -replace '\\(?:em|it|sl)\b', ''
        $txt = Convert-LatexInline $txt
        $txt = $txt -replace '--', [char]0x2013 -replace '\\end\{thebibliography\}', ''
        $txt = (Restore-LatexMath $txt)
        $txt = [regex]::Replace($txt, '\s+', ' ').Trim()
        if ($txt) { [pscustomobject]@{ n = [int]$num; line = "$num. $txt" } }
    }
    return (($lines | Sort-Object n | ForEach-Object { $_.line }) -join "`n")
}

# --- source unpack + main-file discovery ------------------------------------------------------------
function Expand-ArxivSourceTarball {
    param([string]$TarGz, [string]$WorkDir)
    New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
    & tar -xzf $TarGz -C $WorkDir 2>$null
    if ($LASTEXITCODE -ne 0) { throw "tar failed to extract $TarGz" }
    return $WorkDir
}
function Find-LatexMain {
    param([string]$Dir)
    $tex = @(Get-ChildItem -Recurse -File -Filter *.tex $Dir)
    foreach ($f in $tex) { if (Select-String -LiteralPath $f.FullName -Pattern 'documentclass' -Quiet) { return $f.FullName } }
    if ($tex.Count) { return $tex[0].FullName }
    throw "no .tex found under $Dir"
}
function Resolve-LatexInputs {
    param([string]$MainPath, [int]$Depth = 0)
    $u8 = [System.Text.UTF8Encoding]::new($false)
    $tex = [System.IO.File]::ReadAllText($MainPath, $u8)
    if ($Depth -ge 4) { return $tex }
    $dir = Split-Path -Parent $MainPath
    return [regex]::Replace($tex, '\\(?:input|include)\{([^{}]+)\}', {
            param($m)
            $name = $m.Groups[1].Value
            $cand = @("$name", "$name.tex") | ForEach-Object { Join-Path $dir $_ } | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
            if ($cand) { Resolve-LatexInputs -MainPath $cand -Depth ($Depth + 1) } else { '' }
        })
}

# --- orchestrator -----------------------------------------------------------------------------------
# Carry the figures the markdown references OUT of the (about-to-be-deleted) tarball workdir, so image
# links resolve beside the deliverable instead of dying with the temp dir. Targets are probed against the
# workdir tree by leaf name with extension fallback — \includegraphics routinely omits the extension and
# \graphicspath redirects the dir; a recursive leaf search sidesteps both. Raster formats stay image
# links (they render); vector-only source figures (pdf/eps/ps) become plain links — a markdown image tag
# on a .pdf renders broken, and the honest form is still clickable and machine-findable for weaving.
function Copy-LatexFigures {
    param([string]$Markdown, [string]$WorkDir, [string]$OutDir, [string]$Slug)
    $raster = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp')
    $state = @{ copied = 0; missing = 0 }
    $destRoot = Join-Path $OutDir $Slug
    $Markdown = [regex]::Replace($Markdown, '!\[\]\(([^)\s]+)\)', {
            param($m)
            $target = $m.Groups[1].Value
            if ($target -match '^[a-z][a-z0-9+.\-]*://') { return $m.Value }   # web URL: leave as-is
            $leaf = [System.IO.Path]::GetFileName($target)
            $hit = $null
            $cand = Join-Path $WorkDir $target
            if ([System.IO.File]::Exists($cand)) { $hit = Get-Item -LiteralPath $cand }
            if (-not $hit) {
                $pattern = if ([System.IO.Path]::GetExtension($leaf)) { $leaf } else { "$leaf.*" }
                $hit = @(Get-ChildItem -Path $WorkDir -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue |
                         Sort-Object { $raster.IndexOf($_.Extension.ToLowerInvariant()) -lt 0 }) | Select-Object -First 1   # prefer a raster sibling over the .pdf twin
            }
            if (-not $hit) { $state.missing++; return "*[figure: $leaf — source file not found]*" }
            if (-not (Test-Path -LiteralPath $destRoot)) { New-Item -ItemType Directory -Force -Path $destRoot | Out-Null }
            Copy-Item -LiteralPath $hit.FullName -Destination (Join-Path $destRoot $hit.Name) -Force
            $state.copied++
            $rel = "$Slug/$($hit.Name)"
            if ($raster -contains $hit.Extension.ToLowerInvariant()) { return "![]($rel)" }
            return "[figure ($($hit.Extension.TrimStart('.'))): $($hit.Name)]($rel)"
        })
    return [pscustomobject]@{ markdown = $Markdown; copied = $state.copied; missing = $state.missing }
}

function Invoke-ArxivLatexToMarkdown {
    param([string]$TarGz, [string]$Slug, [string]$OutDir)
    $u8 = [System.Text.UTF8Encoding]::new($false)
    # the tex unpacks into a runstamped working dir BESIDE the tarball — an intermediate workflow
    # artifact like any other (gitignored, non-destructive across passes), not a throwaway temp dir.
    # It PERSISTS: downstream consumers (math bank, structure skeleton) re-read the source without
    # re-extraction, and a conversion is inspectable after the fact.
    $run  = New-RunDir (Split-Path -Parent (Resolve-Path -LiteralPath $TarGz).Path)
    $work = Join-Path $run 'tex'
    Expand-ArxivSourceTarball -TarGz $TarGz -WorkDir $work | Out-Null

    $main = Find-LatexMain $work
    $tex = Resolve-LatexInputs -MainPath $main
    $bbl = @(Get-ChildItem -Recurse -File -Filter *.bbl $work) | Select-Object -First 1
    $bblTxt = if ($bbl) { [System.IO.File]::ReadAllText($bbl.FullName, $u8) } else { '' }

    $md = ConvertFrom-Latex $tex $bblTxt
    $refs = Get-LatexReferences $bblTxt (Build-CiteMap $bblTxt)
    if ($refs) { $md += "`n## References`n`n$refs`n" }

    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $figs = Copy-LatexFigures -Markdown $md -WorkDir $work -OutDir $OutDir -Slug $Slug
    $md = $figs.markdown

    # source-authoritative diagrams: render the stashed TikZ envs to SVG and swap their markers for
    # live image links. Macro-expanded first (node labels use the paper's \newcommand vocabulary).
    # Graceful degradation at every level: renderer absent -> all markers stay; one diagram failing
    # to compile -> that marker stays; nothing throws the conversion.
    $rendered = 0
    if ($script:TikzStore.Count -gt 0 -and (Test-TikzRenderAvailable)) {
        $texMacros = Get-LatexMacros $tex
        $jobs = @(foreach ($t in $script:TikzStore) {
                $pkgs = @{} + $script:TikzPkgs
                if ($t.env -eq 'tikzcd') { $pkgs['tikz-cd'] = '' }
                $src = Expand-LatexMacros $t.source $texMacros
                # the tikz stash happens BEFORE the body-wide NiceMatrix normalization — apply the same
                # rewrite here (nicematrix is not in the renderer's texmf tree; stock matrices are)
                $src = $src -replace '\\begin\{([bpBvV]?)NiceMatrix\}\s*(?:\[[^\]]*\])?', '\begin{${1}matrix}'
                $src = $src -replace '\\end\{([bpBvV]?)NiceMatrix\}', '\end{${1}matrix}'
                @{ id = "diagram-$($t.n)"; source = $src
                    tikzLibraries = [string]$script:TikzLibs; texPackages = $pkgs; preamble = [string]$script:TikzPre }
            })
        try {
            $rep = Invoke-TikzRender -Jobs $jobs -OutDir (Join-Path $OutDir $Slug)
            foreach ($res in @($rep.results)) {
                if (-not $res.ok) { continue }
                $n = [int]($res.id -replace '^diagram-', '')
                $md = $md.Replace("*[diagram $n — TikZ source, not rendered]*", "![]($Slug/$($res.id).svg)")
                $rendered++
            }
        } catch { Write-Verbose "tikz-render failed: $($_.Exception.Message)" }
    }

    $outPath = Join-Path $OutDir "$Slug.md"
    [System.IO.File]::WriteAllText($outPath, $md, $u8)

    return [pscustomobject]@{
        slug = $Slug; out = $outPath; main_tex = (Split-Path -Leaf $main)
        run = (Split-Path -Leaf $run); tex = $work   # the persisted unpacked source (run artifact)
        bytes = $md.Length; macros = (Get-LatexMacros $tex).Count
        sections = ([regex]::Matches($md, '(?m)^##\s')).Count
        references = if ($refs) { @($refs -split "`n").Count } else { 0 }
        figures = $figs.copied; figures_missing = $figs.missing
        diagrams = [int]$script:tikzCounter            # TikZ envs found in source
        diagrams_rendered = $rendered                  # markers swapped for source-rendered SVGs
    }
}
