#requires -Version 7.0

# ── codepoint safety: never split a surrogate pair at a boundary
function Move-OffsetToCodepointStart([string]$Text, [int]$i) {
    if ($i -gt 0 -and $i -lt $Text.Length -and [char]::IsLowSurrogate($Text[$i]) -and [char]::IsHighSurrogate($Text[$i - 1])) { return $i - 1 }
    return $i
}
function Move-OffsetToCodepointEnd([string]$Text, [int]$i) {
    if ($i -gt 0 -and $i -lt $Text.Length -and [char]::IsLowSurrogate($Text[$i]) -and [char]::IsHighSurrogate($Text[$i - 1])) { return $i + 1 }
    return $i
}

# ── the one enforced normal form
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

# ── apply a mask to text — the register-extraction bridge ───────────────

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
