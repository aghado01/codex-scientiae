#requires -Version 7.0
<#
  src/preprocess.ps1 — Invoke-Preprocess: the eight-stage on-ramp.

  Takes a raw Docling / opendataloader IR JSON and runs project-ir -> headings -> collapse ->
  zones -> sections -> normalize -> fidelity -> repair, landing the enriched chunk stream + sidecars in a
  `.scratch/` directory BESIDE the source (source-tracked by position, fan-out-friendly — each
  paper's artifacts are self-contained). Logs the 'preprocessed' milestone to the ledger, and
  every write self-registers in the inventory via Write-JsonlStage. Refuses to clobber a paper
  that already carries applied agent repairs unless -Force.

    . ./preprocess.ps1
    Invoke-Preprocess -JsonPath <…/{slug}/{slug}.json> [-Force]
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
        [Parameter(Mandatory)][string]$JsonPath,
        [switch]$Force
    )
    if (-not (Test-Path -LiteralPath $JsonPath)) { return [pscustomobject]@{ ok = $false; reason = "source not found: $JsonPath" } }
    $slug    = [System.IO.Path]::GetFileNameWithoutExtension($JsonPath)
    $scratch = Join-Path (Split-Path -Parent $JsonPath) '.scratch'
    $chunks  = Join-Path $scratch "$slug.chunks.jsonl"
    $nodes   = Join-Path $scratch "$slug.nodes.jsonl"

    # no-clobber: never wipe a paper that already carries applied agent repairs
    if ((Test-Path -LiteralPath $chunks) -and -not $Force) {
        $stage = (Get-LedgerStage $chunks).stage
        if ($stage -eq 'applied') { return [pscustomobject]@{ ok = $false; paper = $slug; reason = 'already worked (applied repairs); pass -Force to re-preprocess' } }
        return [pscustomobject]@{ ok = $true; paper = $slug; skipped = $true; reason = 'already preprocessed'; path = $chunks }
    }
    if (-not (Test-Path -LiteralPath $scratch)) { New-Item -ItemType Directory -Force -Path $scratch | Out-Null }

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

    [pscustomobject]@{ ok = $true; paper = $slug; chunks = $c.Count; tally = $tally; path = $chunks }
}
