#requires -Version 7.0
<#
  src/pdf-converter/math-assembler.ps1 — 1.5-D math structure assembler.

  Turns a run of positioned math glyphs (from the pig substrate: each carrying bx/base/size/font)
  into structurally-valid LaTeX by INVERTING the forward layout: TeX sets scripts at a smaller size
  and a displaced baseline, and NESTS them (a subscript's own subscript is smaller still). The pig
  classifier's flat per-glyph script call cannot express nesting and emits invalid `t_{v}_{1}` for
  `t_{v_{i+1}}` — the dominant display-math render failure. This assembler does the recursive
  size-tier descent instead.

  Scope: this is the "1.5-D" tier — horizontal layout + recursively nested super/subscripts, which
  is what CM's size ladder (10/7/5 pt) encodes unambiguously. TRUE 2-D structure (fractions from
  rule bars, matrices, aligned) is the C# AST tier (Markpig.Pdf) and stays flagged here.

  Deterministic + store-driven: thresholds from classify-config.math_assembler; glyph corrections
  from stores/symbol-map.jsonl (scope 'math'). Unicode content is preserved where KaTeX renders it
  (Greek, most operators) — only math-mode-hostile glyphs are mapped.

    . ./math-assembler.ps1
    ConvertTo-NestedMath -Letters <letter[]> -SizeRatio 0.75 -BaselineTol 0.8 [-SymbolFn {..}]
#>

# net bracket balance of an assembled span: opens ([{ minus closes )]}, plus \left/\right pairs.
# Non-zero ⇒ an unclosed delimiter (the span was truncated, or a norm/abs bar swallowed a partner) —
# a dispatchable flag for the repair tier, never silently "fixed".
function Measure-DelimiterBalance([string] $s) {
    if (-not $s) { return 0 }
    # only CONTENT delimiters ( ) [ ] — the structural { } the assembler emits for _{}/^{} are
    # balanced by construction and would only add noise. A non-zero net = an unclosed content bracket.
    $net = 0
    foreach ($ch in $s.ToCharArray()) {
        switch ($ch) { '(' { $net++ } '[' { $net++ } ')' { $net-- } ']' { $net-- } }
    }
    return $net
}

# glyph text with an optional per-glyph correction hook ($SymbolFn: text,font -> text|null)
function Get-MathGlyphText($g, $SymbolFn) {
    $t = [string]$g.text
    if ($SymbolFn) {
        $m = & $SymbolFn $t ([string]$g.font)
        if ($null -ne $m) { return $m }
    }
    return $t
}

<#
  Recursive descent over glyphs sorted left-to-right. At each position the current glyph is a base;
  the maximal following run of glyphs that are BOTH smaller (< base.size * SizeRatio) AND
  baseline-displaced is its script cluster. That cluster is partitioned into a superscript part
  (higher baseline) and subscript part (lower), and EACH is assembled by the SAME routine — so a
  script's own script nests correctly (t → v → i+1 ⇒ t_{v_{i+1}}). A glyph that returns to base size
  or baseline ends the current term and becomes the next base.
#>
function ConvertTo-NestedMath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Letters,
        [double] $SizeRatio = 0.78,      # a glyph smaller than base*SizeRatio can be a script
        [double] $BaselineTolFrac = 0.12,# baseline delta beyond this fraction of the BASE glyph size = displaced
        [scriptblock] $SymbolFn = $null
    )
    $n = $Letters.Count
    if ($n -eq 0) { return '' }

    # sort by x (start), stable by original index — determinism on tied coordinates
    $ord = [object[]]::new($n); $keys = [double[]]::new($n)
    for ($i = 0; $i -lt $n; $i++) { $ord[$i] = $Letters[$i]; $keys[$i] = [double]$Letters[$i].bx[0] * 1000000.0 + $i }
    [Array]::Sort($keys, $ord)

    $sb = [System.Text.StringBuilder]::new()
    $i = 0
    while ($i -lt $n) {
        $g = $ord[$i]
        $gSize = [double]$g.size
        $gBase = [double]$g.base[1]
        $tol = $BaselineTolFrac * $gSize   # displacement tolerance scales with the base glyph size
        [void]$sb.Append((Get-MathGlyphText $g $SymbolFn))

        # gather the attached script cluster: consecutive smaller + displaced glyphs
        $cluster = [System.Collections.Generic.List[object]]::new()
        $j = $i + 1
        while ($j -lt $n) {
            $h = $ord[$j]
            $displaced = [math]::Abs([double]$h.base[1] - $gBase) -gt $tol
            if (([double]$h.size -lt $gSize * $SizeRatio) -and $displaced) { $cluster.Add($h); $j++ }
            else { break }
        }

        if ($cluster.Count -gt 0) {
            $sups = [System.Collections.Generic.List[object]]::new()
            $subs = [System.Collections.Generic.List[object]]::new()
            foreach ($h in $cluster) {
                if ([double]$h.base[1] -gt $gBase + $tol) { $sups.Add($h) } else { $subs.Add($h) }
            }
            # recurse so a script's own script nests; superscript first (TeX order-agnostic for KaTeX)
            if ($sups.Count -gt 0) {
                [void]$sb.Append('^{'); [void]$sb.Append((ConvertTo-NestedMath -Letters $sups.ToArray() -SizeRatio $SizeRatio -BaselineTolFrac $BaselineTolFrac -SymbolFn $SymbolFn)); [void]$sb.Append('}')
            }
            if ($subs.Count -gt 0) {
                [void]$sb.Append('_{'); [void]$sb.Append((ConvertTo-NestedMath -Letters $subs.ToArray() -SizeRatio $SizeRatio -BaselineTolFrac $BaselineTolFrac -SymbolFn $SymbolFn)); [void]$sb.Append('}')
            }
        }
        $i = $j
    }
    return $sb.ToString()
}
