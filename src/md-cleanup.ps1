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

    $sentinel = [char]0xE000
    $script:mdStore = [System.Collections.Generic.List[string]]::new()
    $script:mdTight = 0
    $protect = { param($m) $script:mdStore.Add($m.Value); "$sentinel$($script:mdStore.Count - 1)$sentinel" }

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
        $script:mdStore.Add($clean); "$sentinel$($script:mdStore.Count - 1)$sentinel"
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
    while ($guard -lt 12 -and $work.IndexOf($sentinel) -ge 0) {
        $work = [regex]::Replace($work, "$sentinel(\d+)$sentinel", { param($m) $script:mdStore[[int]$m.Groups[1].Value] })
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
