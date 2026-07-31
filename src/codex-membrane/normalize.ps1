#requires -Version 7.0
<#
  src/codex-membrane/normalize.ps1 — deterministic content cleanup before grading.

  Three model-free passes the pipeline does on its own, so the agent only ever sees genuine
  judgment calls — never mechanical toil:

  * Math de-spacing — Docling space-tokenizes LaTeX (`\frac { d + 1 } { 2 }`); tighten braces
    and sub/superscripts back to compact form, then canonicalize into the math register
    (src/math-register.ps1). Alphabet macros (\mathbb/\mathcal/\mathfrak) are RETAINED — they are
    notation, not styling (spec §4.1/§8.1; reverses the old default). The pre-image is kept in
    content_raw — every change reversible.

  * Inline math — the extractor space-separates every math glyph (`π ( Z ) ≥ c 0`) while prose
    keeps words and punctuation glued (`(finite)`, `constant.`); a run of single-glyph tokens
    carrying a strong math character is therefore unambiguously inline math, and gets wrapped in
    $...$. "Strong" is decided by Unicode property classes (\p{Sm} + \p{IsGreekandCoptic}), not a
    hand-rolled set; the wrapped run is then converted unicode -> LaTeX (`ϵ`->`\epsilon`, `∈`->`\in`)
    by a table built BY CODEPOINT — no glyph literals to fold — so inline math matches display math.

  * Figure furniture — subfigure labels (`(a) ...`), captions, and OCR crumbs (`=2`) leak into the
    body as untyped prose; tag them is_furniture so finalize drops the noise and sets captions
    apart. Nothing is deleted; the tag is reversible and audited.

    . ./normalize.ps1
    Invoke-Normalize -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>] [-StripMacros mathbb,...]
#>

. "$PSScriptRoot/../shared/jsonl.ps1"
. "$PSScriptRoot/../latex-ingest/latex.ps1"   # Test-AlignmentOutsideEnv (the predicate Repair-MathAlignment fixes against)
. "$PSScriptRoot/../math-register/math-register.ps1"        # ConvertTo-RegisterMath + the shared glyph table ($script:MathLatex/Rx, Convert-MathToLatex)

# Compact a span of space-tokenized LaTeX: drop font-only macros, then tighten the delimiters the
# tokenizer loosened. Conservative — only braces and sub/superscripts close up; spaces separating a
# \command from its argument are left alone, so nothing is silently fused.
# Row breaks (\\) and \text{...} bodies are masked before de-spacing so re-runs stay safe.
function Optimize-MathContent([string]$Latex, [string[]]$StripMacros) {
    $s = $Latex
    foreach ($m in $StripMacros) {
        $s = [regex]::Replace($s, "\\$m\s*\{\s*([^{}]*?)\s*\}", '$1')   # \mathbb { E } -> E
        $s = [regex]::Replace($s, "\\$m\s+(\w)", '$1')                  # \mathbb E     -> E
    }

    $masks = [System.Collections.Generic.List[string]]::new()
    $mask = {
        param($m)
        $masks.Add($m.Value)
        "MATHMASK$($masks.Count - 1)END"
    }
    $s = [regex]::Replace($s, '\\\\', $mask)                             # cases/array row breaks
    $s = [regex]::Replace($s, '\\text\{[^{}]*\}', $mask)                 # \text{ if } spacing

    $s = $s -replace '\{\s+', '{'           # tighten inside opening brace
    $s = $s -replace '\s+\}', '}'           # tighten inside closing brace
    $s = $s -replace '\s+\{', '{'           # close \command { up to its group
    $s = $s -replace '\s*([_^])\s*', '$1'   # tighten sub/superscript
    $s = $s -replace '[ \t]{2,}', ' '       # collapse horizontal space runs (not newlines)

    for ($i = $masks.Count - 1; $i -ge 0; $i--) {
        $s = $s.Replace("MATHMASK${i}END", $masks[$i])
    }
    return $s.Trim()
}

$script:MathFunc = @('exp','log','ln','sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','max','min','sup','inf','lim','det','tr','Pr','Vol','arg','dim','ker','rank','diag','sign','mod','gcd','lcm','vec','Var','Cov')

