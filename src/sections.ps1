#requires -Version 7.0
<#
  src/sections.ps1 — section segmentation + role classification (the proto-TOC).

  Operates on the body + back-matter zones (front-matter is handled by zones.ps1).
  Each real section heading starts a section; every chunk gets its enclosing
  top-level `section`, and each heading gets a `section_level` (nesting depth from
  its number) and a `section_role` classified from canonical vocab (introduction /
  background / methods / results / discussion / conclusion / references /
  acknowledgments / appendix; null for topic-specific sections).

  Running-head furniture is handled here, where it would otherwise spawn phantom
  sections: a *heading-typed* chunk whose text repeats on >= 3 pages is tagged
  is_furniture='running_head' and excluded from sectioning. Restricting to headings
  avoids grabbing the paragraph-typed figure debris that also repeats.

    . ./sections.ps1
    Invoke-Sections -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>]
#>

. "$PSScriptRoot/jsonl.ps1"

function Get-SectionRole([string]$heading) {
    $h = ($heading -replace '^\s*[\d.]+\s*', '').Trim()
    switch -Regex ($h) {
        '(?i)^introduction'                        { return 'introduction' }
        '(?i)related work|^background|preliminar'   { return 'background' }
        '(?i)^discussion'                          { return 'discussion' }
        '(?i)conclu'                               { return 'conclusion' }
        '(?i)^results|experiment|evaluat|numerical' { return 'results' }
        '(?i)^method|^approach|algorithm'          { return 'methods' }
        '(?i)^references|bibliography'             { return 'references' }
        '(?i)acknowledg'                           { return 'acknowledgments' }
        '(?i)^appendix'                            { return 'appendix' }
        default                                     { return $null }
    }
}

# Depth from the heading's own number, plus whether that number existed. Numeric "2.2.1"
# -> depth 3; appendix-style "A.1" / "B.3.2" -> 1 + dotted depth (a lone "A Supplementary"
# has no dotted number, so it falls through to the font pass, which avoids mistaking a section
# that merely opens with "A " for an appendix). numbered=$false marks a provisional level the
# font-calibration pass is free to overwrite.
function Get-SectionLevel([string]$heading) {
    if ($heading -match '^\s*(\d+(?:\.\d+)*)(?:\s|$|[.:])') {
        return @{ level = @($Matches[1] -split '\.').Count; numbered = $true }
    }
    if ($heading -match '^\s*[A-Z](?:\.\d+)+(?:\s|$|[.:])') {
        return @{ level = 1 + @([regex]::Matches($Matches[0], '\.\d+')).Count; numbered = $true }
    }
    return @{ level = 1; numbered = $false }
}

# Normalize a heading for running-head detection: strip a page number from either end
# (recto "TITLE 3" / verso "2 AUTHORS") and collapse whitespace, so the per-page copies
# group as one running head. A pure-number heading (a bare page number) -> empty key.
function Get-RunningHeadKey([string]$content) {
    $s = ($content -replace '^\s*\d+\s+', '') -replace '\s+\d+\s*$', ''
    $s = ($s -replace '\s+', ' ').Trim().ToLowerInvariant()
    if ($s -match '^\d*$') { return '' }
    return $s
}

# A block label (Theorem 2.1, Lemma 3.3, Proof, ...) is body content, not a section —
# heading recovery promotes these to headings on their face, so guard them out of the
# proto-TOC here. They keep their enclosing `section` but get no `section_level`.
function Test-BlockLabel([string]$heading) {
    return [bool]($heading -match '(?i)^\s*(theorem|lemma|proof|corollary|proposition|definition|remark|example|claim|fact|conjecture|notation|assumption|observation)\b')
}

