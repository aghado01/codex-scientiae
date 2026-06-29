#requires -Version 7.0
<#
  src/latex-ingest.ps1 — PROTOTYPE: arXiv LaTeX source -> codex-scientiae markdown, end to end.

  The tractable top rung of the transcription stack (.discussion/ingestion-stack-roadmap.md): for arXiv
  papers we stage the LaTeX `source` artifact, and LaTeX is already structured — so unlike the PDF
  geometry problem, this is a parse/transform, and crucially the MATH PASSES THROUGH VERBATIM ($...$ /
  $$...$$ ARE the codex standard), sidestepping the membrane's whole math-repair problem.

  Architecture mirrors the membrane's principled approach: PROTECT math spans (so text-command regexes
  never run inside math) -> TRANSFORM structure (title/sections/lists/figures/commands) -> RESTORE math.
  In-house (no pandoc/latexml dependency). Prototype scope: handles the common arXiv constructs; known
  rough edges (custom \newcommand macros, tables, deeply-nested braces, non-UTF8 sources) are noted and
  are the next iterations — NOT production-complete.

  Entry point: Invoke-ArxivLatexToMarkdown -TarGz <source.tar.gz> -Slug <name> -OutDir <dir>
#>

# --- math protection (single-pass, script-scoped store so the regex evaluator can reach it) ----------
$script:LtxMathStore = @{}
$script:LtxMathIdx = 0
$script:LtxDisplay = $false
function _LtxMathEval {
    param($m)
    $id = "@@LMATH$($script:LtxMathIdx)@@"; $script:LtxMathIdx++
    $content = $m.Groups[$m.Groups.Count - 1].Value.Trim()
    # Standard codex math: inline $..$, display fenced on its own lines.
    $script:LtxMathStore[$id] = if ($script:LtxDisplay) { "`n`$`$`n$content`n`$`$`n" } else { "`$$content`$" }
    return $id
}
function Protect-LatexMath {
    param([string]$Text)
    $script:LtxMathStore = @{}; $script:LtxMathIdx = 0
    $opt = [System.Text.RegularExpressions.RegexOptions]::Singleline
    $ev = ${function:_LtxMathEval}
    # display first (env math, \[..\], $$..$$), then inline (\(..\), $..$)
    $script:LtxDisplay = $true
    $Text = [regex]::Replace($Text, '\\begin\{(equation|align|gather|multline|eqnarray|displaymath|math|split|alignat)\*?\}(.*?)\\end\{\1\*?\}', $ev, $opt)
    $Text = [regex]::Replace($Text, '\\\[(.*?)\\\]', $ev, $opt)
    $Text = [regex]::Replace($Text, '(?<!\\)\$\$(.*?)\$\$', $ev, $opt)
    $script:LtxDisplay = $false
    $Text = [regex]::Replace($Text, '\\\((.*?)\\\)', $ev, $opt)
    $Text = [regex]::Replace($Text, '(?<!\\)\$(.+?)(?<!\\)\$', $ev, $opt)
    return $Text
}
function Restore-LatexMath {
    param([string]$Text)
    foreach ($id in $script:LtxMathStore.Keys) { $Text = $Text.Replace($id, $script:LtxMathStore[$id]) }
    return $Text
}

# --- brace-aware arg extraction (for title etc. where nesting matters) -------------------------------
function Get-LatexBracedArg {
    param([string]$Text, [int]$OpenBraceIndex)
    $depth = 0
    for ($i = $OpenBraceIndex; $i -lt $Text.Length; $i++) {
        $c = $Text[$i]
        if ($c -eq '{') { $depth++ } elseif ($c -eq '}') { $depth--; if ($depth -eq 0) { return $Text.Substring($OpenBraceIndex + 1, $i - $OpenBraceIndex - 1) } }
    }
    return $null
}
function Get-LatexCommandArg {
    param([string]$Text, [string]$Command)   # e.g. '\title'
    $m = [regex]::Match($Text, [regex]::Escape($Command) + '\s*\{')
    if (-not $m.Success) { return $null }
    return Get-LatexBracedArg $Text ($m.Index + $m.Length - 1)
}

# --- light inline-command cleanup (used for title + bib text, math already protected/absent) ---------
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

