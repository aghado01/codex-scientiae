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
function Get-GibberishSpans([string]$content, [int]$MinRun = 4) {
    $spans = [System.Collections.Generic.List[object]]::new()
    $prose = Get-MaskedText -Text $content -Mask (New-Mask $content $script:RxInlineMath)
    foreach ($unit in (Split-AtLevel -Text $prose -Level Line)) {
        $run = 0; $runStart = -1
        foreach ($tm in [regex]::Matches($unit.Text, '\S+')) {
            if ($tm.Value -match '^[A-Za-z]$') {
                if ($run -eq 0) { $runStart = $tm.Index }
                $run++
                if ($run -ge $MinRun) {
                    $spans.Add([pscustomobject]@{ start = $unit.Start + $runStart; end = $unit.Start + $tm.Index + $tm.Length })
                    return $spans.ToArray()   # same first-hit semantics as the bool test
                }
            }
            else { $run = 0; $runStart = -1 }
        }
    }
    return @()
}

function Test-IsGibberish([string]$content, [int]$MinRun = 4) {
    return @(Get-GibberishSpans $content $MinRun).Count -gt 0
}

# Difference-localization for Get-ChunkIssues — reuses the SAME geometry as each signature's Test predicate.
function Get-IssueSpans([string]$IssueType, [string]$ChunkType, [string]$Content) {
    if (-not $Content) { return @() }
    switch ($IssueType) {
        'intertext'               { return @(Get-IntertextSpans $Content) }
        'replacement_char'        { return @(Get-ReplacementCharSpans $Content) }
        'gibberish'               { return @(Get-GibberishSpans $Content) }
        'ligature_residue'        { return @(Get-LigatureSpans $Content) }
        'alignment_outside_env'     { if ($ChunkType -eq 'formula') { return @(Get-AlignmentOutsideEnvSpans $Content) }; return @() }
        'prose_in_formula'        { if ($ChunkType -eq 'formula') { return @(Get-ProseInFormulaSpans $Content) }; return @() }
        'unbalanced_delimiters'   { return @(Get-UnbalancedDelimiterSpans $Content) }
        'heading_level_unknown'   { return @([pscustomobject]@{ start = 0; end = $Content.Length }) }
        'unwrapped_math' {
            if (-not $script:NormalizeSpanLoaded) {
                . "$PSScriptRoot/normalize.ps1"
                $script:NormalizeSpanLoaded = $true
            }
            return @(Get-UnwrappedMathSpans $Content)
        }
        default { return @() }
    }
}

# ── corruption signatures — ONE definition per signature, the single home both derivations read ──────
# The frozen single-type gate (Get-CorruptionType, first-match → accept/reject) and the multi-issue
# inventory (Get-ChunkIssues, all-match → dispatch enrichment) are two derivations of "what is wrong with
# this chunk." They MUST NOT drift, so they read this ONE ordered table instead of each carrying its own
# copy of the per-signature predicate — the same cross-derivation discipline the mask-algebra substrate
# enforced. Order is the gate's historical precedence: do NOT reorder — the gate returns the FIRST type
# that fires and the corpus A/B pins that verdict. Each signature carries:
#   type  — the corruption_type label
#   Test  — predicate over ($type, $content) → bool   (the SAME check both derivations run)
#   Diag  — the worker-facing diagnostic (the delimiter seam for unbalanced; '' where the name suffices)
# The alignment / prose-in-formula pair are the cross-derivation converges the assembled closure scanner
# (Find-MathClosureIssues) also checks, lifted to chunk level via the shared latex.ps1 predicates so the
# two derivations of "renderable math" can't disagree. Delimiter balance via the context-aware scanner
# (skips escaped \{ \(, pairs \left..\right): full balance for a pure formula; braces only for inline math
# in prose, where prose parens/brackets would otherwise false-positive.
$script:CorruptionSignatures = @(
    [pscustomobject]@{ type = 'intertext'
        Test = { param($type, $content) $content.Contains('\intertext') }
        Diag = { param($type, $content) '' } }
    [pscustomobject]@{ type = 'replacement_char'
        Test = { param($type, $content) $content.Contains([char]0xFFFD) }
        Diag = { param($type, $content) '' } }
    [pscustomobject]@{ type = 'gibberish'
        Test = { param($type, $content) Test-IsGibberish $content }
        Diag = { param($type, $content) '' } }
    [pscustomobject]@{ type = 'ligature_residue'
        Test = { param($type, $content) [bool]($content -match '[ﬀ-ﬄ]') }
        Diag = { param($type, $content) '' } }
    [pscustomobject]@{ type = 'alignment_outside_env'
        Test = { param($type, $content) $type -eq 'formula' -and (Test-AlignmentOutsideEnv $content) }
        Diag = { param($type, $content) '' } }
    [pscustomobject]@{ type = 'prose_in_formula'
        Test = { param($type, $content) $type -eq 'formula' -and -not (Test-IsMath $content) }
        Diag = { param($type, $content) '' } }
    [pscustomobject]@{ type = 'unbalanced_delimiters'
        Test = { param($type, $content)
            if ($type -eq 'formula')         { -not (Get-LatexBalance $content).full }
            elseif ($content.Contains('$'))  { -not (Get-LatexBalance $content).braceBalanced }
            else                             { $false } }
        Diag = { param($type, $content) $b = Get-LatexBalance $content; "brace=$($b.brace) brack=$($b.brack) paren=$($b.paren) lr=$($b.lr)" } }
)

