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
if (Test-Path -LiteralPath (Join-Path $PSScriptRoot '../toc-engine/toc-engine.ps1') -PathType Leaf) {
    . (Join-Path $PSScriptRoot '../toc-engine/toc-engine.ps1')
}

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

# Copy {md + referenced local assets} -> $DestDir/$slug/, creating a self-contained bundle directory.
function Copy-MdDeliverable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$MarkdownPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$DestDir,
        [switch]$EnableEmbeddedToc,
        [switch]$DisableTreeToc,
        [switch]$DisableJsonlToc
    )
    $srcPath = (Resolve-Path -LiteralPath $MarkdownPath -ErrorAction Stop).Path
    $srcDir  = Split-Path -Parent $srcPath
    $fileName = Split-Path -Leaf $srcPath
    $slug = $fileName -replace '(-latex)?\.md$', ''

    # Self-contained bundle directory: $DestDir/$slug/ (unless $DestDir already ends with $slug)
    $destDirFull = [System.IO.Path]::GetFullPath($DestDir)
    $bundleDir = if ((Split-Path -Leaf $destDirFull) -eq $slug) { $destDirFull } else { Join-Path $destDirFull $slug }
    New-Item -ItemType Directory -Force -Path $bundleDir | Out-Null
    $bundleDirFull = (Resolve-Path -LiteralPath $bundleDir).Path

    $md = [System.IO.File]::ReadAllText($srcPath, $script:BundleUtf8)

    # In-doc embedded TOC is DISABLED by default (manuscript is a pristine transfer); refresh ONLY if requested
    if ($EnableEmbeddedToc -and (Get-Command Set-MdContentsBlock -ErrorAction SilentlyContinue)) {
        $md = Set-MdContentsBlock -MarkdownText $md -Slug $slug
    }

    $targets = Get-MdLocalImageLinks $md
    $copied = 0; $missing = [System.Collections.Generic.List[string]]::new()
    $imagesDir = Join-Path $bundleDirFull 'images'

    foreach ($t in $targets) {
        $from = [System.IO.Path]::GetFullPath((Join-Path $srcDir $t))
        if (-not (Test-Path -LiteralPath $from -PathType Leaf)) { $missing.Add($t); continue }

        # Place images into images/ subdirectory
        $imgLeaf = [System.IO.Path]::GetFileName($t)
        $isSvg = $imgLeaf -match '\.svg$'
        if ($isSvg) {
            $pngLeaf = $imgLeaf -replace '\.svg$', '.png'
            $toPng = Join-Path $imagesDir $pngLeaf
            $toDir = Split-Path -Parent $toPng
            if ($toDir) { New-Item -ItemType Directory -Force -Path $toDir | Out-Null }
            
            # Convert SVG to PNG using cairosvg or python shim
            $converted = $false
            try {
                $fromPy = $from.Replace('\', '/')
                $toPngPy = $toPng.Replace('\', '/')
                $pyCmd = "import cairosvg; b=open('$fromPy', 'rb').read(); cairosvg.svg2png(bytestring=b, write_to='$toPngPy')"
                $pyExe = (Get-Command python -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1).Source
                if ($pyExe) {
                    & $pyExe -c $pyCmd 2>$null
                    if ((Test-Path -LiteralPath $toPng -PathType Leaf) -and (Get-Item -LiteralPath $toPng).Length -gt 0) {
                        $converted = $true
                    }
                }
            } catch {}

            if ($converted) {
                # Update link in markdown to point to PNG in images/
                $md = $md.Replace("($t)", "(images/$pngLeaf)")
                $copied++
                continue
            }
        }

        # Non-SVG or SVG conversion fallback: copy directly to images/
        $to = Join-Path $imagesDir $imgLeaf
        $toDir = Split-Path -Parent $to
        if ($toDir) { New-Item -ItemType Directory -Force -Path $toDir | Out-Null }
        if ((Resolve-Path -LiteralPath $from).Path -ne ([System.IO.Path]::GetFullPath($to))) {
            Copy-Item -LiteralPath $from -Destination $to -Force
        }

        # Update link in markdown to point to images/
        $md = $md.Replace("($t)", "(images/$imgLeaf)")
        $copied++
    }

    $mdOut = Join-Path $bundleDirFull "$slug.md"
    [System.IO.File]::WriteAllText($mdOut, $md, $script:BundleUtf8)

    # Emit standalone byte-spanned TOC sidecars ({slug}-tree.md and {slug}.toc.jsonl) via toc-engine
    $tocSidecar = if (Get-Command Export-MdTreeSidecar -ErrorAction SilentlyContinue) {
        Export-MdTreeSidecar -MarkdownPath $mdOut -OutDir $bundleDirFull -Slug $slug -DisableTreeToc:$DisableTreeToc -DisableJsonlToc:$DisableJsonlToc
    } else {
        Export-MdTocSidecar -MarkdownPath $mdOut -OutDir $bundleDirFull -Slug $slug
    }

    # post-copy verification at the DESTINATION — the shipped bundle is what gets checked
    $destTargets = Get-MdLocalImageLinks $md
    $broken = [System.Collections.Generic.List[string]]::new()
    foreach ($t in $destTargets) {
        $check1 = Test-Path -LiteralPath (Join-Path $bundleDirFull $t) -PathType Leaf
        $check2 = Test-Path -LiteralPath (Join-Path $imagesDir ([System.IO.Path]::GetFileName($t))) -PathType Leaf
        if (-not ($check1 -or $check2)) { $broken.Add($t) }
    }
    $sentinels = [ordered]@{
        replacement_char = ([regex]::Matches($md, [char]0xFFFD)).Count   # destroyed codepoints (membrane codepoint-safety doctrine)
        placeholders     = ([regex]::Matches($md, '@@[A-Z]+\d+@@')).Count # leaked protection markers (LMATH/LDISP/ALG/VERB…)
        fill_me_in       = ([regex]::Matches($md, 'FILL_ME_IN')).Count
    }

    return [pscustomobject]@{
        bundle_dir    = $bundleDirFull
        md            = $mdOut
        toc_md        = $tocSidecar.toc_md
        toc_jsonl     = $tocSidecar.toc_jsonl
        links_total   = $targets.Count
        assets_copied = $copied
        assets_missing = @($missing)     # referenced, absent at the SOURCE — the conversion owes these
        links_broken   = @($broken)      # unresolved at the DESTINATION after copy (should be ⊆ missing)
        sentinels      = [pscustomobject]$sentinels
        clean          = ($broken.Count -eq 0 -and ($sentinels.Values | Measure-Object -Sum).Sum -eq 0)
    }
}
