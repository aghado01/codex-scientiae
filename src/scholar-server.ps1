#requires -Version 7.0
<#
  src/scholar-server.ps1 — a pure-PowerShell MCP server for cross-source scholarly DISCOVERY, sibling to
  codex-arxiv (acquisition) and codex-membrane (ingestion). Same protocol spine: newline-delimited
  JSON-RPC 2.0 on stdin/stdout, UTF-8 no-BOM, stdout = protocol frames only.

  It fronts the shared discovery core (scholar-core.ps1) + source adapters (OpenAlex, Semantic Scholar)
  behind one surface — search / related / resolve_doi / get_work — normalizing every source to the Work
  model and deduping the same paper across graphs. Discovery only: it returns DOIs/arXiv-ids/metadata; it
  does NOT stage bytes (that is codex-arxiv / the future sci-hub fetcher).

  Launch:  pwsh -NoProfile -File src/scholar-server.ps1 [-Mailto <email>] [-ConfigPath <scholar-config.json>]
  Secrets/contact come from ENV: CODEX_SCHOLAR_MAILTO (or -Mailto), SEMANTIC_SCHOLAR_API_KEY (optional).
#>

[CmdletBinding()]
param(
    [string]$Mailto,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'scholar-config.json'),
    [string]$ProtocolVersion = '2025-06-18'
)

. "$PSScriptRoot/scholar-core.ps1"
. "$PSScriptRoot/openalex.ps1"
. "$PSScriptRoot/semanticscholar.ps1"

$ProgressPreference = 'SilentlyContinue'
$ServerInfo = @{ name = 'codex-scholar'; version = '0.1.0' }

# Config (non-secret defaults) + identification. Contact: -Mailto > env CODEX_SCHOLAR_MAILTO (no hardcode).
$Config = if (Test-Path -LiteralPath $ConfigPath -PathType Leaf) {
    [System.IO.File]::ReadAllText($ConfigPath, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
} else {
    [pscustomobject]@{ default_sources = @('openalex', 'semanticscholar'); per_page = 25 }
}
$contact = if ($Mailto) { $Mailto } elseif ($env:CODEX_SCHOLAR_MAILTO) { $env:CODEX_SCHOLAR_MAILTO } else { '' }
if ($contact) { Set-ScholarContact $contact }
$PerPage = if ($Config.per_page) { [int]$Config.per_page } else { 25 }

$SourceEnumAll = @('openalex', 'semanticscholar', 'all')
$SourceEnumOne = @('openalex', 'semanticscholar')

# --- tool catalogue ---
$Tools = @(
    @{ name = 'discover_search'
       description = 'Search the scholarly graph for papers — the discovery half of cross-source agentic RAG. source="all" (default) fans across OpenAlex + Semantic Scholar and returns ONE deduped+merged record per paper (source="openalex+semanticscholar"); a single source returns that source''s page with a total_available/next_start envelope. Each Work carries doi AND arxiv_id when known (the acquisition cross-walk), plus abstract/tldr/citation_count. Semantic Scholar is keyless-rate-limited, so a fan degrades gracefully (returns OpenAlex + notes the S2 error). Metadata + abstracts, not paper bodies.'
       inputSchema = @{ type = 'object'; properties = @{
           query = @{ type = 'string'; description = 'free-text or fielded query' }
           source = @{ type = 'string'; enum = $SourceEnumAll; description = 'which graph (default "all" = fan + dedup)' }
           filters = @{ type = 'array'; items = @{ type = 'string' }; description = 'OpenAlex-only literal filters, e.g. ["from_publication_date:2020-01-01"] (ignored for other sources)' }
           start = @{ type = 'integer'; description = 'page offset (default 0); pass back next_start' }
           max_results = @{ type = 'integer'; description = 'results per source (default from config)' }
       }; required = @('query') } }
    @{ name = 'discover_related'
       description = 'Walk the citation/relatedness graph from one paper. kind="citations" (who cites it — forward in time), "references" (what it cites — back to foundations), or "recommendations" (semantic nearest-neighbors, Semantic Scholar/SPECTER only). Returns normalized Work[]. Seed from a seminal paper you found, expand, synthesize.'
       inputSchema = @{ type = 'object'; properties = @{
           id = @{ type = 'string'; description = 'a Work id (OpenAlex W-id or S2 paperId), a DOI, or an arXiv id' }
           kind = @{ type = 'string'; enum = @('citations','references','recommendations'); description = 'graph edge to follow (default citations)' }
           source = @{ type = 'string'; enum = $SourceEnumOne; description = 'which graph (default openalex; recommendations forces semanticscholar)' }
           max_results = @{ type = 'integer'; description = 'cap (default 25)' }
       }; required = @('id') } }
    @{ name = 'resolve_doi'
       description = 'Resolve a loose reference / title / DOI / arXiv id to candidate Work(s) with a canonical DOI — the cross-walk that links the same paper across sources and feeds DOI-based acquisition (sci-hub). A bare DOI/arXiv id resolves directly; a title does a bibliographic search. Returns ranked candidates.'
       inputSchema = @{ type = 'object'; properties = @{
           reference = @{ type = 'string'; description = 'a DOI, arXiv id, title, or free citation string' }
           source = @{ type = 'string'; enum = $SourceEnumOne; description = 'resolver source (default openalex, keyless)' }
       }; required = @('reference') } }
    @{ name = 'get_work'
       description = 'Full normalized Work for one identifier (Work id, DOI, or arXiv id). Same record shape as discover_search results. No disk writes.'
       inputSchema = @{ type = 'object'; properties = @{
           id = @{ type = 'string'; description = 'a Work id, DOI, or arXiv id' }
           source = @{ type = 'string'; enum = $SourceEnumOne; description = 'which graph (default openalex)' }
       }; required = @('id') } }
)

$Prompts = @(
    @{ name = 'discovery_procedure'
       description = 'The cross-source hunt-and-synthesize playbook: orient with discover_search (fan), walk the graph with discover_related (citations/references/recommendations), cross-walk with resolve_doi, converge, and hand keepers (arXiv id / DOI) to acquisition. Inject at the start of a discovery session.' }
)
function Get-PromptText([string]$name) {
    switch ($name) {
        'discovery_procedure' { return [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot 'scholar-discovery.md'), [System.Text.UTF8Encoding]::new($false)) }
        default { throw "prompt not found: $name" }
    }
}

