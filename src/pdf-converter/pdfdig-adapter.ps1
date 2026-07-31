#requires -Version 7.0
<#
  src/pdfdig-adapter.ps1 — project pdfdig classified nodes into the membrane's node dialect.

  The pdfdig lane (src/pdf-converter/) emits RUN-level typed nodes ({slug}.nodes.jsonl beside the
  PDF: type prose|math-role runs|heading-candidate|formula-block|marker, with line_id/block/col,
  script sub|super, tier/outline_level, flags[]). The membrane's stages consume the docling-era
  dialect: LINE/SHARD-level nodes typed paragraph|heading|formula|image that Invoke-Collapse
  agglomerates by bbox continuity. This adapter is the TRANSITIONAL bridge (the pdfdig brief's
  "membrane-compatible IR emission"): it assembles runs into membrane nodes, spending pdfdig's
  born signals so downstream stages do not have to reverse-engineer them:

    heading-candidate lines  -> type 'heading'  (PRE-promoted: Invoke-HeadingRecovery is docling-
                                damage compensation and is SKIPPED on this lane by preprocess)
    formula-block groups     -> ONE type 'formula' node per group (lines joined; finalize wraps $$)
    prose/mono lines         -> type 'paragraph' with inline math seams ($...$, _{}/^{} from the
                                geometric script calls — content opendataloader always destroyed)
    marker lines             -> DROPPED here and counted (page furniture identified by born
                                signals — orientation/margins — not re-detected downstream)

  Ligatures/symbol corrections arrived already applied by the classifier (store-driven); U+FFFD
  and flags ride through. Nothing is silently lost: the summary counts every input node.

    . ./pdfdig-adapter.ps1
    Invoke-ProjectPdfDigNodes -PdfDigNodesPath <{slug}.nodes.jsonl> -OutputPath <run nodes.jsonl>
#>

. "$PSScriptRoot/../shared/jsonl.ps1"

# assemble one line's runs into membrane content: contiguous math runs -> $...$ seams, geometric
# sub/super -> _{}/^{}; trailing run-internal spaces migrate OUTSIDE a closing seam
function ConvertTo-SeamedText([object[]] $Runs, [bool] $DisplayMath) {
    $sb = [System.Text.StringBuilder]::new()
    $inMath = $false
    foreach ($r in $Runs) {
        $t = [string]$r.content
        $isMath = ($r.role -eq 'math')
        $frag = switch ([string]$r.script) {
            'sub'   { '_{' + $t.TrimEnd() + '}' }
            'super' { '^{' + $t.TrimEnd() + '}' }
            default { $t }
        }
        if ($DisplayMath) {
            # inside a formula node everything is already math register — no $ seams
            [void]$sb.Append($frag)
            if ($r.script -in 'sub','super' -and $t.EndsWith(' ')) { [void]$sb.Append(' ') }
            continue
        }
        if ($isMath -and -not $inMath) { [void]$sb.Append('$'); $inMath = $true }
        elseif (-not $isMath -and $inMath) {
            # close the seam BEFORE this prose run; a math tail space belongs outside the $
            $s = $sb.ToString()
            if ($s.EndsWith(' ')) { [void]$sb.Remove($sb.Length - 1, 1); [void]$sb.Append('$ ') }
            else { [void]$sb.Append('$') }
            $inMath = $false
        }
        [void]$sb.Append($frag)
        if ($r.script -in 'sub','super' -and $t.EndsWith(' ') -and -not $DisplayMath) { [void]$sb.Append(' ') }
    }
    if ($inMath) {
        $s = $sb.ToString()
        if ($s.EndsWith(' ')) { [void]$sb.Remove($sb.Length - 1, 1); [void]$sb.Append('$ ') }
        else { [void]$sb.Append('$') }
    }
    return $sb.ToString()
}

function Merge-RunBbox([object[]] $Runs) {
    $l=[double]::MaxValue; $b=[double]::MaxValue; $r=[double]::MinValue; $t=[double]::MinValue
    foreach ($run in $Runs) {
        $bx = $run.'bounding box'
        if (-not $bx -or $bx.Count -ne 4) { continue }
        if ($bx[0] -lt $l) { $l = $bx[0] }; if ($bx[1] -lt $b) { $b = $bx[1] }
        if ($bx[2] -gt $r) { $r = $bx[2] }; if ($bx[3] -gt $t) { $t = $bx[3] }
    }
    if ($r -lt $l) { return $null }
    return @($l, $b, $r, $t)
}

