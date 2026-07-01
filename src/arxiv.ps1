#requires -Version 7.0
<#
  src/arxiv.ps1 — the convention-agnostic core of the codex-arxiv acquisition server.

  Two contracts meet here. The OUTWARD one is stable: arXiv's public Atom API and the arXiv id,
  which is the single canonical key for a paper and never changes shape. The INWARD one is fluid —
  where a fetched paper lands on disk, and under what slug, is an early-growth convention that WILL
  move. So everything inward is data-driven: the layout lives in an external template config
  (arxiv-staging.json) and is expanded through one seam (Resolve-ArxivStageTarget). No ingestion
  layout is hard-coded here; the only thing this file commits to is "the arXiv id identifies a paper".

  This library is pure plumbing — it dot-sources cleanly and is unit-tested offline (atom parsing,
  id handling, template expansion) without touching the network. The protocol shell is arxiv-server.ps1.
#>

# arXiv asks for >= 3s between programmatic requests; a ban is the cost of ignoring it. The floor is ONE
# global clock, but the server now spans two runspaces (the main loop issues search/metadata; a background
# worker issues fetch downloads), so the clock can't be a plain script variable — two copies would each
# think they were first and fire <3s apart. It lives in a synchronized holder that the server injects into
# BOTH runspaces (see Use-ArxivRateState); Wait-ArxivRateLimit locks it across the read-sleep-stamp so every
# arXiv request, from either runspace, is serialized behind the floor.
$script:ArxivRateState     = [hashtable]::Synchronized(@{ LastRequestTicks = [long]0 })
$script:ArxivMinIntervalMs = 3000
# This library's own path, captured at dot-source time, so the server can hand the worker runspace the exact
# file to dot-source into itself (a fresh runspace shares no functions with the main one).
$script:ArxivLibPath       = Join-Path $PSScriptRoot 'arxiv.ps1'
$script:ArxivUserAgent     = 'codex-arxiv-mcp/0.1 (+https://github.com/blazickjp/arxiv-mcp-server; research tool, in-house port)'
$script:ArxivApiUrl        = 'https://export.arxiv.org/api/query'
$script:ArxivNs            = @{ atom = 'http://www.w3.org/2005/Atom'; arxiv = 'http://arxiv.org/schemas/atom' }

# External free text from arXiv (abstracts, comments) is untrusted: it can carry prompt-injection aimed
# at whatever LLM reads this tool's output. We tag it inline so the boundary is visible downstream.
$script:ArxivExternalMark  = '[external:untrusted] '

# --- id handling -------------------------------------------------------------------------------------
# New scheme (post-2007): 2008.10579 with optional vN. Old scheme: archive(.subclass)/7-digit, e.g.
# math.GT/0309136 or hep-th/9901001. We accept both so the server works across the whole corpus age range.
function Test-ArxivId {
    param([string]$Id)
    if ([string]::IsNullOrWhiteSpace($Id)) { return $false }
    return ($Id -match '^\d{4}\.\d{4,5}(v\d+)?$') -or ($Id -match '^[a-z][a-z\-]*(\.[A-Z]{2})?/\d{7}(v\d+)?$')
}

# Decompose an id into { Short (versionless), Versioned (vN if known), Version }. The short id is the
# stable cross-version key; the versioned id is what we name files with so re-fetches don't silently
# alias a different revision.
function Split-ArxivId {
    param([string]$Id)
    $id = $Id.Trim()
    $m  = [regex]::Match($id, 'v(\d+)$')
    if ($m.Success) {
        $short = $id.Substring(0, $m.Index)
        return [pscustomobject]@{ Short = $short; Versioned = $id; Version = [int]$m.Groups[1].Value }
    }
    return [pscustomobject]@{ Short = $id; Versioned = $id; Version = $null }
}

# Filesystem-safe form of any id-derived string: old-style ids carry a '/', and a stray separator in a
# path placeholder is both a layout bug and a traversal vector. Collapse anything outside a safe set.
function ConvertTo-ArxivPathSlug {
    param([string]$Value)
    $s = ($Value -replace '[^A-Za-z0-9._-]', '_').Trim('_', '.')
    if ([string]::IsNullOrWhiteSpace($s)) { throw "id produced an empty path slug: '$Value'" }
    return $s
}

# --- layout seam (the fluid, data-driven part) -------------------------------------------------------
# Built-in fallback so the server still runs if the config file is absent. Metadata is deliberately named
# '.arxiv.json' (NOT '.json') so a staged paper never trips the membrane's {slug}/{slug}.json raw-IR
# discovery before a converter has actually produced an IR.
$script:ArxivDefaultConfig = [pscustomobject]@{
    version      = '0.2.0'
    staging_root = 'ingestion/_inbox'
    slug         = '{idv}'
    layout       = [pscustomobject]@{
        dir      = '{slug}'
        pdf      = '{slug}/{slug}.pdf'
        source   = '{slug}/{slug}.tar.gz'
        html     = '{slug}/{slug}.html'
        metadata = '{slug}/{slug}.arxiv.json'
    }
}

# --- artifact registry -------------------------------------------------------------------------------
# arXiv exposes a paper as several artifact types. The URL per type is the STABLE external contract
# (arxiv.org/pdf, export.arxiv.org/e-print, arxiv.org/html), so it lives in code; only the on-disk PATH
# is fluid and lives in config.layout. 'Expect' is the payload kind a healthy fetch should yield — used
# to reject error pages and (for source) to tell a real LaTeX package from a PDF-only submission.
$script:ArxivArtifacts = [ordered]@{
    pdf    = @{ Build = { param($m) [string]$m.pdf_url };                           Expect = 'pdf'  }
    source = @{ Build = { param($m) "https://export.arxiv.org/e-print/$($m.idv)" }; Expect = 'gzip' }
    html   = @{ Build = { param($m) "https://arxiv.org/html/$($m.idv)" };           Expect = 'html' }
}

