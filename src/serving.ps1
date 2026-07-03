#requires -Version 7.0
<#
  src/serving.ps1 — serving layer over the enriched chunk-JSONL.

  The membrane: orchestrator-facing tools read metadata only (body-blind, so a
  50-page doc costs a few hundred tokens), and the sub-agent-facing slice tool
  returns exactly one work-unit by id via the .jidx seek (a worker never loads
  more than its slice + the context it explicitly asks for).

  The write-side closes the loop, one chunk at a time (one proposal file per id, so
  concurrent workers never conflict). Add-RepairEdit is the pointed path — a surgical
  find->replace that never regenerates the chunk (anti-leakage); Add-RepairProposal is the
  wholesale fallback for anchorless corruption. The hard gate is apply: Invoke-RepairApply
  folds only clean staged content into the stream (Get-CorruptionType is the gate), keeps
  still-flagged proposals staged for more editing, clears the leases it merged, and writes a
  before/after audit. (apply is NOT a git commit.)

    . ./serving.ps1
    Get-IrSummary       -ChunksPath <chunks.jsonl>
    Get-IrHotspots      -ChunksPath <chunks.jsonl> [-Type intertext]
    Get-Slice           -ChunksPath <chunks.jsonl> -Id <n> [-Context 1]
    Add-RepairEdit      -ChunksPath <chunks.jsonl> -Id <n> -Find <str> -Replace <str> [-Source <who>]
    Add-RepairProposal  -ChunksPath <chunks.jsonl> -Id <n> -Content <repaired> [-Source <who>]
    Invoke-RepairApply  -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>]
#>

. "$PSScriptRoot/jsonl.ps1"
. "$PSScriptRoot/fidelity.ps1"
. "$PSScriptRoot/playbook.ps1"   # the repair recipes-as-data the work-order composer pools
. "$PSScriptRoot/crawl.ps1"
. "$PSScriptRoot/runs.ps1"       # run layout ({paper}/.runs/{stamp}) + {paper}@{run} addressing
. "$PSScriptRoot/normalize.ps1"
. "$PSScriptRoot/enrichment.ps1"

function Read-Chunks([string]$Path) {
    [System.IO.File]::ReadLines($Path) | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json }
}

# agreement (Part A): a chunk's structural-ambiguity score for dispatch RANKING. Absent ⇒ 1.0 (nothing
# disputed, lowest priority). fidelity.ps1 computes/stores it; here we only read it for ordering + surfacing.
function Get-ChunkAgreement($Chunk) {
    $v = $Chunk.agreement
    if ($null -ne $v) { return [double]$v }
    return 1.0
}

# run layout + paper addressing live in runs.ps1 (shared with non-membrane lanes, e.g. the LaTeX
# converter's tarball unpacking) — sourced below with the other layers.

# --- discovery over the per-source run layout (crawler, not -Recurse) ---
# ONE current view per paper: the newest run's chunks (legacy .scratch only if no .runs).
function Get-ChunkFiles([string]$Root) {
    $all = @(Invoke-Crawl -Root $Root -Patterns '**/.scratch/*.chunks.jsonl', '**/.runs/*/*.chunks.jsonl' -Semantics Include)
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($cp in $all) {
        $paperDir = Get-PaperDirFromChunks $cp
        $slug     = (Split-Path -Leaf $cp) -replace '\.chunks\.jsonl$', ''
        if ($seen.Add("$paperDir|$slug")) { Get-LatestChunks $paperDir $slug }
    }
}

# survey the ingestion target: each paper raw + whether it's been preprocessed. A paper may carry
# one or both IR lanes — {slug}/{slug}.json (opendataloader/docling era) and/or
# {slug}/{slug}.pdfdig.json (the pdfdig converter's envelope) — aggregated into one row with a
# `lanes` field so the agent can see what intake dialects exist and pick one at preprocess.
function Get-IngestionScan([string]$Root) {
    $papers = [ordered]@{}
    foreach ($json in (Invoke-Crawl -Root $Root -Patterns '**/*.json' -Semantics Include)) {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($json)
        $lane = 'opendataloader'; $slug = $base
        if ($base.EndsWith('.pdfdig')) { $lane = 'pdfdig'; $slug = $base.Substring(0, $base.Length - 7) }
        $paperDir = Split-Path -Parent $json
        if ((Split-Path -Leaf $paperDir) -ne $slug) { continue }   # only {slug}/{slug}[.pdfdig].json raws (skips inventory.json etc.)
        $key = "$paperDir|$slug"
        if (-not $papers.Contains($key)) {
            $papers[$key] = @{ slug = $slug; dir = $paperDir; lanes = [System.Collections.Generic.List[string]]::new(); src = @{} }
        }
        if (-not $papers[$key].lanes.Contains($lane)) { $papers[$key].lanes.Add($lane) }
        $papers[$key].src[$lane] = $json
    }
    foreach ($key in $papers.Keys) {
        $p = $papers[$key]
        $runs    = @(Get-RunChunks $p.dir $p.slug)
        $chunks  = if ($runs.Count) { $runs[0] } else { $null }
        $prepped = [bool]$chunks
        $stage = $null
        # Fault isolation: a corrupt ledger flags this one unit 'unreadable' instead of aborting the
        # whole survey (one bad unit must not blind the agent to every healthy one in the batch).
        if ($prepped) { try { $stage = (Get-LedgerStage $chunks).stage } catch { $stage = 'unreadable' } }
        $srcPath = if ($p.src.ContainsKey('opendataloader')) { $p.src['opendataloader'] } else { $p.src['pdfdig'] }
        [pscustomobject]@{
            paper      = $p.slug
            source     = ([System.IO.Path]::GetRelativePath($Root, $srcPath) -replace '\\', '/')
            lanes      = @($p.lanes | Sort-Object)
            prepped    = $prepped
            stage      = $stage
            runs       = $runs.Count
            latest_run = if ($chunks) { Get-RunName $chunks } else { $null }   # pin any run as {paper}@{run}
        }
    }
}

