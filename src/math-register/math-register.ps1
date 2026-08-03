#requires -Version 7.0
<#
  src/math-register/math-register.ps1 — span-level canonicalization into the math register.

  Implements the mechanical rules of issues/math-register/math-register-spec.md on a single math
  span's LaTeX (the content between $..$ / $$..$$, delimiters excluded). Shared by BOTH conversion
  lanes — latex-ingest's Store-Math serializes every span through it so the oracle deliverable is
  born canonical, and the membrane's normalize chain applies it after glyph repair. One register,
  one code path: conformance is a manuscript property, provenance is irrelevant (spec §0.1).

  Data-driven via target store files under `src/math-register/stores/`:
  - `jurisdiction.json`: Prose protection & boundary masking (\text{...})
  - `operators.json`: Atom-class operator lowering (\operatorname -> \mathrm)
  - `surjections.json`: Normative command alias surjection mappings
  - `hygiene.json`: Target syntax & brace hygiene ({{x}} -> {x})
  - `lexicon.json`: Canonical Unicode symbol dictionary (\alpha, \Omega, \leq)
#>

$script:MathRegisterUtf8 = [System.Text.UTF8Encoding]::new($false)
$script:MathRegisterStoreDataCache = $null

function Get-MathRegisterStore {
    if ($null -ne $script:MathRegisterStoreDataCache) { return $script:MathRegisterStoreDataCache }
    $storesDir = Join-Path $PSScriptRoot 'stores'
    $jurisdictionFile = Join-Path $storesDir 'jurisdiction.json'
    $operatorsFile    = Join-Path $storesDir 'operators.json'
    $surjectionsFile  = Join-Path $storesDir 'surjections.json'
    $hygieneFile      = Join-Path $storesDir 'hygiene.json'
    $lexiconFile      = Join-Path $storesDir 'lexicon.json'

    $jurisdiction = if (Test-Path -LiteralPath $jurisdictionFile -PathType Leaf) { [System.IO.File]::ReadAllText($jurisdictionFile, $script:MathRegisterUtf8) | ConvertFrom-Json } else { @() }
    $operators    = if (Test-Path -LiteralPath $operatorsFile -PathType Leaf)    { [System.IO.File]::ReadAllText($operatorsFile, $script:MathRegisterUtf8)    | ConvertFrom-Json } else { @() }
    $surjections  = if (Test-Path -LiteralPath $surjectionsFile -PathType Leaf)  { [System.IO.File]::ReadAllText($surjectionsFile, $script:MathRegisterUtf8)  | ConvertFrom-Json } else { @() }
    $hygiene      = if (Test-Path -LiteralPath $hygieneFile -PathType Leaf)      { [System.IO.File]::ReadAllText($hygieneFile, $script:MathRegisterUtf8)      | ConvertFrom-Json } else { @() }
    $lexicon      = if (Test-Path -LiteralPath $lexiconFile -PathType Leaf)      { [System.IO.File]::ReadAllText($lexiconFile, $script:MathRegisterUtf8)      | ConvertFrom-Json } else { @() }

    $script:MathRegisterStoreDataCache = [pscustomobject]@{
        prose_masks        = $jurisdiction
        operator_lowerings = $operators
        aliases            = $surjections
        cleanups           = $hygiene
        unicode_glyphs     = $lexicon
    }
    return $script:MathRegisterStoreDataCache
}

# ── Store Pre-compilation ────────────────────────────────────────────────────────────────────────────
$storeData = Get-MathRegisterStore

