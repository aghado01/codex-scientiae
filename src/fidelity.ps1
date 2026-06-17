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
    unbalanced_delimiters - {} / [] / () / \left..\right mismatch in math content
    alignment_outside_env - & alignment tab in a formula with no \begin{...} (KaTeX parse error)
    prose_in_formula  - a formula chunk that reads as natural language (mislabeled / leaked prose)

  The last two are cross-derivation converges: the assembled closure scanner (Find-MathClosureIssues)
  already flags them, but chunk-fidelity didn't — so the two derivations of "renderable math" could
  disagree (a file the scanner later called broken passed fidelity clean). Checking here closes that.

    . ./fidelity.ps1
    Invoke-Fidelity -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>]
#>

. "$PSScriptRoot/jsonl.ps1"
. "$PSScriptRoot/latex.ps1"   # shared math predicates + (transitively) the mask algebra / SpanLevel

$script:RxInlineMath = [regex]'\$\$[\s\S]*?\$\$|\$[^$\n]+\$'   # wrapped math is NOT shatter — mask it first

# gibberish — space-shattered text ("a o f i n t o o t"). The math overlay is masked out (so wrapped
# variables / flattened subscripts inside $...$ aren't mistaken for shatter), then per Line the longest
# run of CONSECUTIVE single-ALPHABETIC tokens is the signal. Two construction fixes over the old
# whole-content '(?:\b\w\s+){6,}' run:
#   * ALPHABETIC singles only — "1 2 3 4 5 6 7" is tabular data, not shatter (the old \w counted digits);
#   * the run, not a 7-long minimum — a shorter shatter trips it ("A l p h a", "r a n k" the old missed),
#     while the run length is exactly what separates true shatter (4-5+) from flattened index variables
#     ("b k i and d k i", broken every 3 by a real word).
# MinRun is tunable; the default is calibrated against the corpus A/B (match-or-reduce false flags).
function Test-IsGibberish([string]$content, [int]$MinRun = 4) {
    $prose = Get-MaskedText -Text $content -Mask (New-Mask $content $script:RxInlineMath)
    foreach ($unit in (Split-AtLevel -Text $prose -Level Line)) {
        $run = 0
        foreach ($t in @($unit.Text -split '\s+' | Where-Object { $_ -ne '' })) {
            if ($t -match '^[A-Za-z]$') { $run++; if ($run -ge $MinRun) { return $true } }
            else { $run = 0 }
        }
    }
    return $false
}

function Get-CorruptionType($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return $null }
    if ($content.Contains('\intertext'))        { return 'intertext' }
    if ($content.Contains([char]0xFFFD))         { return 'replacement_char' }
    if (Test-IsGibberish $content)               { return 'gibberish' }
    if ($content -match '[ﬀ-ﬄ]')        { return 'ligature_residue' }
    # the same impossibilities the assembled scanner checks, lifted to chunk level via the shared
    # latex.ps1 predicates so the two derivations of "renderable math" can't disagree (a file the
    # scanner later calls broken would otherwise pass fidelity clean). normalize auto-wraps docling
    # formulas upstream, so the alignment case here is the safety net for anything that slips.
    if ($Chunk.type -eq 'formula' -and (Test-AlignmentOutsideEnv $content)) { return 'alignment_outside_env' }
    if ($Chunk.type -eq 'formula' -and -not (Test-IsMath $content))         { return 'prose_in_formula' }
    # delimiter balance via the context-aware scanner (skips escaped \{ \(, pairs
    # \left..\right): full balance for a pure formula; braces only for inline math in
    # prose, where prose parens/brackets would otherwise false-positive.
    if ($Chunk.type -eq 'formula') {
        if (-not (Get-LatexBalance $content).full) { return 'unbalanced_delimiters' }
    }
    elseif ($content.Contains('$')) {
        if (-not (Get-LatexBalance $content).braceBalanced) { return 'unbalanced_delimiters' }
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
        if ($ct) {
            $c | Add-Member -NotePropertyName fidelity        -NotePropertyValue 'suspect' -Force
            $c | Add-Member -NotePropertyName corruption_type -NotePropertyValue $ct       -Force
        }
        elseif ($c.level_uncertain) {
            # faithful content, but a heading we couldn't level deterministically — structural,
            # not corruption, yet still a call the model must make. Surface it as actionable.
            $c | Add-Member -NotePropertyName fidelity      -NotePropertyValue 'needs_review'          -Force
            $c | Add-Member -NotePropertyName review_reason -NotePropertyValue 'heading_level_unknown' -Force
        }
        elseif ([int]($c.math_dirt) -ge 2) {
            # faithful prose carrying un-wrapped inline math (the normalize density∧¬mask signal) — the
            # deterministic wrapper conservatively skipped it; the agent wraps it with judgment. The
            # count rides along as math_dirt for dispatch prioritisation (denser = worse).
            $c | Add-Member -NotePropertyName fidelity      -NotePropertyValue 'needs_review'   -Force
            $c | Add-Member -NotePropertyName review_reason -NotePropertyValue 'unwrapped_math' -Force
        }
        else {
            $c | Add-Member -NotePropertyName fidelity -NotePropertyValue 'faithful' -Force
        }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'fidelity'

    $suspect = @($chunks | Where-Object { $_.fidelity -eq 'suspect' })
    "fidelity tagged on $($chunks.Count) chunks  ($($suspect.Count) suspect) -> $ChunksPath"
    "--- hotspots by type ---"
    $suspect | Group-Object corruption_type | Sort-Object Count -Descending | ForEach-Object { "  {0,-18} {1}" -f $_.Name, $_.Count }
    return $manifest
}
