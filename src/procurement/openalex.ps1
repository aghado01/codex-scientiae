#requires -Version 7.0
<#
  src/openalex.ps1 — the OpenAlex source adapter for the scholar discovery framework (increment 2).
  Requires scholar-core.ps1 dot-sourced first (New-ScholarWork / New-ScholarPage / Get-ScholarJson / …).

  OpenAlex is a free, keyless cross-publisher scholarly graph. This adapter maps its JSON onto the shared
  Work model and implements the contract: Search / GetWork / Related (citations|references) / Resolve.
  Citation direction confirmed live: `filter=cites:{id}` returns works that CITE {id}; references come
  from the work's `referenced_works[]`, batch-hydrated via `filter=openalex:{id1|id2|…}`.

  NB: OpenAlex responses are parsed -AsHashtable (Get-OpenAlexJson) because abstract_inverted_index has
  keys that differ only in case — a PSCustomObject can't hold them. So the mappers use hashtable access
  (.ContainsKey / .Keys / .GetEnumerator), not .PSObject.Properties.
#>

# The field projection every call requests — lean but complete for the Work model.
$script:OpenAlexSelect = 'id,doi,title,publication_year,cited_by_count,referenced_works,authorships,primary_location,best_oa_location,locations,ids,abstract_inverted_index,topics'
$script:OpenAlexRateMs = 150   # OpenAlex allows ~10 rps; stay polite

function Get-OpenAlexUrl {
    param([string]$PathAndQuery)
    $url = "https://api.openalex.org/$PathAndQuery"
    if ($script:ScholarContact) {
        $sep = if ($PathAndQuery -match '\?') { '&' } else { '?' }
        $url += "${sep}mailto=$([uri]::EscapeDataString($script:ScholarContact))"
    }
    return $url
}
# One throttled, retried, -AsHashtable GET against OpenAlex.
function Get-OpenAlexJson {
    param([string]$PathAndQuery)
    return Get-ScholarJson -Url (Get-OpenAlexUrl $PathAndQuery) -MinIntervalMs $script:OpenAlexRateMs -RateKey 'openalex' -AsHashtable
}

# Normalize any inbound identifier to an OpenAlex path key: a W-id, or doi:DOI (slashes kept literal).
function ConvertTo-OpenAlexKey {
    param([string]$Id)
    $i = ([string]$Id).Trim()
    if ($i -match '^https?://openalex\.org/(.+)$') { return $Matches[1] }
    if ($i -match '^https?://doi\.org/(.+)$')      { return "doi:$($Matches[1])" }
    if ($i -match '^doi:')                          { return $i }
    if ($i -match '^10\.\d')                        { return "doi:$i" }
    return $i   # assume an OpenAlex entity id (W…/A…/S…/…)
}

# OpenAlex stores abstracts as a {word: [positions]} inverted index — rebuild the linear text.
function ConvertFrom-OpenAlexAbstract {
    param($Inverted)
    if (-not $Inverted) { return $null }
    $slots = @{}
    foreach ($e in $Inverted.GetEnumerator()) {
        foreach ($pos in $e.Value) { $slots[[int]$pos] = $e.Key }
    }
    if (-not $slots.Count) { return $null }
    $max = ($slots.Keys | Measure-Object -Maximum).Maximum
    $words = for ($i = 0; $i -le $max; $i++) { if ($slots.ContainsKey($i)) { $slots[$i] } else { '' } }
    return (($words -join ' ') -replace '\s+', ' ').Trim()
}

