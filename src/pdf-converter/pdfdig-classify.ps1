#requires -Version 7.0
<#
  src/pdf-converter/pdfdig-classify.ps1 — the pdfdig CLASSIFIER: typed node stream from the lanes.

  Consumer of the generic IR substrate (pdfdig-ir.ps1). Where the substrate records measurements
  and claims, THIS stage forms opinions — every one calibrated from the document itself, sourced
  from the stores, and flagged when uncertain (flags, never guesses):

    Stage A  CALIBRATION  per-document order statistics over the lanes: body size, heading tier
             ladder, modal leading, paragraph indent. Quantized typography wants modes and gaps,
             not density clustering — HDBSCAN is reserved for the genuinely continuous problems
             (figure-region assembly v1.1, segmentation third-witness); see issues/pdfdig-lane/.
    Stage B  TYPED EMISSION  run-level nodes in resolved reading order, membrane-canonical fields
             (page / content / font / 'font size' / 'bounding box') + type/role/script/tier/flags.
             Symbol-map corrections + ligature expansion land HERE — the substrate stays faithful.

    . ./pdfdig-classify.ps1
    ConvertTo-PdfDigNodes -IrDir <dir with {slug}.* lanes> -Slug <slug> [-OutDir <dir>]

  Emits: {slug}.nodes.jsonl (+ .jidx/.sig)   the brief's IR contract, project-ir compatible
         {slug}.classify.json                calibration + cross-derivation + health envelope

  PS scope note: helper state (run accumulator, counters) lives in HASHTABLE MEMBERS, never bare
  closure variables — a scriptblock's variable assignments land in its own child scope and silently
  desynchronize; member mutation on a captured reference does not.
#>

. "$PSScriptRoot/pdfdig-ir.ps1"        # store loaders, Get-Modal, jsonl substrate
. "$PSScriptRoot/math-assembler.ps1"   # ConvertTo-NestedMath: recursive size-tier script nesting

# ── symbol-map store: font-aware glyph corrections (math) + ligature expansion (prose).
#    Substrate-faithful discipline: these fire at NODE emission only. ──────────────────────────────
$script:SymbolMap = $null
$script:SymbolMapByChar = $null
function Import-SymbolMap {
    [CmdletBinding()] param([string] $Path = (Join-Path $PSScriptRoot 'stores/symbol-map.jsonl'))
    $rows = foreach ($o in (Read-JsonlStore $Path @('char','unicode','scope'))) {
        [pscustomobject]@{ font_pattern=($o.PSObject.Properties['font_pattern'] ? $o.font_pattern : '*')
                           char=$o.char; unicode=$o.unicode; scope=$o.scope }
    }
    $script:SymbolMap = @($rows)
    $script:SymbolMapByChar = @{}
    foreach ($e in $script:SymbolMap) {
        if (-not $script:SymbolMapByChar.ContainsKey($e.char)) {
            $script:SymbolMapByChar[$e.char] = [System.Collections.Generic.List[object]]::new()
        }
        $script:SymbolMapByChar[$e.char].Add($e)
    }
    $script:SymbolMap.Count
}

function Resolve-Symbol([string] $font, [string] $ch, [string] $role) {
    # char-keyed index: the overwhelmingly common case (no entry for this char) is one dict miss
    $list = $script:SymbolMapByChar[$ch]
    if ($null -eq $list) { return $null }
    foreach ($e in $list) {
        if ($e.scope -ne '*' -and $e.scope -ne $role) { continue }
        if ($e.font_pattern -eq '*' -or $font.StartsWith($e.font_pattern, [StringComparison]::OrdinalIgnoreCase)) {
            return $e.unicode
        }
    }
    return $null
}

# outline cross-derivation: normalized contains-match sidesteps "II." vs "2" numbering dialects
function ConvertTo-NormalizedTitle([string] $s) {
    if (-not $s) { return '' }
    return (($s -replace '[^\p{L}\p{Nd}]', '')).ToLowerInvariant()
}

# outline KEY: strip a leading section number (Roman "III.", Arabic "3"/"3.2", letter "A.") BEFORE
# normalizing, so a numbered on-page heading matches its number-less bookmark title — otherwise the
# numeral prefix ("iii…") defeats the substring test and a wrapped section's first line goes
# unmatched (its wrap tail then orphans as a phantom heading — 2508.11646 §III/§V).
function ConvertTo-OutlineKey([string] $s) {
    if (-not $s) { return '' }
    $t = $s -replace '^\s*([IVXLCDM]+|\d+(\.\d+)*|[A-Za-z])[.)]\s+', ''
    return ConvertTo-NormalizedTitle $t
}

