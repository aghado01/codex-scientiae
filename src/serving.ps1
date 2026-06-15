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
. "$PSScriptRoot/crawl.ps1"

function Read-Chunks([string]$Path) {
    [System.IO.File]::ReadLines($Path) | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json }
}

# --- discovery over the per-source .scratch layout (crawler, not -Recurse) ---
function Get-ChunkFiles([string]$Root) {
    Invoke-Crawl -Root $Root -Patterns '**/.scratch/*.chunks.jsonl' -Semantics Include
}

# survey the ingestion target: each {slug}/{slug}.json raw + whether it's been preprocessed
function Get-IngestionScan([string]$Root) {
    foreach ($json in (Invoke-Crawl -Root $Root -Patterns '**/*.json' -Semantics Include)) {
        $slug     = [System.IO.Path]::GetFileNameWithoutExtension($json)
        $paperDir = Split-Path -Parent $json
        if ((Split-Path -Leaf $paperDir) -ne $slug) { continue }   # only {slug}/{slug}.json raws (skips inventory.json etc.)
        $chunks  = Join-Path $paperDir '.scratch' "$slug.chunks.jsonl"
        $prepped = Test-Path -LiteralPath $chunks
        [pscustomobject]@{
            paper   = $slug
            source  = ([System.IO.Path]::GetRelativePath($Root, $json) -replace '\\', '/')
            prepped = $prepped
            stage   = if ($prepped) { (Get-LedgerStage $chunks).stage } else { $null }
        }
    }
}

# --- lease: anti-clobber by construction. dispatch marks units in-flight so a later dispatch
#     can't re-hand them; apply clears what it merged; release frees abandoned ones. One lease
#     file per document, so the per-paper state never contends.
function Get-LeasedIds([string]$ChunksPath) {
    $p = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.leases.json'
    if (Test-Path -LiteralPath $p) { return @((Get-Content -LiteralPath $p -Raw | ConvertFrom-Json).leased | ForEach-Object { [int]$_ }) }
    return @()
}
function Set-LeasedIds([string]$ChunksPath, [int[]]$Ids) {
    $p = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.leases.json'
    (@{ leased = @($Ids | Sort-Object -Unique) } | ConvertTo-Json -Compress) | Set-Content -LiteralPath $p -Encoding utf8
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
    }
}

function Get-IrHotspots {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath, [string]$Type)
    Read-Chunks $ChunksPath |
        Where-Object { $_.fidelity -in 'suspect','needs_review','needs_repair' -and (-not $Type -or $_.corruption_type -eq $Type) } |
        ForEach-Object {
            [pscustomobject]@{
                id      = $_.id
                page    = $_.page
                grade   = $_.fidelity
                type    = $_.corruption_type
                section = $_.section
                preview = ([string]$_.content).Substring(0, [Math]::Min(54, ([string]$_.content).Length))
            }
        }
}

# --- sub-agent-facing: one work-unit by id, seek via .jidx ---

