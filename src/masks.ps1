#requires -Version 7.0
<#
  src/masks.ps1 — the closed mask-algebra primitive set (precision by construction).

  A detector earns precision the way the rest of the membrane earns its guarantees: by
  construction, not by supervision. Instead of writing the precise pattern (a brittle strip-list
  that loses a whack-a-mole game), write a COARSE overlay (high recall, easy to keep stable) and
  SUBTRACT to isolate the target. Exactness lives in the set operation, not the regex.

  A `Mask` is a NORMALIZED SPAN SET over a string: a sorted, disjoint, half-open [start,end) list of
  UTF-16 offsets, plus the length of the string it is taken over. One representation, one enforced
  invariant — every op returns normal form (construction merges overlaps/adjacency, drops zero-length).

  The closed operation set (brief's algebra name -> the function here), and nothing beyond it:

    | brief    | function          | signature                          |
    |----------|-------------------|------------------------------------|
    | New-Mask | New-Mask          | (text, regex) -> Mask  (the overlay: coarse match -> spans)
    | Complement | Complement-Mask | (Mask[, len]) -> Mask  (everything not covered)
    | Sub      | Sub-Mask          | (Mask a, Mask b) -> Mask  (a \ b)
    | Intersect| Intersect-Mask    | (Mask a, Mask b) -> Mask
    | Union    | Union-Mask        | (Mask a, Mask b) -> Mask
    | Density  | Get-MaskDensity   | (text, within-Mask, register) -> count|spans  (the doccer density)
    | At-Level | Split-AtLevel     | (text, SpanLevel) -> unit list  (the level lens)

  SpanLevel — every detector DECLARES the level it runs at; mixing levels is a bug (doccer #3):
    * Character — UTF-16 offsets into the string (delimiter balance).
    * Line      — newline split within a chunk (alignment pairing, token-shatter density).
    * MultiLine — a chunk / id-range (formula or block extent).

  Discipline (what keeps the algebra from becoming the engine we refuse to build):
    * PURE + TOTAL. Every op is (string|Mask) -> (Mask|number) with no I/O, no state, no side effects;
      defined on empty / full / partial / boundary input; never throws on valid input (propose_edit
      re-grades mid-repair, so an unbalanced intermediate is normal input). Zero-length spans
      normalize away.
    * CODEPOINT SAFE. Offsets are UTF-16 code units (consistent with Get-LatexBalance). A span edge
      lands BETWEEN codepoints, never inside one — SMP math (E/S blackboard bold) is two code units;
      construction snaps any edge that would split a surrogate pair outward to the codepoint boundary.
      Masks do no I/O; the explicit UTF-8-no-BOM backbone lives at the call sites that read content.
    * BOUNDED. Inputs are KB chunks / small id-ranges -> O(n) passes, a mask is a handful of spans.
      No quadratic span growth. Lightweight interval ops, not a sweep engine.

  Non-goals (the fence — escalate, do not build): no SoA columns / DocPlane / bit-planes, no 64KB LUT,
  no hex addressing, no BPE, no general rule-table runner, no persisted mask sidecars (ids are line
  indices that split/merge renumber — masks are computed lazily, in memory, like the hotspot overlay).

  Pure, no I/O — dot-source and call. latex.ps1 / fidelity.ps1 / normalize.ps1 CONSUME this; logic
  does not scatter. This is to spans what latex.ps1 is to math predicates.
#>

# ── codepoint safety: never split a surrogate pair at a boundary ───────────────
# A boundary i splits a pair iff text[i] is a low surrogate and text[i-1] is its high surrogate.
# A start snaps back (include the high half); an end snaps forward (include the low half) — either
# way the full codepoint stays whole. BMP-only patterns never trigger these; the snap is the
# standing-invariant insurance so a future overlay can't quietly halve an SMP glyph.
function Move-OffsetToCodepointStart([string]$Text, [int]$i) {
    if ($i -gt 0 -and $i -lt $Text.Length -and [char]::IsLowSurrogate($Text[$i]) -and [char]::IsHighSurrogate($Text[$i - 1])) { return $i - 1 }
    return $i
}
function Move-OffsetToCodepointEnd([string]$Text, [int]$i) {
    if ($i -gt 0 -and $i -lt $Text.Length -and [char]::IsLowSurrogate($Text[$i]) -and [char]::IsHighSurrogate($Text[$i - 1])) { return $i + 1 }
    return $i
}

# ── the one enforced normal form ───────────────────────────────────────────────
# Clamp to [0,len], tolerate reversed pairs, drop zero/negative-length, surrogate-snap edges (when
# the text is in hand), sort, then merge overlapping AND adjacent spans ([0,3)+[3,5) = [0,5), since
# half-open adjacency is contiguous coverage). Every constructor and op funnels through here, so a
# Mask is ALWAYS sorted, disjoint, half-open — no ad-hoc span shape exists anywhere else.
function Get-NormalizedSpans {
    param([object[]]$Spans, [int]$Length, [AllowEmptyString()][string]$Text)
    $clean = [System.Collections.Generic.List[object]]::new()
    if ($Spans) {
        foreach ($sp in $Spans) {
            $s = [int]$sp.Start; $e = [int]$sp.End
            if ($s -gt $e) { $t = $s; $s = $e; $e = $t }      # tolerate reversed
            if ($s -lt 0) { $s = 0 }
            if ($e -gt $Length) { $e = $Length }
            if ($e -le $s) { continue }                        # zero/negative length normalizes away
            if ($Text) { $s = Move-OffsetToCodepointStart $Text $s; $e = Move-OffsetToCodepointEnd $Text $e }
            $clean.Add([pscustomobject]@{ Start = $s; End = $e })
        }
    }
    if ($clean.Count -le 1) { return , $clean.ToArray() }
    $sorted = $clean | Sort-Object Start, End
    $merged = [System.Collections.Generic.List[object]]::new()
    $cur = $null
    foreach ($sp in $sorted) {
        if ($null -eq $cur) { $cur = [pscustomobject]@{ Start = $sp.Start; End = $sp.End }; continue }
        if ($sp.Start -le $cur.End) { if ($sp.End -gt $cur.End) { $cur.End = $sp.End } }   # overlap/adjacent -> extend
        else { $merged.Add($cur); $cur = [pscustomobject]@{ Start = $sp.Start; End = $sp.End } }
    }
    if ($cur) { $merged.Add($cur) }
    return , $merged.ToArray()
}

# ── New-Mask — the overlay constructor ─────────────────────────────────────────
# Pattern set: a coarse regex over the text -> one span per (non-empty) match. Spans set: raw
# [start,end) pairs (used by the set ops to re-enter normal form). Either way the result is normalized.
function New-Mask {
    [CmdletBinding(DefaultParameterSetName = 'Pattern')]
    param(
        [Parameter(ParameterSetName = 'Pattern', Position = 0)][AllowEmptyString()][string]$Text = '',
        [Parameter(ParameterSetName = 'Pattern', Position = 1)][object]$Pattern,
        [Parameter(ParameterSetName = 'Spans', Mandatory)][AllowEmptyCollection()][AllowNull()][object[]]$Spans,
        [Parameter(ParameterSetName = 'Spans')][AllowEmptyString()][string]$Over,
        [Parameter(ParameterSetName = 'Spans')][int]$Length = -1
    )
    if ($PSCmdlet.ParameterSetName -eq 'Spans') {
        $len = if ($Length -ge 0) { $Length } elseif ($Over) { $Over.Length } else { 0 }
        return [pscustomobject]@{ PSTypeName = 'CodexMask'; Spans = (Get-NormalizedSpans -Spans $Spans -Length $len -Text $Over); Length = $len }
    }
    $len = $Text.Length
    $list = [System.Collections.Generic.List[object]]::new()
    if ($Pattern) {
        $rx = if ($Pattern -is [regex]) { $Pattern } else { [regex]$Pattern }
        foreach ($m in $rx.Matches($Text)) { if ($m.Length -gt 0) { $list.Add([pscustomobject]@{ Start = $m.Index; End = $m.Index + $m.Length }) } }
    }
    return [pscustomobject]@{ PSTypeName = 'CodexMask'; Spans = (Get-NormalizedSpans -Spans $list.ToArray() -Length $len -Text $Text); Length = $len }
}

# ── Complement — everything not covered, within [0,len) ────────────────────────
# Gap-walk over the (sorted, disjoint) spans. Defaults to the mask's own length; pass an explicit
# length to complement within a different universe (the brief's `Complement mask len`).
function Complement-Mask {
    param([Parameter(Mandatory)]$Mask, [int]$Length = -1)
    $len = if ($Length -ge 0) { $Length } else { [int]$Mask.Length }
    $out = [System.Collections.Generic.List[object]]::new()
    $cursor = 0
    foreach ($sp in $Mask.Spans) {
        $s = [Math]::Min([int]$sp.Start, $len); $e = [Math]::Min([int]$sp.End, $len)
        if ($s -gt $cursor) { $out.Add([pscustomobject]@{ Start = $cursor; End = $s }) }
        if ($e -gt $cursor) { $cursor = $e }
    }
    if ($cursor -lt $len) { $out.Add([pscustomobject]@{ Start = $cursor; End = $len }) }
    return New-Mask -Spans $out.ToArray() -Length $len
}

# ── Intersect / Union / Sub — set algebra, output re-normalized ────────────────
# Intersect: classic two-pointer over sorted spans, emit each overlap.
function Intersect-Mask {
    param([Parameter(Mandatory)]$A, [Parameter(Mandatory)]$B)
    $len = [Math]::Max([int]$A.Length, [int]$B.Length)
    $as = @($A.Spans); $bs = @($B.Spans)
    $out = [System.Collections.Generic.List[object]]::new()
    $i = 0; $j = 0
    while ($i -lt $as.Count -and $j -lt $bs.Count) {
        $s = [Math]::Max([int]$as[$i].Start, [int]$bs[$j].Start)
        $e = [Math]::Min([int]$as[$i].End, [int]$bs[$j].End)
        if ($s -lt $e) { $out.Add([pscustomobject]@{ Start = $s; End = $e }) }
        if ([int]$as[$i].End -lt [int]$bs[$j].End) { $i++ } else { $j++ }
    }
    return New-Mask -Spans $out.ToArray() -Length $len
}

# Union: concatenate spans and let the normalizer sort + merge.
function Union-Mask {
    param([Parameter(Mandatory)]$A, [Parameter(Mandatory)]$B)
    $len = [Math]::Max([int]$A.Length, [int]$B.Length)
    return New-Mask -Spans (@($A.Spans) + @($B.Spans)) -Length $len
}

# Sub (a \ b) = a ∩ ¬b. Stays in a's universe (the result length is a's length).
function Sub-Mask {
    param([Parameter(Mandatory)]$A, [Parameter(Mandatory)]$B)
    $len = [Math]::Max([int]$A.Length, [int]$B.Length)
    $r = Intersect-Mask $A (Complement-Mask $B $len)
    return New-Mask -Spans $r.Spans -Length ([int]$A.Length)
}

# ── small total predicates over masks (pure) ──────────────────────────────────
function Test-MaskEmpty { param([Parameter(Mandatory)]$Mask) return (@($Mask.Spans).Count -eq 0) }
function Get-MaskCoverage {
    param([Parameter(Mandatory)]$Mask)
    $n = 0; foreach ($sp in $Mask.Spans) { $n += ([int]$sp.End - [int]$sp.Start) }; return $n
}
function Test-MaskEqual {
    param([Parameter(Mandatory)]$A, [Parameter(Mandatory)]$B)
    $as = @($A.Spans); $bs = @($B.Spans)
    if ($as.Count -ne $bs.Count) { return $false }
    for ($i = 0; $i -lt $as.Count; $i++) { if ([int]$as[$i].Start -ne [int]$bs[$i].Start -or [int]$as[$i].End -ne [int]$bs[$i].End) { return $false } }
    return $true
}

# ── apply a mask to text — the register-extraction bridge (pure) ───────────────
# Blank the masked region to spaces (so a later match can't fuse across a region boundary), leaving
# the COMPLEMENT in place; -Keep inverts (keep the masked region, blank the rest). Length is
# preserved, so offsets still line up. Because masks are surrogate-safe, a boundary never blanks half
# a codepoint. This is the doccer "apply the mask" step the Density count and the gibberish residual
# are both built on.
function Get-MaskedText {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Text, [Parameter(Mandatory)]$Mask, [switch]$Keep)
    $chars = $Text.ToCharArray()
    $cov = New-Object 'bool[]' $Text.Length
    foreach ($sp in $Mask.Spans) {
        $e = [Math]::Min([int]$sp.End, $Text.Length)
        for ($i = [int]$sp.Start; $i -lt $e; $i++) { if ($i -ge 0) { $cov[$i] = $true } }
    }
    for ($i = 0; $i -lt $chars.Length; $i++) { if ($(if ($Keep) { -not $cov[$i] } else { $cov[$i] })) { $chars[$i] = ' ' } }
    return -join $chars
}

# ── Density — the doccer rolling count of a register WITHIN a mask region ──────
# Keep only the `Within` region (blank the rest), then count (or return spans of) the register
# pattern in what remains.
function Get-MaskDensity {
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Text,
        [Parameter(Mandatory)]$Within,
        [Parameter(Mandatory)][object]$Register,
        [switch]$AsSpans
    )
    $rx = if ($Register -is [regex]) { $Register } else { [regex]$Register }
    $kept = Get-MaskedText -Text $Text -Mask $Within -Keep
    if ($AsSpans) {
        $list = [System.Collections.Generic.List[object]]::new()
        foreach ($m in $rx.Matches($kept)) { if ($m.Length -gt 0) { $list.Add([pscustomobject]@{ Start = $m.Index; End = $m.Index + $m.Length }) } }
        return New-Mask -Spans $list.ToArray() -Over $Text
    }
    return $rx.Matches($kept).Count
}

