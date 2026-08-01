#requires -Version 7.0
<#
  src/audits/corpus-audit.ps1 — read-only health audit of the PUBLISHED corpus (the promoted .md bodies under
  compendia/ , codices/ , corpora/). This is the body-side complement to the membrane's chunk-stream
  detectors (src/codex-membrane/fidelity.ps1, exercised by tests/codex-membrane/detectors.Tests.ps1): those grade the IR before
  promotion; this walks what actually shipped and reports the defect classes a deliverable can still
  carry past `publish` (legacy/hand-promoted docs, or classes `publish` does not gate).

  It NEVER writes. It mirrors publish.ps1's hard sentinels (FILL_ME_IN, U+FFFD) and adds the corpus-wide
  hygiene classes surfaced by the 2026-06 housekeeping sweep. Two tiers:

    HARD     — holes that must never ship: FILL_ME_IN, U+FFFD, a UTF-8 BOM (STANDARDS §8 is no-BOM).
               tests/audits/corpus-health.Tests.ps1 pins these (and the now-clean ligature/URL classes) at zero.
    ADVISORY — quality/migration debt, heuristic, not a publish blocker: literal ligatures, mangled URL
               scheme separators, legacy flat image paths ({slug}/… vs images/{slug}/…, STANDARDS §8),
               degenerate single-column tables (a destroyed-table tell), and suspected `?`-mojibake.

  Usage:
    pwsh -File src/audits/corpus-audit.ps1                 # human report over the default roots
    pwsh -File src/audits/corpus-audit.ps1 -Json           # machine-readable findings
    pwsh -File src/audits/corpus-audit.ps1 -Roots compendia
    . ./src/audits/corpus-audit.ps1; Get-CorpusHealth      # dot-source for the data (what the Pester test does)

  PowerShell codepoint discipline (see memory powershell-text-mutation-traps): all matching is ordinal
  via [regex]; String.Replace / -eq / -ne are culture-sensitive and silently fold ligatures, so they are
  NOT used here. I/O is UTF-8-no-BOM with BOM detection done on the raw bytes.
#>
param(
    [string[]]$Roots = @('compendia', 'codices', 'corpora'),
    [string]$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..')),
    [switch]$Json,
    [switch]$Quiet
)

$script:AuditUtf8 = [System.Text.UTF8Encoding]::new($false)

# Ligature block U+FB00-06 (ff fi fl ffi ffl ft st). Ordinal regex class over the actual codepoints.
$script:LigClass = '[' + (-join (0xFB00..0xFB06 | ForEach-Object { [char]$_ })) + ']'
# A mangled scheme separator: scheme colon, then optional inline space, then 3+ slashes; OR colon, inline
# space, then 2+ slashes. Canonical "https://"/"http://" (colon + exactly two slashes, no space) is excluded.
$script:UrlBadRx = '(?:https?):[ \t]*/{3,}|https?:[ \t]+/{2,}'
$script:ImgRx = [regex]'!\[[^\]]*\]\(<?\s*([^)>\s]+?)\s*>?\)'
# A markdown (non-image) link to a local .md target, anchor optional. (?<!\!) drops image links.
$script:MdLinkRx = [regex]'(?<!\!)\[[^\]]*\]\(<?\s*([^)<>\s#]+\.md)(?:#[^)]*)?\s*>?\)'
$script:SingleColSepRx = '(?m)^[ \t]*\|[ \t]*:?-{2,}:?[ \t]*\|[ \t]*$'

