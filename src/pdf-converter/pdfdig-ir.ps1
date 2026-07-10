#requires -Version 7.0
<#
  src/pdf-converter/pdfdig-ir.ps1 — pdfdig generic IR emitter.

  Faithful, opinion-free projection of everything PdfPig can see into the multi-lane JSONL
  substrate described in issues/pdfdig-lane/ir-schema.md. NO classification: roles/scripts/columns
  are measured or recorded-as-claims, never decided here. See issues/pdfdig-lane/pdfpig-capability-map.md
  for the empirical basis of every choice below.

  Lanes emitted (ir-schema.md build order 1-3):
    {slug}.pdfdig.json     document envelope (provenance, origin, bookmarks, font census, health)
    {slug}.letters.jsonl   LANE 1  atomic: every Letter, all born signals (+ block/line/word back-refs)
    {slug}.words.jsonl     LANE 2  derived: NearestNeighbour word assembly
    {slug}.blocks.jsonl    LANE 3  derived: RecursiveXYCut segmentation + reading order — a CLAIM lane
    {slug}.paths.jsonl     LANE 4  vector: paths w/ bezier command-point bbox fallback + rule tags

    . ./pdfdig-ir.ps1
    ConvertTo-PdfDigIr -PdfPath <in.pdf> [-OutDir <dir>] [-Pages 1,2] [-Verbose]
#>

# NB: no session-scope Set-StrictMode — this is a dot-sourceable library; forcing strict mode on
# callers pollutes their session (and trips the host's exit-code epilogue). Code below is strict-safe.
. "$PSScriptRoot/../jsonl.ps1"   # Write-JsonlStage: UTF-8-no-BOM, SMP-safe, .jidx + .sig

$script:PdfPigLib = Join-Path $PSScriptRoot 'lib'   # vendored dlls; falls back to repo lib/pdfpig
if (-not (Test-Path (Join-Path $script:PdfPigLib 'UglyToad.PdfPig.dll'))) {
    $script:PdfPigLib = Join-Path $PSScriptRoot '../../lib/pdfpig'
}

# ── Interop: dependency-ordered load; nullable-struct + out-param traps live here once ──────────
function Import-PdfPig {
    [CmdletBinding()] param([string] $LibDir = $script:PdfPigLib)
    if ('UglyToad.PdfPig.PdfDocument' -as [type]) { return }   # idempotent
    $order = 'UglyToad.PdfPig.Tokens','UglyToad.PdfPig.Core','UglyToad.PdfPig.Tokenization',
             'UglyToad.PdfPig.Fonts','UglyToad.PdfPig','UglyToad.PdfPig.DocumentLayoutAnalysis'
    foreach ($n in $order) {
        $dll = Join-Path $LibDir "$n.dll"
        if (Test-Path $dll) { Add-Type -Path $dll }
        elseif ($n -notlike '*DocumentLayoutAnalysis') { throw "PdfPig assembly not found: $dll" }
    }
}

# ── Config stores (rules-as-data): every cue the engine consults is a validated store, never code.
#    A malformed/incomplete entry THROWS with its line number — bad data is a failure, not a silent
#    skip. See stores/README.md + the growth loop. ─────────────────────────────────────────────────
function Read-JsonlStore([string] $Path, [string[]] $Required) {
    if (-not (Test-Path $Path)) { throw "store not found: $Path" }
    $name = [System.IO.Path]::GetFileName($Path)
    $rows = [System.Collections.Generic.List[object]]::new()
    $ln = 0
    # ReadAllLines (eager) not ReadLines (lazy): a validation throw mid-file must not leave the handle open
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        $ln++
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $o = $null
        try { $o = $line | ConvertFrom-Json } catch { throw "$name line ${ln}: bad JSON — $($_.Exception.Message)" }
        foreach ($req in $Required) {
            if (-not $o.PSObject.Properties[$req] -or ($null -eq $o.$req) -or ($o.$req -is [string] -and $o.$req -eq '')) {
                throw "$name line ${ln}: missing required field '$req'"
            }
        }
        $rows.Add($o)
    }
    return $rows
}

$script:FontRoles = $null
function Import-FontRoles {
    [CmdletBinding()] param([string] $Path = (Join-Path $PSScriptRoot 'stores/font-roles.jsonl'))
    $rows = foreach ($o in (Read-JsonlStore $Path @('pattern','role','family'))) {
        [pscustomobject]@{ pattern=$o.pattern
                           match=($o.PSObject.Properties['match'] ? $o.match : 'prefix')
                           role=$o.role; family=$o.family
                           domain=($o.PSObject.Properties['domain'] ? $o.domain : $null) }
    }
    # longest pattern first ⇒ most specific claim wins (CMMIB before CMMI, LMRomanCaps before LMRoman)
    $script:FontRoles = @($rows | Sort-Object { $_.pattern.Length } -Descending)
    $script:FontRoles.Count
}

