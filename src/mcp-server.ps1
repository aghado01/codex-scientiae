#requires -Version 7.0
<#
  src/mcp-server.ps1 — a pure-PowerShell MCP server over the restoration membrane.

  MCP is a protocol, not a runtime: newline-delimited JSON-RPC 2.0 on stdin/stdout, one
  compact JSON object per line. stdout carries protocol frames ONLY — all logging goes to
  stderr, and every membrane call's output is captured (never left to render to stdout) so
  the stream stays clean. This server exposes serving.ps1's membrane as tools, rooted at a
  work dir where <paper>.chunks.jsonl artifacts live; every tool is paper-addressed, so the
  same server serves one document (depth-1) or a whole batch (depth-n) unchanged.

  Launch from a client's MCP config (-NoProfile keeps the profile off stdout):
    pwsh -NoProfile -File src/mcp-server.ps1 -Root <work-dir>

  Tools: list_documents | get_summary | get_hotspots | get_slice | propose_repair | commit
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Root,
    [string]$ProtocolVersion = '2025-06-18'
)

. "$PSScriptRoot/serving.ps1"

$ServerInfo = @{ name = 'codex-membrane'; version = '0.1.0' }

# --- tool catalogue: name -> description + JSON-Schema for arguments ---
$Tools = @(
    @{ name = 'list_documents'
       description = 'List the documents available under the server root (body-blind).'
       inputSchema = @{ type = 'object'; properties = @{} } }
    @{ name = 'get_summary'
       description = 'Body-blind metadata map of one document: title, zones, section count, repaired/flagged counts, remaining hotspots by type.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string'; description = 'document name, no extension' } }; required = @('paper') } }
    @{ name = 'get_hotspots'
       description = 'The graded work-list for a document: each flagged chunk with id, page, grade, corruption_type, section, preview.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; type = @{ type = 'string'; description = 'optional corruption_type filter' } }; required = @('paper') } }
    @{ name = 'get_slice'
       description = 'Return exactly one chunk by id (plus optional +/- context neighbours), seeked via the .jidx index.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; context = @{ type = 'integer'; description = 'neighbours each side (default 0)' } }; required = @('paper', 'id') } }
    @{ name = 'propose_repair'
       description = 'Stage a repair for one chunk. Accepted only if it passes the corruption detector; a rejection returns the precise delimiter diagnostic. One proposal file per id, so concurrent workers never conflict.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; content = @{ type = 'string' }; source = @{ type = 'string' } }; required = @('paper', 'id', 'content') } }
    @{ name = 'commit'
       description = 'Merge all staged proposals for a document deterministically, re-grade to faithful, and write a before/after audit sidecar.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
)

# --- helpers ---
function Resolve-Paper([string]$paper) {
    if ([string]::IsNullOrWhiteSpace($paper) -or $paper -notmatch '^[\w.\-]+$') { throw "invalid paper name: '$paper'" }
    $path = Join-Path $Root "$paper.chunks.jsonl"
    if (-not (Test-Path -LiteralPath $path)) { throw "document not found: $paper" }
    return $path
}

function Invoke-Tool([string]$name, $arguments) {
    switch ($name) {
        'list_documents' {
            $out = @(Get-ChildItem -LiteralPath $Root -Filter '*.chunks.jsonl' -File -ErrorAction SilentlyContinue |
                     ForEach-Object { $_.Name -replace '\.chunks\.jsonl$', '' })
        }
        'get_summary'  { $out = Get-IrSummary -ChunksPath (Resolve-Paper $arguments.paper) }
        'get_hotspots' {
            $p = Resolve-Paper $arguments.paper
            $out = if ($arguments.type) { Get-IrHotspots -ChunksPath $p -Type ([string]$arguments.type) } else { Get-IrHotspots -ChunksPath $p }
        }
        'get_slice'    { $out = Get-Slice -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Context ([int]$arguments.context) }
        'propose_repair' {
            $src = if ($arguments.source) { [string]$arguments.source } else { 'worker' }
            $out = Add-RepairProposal -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Content ([string]$arguments.content) -Source $src
        }
        'commit'       { $out = Invoke-RepairCommit -ChunksPath (Resolve-Paper $arguments.paper) }
        default        { throw "unknown tool: $name" }
    }
    $text = if ($null -eq $out) { '(no output)' } else { $out | ConvertTo-Json -Depth 12 -Compress }
    return @{ content = @(@{ type = 'text'; text = $text }) }
}

# --- JSON-RPC framing (one compact line per message; stdout = protocol only) ---
function Write-Rpc($id, $result) {
    [Console]::Out.WriteLine((@{ jsonrpc = '2.0'; id = $id; result = $result } | ConvertTo-Json -Depth 16 -Compress))
}
function Write-RpcError($id, [int]$code, [string]$message) {
    [Console]::Out.WriteLine((@{ jsonrpc = '2.0'; id = $id; error = @{ code = $code; message = $message } } | ConvertTo-Json -Depth 8 -Compress))
}

[Console]::Error.WriteLine("codex-membrane MCP server up (root=$Root)")

# --- main loop: newline-delimited JSON-RPC from stdin until EOF ---
while ($null -ne ($line = [Console]::In.ReadLine())) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    try { $req = $line | ConvertFrom-Json } catch { Write-RpcError $null -32700 'parse error'; continue }

    $hasId = $null -ne $req.PSObject.Properties['id']
    $id = if ($hasId) { $req.id } else { $null }

    switch ($req.method) {
        'initialize' {
            $pv = if ($req.params.protocolVersion) { [string]$req.params.protocolVersion } else { $ProtocolVersion }
            Write-Rpc $id @{ protocolVersion = $pv; capabilities = @{ tools = @{} }; serverInfo = $ServerInfo }
        }
        'tools/list' { Write-Rpc $id @{ tools = $Tools } }
        'tools/call' {
            try {
                Write-Rpc $id (Invoke-Tool ([string]$req.params.name) $req.params.arguments)
            } catch {
                Write-Rpc $id @{ content = @(@{ type = 'text'; text = "error: $($_.Exception.Message)" }); isError = $true }
            }
        }
        'ping' { Write-Rpc $id @{} }
        default { if ($hasId) { Write-RpcError $id -32601 "method not found: $($req.method)" } }  # notifications ignored
    }
}
