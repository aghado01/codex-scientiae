#requires -Version 7.0
<#
  src/playbook.ps1 — the repair playbook as DATA: { issue type → recipe fragment }.

  The machine-readable sibling of PROCEDURE.md's prose playbook. The work-order composer pulls only the
  fragments for the issues a deliverable actually carries and orders them structural-before-content. This
  is a flat data map, NOT a rule engine — one terse fix-instruction per type, mirroring the prose
  procedure (which stays the frame and the fallback for anything absent here). Mirror it incrementally:
  when PROCEDURE.md's playbook gains an entry, add the terse sibling here; never fork the workflow.

  Each entry:
    structural — $true when the fix REFRAMES the chunk/span (retype / split / merge / level placement) and
                 must precede content edits (the "restructure first" rule); $false for an in-place edit.
    fix        — the terse repair instruction, mirroring the PROCEDURE.md playbook line.

    . ./playbook.ps1
    Get-RepairRecipe 'unbalanced_delimiters'   # → { type; structural; fix } or $null if not yet data-fied
#>

# Insertion order is the within-band default (structural block first, content block second), so a
# work-order that pulls several fragments reads top-down the way the procedure prescribes.
$script:RepairPlaybook = [ordered]@{
    # ── structural — reframe the chunk/span FIRST (PROCEDURE.md step 4, "restructure first") ──────────
    fragmented_formula    = @{ structural = $true;  fix = 'Block equation shattered across chunks: merge_chunks the span into one, re-ground (ids change), then propose_edit the join seams.' }
    prose_in_formula      = @{ structural = $true;  fix = 'Formula chunk reads as prose: retype_chunk to prose; if real math leaked in, wrap it in $...$ after retyping.' }
    heading_level_unknown = @{ structural = $true;  fix = 'The leveler could not place this heading: set its level from document context (## major, ### sub, per STANDARDS §5), or request_review if genuinely ambiguous.' }
    # ── content — in-place edits, AFTER any structural reframing ──────────────────────────────────────
    intertext             = @{ structural = $false; fix = 'Degenerate \intertext loop bolted onto a complete head: propose_edit find=<the tail from the first \intertext> replace=empty; restore any delimiter partner lost in the tail (the seam). The work-order span covers [first \intertext, end).' }
    unbalanced_delimiters = @{ structural = $false; fix = 'One delimiter open or extra; the seam names it (paren=1 → one unclosed "("; lr=-1 → a dangling \right). Add or remove exactly that one, touch nothing else. The span anchors from the first offending delimiter to end.' }
    unclosed_environment  = @{ structural = $false; fix = 'A \begin{...} with no matching \end{...} (often an \end carried off with a degenerate tail): add the missing \end{<env>} where the block closes, or delete a stray \end. Brace-balanced, so the delimiter gate misses it — the span anchors from the orphaned \begin (or dangling \end) to end. If the partner is in an adjacent chunk this is really a fragmented_formula: merge_chunks first.' }
    alignment_outside_env = @{ structural = $false; fix = 'A bare & outside an alignment environment is a KaTeX parse error: wrap the rows in \begin{aligned}...\end{aligned}, or remove the stray &. Spans list each bare &.' }
    gibberish             = @{ structural = $false; fix = 'Space-shattered text ("a o f i n t o"): the head is usually intact, the tail shattered. Repair the readable intent or delete the unrecoverable run. The span covers the shatter run.' }
    ligature_residue      = @{ structural = $false; fix = 'OCR ligature survivors → fi fl ffi: a direct propose_edit substitution at each listed span.' }
    replacement_char      = @{ structural = $false; fix = 'U+FFFD marks a lost character: restore from context if certain, else request_review. Spans list each sentinel position.' }
    unwrapped_math        = @{ structural = $false; fix = 'Un-wrapped inline math in prose: wrap each span in $...$ (the work-order lists [start,end) offsets). math_dirt counts tokens the auto-wrapper skipped.' }
}

# The recipe fragment for one issue type, or $null when the type has no data-fied recipe yet — the prose
# PROCEDURE.md stays the fallback, and the composer notes the gap rather than inventing a fragment.
function Get-RepairRecipe([string]$Type) {
    if ($script:RepairPlaybook.Contains($Type)) {
        $e = $script:RepairPlaybook[$Type]
        return [pscustomobject]@{ type = $Type; structural = [bool]$e.structural; fix = [string]$e.fix }
    }
    return $null
}

# Is this issue a structural reframe (orders before content fixes)? Unknown types default to content
# (the conservative band — an unrecognized issue does not jump ahead of a known retype/merge).
function Test-StructuralIssue([string]$Type) {
    return ($script:RepairPlaybook.Contains($Type) -and [bool]$script:RepairPlaybook[$Type].structural)
}
