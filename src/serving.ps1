#requires -Version 7.0
<#
  src/serving.ps1 — serving layer over the enriched chunk-JSONL.

  The membrane: orchestrator-facing tools read metadata only (body-blind, so a
  50-page doc costs a few hundred tokens), and the sub-agent-facing slice tool
  returns exactly one work-unit by id via the .jidx seek (a worker never loads
  more than its slice + the context it explicitly asks for).

    . ./serving.ps1
    Get-IrSummary  -ChunksPath <chunks.jsonl>
    Get-IrHotspots -ChunksPath <chunks.jsonl> [-Type intertext]
    Get-Slice      -ChunksPath <chunks.jsonl> -Id <n> [-Context 1]
#>

. "$PSScriptRoot/jsonl.ps1"

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
        flagged  = @($chunks | Where-Object { $_.fidelity -in 'suspect','needs_review','needs_reextraction' }).Count
        hotspots = ($chunks | Where-Object { $_.corruption_type -and $_.fidelity -in 'suspect','needs_review','needs_reextraction' } | Group-Object corruption_type | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ' '
    }
}

function Get-IrHotspots {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$ChunksPath, [string]$Type)
    Read-Chunks $ChunksPath |
        Where-Object { $_.fidelity -in 'suspect','needs_review','needs_reextraction' -and (-not $Type -or $_.corruption_type -eq $Type) } |
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