# --- the core transform: LaTeX body -> markdown ------------------------------------------------------
function ConvertFrom-Latex {
    param([string]$Tex)
    # 1. strip line comments (% to EOL, but not escaped \%)
    $Tex = [regex]::Replace($Tex, '(?m)(?<!\\)%.*$', '')
    # 2. title (from full text, brace-matched) then body between \begin{document}..\end{document}
    $title = Get-LatexCommandArg $Tex '\title'
    $bm = [regex]::Match($Tex, '\\begin\{document\}(.*)\\end\{document\}', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $body = if ($bm.Success) { $bm.Groups[1].Value } else { $Tex }

    # 3. protect math BEFORE any text-command regex touches it
    $body = Protect-LatexMath $body

    # 4. structure transforms (math-free text)
    $body = $body -replace '(?s)\\begin\{abstract\}(.*?)\\end\{abstract\}', "`n## Abstract`n`n`$1`n"
    $body = $body -replace '\\(?:sub){0,2}section\*?\s*\{([^{}]*)\}', { $h = '#' * (2 + ([regex]::Matches($_.Value, 'sub')).Count); "$h $($_.Groups[1].Value)" }
    $body = $body -replace '\\paragraph\*?\s*\{([^{}]*)\}', '**$1** '
    # figures (rough: lift image + caption, drop the env furniture)
    $body = $body -replace '\\includegraphics(?:\[[^\]]*\])?\{([^{}]+)\}', "`n![]($1)`n"
    $body = $body -replace '\\caption\{([^{}]*)\}', "`n`n*$1*`n"
    $body = $body -replace '\\(?:begin|end)\{(?:figure|table|center|wrapfigure)\*?\}(?:\[[^\]]*\])?', ''
    # lists
    $body = $body -replace '\\begin\{(?:itemize|enumerate|description)\}', "`n" -replace '\\end\{(?:itemize|enumerate|description)\}', "`n"
    $body = $body -replace '\\item\s*', "`n- "
    # inline text commands
    $body = $body -replace '\\(?:textbf|textsc)\{([^{}]*)\}', '**$1**'
    $body = $body -replace '\\(?:emph|textit|textsl)\{([^{}]*)\}', '*$1*'
    $body = $body -replace '\\texttt\{([^{}]*)\}', '`$1`'
    $body = $body -replace '\\(?:textrm|textnormal|mbox|text|underline)\{([^{}]*)\}', '$1'
    # cross-refs + citations (keep as readable markers)
    $body = $body -replace '\\(?:eqref|ref|autoref|cref)\{([^{}]*)\}', '(ref: $1)'
    $body = $body -replace '\\(?:cite[a-z]*)\{([^{}]*)\}', '[cite: $1]'
    $body = $body -replace '\\(?:label)\{[^{}]*\}', ''
    # furniture / spacing commands -> drop
    $body = $body -replace '\\(?:maketitle|tableofcontents|newpage|clearpage|noindent|centering|bigskip|medskip|smallskip|vfill|hfill|par)\b', ''
    $body = $body -replace '\\(?:vspace|hspace)\*?\{[^{}]*\}', ''
    # escapes + ties
    $body = $body -replace '\\&', '&' -replace '\\%', '%' -replace '\\_', '_' -replace '\\#', '#' -replace '\\\$', '$'
    $body = $body -replace '~', ' ' -replace '\\,|\\;|\\:|\\!|\\ ', ' ' -replace '``|''''', '"' -replace '\\\\', "`n"

    # 5. restore math, then tidy whitespace
    $body = Restore-LatexMath $body
    $body = [regex]::Replace($body, '[ \t]+\r?\n', "`n")
    $body = [regex]::Replace($body, '\n{3,}', "`n`n")

    $h1 = if ($title) { '# ' + (Convert-LatexInline $title) } else { '# (untitled)' }
    return ($h1 + "`n`n" + $body.Trim() + "`n")
}

# --- references from the .bbl (compiled bibliography) ------------------------------------------------
function Get-LatexReferences {
    param([string]$Bbl)
    if (-not $Bbl) { return $null }
    $items = [regex]::Split($Bbl, '\\bibitem') | Select-Object -Skip 1
    if (-not $items.Count) { return $null }
    $lines = foreach ($it in $items) {
        $key = ([regex]::Match($it, '^\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}')).Groups[1].Value
        $txt = ($it -replace '^\s*(?:\[[^\]]*\])?\s*\{[^}]+\}', '')
        $txt = (Protect-LatexMath $txt); $txt = Convert-LatexInline $txt; $txt = Restore-LatexMath $txt
        $txt = [regex]::Replace($txt, '\s+', ' ').Trim()
        if ($txt) { "- **[$key]** $txt" }
    }
    return ($lines -join "`n")
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
    foreach ($f in $tex) {
        if (Select-String -LiteralPath $f.FullName -Pattern 'documentclass' -Quiet) { return $f.FullName }
    }
    if ($tex.Count) { return $tex[0].FullName }
    throw "no .tex found under $Dir"
}
# Flatten \input{f} / \include{f} by inlining (one level deep is enough for most arXiv submissions).
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
    $tex  = Resolve-LatexInputs -MainPath $main
    $md   = ConvertFrom-Latex $tex

    $bbl = @(Get-ChildItem -Recurse -File -Filter *.bbl $work) | Select-Object -First 1
    $refs = if ($bbl) { Get-LatexReferences ([System.IO.File]::ReadAllText($bbl.FullName, $u8)) } else { $null }
    if ($refs) { $md += "`n## References`n`n$refs`n" }

    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $outPath = Join-Path $OutDir "$Slug.md"
    [System.IO.File]::WriteAllText($outPath, $md, $u8)
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue

    $refCount = if ($refs) { @($refs -split "`n").Count } else { 0 }
    return [pscustomobject]@{
        slug = $Slug; out = $outPath; main_tex = (Split-Path -Leaf $main)
        bytes = $md.Length; math_spans = $script:LtxMathStore.Count
        sections = ([regex]::Matches($md, '(?m)^##\s')).Count; references = $refCount
    }
}
