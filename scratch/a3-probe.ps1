# a3-probe.ps1 — A3-0 four-layer caption-localization probe (chip brief issues/clustering/a3-0-probe-brief.md).
#
# PROBE + REPORT ONLY: inspects the newest pig runs; mutates nothing.
#
# Targets — the three non-oracle-noise PRIMARY unders (gauntlet/ph-zigzag):
#   2210.00916   Fig 1  oracle caption "General pipeline illustration."            (tikz diagram-1)
#   2210.00916   Fig 4  oracle caption "Pyramid for the case n=3, with ..."        (tikz diagram-7)
#   2302.12796v2 Fig 5  oracle caption "Parts of the sub-forests MF^{i+1}(F), MF^{i+1}(F'). Node level
#                        increases from left to right."                            (v-e-sw.png)
#   (2302 "Figure 1" is a \parpic \captionof{figure}{} with EMPTY text — outside the PRIMARY oracle.)
#
# Four layers, each searched INDEPENDENTLY, grounded by oracle caption content + PDF coords:
#   L1 letters.jsonl — per-page normalized glyph stream (ligatures expanded, whitespace/hyphens
#      stripped) searched ordinally for caption key phrases + the "Figure N" cue census.
#   L2 words.jsonl   — same search over the token stream; cross-mapped against L1 letter→word ids.
#   L3 blocks.jsonl  — the block(s) holding the matched glyphs: assembly, fragmentation, block-start
#      cue visibility (the EXACT Add-FigureCaptions test: cue regex over first 14 chars of text).
#   L4 nodes.jsonl + figures.jsonl — typed node for the caption block, then a faithful mirror of the
#      Add-FigureCaptions candidate scan (overlap >= 0.25 of narrower width; gap in [-2, 4.5em];
#      cue-in-14; kind==figure) between the caption block and every region on its page.
#
# Iteration record:
#   v1 2026-07-17 — initial census for the three floats.
#   v2 2026-07-18 — evidence deepened: cue-census rows now print the carrier block's bbox + full
#      text; L3 prints EVERY line of each caption block (exposes the 2302 superscript-pollution
#      lines) plus a same-row block scan (exposes the 2210 per-word fragmentation and the
#      would-be "Figure"+"N:" stitch). Verdicts unchanged from v1.

using namespace System.Text
using namespace System.Text.Json
using namespace System.Collections.Generic

$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$gauntlet = Join-Path $repo 'ingestion\gauntlet\ph-zigzag'
$cfgPath = Join-Path $repo 'src\pdf-converter\stores\classify-config.json'