# The Unicode -> LaTeX codepoint table ($script:MathLatex / $script:MathLatexRx) and
# Convert-MathToLatex moved to src/math-register.ps1 (dot-sourced above) — one glyph mapping
# shared by both conversion lanes (spec §5). Everything below still reads them from script scope.

# Prose-context overlay for math_dirt — subtract from the un-wrapped residual so biochemistry /
# unit / disjunctive prose mentions do not inflate the density gate. Same mask feeds
# Get-UnwrappedMathSpans so dispatch spans stay aligned with the count.
function Get-ProseContextMask([string]$s) {
    if (-not $s) { return (New-Mask -Spans @() -Length 0) }
    $spans = [System.Collections.Generic.List[object]]::new()
    foreach ($m in [regex]::Matches($s, '[\p{IsGreekandCoptic}]-[A-Za-z][\w-]*')) {
        $spans.Add([pscustomobject]@{ Start = $m.Index; End = $m.Index + $m.Length })
    }
    foreach ($m in [regex]::Matches($s, '\d+(?:\.\d+)?\s*[%°\u2103\u2032\u2033]')) {
        $spans.Add([pscustomobject]@{ Start = $m.Index; End = $m.Index + $m.Length })
    }
    foreach ($m in [regex]::Matches($s, '[\p{IsGreekandCoptic}](?:\s+(?:and|or)\s+[\p{IsGreekandCoptic}])+')) {
        $spans.Add([pscustomobject]@{ Start = $m.Index; End = $m.Index + $m.Length })
    }
    return (New-Mask -Spans $spans.ToArray() -Over $s)
}

function Get-MathDirtResidualMask([string]$Content) {
    $outside = Complement-Mask (Get-InlineMathMask $Content)
    return (Sub-Mask $outside (Get-ProseContextMask $Content))
}

function Get-MathDirt([string]$Content) {
    if (-not $Content) { return 0 }
    return (Get-MaskDensity -Text $Content -Within (Get-MathDirtResidualMask $Content) -Register $script:MathLatexRx)
}

# Alignment tabs (&) are a KaTeX/MathJax parse error OUTSIDE an alignment environment — docling
# sometimes flattens a multi-line derivation to bare "$$ a &= b \\ &= c $$" with the \begin{aligned}
# wrapper dropped, which fails at the first &. Wrap the body so it renders; only when there's an
# unescaped & and no environment already present (\\ alone is a legal display line break — untouched).
function Repair-MathAlignment([string]$math) {
    if (Test-AlignmentOutsideEnv $math) {
        return "\begin{aligned}`n" + $math.Trim() + "`n\end{aligned}"
    }
    return $math
}

# A glyph token: a lone character, a number, a known math function, or a short index list (j,k).
# Lone 'a'/'I' (article/pronoun) are NOT special-cased here: excluding them severed runs that
# legitimately start with those variables ("I \in R", "a \le b"). The strong-math gate in Add-MathRun
# is the real guard — a run carrying no \p{Sm}/Greek/relation is never wrapped, so a stray prose
# "a"/"I" forms a lone, strong-less run and is left untouched.
function Test-MathGlyphToken([string]$tok) {
    if ($tok.Length -eq 1) { return $true }
    if ($tok -match '^\d+$') { return $true }
    if ($script:MathFunc -contains $tok) { return $true }
    if ($tok -match '^[A-Za-z](,[A-Za-z0-9]){1,3}$') { return $true }
    return $false
}

# A strong token forces a run to read as math — decided from the Unicode database, not a literal
# map: a MathSymbol (∈ ≥ ∞ × ± → ∑ ∥ ...), a Greek/Coptic letter, a mathematical-alphanumeric, or an
# ASCII relation. Bare multiplication dots / asterisks are excluded — too weak alone, and footnote
# markers (U+2217) live in MathSymbol too.
function Test-StrongMath([string]$tok) {
    if ($tok.Length -ne 1) { return $false }
    if ($tok -match '\p{IsGreekandCoptic}') { return $true }                         # any Greek letter
    if ($tok -match '\p{Sm}') { return ([int][char]$tok[0]) -notin 0x00D7, 0x00B7, 0x00F7, 0x2217, 0x22C5, 0x22C6 }  # math symbol, minus weak dots/footnote ∗
    return ($tok -in '=', '<', '>', '+')
}

