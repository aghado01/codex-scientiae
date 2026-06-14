#requires -Version 7.0
<#
  src/serving.ps1 — serving layer over the enriched chunk-JSONL.

  The membrane: orchestrator-facing tools read metadata only (body-blind, so a
  50-page doc costs a few hundred tokens), and the sub-agent-facing slice tool
  returns exactly one work-unit by id via the .jidx seek (a worker never loads
  more than its slice + the context it explicitly asks for).

  The write-side closes the loop: a worker stages a *validated* repair for one chunk
  (Add-RepairProposal — one file per id, so concurrent workers never conflict), and the
  orchestrator merges all staged proposals deterministically (Invoke-RepairCommit). A
  repair is accepted iff Get-CorruptionType finds nothing wrong with it — the detector is
  the merge-gate. Before/after of every commit lands in a .commit-audit sidecar.

    . ./serving.ps1
    Get-IrSummary       -ChunksPath <chunks.jsonl>
    Get-IrHotspots      -ChunksPath <chunks.jsonl> [-Type intertext]
    Get-Slice           -ChunksPath <chunks.jsonl> -Id <n> [-Context 1]
    Add-RepairProposal  -ChunksPath <chunks.jsonl> -Id <n> -Content <repaired> [-Source <who>]
    Invoke-RepairCommit -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>]
#>

. "$PSScriptRoot/jsonl.ps1"
. "$PSScriptRoot/fidelity.ps1"

function Read-Chunks([string]$Path) {
    [System.IO.File]::ReadLines($Path) | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json }
}

# --- orchestrator-facing: metadata only ---