# ── At-Level — the level lens (interpretation over the strings already held) ───
# Returns the units at the requested level, each carrying its [Start,End) offsets into the ORIGINAL
# string so a level-local mask can be lifted back (Move-Mask) and recomposed. Character/MultiLine
# are one whole-string unit (Character = balance over the full offset space; MultiLine = the chunk);
# Line splits on newline, the \n excluded from each unit.
function Split-AtLevel {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Text, [Parameter(Mandatory)][ValidateSet('Character', 'Line', 'MultiLine')][string]$Level)
    if ($Level -eq 'Line') {
        $out = [System.Collections.Generic.List[object]]::new()
        $start = 0
        for ($i = 0; $i -lt $Text.Length; $i++) {
            if ($Text[$i] -eq "`n") { $out.Add([pscustomobject]@{ Start = $start; End = $i; Text = $Text.Substring($start, $i - $start) }); $start = $i + 1 }
        }
        $out.Add([pscustomobject]@{ Start = $start; End = $Text.Length; Text = $Text.Substring($start) })
        return , $out.ToArray()
    }
    return , @([pscustomobject]@{ Start = 0; End = $Text.Length; Text = $Text })
}

# ── offset arithmetic — change-of-basis for masks (the pincer substrate) ───────
# Move-Mask shifts spans into a universe of a given length; Limit-Mask restricts a mask to [Start,End)
# and rebases it to [0,End-Start). Together they lift a level-local mask back to the parent offset
# space — the bottom-up half of the pincer (Character atoms -> Line spans -> MultiLine extent). The
# coincidence test (top-down derivation == bottom-up derivation) is exercised in the validation suite;
# the dispatch-ranking / impossibility-gate POLICY readouts are deferred (membrane-upgrade-plan).
function Move-Mask {
    param([Parameter(Mandatory)]$Mask, [Parameter(Mandatory)][int]$By, [Parameter(Mandatory)][int]$Length)
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($sp in $Mask.Spans) { $out.Add([pscustomobject]@{ Start = [int]$sp.Start + $By; End = [int]$sp.End + $By }) }
    return New-Mask -Spans $out.ToArray() -Length $Length
}
function Limit-Mask {
    param([Parameter(Mandatory)]$Mask, [Parameter(Mandatory)][int]$Start, [Parameter(Mandatory)][int]$End)
    $region = New-Mask -Spans @([pscustomobject]@{ Start = $Start; End = $End }) -Length ([int]$Mask.Length)
    return Move-Mask (Intersect-Mask $Mask $region) (-$Start) ($End - $Start)
}
