#requires -Version 7.0
<#
  src/md-cleanup.ps1 — post-hoc deterministic cleanup for existing markdown corpora.

  Lifts the safe text transforms from the restoration pipeline and runs them straight on assembled
  markdown — no JSON needed. Quick fixes, not the full monty:

    * ligatures   ﬁ ﬂ ﬀ ... -> fi fl ff ...                  (everywhere but fenced code)
    * inline math  unwrapped Greek/operator runs -> $...$ LaTeX (glyph-run detection)
    * closures     existing inline $...$ tightened + unicode->LaTeX (de-spaced, \mathbb stripped)

  Markdown-aware and conservative: fenced code, display $$ blocks, inline code, links/images and
  existing inline math are protected; table rows are left unwrapped (pipes would mis-wrap); leading
  indentation and line endings are preserved. DRY-RUN by default — pass -Apply to write in place.

    . ./md-cleanup.ps1
    Invoke-MarkdownCleanup -Path file.md                 # report only
    Invoke-MarkdownCleanup -Path file.md -Apply          # write in place
    Invoke-MarkdownCleanup -Path some/dir -Apply         # every *.md under dir
#>

. "$PSScriptRoot/normalize.ps1"
. "$PSScriptRoot/crawl.ps1"
. "$PSScriptRoot/latex.ps1"

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
        [switch]$Apply
    )
    if (Test-Path -LiteralPath $Path -PathType Container) {
        return @(Invoke-Crawl -Root $Path -Patterns '**/*.md' -Semantics Include |
                 ForEach-Object { Invoke-MarkdownCleanup -Path $_ -Apply:$Apply })
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
    $work = [regex]::Replace($work, '(?ms)^```.*?^```', $protect)        # fenced code
    $work = [regex]::Replace($work, '(?s)\$\$.+?\$\$', $protect)         # display math (untouched)
    $work = [regex]::Replace($work, '`[^`\n]+`', $protect)               # inline code
    $work = [regex]::Replace($work, '!?\[[^\]]*\]\([^)]*\)', $protect)   # links / images

    # closures: tighten + convert existing inline math, then protect it from the wrap pass
    $work = [regex]::Replace($work, '\$[^$\n]+\$', {
        param($m)
        $inner = $m.Value.Substring(1, $m.Value.Length - 2)
        $clean = '$' + (Convert-MathToLatex (Optimize-MathContent $inner @('mathbb'))) + '$'
        if ($clean -ne $m.Value) { $script:mdTight++ }
        $script:mdStore.Add($clean); "$marker$($script:mdStore.Count - 1)$marker"
    })

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
    }
}

# ── closure scanner (read-only) ───────────────────────────────────────────────
# Reports math spans whose delimiters don't close, via the PSLinter-derived Get-LatexBalance. It
# detects, it does not fix — there's no deterministic spot for a missing brace — so it hands back a
# punch-list (file / line / what's off / the span) for a human to close.

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

    foreach ($s in $spans) {
        $b = Get-LatexBalance $s.inner
        if ($b.full) { continue }
        $line = 1; foreach ($p in $nl) { if ($p -lt $s.idx) { $line++ } else { break } }
        $span = ($s.val -replace "`n", ' '); if ($span.Length -gt 72) { $span = $span.Substring(0, 72) + '...' }
        $out.Add([pscustomobject]@{ file = $file; line = $line; kind = $s.kind; issue = (Format-Imbalance $b); span = $span })
    }
    return $out.ToArray()
}
