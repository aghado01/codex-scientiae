#requires -Version 7.0
<#
  src/audits/md-cleanup.ps1 — post-hoc deterministic cleanup for existing markdown corpora.

  Lifts the safe text transforms from the restoration pipeline and runs them straight on assembled
  markdown — no JSON needed. Quick fixes, not the full monty:

    * ligatures   ﬁ ﬂ ﬀ ... -> fi fl ff ...                  (everywhere but fenced code)
    * inline math  unwrapped Greek/operator runs -> $...$ LaTeX (glyph-run detection)
    * closures     existing inline $...$ tightened + unicode->LaTeX (de-spaced, \mathbb stripped)

  Markdown-aware and conservative: fenced code, display $$ blocks, inline code, links/images and
  existing inline math are protected; table rows are left unwrapped (pipes would mis-wrap); leading
  indentation and line endings are preserved. DRY-RUN by default — pass -Apply to write in place.
  Pass -LigaturesOnly to run only ligature repair (safe on math-heavy compendia after layer 3).
  Test-MarkdownCleanupIdempotent verifies a second pass is a no-op after one -Apply.

    . ./md-cleanup.ps1
    Invoke-MarkdownCleanup -Path file.md                 # report only
    Invoke-MarkdownCleanup -Path file.md -Apply          # write in place
    Invoke-MarkdownCleanup -Path some/dir -Apply         # every *.md under dir
#>

. "$PSScriptRoot/../md-postprocess/md-math.ps1"        # Optimize-MathContent, Repair-MathAlignment, Test-MathGlyphToken, Test-StrongMath
. "$PSScriptRoot/../math-register/math-register.ps1"   # Convert-MathToLatex + ConvertTo-RegisterMath (previously reached transitively)
. "$PSScriptRoot/../shared/crawl.ps1"
. "$PSScriptRoot/../latex-ingest/latex.ps1"            # Get-LatexBalance, Test-IsMath, Test-AlignmentOutsideEnv

$script:Ligatures = @{
    "$([char]0xFB00)" = 'ff'; "$([char]0xFB01)" = 'fi'; "$([char]0xFB02)" = 'fl'
    "$([char]0xFB03)" = 'ffi'; "$([char]0xFB04)" = 'ffl'; "$([char]0xFB05)" = 'ft'; "$([char]0xFB06)" = 'st'
}
function Repair-Ligatures([string]$s) {
    foreach ($k in $script:Ligatures.Keys) { if ($s.Contains($k)) { $s = $s.Replace($k, $script:Ligatures[$k]) } }
    return $s
}

# Flush a glyph run, preserving the whitespace that separates it from following prose. A run wraps
# (and converts to LaTeX) only if it carries a strong math character.
function Add-MdMathRun($Run, $Out) {
    if ($Run.Count -eq 0) { return }
    $tail = ''
    while ($Run.Count -gt 0 -and $Run[$Run.Count - 1] -match '^\s+$') { $tail = $Run[$Run.Count - 1] + $tail; $Run.RemoveAt($Run.Count - 1) }
    if ($Run.Count -gt 0) {
        $joined = $Run -join ''
        $strong = 0; foreach ($p in $Run) { if ($p -notmatch '^\s+$' -and (Test-StrongMath $p)) { $strong++ } }
        # a run carrying a non-ASCII, non-Greek letter is OCR corruption (ð, Þ, þ, ...), not math —
        # a real variable is ASCII or Greek. Refuse to wrap it.
        if ($strong -ge 1 -and $joined -notmatch '[\p{L}-[a-zA-ZͰ-Ͽ]]') {
            $Out.Add('$' + (Convert-MathToLatex $joined) + '$')
        }
        else { foreach ($p in $Run) { $Out.Add($p) } }
    }
    if ($tail) { $Out.Add($tail) }
    $Run.Clear()
}