# One file's findings. Counts are ordinal occurrence counts; bom is a bool surfaced as 0/1.
function Get-FileHealth([string]$path, [string]$repoRoot) {
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $bom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    $t = [System.IO.File]::ReadAllText($path, $script:AuditUtf8)   # detectEncodingFromByteOrderMarks strips a leading BOM

    $fillme = ([regex]::Matches($t, [regex]::Escape('FILL_ME_IN'))).Count
    $fffd   = ([regex]::Matches($t, [regex]::Escape([string][char]0xFFFD))).Count
    $lig    = ([regex]::Matches($t, $script:LigClass)).Count
    $urlbad = ([regex]::Matches($t, $script:UrlBadRx)).Count
    $singlecol = ([regex]::Matches($t, $script:SingleColSepRx)).Count

    # Link checks scan comment-stripped text: a link inside <!-- --> is intentionally inactive (e.g. the
    # commented-out future-book placeholders in CODICES.md) and must not count as broken.
    $linkText = [regex]::Replace($t, '(?s)<!--.*?-->', '')
    # broken image links: a relative image target that does NOT resolve to a file on disk (convention-
    # agnostic — catches the compendia legacy flat {slug}/… outliers whose figures were moved to
    # images/{slug}/ without rewriting the body, while corpora's {slug}_images/ and codices' own layouts
    # resolve and so are not flagged). External (http(s)/data) and root-absolute targets are skipped.
    $dir = Split-Path -Parent $path
    $brokenimg = 0
    foreach ($m in $script:ImgRx.Matches($linkText)) {
        $tgt = ($m.Groups[1].Value).Trim()
        if (-not $tgt -or $tgt -match '^(?i:https?:)//' -or $tgt -match '^(?i:data:)' -or $tgt -match '^/') { continue }
        $tgt = $tgt -replace '%20', ' '
        if (-not (Test-Path -LiteralPath (Join-Path $dir $tgt))) { $brokenimg++ }
    }
    # broken internal nav: a local .md link target that does not resolve (catches stale telescoping nav,
    # e.g. a pillar index pointing at recategorised papers). External/root-absolute targets skipped.
    $brokenmd = 0
    foreach ($m in $script:MdLinkRx.Matches($linkText)) {
        $tgt = ($m.Groups[1].Value).Trim()
        if (-not $tgt -or $tgt -match '^(?i:https?:)//' -or $tgt -match '^/') { continue }
        $tgt = $tgt -replace '%20', ' '
        if (-not (Test-Path -LiteralPath (Join-Path $dir $tgt))) { $brokenmd++ }
    }
    # suspected ?-mojibake: a letter-?-lowercase run on a NON-URL line (drops forum?id=, cfm?id=, jsp? FPs).
    $mojibake = 0
    foreach ($line in ($t -split "`n")) {
        if ($line -match '(?i:https?://|\.cfm\?|\.jsp\?|\.php\?|/forum\?|openreview)') { continue }
        $mojibake += ([regex]::Matches($line, '[A-Za-z]\?[a-z]')).Count
    }

    $rel = [System.IO.Path]::GetRelativePath($repoRoot, $path) -replace '\\', '/'
    [pscustomobject]@{
        file = $rel
        bom = [int][bool]$bom
        fill_me_in = $fillme
        u_fffd = $fffd
        ligatures = $lig
        url_mangled = $urlbad
        broken_image_link = $brokenimg
        broken_md_link = $brokenmd
        single_col_table = $singlecol
        mojibake_suspect = $mojibake
        hard = ([int][bool]$bom) + $fillme + $fffd
    }
}

