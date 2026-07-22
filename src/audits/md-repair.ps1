#requires -Version 7.0
<#
  src/md-repair.ps1 — surgical, byte-offset-anchored post-hoc repair for promoted markdown.

  Mirrors the membrane's law of exposure for raw .md (no JSON / IR available post-promotion):
  DETECT problems, classify each into auto-fixable vs needs-manual, and expose a byte-offset
  anchor so the fix — automatic or agent-authored — lands as an exact splice, never a fragile
  find/replace. The byte offset is the markdown analog of the membrane's stable chunk id.

  Heading lane (first detector):
    Get-MdHeadings -Path file.md
        # inventory: every heading with { line, offset, length, level, text, raw, verdict, reason, fix }
    Set-MdSpan -Path file.md -Offset N -Length L -Replacement '...' [-Expect '<current bytes>']
        # surgical byte splice; -Expect makes a stale offset fail loudly instead of corrupting
    Repair-MdHeadings -Path file.md [-Apply]
        # auto-fix the confident verdicts (back-to-front so offsets don't shift), return the escalation list

  Verdicts:
    keep          — real section heading (H1 title, numbered/lettered section, or canonical section word)
    demote-caption — float caption (Algorithm/Figure/Table N ...) -> bold paragraph
    demote-label   — theorem-environment label (incl. number-prefixed) -> bold paragraph
    escalate       — furniture / table-fragment / fused body / cryptic: isolate for surgical hand-fix

  All I/O is UTF-8 without BOM; offsets index on-disk bytes so SMP math / ligatures stay exact.
#>

$script:Utf8 = [System.Text.UTF8Encoding]::new($false)

# Line index over raw file bytes: one record per line with its byte offset and content byte length
# (line terminator excluded), plus decoded text. Handles LF and CRLF; offsets index on-disk bytes.
function Get-MdLineIndex([byte[]]$Bytes) {
    $lines = [System.Collections.Generic.List[object]]::new()
    $n = $Bytes.Length
    $start = 0; $lineNo = 1
    for ($i = 0; $i -lt $n; $i++) {
        if ($Bytes[$i] -eq 0x0A) {
            $contentEnd = $i
            if ($contentEnd -gt $start -and $Bytes[$contentEnd - 1] -eq 0x0D) { $contentEnd-- }  # drop trailing CR
            $len = $contentEnd - $start
            $text = if ($len -gt 0) { $script:Utf8.GetString($Bytes, $start, $len) } else { '' }
            $lines.Add([pscustomobject]@{ Line = $lineNo; Offset = $start; Length = $len; Text = $text })
            $lineNo++; $start = $i + 1
        }
    }
    if ($start -lt $n) {                                          # tail with no trailing newline
        $contentEnd = $n
        if ($contentEnd -gt $start -and $Bytes[$contentEnd - 1] -eq 0x0D) { $contentEnd-- }
        $len = $contentEnd - $start
        $lines.Add([pscustomobject]@{ Line = $lineNo; Offset = $start; Length = $len; Text = $script:Utf8.GetString($Bytes, $start, $len) })
    }
    return $lines
}