# --- tool dispatch ---
function Invoke-Tool([string]$name, $arguments) {
    switch ($name) {
        'discover_search' {
            $q       = [string]$arguments.query
            $src     = if ($arguments.source) { [string]$arguments.source } else { 'all' }
            $start   = if ($null -ne $arguments.start) { [int]$arguments.start } else { 0 }
            $max     = if ($arguments.max_results) { [int]$arguments.max_results } else { $PerPage }
            $filters = if ($arguments.filters) { [string[]]@($arguments.filters) } else { @() }
            switch ($src) {
                'openalex'        { $out = OpenAlex-Search -Query $q -Filters $filters -Start $start -PerPage $max }
                'semanticscholar' { $out = SemanticScholar-Search -Query $q -Start $start -Limit $max }
                default {
                    # fan across both, dedup+merge; ANY single source failing (e.g. an S2 429 or a
                    # transient blip) is noted per-source, never sinks the whole search.
                    $perSource = @(); $all = @()
                    foreach ($srcName in @('openalex', 'semanticscholar')) {
                        try {
                            $pg = if ($srcName -eq 'openalex') { OpenAlex-Search -Query $q -Filters $filters -Start $start -PerPage $max }
                                  else { SemanticScholar-Search -Query $q -Start $start -Limit $max }
                            $perSource += [pscustomobject]@{ source = $srcName; total_available = $pg.total_available; returned = $pg.returned }
                            $all += @($pg.works)
                        } catch {
                            $perSource += [pscustomobject]@{ source = $srcName; error = [string]$_.Exception.Message }
                        }
                    }
                    $merged = @(Merge-ScholarWorks $all)
                    $out = [pscustomobject]@{ source = 'all'; sources = $perSource; returned = $merged.Count; works = $merged }
                }
            }
        }
        'discover_related' {
            $id   = [string]$arguments.id
            $kind = if ($arguments.kind) { [string]$arguments.kind } else { 'citations' }
            $src  = if ($arguments.source) { [string]$arguments.source } else { 'openalex' }
            $lim  = if ($arguments.max_results) { [int]$arguments.max_results } else { 25 }
            if ($kind -eq 'recommendations') { $src = 'semanticscholar' }   # only S2 has it
            $out = switch ($src) {
                'semanticscholar' { @(SemanticScholar-Related -Id $id -Kind $kind -Limit $lim) }
                default           { @(OpenAlex-Related -Id $id -Kind $kind -Limit $lim) }
            }
        }
        'resolve_doi' {
            $ref = [string]$arguments.reference
            $src = if ($arguments.source) { [string]$arguments.source } else { 'openalex' }
            $out = switch ($src) {
                'semanticscholar' { @(SemanticScholar-Resolve $ref) }
                default           { @(OpenAlex-Resolve $ref) }
            }
        }
        'get_work' {
            $id  = [string]$arguments.id
            $src = if ($arguments.source) { [string]$arguments.source } else { 'openalex' }
            $out = switch ($src) {
                'semanticscholar' { SemanticScholar-GetWork $id }
                default           { OpenAlex-GetWork $id }
            }
        }
        default { throw "unknown tool: $name" }
    }
    $text = if ($null -eq $out) { '(no output)' } else { $out | ConvertTo-Json -Depth 12 -Compress }
    return @{ content = @(@{ type = 'text'; text = $text }) }
}

