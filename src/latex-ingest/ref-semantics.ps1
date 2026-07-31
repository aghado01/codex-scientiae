#requires -Version 7.0
<#
  src/latex-ingest/ref-semantics.ps1 — the reference-resolution stage.

  Extracted from latex-ingest.ps1: cross-reference handling is a STAGE in the assembly architecture,
  not a special case buried mid-file. It owns the whole \ref family — the relevance probe, the label
  ->{number,type} view over the numbering stages' maps, and the per-macro rendering contracts.

  Depends on the caller having already built \\\ (thm/eq/fig/tab/sec/custom + types) via
  Convert-CrossRefEnvs + Build-LabelMaps, and passes through \\\ for \cite resolution.
#>
# --- reference semantics: ONE stage, one contract table ----------------------------------------------
# The ref family is NOT interchangeable, and lumping it into a single regex can only ever emit the lowest
# common denominator — which is why every \cref site used to lose its type name and read "immediate from
# 2.9" where the paper reads "immediate from lemma 2.9". The contracts actually differ:
#
#   \ref        number only                    \cref        lowercase type + number  ("lemma 2.9")
#   \labelcref  number only — cleveref's       \Cref        capitalized              ("Lemma 2.9")
#               DELIBERATE bare form           \autoref     capitalized (hyperref's own name table)
#   \pageref    a page markdown does not       \vref \Vref  cleveref + page hint -> as \cref/\Cref
#   \cpageref   have -> degrade to the target  \crefrange   "theorems 2.1 to 2.5"
#   \eqref      (number)                       \nameref     the target's TITLE (see limitation below)
#
# cleveref derives the type name from the TARGET's environment, never from the reference site, so the
# label->type map recorded by the numbering walk is the whole of the evidence this stage needs.
#
# LIMITATION: \nameref renders the target's title text, which the numbering walk does not capture (it
# would need brace-matched section titles). It degrades to the \Cref form rather than emitting nothing.

$script:RefUtf8 = [System.Text.UTF8Encoding]::new($false)
$script:RefMacroStoreCache = $null

<#
  The per-macro contracts are CUES, not logic: which macros a source reaches for varies with its package
  set, and the family grows (cleveref, hyperref, varioref each add their own). They live in
  stores/ref-macros.json — same rules-as-data discipline as the math stores — so supporting a new macro
  is a data edit. A missing or malformed store THROWS: defaulting would silently render every typed
  reference bare, which is precisely the failure this stage exists to fix.

  Alternation is built longest-name-first: .NET regex is leftmost-first, so an unsorted list would let
  \cref match inside \crefrange and leave a stray "range" in the prose.
#>
function Get-RefMacroStore {
    if ($null -ne $script:RefMacroStoreCache) { return $script:RefMacroStoreCache }
    $storePath = Join-Path $PSScriptRoot 'stores/ref-macros.json'
    if (-not (Test-Path -LiteralPath $storePath -PathType Leaf)) { throw "ref-macro store not found: $storePath" }
    $records = [System.IO.File]::ReadAllText($storePath, $script:RefUtf8) | ConvertFrom-Json

    # ORDINAL, not a plain @{}: PowerShell hashtables are case-INSENSITIVE, so \cref and \Cref (and
    # \vref/\Vref, \crefrange/\Crefrange) collide onto one key — one record silently overwrites the other
    # and the survivor's casing is the only name that reaches the alternation, leaving \Cref unmatched.
    $byMacro = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::Ordinal)
    foreach ($r in $records) {
        foreach ($f in 'macro', 'style', 'arity') {
            if ([string]::IsNullOrWhiteSpace($r.$f)) { throw "ref-macro store: record '$($r.id)' is missing '$f' ($storePath)" }
        }
        if ($r.style -notin 'lower', 'upper', 'bare') { throw "ref-macro store: record '$($r.id)' has unknown style '$($r.style)' ($storePath)" }
        if ($r.arity -notin 'single', 'range', 'upstream') { throw "ref-macro store: record '$($r.id)' has unknown arity '$($r.arity)' ($storePath)" }
        $byMacro[[string]$r.macro] = $r
    }
    $names = @($byMacro.Keys | Sort-Object -Property @{ Expression = { $_.Length }; Descending = $true }, @{ Expression = { $_ } })
    $single = @($names | Where-Object { $byMacro[$_].arity -eq 'single' })
    $range = @($names | Where-Object { $byMacro[$_].arity -eq 'range' })

    $script:RefMacroStoreCache = [pscustomobject]@{
        by_macro     = $byMacro
        all_names    = $names
        single_names = $single
        range_names  = $range
        typed_names  = @($names | Where-Object { [bool]$byMacro[$_].typed })
    }
    return $script:RefMacroStoreCache
}

