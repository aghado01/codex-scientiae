#requires -Version 7.0
<#
  src/publish.ps1 — promote a finalized deliverable from its .scratch/ staging into the live
  compendium tree (compendia/{topic}/). This is the post-`finalize` stage the membrane did not
  previously expose as a tool, so agents hand-scripted it from the console (the source of the
  cp1252 / parser churn in the feedback briefs). It crosses the ingestion→compendia boundary
  deliberately: the server now anchors at the repo root so this lane can reach the published corpus.

  Canonical layout (nested-images convention):
    compendia/{topic}/{slug}.md                     # body; figure links rewritten to images/{slug}/...
    compendia/{topic}/references/{slug}.md          # bibliography sidecar
    compendia/{topic}/images/{slug}/imageFileN.png  # only the figures the body actually references
    compendia/{topic}/_CONTENTS.md                  # index block upserted (replace-in-place, else append)

  The _CONTENTS upsert is non-destructive: an existing block for the slug is replaced where it sits
  (thematic ordering preserved); a new slug is appended at the end and flagged for the curator to
  reposition by theme. We never re-sort the index — that ordering is a human curation act.

    . ./publish.ps1
    Invoke-Publish -ChunksPath <.scratch/{slug}.chunks.jsonl> -CompendiaRoot <dir> -Topic <name> [-Force] [-DryRun]
#>

. "$PSScriptRoot/finalize.ps1"

$script:PubUtf8 = [System.Text.UTF8Encoding]::new($false)

# Defect sentinels that must never reach the live corpus: an unconverted-block placeholder (a table or
# block the extractor/agent gave up on and left a marker for) and the U+FFFD lossy-decode char. These are
# holes a `pending` count cannot see — a chunk graded `faithful` can still carry one — so publish gates on
# them in their own right, sourcing the recovery from the .archive raw (the loop that surfaced this).
$script:PubDefectSentinels = @(
    [pscustomobject]@{ Pattern = 'FILL_ME_IN';            Label = 'FILL_ME_IN' }
    [pscustomobject]@{ Pattern = ([string][char]0xFFFD); Label = 'U+FFFD' }
)

# Count each defect sentinel surviving in the materialized body / references. Body-and-refs, since either
# can carry a dropped table. Returns one record per sentinel that fired (label, body, references, total).
function Get-PublishDefects([string]$body, [string]$refs) {
    $found = [System.Collections.Generic.List[object]]::new()
    foreach ($s in $script:PubDefectSentinels) {
        $nb = if ($body) { ([regex]::Matches($body, [regex]::Escape($s.Pattern))).Count } else { 0 }
        $nr = if ($refs) { ([regex]::Matches($refs, [regex]::Escape($s.Pattern))).Count } else { 0 }
        if (($nb + $nr) -gt 0) { $found.Add([pscustomobject]@{ label = $s.Label; body = $nb; references = $nr; total = $nb + $nr }) }
    }
    return $found
}

# Rewrite raw figure links — ![alt](slug/imageFileN.ext) or the <>-wrapped ![alt](<slug/imageFileN.ext>)
# form finalize emits — to the nested images/{slug}/... target. Anchored on the link opener (](  or ](<)
# so only link targets are touched, and idempotent: a path already under images/ never re-matches.
function Convert-ImageLinks([string]$body, [string]$slug) {
    $pat = '(\]\(<?)(' + [regex]::Escape($slug) + '/)'
    return [regex]::Replace($body, $pat, { param($m) $m.Groups[1].Value + 'images/' + $slug + '/' })
}

# The figure filenames the (rewritten) body actually references — under the nested images/{slug}/ form.
function Get-ReferencedImages([string]$body, [string]$slug) {
    $rx = [regex]('images/' + [regex]::Escape($slug) + '/([^)>\s]+)')
    $names = [System.Collections.Generic.List[string]]::new()
    foreach ($m in $rx.Matches($body)) { if ($names -notcontains $m.Groups[1].Value) { $names.Add($m.Groups[1].Value) } }
    return $names
}

# The REAL figures, read from the raw docling .md (which references exactly the kept figures, debris
# already excluded). Preprocessing strips images from the chunk stream, so finalize emits an image-less
# body — these are the figures publish must carry and, where the body omits them, surface for splicing.
# Returns one record per figure: { file, alt }.
function Get-SourceFigures([string]$rawMdPath, [string]$slug) {
    $figs = [System.Collections.Generic.List[object]]::new()
    if (-not (Test-Path -LiteralPath $rawMdPath)) { return $figs }
    $raw = [System.IO.File]::ReadAllText($rawMdPath, $script:PubUtf8)
    $rx = [regex]('!\[([^\]]*)\]\(<?' + [regex]::Escape($slug) + '/([^)>\s]+)>?\)')
    $seen = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($m in $rx.Matches($raw)) {
        $file = $m.Groups[2].Value
        if ($seen.Add($file)) { $figs.Add([pscustomobject]@{ file = $file; alt = $m.Groups[1].Value }) }
    }
    return $figs
}

