#requires -Version 7.0
<#
  src/mcp-servers/procurement/zenodo-server.ps1 — pure-PowerShell MCP server for Zenodo acquisition.

  Protocol: Newline-delimited JSON-RPC 2.0 on stdin/stdout, UTF-8 no-BOM.
  Exposes tools: search, get_metadata, fetch, fetch_status, list_inbox, inspect, clear.
#>

[CmdletBinding()]
param(
    [string]$StagingRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot '../../procurement/schemas/zenodo-staging.json'),
    [string]$ProtocolVersion = '2025-06-18'
)

$script:ProcurementLibRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../procurement'))
. (Join-Path $script:ProcurementLibRoot 'zenodo.ps1')

$ProgressPreference = 'SilentlyContinue'
$RepoRoot   = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
$ServerInfo = @{ name = 'codex-zenodo'; version = '0.1.0' }

$Config = Get-ZenodoConfig -Path $ConfigPath
$rawRoot = if ($StagingRoot) { $StagingRoot } else { [string]$Config.staging_root }
$EffectiveStagingRoot = if ([System.IO.Path]::IsPathRooted($rawRoot)) {
    [System.IO.Path]::GetFullPath($rawRoot)
} else {
    [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $rawRoot))
}

Initialize-ZenodoJobs -Config $Config -StagingRoot $EffectiveStagingRoot -RepoRoot $RepoRoot `
    -LibPath (Join-Path $script:ProcurementLibRoot 'zenodo.ps1')

$Tools = @(
    @{ name = 'search'
       description = 'Search Zenodo records via REST API (https://zenodo.org/api/records). Returns total_available, returned, page, size, and hits array.'
       inputSchema = @{ type = 'object'; properties = @{
           query = @{ type = 'string'; description = 'Free text or fielded query string' }
           type = @{ type = 'string'; description = 'Optional resource type filter (publication, dataset, software, poster)' }
           sort = @{ type = 'string'; enum = @('bestmatch', 'mostrecent'); description = 'Sort order (default bestmatch)' }
           size = @{ type = 'integer'; description = 'Results per page (default 10)' }
           page = @{ type = 'integer'; description = 'Page number (default 1)' }
       }; required = @('query') } }
    @{ name = 'get_metadata'
       description = 'Get raw record metadata and file manifest for a Zenodo record ID (e.g. 1234567) or DOI (10.5281/zenodo.1234567).'
       inputSchema = @{ type = 'object'; properties = @{
           id = @{ type = 'string'; description = 'Zenodo record ID or DOI' }
       }; required = @('id') } }
    @{ name = 'fetch'
       description = 'Stage a Zenodo record into ingestion/_inbox/{slug}/. Non-blocking; returns job_id.'
       inputSchema = @{ type = 'object'; properties = @{
           id = @{ type = 'string'; description = 'Zenodo record ID or DOI' }
           artifacts = @{ type = 'array'; items = @{ type = 'string'; enum = @('pdf', 'source') }; description = 'Artifact types to stage (default ["pdf"])' }
           force = @{ type = 'boolean'; description = 'Re-download even if already staged' }
       }; required = @('id') } }
    @{ name = 'fetch_status'
       description = 'Poll a background Zenodo fetch job status.'
       inputSchema = @{ type = 'object'; properties = @{
           job_id = @{ type = 'string'; description = 'Job ID returned by fetch' }
       } } }
)

function Invoke-Tool([string]$name, $arguments) {
    switch ($name) {
        'search' {
            $out = Invoke-ZenodoSearch -Query ([string]$arguments.query) `
                -Type ([string]$arguments.type) `
                -Sort $(if ($arguments.sort) { [string]$arguments.sort } else { 'bestmatch' }) `
                -Size $(if ($arguments.size) { [int]$arguments.size } else { 10 }) `
                -Page $(if ($arguments.page) { [int]$arguments.page } else { 1 })
        }
        'get_metadata' { $out = Get-ZenodoMetadata ([string]$arguments.id) }
        'fetch' {
            $arts = if ($arguments.artifacts) { [string[]]@($arguments.artifacts) } else { @('pdf') }
            $out = Start-ZenodoFetchJob -Id ([string]$arguments.id) -Artifacts $arts -Force:([bool]$arguments.force)
        }
        'fetch_status' { $out = Get-ZenodoJobStatus -JobId ([string]$arguments.job_id) }
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

$script:Initialized = $false
Write-Log "codex-zenodo MCP server up (staging=$EffectiveStagingRoot)"

try {
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
                $result = @{ protocolVersion = $pv; capabilities = @{ tools = @{} }; serverInfo = $ServerInfo; instructions = "codex-zenodo acquisition server" }
                $script:Initialized = $true
                Write-Rpc $id $result
            }
            'notifications/initialized' { }
            'tools/list' { Write-Rpc $id @{ tools = $Tools } }
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
    }
}
} finally { }