# The frozen merge-gate: the FIRST signature that fires (historical precedence), else $null (clean). This
# stays the sole driver of fidelity grading and the apply gate; the inventory below never moves it. Reads
# the shared table, so it cannot drift from Get-ChunkIssues.
function Get-CorruptionType($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return $null }
    $type = [string]$Chunk.type
    foreach ($sig in $script:CorruptionSignatures) {
        if (& $sig.Test $type $content) { return $sig.type }
    }
    return $null
}

# Multi-issue inventory (the DISPATCH derivation) — EVERY signature that fires, as {type, spans, diagnostic},
# not the gate's first-match. Additive and SEPARATE from Get-CorruptionType: it never touches accept/
# reject; it only enriches what the worker is dispatched to do, so a chunk carrying e.g. ligature_residue
# AND unbalanced_delimiters surfaces both for one composed work-order instead of N re-dispatches. Folds in
# the two needs_review kinds Invoke-Fidelity routes on (content the gate calls clean but the stage still
# flags): heading_level_unknown (level_uncertain) and unwrapped_math (math_dirt ≥ 2) — the SAME booleans
# Invoke-Fidelity uses, so those don't drift either. Computed on demand (at dispatch / slice time), never
# stored: the work-order is assembled lazily, so there is no sidecar to go stale under id renumbering.
# `spans` are half-open [start,end) UTF-16 offsets into the chunk — repair hints, not sub work-units;
# localized via Get-IssueSpans (same geometry as each signature's Test predicate).
# Returns @() for a clean chunk.
function Get-ChunkIssues($Chunk) {
    $content = [string]$Chunk.content
    $type    = [string]$Chunk.type
    $issues  = [System.Collections.Generic.List[object]]::new()
    if ($content) {
        foreach ($sig in $script:CorruptionSignatures) {
            if (& $sig.Test $type $content) {
                $issues.Add([pscustomobject]@{
                    type       = $sig.type
                    spans      = @(Get-IssueSpans $sig.type $type $content)
                    diagnostic = [string](& $sig.Diag $type $content)
                })
            }
        }
    }
    # the needs_review kinds — faithful content the fidelity stage still hands the agent (the gate is
    # clean, so these are NOT in the shared table). Mirror Invoke-Fidelity's two branches exactly.
    if ($Chunk.level_uncertain) {
        $issues.Add([pscustomobject]@{
            type       = 'heading_level_unknown'
            spans      = @(Get-IssueSpans 'heading_level_unknown' $type $content)
            diagnostic = ''
        })
    }
    if ([int]($Chunk.math_dirt) -ge 2) {
        $issues.Add([pscustomobject]@{
            type       = 'unwrapped_math'
            spans      = @(Get-IssueSpans 'unwrapped_math' $type $content)
            diagnostic = "math_dirt=$([int]$Chunk.math_dirt)"
        })
    }
    return $issues.ToArray()
}

# Structural impossibilities (Part B) — mis-*geometry* only: a chunk cannot land when its type/label is
# structurally wrong (alignment outside env, prose mislabeled as formula). unbalanced_delimiters is
# fixable corruption (merge-then-fix, propose_edit) — NOT a global structural impossibility; it gets
# op-specific guards instead (split orphaning; merge only when the join WORSENS balance vs the parts).
# Content-only signatures (ligature, gibberish, …) stay on the content-repair path. ONE table, no fork.
$script:StructuralImpossibilityTypes = @('alignment_outside_env', 'prose_in_formula')

function Get-StructuralImpossibility($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return $null }
    $type = [string]$Chunk.type
    foreach ($sig in $script:CorruptionSignatures) {
        if ($sig.type -notin $script:StructuralImpossibilityTypes) { continue }
        if (& $sig.Test $type $content) {
            return [pscustomobject]@{ reason = $sig.type; diagnostic = [string](& $sig.Diag $type $content) }
        }
    }
    return $null
}

# Delimiter imbalance via the shared table's unbalanced_delimiters row — for op-specific gates (split
# orphaning) that must reuse the SAME predicate/diagnostic, not a forked copy.
function Test-ChunkUnbalanced($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return $false }
    $sig = $script:CorruptionSignatures | Where-Object { $_.type -eq 'unbalanced_delimiters' } | Select-Object -First 1
    return [bool](& $sig.Test ([string]$Chunk.type) $content)
}

function Get-UnbalancedDiagnostic($Chunk) {
    $sig = $script:CorruptionSignatures | Where-Object { $_.type -eq 'unbalanced_delimiters' } | Select-Object -First 1
    return [string](& $sig.Diag ([string]$Chunk.type) ([string]$Chunk.content))
}

