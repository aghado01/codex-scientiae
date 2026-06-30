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
    foreach ($m in ([regex]'\\DeclareMathOperator\*?\s*\{\s*\\([A-Za-z]+)\s*\}\s*\{').Matches($Tex)) {
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
    $T = [regex]::Replace($T, '\\cite[a-z]*\{([^{}]+)\}', { param($m) '[' + (($m.Groups[1].Value -split '\s*,\s*' | ForEach-Object { if ($CiteMap.ContainsKey($_)) { $CiteMap[$_] } else { '?' } }) -join ', ') + ']' })
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
    $Text = [regex]::Replace($Text, '(?<!\\)\$\$(.*?)\$\$', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $true }, $SL)
    $Text = [regex]::Replace($Text, '\\\((.*?)\\\)', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $false }, $SL)
    $Text = [regex]::Replace($Text, '(?<!\\)\$(.+?)(?<!\\)\$', { param($m) Store-Math ($m.Groups[1].Value.Trim()) $false }, $SL)
    return $Text
}
function Restore-LatexMath {
    param([string]$Text)
    foreach ($id in $script:LtxMathStore.Keys) { $Text = $Text.Replace($id, $script:LtxMathStore[$id]) }
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
    $Tex = [regex]::Replace($Tex, '(?m)(?<!\\)%.*$', '')                       # strip comments
    $macros = Get-LatexMacros $Tex
    $title = Get-LatexCommandArg $Tex '\title'
    $bm = [regex]::Match($Tex, '\\begin\{document\}(.*)\\end\{document\}', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $body = if ($bm.Success) { $bm.Groups[1].Value } else { $Tex }

    $body = Expand-LatexMacros $body $macros                                   # macros (incl inside math)
    $maps = Build-LabelMaps $body; $citeMap = Build-CiteMap $Bbl
    $body = Resolve-Refs $body $maps $citeMap                                  # \cite/\eqref/\ref -> numbers
    $body = $body -replace '\\label\{[^{}]*\}', ''                            # strip labels (text + soon-math)

    # theorem family (shared counter) + proof, numbered to match the rendered paper
    $script:thmCounter = 0
    $body = [regex]::Replace($body, '\\begin\{(theorem|lemma|corollary|proposition)\}(?:\s*\[([^\]]*)\])?', {
            param($m) $script:thmCounter++; $lab = (Get-Culture).TextInfo.ToTitleCase($m.Groups[1].Value)
            $note = if ($m.Groups[2].Success) { " ($($m.Groups[2].Value))" } else { '' }; "`n`n**$lab $script:thmCounter$note.** " })
    $body = [regex]::Replace($body, '\\begin\{proof\}(?:\s*\[([^\]]*)\])?', { param($m) $t = if ($m.Groups[1].Success) { $m.Groups[1].Value } else { 'Proof' }; "`n`n*$t.* " })
    $body = $body -replace '\\end\{(theorem|lemma|corollary|proposition|proof)\}', ''

    $body = Replace-BracedCommand $body '\abstract' { param($a) "`n## Abstract`n`n$a`n" }
    $body = Replace-BracedCommand $body '\footnote' { param($a) " ($($a.Trim()))" }

    $body = Protect-LatexMath $body                                            # protect BEFORE text regexes

    $body = $body -replace '(?s)\\begin\{abstract\}(.*?)\\end\{abstract\}', "`n## Abstract`n`n`$1`n"
    $body = $body -replace '\\(?:sub){0,2}section\*?\s*\{([^{}]*)\}', { $h = '#' * (2 + ([regex]::Matches($_.Value, 'sub')).Count); "$h $($_.Groups[1].Value)" }
    $body = $body -replace '\\paragraph\*?\s*\{([^{}]*)\}', '**$1** '
    $body = $body -replace '\\includegraphics(?:\[[^\]]*\])?\{([^{}]+)\}', "`n![]($1)`n"
    $body = $body -replace '\\caption\{([^{}]*)\}', "`n`n*$1*`n"
    $body = $body -replace '\\(?:begin|end)\{(?:figure|table|center|wrapfigure)\*?\}(?:\[[^\]]*\])?', ''
    $body = $body -replace '\\begin\{(?:itemize|enumerate|description)\}', "`n" -replace '\\end\{(?:itemize|enumerate|description)\}', "`n"
    $body = $body -replace '\\item\s*', "`n- "
    $body = $body -replace '\\(?:textbf|textsc)\{([^{}]*)\}', '**$1**'
    $body = $body -replace '\\(?:emph|textit|textsl)\{([^{}]*)\}', '*$1*'
    $body = $body -replace '\\texttt\{([^{}]*)\}', '`$1`'
    $body = $body -replace '\\(?:textrm|textnormal|mbox|text|underline)\{([^{}]*)\}', '$1'
    $body = $body -replace '\\bibliographystyle\s*\{[^{}]*\}', '' -replace '\\bibliography\s*\{[^{}]*\}', ''
    $body = $body -replace '\\(?:maketitle|tableofcontents|newpage|clearpage|noindent|centering|bigskip|medskip|smallskip|vfill|hfill|par)\b', ''
    $body = $body -replace '\\(?:vspace|hspace)\*?\{[^{}]*\}', ''
    $body = $body -replace '\\&', '&' -replace '\\%', '%' -replace '\\_', '_' -replace '\\#', '#' -replace '\\\$', '$'
    $body = $body -replace '~', ' ' -replace '\\,|\\;|\\:|\\!|\\ ', ' ' -replace '``|''''', '"'

    $body = Restore-LatexMath $body
    $body = [regex]::Replace($body, '[ \t]+\r?\n', "`n")
    $body = [regex]::Replace($body, '\n{3,}', "`n`n")

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
function Invoke-ArxivLatexToMarkdown {
    param([string]$TarGz, [string]$Slug, [string]$OutDir)
    $u8 = [System.Text.UTF8Encoding]::new($false)
    $work = Join-Path ([System.IO.Path]::GetTempPath()) ("ltx_" + [System.IO.Path]::GetFileNameWithoutExtension($TarGz) + "_" + $Slug)
    if (Test-Path $work) { Remove-Item -LiteralPath $work -Recurse -Force }
    Expand-ArxivSourceTarball -TarGz $TarGz -WorkDir $work | Out-Null

    $main = Find-LatexMain $work
    $tex = Resolve-LatexInputs -MainPath $main
    $bbl = @(Get-ChildItem -Recurse -File -Filter *.bbl $work) | Select-Object -First 1
    $bblTxt = if ($bbl) { [System.IO.File]::ReadAllText($bbl.FullName, $u8) } else { '' }

    $md = ConvertFrom-Latex $tex $bblTxt
    $refs = Get-LatexReferences $bblTxt (Build-CiteMap $bblTxt)
    if ($refs) { $md += "`n## References`n`n$refs`n" }

    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $outPath = Join-Path $OutDir "$Slug.md"
    [System.IO.File]::WriteAllText($outPath, $md, $u8)
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue

    return [pscustomobject]@{
        slug = $Slug; out = $outPath; main_tex = (Split-Path -Leaf $main)
        bytes = $md.Length; macros = (Get-LatexMacros $tex).Count
        sections = ([regex]::Matches($md, '(?m)^##\s')).Count
        references = if ($refs) { @($refs -split "`n").Count } else { 0 }
    }
}