function Read-JsonlLane([string] $Path) {
    if (-not (Test-Path $Path)) { throw "lane not found: $Path (run ConvertTo-PdfDigIr first)" }
    # per-line -AsHashtable: measured fastest on the 84p bench (18.8s vs 23.7s PSCustomObject
    # vs 26.3s single batched parse — Newtonsoft's large-array conversion LOSES to per-line);
    # comma-wrapped return so the 126k-element result isn't streamed element-wise
    $out = [System.Collections.Generic.List[object]]::new(131072)
    foreach ($l in [System.IO.File]::ReadAllLines($Path)) {
        if (-not [string]::IsNullOrWhiteSpace($l)) {
            $out.Add((ConvertFrom-Json -InputObject $l -AsHashtable))
        }
    }
    return ,$out
}

# ── run assembly + node emission for one line. $Ctx carries all cross-line mutable state:
#    nid, formulaGroup, subs, ligs, nodes(List), typeCounts(hashtable), cfg, fontRole. ─────────────
function Emit-PdfDigLine {
    param($Ctx, $Letters, $LineId, $BlockId, $Col, [string]$LineType, $Tier, [string[]]$LineFlags, $St, $OutlineLevel, $OutlineRef)

    $cfg = $Ctx.cfg

    # DISPLAY MATH: assemble the whole line with recursive size-tier script NESTING (not the flat
    # per-glyph script call below, which emits the invalid t_{v}_{1} for nested t_{v_{i+1}}). One
    # math run carries the assembled LaTeX; the adapter joins group lines as $$...$$.
    if ($LineType -eq 'formula-block') {
        $ma = $cfg.math_assembler
        $symFn = $Ctx.mathSymbolFn
        $latex = ConvertTo-NestedMath -Letters $Letters -SizeRatio $ma.size_ratio -BaselineTolFrac $ma.baseline_tol_frac -SymbolFn $symFn
        $bx0=[double]::MaxValue; $by0=[double]::MaxValue; $bx1=[double]::MinValue; $by1=[double]::MinValue
        foreach ($lt in $Letters) {
            if ($lt.bx[0] -lt $bx0) { $bx0=$lt.bx[0] }; if ($lt.bx[1] -lt $by0) { $by0=$lt.bx[1] }
            if ($lt.bx[2] -gt $bx1) { $bx1=$lt.bx[2] }; if ($lt.bx[3] -gt $by1) { $by1=$lt.bx[3] }
        }
        $rec = [ordered]@{
            id = $Ctx.nid; type = $LineType; page = $St.page; line_id = $LineId; block = $BlockId; col = $Col
            baseline_y = [math]::Round($St.base, 2); content = $latex; font = ''; 'font size' = $St.size
            'bounding box' = @([math]::Round($bx0,2),[math]::Round($by0,2),[math]::Round($bx1,2),[math]::Round($by1,2))
            role = 'math'; script = 'normal'
        }
        $rec.formula_group = $Ctx.formulaGroup
        $fl = [System.Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
        foreach ($f in $LineFlags) { if ($f) { [void]$fl.Add($f) } }
        # balance check: unclosed delimiter in the assembled span is a dispatchable flag, not a guess
        if ((Measure-DelimiterBalance $latex) -ne 0) { [void]$fl.Add('unbalanced_delimiters') }
        $rec.flags = @($fl)
        $Ctx.nodes.Add($rec); $Ctx.nid++
        $Ctx.typeCounts[$LineType] = 1 + ($Ctx.typeCounts[$LineType] ?? 0)
        return
    }

    # key-array sort, not Sort-Object{} — no per-comparison scriptblock in the hot path.
    # [Array]::Sort is UNSTABLE: augment the key with the index tiebreak or overprint/combining
    # glyphs sharing an x-coordinate swap between runs and change run splits (determinism!)
    $n = $Letters.Count
    $sorted = [object[]]::new($n)
    $keys = [double[]]::new($n)
    for ($i = 0; $i -lt $n; $i++) { $sorted[$i] = $Letters[$i]; $keys[$i] = $Letters[$i].bx[0] * 1000000.0 + $i }
    [Array]::Sort($keys, $sorted)
    $spaceGap = $cfg.line_grouping.space_gap_fraction * $St.size
    $runs = [System.Collections.Generic.List[object]]::new()
    $cur = @{ sb=[System.Text.StringBuilder]::new(); role=''; script=''; font=''; size=0.0
              l=[double]::MaxValue; b=[double]::MaxValue; r=[double]::MinValue; t=[double]::MinValue
              flags=[System.Collections.Generic.HashSet[string]]::new() }

    $flush = {   # mutates $cur MEMBERS + $runs contents only (scope-safe)
        if ($cur.sb.Length -gt 0) {
            $runs.Add(@{ text=$cur.sb.ToString(); role=$cur.role; script=$cur.script; font=$cur.font; size=$cur.size
                         bx=@([math]::Round($cur.l,2),[math]::Round($cur.b,2),[math]::Round($cur.r,2),[math]::Round($cur.t,2))
                         flags=@($cur.flags) })
            [void]$cur.sb.Clear(); $cur.flags.Clear()
            $cur.l=[double]::MaxValue; $cur.b=[double]::MaxValue; $cur.r=[double]::MinValue; $cur.t=[double]::MinValue
        }
    }

    $prevRight = [double]::NaN
    foreach ($lt in $sorted) {
        # script call: smaller glyph displaced off the line baseline (knobs: classify-config.script)
        $s = 'normal'
        if ($lt.size -lt $St.size * $cfg.script.size_ratio_max) {
            $dy = $lt.base[1] - $St.base
            if ($dy -lt -$cfg.script.sub_min_drop) { $s = 'sub' }
            elseif ($dy -gt $cfg.script.super_min_rise) { $s = 'super' }
        }
        # role: displaced script glyphs are math by construction (fixes CMR-digit subscripts);
        # else store role_hint; unknown degrades to prose WITH a flag, never silently
        $fr = $Ctx.fontRole[$lt.font]
        $r = if ($s -ne 'normal') { 'math' }
             elseif ($fr -in 'math','mono','prose') { $fr }
             else { 'prose' }
        $unknownRole = ($fr -notin 'math','mono','prose')

        # ADVANCE-based gap, not glyph-box gap: prevRight is the pen position after the previous
        # glyph's advance (start + wadv), compared to this glyph's START (base x). A narrow glyph
        # like "1" has a box far narrower than its advance, so a box-to-box gap spuriously exceeds
        # threshold and injects "[ 1 ]"; the advance is the true pen metric (pdftotext/pdf.js do this).
        $space = (-not [double]::IsNaN($prevRight)) -and (($lt.base[0] - $prevRight) -gt $spaceGap)
        $boundary = ($cur.sb.Length -eq 0) -or ($r -ne $cur.role) -or ($s -ne $cur.script) -or ($lt.font -ne $cur.font)
        if ($boundary) {
            if ($space -and $cur.sb.Length -gt 0) { [void]$cur.sb.Append(' ') }   # trailing space stays on the flushed run
            & $flush
            $cur.role=$r; $cur.script=$s; $cur.font=$lt.font; $cur.size=$lt.size
        } elseif ($space) { [void]$cur.sb.Append(' ') }

        # symbol-map correction (math scope) + ligature expansion (prose scope) — store-driven
        $txt = $lt.text
        $mapped = Resolve-Symbol $lt.font $txt $r
        if ($null -ne $mapped) {
            if ($r -eq 'prose') { $Ctx.ligs++ } else { $Ctx.subs++ }
            $txt = $mapped
        }
        if ($txt -and $txt.Contains([char]0xFFFD)) { [void]$cur.flags.Add('unmapped_symbol') }
        if ($unknownRole) { [void]$cur.flags.Add('unknown_font_role') }
        [void]$cur.sb.Append($txt)
        if ($lt.bx[0] -lt $cur.l) { $cur.l = $lt.bx[0] }; if ($lt.bx[1] -lt $cur.b) { $cur.b = $lt.bx[1] }
        if ($lt.bx[2] -gt $cur.r) { $cur.r = $lt.bx[2] }; if ($lt.bx[3] -gt $cur.t) { $cur.t = $lt.bx[3] }
        # pen after this glyph = its start + advance width (falls back to box-right if wadv absent)
        $adv = [double]$lt.wadv
        $prevRight = if ($adv -gt 0) { [double]$lt.base[0] + $adv } else { [double]$lt.bx[2] }
    }
    & $flush

    foreach ($run in $runs) {
        $rec = [ordered]@{
            id      = $Ctx.nid
            type    = $LineType
            page    = $St.page
            line_id = $LineId
            block   = $BlockId
            col     = $Col
            baseline_y = [math]::Round($St.base, 2)
            content = $run.text
            font    = $run.font
            'font size' = $run.size
            'bounding box' = $run.bx
            role    = $run.role
            script  = $run.script
        }
        if ($null -ne $Tier) { $rec.tier = $Tier }
        if ($null -ne $OutlineLevel) { $rec.outline_level = $OutlineLevel }
        if ($null -ne $OutlineRef) { $rec.outline_ref = $OutlineRef }
        if ($LineType -eq 'formula-block') { $rec.formula_group = $Ctx.formulaGroup }
        $fl = [System.Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
        foreach ($f in $run.flags)  { if ($f) { [void]$fl.Add($f) } }
        foreach ($f in $LineFlags)  { if ($f) { [void]$fl.Add($f) } }
        $rec.flags = @($fl)
        $Ctx.nodes.Add($rec)
        $Ctx.nid++
    }
    $Ctx.typeCounts[$LineType] = 1 + ($Ctx.typeCounts[$LineType] ?? 0)
}

function ConvertTo-PdfDigNodes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $IrDir,
        [Parameter(Mandatory)] [string] $Slug,
        [string] $OutDir,
        [string] $EngineVersion = '0.2.0'
    )
    Import-FontRoles | Out-Null
    Import-ClassifyConfig | Out-Null
    Import-SymbolMap | Out-Null
    if (-not $OutDir) { $OutDir = $IrDir }

    $cfg = $script:ClassifyConfig
    $envelope = Get-Content (Join-Path $IrDir "$Slug.pdfdig.json") -Raw -Encoding utf8 | ConvertFrom-Json
    $letters  = Read-JsonlLane (Join-Path $IrDir "$Slug.letters.jsonl")
    $blocks   = Read-JsonlLane (Join-Path $IrDir "$Slug.blocks.jsonl")

    # font → role_hint from the substrate's census (store-derived there; one dict here)
    $fontRole = @{}
    foreach ($f in $envelope.fonts) { $fontRole[$f.name] = $f.role_hint }
    $pageDims = @{}
    foreach ($p in $envelope.pages) { $pageDims[[int]$p.n] = $p }

    # group letters by substrate line id; orphans (no line back-ref) kept per page
    $lineLetters = @{}
    $orphans = @{}
    foreach ($lt in $letters) {
        if ($null -ne $lt.line) {
            if (-not $lineLetters.ContainsKey([int]$lt.line)) { $lineLetters[[int]$lt.line] = [System.Collections.Generic.List[object]]::new() }
            $lineLetters[[int]$lt.line].Add($lt)
        } else {
            if (-not $orphans.ContainsKey([int]$lt.page)) { $orphans[[int]$lt.page] = [System.Collections.Generic.List[object]]::new() }
            $orphans[[int]$lt.page].Add($lt)
        }
    }

    # ══ Stage A: CALIBRATION — order statistics over quantized typography ══════════════════════
    $sizeCount = @{}
    foreach ($lt in $letters) {
        if ($fontRole[$lt.font] -eq 'prose') { $k=[string]$lt.size; $sizeCount[$k] = 1 + ($sizeCount[$k] ?? 0) }
    }
    if ($sizeCount.Count -eq 0) { foreach ($lt in $letters) { $k=[string]$lt.size; $sizeCount[$k] = 1 + ($sizeCount[$k] ?? 0) } }
    $bodySize = [double](($sizeCount.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key)

    # line-level stats once, reused by tiering + emission
    $lineStats = @{}
    foreach ($b in $blocks) {
        foreach ($ln in $b.lines) {
            $ls = $lineLetters[[int]$ln.id]
            if (-not $ls -or $ls.Count -eq 0) { continue }
            $cnt = $ls.Count
            $sizes = [double[]]::new($cnt); $bases = [double[]]::new($cnt)
            $boldN = 0; $mathN = 0; $rotN = 0; $lastBold = -1
            for ($i = 0; $i -lt $cnt; $i++) {
                $lt = $ls[$i]
                $sizes[$i] = $lt.size; $bases[$i] = $lt.base[1]
                if ($lt.bold_name) { $boldN++; $lastBold = $i }
                if ($fontRole[$lt.font] -eq 'math') { $mathN++ }
                if ($lt.orient -ne 'Horizontal') { $rotN++ }
            }
            $modalSize = [double](Get-Modal $sizes)
            $baseY = [double](Get-Modal $bases)
            # bold_tail = glyphs after the last bold one. A bold PREFIX with a real tail is a run-in
            # paragraph lead ("Cycles as Fundamental Memory Units. We then…"), not a section heading.
            $boldTail = if ($lastBold -ge 0) { $cnt - 1 - $lastBold } else { $cnt }
            $lineStats[[int]$ln.id] = @{
                size=$modalSize; base=$baseY; n=$ls.Count
                bold_frac=$boldN/$ls.Count; math_frac=$mathN/$ls.Count; rot_frac=$rotN/$ls.Count
                bold_tail=$boldTail
                page=[int]$b.page
            }
        }
    }

    # heading tier ladder: distinct line modal sizes above body*ratio, desc; bold-at-body = last tier.
    # Rotated lines (arXiv stamp, sidebars) are excluded — they classify as markers and must not
    # pollute the ladder (specimen 2508.11646: Times-Roman 20 Rotate270 stamp).
    $tierSet = [System.Collections.Generic.HashSet[double]]::new()
    foreach ($st in $lineStats.Values) {
        if ($st.rot_frac -gt 0.5) { continue }
        if ($st.size -ge $bodySize * $cfg.headings.min_size_ratio_over_body -and $st.size -gt $bodySize) { [void]$tierSet.Add($st.size) }
    }
    # merge adjacent sizes into tier BANDS: TeX sizes are quantized magsteps but office pipelines
    # emit continuous jitter (2504.09042: 16.3/16.4/16.5/16.7 = ONE visual tier). Deterministic
    # 1-D gap-merge — sizes closer than tier_merge_gap_pt share a band.
    $tiers = [System.Collections.Generic.List[object]]::new()   # each: @{ hi; lo }
    foreach ($sz in ($tierSet | Sort-Object -Descending)) {
        if ($tiers.Count -gt 0 -and ($tiers[$tiers.Count-1].lo - $sz) -le $cfg.headings.tier_merge_gap_pt) {
            $tiers[$tiers.Count-1].lo = $sz
        } else {
            $tiers.Add(@{ hi = $sz; lo = $sz })
        }
    }
    $boldBodyTier = $tiers.Count                       # bold-at-body-size tier sits below all size tiers

    # modal leading (intra-block consecutive baseline gaps) + paragraph indent register
    $gapCount = @{}; $indentCount = @{}
    foreach ($b in $blocks) {
        $prev = $null
        foreach ($ln in $b.lines) {
            $st = $lineStats[[int]$ln.id]; if (-not $st) { continue }
            if ($null -ne $prev) {
                $g = [math]::Round(($prev - $st.base) * 2, 0) / 2   # 0.5pt bins
                if ($g -gt 0 -and $g -lt 4 * $bodySize) { $k=[string]$g; $gapCount[$k] = 1 + ($gapCount[$k] ?? 0) }
            }
            $prev = $st.base
            $ind = [math]::Round(($ln.bx[0] - $b.bx[0]) * 2, 0) / 2
            if ($ind -ge 0) { $k=[string]$ind; $indentCount[$k] = 1 + ($indentCount[$k] ?? 0) }
        }
    }
    $leading = if ($gapCount.Count) { [double](($gapCount.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key) } else { $null }
    $indentPt = $null
    if ($indentCount.Count) {
        $indentPt = [double](($indentCount.GetEnumerator() | Where-Object { [double]$_.Key -gt 1.0 } |
                              Sort-Object Value -Descending | Select-Object -First 1)?.Key)
    }

    $calibration = [ordered]@{
        body_size = $bodySize
        tier_sizes = @($tiers | ForEach-Object { if ($_.hi -eq $_.lo) { [string]$_.hi } else { "$($_.hi)-$($_.lo)" } })
        bold_body_tier = $boldBodyTier
        leading = $leading
        indent_pt = $indentPt
        prose_letter_sizes = [ordered]@{}
    }
    foreach ($kv in ($sizeCount.GetEnumerator() | Sort-Object { [double]$_.Key } -Descending | Select-Object -First 12)) {
        $calibration.prose_letter_sizes[$kv.Key] = $kv.Value
    }

    # bookmark outline (number-stripped key) for heading cross-derivation. `ref` = stable index — a
    # wrapped heading's fragments all match the SAME ref, which the adapter uses to re-fuse them.
    $outline = @(); $oi = 0
    foreach ($bm in $envelope.bookmarks) {
        $outline += @{ norm = (ConvertTo-OutlineKey $bm.title); title = $bm.title; page = $bm.page
                       level = $bm.level; ref = $oi; matched = $false }
        $oi++
    }

    # ══ Stage B: TYPED EMISSION — run-level nodes in resolved reading order ════════════════════
    $ctx = @{
        nid = 0; formulaGroup = -1; subs = 0; ligs = 0
        nodes = [System.Collections.Generic.List[object]]::new()
        typeCounts = @{}
        cfg = $cfg; fontRole = $fontRole
        # store-driven glyph correction for the assembler (math scope): CMSY-k/‖ -> \|, etc.
        mathSymbolFn = { param($t, $f) Resolve-Symbol $f $t 'math' }
    }
    $docFlags = [System.Collections.Generic.List[object]]::new()
    if ($envelope.fonts | Where-Object { $_.family -eq 'cmbright' } | Select-Object -First 1) {
        $docFlags.Add([ordered]@{ code='math_role_ambiguous_sf'; detail='cmbright sets math in SF fonts; font-name role separation unavailable (registry: 2210.00916)' })
    }
    if ($tiers.Count -gt $cfg.headings.max_tiers_before_flag) {
        $docFlags.Add([ordered]@{ code='tier_ladder_noisy'; detail="$($tiers.Count) tier bands after merging — continuous size jitter (office/publisher pipeline?); heading tiers are low-confidence" })
    }
    $orphanLetterCount = 0
    foreach ($v in $orphans.Values) { $orphanLetterCount += $v.Count }
    if ($letters.Count -gt 0 -and $orphanLetterCount / $letters.Count -gt 0.05) {
        $docFlags.Add([ordered]@{ code='substrate_coverage_gap'
                                  detail="$orphanLetterCount/$($letters.Count) letters carry no line back-ref — lanes 2/3 under-covered this layout; orphan lines carry suspect_reading_order" })
    }

    $headingCandidates = 0; $headingsConfirmed = 0; $orphanLines = 0
    # composite-key array sort (page, reading_order) — no per-comparison scriptblocks
    $blocksSorted = [object[]]::new($blocks.Count)
    $bKeys = [long[]]::new($blocks.Count)
    for ($i = 0; $i -lt $blocks.Count; $i++) {
        $blocksSorted[$i] = $blocks[$i]
        $bKeys[$i] = ([long][int]$blocks[$i].page -shl 32) -bor ([long][int]$blocks[$i].reading_order -band 0xFFFFFFFFL)
    }
    [Array]::Sort($bKeys, $blocksSorted)
    foreach ($b in $blocksSorted) {
        $prevFormulaBase = $null
        foreach ($ln in $b.lines) {
            $ls = $lineLetters[[int]$ln.id]
            if (-not $ls -or $ls.Count -eq 0) { continue }
            $st = $lineStats[[int]$ln.id]
            $pd = $pageDims[[int]$b.page]
            $lineFlags = [System.Collections.Generic.List[string]]::new()
            if ($null -eq $b.column_band) { $lineFlags.Add('suspect_reading_order') }

            # ── line type decision ladder: furniture → heading → formula → prose ──
            $lineType = 'prose'; $tier = $null; $outlineHit = $null
            $nearEdge = ($st.base -gt (1 - $cfg.furniture.margin_frac) * $pd.h) -or ($st.base -lt $cfg.furniture.margin_frac * $pd.h)
            if ($st.rot_frac -gt 0.5) {
                $lineType = 'marker'; $lineFlags.Add('rotated_text')
            } elseif ($nearEdge -and $st.size -le $bodySize + 0.1) {
                $lineType = 'marker'; $lineFlags.Add('page_furniture')
            } else {
                $tierIdx = -1
                for ($ti = 0; $ti -lt $tiers.Count; $ti++) {
                    if ($st.size -ge $tiers[$ti].lo - 0.01 -and $st.size -le $tiers[$ti].hi + 0.01) { $tierIdx = $ti; break }
                }
                $isTierSize = $tierIdx -ge 0
                $isBoldBody = ($st.bold_frac -ge $cfg.headings.bold_line_frac) -and ($st.size -ge $bodySize - 0.1) -and (-not $isTierSize)
                # RUN-IN detection: a bold PREFIX followed by a substantial regular tail is a
                # paragraph lead ("Chain Complex: <definition>"), not a section heading. Requires
                # actual bold (bold_tail < n ⟺ some bold present) so non-bold outline headings are
                # not caught. Blocks BOTH promotion paths below — a run-in lead can spuriously
                # prefix-match a section bookmark ("Chain Complex" ⊂ "Chain Complex and Homology…").
                $isRunIn = ($st.bold_tail -ge $cfg.headings.run_in_min_tail) -and ($st.bold_tail -lt $st.n)
                if ($isBoldBody -and $isRunIn) { $isBoldBody = $false }
                # outline witness runs in BOTH directions: it confirms typographic candidates AND
                # proposes headings typography cannot see (body-size regular-face all-caps section
                # heads — specimen 2508.11646's IEEE style). A proposed heading carries provenance
                # (heading_from_outline + outline_level), never a fabricated tier.
                $outlineHit = $null; $outlineFragment = $false
                if ($outline.Count -gt 0 -and $st.n -le $cfg.headings.max_line_letters) {
                    $lineNorm = ConvertTo-OutlineKey $ln.text
                    foreach ($o in $outline) {
                        if (-not $o.norm) { continue }
                        if ([math]::Abs(($o.page ?? $b.page) - $b.page) -gt 1) { continue }
                        # bidirectional contains: FORWARD = line holds the whole title (a full heading);
                        # REVERSE = line is a FRAGMENT of a longer title wrapped across lines (III/V).
                        # A reverse-only match is flagged: a wrapped fragment re-fuses with its sibling
                        # in the adapter, but a LONE reverse fragment (e.g. the common word "Homology"
                        # matching a section title that contains it) is spurious and gets demoted there.
                        $fwd = $lineNorm.Contains($o.norm)
                        $rev = ($lineNorm.Length -ge 8 -and $o.norm.Contains($lineNorm))
                        if ($fwd -or $rev) { $outlineHit = $o; $outlineFragment = (-not $fwd); break }
                    }
                }
                # a heading is prose, not math — a large display delimiter ("[" from \left[) matches a
                # size tier by font but is math (math_frac high); route it to formula, not a heading.
                # Also require a real prose WORD: a large "[γ]" display fragment has math_frac only ~0.3
                # (prose brackets + one math glyph) yet is plainly not a heading.
                $mathHeavy = ($st.math_frac -ge 0.5) -or (-not ($ln.text -match '[A-Za-z]{2,}'))
                if (($isTierSize -or $isBoldBody) -and -not $mathHeavy -and $st.n -le $cfg.headings.max_line_letters) {
                    $lineType = 'heading-candidate'
                    $tier = if ($isTierSize) { $tierIdx } else { $boldBodyTier }
                    $headingCandidates++
                    if ($outlineHit) {
                        $outlineHit.matched = $true; $lineFlags.Add('heading_confirmed_outline'); $headingsConfirmed++
                    }
                } elseif ($outlineHit -and -not $isRunIn -and -not $mathHeavy) {
                    $lineType = 'heading-candidate'
                    $tier = $null   # semantic level comes from the outline, not typography
                    $outlineHit.matched = $true
                    $lineFlags.Add($(if ($outlineFragment) { 'outline_fragment' } else { 'heading_from_outline' }))
                    $headingCandidates++; $headingsConfirmed++
                } elseif ($st.math_frac -ge $cfg.display_math.min_math_frac) {
                    $lineW = $ln.bx[2] - $ln.bx[0]; $blockW = $b.bx[2] - $b.bx[0]
                    if ($blockW -le 0 -or ($lineW / $blockW) -le $cfg.display_math.max_width_frac_of_block) {
                        $lineType = 'formula-block'
                        $stacked = ($null -ne $prevFormulaBase) -and (($prevFormulaBase - $st.base) -lt $cfg.display_math.stack_gap_factor * $st.size)
                        if (-not $stacked) { $ctx.formulaGroup++ }
                        else { $lineFlags.Add('needs_2d_assembly') }
                    }
                }
            }
            $prevFormulaBase = if ($lineType -eq 'formula-block') { $st.base } else { $null }
            $olv = $null; $oref = $null
            if ($lineType -eq 'heading-candidate' -and $outlineHit) { $olv = $outlineHit.level; $oref = $outlineHit.ref }
            Emit-PdfDigLine -Ctx $ctx -Letters $ls -LineId ([int]$ln.id) -BlockId $b.id -Col $b.column_band `
                            -LineType $lineType -Tier $tier -LineFlags $lineFlags.ToArray() -St $st -OutlineLevel $olv -OutlineRef $oref
        }
    }

    # orphan letters (no substrate line): grouped by baseline proximity, honestly flagged.
    # typed-array sort, NOT `$orphans.Keys | Sort-Object` — pipeline output is PSObject-wrapped,
    # and a wrapped int stored into a node record blows up the substrate's Newtonsoft fast path
    $orphanPages = [int[]]::new($orphans.Keys.Count)
    $orphans.Keys.CopyTo($orphanPages, 0)
    [Array]::Sort($orphanPages)
    foreach ($pg in $orphanPages) {
        $tol = $cfg.line_grouping.baseline_tolerance_pt
        $groups = [System.Collections.Generic.List[object]]::new()
        foreach ($lt in ($orphans[$pg] | Sort-Object { -$_.base[1] }, { $_.base[0] })) {
            # direct assignment, NOT `$g = if (...) {...}` — if-expression output passes through
            # pipeline semantics and UNROLLS a single-element List to its bare element
            $g = $null
            if ($groups.Count) { $g = $groups[$groups.Count-1] }
            if ($g -and [math]::Abs($g[0].base[1] - $lt.base[1]) -le $tol) { $g.Add($lt) }
            else { $groups.Add([System.Collections.Generic.List[object]]::new(@($lt))) }
        }
        foreach ($g in $groups) {
            $st = @{ size=[double](Get-Modal @($g | ForEach-Object size)); base=[double](Get-Modal @($g | ForEach-Object { $_.base[1] }))
                     n=$g.Count; bold_frac=0.0; math_frac=0.0; rot_frac=0.0; page=$pg }
            Emit-PdfDigLine -Ctx $ctx -Letters $g -LineId $null -BlockId $null -Col $null `
                            -LineType 'prose' -Tier $null -LineFlags @('orphan_letters','suspect_reading_order') -St $st
            $orphanLines++
        }
    }

    # ── cross-derivation + health ────────────────────────────────────────────────────────────────
    $unmatchedBm = @($outline | Where-Object { -not $_.matched } | ForEach-Object title)
    if ($unmatchedBm.Count -gt 0 -and $outline.Count -gt 0) {
        $docFlags.Add([ordered]@{ code='outline_headings_unmatched'
                                  detail="$($unmatchedBm.Count)/$($outline.Count) bookmark titles matched no heading-candidate line" })
    }
    $health = [ordered]@{
        nodes_total = $ctx.nodes.Count
        heading_candidates = $headingCandidates
        headings_confirmed_outline = $headingsConfirmed
        bookmarks_total = $outline.Count
        bookmarks_matched = @($outline | Where-Object { $_.matched }).Count
        symbol_corrections = $ctx.subs
        ligature_expansions = $ctx.ligs
        orphan_lines = $orphanLines
        flags_doc = $docFlags.Count
    }

    $classifyEnv = [ordered]@{
        schema = 'pdfdig-classify/1'
        source = [ordered]@{ slug=$Slug; ir_engine=$envelope.engine.version; ir_config_hash=$envelope.engine.config_hash }
        engine = [ordered]@{ name='pdfdig-classify'; version=$EngineVersion; config_hash=$script:ClassifyConfigHash
                             run_utc=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
        origin = $envelope.document.origin
        calibration = $calibration
        node_types = $ctx.typeCounts
        health = $health
        outline_unmatched = @($unmatchedBm)
        flags = @($docFlags)
    }

    $nodesPath = Join-Path $OutDir "$Slug.nodes.jsonl"
    Write-JsonlStage -Records $ctx.nodes.ToArray() -OutputPath $nodesPath -SourcePath (Join-Path $IrDir "$Slug.pdfdig.json") -Stage 'pdfdig-classify/nodes' | Out-Null
    $cePath = Join-Path $OutDir "$Slug.classify.json"
    [System.IO.File]::WriteAllText($cePath, ($classifyEnv | ConvertTo-Json -Depth 10), [System.Text.UTF8Encoding]::new($false))

    [pscustomobject]@{
        Slug = $Slug; Nodes = $ctx.nodes.Count; NodesPath = $nodesPath; Envelope = $cePath
        Calibration = $calibration; NodeTypes = $ctx.typeCounts; Health = $health
    }
}