$script:ProducerMap = $null
function Import-ProducerMap {
    [CmdletBinding()] param([string] $Path = (Join-Path $PSScriptRoot 'stores/producer-map.jsonl'))
    $rows = foreach ($o in (Read-JsonlStore $Path @('pattern','origin'))) {
        [pscustomobject]@{ pattern=$o.pattern; origin=$o.origin
                           tex=($o.PSObject.Properties['tex'] ? $o.tex : $null)          # true/false/null=inconclusive
                           rewriter=($o.PSObject.Properties['rewriter'] ? [bool]$o.rewriter : $false) }
    }
    $script:ProducerMap = @($rows | Sort-Object { $_.pattern.Length } -Descending)
    $script:ProducerMap.Count
}

$script:ClassifyConfig = $null
$script:ClassifyConfigHash = $null
function Import-ClassifyConfig {
    [CmdletBinding()] param([string] $Path = (Join-Path $PSScriptRoot 'stores/classify-config.json'))
    if (-not (Test-Path $Path)) { throw "classify-config not found: $Path" }
    $raw = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
    $script:ClassifyConfig = $raw | ConvertFrom-Json
    # config_hash rides in the IR header so conversions are version-diffable against knob changes
    $sha = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($raw))
    $script:ClassifyConfigHash = ([System.Convert]::ToHexString($sha)).Substring(0,12).ToLowerInvariant()
    $script:ClassifyConfigHash
}

function Get-FontSubsetStripped([string] $name) {
    if (-not $name) { return '' }
    # subset tag is 6 chars + '+' (e.g. ASYHPE+NimbusRomNo9L-Regu)
    if ($name.Length -gt 7 -and $name[6] -eq '+') { return $name.Substring(7) }
    return $name
}

function Resolve-Family([string] $strippedName) {
    if (-not $strippedName) { return @{ family='unknown'; role='unknown'; domain=$null } }
    if ($null -eq $script:FontRoles) { Import-FontRoles | Out-Null }
    foreach ($e in $script:FontRoles) {   # already sorted longest-first ⇒ first hit is most specific
        $hit = if ($e.match -eq 'prefix') {
            $strippedName.StartsWith($e.pattern, [StringComparison]::OrdinalIgnoreCase)
        } else {
            $strippedName.IndexOf($e.pattern, [StringComparison]::OrdinalIgnoreCase) -ge 0
        }
        if ($hit) { return @{ family=$e.family; role=$e.role; domain=$e.domain } }
    }
    return @{ family='unknown'; role='unknown'; domain=$null }
}

# name-derived bold: TeX bold is name-encoded (-Medi/-Bold/-Bx/CMBX), NOT FontDetails.IsBold (capability map §1a)
function Test-BoldByName([string] $strippedName) {
    if (-not $strippedName) { return $false }
    return ($strippedName -match '(?i)bold|-Bx|CMBX|-Medi|-Semib|Black|Heavy')
}

function ConvertTo-HexColor($color) {
    try {
        if ($null -eq $color) { return $null }
        $rgb = $color.ToRGBValues()
        $r = [int][math]::Round($rgb.Item1 * 255); $g = [int][math]::Round($rgb.Item2 * 255); $b = [int][math]::Round($rgb.Item3 * 255)
        if ($r -eq 0 -and $g -eq 0 -and $b -eq 0) { return $null }   # default black ⇒ omit
        return '#{0:x2}{1:x2}{2:x2}' -f $r, $g, $b
    } catch { return $null }
}

function Resolve-ProducerEntry([string] $s) {
    if ([string]::IsNullOrEmpty($s)) { return $null }
    if ($null -eq $script:ProducerMap) { Import-ProducerMap | Out-Null }
    foreach ($e in $script:ProducerMap) {
        if ($s.IndexOf($e.pattern, [StringComparison]::OrdinalIgnoreCase) -ge 0) { return $e }
    }
    return $null
}

<#
  Origin ladder — cues from stores/producer-map.jsonl, strongest metadata first, then font evidence
  (capability map §3): producer string > creator string (survives the arXiv/pikepdf rewrite as
  "arXiv GenPDF (tex2pdf:)") > CM/AMS font presence. A REWRITER match (pikepdf/qpdf/Ghostscript)
  doesn't answer origin — it explains why the ladder must continue. Records WHICH cue fired and the
  rewriter (when seen) so downstream knows the sense used.