# Net bracket contribution of a token: opens ( [ { minus closes ) ] }. Lets the run builder know it is
# still inside an open delimiter, so a glued-punctuation filler (",r", "x*") doesn't cut the run before
# its closer arrives.
function Get-BracketDelta([string]$tok) {
    $d = 0
    foreach ($ch in $tok.ToCharArray()) {
        if     ($ch -eq '(' -or $ch -eq '[' -or $ch -eq '{') { $d++ }
        elseif ($ch -eq ')' -or $ch -eq ']' -or $ch -eq '}') { $d-- }
    }
    return $d
}

# Mid-expression filler: a non-glyph token that may be pulled INTO a run while a bracket is still open,
# so "( 0 ,r x * )" stays one $...$ span instead of splitting at the glued ",r". Conservative — any
# token carrying a 3+ letter word is prose (a real word inside the bracket means it was mis-tokenized,
# not math), and it must be made only of letters/digits/math punctuation so no stray markup is swallowed.
function Test-RunFiller([string]$tok) {
    if ($tok -eq '') { return $false }
    if ($tok -match '[A-Za-z]{3,}') { return $false }
    return ($tok -match '^[\p{L}\p{N}\p{P}\p{S}]+$')
}

# Per-class, never-negative delimiter check for an inline run. No LaTeX escapes exist at this stage
# (conversion to \command runs after wrapping, and adds only balanced braces), so a plain character
# scan matches Get-LatexBalance.full — the exact predicate the closure scanner uses.
function Test-RunBalanced([string]$s) {
    $p = 0; $b = 0; $c = 0
    foreach ($ch in $s.ToCharArray()) {
        switch ($ch) {
            '(' { $p++ } ')' { $p--; if ($p -lt 0) { return $false } }
            '[' { $b++ } ']' { $b--; if ($b -lt 0) { return $false } }
            '{' { $c++ } '}' { $c--; if ($c -lt 0) { return $false } }
        }
    }
    return ($p -eq 0 -and $b -eq 0 -and $c -eq 0)
}

# Flag, per token, any bracket with no partner in the run (an unmatched closer, or an opener never
# closed). Counts ( ) [ ] { } per class — matching Get-LatexBalance's per-class, never-negative rule —
# and attributes each widowed delimiter to the token carrying it, so the wrap can fall on the balanced
# side of it and the $...$ span we emit is always closed.
function Get-RunOrphans($Run) {
    $n = $Run.Count
    $orphan = New-Object 'bool[]' $n
    $stacks = @{ '(' = [System.Collections.Generic.Stack[int]]::new(); '[' = [System.Collections.Generic.Stack[int]]::new(); '{' = [System.Collections.Generic.Stack[int]]::new() }
    $opener = @{ ')' = '('; ']' = '['; '}' = '{' }
    for ($i = 0; $i -lt $n; $i++) {
        foreach ($ch in ([string]$Run[$i]).ToCharArray()) {
            $k = [string]$ch
            if     ($stacks.ContainsKey($k)) { $stacks[$k].Push($i) }
            elseif ($opener.ContainsKey($k)) {
                $s = $stacks[$opener[$k]]
                if ($s.Count -gt 0) { [void]$s.Pop() } else { $orphan[$i] = $true }
            }
        }
    }
    foreach ($key in @($stacks.Keys)) { while ($stacks[$key].Count -gt 0) { $orphan[$stacks[$key].Pop()] = $true } }
    return ,$orphan
}

# Emit one balanced segment of a run: wrap it in $...$ when it carries a strong math character and is
# delimiter-balanced, otherwise pass its tokens through as prose. The balance re-check is a backstop —
# a glued bracket the orphan split couldn't isolate falls back to prose, never a broken span.
function Add-RunSegment($Seg, $Out) {
    if ($Seg.Count -eq 0) { return }
    $strong = 0; foreach ($t in $Seg) { if (Test-StrongMath $t) { $strong++ } }
    $body = $Seg -join ' '
    if ($strong -ge 1 -and (Test-RunBalanced $body)) { $Out.Add('$' + (Convert-MathToLatex $body) + '$') }
    else { foreach ($t in $Seg) { $Out.Add($t) } }
    $Seg.Clear()
}