# Classify a heading's text (the part after the #s). Order matters: caption/label patterns are tested
# before the numbered/section gate, because "1. Proposition" and "Algorithm 1 ..." both open with a number.
function Get-MdHeadingVerdict([string]$text) {
    $t = $text.Trim()

    # --- float caption -> demote to bold ---
    if ($t -match '^(Algorithm|Figure|Fig\.?|Table|Tab\.?|Listing|Eq\.?|Equation|Scheme|Plate)\s+\d') {
        return @{ verdict = 'demote-caption'; reason = 'float caption'; fix = "**$t**" }
    }

    # --- theorem-environment label -> demote to bold ---
    $env = 'Theorem|Lemma|Proposition|Corollary|Definition|Remark|Proof|Example|Claim|Fact|Conjecture|Notation|Assumption|Observation|Property|Question'
    # env word leading the heading ("Proposition 13. ...", "Theorem 5.3 ...", "Proof of ..."). (?!-) rejects
    # hyphen compounds like "Proof-of-principle experimentation" — a real section, NOT a proof environment.
    if ($t -match "^($env)\b(?!-)") {
        return @{ verdict = 'demote-label'; reason = 'theorem-environment label'; fix = "**$t**" }
    }
    # a number-prefixed BARE env word ("1. Proposition", "6. Lemma") — nothing of substance after the word
    if ($t -match "^\d+[.)]?\s+($env)\b(?!-)\s*[.:]?\s*$") {
        return @{ verdict = 'demote-label'; reason = 'theorem-environment label (number-prefixed)'; fix = "**$t**" }
    }

    # --- front/back-matter furniture promoted to a heading -> escalate ---
    if ($t -match '(?i)(publishing|leibniz-zentrum|national laborator|\bdepartment\b|universit|\binstitut|\bschool of\b)' -or
        $t -match '(?i)^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s+\d{1,2},?\s+\d{4}' -or   # "April 1, 2025"
        $t -match '^[XVILCM]+\s*:\s*\d+\s*$' -or                                                              # "XX :2" page marker
        $t -match '(?i)^(categories and subject|keywords?)\b') {
        return @{ verdict = 'escalate'; reason = 'front/back-matter furniture promoted to heading'; fix = $null }
    }

    # --- real section heading: numbered/lettered, "Appendix X", or a canonical section word ---
    $numbered    = $t -match '^(\d+(\.\d+)*|[A-Z]\.\d+(\.\d+)*)\.?\s'                # 1, 2.3, A.1, B.7 (bare "A" handled below)
    $appendix    = $t -match '(?i)^appendix\s+[A-Z0-9]'
    $sectionWord = $t -match '(?i)^(\d+\.?\s+)?(abstract|introduction|background|related work|preliminar|notation|motivation|method|approach|materials|result|experiment|evaluation|numerical|analysis|discussion|conclusion|references|bibliography|acknowledg|appendix|supplement|reproducib|availability|contents|chapter)'
    if ($numbered -or $appendix -or $sectionWord) {
        # strip the leading section label, then a second sentence fused after the title (". Capital" or
        # " : more") betrays body text run into the heading. Length/math alone do NOT condemn a numbered
        # heading — many real ones are long or carry symbols.
        $body = $t -replace '(?i)^(appendix\s+[A-Z0-9]+|[A-Z]\.\d+(\.\d+)*|\d+(\.\d+)*)[.:)]?\s+', ''
        if ($body -match '\.\s+[A-Z]' -or $body -match '\s:\s\S') {
            return @{ verdict = 'escalate'; reason = 'section heading with body text fused in'; fix = $null }
        }
        return @{ verdict = 'keep'; reason = 'section heading'; fix = $null }
    }

    # --- unnumbered: most are real section titles; escalate only the suspicious shapes ---
    $words = @($t -split '\s+' | Where-Object { $_ })
    # a lone uppercase letter + one-word body — real appendix ("D Datasets") or shattered table column ("T Gudhi")
    if ($t -match '^[A-Z]\s+\S' -and (@(($t -replace '^[A-Z]\s+', '') -split '\s+' | Where-Object { $_ }).Count) -le 1) {
        return @{ verdict = 'escalate'; reason = 'single-letter heading, one-word body — appendix or table fragment?'; fix = $null }
    }
    if ($words.Count -le 1 -and $t.Length -le 5) {
        return @{ verdict = 'escalate'; reason = 'very short token — table fragment?'; fix = $null }
    }
    if ($t -match ':\s*$' -or $t -match '[=\[\]]' -or $t -match '[<>≤≥]\s*\d') {
        return @{ verdict = 'escalate'; reason = 'trailing colon / formula operators — fragment or prose, not a heading'; fix = $null }
    }
    if ($t.Length -gt 90) {
        return @{ verdict = 'escalate'; reason = 'long unnumbered line — prose promoted to a heading?'; fix = $null }
    }
    return @{ verdict = 'keep'; reason = 'unnumbered section heading'; fix = $null }
}

function Get-MdHeadings {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $lines = Get-MdLineIndex $bytes
    $inFence = $false
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($ln in $lines) {
        if ($ln.Text -match '^\s*```') { $inFence = -not $inFence; continue }   # never read inside a code fence
        if ($inFence) { continue }
        if ($ln.Text -match '^(#{1,6})\s+(.*\S)\s*$') {
            $level = $Matches[1].Length
            $htext = $Matches[2]
            $v = if ($level -eq 1) { @{ verdict = 'keep'; reason = 'document title (H1)'; fix = $null } }
                 else { Get-MdHeadingVerdict $htext }
            $out.Add([pscustomobject]@{
                line = $ln.Line; offset = $ln.Offset; length = $ln.Length; level = $level
                text = $htext; raw = $ln.Text; verdict = $v.verdict; reason = $v.reason; fix = $v.fix
            })
        }
    }
    return $out.ToArray()
}