# Build the compendium _CONTENTS block for one paper: the "## [title](slug.md)" header plus the body's
# own "## Contents" entries with their in-doc anchors re-pointed at slug.md (mirrors rebuild-ph-contents).
function New-ContentsBlock([string]$body, [string]$slug, [string]$title) {
    $toc = [System.Collections.Generic.List[string]]::new()
    $inContents = $false
    foreach ($line in ($body -split "`n")) {
        if ($line -match '^##\s+Contents\s*$') { $inContents = $true; continue }
        if ($inContents -and $line -match '^##\s') { break }
        if ($inContents -and $line -match '^\s*-\s+\[') { $toc.Add(($line -replace '\]\(#', "]($slug.md#")) }
    }
    $block = [System.Collections.Generic.List[string]]::new()
    $block.Add("## [$title]($slug.md)")
    $block.Add('')
    if ($toc.Count -eq 0) { $block.Add("- [References]($slug.md#references)") } else { foreach ($t in $toc) { $block.Add($t) } }
    $block.Add(''); $block.Add('---'); $block.Add('')
    return ($block -join "`n")
}

# Upsert one paper's block into compendia/{topic}/_CONTENTS.md. Replace-in-place if a block for the slug
# exists (position, hence thematic ordering, preserved); else append. Returns the action taken. Never sorts.
function Set-ContentsBlock {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ContentsPath,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string]$Block,
        [switch]$DryRun
    )
    $blockEsc = [regex]::Escape("$Slug.md")
    if (-not (Test-Path -LiteralPath $ContentsPath)) {
        $action = 'created'
        $text = "# " + $Slug + " Compendium`n`n" + $Block        # placeholder H1; curator titles it
    } else {
        $existing = [System.IO.File]::ReadAllText($ContentsPath, $script:PubUtf8)
        # an existing block runs from its "## [..](slug.md..)" header to the next "## " header (exclusive).
        $hdr = [regex]("(?m)^##\s+\[[^\]]*\]\(" + $blockEsc + "[)#]")
        $hm = $hdr.Match($existing)
        if ($hm.Success) {
            $action = 'replaced'
            $rest = $existing.Substring($hm.Index + $hm.Length)
            $nxt = [regex]::Match($rest, "(?m)^##\s+\[")
            $end = if ($nxt.Success) { $hm.Index + $hm.Length + $nxt.Index } else { $existing.Length }
            $text = $existing.Substring(0, $hm.Index) + $Block + $existing.Substring($end)
        } else {
            $action = 'appended'
            $text = $existing.TrimEnd() + "`n`n" + $Block
        }
    }
    if (-not $DryRun) {
        $dir = Split-Path -Parent $ContentsPath
        if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
        [System.IO.File]::WriteAllText($ContentsPath, ($text.TrimEnd() + "`n"), $script:PubUtf8)
    }
    return $action
}