# Read up to N leading bytes without slurping a (possibly multi-MB) artifact into memory.
function Get-FileHeadBytes {
    param([string]$Path, [int]$Count = 16)
    $fs = [System.IO.File]::OpenRead($Path)
    try { $b = [byte[]]::new($Count); $n = $fs.Read($b, 0, $Count); if ($n -lt $Count) { return $b[0..([Math]::Max($n - 1, 0))] }; return $b }
    finally { $fs.Dispose() }
}

# Classify a downloaded payload by magic bytes / leading text: %PDF -> pdf, 1F 8B -> gzip, <… -> html.
# arXiv's e-print returns a gzip tarball for normal LaTeX submissions but a bare PDF for PDF-only ones
# (i.e. NO source), so 'source' callers use this to distinguish "got LaTeX" from "no source exists".
function Get-ArxivPayloadKind {
    param([byte[]]$Head)
    if ($Head.Count -ge 4 -and $Head[0] -eq 0x25 -and $Head[1] -eq 0x50 -and $Head[2] -eq 0x44 -and $Head[3] -eq 0x46) { return 'pdf' }
    if ($Head.Count -ge 2 -and $Head[0] -eq 0x1F -and $Head[1] -eq 0x8B) { return 'gzip' }
    $txt = (-join ($Head | ForEach-Object { [char]$_ })).TrimStart().ToLowerInvariant()
    if ($txt.StartsWith('<!doctype') -or $txt.StartsWith('<html') -or $txt.StartsWith('<?xml')) { return 'html' }
    return 'unknown'
}

# Prove a gzip payload is complete: inflate it AND check the inflated byte count against the gzip ISIZE
# trailer (last 4 bytes = uncompressed size mod 2^32). This catches the "incomplete response body" failure
# the upstream arxiv-mcp-server documented for larger e-prints — a magic-byte check only sees the first two
# bytes, and .NET's GZipStream does NOT reliably throw on a truncated deflate stream (it can stop silently),
# so the count-vs-ISIZE comparison is what makes truncation detectable. Used as the completeness guard when
# the server withheld a Content-Length to size-check against.
function Test-ArxivGzipIntact {
    param([string]$Path)
    try {
        $len = (Get-Item -LiteralPath $Path).Length
        if ($len -lt 18) { return $false }   # gzip header(10) + at least a byte + trailer(8)
        $fs = [System.IO.File]::OpenRead($Path)
        try {
            $trailer = [byte[]]::new(4)
            [void]$fs.Seek(-4, [System.IO.SeekOrigin]::End)
            [void]$fs.Read($trailer, 0, 4)
            $isize = [System.BitConverter]::ToUInt32($trailer, 0)
            [void]$fs.Seek(0, [System.IO.SeekOrigin]::Begin)
            $gz = [System.IO.Compression.GZipStream]::new($fs, [System.IO.Compression.CompressionMode]::Decompress)
            try {
                $buf = [byte[]]::new(131072); [uint64]$count = 0
                while (($n = $gz.Read($buf, 0, $buf.Length)) -gt 0) { $count += $n }
            } finally { $gz.Dispose() }
            return (($count -band 0xFFFFFFFF) -eq $isize)   # inflated size must match the declared ISIZE
        } finally { $fs.Dispose() }
    } catch { return $false }   # inflate threw (mid-block truncation) => not intact
}

function Get-ArxivConfig {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $script:ArxivDefaultConfig }
    $raw = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
    $cfg = $raw | ConvertFrom-Json
    # Fill any missing field from the default so a partial config is still usable.
    if (-not $cfg.staging_root) { $cfg | Add-Member -NotePropertyName staging_root -NotePropertyValue $script:ArxivDefaultConfig.staging_root -Force }
    if (-not $cfg.slug)         { $cfg | Add-Member -NotePropertyName slug         -NotePropertyValue $script:ArxivDefaultConfig.slug -Force }
    if (-not $cfg.layout)       { $cfg | Add-Member -NotePropertyName layout       -NotePropertyValue $script:ArxivDefaultConfig.layout -Force }
    return $cfg
}

# Expand the placeholder set for one paper. Every value that may reach a path is pre-sanitized here, so
# the template's own '/' are the only separators that survive expansion.
function Get-ArxivPlaceholders {
    param([pscustomobject]$Meta)
    $parts = Split-ArxivId $Meta.id
    $year  = if ($Meta.published -match '^(\d{4})') { $Matches[1] } else { '' }
    return @{
        '{id}'                = ConvertTo-ArxivPathSlug $parts.Short
        '{idv}'               = ConvertTo-ArxivPathSlug $parts.Versioned
        '{primary_category}'  = if ($Meta.primary_category) { ConvertTo-ArxivPathSlug ([string]$Meta.primary_category) } else { 'uncat' }
        '{year}'              = if ($year) { $year } else { 'undated' }
    }
}

function Expand-ArxivTemplate {
    param([string]$Template, [hashtable]$Placeholders)
    $out = $Template
    # {slug} resolves first (it is itself a template), then the primitive placeholders.
    foreach ($k in $Placeholders.Keys) { $out = $out.Replace($k, [string]$Placeholders[$k]) }
    return $out
}