# Flush an accumulated glyph run: trailing sentence punctuation peels back to prose, then the run is
# split at any unmatched bracket so a bracketed sub-expression is never cut across the $ boundary. Each
# balanced segment is wrapped (if it carries strong math); the widowed delimiters stay as prose.
function Add-MathRun($Run, $Out) {
    if ($Run.Count -eq 0) { return }
    $head = [System.Collections.Generic.List[string]]::new()
    while ($Run.Count -gt 0 -and $Run[0] -match '^[,.;:]$') { $head.Add($Run[0]); $Run.RemoveAt(0) }
    $tail = [System.Collections.Generic.List[string]]::new()
    while ($Run.Count -gt 0 -and $Run[$Run.Count - 1] -match '^[,.;:]$') {
        $tail.Insert(0, $Run[$Run.Count - 1]); $Run.RemoveAt($Run.Count - 1)
    }
    foreach ($t in $head) { $Out.Add($t) }
    $orphan = Get-RunOrphans $Run
    $seg = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $Run.Count; $i++) {
        if ($orphan[$i]) { Add-RunSegment $seg $Out; $Out.Add($Run[$i]) }
        else { $seg.Add($Run[$i]) }
    }
    Add-RunSegment $seg $Out
    foreach ($t in $tail) { $Out.Add($t) }
    $Run.Clear()
}

# Wrap inline math by the glyph-run signal: maximal runs of space-separated glyph tokens carrying a
# strong math character become $...$. Prose words break runs; glued punctuation stays prose, so
# spaced math parens are caught and prose parens are not.
function ConvertTo-InlineMath([string]$Content) {
    # Un-glue brackets and punctuation from adjacent digits/math symbols/Greek, so the extractor's
    # inconsistent spacing ("(0", ",ε") can't fragment a run. Letters stay glued, so prose
    # "(finite)" is untouched; sentence commas that land at a run edge are peeled back in Add-MathRun.
    $c = [regex]::Replace($Content, '([(\[{,;])(?=\d|\p{Sm}|\p{IsGreekandCoptic})', '$1 ')
    $c = [regex]::Replace($c,        '(?<=\d|\p{Sm}|\p{IsGreekandCoptic})([)\]},;])', ' $1')
    $out = [System.Collections.Generic.List[string]]::new()
    $run = [System.Collections.Generic.List[string]]::new()
    $depth = 0      # net open brackets carried by $run; >0 means the run is still inside a delimiter
    $filled = 0     # consecutive non-glyph fillers pulled in while mid-bracket (bounded, anti-runaway)
    foreach ($t in ($c -split '\s+')) {
        if ($t -eq '') { continue }
        if (Test-MathGlyphToken $t) {
            $run.Add($t); $depth += (Get-BracketDelta $t); $filled = 0
        }
        elseif ($depth -gt 0 -and $filled -lt 3 -and (Test-RunFiller $t)) {
            # mid-bracket: keep glued punctuation ( ",r" ) inside the run so "( ... )" stays one span
            $run.Add($t); $depth += (Get-BracketDelta $t); $filled++
        }
        else { Add-MathRun $run $out; $out.Add($t); $depth = 0; $filled = 0 }
    }
    Add-MathRun $run $out
    return ($out -join ' ')
}