# --- lease: anti-clobber by construction. dispatch marks units in-flight so a later dispatch
#     can't re-hand them; apply clears what it merged; release frees abandoned ones. One lease
#     file per document, so the per-paper state never contends.
function Get-LeasedIds([string]$ChunksPath) {
    $p = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.leases.json'
    if (Test-Path -LiteralPath $p) { return @(([System.IO.File]::ReadAllText($p, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json).leased | ForEach-Object { [int]$_ }) }
    return @()
}
function Set-LeasedIds([string]$ChunksPath, [int[]]$Ids) {
    $p = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.leases.json'
    [System.IO.File]::WriteAllText($p, (@{ leased = @($Ids | Sort-Object -Unique) } | ConvertTo-Json -Compress), [System.Text.UTF8Encoding]::new($false))
}
function Clear-Leases([string]$ChunksPath, [int[]]$Ids) {
    if ($Ids -and $Ids.Count) { Set-LeasedIds $ChunksPath @(Get-LeasedIds $ChunksPath | Where-Object { $_ -notin $Ids }) }
    else { Set-LeasedIds $ChunksPath @() }
    [pscustomobject]@{ ok = $true; leased = @(Get-LeasedIds $ChunksPath).Count }
}

# --- orchestrator-facing: metadata only ---

function Get-IrSummary {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath)
    $chunks = @(Read-Chunks $ChunksPath)
    $reqPath = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.review-requests.jsonl'
    $enrich  = Get-EnrichmentCounts (Get-EnrichablesFromChunks $chunks)
    [pscustomobject]@{
        chunks   = $chunks.Count
        pages    = (@($chunks.page | Sort-Object -Unique)).Count
        title    = ($chunks | Where-Object { $_.title_candidate } | Select-Object -First 1).content
        zones    = ($chunks | Group-Object zone | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ' '
        sections = @($chunks | Where-Object { $_.type -eq 'heading' -and $_.section_level -and $_.is_furniture -ne 'running_head' }).Count
        repaired = @($chunks | Where-Object { $_.fidelity -eq 'repaired' }).Count
        flagged  = @($chunks | Where-Object { $_.fidelity -in 'suspect','needs_review','needs_repair' }).Count
        unrecoverable = @($chunks | Where-Object { $_.fidelity -eq 'unrecoverable' }).Count
        hotspots = ($chunks | Where-Object { $_.corruption_type -and $_.fidelity -in 'suspect','needs_review','needs_repair' } | Group-Object corruption_type | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ' '
        review_pending = $(if (Test-Path -LiteralPath $reqPath) { @([System.IO.File]::ReadLines($reqPath) | Where-Object { $_ }).Count } else { 0 })
        enrichable     = $enrich.enrichable
        enrichable_buckets = "safe-wrap=$($enrich.safe_wrap) lossy=$($enrich.lossy) auto=$($enrich.auto_tier) review=$($enrich.review_tier)"
    }
}

function Get-Enrichables {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath)
    return @(Get-EnrichablesFromChunks @(Read-Chunks $ChunksPath))
}

function Group-MathHotspots($chunks) {
    $spans = [System.Collections.Generic.List[object]]::new()
    $run = [System.Collections.Generic.List[object]]::new()
    $commitRun = {
        if ($run.Count -gt 1) {
            $join = ($run.content) -join "`n"
            $balJoin = Get-LatexBalance $join
            $hasUnbalanced = $false
            $sumPartsRes = 0
            foreach ($m in $run) {
                $b = Get-LatexBalance $m.content
                if (-not $b.full) { $hasUnbalanced = $true }
                $sumPartsRes += [Math]::Abs($b.brace) + [Math]::Abs($b.brack) + [Math]::Abs($b.paren) + [Math]::Abs($b.lr)
            }
            $joinRes = [Math]::Abs($balJoin.brace) + [Math]::Abs($balJoin.brack) + [Math]::Abs($balJoin.paren) + [Math]::Abs($balJoin.lr)
            
            if ($hasUnbalanced -and ($balJoin.full -or $joinRes -lt $sumPartsRes)) {
                $spans.Add([pscustomobject]@{
                    ids = @($run.id)
                    pages = @($run.page | Sort-Object -Unique)
                    bytes = $join.Length
                    joined_seam = "brace=$($balJoin.brace) brack=$($balJoin.brack) paren=$($balJoin.paren) lr=$($balJoin.lr)"
                    preview_joined = $join.Substring(0, [Math]::Min(54, $join.Length))
                })
            }
        }
        $run.Clear()
    }
    
    foreach ($c in $chunks) {
        # math-dense = formula, or prose carrying enough un-wrapped math to be part of the equation
        # (density via the normalize math_dirt count, NOT mere presence of one glyph -- presence would
        # swallow ordinary prose that mentions a single symbol into the span). v1 per the brief.
        $isMathDense = ($c.type -eq 'formula') -or ([int]$c.math_dirt -ge 2)
        if ($isMathDense) {
            $run.Add($c)
        } else {
            & $commitRun
        }
    }
    & $commitRun
    return $spans
}

# ── composite work-orders — the dispatch SPINE: inventory → group by deliverable → compose ───────────
# Turns per-chunk dispatch from "one corruption_type → look up the playbook" into a composite work-order:
# inventory ALL flagged issues in a deliverable (Get-ChunkIssues), pool them, and compose ONE body-light
# order (ordered recipes + diagnostics) the worker resolves in a single pass. Additive enrichment of the
# pointer/slice — it never changes the dispatched deliverable SET, the agreement ordering, leasing, or the
# budget; the single-type gate stays frozen. Body-light by construction: NEVER carries a chunk body.

# Pool the inventory across a deliverable's member chunks (chunk-level deliverable granularity; spans are
# per-chunk repair hints, not sub work-units). Each issue tags its source id + localized spans. Shared by
# the composer and the dispatch pointer profile, so the two never drift from the inventory.
function Get-DeliverableIssues($Members) {
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($m in $Members) {
        foreach ($iss in (Get-ChunkIssues $m)) {
            $out.Add([pscustomobject]@{
                type       = [string]$iss.type
                id         = [int]$m.id
                spans      = @($iss.spans)
                diagnostic = [string]$iss.diagnostic
            })
        }
    }
    return $out.ToArray()
}

# The COMPOSER — assemble one body-light work-order for a deliverable. Pools every member's issues
# (Get-DeliverableIssues), pairs each with its data-fied recipe fragment (playbook.ps1), and ORDERS them
# structural-before-content (retype / split / merge / level placement first, then content edits — the
# "restructure first" rule), a STABLE order so insertion (document/inventory) order holds within each
# band and the result is deterministic. A fragmented-formula span leads with its merge instruction (the
# deliverable-level structural frame), then pools each member's own issues. Carries types + diagnostics +
# recipes ONLY — no chunk body — so the worker still slices its own content (the body-blind contract).
function New-WorkOrder {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Kind,        # 'chunk' | 'fragmented_formula'
        [Parameter(Mandatory)][int]$Id,             # the anchor id (the deliverable handle)
        [int[]]$Span,                               # member ids for a span deliverable, else $null
        [Parameter(Mandatory)][object[]]$Members    # the member chunk object(s)
    )
    $pooled = [System.Collections.Generic.List[object]]::new()
    if ($Kind -eq 'fragmented_formula') {
        # the deliverable-level structural frame: merge the span before any member content edit
        $r = Get-RepairRecipe 'fragmented_formula'
        $pooled.Add([pscustomobject]@{ type = 'fragmented_formula'; id = $Id; spans = @(); diagnostic = ''; structural = $true; fix = [string]$r.fix })
    }
    foreach ($iss in (Get-DeliverableIssues $Members)) {
        $r = Get-RepairRecipe $iss.type
        $pooled.Add([pscustomobject]@{
            type       = [string]$iss.type
            id         = [int]$iss.id
            spans      = @($iss.spans)
            diagnostic = [string]$iss.diagnostic
            structural = [bool]($r -and $r.structural)
            fix        = if ($r) { [string]$r.fix } else { '' }   # absent recipe → PROCEDURE.md is the fallback
        })
    }
    # structural band before content band; STABLE within each (insertion order preserved). $false (0)
    # sorts before $true (1), so "NOT structural" puts structural entries first.
    $ordered = @($pooled | Sort-Object -Stable -Property @{ Expression = { -not $_.structural } })
    [pscustomobject]@{
        deliverable = $Kind
        id          = $Id
        span        = $Span
        issues      = @($ordered | ForEach-Object { $_.type })   # the lightweight profile (also on the pointer)
        recipes     = $ordered                                    # ordered { type; id; spans; diagnostic; structural; fix }
    }
}

