#requires -Version 7.0
<#
  src/fidelity.ps1 — corruption signatures -> per-chunk hotspot tags.

  Tags each chunk `fidelity` (faithful | suspect) and, when suspect, the
  `corruption_type` that fired. Faithful chunks pass untouched; the suspect set is
  the bounded work-list the serving layer hands to the model.

  Signatures are cheap and high-precision, drawn from corruption we've actually seen
  in the corpus:
    intertext         - `\intertext` sludge bolted onto real math (locator, not oracle)
    replacement_char  - the U+FFFD sentinel
    gibberish         - space-shattered single-char runs ("a o f i n t o o t")
    ligature_residue  - OCR ligatures that survived collapse
    unbalanced_braces - `{` / `}` mismatch in math content

    . ./fidelity.ps1
    Invoke-Fidelity -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>]
#>

. "$PSScriptRoot/jsonl.ps1"

function Get-CorruptionType($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return $null }
    if ($content.Contains('\intertext'))        { return 'intertext' }
    if ($content.Contains([char]0xFFFD))         { return 'replacement_char' }
    if ($content -match '(?:\b\w\s+){6,}\b\w\b') { return 'gibberish' }
    if ($content -match '[ﬀ-ﬄ]')        { return 'ligature_residue' }
    if ($Chunk.type -eq 'formula' -or $content.Contains('$')) {
        $open  = ([regex]::Matches($content, '\{')).Count
        $close = ([regex]::Matches($content, '\}')).Count
        if ($open -ne $close) { return 'unbalanced_braces' }
    }
    return $null
}

function Invoke-Fidelity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ChunksPath,
        [string] $NodesPath
    )

    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    foreach ($c in $chunks) {
        $ct = Get-CorruptionType $c
        $fidelity = if ($ct) { 'suspect' } else { 'faithful' }
        $c | Add-Member -NotePropertyName fidelity -NotePropertyValue $fidelity -Force
        if ($ct) { $c | Add-Member -NotePropertyName corruption_type -NotePropertyValue $ct -Force }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'fidelity'

    $suspect = @($chunks | Where-Object { $_.fidelity -eq 'suspect' })
    "fidelity tagged on $($chunks.Count) chunks  ($($suspect.Count) suspect) -> $ChunksPath"
    "--- hotspots by type ---"
    $suspect | Group-Object corruption_type | Sort-Object Count -Descending | ForEach-Object { "  {0,-18} {1}" -f $_.Name, $_.Count }
    return $manifest
}