# Upfront relevance probe: a paper that never loads cleveref and never uses a typed ref macro must not
# have type names invented for it. Also reports per-macro usage so a lane can see what a source exercises.
function Get-RefSemantics {
    param([string]$Tex)
    $store = Get-RefMacroStore
    $usage = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
    $rx = '(?<![A-Za-z@])\\(' + ($store.all_names -join '|') + ')\s*\{'
    foreach ($m in [regex]::Matches($Tex, $rx)) {
        $k = $m.Groups[1].Value
        if ($usage.ContainsKey($k)) { $usage[$k]++ } else { $usage[$k] = 1 }
    }
    $loaded = [regex]::IsMatch($Tex, '\\usepackage(?:\[[^\]]*\])?\s*\{[^{}]*\bcleveref\b[^{}]*\}')
    $typed = 0
    foreach ($k in $store.typed_names) { if ($usage.ContainsKey($k)) { $typed += $usage[$k] } }
    return @{ cleveref_loaded = $loaded; usage = $usage; typed_sites = $typed; relevant = ($loaded -or $typed -gt 0) }
}

function Get-RefPlural([string]$Word) {
    if ([string]::IsNullOrEmpty($Word)) { return $Word }
    if ($Word -match '(?i)[^aeiou]y$') { return $Word.Substring(0, $Word.Length - 1) + 'ies' }   # corollary -> corollaries
    if ($Word -match '(?i)(s|x|z|ch|sh)$') { return $Word + 'es' }
    return $Word + 's'
}

function Join-RefList($Items) {
    $a = @($Items)
    if ($a.Count -eq 0) { return '' }
    if ($a.Count -eq 1) { return [string]$a[0] }
    if ($a.Count -eq 2) { return "$($a[0]) and $($a[1])" }
    return (($a[0..($a.Count - 2)]) -join ', ') + ' and ' + $a[-1]
}

# label -> { num; type } over every map the numbering stages produced. $Maps.types carries the display
# type recorded by the theorem/section walk; equation/figure/table types are implied by which map hits.
function Get-RefTarget($Maps, [string]$Key) {
    if ($Maps.thm -and $Maps.thm.ContainsKey($Key)) {
        $ty = if ($Maps.types -and $Maps.types.ContainsKey($Key)) { [string]$Maps.types[$Key] } else { '' }
        return @{ num = "$($Maps.thm[$Key])"; type = $ty }
    }
    if ($Maps.eq  -and $Maps.eq.ContainsKey($Key))  { return @{ num = "$($Maps.eq[$Key])";  type = 'Equation' } }
    if ($Maps.fig -and $Maps.fig.ContainsKey($Key)) { return @{ num = "$($Maps.fig[$Key])"; type = 'Figure' } }
    if ($Maps.tab -and $Maps.tab.ContainsKey($Key)) { return @{ num = "$($Maps.tab[$Key])"; type = 'Table' } }
    if ($Maps.sec -and $Maps.sec.ContainsKey($Key)) {
        $ty = if ($Maps.types -and $Maps.types.ContainsKey($Key)) { [string]$Maps.types[$Key] } else { 'Section' }
        return @{ num = "$($Maps.sec[$Key])"; type = $ty }
    }
    if ($Maps.custom -and $Maps.custom.ContainsKey($Key)) { return @{ num = "$($Maps.custom[$Key])"; type = '' } }
    return $null
}