# Whitespace-preserving inline-math wrap of one prose line.
function Wrap-InlineMathMd([string]$Line) {
    $out = [System.Collections.Generic.List[string]]::new()
    $run = [System.Collections.Generic.List[string]]::new()
    foreach ($p in [regex]::Split($Line, '(\s+)')) {
        if ($p -eq '') { continue }
        if ($p -match '^\s+$') { if ($run.Count -gt 0) { $run.Add($p) } else { $out.Add($p) }; continue }
        if (Test-MathGlyphToken $p) { $run.Add($p) }
        else { Add-MdMathRun $run $out; $out.Add($p) }
    }
    Add-MdMathRun $run $out
    return ($out -join '')
}

function Invoke-MarkdownCleanup {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Path,
        [switch]$Apply,
        [switch]$LigaturesOnly
    )
    if (Test-Path -LiteralPath $Path -PathType Container) {
        return @(Invoke-Crawl -Root $Path -Patterns '**/*.md' -Semantics Include |
                 ForEach-Object { Invoke-MarkdownCleanup -Path $_ -Apply:$Apply -LigaturesOnly:$LigaturesOnly })
    }

    $raw  = [System.IO.File]::ReadAllText($Path)
    $nl   = if ($raw.Contains("`r`n")) { "`r`n" } else { "`n" }
    $orig = $raw -replace "`r`n", "`n"

    # Masking marker — MUST be absent from the content. This corpus treats Private Use Area
    # codepoints as semantic typesetter signal (PROCEDURE/WORKFLOW), so the old bare U+E000
    # sentinel could collide with real PUA content and corrupt it on restore. Use a GUID-nonced
    # multi-char ASCII marker (no whitespace / ligature / pipe chars, so the ligature + inline-wrap
    # line passes leave it intact as one prose token; trailing '_' keeps the index digits
    # unambiguous) and assert it does not occur in the source before masking with it.
    $nonce  = [System.Guid]::NewGuid().ToString('N')
    $marker = "RMASK_${nonce}_"
    while ($orig.Contains($marker)) { $nonce = [System.Guid]::NewGuid().ToString('N'); $marker = "RMASK_${nonce}_" }
    $script:mdStore = [System.Collections.Generic.List[string]]::new()
    $script:mdTight = 0
    $protect = { param($m) $script:mdStore.Add($m.Value); "$marker$($script:mdStore.Count - 1)$marker" }

    $work = $orig
    if (-not $LigaturesOnly) {
    $work = [regex]::Replace($work, '(?ms)^```.*?^```', $protect)        # fenced code
    # (the old global \mathbb strip is GONE: alphabet macros are notation-bearing and retained
    # unconditionally — math-register spec §4.1/§8.1 reverses the minimalism-era default.)
    # display math: minimalise (de-space, unicode->LaTeX, register-canonicalize), then protect from
    # later passes. Balance is untouched, so a broken block stays broken and still surfaces in the
    # closure scanner.
    $work = [regex]::Replace($work, '(?s)\$\$(.+?)\$\$', {
        param($m)
        $rebuilt = '$$' + "`n" + (Repair-MathAlignment (ConvertTo-RegisterMath (Convert-MathToLatex (Optimize-MathContent $m.Groups[1].Value @())))) + "`n" + '$$'
        if ($rebuilt -ne $m.Value) { $script:mdTight++ }
        $script:mdStore.Add($rebuilt); "$marker$($script:mdStore.Count - 1)$marker"
    })
    $work = [regex]::Replace($work, '`[^`\n]+`', $protect)               # inline code
    $work = [regex]::Replace($work, '!?\[[^\]]*\]\([^)]*\)', $protect)   # links / images

    # closures: tighten + convert existing inline math, then protect it from the wrap pass
    $work = [regex]::Replace($work, '\$[^$\n]+\$', {
        param($m)
        $inner = $m.Value.Substring(1, $m.Value.Length - 2)
        $clean = '$' + (ConvertTo-RegisterMath -Latex (Convert-MathToLatex (Optimize-MathContent $inner @())) -Inline) + '$'
        if ($clean -ne $m.Value) { $script:mdTight++ }
        $script:mdStore.Add($clean); "$marker$($script:mdStore.Count - 1)$marker"
    })
    }

    # ligatures (all lines) + inline-math wrap (skip table rows — pipes would mis-wrap)
    $ligFixed = 0; $wrapped = 0
    $lines = $work -split "`n", -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $b = $lines[$i]
        $l = Repair-Ligatures $b
        if ($l -ne $b) { $ligFixed++ }
        if (([regex]::Matches($l, '\|')).Count -lt 2) {
            $w = Wrap-InlineMathMd $l
            if ($w -ne $l) { $wrapped++ }
            $l = $w
        }
        $lines[$i] = $l
    }
    $work = $lines -join "`n"

    # restore protected regions (iterative, for any nesting)
    $guard = 0
    $restoreRx = [regex]::Escape($marker) + '(\d+)' + [regex]::Escape($marker)
    while ($guard -lt 12 -and $work.IndexOf($marker) -ge 0) {
        $work = [regex]::Replace($work, $restoreRx, { param($m) $script:mdStore[[int]$m.Groups[1].Value] })
        $guard++
    }

    $changed = $work -ne $orig
    if ($changed -and $Apply) { [System.IO.File]::WriteAllText($Path, ($work -replace "`n", $nl)) }
    [pscustomobject]@{
        file           = [System.IO.Path]::GetFileName($Path)
        changed        = $changed
        ligatures      = $ligFixed
        inline_wrapped = $wrapped
        math_tightened = $script:mdTight
        written        = [bool]($changed -and $Apply)
        ligatures_only = [bool]$LigaturesOnly
    }
}

