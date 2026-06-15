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

    # running-head furniture: heading text on >= 3 distinct pages
    $headingPages = @{}
    foreach ($c in $chunks) {
        if ($c.type -eq 'heading' -and $c.content) {
            $k = Get-RunningHeadKey ([string]$c.content)
            if ($k -eq '') { continue }
            if (-not $headingPages.ContainsKey($k)) { $headingPages[$k] = [System.Collections.Generic.HashSet[int]]::new() }
            [void]$headingPages[$k].Add([int]$c.page)
        }
    }
    $runningHeads = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($k in $headingPages.Keys) { if ($headingPages[$k].Count -ge 3) { [void]$runningHeads.Add($k) } }

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

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'sections'

    $rh = @($chunks | Where-Object { $_.is_furniture -eq 'running_head' })
    "sections tagged on $($chunks.Count) chunks  (running-head furniture: $($rh.Count) chunks; unnumbered headings font-levelled: $relevelled, flagged: $flagged) -> $ChunksPath"
    "--- proto-TOC (body + back-matter section headings) ---"
    $chunks | Where-Object { $_.type -eq 'heading' -and $null -ne $_.section_level -and $_.is_furniture -ne 'running_head' } |
        ForEach-Object {
            $indent = '  ' * ([int]$_.section_level)
            "{0}{1}  [{2}]" -f $indent, (([string]$_.content).Substring(0,[Math]::Min(50,([string]$_.content).Length))), ([string]$_.section_role)
        }
    return $manifest
}
