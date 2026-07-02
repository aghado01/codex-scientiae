#requires -Version 7.0
<#
  src/preprocess.ps1 — Invoke-Preprocess: the eight-stage on-ramp.

  Takes a raw Docling / opendataloader IR JSON and runs project-ir -> headings -> collapse ->
  zones -> sections -> normalize -> fidelity -> repair, landing the enriched chunk stream + sidecars in a
  fresh runstamped directory BESIDE the source — `{paper}/.runs/{yyyyMMdd_HHmmss}/` (source-tracked by
  position, fan-out-friendly — each paper's artifacts are self-contained; a legacy `.scratch/` dir reads
  as the oldest run). Logs the 'preprocessed' milestone to the ledger, and every write self-registers in
  the inventory via Write-JsonlStage.

  EVERY invocation creates a NEW run — preprocess starts a workflow; the read/repair tools continue one
  (they resolve the latest run, or any pinned '{paper}@{run}'). Prior runs are never touched, but a new
  run DOES become the paper's current view: when the displaced run carries agent work (applied/finalized/
  published) the result says so and names the pin address. Batch on-ramps should preprocess only docs the
  scan shows unprepped.

    . ./preprocess.ps1
    Invoke-Preprocess -JsonPath <…/{slug}/{slug}.json>
#>

. "$PSScriptRoot/project-ir.ps1"
. "$PSScriptRoot/headings.ps1"
. "$PSScriptRoot/collapse.ps1"
. "$PSScriptRoot/zones.ps1"
. "$PSScriptRoot/sections.ps1"
. "$PSScriptRoot/normalize.ps1"
. "$PSScriptRoot/fidelity.ps1"
. "$PSScriptRoot/repair.ps1"
. "$PSScriptRoot/serving.ps1"

function Invoke-Preprocess {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$JsonPath
    )
    if (-not (Test-Path -LiteralPath $JsonPath)) { return [pscustomobject]@{ ok = $false; reason = "source not found: $JsonPath" } }
    $slug     = [System.IO.Path]::GetFileNameWithoutExtension($JsonPath)
    $paperDir = Split-Path -Parent $JsonPath

    # every invocation is a NEW run; prior runs are preserved untouched, by construction. But the new
    # run becomes the paper's current view — if the run it displaces carries agent work, say so loudly.
    $prior = @(Get-RunChunks $paperDir $slug)
    $displaced = $null
    if ($prior.Count) {
        $pStage = try { (Get-LedgerStage $prior[0]).stage } catch { $null }
        if ($pStage -and $pStage -ne 'preprocessed') {
            $displaced = "prior run '$(Get-RunName $prior[0])' carries '$pStage' work — it stays intact; address it as $slug@$(Get-RunName $prior[0])"
        }
    }
    $scratch = New-RunDir $paperDir
    $chunks  = Join-Path $scratch "$slug.chunks.jsonl"
    $nodes   = Join-Path $scratch "$slug.nodes.jsonl"

    Invoke-ProjectIr       -JsonPath $JsonPath -OutputPath $nodes | Out-Null
    Invoke-HeadingRecovery -NodesPath $nodes | Out-Null
    Invoke-Collapse        -NodesPath $nodes -OutputPath $chunks | Out-Null
    Invoke-Zones           -ChunksPath $chunks -NodesPath $nodes | Out-Null
    Invoke-Sections        -ChunksPath $chunks -NodesPath $nodes | Out-Null
    Invoke-Normalize       -ChunksPath $chunks -NodesPath $nodes | Out-Null
    Invoke-Fidelity        -ChunksPath $chunks -NodesPath $nodes | Out-Null
    Invoke-Repair          -ChunksPath $chunks -NodesPath $nodes | Out-Null

    $c = @(Read-Chunks $chunks)
    $tally = @{
        repaired     = @($c | Where-Object { $_.fidelity -eq 'repaired' }).Count
        needs_review = @($c | Where-Object { $_.fidelity -eq 'needs_review' }).Count
        needs_repair = @($c | Where-Object { $_.fidelity -eq 'needs_repair' }).Count
    }
    Add-LedgerEntry $chunks 'preprocessed' $tally

    $out = [ordered]@{ ok = $true; paper = $slug; run = (Get-RunName $chunks); chunks = $c.Count; tally = $tally; path = $chunks; prior_runs = $prior.Count }
    if ($displaced) { $out.displaced = $displaced }
    [pscustomobject]$out
}
