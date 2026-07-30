#requires -Version 7.0
<#
  src/ingest-batch.ps1 — generic greedy parallel batch runner for per-paper converter jobs.
  (Generalized from the gauntlet-born harness — this is a GENERAL ingestion utility, not a
  gauntlet fixture; the gauntlet is simply its heaviest customer. Slated for exposure as a
  librarian-agent MCP tool once the librarian plane exists — keep Invoke-IngestBatch clean to
  wrap: pure parameters in, result rows out, no interactive state.)

  MODEL: resolve a list of TARGETS into per-paper jobs, flatten into ONE queue ordered
  longest-first (by source size — big papers start first so the batch tail is short jobs, not a
  monster), and grind it with a fixed worker pool. `ForEach-Object -Parallel -ThrottleLimit N` IS
  the async-greedy dispatcher: a runspace that finishes its job pulls the next queue item. Each
  job executes in its OWN child pwsh process (ingest-batch-worker.ps1) — process isolation on
  purpose: the IR layer carries $script:-scoped caches, PdfPig heap on a 7MB paper should die
  with the job, and a worker crash must never take the pool down.

  TARGETS (-Path, 1+; each resolved by what it IS — nothing is hardcoded to any corpus root):
    a .pdf file      → one pig job for that paper
    a .tar.gz file   → one latex job for that paper
    a paper dir      → its jobs ({slug}.pdf / {slug}.tar.gz where slug = the dir name)
    a group dir      → every paper dir under it
  Relative paths resolve against the CWD first, then ingestion-root-relative (so the curated
  shorthand 'gauntlet/spc' works from anywhere in the repo). EXPLICIT FILE TARGETS ARE
  IMPERATIVE: naming a file bypasses skip-has-run — "re-run THIS one" is the hot-example
  iteration loop; directory targets respect existing runs (newest-wins convention) unless -Force.

  JOB TYPES (both per-paper share-nothing — every write lands under the paper's own dir):
    pig   — Invoke-Pdfdig on {slug}.pdf                 → {paper}/.runs/{stamp}/pig/  (IR + figures + crops)
    latex — Invoke-ArxivLatexToMarkdown on {slug}.tar.gz → {paper}/.runs/{stamp}/tex/ + {slug}-latex.md
            (persists the {slug}.oracle-counts.json sidecar the figure gate scores against)
  -JobTypes filters dir-derived jobs (default: both). An explicit file target whose type is
  filtered out becomes a skip-filtered row — never a silent drop.

  INTAKE GUARDS at gather time (they double as the in-flight-download guard for a corpus still
  being populated): a pig job needs a %PDF header, a latex job needs gzip magic — bad or partial
  sources become skip-bad-src rows, never queue entries.

  TOOLCHAIN WARMUP (latex): diagram rendering shells to tectonic, whose bundle/format cache is
  shared across processes — a COLD cache warmed by many parallel first-runs can race. When latex
  jobs are queued, Invoke-IngestBatch runs Initialize-BatchToolchain ONCE before the pool deploys
  (initialization at compile time, never per worker): pin the cache location and compile one tiny
  tikz/tikz-cd standalone so bundle + format + package caches are hot before any worker races
  them. Non-fatal when tectonic is absent — the render ladder falls back per paper.

    . ./src/ingest-batch.ps1
    Get-IngestBatchJobs -Path gauntlet/spc | Format-Table                      # the plan, no work
    Invoke-IngestBatch  -Path gauntlet/spc/BWD1996                             # one paper, both lanes
    Invoke-IngestBatch  -Path ingestion/gauntlet/spc/YG2019/YG2019.pdf         # ONE hot example (re-runs)
    Invoke-IngestBatch  -Path gauntlet/kisungyou, gauntlet/mapper -Workers 6   # corpus-scale grind
#>

# magic-byte sniff: 'pdf' = %PDF- prefix; 'gz' = 1F 8B. A short/unreadable file fails the sniff —
# exactly right for a partially-downloaded source.
function Test-BatchSourceMagic([string] $Path, [string] $Kind) {
    try {
        $fs = [System.IO.File]::OpenRead($Path)
        try { $b = [byte[]]::new(5); $n = $fs.Read($b, 0, 5) } finally { $fs.Dispose() }
        switch ($Kind) {
            'pdf' { return ($n -ge 5 -and [System.Text.Encoding]::ASCII.GetString($b) -eq '%PDF-') }
            'gz'  { return ($n -ge 2 -and $b[0] -eq 0x1F -and $b[1] -eq 0x8B) }
        }
    } catch { return $false }
    $false
}

# One-time pre-deployment toolchain warmup — runs BEFORE workers deploy, never inside them.
# Pins the tectonic cache (Initialize-TectonicCache — the portable-env default location is
# unreliable; child processes inherit the pinned env var) and compiles one minimal tikz/tikz-cd
# standalone so the shared bundle/format/package caches are hot before parallel first-compiles
# can race them. Returns $true when the cache is verifiably hot; $false is non-fatal (the
# per-paper render ladder degrades gracefully — tikzjax/markers — and cold-cache compiles retry
# once anyway).
function Initialize-BatchToolchain {
    param([Parameter(Mandatory)] [string] $Repo)
    . (Join-Path $Repo 'src/latex-ingest/tex-render.ps1')
    $tectonic = Get-TectonicPath
    if (-not $tectonic) {
        Write-Host '  warmup: tectonic absent — diagram renders fall back to the ladder (tikzjax/markers)'
        return $false
    }
    Initialize-TectonicCache
    $work = Join-Path ([System.IO.Path]::GetTempPath()) ('ingest-warmup-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    try {
        $tex = Join-Path $work 'warmup.tex'
        # the base package set the render ladder replays: standalone + tikz + tikz-cd
        $doc = "\documentclass{standalone}`n\usepackage{tikz}`n\usepackage{tikz-cd}`n" +
               "\begin{document}`n\begin{tikzcd}A \arrow[r] & B\end{tikzcd}`n\end{document}`n"
        [System.IO.File]::WriteAllText($tex, $doc, [System.Text.UTF8Encoding]::new($false))
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $tectonic -X compile $tex --outdir $work *> (Join-Path $work 'warmup.log')
        $ok = ($LASTEXITCODE -eq 0 -and (Test-Path (Join-Path $work 'warmup.pdf')))
        Write-Host ("  warmup: tectonic cache {0} ({1}s)" -f $(if ($ok) { 'HOT — probe compile ok' } else { 'probe compile FAILED — workers still retry cold-cache races' }), [math]::Round($sw.Elapsed.TotalSeconds, 1))
        return $ok
    }
    finally { Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue }
}

# Slug from a source file name: strips .pdf, or the DOUBLE extension .tar.gz.
function Get-BatchSlug([string] $FileName) {
    if ($FileName.EndsWith('.tar.gz', [System.StringComparison]::OrdinalIgnoreCase)) { return $FileName.Substring(0, $FileName.Length - 7) }
    [System.IO.Path]::GetFileNameWithoutExtension($FileName)
}

# Resolve one -Path entry: literal/CWD first, then ingestion-root-relative. Classifies into
# pdf-file / tgz-file / paper-dir / group-dir (a dir owning {dirname}.pdf or {dirname}.tar.gz is
# a paper; anything else is a group whose CHILD dirs are treated as papers).
function Resolve-BatchTarget {
    param([Parameter(Mandatory)] [string] $Target, [string] $IngestionRoot)
    $abs = $null
    if (Test-Path -LiteralPath $Target) { $abs = (Resolve-Path -LiteralPath $Target).Path }
    elseif ($IngestionRoot) {
        $cand = Join-Path $IngestionRoot $Target
        if (Test-Path -LiteralPath $cand) { $abs = (Resolve-Path -LiteralPath $cand).Path }
    }
    if (-not $abs) { throw "target not found (checked literal and ingestion-root-relative): $Target" }
    $item = Get-Item -LiteralPath $abs -Force
    if (-not $item.PSIsContainer) {
        if ($item.Name.EndsWith('.pdf', [System.StringComparison]::OrdinalIgnoreCase))    { return @{ kind = 'pdf-file'; path = $abs } }
        if ($item.Name.EndsWith('.tar.gz', [System.StringComparison]::OrdinalIgnoreCase)) { return @{ kind = 'tgz-file'; path = $abs } }
        throw "unsupported file target (need .pdf or .tar.gz): $abs"
    }
    $slug = $item.Name
    $isPaper = (Test-Path -LiteralPath (Join-Path $abs "$slug.pdf")) -or (Test-Path -LiteralPath (Join-Path $abs "$slug.tar.gz"))
    @{ kind = $(if ($isPaper) { 'paper-dir' } else { 'group-dir' }); path = $abs }
}

function Get-IngestBatchJobs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string[]] $Path,
        [ValidateSet('pig', 'latex')] [string[]] $JobTypes = @('pig', 'latex'),
        [switch] $Force,
        [string] $IngestionRoot = (Join-Path (Split-Path $PSScriptRoot -Parent) 'ingestion')
    )
    # group label = ingestion-root-relative when under it (the curated shorthand), else the dir itself
    $rootPrefix = if ($IngestionRoot -and (Test-Path -LiteralPath $IngestionRoot)) { (Resolve-Path -LiteralPath $IngestionRoot).Path + [System.IO.Path]::DirectorySeparatorChar } else { $null }
    $labelOf = {
        param([string] $PaperDir)
        $parent = Split-Path -Parent $PaperDir
        if ($rootPrefix -and $parent.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) { return $parent.Substring($rootPrefix.Length).Replace('\', '/') }
        $parent
    }

    # one job candidate per (paper, type); explicit file targets carry imperative=TRUE
    $seen = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $add = {
        param([string] $Src, [string] $Type, [string] $PaperDir, [bool] $Imperative)
        if ($seen.ContainsKey($Src)) { if ($Imperative) { $seen[$Src].imperative = $true }; return }
        $slug = Get-BatchSlug (Split-Path -Leaf $Src)
        $seen[$Src] = [pscustomobject]@{
            group = & $labelOf $PaperDir; slug = $slug; type = $Type; src = $Src; paper_dir = $PaperDir
            mb = [math]::Round((Get-Item -LiteralPath $Src).Length / 1mb, 2); imperative = $Imperative; status = $null
        }
    }
    $paperJobs = {
        param([string] $PaperDir, [bool] $Imperative)
        $slug = Split-Path -Leaf $PaperDir
        $pdf = Join-Path $PaperDir "$slug.pdf"
        $tgz = Join-Path $PaperDir "$slug.tar.gz"
        if (($JobTypes -contains 'pig') -and (Test-Path -LiteralPath $pdf))   { & $add $pdf 'pig' $PaperDir $Imperative }
        if (($JobTypes -contains 'latex') -and (Test-Path -LiteralPath $tgz)) { & $add $tgz 'latex' $PaperDir $Imperative }
    }

    foreach ($t in $Path) {
        $r = Resolve-BatchTarget -Target $t -IngestionRoot $IngestionRoot
        switch ($r.kind) {
            'pdf-file'  { & $add $r.path 'pig' (Split-Path -Parent $r.path) $true }
            'tgz-file'  { & $add $r.path 'latex' (Split-Path -Parent $r.path) $true }
            'paper-dir' { & $paperJobs $r.path $false }
            'group-dir' {
                $papers = @(Get-ChildItem -LiteralPath $r.path -Directory | Sort-Object Name)
                if (-not $papers.Count) { Write-Warning "group target has no paper dirs: $($r.path)" }
                foreach ($pd in $papers) { & $paperJobs $pd.FullName $false }
            }
        }
    }

    # status: explicit file of a filtered type → skip-filtered (visible, never silent); bad magic →
    # skip-bad-src; existing run → skip-has-run UNLESS imperative or -Force
    foreach ($j in $seen.Values) {
        if ($JobTypes -notcontains $j.type) { $j.status = 'skip-filtered'; continue }
        $magicKind = if ($j.type -eq 'pig') { 'pdf' } else { 'gz' }
        if (-not (Test-BatchSourceMagic $j.src $magicKind)) { $j.status = 'skip-bad-src'; continue }
        $hasRun = if ($j.type -eq 'pig') {
            @(Get-ChildItem (Join-Path $j.paper_dir ".runs/*/pig/$($j.slug).figures.jsonl") -ErrorAction SilentlyContinue).Count -gt 0
        } else {
            (Test-Path -LiteralPath (Join-Path $j.paper_dir "$($j.slug)-latex.md")) -or
            @(Get-ChildItem (Join-Path $j.paper_dir '.runs/*/tex') -ErrorAction SilentlyContinue).Count -gt 0
        }
        $j.status = if ($hasRun -and -not ($Force -or $j.imperative)) { 'skip-has-run' } else { 'queued' }
    }

    # queued first, longest-first inside the queue; skips trail for the report
    @($seen.Values | Sort-Object @{ e = { $_.status -ne 'queued' } }, @{ e = { $_.mb }; Descending = $true })
}

function Invoke-IngestBatch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string[]] $Path,
        [ValidateSet('pig', 'latex')] [string[]] $JobTypes = @('pig', 'latex'),
        [int] $Workers = 6,
        [switch] $Force,
        [switch] $DryRun,
        [string] $LogDir,
        [string] $IngestionRoot
    )
    $repo = Split-Path $PSScriptRoot -Parent
    $gatherArgs = @{ Path = $Path; JobTypes = $JobTypes; Force = $Force }
    if ($IngestionRoot) { $gatherArgs.IngestionRoot = $IngestionRoot }
    $all = Get-IngestBatchJobs @gatherArgs
    $queued = @($all | Where-Object status -EQ 'queued')
    $skipped = @($all | Where-Object status -NE 'queued')
    foreach ($s in $skipped) { Write-Host ("  {0,-14} {1} {2} ({3})" -f $s.status, $s.slug, $s.type, $s.group) }
    if ($DryRun -or -not $queued.Count) {
        Write-Host ("plan: {0} queued / {1} skipped{2}" -f $queued.Count, $skipped.Count, $(if ($DryRun) { ' — dry run, nothing executed' } else { '' }))
        return $all
    }
    if (-not $LogDir) { $LogDir = Join-Path ([System.IO.Path]::GetTempPath()) ('ingest-batch-' + (Get-Date -Format 'yyyyMMdd_HHmmss')) }
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    $worker = Join-Path $PSScriptRoot 'ingest-batch-worker.ps1'
    # initialization phase: shared-toolchain warmup BEFORE the pool deploys (once, not per worker)
    if (@($queued | Where-Object type -EQ 'latex').Count) { $null = Initialize-BatchToolchain -Repo $repo }
    Write-Host ("batch: {0} job(s) on {1} worker(s); per-job logs -> {2}" -f $queued.Count, $Workers, $LogDir)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    $results = $queued | ForEach-Object -ThrottleLimit $Workers -Parallel {
        $j = $_
        $log = Join-Path $using:LogDir ("{0}.{1}.log" -f $j.slug, $j.type)
        $t = [System.Diagnostics.Stopwatch]::StartNew()
        & pwsh -NoProfile -NonInteractive -File $using:worker `
            -Type $j.type -Src $j.src -Slug $j.slug -PaperDir $j.paper_dir -Repo $using:repo *> $log
        $ok = ($LASTEXITCODE -eq 0)
        $t.Stop()
        # the worker's final stdout line is a compact JSON result (BATCH-RESULT prefix); absent on crash
        $detail = $null
        foreach ($line in @(Get-Content -LiteralPath $log -Tail 5 -ErrorAction SilentlyContinue)) {
            if ($line -like 'BATCH-RESULT *') { try { $detail = $line.Substring(13) | ConvertFrom-Json } catch {} }
        }
        $row = [pscustomobject]@{
            group = $j.group; slug = $j.slug; type = $j.type
            status = $(if ($ok) { 'ok' } else { 'FAIL' })
            min = [math]::Round($t.Elapsed.TotalMinutes, 1); mb = $j.mb
            run = $detail.run; note = $detail.note; log = $log
        }
        Write-Host ("  [{0}] {1,-16} {2,-5} {3,-4} {4,5} min  {5}" -f (Get-Date -Format 'HH:mm:ss'), $row.slug, $row.type, $row.status, $row.min, ($row.note ?? ''))
        $row
    }

    $sw.Stop()
    $results = @($results)
    $fails = @($results | Where-Object status -EQ 'FAIL')
    Write-Host ("batch done: {0} ok / {1} FAIL, wall {2} min for {3} job-min of work ({4:n1}x)" -f `
        ($results.Count - $fails.Count), $fails.Count, [math]::Round($sw.Elapsed.TotalMinutes, 1), `
        [math]::Round((@($results | Measure-Object min -Sum).Sum), 1), `
        $(if ($sw.Elapsed.TotalMinutes -gt 0) { (@($results | Measure-Object min -Sum).Sum) / $sw.Elapsed.TotalMinutes } else { 0 }))
    $results + $skipped
}