# Alias Surjection Map & Regex
$script:MathAliasMap = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
if ($storeData -and $storeData.aliases) {
    foreach ($a in $storeData.aliases) {
        foreach ($m in $a.members) {
            $script:MathAliasMap[$m] = $a.canonical
        }
    }
}
$script:MathAliasRx = if ($script:MathAliasMap.Count -gt 0) {
    [regex]('(?:' + (($script:MathAliasMap.Keys | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')(?![a-zA-Z])')
} else { $null }

# Unicode Glyph Map & Regex
$script:MathLatex = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
if ($storeData -and $storeData.unicode_glyphs) {
    foreach ($item in $storeData.unicode_glyphs) {
        $script:MathLatex[$item.glyph] = $item.latex
    }
}
$script:MathLatexRx = if ($script:MathLatex.Count -gt 0) {
    # the glyph pass exists to spell NON-ASCII glyphs as control sequences. A pure-ASCII key is
    # store corruption — it would rewrite ordinary letters/words body-wide (the 'o'-splitting
    # incident: glyph "o" mapped to "o" injected a space after every o in any non-ASCII span).
    # Refuse such keys loudly and build the matcher from the sound ones only.
    $badKeys = @($script:MathLatex.Keys | Where-Object { $_ -notmatch '[^\x00-\x7F]' })
    if ($badKeys.Count -gt 0) { Write-Warning "math-register lexicon: refusing $($badKeys.Count) pure-ASCII glyph key(s): $($badKeys -join ' ')" }
    $soundKeys = @($script:MathLatex.Keys | Where-Object { $_ -match '[^\x00-\x7F]' })
    if ($soundKeys.Count -gt 0) {
        [regex]('(' + (($soundKeys | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')')
    } else { $null }
} else { $null }

# Convert the unicode in a wrapped run to LaTeX.
function Convert-MathToLatex([string]$s) {
    if (-not $script:MathLatexRx) { return $s }
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
    $store = Get-MathRegisterStore

    # 1. Prose Masking Pass (from jurisdiction.json)
    $masks = [System.Collections.Generic.List[string]]::new()
    if ($store -and $store.prose_masks) {
        foreach ($pm in $store.prose_masks) {
            $s = [regex]::Replace($s, $pm.pattern, { param($m) $masks.Add($m.Value); "REGMASK$($masks.Count - 1)END" })
        }
    } else {
        $s = [regex]::Replace($s, '\\text\s*\{[^{}]*\}', { param($m) $masks.Add($m.Value); "REGMASK$($masks.Count - 1)END" })
    }

    # 2. Operator Lowering Pass (from operators.json)
    if ($store -and $store.operator_lowerings) {
        foreach ($op in $store.operator_lowerings) {
            $s = [regex]::Replace($s, $op.pattern, $op.replacement)
        }
    } else {
        $s = [regex]::Replace($s, '\\operatorname\s*\*?\s*\{\s*([^{}]*?)\s*\}', '\mathrm{$1}')
    }

    # 3. Alias Surjection Pass (§4.3 — from surjections.json)
    if ($script:MathAliasRx) {
        $s = $script:MathAliasRx.Replace($s, { param($m) $script:MathAliasMap[$m.Value] })
    }

    # 4. Cleanups Pass (from hygiene.json)
    if ($store -and $store.cleanups) {
        foreach ($c in $store.cleanups) {
            if ($c.PSObject.Properties['scope'] -and $c.scope -eq 'inline' -and -not $Inline) { continue }
            if ($c.loop) {
                do { $prev = $s; $s = [regex]::Replace($s, $c.pattern, $c.replacement) } while ($s -ne $prev)
            } else {
                $s = [regex]::Replace($s, $c.pattern, $c.replacement)
            }
        }
    } else {
        do { $prev = $s; $s = [regex]::Replace($s, '\{\s*\{([^{}]*)\}\s*\}', '{$1}') } while ($s -ne $prev)
        $s = $s -replace '[ \t]{2,}', ' '
    }

    # 5. Unicode Glyph -> Control Sequence Pass (§5 — from lexicon.json)
    if ($script:MathLatexRx -and $s -match '[^\x00-\x7F]') {
        $src = $s
        $s = $script:MathLatexRx.Replace($src, {
            param($m)
            $v = $null
            if (-not $script:MathLatex.TryGetValue($m.Value, [ref]$v)) { return $m.Value }
            $j = $m.Index + $m.Length
            # the separator exists to terminate a CONTROL WORD before a following letter (\mux vs
            # \mu x); a replacement ending in a bare letter never needs it — juxtaposed letters are
            # separate math tokens.
            if ($v -match '\\[A-Za-z]+$' -and $j -lt $src.Length -and [char]::IsLetter($src[$j])) { return $v + ' ' }
            return $v
        })
    }

    # Restore masked prose bodies
    for ($i = $masks.Count - 1; $i -ge 0; $i--) { $s = $s.Replace("REGMASK${i}END", $masks[$i]) }
    return $s
}