# Piece 2 — bucket a document's actionable chunks into the deliverables that ship, each with its composed
# work-order: default = the chunk; a fragmented-formula span (Group-MathHotspots, the first grouping rule)
# = a multi-chunk deliverable pooling its members. Deterministic + lazy (from the live stream, no sidecar),
# document order. Uses the SAME eligibility + span/skip bookkeeping as Invoke-Dispatch, so the deliverable
# SET equals the dispatched work-SET (the composite is additive, never a new work-set). Leasing is the
# in-flight filter dispatch layers on top; the SET itself is lease-agnostic.
function Group-Deliverables($chunks) {
    $spans = Group-MathHotspots $chunks
    $spanLookup = @{}
    foreach ($s in $spans) { foreach ($sid in $s.ids) { $spanLookup[[int]$sid] = $s } }
    $byId = @{}
    foreach ($c in $chunks) { $byId[[int]$c.id] = $c }
    $skip = @{}
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($c in $chunks) {
        if ($c.fidelity -ne 'needs_review' -and $c.fidelity -ne 'needs_repair' -and $c.fidelity -ne 'suspect') { continue }
        if ([int]$c.id -in $skip.Keys) { continue }
        if ($spanLookup.ContainsKey([int]$c.id)) {
            $span = $spanLookup[[int]$c.id]
            foreach ($sid in $span.ids) { $skip[[int]$sid] = $true }
            $members = @($span.ids | ForEach-Object { $byId[[int]$_] })
            $out.Add((New-WorkOrder -Kind 'fragmented_formula' -Id ([int]$span.ids[0]) -Span @($span.ids | ForEach-Object { [int]$_ }) -Members $members))
        } else {
            $out.Add((New-WorkOrder -Kind 'chunk' -Id ([int]$c.id) -Members @($c)))
        }
    }
    return $out.ToArray()
}

