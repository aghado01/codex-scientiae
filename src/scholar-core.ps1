#requires -Version 7.0
<#
  src/scholar-core.ps1 — the source-agnostic core of the scholar discovery framework.
  (Increment 1 of .discussion/scholar-discovery-framework.md.)

  It generalizes the arXiv server's HTTP / retry / per-host rate-limit, and adds the normalized **Work**
  model + paging envelope that every source adapter emits — so an agentic-RAG loop synthesizes across
  OpenAlex / Semantic Scholar / arXiv uniformly. Discovery only; acquisition (staging bytes to the inbox)
  stays source-specific (codex-arxiv, future sci-hub).

  ADAPTER CONTRACT — each source adapter (openalex.ps1, semanticscholar.ps1, …) implements these,
  returning the shared types defined below:
    <Source>-Search  (query, filters, start)   -> New-ScholarPage wrapping Work[]
    <Source>-GetWork (id | doi)                 -> Work
    <Source>-Related (id | doi, kind)           -> Work[]   (kind: citations | references | recommendations)
    <Source>-Resolve (reference | title | doi)  -> Work[]   (best-effort DOI/metadata resolution)

  Pure plumbing: dot-sources cleanly, unit-tested offline, and deliberately does NOT touch arxiv.ps1 —
  the codex-arxiv server keeps its own copy until/if it migrates onto this core (brief §7 increment 4).
#>

# Polite identification. A contact email opts into OpenAlex's polite pool and is good manners for every
# source. It is NOT hardcoded — the server/adapters set it from config or env, so a personal address is
# never committed to the repo.
$script:ScholarContact   = ''
$script:ScholarUserAgent = 'codex-scientiae-scholar/0.1'
function Set-ScholarContact { param([string]$Email) $script:ScholarContact = $Email }
function Get-ScholarUserAgent {
    if ($script:ScholarContact) { return "$script:ScholarUserAgent (mailto:$script:ScholarContact)" }
    return $script:ScholarUserAgent
}

# --- per-host rate limiting --------------------------------------------------------------------------
# Each source has its own floor (arXiv 3s, Semantic Scholar ~1rps keyless, OpenAlex generous). Key the
# clock by host so a slow source never throttles another; the adapter passes its source's MinIntervalMs.
$script:ScholarLastRequest = @{}
function Wait-ScholarRate {
    param([string]$Key, [int]$MinIntervalMs)
    if ($MinIntervalMs -le 0) { return }
    $last = if ($script:ScholarLastRequest.ContainsKey($Key)) { $script:ScholarLastRequest[$Key] } else { [datetime]::MinValue }
    $elapsed = ([datetime]::UtcNow - $last).TotalMilliseconds
    if ($elapsed -lt $MinIntervalMs) { Start-Sleep -Milliseconds ([int]($MinIntervalMs - $elapsed)) }
    $script:ScholarLastRequest[$Key] = [datetime]::UtcNow
}

# --- transient-failure classification (generalized from arxiv.ps1) ----------------------------------
function Get-ScholarErrorParts {
    param($ErrorRecord)
    $ex = $ErrorRecord.Exception
    $code = 0; try { if ($ex.Response) { $code = [int]$ex.Response.StatusCode } } catch {}
    return @{ Code = $code; Message = [string]$ex.Message }
}
# Pure retry policy: transient (transport blips + genuine 5xx) gets a backoff retry; 429/503 (rate limit)
# and 4xx (permanent) fast-fail. Source-neutral message text.
function Get-ScholarTransience {
    param([int]$Code, [string]$Message)
    if ($Code) {
        if ($Code -eq 429 -or $Code -eq 503) { return [pscustomobject]@{ Transient = $false; Code = $Code; Message = "rate limited (HTTP $Code) — wait ~60s before retrying; do not loop." } }
        if ($Code -eq 500 -or $Code -eq 502 -or $Code -eq 504) { return [pscustomobject]@{ Transient = $true; Code = $Code; Message = "server error (HTTP $Code): $Message" } }
        return [pscustomobject]@{ Transient = $false; Code = $Code; Message = "request failed (HTTP $Code): $Message" }
    }
    if ($Message -match 'No such host is known|name or service not known|actively refused|connection.*(reset|closed|refused|aborted|forcibly)|reset by peer|timed out|timeout|unreachable|temporar') {
        return [pscustomobject]@{ Transient = $true; Code = 0; Message = "network error: $Message" }
    }
    return [pscustomobject]@{ Transient = $false; Code = 0; Message = "request failed: $Message" }
}

