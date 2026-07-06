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
. "$PSScriptRoot/pdf-raster.ps1"    # PNG-terminal raster: \includegraphics PDF assets + compiled-diagram PDFs -> PNG (MuPDF WASM)
. "$PSScriptRoot/tex-render.ps1"    # unified diagram render: tectonic snippet -> PDF -> PNG (all packages incl. xy-pic); graceful when absent

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
    $m = [regex]::Match($Text, [regex]::Escape($Command) + '\s*(?:\[[^\]]*\])?\s*\{')   # skip an optional [..] arg, e.g. \title[short]{long}
    if (-not $m.Success) { return $null }
    return Get-LatexBracedArg $Text ($m.Index + $m.Length - 1)
}
function Replace-BracedCommand {
    param([string]$T, [string]$Cmd, [scriptblock]$Fmt)   # replace every \Cmd{...} with &Fmt($arg)
    while ($true) {
        $m = [regex]::Match($T, [regex]::Escape($Cmd) + '\*?(?:\[[^\]]*\])?\s*\{')   # tolerate a *-variant + optional [..] arg (e.g. \author*[1]{..})
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
    $Body = $Body -replace '\\cmidrule\s*(?:\([^)]*\))?\s*\{[^}]*\}', '' -replace '\\(?:morecmidrules|addlinespace)\b(?:\[[^\]]*\])?', ''   # booktabs rules
    $Body = [regex]::Replace($Body, '\\multicolumn\{\d+\}\{[^}]*\}\{((?:[^{}]|\{[^{}]*\})*)\}', '$1')   # content may nest one brace level (\textbf{..}); spec braces can carry | — both tolerated
    # a row break \\ may carry an optional spacing arg (\\[0.5ex]) — strip it so it does not leak as a cell
    $Body = [regex]::Replace($Body, '\\\\\s*\[[^\]]*\]', '\\')
    $s = $Spec -replace '\|', '' -replace '[@<>]\{[^}]*\}', '' -replace '[pmb]\{[^}]*\}', 'X'
    $ncol = ($s -replace '[^clrX]', '').Length
    if ($ncol -lt 1) { $ncol = 1 }
    $rows = @([regex]::Split($Body, '\\\\') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
    if (-not $rows.Count) { return '' }
    $out = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $rows.Count; $i++) {
        $cells = @([regex]::Split($rows[$i], '(?<!\\)&') | ForEach-Object { ($_ -replace '\s+', ' ').Trim() -replace '\\&', '&' })   # md cells cannot contain newlines — an embedded blank line breaks the whole table row
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
    # ORDINAL keys: LaTeX command names are case-sensitive and papers really do define both \Vect and
    # \vect — a PS [ordered]@{} is case-INSENSITIVE, so the second definition silently overwrites the
    # first and only the stored spelling ever expands (found via 2111.15058v3: 22 \vect left literal).
    $macros = [System.Collections.Specialized.OrderedDictionary]::new([System.StringComparer]::Ordinal)
    $rx = [regex]'\\(?:newcommand|renewcommand|providecommand)\*?\s*\{?\s*\\([A-Za-z]+|.)\s*\}?\s*(?:\[(\d+)\])?\s*(?:\[([^\]]*)\])?\s*\{'   # \*? : the starred short-arg form is common
    foreach ($m in $rx.Matches($Tex)) {
        $name = $m.Groups[1].Value
        $nargs = if ($m.Groups[2].Success) { [int]$m.Groups[2].Value } else { 0 }
        $opt = if ($m.Groups[3].Success) { $m.Groups[3].Value } else { $null }
        $body = Get-LatexBracedArg $Tex ($m.Index + $m.Length - 1)
        # bodies written with %-line-continuations carry the % into the expansion, where it comments out
        # the REST OF THE MATH SPAN (swallowing closing braces). TeX eats %+newline — do the same.
        if ($null -ne $body) { $body = [regex]::Replace($body, '(?<!\\)%[^\r\n]*\r?\n?', '') }
        # bodies built on TeX-engine/drawing internals (pgf pictures, \mathpalette, @-names) can never
        # render in KaTeX — expanding them sprays internals into the output. SKIP the def: the macro NAME
        # then surfaces intact — addressable by the compat table or a per-paper patch — instead of soup.
        if ($null -ne $body -and $body -match '\\pgf[a-z]|\\mathpalette(?![A-Za-z])|\\[A-Za-z]+@[A-Za-z]') { continue }
        if ($null -ne $body) { $macros[$name] = [pscustomobject]@{ nargs = $nargs; opt = $opt; body = $body } }
    }
    foreach ($m in ([regex]'\\DeclareMathOperator\*?\s*\{?\s*\\([A-Za-z]+)\s*\}?\s*\{').Matches($Tex)) {   # braces around the operator name are optional
        $name = $m.Groups[1].Value; $body = Get-LatexBracedArg $Tex ($m.Index + $m.Length - 1)
        if ($null -ne $body) { $macros[$name] = [pscustomobject]@{ nargs = 0; opt = $null; body = "\operatorname{$body}" } }
    }
    # \let\A\B (also \let\A=\B): a zero-arg alias — papers alias whole vocabularies this way
    # (\let\union\cup, \let\rseqlrarr\xdashleftrightarrow). The alias body is the TARGET name; the
    # expansion fixed-point resolves chains (\let\intsec\intersect -> \intersect -> \cap).
    foreach ($m in ([regex]'\\let\s*\\([A-Za-z]+)\s*=?\s*\\([A-Za-z]+)').Matches($Tex)) {
        $macros[$m.Groups[1].Value] = [pscustomobject]@{ nargs = 0; opt = $null; body = '\' + $m.Groups[2].Value }
    }
    # \DeclarePairedDelimiter{\ceil}{\lceil}{\rceil} (mathtools): a 1-arg macro wrapping in its fences.
    # KaTeX has no \DeclarePairedDelimiter, so realize it as a plain \newcommand-equivalent.
    foreach ($m in ([regex]'\\DeclarePairedDelimiter\*?\s*\\([A-Za-z]+)\s*\{([^{}]*)\}\s*\{([^{}]*)\}').Matches($Tex)) {
        $macros[$m.Groups[1].Value] = [pscustomobject]@{ nargs = 1; opt = $null; body = $m.Groups[2].Value + ' #1 ' + $m.Groups[3].Value }
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
                $exp = $def.body
                for ($k = $def.nargs; $k -ge 1; $k--) {
                    # glue guard INSIDE the body too: {\lbarrowspace#1} with arg 'c' must not fuse into
                    # \lbarrowspacec — when #k directly follows a control word and the arg starts with a
                    # letter, keep the token boundary with a space.
                    $argv = [string]$args[$k - 1]
                    $exp = [regex]::Replace($exp, '(\\[A-Za-z]+)?#' + $k, {
                            param($mm)
                            if ($mm.Groups[1].Success -and $argv.Length -gt 0 -and [char]::IsLetter($argv[0])) { $mm.Groups[1].Value + ' ' + $argv }
                            else { $mm.Groups[1].Value + $argv } }.GetNewClosure())
                }
                # GLUE GUARDS: a control word and an adjacent letter must never fuse into a NEW control word.
                # Head: \in followed by \chn expanding to 'c' would produce \inc (an undefined command born in
                # the expander). Tail: a body ending in a control word followed by a source letter fuses too.
                if ($exp.Length -gt 0 -and [char]::IsLetter($exp[0])) {
                    $tail = if ($sb.Length -gt 40) { $sb.ToString($sb.Length - 40, 40) } else { $sb.ToString() }
                    if ([regex]::IsMatch($tail, '\\[A-Za-z]+$')) { [void]$sb.Append(' ') }
                }
                [void]$sb.Append($exp)
                if ($cur -lt $Text.Length -and [char]::IsLetter($Text[$cur]) -and [regex]::IsMatch($exp, '\\[A-Za-z]+$')) { [void]$sb.Append(' ') }
                $pos = $cur; $changed = $true
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
    # ordinal maps: \label keys are case-sensitive identifiers (eq:A vs eq:a must not collide)
    $thm = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
    $eq = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
    $fig = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
    $tab = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
    $tc = 0; $ec = 0; $fc = 0; $bc = 0   # theorem-family share one counter; numbered eq envs another; figures + tables count their own
    foreach ($m in ([regex]'\\begin\{(theorem|lemma|corollary|proposition|equation|align|gather|multline|eqnarray|alignat)(\*?)\}').Matches($Body)) {
        $env = $m.Groups[1].Value; $star = $m.Groups[2].Value -eq '*'
        $endIdx = $Body.IndexOf('\end{' + $env, $m.Index); $seg = if ($endIdx -ge 0) { $Body.Substring($m.Index, $endIdx - $m.Index) } else { '' }
        $lbl = [regex]::Match($seg, '\\label\{([^{}]+)\}')
        if ($env -in 'theorem', 'lemma', 'corollary', 'proposition') { $tc++; if ($lbl.Success) { $thm[$lbl.Groups[1].Value] = $tc } }
        elseif (-not $star) { $ec++; if ($lbl.Success) { $eq[$lbl.Groups[1].Value] = $ec } }
    }
    # figure/table floats: one counter each; the float's FIRST \label (conventionally right after \caption)
    # maps to it, so \ref/\cref resolve to a number instead of leaking "Figure ?"/"Table ?" placeholders.
    foreach ($m in ([regex]'\\begin\{(figure|table)(\*?)\}').Matches($Body)) {
        $env = $m.Groups[1].Value
        $endIdx = $Body.IndexOf('\end{' + $env, $m.Index); $seg = if ($endIdx -ge 0) { $Body.Substring($m.Index, $endIdx - $m.Index) } else { '' }
        $lbl = [regex]::Match($seg, '\\label\{([^{}]+)\}')
        if ($env -eq 'figure') { $fc++; if ($lbl.Success) { $fig[$lbl.Groups[1].Value] = $fc } }
        else { $bc++; if ($lbl.Success) { $tab[$lbl.Groups[1].Value] = $bc } }
    }
    # counts ride alongside the label→number maps: the maps only hold LABELLED floats/envs, but the raw
    # counters saw every one — so counts.figures ($fc) is the true float count, ≥ maps.fig.Count. The
    # oracle-batch harness reads these back (persisted via Get-LatexOracleCounts) as the figure-count truth.
    return @{ thm = $thm; eq = $eq; fig = $fig; tab = $tab
              counts = @{ figures = $fc; tables = $bc; theorems = $tc; equations = $ec } }
}

# Oracle count model — TWO populations (the ONE source of truth, reused by the persist path in
# Invoke-ArxivLatexToMarkdown and the harness in Compare-FigureCounts). A diagram-heavy paper (zigzag /
# category theory) has two visually-distinct things a geometry converter sees as "figure regions", and
# they must NOT be conflated:
#   figures         = \begin{figure} FLOATS — the CAPTIONED figures a human means by "figure". The
#                     PRIMARY oracle: compare against pig's CAPTIONED regions.
#   inline_diagrams = TikZ/xy-pic commutative diagrams OUTSIDE any figure float — inline mathematical
#                     typesetting (like display equations), uncaptioned, NOT floats. A separate
#                     population: compare against pig's UNCAPTIONED regions.
# Counting drawn OBJECTS (\includegraphics + all diagrams) as one number was WRONG: on 2210 it scored
# 28 while the source has 16 captioned floats + 23 inline diagrams — it counted inline tikzcd as figures
# and (worse) missed all 11 xy-pic entirely. xy-pic (\xymatrix / \begin{xy}) is a SECOND diagram package
# and is counted here now. A diagram INSIDE a float is part of that one figure (already in figures), so
# only diagrams outside floats are inline. Runs on the RESOLVED body; the env regexes are macro-robust.
function Get-LatexOracleCounts {
    param([Parameter(Mandatory)][string]$Body)
    $maps   = Build-LabelMaps $Body
    $incg   = ([regex]'\\includegraphics(?:\[[^\]]*\])?\{').Matches($Body).Count
    $tikzRe = [regex]'\\begin\{(?:tikzpicture|tikzcd)\}'
    $xyRe   = [regex]'\\xymatrix|\\begin\{xy\}'                # xy-pic: the 2nd commutative-diagram package
    $diagTotal  = $tikzRe.Matches($Body).Count + $xyRe.Matches($Body).Count
    # inline = outside any figure float (blank the floats out, then count what remains)
    $inlineBody = [regex]::Replace($Body, '(?s)\\begin\{figure\*?\}.*?\\end\{figure\*?\}', '')
    $inlineDiag = $tikzRe.Matches($inlineBody).Count + $xyRe.Matches($inlineBody).Count
    return [ordered]@{
        figures         = [int]$maps.counts.figures    # \begin{figure} floats — the CAPTIONED-figure oracle (PRIMARY)
        inline_diagrams = [int]$inlineDiag              # tikz/xy diagrams outside floats — inline math (2nd population)
        images          = [int]$incg                    # \includegraphics placements (subfigures inflate this)
        diagrams_total  = [int]$diagTotal               # all tikz/cd/xy diagram envs (floated + inline)
        tables          = [int]$maps.counts.tables
        theorems        = [int]$maps.counts.theorems
        equations       = [int]$maps.counts.equations
        oracle_figures  = [int]$maps.counts.figures     # PRIMARY comparison target = captioned figure floats
    }
}
function Build-CiteMap {
    param([string]$Bbl)   # \bibitem order = citation number (\bibliographystyle{plain} renders these)
    # ordinal: bib keys are case-sensitive (chen2019 vs Chen2019 are distinct entries)
    $map = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal); $i = 0
    if ($Bbl) { foreach ($m in ([regex]'\\bibitem(?:\[[^\]]*\])?\s*\{([^{}]+)\}').Matches($Bbl)) { $i++; $map[$m.Groups[1].Value] = $i } }
    return $map
}
function Resolve-Refs {
    param([string]$T, $Maps, $CiteMap)
    # consume natbib optional pre/post-notes (\citep[see][p. 7]{key}) — else the [..] brackets leak and read as broken reference links
    $T = [regex]::Replace($T, '\\cite[a-z]*(?:\[[^\]]*\])?(?:\[[^\]]*\])?\s*\{([^{}]+)\}', { param($m) '[' + (($m.Groups[1].Value -split '\s*,\s*' | ForEach-Object { if ($CiteMap.ContainsKey($_)) { $CiteMap[$_] } else { '?' } }) -join ', ') + ']' })
    $T = [regex]::Replace($T, '\\eqref\{([^{}]+)\}', { param($m) $k = $m.Groups[1].Value; if ($Maps.eq.ContainsKey($k)) { "($($Maps.eq[$k]))" } else { '(?)' } })
    # \Cref/\vref/\labelcref included (cleveref) — else the capitalized forms leak verbatim; check every map
    $T = [regex]::Replace($T, '\\(?:ref|autoref|cref|Cref|vref|labelcref)\{([^{}]+)\}', { param($m) $k = $m.Groups[1].Value
            if ($Maps.thm.ContainsKey($k)) { "$($Maps.thm[$k])" } elseif ($Maps.eq.ContainsKey($k)) { "$($Maps.eq[$k])" }
            elseif ($Maps.fig.ContainsKey($k)) { "$($Maps.fig[$k])" } elseif ($Maps.tab.ContainsKey($k)) { "$($Maps.tab[$k])" }
            elseif ($Maps.sec -and $Maps.sec.ContainsKey($k)) { "$($Maps.sec[$k])" }
            elseif ($Maps.custom -and $Maps.custom.ContainsKey($k)) { "$($Maps.custom[$k])" } else { '?' } })
    return $T
}

# --- diagram transpilers (ENCODE-FIRST): xy-pic + tikzcd -> semantic KaTeX ---------------------------
# Doctrine (issues/latex-oracle-images.md, 2026-07-05): a diagram that CAN be expressed as semantic,
# KaTeX-renderable math MUST be — an image is the LAST resort. The corpus is consumed by reasoning
# models: $0 \longrightarrow K$ is legible content; a PNG (or a \begin{CD} wrapper) is not. Two
# deterministic rungs share one grid model (rows of { node; arrows }, each arrow { dir; style;
# over; under }) and one emitter:
#   1-D  — a SINGLE-ROW diagram with r/l arrows -> inline arrows (\longrightarrow, or
#          \xrightarrow[under]{over} when the morphism is labelled, per faithful-not-filtered).
#   2-D  — an ORTHOGONAL grid (r/l/u/d single-step arrows only) -> the core \begin{array} primitive;
#          vertical arrows are \uparrow/\downarrow with labels as superscript beside the arrow
#          (under-labels as subscript — user convention 2026-07-05).
# ANY construct beyond that (diagonals, curves/loops/bends, rotation options, styles with no exact
# KaTeX form) returns $null — never a guessed encoding — and the diagram falls to the render ladder +
# the diagrams work-list (the reasoning-agent seam).
function Format-VerticalArrow {
    param($G)   # vertical slot arrow -> KaTeX, or $null (only PLAIN verticals have a KaTeX form — no \hookuparrow etc.)
    if ($G.style -ne 'plain') { return $null }
    $a = if ($G.dir -ceq 'd') { '\downarrow' } else { '\uparrow' }
    if ($null -ne $G.under) { $a += '_{' + $G.under + '}' }
    if ($null -ne $G.over) { $a += '^{' + $G.over + '}' }
    return $a
}
function Format-DiagramGrid {
    param($Rows)   # rows of cells (@{ node; arrows }) -> inline chain (1 row) | \begin{array} (grid) | $null
    $R = $Rows.Count
    # NOTE: PS variables are case-INSENSITIVE — a `$r` loop variable here would clobber `$R`
    $C = 0; foreach ($row in $Rows) { if ($row.Count -gt $C) { $C = $row.Count } }
    if ($R -lt 1 -or $C -lt 1 -or ($R -eq 1 -and $C -lt 2)) { return $null }
    # place every arrow into its slot between adjacent cells; off-grid or double-booked slots bail
    $h = @{}; $v = @{}   # "i,j" -> arrow; h: cell (i,j)->(i,j+1); v: cell (i,j)->(i+1,j)
    for ($i = 0; $i -lt $R; $i++) {
        for ($j = 0; $j -lt $Rows[$i].Count; $j++) {
            foreach ($g in $Rows[$i][$j].arrows) {
                $isH = $g.dir -ceq 'r' -or $g.dir -ceq 'l'
                $gi = if ($g.dir -ceq 'u') { $i - 1 } else { $i }
                $gj = if ($g.dir -ceq 'l') { $j - 1 } else { $j }
                if ($isH) { if ($gi -lt 0 -or $gj -lt 0 -or $gj -ge $C - 1 -or $h.ContainsKey("$gi,$gj")) { return $null }; $h["$gi,$gj"] = $g }
                else { if ($gi -lt 0 -or $gi -ge $R - 1 -or $gj -lt 0 -or $v.ContainsKey("$gi,$gj")) { return $null }; $v["$gi,$gj"] = $g }
            }
        }
    }
    $node = { param($i, $j) if ($j -lt $Rows[$i].Count -and $Rows[$i][$j].node -ne '') { $Rows[$i][$j].node } else { '' } }
    if ($R -eq 1) {
        # 1-D chain: nodes joined by their gap arrows (a gap with no morphism drawn renders as spacing)
        $out = [System.Text.StringBuilder]::new()
        for ($j = 0; $j -lt $C; $j++) {
            $n = & $node 0 $j
            [void]$out.Append($(if ($n -ne '') { $n } else { '{}' }))
            if ($j -lt $C - 1) {
                $arrow = if ($h.ContainsKey("0,$j")) { Format-CdArrow $h["0,$j"] } else { '\quad' }
                if ($null -eq $arrow) { return $null }
                [void]$out.Append(' ').Append($arrow).Append(' ')
            }
        }
        return $out.ToString()
    }
    # 2-D grid: array columns/rows interleave nodes with arrow slots (2C-1 x 2R-1)
    $lines = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $R; $i++) {
        $cells = [System.Collections.Generic.List[string]]::new()
        for ($j = 0; $j -lt $C; $j++) {
            $cells.Add((& $node $i $j))
            if ($j -lt $C - 1) {
                $a = if ($h.ContainsKey("$i,$j")) { Format-CdArrow $h["$i,$j"] } else { '' }
                if ($null -eq $a) { return $null }
                $cells.Add($a)
            }
        }
        $lines.Add(($cells -join ' & '))
        if ($i -lt $R - 1) {
            $cells = [System.Collections.Generic.List[string]]::new()
            for ($j = 0; $j -lt $C; $j++) {
                $a = if ($v.ContainsKey("$i,$j")) { Format-VerticalArrow $v["$i,$j"] } else { '' }
                if ($null -eq $a) { return $null }
                $cells.Add($a)
                if ($j -lt $C - 1) { $cells.Add('') }
            }
            $lines.Add(($cells -join ' & '))
        }
    }
    return '\begin{array}{' + ('c' * (2 * $C - 1)) + "}`n" + ($lines -join " \\`n") + "`n\end{array}"
}
function Convert-XyDiagramBody {
    param([string]$Inner)   # \xymatrix{...} body -> $Rows for Format-DiagramGrid, or $null
    # split into rows on depth-0 '\\' and cells on depth-0 '&'
    $rows = [System.Collections.Generic.List[object]]::new()
    $cells = [System.Collections.Generic.List[string]]::new()
    $sb = [System.Text.StringBuilder]::new(); $depth = 0
    for ($k = 0; $k -lt $Inner.Length; $k++) {
        $c = $Inner[$k]
        if ($c -eq '\') {
            if ($k + 1 -lt $Inner.Length -and $Inner[$k + 1] -eq '\' -and $depth -eq 0) {
                $cells.Add($sb.ToString()); [void]$sb.Clear()
                $rows.Add($cells); $cells = [System.Collections.Generic.List[string]]::new()
                $k++; continue
            }
            [void]$sb.Append($c)
            if ($k + 1 -lt $Inner.Length) { $k++; [void]$sb.Append($Inner[$k]) }   # escaped char rides along (incl. braced-label internals)
            continue
        }
        if ($c -eq '{') { $depth++ } elseif ($c -eq '}') { $depth-- }
        if ($c -eq '&' -and $depth -eq 0) { $cells.Add($sb.ToString()); [void]$sb.Clear(); continue }
        [void]$sb.Append($c)
    }
    $cells.Add($sb.ToString())
    if ($cells.Count -gt 1 -or $cells[0].Trim() -ne '') { $rows.Add($cells) }   # drop a trailing empty row from a final \\

    $parsed = [System.Collections.Generic.List[object]]::new()
    foreach ($rowCells in $rows) {
        $prow = [System.Collections.Generic.List[object]]::new()
        foreach ($cell in $rowCells) {
            $arrows = [System.Collections.Generic.List[object]]::new()
            $node = [System.Text.StringBuilder]::new()
            for ($k = 0; $k -lt $cell.Length; $k++) {
                if ($cell[$k] -eq '\' -and $k + 2 -lt $cell.Length -and $cell.Substring($k, 3) -ceq '\ar') {
                    $j = $k + 3
                    while ($j -lt $cell.Length -and $cell[$j] -eq ' ') { $j++ }
                    if ($j -ge $cell.Length -or $cell[$j] -ne '[') { return $null }   # \ar@(..) loops, \ar@/^/ curves, or a different control word — bail
                    $cb = $cell.IndexOf(']', $j); if ($cb -lt 0) { return $null }
                    $spec = $cell.Substring($j + 1, $cb - $j - 1)
                    if ($spec -cnotmatch '^[rlud]$') { return $null }                 # diagonal/multi-step targets — beyond the orthogonal rung
                    $j = $cb + 1
                    $over = $null; $under = $null
                    while ($j -lt $cell.Length) {                                     # ^over / _under morphism labels (either, both, or none)
                        while ($j -lt $cell.Length -and $cell[$j] -eq ' ') { $j++ }
                        if ($j -lt $cell.Length -and ($cell[$j] -eq '^' -or $cell[$j] -eq '_')) {
                            $side = $cell[$j]; $j++
                            while ($j -lt $cell.Length -and $cell[$j] -eq ' ') { $j++ }
                            if ($j -ge $cell.Length) { return $null }
                            if ($cell[$j] -eq '{') { $lbl = Get-LatexBracedArg $cell $j; if ($null -eq $lbl) { return $null }; $j = Get-BraceGroupEnd $cell $j }
                            elseif ($cell[$j] -eq '\') { $e2 = $j + 1; while ($e2 -lt $cell.Length -and [char]::IsLetter($cell[$e2])) { $e2++ }; $lbl = $cell.Substring($j, $e2 - $j); $j = $e2 }
                            else { $lbl = [string]$cell[$j]; $j++ }
                            if ($side -eq '^') { $over = $lbl } else { $under = $lbl }
                        } else { break }
                    }
                    $arrows.Add(@{ dir = $spec; style = 'plain'; over = $over; under = $under })
                    $k = $j - 1
                    continue
                }
                [void]$node.Append($cell[$k])
            }
            $prow.Add(@{ node = $node.ToString().Trim(); arrows = $arrows })
        }
        $parsed.Add($prow)
    }
    return , $parsed   # unary comma: stop the pipeline from unrolling the row list
}
function Convert-XyDiagramSpan {
    param([string]$T)   # whole math-span content; EVERY \xymatrix inside must transpile or the span fails ($null)
    while ($true) {
        $m = [regex]::Match($T, '\\xymatrix')
        if (-not $m.Success) { return $T }
        $i = $m.Index + $m.Length
        while ($i -lt $T.Length -and [char]::IsWhiteSpace($T[$i])) { $i++ }
        # spacing options (@C=2em/@R…/@M/@W/@H/@L/@1/@!…) don't change semantics — skip; a direction
        # option (@dr etc.) ROTATES the diagram — semantic, bail rather than mis-encode
        while ($i -lt $T.Length -and $T[$i] -eq '@') {
            $i++
            if ($i -ge $T.Length -or 'CRMWHL1!='.IndexOf($T[$i]) -lt 0) { return $null }
            while ($i -lt $T.Length -and $T[$i] -ne '@' -and $T[$i] -ne '{') { $i++ }
        }
        if ($i -ge $T.Length -or $T[$i] -ne '{') { return $null }
        $end = Get-BraceGroupEnd $T $i
        if ($end -lt 0) { return $null }
        $rows = Convert-XyDiagramBody ($T.Substring($i + 1, $end - $i - 2))
        if ($null -eq $rows) { return $null }
        $chain = Format-DiagramGrid $rows
        if ($null -eq $chain) { return $null }
        $T = $T.Substring(0, $m.Index) + $chain + $T.Substring($end)
    }
}

# --- tikzcd linear-chain transpiler (ENCODE-FIRST, sibling of Convert-XyLinearSpan) -------------------
# Same doctrine, second dialect: a SINGLE-ROW \begin{tikzcd} whose arrows are all plain \arrow[r]/\arrow[l]
# (alias \ar) is a 1-D sequence — transpile to inline arrows. tikzcd's label syntax is quoted ("f", with '
# or swap flipping it below); the ONLY style options accepted are the ones with exact KaTeX equivalents
# (hook -> \(x)hookrightarrow, two heads -> \(x)twoheadrightarrow, maps to -> \(x)mapsto, dashed ->
# \dashrightarrow unlabeled) — all verified against the vendored KaTeX. Anything else (u/d/diagonal
# targets, bends, shifts, Rightarrow, dotted, …) returns $null and falls to the render ladder + work-list.
function Convert-TikzcdArrowSpec {
    param([string]$Spec)   # the [...] option list of one \arrow — returns @{dir;style;over;under} or $null
    $q = [char]34
    # comma-split at depth 0, quote-aware (labels like "[0,1]" carry commas and brackets)
    $toks = [System.Collections.Generic.List[string]]::new()
    $sb = [System.Text.StringBuilder]::new(); $depth = 0; $inQ = $false
    for ($k = 0; $k -lt $Spec.Length; $k++) {
        $c = $Spec[$k]
        if ($c -eq $q) { $inQ = -not $inQ }
        elseif (-not $inQ) {
            if ($c -eq '{') { $depth++ } elseif ($c -eq '}') { $depth-- }
            elseif ($c -eq ',' -and $depth -eq 0) { $toks.Add($sb.ToString()); [void]$sb.Clear(); continue }
        }
        [void]$sb.Append($c)
    }
    $toks.Add($sb.ToString())
    if ($toks.Count -lt 1) { return $null }
    $dir = $toks[0].Trim()
    if ($dir -cnotmatch '^[rlud]$') { return $null }   # single-step orthogonal only; diagonals/multi-step -> not this rung
    $style = 'plain'; $over = $null; $under = $null; $swap = $false
    for ($t = 1; $t -lt $toks.Count; $t++) {
        $tok = $toks[$t].Trim()
        if ($tok -eq '') { continue }
        if ($tok[0] -eq $q) {
            $close = $tok.IndexOf($q, 1); if ($close -lt 0) { return $null }
            $lbl = $tok.Substring(1, $close - 1)
            $rest = $tok.Substring($close + 1).Trim()
            if ($rest -eq "'" -or $rest -eq 'swap') { if ($null -ne $under) { return $null }; $under = $lbl }
            elseif ($rest -eq '' -or $rest -eq 'description' -or $rest -match '^near (start|end)$') { if ($null -ne $over) { return $null }; $over = $lbl }
            else { return $null }
            continue
        }
        switch -CaseSensitive ($tok) {
            'swap'      { $swap = $true; continue }
            'hook'      { $style = 'hook'; continue }
            "hook'"     { $style = 'hook'; continue }
            'two heads' { $style = 'twoheads'; continue }
            'maps to'   { $style = 'mapsto'; continue }
            'mapsto'    { $style = 'mapsto'; continue }
            'dashed'    { $style = 'dashed'; continue }
            default     { return $null }   # bends, shifts, u/d cells, Rightarrow, dotted, … — not this rung
        }
    }
    if ($swap) { $tmp = $over; $over = $under; $under = $tmp }
    return @{ dir = $dir; style = $style; over = $over; under = $under }
}
function Format-CdArrow {
    param($G)   # gap record -> KaTeX arrow, or $null when no faithful form exists
    $lab = ($null -ne $G.over -or $null -ne $G.under)
    $u = if ($null -ne $G.under) { '[{' + $G.under + '}]' } else { '' }
    $o = '{' + $(if ($null -ne $G.over) { $G.over } else { '' }) + '}'
    switch ($G.style) {
        'plain'    { if ($lab) { $(if ($G.dir -ceq 'r') { '\xrightarrow' } else { '\xleftarrow' }) + $u + $o } else { if ($G.dir -ceq 'r') { '\longrightarrow' } else { '\longleftarrow' } } }
        'hook'     { if ($lab) { $(if ($G.dir -ceq 'r') { '\xhookrightarrow' } else { '\xhookleftarrow' }) + $u + $o } else { if ($G.dir -ceq 'r') { '\hookrightarrow' } else { '\hookleftarrow' } } }
        'twoheads' { if ($lab) { $(if ($G.dir -ceq 'r') { '\xtwoheadrightarrow' } else { '\xtwoheadleftarrow' }) + $u + $o } else { if ($G.dir -ceq 'r') { '\twoheadrightarrow' } else { '\twoheadleftarrow' } } }
        'mapsto'   { if ($G.dir -cne 'r') { $null } elseif ($lab) { '\xmapsto' + $u + $o } else { '\mapsto' } }   # no left mapsto in KaTeX
        'dashed'   { if ($lab) { $null } elseif ($G.dir -ceq 'r') { '\dashrightarrow' } else { '\dashleftarrow' } }   # no labelled x-form
        default    { $null }
    }
}
function Convert-TikzcdDiagram {
    param([string]$EnvSource)   # full \begin{tikzcd}...\end{tikzcd}; returns inline chain / \begin{array}, or $null
    $m = [regex]::Match($EnvSource, '(?s)^\s*\\begin\{tikzcd\}\s*(?:\[([^\]]*)\])?(.*?)\\end\{tikzcd\}\s*$')
    if (-not $m.Success) { return $null }
    if ($m.Groups[1].Success) {
        foreach ($opt in ($m.Groups[1].Value -split ',')) {   # spacing options only; arrows=…/ampersand replacement=… are semantic — bail
            $o = $opt.Trim()
            if ($o -eq '' -or $o -ceq 'cramped' -or $o -match '^(row sep|column sep|sep)\s*=') { continue }
            return $null
        }
    }
    $inner = $m.Groups[2].Value
    # split into rows on depth-0 '\\' and cells on depth-0 '&'
    $rows = [System.Collections.Generic.List[object]]::new()
    $cells = [System.Collections.Generic.List[string]]::new()
    $sb = [System.Text.StringBuilder]::new(); $depth = 0
    for ($k = 0; $k -lt $inner.Length; $k++) {
        $c = $inner[$k]
        if ($c -eq '\') {
            if ($k + 1 -lt $inner.Length -and $inner[$k + 1] -eq '\' -and $depth -eq 0) {
                $cells.Add($sb.ToString()); [void]$sb.Clear()
                $rows.Add($cells); $cells = [System.Collections.Generic.List[string]]::new()
                $k++; continue
            }
            [void]$sb.Append($c)
            if ($k + 1 -lt $inner.Length) { $k++; [void]$sb.Append($inner[$k]) }
            continue
        }
        if ($c -eq '{') { $depth++ } elseif ($c -eq '}') { $depth-- }
        if ($c -eq '&' -and $depth -eq 0) { $cells.Add($sb.ToString()); [void]$sb.Clear(); continue }
        [void]$sb.Append($c)
    }
    $cells.Add($sb.ToString())
    if ($cells.Count -gt 1 -or $cells[0].Trim() -ne '') { $rows.Add($cells) }   # drop a trailing empty row from a final \\

    $q = [char]34
    $parsed = [System.Collections.Generic.List[object]]::new()
    foreach ($rowCells in $rows) {
        $prow = [System.Collections.Generic.List[object]]::new()
        foreach ($cell in $rowCells) {
            $arrows = [System.Collections.Generic.List[object]]::new()
            $node = [System.Text.StringBuilder]::new()
            for ($k = 0; $k -lt $cell.Length; $k++) {
                $isAr = $false; $cmdLen = 0
                if ($cell[$k] -eq '\') {
                    if ($k + 6 -lt $cell.Length -and $cell.Substring($k, 6) -ceq '\arrow' -and -not [char]::IsLetter($cell[$k + 6])) { $isAr = $true; $cmdLen = 6 }
                    elseif ($k + 3 -lt $cell.Length -and $cell.Substring($k, 3) -ceq '\ar' -and -not [char]::IsLetter($cell[$k + 3])) { $isAr = $true; $cmdLen = 3 }
                }
                if ($isAr) {
                    $j = $k + $cmdLen
                    while ($j -lt $cell.Length -and $cell[$j] -eq ' ') { $j++ }
                    if ($j -ge $cell.Length -or $cell[$j] -ne '[') { return $null }
                    # find the matching ']' quote-aware (labels carry brackets: "[0,1]")
                    $inQ = $false; $cb = -1
                    for ($p = $j + 1; $p -lt $cell.Length; $p++) {
                        if ($cell[$p] -eq $q) { $inQ = -not $inQ }
                        elseif ($cell[$p] -eq ']' -and -not $inQ) { $cb = $p; break }
                    }
                    if ($cb -lt 0) { return $null }
                    $g = Convert-TikzcdArrowSpec ($cell.Substring($j + 1, $cb - $j - 1))
                    if ($null -eq $g) { return $null }
                    $arrows.Add($g)
                    $k = $cb
                    continue
                }
                [void]$node.Append($cell[$k])
            }
            $prow.Add(@{ node = $node.ToString().Trim(); arrows = $arrows })
        }
        $parsed.Add($prow)
    }
    return (Format-DiagramGrid $parsed)
}

# --- diagram store (UNIFIED: TikZ + xy-pic) ---------------------------------------------------------
# One numbered store for every drawn diagram env, whatever the package. TikZ/tikzcd are stashed from the
# body BEFORE math protection (their node labels carry $..$); xy-pic \xymatrix spans are diverted from
# WITHIN math protection (Store-Math hook) because they live in math mode. Each gets an addressable marker
# in the flow; the render stage (Invoke-ArxivLatexToMarkdown) swaps markers for PNG links — tectonic
# compiles the snippet to PDF and MuPDF rasterizes it (PNG is the terminal register, issues/latex-oracle-
# images.md) — with tikzjax->SVG as the zero-dependency fallback for plain TikZ. A diagram that fails to
# render (or has no compiler) keeps its FLAGGED marker: never a silent drop, never KaTeX-invalid source.
$script:DiagramStore = [System.Collections.Generic.List[object]]::new()
$script:diagCounter = 0
$script:XyEncoded = 0     # xymatrix spans transpiled to semantic inline arrows (never reached the store)
$script:CdEncoded = 0     # tikzcd envs transpiled likewise (the second dialect of the same rung)
function Add-Diagram {
    param([string]$Source, [string]$Kind, [bool]$Display = $true)
    $script:diagCounter++
    $script:DiagramStore.Add([pscustomobject]@{ n = $script:diagCounter; kind = $Kind; source = $Source; display = $Display })
    return "`n`n$(Format-DiagramMarker $script:diagCounter $Kind)`n`n"
}
# the marker is the FALLBACK rendering AND the render stage's replacement key — built one way, matched
# one way. Kind rides in the text as an honest flag (what kind of diagram is unrendered here).
function Format-DiagramMarker { param([int]$N, [string]$Kind) "*[diagram $N — $Kind, not rendered]*" }

# --- math protection (env-aware): alignment envs wrap in aligned/gathered so the &/\\ stay valid -------
$script:LtxMathStore = @{}
$script:LtxMathIdx = 0
function Store-Math {
    param([string]$Content, [bool]$Display)
    # xy-pic commutative diagrams (\xymatrix) live in math mode, but KaTeX cannot render xy-pic — left as
    # $..$ they leak KaTeX-invalid source (the "silent drop" of issues/latex-oracle-images.md).
    # ENCODE FIRST: a provably-linear chain transpiles to semantic inline arrows and stays REAL MATH in
    # the markdown — the goal register, legible to a reasoning model where a PNG is not. Only when no
    # faithful encoding exists does the whole span (delimiters included, so it compiles standalone)
    # divert to the diagram store: render ladder -> PNG/marker + work-list for agent translation.
    if ($Content -match '\\xymatrix') {
        $enc = Convert-XyDiagramSpan $Content
        if ($null -ne $enc) { $script:XyEncoded++; $Content = $enc }
        else {
            # $-delimited so the standalone snippet compiles: the `standalone` class does NOT honour
            # \[..\] display delimiters (\mathbb -> "allowed only in math mode"), but $\displaystyle..$ does.
            $span = if ($Display) { '$\displaystyle ' + $Content.Trim() + '$' } else { '$' + $Content.Trim() + '$' }
            return (Add-Diagram $span 'xymatrix' $Display)
        }
    }
    # DISPLAY vs INLINE carry DISTINCT placeholder prefixes (LDISP/LMATH) so the prose-reflow pass can keep
    # a display block standalone (its own blank-separated line) while inline math flows as a token — a single
    # shared prefix would force reflow to treat every inline $x$ as a block, or glue $$..$$ into a paragraph.
    $tag = if ($Display) { 'LDISP' } else { 'LMATH' }
    $id = "@@$tag$($script:LtxMathIdx)@@"; $script:LtxMathIdx++
    # a text BOX embedded in math (\parbox{6cm}{prose}, used to stack prose in a display) is KaTeX-invalid;
    # map it to \text{prose} — which renders and keeps any nested $..$. (\mbox/\hbox already became \text
    # pre-protection; this catches the two-arg \parbox, whose width group must be dropped, only inside math.)
    $Content = [regex]::Replace($Content, '\\parbox\s*(?:\[[^\]]*\])?\s*\{[^{}]*\}', '\text')
    # \raisebox{len}[..][..]{X} / \scalebox{f}{X} in MATH position: box content is TEXT mode by TeX
    # semantics. REGISTER RULE (positional, like \ensuremath — content never changes register silently):
    # a payload that is itself \(y\) or $y$ was math all along — the box was pure presentation — so it
    # collapses back to {y} in the enclosing math register; any other payload becomes \text{X}, the
    # legal KaTeX bridge (whose nested $..$ the normalization below rewrites to \(..\)). Never drop the
    # wrapper alone: that strands text-mode delimiters inside math.
    while ($true) {
        $bm = [regex]::Match($Content, '\\(?:raisebox|scalebox)\s*\{')
        if (-not $bm.Success) { break }
        $o1 = $bm.Index + $bm.Length - 1
        $e1 = Get-BraceGroupEnd $Content $o1
        if ($e1 -lt 0) { break }
        $cur = $e1
        while ($cur -lt $Content.Length -and $Content[$cur] -eq '[') { $cb = $Content.IndexOf(']', $cur); if ($cb -lt 0) { break }; $cur = $cb + 1 }
        if ($cur -ge $Content.Length -or $Content[$cur] -ne '{') {
            $Content = $Content.Substring(0, $bm.Index) + $Content.Substring($e1)   # bare wrapper, no payload group: drop it
            continue
        }
        $e2 = Get-BraceGroupEnd $Content $cur
        if ($e2 -lt 0) { break }
        $inner = $Content.Substring($cur + 1, $e2 - $cur - 2).Trim()
        $repl =
            if ($inner -match '^\\\((.*)\\\)$') { '{' + $matches[1].Trim() + '}' }
            elseif ($inner -match '^\$(.*)\$$') { '{' + $matches[1].Trim() + '}' }
            else { '\text{' + $inner + '}' }
        $Content = $Content.Substring(0, $bm.Index) + $repl + $Content.Substring($e2)
    }
    # \ensuremath in MATH position is a no-op wrapper BY DEFINITION — unwrap it, KEEPING the brace group
    # ({ab}^c ≠ ab^c). The content never leaves the math register: this enclosing span already owns it.
    # (The PROSE position is the opposite move — promotion to an inline span — handled post-protection.)
    while ($true) {
        $em = [regex]::Match($Content, '\\ensuremath\s*\{')
        if (-not $em.Success) { break }
        $open = $em.Index + $em.Length - 1; $end = Get-BraceGroupEnd $Content $open
        if ($end -lt 0) { break }
        $Content = $Content.Substring(0, $em.Index) + $Content.Substring($open, $end - $open) + $Content.Substring($end)
    }
    # math-mode small caps: KaTeX has no \textsc in math — \text keeps the content live (algorithm-name
    # tokens like \textsc{ConvertFilt} inside pseudocode math reach here via the protected alg spans).
    $Content = $Content -replace '\\textsc(?=\s*\{)', '\text'
    # NESTING REGISTER: any $..$ still inside this span is text-bridged inner math (\text{... $x$ ...} —
    # the delimiter-aware capture above guarantees it sits inside a brace group). Emitting bare inner $
    # inside a $/$$-delimited markdown span breaks every scanner downstream (incl. render_check's
    # extractor); KaTeX accepts \(..\) inside \text — so normalize: outer delimiters own $/$$, bridged
    # inner math is ALWAYS \(..\). One unambiguous register for every consumer.
    $Content = [regex]::Replace($Content, '(?<!\\)\$(.+?)(?<!\\)\$', '\($1\)',
        [System.Text.RegularExpressions.RegexOptions]::Singleline)
    # display fenced on its own lines; inline collapses source line-breaks so a span never crosses a blank line
    $script:LtxMathStore[$id] = if ($Display) { "`n`$`$`n$($Content.Trim())`n`$`$`n" } else { '$' + (($Content -replace '\s*\r?\n\s*', ' ').Trim()) + '$' }
    return $id
}
function Protect-LatexMath {
    param([string]$Text)
    $script:LtxMathStore = @{}; $script:LtxMathIdx = 0
    $SL = [System.Text.RegularExpressions.RegexOptions]::Singleline
    # $$-display handling is the TEX-FAITHFUL scanner, NOT a regex — a global '$$(.*?)$$' here re-corrupts
    # adjacent inline delimiters ($($$x$…) that Convert-DisplayDollars deliberately left alone. Idempotent,
    # so the body path (already converted) is unharmed and the refs path gets the same faithful treatment.
    $Text = Convert-DisplayDollars $Text
    foreach ($e in 'align', 'alignat', 'flalign', 'eqnarray', 'split', 'multline') {
        $Text = [regex]::Replace($Text, "\\begin\{$e\*?\}(.*?)\\end\{$e\*?\}", { param($m) Store-Math ("\begin{aligned}`n" + $m.Groups[1].Value.Trim() + "`n\end{aligned}") $true }, $SL)
    }
    $Text = [regex]::Replace($Text, "\\begin\{gather\*?\}(.*?)\\end\{gather\*?\}", { param($m) Store-Math ("\begin{gathered}`n" + $m.Groups[1].Value.Trim() + "`n\end{gathered}") $true }, $SL)
    $Text = [regex]::Replace($Text, "\\begin\{(equation|displaymath|math)\*?\}(.*?)\\end\{\1\*?\}", { param($m) Store-Math ($m.Groups[2].Value.Trim()) $true }, $SL)
    $Text = [regex]::Replace($Text, '\\\[(.*?)\\\]', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $true }, $SL)
    # \(..\) is handled by the SAME sequential scanner as $..$ — a separate regex pass here would capture
    # a \(y\) sitting INSIDE a not-yet-scanned $..$ span (e.g. a \raisebox payload) and placeholder it away
    # before Store-Math can resolve its register positionally. One pass, TeX-faithful, in reading order.
    $Text = Protect-InlineDollarSpans $Text
    return $Text
}

# Strip macro-declaration STATEMENTS from body text (they are harvested separately; see call site).
# Brace-aware: definition bodies nest braces freely. Families: \newcommand/\renewcommand/\providecommand
# (optional arg-count/default groups), \DeclareMathOperator, paramful/paramless \def, \let aliases, and
# whole \makeatletter…\makeatother spans (@-internal plumbing is never rendered content).
function Remove-LatexDeclarations {
    param([string]$T)
    $T = [regex]::Replace($T, '(?s)\\makeatletter.*?\\makeatother', '')
    $heads = @(
        '\\(?:new|renew|provide)command\*?\s*\{?\s*\\[A-Za-z@]+\s*\}?\s*(?:\[\d+\])?\s*(?:\[[^\]]*\])?\s*\{',
        '\\DeclareMathOperator\*?\s*\{?\s*\\[A-Za-z@]+\s*\}?\s*\{',
        '\\def\s*\\[A-Za-z@]+[^{]*\{'
    )
    foreach ($h in $heads) {
        while ($true) {
            $m = [regex]::Match($T, $h)
            if (-not $m.Success) { break }
            $end = Get-BraceGroupEnd $T ($m.Index + $m.Length - 1)
            if ($end -lt 0) { break }
            $T = $T.Substring(0, $m.Index) + $T.Substring($end)
        }
    }
    $T = [regex]::Replace($T, '\\let\s*\\[A-Za-z@]+\s*=?\s*\\[A-Za-z@]+', '')
    return $T
}

# Old-style $$..$$ -> \[..\], TEX-FAITHFULLY. TeX pairs `$` sequentially: `$$` opens a DISPLAY only when
# the scanner reaches it OUTSIDE math. In `$($$\mathrm{..}$` the two adjacent $ are an inline span CLOSING
# and the next OPENING — a regex that globally pairs `$$...$$` reads them as display fences and swallows
# whole paragraphs of prose into math. Escapes skipped; an unpaired trailing $$ passes through untouched.
function Convert-DisplayDollars {
    param([string]$T)
    $sb = [System.Text.StringBuilder]::new($T.Length + 16)
    $i = 0; $n = $T.Length; $inInline = $false
    while ($i -lt $n) {
        $c = $T[$i]
        if ($c -eq '\') { [void]$sb.Append($c); if ($i + 1 -lt $n) { [void]$sb.Append($T[$i + 1]) }; $i += 2; continue }
        if ($c -ne '$') { [void]$sb.Append($c); $i++; continue }
        if (-not $inInline -and $i + 1 -lt $n -and $T[$i + 1] -eq '$') {
            $j = $i + 2; $close = -1
            while ($j -lt $n - 1) {
                if ($T[$j] -eq '\') { $j += 2; continue }
                if ($T[$j] -eq '$' -and $T[$j + 1] -eq '$') { $close = $j; break }
                $j++
            }
            if ($close -lt 0) { [void]$sb.Append('$$'); $i += 2; continue }
            [void]$sb.Append('\[').Append($T.Substring($i + 2, $close - $i - 2)).Append('\]')
            $i = $close + 2
            continue
        }
        $inInline = -not $inInline
        [void]$sb.Append($c); $i++
    }
    return $sb.ToString()
}

# Inline $..$ pairing, NESTING-AWARE. A text-mode bridge inside inline math (\text{... $x$ ...}) is legal
# LaTeX and legal KaTeX, but a non-greedy regex pairs the opener with the FIRST inner $ — shredding the
# span (unbalanced braces in math, inner math leaked to the prose passes). Interval-algebra view (the
# doccer/masks calculus): escaped characters and brace groups are masked intervals; a `$` DELIMITS only
# in the unmasked layer. This scanner is that calculus in one O(n) pass — a $ opens a span, and only a $
# at brace depth 0 (escapes skipped) closes it. Inner $s ride INSIDE the span content, where Store-Math
# normalizes them to \(..\) (see there).
function Protect-InlineDollarSpans {
    param([string]$Text)
    $sb = [System.Text.StringBuilder]::new($Text.Length + 64)
    $i = 0; $n = $Text.Length
    while ($i -lt $n) {
        $c = $Text[$i]
        if ($c -eq '\') {
            # \( opens an inline span exactly like $ — handled HERE (reading order), not by a regex pass,
            # so a \(y\) inside a $-span rides along as span content for Store-Math's positional rules.
            if ($i + 1 -lt $n -and $Text[$i + 1] -eq '(') {
                $j = $i + 2; $close = -1
                while ($j -lt $n - 1) {
                    if ($Text[$j] -eq '\') { if ($Text[$j + 1] -eq ')') { $close = $j; break }; $j += 2; continue }
                    $j++
                }
                if ($close -lt 0) { [void]$sb.Append('\('); $i += 2; continue }   # unclosed: copy verbatim
                [void]$sb.Append((Store-Math ($Text.Substring($i + 2, $close - $i - 2).Trim()) $false))
                $i = $close + 2
                continue
            }
            # any other escaped char (incl. \$ \{ \}): copy both, never interpret
            [void]$sb.Append($c); if ($i + 1 -lt $n) { [void]$sb.Append($Text[$i + 1]) }
            $i += 2; continue
        }
        if ($c -ne '$') { [void]$sb.Append($c); $i++; continue }
        $j = $i + 1; $depth = 0; $close = -1
        while ($j -lt $n) {
            $d = $Text[$j]
            if ($d -eq '\') { $j += 2; continue }
            if ($d -eq '{') { $depth++ }
            elseif ($d -eq '}') { if ($depth -gt 0) { $depth-- } }   # stray } tolerated, never negative
            elseif ($d -eq '$' -and $depth -eq 0) { $close = $j; break }
            $j++
        }
        if ($close -lt 0 -or $close -eq $i + 1) {   # unpaired $, or an empty $$ remnant: copy verbatim
            [void]$sb.Append($c); $i++; continue
        }
        [void]$sb.Append((Store-Math ($Text.Substring($i + 1, $close - $i - 1).Trim()) $false))
        $i = $close + 1
    }
    return $sb.ToString()
}
function Restore-LatexMath {
    param([string]$Text)
    # iterate to a fixed point: a stored span can contain another placeholder (nested $..$ around a display
    # placeholder), and hashtable key order is arbitrary — a single ordered pass can re-introduce an already-
    # processed placeholder and leak it. Re-run until none remain (bounded by nesting depth).
    for ($pass = 0; $pass -lt 8 -and ($Text -match '@@L(?:MATH|DISP)\d+@@'); $pass++) {
        $Text = [regex]::Replace($Text, '@@L(?:MATH|DISP)\d+@@', { param($m) if ($script:LtxMathStore.Contains($m.Value)) { $script:LtxMathStore[$m.Value] } else { $m.Value } })
    }
    return $Text
}

# --- inline text-command cleanup, accents, old-style {\em ..} (used in body + bib text) ----------------
function Convert-LatexInline {
    param([string]$T)
    $T = $T -replace '\\(?:textbf|textsc)\{([^{}]*)\}', '**$1**'
    $T = $T -replace '\\(?:emph|textit|textsl)\{([^{}]*)\}', '*$1*'
    $T = [regex]::Replace($T, '\\texttt\{([^{}]*)\}', { param($m) '`' + $m.Groups[1].Value.Trim() + '`' })   # trim: no space inside code spans (MD038)
    $T = $T -replace '\\(?:textrm|textnormal|mbox|text)\{([^{}]*)\}', '$1'
    $T = $T -replace '\\(?:newblock|noindent|maketitle|centering)\b', ''
    $T = $T -replace '\\&', '&' -replace '\\%', '%' -replace '\\_', '_' -replace '\\#', '#' -replace '\\\$', '$'
    $T = $T -replace '~', ' ' -replace '\\,|\\;|\\:|\\!', ' ' -replace '``|''''', '"'
    return $T.Trim()
}
# Case-sensitive (ORDINAL) maps: a PowerShell hashtable is case-INSENSITIVE, so \'a and \'A would collide —
# build Dictionaries with an ordinal comparer instead. Keys are the LaTeX accent spelling (grave `` -> real
# backtick), values the precomposed glyph; Apply-Accents normalizes the braced form \'{e} to \'e first. The
# accent-command family (\c \v \u \H) normalizes to a SPACE key (\c c); the diacritic family (\' \` \" \^ \~
# \= \.) to a no-space key (\'e, \=o).
$script:AccentMap = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
$script:LigatureMap = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
$__accPairs = @(
    "\'a", 'á', "\'e", 'é', "\'i", 'í', "\'o", 'ó', "\'u", 'ú', "\'y", 'ý', "\'n", 'ń', "\'c", 'ć', "\'s", 'ś', "\'z", 'ź', "\'r", 'ŕ', "\'l", 'ĺ',
    "\'A", 'Á', "\'E", 'É', "\'I", 'Í', "\'O", 'Ó', "\'U", 'Ú', "\'C", 'Ć', "\'N", 'Ń', "\'S", 'Ś', "\'Z", 'Ź',
    "\``a", 'à', "\``e", 'è', "\``i", 'ì', "\``o", 'ò', "\``u", 'ù', "\``A", 'À', "\``E", 'È', "\``O", 'Ò', "\``U", 'Ù',
    '\"a', 'ä', '\"e', 'ë', '\"i', 'ï', '\"o', 'ö', '\"u', 'ü', '\"y', 'ÿ', '\"A', 'Ä', '\"E', 'Ë', '\"O', 'Ö', '\"U', 'Ü',
    '\^a', 'â', '\^e', 'ê', '\^i', 'î', '\^o', 'ô', '\^u', 'û', '\^A', 'Â', '\^E', 'Ê', '\^O', 'Ô', '\^U', 'Û',
    '\~n', 'ñ', '\~a', 'ã', '\~o', 'õ', '\~N', 'Ñ', '\~A', 'Ã', '\~O', 'Õ',
    '\c c', 'ç', '\c C', 'Ç', '\c s', 'ş',
    '\v s', 'š', '\v c', 'č', '\v z', 'ž', '\v e', 'ě', '\v r', 'ř', '\v n', 'ň', '\v S', 'Š', '\v C', 'Č', '\v Z', 'Ž',
    '\=a', 'ā', '\=e', 'ē', '\=i', 'ī', '\=o', 'ō', '\=u', 'ū', '\.z', 'ż', '\u g', 'ğ', '\H o', 'ő', '\H u', 'ű'
)
for ($__i = 0; $__i -lt $__accPairs.Count; $__i += 2) { $script:AccentMap[$__accPairs[$__i]] = $__accPairs[$__i + 1] }
$__ligPairs = @('aa', 'å', 'AA', 'Å', 'ae', 'æ', 'AE', 'Æ', 'oe', 'œ', 'OE', 'Œ', 'ss', 'ß', 'o', 'ø', 'O', 'Ø', 'l', 'ł', 'L', 'Ł', 'i', 'ı', 'j', 'ȷ')
for ($__i = 0; $__i -lt $__ligPairs.Count; $__i += 2) { $script:LigatureMap[$__ligPairs[$__i]] = $__ligPairs[$__i + 1] }
function Apply-Accents {
    param([string]$T)
    # normalize the braced/grouped spellings so ONE map covers all forms: \'{e}->\'e ; \c{c}->\c c (space key).
    $T = [regex]::Replace($T, "\\([``'^""~=.])\s*\{([a-zA-Z])\}", '\$1$2')
    $T = [regex]::Replace($T, '\\([cvuH])\s*\{([a-zA-Z])\}', '\$1 $2')
    foreach ($k in $script:AccentMap.Keys) { $T = $T.Replace($k, $script:AccentMap[$k]) }
    # a diacritic we have no glyph for: drop the accent, keep the base letter (never leak \'x into prose)
    $T = [regex]::Replace($T, "\\([``'^""~=.])\s*([a-zA-Z])", '$2')
    $T = [regex]::Replace($T, '\\([cvuH])\s+([a-zA-Z])', '$2')
    # single-token ligatures/specials: \aa \o \ss \ae \oe \l (+ upper), dotless \i \j — word-bounded (\o != \omega),
    # then SWALLOW the control-word terminator ({} or one space) so \ss e -> "ße", not "ß e".
    $T = [regex]::Replace($T, '\\(aa|AA|ae|AE|oe|OE|ss|o|O|l|L|i|j)(?![a-zA-Z])(?:\{\}|[ \t])?', { param($m) if ($script:LigatureMap.ContainsKey($m.Groups[1].Value)) { $script:LigatureMap[$m.Groups[1].Value] } else { $m.Value } })
    return $T
}

# Title hygiene: a \title{..} (or a manual \Large{..}) body may carry \thanks{funding}, \footnote{..}, a
# \\ stacked subtitle, and font/format commands — none of which belong in the H1. Strip the footnote-family
# notes brace-aware (their text holds braces), flatten \\, drop residual format commands + braces, collapse ws.
function Clean-LatexTitle {
    param([string]$T)
    if ([string]::IsNullOrWhiteSpace($T)) { return $null }
    $T = Replace-BracedCommand $T '\thanks' { '' }
    $T = Replace-BracedCommand $T '\footnote' { '' }
    $T = $T -replace '\\(?:thanks|footnotemark|footnote)\b', ''
    $T = $T -replace '\\\\', ' '                                              # \\ stacked title/subtitle -> space
    $T = $T -replace '\\(?:Large|LARGE|huge|Huge|large|Small|small|normalsize|textbf|textsc|textit|textsl|textrm|textnormal|emph|mathbf|mathrm|bf|it|sc|sl|em|rm|centering|newline|par|scshape|bfseries|itshape)\b', ''
    $T = $T -replace '[{}]', ''
    return ([regex]::Replace($T, '\s+', ' ')).Trim()
}

# old-style font TOGGLES: {\em ..}/{\it ..}/{\bf ..}/{\sc ..}/{\tt ..} — the switch form (vs \emph{..}). The
# body transforms only catch the \cmd{..} argument form, so without this the switch form leaks verbatim as
# literal "{\em word}". Brace-aware + iterated so nesting and long spans resolve; runs while math is protected.
function Convert-BraceToggles {
    param([string]$T)
    $wrap = @{ em = '*'; it = '*'; sl = '*'; itshape = '*'; slshape = '*'; bf = '**'; bfseries = '**'; sc = '**'; scshape = '**'; tt = '`'; ttfamily = '`' }
    for ($i = 0; $i -lt 500; $i++) {
        $m = [regex]::Match($T, '\{\s*\\(em|itshape|it|slshape|sl|bfseries|bf|scshape|sc|ttfamily|tt|rmfamily|rm|sffamily|sf|normalfont)\b[ \t]*')
        if (-not $m.Success) { break }
        $end = Get-BraceGroupEnd $T $m.Index
        if ($end -lt 0) { break }
        $inner = $T.Substring($m.Index + $m.Length, $end - 1 - ($m.Index + $m.Length))
        $w = if ($wrap.ContainsKey($m.Groups[1].Value)) { $wrap[$m.Groups[1].Value] } else { '' }
        $repl = if ($w -and $inner.Trim()) { $w + $inner.Trim() + $w } else { $inner }
        $T = $T.Substring(0, $m.Index) + $repl + $T.Substring($end)
    }
    return $T
}
# frame/box wrappers that carry NO markdown structure: keep the CONTENT arg, discard the frame and any
# leading width/pos/colour args (\parbox{width}{..}, \fbox{..}, \centerline{..}). Brace-aware + iterated so
# a nested \fbox{\parbox{\textwidth}{..}} collapses to just its body instead of leaking the wrapper braces.
function Unwrap-Boxes {
    param([string]$T)
    $lead = @{ fbox = 0; framebox = 0; centerline = 0; makebox = 0; parbox = 1; colorbox = 1; fcolorbox = 2; raisebox = 1 }
    $names = ($lead.Keys | Sort-Object { $_.Length } -Descending | ForEach-Object { [regex]::Escape($_) }) -join '|'
    for ($iter = 0; $iter -lt 200; $iter++) {
        $m = [regex]::Match($T, "\\($names)\b")
        if (-not $m.Success) { break }
        $name = $m.Groups[1].Value; $cur = $m.Index + $m.Length; $ok = $true
        while ($cur -lt $T.Length -and $T[$cur] -eq ' ') { $cur++ }
        while ($cur -lt $T.Length -and $T[$cur] -eq '[') { $cl = $T.IndexOf(']', $cur); if ($cl -lt 0) { $ok = $false; break }; $cur = $cl + 1; while ($cur -lt $T.Length -and $T[$cur] -eq ' ') { $cur++ } }
        if (-not $ok) { break }
        for ($k = 0; $k -lt $lead[$name]; $k++) {
            while ($cur -lt $T.Length -and $T[$cur] -eq ' ') { $cur++ }
            if ($cur -lt $T.Length -and $T[$cur] -eq '[') { $cl = $T.IndexOf(']', $cur); if ($cl -ge 0) { $cur = $cl + 1 } }
            while ($cur -lt $T.Length -and $T[$cur] -eq ' ') { $cur++ }
            if ($cur -lt $T.Length -and $T[$cur] -eq '{') { $e = Get-BraceGroupEnd $T $cur; if ($e -lt 0) { $ok = $false; break }; $cur = $e } else { $ok = $false; break }
        }
        if (-not $ok) { break }
        while ($cur -lt $T.Length -and $T[$cur] -eq ' ') { $cur++ }
        if ($cur -lt $T.Length -and $T[$cur] -eq '{') {
            $e = Get-BraceGroupEnd $T $cur; if ($e -lt 0) { break }
            $T = $T.Substring(0, $m.Index) + $T.Substring($cur + 1, $e - $cur - 2) + $T.Substring($e)
        } else { $T = $T.Substring(0, $m.Index) + $T.Substring($m.Index + $m.Length) }   # no content group: drop the bare command token, make progress
    }
    return $T
}

# STANDARDS §4: remove hard wraps. LaTeX source wraps prose at ~80 cols; those breaks are semantically
# meaningless and, kept verbatim, sever token sequences (and every stray whole-line comment left a blank
# that split a paragraph). Reflow each blank-line-separated BLOCK: fold a wrapped continuation line into the
# logical line above it, UNLESS the line opens a markdown block-construct (heading, list item, table row,
# blockquote) or the block is a standalone display-math/algorithm/verbatim placeholder — those pass through
# intact. Must run while math is protected: LDISP display tokens are forced onto their own blank-separated
# line first, so a paragraph is never glued to a $$-block and inline $x$ (LMATH) rides along as plain text.
function Join-WrappedProse {
    param([string]$T)
    $T = [regex]::Replace($T, '[ \t]*@@(LDISP|ALG|VERB)(\d+)@@[ \t]*', "`n`n@@`$1`$2@@`n`n")
    $T = [regex]::Replace($T, '\n{3,}', "`n`n")
    $blocks = [regex]::Split($T, '\n[ \t]*\n')
    $out = [System.Collections.Generic.List[string]]::new()
    foreach ($blk in $blocks) {
        if ($blk.Trim() -eq '') { continue }
        if ($blk -match '^\s*@@(?:LDISP|ALG|VERB)\d+@@\s*$') { $out.Add($blk.Trim()); continue }   # standalone placeholder block
        $logical = [System.Collections.Generic.List[string]]::new()
        foreach ($ln in ($blk -split '\n')) {
            $s = $ln.Trim()
            if ($s -eq '') { continue }
            $starter = $s -match '^(#{1,6}\s|[-*+]\s|\d+[.)]\s|>\s|\|)'                              # heading / bullet / ordered / quote / table row
            if ($logical.Count -eq 0 -or $starter -or ($logical[$logical.Count - 1] -match '^#{1,6}\s')) { $logical.Add($s) }
            else { $logical[$logical.Count - 1] = $logical[$logical.Count - 1] + ' ' + $s }
        }
        $out.Add(($logical -join "`n"))
    }
    return ($out -join "`n`n")
}

# Parse \newtheorem declarations into a counter MODEL so theorem-like envs number EXACTLY as the rendered
# paper does: env -> @{ disp; group (the counter it shares, resolved to the chain root); within (numbered +
# reset per \section); star (unnumbered) }. \newtheorem{x}{D}=own counter; {x}[y]{D}=shares y's counter;
# {x}{D}[section]=numbered within section; \newtheorem*{x}{D}=unnumbered. Declarations WIN; the standard names
# get sensible defaults when the paper declares none (theorem family shares one flat counter; other thm-likes
# surface UNNUMBERED — we never fabricate a scheme we can't read).
# --- custom (author-declared) counters -------------------------------------------------------------
# The standard counters (equation/theorem/figure/section) are handled by Build-LabelMaps + the theorem
# walk. But papers \newcounter their own (e.g. \newcounter{desccounter} for lettered proof cases) and
# reference them with \Alph{}/\ref{} — the standard walk knows nothing of these, so \Alph{desccounter}
# leaks and \ref{...} resolves to "?". This is a SCOPED LaTeX counter state-machine: walk the resolved
# body in document order, tracking each custom counter's value, so \Alph{c}/\arabic{c}/… render to their
# letter/number and a \label bound to a \refstepcounter (or a plain enumerate \item) resolves faithfully.
function ConvertTo-Roman {
    param([int]$N)
    if ($N -le 0) { return [string]$N }
    $out = ''
    foreach ($p in @(@(1000, 'M'), @(900, 'CM'), @(500, 'D'), @(400, 'CD'), @(100, 'C'), @(90, 'XC'), @(50, 'L'), @(40, 'XL'), @(10, 'X'), @(9, 'IX'), @(5, 'V'), @(4, 'IV'), @(1, 'I'))) {
        while ($N -ge $p[0]) { $out += $p[1]; $N -= $p[0] }
    }
    return $out
}
function Format-Counter {
    param([int]$N, [string]$Style)
    # -CaseSensitive is LOAD-BEARING: PS switch is case-insensitive by default, so 'Alph' would also match
    # the 'alph' arm (and 'Roman' the 'roman' arm), emitting BOTH values ("A a"). [[powershell-text-mutation-traps]]
    switch -CaseSensitive ($Style) {
        'Alph'  { if ($N -ge 1 -and $N -le 26) { [string][char](64 + $N) } else { [string]$N } }
        'alph'  { if ($N -ge 1 -and $N -le 26) { [string][char](96 + $N) } else { [string]$N } }
        'Roman' { ConvertTo-Roman $N }
        'roman' { (ConvertTo-Roman $N).ToLowerInvariant() }
        default { [string]$N }   # arabic
    }
}
function Resolve-CustomCounters {
    param([string]$Body, [string]$Tex)
    # counters we may touch: those the SOURCE declares/drives (never the standard ones, which get no
    # source-level \newcounter/\refstepcounter — so \arabic{page} etc. is left alone).
    $tracked = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($m in [regex]::Matches($Tex, '\\(?:newcounter|(?:step|refstep|set|addto)counter)\s*\{([A-Za-z@]+)\}')) { [void]$tracked.Add($m.Groups[1].Value) }
    if ($tracked.Count -eq 0) { return @{ body = $Body; labels = @{} } }

    $ci = [System.StringComparer]::Ordinal
    $val = [System.Collections.Generic.Dictionary[string, int]]::new($ci)
    $labels = [System.Collections.Generic.Dictionary[string, string]]::new($ci)
    $enum = [System.Collections.Generic.Stack[int]]::new()   # nested enumerate item counters
    # refTarget (the value the NEXT \label captures) lives in a hashtable: a bare string assigned inside the
    # MatchEvaluator would write to a scriptblock-LOCAL, not persist across matches (PS value-type scoping).
    $st = @{ rt = $null }
    $styleOf = @{}; foreach ($c in $tracked) { $styleOf[$c] = Get-CounterStyle $Tex $c }

    $rx = [regex]'\\newcounter\s*\{(?<nc>[A-Za-z@]+)\}(?:\[[A-Za-z@]+\])?|\\setcounter\s*\{(?<sc>[A-Za-z@]+)\}\s*\{(?<sv>-?\d+)\}|\\addtocounter\s*\{(?<ac>[A-Za-z@]+)\}\s*\{(?<av>-?\d+)\}|\\refstepcounter\s*\{(?<rc>[A-Za-z@]+)\}|\\stepcounter\s*\{(?<stc>[A-Za-z@]+)\}|\\(?<vs>Alph|alph|Roman|roman|arabic)\s*\{(?<vc>[A-Za-z@]+)\}|\\begin\s*\{enumerate\}|\\end\s*\{enumerate\}|\\item\s*(?<br>\[)?|\\label\s*\{(?<lb>[^{}]+)\}'
    $body2 = $rx.Replace($Body, {
            param($m)
            if ($m.Groups['nc'].Success) { $val[$m.Groups['nc'].Value] = 0; return '' }
            if ($m.Groups['sc'].Success) { $val[$m.Groups['sc'].Value] = [int]$m.Groups['sv'].Value; return '' }
            if ($m.Groups['ac'].Success) { $c = $m.Groups['ac'].Value; $cur = if ($val.ContainsKey($c)) { $val[$c] } else { 0 }; $val[$c] = $cur + [int]$m.Groups['av'].Value; return '' }
            if ($m.Groups['rc'].Success) { $c = $m.Groups['rc'].Value; $cur = if ($val.ContainsKey($c)) { $val[$c] } else { 0 }; $val[$c] = $cur + 1; $sty = if ($styleOf.ContainsKey($c)) { $styleOf[$c] } else { 'arabic' }; $st.rt = Format-Counter $val[$c] $sty; return '' }
            if ($m.Groups['stc'].Success) { $c = $m.Groups['stc'].Value; $cur = if ($val.ContainsKey($c)) { $val[$c] } else { 0 }; $val[$c] = $cur + 1; return '' }
            if ($m.Groups['vs'].Success) {
                $c = $m.Groups['vc'].Value
                if (-not $tracked.Contains($c) -or -not $val.ContainsKey($c)) { return $m.Value }   # untracked -> leave for the straggler strip
                return (Format-Counter $val[$c] $m.Groups['vs'].Value)
            }
            if ($m.Value -match '^\\begin') { $enum.Push(0); return $m.Value }
            if ($m.Value -match '^\\end') { if ($enum.Count) { [void]$enum.Pop() }; return $m.Value }
            if ($m.Value -match '^\\item') {
                if (-not $m.Groups['br'].Success -and $enum.Count) { $top = $enum.Pop() + 1; $enum.Push($top); $st.rt = [string]$top }   # a bracketed \item[x] does NOT step the list counter
                return $m.Value
            }
            if ($m.Groups['lb'].Success) { if ($null -ne $st.rt) { $labels[$m.Groups['lb'].Value] = $st.rt }; return $m.Value }
            return $m.Value
        })
    return @{ body = $body2; labels = $labels }
}
# a counter's DISPLAY style from \renewcommand{\the<c>}{\Alph{<c>}} (default arabic)
function Get-CounterStyle {
    param([string]$Tex, [string]$Counter)
    $m = [regex]::Match($Tex, '\\(?:re)?newcommand\*?\s*\{?\s*\\the' + [regex]::Escape($Counter) + '\s*\}?\s*\{\s*\\(Alph|alph|Roman|roman|arabic)\b')
    if ($m.Success) { return $m.Groups[1].Value }
    return 'arabic'
}

function Get-TheoremModel {
    param([string]$Tex)
    $model = [ordered]@{}
    foreach ($n in 'theorem', 'lemma', 'corollary', 'proposition') { $model[$n] = @{ star = $false; disp = (Get-Culture).TextInfo.ToTitleCase($n); group = 'theorem'; within = $false } }
    foreach ($n in 'definition', 'defn', 'remark', 'example', 'note', 'claim', 'observation', 'notation', 'conjecture', 'assumption', 'fact', 'property', 'question', 'construction', 'convention', 'result', 'resultx') {
        $disp = if ($n -in 'result', 'resultx') { 'Result' } elseif ($n -eq 'defn') { 'Definition' } else { (Get-Culture).TextInfo.ToTitleCase($n) }
        $model[$n] = @{ star = $true; disp = $disp; group = $n; within = $false }
    }
    $decl = [ordered]@{}
    foreach ($m in [regex]::Matches($Tex, '\\newtheorem(\*?)\s*\{([^{}]+)\}(?:\s*\[([^\]]+)\])?\s*\{([^{}]+)\}(?:\s*\[([^\]]+)\])?')) {
        $name = $m.Groups[2].Value
        if ($decl.Contains($name)) { continue }                                  # first declaration wins (papers redeclare in comments/appendix)
        $decl[$name] = @{ star = ($m.Groups[1].Value -eq '*'); shared = $m.Groups[3].Value; disp = $m.Groups[4].Value; within = ($m.Groups[5].Value -ne '') }
    }
    foreach ($name in @($decl.Keys)) {
        $d = $decl[$name]; $root = $name; $seen = @{}
        while ($decl.Contains($root) -and $decl[$root].shared -and -not $seen.Contains($root)) { $seen[$root] = 1; $root = $decl[$root].shared }
        $within = if ($decl.Contains($root)) { $decl[$root].within } else { $d.within }
        $model[$name] = @{ star = $d.star; disp = $d.disp; group = $root; within = $within }
    }
    return $model
}
# Single ordered pass over \section-family markers, theorem-like envs, and \labels. Numbers each theorem-like
# env per the counter model (shared groups; a within-section group resets each \section and prefixes the
# section number), rewrites its \begin{env}[note] to a bold numbered label and drops \end{env}, and records
# label->number for BOTH sections and theorem envs so \ref/\cref resolve to the paper's actual numbers instead
# of "?". Section markers and everything else are emitted verbatim (the section-render pass handles them next).
# Label association: a \section/\begin{thm} arms `pending`, consumed only by the IMMEDIATELY-following \label
# (any other token clears it) — so an equation \label deeper inside a theorem is not mis-captured.
function Convert-CrossRefEnvs {
    param([string]$Body, $Model)
    # label->number maps ordinal (case-sensitive \label keys); $ctr/$within key on env names — same rule
    $thmMap = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $secMap = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $ctr = @{}; $within = @{}
    $sec = 0; $sub = 0; $subsub = 0
    $sb = [System.Text.StringBuilder]::new(); $pos = 0; $pending = $null
    $rx = [regex]'\\(section|subsection|subsubsection)(\*?)\s*\{|\\begin\{([A-Za-z][A-Za-z0-9]*\*?)\}[ \t]*(?:\[([^\]]*)\])?|\\end\{([A-Za-z][A-Za-z0-9]*\*?)\}|\\label\{([^{}]+)\}'
    foreach ($m in $rx.Matches($Body)) {
        if ($m.Index -lt $pos) { continue }
        [void]$sb.Append($Body.Substring($pos, $m.Index - $pos))
        $emit = $m.Value
        if ($m.Groups[1].Success) {                                              # \section family
            if ($m.Groups[2].Value -ne '*') {
                $num = switch ($m.Groups[1].Value) {
                    'section' { $sec++; $sub = 0; $subsub = 0; foreach ($g in @($within.Keys)) { if ($within[$g]) { $ctr[$g] = 0 } }; "$sec" }
                    'subsection' { $sub++; $subsub = 0; "$sec.$sub" }
                    'subsubsection' { $subsub++; "$sec.$sub.$subsub" }
                }
                $pending = @{ kind = 'sec'; num = $num }
            } else { $pending = $null }
        }
        elseif ($m.Groups[3].Success) {                                          # \begin{env}
            $env = $m.Groups[3].Value; $note = if ($m.Groups[4].Success) { " ($($m.Groups[4].Value))" } else { '' }
            if ($Model.Contains($env)) {
                $e = $Model[$env]
                if ($e.star) { $emit = "`n`n**$($e.disp)$note.** "; $pending = $null }
                else {
                    $g = $e.group; if (-not $ctr.Contains($g)) { $ctr[$g] = 0 }; $within[$g] = $e.within
                    $ctr[$g]++; $num = if ($e.within) { "$sec.$($ctr[$g])" } else { "$($ctr[$g])" }
                    $emit = "`n`n**$($e.disp) $num$note.** "; $pending = @{ kind = 'thm'; num = $num }
                }
            }
            # a NON-model \begin (equation, enumerate, …) leaves `pending` intact, so a theorem's label placed
            # AFTER its statement body (\begin{theorem} <stmt> \label{..}) is still captured (first-label-in-env).
        }
        elseif ($m.Groups[5].Success) { if ($Model.Contains($m.Groups[5].Value)) { $emit = ''; $pending = $null } }   # theorem env closed: disarm
        elseif ($m.Groups[6].Success -and $pending) {                            # \label — FIRST label in the armed env/section wins
            if ($pending.kind -eq 'sec') { $secMap[$m.Groups[6].Value] = $pending.num } else { $thmMap[$m.Groups[6].Value] = $pending.num }
            $pending = $null
        }
        [void]$sb.Append($emit); $pos = $m.Index + $m.Length
    }
    [void]$sb.Append($Body.Substring($pos))
    return @{ body = $sb.ToString(); thm = $thmMap; sec = $secMap }
}

# --- the core transform: LaTeX -> markdown ----------------------------------------------------------
function ConvertFrom-Latex {
    param([string]$Tex, [string]$Bbl)
    $Tex = Protect-VerbatimBlocks $Tex                                         # code is code: stash before % -stripping and $ -protection
    $Tex = [regex]::Replace($Tex, '(?m)^[ \t]*(?<!\\)%.*\r?\n', '')            # whole-line comments: drop the line so no spurious blank line (which splits a paragraph) survives
    $Tex = [regex]::Replace($Tex, '(?m)(?<!\\)%.*$', '')                       # trailing comments: keep code before % — (?m) is LOAD-BEARING (without it, .*$ only strips the LAST line, leaking mid-doc comment text — e.g. a commented `$$` mispairs display math and swallows prose)
    $macros = Get-LatexMacros $Tex
    # papers that INLINE a dashed-arrows snippet define \xdash… themselves via \mathpalette/@-internals
    # KaTeX can never render — drop those DEFS so the names stay unexpanded and the compat table below
    # maps them to verified \overset forms instead of their bodies exploding into \da@ soup.
    foreach ($n in 'xdashrightarrow', 'xdashleftarrow', 'xdashleftrightarrow') { if ($macros.Contains($n)) { $macros.Remove($n) } }
    $title = Clean-LatexTitle (Get-LatexCommandArg $Tex '\title')
    $bm = [regex]::Match($Tex, '\\begin\{document\}(.*)\\end\{document\}', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $body = if ($bm.Success) { $bm.Groups[1].Value } else { $Tex }

    # fallback for manually-typeset titles (no \title{}): first big-font block in the frontmatter, in EITHER
    # idiom — {\Large ..} (brace-first) or \Large{..} (command-first, e.g. arXiv:2210.00916 "ONE DIAMOND..").
    if (-not $title) {
        $lm = [regex]::Match($body, '\{\s*\\(?:Large|LARGE|huge|Huge)\b')
        if ($lm.Success) { $g = Get-LatexBracedArg $body $lm.Index; if ($g) { $title = Clean-LatexTitle $g } }
        if (-not $title) {
            $lm2 = [regex]::Match($body, '\\(?:Large|LARGE|huge|Huge)\s*\{')
            if ($lm2.Success) { $g2 = Get-LatexBracedArg $body ($lm2.Index + $lm2.Length - 1); if ($g2) { $title = Clean-LatexTitle $g2 } }
        }
    }

    # excluded content never renders in the PDF, so it must not pollute the ground-truth markdown: the
    # `comment` environment (comment package) and \iffalse..\fi conditional blocks are dropped wholesale.
    $body = [regex]::Replace($body, '(?s)\\begin\{comment\}.*?\\end\{comment\}', '')
    $body = [regex]::Replace($body, '(?s)\\iffalse\b.*?\\fi\b', '')
    $body = [regex]::Replace($body, '(?s)\\begin\{CCSXML\}.*?\\end\{CCSXML\}', '')          # ACM CCS concept XML: metadata, never renders
    # inline \begin{thebibliography}..\end{thebibliography}: the References section is emitted separately from
    # the .bbl (Get-LatexReferences, with an inline-thebibliography fallback), so drop it here rather than let
    # its \bibitem bodies bleed into the prose as an unnumbered tail.
    $body = [regex]::Replace($body, '(?s)\\begin\{thebibliography\}\s*(?:\{[^{}]*\})?.*?\\end\{thebibliography\}', '')

    # body-position macro DECLARATIONS: already harvested by Get-LatexMacros (which scans the FULL source),
    # so left in the body they are pure machinery — and worse, they SELF-MANGLE under expansion
    # (\newcommand{\lefti}{\vartriangleleft}: the \lefti inside its own declaration expands, leaking
    # "\newcommand{\vartriangleleft}{\vartriangleleft}" into the prose). Strip the statements, brace-aware.
    # Verbatim listings are already placeholders here, so code samples showing \newcommand are untouched.
    $body = Remove-LatexDeclarations $body

    # old-style $$display$$ -> \[..\] up front: display and inline math otherwise share the `$` delimiter, so
    # the parser conflates them and one mis-pair cascades through every downstream `$` (swallowing prose).
    # TEX-FAITHFUL scan, not a regex: `$$` only opens a DISPLAY when reached outside math — in `$($$x$…`
    # (an inline span closing and the next immediately opening) the pair is two INLINE delimiters.
    $body = Convert-DisplayDollars $body

    # Diagrams: STASH the source and drop a numbered marker in the flow. The source is the AUTHORITY for
    # diagrams (PDF-side image extraction is unreliable) — Invoke-ArxivLatexToMarkdown renders each stashed
    # env and swaps the marker for a live image link; where no renderer is present or a diagram fails to
    # compile, the addressable flagged marker stays. Preamble hints (tikz libraries + tikz-adjacent
    # packages) are captured for the tikzjax fallback; the FULL preamble is replayed by tectonic.
    $script:DiagramStore = [System.Collections.Generic.List[object]]::new()
    $script:diagCounter = 0
    $script:XyEncoded = 0
    $script:CdEncoded = 0
    $pre = $Tex.Substring(0, [Math]::Max(0, $Tex.IndexOf('\begin{document}')))
    $script:TikzPreamble = $pre    # replayed verbatim by the tectonic snippet builder (author macros are the fidelity trap)
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
    # tikzpicture / tikzcd: text-mode float envs — stash the whole env before math protection (node labels
    # carry their own $..$). xy-pic \begin{xy}..\end{xy} is likewise a text-mode env (the \xymatrix COMMAND
    # is math-mode and is diverted from Store-Math instead). One unified store, numbered in document order.
    # tikzcd goes ENCODE-FIRST: a provably-linear chain transpiles to inline arrows and is emitted as a
    # display-math span (real math, the goal register) instead of ever reaching the store. Authors often
    # wrap tikzcd in \[..\] themselves — strip that wrapper first so the emission never nests delimiters.
    $body = [regex]::Replace($body, '(?s)\\\[\s*(\\begin\{tikzcd\}.*?\\end\{tikzcd\})\s*\\\]', '$1')
    # core-LaTeX `picture` envs (\put/\line vector overlays) are drawn figures like tikzpicture — same
    # store, same tectonic ladder; leaked raw they spray \put coordinates through the prose.
    $body = [regex]::Replace($body, '(?s)\\begin\{(tikzpicture|tikzcd|picture)\}.*?\\end\{\1\}', {
            param($m)
            if ($m.Groups[1].Value -eq 'tikzcd') {
                $enc = Convert-TikzcdDiagram $m.Value
                if ($null -ne $enc) { $script:CdEncoded++; return "`n`n\[`n$enc`n\]`n`n" }
            }
            Add-Diagram $m.Value $m.Groups[1].Value $true })
    $body = [regex]::Replace($body, '(?s)\\begin\{xy\}.*?\\end\{xy\}', {
            param($m) Add-Diagram $m.Value 'xy' $true })

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
    # amsmath's capitalized accent aliases (\Bar, \Hat, … — for nesting accents) are not in KaTeX; the
    # lowercase accents are the same glyphs. Case-sensitive + word-bounded (\Vec must not touch \Vector).
    $body = [regex]::Replace($body, '\\(Bar|Hat|Tilde|Vec|Dot|Ddot|Check|Breve|Acute|Grave)(?![a-zA-Z])',
        { param($m) '\' + $m.Groups[1].Value.ToLowerInvariant() })
    $body = $body -replace '\\lefteqn\b', ''                                   # KaTeX-unsupported; drop, keep its {group}
    $body = $body -replace '\\(?:mbox|hbox)(?=\s*\{)', '\text'                 # KaTeX has no \mbox/\hbox — \text works in math AND is unwrapped in prose below; must precede Protect-LatexMath
    $body = Convert-BorderMatrix $body                                         # \bordermatrix -> ruled array

    $body = Expand-LatexMacros $body $macros                                   # macros (incl inside math)

    # --- KaTeX-compat substitutions (post-expansion; every target render-check-verified) --------------
    # Semantic upgrades first: the hand-rolled amalgamation (180°-rotated Π, literally named \Amalg in
    # 2307) IS \amalg; the -45°-rotated arrows are the diagonal add/delete markers (\searrow/\nwarrow).
    # Rotation of anything else is presentation — keep the content, drop the box. \xdash… arrows (amsmath
    # dashed x-arrows, KaTeX-absent) keep BOTH their label and their dashedness via \overset over the
    # KaTeX dashed arrows. \nonscript is a script-style spacing conditional — content-free, dropped.
    $body = [regex]::Replace($body, '(?:\\mathbin\{\\text\{)?\\rotatebox\s*(?:\[[^\]]*\])?\s*\{180\}\s*\{\s*\$?\{?\\Pi\}?\$?\s*\}(?:\}\})?', '\amalg')
    $body = [regex]::Replace($body, '\\rotatebox\s*(?:\[[^\]]*\])?\s*\{-45\}\s*\{\s*\$\{?\\rightarrow\}?\$\s*\}', '\searrow')
    $body = [regex]::Replace($body, '\\rotatebox\s*(?:\[[^\]]*\])?\s*\{-45\}\s*\{\s*\$\{?\\leftarrow\}?\$\s*\}', '\nwarrow')
    $body = [regex]::Replace($body, '\\rotatebox\s*(?:\[[^\]]*\])?\s*\{-45\}\s*\{\s*\$\{?\\leftrightarrow\}?\$\s*\}', '\mathrel{\nwarrow\mkern-11mu\searrow}')
    $body = [regex]::Replace($body, '\\rotatebox\s*(?:\[[^\]]*\])?\s*\{[^{}]*\}\s*\{([^{}]*)\}', '$1')
    $body = Replace-BracedCommand $body '\xdashleftrightarrow' { param($a) '\overset{' + $a + '}{\dashleftarrow\mkern-14mu\dashrightarrow}' }
    $body = Replace-BracedCommand $body '\xdashrightarrow' { param($a) '\overset{' + $a + '}{\dashrightarrow}' }
    $body = Replace-BracedCommand $body '\xdashleftarrow' { param($a) '\overset{' + $a + '}{\dashleftarrow}' }
    $body = $body -replace '\\lbarrowspace(?![a-zA-Z])', '\,'
    $body = $body -replace '\\nonscript(?![a-zA-Z])', ''
    $body = $body -replace '\\(?:linebreak|nolinebreak)(?:\[[0-9]\])?(?![a-zA-Z])', ''   # break hints: presentation only, valid in math where KaTeX lacks them
    $body = $body -replace '\\mathds(?![a-zA-Z])', '\mathbb'                    # dsfont: \mathds{1} indicator -> \mathbb{1} (KaTeX has \mathbb, not \mathds)
    $body = $body -replace '\\colim(?![a-zA-Z])', '\operatorname*{colim}'      # standard operator papers hand-roll via \mathpalette under-arrows (body dropped by the internals guard)
    $body = $body -replace '\\begin\{(aligned|alignedat|gathered|cases)\}\s*\[[^\]]*\]', '\begin{$1}'   # KaTeX rejects the [t]/[b] position arg these amsmath envs allow
    # \scaleobj{f}{x} (scalerel) is a MATH-MODE scaling wrapper: dropping the factor leaves {x} still in
    # the math register — presentation gone, content untouched. (\raisebox/\scalebox are TEXT-mode boxes
    # and are handled POSITIONALLY in Store-Math — a body-wide strip here would strand their \(..\)
    # delimiters inside math, a register violation.)
    $body = $body -replace '\\scaleobj\s*\{[^{}]*\}', ''

    # accents/single-arg ops written without braces around a (now-expanded) macro arg break KaTeX
    # (e.g. source \underline\IK -> \underline \mathbb{K}); re-brace the argument. \s* not \s+: authors
    # also write the form with NO space (\overline\mathbb{N}).
    $body = $body -replace '\\(underline|overline|widehat|widetilde|widecheck|hat|bar|tilde|vec|check|breve|acute|grave|dot|ddot|mathring)\s*(\\[A-Za-z]+\{[^{}]*\})', '\$1{$2}'
    # custom author counters (\newcounter{desccounter} + \Alph{}/\ref{}): resolve BEFORE the theorem/section
    # walk so \Alph{c} renders to its letter and \label-bound values feed \ref. Runs post-expansion so a
    # \descitem-style macro is already expanded to its \refstepcounter+\item.
    $cc = Resolve-CustomCounters $body $Tex
    $body = $cc.body
    # theorem/section cross-refs: number + render theorem-like envs here (ordered walk over the counter model),
    # BEFORE math protection, so the same numbers feed both the inline labels and \ref resolution.
    $xref = Convert-CrossRefEnvs $body (Get-TheoremModel $Tex)
    $body = $xref.body
    $maps = Build-LabelMaps $body; $citeMap = Build-CiteMap $Bbl               # equation/figure/table counters
    $maps.thm = $xref.thm; $maps.sec = $xref.sec                              # theorem + section label->number from the walk
    $maps.custom = $cc.labels                                                  # custom-counter label->value (lettered cases, enumerate items)
    $body = Resolve-Refs $body $maps $citeMap                                  # \cite/\eqref/\ref -> numbers
    $body = $body -replace '\\label\{[^{}]*\}', ''                            # strip labels (text + soon-math)

    # Protect math BEFORE the algorithm/theorem/text passes. Position is load-bearing for TOKENIZATION
    # CONSISTENCY: algorithm-internal math ($x_i$, \mathbf, \gets) must reach the store INTACT so the
    # pseudocode fences carry the same $-delimited, macro-expanded KaTeX-primitive tokens as body math —
    # Flatten-AlgText then only ever sees scaffold prose (placeholders carry the math past it), never
    # math. One expression, one token stream, wherever it appears.
    $body = Protect-LatexMath $body

    # \ensuremath surviving protection is in PROSE position, where it asserts "this content is math" —
    # honor that by PROMOTING it to a protected inline span. Never strip it to bare tokens: the register
    # objective is that math always tokenizes as math ($\varepsilon$-neighborhood, not ε-soup in prose).
    $body = Replace-BracedCommand $body '\ensuremath' { param($a) Store-Math $a $false }

    $body = Convert-Algorithms $body                                          # algpseudocode -> fenced pseudocode

    # proof (unnumbered; \begin{proof}[Proof of X] -> an italic label). The theorem-like envs were already
    # numbered + rendered by Convert-CrossRefEnvs (counter-model walk) above; only proof remains here — it is
    # deliberately excluded from the model so it keeps its distinct *italic* form, not a bold numbered label.
    $body = [regex]::Replace($body, '\\begin\{[Pp]roof\}(?:\s*\[([^\]]*)\])?', { param($m) $t = if ($m.Groups[1].Success) { $m.Groups[1].Value } else { 'Proof' }; "`n`n*$t.* " })
    $body = $body -replace '\\end\{[Pp]roof\}', ''

    # tcolorbox callouts: surface the box title (title= key, usually last in the option list) as a bold
    # label and keep the body prose; drop the wrapper rather than leaking \begin{tcolorbox}[...] verbatim.
    $body = [regex]::Replace($body, '\\begin\{tcolorbox\}(?:\[([^\]]*)\])?', {
            param($m) $tm = [regex]::Match($m.Groups[1].Value, 'title\s*=\s*\{?(.+?)\}?\s*$')
            if ($tm.Success) { "`n`n**$($tm.Groups[1].Value.Trim())**`n`n" } else { "`n`n" } })
    $body = $body -replace '\\end\{tcolorbox\}', "`n`n"
    # …and author-DECLARED tcolorbox envs (\newtcolorbox{mybox}…): same treatment per declared name —
    # \begin{mybox}[opts]{Title} surfaces the title bold, the wrapper never leaks. (A tcb label= ref
    # stays "?": the auto counter is section-scoped and we never fabricate a scheme we can't read.)
    foreach ($tcb in [regex]::Matches($pre, '\\(?:newtcolorbox|DeclareTColorBox)\s*(?:\[[^\]]*\])?\s*\{([A-Za-z]+)\}')) {
        $bn = $tcb.Groups[1].Value
        $body = [regex]::Replace($body, '\\begin\{' + [regex]::Escape($bn) + '\}(?:\[[^\]]*\])?(?:\{([^{}]*)\})?', {
                param($m) if ($m.Groups[1].Success -and $m.Groups[1].Value.Trim()) { "`n`n**$($m.Groups[1].Value.Trim()).**`n`n" } else { "`n`n" } })
        $body = $body -replace ('\\end\{' + [regex]::Escape($bn) + '\}'), "`n`n"
    }

    $body = Replace-BracedCommand $body '\abstract' { param($a) "`n## Abstract`n`n$a`n" }
    $body = Replace-BracedCommand $body '\footnote' { param($a) " ($($a.Trim()))" }
    $body = Replace-BracedCommand $body '\keywords' { param($a) "`n**Keywords:** " + (($a -replace '\s+', ' ').Trim()) + "`n" }
    # sn-jnl / article author metadata is not part of the corpus format (STANDARDS §8): strip it brace-aware
    # so \author*[1]{\fnm{}\sur{}}, \affil[..]{\orgdiv{}…}, \email, \equalcont, \orcid stop leaking into the
    # body. \title is already lifted to the H1 (Get-LatexCommandArg above); the raw command is dropped here.
    # …including the amsart dialect: \address/\curraddr (institutional addresses), \subjclass[2020]{MSC},
    # \dedicatory, \urladdr — same never-rendered-in-corpus front-matter class (STANDARDS §8).
    foreach ($fm in '\title', '\author', '\affil', '\email', '\equalcont', '\orcid', '\orcidlink', '\thanks', '\address', '\curraddr', '\subjclass', '\dedicatory', '\urladdr') {
        $body = Replace-BracedCommand $body $fm { '' }
    }

    $body = $body -replace '(?s)\\begin\{abstract\}(.*?)\\end\{abstract\}', "`n## Abstract`n`n`$1`n"
    $body = $body -replace '\\(?:sub){0,2}section\*?\s*\{([^{}]*)\}', { $h = '#' * (2 + ([regex]::Matches($_.Value, 'sub')).Count); "`n`n$h $($_.Groups[1].Value)`n`n" }   # blank lines around headings (MD022)
    $body = [regex]::Replace($body, '\\(?:sub)?paragraph\*?\s*\{([^{}]*)\}', { param($m) '**' + $m.Groups[1].Value.Trim() + '** ' })   # trim: no space inside emphasis (MD037)
    $body = $body -replace '\\includegraphics(?:\[[^\]]*\])?\{([^{}]+)\}', "`n![](`$1)`n"   # escape `$1: double-quoted, PS would else interpolate it away
    $body = [regex]::Replace($body, '\\caption\{([^{}]*)\}', { param($m) $c = $m.Groups[1].Value.Trim()
            if ($c -and $c -notmatch '[.!?:]$') { $c += '.' }   # captions are sentences: terminal punctuation (also disarms MD036 emphasis-as-heading)
            if ($c) { "`n`n*$c*`n" } else { '' } })   # trim: no space inside emphasis (MD037)
    # acknowledgements env: the journal class renders an "Acknowledgements" heading — surface it faithfully as
    # a section (content KEPT). This is a FAITHFUL transcription: editorial drops (acks, ref sidecar split, …)
    # are the PROMOTION phase's job, never the converter's.
    $body = [regex]::Replace($body, '\\begin\{(?:acknowledge?ments?|acknowledgement|acks)\}(?:\[[^\]]*\])?', "`n`n## Acknowledgements`n`n")
    $body = $body -replace '\\end\{(?:acknowledge?ments?|acknowledgement|acks)\}', "`n`n"
    $body = $body -replace '\\(?:begin|end)\{(?:figure|table|center|wrapfigure|wraptable)\*?\}(?:\[[^\]]*\])?(?:\{[^{}]*\})*', ''   # wraptable/wrapfigure carry {placement}{width} args
    $body = $body -replace '\\(?:begin|end)\{(?:flushleft|flushright|appendices|subequations|quote|quotation|framed|mdframed|titlepage|adjustwidth)\*?\}(?:\[[^\]]*\])?', ''   # structural wrappers, keep content
    $body = $body -replace '\\begin\{minipage\}(?:\[[^\]]*\])?\{[^}]*\}', '' -replace '\\end\{minipage\}', ''
    $body = $body -replace '\\begin\{subfigure\}(?:\[[^\]]*\])?(?:\{[^}]*\})?', '' -replace '\\end\{subfigure\}', ''   # keep panel content, drop wrapper
    $body = $body -replace '\\begin\{(?:itemize|enumerate|description)\*?\}', "`n`n" -replace '\\end\{(?:itemize|enumerate|description)\*?\}', "`n`n"   # blank lines around lists (MD032); *-variant star is INSIDE the braces
    # description-list \item[term]: surface the bracketed term as a bold lead-in (else it leaks as literal
    # "[term]:"); plain \item -> bullet. The [term] runs before the plain rule so it wins.
    $body = [regex]::Replace($body, '\\item\s*\[([^\]]*)\]\s*:?\s*', { param($m)
            $term = $m.Groups[1].Value.Trim() -replace ':$', ''
            $bare = $term -replace '\\[A-Za-z]+', '' -replace '[{}*]', ''   # strip formatting to see the term's substance
            if ($bare -match '^\d+[.)]?$') { "`n" + ($bare -replace '[.)]$', '') + '. ' }   # numeric term: a real ordered item, not a bold label
            else { "`n- **" + $term + ':** ' } })   # absorb a trailing source ':' so the term is not double-colonned
    $body = $body -replace '\\item\s*', "`n- "
    # LaTeX quotes -> straight quotes, BEFORE \texttt becomes backticks (a lone ` is a left-single-quote
    # here, not a code fence — leaving it turns `word' into a spurious code span). Doubles first.
    $body = $body -replace '``', '"' -replace "''", '"'
    $body = $body -replace '`', "'"
    $body = Convert-BraceToggles $body                                         # {\em ..}/{\bf ..} switch form -> * / ** (brace-aware)
    $body = Unwrap-Boxes $body                                                 # \fbox/\parbox/\centerline -> content (drop frame + width/pos args)
    $body = [regex]::Replace($body, '\\(?:textbf|textsc)\{([^{}]*)\}', { param($m) '**' + ($m.Groups[1].Value.Trim() -replace '\*', '\*') + '**' })   # trim (MD037); escape literal * (author's \emph{Density* corruptions} must not unbalance md emphasis)
    $body = [regex]::Replace($body, '\\(?:emph|textit|textsl)\{([^{}]*)\}', { param($m) '*' + ($m.Groups[1].Value.Trim() -replace '\*', '\*') + '*' })
    $body = [regex]::Replace($body, '\\texttt\{([^{}]*)\}', { param($m) '`' + $m.Groups[1].Value.Trim() + '`' })   # trim: no space inside code spans (MD038)
    $body = $body -replace '\\(?:textrm|textnormal|textsf|textup|textmd|mbox|text|underline)\{([^{}]*)\}', '$1'
    # counter machinery: side-effect commands (\stepcounter/\refstepcounter/\setcounter/…) produce NO
    # output — drop them; value-producing \Alph/\arabic/… of a counter we cannot track (custom author
    # counters) drop too rather than leak the command verbatim.
    $body = $body -replace '\\(?:step|refstep|addto)?(?:set)?counter\*?\{[^{}]*\}(?:\{[^{}]*\})?', ''
    $body = $body -replace '\\(?:arabic|Alph|alph|Roman|roman|fnsymbol|value)\{[^{}]*\}', ''
    $body = $body -replace '\\(?:textcolor|colorbox)\{[^{}]*\}\{([^{}]*)\}', '$1' -replace '\\color\{[^{}]*\}', ''   # drop colour styling, keep text
    $body = $body -replace '\\hyperlink\{(https?://[^{}]*)\}\{[^{}]*\}', '<$1>' -replace '\\(?:hyperlink|hypertarget)\{[^{}]*\}\{([^{}]*)\}', '$1'
    $body = $body -replace '\\href\{([^{}]*)\}\{([^{}]*)\}', '[$2]($1)' -replace '\\url\{([^{}]*)\}', '<$1>'   # links, angle-bracketed (MD034)
    $body = Apply-Accents $body                                               # text-mode accents/ligatures in PROSE (M\'{e}moli -> Mémoli); math is placeholder-safe here
    $body = $body -replace '\\bibliographystyle\s*\{[^{}]*\}', '' -replace '\\bibliography\s*\{[^{}]*\}', ''
    $body = $body -replace '\\(?:maketitle|tableofcontents|newpage|clearpage|noindent|centering|bigskip|medskip|smallskip|vfill|hfill|par)\b', ''
    $body = $body -replace '\\(?:vspace|hspace)\*?\{[^{}]*\}', ''
    $body = $body -replace '\\&', '&' -replace '\\%', '%' -replace '\\_', '_' -replace '\\#', '#' -replace '\\\$', '$'
    $body = $body -replace '~', ' ' -replace '\\,|\\;|\\:|\\!|\\ ', ' ' -replace '``|''''', '"'

    # whitespace normalize while math/alg/verb are still opaque placeholders
    $body = $body -replace '\t', ' '                                          # hard tabs -> space (MD010)
    $body = [regex]::Replace($body, '[ \t]+\r?\n', "`n")
    $body = [regex]::Replace($body, '(?m)^[ \t]+', '')                        # dedent: source indentation is meaningless in md and reads as spurious indented-code blocks
    $body = [regex]::Replace($body, '\n{3,}', "`n`n")
    # STANDARDS §4 — remove hard wraps: reflow source-wrapped prose into flowing paragraphs. Runs while math
    # is @@LMATH/@@LDISP/@@ALG/@@VERB placeholders, so a join can never split a formula or shred pseudocode.
    $body = Join-WrappedProse $body
    $body = Restore-LatexMath $body
    # \textsc has no KaTeX equivalent; prose occurrences already became **bold** above, so any survivor is
    # math-mode small-caps (algorithm pseudocode) — map the control word to \text, preserving its brace group.
    $body = $body -replace '\\textsc(?=\s*\{)', '\text'
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
        $txt = $txt -replace '\\(?:mbox|hbox)(?=\s*\{)', '\text'                # KaTeX-safe math text in refs ($\ell^{\mbox{p}}$ -> \text{p})
        $txt = (Protect-LatexMath $txt)
        $txt = Apply-Accents $txt
        $txt = [regex]::Replace($txt, '\{\\(?:em|it|sl)\s+([^{}]*)\}', '*$1*')
        $txt = $txt -replace '\\(?:em|it|sl)\b', ''
        $txt = Convert-LatexInline $txt
        $txt = $txt -replace '--', [char]0x2013 -replace '\\end\{thebibliography\}', ''
        # bibtex protective braces ({K}rull, {Krull-Remak}, and {$math$} groups) are grouping-only — strip the
        # bare braces (math is a placeholder here, so this never touches real math braces). Iterate for nesting.
        for ($bp = 0; $bp -lt 3 -and $txt -match '\{[^{}\\]*\}'; $bp++) { $txt = [regex]::Replace($txt, '\{([^{}\\]*)\}', '$1') }
        $txt = (Restore-LatexMath $txt)
        $txt = [regex]::Replace($txt, '\s+', ' ').Trim()
        # a \bibitem whose key never appears in the cite map resolves to '?' — sort it to the END rather than
        # crash on [int]'?' (a real hazard: uncited-but-listed entries, or a biber key-normalization mismatch).
        if ($txt) { [pscustomobject]@{ n = $(if ($num -match '^\d+$') { [int]$num } else { [int]::MaxValue }); line = "$num. $txt" } }
    }
    return (($lines | Sort-Object n | ForEach-Object { $_.line }) -join "`n")
}

# --- biblatex/biber .bbl bridge: modern papers compile with biblatex, whose .bbl has NO \bibitem — entries
# are \entry{key}{type}{opts}..\endentry with structured \name{}/\field{} data. Re-serialize each entry (in
# .bbl order = citation number) into a synthetic \bibitem{key} <plain text> so the traditional \bibitem
# pipeline (Build-CiteMap + Get-LatexReferences) works UNCHANGED, and no bibliography is silently lost. --
function Get-BiblatexField {
    param([string]$Body, [string]$Field)
    $m = [regex]::Match($Body, '\\field\{' + [regex]::Escape($Field) + '\}\s*\{')
    if (-not $m.Success) { return '' }
    $v = Get-LatexBracedArg $Body ($m.Index + $m.Length - 1)
    if ($null -eq $v) { return '' }
    return ($v -replace '\\bib[a-zA-Z]+', ' ' -replace '\s+', ' ').Trim()
}
function ConvertFrom-BiblatexBbl {
    param([string]$Bbl)
    if (-not $Bbl -or $Bbl -notmatch '\\entry\{') { return $null }
    $sb = [System.Text.StringBuilder]::new()
    foreach ($e in [regex]::Matches($Bbl, '(?s)\\entry\{([^{}]+)\}\{[^{}]*\}\{[^{}]*\}(.*?)\\endentry')) {
        $key = $e.Groups[1].Value; $body = $e.Groups[2].Value; $names = @()
        $hdr = [regex]::Match($body, '\\name\{(?:author|editor)\}\{\d+\}\{[^{}]*\}\s*\{')   # \name{author}{N}{opts}{ ..name-block.. }
        if ($hdr.Success) {
            $blk = Get-LatexBracedArg $body ($hdr.Index + $hdr.Length - 1)                  # brace-aware: the block nests {{..}{family={X}..given={Y}..}}
            if ($blk) {
                foreach ($p in [regex]::Matches($blk, 'family=\{([^{}]*)\}[\s\S]*?given=\{([^{}]*)\}')) {
                    $fam = ($p.Groups[1].Value -replace '\\bib[a-zA-Z]+', ' ' -replace '[{}]', '' -replace '\s+', ' ').Trim()
                    $giv = ($p.Groups[2].Value -replace '\\bibinitperiod', '.' -replace '\\bib[a-zA-Z]+', ' ' -replace '[{}]', '' -replace '\s+', ' ').Trim()
                    if ($fam) { $names += $(if ($giv) { "$fam, $giv" } else { $fam }) }
                }
            }
        }
        $auth = if ($names.Count -gt 6) { ($names[0..5] -join '; ') + ' et al.' } elseif ($names.Count) { $names -join '; ' } else { '' }
        $title = Get-BiblatexField $body 'title'
        $cont = Get-BiblatexField $body 'journaltitle'; if (-not $cont) { $cont = Get-BiblatexField $body 'booktitle' }
        $year = Get-BiblatexField $body 'year'; if (-not $year) { $d = Get-BiblatexField $body 'date'; if ($d -match '(\d{4})') { $year = $matches[1] } }
        $tail = (@($cont, $year) | Where-Object { $_ }) -join ', '
        $line = ((@($auth, $title, $tail) | Where-Object { $_ }) -join '. ').Trim()
        if ($line) { [void]$sb.AppendLine("\bibitem{$key} $line.") }
    }
    $s = $sb.ToString(); return $(if ($s.Trim()) { $s } else { $null })
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
# \graphicspath redirects the dir; a recursive leaf search sidesteps both. PNG is the TERMINAL image
# register (issues/latex-oracle-images.md): raster formats (png/jpg/…) pass straight through; PDF assets —
# the DOMINANT \includegraphics format across the corpus — are rasterized to PNG via MuPDF (batched, one
# node invocation); EPS/PS (no MuPDF handler) stay a FLAGGED marker until the tectonic wrap, never a
# broken image tag. Missing/unconverted always flag — never a silently-dead link.
function Copy-LatexFigures {
    param([string]$Markdown, [string]$WorkDir, [string]$OutDir, [string]$Slug)
    $rasterExt = @('.png', '.jpg', '.jpeg', '.gif', '.webp')   # pass straight through (already a terminal raster)
    $preferExt = $rasterExt + '.svg'                            # glob-sibling preference: a raster/svg twin beats the .pdf
    $state = @{ copied = 0; png = 0; missing = 0 }
    $destRoot = Join-Path $OutDir $Slug
    $pdfJobs = [System.Collections.Generic.List[object]]::new()  # PDF assets -> PNG, batched into one raster call
    $epsJobs = [System.Collections.Generic.List[object]]::new()  # EPS/PS assets -> PNG via tectonic wrap (no MuPDF handler)
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
                         Sort-Object { $preferExt.IndexOf($_.Extension.ToLowerInvariant()) -lt 0 }) | Select-Object -First 1   # prefer a raster sibling over the .pdf twin
            }
            if (-not $hit) { $state.missing++; return "*[figure: $leaf — source file not found]*" }
            if (-not (Test-Path -LiteralPath $destRoot)) { New-Item -ItemType Directory -Force -Path $destRoot | Out-Null }
            $ext = $hit.Extension.ToLowerInvariant()
            if ($rasterExt -contains $ext) {
                Copy-Item -LiteralPath $hit.FullName -Destination (Join-Path $destRoot $hit.Name) -Force
                $state.copied++; $state.png++
                return "![figure: $([System.IO.Path]::GetFileNameWithoutExtension($hit.Name))]($Slug/$($hit.Name))"
            }
            if ($ext -eq '.pdf') {
                # PDF -> PNG: defer to a batched MuPDF call. Emit a placeholder now (unique per asset via the
                # job count); resolved to the PNG link — or a flagged marker on failure — after the batch.
                $png = [System.IO.Path]::GetFileNameWithoutExtension($hit.Name) + '.png'
                $ph = "@@FIGSLOT$($pdfJobs.Count)@@"
                $pdfJobs.Add([pscustomobject]@{ ph = $ph; pdf = $hit.FullName; out = (Join-Path $destRoot $png); rel = "$Slug/$png"; leaf = $hit.Name })
                return $ph
            }
            if ($ext -eq '.svg') {
                # vector, but this build has no SVG rasterizer — pass the SVG through as an image link (renders
                # in most viewers). Not yet terminal PNG; rare as an \includegraphics asset. Flagged in counts.
                Copy-Item -LiteralPath $hit.FullName -Destination (Join-Path $destRoot $hit.Name) -Force
                $state.copied++
                return "![figure: $([System.IO.Path]::GetFileNameWithoutExtension($hit.Name))]($Slug/$($hit.Name))"
            }
            if ($ext -eq '.eps' -or $ext -eq '.ps') {
                # EPS/PS: no MuPDF handler — defer to a tectonic \includegraphics wrap (-> PDF -> PNG). Emit a
                # placeholder now; resolved to the PNG link or a flagged marker after the batch.
                $png = [System.IO.Path]::GetFileNameWithoutExtension($hit.Name) + '.png'
                $ph = "@@EPSSLOT$($epsJobs.Count)@@"
                $epsJobs.Add([pscustomobject]@{ ph = $ph; src = $hit.FullName; out = (Join-Path $destRoot $png); rel = "$Slug/$png"; leaf = $hit.Name; ext = $ext.TrimStart('.') })
                return $ph
            }
            # other non-raster sources: no conversion path — flag rather than emit a broken image tag.
            $state.missing++
            return "*[figure ($($ext.TrimStart('.'))): $leaf — vector source, PNG pending]*"
        })

    # batch-rasterize the PDF assets to PNG in ONE MuPDF invocation, then resolve their placeholders.
    if ($pdfJobs.Count -gt 0) {
        New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
        $ok = @{}
        if (Test-PdfRasterAvailable) {
            try {
                $res = Invoke-PdfRaster -Jobs @($pdfJobs | ForEach-Object { @{ pdf = $_.pdf; out = $_.out } }) -Dpi 200 -WorkDir $destRoot
                foreach ($r in @($res)) { $ok[$r.out] = [bool]$r.ok }
            } catch { Write-Verbose "pdf-raster failed: $($_.Exception.Message)" }
        }
        foreach ($j in $pdfJobs) {
            if ($ok[$j.out]) { $state.copied++; $state.png++; $Markdown = $Markdown.Replace($j.ph, "![figure: $([System.IO.Path]::GetFileNameWithoutExtension($j.leaf))]($($j.rel))") }
            else { $state.missing++; $Markdown = $Markdown.Replace($j.ph, "*[figure (pdf): $($j.leaf) — PNG conversion pending]*") }
        }
    }

    # EPS/PS assets: wrap each in a graphicx standalone doc, compile with tectonic (-> PDF), rasterize to PNG.
    if ($epsJobs.Count -gt 0) {
        New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
        $ok = @{}
        if (Test-TexRenderAvailable) {
            try {
                $res = Invoke-TexGraphicRender -Assets @($epsJobs | ForEach-Object { @{ src = $_.src; out = $_.out } }) -OutDir $destRoot -Dpi 200
                foreach ($r in @($res)) { $ok[$r.out] = [bool]$r.ok }
            } catch { Write-Verbose "tex-graphic failed: $($_.Exception.Message)" }
        }
        foreach ($j in $epsJobs) {
            if ($ok[$j.out]) { $state.copied++; $state.png++; $Markdown = $Markdown.Replace($j.ph, "![figure: $([System.IO.Path]::GetFileNameWithoutExtension($j.leaf))]($($j.rel))") }
            else { $state.missing++; $Markdown = $Markdown.Replace($j.ph, "*[figure ($($j.ext)): $($j.leaf) — PNG conversion pending]*") }
        }
    }
    return [pscustomobject]@{ markdown = $Markdown; copied = $state.copied; png = $state.png; missing = $state.missing }
}

# ----------------------------------------------------------------------------------------------------
# PER-PAPER PATCH LANE — the durable home for repair-tier corrections (curated errata).
#
# The converter is FAITHFUL by doctrine ([[latex-faithful-not-filtered]]): it must never guess-fix an
# author's defect (an undefined macro, a typo'd control sequence). But a faithful transcription of a
# DEFECTIVE source is itself defective (it won't render), and a one-off hand-edit to the deliverable is
# erased by the next latex_convert. The durable home is a per-paper, human-authored, JUSTIFIED patch
# file BESIDE the source ({slug}-latex.patch.jsonl), re-applied on EVERY conversion. This is NOT the
# converter editorializing on its own judgement: each patch is explicit data carrying a REASON, an
# occurrence GUARD that fails LOUDLY if the source drifts (upstream fixes the defect, or our converter
# changes its emission), and a full audit trail in the tool result. The converter's DEFAULT — no patch
# file — stays 100% faithful; the patch is opt-in per-paper curation, the persistent analog of a
# propose_edit / splice_md that survives regeneration.
#
# Three ops, applied in file order:
#   define_macro   {name, body, [expect_uses]}  — SOURCE phase: supply an omitted \newcommand so the
#                  converter's OWN ordinal, control-word-boundary-safe expander (Expand-LatexMacros)
#                  resolves the undefined control sequence exactly as a defined one would. The
#                  least-interventionist fix for the undefined-macro class: no output surgery, no
#                  \foo-vs-\foobar boundary hazard (the expander is token-aware by construction).
#   source_replace {find, replace, [expect]}    — SOURCE phase: regex substitution on the resolved LaTeX
#                  before conversion (for defects best corrected in TeX space).
#   output_replace {find, replace, [expect]}    — OUTPUT phase: regex substitution on the emitted
#                  markdown just before write (for converter-output quirks with no clean TeX-space handle).
# Every patch carries op + reason (REQUIRED); optionally class, source_ref, authored_by, authored_utc.
# ----------------------------------------------------------------------------------------------------
function Read-LatexPatchFile {
    param([string]$Dir, [string]$Slug)
    $path = Join-Path $Dir "$Slug-latex.patch.jsonl"
    if (-not (Test-Path -LiteralPath $path)) { return @() }
    $u8 = [System.Text.UTF8Encoding]::new($false)
    $patches = [System.Collections.Generic.List[object]]::new()
    $ln = 0
    foreach ($line in [System.IO.File]::ReadAllLines($path, $u8)) {
        $ln++
        $t = $line.Trim()
        if (-not $t -or $t.StartsWith('#') -or $t.StartsWith('//')) { continue }   # comment / blank lines allowed
        $obj = $null
        try { $obj = $t | ConvertFrom-Json } catch { throw "patch $Slug-latex.patch.jsonl:$ln — invalid JSON: $($_.Exception.Message)" }
        $op = [string]$obj.op
        if ($op -notin 'define_macro', 'source_replace', 'output_replace') { throw "patch $Slug-latex.patch.jsonl:$ln — unknown op '$op' (want define_macro | source_replace | output_replace)" }
        if ([string]::IsNullOrWhiteSpace([string]$obj.reason)) { throw "patch $Slug-latex.patch.jsonl:$ln — missing 'reason' (every erratum must be justified)" }
        $patches.Add($obj)
    }
    return $patches.ToArray()
}

# a stale patch (matches nothing, or a count that no longer holds) is a SIGNAL, not something to swallow:
# throw so the human learns the upstream/converter drifted and the erratum needs review.
function Assert-PatchHits {
    param([int]$Hits, $Expect, [string]$What, [string]$Slug)
    if ($Hits -eq 0) { throw "patch[$Slug] $What is STALE — matched nothing in the source (upstream fixed it, or the converter drifted); review/remove the patch" }
    if ($null -ne $Expect -and [int]$Expect -ne $Hits) { throw "patch[$Slug] $What — expected $([int]$Expect) occurrence(s), found $Hits; review the patch" }
}

# SOURCE phase: define_macro (accumulated, prepended once) + source_replace (in file order). Returns the
# patched TeX and the audit list of what fired.
function Invoke-LatexSourcePatches {
    param([string]$Tex, [object[]]$Patches, [string]$Slug)
    $ci = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
    $applied = [System.Collections.Generic.List[object]]::new()
    $prefix = ''
    foreach ($p in $Patches) {
        switch ([string]$p.op) {
            'define_macro' {
                $name = [string]$p.name
                if ([string]::IsNullOrWhiteSpace($name)) { throw "patch[$Slug] define_macro missing 'name'" }
                $bare = $name.TrimStart('\')
                $esc = [regex]::Escape($bare)
                $uses = ([regex]::new('\\' + $esc + '(?![A-Za-z])', $ci)).Matches($Tex).Count
                # any definition idiom the source might use — \newcommand-family, \def, or \let — means the
                # author (or a future version) already defines it, so this erratum is redundant/stale.
                $alreadyDef = ([regex]::new('\\(?:(?:new|renew|provide)command\s*\{?\s*|def\s*|let\s*)\\' + $esc + '(?![A-Za-z])', $ci)).IsMatch($Tex)
                if ($alreadyDef) { throw "patch[$Slug] define_macro \$bare is STALE — the source ALREADY defines it (erratum redundant); review/remove the patch" }
                Assert-PatchHits -Hits $uses -Expect $p.expect_uses -What "define_macro \$bare" -Slug $Slug
                $prefix += "% codex-patch define_macro: $name`n\newcommand{$name}{$([string]$p.body)}`n"
                $applied.Add([ordered]@{ op = 'define_macro'; name = $name; body = [string]$p.body; uses = $uses; class = [string]$p.class; reason = [string]$p.reason })
            }
            'source_replace' {
                $find = [string]$p.find
                if ([string]::IsNullOrEmpty($find)) { throw "patch[$Slug] source_replace missing 'find'" }
                $hits = ([regex]::new($find, $ci)).Matches($Tex).Count
                Assert-PatchHits -Hits $hits -Expect $p.expect -What "source_replace /$find/" -Slug $Slug
                $Tex = ([regex]::new($find, $ci)).Replace($Tex, [string]$p.replace)
                $applied.Add([ordered]@{ op = 'source_replace'; find = $find; replace = [string]$p.replace; hits = $hits; class = [string]$p.class; reason = [string]$p.reason })
            }
            'output_replace' { }   # handled in the output phase
        }
    }
    if ($prefix) { $Tex = $prefix + $Tex }   # injected defs go on top so any real author def (later) still wins
    return @{ tex = $Tex; applied = $applied.ToArray() }
}

# OUTPUT phase: output_replace on the assembled markdown, just before write.
function Invoke-LatexOutputPatches {
    param([string]$Markdown, [object[]]$Patches, [string]$Slug)
    $ci = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
    $applied = [System.Collections.Generic.List[object]]::new()
    foreach ($p in $Patches) {
        if ([string]$p.op -ne 'output_replace') { continue }
        $find = [string]$p.find
        if ([string]::IsNullOrEmpty($find)) { throw "patch[$Slug] output_replace missing 'find'" }
        $hits = ([regex]::new($find, $ci)).Matches($Markdown).Count
        Assert-PatchHits -Hits $hits -Expect $p.expect -What "output_replace /$find/" -Slug $Slug
        $Markdown = ([regex]::new($find, $ci)).Replace($Markdown, [string]$p.replace)
        $applied.Add([ordered]@{ op = 'output_replace'; find = $find; replace = [string]$p.replace; hits = $hits; class = [string]$p.class; reason = [string]$p.reason })
    }
    return @{ markdown = $Markdown; applied = $applied.ToArray() }
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
    # per-paper curated errata (the faithful-not-filtered escape hatch): supply omitted macro defs /
    # correct author defects in SOURCE space BEFORE anything downstream reads $tex, so oracle counts,
    # macro collection, and conversion all see one patched source of truth. No patch file → pure no-op.
    $patches = Read-LatexPatchFile -Dir $OutDir -Slug $Slug
    $srcPatch = Invoke-LatexSourcePatches -Tex $tex -Patches $patches -Slug $Slug
    $tex = $srcPatch.tex
    # oracle object counts off the resolved source (macro-robust env regexes) — persisted below as the
    # {slug}.oracle-counts.json sidecar the figure-count harness scores pig against.
    $oracleCounts = Get-LatexOracleCounts $tex
    $bbl = @(Get-ChildItem -Recurse -File -Filter *.bbl $work) | Select-Object -First 1
    $bblTxt = if ($bbl) { [System.IO.File]::ReadAllText($bbl.FullName, $u8) } else { '' }
    # biblatex/biber .bbl (\entry{}, no \bibitem): re-serialize to synthetic \bibitem form so refs survive.
    if ($bblTxt -match '\\entry\{') { $syn = ConvertFrom-BiblatexBbl $bblTxt; if ($syn) { $bblTxt = $syn } }
    # still no \bibitem (no .bbl, or an unparseable one): recover an inline \begin{thebibliography} from source.
    # Traditional \bibitem syntax is identical inline, so Get-LatexReferences parses the recovered block as-is.
    if ($bblTxt -notmatch '\\bibitem') { $ib = [regex]::Match($tex, '(?s)\\begin\{thebibliography\}.*?\\end\{thebibliography\}'); if ($ib.Success) { $bblTxt = $ib.Value } }

    $md = ConvertFrom-Latex $tex $bblTxt
    $refs = Get-LatexReferences $bblTxt (Build-CiteMap $bblTxt)
    if ($refs) { $md += "`n## References`n`n$refs`n" }

    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $figs = Copy-LatexFigures -Markdown $md -WorkDir $work -OutDir $OutDir -Slug $Slug
    $md = $figs.markdown

    # source-authoritative diagrams (TikZ/tikzcd/xy-pic): render each to a PNG and swap its marker for a
    # live image link. PNG is the terminal register (issues/latex-oracle-images.md). A rendering ladder,
    # each rung a graceful fallback for the one above; nothing throws the conversion:
    #   rung 1  tectonic: compile the snippet (author preamble replayed — macros are the fidelity trap) ->
    #           PDF -> MuPDF -> PNG. One path for ALL packages, incl. xy-pic; the most faithful.
    #   rung 2  tikzjax -> SVG: zero-dependency fallback for plain TikZ/tikzcd when tectonic is absent.
    #           (xy-pic is beyond tikzjax; SVG is a non-terminal intermediate accepted only as degradation.)
    #   rung 3  flagged marker stays: never a silent drop, never KaTeX-invalid source (the xy-pic bug fix).
    $destDir  = Join-Path $OutDir $Slug
    $texMacros = Get-LatexMacros $tex
    $diag     = @{ png = 0; svg = 0 }
    $doneN    = [System.Collections.Generic.HashSet[int]]::new()
    $pngN     = [System.Collections.Generic.HashSet[int]]::new()   # which of doneN landed as PNG (vs SVG fallback)

    if ($script:DiagramStore.Count -gt 0 -and (Test-TexRenderAvailable)) {
        $texJobs = @($script:DiagramStore | ForEach-Object {
                @{ id = "diagram-$($_.n)"; source = (Expand-LatexMacros $_.source $texMacros); kind = $_.kind; display = [bool]$_.display } })
        try {
            $rep = Invoke-TexDiagramRender -Jobs $texJobs -Preamble $script:TikzPreamble -TikzLibraries $script:TikzLibs -OutDir $destDir -Dpi 200
            $ok = @{}; foreach ($r in @($rep.results)) { if ($r.ok) { $ok[[int]($r.id -replace '^diagram-', '')] = $true } }
            foreach ($d in $script:DiagramStore) {
                if ($ok[$d.n]) { $md = $md.Replace((Format-DiagramMarker $d.n $d.kind), "![diagram $($d.n) ($($d.kind))]($Slug/diagram-$($d.n).png)"); [void]$doneN.Add($d.n); [void]$pngN.Add($d.n); $diag.png++ }
            }
        } catch { Write-Verbose "tex-render (tectonic) failed: $($_.Exception.Message)" }
    }

    $tikzTodo = @($script:DiagramStore | Where-Object { $_.kind -in 'tikzpicture', 'tikzcd' -and -not $doneN.Contains($_.n) })
    if ($tikzTodo.Count -gt 0 -and (Test-TikzRenderAvailable)) {
        $jobs = @(foreach ($t in $tikzTodo) {
                $pkgs = @{} + $script:TikzPkgs
                if ($t.kind -eq 'tikzcd') { $pkgs['tikz-cd'] = '' }
                $src = Expand-LatexMacros $t.source $texMacros
                # the tikz stash happens BEFORE the body-wide NiceMatrix normalization — apply the same
                # rewrite here (nicematrix is not in the renderer's texmf tree; stock matrices are)
                $src = $src -replace '\\begin\{([bpBvV]?)NiceMatrix\}\s*(?:\[[^\]]*\])?', '\begin{${1}matrix}'
                $src = $src -replace '\\end\{([bpBvV]?)NiceMatrix\}', '\end{${1}matrix}'
                @{ id = "diagram-$($t.n)"; source = $src
                    tikzLibraries = [string]$script:TikzLibs; texPackages = $pkgs; preamble = [string]$script:TikzPre }
            })
        try {
            $rep = Invoke-TikzRender -Jobs $jobs -OutDir $destDir
            foreach ($res in @($rep.results)) {
                if (-not $res.ok) { continue }
                $n = [int]($res.id -replace '^diagram-', '')
                $kind = (@($script:DiagramStore | Where-Object { $_.n -eq $n })[0]).kind
                $md = $md.Replace((Format-DiagramMarker $n $kind), "![diagram $n ($kind)]($Slug/diagram-$n.svg)")
                [void]$doneN.Add($n); $diag.svg++
            }
        } catch { Write-Verbose "tikz-render failed: $($_.Exception.Message)" }
    }
    $rendered = $diag.png + $diag.svg
    $diagUnrendered = $script:DiagramStore.Count - $doneN.Count

    # diagrams work-list — the reasoning-agent seam (encode-first doctrine, issues/latex-oracle-images.md):
    # every diagram that did NOT land as semantic math is listed with its original source and disposition,
    # so a downstream translation pass (MCP harness -> reasoning model) can attempt an inline-arrow /
    # \begin{array} encoding and swap the image or marker out for real math. The image is a STOPGAP, not
    # the deliverable register. UTF-8-no-BOM JSONL in the tex run dir beside the other sidecars.
    $dsb = [System.Text.StringBuilder]::new()
    foreach ($d in $script:DiagramStore) {
        $status = if (-not $doneN.Contains($d.n)) { 'marker' } elseif ($pngN.Contains($d.n)) { 'png' } else { 'svg' }
        [void]$dsb.AppendLine(([ordered]@{
                    n = $d.n; kind = $d.kind; status = $status
                    image = $(if ($status -ne 'marker') { "$Slug/diagram-$($d.n).$status" } else { $null })
                    source = $d.source
                } | ConvertTo-Json -Depth 3 -Compress))
    }
    [System.IO.File]::WriteAllText((Join-Path $work "$Slug.diagrams.jsonl"), $dsb.ToString(), $u8)

    # FINAL HYGIENE (STANDARDS §4) + REGISTER SAFETY, one fence-aware line walk:
    #  - inside ``` fences: byte-verbatim (code samples keep their own blanks/tabs/spacing)
    #  - trailing whitespace stripped (MD009); blank runs collapsed to ONE blank line (MD012)
    #  - bare URLs wrapped <…> (MD034), trailing sentence punctuation left outside the autolink
    #  - two ADJACENT inline spans emit `$a$$b$` — indistinguishable from a display fence to every
    #    markdown scanner (render_check's extractor included). True display fences sit ALONE on their
    #    line, so any mid-line unescaped `$$` is span adjacency: restore the boundary with a space.
    $lines = [System.Collections.Generic.List[string]]::new()
    $inFence = $false; $blankRun = 0; $lastH = 0
    $olN = 0; $bulletRun = [System.Collections.Generic.List[int]]::new()   # nested-list repair state (see the ol-resume branch)
    foreach ($ln in ($md -split "`n")) {
        if ($ln -match '^```') { $inFence = -not $inFence; $blankRun = 0; $lines.Add($ln); continue }
        if ($inFence) { $lines.Add($ln); continue }
        $ln = ($ln -replace '\t', ' ').TrimEnd()   # hard tabs -> space (MD010); a stray tab can ride out of a restored math/alg span
        if ($ln -eq '') { $blankRun++; if ($blankRun -gt 1) { continue }; $lines.Add(''); continue }
        $blankRun = 0
        if ($ln -match '^(#{1,6})\s+(.*\S)\s*$') {
            # headings: strip trailing sentence punctuation (MD026); CLAMP level jumps deeper than one tier
            # (§5 — an author's \subsubsection* directly under a \section misstates nesting as ##→####).
            $lvl = $matches[1].Length
            if ($lastH -gt 0 -and $lvl -gt $lastH + 1) { $lvl = $lastH + 1 }
            $lastH = $lvl
            $lines.Add(('#' * $lvl) + ' ' + ($matches[2] -replace '[.:;,]+$', ''))
            continue
        }
        if ($ln -ne '$$') {
            $ln = [regex]::Replace($ln, '(?<!\\)\$\$', '$ $')
            $ln = [regex]::Replace($ln, '(?<![<(\[])(https?://[^\s<>()\[\]]+)', {
                    param($m) $u = $m.Groups[1].Value; $p = ''
                    while ($u.Length -gt 1 -and $u[-1] -in '.', ',', ';', ':') { $p = $u[-1] + $p; $u = $u.Substring(0, $u.Length - 1) }
                    "<$u>$p" })
            # bare e-mail -> autolink (MD034); skip if already inside <>/()/[] or a mailto:
            $ln = [regex]::Replace($ln, '(?<![<(\[:/\w.])([A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,})', '<$1>')
            # a resolved \cref number landing at line start ("14.  Alternatively…") reads as an ordered-list
            # marker to markdown. Real items follow a blank line or another item IN SEQUENCE (n+1, or 1 for
            # all-ones style); mid-paragraph, or mid-list out of sequence, = accident — escape it to prose.
            if ($ln -match '^(\d+)\. ' -and $lines.Count -gt 0) {
                $curN = [int]$matches[1]
                $prevLn = $lines[$lines.Count - 1]
                $escape = $false
                if ($prevLn -ne '' -and $prevLn -notmatch '^(\d+\. |- |\* )') { $escape = $true }                       # mid-paragraph
                elseif ($prevLn -match '^(\d+)\. ' -and $curN -ne ([int]$matches[1] + 1) -and $curN -ne 1) { $escape = $true }   # mid-list, out of sequence
                if ($escape) { $ln = $ln -replace '^(\d+)\. ', '$1\. ' }
                else {
                    # NESTED-LIST REPAIR: dedent/reflow flattens LaTeX nesting, so an itemize inside an
                    # enumerate emits flat bullets that SPLIT the ordered list. When item N+1 resumes after
                    # a bullet run, those bullets belong UNDER item N — retro-indent them (md continuation).
                    if ($curN -eq $olN + 1 -and $bulletRun.Count -gt 0) {
                        foreach ($bi in $bulletRun) { $lines[$bi] = '    ' + $lines[$bi] }
                    }
                    $olN = $curN; $bulletRun.Clear()
                }
            }
            elseif ($ln -match '^- ' -and $olN -gt 0) { $bulletRun.Add($lines.Count) }   # candidate nested bullets (index of the line about to be added)
            elseif ($ln -ne '' -and $ln -notmatch '^(\d+[.\\]|- |\* )' -and $olN -gt 0 -and $bulletRun.Count -eq 0) { $olN = 0 }   # prose after the list closes it (bullets pending stay: item text continuation)
            # heading-level clamp (§5): a jump deeper than one level (## -> ####, author skipping a tier)
            # misstates nesting — demote to parent+1. (Heading lines are handled in their own branch above,
            # so track the last heading seen from there.)
        }
        $lines.Add($ln)
    }
    $md = (($lines -join "`n").TrimEnd()) + "`n"

    # OUTPUT-phase errata (converter-output quirks with no clean TeX-space handle) — last transform,
    # applied to the near-emission text so a human authors find-strings against what the deliverable shows.
    $outPatch = Invoke-LatexOutputPatches -Markdown $md -Patches $patches -Slug $Slug
    $md = $outPatch.markdown
    $patchesApplied = @($srcPatch.applied) + @($outPatch.applied)

    $outPath = Join-Path $OutDir "$Slug-latex.md"   # lane-tagged at slug root (STANDARDS §9); docling keeps the bare {slug}.md
    [System.IO.File]::WriteAllText($outPath, $md, $u8)

    # oracle-counts sidecar: persist the figure/table/diagram truth INTO the tex run dir ($work =
    # .runs/{stamp}/tex, git-ignored) so the standing figure-count harness (Compare-FigureCounts) reads
    # it back with newest-run-wins, instead of the deleted ad-hoc one-off. figures_missing is the
    # oracle-CONFIDENCE flag (referenced images the source never provided → the count is low-confidence,
    # to be ANNOTATED not chased). UTF-8-no-BOM like every content artifact.
    $oracleSidecar = [ordered]@{
        schema            = 'oracle-counts/2'
        slug              = $Slug
        figures           = $oracleCounts.figures         # \begin{figure} floats — CAPTIONED-figure oracle (PRIMARY)
        inline_diagrams   = $oracleCounts.inline_diagrams # tikz/xy diagrams outside floats — inline math (2nd population)
        images            = $oracleCounts.images          # \includegraphics placements (subfigures inflate this)
        diagrams_total    = $oracleCounts.diagrams_total  # all tikz/cd/xy diagram envs
        oracle_figures    = $oracleCounts.oracle_figures  # == figures — the primary pig-captioned comparison target
        tables            = $oracleCounts.tables
        theorems          = $oracleCounts.theorems
        equations         = $oracleCounts.equations
        figures_copied    = [int]$figs.copied             # \includegraphics assets resolved on disk (PDF→PNG converted, raster passthrough)
        figures_png       = [int]$figs.png                 # of those, how many landed as PNG (converted or already raster) — the terminal register
        figures_missing   = [int]$figs.missing            # referenced-but-absent → oracle CONFIDENCE flag
        diagrams_found    = [int]$script:DiagramStore.Count # TikZ + tikzcd + xy-pic envs stashed (could NOT be encoded as math)
        diagrams_encoded  = [int]($script:XyEncoded + $script:CdEncoded)   # xymatrix + tikzcd spans transpiled to semantic inline arrows — REAL MATH, the goal register
        diagrams_rendered = [int]$rendered                 # markers swapped for images (PNG via tectonic + SVG via tikzjax fallback)
        diagrams_png      = [int]$diag.png                 # rendered to PNG (tectonic → PDF → MuPDF) — the terminal register
        diagrams_svg      = [int]$diag.svg                 # rendered to SVG (tikzjax fallback, non-terminal intermediate; present only when tectonic absent)
        diagrams_marker   = [int]$diagUnrendered           # left as a FLAGGED marker (no compiler / compile failed) — never a silent drop
        patches_applied   = [int]$patchesApplied.Count     # per-paper curated errata re-applied this conversion (0 = pure faithful)
        main_tex          = (Split-Path -Leaf $main)
        run_utc           = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    }
    [System.IO.File]::WriteAllText((Join-Path $work "$Slug.oracle-counts.json"),
        ($oracleSidecar | ConvertTo-Json -Depth 4), $u8)

    return [pscustomobject]@{
        slug = $Slug; out = $outPath; main_tex = (Split-Path -Leaf $main)
        run = (Split-Path -Leaf $run); tex = $work   # the persisted unpacked source (run artifact)
        bytes = $md.Length; macros = (Get-LatexMacros $tex).Count
        sections = ([regex]::Matches($md, '(?m)^##\s')).Count
        references = if ($refs) { @($refs -split "`n").Count } else { 0 }
        figures = $figs.copied; figures_png = $figs.png; figures_missing = $figs.missing
        oracle_figures = $oracleCounts.oracle_figures  # \includegraphics placements + TikZ diagrams
        diagrams = [int]$script:DiagramStore.Count     # TikZ + tikzcd + xy-pic envs that could NOT be encoded as math
        diagrams_encoded = [int]($script:XyEncoded + $script:CdEncoded)   # xymatrix + tikzcd transpiled to inline arrows (real math)
        diagrams_rendered = $rendered                  # markers swapped for images
        diagrams_png = $diag.png; diagrams_svg = $diag.svg; diagrams_marker = $diagUnrendered
        patched = $patchesApplied                       # curated-errata audit trail (op/find/replace/hits/reason) — the human-visible record
    }
}