function Get-IrSummary {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath)
    $chunks = @(Read-Chunks $ChunksPath)
    [pscustomobject]@{
        chunks   = $chunks.Count
        pages    = (@($chunks.page | Sort-Object -Unique)).Count
        title    = ($chunks | Where-Object { $_.title_candidate } | Select-Object -First 1).content
        zones    = ($chunks | Group-Object zone | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ' '
        sections = @($chunks | Where-Object { $_.type -eq 'heading' -and $_.section_level -and $_.is_furniture -ne 'running_head' }).Count
        repaired = @($chunks | Where-Object { $_.fidelity -eq 'repaired' }).Count
        flagged  = @($chunks | Where-Object { $_.fidelity -in 'suspect','needs_review','needs_repair' }).Count
        hotspots = ($chunks | Where-Object { $_.corruption_type -and $_.fidelity -in 'suspect','needs_review','needs_repair' } | Group-Object corruption_type | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ' '
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
    $lo = [Math]::Max(0, $Id - $Context)
    $hi = [Math]::Min($idx.LineCount - 1, $Id + $Context)
    for ($i = $lo; $i -le $hi; $i++) { Read-JsonlRecord -Path $ChunksPath -At $i }
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

# --- orchestrator-facing: merge staged proposals deterministically (the chokepoint) ---

function Invoke-RepairCommit {
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
    if ($props.Count -eq 0) { "no staged proposals to commit"; return }

    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    $audit = [System.Collections.Generic.List[object]]::new()
    $applied = 0; $rejected = 0
    foreach ($c in $chunks) {
        if (-not $props.ContainsKey([int]$c.id)) { continue }
        $p = $props[[int]$c.id]
        # re-gate at the merge boundary (defense in depth)
        if (Get-CorruptionType ([pscustomobject]@{ type = $c.type; content = [string]$p.content })) { $rejected++; continue }
        $audit.Add([pscustomobject][ordered]@{
            id = [int]$c.id; source = [string]$p.source
            before = [string]$c.content; after = [string]$p.content; was = [string]$c.corruption_type
        })
        $c.content = [string]$p.content
        $c | Add-Member -NotePropertyName fidelity      -NotePropertyValue 'faithful'        -Force
        $c | Add-Member -NotePropertyName repair        -NotePropertyValue 'agent_committed' -Force
        $c | Add-Member -NotePropertyName repair_source -NotePropertyValue ([string]$p.source) -Force
        $c.PSObject.Properties.Remove('corruption_type')
        $c.PSObject.Properties.Remove('seam')
        $applied++
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'commit'
    $auditPath = ($ChunksPath -replace '\.chunks\.jsonl$', '') + '.commit-audit.jsonl'
    [void](Write-JsonlStage -Records $audit.ToArray() -OutputPath $auditPath -SourcePath $NodesPath -Stage 'commit-audit')
    Remove-Item -LiteralPath $propDir -Recurse -Force -ErrorAction SilentlyContinue

    "committed $applied repairs ($rejected re-rejected at merge gate) -> $ChunksPath"
    "  before/after -> $auditPath (audit)"
    return $manifest
}

# --- orchestrator-facing, depth-n: the batch view + budgeted work allocation ---
# Same membrane one level up: counts/sizes only (body-blind), pointers not bodies. A
# single server rooted at a work dir serves one document or a whole batch unchanged.

function Get-BatchSummary {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Root)
    Get-ChildItem -LiteralPath $Root -Filter '*.chunks.jsonl' -File -ErrorAction SilentlyContinue | ForEach-Object {
        $chunks = @(Read-Chunks $_.FullName)
        $review = @($chunks | Where-Object { $_.fidelity -eq 'needs_review' -or $_.fidelity -eq 'needs_repair' -or $_.fidelity -eq 'suspect' })
        $bytes = 0; foreach ($r in $review) { $bytes += ([string]$r.content).Length }
        [pscustomobject]@{
            paper        = ($_.Name -replace '\.chunks\.jsonl$', '')
            chunks       = $chunks.Count
            pages        = (@($chunks.page | Sort-Object -Unique)).Count
            repaired     = @($chunks | Where-Object { $_.fidelity -eq 'repaired' }).Count
            actionable   = $review.Count                                                       # agent's work (review + repair)
            handoff      = @($chunks | Where-Object { $_.fidelity -eq 'unrecoverable' }).Count  # rare terminal: agent also failed -> source PDF
            review_bytes = $bytes
        }
    }
}

# Return the next bundle of agent-actionable work-unit POINTERS (never content) whose
# total content size fits the byte budget — the orchestrator fans its workers over these,
# each worker fetching its own slice. Stateless: commit re-grades to faithful, so worked
# chunks drop out of the next dispatch. (Procedure: commit between dispatches; a lease that
# makes that conflict-free even pre-commit is the v2.)
function Invoke-Dispatch {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Root,
        [long]$BudgetBytes = 40000,
        [string]$Paper
    )
    if ($Paper -and $Paper -notmatch '^[\w.\-]+$') { throw "invalid paper name: '$Paper'" }
    $files = if ($Paper) { @(Get-Item -LiteralPath (Join-Path $Root "$Paper.chunks.jsonl") -ErrorAction SilentlyContinue) }
             else { @(Get-ChildItem -LiteralPath $Root -Filter '*.chunks.jsonl' -File -ErrorAction SilentlyContinue) }
    $batch = [System.Collections.Generic.List[object]]::new()
    $used = 0L; $remChunks = 0; $remBytes = 0L
    foreach ($f in $files) {
        $name = $f.Name -replace '\.chunks\.jsonl$', ''
        foreach ($c in (Read-Chunks $f.FullName)) {
            if ($c.fidelity -ne 'needs_review' -and $c.fidelity -ne 'needs_repair' -and $c.fidelity -ne 'suspect') { continue }
            $bytes = ([string]$c.content).Length
            if ($used + $bytes -le $BudgetBytes -or $batch.Count -eq 0) {     # always make progress
                $batch.Add([pscustomobject]@{ paper = $name; id = [int]$c.id; grade = [string]$c.fidelity; bytes = $bytes; section = [string]$c.section; seam = [string]$c.seam })
                $used += $bytes
            } else { $remChunks++; $remBytes += $bytes }
        }
    }
    [pscustomobject]@{
        batch = $batch.ToArray(); count = $batch.Count; total_bytes = $used
        remaining = [pscustomobject]@{ chunks = $remChunks; bytes = $remBytes }
    }
}