function Test-MarkdownCleanupIdempotent {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Path)
    if (Test-Path -LiteralPath $Path -PathType Container) {
        return @(Invoke-Crawl -Root $Path -Patterns '**/*.md' -Semantics Include |
                 ForEach-Object { Test-MarkdownCleanupIdempotent -Path $_ })
    }
    $first = Invoke-MarkdownCleanup -Path $Path
    if (-not $first.changed) {
        return [pscustomobject]@{ file = $first.file; idempotent = $true; note = 'already stable' }
    }
    $raw = [System.IO.File]::ReadAllText($Path)
    $nl  = if ($raw.Contains("`r`n")) { "`r`n" } else { "`n" }
    $tmp = [System.IO.Path]::ChangeExtension($Path, '.mdcleanup-idem.tmp')
    try {
        [System.IO.File]::WriteAllText($tmp, ($raw -replace "`r`n", "`n"))
        Invoke-MarkdownCleanup -Path $tmp -Apply | Out-Null
        $second = Invoke-MarkdownCleanup -Path $tmp
        [pscustomobject]@{
            file        = $first.file
            idempotent  = -not $second.changed
            first_pass  = $first.changed
            second_pass = $second.changed
        }
    }
    finally {
        if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
    }
}

# ── closure + structure scanner (read-only) ───────────────────────────────────
# Hands back a punch-list of math that needs reasoning to fix — it detects, it never fixes:
#   * delimiter closures (per span) — {} [] () \left\right that don't balance, via Get-LatexBalance
#   * structure (per file)          — prose captured inside $$ (the tell of a mis-paired delimiter,
#                                      aggregated since one break cascades) and odd-parity orphans
#                                      (a literally unmatched $$, the root of the cascade)
# Delimiter rows are precise (file/line/what's-off/span); structure rows are one verdict per file.

function Format-Imbalance($b) {
    $p = [System.Collections.Generic.List[string]]::new()
    if ($b.brace -gt 0) { $p.Add("$($b.brace) unclosed {") } elseif ($b.brace -lt 0) { $p.Add("$(-$b.brace) extra }") }
    if ($b.brack -gt 0) { $p.Add("$($b.brack) unclosed [") } elseif ($b.brack -lt 0) { $p.Add("$(-$b.brack) extra ]") }
    if ($b.paren -gt 0) { $p.Add("$($b.paren) unclosed (") } elseif ($b.paren -lt 0) { $p.Add("$(-$b.paren) extra )") }
    if ($b.lr    -gt 0) { $p.Add("$($b.lr) unclosed \left") } elseif ($b.lr -lt 0) { $p.Add("$(-$b.lr) extra \right") }
    if ($p.Count -eq 0) { $p.Add('closer before opener') }
    return ($p -join ', ')
}

