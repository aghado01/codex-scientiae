#requires -Version 7.0
<#
  src/md-postprocess/md-hygiene.ps1 — emission-grade markdown hygiene, as a format-agnostic primitive
  (pure text in/text out). Extracted verbatim from latex-ingest's inline emission walk, where it
  had accreted as mixed concerns — nothing in it is LaTeX-specific; the rules are properties of
  the TARGET register (STANDARDS §4/§5 hygiene + math-span safety), so any lane emitting corpus
  markdown may serialize through it. The per-rule provenance notes below name the conversion
  defects that motivated each rule (the §9 accretion method: rules earn their place).

  One fence-aware line walk:
   - inside ``` fences: byte-verbatim (code samples keep their own blanks/tabs/spacing)
   - hard tabs -> space (MD010); trailing whitespace stripped (MD009); blank runs -> ONE (MD012)
   - headings: trailing sentence punctuation stripped (MD026); level jumps deeper than one tier
     CLAMPED to parent+1 (a \subsubsection* under a \section misstates nesting as ##->####)
   - bare URLs / e-mails wrapped <…> (MD034), trailing sentence punctuation left outside
   - REGISTER SAFETY: two adjacent inline spans emit `$a$$b$` — indistinguishable from a display
     fence to every markdown scanner (math-render's extractor included). True display fences sit
     ALONE on their line, so any mid-line unescaped `$$` is span adjacency: restore the boundary.
   - ordered-list accidents: a resolved cross-ref number at line start ("14. Alternatively…")
     reads as a list marker — escaped to prose unless it is genuinely in sequence; flat bullets
     that split a numbered list (flattened nesting) are retro-indented under their item.

  Idempotent: a document that already satisfies the rules passes through byte-identical.
#>

function Format-MdHygiene {
    param([string]$Markdown)
    $lines = [System.Collections.Generic.List[string]]::new()
    $inFence = $false; $blankRun = 0; $lastH = 0
    $olN = 0; $bulletRun = [System.Collections.Generic.List[int]]::new()   # nested-list repair state (see the ol-resume branch)
    foreach ($ln in ($Markdown -split "`n")) {
        if ($ln -match '^```') { $inFence = -not $inFence; $blankRun = 0; $lines.Add($ln); continue }
        if ($inFence) { $lines.Add($ln); continue }
        $ln = ($ln -replace '\t', ' ').TrimEnd()   # hard tabs -> space (MD010); a stray tab can ride out of a restored math/alg span
        if ($ln -eq '') { $blankRun++; if ($blankRun -gt 1) { continue }; $lines.Add(''); continue }
        $blankRun = 0
        if ($ln -match '^(#{1,6})\s+(.*\S)\s*$') {
            # headings: strip trailing sentence punctuation (MD026); CLAMP level jumps deeper than one tier
            # (§5 — an author's \subsubsection* directly under a \section misstates nesting as ##→####).
            $lvl = $matches[1].Length
            if ($lastH -gt 0 -and $lvl -gt $lastH + 1) { $lvl = $lastH + 1 }
            $lastH = $lvl
            $lines.Add(('#' * $lvl) + ' ' + ($matches[2] -replace '[.:;,]+$', ''))
            continue
        }
        if ($ln -ne '$$') {
            $ln = [regex]::Replace($ln, '(?<!\\)\$\$', '$ $')
            $ln = [regex]::Replace($ln, '(?<![<(\[])(https?://[^\s<>()\[\]]+)', {
                    param($m) $u = $m.Groups[1].Value; $p = ''
                    while ($u.Length -gt 1 -and $u[-1] -in '.', ',', ';', ':') { $p = $u[-1] + $p; $u = $u.Substring(0, $u.Length - 1) }
                    "<$u>$p" })
            # bare e-mail -> autolink (MD034); skip if already inside <>/()/[] or a mailto:
            $ln = [regex]::Replace($ln, '(?<![<(\[:/\w.])([A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,})', '<$1>')
            # a resolved cross-ref number landing at line start ("14.  Alternatively…" from a \cref) reads
            # as an ordered-list marker to markdown. Real items follow a blank line or another item IN
            # SEQUENCE (n+1, or 1 for all-ones style); mid-paragraph, or mid-list out of sequence,
            # = accident — escape it to prose.
            if ($ln -match '^(\d+)\. ') {
                $curN = [int]$matches[1]
                $prevLn = if ($lines.Count -gt 0) { $lines[$lines.Count - 1] } else { '' }
                $escape = $false
                # prev-line list shapes accept leading indent (nested items / retro-indented bullets are
                # list CONTEXT, not prose) — required for idempotency: re-running the walk on its own
                # output must not escape an item whose bullets were indented under it on the first pass.
                if ($prevLn -ne '' -and $prevLn -notmatch '^\s*(\d+\. |- |\* )') { $escape = $true }                    # mid-paragraph
                elseif ($prevLn -match '^(\d+)\. ' -and $curN -ne ([int]$matches[1] + 1) -and $curN -ne 1) { $escape = $true }   # mid-list, out of sequence
                if ($escape) { $ln = $ln -replace '^(\d+)\. ', '$1\. ' }
                else {
                    # NESTED-LIST REPAIR: dedent/reflow flattens source nesting (LaTeX itemize inside an
                    # enumerate), emitting flat bullets that SPLIT the ordered list. When item N+1 resumes
                    # after a bullet run, those bullets belong UNDER item N — retro-indent them (md continuation).
                    if ($curN -eq $olN + 1 -and $bulletRun.Count -gt 0) {
                        foreach ($bi in $bulletRun) { $lines[$bi] = '    ' + $lines[$bi] }
                    }
                    $olN = $curN; $bulletRun.Clear()
                }
            }
            elseif ($ln -match '^- ' -and $olN -gt 0) { $bulletRun.Add($lines.Count) }   # candidate nested bullets (index of the line about to be added)
            elseif ($ln -ne '' -and $ln -notmatch '^\s*(\d+[.\\]|- |\* )' -and $olN -gt 0 -and $bulletRun.Count -eq 0) { $olN = 0 }   # prose closes the list; INDENTED list lines are continuation, and bullets pending stay (item text)
        }
        $lines.Add($ln)
    }
    return (($lines -join "`n").TrimEnd()) + "`n"
}