function Invoke-Publish {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [Parameter(Mandatory)][string]$CompendiaRoot,
        [Parameter(Mandatory)][string]$Topic,
        [switch]$Force,
        [switch]$DryRun
    )
    if ($Topic -notmatch '^[\w.\-]+$') { throw "invalid topic: '$Topic'" }

    # (re)materialize the deliverable from the chunk stream so what we promote reflects the latest
    # applied repairs — finalize is idempotent and writes into .scratch/.
    $fin = Invoke-Finalize -ChunksPath $ChunksPath
    $slug = $fin.paper
    # Policy gates enforce on a real publish; a dry run is a pure preview — it reports every blocker in the
    # manifest (pending, defects) rather than throwing, so you can see all of them before committing.
    if ([int]$fin.pending -gt 0 -and -not $Force -and -not $DryRun) {
        throw "deliverable is provisional: $($fin.pending) chunk(s) still flagged. Resolve them (or pass force=true to publish anyway)."
    }

    $scratchDir = Split-Path -Parent $ChunksPath
    $paperDir   = Split-Path -Parent $scratchDir
    $rawImgDir  = Join-Path $paperDir $slug                       # ingestion/.../{slug}/{slug}/imageFileN

    $topicDir = Join-Path $CompendiaRoot $Topic
    $destBody = Join-Path $topicDir "$slug.md"
    $destRefDir = Join-Path $topicDir 'references'
    $destRef  = Join-Path $destRefDir "$slug.md"
    $destImgDir = Join-Path (Join-Path $topicDir 'images') $slug

    # --- body: rewrite figure links to the nested form ---
    $bodyRaw = [System.IO.File]::ReadAllText($fin.body, $script:PubUtf8)
    $body = Convert-ImageLinks $bodyRaw $slug
    $rewrites = ([regex]::Matches($body, 'images/' + [regex]::Escape($slug) + '/')).Count

    # --- references sidecar ---
    $refText = if (Test-Path -LiteralPath $fin.references) { [System.IO.File]::ReadAllText($fin.references, $script:PubUtf8) } else { $null }

    # --- defect guard: a holed deliverable must not silently reach the live corpus (fix the leak) ---
    # @() pins array semantics: an empty List returned through the pipeline unrolls to $null otherwise.
    $defects = @(Get-PublishDefects $body $refText)
    if ($defects.Count -gt 0 -and -not $Force -and -not $DryRun) {
        $d = ($defects | ForEach-Object { "$($_.total)×$($_.label)" }) -join ', '
        throw "refusing to publish a holed deliverable ($d): a defect sentinel survived into the body/references. Recover the dropped content from its raw under .archive/compendia/$Topic/$slug/ and re-finalize, or pass force=true to ship the holes anyway."
    }

    # --- figures: carry the REAL figures (from the raw docling md), and surface which the body omits ---
    $srcFigs  = Get-SourceFigures (Join-Path $paperDir "$slug.md") $slug
    $bodyRefs = Get-ReferencedImages $body $slug
    $imgPlan = [System.Collections.Generic.List[object]]::new()
    $imgMissing = [System.Collections.Generic.List[string]]::new()
    $omitted = [System.Collections.Generic.List[object]]::new()
    foreach ($f in $srcFigs) {
        $src = Join-Path $rawImgDir $f.file
        if (Test-Path -LiteralPath $src) { $imgPlan.Add([pscustomobject]@{ src = $src; dest = (Join-Path $destImgDir $f.file) }) }
        else { $imgMissing.Add($f.file) }
        if ($bodyRefs -notcontains $f.file) {
            $omitted.Add([pscustomobject]@{ file = $f.file; alt = $f.alt; splice = "![$($f.alt)](images/$slug/$($f.file))" })
        }
    }

    # --- _CONTENTS block ---
    $title = ($body -split "`n" | Where-Object { $_ -match '^#\s+' } | Select-Object -First 1) -replace '^#\s+', ''
    if (-not $title) { $title = $slug }
    $contentsPath = Join-Path $topicDir '_CONTENTS.md'
    $block = New-ContentsBlock $body $slug $title

    if (-not $DryRun) {
        foreach ($d in @($topicDir, $destRefDir, $destImgDir)) { if (-not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null } }
        [System.IO.File]::WriteAllText($destBody, $body, $script:PubUtf8)
        if ($null -ne $refText) { [System.IO.File]::WriteAllText($destRef, $refText, $script:PubUtf8) }
        foreach ($p in $imgPlan) { Copy-Item -LiteralPath $p.src -Destination $p.dest -Force }
    }
    $contentsAction = Set-ContentsBlock -ContentsPath $contentsPath -Slug $slug -Block $block -DryRun:$DryRun

    if (-not $DryRun) {
        Add-LedgerEntry $ChunksPath 'published' @{
            topic = $Topic; body = (Get-RepoRelative $destBody $CompendiaRoot); images = $imgPlan.Count
            figures_omitted = $omitted.Count; defects = $defects.Count; contents = $contentsAction; pending = $fin.pending
        }
    }

    # honest closing note: the mechanical move never silently hides the two gaps publish can't close
    # itself — a provisional deliverable, and figures finalize dropped that the body still lacks.
    $notes = [System.Collections.Generic.List[string]]::new()
    if ($contentsAction -eq 'appended') { $notes.Add("_CONTENTS block appended at end — reposition by theme if desired.") }
    if ($omitted.Count -gt 0) { $notes.Add("$($omitted.Count) source figure(s) are NOT referenced in the body (finalize strips images). Files are placed under images/$slug/; splice each into the body with splice_md using the ready snippet in figures_omitted.") }
    if ($defects.Count -gt 0) { $notes.Add("$(($defects | ForEach-Object { "$($_.total)×$($_.label)" }) -join ', ') defect sentinel(s) survived into the deliverable — recover from the .archive raw before publishing (force=true ships the holes).") }
    if ([int]$fin.pending -gt 0) { $notes.Add("$($fin.pending) chunk(s) still flagged (provisional deliverable).") }

    return [pscustomobject]@{
        ok = $true; paper = $slug; topic = $Topic; dry_run = [bool]$DryRun
        body = $destBody; references = $(if ($null -ne $refText) { $destRef } else { $null })
        images = $imgPlan.Count; images_missing = $imgMissing.ToArray(); links_rewritten = $rewrites
        figures_omitted = $omitted.ToArray()
        defects = $defects
        contents = [pscustomobject]@{ action = $contentsAction; path = $contentsPath }
        pending = $fin.pending
        notes = $notes.ToArray()
    }
}

# best-effort repo-relative path for the ledger record (cosmetic; absolute is fine if it escapes)
function Get-RepoRelative([string]$path, [string]$compendiaRoot) {
    try { $repo = Split-Path -Parent $compendiaRoot; return ([System.IO.Path]::GetRelativePath($repo, $path) -replace '\\', '/') }
    catch { return $path }
}
