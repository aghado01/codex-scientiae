#requires -Version 7.0
<#
  src/repair.ps1 — deterministic suffix excision on flagged chunks.

  A corpus field study (26 papers, 144 suspects -> src/.work/suspect-study.json) showed
  the loop corruptions are unholy SUFFIXES, not holes: every `intertext` suspect has a
  brace-balanced head that ends at a clean LaTeX boundary, with the degeneration
  (\intertext + regurgitated / space-shattered echo) appended AFTER the real content.
  So where the evidence earns it this pass excises the garbage tail and keeps the head;
  where it doesn't, it defers to re-extraction. Nothing is discarded silently — every
  excised tail goes to a .repair-discards sidecar (head + tail = the original content).

  Re-grades each suspect chunk's `fidelity` by corruption_type + head quality, using the
  context-aware delimiter scanner in latex.ps1:
    repaired      - intertext, head FULLY delimiter-balanced + clean-ended -> tail excised
    needs_review  - gibberish, or an intertext head with a delimiter partner left in the tail
                    (`seam` noted) -> tail excised, agent verifies
    needs_repair  - the deterministic pass couldn't auto-fix (tiny/unbalanced head, unbalanced
                    delimiters) -> left intact for the AGENT to repair. This is NOT a
                    re-extraction hand-off: the docling failure modes are tractable, so the
                    agent is the next tier, not the source PDF. True re-extraction
                    (`unrecoverable`) is reached only if the agent ALSO fails -- expected to be
                    vanishingly rare; a high needs_repair-survival rate indicts this tool's
                    repair logic before it indicts the export.

    . ./repair.ps1
    Invoke-Repair -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>] [-MinHeadFrac 0.4]
#>

. "$PSScriptRoot/jsonl.ps1"
. "$PSScriptRoot/latex.ps1"

# Locate the corruption onset: the first \intertext marker, else the first space-shattered
# run (gibberish). -1 when neither is present (e.g. a plain unbalanced-braces formula).
#
# SURROGATE-SAFE BY CONSTRUCTION: the returned offset is never arithmetic — it is either
# String.IndexOf of the ASCII literal '\intertext' (offset lands on the '\' code unit) or
# Regex.Match(...).Index, whose match begins at a '\w' character. A lone surrogate code unit has
# Unicode category Cs, matched by neither '\' nor '\w', so $onset always lands on the FIRST code
# unit of a non-surrogate (BMP) char — a valid UTF-16 boundary. The downstream
# $content.Substring(0,$onset) / Substring($onset) split therefore can never bisect an SMP
# surrogate pair (e.g. 𝔼 U+1D53C = D835 DD3C). No clamp needed.
function Get-CorruptionOnset([string]$content) {
    $i = $content.IndexOf('\intertext')
    if ($i -ge 0) { return $i }
    $m = [regex]::Match($content, '(?:\b\w\s){5,}')
    if ($m.Success) { return $m.Index }
    return -1
}

function Invoke-Repair {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ChunksPath,
        [string] $NodesPath,
        [double] $MinHeadFrac = 0.4
    )

    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    $excised = [System.Collections.Generic.List[object]]::new()
    $tally = [ordered]@{ repaired = 0; needs_review = 0; needs_repair = 0 }

    foreach ($c in $chunks) {
        if ($c.fidelity -ne 'suspect') { continue }
        $content = [string]$c.content
        $ct = [string]$c.corruption_type
        $onset = Get-CorruptionOnset $content

        $grade = 'needs_repair'; $doExcise = $false; $bal = $null
        if ($onset -gt 0 -and $content.Length -gt 0) {
            $head     = $content.Substring(0, $onset)
            $bal      = Get-LatexBalance $head
            $cleanEnd = [bool]($head.TrimEnd() -match '[\\}\])\.,]$')
            $hasWord  = [bool]($head -match '[A-Za-z]{3,}')
            $frac     = $head.Length / $content.Length
            # the \end that closes a \begin in the head can sit IN the tail; excising it would orphan the
            # environment. The head stays brace-balanced, so $bal (Get-LatexBalance) is blind to the break
            # — check \begin/\end closure of the head explicitly and DON'T excise when it would leave an
            # environment open. A deferred chunk stays flagged for the agent, who has context to close it.
            $envOk    = (Get-EnvironmentBalance $head).balanced

            # intertext: a brace-balanced, clean-ended head is the real formula -> excise the
            # loop. Grade by FULL delimiter balance (incl []/() and \left\right via the scanner):
            # all-balanced -> repaired; a partner left in the tail -> needs_review (seam noted).
            if ($ct -eq 'intertext' -and $bal.braceBalanced -and $cleanEnd -and $envOk) {
                $doExcise = $true
                $grade = if ($bal.full) { 'repaired' } else { 'needs_review' }
            }
            elseif ($ct -eq 'gibberish' -and $bal.braceBalanced -and $hasWord -and $frac -ge $MinHeadFrac -and $envOk) {
                $doExcise = $true; $grade = 'needs_review'
            }
        }

        if ($doExcise) {
            $excised.Add([pscustomobject][ordered]@{
                id = $c.id; corruption_type = $ct; grade = $grade
                head_len = $onset; tail_len = ($content.Length - $onset)
                tail = $content.Substring($onset)
                discard_reason = 'degenerate_suffix'; discard_pass = 'repair'
            })
            $c.content = ($content.Substring(0, $onset) -replace '[\s&\\]+$', '')
            $c | Add-Member -NotePropertyName repair        -NotePropertyValue 'tail_excised' -Force
            $c | Add-Member -NotePropertyName excised_chars -NotePropertyValue ($content.Length - $onset) -Force
            if ($grade -eq 'needs_review' -and $bal -and -not $bal.full) {
                $c | Add-Member -NotePropertyName seam -NotePropertyValue ("brace={0} brack={1} paren={2} lr={3}" -f $bal.brace, $bal.brack, $bal.paren, $bal.lr) -Force
            }
        } else {
            $c | Add-Member -NotePropertyName repair -NotePropertyValue 'deferred' -Force
        }
        $c | Add-Member -NotePropertyName fidelity -NotePropertyValue $grade -Force
        $tally[$grade]++
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'repair'
    $discPath = $ChunksPath -replace '\.chunks\.jsonl$', '.repair-discards.jsonl'
    if ($discPath -eq $ChunksPath) { $discPath = "$ChunksPath.repair-discards.jsonl" }
    $discManifest = Write-JsonlStage -Records $excised.ToArray() -OutputPath $discPath -SourcePath $NodesPath -Stage 'repair-discards'

    "repair: $($excised.Count) suffixes excised -> $($discManifest.Jsonl) (audit)"
    "  repaired (intertext) ........ $($tally.repaired)"
    "  needs_review (gibberish) .... $($tally.needs_review)"
    "  needs_repair (agent's turn) . $($tally.needs_repair)"
    return $manifest
}