function Find-MathClosureIssues {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Path)
    if (Test-Path -LiteralPath $Path -PathType Container) {
        return @(Invoke-Crawl -Root $Path -Patterns '**/*.md' -Semantics Include |
                 ForEach-Object { Find-MathClosureIssues -Path $_ })
    }
    $text = ([System.IO.File]::ReadAllText($Path)) -replace "`r`n", "`n"
    $file = [System.IO.Path]::GetFileName($Path)
    $nl   = @([regex]::Matches($text, "`n") | ForEach-Object { $_.Index })
    $out  = [System.Collections.Generic.List[object]]::new()

    # mask fenced code + display math (preserve newlines/offsets) so inline scan ignores them
    $maskInline = [regex]::Replace($text,       '(?ms)^```.*?^```', { param($x) ($x.Value -replace '[^\n]', ' ') })
    $maskInline = [regex]::Replace($maskInline, '(?s)\$\$.+?\$\$',  { param($x) ($x.Value -replace '[^\n]', ' ') })

    $spans = @()
    foreach ($m in [regex]::Matches($text,       '(?s)\$\$(.+?)\$\$')) { $spans += [pscustomobject]@{ idx = $m.Index; val = $m.Value; inner = $m.Groups[1].Value; kind = 'display' } }
    foreach ($m in [regex]::Matches($maskInline, '\$[^$\n]+\$'))       { $spans += [pscustomobject]@{ idx = $m.Index; val = $m.Value; inner = $m.Value.Substring(1, $m.Value.Length - 2); kind = 'inline' } }

    $proseCount = 0; $proseLine = 0
    foreach ($s in $spans) {
        $b = Get-LatexBalance $s.inner
        $line = 1; foreach ($p in $nl) { if ($p -lt $s.idx) { $line++ } else { break } }
        # alignment tab (&) outside an environment is a hard KaTeX/MathJax parse error — independent
        # of brace balance (a block can be perfectly balanced yet still fail at the first &), so it's
        # checked on its own. \\ alone is a legal display line break and is NOT flagged.
        if (Test-AlignmentOutsideEnv $s.inner) {
            $span = ($s.val -replace "`n", ' '); if ($span.Length -gt 72) { $span = $span.Substring(0, 72) + '...' }
            $out.Add([pscustomobject]@{ file = $file; line = $line; kind = $s.kind; issue = ('alignment & outside ' + '\begin{...}' + ' (parse error)'); span = $span })
        }
        if (-not $b.full) {
            $span = ($s.val -replace "`n", ' '); if ($span.Length -gt 72) { $span = $span.Substring(0, 72) + '...' }
            $out.Add([pscustomobject]@{ file = $file; line = $line; kind = $s.kind; issue = (Format-Imbalance $b); span = $span })
        }
        elseif ($s.kind -eq 'display' -and -not (Test-IsMath $s.inner)) {
            $proseCount++; if ($proseLine -eq 0) { $proseLine = $line }
        }
    }

    # structure issues are AGGREGATED per file: one mis-paired $$ cascades into many prose-blocks
    # downstream, so a single verdict (count = severity) is honest where N rows would imply N fixes.
    if ($proseCount -gt 0) {
        $out.Add([pscustomobject]@{ file = $file; line = $proseLine; kind = 'structure'; issue = ("$proseCount display block(s) read as prose - " + '$$' + ' pairing broken upstream'); span = '(first at this line)' })
    }
    $codeMasked = [regex]::Replace($text, '(?ms)^```.*?^```', { param($x) ($x.Value -replace '[^\n]', ' ') })
    $dd = [regex]::Matches($codeMasked, '\$\$')
    if (($dd.Count % 2) -ne 0) {
        $last = $dd[$dd.Count - 1]; $line = 1; foreach ($p in $nl) { if ($p -lt $last.Index) { $line++ } else { break } }
        $out.Add([pscustomobject]@{ file = $file; line = $line; kind = 'structure'; issue = ('unmatched ' + '$$' + ' delimiter (odd count ' + $dd.Count + ')'); span = '(orphan at/after this line)' })
    }
    return $out.ToArray()
}