# Body prose that is really figure apparatus, by leading shape: a figure/table caption, a subfigure
# label, or a short non-linguistic OCR crumb. null = leave it as body content.
function Get-FurnitureKind([object]$Chunk, [double]$MedianFont = 0) {
    if ([string]$Chunk.type -ne 'prose') { return $null }
    $t = ([string]$Chunk.content).Trim()
    # small-font gate (principled typography signal): a prose node typeset well below the body median
    # is caption/footnote-grade. It GUARDS the colon-less caption cue, so body prose like "Figure 6
    # shows ..." at body size is never mistaken for a caption. font=null ghosts score 0 -> skip.
    $fs = if ($null -ne $Chunk.font_size) { [double]$Chunk.font_size } else { 0.0 }
    $small = ($MedianFont -gt 0 -and $Chunk.font -and $fs -gt 0 -and $fs -lt 0.85 * $MedianFont)
    if ($t -match '^(Figure|Fig\.?|Table|Tab\.?)\s*\d+\s*[:.]')        { return 'caption' }
    if ($small -and $t -match '^(Figure|Fig\.?|Table|Tab\.?)\s*\d+\b') { return 'caption' }   # colon-less caption, font-guarded
    if ($t -match '^\([a-z]\)\s')                                      { return 'figure_label' }
    # "short" = glyph count, not UTF-16 code units: an SMP run (each math glyph = 2 code units)
    # would otherwise escape this crumb gate. Count text elements so 𝔼𝔽𝔾 reads as 3, not 6.
    if ([System.Globalization.StringInfo]::new($t).LengthInTextElements -le 4 -and $t -notmatch '[A-Za-z]{2,}') { return 'crumb' }
    return $null
}

# ── display-vocabulary inline-script reconstruction ───────────────────────────
# docling keeps DISPLAY math as structured LaTeX but flattens INLINE math to text ("x 0"), losing the
# sub-vs-super distinction. The display formulas are a Rosetta Stone for the paper's own notation:
# harvest each base's sub/superscript usage from them, then deterministically rebuild the flattened
# inline occurrences. Only base+script pairs the display math actually uses are touched — an unknown
# pair is left flat for reasoning, never guessed.
function Get-MathVocab([string[]]$FormulaContents) {
    $sub = @{}; $sup = @{}
    foreach ($f in $FormulaContents) {
        foreach ($m in [regex]::Matches([string]$f, '([A-Za-z])\s*(\^|_)\s*\{?\s*([A-Za-z0-9]{1,3})\s*\}?')) {
            $k = $m.Groups[1].Value + '|' + $m.Groups[3].Value
            if ($m.Groups[2].Value -eq '_') { $sub[$k] = [int]$sub[$k] + 1 } else { $sup[$k] = [int]$sup[$k] + 1 }
        }
    }
    $v = @{}
    foreach ($k in (@($sub.Keys) + @($sup.Keys) | Select-Object -Unique)) {
        $script = ($k -split '\|')[1]
        $v[$k] = if ([int]$sub[$k] -ge [int]$sup[$k]) { '_{' + $script + '}' } else { '^{' + $script + '}' }
    }
    return $v
}

$script:mdVocab = @{}; $script:mdScripts = 0
# Rewrite "base SPACE script" -> "base_{script}"/"base^{script}" for vocab pairs only; lone a/I are
# excluded (article/pronoun). $Wrap also wraps each rebuilt token in $...$ (for bare prose occurrences).
function Reconstruct-Scripts([string]$s, [bool]$Wrap) {
    # The vocab membership IS the safety gate (only notation the display math uses), so no need to
    # exclude the article 'a' — that would also block the variable a_i. The trailing (?![...\.])
    # guards abbreviations: "i.i.d", "a priori" don't reconstruct because the script is followed by a letter/dot.
    return [regex]::Replace($s, '(?<![A-Za-z0-9$\\])([A-Za-z])\s+([A-Za-z0-9]{1,3})(?![A-Za-z0-9.])', {
        param($m)
        $k = $m.Groups[1].Value + '|' + $m.Groups[2].Value
        if (-not $script:mdVocab.ContainsKey($k)) { return $m.Value }
        $script:mdScripts++
        $rebuilt = $m.Groups[1].Value + $script:mdVocab[$k]
        if ($Wrap) { '$' + $rebuilt + '$' } else { $rebuilt }
    })
}

# Apply reconstruction: inside existing $...$ spans (no re-wrap), and to bare vocab pairs in the prose
# between spans (wrapped). Splitting on the spans keeps the two contexts from colliding.
function Repair-InlineScripts([string]$Content, [hashtable]$Vocab) {
    if ($Vocab.Count -eq 0) { return $Content }
    $script:mdVocab = $Vocab
    $parts = [regex]::Split($Content, '(\$[^$\n]+\$)')
    for ($i = 0; $i -lt $parts.Count; $i++) {
        if ($parts[$i] -match '^\$[^$\n]+\$$') {
            $parts[$i] = '$' + (Reconstruct-Scripts $parts[$i].Substring(1, $parts[$i].Length - 2) $false) + '$'
        }
        else { $parts[$i] = Reconstruct-Scripts $parts[$i] $true }
    }
    return ($parts -join '')
}