function Get-Slice {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [Parameter(Mandatory)][int]$Id,
        [int]$Context = 0
    )
    $idx = [JsonlIndex]::Load("$ChunksPath.jidx")
    $propDir = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.proposals'
    $lo = [Math]::Max(0, $Id - $Context)
    $hi = [Math]::Min($idx.LineCount - 1, $Id + $Context)
    for ($i = $lo; $i -le $hi; $i++) {
        $rec = Read-JsonlRecord -Path $ChunksPath -At $i
        # overlay a staged proposal if one exists, so re-grounding shows the true working state
        $pf = Join-Path $propDir "$($rec.id).json"
        if (Test-Path -LiteralPath $pf) {
            $p = Get-Content -LiteralPath $pf -Raw | ConvertFrom-Json
            $rec | Add-Member -NotePropertyName content -NotePropertyValue ([string]$p.content) -Force
            $rec | Add-Member -NotePropertyName staged  -NotePropertyValue $true -Force
        }
        $rec
    }
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
    ($rec | ConvertTo-Json -Compress -Depth 8) | Set-Content -LiteralPath (Join-Path $propDir "$Id.json") -Encoding utf8
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
        $p = Get-Content -LiteralPath $propFile -Raw | ConvertFrom-Json
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
    ($rec | ConvertTo-Json -Compress -Depth 8) | Set-Content -LiteralPath $propFile -Encoding utf8

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
            $p = Get-Content -LiteralPath $f.FullName -Raw | ConvertFrom-Json
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
        $audit.Add([pscustomobject][ordered]@{
            id = [int]$c.id; source = [string]$p.source
            before = [string]$c.content; after = [string]$p.content; was = [string]$c.corruption_type
        })
        $c.content = [string]$p.content
        $c | Add-Member -NotePropertyName fidelity      -NotePropertyValue 'faithful'      -Force
        $c | Add-Member -NotePropertyName repair        -NotePropertyValue 'agent_applied' -Force
        $c | Add-Member -NotePropertyName repair_source -NotePropertyValue ([string]$p.source) -Force
        $c.PSObject.Properties.Remove('corruption_type')
        $c.PSObject.Properties.Remove('seam')
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
        $chunks = @(Read-Chunks $cp)
        $review = @($chunks | Where-Object { $_.fidelity -eq 'needs_review' -or $_.fidelity -eq 'needs_repair' -or $_.fidelity -eq 'suspect' })
        $bytes = 0; foreach ($r in $review) { $bytes += ([string]$r.content).Length }
        $ls = Get-LedgerStage $cp
        [pscustomobject]@{
            paper        = ((Split-Path -Leaf $cp) -replace '\.chunks\.jsonl$', '')
            stage        = if ($ls) { [string]$ls.stage } else { 'unknown' }
            chunks       = $chunks.Count
            pages        = (@($chunks.page | Sort-Object -Unique)).Count
            repaired     = @($chunks | Where-Object { $_.fidelity -eq 'repaired' }).Count
            actionable   = $review.Count                                                       # agent's work (review + repair)
            handoff      = @($chunks | Where-Object { $_.fidelity -eq 'unrecoverable' }).Count  # rare terminal: agent also failed -> source PDF
            review_bytes = $bytes
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
    if ($Paper -and $Paper -notmatch '^[\w.\-]+$') { throw "invalid paper name: '$Paper'" }
    $files = if ($Paper) { @(Invoke-Crawl -Root $Root -Patterns "**/.scratch/$Paper.chunks.jsonl" -Semantics Include) }
             else { @(Get-ChunkFiles $Root) }
    $batch = [System.Collections.Generic.List[object]]::new()
    $newLeases = @{}
    $used = 0L; $remChunks = 0; $remBytes = 0L
    foreach ($cp in $files) {
        $name = (Split-Path -Leaf $cp) -replace '\.chunks\.jsonl$', ''
        $leased = Get-LeasedIds $cp
        foreach ($c in (Read-Chunks $cp)) {
            if ($c.fidelity -ne 'needs_review' -and $c.fidelity -ne 'needs_repair' -and $c.fidelity -ne 'suspect') { continue }
            if ([int]$c.id -in $leased) { continue }   # already in flight
            $bytes = ([string]$c.content).Length
            if ($used + $bytes -le $BudgetBytes -or $batch.Count -eq 0) {     # always make progress
                $batch.Add([pscustomobject]@{ paper = $name; id = [int]$c.id; grade = [string]$c.fidelity; bytes = $bytes; section = [string]$c.section; seam = [string]$c.seam })
                $used += $bytes
                if (-not $newLeases.ContainsKey($cp)) { $newLeases[$cp] = [System.Collections.Generic.List[int]]::new() }
                $newLeases[$cp].Add([int]$c.id)
            } else { $remChunks++; $remBytes += $bytes }
        }
    }
    foreach ($cp in $newLeases.Keys) { Set-LeasedIds $cp (@(Get-LeasedIds $cp) + @($newLeases[$cp])) }   # lease the bundle
    [pscustomobject]@{
        batch = $batch.ToArray(); count = $batch.Count; total_bytes = $used
        remaining = [pscustomobject]@{ chunks = $remChunks; bytes = $remBytes }
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
    (@{ id = $Id; message = $Message; source = $Source } | ConvertTo-Json -Compress) | Add-Content -LiteralPath $reqPath -Encoding utf8
    [pscustomobject]@{ ok = $true; id = $Id; queued = 'review-requests' }
}
