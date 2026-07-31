#requires -Version 7.0
<#
  src/reader-mcp/reader-mcp.ps1 — the CONSUMER-side MCP server over codex-scientiae deliverable bundles.

  Two planes, two audiences. codex-membrane is the librarian's instrument: it ingests, audits, repairs and
  publishes. This is the reader's: it opens finished bundles and slices them, and it can do nothing else —
  there is no write path anywhere in this file.

  SELF-CONTAINED BY DESIGN. It encodes codex-scientiae's bundle conventions (that is the whole point) but
  dot-sources nothing from src/, so it can be installed globally and pointed at any directory holding
  bundles — codex-scientiae itself, or a satellite repo of published deliverables. Agents that consume the
  corpus never need the generating tree on disk.

    pwsh -NoProfile -File reader-mcp.ps1 -Root <dir-of-bundles>

  A BUNDLE is the standard single-document deliverable:
      {slug}/{slug}.md            the manuscript
      {slug}/{slug}.toc.jsonl     byte-spanned section index   <- the machine entry point
      {slug}/{slug}-tree.md       human/agent manifest + frontmatter
      {slug}/images/*             assets referenced by the manuscript
  Discovery keys on the .toc.jsonl, because that is the file that makes a directory READABLE by span.
#>

[CmdletBinding()]
param(
    [string]$Root = (Get-Location).Path,
    [string]$ProtocolVersion = '2025-06-18'
)

$ServerInfo = @{ name = 'codex-reader'; version = '0.1.0' }

# --- own the protocol channel at the .NET level, pinned to UTF-8 (no BOM) ---------------------------
# Redirected std streams on Windows otherwise default to the ANSI/OEM code page, which collapses SMP
# Unicode (𝔼, surrogate pairs) to '?'/U+FFFD on both read and write — fatal for a math corpus.
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$script:Utf8 = [System.Text.UTF8Encoding]::new($false)
$script:Rpc = [System.IO.StreamWriter]::new([Console]::OpenStandardOutput(), $script:Utf8); $script:Rpc.AutoFlush = $true
$script:In = [System.IO.StreamReader]::new([Console]::OpenStandardInput(), $script:Utf8)
[Console]::SetOut([Console]::Error)   # stray host writes land in the log, never mid-frame on stdout

function Write-Log([string]$m) { [Console]::Error.WriteLine($m) }
function Write-Rpc($id, $result) {
    $script:Rpc.WriteLine((@{ jsonrpc = '2.0'; id = $id; result = $result } | ConvertTo-Json -Depth 24 -Compress))
}
function Write-RpcError($id, [int]$code, [string]$message) {
    $script:Rpc.WriteLine((@{ jsonrpc = '2.0'; id = $id; error = @{ code = $code; message = $message } } | ConvertTo-Json -Depth 8 -Compress))
}
function New-TextResult([string]$text) { return @{ content = @(@{ type = 'text'; text = $text }) } }
function New-JsonResult($obj) { return New-TextResult ($obj | ConvertTo-Json -Depth 24) }

# --- bundle discovery ------------------------------------------------------------------------------
# Keyed on {slug}.toc.jsonl: that sidecar is what makes a directory readable BY SPAN, which is this
# server's entire reason to exist. A directory holding a bare .md is a file, not a bundle.
$script:BundleCache = $null

function Get-Bundles([switch]$Refresh) {
    if ($script:BundleCache -and -not $Refresh) { return $script:BundleCache }
    $found = [System.Collections.Generic.List[object]]::new()
    if ([System.IO.Directory]::Exists($Root)) {
        foreach ($sidecar in [System.IO.Directory]::EnumerateFiles($Root, '*.toc.jsonl', [System.IO.SearchOption]::AllDirectories)) {
            $dir = [System.IO.Path]::GetDirectoryName($sidecar)
            $slug = [System.IO.Path]::GetFileName($sidecar) -replace '\.toc\.jsonl$', ''
            $md = Join-Path $dir "$slug.md"
            if (-not [System.IO.File]::Exists($md)) { continue }
            $found.Add([pscustomobject]@{
                    slug     = $slug
                    dir      = $dir
                    markdown = $md
                    toc      = $sidecar
                    tree     = Join-Path $dir "$slug-tree.md"
                })
        }
    }
    $script:BundleCache = @($found | Sort-Object slug)
    return $script:BundleCache
}

function Resolve-Bundle([string]$Slug) {
    if ([string]::IsNullOrWhiteSpace($Slug)) { throw 'slug is required' }
    $hit = @(Get-Bundles | Where-Object { $_.slug -eq $Slug })
    if ($hit.Count -eq 1) { return $hit[0] }
    if ($hit.Count -gt 1) { throw "ambiguous slug '$Slug' — $($hit.Count) bundles share it" }
    $known = @(Get-Bundles | Select-Object -First 12 -ExpandProperty slug) -join ', '
    throw "no bundle '$Slug' under $Root$(if ($known) { " — known: $known" })"
}

# Section index straight off the machine sidecar. One JSON object per line; unreadable lines are skipped
# rather than fatal, so one corrupt row cannot make a whole document unreadable.
function Get-Sections($Bundle) {
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($Bundle.toc, $script:Utf8)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try { $rows.Add(($line | ConvertFrom-Json)) } catch { Write-Log "skipping malformed toc row in $($Bundle.slug): $($_.Exception.Message)" }
    }
    return $rows
}

# Manifest frontmatter, when the tree sidecar is present. Deliberately a small hand-rolled reader: a
# YAML dependency is not worth carrying for six scalar fields, and the block is engine-generated.
function Get-Frontmatter($Bundle) {
    $fm = [ordered]@{}
    if (-not [System.IO.File]::Exists($Bundle.tree)) { return $fm }
    $text = [System.IO.File]::ReadAllText($Bundle.tree, $script:Utf8)
    $m = [regex]::Match($text, '(?s)\A---\r?\n(.*?)\r?\n---')
    if (-not $m.Success) { return $fm }
    foreach ($line in ($m.Groups[1].Value -split '\r?\n')) {
        $kv = [regex]::Match($line, '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*?)\s*$')
        if (-not $kv.Success) { continue }
        $v = $kv.Groups[2].Value.Trim()
        if ($v.Length -ge 2 -and $v.StartsWith('"') -and $v.EndsWith('"')) { $v = $v.Substring(1, $v.Length - 2) }
        $fm[$kv.Groups[1].Value] = $v
    }
    return $fm
}

# --- UTF-8-safe byte slicing -----------------------------------------------------------------------
# Continuation bytes are 10xxxxxx (0x80–0xBF); a boundary landing on one is mid-codepoint. Start walks
# BACK to the lead byte and end walks FORWARD past the continuation, so a slice never splits a character
# and never silently drops one — it over-includes at the edges instead, which is harmless when reading.
#
# NOTE this is a BYTE-domain rule. Codex-scientiae's own masks.ps1 helpers snap UTF-16 surrogate pairs
# and index CHAR positions; feeding them a byte offset is a units error, not a safety net.
function Get-SafeSlice([byte[]]$Bytes, [int]$Start, [int]$End) {
    $n = $Bytes.Length
    if ($Start -lt 0) { $Start = 0 }
    if ($End -gt $n) { $End = $n }
    if ($End -le $Start) { return @{ text = ''; byte_start = $Start; byte_end = $Start } }
    while ($Start -gt 0 -and ($Bytes[$Start] -band 0xC0) -eq 0x80) { $Start-- }
    while ($End -lt $n -and ($Bytes[$End] -band 0xC0) -eq 0x80) { $End++ }
    return @{ text = $script:Utf8.GetString($Bytes, $Start, $End - $Start); byte_start = $Start; byte_end = $End }
}

# --- tools -----------------------------------------------------------------------------------------

function Tool-ListDocuments($a) {
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($b in Get-Bundles) {
        $fm = Get-Frontmatter $b
        $out.Add([ordered]@{
                slug          = $b.slug
                title         = [string]$fm['title']
                authors       = [string]$fm['authors']
                doi           = [string]$fm['doi']
                total_bytes   = if ($fm['total_bytes']) { [int]$fm['total_bytes'] } else { (Get-Item -LiteralPath $b.markdown).Length }
                section_count = if ($fm['section_count']) { [int]$fm['section_count'] } else { (Get-Sections $b).Count }
                path          = [System.IO.Path]::GetRelativePath($Root, $b.dir).Replace('\', '/')
            })
    }
    return New-JsonResult @{ root = $Root; count = $out.Count; documents = $out }
}

function Tool-GetManifest($a) {
    $b = Resolve-Bundle ([string]$a.slug)
    $sections = @(Get-Sections $b | ForEach-Object {
            [ordered]@{ level = $_.level; heading = $_.heading; anchor = $_.anchor
                byte_start = $_.byte_start; byte_end = $_.byte_end; byte_width = $_.byte_width
            }
        })
    $assets = @()
    $imgDir = Join-Path $b.dir 'images'
    if ([System.IO.Directory]::Exists($imgDir)) {
        $assets = @([System.IO.Directory]::EnumerateFiles($imgDir, '*', [System.IO.SearchOption]::AllDirectories) |
            ForEach-Object { [System.IO.Path]::GetRelativePath($b.dir, $_).Replace('\', '/') } | Sort-Object)
    }
    return New-JsonResult @{
        slug = $b.slug; frontmatter = (Get-Frontmatter $b); section_count = $sections.Count
        sections = $sections; assets = $assets
        usage = 'read_section with an anchor for a whole section; read_span for an arbitrary [byte_start, byte_end).'
    }
}

function Tool-ReadSection($a) {
    $b = Resolve-Bundle ([string]$a.slug)
    $anchor = [string]$a.anchor
    if ([string]::IsNullOrWhiteSpace($anchor)) { throw 'anchor is required (see get_manifest)' }
    $sections = @(Get-Sections $b)
    $idx = -1
    for ($i = 0; $i -lt $sections.Count; $i++) { if ($sections[$i].anchor -eq $anchor) { $idx = $i; break } }
    if ($idx -lt 0) { throw "no section '$anchor' in $($b.slug) — call get_manifest for the anchor list" }

    # `following` extends the read through N subsequent sections, so a caller chasing a subsection tree
    # does not have to issue one call per heading.
    $following = 0
    if ($null -ne $a.following) { $following = [Math]::Max(0, [int]$a.following) }
    $last = [Math]::Min($sections.Count - 1, $idx + $following)

    $bytes = [System.IO.File]::ReadAllBytes($b.markdown)
    $slice = Get-SafeSlice $bytes ([int]$sections[$idx].byte_start) ([int]$sections[$last].byte_end)
    return New-JsonResult @{
        slug = $b.slug; anchor = $anchor; heading = $sections[$idx].heading
        sections_read = ($last - $idx + 1)
        byte_start = $slice.byte_start; byte_end = $slice.byte_end
        byte_width = ($slice.byte_end - $slice.byte_start)
        text = $slice.text
    }
}

function Tool-ReadSpan($a) {
    $b = Resolve-Bundle ([string]$a.slug)
    if ($null -eq $a.byte_start -or $null -eq $a.byte_end) { throw 'byte_start and byte_end are both required' }
    $bytes = [System.IO.File]::ReadAllBytes($b.markdown)
    $slice = Get-SafeSlice $bytes ([int]$a.byte_start) ([int]$a.byte_end)
    return New-JsonResult @{
        slug = $b.slug; requested = @{ byte_start = [int]$a.byte_start; byte_end = [int]$a.byte_end }
        byte_start = $slice.byte_start; byte_end = $slice.byte_end
        byte_width = ($slice.byte_end - $slice.byte_start)
        snapped = ($slice.byte_start -ne [int]$a.byte_start -or $slice.byte_end -ne [int]$a.byte_end)
        text = $slice.text
    }
}

function Tool-SearchHeadings($a) {
    $q = [string]$a.query
    if ([string]::IsNullOrWhiteSpace($q)) { throw 'query is required' }
    $rx = [regex]::new($q, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $scope = if ($a.slug) { @(Resolve-Bundle ([string]$a.slug)) } else { Get-Bundles }
    $hits = [System.Collections.Generic.List[object]]::new()
    foreach ($b in $scope) {
        foreach ($s in (Get-Sections $b)) {
            if ($rx.IsMatch([string]$s.heading)) {
                $hits.Add([ordered]@{ slug = $b.slug; heading = $s.heading; anchor = $s.anchor
                        level = $s.level; byte_start = $s.byte_start; byte_end = $s.byte_end; byte_width = $s.byte_width
                    })
            }
        }
    }
    return New-JsonResult @{ query = $q; count = $hits.Count; matches = $hits }
}

$Tools = @(
    @{ name        = 'list_documents'
       description = 'Enumerate the deliverable bundles under the served root, with title/authors/doi/size from each manifest. Start here when you do not already know a slug.'
       inputSchema = @{ type = 'object'; properties = @{} } }
    @{ name        = 'get_manifest'
       description = 'The section index for one document: every heading with its anchor and half-open byte span [byte_start, byte_end), plus manifest frontmatter and the asset list. Read this before slicing — anchors and spans come from here.'
       inputSchema = @{ type = 'object'; properties = @{ slug = @{ type = 'string' } }; required = @('slug') } }
    @{ name        = 'read_section'
       description = 'Read one section of a document by its anchor, resolved through the byte-spanned index. Optional `following` extends the read through N subsequent sections in document order. Spans are addresses, not budgets: a short section may carry the central result, and prose sections carry the rationale that makes the formal content intelligible.'
       inputSchema = @{ type = 'object'; properties = @{
                slug      = @{ type = 'string' }
                anchor    = @{ type = 'string'; description = 'anchor from get_manifest' }
                following = @{ type = 'integer'; description = 'also read this many sections after it (default 0)' }
            }; required = @('slug', 'anchor') } }
    @{ name        = 'read_span'
       description = 'Read an arbitrary half-open byte range [byte_start, byte_end) from a document. Boundaries landing mid-codepoint are snapped outward to whole characters; `snapped` reports whether that happened. Prefer read_section when a whole section is what you want.'
       inputSchema = @{ type = 'object'; properties = @{
                slug       = @{ type = 'string' }
                byte_start = @{ type = 'integer' }
                byte_end   = @{ type = 'integer' }
            }; required = @('slug', 'byte_start', 'byte_end') } }
    @{ name        = 'search_headings'
       description = 'Regex search over section headings, across every bundle under the root or within one document. Returns hits with their byte spans, so a match can be read immediately.'
       inputSchema = @{ type = 'object'; properties = @{
                query = @{ type = 'string'; description = 'regex, case-insensitive' }
                slug  = @{ type = 'string'; description = 'optional: restrict to one document' }
            }; required = @('query') } }
)

function Invoke-Tool([string]$name, $a) {
    switch ($name) {
        'list_documents'  { return Tool-ListDocuments $a }
        'get_manifest'    { return Tool-GetManifest $a }
        'read_section'    { return Tool-ReadSection $a }
        'read_span'       { return Tool-ReadSpan $a }
        'search_headings' { return Tool-SearchHeadings $a }
        default           { throw "unknown tool: $name" }
    }
}

# --- main loop: newline-delimited JSON-RPC from stdin until EOF -------------------------------------
$script:Initialized = $false
while ($null -ne ($line = $script:In.ReadLine())) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $req = $null
    try { $req = $line | ConvertFrom-Json } catch { Write-Log "unparseable frame: $($_.Exception.Message)"; continue }
    $hasId = $null -ne $req.PSObject.Properties['id']
    $id = if ($hasId) { $req.id } else { $null }
    try {
        switch ([string]$req.method) {
            'initialize' {
                $n = @(Get-Bundles -Refresh).Count
                Write-Rpc $id @{
                    protocolVersion = $ProtocolVersion
                    capabilities    = @{ tools = @{} }
                    serverInfo      = $ServerInfo
                    instructions    = "codex-reader: $n bundle(s) under '$Root'. READ-ONLY — this server opens finished deliverables and slices them; it cannot modify anything. Each document ships a byte-spanned section index, so you can read one section without loading the manuscript. Start with list_documents (or get_manifest if you know the slug), then read_section by anchor. Byte spans are ADDRESSES for returning to a place, not a budget for deciding whether to go there — section size says nothing about importance."
                }
                $script:Initialized = $true
                Write-Log "codex-reader: serving $n bundle(s) from $Root"
            }
            'notifications/initialized' { }
            'tools/list' { Write-Rpc $id @{ tools = $Tools } }
            'tools/call' {
                try { Write-Rpc $id (Invoke-Tool ([string]$req.params.name) $req.params.arguments) }
                catch { Write-Rpc $id @{ content = @(@{ type = 'text'; text = "error: $($_.Exception.Message)" }); isError = $true } }
            }
            'ping' { Write-Rpc $id @{} }
            default { if ($hasId) { Write-RpcError $id -32601 "method not found: $($req.method)" } }
        }
    } catch {
        if ($hasId) { Write-RpcError $id -32603 "internal error: $($_.Exception.Message)" }
        Write-Log "request error ($($req.method)): $($_.Exception.Message)"
    }
}
