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

function Get-SectionLevel([string]$heading) {
    if ($heading -match '^\s*(\d+(\.\d+)*)') {
        return @(($Matches[1] -split '\.') | Where-Object { $_ -ne '' }).Count
    }
    return 1
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
            $role  = Get-SectionRole ([string]$c.content)
            $level = Get-SectionLevel ([string]$c.content)
            $c | Add-Member -NotePropertyName section_role  -NotePropertyValue $role  -Force
            $c | Add-Member -NotePropertyName section_level -NotePropertyValue $level -Force
            if ($level -eq 1) { $currentSection = [string]$c.content }
        }
        if ($currentSection) { $c | Add-Member -NotePropertyName section -NotePropertyValue $currentSection -Force }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'sections'

    $rh = @($chunks | Where-Object { $_.is_furniture -eq 'running_head' })
    "sections tagged on $($chunks.Count) chunks  (running-head furniture: $($rh.Count) chunks) -> $ChunksPath"
    "--- proto-TOC (body + back-matter section headings) ---"
    $chunks | Where-Object { $_.type -eq 'heading' -and $null -ne $_.section_level -and $_.is_furniture -ne 'running_head' } |
        ForEach-Object {
            $indent = '  ' * ([int]$_.section_level)
            "{0}{1}  [{2}]" -f $indent, (([string]$_.content).Substring(0,[Math]::Min(50,([string]$_.content).Length))), ([string]$_.section_role)
        }
    return $manifest
}