function Invoke-ProjectPdfDigNodes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $PdfDigNodesPath,
        [Parameter(Mandatory)] [string] $OutputPath,
        [string] $SourcePath   # provenance for the .sig (defaults to the pdfdig nodes lane)
    )
    if (-not $SourcePath) { $SourcePath = $PdfDigNodesPath }

    # read run-nodes (already in resolved reading order; ids sequential)
    $runs = [System.Collections.Generic.List[object]]::new(32768)
    foreach ($l in [System.IO.File]::ReadAllLines($PdfDigNodesPath)) {
        if (-not [string]::IsNullOrWhiteSpace($l)) { $runs.Add((ConvertFrom-Json -InputObject $l -AsHashtable)) }
    }

    # CAPTION PRE-TYPING (the caption-weld fix, tier3-engineering-plan.md render-harvest): the pig
    # figure lane already KNOWS which Lane-3 blocks are captions (figures.jsonl caption.block_id — the
    # attachment is geometric+cue evidence, not string matching). Spend that born signal here: lines
    # belonging to a caption block emit as ONE standalone type='caption' node instead of paragraph
    # shards, so collapse can never agglomerate a caption into the preceding prose ("…SSIM (bottom)
    # overFigure 2: …", 2008.10579v1 chunk 342) and normalize/finalize see it as caption furniture
    # born-typed. Same idiom as pre-typed headings. Absent figures lane ⇒ behavior unchanged.
    $captionBlocks = @{}
    $figJsonl = Join-Path (Split-Path $PdfDigNodesPath -Parent) ((Split-Path -Leaf $PdfDigNodesPath) -replace '\.nodes\.jsonl$', '.figures.jsonl')
    if (Test-Path -LiteralPath $figJsonl) {
        foreach ($l in [System.IO.File]::ReadLines($figJsonl)) {
            if ([string]::IsNullOrWhiteSpace($l)) { continue }
            $f = ConvertFrom-Json -InputObject $l
            if ($f.caption -and $null -ne $f.caption.block_id) { $captionBlocks[[int]$f.caption.block_id] = $true }
        }
    }

    # group consecutive runs into LINES (line_id when present; orphans key on page+baseline)
    $lines = [System.Collections.Generic.List[object]]::new(8192)
    $cur = $null; $curKey = $null
    foreach ($r in $runs) {
        $key = if ($null -ne $r.line_id) { "L$($r.line_id)" } else { "O$($r.page):$($r.baseline_y)" }
        if ($key -ne $curKey) {
            if ($cur) { $lines.Add($cur) }
            $cur = [System.Collections.Generic.List[object]]::new(8)
            $curKey = $key
        }
        $cur.Add($r)
    }
    if ($cur) { $lines.Add($cur) }

    # max run font size on a line (title = the doc's largest; carried so zones picks the title by
    # typography, not just reading order)
    $lineFontSize = {
        param($runsArr)
        $mx = 0.0
        foreach ($r in $runsArr) { $s = [double]$r.'font size'; if ($s -gt $mx) { $mx = $s } }
        if ($mx -gt 0) { $mx } else { $null }
    }

    # emit membrane nodes: paragraph | heading | formula (grouped) — markers dropped + counted
    $out = [System.Collections.Generic.List[object]]::new(8192)
    $id = 0
    $markersDropped = 0; $flagged = 0; $formulaLines = 0
    $counts = @{ paragraph = 0; heading = 0; formula = 0; caption = 0 }
    $captionOpen = $null   # @{ block; page; runs; contentLines; flags } — a caption block's wrapped lines merge
    $formulaOpen = $null   # @{ group; content(List); runs(List) } — consecutive same-group lines merge
    # @{ key; page; level; runs; contentLines; flags } — consecutive lines sharing a merge key
    # (same outline entry, or the tier-0 title) are physical wraps of ONE logical heading
    $headingOpen = $null

    $closeFormula = {
        if ($null -ne $formulaOpen) {
            $out.Add([ordered]@{
                id = $id; type = 'formula'; page = $formulaOpen.page
                bbox = (Merge-RunBbox $formulaOpen.runs.ToArray())
                content = ($formulaOpen.content -join "`n")
                flags = @($formulaOpen.flags)   # SortedSet: ordered, deduped, NO pipeline (wrap-free)
            })
            $counts.formula++
        }
    }
    $closeCaption = {
        if ($null -ne $captionOpen) {
            $out.Add([ordered]@{
                id = $id; type = 'caption'; page = $captionOpen.page
                bbox = (Merge-RunBbox $captionOpen.runs.ToArray())
                content = ($captionOpen.contentLines -join ' ')   # wrapped caption lines rejoin with a space
                flags = @($captionOpen.flags)
            })
            $counts.caption++
        }
    }
    $closeHeading = {
        if ($null -ne $headingOpen) {
            # a lone outline_fragment (reverse-only bookmark match that never merged with a sibling
            # wrap line) is a spurious match — demote it to prose rather than emit a phantom heading
            $lone = ($headingOpen.contentLines.Count -eq 1 -and $headingOpen.flags.Contains('outline_fragment'))
            $bx = (Merge-RunBbox $headingOpen.runs.ToArray())
            $content = ($headingOpen.contentLines -join ' ')   # wrapped physical lines rejoin with a space
            $fsz = (& $lineFontSize $headingOpen.runs.ToArray())
            if ($lone) {
                $out.Add([ordered]@{ id = $id; type = 'paragraph'; page = $headingOpen.page
                    bbox = $bx; content = $content; font_size = $fsz; flags = @($headingOpen.flags) })
                $counts.paragraph++
            } else {
                $out.Add([ordered]@{ id = $id; type = 'heading'; page = $headingOpen.page
                    bbox = $bx; content = $content; heading_level = $headingOpen.level
                    font_size = $fsz; flags = @($headingOpen.flags) })
                $counts.heading++
            }
        }
    }

    foreach ($ln in $lines) {
        $first = $ln[0]
        $ltype = [string]$first.type
        $lineFlags = [System.Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)   # sorted = deterministic emission
        foreach ($r in $ln) { foreach ($f in $r.flags) { [void]$lineFlags.Add([string]$f) } }
        if ($lineFlags.Count -gt 0) { $flagged++ }

        # caption-block lines intercept FIRST (born signal beats line type): consecutive lines of one
        # caption block fuse into a single standalone caption node
        $blkId = if ($null -ne $first.block) { [int]$first.block } else { -1 }
        if ($blkId -ge 0 -and $captionBlocks.ContainsKey($blkId)) {
            & $closeFormula; if ($null -ne $formulaOpen) { $id++; $formulaOpen = $null }
            & $closeHeading; if ($null -ne $headingOpen) { $id++; $headingOpen = $null }
            $seamed = ConvertTo-SeamedText $ln.ToArray() $false
            if ($null -ne $captionOpen -and $captionOpen.block -eq $blkId) {
                $captionOpen.runs.AddRange($ln)
                $captionOpen.contentLines.Add($seamed)
                foreach ($f in $lineFlags) { [void]$captionOpen.flags.Add($f) }
                continue
            }
            & $closeCaption; if ($null -ne $captionOpen) { $id++ }
            $captionOpen = @{
                block = $blkId; page = $first.page
                runs = [System.Collections.Generic.List[object]]::new()
                contentLines = [System.Collections.Generic.List[string]]::new()
                flags = [System.Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
            }
            $captionOpen.runs.AddRange($ln)
            $captionOpen.contentLines.Add($seamed)
            foreach ($f in $lineFlags) { [void]$captionOpen.flags.Add($f) }
            [void]$captionOpen.flags.Add('pig_caption')
            continue
        }
        & $closeCaption; if ($null -ne $captionOpen) { $id++; $captionOpen = $null }

        if ($ltype -eq 'marker') {
            & $closeFormula; if ($null -ne $formulaOpen) { $id++; $formulaOpen = $null }
            & $closeHeading; if ($null -ne $headingOpen) { $id++; $headingOpen = $null }
            $markersDropped++; continue
        }

        if ($ltype -eq 'formula-block') {
            & $closeHeading; if ($null -ne $headingOpen) { $id++; $headingOpen = $null }
            $formulaLines++
            $g = $first.formula_group
            if ($null -ne $formulaOpen -and $formulaOpen.group -eq $g) {
                $formulaOpen.content.Add((ConvertTo-SeamedText $ln.ToArray() $true))
                $formulaOpen.runs.AddRange($ln)
                foreach ($f in $lineFlags) { [void]$formulaOpen.flags.Add($f) }
                continue
            }
            & $closeFormula; if ($null -ne $formulaOpen) { $id++ }
            $formulaOpen = @{
                group = $g; page = $first.page
                content = [System.Collections.Generic.List[string]]::new()
                runs = [System.Collections.Generic.List[object]]::new()
                flags = [System.Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
            }
            $formulaOpen.content.Add((ConvertTo-SeamedText $ln.ToArray() $true))
            $formulaOpen.runs.AddRange($ln)
            foreach ($f in $lineFlags) { [void]$formulaOpen.flags.Add($f) }
            continue
        }
        & $closeFormula; if ($null -ne $formulaOpen) { $id++; $formulaOpen = $null }

        if ($ltype -eq 'heading-candidate') {
            # heading_level: the PDF outline is authoritative when it matched; else fall back to the
            # typographic tier (0=title/largest .. bold-body run-in = deepest), clamped to md's H1..H6.
            # This is the "outline knows the true depth" fix for -Medi run-in over-promotion.
            $hl = $null
            if ($null -ne $first.outline_level) { $hl = [int]$first.outline_level + 1 }
            elseif ($null -ne $first.tier)      { $hl = [math]::Min(6, [int]$first.tier + 1) }
            $tier = if ($null -ne $first.tier) { [int]$first.tier } else { -1 }

            # merge key: a wrapped heading's physical lines share ONE key and re-fuse. Same outline
            # entry (section titles that wrap mid-phrase — "…TOPOLOGICAL" / "DYNAMICS"), or the
            # tier-0 title (unique-largest font, no outline entry). A null key = standalone: author
            # blocks / run-in bold heads (same tier but distinct lines) must NOT fuse.
            $mergeKey = if ($null -ne $first.outline_ref) { "ol:$($first.outline_ref)" }
                        elseif ($tier -eq 0) { "title:$($first.page)" }
                        else { $null }
            $seamed = ConvertTo-SeamedText $ln.ToArray() $false

            if ($null -ne $mergeKey -and $null -ne $headingOpen -and $headingOpen.key -eq $mergeKey -and $headingOpen.page -eq $first.page) {
                $headingOpen.runs.AddRange($ln)
                $headingOpen.contentLines.Add($seamed)
                if ($null -ne $hl -and ($null -eq $headingOpen.level -or $hl -lt $headingOpen.level)) { $headingOpen.level = $hl }
                foreach ($f in $lineFlags) { [void]$headingOpen.flags.Add($f) }
                continue
            }
            & $closeHeading; if ($null -ne $headingOpen) { $id++; $headingOpen = $null }
            $newHead = @{
                key = $mergeKey; page = $first.page; level = $hl
                runs = [System.Collections.Generic.List[object]]::new()
                contentLines = [System.Collections.Generic.List[string]]::new()
                flags = [System.Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
            }
            $newHead.runs.AddRange($ln); $newHead.contentLines.Add($seamed)
            foreach ($f in $lineFlags) { [void]$newHead.flags.Add($f) }
            if ($null -eq $mergeKey) {
                # standalone: emit immediately, don't hold open (never merges with a neighbor)
                $headingOpen = $newHead; & $closeHeading; $id++; $headingOpen = $null
            } else {
                $headingOpen = $newHead
            }
            continue
        }
        & $closeHeading; if ($null -ne $headingOpen) { $id++; $headingOpen = $null }

        # prose / anything else -> paragraph shard (collapse agglomerates by bbox continuity)
        $out.Add([ordered]@{
            id = $id; type = 'paragraph'; page = $first.page
            bbox = (Merge-RunBbox $ln.ToArray())
            content = (ConvertTo-SeamedText $ln.ToArray() $false)
            font_size = (& $lineFontSize $ln.ToArray())
            flags = @($lineFlags)
        })
        $counts.paragraph++; $id++
    }
    & $closeFormula; if ($null -ne $formulaOpen) { $id++; $formulaOpen = $null }
    & $closeHeading; if ($null -ne $headingOpen) { $id++; $headingOpen = $null }
    & $closeCaption; if ($null -ne $captionOpen) { $id++; $captionOpen = $null }

    $null = Write-JsonlStage -Records $out.ToArray() -OutputPath $OutputPath -SourcePath $SourcePath -Stage 'pdfdig-adapter'

    [pscustomobject]@{
        Nodes = $out.Count
        Lines = $lines.Count
        Paragraphs = $counts.paragraph; Headings = $counts.heading
        Formulas = $counts.formula; FormulaLines = $formulaLines   # nodes group; lines are the input tally
        Captions = $counts.caption   # born-typed from the pig figure lane's caption block ids
        MarkersDropped = $markersDropped
        FlaggedLines = $flagged
    }
}
