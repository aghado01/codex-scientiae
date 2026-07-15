#requires -Version 7.0
<#
  src/gauntlet-batch.ps1 — the gauntlet grinder: greedy parallel batch runner for per-paper
  converter jobs across corpus groups.

  MODEL: gather every runnable job across the given groups, flatten into ONE queue ordered
  longest-first (by source size — big papers start first so the batch tail is short jobs, not a
  monster), and grind it with a fixed worker pool. `ForEach-Object -Parallel -ThrottleLimit N` IS
  the async-greedy dispatcher: a runspace that finishes its job pulls the next queue item. Each
  job executes in its OWN child pwsh process (gauntlet-batch-worker.ps1) — process isolation on
  purpose: the IR layer carries $script:-scoped caches, PdfPig heap on a 7MB paper should die
  with the job, and a worker crash must never take the pool down.

  JOB TYPES (per-paper share-nothing — every write lands under the paper's own dir):
    pig   — Invoke-Pdfdig on {slug}.pdf                 → {paper}/.runs/{stamp}/pig/  (IR + figures + crops)
    latex — Invoke-ArxivLatexToMarkdown on {slug}.tar.gz → {paper}/.runs/{stamp}/tex/ + {slug}-latex.md
            (persists the {slug}.oracle-counts.json sidecar the figure gate scores against)

  INTAKE GUARDS at gather time (they double as the in-flight-download guard for an accession-OPEN
  corpus): a pig job needs a %PDF header, a latex job needs gzip magic — bad or partial sources
  become skip-bad-src rows, never queue entries. Existing runs are respected (newest-wins
  convention: a paper with a pig run / tex run+deliverable is skip-has-run) unless -Force.

  TOOLCHAIN WARMUP (latex): diagram rendering shells to tectonic, whose bundle/format cache is
  shared across processes — a COLD cache warmed by many parallel first-runs can race. When latex
  jobs are queued, Invoke-CorpusBatch runs Initialize-BatchToolchain ONCE before the pool deploys
  (the colonel shape: initialization at compile time, not per worker): pin the cache location and
  compile one tiny tikz/tikz-cd standalone so bundle + format + package caches are hot before any
  worker races them. Non-fatal when tectonic is absent — the render ladder falls back per paper.

    . ./src/gauntlet-batch.ps1
    Get-CorpusBatchJobs -Groups gauntlet/spc -JobTypes pig | Format-Table       # the plan, no work
    Invoke-CorpusBatch  -Groups gauntlet/spc,gauntlet/kisungyou -JobTypes pig,latex -Workers 6
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

# One-time pre-deployment toolchain warmup — runs BEFORE workers deploy, never inside them (the
# colonel analogy: chain-executor loads into the ISS at compile time, once). Pins the tectonic
# cache (Initialize-TectonicCache — the portable-env default location is unreliable; child
# processes inherit the pinned env var) and compiles one minimal tikz/tikz-cd standalone so the
# shared bundle/format/package caches are hot before parallel first-compiles can race them.
# Returns $true when the cache is verifiably hot; $false is non-fatal (the per-paper render
# ladder degrades gracefully — tikzjax/markers — and cold-cache compiles retry once anyway).
function Initialize-BatchToolchain {
    param([Parameter(Mandatory)] [string] $Repo)
    . (Join-Path $Repo 'src/tex-render.ps1')
    $tectonic = Get-TectonicPath
    if (-not $tectonic) {
        Write-Host '  warmup: tectonic absent — diagram renders fall back to the ladder (tikzjax/markers)'
        return $false
    }
    Initialize-TectonicCache
    $work = Join-Path ([System.IO.Path]::GetTempPath()) ('gauntlet-warmup-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
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

function Get-CorpusBatchJobs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string[]] $Groups,
        [ValidateSet('pig', 'latex')] [string[]] $JobTypes = @('pig'),
        [switch] $Force,
        [string] $IngestionRoot = (Join-Path (Split-Path $PSScriptRoot -Parent) 'ingestion')
    )
    $jobs = [System.Collections.Generic.List[object]]::new()
    foreach ($group in $Groups) {
        $gdir = Join-Path $IngestionRoot $group
        if (-not (Test-Path -LiteralPath $gdir)) { throw "group not found: $gdir" }
        foreach ($pd in (Get-ChildItem -LiteralPath $gdir -Directory | Sort-Object Name)) {
            $slug = $pd.Name
            if ($JobTypes -contains 'pig') {
                $pdf = Join-Path $pd.FullName "$slug.pdf"
                if (Test-Path -LiteralPath $pdf) {
                    $hasRun = @(Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -ErrorAction SilentlyContinue).Count -gt 0
                    $status = if ($hasRun -and -not $Force) { 'skip-has-run' }
                              elseif (-not (Test-BatchSourceMagic $pdf 'pdf')) { 'skip-bad-src' }
                              else { 'queued' }
                    $jobs.Add([pscustomobject]@{
                        group = $group; slug = $slug; type = 'pig'; src = $pdf; paper_dir = $pd.FullName
                        mb = [math]::Round((Get-Item -LiteralPath $pdf).Length / 1mb, 2); status = $status })
                }
            }
            if ($JobTypes -contains 'latex') {
                $tgz = Join-Path $pd.FullName "$slug.tar.gz"
                if (Test-Path -LiteralPath $tgz) {
                    $hasRun = (Test-Path -LiteralPath (Join-Path $pd.FullName "$slug-latex.md")) -or
                              @(Get-ChildItem (Join-Path $pd.FullName '.runs/*/tex') -ErrorAction SilentlyContinue).Count -gt 0
                    $status = if ($hasRun -and -not $Force) { 'skip-has-run' }
                              elseif (-not (Test-BatchSourceMagic $tgz 'gz')) { 'skip-bad-src' }
                              else { 'queued' }
                    $jobs.Add([pscustomobject]@{
                        group = $group; slug = $slug; type = 'latex'; src = $tgz; paper_dir = $pd.FullName
                        mb = [math]::Round((Get-Item -LiteralPath $tgz).Length / 1mb, 2); status = $status })
                }
            }
        }
    }
    # queued first, longest-first inside the queue; skips trail for the report
    @($jobs | Sort-Object @{ e = { $_.status -ne 'queued' } }, @{ e = { $_.mb }; Descending = $true })
}

function Invoke-CorpusBatch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string[]] $Groups,
        [ValidateSet('pig', 'latex')] [string[]] $JobTypes = @('pig'),
        [int] $Workers = 6,
        [switch] $Force,
        [switch] $DryRun,
        [string] $LogDir
    )
    $repo = Split-Path $PSScriptRoot -Parent
    $all = Get-CorpusBatchJobs -Groups $Groups -JobTypes $JobTypes -Force:$Force
    $queued = @($all | Where-Object status -EQ 'queued')
    $skipped = @($all | Where-Object status -NE 'queued')
    foreach ($s in $skipped) { Write-Host ("  {0,-14} {1} {2} ({3})" -f $s.status, $s.slug, $s.type, $s.group) }
    if ($DryRun -or -not $queued.Count) {
        Write-Host ("plan: {0} queued / {1} skipped{2}" -f $queued.Count, $skipped.Count, $(if ($DryRun) { ' — dry run, nothing executed' } else { '' }))
        return $all
    }
    if (-not $LogDir) { $LogDir = Join-Path ([System.IO.Path]::GetTempPath()) ('gauntlet-batch-' + (Get-Date -Format 'yyyyMMdd_HHmmss')) }
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    $worker = Join-Path $PSScriptRoot 'gauntlet-batch-worker.ps1'
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
