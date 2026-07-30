#requires -Version 7.0
<#
  src/math-register.ps1 — span-level canonicalization into the math register.

  Implements the mechanical rules of issues/math-register/math-register-spec.md on a single math
  span's LaTeX (the content between $..$ / $$..$$, delimiters excluded). Shared by BOTH conversion
  lanes — latex-ingest's Store-Math serializes every span through it so the oracle deliverable is
  born canonical, and the membrane's normalize chain applies it after glyph repair. One register,
  one code path: conformance is a manuscript property, provenance is irrelevant (spec §0.1).

  Passes, in order (each idempotent, so the composition is):
    1. \text{..} bodies masked — prose is outside every math rule's jurisdiction (§3)
    2. \operatorname{X} / \operatorname*{X} -> \mathrm{X} (P4/§4.3). The residue quotiented away —
       \mathop atom class, operator spacing, display-limit placement — is TeX typesetting machinery,
       explicitly furniture under P1. The input form stays valuable as parser EVIDENCE (§4.5); it is
       inadmissible in the target.
    3. Alias surjection (§4.3): one concept, one spelling. Table below.
    4. Furniture removal (§4.2): renderer injection, manual spacing, redundant grouping.
    5. Glyph -> control sequence (§5): non-ASCII math symbols spelled as commands (\Omega, never Ω).
       The codepoint table lives HERE (moved from normalize.ps1) so both lanes share one mapping.

  Deliberately NOT here — spec §8.3 open items get no code until the corpus rules on them:
  \, (integrand kerning), \quad, \left/\right size matching, \big-family disambiguation.
  What is NEVER here: \mathbb/\mathcal/\mathfrak stripping — alphabet macros are notation,
  retained unconditionally (§4.1/§8.1; reverses the old normalize.ps1 default).
#>

# ── §4.3 alias surjection — spec rows + their exact mirror classes, nothing speculative ────────────
# Data-shaped per §4.4: one concept per entry, canonical ∈ members (fixed point — canonical forms
# are never members of another entry, so applying twice equals applying once), members pairwise
# disjoint. Grow via the §9 method: a row lands when a real document motivates it.
$script:MathAliases = @(
    @{ canonical = '\geq';  members = @('\ge', '\geqslant') }
    @{ canonical = '\leq';  members = @('\le', '\leqslant') }
    @{ canonical = '\neq';  members = @('\ne') }
    @{ canonical = '\to';   members = @('\rightarrow') }
    @{ canonical = '\frac'; members = @('\dfrac', '\tfrac') }
)
$script:MathAliasMap = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
foreach ($a in $script:MathAliases) { foreach ($m in $a.members) { $script:MathAliasMap[$m] = $a.canonical } }
# right boundary (?![a-zA-Z]) keeps \ge from matching inside \geq/\gets/\genfrac; the leading
# backslash is its own left boundary (\rightarrow never matches inside \longrightarrow/\xrightarrow).
$script:MathAliasRx = [regex]('(?:' + (($script:MathAliasMap.Keys | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')(?![a-zA-Z])')

# ── §5 glyph -> lexical mapping (moved verbatim from codex-membrane/normalize.ps1) ─────────────────
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
# (Moved verbatim from normalize.ps1 — the membrane's inline-run wrapping still calls it directly.)
function Convert-MathToLatex([string]$s) {
    $r = $script:MathLatexRx.Replace($s, {
        param($m)
        $v = $null
        if ($script:MathLatex.TryGetValue($m.Value, [ref]$v)) { return $v + ' ' }
        return $m.Value
    })
    return (($r -replace '\s{2,}', ' ').Trim())
}

# ── the canonicalizer ──────────────────────────────────────────────────────────────────────────────
function ConvertTo-RegisterMath {
    param([string]$Latex, [switch]$Inline)
    if ([string]::IsNullOrWhiteSpace($Latex)) { return $Latex }
    $s = $Latex

    # 1. mask \text bodies — no math rule may rewrite prose (§3). Flat bodies only: a nested-brace
    #    \text stays live, the conservative failure (commands/glyphs there still render under KaTeX).
    $masks = [System.Collections.Generic.List[string]]::new()
    $s = [regex]::Replace($s, '\\text\s*\{[^{}]*\}', { param($m) $masks.Add($m.Value); "REGMASK$($masks.Count - 1)END" })

    # 2. \operatorname lowering (P4/§4.3). Flat operator names only ([^{}]) — a nested-brace name is
    #    left as \operatorname, which KaTeX renders; never guessed at.
    $s = [regex]::Replace($s, '\\operatorname\s*\*?\s*\{\s*([^{}]*?)\s*\}', '\mathrm{$1}')

    # 3. alias surjection (§4.3)
    $s = $script:MathAliasRx.Replace($s, { param($m) $script:MathAliasMap[$m.Value] })

    # 4. furniture removal (§4.2) — the enumerated conservative cut; §8.3 open items untouched
    $s = [regex]::Replace($s, '\\textcolor\s*(?:\[[^\]]*\])?\s*\{[^{}]*\}\s*(?=\{)', '')   # keep the payload group: grouping may be load-bearing after ^/_
    $s = [regex]::Replace($s, '\\color\s*(?:\[[^\]]*\])?\s*\{[^{}]*\}', '')
    $s = [regex]::Replace($s, '\\[vh]space\*?\s*\{[^{}]*\}', '')
    $s = [regex]::Replace($s, '\\(?:smallskip|medskip|bigskip|noindent)(?![a-zA-Z])', '')
    $s = $s -replace '\\!', ''                                                             # negative kerning is always visual
    if ($Inline) { $s = [regex]::Replace($s, '\\displaystyle(?![a-zA-Z])\s*', '') }        # sizing injection in inline position
    do { $prev = $s; $s = [regex]::Replace($s, '\{\s*\{([^{}]*)\}\s*\}', '{$1}') } while ($s -ne $prev)   # {{x}} -> {x}
    $s = $s -replace '[ \t]{2,}', ' '                                                      # close the seams the removals left; newlines untouched

    # 5. glyph -> control sequence (§5): only on non-ASCII presence; trailing space only when the
    #    next char would fuse with a command word (display newlines preserved — unlike Convert-MathToLatex,
    #    which collapses all whitespace and is only safe on single-line runs).
    if ($s -match '[^\x00-\x7F]') {
        $src = $s
        $s = $script:MathLatexRx.Replace($src, {
            param($m)
            $v = $null
            if (-not $script:MathLatex.TryGetValue($m.Value, [ref]$v)) { return $m.Value }
            $j = $m.Index + $m.Length
            if ($v -match '[A-Za-z]$' -and $j -lt $src.Length -and [char]::IsLetter($src[$j])) { return $v + ' ' }
            return $v
        })
    }

    for ($i = $masks.Count - 1; $i -ge 0; $i--) { $s = $s.Replace("REGMASK${i}END", $masks[$i]) }
    return $s
}
