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
. "$PSScriptRoot/restructure.ps1"
. "$PSScriptRoot/preprocess.ps1"
. "$PSScriptRoot/finalize.ps1"

$ServerInfo = @{ name = 'codex-membrane'; version = '0.1.0' }

# --- tool catalogue: name -> description + JSON-Schema for arguments ---
$Tools = @(
    @{ name = 'list_documents'
       description = 'Survey the ingestion root: every {slug}/{slug}.json raw with whether it has been preprocessed and its current milestone stage. Body-blind. The "Go" starting point.'
       inputSchema = @{ type = 'object'; properties = @{} } }
    @{ name = 'preprocess'
       description = 'Run the seven-stage pipeline on a document''s raw IR, landing the enriched chunk stream + sidecars in its .scratch/ and logging the preprocessed milestone. Refuses to clobber applied repairs unless force=true.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; force = @{ type = 'boolean' } }; required = @('paper') } }
    @{ name = 'get_inventory'
       description = 'The in-play artifacts registered for a document: each durable file with stage, record count, byte size, and source (the build chain). The object-state window, complementing the milestone ledger.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'finalize'
       description = 'Close the loop: serialize the repaired chunk stream into the corpus deliverable — a {slug}.md body (H1 title, Contents, sections at depth, block math fenced) plus a references/{slug}.md bibliography sidecar, per STANDARDS.md. First pass writes into the document''s .scratch/. Returns counts; pending = flagged chunks still unresolved (the deliverable is provisional while pending > 0). Logs the finalized milestone.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'review_document'
       description = 'The one sanctioned holistic read. The membrane is body-blind by design — the repair loop works through scoped slices and never re-reads the whole paper. Call this ONCE at the end, after repairs are applied: it assembles the current deliverable and returns the full body + references sidecar for a final spot-check, alongside the still-flagged chunks (id + reason) so the read is targeted. Content IS the return here. Anything you catch, fix with propose_edit on the named chunk, then review again.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'get_summary'
       description = 'Body-blind metadata map of one document: title, zones, section count, repaired/flagged counts, remaining hotspots by type.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string'; description = 'document name, no extension' } }; required = @('paper') } }
    @{ name = 'get_hotspots'
       description = 'The graded work-list for a document: each flagged chunk with id, page, grade, corruption_type, section, preview.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; type = @{ type = 'string'; description = 'optional corruption_type filter' } }; required = @('paper') } }
    @{ name = 'get_slice'
       description = 'Return exactly one chunk by id (plus optional +/- context neighbours), seeked via the .jidx index.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; context = @{ type = 'integer'; description = 'neighbours each side (default 0)' } }; required = @('paper', 'id') } }
    @{ name = 'propose_edit'
       description = 'Pointed surgical fix on one chunk: replace a UNIQUE find-string with replace (empty replace = delete). Never regenerates the chunk -- send only the diff. Stacks on prior staged edits; reports whether the result is clean or still flagged (with diagnostic). The hard gate is commit. PREFER this over propose_repair.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; find = @{ type = 'string'; description = 'exact substring to replace; must occur exactly once in the current content' }; replace = @{ type = 'string'; description = 'replacement text (empty string deletes the find)' }; source = @{ type = 'string' } }; required = @('paper', 'id', 'find', 'replace') } }
    @{ name = 'propose_repair'
       description = 'Wholesale fallback: stage full replacement content for one chunk. Use ONLY when corruption is so total there is no anchor for propose_edit. Accepted only if it passes the corruption detector; a rejection returns the precise delimiter diagnostic.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; content = @{ type = 'string' }; source = @{ type = 'string' } }; required = @('paper', 'id', 'content') } }
    @{ name = 'apply'
       description = 'Fold all staged proposals for a document into the stream (only clean ones merge; still-flagged stay staged), clear the leases merged, and log the milestone. NOT a git commit.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'release'
       description = 'Free leased work-units abandoned by a worker so they can be re-dispatched. Pass ids to release some, or omit to release all of a document.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; ids = @{ type = 'array'; items = @{ type = 'integer' } } }; required = @('paper') } }
    @{ name = 'retype_chunk'
       description = 'Structural: change the type of one chunk (e.g. a formula mis-typed as prose). In place, no id change; re-grades the chunk.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; new_type = @{ type = 'string'; description = 'e.g. formula | prose | heading | table | list' } }; required = @('paper', 'id', 'new_type') } }
    @{ name = 'split_chunk'
       description = 'Structural: split one chunk into two at a UNIQUE marker (the marker begins the second chunk). Renumbers ids + rebuilds the index, so re-orient after. Refuses while content proposals are staged.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; before = @{ type = 'string'; description = 'unique substring that starts the second chunk' } }; required = @('paper', 'id', 'before') } }
    @{ name = 'merge_chunks'
       description = 'Structural: merge a contiguous run of chunks into one (e.g. a formula fragmented across chunks). Renumbers ids + rebuilds the index, so re-orient after. Refuses while content proposals are staged.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; ids = @{ type = 'array'; items = @{ type = 'integer' }; description = 'contiguous chunk ids' } }; required = @('paper', 'ids') } }
    @{ name = 'get_batch_summary'
       description = 'Body-blind batch map: per document under the server root, counts (chunks, pages, repaired, actionable, handoff) plus the actionable byte-size. The orchestrator plans and budgets the whole batch from this without reading any bodies.'
       inputSchema = @{ type = 'object'; properties = @{} } }
    @{ name = 'dispatch'
       description = 'Return the next bundle of agent-actionable work-unit pointers (paper, id, grade, section, seam — never content) whose total size fits a byte budget; the orchestrator fans its workers over them. Stateless: commit between dispatches.'
       inputSchema = @{ type = 'object'; properties = @{ budget_bytes = @{ type = 'integer'; description = 'max total content bytes in the bundle (default 40000)' }; paper = @{ type = 'string'; description = 'optional: restrict to one document' } } } }
    @{ name = 'search'
       description = 'Restoration-native query over a document: filter chunks by any combination of zone, section (regex), grade, type, page, content (regex). Returns body-light pointers (id, page, type, grade, section, preview), capped at limit.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; zone = @{ type = 'string' }; section = @{ type = 'string'; description = 'regex' }; grade = @{ type = 'string'; description = 'faithful|repaired|needs_review|needs_repair|suspect|unrecoverable' }; type = @{ type = 'string'; description = 'prose|formula|heading|table|list' }; page = @{ type = 'integer' }; contains = @{ type = 'string'; description = 'content regex' }; limit = @{ type = 'integer' } }; required = @('paper') } }
    @{ name = 'get_audit'
       description = 'Provenance of what the pipeline removed or changed. No filter -> per-kind counts; with id or kind -> the matching records. Kinds: discards (figure debris), repair (excised tails), apply (agent before/after), structure (retype/split/merge).'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; kind = @{ type = 'string'; description = 'discards|repair|apply|structure' } }; required = @('paper') } }
    @{ name = 'mark_unrecoverable'
       description = 'Terminal escalation: the agent tried and cannot repair this chunk from the export. Sets fidelity=unrecoverable (the rare hand-off that earns re-extraction by the successor) and drops any staged edit. Use sparingly -- a high unrecoverable rate indicts the repair attempt, not the export.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; reason = @{ type = 'string' } }; required = @('paper', 'id') } }
    @{ name = 'request_review'
       description = 'Human check-in: queue a chunk for the supervising user with a message (surfaces as review_pending in get_summary). Use when uncertain rather than guessing.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; message = @{ type = 'string' } }; required = @('paper', 'id', 'message') } }
)

# --- helpers ---
function Resolve-Paper([string]$paper) {
    if ([string]::IsNullOrWhiteSpace($paper) -or $paper -notmatch '^[\w.\-]+$') { throw "invalid paper name: '$paper'" }
    $path = @(Invoke-Crawl -Root $Root -Patterns "**/.scratch/$paper.chunks.jsonl" -Semantics Include) | Select-Object -First 1
    if (-not $path) { throw "document not found or not preprocessed: $paper" }
    return $path
}
function Resolve-Source([string]$paper) {
    if ([string]::IsNullOrWhiteSpace($paper) -or $paper -notmatch '^[\w.\-]+$') { throw "invalid paper name: '$paper'" }
    $path = @(Invoke-Crawl -Root $Root -Patterns "**/$paper/$paper.json" -Semantics Include) | Select-Object -First 1
    if (-not $path) { throw "source raw not found: $paper" }
    return $path
}

function Invoke-Tool([string]$name, $arguments) {
    switch ($name) {
        'list_documents' { $out = @(Get-IngestionScan -Root $Root) }
        'preprocess'     { $out = Invoke-Preprocess -JsonPath (Resolve-Source $arguments.paper) -Force:([bool]$arguments.force) }
        'get_inventory'  { $out = Get-Inventory (Resolve-Paper $arguments.paper) }
        'finalize'        { $out = Invoke-Finalize  -ChunksPath (Resolve-Paper $arguments.paper) }
        'review_document' { $out = Get-FinalReview  (Resolve-Paper $arguments.paper) }
        'get_summary'  { $out = Get-IrSummary -ChunksPath (Resolve-Paper $arguments.paper) }
        'get_hotspots' {
            $p = Resolve-Paper $arguments.paper
            $out = if ($arguments.type) { Get-IrHotspots -ChunksPath $p -Type ([string]$arguments.type) } else { Get-IrHotspots -ChunksPath $p }
        }
        'get_slice'    { $out = Get-Slice -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Context ([int]$arguments.context) }
        'propose_edit' {
            $src = if ($arguments.source) { [string]$arguments.source } else { 'worker' }
            $out = Add-RepairEdit -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Find ([string]$arguments.find) -Replace ([string]$arguments.replace) -Source $src
        }
        'propose_repair' {
            $src = if ($arguments.source) { [string]$arguments.source } else { 'worker' }
            $out = Add-RepairProposal -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Content ([string]$arguments.content) -Source $src
        }
        'apply'        { $out = Invoke-RepairApply -ChunksPath (Resolve-Paper $arguments.paper) }
        'release'      { $rids = if ($arguments.ids) { [int[]]@($arguments.ids) } else { @() }; $out = Clear-Leases -ChunksPath (Resolve-Paper $arguments.paper) -Ids $rids }
        'retype_chunk' { $out = Set-ChunkType -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -NewType ([string]$arguments.new_type) }
        'split_chunk'  { $out = Split-Chunk   -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Before ([string]$arguments.before) }
        'merge_chunks' { $out = Merge-Chunks  -ChunksPath (Resolve-Paper $arguments.paper) -Ids ([int[]]@($arguments.ids)) }
        'get_batch_summary' { $out = @(Get-BatchSummary -Root $Root) }
        'dispatch' {
            $bud = if ($arguments.budget_bytes) { [long]$arguments.budget_bytes } else { 40000 }
            $out = if ($arguments.paper) { Invoke-Dispatch -Root $Root -BudgetBytes $bud -Paper ([string]$arguments.paper) } else { Invoke-Dispatch -Root $Root -BudgetBytes $bud }
        }
        'search' {
            $out = Search-Chunks -ChunksPath (Resolve-Paper $arguments.paper) `
                -Zone ([string]$arguments.zone) -Section ([string]$arguments.section) -Grade ([string]$arguments.grade) `
                -Type ([string]$arguments.type) -Page $(if ($null -ne $arguments.page) { [int]$arguments.page } else { -1 }) `
                -Contains ([string]$arguments.contains) -Limit $(if ($arguments.limit) { [int]$arguments.limit } else { 50 })
        }
        'get_audit'          { $out = Get-Audit -ChunksPath (Resolve-Paper $arguments.paper) -Id $(if ($null -ne $arguments.id) { [int]$arguments.id } else { -1 }) -Kind ([string]$arguments.kind) }
        'mark_unrecoverable' { $out = Set-Unrecoverable -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Reason ([string]$arguments.reason) }
        'request_review'     { $out = Add-ReviewRequest -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Message ([string]$arguments.message) }
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
