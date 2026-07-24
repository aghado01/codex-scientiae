#requires -Version 7.0
<#
  src/procurement/semanticscholar.ps1 — the Semantic Scholar source adapter for the scholar discovery framework
  (increment 2). Requires scholar-core.ps1 dot-sourced first.

  Semantic Scholar's Graph API is a cross-publisher scholarly graph with SPECTER-based recommendations,
  TLDR summaries, and influential-citation signals. Keyless works but is rate-limited (shared pool); an
  optional API key (env SEMANTIC_SCHOLAR_API_KEY -> x-api-key header) lifts limits. This adapter maps its
  JSON onto the shared Work model and implements Search / GetWork / Related (citations|references|
  recommendations) / Resolve.
#>

$script:S2Graph  = 'https://api.semanticscholar.org/graph/v1'
$script:S2Rec    = 'https://api.semanticscholar.org/recommendations/v1'
$script:S2Fields = 'paperId,externalIds,title,abstract,year,venue,authors,citationCount,referenceCount,tldr,openAccessPdf,fieldsOfStudy'

# Keyless is throttled hard (shared pool) — be conservative; a key allows a tighter interval.
function Get-S2Interval { if ($env:SEMANTIC_SCHOLAR_API_KEY) { return 350 } else { return 1100 } }
function Get-S2Headers  { if ($env:SEMANTIC_SCHOLAR_API_KEY) { return @{ 'x-api-key' = $env:SEMANTIC_SCHOLAR_API_KEY } } else { return @{} } }

# Normalize any inbound identifier to an S2 paper key (it accepts typed prefixes natively).
function ConvertTo-S2Key {
    param([string]$Id)
    $i = ([string]$Id).Trim()
    if ($i -match '^(DOI|ARXIV|MAG|ACL|PMID|PMCID|CorpusId|URL):') { return $i }
    if ($i -match '^10\.\d')           { return "DOI:$i" }
    if ($i -match '^\d{4}\.\d{4,5}')    { return "ARXIV:$i" }
    return $i   # assume an S2 paperId (40-hex) or a paper URL
}

# Raw S2 paper JSON -> normalized Work.
function ConvertFrom-S2Paper {
    param($P)
    if (-not $P -or -not $P.paperId) { return $null }
    $ext = @{}
    # NB: loop var must NOT be $p — PowerShell is case-insensitive, so $p would clobber the $P parameter.
    if ($P.externalIds) { foreach ($kv in $P.externalIds.PSObject.Properties) { if ($null -ne $kv.Value) { $ext[$kv.Name] = [string]$kv.Value } } }
    $doi   = if ($P.externalIds -and $P.externalIds.DOI)   { [string]$P.externalIds.DOI }   else { $null }
    $arxiv = if ($P.externalIds -and $P.externalIds.ArXiv) { [string]$P.externalIds.ArXiv } else { $null }
    $authors = @($P.authors | ForEach-Object { $_.name } | Where-Object { $_ })
    $pdf  = if ($P.openAccessPdf -and $P.openAccessPdf.url) { [string]$P.openAccessPdf.url } else { $null }
    $tldr = if ($P.tldr -and $P.tldr.text) { [string]$P.tldr.text } else { $null }
    $fields = @($P.fieldsOfStudy)
    $cc = if ($null -ne $P.citationCount) { [int]$P.citationCount } else { -1 }
    $rc = if ($null -ne $P.referenceCount) { [int]$P.referenceCount } else { -1 }
    $yr = if ($null -ne $P.year) { [int]$P.year } else { 0 }

    return New-ScholarWork -Source 'semanticscholar' -SourceId ([string]$P.paperId) -Doi $doi -ArxivId $arxiv `
        -Title ([string]$P.title) -Authors $authors -Abstract ([string]$P.abstract) -Year $yr `
        -Venue ([string]$P.venue) -PdfUrl $pdf -CitationCount $cc -ReferencesCount $rc -Tldr $tldr `
        -Fields $fields -ExternalIds $ext
}

function SemanticScholar-Search {
    param([string]$Query, [int]$Start = 0, [int]$Limit = 25)
    $lim = [Math]::Min([Math]::Max($Limit, 1), 100)
    $url = "$script:S2Graph/paper/search?query=$([uri]::EscapeDataString($Query))&offset=$([Math]::Max($Start,0))&limit=$lim&fields=$script:S2Fields"
    $j = Get-ScholarJson -Url $url -Headers (Get-S2Headers) -MinIntervalMs (Get-S2Interval) -RateKey 'semanticscholar'
    $works = @($j.data | ForEach-Object { ConvertFrom-S2Paper $_ } | Where-Object { $_ })
    $total = if ($null -ne $j.total) { [int]$j.total } else { -1 }
    return New-ScholarPage -Source 'semanticscholar' -Total $total -Start ([Math]::Max($Start, 0)) -Works $works
}

function SemanticScholar-GetWork {
    param([string]$Id)
    $key = ConvertTo-S2Key $Id
    $j = Get-ScholarJson -Url "$script:S2Graph/paper/$($key)?fields=$script:S2Fields" -Headers (Get-S2Headers) -MinIntervalMs (Get-S2Interval) -RateKey 'semanticscholar'
    return ConvertFrom-S2Paper $j
}

function SemanticScholar-Related {
    param([string]$Id, [string]$Kind = 'recommendations', [int]$Limit = 25)
    $key = ConvertTo-S2Key $Id
    $lim = [Math]::Min([Math]::Max($Limit, 1), 100)
    switch ($Kind) {
        'references' {
            $j = Get-ScholarJson -Url "$script:S2Graph/paper/$($key)/references?fields=$script:S2Fields&limit=$lim" -Headers (Get-S2Headers) -MinIntervalMs (Get-S2Interval) -RateKey 'semanticscholar'
            return @($j.data | ForEach-Object { ConvertFrom-S2Paper $_.citedPaper } | Where-Object { $_ })
        }
        'citations' {
            $j = Get-ScholarJson -Url "$script:S2Graph/paper/$($key)/citations?fields=$script:S2Fields&limit=$lim" -Headers (Get-S2Headers) -MinIntervalMs (Get-S2Interval) -RateKey 'semanticscholar'
            return @($j.data | ForEach-Object { ConvertFrom-S2Paper $_.citingPaper } | Where-Object { $_ })
        }
        'recommendations' {
            $j = Get-ScholarJson -Url "$script:S2Rec/papers/forpaper/$($key)?fields=$script:S2Fields&limit=$lim" -Headers (Get-S2Headers) -MinIntervalMs (Get-S2Interval) -RateKey 'semanticscholar'
            return @($j.recommendedPapers | ForEach-Object { ConvertFrom-S2Paper $_ } | Where-Object { $_ })
        }
        default { throw "unknown related kind: '$Kind' (citations|references|recommendations)" }
    }
}

# Resolve a free reference / title / DOI / arXiv id to candidate Works.
function SemanticScholar-Resolve {
    param([string]$Reference)
    $r = ([string]$Reference).Trim()
    if ($r -match '10\.\d{4,9}/\S+')         { try { return @((SemanticScholar-GetWork "DOI:$($Matches[0])")) } catch { } }
    if ($r -match '^\d{4}\.\d{4,5}(v\d+)?$')  { try { return @((SemanticScholar-GetWork "ARXIV:$r")) } catch { } }
    return @((SemanticScholar-Search -Query $r -Limit 5).works)
}
