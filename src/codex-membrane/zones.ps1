#requires -Version 7.0
<#
  src/codex-membrane/zones.ps1 — zone segmentation + front-matter scaffolding.

  Tags each chunk with a `zone` (frontmatter / body / backmatter) from reliable
  landmarks, isolating the messy, venue-specific front/back matter into bounded
  blocks for the downstream model while leaving the clean body automatable. Inside
  the front-matter block it does only the *safe, universal* untangling: marks the
  largest-font heading as `title_candidate`, and tags venue-agnostic boilerplate
  (DOI / dates / emails / URLs / arXiv / MSC / keywords / funding) with the pattern
  that fired. Everything else is left unresolved, flagged for the model — not guessed.

    . ./zones.ps1
    Invoke-Zones -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>]
#>

. "$PSScriptRoot/../shared/jsonl.ps1"

# venue-agnostic boilerplate patterns: name -> regex (first match wins)
$script:BoilerplatePatterns = [ordered]@{
    doi      = '(?i)\bdoi:\s*\S|10\.\d{4,}/'
    date     = '(?i)\b(received|revised|accepted|published)\s*:'
    email    = '[\w.\-]+@[\w.\-]+\.\w{2,}'
    url      = '(?i)https?://'
    arxiv    = '(?i)arxiv:\s*\d'
    msc      = '(?i)mathematics subject classification'
    keywords = '(?i)^\s*key\s?words'
    funding  = '(?i)(funded by|supported by|support for|grant\b|\bnsf\b|\bnih\b)'
}

# a heading that opens the body (first numbered section, or "Introduction"). Numbering dialects:
# Arabic "1 ..." / "1. ...", ROMAN "I. ..." (IEEE style — the 2508.11646 zoning failure, both
# lanes), and "Introduction" with or without either prefix.
function Test-BodyStartHeading([string]$content) {
    return ($content -match '^\s*\d+(\.\d+)*\.?\s+[A-Za-z]') -or
           ($content -cmatch '^\s*[IVXL]+\.\s+\S') -or
           ($content -match '(?i)^\s*((\d+(\.\d+)*|[IVXL]+)\.?\s+)?introduction\s*$')
}

# a heading that opens the back-matter (References / Bibliography)
function Test-BackmatterHeading([string]$content) {
    return $content -match '(?i)^\s*(\d+\.?\s+)?(references|bibliography)\s*$'
}

function Invoke-Zones {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ChunksPath,
        [string] $NodesPath
    )

    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    # 1. zone segmentation — sequential state machine over reading order; only
    #    headings move the boundary.
    $zone = 'frontmatter'
    foreach ($c in $chunks) {
        $content = [string]$c.content
        if ($c.type -eq 'heading') {
            if ($zone -eq 'frontmatter' -and (Test-BodyStartHeading $content)) { $zone = 'body' }
            elseif ($zone -ne 'backmatter' -and (Test-BackmatterHeading $content)) { $zone = 'backmatter' }
        }
        $c | Add-Member -NotePropertyName zone -NotePropertyValue $zone -Force
    }

    # 2. universal boilerplate hints — anywhere (footnote MSC/funding lives in body).
    #    Tagged before the title pick so a big-font boilerplate line (the arXiv margin
    #    watermark, set at 20pt) can't be mistaken for the title.
    foreach ($c in $chunks) {
        $content = [string]$c.content
        if (-not $content) { continue }
        foreach ($name in $script:BoilerplatePatterns.Keys) {
            if ($content -match $script:BoilerplatePatterns[$name]) {
                $c | Add-Member -NotePropertyName boilerplate_hint -NotePropertyValue $name -Force
                break
            }
        }
    }

    # 3. title candidate — largest-font non-boilerplate front-matter heading, ties broken
    #    by reading order (the title leads the page). Falls back to a 'Doctitle'-level
    #    heading, then the first heading, when font metadata is absent.
    $fm = @($chunks | Where-Object { $_.zone -eq 'frontmatter' -and $_.type -eq 'heading' -and -not $_.boilerplate_hint })
    $withFont = @($fm | Where-Object { $null -ne $_.font_size })
    $titleChunk = if ($withFont.Count) {
        $withFont | Sort-Object @{Expression={[double]$_.font_size};Descending=$true}, @{Expression={[int]$_.id};Descending=$false} | Select-Object -First 1
    } else {
        $dt = @($fm | Where-Object { $_.level -eq 'Doctitle' })
        if ($dt.Count) { $dt[0] } elseif ($fm.Count) { $fm[0] } else { $null }
    }
    if ($titleChunk) { $titleChunk | Add-Member -NotePropertyName title_candidate -NotePropertyValue $true -Force }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'zones'

    "zones tagged on $($chunks.Count) chunks -> $ChunksPath"
    ($chunks | Group-Object zone | Sort-Object Name | ForEach-Object { "  {0,-12} {1}" -f $_.Name, $_.Count })
    $tc = @($chunks | Where-Object { $_.title_candidate })
    if ($tc.Count) { "  title_candidate -> '$(([string]$tc[0].content).Substring(0,[Math]::Min(52,([string]$tc[0].content).Length)))'" }
    $bh = $chunks | Where-Object { $_.boilerplate_hint } | Group-Object boilerplate_hint | Sort-Object Count -Descending
    if ($bh) { "  boilerplate hints: " + (($bh | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ', ') }
    return $manifest
}