function Get-IrHotspots {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath, [string]$Type)
    $chunks = @(Read-Chunks $ChunksPath)
    $spans = Group-MathHotspots $chunks
    $spanLookup = @{}
    foreach ($s in $spans) { foreach ($sid in $s.ids) { $spanLookup[[int]$sid] = $s } }
    $byId = @{}
    foreach ($c in $chunks) { $byId[[int]$c.id] = $c }
    $skipIds = @{}
    
    $chunks |
        Where-Object { $_.fidelity -in 'suspect','needs_review','needs_repair' -and (-not $Type -or $_.corruption_type -eq $Type -or $_.review_reason -eq $Type) } |
        ForEach-Object {
            if ([int]$_.id -in $skipIds.Keys) { return }
            if ($spanLookup.ContainsKey([int]$_.id)) {
                $span = $spanLookup[[int]$_.id]
                foreach ($sid in $span.ids) { $skipIds[[int]$sid] = $true }
                [pscustomobject]@{
                    id      = $span.ids[0]
                    span    = $span.ids
                    kind    = 'fragmented_formula'
                    page    = $span.pages[0]
                    grade   = $_.fidelity
                    type    = $(if ($_.corruption_type) { $_.corruption_type } else { $_.review_reason })
                    section = $_.section
                    agreement = ($span.ids | ForEach-Object { Get-ChunkAgreement $byId[[int]$_] } | Measure-Object -Minimum).Minimum
                    preview = $span.preview_joined
                }
            } else {
                [pscustomobject]@{
                    id      = $_.id
                    page    = $_.page
                    grade   = $_.fidelity
                    type    = $(if ($_.corruption_type) { $_.corruption_type } else { $_.review_reason })
                    section = $_.section
                    agreement = (Get-ChunkAgreement $_)
                    preview = ([string]$_.content).Substring(0, [Math]::Min(54, ([string]$_.content).Length))
                }
            }
        }
}

# --- sub-agent-facing: one work-unit by id, seek via .jidx ---

function Get-Slice {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [Parameter(Mandatory)][int]$Id,
        [int]$Context = 0,
        [int]$ToId = -1
    )
    $idx = [JsonlIndex]::Load("$ChunksPath.jidx")
    $propDir = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals'
    if ($ToId -ge 0) {
        $lo = $Id
        $hi = [Math]::Min($idx.LineCount - 1, $ToId)
    } else {
        $lo = [Math]::Max(0, $Id - $Context)
        $hi = [Math]::Min($idx.LineCount - 1, $Id + $Context)
    }
    $recs = [System.Collections.Generic.List[object]]::new()
    for ($i = $lo; $i -le $hi; $i++) {
        $rec = Read-JsonlRecord -Path $ChunksPath -At $i
        # overlay a staged proposal if one exists, so re-grounding shows the true working state
        $pf = Join-Path $propDir "$($rec.id).json"
        if (Test-Path -LiteralPath $pf) {
            $p = [System.IO.File]::ReadAllText($pf, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
            $rec | Add-Member -NotePropertyName content -NotePropertyValue ([string]$p.content) -Force
            $rec | Add-Member -NotePropertyName staged  -NotePropertyValue $true -Force
        }
        $recs.Add($rec)
    }
    # Compose the body-light work-order for the deliverable the worker was routed to, attached to the
    # anchor record (lazy: only when issues remain). The deliverable IS the slice you request — an explicit
    # forward range (id..to_id, the dispatch span contract the procedure drives) is the fragmented-formula
    # span: pool every member's issues under the merge frame; a plain slice is the single anchor chunk.
    # Pools over EXACTLY the records already read — no second full-document pass — so get_slice stays
    # seek-light; issues are recomputed from the staged-or-committed content in hand, so the order always
    # reflects what is LEFT to fix. Never carries a body of its own (body-blind): the records carry content.
    $anchor = $recs | Where-Object { [int]$_.id -eq $Id } | Select-Object -First 1
    if ($anchor) {
        $wo = if ($ToId -ge 0 -and $recs.Count -gt 1) {
            New-WorkOrder -Kind 'fragmented_formula' -Id $Id -Span @($recs | ForEach-Object { [int]$_.id }) -Members @($recs)
        } else {
            New-WorkOrder -Kind 'chunk' -Id $Id -Members @($anchor)
        }
        if ($wo.recipes.Count -gt 0) { $anchor | Add-Member -NotePropertyName work_order -NotePropertyValue $wo -Force }
    }
    foreach ($r in $recs) { $r }
}

