#requires -Version 7.0
<#
  src/runs.ps1 — the run layout + paper addressing, as a standalone layer.

  Every workflow pass lands its intermediate artifacts in a runstamped dir —
  {paper}/.runs/{yyyyMMdd_HHmmss}/ — beside the source it derives from. Non-destructive iteration
  by construction: a new run never touches a prior one; the legacy single .scratch/ dir reads as
  the OLDEST run; resolution is newest-run-wins unless the address pins a run ({paper}@{run}).

  Split out of serving.ps1 so non-membrane lanes (the LaTeX converter's tarball unpacking) share
  the same layout without dragging the serving stack. Sources only the crawler.
#>

. "$PSScriptRoot/crawl.ps1"

# newest-first chunk paths for one paper, across .runs/* (stamp-descending) then legacy .scratch
function Get-RunChunks([string]$PaperDir, [string]$Slug) {
    $out = [System.Collections.Generic.List[string]]::new()
    $runsRoot = Join-Path $PaperDir '.runs'
    if ([System.IO.Directory]::Exists($runsRoot)) {
        foreach ($d in ([System.IO.Directory]::EnumerateDirectories($runsRoot) | Sort-Object -Descending)) {
            $c = Join-Path $d "$Slug.chunks.jsonl"
            if ([System.IO.File]::Exists($c)) { $out.Add($c) }
        }
    }
    $legacy = Join-Path $PaperDir '.scratch' "$Slug.chunks.jsonl"
    if ([System.IO.File]::Exists($legacy)) { $out.Add($legacy) }
    return $out
}

function Get-LatestChunks([string]$PaperDir, [string]$Slug) {
    return @(Get-RunChunks $PaperDir $Slug) | Select-Object -First 1
}

# fresh run dir; a same-second collision bumps a numeric suffix (still sorts after its base stamp)
function New-RunDir([string]$PaperDir) {
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $dir = Join-Path $PaperDir '.runs' $stamp
    $n = 1
    while (Test-Path -LiteralPath $dir) { $n++; $dir = Join-Path $PaperDir '.runs' "$stamp-$n" }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    return $dir
}

# paper dir from a chunk path, whichever layout it sits in ({paper}/.runs/{stamp}/ or {paper}/.scratch/)
function Get-PaperDirFromChunks([string]$ChunksPath) {
    $d = Split-Path -Parent $ChunksPath
    if ((Split-Path -Leaf $d) -eq '.scratch') { return (Split-Path -Parent $d) }
    $p = Split-Path -Parent $d
    if ((Split-Path -Leaf $p) -eq '.runs') { return (Split-Path -Parent $p) }
    return $p   # explicit/foreign layout: best effort
}

# --- pig / pdfdig IR-lane discovery: the converter's regenerable IR ({slug}.pdfdig.json + lanes +
#     nodes/classify/figures) lands under {paper}/.runs/{stamp}/pig/ (git-ignored, mirrors the tex
#     lane's .runs/{stamp}/tex/), NOT beside the source. These helpers find the newest such run.

# paper dir from an IR envelope path: a docling/beside-source raw sits in the paper dir directly; a
# pig-lane envelope sits under {paper}/.runs/{stamp}/pig/, so climb back out to the paper dir.
function Get-PaperDirFromIr([string]$IrPath) {
    $d = Split-Path -Parent $IrPath
    if ((Split-Path -Leaf $d) -eq 'pig') {
        $stampDir = Split-Path -Parent $d
        $runsDir  = Split-Path -Parent $stampDir
        if ((Split-Path -Leaf $runsDir) -eq '.runs') { return (Split-Path -Parent $runsDir) }
    }
    return $d
}

# newest-first pig-lane IR run dirs ({paper}/.runs/{stamp}/pig holding {slug}.pdfdig.json), stamp-desc.
function Get-PigRunDirs([string]$PaperDir, [string]$Slug) {
    $out = [System.Collections.Generic.List[string]]::new()
    $runsRoot = Join-Path $PaperDir '.runs'
    if ([System.IO.Directory]::Exists($runsRoot)) {
        foreach ($d in ([System.IO.Directory]::EnumerateDirectories($runsRoot) | Sort-Object -Descending)) {
            $pig = Join-Path $d 'pig'
            if ([System.IO.File]::Exists((Join-Path $pig "$Slug.pdfdig.json"))) { $out.Add($pig) }
        }
    }
    return $out
}

# newest pig-lane envelope path for a paper, or $null. Prefers the run layout
# ({paper}/.runs/{stamp}/pig/); falls back to the RETIRED beside-source location so any pre-
# orchestrator conversion still resolves. The {slug}.nodes.jsonl the classifier emits sits beside it.
function Get-PigEnvelope([string]$PaperDir, [string]$Slug) {
    $dirs = @(Get-PigRunDirs $PaperDir $Slug)
    if ($dirs.Count) { return (Join-Path $dirs[0] "$Slug.pdfdig.json") }
    $legacy = Join-Path $PaperDir "$Slug.pdfdig.json"
    if ([System.IO.File]::Exists($legacy)) { return $legacy }
    return $null
}

# a run's display name from its chunk path: the runstamp, or '.scratch' for the legacy dir
function Get-RunName([string]$ChunksPath) {
    return (Split-Path -Leaf (Split-Path -Parent $ChunksPath))
}

# split a '{paper}@{run}' address → paper part + run pin ($null when unpinned). The pin names a
# runstamp ('20260701_203601') or the legacy '.scratch'; '@' appears in neither slugs nor paths.
function Split-PaperAddress([string]$Paper) {
    $i = $Paper.LastIndexOf('@')
    if ($i -gt 0 -and $i -lt ($Paper.Length - 1)) { return @($Paper.Substring(0, $i), $Paper.Substring($i + 1)) }
    return @($Paper, $null)
}

# --- paper addressing: a bare slug (must be UNIQUE under $Root — ambiguity is an error, never
#     first-hit-wins) or a root-relative paper-dir path ('compendia/membrane-testing/2508.11646v1';
#     a leading 'ingestion/' is tolerated). Path form is confined to $Root.
function Resolve-PaperDir([string]$Root, [string]$Paper) {
    if ([string]::IsNullOrWhiteSpace($Paper)) { throw "invalid paper name: '$Paper'" }
    $p = $Paper -replace '\\', '/'
    if ($p -match '/') {
        $rootFull = [System.IO.Path]::GetFullPath($Root)
        if ((Split-Path -Leaf $rootFull) -eq 'ingestion' -and $p -match '^ingestion/') { $p = $p.Substring(10) }
        $full = [System.IO.Path]::GetFullPath((Join-Path $rootFull $p))
        $sep  = [System.IO.Path]::DirectorySeparatorChar
        if (-not ("$full$sep").StartsWith(($rootFull.TrimEnd($sep) + $sep), [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "paper path escapes the ingestion root: '$Paper'"
        }
        if (-not [System.IO.Directory]::Exists($full)) { throw "paper dir not found: '$Paper'" }
        return $full
    }
    if ($p -notmatch '^[\w.\-]+$') { throw "invalid paper name: '$Paper'" }
    # a paper dir is recognized by EITHER IR lane's raw — {slug}.json (opendataloader) beside the
    # source, or the pdfdig envelope {slug}.pdfdig.json (now under {slug}/.runs/*/pig/, git-ignored;
    # a retired beside-source copy still matches the second glob). A pig-only paper must resolve too.
    $hits = @(Invoke-Crawl -Root $Root -Patterns "**/$p/$p.json", "**/$p/$p.pdfdig.json", "**/$p/.runs/*/pig/$p.pdfdig.json" -Semantics Include |
              ForEach-Object { Get-PaperDirFromIr $_ } | Sort-Object -Unique)
    if ($hits.Count -eq 0) { throw "document not found: $p" }
    if ($hits.Count -gt 1) {
        $rels = $hits | ForEach-Object { [System.IO.Path]::GetRelativePath($Root, $_) -replace '\\', '/' }
        throw "ambiguous paper '$p' — qualify with a path: $($rels -join '  |  ')"
    }
    return $hits[0]
}

# chunks for a paper address: unpinned → the LATEST run; '{paper}@{run}' → exactly that run
# (runstamp or the legacy '.scratch'). An unknown pin throws listing the runs that do exist.
function Resolve-PaperChunks([string]$Root, [string]$Paper) {
    $addr = Split-PaperAddress $Paper
    $dir  = Resolve-PaperDir $Root $addr[0]
    $slug = Split-Path -Leaf $dir
    if ($addr[1]) {
        $c = if ($addr[1] -eq '.scratch') { Join-Path $dir '.scratch' "$slug.chunks.jsonl" }
             else                         { Join-Path $dir '.runs' $addr[1] "$slug.chunks.jsonl" }
        if (-not [System.IO.File]::Exists($c)) {
            $have = @(Get-RunChunks $dir $slug | ForEach-Object { Get-RunName $_ })
            $hint = if ($have.Count) { "runs on disk: $($have -join ', ')" } else { 'no runs on disk' }
            throw "run '$($addr[1])' not found for $slug — $hint"
        }
        return $c
    }
    $c = Get-LatestChunks $dir $slug
    if (-not $c) { throw "document not preprocessed (no run yet): $slug" }
    return $c
}

function Resolve-PaperSource([string]$Root, [string]$Paper, [string]$Lane = 'auto') {
    $addr = Split-PaperAddress $Paper
    if ($addr[1]) { throw "runs are immutable — preprocess always creates a NEW run, so '@$($addr[1])' cannot be re-entered; address the pinned run on the read/repair tools instead" }
    $dir  = Resolve-PaperDir $Root $addr[0]
    $slug = Split-Path -Leaf $dir
    # two IR lanes: {slug}.json (opendataloader/docling era) BESIDE the source, and the pdfdig/pig
    # converter's envelope {slug}.pdfdig.json — now discovered under the newest {slug}/.runs/*/pig/
    # ({slug}.nodes.jsonl beside it in that run dir), NOT beside the source. 'auto' prefers pdfdig
    # (the forward path); pass lane='opendataloader' to choose the docling-repair IR when both exist.
    $odl = Join-Path $dir "$slug.json"
    switch ($Lane) {
        'opendataloader' {
            if (Test-Path -LiteralPath $odl) { return $odl }
            throw "opendataloader source not found for '$slug' ({slug}.json — the docling-repair workflow needs the docling JSON IR)"
        }
        'pdfdig' {
            $pig = Get-PigEnvelope $dir $slug
            if ($pig) { return $pig }
            throw "pdfdig source not found for '$slug' (no {slug}.pdfdig.json under .runs/*/pig/ — run the pig / pdf-converter orchestrator, Invoke-Pdfdig, on the PDF first)"
        }
        default {
            $pig = Get-PigEnvelope $dir $slug
            if ($pig) { return $pig }
            if (Test-Path -LiteralPath $odl) { return $odl }
            throw "source raw not found: $slug (neither a pig run under .runs/*/pig/ nor {slug}.json)"
        }
    }
}