#>
function Get-OriginVerdict([string] $producer, [string] $creator, [hashtable] $familiesSeen) {
    $rewriter = $null
    $pe = Resolve-ProducerEntry $producer
    if ($pe -and $pe.rewriter) { $rewriter = $pe.origin; $pe = $null }
    if ($pe -and $null -ne $pe.tex) {
        $tag = if ($pe.tex) { 'tex' } else { $pe.origin }
        return @{ tag=$tag; cue='producer'; producer_verdict=$pe.tex; rewriter=$rewriter }
    }
    $ce = Resolve-ProducerEntry $creator
    if ($ce -and -not $ce.rewriter -and $null -ne $ce.tex) {
        $tag = if ($ce.tex) { 'tex' } else { $ce.origin }
        return @{ tag=$tag; cue='creator'; producer_verdict=$false; rewriter=$rewriter }
    }
    $hasCmAms = $familiesSeen.ContainsKey('cm') -or $familiesSeen.ContainsKey('ams') -or
                $familiesSeen.ContainsKey('rsfs') -or $familiesSeen.ContainsKey('eu')
    if ($hasCmAms) { return @{ tag='tex'; cue='fonts'; producer_verdict=$null; rewriter=$rewriter } }
    return @{ tag='unknown'; cue='none'; producer_verdict=$null; rewriter=$rewriter }
}

function Get-Bookmarks($doc) {
    $bm = $null
    if (-not $doc.TryGetBookmarks([ref]$bm)) { return @() }
    $out = [System.Collections.Generic.List[object]]::new()
    $walk = {
        param($node)
        $page = $null
        $pn = $node.PSObject.Properties['PageNumber']
        if ($pn) { $page = $pn.Value }
        $out.Add([ordered]@{ title = $node.Title; level = $node.Level; page = $page })
        foreach ($c in $node.Children) { & $walk $c }
    }
    foreach ($r in $bm.Roots) { & $walk $r }
    return $out.ToArray()
}

function ConvertTo-BxArray($rect) {
    @([math]::Round($rect.Left,2),[math]::Round($rect.Bottom,2),[math]::Round($rect.Right,2),[math]::Round($rect.Top,2))
}

# modal value of a sequence (first-seen wins ties) — small hashtable count, no pipeline
function Get-Modal($values) {
    $c = [ordered]@{}
    foreach ($v in $values) { $k = [string]$v; $c[$k] = 1 + ($c[$k] ?? 0) }
    $best = $null; $bestN = -1
    foreach ($k in $c.Keys) { if ($c[$k] -gt $bestN) { $best = $k; $bestN = $c[$k] } }
    return $best
}

function Join-PdfDigTextLines([string[]] $LineTexts) {
    $sb = [System.Text.StringBuilder]::new()
    $dehyphenated = $false
    foreach ($lineText in $LineTexts) {
        $t = (($lineText ?? '') -replace '\s+', ' ').Trim()
        if ($t -eq '') { continue }
        if ($sb.Length -eq 0) {
            [void]$sb.Append($t)
            continue
        }
        $cur = $sb.ToString()
        if ($cur -cmatch '[a-z]-$' -and $t -cmatch '^[a-z]') {
            $sb.Length = $sb.Length - 1
            [void]$sb.Append($t)
            $dehyphenated = $true
        }
        elseif ($cur.EndsWith('-')) {
            [void]$sb.Append($t)
        }
        else {
            [void]$sb.Append(' ')
            [void]$sb.Append($t)
        }
    }
    [pscustomobject]@{
        text = $sb.ToString()
        dehyphenated = $dehyphenated
    }
}

<#
  Column bands — a per-page LABELING of the XYCut claim, not a decision (ir-schema LANE 3).
  Narrow blocks' left edges are clustered; >=2 clusters separated by >12% of text width = multi-band
  page. Wide blocks (>=70% text width) = 'span'. A block fitting no band cleanly = null (ambiguous),
  which feeds health.columns_confident_frac — the flag channel, not a silent guess.