# --- sub-agent-facing: stage a validated repair (one file per id -> conflict-free) ---

function Add-RepairProposal {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [Parameter(Mandatory)][int]$Id,
        [Parameter(Mandatory)][string]$Content,
        [string]$Source = 'worker'
    )
    $target = Read-JsonlRecord -Path $ChunksPath -At $Id
    if (-not $target -or [int]$target.id -ne $Id) {
        return [pscustomobject]@{ accepted = $false; id = $Id; reason = 'chunk id not found at that line' }
    }
    # gate: the repair is accepted iff the fidelity detector finds nothing wrong with it
    $ct = Get-CorruptionType ([pscustomobject]@{ type = $target.type; content = $Content })
    if ($ct) {
        $diag = if ($ct -eq 'unbalanced_delimiters') {
            $b = Get-LatexBalance $Content; "brace=$($b.brace) brack=$($b.brack) paren=$($b.paren) lr=$($b.lr)"
        } else { '' }
        return [pscustomobject]@{ accepted = $false; id = $Id; reason = "repair still flags as $ct"; diagnostic = $diag }
    }
    $propDir = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals'
    if (-not (Test-Path -LiteralPath $propDir)) { New-Item -ItemType Directory -Force -Path $propDir | Out-Null }
    $rec = [ordered]@{ id = $Id; type = [string]$target.type; content = $Content; source = $Source }
    [System.IO.File]::WriteAllText((Join-Path $propDir "$Id.json"), ($rec | ConvertTo-Json -Compress -Depth 8), [System.Text.UTF8Encoding]::new($false))
    return [pscustomobject]@{ accepted = $true; id = $Id }
}

# Pointed write: a surgical find->replace on one chunk, applied to the staged-or-committed
# content (so edits stack). The agent sends the minimal diff -- anti-leakage: it never
# regenerates the whole chunk, so the untouched bytes stay byte-identical. `Find` must be
# UNIQUE in the base (the manifest's character-strict rule). Stages the result and REPORTS
# its corruption status rather than rejecting on it -- the hard gate is commit, so an
# intermediate edit in a multi-step repair may legitimately still read 'flagged'.
function Add-RepairEdit {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [Parameter(Mandatory)][int]$Id,
        [Parameter(Mandatory)][string]$Find,
        [Parameter(Mandatory)][AllowEmptyString()][string]$Replace,
        [string]$Source = 'worker'
    )
    if ($Find -eq '') { return [pscustomobject]@{ accepted = $false; id = $Id; reason = 'empty find anchor' } }
    $propDir = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals'
    $propFile = Join-Path $propDir "$Id.json"
    if (Test-Path -LiteralPath $propFile) {
        $p = [System.IO.File]::ReadAllText($propFile, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
        $base = [string]$p.content; $type = [string]$p.type
    } else {
        $target = Read-JsonlRecord -Path $ChunksPath -At $Id
        if (-not $target -or [int]$target.id -ne $Id) { return [pscustomobject]@{ accepted = $false; id = $Id; reason = 'chunk id not found at that line' } }
        $base = [string]$target.content; $type = [string]$target.type
    }
    $idx = $base.IndexOf($Find)
    if ($idx -lt 0) { return [pscustomobject]@{ accepted = $false; id = $Id; reason = 'anchor not found in current content' } }
    if ($base.IndexOf($Find, $idx + $Find.Length) -ge 0) { return [pscustomobject]@{ accepted = $false; id = $Id; reason = 'anchor not unique -- narrow the find string' } }
    $new = $base.Substring(0, $idx) + $Replace + $base.Substring($idx + $Find.Length)

    if (-not (Test-Path -LiteralPath $propDir)) { New-Item -ItemType Directory -Force -Path $propDir | Out-Null }
    $rec = [ordered]@{ id = $Id; type = $type; content = $new; source = $Source }
    [System.IO.File]::WriteAllText($propFile, ($rec | ConvertTo-Json -Compress -Depth 8), [System.Text.UTF8Encoding]::new($false))

    $ct = Get-CorruptionType ([pscustomobject]@{ type = $type; content = $new })
    $diag = if ($ct -eq 'unbalanced_delimiters') { $b = Get-LatexBalance $new; "brace=$($b.brace) brack=$($b.brack) paren=$($b.paren) lr=$($b.lr)" } else { '' }
    [pscustomobject]@{ accepted = $true; id = $Id; status = $(if ($ct) { 'flagged' } else { 'clean' }); corruption_type = $ct; diagnostic = $diag; content = $new }
}

