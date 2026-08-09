#requires -Version 7.0
<#
  src/math-channel/md-math.ps1 — math-span primitives for markdown that arrived from a
  non-markdown source. Pure text in / text out: every function takes a string (or a token) and
  returns a string or a boolean. No document model, no chunk stream, no run addressing — so any
  lane that produces markdown from PDF, LaTeX, or an IR can serialize its math spans through the
  same rules.

  Two jobs, kept separate:

  * SPAN REPAIR — Optimize-MathContent tightens LaTeX that an extractor space-tokenized
    (`\frac { d + 1 } { 2 }`); Repair-MathAlignment wraps a bare alignment body so it parses.
    Both are conservative and idempotent: re-running on already-clean input is a no-op.

  * RUN CLASSIFICATION — Test-MathGlyphToken and Test-StrongMath are the two predicates a caller
    needs to decide whether a whitespace-separated run of tokens is inline math. They classify
    tokens only; assembling and wrapping the run belongs to the caller, which owns the surrounding
    markdown context (fences, tables, links) these predicates deliberately know nothing about.

  Unicode -> LaTeX conversion and register canonicalization are NOT here: they belong to
  src/math-channel, and a caller composes them (see src/md-postprocess/audits/md-cleanup.ps1).

    . ./md-math.ps1
    Optimize-MathContent '\frac { d + 1 } { 2 }' @()      # -> \frac{d+1}{2}
    Repair-MathAlignment 'a &= b \\ &= c'                 # -> \begin{aligned} ... \end{aligned}
#>

. "$PSScriptRoot/../latex-ingest/latex.ps1"   # Test-AlignmentOutsideEnv — the predicate Repair-MathAlignment fixes against

# Compact a span of space-tokenized LaTeX: drop the named font-only macros, then tighten the
# delimiters the tokenizer loosened. Conservative — only braces and sub/superscripts close up;
# spaces separating a \command from its argument are left alone, so nothing is silently fused.
# Row breaks (\\) and \text{...} bodies are masked before de-spacing, so re-runs stay safe.
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

# Alignment tabs (&) are a KaTeX/MathJax parse error OUTSIDE an alignment environment. A converter
# that flattens a multi-line derivation to bare "$$ a &= b \\ &= c $$" drops the \begin{aligned}
# wrapper, and the span fails at the first &. Wrap the body so it renders — only when there is an
# unescaped & and no environment already present (\\ alone is a legal display line break, untouched).
function Repair-MathAlignment([string]$math) {
    if (Test-AlignmentOutsideEnv $math) {
        return "\begin{aligned}`n" + $math.Trim() + "`n\end{aligned}"
    }
    return $math
}

# Function names that read as math rather than prose when they appear as a bare token.
$script:MathFunc = @('exp','log','ln','sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','max','min','sup','inf','lim','det','tr','Pr','Vol','arg','dim','ker','rank','diag','sign','mod','gcd','lcm','vec','Var','Cov')

# A glyph token: a lone character, a number, a known math function, or a short index list (j,k).
# Lone 'a'/'I' (article/pronoun) are NOT special-cased here — excluding them severed runs that
# legitimately start with those variables ("I \in R", "a \le b"). The caller's strong-math gate is
# the real guard: a run carrying no \p{Sm}/Greek/relation is never wrapped, so a stray prose "a"/"I"
# forms a lone, strong-less run and is left untouched.
function Test-MathGlyphToken([string]$tok) {
    if ($tok.Length -eq 1) { return $true }
    if ($tok -match '^\d+$') { return $true }
    if ($script:MathFunc -contains $tok) { return $true }
    if ($tok -match '^[A-Za-z](,[A-Za-z0-9]){1,3}$') { return $true }
    return $false
}

# A strong token forces a run to read as math — decided from the Unicode database, not a literal
# map: a MathSymbol (∈ ≥ ∞ × ± → ∑ ∥ ...), a Greek/Coptic letter, or an ASCII relation. Bare
# multiplication dots / asterisks are excluded — too weak alone, and footnote markers (U+2217) live
# in MathSymbol too.
function Test-StrongMath([string]$tok) {
    if ($tok.Length -ne 1) { return $false }
    if ($tok -match '\p{IsGreekandCoptic}') { return $true }                         # any Greek letter
    if ($tok -match '\p{Sm}') { return ([int][char]$tok[0]) -notin 0x00D7, 0x00B7, 0x00F7, 0x2217, 0x22C5, 0x22C6 }  # math symbol, minus weak dots/footnote ∗
    return ($tok -in '=', '<', '>', '+')
}
