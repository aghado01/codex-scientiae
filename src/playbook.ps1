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
    # ── SOFT band — valid-but-wrong tells the hard gate cannot see (needs_review). The math is structurally
    # valid; read it for SENSE. Several are converter LOSS (the bytes are gone) — recover from source, never invent.
    glyph_name_leak       = @{ structural = $false; fix = 'A PDF glyph NAME leaked as literal text (glyph[negationslash], glyph[lscript]): propose_edit each span to its LaTeX command (negationslash->\neq, lscript->\ell, greaterorequalslant->\geqslant, lessorequalslant->\leqslant, element->\in). Deterministic substitution, no judgement.' }
    degenerate_structure  = @{ structural = $false; fix = 'A \substack / \max / \min carrying no constraint — the equation body was destroyed by the converter and only the operator scaffold survived (still valid LaTeX). NOT repairable in place: recover the real equation from source (acquire the arXiv LaTeX) or mark_unrecoverable.' }
    hallucinated_subexpr  = @{ structural = $false; fix = 'A self-cancelling subexpression (X - X, e.g. k_i - k_i = 0) signals OCR/VLM hallucination injected into the math. Verify against source; delete the hallucinated run (often a whole \\-separated row of nonsense) or recover the real line from source. Do not keep it.' }
    dangling_operator     = @{ structural = $false; fix = 'The equation ends on an operator with no right-hand side — the converter truncated the tail. If the continuation is the next chunk, merge_chunks (glance at the seam); else restore the missing side from source. Never invent it.' }
    text_sentence_in_math = @{ structural = $false; fix = 'A sentence fragment is smuggled inside \text{} blocks of this formula — prose merged in from the next line. Glance at the seam (get_slice context=1): the prose belongs to the neighbouring chunk. propose_edit the merged tail (the trailing \text{...} and any math pulled in with it) to empty; the real equation is what remains.' }
    bare_number_row       = @{ structural = $false; fix = 'A lone integer on its own alignment row (\\ & \quad 4) is a page / footnote number the converter swept into the math: propose_edit the row (from its \\) to empty.' }
    prose_seam_merge      = @{ structural = $false; fix = 'This formula''s \text{} prose duplicates the adjacent paragraph verbatim — the converter merged a prose line into the equation. The duplicate belongs to the neighbour (get_slice context=1 to confirm): propose_edit the flagged \text{...} (and any math pulled in with it) to empty; the real equation is what remains.' }
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
