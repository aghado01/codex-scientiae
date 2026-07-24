#requires -Version 7.0
<#
  src/procurement/arxiv-adapter.ps1 — the arXiv source adapter for the scholar discovery framework (increment 4).
  Requires scholar-core.ps1 AND arxiv.ps1 dot-sourced first.

  arXiv is a search + metadata source (a preprint repository), NOT a citation graph — so this adapter
  implements Search / GetWork and feeds discover_search's fan, but NOT Related/Resolve (no graph). It
  reuses arxiv.ps1's tested Atom search/metadata and just normalizes the arXiv record onto the Work model
  (stripping the [external:untrusted] marker, which the Work layer conveys via the prompt instead).
#>

function ConvertFrom-ArxivToWork {
    param($P)
    if (-not $P) { return $null }
    $mark = $script:ArxivExternalMark   # defined by arxiv.ps1
    $abs = [string]$P.abstract;    if ($mark -and $abs.StartsWith($mark)) { $abs = $abs.Substring($mark.Length) }
    $jr  = [string]$P.journal_ref; if ($mark -and $jr.StartsWith($mark))  { $jr  = $jr.Substring($mark.Length) }
    $year = if ($P.published -match '^(\d{4})') { [int]$Matches[1] } else { 0 }
    $ext = @{ arxiv = [string]$P.idv }
    if ($P.doi) { $ext['doi'] = [string]$P.doi }
    return New-ScholarWork -Source 'arxiv' -SourceId ([string]$P.idv) -Doi ([string]$P.doi) -ArxivId ([string]$P.idv) `
        -Title ([string]$P.title) -Authors @($P.authors) -Abstract $abs -Year $year `
        -Venue $(if ($jr) { $jr } else { $null }) -PdfUrl ([string]$P.pdf_url) -OaUrl ([string]$P.abs_url) `
        -Fields @($P.categories) -ExternalIds $ext
}

function Arxiv-Search {
    param([string]$Query, [int]$Start = 0, [int]$Limit = 25)
    $res = Invoke-ArxivSearch -Query $Query -MaxResults $Limit -Start $Start
    $works = @($res.papers | ForEach-Object { ConvertFrom-ArxivToWork $_ })
    return New-ScholarPage -Source 'arxiv' -Total ([int]$res.total_available) -Start ([Math]::Max($Start, 0)) -Works $works
}

function Arxiv-GetWork {
    param([string]$Id)
    $m = Get-ArxivMetadata $Id
    if ($m -is [array]) { $m = $m[0] }
    return ConvertFrom-ArxivToWork $m
}