# Un-bleed prose docling merged into a display formula: it duplicates a paragraph into a trailing
# \text{...} row of the preceding equation AND keeps the real prose chunk. Drop trailing prose rows
# (Test-IsMath -Level Row = false) — but ONLY when the bled text is confirmed duplicated in a nearby
# prose chunk, so nothing is lost. Structural: must run before the vocab harvest so the Rosetta Stone stays clean.
function Get-UnbledFormula($Chunks, $Index) {
    $content = [string]$Chunks[$Index].content
    $rows = $content -split '\\\s*\\'        # row breaks, tolerant of the raw's space-tokenization
    if ($rows.Count -lt 2) { return $content }
    $start = 0;               while ($start -lt $rows.Count - 1 -and -not (Test-IsMath $rows[$start] -Level Row)) { $start++ }  # leading prose
    $end   = $rows.Count - 1; while ($end -gt $start           -and -not (Test-IsMath $rows[$end] -Level Row))   { $end-- }     # trailing prose
    if ($start -eq 0 -and $end -eq $rows.Count - 1) { return $content }
    $dropped = @()
    if ($start -gt 0)             { $dropped += $rows[0..($start - 1)] }
    if ($end -lt $rows.Count - 1) { $dropped += $rows[($end + 1)..($rows.Count - 1)] }
    $probe = ([regex]::Match(($dropped -join ' '), '[A-Za-z]{5,}')).Value
    if (-not $probe) { return $content }
    for ($j = [Math]::Max(0, $Index - 3); $j -le [Math]::Min($Index + 3, $Chunks.Count - 1); $j++) {
        if ($j -ne $Index -and [string]$Chunks[$j].type -eq 'prose' -and [string]$Chunks[$j].content -match [regex]::Escape($probe)) {
            return ($rows[$start..$end] -join '\\').Trim()   # duplicated nearby -> keep only the math core
        }
    }
    return $content
}