# Surgical splice: replace exactly Length bytes at byte Offset with Replacement. -Expect (the current
# bytes at that span) guards against a stale offset — if they don't match, throw rather than corrupt.
function Set-MdSpan {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][int]$Offset,
        [Parameter(Mandatory)][int]$Length,
        [Parameter(Mandatory)][string]$Replacement,
        [string]$Expect
    )
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($Offset -lt 0 -or $Length -lt 0 -or ($Offset + $Length) -gt $bytes.Length) {
        throw "span out of range: offset=$Offset length=$Length file=$($bytes.Length)B"
    }
    $current = $script:Utf8.GetString($bytes, $Offset, $Length)
    if ($PSBoundParameters.ContainsKey('Expect') -and $current -ne $Expect) {
        throw "stale anchor at [$Offset,+$Length]: on disk = '$current'  expected = '$Expect'  (offsets shifted — re-run Get-MdHeadings)"
    }
    $repl = $script:Utf8.GetBytes($Replacement)
    $tailLen = $bytes.Length - $Offset - $Length
    $new = [byte[]]::new($Offset + $repl.Length + $tailLen)
    [Array]::Copy($bytes, 0, $new, 0, $Offset)
    [Array]::Copy($repl, 0, $new, $Offset, $repl.Length)
    [Array]::Copy($bytes, $Offset + $Length, $new, $Offset + $repl.Length, $tailLen)
    [System.IO.File]::WriteAllBytes($Path, $new)
    return [pscustomobject]@{ path = $Path; offset = $Offset; was = $current; now = $Replacement; byte_delta = ($repl.Length - $Length) }
}

# Detect + auto-fix the confident verdicts, isolate the rest. Auto edits are applied back-to-front so an
# earlier splice never shifts a later anchor. Returns a digest plus the escalation list (each carries the
# offset anchor an agent uses to pull the fragment, decide a fix, and call Set-MdSpan).
function Repair-MdHeadings {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Path, [switch]$Apply)
    $heads = Get-MdHeadings -Path $Path
    $auto  = @($heads | Where-Object { $_.fix })
    $escal = @($heads | Where-Object { $_.verdict -eq 'escalate' })
    $applied = 0
    if ($Apply) {
        foreach ($h in ($auto | Sort-Object offset -Descending)) {
            Set-MdSpan -Path $Path -Offset $h.offset -Length $h.length -Replacement $h.fix -Expect $h.raw | Out-Null
            $applied++
        }
    }
    return [pscustomobject]@{
        path         = $Path
        headings     = $heads.Count
        auto_fixable = $auto.Count
        applied      = $applied
        escalate     = $escal.Count
        escalations  = $escal
    }
}

# GitHub-style heading slug — mirrors finalize.ps1 ConvertTo-Anchor so a regenerated TOC matches finalize.
function Get-MdAnchor([string]$h) {
    (($h.ToLowerInvariant() -replace '[^\w\s-]', '') -replace '\s+', '-')
}

# Regenerate a document's "## Contents" block from its current KEEP headings (H2+), so the in-doc TOC and
# the compendium index (which rebuild-ph-contents.ps1 reads from this block) stop listing demoted/escalated
# headings and dead anchors. An existing References sidecar link is preserved.
function Update-MdContents {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Path, [switch]$Apply)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $lines = Get-MdLineIndex $bytes
    $startIdx = -1
    for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i].Text -match '^##\s+Contents\s*$') { $startIdx = $i; break } }
    if ($startIdx -lt 0) { return [pscustomobject]@{ path = $Path; updated = $false; reason = 'no ## Contents block' } }
    $endIdx = $lines.Count
    for ($j = $startIdx + 1; $j -lt $lines.Count; $j++) { if ($lines[$j].Text -match '^##\s') { $endIdx = $j; break } }
    $refLine = $null
    for ($k = $startIdx + 1; $k -lt $endIdx; $k++) { if ($lines[$k].Text -match '^\s*-\s+\[References\]') { $refLine = $lines[$k].Text.Trim(); break } }
    $heads = @(Get-MdHeadings -Path $Path | Where-Object { $_.level -ge 2 -and $_.verdict -eq 'keep' -and $_.text -notmatch '(?i)^contents\s*$' })
    $toc = [System.Collections.Generic.List[string]]::new()
    foreach ($h in $heads) { $toc.Add(('  ' * ($h.level - 2)) + "- [$($h.text)](#$(Get-MdAnchor $h.text))") }
    if ($refLine) { $toc.Add($refLine) }
    $block = "## Contents`n`n" + ($toc -join "`n") + "`n`n"
    $spanOffset = $lines[$startIdx].Offset
    $spanEnd    = if ($endIdx -lt $lines.Count) { $lines[$endIdx].Offset } else { $bytes.Length }
    if ($Apply) { Set-MdSpan -Path $Path -Offset $spanOffset -Length ($spanEnd - $spanOffset) -Replacement $block | Out-Null }
    return [pscustomobject]@{ path = $Path; updated = [bool]$Apply; entries = $toc.Count }
}