function Invoke-ToolGuarded([string]$name, $arguments) {
    $result = $null
    Invoke-Tool $name $arguments 3>&1 4>&1 5>&1 6>&1 | ForEach-Object {
        if ($_ -is [System.Collections.IDictionary]) { $result = $_ }
        else { [Console]::Error.WriteLine([string]$_) }
    }
    return $result
}

# --- own the protocol channel at the .NET level, pinned to UTF-8 (no BOM) ---
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$utf8 = [System.Text.UTF8Encoding]::new($false)
$script:Rpc = [System.IO.StreamWriter]::new([Console]::OpenStandardOutput(), $utf8); $script:Rpc.AutoFlush = $true
$script:In  = [System.IO.StreamReader]::new([Console]::OpenStandardInput(),  $utf8)
[Console]::SetOut([Console]::Error)

function Write-Log([string]$m) { [Console]::Error.WriteLine($m) }
function Write-Rpc($id, $result) {
    $script:Rpc.WriteLine((@{ jsonrpc = '2.0'; id = $id; result = $result } | ConvertTo-Json -Depth 16 -Compress))
}
function Write-RpcError($id, [int]$code, [string]$message) {
    $script:Rpc.WriteLine((@{ jsonrpc = '2.0'; id = $id; error = @{ code = $code; message = $message } } | ConvertTo-Json -Depth 8 -Compress))
}

$script:Readiness = $null
$script:Initialized = $false
$s2key  = if ($env:SEMANTIC_SCHOLAR_API_KEY) { 'set' } else { 'unset (keyless, rate-limited)' }
$mailNote = if ($contact) { "contact $contact" } else { 'no contact (set CODEX_SCHOLAR_MAILTO for OpenAlex polite pool)' }
Write-Log "codex-scholar MCP server up (sources: openalex, semanticscholar; S2 key $s2key; $mailNote)"

# --- main loop ---
while ($null -ne ($line = $script:In.ReadLine())) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    try { $req = $line | ConvertFrom-Json } catch { Write-RpcError $null -32700 'parse error'; continue }

    $hasId = $null -ne $req.PSObject.Properties['id']
    $id = if ($hasId) { $req.id } else { $null }

    try {
    if (-not $script:Initialized -and $req.method -ne 'initialize' -and $req.method -ne 'ping') {
        if ($hasId) { Write-RpcError $id -32600 'not initialized' }
        continue
    }
    switch ($req.method) {
        'initialize' {
            $pv = if ($req.params.protocolVersion) { [string]$req.params.protocolVersion } else { $ProtocolVersion }
            $result = @{ protocolVersion = $pv; capabilities = @{ tools = @{}; prompts = @{} }; serverInfo = $ServerInfo }
            if ($null -eq $script:Readiness) {
                $script:Readiness = "codex-scholar: cross-source scholarly DISCOVERY (OpenAlex + Semantic Scholar), sibling to codex-arxiv (acquisition). Use discover_search (fan + dedup) to find papers, discover_related to walk citations/references/recommendations, resolve_doi to cross-walk, get_work for full records — every result is a normalized Work carrying doi + arxiv_id for the acquisition hand-off. This connection is your live session — call these tools directly. Semantic Scholar is keyless-rate-limited ($s2key); fans degrade gracefully. Inject the discovery_procedure prompt for the full agentic-RAG playbook. Discovery only — staging bytes is codex-arxiv / sci-hub."
            }
            $result.instructions = $script:Readiness
            $script:Initialized = $true
            Write-Rpc $id $result
        }
        'notifications/initialized' { }
        'tools/list' { Write-Rpc $id @{ tools = $Tools } }
        'prompts/list' { Write-Rpc $id @{ prompts = $Prompts } }
        'prompts/get' {
            $pname = [string]$req.params.name
            try {
                $text = Get-PromptText $pname
                $desc = (@($Prompts | Where-Object { $_.name -eq $pname }) | Select-Object -First 1).description
                Write-Rpc $id @{ description = $desc; messages = @(@{ role = 'user'; content = @{ type = 'text'; text = $text } }) }
            } catch {
                Write-RpcError $id -32602 "prompt not found: $pname"
            }
        }
        'tools/call' {
            try {
                Write-Rpc $id (Invoke-ToolGuarded ([string]$req.params.name) $req.params.arguments)
            } catch {
                Write-Rpc $id @{ content = @(@{ type = 'text'; text = "error: $($_.Exception.Message)" }); isError = $true }
            }
        }
        'ping' { Write-Rpc $id @{} }
        default { if ($hasId) { Write-RpcError $id -32601 "method not found: $($req.method)" } }
    }
    } catch {
        if ($hasId) { Write-RpcError $id -32603 "internal error: $($_.Exception.Message)" }
        Write-Log "request error ($($req.method)): $($_.Exception.Message)"
    }
}