function Invoke-Normalize {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ChunksPath,
        [string] $NodesPath,
        # DEFAULT REVERSED (spec §8.1): alphabet macros are notation-bearing and are never stripped.
        # The knob survives for callers with a stated reason; empty means faithful.
        [string[]] $StripMacros = @(),
        # 'opendataloader' (docling) needs the flattened-inline-math RECONSTRUCTION (space-separated
        # glyph runs -> $...$, script reconstruction). The pig lane already emits $-wrapped inline math
        # with correct advance-metric spacing, so that pass only corrupts it (un-gluing "[1]"->"[ 1 ]").
        [string] $Lane = 'opendataloader'
    )
    $reconstructInline = ($Lane -ne 'pdfdig')
    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    $mathFixed = 0; $inlineFixed = 0; $unbled = 0; $script:mdScripts = 0; $script:mdDirt = 0
    $furn = [ordered]@{ caption = 0; figure_label = 0; crumb = 0 }
    $formulaContents = [System.Collections.Generic.List[string]]::new()

    # body font-size baseline for the furniture small-font gate: median over prose nodes with a real
    # font (ghost-layer font=null placeholders excluded, so they can't drag the median toward 12pt).
    $bodyFonts = [System.Collections.Generic.List[double]]::new()
    foreach ($c in $chunks) {
        if ([string]$c.type -eq 'prose' -and $c.font -and $null -ne $c.font_size) {
            $v = [double]$c.font_size; if ($v -gt 0) { $bodyFonts.Add($v) }
        }
    }
    $medianFont = 0.0
    if ($bodyFonts.Count) { $sorted = @($bodyFonts | Sort-Object); $medianFont = $sorted[[int][math]::Floor($sorted.Count / 2)] }

    # pass 1 (structural): un-bleed prose from formulas, de-space them (harvesting clean LaTeX for the
    # vocab), and tag figure furniture — all before any content op assumes the structure is sound.
    for ($i = 0; $i -lt $chunks.Count; $i++) {
        $c = $chunks[$i]
        if ([string]$c.type -eq 'formula' -and $c.content) {
            $orig  = [string]$c.content
            $clean = Get-UnbledFormula $chunks $i
            if ($clean -ne $orig) { $unbled++ }
            $norm = Repair-MathAlignment (ConvertTo-RegisterMath (Convert-MathToLatex (Optimize-MathContent $clean $StripMacros)))   # un-bled, de-spaced, unicode -> LaTeX, register-canonical, alignment-wrapped
            if ($norm -ne $orig) { $c | Add-Member -NotePropertyName content_raw -NotePropertyValue $orig -Force; $c.content = $norm; $mathFixed++ }
            $formulaContents.Add([string]$c.content)
            continue
        }
        $kind = Get-FurnitureKind $c $medianFont
        if ($kind -and -not $c.is_furniture) { $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue $kind -Force; $furn[$kind]++ }
    }

    $vocab = Get-MathVocab $formulaContents.ToArray()   # the Rosetta Stone, harvested from un-bled formulas

    # pass 2: prose — wrap inline-math runs, then reconstruct flattened scripts from the display vocab
    foreach ($c in $chunks) {
        if ([string]$c.type -eq 'prose' -and $c.content -and -not $c.is_furniture) {
            $orig    = [string]$c.content
            # pig lane: inline math is already $-wrapped by the converter (geometry) — do NOT
            # re-detect/re-tokenize (that spaces citations); only tighten the existing spans below.
            $wrapped = if ($reconstructInline) { Repair-InlineScripts (ConvertTo-InlineMath $orig) $vocab } else { $orig }
            # tighten the inline spans the same way display math is tightened (de-space braces, then
            # register-canonicalize) — otherwise pre-wrapped set-builder notation keeps its OCR
            # spacing, e.g. "{ X }". \mathbb et al. are retained (spec §8.1).
            $wrapped = [regex]::Replace($wrapped, '\$[^$\n]+\$', { param($m) '$' + (ConvertTo-RegisterMath -Latex (Optimize-MathContent ($m.Value.Substring(1, $m.Value.Length - 2)) @()) -Inline) + '$' })
            if ($wrapped -ne $orig) { $c | Add-Member -NotePropertyName content_raw -NotePropertyValue $orig -Force; $c.content = $wrapped; $inlineFixed++ }
            # dirt signal: Density(MathLatexRx, Sub(Complement($…$), prose_context)) — the named
            # mask-algebra instance; prose-context subtracts α-helix / unit / disjunctive mentions.
            $dirt = Get-MathDirt $wrapped
            if ($dirt -gt 0) { $c | Add-Member -NotePropertyName math_dirt -NotePropertyValue $dirt -Force; $script:mdDirt += $dirt }
        }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'normalize'
    "normalize: formulas un-bled $unbled, math tightened $mathFixed, inline wrapped $inlineFixed, scripts reconstructed $($script:mdScripts), unwrapped-math signals $($script:mdDirt) (vocab $($vocab.Count)); furniture — caption $($furn.caption), figure_label $($furn.figure_label), crumb $($furn.crumb) -> $ChunksPath"
    return $manifest
}

# Difference-localization for unwrapped_math — the mask union the math_dirt signal and the structure
# overlay both read: math-structure minus inline $...$, PLUS any MathLatexRx glyph surviving outside
# wrapped spans (Unicode α etc. that RxMathStructure may miss but math_dirt counts). One home beside the
# math_dirt density pass; fidelity's Get-ChunkIssues calls this lazily for span hints on the work-order.
function Get-UnwrappedMathSpans([string]$Content) {
    if (-not $Content) { return @() }
    $residual = Get-MathDirtResidualMask $Content
    $glyphs = Get-MaskDensity -Text $Content -Within $residual -Register $script:MathLatexRx -AsSpans
    $suppress = Get-ProseContextMask $Content
    $structure = Sub-Mask (Get-UnwrappedMathStructureMask $Content) $suppress
    return (Get-MaskSpanRecords (Union-Mask $structure $glyphs))
}