#>
function Get-ColumnBands([object[]] $blockRecs) {
    if ($blockRecs.Count -eq 0) { return }
    if ($null -eq $script:ClassifyConfig) { Import-ClassifyConfig | Out-Null }
    $cc = $script:ClassifyConfig.columns
    $lefts  = @($blockRecs | ForEach-Object { $_.bx[0] })
    $rights = @($blockRecs | ForEach-Object { $_.bx[2] })
    $tL = ($lefts | Measure-Object -Minimum).Minimum
    $tR = ($rights | Measure-Object -Maximum).Maximum
    $W = $tR - $tL
    if ($W -le 0) { foreach ($b in $blockRecs) { $b.column_band = 0 }; return }

    $narrow = @($blockRecs | Where-Object { ($_.bx[2] - $_.bx[0]) -lt $cc.narrow_width_frac * $W })
    $clusters = [System.Collections.Generic.List[object]]::new()
    foreach ($b in ($narrow | Sort-Object { $_.bx[0] })) {
        $last = if ($clusters.Count) { $clusters[$clusters.Count-1] } else { $null }
        if ($last -and ($b.bx[0] - $last.max) -le $cc.cluster_gap_frac * $W) {
            if ($b.bx[0] -lt $last.min) { $last.min = $b.bx[0] }
            if ($b.bx[0] -gt $last.max) { $last.max = $b.bx[0] }
            $last.members.Add($b)
        } else {
            $clusters.Add(@{ min = $b.bx[0]; max = $b.bx[0]; members = [System.Collections.Generic.List[object]]::new(@($b)) })
        }
    }

    if ($clusters.Count -lt 2) {
        foreach ($b in $blockRecs) { $b.column_band = 0 }   # single-column page: one band, all confident
        return
    }
    $tol = $cc.assign_tolerance_frac * $W
    foreach ($b in $blockRecs) {
        $bw = $b.bx[2] - $b.bx[0]
        if ($bw -ge $cc.span_width_frac * $W) { $b.column_band = 'span'; continue }
        $band = $null
        for ($i = 0; $i -lt $clusters.Count; $i++) {
            if ($b.bx[0] -ge $clusters[$i].min - $tol -and $b.bx[0] -le $clusters[$i].max + $tol) { $band = $i; break }
        }
        $b.column_band = $band   # null = ambiguous ⇒ counted against columns_confident_frac
    }
}

# conservative bbox from a path's command points (control points included — over-estimates, tagged
# as such). Fallback for bezier-only subpaths where 0.1.14 GetBoundingRectangle() returns null
# (capability map §5). Generic property scan: works for Move(Location), Line(From/To),
# CubicBezierCurve(Start/End/control points) without naming any command type.
function Get-PathCommandBbox($path) {
    $minX = [double]::MaxValue; $minY = [double]::MaxValue
    $maxX = [double]::MinValue; $maxY = [double]::MinValue
    $n = 0
    foreach ($sp in $path) {
        foreach ($cmd in $sp.Commands) {
            foreach ($prop in $cmd.PSObject.Properties) {
                $v = $prop.Value
                if ($v -is [UglyToad.PdfPig.Core.PdfPoint]) {
                    if ($v.X -lt $minX) { $minX = $v.X }; if ($v.X -gt $maxX) { $maxX = $v.X }
                    if ($v.Y -lt $minY) { $minY = $v.Y }; if ($v.Y -gt $maxY) { $maxY = $v.Y }
                    $n++
                }
            }
        }
    }
    if ($n -eq 0) { return $null }
    @([math]::Round($minX,2),[math]::Round($minY,2),[math]::Round($maxX,2),[math]::Round($maxY,2))
}

