#requires -Version 7.0
<#
  src/audits/md-bundle.ps1 — standalone-deliverable bundling, as a format-agnostic markdown
  primitive: copy a finished .md plus every LOCAL asset it references to a destination shelf
  (the ingestion/_markdown pattern — {slug}-latex.md beside its {slug}/ asset folder), then
  VERIFY the result: every relative image link must resolve at the destination, and known defect
  sentinels (U+FFFD, leaked @@…@@ placeholders, FILL_ME_IN) are counted, never silently shipped.

  This is delivery polish WITHOUT the publish formalities — no compendium index, no Contents-page
  rewrite (that stays src/publish.ps1's job). Lane-agnostic: works on latex-ingest, membrane, or
  hand-edited markdown alike, because it reads only the document and its links.
#>

. "$PSScriptRoot/md-toc.ps1"   # Export-MdTocSidecar — standalone byte-spanned TOC sidecar primitive

$script:BundleUtf8 = [System.Text.UTF8Encoding]::new($false)

# Relative image-link targets in markdown TEXT, reading order, deduped. Web/data URIs, absolute
# and drive/UNC paths are NOT bundle candidates and are skipped (never an error — a web image is
# legitimate; only a relative link that fails to resolve is a defect, and that surfaces below).
function Get-MdLocalImageLinks([string]$Markdown) {
    $targets = [System.Collections.Generic.List[string]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($m in [regex]::Matches($Markdown, '!\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)')) {
        $t = $m.Groups[1].Value
        if ($t -match '^(?:[a-z][a-z0-9+.-]*:|/|\\\\|[A-Za-z]:)') { continue }
        if ($seen.Add($t)) { $targets.Add($t) }
    }
    return ,$targets
}

# Copy {md + referenced local assets} -> $DestDir, preserving each asset's relative subpath so the
# document's links keep resolving unchanged. Returns the audit record; missing sources and sentinel
# hits are REPORTED, never fatal — the bundle lands as complete as the source allows, and the
# record says exactly what is owed (the flagged-marker doctrine: no silent drops).
function Copy-MdDeliverable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$MarkdownPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$DestDir
    )
    $srcPath = (Resolve-Path -LiteralPath $MarkdownPath -ErrorAction Stop).Path
    $srcDir  = Split-Path -Parent $srcPath
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    $destDirFull = (Resolve-Path -LiteralPath $DestDir).Path
    $md = [System.IO.File]::ReadAllText($srcPath, $script:BundleUtf8)

    $targets = Get-MdLocalImageLinks $md
    $copied = 0; $missing = [System.Collections.Generic.List[string]]::new()
    foreach ($t in $targets) {
        $from = Join-Path $srcDir $t
        if (-not (Test-Path -LiteralPath $from -PathType Leaf)) { $missing.Add($t); continue }
        $to = Join-Path $destDirFull $t
        $toDir = Split-Path -Parent $to
        if ($toDir) { New-Item -ItemType Directory -Force -Path $toDir | Out-Null }
        if ((Resolve-Path -LiteralPath $from).Path -ne ([System.IO.Path]::GetFullPath($to))) {
            Copy-Item -LiteralPath $from -Destination $to -Force
        }
        $copied++
    }

    $mdOut = Join-Path $destDirFull (Split-Path -Leaf $srcPath)
    if ($srcPath -ne [System.IO.Path]::GetFullPath($mdOut)) {
        Copy-Item -LiteralPath $srcPath -Destination $mdOut -Force
    }

    # Emit standalone byte-spanned TOC sidecars ({slug}-toc.md and {slug}.toc.jsonl) on the shelf
    $tocSidecar = Export-MdTocSidecar -MarkdownPath $mdOut -OutDir $destDirFull

    # post-copy verification at the DESTINATION — the shipped bundle is what gets checked
    $broken = [System.Collections.Generic.List[string]]::new()
    foreach ($t in $targets) {
        if (-not (Test-Path -LiteralPath (Join-Path $destDirFull $t) -PathType Leaf)) { $broken.Add($t) }
    }
    $sentinels = [ordered]@{
        replacement_char = ([regex]::Matches($md, [char]0xFFFD)).Count   # destroyed codepoints (membrane codepoint-safety doctrine)
        placeholders     = ([regex]::Matches($md, '@@[A-Z]+\d+@@')).Count # leaked protection markers (LMATH/LDISP/ALG/VERB…)
        fill_me_in       = ([regex]::Matches($md, 'FILL_ME_IN')).Count
    }

    return [pscustomobject]@{
        md            = $mdOut
        links_total   = $targets.Count
        assets_copied = $copied
        assets_missing = @($missing)     # referenced, absent at the SOURCE — the conversion owes these
        links_broken   = @($broken)      # unresolved at the DESTINATION after copy (should be ⊆ missing)
        sentinels      = [pscustomobject]$sentinels
        clean          = ($broken.Count -eq 0 -and ($sentinels.Values | Measure-Object -Sum).Sum -eq 0)
    }
}