# Render one reference site per its macro's contract. $Style: 'bare' | 'lower' | 'upper'.
# Runs of same-typed targets collapse to one plural type word ("theorems 2.1 and 2.18"), while a mixed
# \cref{thm:a,fig:b} still reads "theorem 2.1 and figure 3" — both are cleveref's own behaviour.
function Format-RefPhrase($Maps, [string[]]$Keys, [string]$Style) {
    $items = [System.Collections.Generic.List[object]]::new()
    foreach ($k in $Keys) {
        $t = Get-RefTarget $Maps $k
        if ($null -eq $t) { $items.Add(@{ num = '?'; type = '' }) } else { $items.Add($t) }
    }
    if ($Style -eq 'bare') {
        $nums = [System.Collections.Generic.List[string]]::new()
        foreach ($it in $items) { $nums.Add([string]$it.num) }
        return (Join-RefList $nums)
    }
    $parts = [System.Collections.Generic.List[string]]::new()
    $i = 0
    while ($i -lt $items.Count) {
        $type = [string]$items[$i].type
        $run = [System.Collections.Generic.List[string]]::new()
        while ($i -lt $items.Count -and [string]$items[$i].type -eq $type) { $run.Add([string]$items[$i].num); $i++ }
        $word = $type
        if ($word -and $run.Count -gt 1) { $word = Get-RefPlural $word }
        if ($word) {
            if ($Style -eq 'lower') { $word = $word.ToLowerInvariant() }
            $parts.Add("$word $(Join-RefList $run)")
        }
        else { $parts.Add((Join-RefList $run)) }
    }
    return (Join-RefList $parts)
}

function Resolve-Refs {
    param([string]$T, $Maps, $CiteMap, $Semantics)
    # consume natbib optional pre/post-notes (\citep[see][p. 7]{key}) — else the [..] brackets leak and read as broken reference links
    $T = [regex]::Replace($T, '\\cite[a-z]*(?:\[[^\]]*\])?(?:\[[^\]]*\])?\s*\{([^{}]+)\}', { param($m) '[' + (($m.Groups[1].Value -split '\s*,\s*' | ForEach-Object { if ($CiteMap.ContainsKey($_)) { $CiteMap[$_] } else { '?' } }) -join ', ') + ']' })
    $T = [regex]::Replace($T, '(?<![A-Za-z@])\\eqref\s*\{([^{}]+)\}', { param($m) $k = $m.Groups[1].Value; if ($Maps.eq.ContainsKey($k)) { "($($Maps.eq[$k]))" } else { '(?)' } })

    $store = Get-RefMacroStore
    $typedRelevant = ($null -eq $Semantics) -or [bool]$Semantics.relevant

    if ($typedRelevant -and $store.range_names.Count -gt 0) {
        # a SPAN of two labels, not a list: "theorems 2.1 to 2.5"
        $rangeRx = '(?<![A-Za-z@])\\(' + ($store.range_names -join '|') + ')\s*\{([^{}]+)\}\s*\{([^{}]+)\}'
        $T = [regex]::Replace($T, $rangeRx, {
                param($m)
                $style = [string]$store.by_macro[$m.Groups[1].Value].style
                $a = Get-RefTarget $Maps $m.Groups[2].Value.Trim()
                $b = Get-RefTarget $Maps $m.Groups[3].Value.Trim()
                $numA = if ($a) { $a.num } else { '?' }
                $numB = if ($b) { $b.num } else { '?' }
                $word = if ($a -and $a.type) { Get-RefPlural $a.type } else { '' }
                if ($word -and $style -eq 'lower') { $word = $word.ToLowerInvariant() }
                if ($word) { "$word $numA to $numB" } else { "$numA to $numB" }
            })
    }

    # the single-argument family, each rendered by its own contract from the store
    $singleRx = '(?<![A-Za-z@])\\(' + ($store.single_names -join '|') + ')\s*\{([^{}]+)\}'
    $T = [regex]::Replace($T, $singleRx, {
            param($m)
            $keys = @($m.Groups[2].Value -split '\s*,\s*' | Where-Object { $_.Trim().Length -gt 0 } | ForEach-Object { $_.Trim() })
            $style = [string]$store.by_macro[$m.Groups[1].Value].style
            if (-not $typedRelevant) { $style = 'bare' }   # nothing typed in play: never invent a name
            $out = Format-RefPhrase $Maps $keys $style
            if ([string]::IsNullOrWhiteSpace($out)) { '?' } else { $out }
        })
    return $T
}