# Raw OpenAlex work (hashtable) -> normalized Work.
function ConvertFrom-OpenAlexWork {
    param($W)
    if (-not $W) { return $null }
    $oaId = ([string]$W.id) -replace '^https?://openalex\.org/', ''
    $doi  = if ($W.doi) { [string]$W.doi } elseif ($W.ids -and $W.ids.doi) { [string]$W.ids.doi } else { $null }

    # arXiv id: OpenAlex rarely exposes it directly; best-effort from ids or an arxiv.org location url.
    $arxiv = $null
    if ($W.ids -and $W.ids.ContainsKey('arxiv') -and $W.ids['arxiv']) { $arxiv = [string]$W.ids['arxiv'] }
    if (-not $arxiv) {
        foreach ($loc in @($W.primary_location, $W.best_oa_location) + @($W.locations)) {
            if (-not $loc) { continue }
            foreach ($u in @($loc.landing_page_url, $loc.pdf_url)) {
                if ($u -and ($u -match 'arxiv\.org/(?:abs|pdf)/([^\s?]+?)(?:\.pdf)?$')) { $arxiv = $Matches[1]; break }
            }
            if ($arxiv) { break }
        }
    }

    $authors = @($W.authorships | ForEach-Object { $_.author.display_name } | Where-Object { $_ })
    $pdf = if ($W.best_oa_location -and $W.best_oa_location.pdf_url) { [string]$W.best_oa_location.pdf_url }
           elseif ($W.primary_location -and $W.primary_location.pdf_url) { [string]$W.primary_location.pdf_url } else { $null }
    $oa  = if ($W.best_oa_location -and $W.best_oa_location.landing_page_url) { [string]$W.best_oa_location.landing_page_url } else { $null }
    $venue = if ($W.primary_location -and $W.primary_location.source) { [string]$W.primary_location.source.display_name } else { $null }
    $fields = @($W.topics | ForEach-Object { $_.display_name } | Where-Object { $_ } | Select-Object -First 5)
    $ext = @{}
    if ($W.ids) { foreach ($k in $W.ids.Keys) { if ($W.ids[$k]) { $ext[$k] = [string]$W.ids[$k] } } }
    $cc = if ($null -ne $W.cited_by_count) { [int]$W.cited_by_count } else { -1 }
    $rc = if ($W.ContainsKey('referenced_works')) { @($W.referenced_works).Count } else { -1 }
    $yr = if ($null -ne $W.publication_year) { [int]$W.publication_year } else { 0 }

    return New-ScholarWork -Source 'openalex' -SourceId $oaId -Doi $doi -ArxivId $arxiv `
        -Title ([string]$W.title) -Authors $authors -Abstract (ConvertFrom-OpenAlexAbstract $W.abstract_inverted_index) `
        -Year $yr -Venue $venue -OaUrl $oa -PdfUrl $pdf -CitationCount $cc -ReferencesCount $rc `
        -Fields $fields -ExternalIds $ext
}

function OpenAlex-Search {
    param([string]$Query, [string[]]$Filters = @(), [int]$Start = 0, [int]$PerPage = 25)
    $per  = [Math]::Min([Math]::Max($PerPage, 1), 50)
    $page = [int][Math]::Floor([Math]::Max($Start, 0) / $per) + 1
    $qs = @("per-page=$per", "page=$page", "select=$script:OpenAlexSelect")
    if ($Query)         { $qs += "search=$([uri]::EscapeDataString($Query))" }
    if ($Filters.Count) { $qs += "filter=$(($Filters -join ','))" }   # filter syntax is literal (cites:, from_date:, |)
    $j = Get-OpenAlexJson ("works?" + ($qs -join '&'))
    $works = @($j.results | ForEach-Object { ConvertFrom-OpenAlexWork $_ })
    return New-ScholarPage -Source 'openalex' -Total ([int]$j.meta.count) -Start ([Math]::Max($Start, 0)) -Works $works
}

function OpenAlex-GetWork {
    param([string]$Id)
    $key = ConvertTo-OpenAlexKey $Id
    return ConvertFrom-OpenAlexWork (Get-OpenAlexJson "works/$($key)?select=$script:OpenAlexSelect")
}

function OpenAlex-Related {
    param([string]$Id, [string]$Kind = 'citations', [int]$Limit = 25)
    $lim = [Math]::Min([Math]::Max($Limit, 1), 50)
    switch ($Kind) {
        'citations' {
            $oaId = ConvertTo-OpenAlexKey $Id
            if ($oaId -match '^doi:') { $oaId = (OpenAlex-GetWork $Id).source_id }   # cites: needs the W-id
            $j = Get-OpenAlexJson "works?filter=cites:$oaId&per-page=$lim&select=$script:OpenAlexSelect"
            return @($j.results | ForEach-Object { ConvertFrom-OpenAlexWork $_ })
        }
        'references' {
            $raw = Get-OpenAlexJson "works/$(ConvertTo-OpenAlexKey $Id)?select=referenced_works"
            $ids = @($raw.referenced_works | ForEach-Object { ([string]$_) -replace '^https?://openalex\.org/', '' } | Select-Object -First $lim)
            if (-not $ids.Count) { return @() }
            $j = Get-OpenAlexJson "works?filter=openalex:$(($ids -join '|'))&per-page=$($ids.Count)&select=$script:OpenAlexSelect"
            return @($j.results | ForEach-Object { ConvertFrom-OpenAlexWork $_ })
        }
        'recommendations' { throw "OpenAlex has no recommendations endpoint — use Semantic Scholar for kind 'recommendations'." }
        default           { throw "unknown related kind: '$Kind' (citations|references)" }
    }
}

# Resolve a free reference / title / DOI to candidate Works (DOI -> direct; else bibliographic search).
function OpenAlex-Resolve {
    param([string]$Reference)
    $r = ([string]$Reference).Trim()
    if ($r -match '10\.\d{4,9}/\S+') {
        try { return @((OpenAlex-GetWork "doi:$($Matches[0])")) } catch { }
    }
    return @((OpenAlex-Search -Query $r -PerPage 5).works)
}