# Whole-corpus audit. Returns { generated, roots, files (per-file findings with any nonzero class),
# totals (per-class sums), counts (files scanned), hard_ok (bool) }.
function Get-CorpusHealth {
    [CmdletBinding()] param(
        [string[]]$Roots = @('compendia', 'codices', 'corpora'),
        [string]$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
    )
    $classes = 'bom', 'fill_me_in', 'u_fffd', 'ligatures', 'url_mangled', 'broken_image_link', 'broken_md_link', 'single_col_table', 'mojibake_suspect'
    $totals = [ordered]@{}; foreach ($c in $classes) { $totals[$c] = 0 }
    $perFile = [System.Collections.Generic.List[object]]::new()
    $scanned = 0
    foreach ($r in $Roots) {
        $root = Join-Path $RepoRoot $r
        if (-not (Test-Path -LiteralPath $root)) { continue }
        foreach ($f in (Get-ChildItem -LiteralPath $root -Recurse -Filter *.md -File)) {
            $scanned++
            $h = Get-FileHealth $f.FullName $RepoRoot
            foreach ($c in $classes) { $totals[$c] += [int]$h.$c }
            if (($classes | ForEach-Object { [int]$h.$_ } | Measure-Object -Sum).Sum -gt 0) { $perFile.Add($h) }
        }
    }
    [pscustomobject]@{
        roots = $Roots
        files_scanned = $scanned
        files_with_findings = $perFile.Count
        totals = [pscustomobject]$totals
        hard_ok = (([int]$totals['bom']) + [int]$totals['fill_me_in'] + [int]$totals['u_fffd']) -eq 0
        files = $perFile.ToArray()
    }
}

function Write-CorpusHealthReport($health) {
    $t = $health.totals
    Write-Host ''
    Write-Host "Corpus health — $($health.files_scanned) files under [$($health.roots -join ', ')]"
    Write-Host ('=' * 64)
    Write-Host 'HARD (must be zero — publish holes / encoding):'
    Write-Host ("  FILL_ME_IN .......... {0}" -f $t.fill_me_in)
    Write-Host ("  U+FFFD .............. {0}" -f $t.u_fffd)
    Write-Host ("  UTF-8 BOM files ..... {0}" -f $t.bom)
    Write-Host ("  => {0}" -f $(if ($health.hard_ok) { 'PASS — no holes shipped' } else { 'FAIL — holed/BOM document in the corpus' }))
    Write-Host ''
    Write-Host 'ADVISORY (quality / migration debt):'
    Write-Host ("  literal ligatures ... {0}" -f $t.ligatures)
    Write-Host ("  mangled URL seps .... {0}" -f $t.url_mangled)
    Write-Host ("  broken image links .. {0}" -f $t.broken_image_link)
    Write-Host ("  broken md/nav links . {0}" -f $t.broken_md_link)
    Write-Host ("  single-col tables ... {0}" -f $t.single_col_table)
    Write-Host ("  suspected ?-mojibake  {0}" -f $t.mojibake_suspect)
    if (-not $Quiet -and $health.files.Count -gt 0) {
        Write-Host ''
        Write-Host 'Per-file (nonzero classes only):'
        foreach ($h in ($health.files | Sort-Object -Property @{e={$_.hard}}, @{e={$_.ligatures + $_.url_mangled + $_.broken_image_link}} -Descending)) {
            $flags = @()
            if ($h.fill_me_in) { $flags += "FILL_ME_IN×$($h.fill_me_in)" }
            if ($h.u_fffd) { $flags += "FFFD×$($h.u_fffd)" }
            if ($h.bom) { $flags += 'BOM' }
            if ($h.ligatures) { $flags += "lig×$($h.ligatures)" }
            if ($h.url_mangled) { $flags += "url×$($h.url_mangled)" }
            if ($h.broken_image_link) { $flags += "brokenimg×$($h.broken_image_link)" }
            if ($h.broken_md_link) { $flags += "brokenmd×$($h.broken_md_link)" }
            if ($h.single_col_table) { $flags += "1col×$($h.single_col_table)" }
            if ($h.mojibake_suspect) { $flags += "moji?×$($h.mojibake_suspect)" }
            Write-Host ("  {0,-46} {1}" -f $h.file, ($flags -join ' '))
        }
    }
    Write-Host ''
}

# Run the report only when invoked as a script (pwsh -File / & ), not when dot-sourced (InvocationName '.').
if ($MyInvocation.InvocationName -ne '.') {
    $health = Get-CorpusHealth -Roots $Roots -RepoRoot $RepoRoot
    if ($Json) { $health | ConvertTo-Json -Depth 6 }
    else { Write-CorpusHealthReport $health }
    exit ([int](-not $health.hard_ok))
}
