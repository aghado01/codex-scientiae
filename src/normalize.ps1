#requires -Version 7.0
<#
  src/normalize.ps1 — deterministic content cleanup before grading.

  Three model-free passes the pipeline does on its own, so the agent only ever sees genuine
  judgment calls — never mechanical toil:

  * Math de-spacing — Docling space-tokenizes LaTeX (`\frac { d + 1 } { 2 }`); tighten braces
    and sub/superscripts back to compact form, and strip blackboard-bold and other font-only
    macros (`\mathbb { E }` -> `E`). The pre-image is kept in content_raw — every change reversible.

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

. "$PSScriptRoot/jsonl.ps1"

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

# Unicode -> LaTeX, built BY CODEPOINT at runtime so source-file Unicode normalisation can't fold a
# variant Greek glyph onto the wrong (or duplicate) key. A symbol absent from the table falls through
# unchanged, so the worst case is a still-rendering unicode char, never a broken one.
# Ordinal (case-sensitive) — a default @{} hashtable folds λ/Λ, π/ϖ, ε/ϵ onto one key.
$script:MathLatex = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
$gl = 'alpha','beta','gamma','delta','varepsilon','zeta','eta','theta','iota','kappa','lambda','mu','nu','xi','o','pi','rho','varsigma','sigma','tau','upsilon','phi','chi','psi','omega'
for ($i = 0; $i -lt $gl.Count; $i++) { $script:MathLatex[([char](0x03B1 + $i)).ToString()] = $(if ($gl[$i] -eq 'o') { 'o' } else { '\' + $gl[$i] }) }
$byCode = @{
    0x0393='\Gamma'; 0x0394='\Delta'; 0x0398='\Theta'; 0x039B='\Lambda'; 0x039E='\Xi'; 0x03A0='\Pi'; 0x03A3='\Sigma'; 0x03A5='\Upsilon'; 0x03A6='\Phi'; 0x03A8='\Psi'; 0x03A9='\Omega'
    0x03D1='\vartheta'; 0x03D5='\varphi'; 0x03D6='\varpi'; 0x03F0='\varkappa'; 0x03F1='\varrho'; 0x03F5='\epsilon'
    0x2208='\in'; 0x2209='\notin'; 0x2282='\subset'; 0x2286='\subseteq'; 0x2283='\supset'; 0x2287='\supseteq'; 0x222A='\cup'; 0x2229='\cap'; 0x221E='\infty'; 0x00B1='\pm'; 0x2213='\mp'; 0x00D7='\times'; 0x00F7='\div'; 0x2264='\leq'; 0x2265='\geq'; 0x2260='\neq'; 0x2248='\approx'; 0x223C='\sim'; 0x2243='\simeq'; 0x2245='\cong'; 0x2261='\equiv'; 0x2192='\to'; 0x2190='\gets'; 0x21A6='\mapsto'; 0x21D2='\Rightarrow'; 0x21D4='\Leftrightarrow'; 0x2200='\forall'; 0x2203='\exists'; 0x2207='\nabla'; 0x2202='\partial'; 0x2211='\sum'; 0x220F='\prod'; 0x222B='\int'; 0x221A='\sqrt'; 0x221D='\propto'; 0x2295='\oplus'; 0x2297='\otimes'; 0x2216='\setminus'; 0x2205='\emptyset'; 0x2227='\wedge'; 0x2228='\vee'; 0x00AC='\neg'; 0x2218='\circ'; 0x27E8='\langle'; 0x27E9='\rangle'; 0x2225='\|'; 0x22C5='\cdot'; 0x00B7='\cdot'; 0x2026='\dots'; 0x225C='\triangleq'; 0x226A='\ll'; 0x226B='\gg'; 0x230A='\lfloor'; 0x230B='\rfloor'; 0x2308='\lceil'; 0x2309='\rceil'; 0x2212='-'; 0x2217='*'; 0x22C6='\star'; 0x2032="'"
    0x2193='\downarrow'; 0x2191='\uparrow'; 0x2206='\Delta'; 0x224D='\asymp'; 0x2272='\lesssim'; 0x2273='\gtrsim'; 0x22A4='\top'; 0x22A5='\perp'; 0x2AB0='\succeq'; 0x2AAF='\preceq'; 0x2223='\mid'
}
foreach ($k in $byCode.Keys) { $script:MathLatex[([char]$k).ToString()] = $byCode[$k] }
$script:MathLatexRx = [regex]('(' + (($script:MathLatex.Keys | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')')

# Convert the unicode in a wrapped run to LaTeX. Each mapped symbol gets a trailing space so a command
# can't fuse with the next token (\Lambda x, never \Lambdax); runs of space then collapse.
function Convert-MathToLatex([string]$s) {
    $r = $script:MathLatexRx.Replace($s, {
        param($m)
        $v = $null
        if ($script:MathLatex.TryGetValue($m.Value, [ref]$v)) { return $v + ' ' }
        return $m.Value
    })
    return (($r -replace '\s{2,}', ' ').Trim())
}

# A glyph token: a lone character, a number, a known math function, or a short index list (j,k).
# Lone 'a'/'I' are excluded — the English article and pronoun are too ambiguous to claim as math.
function Test-MathGlyphToken([string]$tok) {
    if ($tok -ceq 'a' -or $tok -ceq 'I') { return $false }
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

# Flush an accumulated glyph run: trailing sentence punctuation peels back to prose; the run is
# wrapped in $...$ (unicode kept as-is) only if it carries a strong math character.
function Add-MathRun($Run, $Out) {
    if ($Run.Count -eq 0) { return }
    $head = [System.Collections.Generic.List[string]]::new()
    while ($Run.Count -gt 0 -and $Run[0] -match '^[,.;:]$') { $head.Add($Run[0]); $Run.RemoveAt(0) }
    $tail = [System.Collections.Generic.List[string]]::new()
    while ($Run.Count -gt 0 -and $Run[$Run.Count - 1] -match '^[,.;:]$') {
        $tail.Insert(0, $Run[$Run.Count - 1]); $Run.RemoveAt($Run.Count - 1)
    }
    foreach ($t in $head) { $Out.Add($t) }
    $strong = 0; foreach ($t in $Run) { if (Test-StrongMath $t) { $strong++ } }
    if ($Run.Count -ge 1 -and $strong -ge 1) { $Out.Add('$' + (Convert-MathToLatex ($Run -join ' ')) + '$') }
    else { foreach ($t in $Run) { $Out.Add($t) } }
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
    foreach ($t in ($c -split '\s+')) {
        if ($t -eq '') { continue }
        if (Test-MathGlyphToken $t) { $run.Add($t) }
        else { Add-MathRun $run $out; $out.Add($t) }
    }
    Add-MathRun $run $out
    return ($out -join ' ')
}

# Body prose that is really figure apparatus, by leading shape: a figure/table caption, a subfigure
# label, or a short non-linguistic OCR crumb. null = leave it as body content.
function Get-FurnitureKind([object]$Chunk) {
    if ([string]$Chunk.type -ne 'prose') { return $null }
    $t = ([string]$Chunk.content).Trim()
    if ($t -match '^(Figure|Fig\.?|Table|Tab\.?)\s*\d+\s*[:.]') { return 'caption' }
    if ($t -match '^\([a-z]\)\s')                                { return 'figure_label' }
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

# A formula row is math (not bled prose) if, after stripping command names, it carries at most a
# couple of 4+ letter words — same heuristic the closure scanner uses, local so the pipeline needn't
# dot-source md-cleanup.
function Test-MathRow([string]$s) {
    return (([regex]::Matches(($s -replace '\\[A-Za-z]+', ' '), '[A-Za-z]{4,}')).Count -le 2)
}

# Un-bleed prose docling merged into a display formula: it duplicates a paragraph into a trailing
# \text{...} row of the preceding equation AND keeps the real prose chunk. Drop trailing prose rows
# (Test-MathRow = false) — but ONLY when the bled text is confirmed duplicated in a nearby prose chunk,
# so nothing is lost. Structural: must run before the vocab harvest so the Rosetta Stone stays clean.
function Get-UnbledFormula($Chunks, $Index) {
    $content = [string]$Chunks[$Index].content
    $rows = $content -split '\\\s*\\'        # row breaks, tolerant of the raw's space-tokenization
    if ($rows.Count -lt 2) { return $content }
    $start = 0;               while ($start -lt $rows.Count - 1 -and -not (Test-MathRow $rows[$start])) { $start++ }  # leading prose
    $end   = $rows.Count - 1; while ($end -gt $start           -and -not (Test-MathRow $rows[$end]))   { $end-- }     # trailing prose
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
        [string[]] $StripMacros = @('mathbb')
    )
    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    $mathFixed = 0; $inlineFixed = 0; $unbled = 0; $script:mdScripts = 0
    $furn = [ordered]@{ caption = 0; figure_label = 0; crumb = 0 }
    $formulaContents = [System.Collections.Generic.List[string]]::new()

    # pass 1 (structural): un-bleed prose from formulas, de-space them (harvesting clean LaTeX for the
    # vocab), and tag figure furniture — all before any content op assumes the structure is sound.
    for ($i = 0; $i -lt $chunks.Count; $i++) {
        $c = $chunks[$i]
        if ([string]$c.type -eq 'formula' -and $c.content) {
            $orig  = [string]$c.content
            $clean = Get-UnbledFormula $chunks $i
            if ($clean -ne $orig) { $unbled++ }
            $norm = Convert-MathToLatex (Optimize-MathContent $clean $StripMacros)   # un-bled, de-spaced, unicode -> LaTeX
            if ($norm -ne $orig) { $c | Add-Member -NotePropertyName content_raw -NotePropertyValue $orig -Force; $c.content = $norm; $mathFixed++ }
            $formulaContents.Add([string]$c.content)
            continue
        }
        $kind = Get-FurnitureKind $c
        if ($kind -and -not $c.is_furniture) { $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue $kind -Force; $furn[$kind]++ }
    }

    $vocab = Get-MathVocab $formulaContents.ToArray()   # the Rosetta Stone, harvested from un-bled formulas

    # pass 2: prose — wrap inline-math runs, then reconstruct flattened scripts from the display vocab
    foreach ($c in $chunks) {
        if ([string]$c.type -eq 'prose' -and $c.content -and -not $c.is_furniture) {
            $orig    = [string]$c.content
            $wrapped = Repair-InlineScripts (ConvertTo-InlineMath $orig) $vocab
            if ($wrapped -ne $orig) { $c | Add-Member -NotePropertyName content_raw -NotePropertyValue $orig -Force; $c.content = $wrapped; $inlineFixed++ }
        }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'normalize'
    "normalize: formulas un-bled $unbled, math tightened $mathFixed, inline wrapped $inlineFixed, scripts reconstructed $($script:mdScripts) (vocab $($vocab.Count)); furniture — caption $($furn.caption), figure_label $($furn.figure_label), crumb $($furn.crumb) -> $ChunksPath"
    return $manifest
}