# --- orchestrator-facing: apply staged proposals into the stream (the chokepoint) ---
# NOT a git commit — it folds staged edits into chunks.jsonl, clears the leases it merged,
# and logs an 'applied' milestone to the ledger.
function Invoke-RepairApply {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [string]$NodesPath
    )
    $propDir = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals'
    $props = @{}
    if (Test-Path -LiteralPath $propDir) {
        foreach ($f in Get-ChildItem -LiteralPath $propDir -Filter '*.json' -File) {
            $p = [System.IO.File]::ReadAllText($f.FullName, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
            $props[[int]$p.id] = $p
        }
    }
    if ($props.Count -eq 0) { "no staged proposals to apply"; return }

    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    $audit = [System.Collections.Generic.List[object]]::new()
    $appliedIds = [System.Collections.Generic.List[int]]::new()
    $held = 0
    foreach ($c in $chunks) {
        if (-not $props.ContainsKey([int]$c.id)) { continue }
        $p = $props[[int]$c.id]
        # the hard gate: only clean staged content merges. Still-flagged proposals are KEPT
        # staged (mid multi-step repair), not discarded.
        if (Get-CorruptionType ([pscustomobject]@{ type = $c.type; content = [string]$p.content })) { $held++; continue }
        # deterministic content-tier normalization of the agent's edit — the SAME pass the normalize
        # stage runs on docling content. An agent repairing a formula naturally types \mathbb / loose
        # spacing / bare-& alignment; tidy it on the way in so the chunk stream stays minimal and the
        # deliverable needs no separate md-cleanup pass (md-cleanup is then a verifier, not a fixer).
        $newContent = [string]$p.content
        if ([string]$c.type -eq 'formula') {
            $newContent = Repair-MathAlignment (Convert-MathToLatex (Optimize-MathContent $newContent @('mathbb')))
        }
        $audit.Add([pscustomobject][ordered]@{
            id = [int]$c.id; source = [string]$p.source
            before = [string]$c.content; after = $newContent; was = [string]$c.corruption_type
        })
        $c.content = $newContent
        $c | Add-Member -NotePropertyName fidelity      -NotePropertyValue 'faithful'      -Force
        $c | Add-Member -NotePropertyName repair        -NotePropertyValue 'agent_applied' -Force
        $c | Add-Member -NotePropertyName repair_source -NotePropertyValue ([string]$p.source) -Force
        $c.PSObject.Properties.Remove('corruption_type')
        $c.PSObject.Properties.Remove('seam')
        $c.PSObject.Properties.Remove('seam_merge')   # the cross-chunk soft flag clears on a merged fix too
        $appliedIds.Add([int]$c.id)
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'apply'
    $auditPath = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.apply-audit.jsonl'
    [void](Write-JsonlStage -Records $audit.ToArray() -OutputPath $auditPath -SourcePath $NodesPath -Stage 'apply-audit')
    foreach ($aid in $appliedIds) { Remove-Item -LiteralPath (Join-Path $propDir "$aid.json") -Force -ErrorAction SilentlyContinue }  # clear merged
    Clear-Leases $ChunksPath @($appliedIds) | Out-Null   # free what we merged
    $remActionable = @($chunks | Where-Object { $_.fidelity -in 'needs_review','needs_repair','suspect' }).Count
    Add-LedgerEntry $ChunksPath 'applied' @{ committed = $appliedIds.Count; remaining = $remActionable }

    "applied $($appliedIds.Count) repairs ($held held -- still flagged, kept staged) -> $ChunksPath"
    "  before/after -> $auditPath (audit)"
    return $manifest
}

# --- orchestrator-facing, depth-n: the batch view + budgeted work allocation ---
# Same membrane one level up: counts/sizes only (body-blind), pointers not bodies. A
# single server rooted at a work dir serves one document or a whole batch unchanged.

function Get-BatchSummary {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Root)
    foreach ($cp in (Get-ChunkFiles $Root)) {
        $paper = ((Split-Path -Leaf $cp) -replace '\.chunks\.jsonl$', '')
        try {
            $chunks = @(Read-Chunks $cp)
            $review = @($chunks | Where-Object { $_.fidelity -eq 'needs_review' -or $_.fidelity -eq 'needs_repair' -or $_.fidelity -eq 'suspect' })
            $bytes = 0; foreach ($r in $review) { $bytes += ([string]$r.content).Length }
            # the paper's most-disputed actionable unit (min agreement) — where to point agents first
            $agreement = if ($review.Count) { ($review | ForEach-Object { Get-ChunkAgreement $_ } | Measure-Object -Minimum).Minimum } else { 1.0 }
            $ls = Get-LedgerStage $cp
            [pscustomobject]@{
                paper        = $paper
                run          = (Get-RunName $cp)                                                    # the CURRENT view; pin as {paper}@{run}
                stage        = if ($ls) { [string]$ls.stage } else { 'unknown' }
                chunks       = $chunks.Count
                pages        = (@($chunks.page | Sort-Object -Unique)).Count
                repaired     = @($chunks | Where-Object { $_.fidelity -eq 'repaired' }).Count
                actionable   = $review.Count                                                       # agent's work (review + repair)
                handoff      = @($chunks | Where-Object { $_.fidelity -eq 'unrecoverable' }).Count  # rare terminal: agent also failed -> source PDF
                review_bytes = $bytes
                agreement    = $agreement                                                          # 0-1; lowest = most structurally disputed
            }
        } catch {
            # Fault isolation: a malformed unit (corrupt .chunks.jsonl / .ledger.jsonl) surfaces as a
            # flagged 'unreadable' row the agent can escalate, never aborting the whole-batch survey.
            [pscustomobject]@{
                paper        = $paper
                run          = (Get-RunName $cp)
                stage        = 'unreadable'
                chunks       = 0
                pages        = 0
                repaired     = 0
                actionable   = 0
                handoff      = 0
                review_bytes = 0
                error        = [string]$_.Exception.Message
            }
        }
    }
}