function ConvertTo-PdfDigIr {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $PdfPath,
        [string] $OutDir,
        [int[]]  $Pages,                 # optional page subset (1-based); default all
        [string] $EngineVersion = '0.2.0'
    )
    Import-PdfPig
    Import-FontRoles | Out-Null
    Import-ProducerMap | Out-Null
    Import-ClassifyConfig | Out-Null

    $PdfPath = (Resolve-Path -LiteralPath $PdfPath).Path
    $slug    = [System.IO.Path]::GetFileNameWithoutExtension($PdfPath)
    if (-not $OutDir) { $OutDir = [System.IO.Path]::GetDirectoryName($PdfPath) }
    if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }

    $bytes  = (Get-Item -LiteralPath $PdfPath).Length
    $sha    = (Get-FileHash -LiteralPath $PdfPath -Algorithm SHA256).Hash.ToLowerInvariant()

    $doc = [UglyToad.PdfPig.PdfDocument]::Open($PdfPath)
    try {
        $producer = ''; $creator = $null; $title = $null; $author = $null
        try { $producer = $doc.Information.Producer } catch {}
        try { $creator  = $doc.Information.Creator }  catch {}
        try { $title    = $doc.Information.Title }    catch {}
        try { $author   = $doc.Information.Author }   catch {}
        $version = 0.0; try { $version = $doc.Version } catch {}
        $hasXmp = $false; $x = $null; try { $hasXmp = $doc.TryGetXmpMetadata([ref]$x) } catch {}

        $pageList = if ($Pages) { $Pages } else { 1..$doc.NumberOfPages }

        # DLA singletons (claim-lane machinery — capability map §2)
        $nnExtractor = [UglyToad.PdfPig.DocumentLayoutAnalysis.WordExtractor.NearestNeighbourWordExtractor]::Instance
        $segmenter   = [UglyToad.PdfPig.DocumentLayoutAnalysis.PageSegmenter.RecursiveXYCut]::Instance
        $roDetector  = [UglyToad.PdfPig.DocumentLayoutAnalysis.ReadingOrderDetector.UnsupervisedReadingOrderDetector]::Instance

        # ── lanes + rolling census/health accumulators ──────────────────────────────────────
        # per-document hot-loop caches: raw FontName → resolved {stripped,family,role,bold}
        # (kills a 65-entry store scan + regex per letter), IColor instance → hex (ref-keyed;
        # GrayColor.Black is a shared instance on most letters)
        $resolveCache = @{}
        $colorCache = [System.Collections.Generic.Dictionary[object,object]]::new([System.Collections.Generic.ReferenceEqualityComparer]::Instance)
        $letters   = [System.Collections.Generic.List[object]]::new()
        $wordRecs  = [System.Collections.Generic.List[object]]::new()
        $blockRecs = [System.Collections.Generic.List[object]]::new()
        $pathRecs  = [System.Collections.Generic.List[object]]::new()
        $xobjRecs  = [System.Collections.Generic.List[object]]::new()   # LANE 5: placed bitmap rectangles
        $fontCensus = @{}    # stripped name -> @{ family; role; sizes(HashSet); count }
        $famSeen    = @{}    # family -> $true (for origin evidence)
        $pageStats  = [System.Collections.Generic.List[object]]::new()
        $flags      = [System.Collections.Generic.List[object]]::new()
        $lettersTotal = 0; $unknownRole = 0; $unmapped = 0; $invisible = 0
        $blocksTotal = 0; $blocksConfident = 0
        $lid = 0; $wid = 0; $bid = 0; $lnid = 0; $vpid = 0; $xid = 0   # vpid: $pid is a PS automatic (read-only) var

        foreach ($pn in $pageList) {
            $page = $doc.GetPage($pn)
            $pl = $page.Letters
            $orient = @{}; $modes = @{}
            # letter object → global id, for back-ref filling from lanes 2/3 (reference equality:
            # Letter doesn't override Equals; DLA hands back the same instances)
            $refMap = [System.Collections.Generic.Dictionary[object,int]]::new([System.Collections.Generic.ReferenceEqualityComparer]::Instance)

            # ── LANE 1: letters (hot loop: cached font/color resolution, hashtable records,
            #    no per-letter function calls — low-level per the repo's engine-code discipline) ─
            foreach ($lt in $pl) {
                $rawName = $lt.FontName ?? ''
                $fc = $resolveCache[$rawName]
                if ($null -eq $fc) {
                    $stripped0 = Get-FontSubsetStripped $rawName
                    $fam0 = Resolve-Family $stripped0
                    $fc = @{ stripped=$stripped0; family=$fam0.family; role=$fam0.role; bold=(Test-BoldByName $stripped0) }
                    $resolveCache[$rawName] = $fc
                }
                $stripped = $fc.stripped

                if (-not $fontCensus.ContainsKey($stripped)) {
                    $fontCensus[$stripped] = @{ family=$fc.family; role=$fc.role;
                                                sizes=[System.Collections.Generic.HashSet[double]]::new(); count=0 }
                }
                $c = $fontCensus[$stripped]
                $sz = [math]::Round($lt.PointSize,1)
                [void]$c.sizes.Add($sz); $c.count++
                $famSeen[$fc.family] = $true

                $lettersTotal++
                if ($fc.family -eq 'unknown') { $unknownRole++ }
                $txt = $lt.Value
                if ($txt -and $txt.Contains([char]0xFFFD)) { $unmapped++ }
                $rm = [string]$lt.RenderingMode
                if ($rm -eq 'NeitherClip' -or $rm -eq 'Neither') { $invisible++ }
                $ori = [string]$lt.TextOrientation
                $orient[$ori] = 1 + ($orient[$ori] ?? 0)
                $modes[$rm] = 1 + ($modes[$rm] ?? 0)

                $col = $lt.Color
                $hex = $null
                if ($null -ne $col -and -not $colorCache.TryGetValue($col, [ref]$hex)) {
                    $hex = ConvertTo-HexColor $col
                    $colorCache[$col] = $hex
                }

                $bb = $lt.BoundingBox
                $letters.Add([ordered]@{
                    id     = $lid
                    page   = $pn
                    seq    = $lt.TextSequence
                    text   = $txt
                    bx     = @([math]::Round($bb.Left,2),[math]::Round($bb.Bottom,2),[math]::Round($bb.Right,2),[math]::Round($bb.Top,2))
                    base   = @([math]::Round($lt.StartBaseLine.X,2),[math]::Round($lt.StartBaseLine.Y,2))
                    ebase  = @([math]::Round($lt.EndBaseLine.X,2),[math]::Round($lt.EndBaseLine.Y,2))
                    size   = $sz
                    font   = $stripped
                    family = $fc.family
                    italic = [bool]$lt.FontDetails.IsItalic
                    bold_name = $fc.bold
                    wadv   = [math]::Round($lt.Width,2)
                    render = $rm
                    orient = $ori
                    color  = $hex
                    block  = $null; line = $null; word = $null
                })
                $refMap[$lt] = $lid
                $lid++
            }

            # ── LANE 2: words (NearestNeighbour) ─────────────────────────────────────────────
            # typed list — GetBlocks(IEnumerable<Word>) will not bind a List[object] from PS
            $pageWords = [System.Collections.Generic.List[UglyToad.PdfPig.Content.Word]]::new()
            $wordIdMap = [System.Collections.Generic.Dictionary[object,int]]::new([System.Collections.Generic.ReferenceEqualityComparer]::Instance)
            if ($pl.Count -gt 0) {
                foreach ($w in $page.GetWords($nnExtractor)) { $pageWords.Add($w) }
                # canonical word order: NN extraction parallelizes internally and emits words in
                # NONDETERMINISTIC order across runs — sort by first-letter content position so
                # the lanes are regenerable and version-diffable (byte-identical re-runs)
                if ($pageWords.Count -gt 1) {
                    $wArr = $pageWords.ToArray()
                    $wKeys = [int[]]::new($wArr.Length)
                    for ($wi = 0; $wi -lt $wArr.Length; $wi++) { $wKeys[$wi] = $refMap[$wArr[$wi].Letters[0]] }
                    [Array]::Sort($wKeys, $wArr)
                    $pageWords.Clear(); $pageWords.AddRange($wArr)
                }
                foreach ($w in $pageWords) {
                    $letterIds = [System.Collections.Generic.List[int]]::new()
                    foreach ($wl in $w.Letters) {
                        $i = 0
                        if ($refMap.TryGetValue($wl, [ref]$i)) {
                            $letterIds.Add($i)
                            $letters[$i].word = $wid
                        }
                    }
                    $wordRecs.Add([ordered]@{
                        id = $wid; page = $pn; text = $w.Text
                        bx = (ConvertTo-BxArray $w.BoundingBox)
                        font = (Get-FontSubsetStripped $w.FontName)
                        orient = [string]$w.TextOrientation
                        letters = $letterIds.ToArray()
                        block = $null; line = $null
                    })
                    $wordIdMap[$w] = $wid
                    $wid++
                }
            }

            # ── LANE 3: blocks (XYCut) + reading order — the CLAIM lane ──────────────────────
            $pageBlockRecs = [System.Collections.Generic.List[object]]::new()
            if ($pageWords.Count -gt 0) {
                try {
                    $blocks = $segmenter.GetBlocks($pageWords)
                    $ordered = @($roDetector.Get($blocks))
                    $ro = 0
                    foreach ($b in $ordered) {
                        $lineRecs = [System.Collections.Generic.List[object]]::new()
                        $lineTexts = [System.Collections.Generic.List[string]]::new()
                        foreach ($tl in $b.TextLines) {
                            $lineWordIds = [System.Collections.Generic.List[int]]::new()
                            $lineFonts = [System.Collections.Generic.List[string]]::new()
                            $lineSizes = [System.Collections.Generic.List[double]]::new()
                            foreach ($lw in $tl.Words) {
                                $i = 0
                                if ($wordIdMap.TryGetValue($lw, [ref]$i)) {
                                    $lineWordIds.Add($i)
                                    $wordRecs[$i].block = $bid
                                    $wordRecs[$i].line  = $lnid
                                    foreach ($li in $wordRecs[$i].letters) {
                                        $letters[$li].block = $bid
                                        $letters[$li].line  = $lnid
                                        $lineFonts.Add($letters[$li].font)
                                        $lineSizes.Add($letters[$li].size)
                                    }
                                }
                            }
                            $lineRecs.Add([ordered]@{
                                id = $lnid
                                bx = (ConvertTo-BxArray $tl.BoundingBox)
                                text = $tl.Text
                                words = $lineWordIds.ToArray()
                                modal_font = (Get-Modal $lineFonts)
                                modal_size = [double](Get-Modal $lineSizes)
                            })
                            $lineTexts.Add([string]$tl.Text)
                            $lnid++
                        }
                        $blockJoin = Join-PdfDigTextLines -LineTexts $lineTexts.ToArray()
                        $blockText = $blockJoin.text
                        $preview = if ($blockText.Length -gt 100) { $blockText.Substring(0,100) } else { $blockText }
                        $rec = [ordered]@{
                            id = $bid; page = $pn
                            bx = (ConvertTo-BxArray $b.BoundingBox)
                            segmenter = 'xycut'; reading_order = $ro
                            column_band = $null
                            lines = $lineRecs.ToArray()
                            text_preview = $preview
                            # full block text (whitespace-normalized, UNtruncated) — captions and any consumer
                            # that quotes a block verbatim need more than the 100-char preview (the truncated-
                            # caption defect the finalize weave's render surfaced, 2026-07-07)
                            text = $blockText
                        }
                        if ($blockJoin.dehyphenated) { $rec['dehyphenated'] = $true }
                        $blockRecs.Add($rec); $pageBlockRecs.Add($rec)
                        $bid++; $ro++
                    }
                    Get-ColumnBands $pageBlockRecs.ToArray()
                    foreach ($b in $pageBlockRecs) {
                        $blocksTotal++
                        if ($null -ne $b.column_band) { $blocksConfident++ }
                    }
                } catch {
                    $flags.Add([ordered]@{ code='segmenter_error'; detail="page ${pn}: $($_.Exception.Message)" })
                }
            }

            # ── LANE 4: vector paths ─────────────────────────────────────────────────────────
            foreach ($path in $page.Paths) {
                $bx = $null; $bxSource = $null
                # PS AUTO-UNWRAPS Nullable<T> returns: $null when empty, bare PdfRectangle when present.
                # Never test .HasValue on the result — it is always $null on the unwrapped struct and
                # silently reads as false (the probe-3 lesson, capability map §5).
                $api = $path.GetBoundingRectangle()
                if ($null -ne $api) {
                    $bx = ConvertTo-BxArray $api; $bxSource = 'api'
                } else {
                    $bx = Get-PathCommandBbox $path
                    if ($null -ne $bx) { $bxSource = 'commands' }  # conservative: control points included
                }
                $kinds = [System.Collections.Generic.HashSet[string]]::new()
                foreach ($sp in $path) {
                    foreach ($cmd in $sp.Commands) {
                        $k = $cmd.GetType().Name.ToLowerInvariant()
                        if ($k -notin 'move','close') { [void]$kinds.Add($k) }
                    }
                }
                $rule = $null
                if ($null -ne $bx -and -not $kinds.Contains('cubicbeziercurve')) {
                    $rc = $script:ClassifyConfig.rules
                    $w = $bx[2] - $bx[0]; $h = $bx[3] - $bx[1]
                    if ($h -le $rc.max_thickness_pt -and $w -gt $rc.min_length_pt) { $rule = 'hrule' }
                    elseif ($w -le $rc.max_thickness_pt -and $h -gt $rc.min_length_pt) { $rule = 'vrule' }
                }
                $pathRecs.Add([ordered]@{
                    id = $vpid; page = $pn
                    is_clipping = $path.IsClipping; is_filled = $path.IsFilled; is_stroked = $path.IsStroked
                    line_width = [math]::Round($path.LineWidth, 2)
                    subpaths = $path.Count
                    kinds = @($kinds)
                    bbox = $bx; bbox_source = $bxSource
                    rule = $rule
                })
                $vpid++
            }

            # ── LANE 5: xobject images ───────────────────────────────────────────────────────
            # placed bitmap rectangles (IPdfImage.Bounds — the post-transform page-coordinate rect,
            # exactly the clustering input; the raw image matrix is unnecessary). The raster figures the
            # vector lanes are blind to. One record per GetImages() image; NOT injected into paths.jsonl
            # (that lane's contract is pure vector). The envelope's per-page `images` already COUNTS these
            # (below); this lane adds their GEOMETRY so a bitmap becomes a first-class clustered point.
            foreach ($img in $page.GetImages()) {
                $xobjRecs.Add([ordered]@{
                    id = $xid; page = $pn
                    bbox = (ConvertTo-BxArray $img.Bounds)
                    kind = 'image'
                })
                $xid++
            }

            $pageStats.Add([ordered]@{
                n=$pn; w=[math]::Round($page.Width,1); h=[math]::Round($page.Height,1)
                rotation=$page.Rotation.Value; letters=$pl.Count
                words=$pageWords.Count; blocks=$pageBlockRecs.Count; segmenter='xycut'
                paths=$page.Paths.Count; images=@($page.GetImages()).Count
                orientations=$orient; render_modes=$modes
            })
        }

        $origin = Get-OriginVerdict $producer $creator $famSeen

        $fonts = foreach ($k in ($fontCensus.Keys | Sort-Object)) {
            $c = $fontCensus[$k]
            [ordered]@{ name=$k; family=$c.family; role_hint=$c.role
                        sizes=@($c.sizes | Sort-Object -Descending); letters=$c.count }
        }

        if ($origin.rewriter) {
            $flags.Add([ordered]@{ code='producer_rewritten'; detail="producer '$producer' is a rewriter ($($origin.rewriter)); origin resolved via cue '$($origin.cue)'" })
        } elseif ($origin.cue -eq 'fonts') {
            $flags.Add([ordered]@{ code='producer_unrecognized'; detail="producer '$producer' matched no store entry; origin inferred from fonts" })
        }
        if ($unmapped -gt 0) { $flags.Add([ordered]@{ code='unmapped_symbol'; detail="$unmapped letter(s) carry U+FFFD" }) }
        if ($unknownRole -gt 0) { $flags.Add([ordered]@{ code='unknown_font_role'; detail="$unknownRole letter(s) in fonts with no family match" }) }

        $health = [ordered]@{
            letters_total        = $lettersTotal
            known_font_role_frac = if ($lettersTotal) { [math]::Round(1 - $unknownRole/$lettersTotal, 4) } else { $null }
            unmapped_symbol_count= $unmapped
            invisible_letter_frac= if ($lettersTotal) { [math]::Round($invisible/$lettersTotal, 4) } else { 0 }
            columns_confident_frac = if ($blocksTotal) { [math]::Round($blocksConfident/$blocksTotal, 4) } else { $null }
            flags_per_page       = if ($pageList.Count) { [math]::Round($flags.Count/$pageList.Count, 3) } else { 0 }
            domain               = switch ($origin.tag) {
                                       'tex'     { 'tex-origin' }
                                       'unknown' { 'unknown' }
                                       default   { 'office' }    # positive non-TeX producer tag (adobe/word/indesign/…)
                                   }
        }

        $envelope = [ordered]@{
            schema = 'pdfdig-ir/1'
            source = [ordered]@{ pdf=[System.IO.Path]::GetFileName($PdfPath); slug=$slug; bytes=$bytes; sha256=$sha }
            engine = [ordered]@{ name='pdfdig-ps'; version=$EngineVersion; pdfpig='0.1.14'
                                 config_hash=$script:ClassifyConfigHash
                                 run_utc=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
            document = [ordered]@{
                pages=$doc.NumberOfPages; version=$version; encrypted=$doc.IsEncrypted
                producer=$producer; creator=$creator; title=$title; author=$author
                origin=$origin
                has_struct_tree = ($doc.GetPage($pageList[0]).GetMarkedContents().Count -gt 0)
                has_xmp=$hasXmp; has_bookmarks=$false
            }
            bookmarks = (Get-Bookmarks $doc)
            fonts     = @($fonts)
            pages     = @($pageStats)
            health    = $health
            flags     = @($flags)
        }
        $envelope.document.has_bookmarks = ($envelope.bookmarks.Count -gt 0)

        # ── write ────────────────────────────────────────────────────────────────────────────
        $outputs = [ordered]@{}
        $lanes = @(
            @{ name='letters';  recs=$letters },
            @{ name='words';    recs=$wordRecs },
            @{ name='blocks';   recs=$blockRecs },
            @{ name='paths';    recs=$pathRecs },
            @{ name='xobjects'; recs=$xobjRecs }   # LANE 5 (NOT 'images' — that's the MuPDF render manifest)
        )
        foreach ($lane in $lanes) {
            $p = Join-Path $OutDir "$slug.$($lane.name).jsonl"
            Write-JsonlStage -Records $lane.recs.ToArray() -OutputPath $p -SourcePath $PdfPath -Stage "pdfdig-ir/$($lane.name)" | Out-Null
            $outputs[$lane.name] = $p
        }
        $envPath = Join-Path $OutDir "$slug.pdfdig.json"
        [System.IO.File]::WriteAllText($envPath, ($envelope | ConvertTo-Json -Depth 12), [System.Text.UTF8Encoding]::new($false))

        [pscustomobject]@{
            Slug = $slug; Envelope = $envPath
            Letters = $letters.Count; Words = $wordRecs.Count; Blocks = $blockRecs.Count; Paths = $pathRecs.Count; Xobjects = $xobjRecs.Count
            Pages = $pageList.Count
            Origin = "$($origin.tag) (cue=$($origin.cue))"; Fonts = @($fonts).Count
            Health = $health; Flags = $flags.Count
            Outputs = $outputs
        }
    } finally {
        $doc.Dispose()
    }
}