# ── split-equation repair (write) ─────────────────────────────────────────────
# A display equation broken across a page/column boundary leaves a $$ block that leaks openers
# followed by one that leaks closers, bridged only by whitespace or a short leaked math fragment
# (a stray ")" etc.). Join them when — and only when — the concatenation balances (Get-LatexBalance
# .full). The balance close is the deterministic proof they were one equation; prose between the
# halves aborts the join.

# The text between two display blocks is bridgeable if it's a short math fragment, not prose: strip
# LaTeX command names, then reject anything carrying a real (4+ letter) word or running long.
function Test-MathBridge([string]$between) {
    $t = ($between -replace '\\[A-Za-z]+', ' ').Trim()
    return ($t.Length -le 40 -and $t -notmatch '[A-Za-z]{4,}')
}

# Test-IsMath (math-vs-prose) and Test-AlignmentOutsideEnv now live in latex.ps1, shared with the
# chunk-level fidelity grader so the two derivations of "is this math" can't drift apart. Both
# Find-MathClosureIssues and Repair-SplitEquations below consume them via that sourced module.

function Repair-SplitEquations {
    [CmdletBinding()] param([Parameter(Mandatory)][string]$Path, [switch]$Apply)
    if (Test-Path -LiteralPath $Path -PathType Container) {
        return @(Invoke-Crawl -Root $Path -Patterns '**/*.md' -Semantics Include |
                 ForEach-Object { Repair-SplitEquations -Path $_ -Apply:$Apply })
    }
    $raw  = [System.IO.File]::ReadAllText($Path)
    $eol  = if ($raw.Contains("`r`n")) { "`r`n" } else { "`n" }
    $text = $raw -replace "`r`n", "`n"
    $file = [System.IO.Path]::GetFileName($Path)
    $nl   = @([regex]::Matches($text, "`n") | ForEach-Object { $_.Index })

    $blocks = @()
    foreach ($m in [regex]::Matches($text, '(?s)\$\$(.+?)\$\$')) {
        $blocks += [pscustomobject]@{ start = $m.Index; end = $m.Index + $m.Length; inner = $m.Groups[1].Value }
    }
    $merges = [System.Collections.Generic.List[object]]::new()
    $i = 0
    while ($i -lt $blocks.Count) {
        $b = Get-LatexBalance $blocks[$i].inner
        $leaksOpeners = (-not $b.full) -and (-not $b.everNegative) -and $b.brace -ge 0 -and $b.brack -ge 0 -and $b.paren -ge 0 -and $b.lr -ge 0
        if (-not ($leaksOpeners -and (Test-IsMath $blocks[$i].inner))) { $i++; continue }
        $acc = $blocks[$i].inner.Trim(); $j = $i; $done = $false
        while (($j + 1) -lt $blocks.Count -and ($j - $i) -lt 3) {
            $between = $text.Substring($blocks[$j].end, $blocks[$j + 1].start - $blocks[$j].end)
            if (-not (Test-MathBridge $between)) { break }
            $acc = ($acc + ' ' + $between.Trim() + ' ' + $blocks[$j + 1].inner.Trim()).Trim()
            $j++
            if ((Get-LatexBalance $acc).full) { if (Test-IsMath $acc) { $done = $true }; break }
        }
        if ($done) {
            $line = 1; foreach ($p in $nl) { if ($p -lt $blocks[$i].start) { $line++ } else { break } }
            $merges.Add([pscustomobject]@{ start = $blocks[$i].start; end = $blocks[$j].end; line = $line; parts = ($j - $i + 1); inner = $acc })
            $i = $j + 1
        }
        else { $i++ }
    }

    $work = $text
    for ($k = $merges.Count - 1; $k -ge 0; $k--) {
        $mg = $merges[$k]
        $work = $work.Substring(0, $mg.start) + '$$' + "`n" + $mg.inner + "`n" + '$$' + $work.Substring($mg.end)
    }
    $changed = $work -ne $text
    if ($changed -and $Apply) { [System.IO.File]::WriteAllText($Path, ($work -replace "`n", $eol)) }
    [pscustomobject]@{ file = $file; merges = $merges.Count; written = [bool]($changed -and $Apply); detail = $merges.ToArray() }
}