$cfg = (Get-Content $cfgPath -Raw | ConvertFrom-Json).figure_regions
$maxGapEm = [double]$cfg.caption_max_gap_em
$minOvl = [double]$cfg.caption_min_overlap_frac
$cueRe = [regex]('(' + (($cfg.caption_cue_words | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')\.?\s*\d')

# --- normalization: expand ligatures, drop whitespace + hyphen family; ordinal everywhere ---
$ligMap = @{
    [char]0xFB00 = 'ff'; [char]0xFB01 = 'fi'; [char]0xFB02 = 'fl'
    [char]0xFB03 = 'ffi'; [char]0xFB04 = 'ffl'; [char]0xFB05 = 'ft'; [char]0xFB06 = 'st'
}
$dropChars = [HashSet[char]]::new()
foreach ($c in @([char]0x2D, [char]0x2010, [char]0x2011, [char]0x2212, [char]0xAD)) { [void]$dropChars.Add($c) }

function Add-Normalized([StringBuilder] $Sb, [List[int]] $Map, [string] $Text, [int] $SrcId) {
    foreach ($ch in $Text.ToCharArray()) {
        if ([char]::IsWhiteSpace($ch) -or $dropChars.Contains($ch)) { continue }
        if ($ligMap.ContainsKey($ch)) {
            foreach ($e in $ligMap[$ch].ToCharArray()) { [void]$Sb.Append($e); $Map.Add($SrcId) }
        } else {
            [void]$Sb.Append($ch); $Map.Add($SrcId)
        }
    }
}

function Get-NormalizedNeedle([string] $Text) {
    $sb = [StringBuilder]::new(); $map = [List[int]]::new()
    Add-Normalized $sb $map $Text -1
    return $sb.ToString()
}

# --- tiny JsonElement helpers (fields are optional across vintages) ---
function Get-JInt([JsonElement] $El, [string] $Name, [int] $Default = -1) {
    $v = [JsonElement]::new()
    if ($El.TryGetProperty($Name, [ref]$v) -and $v.ValueKind -eq [JsonValueKind]::Number) { return $v.GetInt32() }
    return $Default
}
function Get-JStr([JsonElement] $El, [string] $Name) {
    $v = [JsonElement]::new()
    if ($El.TryGetProperty($Name, [ref]$v) -and $v.ValueKind -eq [JsonValueKind]::String) { return $v.GetString() }
    return $null
}
function Get-JBox([JsonElement] $El, [string] $Name) {
    $v = [JsonElement]::new()
    if ($El.TryGetProperty($Name, [ref]$v) -and $v.ValueKind -eq [JsonValueKind]::Array -and $v.GetArrayLength() -eq 4) {
        $b = [double[]]::new(4)
        for ($i = 0; $i -lt 4; $i++) { $b[$i] = $v[$i].GetDouble() }
        return $b
    }
    return $null
}

# --- per-page normalized stream (glyph or token) with source-id map ---
class LaneStream {
    [hashtable] $Text = @{}     # page -> string
    [hashtable] $Map = @{}      # page -> List[int] (source id per normalized char)
}

function Read-LaneStream([string] $Path, [string] $IdField = 'id') {
    $ls = [LaneStream]::new()
    $sbs = @{}; $maps = @{}
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $doc = [JsonDocument]::Parse($line)
        try {
            $el = $doc.RootElement
            $page = Get-JInt $el 'page'
            $txt = Get-JStr $el 'text'
            if ($null -eq $txt -or $txt.Length -eq 0) { continue }
            if (-not $sbs.ContainsKey($page)) { $sbs[$page] = [StringBuilder]::new(); $maps[$page] = [List[int]]::new() }
            Add-Normalized $sbs[$page] $maps[$page] $txt (Get-JInt $el $IdField)
        } finally { $doc.Dispose() }
    }
    foreach ($p in $sbs.Keys) { $ls.Text[$p] = $sbs[$p].ToString(); $ls.Map[$p] = $maps[$p] }
    return $ls
}

# --- record loaders (only the fields the probe reports) ---
function Read-LetterIndex([string] $Path) {
    $idx = [Dictionary[int, object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $doc = [JsonDocument]::Parse($line)
        try {
            $el = $doc.RootElement
            $idx[(Get-JInt $el 'id')] = [pscustomobject]@{
                page = Get-JInt $el 'page'; text = Get-JStr $el 'text'; bx = Get-JBox $el 'bx'
                block = Get-JInt $el 'block'; line = Get-JInt $el 'line'; word = Get-JInt $el 'word'
                font = Get-JStr $el 'font'
            }
        } finally { $doc.Dispose() }
    }
    return $idx
}

function Read-WordIndex([string] $Path) {
    $idx = [Dictionary[int, object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $doc = [JsonDocument]::Parse($line)
        try {
            $el = $doc.RootElement
            $idx[(Get-JInt $el 'id')] = [pscustomobject]@{
                page = Get-JInt $el 'page'; text = Get-JStr $el 'text'; bx = Get-JBox $el 'bx'
                block = Get-JInt $el 'block'; line = Get-JInt $el 'line'
            }
        } finally { $doc.Dispose() }
    }
    return $idx
}

function Read-BlockIndex([string] $Path) {
    $idx = [Dictionary[int, object]]::new()
    foreach ($raw in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($raw)) { continue }
        $b = $raw | ConvertFrom-Json
        $idx[[int]$b.id] = $b
    }
    return $idx
}

function Read-Jsonl([string] $Path) {
    $list = [List[object]]::new()
    foreach ($raw in [System.IO.File]::ReadLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($raw)) { continue }
        $list.Add(($raw | ConvertFrom-Json))
    }
    return $list
}

function Get-UnionBox([List[object]] $Boxes) {
    $x0 = [double]::MaxValue; $y0 = [double]::MaxValue; $x1 = [double]::MinValue; $y1 = [double]::MinValue
    foreach ($b in $Boxes) {
        if ($null -eq $b) { continue }
        $xs = @([Math]::Min($b[0], $b[2]), [Math]::Max($b[0], $b[2]))
        $ys = @([Math]::Min($b[1], $b[3]), [Math]::Max($b[1], $b[3]))
        if ($xs[0] -lt $x0) { $x0 = $xs[0] }; if ($ys[0] -lt $y0) { $y0 = $ys[0] }
        if ($xs[1] -gt $x1) { $x1 = $xs[1] }; if ($ys[1] -gt $y1) { $y1 = $ys[1] }
    }
    return @([Math]::Round($x0, 2), [Math]::Round($y0, 2), [Math]::Round($x1, 2), [Math]::Round($y1, 2))
}

# find all occurrences of a normalized needle; returns per-match: page, source-id list
function Find-InStream([LaneStream] $Stream, [string] $Needle, [bool] $NextNotDigit = $false) {
    $hits = [List[object]]::new()
    foreach ($page in ($Stream.Text.Keys | Sort-Object)) {
        $hay = $Stream.Text[$page]; $map = $Stream.Map[$page]
        $from = 0
        while ($true) {
            $at = $hay.IndexOf($Needle, $from, [StringComparison]::Ordinal)
            if ($at -lt 0) { break }
            $from = $at + 1
            if ($NextNotDigit) {
                $nx = $at + $Needle.Length
                if ($nx -lt $hay.Length -and [char]::IsDigit($hay[$nx])) { continue }
            }
            $ids = [List[int]]::new()
            for ($i = $at; $i -lt $at + $Needle.Length; $i++) {
                $sid = $map[$i]
                if ($ids.Count -eq 0 -or $ids[$ids.Count - 1] -ne $sid) { $ids.Add($sid) }
            }
            $tail = $hay.Substring($at, [Math]::Min(40, $hay.Length - $at))
            $hits.Add([pscustomobject]@{ page = $page; ids = $ids; context = $tail })
        }
    }
    return $hits
}

# ============================== the walk ==============================

$targets = @(
    [pscustomobject]@{
        slug = '2210.00916'; run = '20260715_063739'; label = 'Figure 1'; num = 1
        phrases = @('General pipeline illustration')
    }
    [pscustomobject]@{
        slug = '2210.00916'; run = '20260715_063739'; label = 'Figure 4'; num = 4
        phrases = @('Pyramid for the case')
    }
    [pscustomobject]@{
        slug = '2302.12796v2'; run = '20260707_025336'; label = 'Figure 5'; num = 5
        phrases = @('Parts of the sub-forests', 'Node level increases from left to right')
    }
)

$laneCache = @{}
foreach ($t in $targets) {
    $key = $t.slug
    if (-not $laneCache.ContainsKey($key)) {
        $pig = Join-Path $gauntlet "$($t.slug)\.runs\$($t.run)\pig"
        Write-Host "loading lanes: $($t.slug) @ $($t.run) ..."
        $classify = Get-Content (Join-Path $pig "$($t.slug).classify.json") -Raw | ConvertFrom-Json
        $laneCache[$key] = [pscustomobject]@{
            pig = $pig
            bodyPt = [double]$classify.calibration.body_size
            lettersStream = Read-LaneStream (Join-Path $pig "$($t.slug).letters.jsonl")
            wordsStream = Read-LaneStream (Join-Path $pig "$($t.slug).words.jsonl")
            letters = Read-LetterIndex (Join-Path $pig "$($t.slug).letters.jsonl")
            words = Read-WordIndex (Join-Path $pig "$($t.slug).words.jsonl")
            blocks = Read-BlockIndex (Join-Path $pig "$($t.slug).blocks.jsonl")
            nodes = Read-Jsonl (Join-Path $pig "$($t.slug).nodes.jsonl")
            figures = Read-Jsonl (Join-Path $pig "$($t.slug).figures.jsonl")
        }
    }
}

foreach ($t in $targets) {
    $lane = $laneCache[$t.slug]
    $bp = $lane.bodyPt
    Write-Host ''
    Write-Host ('=' * 90)
    Write-Host ("TARGET  $($t.slug)  $($t.label)   (body_pt=$bp, run=$($t.run))")
    Write-Host ('=' * 90)

    # ---------- L1: glyph stream ----------
    $capLetterIds = $null; $capPage = -1
    foreach ($phrase in $t.phrases) {
        $needle = Get-NormalizedNeedle $phrase
        $hits = Find-InStream $lane.lettersStream $needle
        Write-Host "L1 letters  phrase '$phrase' -> $($hits.Count) match(es)"
        foreach ($h in $hits) {
            $boxes = [List[object]]::new()
            foreach ($id in $h.ids) { $boxes.Add($lane.letters[$id].bx) }   # List, not @(): a double[] flattens in @(foreach)
            $blocks = @($h.ids | ForEach-Object { $lane.letters[$_].block } | Sort-Object -Unique)
            $words = @($h.ids | ForEach-Object { $lane.letters[$_].word } | Sort-Object -Unique)
            $noWord = @($h.ids | Where-Object { $lane.letters[$_].word -lt 0 }).Count
            Write-Host ("    p$($h.page) letters $($h.ids[0])..$($h.ids[$h.ids.Count-1]) bbox=[$((Get-UnionBox $boxes) -join ',')] blocks=[$($blocks -join ',')] words $($words[0])..$($words[$words.Count-1]) unworded=$noWord")
            if ($null -eq $capLetterIds) { $capLetterIds = $h.ids; $capPage = $h.page }
        }
    }

    # cue census: every 'Figure N' occurrence (letters lane), block-start vs in-text
    $cueNeedle = "Figure$($t.num)"
    $cueHits = Find-InStream $lane.lettersStream $cueNeedle $true
    Write-Host "L1 cue census 'Figure $($t.num)' (next-char-not-digit) -> $($cueHits.Count) occurrence(s)"
    foreach ($h in $cueHits) {
        $bid = $lane.letters[$h.ids[0]].block
        $blk = if ($bid -ge 0 -and $lane.blocks.ContainsKey($bid)) { $lane.blocks[$bid] } else { $null }
        $btxt = if ($blk) { [string]$blk.text } else { '<no block>' }
        $head = $btxt.Substring(0, [Math]::Min(14, $btxt.Length))
        $cueOk = $cueRe.Match($head).Success
        $bbx = if ($blk) { "[$($blk.bx -join ',')]" } else { '-' }
        Write-Host ("    p$($h.page) letters@$($h.ids[0]) block=$bid bx=$bbx cue_in_14=$cueOk head='$head' blocktext='$($btxt.Substring(0, [Math]::Min(60, $btxt.Length)))' ctx='$($h.context)'")
    }

    # ---------- L2: token stream (independent search) ----------
    $capWordIds = $null
    foreach ($phrase in $t.phrases) {
        $needle = Get-NormalizedNeedle $phrase
        $hits = Find-InStream $lane.wordsStream $needle
        Write-Host "L2 words    phrase '$phrase' -> $($hits.Count) match(es)"
        foreach ($h in $hits) {
            $toks = @(foreach ($id in $h.ids) { $lane.words[$id].text })
            $blocks = @($h.ids | ForEach-Object { $lane.words[$_].block } | Sort-Object -Unique)
            Write-Host ("    p$($h.page) words $($h.ids[0])..$($h.ids[$h.ids.Count-1]) blocks=[$($blocks -join ',')] tokens='$($toks -join ' ')'")
            if ($null -eq $capWordIds) { $capWordIds = $h.ids }
        }
    }

    if ($null -eq $capLetterIds) {
        Write-Host 'VERDICT: layer 1 FAIL — caption glyphs absent from letters.jsonl (extraction failure).'
        continue
    }

    # ---------- L3: block assembly ----------
    $capBlockIds = @($capLetterIds | ForEach-Object { $lane.letters[$_].block } | Sort-Object -Unique)
    foreach ($bid in $capBlockIds) {
        if ($bid -lt 0 -or -not $lane.blocks.ContainsKey($bid)) {
            Write-Host "L3 blocks   letters map to block=$bid (NOT IN blocks.jsonl)"
            continue
        }
        $blk = $lane.blocks[$bid]
        $btxt = [string]$blk.text
        $head = $btxt.Substring(0, [Math]::Min(14, $btxt.Length))
        $cueOk = $cueRe.Match($head).Success
        $nLines = @($blk.lines).Count
        Write-Host ("L3 block $bid p$($blk.page) bx=[$($blk.bx -join ',')] reading_order=$($blk.reading_order) lines=$nLines textlen=$($btxt.Length)")
        Write-Host ("    cue_in_14=$cueOk head='$head'")
        $capLineIds = @($capLetterIds | ForEach-Object { $lane.letters[$_].line } | Sort-Object -Unique)
        foreach ($ln in @($blk.lines)) {
            $mark = if ($capLineIds -contains [int]$ln.id) { 'caption' } else { 'other  ' }
            $ltxt = [string]$ln.text
            Write-Host ("    $mark line $($ln.id) bx=[$($ln.bx -join ',')] modal_size=$($ln.modal_size) text='$($ltxt.Substring(0, [Math]::Min(100, $ltxt.Length)))'")
        }
    }

    # same-row scan: every block on the caption page whose vertical span overlaps the caption row —
    # documents per-word fragmentation and what a "Figure"+"N:" row-stitch would see.
    $rowBoxes = [List[object]]::new()
    foreach ($id in $capLetterIds) { $rowBoxes.Add($lane.letters[$id].bx) }
    $rowBox = Get-UnionBox $rowBoxes
    $rowBlocks = [List[object]]::new()
    foreach ($kv in $lane.blocks.GetEnumerator()) {
        $b = $kv.Value
        if ([int]$b.page -ne $capPage) { continue }
        $y0 = [Math]::Min([double]$b.bx[1], [double]$b.bx[3]); $y1 = [Math]::Max([double]$b.bx[1], [double]$b.bx[3])
        if ($y1 -ge $rowBox[1] -and $y0 -le $rowBox[3]) { $rowBlocks.Add($b) }
    }
    Write-Host "L3 same-row scan: $($rowBlocks.Count) block(s) overlap the caption row y=[$($rowBox[1]),$($rowBox[3])] on p$capPage"
    foreach ($b in ($rowBlocks | Sort-Object { [double]$_.bx[0] })) {
        $btxt = [string]$b.text
        Write-Host ("    b$($b.id) bx=[$($b.bx -join ',')] text='$($btxt.Substring(0, [Math]::Min(40, $btxt.Length)))'")
    }

    # ---------- L4: typed nodes + the mirrored attachment scan ----------
    foreach ($bid in $capBlockIds) {
        $bNodes = @($lane.nodes | Where-Object { [int]$_.block -eq $bid -and [int]$_.page -eq $capPage })
        foreach ($n in $bNodes) {
            $c = [string]$n.content
            Write-Host ("L4 node $($n.id) type=$($n.type) role=$($n.role) content='$($c.Substring(0, [Math]::Min(70, $c.Length)))'")
        }
    }

    $primaryBid = $capBlockIds[0]
    $blk = $lane.blocks[$primaryBid]
    $bl = [double]$blk.bx[0]; $bb = [double]$blk.bx[1]; $br = [double]$blk.bx[2]; $bt = [double]$blk.bx[3]
    $btxt = [string]$blk.text
    $head = $btxt.Substring(0, [Math]::Min(14, $btxt.Length))
    $cueOk = $cueRe.Match($head).Success
    $maxGap = $maxGapEm * $bp
    $pageRegions = @($lane.figures | Where-Object { [int]$_.page -eq $capPage })
    Write-Host "L4 attachment mirror: caption block $primaryBid p$capPage bx=[$($blk.bx -join ',')] vs $($pageRegions.Count) region(s) on page (maxGap=$([Math]::Round($maxGap,1))pt, minOvl=$minOvl, cue_in_14=$cueOk)"
    if ($pageRegions.Count -eq 0) { Write-Host '    NO REGIONS on the caption page.' }
    foreach ($f in $pageRegions) {
        $figL = [double]$f.bbox[0]; $figB = [double]$f.bbox[1]; $figR = [double]$f.bbox[2]; $figT = [double]$f.bbox[3]
        $figW = $figR - $figL
        $ovl = [Math]::Min($figR, $br) - [Math]::Max($figL, $bl)
        $den = [Math]::Min($figW, $br - $bl)
        $frac = if ($den -gt 0) { [Math]::Round($ovl / $den, 3) } else { -1 }
        $gapBelow = [Math]::Round($figB - $bt, 1)
        $gapAbove = [Math]::Round($bb - $figT, 1)
        $ovlPass = ($den -gt 0 -and ($ovl / $den) -ge $minOvl)
        $belowPass = ($gapBelow -ge -2 -and $gapBelow -le $maxGap)
        $abovePass = ($gapAbove -ge -2 -and $gapAbove -le $maxGap)
        $kindPass = ([string]$f.kind -eq 'figure')
        $verdict = if ($ovlPass -and ($belowPass -or $abovePass) -and $kindPass -and $cueOk) { 'WOULD-ATTACH' } else { 'no' }
        $why = @()
        if (-not $kindPass) { $why += "kind=$($f.kind)" }
        if (-not $ovlPass) { $why += "ovl=$frac" }
        if (-not ($belowPass -or $abovePass)) { $why += "gapB=$($gapBelow)pt/$([Math]::Round($gapBelow/$bp,1))em gapA=$($gapAbove)pt/$([Math]::Round($gapAbove/$bp,1))em" }
        if (-not $cueOk) { $why += 'cue-miss' }
        $capState = if ($f.caption) { "cap='$(([string]$f.caption.text).Substring(0, [Math]::Min(30, ([string]$f.caption.text).Length)))'" } else { 'uncaptioned' }
        Write-Host ("    region $($f.id) kind=$($f.kind) flag=$($f.flag) bbox=[$($f.bbox -join ',')] $capState -> $verdict $(if ($why.Count) { '(' + ($why -join '; ') + ')' })")
    }
}
Write-Host ''
Write-Host 'probe complete.'