# Return the next bundle of agent-actionable work-unit POINTERS (never content) whose total
# content size fits the byte budget — the orchestrator fans its workers over these, each
# fetching its own slice. Anti-clobber by construction: dispatched units are LEASED (skipped by
# later dispatches) until apply merges them or release frees them — no "commit between
# dispatches" rule needed.
function Invoke-Dispatch {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Root,
        [long]$BudgetBytes = 40000,
        [string]$Paper
    )
    $files = if ($Paper) { @(Resolve-PaperChunks -Root $Root -Paper $Paper) }
             else { @(Get-ChunkFiles $Root) }
    # Phase 1 — enumerate candidate work-unit POINTERS (the SAME eligible set + span grouping as before),
    # each carrying its agreement. No leasing here: RANKING must not change WHICH units are eligible.
    $candidates = [System.Collections.Generic.List[object]]::new()
    $skipped = [System.Collections.Generic.List[object]]::new()
    foreach ($cp in $files) {
        $name = (Split-Path -Leaf $cp) -replace '\.chunks\.jsonl$', ''
        # Fault isolation: materialize the unit's reads up front so a corrupt line throws atomically
        # (before any lease/add); a bad unit is skipped + reported, never aborting the whole bundle.
        try {
            $leased   = Get-LeasedIds $cp
            $cpChunks = @(Read-Chunks $cp)
        } catch {
            $skipped.Add([pscustomobject]@{ paper = $name; error = [string]$_.Exception.Message })
            continue
        }
        $spans = Group-MathHotspots $cpChunks
        $spanLookup = @{}
        foreach ($s in $spans) { foreach ($sid in $s.ids) { $spanLookup[[int]$sid] = $s } }
        $byId = @{}
        foreach ($c in $cpChunks) { $byId[[int]$c.id] = $c }
        $skipIds = @{}

        foreach ($c in $cpChunks) {
            if ($c.fidelity -ne 'needs_review' -and $c.fidelity -ne 'needs_repair' -and $c.fidelity -ne 'suspect') { continue }
            if ([int]$c.id -in $leased) { continue }   # already in flight
            if ([int]$c.id -in $skipIds.Keys) { continue }

            $bytes = ([string]$c.content).Length
            $span = $null
            if ($spanLookup.ContainsKey([int]$c.id)) {
                $span = $spanLookup[[int]$c.id]
                $bytes = $span.bytes
                $overlap = $span.ids | Where-Object { $_ -in $leased }
                if ($overlap) { continue }
            }

            if ($span) {
                foreach ($sid in $span.ids) { $skipIds[[int]$sid] = $true }
                # a fragmented-formula span takes the MIN agreement over its members (most-disputed leads)
                $agreement = ($span.ids | ForEach-Object { Get-ChunkAgreement $byId[[int]$_] } | Measure-Object -Minimum).Minimum
                # additive: the multi-issue profile pooled over the span's members (the inventory), for
                # routing/visibility — the full composed work-order is assembled at get_slice time.
                $issues = @(Get-DeliverableIssues @($span.ids | ForEach-Object { $byId[[int]$_] }) | ForEach-Object { $_.type } | Select-Object -Unique)
                $item = [pscustomobject]@{ paper = $name; run = (Get-RunName $cp); id = [int]$span.ids[0]; span = $span.ids; kind = 'fragmented_formula'; grade = [string]$c.fidelity; bytes = $bytes; section = [string]$c.section; seam = $span.joined_seam; agreement = $agreement; issues = $issues }
                $candidates.Add([pscustomobject]@{ cp = $cp; bytes = $bytes; agreement = [double]$agreement; leaseIds = @($span.ids | ForEach-Object { [int]$_ }); units = $span.ids.Count; item = $item })
            } else {
                $agreement = Get-ChunkAgreement $c
                # additive: the chunk's own multi-issue profile (the inventory) for routing/visibility
                $issues = @(Get-ChunkIssues $c | ForEach-Object { $_.type })
                $item = [pscustomobject]@{ paper = $name; run = (Get-RunName $cp); id = [int]$c.id; grade = [string]$c.fidelity; bytes = $bytes; section = [string]$c.section; seam = [string]$c.seam; agreement = $agreement; issues = $issues }
                $candidates.Add([pscustomobject]@{ cp = $cp; bytes = $bytes; agreement = [double]$agreement; leaseIds = @([int]$c.id); units = 1; item = $item })
            }
        }
    }
    # Phase 2 — order by ASCENDING agreement (most-disputed first), a STABLE sort: ties keep enumeration
    # order (file + line), so an unscored corpus reproduces the OLD order exactly and re-runs are identical.
    $ordered = @($candidates | Sort-Object -Stable -Property @{ Expression = { [double]$_.agreement } })

    # Phase 3 — budget-fill in priority order; lease only what we actually hand out (per-item check, no
    # break — a later smaller unit can still fit, exactly as before; only the order of consideration moved).
    $batch = [System.Collections.Generic.List[object]]::new()
    $newLeases = @{}
    $used = 0L; $remChunks = 0; $remBytes = 0L
    foreach ($cand in $ordered) {
        if ($used + $cand.bytes -le $BudgetBytes -or $batch.Count -eq 0) {     # always make progress
            $batch.Add($cand.item)
            if (-not $newLeases.ContainsKey($cand.cp)) { $newLeases[$cand.cp] = [System.Collections.Generic.List[int]]::new() }
            foreach ($lid in $cand.leaseIds) { $newLeases[$cand.cp].Add([int]$lid) }
            $used += $cand.bytes
        } else {
            $remChunks += $cand.units
            $remBytes  += $cand.bytes
        }
    }
    foreach ($cp in $newLeases.Keys) { Set-LeasedIds $cp (@(Get-LeasedIds $cp) + @($newLeases[$cp])) }   # lease the bundle
    [pscustomobject]@{
        batch = $batch.ToArray(); count = $batch.Count; total_bytes = $used
        remaining = [pscustomobject]@{ chunks = $remChunks; bytes = $remBytes }
        skipped = $skipped.ToArray()   # units that could not be read (malformed); surfaced, not silently dropped
    }
}