# Map (paper metadata, config, staging root) -> absolute { Dir, Pdf, Metadata } paths, confined under the
# staging root. This is THE single edit point when the on-disk convention changes: re-point the config,
# never the code. Confinement mirrors the membrane's Resolve-Scope so a malformed template/id can't escape.
function Resolve-ArxivStageTarget {
    param(
        [pscustomobject]$Meta,
        [pscustomobject]$Config,
        [string]$StagingRoot   # already absolute
    )
    $ph = Get-ArxivPlaceholders $Meta
    $ph['{slug}'] = ConvertTo-ArxivPathSlug (Expand-ArxivTemplate ([string]$Config.slug) $ph)

    $rootFull = [System.IO.Path]::GetFullPath($StagingRoot)
    $sep      = [System.IO.Path]::DirectorySeparatorChar
    $rootPfx  = $rootFull.TrimEnd($sep) + $sep

    $resolve = {
        param($tpl)
        $rel  = (Expand-ArxivTemplate ([string]$tpl) $ph).Replace('/', $sep).Replace('\', $sep)
        $full = [System.IO.Path]::GetFullPath((Join-Path $rootFull $rel))
        if (-not ("$full$sep").StartsWith($rootPfx, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "stage target escapes the staging root: '$rel'"
        }
        return $full
    }
    # Resolve every layout key except dir/metadata as a stageable artifact path, so adding a new artifact
    # type is a config edit (a new layout key) — no code change here.
    $artifacts = @{}
    foreach ($p in $Config.layout.PSObject.Properties) {
        if ($p.Name -in @('dir', 'metadata')) { continue }
        $artifacts[$p.Name] = & $resolve $p.Value
    }
    return [pscustomobject]@{
        Slug      = $ph['{slug}']
        Dir       = & $resolve $Config.layout.dir
        Metadata  = & $resolve $Config.layout.metadata
        Artifacts = $artifacts
    }
}

# --- arXiv API ---------------------------------------------------------------------------------------
# Point this runspace's limiter at a shared rate-state holder. The server calls this inside the worker
# runspace (passing the main runspace's holder) so the two share ONE clock; the main runspace and the
# offline unit tests use the module-scope default created above.
function Use-ArxivRateState {
    param([hashtable]$State)
    if ($State) { $script:ArxivRateState = $State }
}

function Wait-ArxivRateLimit {
    $st = $script:ArxivRateState
    [System.Threading.Monitor]::Enter($st)
    try {
        $last    = [datetime]::new([long]$st['LastRequestTicks'], [System.DateTimeKind]::Utc)
        $elapsed = ([datetime]::UtcNow - $last).TotalMilliseconds
        if ($elapsed -lt $script:ArxivMinIntervalMs) {
            Start-Sleep -Milliseconds ([int]($script:ArxivMinIntervalMs - $elapsed))
        }
        $st['LastRequestTicks'] = [datetime]::UtcNow.Ticks
    } finally { [System.Threading.Monitor]::Exit($st) }
}

# Pull (http-status, message) out of a caught web error. status = 0 when the failure is below HTTP
# (DNS / connect / TLS / timeout) — there is no response object then.
function Get-ArxivErrorParts {
    param($ErrorRecord)
    $ex = $ErrorRecord.Exception
    $code = 0; try { if ($ex.Response) { $code = [int]$ex.Response.StatusCode } } catch {}
    return @{ Code = $code; Message = [string]$ex.Message }
}

# Pure retry classifier (unit-tested): given a status code + message, decide retry policy and the
# user-facing message. Transient = worth a backoff retry (transport blips + genuine 5xx). Fast-fail =
# 429/503 (rate-limit — retrying deepens the ban) and 4xx (permanent: bad query/id/missing artifact).
function Get-ArxivTransience {
    param([int]$Code, [string]$Message)
    if ($Code) {
        if ($Code -eq 429 -or $Code -eq 503) { return [pscustomobject]@{ Transient = $false; Code = $Code; Message = "arXiv is rate limiting this IP (HTTP $Code). Wait ~60s before retrying; do not loop." } }
        if ($Code -eq 500 -or $Code -eq 502 -or $Code -eq 504) { return [pscustomobject]@{ Transient = $true; Code = $Code; Message = "arXiv server error (HTTP $Code): $Message" } }
        return [pscustomobject]@{ Transient = $false; Code = $Code; Message = "arXiv request failed (HTTP $Code): $Message" }
    }
    if ($Message -match 'No such host is known|name or service not known|actively refused|connection.*(reset|closed|refused|aborted|forcibly)|reset by peer|timed out|timeout|unreachable|temporar|truncat|incomplete') {
        return [pscustomobject]@{ Transient = $true; Code = 0; Message = "arXiv network error: $Message" }
    }
    return [pscustomobject]@{ Transient = $false; Code = 0; Message = "arXiv request failed: $Message" }
}

# One GET against the arXiv API, with bounded retry on TRANSIENT failures (the export.arxiv.org host
# flaps — intermittent DNS / 5xx — so a single blip must not surface as a hard error). The rate-limit
# floor already spaces attempts >=3s; we add a little extra backoff. 429/503 + 4xx fail fast.
function Invoke-ArxivApi {
    param([hashtable]$Query, [int]$MaxAttempts = 3)
    $pairs = foreach ($k in $Query.Keys) { "$k=$($Query[$k])" }
    $url   = $script:ArxivApiUrl + '?' + ($pairs -join '&')
    $headers = @{ 'User-Agent' = $script:ArxivUserAgent }
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        Wait-ArxivRateLimit
        try {
            # ConnectionTimeoutSeconds = total budget; OperationTimeoutSeconds = per-read (idle) timeout so a
            # stalled socket fails fast. HTTP/2 (falls back to 1.1) is what browsers use and is far more
            # resilient to a lossy link than a pinned 1.1 over TCP (no head-of-line block on a lost packet).
            # Fastly also serves HTTP/3, which IWR can't negotiate — that needs the SocketsHttpHandler engine
            # (see issues/arxiv-async/sockets-httphandler-fetch-engine.md).
            return [string](Invoke-WebRequest -Uri $url -Headers $headers `
                -ConnectionTimeoutSeconds 30 -OperationTimeoutSeconds 15 -HttpVersion 2.0 `
                -MaximumRedirection 3 -ErrorAction Stop).Content
        } catch {
            $ep  = Get-ArxivErrorParts $_
            $cls = Get-ArxivTransience -Code $ep.Code -Message $ep.Message
            if (-not $cls.Transient -or $attempt -eq $MaxAttempts) { throw $cls.Message }
            Start-Sleep -Milliseconds ([int](400 * [Math]::Pow(2, $attempt - 1)))
        }
    }
}

# Parse an Atom feed into paper records. Body-light pointers + the (marked) abstract — exactly what a
# discovery client needs to choose a paper without us re-hosting arXiv.
function ConvertFrom-ArxivAtom {
    param([string]$Xml)
    $doc = [xml]$Xml
    $ns  = [System.Xml.XmlNamespaceManager]::new($doc.NameTable)
    $ns.AddNamespace('atom',  $script:ArxivNs.atom)
    $ns.AddNamespace('arxiv', $script:ArxivNs.arxiv)

    $results = @()
    foreach ($entry in $doc.SelectNodes('//atom:entry', $ns)) {
        $idNode = $entry.SelectSingleNode('atom:id', $ns)
        if (-not $idNode -or [string]::IsNullOrWhiteSpace($idNode.InnerText)) { continue }
        $rawId     = ($idNode.InnerText -split '/abs/')[-1]
        $parts     = Split-ArxivId $rawId

        $titleNode = $entry.SelectSingleNode('atom:title', $ns)
        $title     = if ($titleNode) { ($titleNode.InnerText.Trim() -replace '\s+', ' ') } else { '' }

        $authors = @()
        foreach ($a in $entry.SelectNodes('atom:author/atom:name', $ns)) { $authors += $a.InnerText.Trim() }

        $sumNode  = $entry.SelectSingleNode('atom:summary', $ns)
        $abstract = if ($sumNode) { $script:ArxivExternalMark + ($sumNode.InnerText.Trim() -replace '\s+', ' ') } else { '' }

        $cats = @()
        $primary = $null
        $pc = $entry.SelectSingleNode('arxiv:primary_category', $ns)
        if ($pc -and $pc.GetAttribute('term')) { $primary = $pc.GetAttribute('term'); $cats += $primary }
        foreach ($c in $entry.SelectNodes('atom:category', $ns)) {
            $t = $c.GetAttribute('term'); if ($t -and ($cats -notcontains $t)) { $cats += $t }
        }
        if (-not $primary -and $cats.Count) { $primary = $cats[0] }

        $pubNode = $entry.SelectSingleNode('atom:published', $ns)
        $updNode = $entry.SelectSingleNode('atom:updated', $ns)
        $doiNode = $entry.SelectSingleNode('arxiv:doi', $ns)
        $jrNode  = $entry.SelectSingleNode('arxiv:journal_ref', $ns)
        $cmtNode = $entry.SelectSingleNode('arxiv:comment', $ns)

        $pdfUrl = $null
        foreach ($lnk in $entry.SelectNodes('atom:link', $ns)) {
            if ($lnk.GetAttribute('title') -eq 'pdf') { $pdfUrl = $lnk.GetAttribute('href'); break }
        }
        if (-not $pdfUrl) { $pdfUrl = "https://arxiv.org/pdf/$($parts.Versioned)" }

        $results += [pscustomobject]@{
            id               = $parts.Short
            idv              = $parts.Versioned
            title            = $title
            authors          = $authors
            abstract         = $abstract
            categories       = $cats
            primary_category = $primary
            published        = if ($pubNode) { $pubNode.InnerText } else { '' }
            updated          = if ($updNode) { $updNode.InnerText } else { '' }
            doi              = if ($doiNode) { $doiNode.InnerText } else { $null }
            journal_ref      = if ($jrNode)  { $script:ArxivExternalMark + $jrNode.InnerText } else { $null }
            comment          = if ($cmtNode) { $script:ArxivExternalMark + $cmtNode.InnerText } else { $null }
            pdf_url          = $pdfUrl
            abs_url          = "https://arxiv.org/abs/$($parts.Versioned)"
        }
    }
    # Plain array (no unary-comma wrap): callers that need a count re-wrap with @(), and ,@() would
    # otherwise read as Count 1 for an empty feed.
    return $results
}

# Feed-level OpenSearch counters: how many matched in total (vs how many this page returned) + the
# page offset. Lets an agentic-RAG loop tell "this query matched 4823, refine it" from "matched 3,
# done", and page deeper on a good query. Returns -1 for a field arXiv omitted.
function Get-ArxivFeedMeta {
    param([string]$Xml)
    $doc = [xml]$Xml
    $ns  = [System.Xml.XmlNamespaceManager]::new($doc.NameTable)
    $ns.AddNamespace('os', 'http://a9.com/-/spec/opensearch/1.1/')
    $get = { param($n) $node = $doc.SelectSingleNode("//os:$n", $ns); if ($node -and $node.InnerText) { [int]$node.InnerText } else { -1 } }
    return [pscustomobject]@{
        total    = & $get 'totalResults'
        start    = & $get 'startIndex'
        per_page = & $get 'itemsPerPage'
    }
}

# arXiv's feed carries opensearch:totalResults — how many papers match across ALL of arXiv, not just
# this page. Surfacing it lets an agent run an INFORMED sweep (huge -> narrow; 0 -> rephrase; page on).
function Get-ArxivTotalResults {
    param([string]$Xml)
    try {
        $doc = [xml]$Xml
        $ns  = [System.Xml.XmlNamespaceManager]::new($doc.NameTable)
        $ns.AddNamespace('os', 'http://a9.com/-/spec/opensearch/1.1/')
        $n = $doc.SelectSingleNode('//os:totalResults', $ns)
        if ($n -and $n.InnerText) { return [long]$n.InnerText }
    } catch {}
    return $null
}

# Build the arXiv search_query exactly as arXiv expects: parts joined by AND, categories OR'd, dates as
# submittedDate:[start+TO+end]. The '+' inside '+TO+' must stay literal, so we encode by token replacement
# (the same dance the upstream Python server does) rather than a blanket URL-encode that would mangle it.
function Build-ArxivSearchQuery {
    param([string]$Query, [string[]]$Categories, [string]$DateFrom, [string]$DateTo)
    $parts = @()
    if ($Query -and $Query.Trim())  { $parts += "($($Query.Trim()))" }
    if ($Categories -and $Categories.Count) {
        $parts += '(' + (($Categories | ForEach-Object { "cat:$_" }) -join ' OR ') + ')'
    }
    if ($DateFrom -or $DateTo) {
        $start = if ($DateFrom) { ([datetime]$DateFrom).ToString('yyyyMMdd') + '0000' } else { '199107010000' }
        $end   = if ($DateTo)   { ([datetime]$DateTo).ToString('yyyyMMdd')   + '2359' } else { (Get-Date).ToString('yyyyMMdd') + '2359' }
        $parts += "submittedDate:[$start+TO+$end]"
    }
    if (-not $parts.Count) { throw 'no search criteria provided (need query, categories, or a date bound)' }
    $final = $parts -join ' AND '
    return $final.Replace(' AND ', '+AND+').Replace(' OR ', '+OR+').Replace(' ', '+')
}

function Invoke-ArxivSearch {
    param(
        [string]$Query,
        [string[]]$Categories,
        [string]$DateFrom,
        [string]$DateTo,
        [string]$SortBy = 'relevance',
        [int]$MaxResults = 10,
        [int]$Start = 0
    )
    $max   = [Math]::Min([Math]::Max($MaxResults, 1), 50)
    $start = [Math]::Max($Start, 0)
    $sort  = if ($SortBy -eq 'date') { 'submittedDate' } else { 'relevance' }
    $sq    = Build-ArxivSearchQuery -Query $Query -Categories $Categories -DateFrom $DateFrom -DateTo $DateTo
    $xml   = Invoke-ArxivApi -Query ([ordered]@{
        search_query = $sq; start = $start; max_results = $max; sortBy = $sort; sortOrder = 'descending'
    })
    $papers = @(ConvertFrom-ArxivAtom $xml)
    $feed   = Get-ArxivFeedMeta $xml
    # next_start guides the agent's paging: the offset for the next page, or -1 when the window is exhausted.
    $next = if ($feed.total -ge 0 -and ($start + $papers.Count) -lt $feed.total) { $start + $papers.Count } else { -1 }
    return [pscustomobject]@{
        total_available = $feed.total      # how many papers match the query in all of arXiv (-1 if unknown)
        returned        = $papers.Count    # how many this page carries
        start           = $start
        next_start      = $next            # feed to the next search's start, or -1 if done
        query           = $sq
        papers          = $papers
    }
}

# Single (or comma-separated) id -> full metadata via id_list. Latest version if no vN given.
function Get-ArxivMetadata {
    param([string]$Id)
    $ids = ($Id -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    foreach ($i in $ids) { if (-not (Test-ArxivId $i)) { throw "invalid arXiv id: '$i'" } }
    $xml    = Invoke-ArxivApi -Query ([ordered]@{ id_list = ($ids -join ','); max_results = $ids.Count })
    $papers = @(ConvertFrom-ArxivAtom $xml)
    if (-not $papers.Count) { throw "no arXiv record found for: $Id" }
    if ($papers.Count -eq 1) { return $papers[0] }
    return $papers
}

# --- fetch + inbox ----------------------------------------------------------------------------------
function Invoke-ArxivFetch {
    param(
        [string]$Id,
        [pscustomobject]$Config,
        [string]$StagingRoot,        # absolute
        [string]$RepoRoot,           # absolute, for repo-relative reporting
        [string[]]$Artifacts = @('pdf'),
        [switch]$Force
    )
    if (-not (Test-ArxivId $Id)) { throw "invalid arXiv id: '$Id'" }
    $want = @($Artifacts | ForEach-Object { ([string]$_).ToLowerInvariant() } | Select-Object -Unique)
    if (-not $want.Count) { $want = @('pdf') }
    foreach ($a in $want) {
        if (-not $script:ArxivArtifacts.Contains($a)) { throw "unknown artifact type: '$a' (known: $($script:ArxivArtifacts.Keys -join ', '))" }
    }

    $meta = Get-ArxivMetadata $Id
    if ($meta -is [array]) { $meta = $meta[0] }
    $target = Resolve-ArxivStageTarget -Meta $meta -Config $Config -StagingRoot $StagingRoot
    New-Item -ItemType Directory -Force -Path $target.Dir | Out-Null
    $headers = @{ 'User-Agent' = $script:ArxivUserAgent }

    # Per-artifact fetch: a failure on one (404 / not-a-PDF / PDF-only-no-source) is reported as
    # unavailable and does NOT abort the others. Each result is { staged | available:false + reason }.
    $results = [ordered]@{}
    foreach ($a in $want) {
        if (-not $target.Artifacts.ContainsKey($a)) {
            $results[$a] = @{ available = $false; reason = "no path template for '$a' in layout config" }; continue
        }
        $dest = $target.Artifacts[$a]
        if ((Test-Path -LiteralPath $dest -PathType Leaf) -and -not $Force) {
            $results[$a] = @{ staged = $true; already_present = $true; path = (Get-RepoRelative $dest $RepoRoot); bytes = (Get-Item -LiteralPath $dest).Length }
            continue
        }
        $url = & ($script:ArxivArtifacts[$a].Build) $meta
        $expect = $script:ArxivArtifacts[$a].Expect
        $tmp = "$dest.part"
        $downloaded = $false
        for ($attempt = 1; $attempt -le 3; $attempt++) {
            Wait-ArxivRateLimit
            try {
                # OperationTimeoutSeconds is the key setting: a dead/stalled transfer aborts in ~30s (per-read
                # idle) and retries instead of parking on the full budget. HTTP/2 (falls back to 1.1) is what
                # browsers use and is far more resilient to a lossy link than a pinned 1.1 over TCP — a lost
                # packet head-of-line-blocks a 1.1 stream but not h2/h3. (Fastly also serves HTTP/3, which IWR
                # can't negotiate; the SocketsHttpHandler engine can — see the brief.) -PassThru lets us verify
                # the body isn't truncated.
                $resp = Invoke-WebRequest -Uri $url -OutFile $tmp -Headers $headers -PassThru `
                    -ConnectionTimeoutSeconds 120 -OperationTimeoutSeconds 30 -HttpVersion 2.0 `
                    -MaximumRedirection 5 -ErrorAction Stop
                # Truncation guard (arxiv-mcp-server saw "incomplete response bodies" on larger e-prints): a
                # stalled/cut connection can leave a short file that still passes the magic-byte kind check.
                # If the server gave a Content-Length, a size match is conclusive (TLS guarantees the bytes);
                # when it's absent (chunked), prove a source tarball inflates end-to-end. A miss throws, which
                # Get-ArxivTransience now classes transient, so it retries like any other transport blip.
                $clen = if ($resp -and $resp.Headers.ContainsKey('Content-Length')) { [int64]($resp.Headers['Content-Length'] | Select-Object -First 1) } else { $null }
                $got  = (Get-Item -LiteralPath $tmp).Length
                if ($null -ne $clen) {
                    if ($got -ne $clen) { throw "truncated download: got $got of $clen bytes" }
                } elseif ($a -eq 'source' -and (Get-ArxivPayloadKind -Head (Get-FileHeadBytes -Path $tmp -Count 2)) -eq 'gzip' -and -not (Test-ArxivGzipIntact -Path $tmp)) {
                    throw 'truncated download: source gzip is incomplete (failed to inflate)'
                }
                $downloaded = $true; break
            } catch {
                $ep  = Get-ArxivErrorParts $_
                $cls = Get-ArxivTransience -Code $ep.Code -Message $ep.Message
                if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
                if (-not $cls.Transient -or $attempt -eq 3) {
                    $reason = if ($ep.Code -eq 404) { "arXiv has no '$a' artifact for $($meta.idv) (HTTP 404)" } else { $cls.Message }
                    $results[$a] = @{ available = $false; reason = $reason }
                    break
                }
                Start-Sleep -Milliseconds ([int](400 * [Math]::Pow(2, $attempt - 1)))
            }
        }
        if (-not $downloaded) { continue }
        $kind = Get-ArxivPayloadKind -Head (Get-FileHeadBytes -Path $tmp -Count 16)
        if ($a -eq 'source' -and $kind -eq 'pdf') {
            Remove-Item -LiteralPath $tmp -Force
            $results[$a] = @{ available = $false; reason = 'PDF-only submission — arXiv has no LaTeX/source package for this paper' }
            continue
        }
        if ($kind -ne $expect) {
            Remove-Item -LiteralPath $tmp -Force
            $results[$a] = @{ available = $false; reason = "payload was '$kind', expected '$expect' (arXiv may have served an error page)" }
            continue
        }
        Move-Item -LiteralPath $tmp -Destination $dest -Force
        $results[$a] = @{ staged = $true; already_present = $false; path = (Get-RepoRelative $dest $RepoRoot)
                          bytes = (Get-Item -LiteralPath $dest).Length; url = $url; kind = $kind; fetched_at = (Get-Date).ToString('o') }
    }

    # Merge into any existing sidecar so re-fetching one artifact preserves the records of the others.
    $artifactRecords = @{}
    if (Test-Path -LiteralPath $target.Metadata -PathType Leaf) {
        try {
            $prev = [System.IO.File]::ReadAllText($target.Metadata, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
            if ($prev.artifacts) { foreach ($pp in $prev.artifacts.PSObject.Properties) { $artifactRecords[$pp.Name] = $pp.Value } }
        } catch {}
    }
    foreach ($k in $results.Keys) { $artifactRecords[$k] = $results[$k] }

    $sidecar = [ordered]@{
        id = $meta.id; idv = $meta.idv; title = $meta.title; authors = $meta.authors
        abstract = $meta.abstract; categories = $meta.categories; primary_category = $meta.primary_category
        published = $meta.published; updated = $meta.updated; doi = $meta.doi
        journal_ref = $meta.journal_ref; comment = $meta.comment; abs_url = $meta.abs_url; pdf_url = $meta.pdf_url
        fetched_at = (Get-Date).ToString('o'); fetched_by = 'codex-arxiv-mcp/0.2'; artifacts = $artifactRecords
    }
    [System.IO.File]::WriteAllText($target.Metadata,
        ($sidecar | ConvertTo-Json -Depth 8), [System.Text.UTF8Encoding]::new($false))

    return [pscustomobject]@{
        id = $meta.id; idv = $meta.idv; slug = $target.Slug; title = $meta.title
        metadata_path = (Get-RepoRelative $target.Metadata $RepoRoot); artifacts = $results
    }
}

function Get-RepoRelative {
    param([string]$Full, [string]$RepoRoot)
    try { return [System.IO.Path]::GetRelativePath($RepoRoot, $Full).Replace('\', '/') } catch { return $Full }
}

# Enumerate staged papers by reading their metadata sidecars. The inbox shape is whatever the layout
# config says, so we discover by sidecar filename pattern derived from the metadata template's leaf.
function Get-ArxivInbox {
    param([pscustomobject]$Config, [string]$StagingRoot, [string]$RepoRoot)
    if (-not (Test-Path -LiteralPath $StagingRoot -PathType Container)) { return @() }
    # The metadata template's trailing literal (e.g. '.arxiv.json') is our discovery suffix.
    $leafTpl = Split-Path -Leaf ([string]$Config.layout.metadata)
    $suffix  = ($leafTpl -replace '\{[^}]+\}', '')   # strip placeholders -> '.arxiv.json'
    if (-not $suffix) { $suffix = '.arxiv.json' }
    $items = @()
    foreach ($f in Get-ChildItem -LiteralPath $StagingRoot -Recurse -File -Filter "*$suffix" -ErrorAction SilentlyContinue) {
        try { $m = ([System.IO.File]::ReadAllText($f.FullName, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json) } catch { continue }
        # Summarize which artifacts are actually staged (sidecar may also record unavailable ones).
        $staged = @(); $bytes = 0
        if ($m.artifacts) {
            foreach ($pp in $m.artifacts.PSObject.Properties) {
                if ($pp.Value.staged) { $staged += $pp.Name; $bytes += [long]$pp.Value.bytes }
            }
        }
        $items += [pscustomobject]@{
            id = $m.id; idv = $m.idv; title = $m.title; primary_category = $m.primary_category
            fetched_at = $m.fetched_at; artifacts = $staged; bytes = $bytes
            dir = (Get-RepoRelative $f.DirectoryName $RepoRoot)
            metadata_path = (Get-RepoRelative $f.FullName $RepoRoot)
        }
    }
    return $items
}

function Get-ArxivInboxItem {
    param([string]$Id, [pscustomobject]$Config, [string]$StagingRoot, [string]$RepoRoot)
    $hit = Get-ArxivInbox -Config $Config -StagingRoot $StagingRoot -RepoRoot $RepoRoot |
           Where-Object { $_.id -eq $Id -or $_.idv -eq $Id } | Select-Object -First 1
    if (-not $hit) { throw "not in inbox: $Id" }
    $full = Join-Path $RepoRoot $hit.metadata_path
    $meta = [System.IO.File]::ReadAllText($full, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
    return $meta
}

# Remove one staged paper's directory. Path-confined to the staging root (no escape via a crafted id),
# and re-fetchable, so this is the rare destructive op that is safe to expose to the agent directly.
function Remove-ArxivInboxItem {
    param([string]$Id, [pscustomobject]$Config, [string]$StagingRoot, [string]$RepoRoot)
    $hit = Get-ArxivInbox -Config $Config -StagingRoot $StagingRoot -RepoRoot $RepoRoot |
           Where-Object { $_.id -eq $Id -or $_.idv -eq $Id } | Select-Object -First 1
    if (-not $hit) { throw "not in inbox: $Id" }
    $dir      = Join-Path $RepoRoot $hit.dir
    $dirFull  = [System.IO.Path]::GetFullPath($dir)
    $rootFull = [System.IO.Path]::GetFullPath($StagingRoot)
    $sep      = [System.IO.Path]::DirectorySeparatorChar
    if (-not "$dirFull".StartsWith($rootFull.TrimEnd($sep) + $sep, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "refusing to remove a path outside the staging root: $dir"
    }
    $n = @(Get-ChildItem -LiteralPath $dirFull -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item -LiteralPath $dirFull -Recurse -Force
    return [pscustomobject]@{ removed = $hit.idv; dir = $hit.dir; files_removed = $n }
}

# --- async fetch jobs --------------------------------------------------------------------------------
# A fetch can take many seconds (cold/large e-print packaging on export.arxiv.org), which would freeze the
# single-threaded server and outlast the MCP client's call timeout. So fetch is ENQUEUED onto a background
# worker and returns a job handle immediately; the client polls Get-ArxivFetchJob. ONE worker (not a pool)
# is deliberate: it keeps every download behind the shared 3s arXiv floor, so the server stays non-blocking
# without risking the ban that concurrent downloads would earn.
$script:ArxivJobs        = $null   # ConcurrentDictionary[string, hashtable]  -- the job registry
$script:ArxivQueue       = $null   # BlockingCollection[string]               -- job ids awaiting the worker
$script:ArxivWorkerPS    = $null   # [powershell] running the drain loop
$script:ArxivWorkerAsync = $null   # its IAsyncResult handle

# Stand up the registry, queue, and single worker runspace. Idempotent (a second call is a no-op) so the
# server can call it unconditionally at startup. The worker dot-sources THIS library into its own runspace
# and is pinned to the main runspace's rate-state holder so both honour the one 3s clock.
function Initialize-ArxivJobs {
    param(
        [pscustomobject]$Config,
        [string]$StagingRoot,
        [string]$RepoRoot,
        [string]$LibPath = $script:ArxivLibPath
    )
    if ($script:ArxivJobs) { return }
    $script:ArxivJobs  = [System.Collections.Concurrent.ConcurrentDictionary[string,hashtable]]::new()
    $script:ArxivQueue = [System.Collections.Concurrent.BlockingCollection[string]]::new()

    # CreateDefault() (not CreateDefault2) so the worker runspace has Management + Utility loaded — it needs
    # Invoke-WebRequest, New-Item/Move-Item/Get-Item, ConvertTo/From-Json, Get-Date, Start-Sleep.
    $iss = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
    $rs  = [runspacefactory]::CreateRunspace($iss)
    $rs.Open()
    $rs.SessionStateProxy.SetVariable('WJobs',        $script:ArxivJobs)
    $rs.SessionStateProxy.SetVariable('WQueue',       $script:ArxivQueue)
    $rs.SessionStateProxy.SetVariable('WRateState',   $script:ArxivRateState)
    $rs.SessionStateProxy.SetVariable('WConfig',      $Config)
    $rs.SessionStateProxy.SetVariable('WStagingRoot', $StagingRoot)
    $rs.SessionStateProxy.SetVariable('WRepoRoot',    $RepoRoot)
    $rs.SessionStateProxy.SetVariable('WLibPath',     $LibPath)

    $ps = [powershell]::Create()
    $ps.Runspace = $rs
    [void]$ps.AddScript({
        # Progress UI would spray the host stream that the protocol channel shares; this runspace does not
        # inherit the main runspace's preference, so silence it here too.
        $ProgressPreference = 'SilentlyContinue'
        . $WLibPath
        Use-ArxivRateState $WRateState          # share the ONE 3s clock with the main runspace
        # Drain the queue one job at a time until the server completes it (shutdown). GetConsumingEnumerable
        # blocks with no busy-wait and ends cleanly once CompleteAdding is called.
        foreach ($jobId in $WQueue.GetConsumingEnumerable()) {
            $rec = $null
            if (-not $WJobs.TryGetValue($jobId, [ref]$rec)) { continue }
            $rec.status     = 'running'
            $rec.started_at = (Get-Date).ToString('o')
            try {
                $out = Invoke-ArxivFetch -Id $rec.arxiv_id -Config $WConfig `
                    -StagingRoot $WStagingRoot -RepoRoot $WRepoRoot `
                    -Artifacts ([string[]]$rec.artifacts) -Force:([bool]$rec.force)
                $rec.result = $out
                $rec.status = 'done'
            } catch {
                $rec.reason = [string]$_.Exception.Message
                $rec.status = 'failed'
            }
            $rec.finished_at = (Get-Date).ToString('o')
        }
    })
    $script:ArxivWorkerPS    = $ps
    $script:ArxivWorkerAsync = $ps.BeginInvoke()
}

# Enqueue a fetch. Validates the id synchronously (so a bad id fails the tool call now, not silently on the
# worker) then returns a { job_id, status: queued } handle. The download itself happens on the worker.
function Add-ArxivFetchJob {
    param([string]$Id, [string[]]$Artifacts = @('pdf'), [switch]$Force)
    if (-not $script:ArxivJobs) { throw 'fetch jobs not initialized (call Initialize-ArxivJobs first)' }
    if (-not (Test-ArxivId $Id)) { throw "invalid arXiv id: '$Id'" }
    $want = @($Artifacts | ForEach-Object { ([string]$_).ToLowerInvariant() } | Select-Object -Unique)
    if (-not $want.Count) { $want = @('pdf') }
    $jobId = 'job-' + [guid]::NewGuid().ToString('N').Substring(0, 12)
    $rec = @{
        id = $jobId; arxiv_id = $Id; artifacts = $want; force = [bool]$Force
        status = 'queued'; result = $null; reason = $null
        enqueued_at = (Get-Date).ToString('o'); started_at = $null; finished_at = $null
    }
    [void]$script:ArxivJobs.TryAdd($jobId, $rec)
    $script:ArxivQueue.Add($jobId)
    return [pscustomobject]@{
        job_id = $jobId; status = 'queued'; arxiv_id = $Id; artifacts = $want
        note = 'fetch running in background — poll fetch_status with this job_id'
    }
}

# Project a job record to a clean output view (result only when done, reason only when failed).
function ConvertTo-ArxivJobView {
    param([hashtable]$Rec)
    $v = [ordered]@{
        job_id = $Rec.id; arxiv_id = $Rec.arxiv_id; artifacts = $Rec.artifacts; status = $Rec.status
        enqueued_at = $Rec.enqueued_at; started_at = $Rec.started_at; finished_at = $Rec.finished_at
    }
    if ($Rec.status -eq 'done')   { $v['result'] = $Rec.result }
    if ($Rec.status -eq 'failed') { $v['reason'] = $Rec.reason }
    return [pscustomobject]$v
}

# Is the background worker still draining the queue? Its normal state is Running (parked on the queue);
# any other state while the server is up means the drain loop exited unexpectedly and queued/running jobs
# will never progress. Used to (a) stop a long-poll from waiting out its whole window on a dead worker and
# (b) flag stalled jobs so the agent stops polling a job that can't advance.
function Test-ArxivWorkerAlive {
    if (-not $script:ArxivWorkerPS) { return $false }
    return ($script:ArxivWorkerPS.InvocationStateInfo.State -in @('Running', 'NotStarted'))
}

# Best-effort reason a dead worker died, for the stalled-job annotation.
function Get-ArxivWorkerError {
    if (-not $script:ArxivWorkerPS) { return 'worker not started' }
    $e = $script:ArxivWorkerPS.Streams.Error | Select-Object -First 1
    if ($e) { return [string]$e } else { return 'worker drain loop exited without an error record' }
}

# One job by id, or (no id) every job newest-first. Evicts terminal jobs past the TTL first so the registry
# doesn't grow without bound in a long-lived server.
#
# WaitSeconds > 0 is the opt-in long-poll: block up to that many seconds (hard-capped at $MaxWaitSeconds so
# the call can't outlive the MCP client's own tool timeout) for a still-running job to finish, returning the
# instant it goes terminal. The worker mutates the SAME $rec hashtable from its runspace, so re-reading
# $rec.status here sees its progress with no re-lookup. A dead worker breaks the wait immediately and the
# returned view is flagged stalled + worker_error so the caller stops polling.
function Get-ArxivFetchJob {
    param([string]$JobId, [int]$TtlMinutes = 30, [int]$WaitSeconds = 0, [int]$MaxWaitSeconds = 55)
    if (-not $script:ArxivJobs) { throw 'fetch jobs not initialized' }
    Clear-ArxivStaleJobs -TtlMinutes $TtlMinutes
    if ($JobId) {
        $rec = $null
        if (-not $script:ArxivJobs.TryGetValue($JobId, [ref]$rec)) { throw "no such fetch job: $JobId" }
        if ($WaitSeconds -gt 0 -and $rec.status -in @('queued', 'running')) {
            $deadline = (Get-Date).AddSeconds([Math]::Min($WaitSeconds, $MaxWaitSeconds))
            while ($rec.status -in @('queued', 'running') -and (Get-Date) -lt $deadline) {
                if (-not (Test-ArxivWorkerAlive)) { break }
                Start-Sleep -Milliseconds 500
            }
        }
        $view = ConvertTo-ArxivJobView $rec
        if ($rec.status -in @('queued', 'running') -and -not (Test-ArxivWorkerAlive)) {
            $view | Add-Member -NotePropertyName stalled      -NotePropertyValue $true                 -Force
            $view | Add-Member -NotePropertyName worker_error -NotePropertyValue (Get-ArxivWorkerError) -Force
        }
        return $view
    }
    return @($script:ArxivJobs.Values | ForEach-Object { ConvertTo-ArxivJobView $_ } |
             Sort-Object -Property enqueued_at -Descending)
}

# Drop done/failed jobs whose finished_at is older than the TTL. Queued/running jobs are never evicted.
function Clear-ArxivStaleJobs {
    param([int]$TtlMinutes = 30)
    if (-not $script:ArxivJobs) { return }
    $cutoff = (Get-Date).AddMinutes(-$TtlMinutes)
    foreach ($pair in $script:ArxivJobs.ToArray()) {
        $r = $pair.Value
        if ($r.status -notin @('done','failed') -or -not $r.finished_at) { continue }
        # Tolerant parse: a malformed finished_at must never crash a status poll — just skip its eviction.
        $fin = [datetime]::MinValue
        if ([datetime]::TryParse([string]$r.finished_at, [ref]$fin) -and $fin -lt $cutoff) {
            $tmp = $null; [void]$script:ArxivJobs.TryRemove($pair.Key, [ref]$tmp)
        }
    }
}

# Graceful shutdown for tests/teardown: stop accepting work, let the worker exit its drain loop, dispose.
# The live server doesn't call this (process exit reaps the worker); it exists so tests don't leak runspaces.
function Stop-ArxivJobs {
    if ($script:ArxivQueue)    { try { $script:ArxivQueue.CompleteAdding() } catch {} }
    if ($script:ArxivWorkerPS) {
        try { [void]$script:ArxivWorkerPS.EndInvoke($script:ArxivWorkerAsync) } catch {}
        try { $script:ArxivWorkerPS.Runspace.Dispose() } catch {}
        try { $script:ArxivWorkerPS.Dispose() } catch {}
    }
    $script:ArxivWorkerPS = $null; $script:ArxivWorkerAsync = $null
    $script:ArxivJobs = $null; $script:ArxivQueue = $null
}