# --- HTTP: one GET with per-host throttle + transient retry ------------------------------------------
function Invoke-ScholarApi {
    param(
        [string]$Url,
        [hashtable]$Headers = @{},
        [int]$MinIntervalMs = 1000,
        [int]$TimeoutSec = 30,
        [int]$MaxAttempts = 3,
        [string]$RateKey
    )
    $key = if ($RateKey) { $RateKey } else { ([uri]$Url).Host }
    $h = @{ 'User-Agent' = (Get-ScholarUserAgent) } + $Headers   # caller headers win on conflict
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        Wait-ScholarRate -Key $key -MinIntervalMs $MinIntervalMs
        try {
            return [string](Invoke-WebRequest -Uri $Url -Headers $h -TimeoutSec $TimeoutSec -MaximumRedirection 5 -ErrorAction Stop).Content
        } catch {
            $ep  = Get-ScholarErrorParts $_
            $cls = Get-ScholarTransience -Code $ep.Code -Message $ep.Message
            if (-not $cls.Transient -or $attempt -eq $MaxAttempts) { throw $cls.Message }
            Start-Sleep -Milliseconds ([int](400 * [Math]::Pow(2, $attempt - 1)))
        }
    }
}
# JSON convenience for the JSON sources (OpenAlex / Semantic Scholar); arXiv-style XML uses Invoke-ScholarApi.
function Get-ScholarJson {
    param([string]$Url, [hashtable]$Headers = @{}, [int]$MinIntervalMs = 1000, [int]$TimeoutSec = 30, [int]$MaxAttempts = 3, [string]$RateKey)
    return (Invoke-ScholarApi -Url $Url -Headers $Headers -MinIntervalMs $MinIntervalMs -TimeoutSec $TimeoutSec -MaxAttempts $MaxAttempts -RateKey $RateKey) | ConvertFrom-Json
}

# --- the normalized Work model ----------------------------------------------------------------------
# Canonical DOI key: lowercase, scheme/host/`doi:` prefix stripped. DOIs are case-insensitive in practice,
# so normalizing makes them safe dedup + sci-hub keys.
function ConvertTo-NormalizedDoi {
    param([string]$Doi)
    if ([string]::IsNullOrWhiteSpace($Doi)) { return $null }
    $d = $Doi.Trim()
    $d = $d -replace '^(https?://)?(dx\.)?doi\.org/', ''
    $d = $d -replace '^doi:', ''
    return $d.ToLowerInvariant()
}

# A stable identity key for cross-source dedup: prefer DOI, then arXiv id, then source:source_id.
function Get-ScholarWorkKey {
    param([pscustomobject]$Work)
    if ($Work.doi)      { return "doi:$($Work.doi)" }
    if ($Work.arxiv_id) { return "arxiv:$(([string]$Work.arxiv_id).ToLowerInvariant())" }
    return "$($Work.source):$($Work.source_id)"
}

# Every adapter emits this exact shape (unset fields -> $null / empty array), so the agent reasons across
# sources uniformly. arxiv_id AND doi both carried when known — that cross-walk picks the acquisition route
# (prefer arXiv `source` artifact when arxiv_id is present; else DOI -> sci-hub).
function New-ScholarWork {
    param(
        [string]$Source, [string]$SourceId, [string]$Doi, [string]$ArxivId,
        [string]$Title, [string[]]$Authors = @(), [string]$Abstract,
        [int]$Year = 0, [string]$Venue, [string]$OaUrl, [string]$PdfUrl,
        [int]$CitationCount = -1, [int]$ReferencesCount = -1, [string]$Tldr,
        [string[]]$Fields = @(), [hashtable]$ExternalIds = @{}
    )
    return [pscustomobject]@{
        source           = $Source
        source_id        = $SourceId
        doi              = (ConvertTo-NormalizedDoi $Doi)
        arxiv_id         = if ($ArxivId) { $ArxivId } else { $null }
        title            = $Title
        authors          = @($Authors)
        abstract         = $Abstract
        year             = if ($Year -gt 0) { $Year } else { $null }
        venue            = $Venue
        oa_url           = $OaUrl
        pdf_url          = $PdfUrl
        citation_count   = if ($CitationCount -ge 0) { $CitationCount } else { $null }
        references_count = if ($ReferencesCount -ge 0) { $ReferencesCount } else { $null }
        tldr             = $Tldr
        fields           = @($Fields)
        external_ids     = $ExternalIds
    }
}

# --- paging envelope (consistent with codex-arxiv's search shape) -----------------------------------
function New-ScholarPage {
    param([string]$Source, [int]$Total = -1, [int]$Start = 0, [pscustomobject[]]$Works = @())
    $w = @($Works)
    $next = if ($Total -ge 0 -and ($Start + $w.Count) -lt $Total) { $Start + $w.Count } else { -1 }
    return [pscustomobject]@{
        source          = $Source
        total_available = $Total       # -1 if the source did not report a total
        returned        = $w.Count
        start           = $Start
        next_start      = $next        # feed back as the next page's start, or -1 when exhausted
        works           = $w
    }
}