# --- search: restoration-native query over the stream, body-light pointers ---
# Any combination of facets (AND). Section/Contains are regex; the rest are exact.
function Search-Chunks {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [string]$Zone, [string]$Section, [string]$Grade, [string]$Type,
        [int]$Page = -1, [string]$Contains, [int]$Limit = 50
    )
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($c in (Read-Chunks $ChunksPath)) {
        if ($Zone     -and $c.zone     -ne $Zone)  { continue }
        if ($Grade    -and $c.fidelity -ne $Grade) { continue }
        if ($Type     -and $c.type     -ne $Type)  { continue }
        if ($Page -ge 0 -and [int]$c.page -ne $Page) { continue }
        if ($Section  -and ([string]$c.section -notmatch $Section))  { continue }
        if ($Contains -and ([string]$c.content -notmatch $Contains)) { continue }
        $out.Add([pscustomobject]@{
            id = $c.id; page = $c.page; type = $c.type; grade = $c.fidelity; section = $c.section
            preview = ([string]$c.content).Substring(0, [Math]::Min(54, ([string]$c.content).Length))
        })
        if ($out.Count -ge $Limit) { break }
    }
    $out
}

# --- audit: provenance of what the pipeline removed or changed ---
# No filter -> per-kind counts (body-light). With Id/Kind -> the matching records (cap 100).
function Get-Audit {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath, [int]$Id = -1, [string]$Kind)
    $base = $ChunksPath -replace '\.chunks\.jsonl$', ''
    $sources = [ordered]@{
        discards  = "$base.discards.jsonl"         # figure debris (collapse)
        repair    = "$base.repair-discards.jsonl"  # excised degenerate tails
        apply     = "$base.apply-audit.jsonl"      # agent before/after
        structure = "$base.structure-audit.jsonl"  # retype / split / merge
    }
    if (-not $Kind -and $Id -lt 0) {
        return $sources.GetEnumerator() | ForEach-Object {
            $n = if (Test-Path -LiteralPath $_.Value) { @([System.IO.File]::ReadLines($_.Value) | Where-Object { $_ }).Count } else { 0 }
            [pscustomobject]@{ kind = $_.Key; records = $n }
        }
    }
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($k in $sources.Keys) {
        if ($Kind -and $k -ne $Kind) { continue }
        if (-not (Test-Path -LiteralPath $sources[$k])) { continue }
        foreach ($line in [System.IO.File]::ReadLines($sources[$k])) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $r = $line | ConvertFrom-Json
            if ($Id -ge 0) {
                $hit = ($null -ne $r.id -and [int]$r.id -eq $Id) -or ($r.ids -and ($Id -in @($r.ids | ForEach-Object { [int]$_ })))
                if (-not $hit) { continue }
            }
            $r | Add-Member -NotePropertyName kind -NotePropertyValue $k -Force
            $out.Add($r)
            if ($out.Count -ge 100) { break }
        }
    }
    $out
}

# --- escalate: the rare terminal (agent gave up) + the human check-in ---

function Set-Unrecoverable {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath, [Parameter(Mandatory)][int]$Id,
        [string]$Reason = '', [string]$NodesPath
    )
    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) { if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) } }
    $c = $chunks | Where-Object { [int]$_.id -eq $Id } | Select-Object -First 1
    if (-not $c) { return [pscustomobject]@{ ok = $false; reason = "chunk $Id not found" } }
    $c | Add-Member -NotePropertyName fidelity -NotePropertyValue 'unrecoverable' -Force
    $c | Add-Member -NotePropertyName unrecoverable_reason -NotePropertyValue $Reason -Force
    $propFile = Join-Path (($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals') "$Id.json"
    if (Test-Path -LiteralPath $propFile) { Remove-Item -LiteralPath $propFile -Force }  # agent gave up; drop any staged edit
    [void](Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'escalate')
    [pscustomobject]@{ ok = $true; id = $Id; fidelity = 'unrecoverable'; reason = $Reason }
}

function Add-ReviewRequest {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath, [Parameter(Mandatory)][int]$Id,
        [Parameter(Mandatory)][string]$Message, [string]$Source = 'worker'
    )
    $reqPath = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.review-requests.jsonl'
    [System.IO.File]::AppendAllText($reqPath, ((@{ id = $Id; message = $Message; source = $Source } | ConvertTo-Json -Compress) + "`n"), [System.Text.UTF8Encoding]::new($false))
    [pscustomobject]@{ ok = $true; id = $Id; queued = 'review-requests' }
}