function Get-BalanceResidual([string]$Content) {
    $b = Get-LatexBalance $Content
    return [Math]::Abs($b.brace) + [Math]::Abs($b.brack) + [Math]::Abs($b.paren) + [Math]::Abs($b.lr)
}

# ── agreement — structural-ambiguity score for dispatch RANKING (Part A; ranks, never gates) ───────
# agreement ∈ [0,1] is the mask IoU (Jaccard) of >=2 INDEPENDENT derivations of the same property, each
# rendered as a Mask: coverage(A∩B)/coverage(A∪B), defined 1 when the union is empty (both derivations
# agree there is nothing). The score is the MIN over the applicable pairs (the most-disputed derivation
# dominates), so dispatch can spend the agent's scarcest resource — budget — on genuinely uncertain
# regions first, not on single-detector noise. Pure composition of the EXISTING set-ops + already-ported
# detectors: adds NO mask primitive, NO new detection heuristic. It only RE-ORDERS the work-list; the
# work-SET (the fidelity gate) and every accept/reject are untouched.
#
# Cardinality is Get-MaskCoverage (covered UTF-16 units) — the set size Jaccard needs; Get-MaskDensity
# counts register tokens, a different thing. The derivation pairs, applied where the chunk type fits:
#   math    — math-by-content (the RxMathStructure overlay, via Get-MathStructureMask) vs math-by-label
#             (type=='formula' ⇒ the whole chunk is claimed math). GRADED: for a formula this is the
#             fraction that is actual math structure, so prose leaked into a formula drives it down.
#   heading — typography-derived (docling laid it out as a heading: type=='heading') vs markup-derived
#             (the font/number leveler placed it: section_level present AND not level_uncertain). The
#             heading the leveler could not place — the existing level_uncertain dispute — scores 0.
#   closure — the pincer top-down==bottom-up coincidence (the substrate's tested law): the whole-chunk
#             math-structure mask vs the per-line masks lifted back. <1 when a formula's structure spans
#             a line boundary the per-line view can't see. Balance (Get-LatexBalance) already gates the
#             SET as unbalanced_delimiters; it is NOT folded into the score (rank and gate stay distinct).
function Get-MaskIoU($A, $B) {
    $inter = Get-MaskCoverage (Intersect-Mask $A $B)
    $union = Get-MaskCoverage (Union-Mask $A $B)
    if ($union -le 0) { return 1.0 }     # empty union: both derivations agree there is nothing
    return [double]$inter / [double]$union
}

function Get-AgreementScore($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return 1.0 }    # nothing to dispute
    $type = [string]$Chunk.type
    $len  = $content.Length
    $full  = New-Mask -Spans @([pscustomobject]@{ Start = 0; End = $len }) -Length $len
    $empty = New-Mask -Spans @() -Length $len
    $scores = [System.Collections.Generic.List[double]]::new()

    # math pair — any math signal: a formula label, or content the math-structure overlay matches
    $byContent = Get-MathStructureMask $content
    $isFormula = ($type -eq 'formula')
    if ($isFormula -or -not (Test-MaskEmpty $byContent)) {
        $byLabel = if ($isFormula) { $full } else { $empty }
        $scores.Add((Get-MaskIoU $byContent $byLabel))
    }

    # heading pair — docling laid this out as a heading (typography); did the leveler place it (markup)?
    if ($type -eq 'heading') {
        $placed = ($null -ne $Chunk.section_level) -and (-not $Chunk.level_uncertain)
        $markup = if ($placed) { $full } else { $empty }
        $scores.Add((Get-MaskIoU $full $markup))
    }

    # closure pair (formula) — the pincer: whole-chunk structure mask (top-down) vs per-line lifted union
    if ($isFormula) {
        $bottomUp = $empty
        foreach ($u in (Split-AtLevel -Text $content -Level Line)) {
            $bottomUp = Union-Mask $bottomUp (Move-Mask (Get-MathStructureMask $u.Text) $u.Start $len)
        }
        $scores.Add((Get-MaskIoU $byContent $bottomUp))
    }

    if ($scores.Count -eq 0) { return 1.0 }   # no applicable pair: nothing disputed
    return ($scores | Measure-Object -Minimum).Minimum
}

# Recompute + store agreement on a chunk EXACTLY like math_dirt: a per-chunk field (never a sidecar, so
# split/merge id renumbering can't strand it), written only when there is dispute to record (<1.0) and
# CLEARED when a re-grade returns it to 1.0, so a stale low score never lingers. Absent ⇒ 1.0 downstream.
function Set-ChunkAgreement($Chunk) {
    $a = Get-AgreementScore $Chunk
    if ($a -lt 1.0) { $Chunk | Add-Member -NotePropertyName agreement -NotePropertyValue ([double]$a) -Force }
    elseif ($Chunk.PSObject.Properties['agreement']) { $Chunk.PSObject.Properties.Remove('agreement') }
    return $a
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
        Set-ChunkAgreement $c | Out-Null   # recompute the ranking score every re-grade (ranks, never gates)
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
