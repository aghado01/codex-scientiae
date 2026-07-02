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
    $hits = @(Invoke-Crawl -Root $Root -Patterns "**/$p/$p.json" -Semantics Include |
              ForEach-Object { Split-Path -Parent $_ } | Sort-Object -Unique)
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

function Resolve-PaperSource([string]$Root, [string]$Paper) {
    $addr = Split-PaperAddress $Paper
    if ($addr[1]) { throw "runs are immutable — preprocess always creates a NEW run, so '@$($addr[1])' cannot be re-entered; address the pinned run on the read/repair tools instead" }
    $dir  = Resolve-PaperDir $Root $addr[0]
    $slug = Split-Path -Leaf $dir
    $j = Join-Path $dir "$slug.json"
    if (-not (Test-Path -LiteralPath $j)) { throw "source raw not found: $slug" }
    return $j
}