function Invoke-Sections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ChunksPath,
        [string] $NodesPath
    )

    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    # heading furniture, two kinds: running heads (heading text on >= 3 distinct pages) and figure
    # labels (a heading text repeated >= 2 times). A real section heading is unique, so any repeat is
    # panel/legend text the struct-tree mis-typed as a heading — running-head's >=3-page rule misses
    # these because multi-panel labels repeat on a SINGLE page.
    $headingPages = @{}; $headingCount = @{}
    foreach ($c in $chunks) {
        if ($c.type -eq 'heading' -and $c.content) {
            $k = Get-RunningHeadKey ([string]$c.content)
            if ($k -eq '') { continue }
            if (-not $headingPages.ContainsKey($k)) { $headingPages[$k] = [System.Collections.Generic.HashSet[int]]::new(); $headingCount[$k] = 0 }
            [void]$headingPages[$k].Add([int]$c.page)
            $headingCount[$k]++
        }
    }
    $runningHeads = [System.Collections.Generic.HashSet[string]]::new()
    $repeatedHeads = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($k in $headingPages.Keys) {
        if ($headingPages[$k].Count -ge 3) { [void]$runningHeads.Add($k) }
        elseif ($headingCount[$k] -ge 2)   { [void]$repeatedHeads.Add($k) }
    }

    # sectioning walk over body + back-matter
    $currentSection = $null
    foreach ($c in $chunks) {
        if ($c.zone -eq 'frontmatter') { continue }
        if ($c.type -eq 'heading' -and $c.content) {
            $key = Get-RunningHeadKey ([string]$c.content)
            if ($key -eq '' -or $runningHeads.Contains($key)) {
                $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'running_head' -Force
                continue
            }
            # a repeated heading that isn't numbered is a panel/legend label, not a section
            if ($repeatedHeads.Contains($key) -and -not (Get-SectionLevel ([string]$c.content)).numbered) {
                $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue 'figure_label' -Force
                continue
            }
            if ($c.boilerplate_hint) { continue }   # an email/url/etc promoted on its face is not a section
            if (Test-BlockLabel ([string]$c.content)) {
                $c | Add-Member -NotePropertyName is_block -NotePropertyValue $true -Force
            }
            else {
                $role = Get-SectionRole ([string]$c.content)
                $lv   = Get-SectionLevel ([string]$c.content)
                $c | Add-Member -NotePropertyName section_role  -NotePropertyValue $role     -Force
                $c | Add-Member -NotePropertyName section_level -NotePropertyValue $lv.level  -Force
                $c | Add-Member -NotePropertyName level_source  -NotePropertyValue $(if ($lv.numbered) { 'numbered' } else { 'default' }) -Force
                if ($lv.level -eq 1) { $currentSection = [string]$c.content }
            }
        }
        if ($currentSection) { $c | Add-Member -NotePropertyName section -NotePropertyValue $currentSection -Force }
    }

    # font-calibrated leveling for unnumbered headings. The numbered headings teach a
    # font_size -> level map (their own numbers are ground truth); each unnumbered heading then
    # inherits the level of its nearest font tier. An unnumbered heading with no usable font and
    # numbered siblings to contrast against can't be placed deterministically — flag it for review
    # rather than leave it silently at the top level.
    $secHeads = @($chunks | Where-Object {
        $_.type -eq 'heading' -and $null -ne $_.section_level -and $_.is_furniture -ne 'running_head' -and -not $_.title_candidate })
    $cal = @{}
    foreach ($h in $secHeads) {
        if ($h.level_source -ne 'numbered' -or $null -eq $h.font_size) { continue }
        $sz = [math]::Round([double]$h.font_size, 1)
        if (-not $cal.ContainsKey($sz)) { $cal[$sz] = [System.Collections.Generic.List[int]]::new() }
        $cal[$sz].Add([int]$h.section_level)
    }
    $sizeLevel = @{}
    foreach ($sz in $cal.Keys) { $sizeLevel[$sz] = [int]($cal[$sz] | Group-Object | Sort-Object Count -Descending | Select-Object -First 1).Name }
    $calSizes = @($sizeLevel.Keys)
    $relevelled = 0; $flagged = 0
    foreach ($h in $secHeads) {
        if ($h.level_source -eq 'numbered') { continue }
        if ($null -ne $h.font_size -and $calSizes.Count) {
            $fs   = [double]$h.font_size
            $near = $calSizes | Sort-Object { [math]::Abs($_ - $fs) } | Select-Object -First 1
            $h.section_level = [int]$sizeLevel[$near]
            $h.level_source  = 'font'
            $relevelled++
        }
        elseif ($calSizes.Count) {
            # numbered siblings exist but there's no usable font to place this heading against —
            # record the uncertainty; fidelity (the next stage) lifts level_uncertain to needs_review.
            $h | Add-Member -NotePropertyName level_uncertain -NotePropertyValue $true -Force
            $flagged++
        }
    }

    # citation-run references: a contiguous run (>= 3) of bracketed/numbered citation chunks is the
    # bibliography even with no "References" heading (refs-in-lists, common in letter-format papers).
    # Mark them is_reference + backmatter so finalize routes them to the sidecar and the run fixes the
    # back-matter boundary. Bracketed [N]/(N) is unambiguous; bare "N." must carry a (year) to qualify
    # (so a numbered procedure list isn't mistaken for references).
    $isCite = { param($t) ($t -match '^\s*(\[\d+\]|\(\d+\))\s+\S') -or ($t -match '^\s*\d+\.\s+[A-Z]' -and $t -match '\((1[89]|20)\d{2}\)') }
    $refMarked = 0; $i = 0
    while ($i -lt $chunks.Count) {
        if (& $isCite ([string]$chunks[$i].content)) {
            $j = $i; while ($j -lt $chunks.Count -and (& $isCite ([string]$chunks[$j].content))) { $j++ }
            if (($j - $i) -ge 3) {
                for ($k = $i; $k -lt $j; $k++) {
                    $chunks[$k] | Add-Member -NotePropertyName is_reference -NotePropertyValue $true -Force
                    $chunks[$k] | Add-Member -NotePropertyName zone         -NotePropertyValue 'backmatter' -Force
                    $refMarked++
                }
            }
            $i = $j
        }
        else { $i++ }
    }

    # collapsed-frontmatter recovery: a letter-format paper with no section headings (only a title)
    # gives the zone state machine no body-start heading to trip on, so every body paragraph stays
    # zoned 'frontmatter' and finalize would render the whole intro/body above "## Contents". When
    # that collapse is detected — no chunk ever reached the body zone AND the paper carries <= 1 real
    # heading (the title) — re-establish the front->body boundary heuristically: front matter is the
    # title plus the contiguous leading byline/affiliation/abstract block; everything after it (and not
    # already routed to the citation-run backmatter) becomes body. Gated tightly so papers that DO
    # carry section headings keep the boundary the state machine already placed.
    #
    # Scope note: the byline/affiliation and abstract frequently fuse into ONE chunk here (collapse
    # merges adjacent paragraphs by bbox proximity, ignoring font-size — e.g. BWD1996 fuses the 10.5pt
    # byline, the 9.5pt affiliation, and the 9.5pt abstract). Splitting that block so the abstract
    # becomes its own "## Abstract" section is deliberately NOT done here: the abstract is detectable by
    # typography, but the byline|abstract seam itself carries no typographic signal (same font, adjacent,
    # no gap) — only content patterns, which would be brittle venue-specific magic strings. That seam is
    # a semantic call, deferred to the membrane/content tier (split_chunk / retype_chunk), which reads
    # the text. The whole fused block therefore rests in frontmatter, which is correct for the byline.
    $demoted = 0
    $realHeads = @($chunks | Where-Object {
        $_.type -eq 'heading' -and $_.is_furniture -notin 'running_head','figure_label' -and -not $_.boilerplate_hint })
    $hasBody = [bool]@($chunks | Where-Object { $_.zone -eq 'body' }).Count
    if (-not $hasBody -and $realHeads.Count -le 1) {
        # a leading chunk is still front matter if it carries an affiliation, an editorial date, a
        # publication identifier, or an explicit Abstract label. The byline/abstract is commonly fused
        # into one chunk (as here), so this fires on it while staying silent on the first body paragraph.
        $isFrontSignal = {
            param($t)
            ($t -match '(?i)\b(department|institut|universit|laborator|college|facult|centre|center for|academ|école|hospital|school of)\b') -or
            ($t -match '(?i)\(?\s*(received|revised|accepted|submitted)\b')                                                                 -or
            ($t -match '\[\s*S?\d{4}-\d{3,4}')                                                                                              -or
            ($t -match '(?i)^\s*abstract\b')
        }
        $titleIdx = -1
        for ($t = 0; $t -lt $chunks.Count; $t++) { if ($chunks[$t].title_candidate) { $titleIdx = $t; break } }
        # contiguous leading block from just after the title: the first non-empty chunk is taken as
        # front matter (a byline is universal), then the block extends across further front-signal
        # chunks and stops at the first body paragraph. Contiguity keeps a stray "University" deep in
        # the body from dragging the boundary down.
        $lastFront = $titleIdx; $started = $false
        for ($k = $titleIdx + 1; $k -lt $chunks.Count; $k++) {
            $c = $chunks[$k]
            if ($c.is_reference -or $c.zone -ne 'frontmatter') { break }
            $txt = [string]$c.content
            if ([string]::IsNullOrWhiteSpace($txt)) { continue }
            if (-not $started)         { $lastFront = $k; $started = $true; continue }
            if (& $isFrontSignal $txt) { $lastFront = $k }
            else                       { break }
        }
        # demote every remaining frontmatter chunk after the header block to body; references (already
        # routed to backmatter by the citation-run detector) are left untouched.
        for ($k = $lastFront + 1; $k -lt $chunks.Count; $k++) {
            $c = $chunks[$k]
            if ($c.is_reference -or $c.zone -ne 'frontmatter') { continue }
            $c.zone = 'body'
            $demoted++
        }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'sections'

    $rh = @($chunks | Where-Object { $_.is_furniture -eq 'running_head' })
    "sections tagged on $($chunks.Count) chunks  (running-head furniture: $($rh.Count) chunks; unnumbered headings font-levelled: $relevelled, flagged: $flagged; references marked: $refMarked; collapsed-frontmatter body recovered: $demoted) -> $ChunksPath"
    "--- proto-TOC (body + back-matter section headings) ---"
    $chunks | Where-Object { $_.type -eq 'heading' -and $null -ne $_.section_level -and $_.is_furniture -ne 'running_head' } |
        ForEach-Object {
            $indent = '  ' * ([int]$_.section_level)
            "{0}{1}  [{2}]" -f $indent, (([string]$_.content).Substring(0,[Math]::Min(50,([string]$_.content).Length))), ([string]$_.section_role)
        }
    return $manifest
}
