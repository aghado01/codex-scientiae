#requires -Version 7.0
<#
  src/logistics/run-paths.ps1 — runstamped artifact addressing.

  This file is the minting authority for both runstamped tiers. Stamp format is
  `yyyyMMdd_HHmmss` in ISO date order (lexical sort = chronological) and carries NO label; the
  `_NN` suffix is a same-second collision sequence, not a description.

    artifacts/{module}/{stamp}/{slug}/        New-ModuleRunDir     per-module run output
    artifacts/tests/{suite}/{stamp}[_NN]/     New-TestSuiteRunDir  test-batch roots

  Two tiers, kept separate on purpose: a test run is not module output. It spans whatever the
  batch selected and holds results, not product, so it lives under the `tests/` process bucket
  keyed by suite rather than beside the module's own artifacts.

  There is no `runs/` segment in either. The stamp under a module IS the run; interposing a
  literal `runs` directory says nothing the layout does not already say (owner ruling 2026-08-26).

  Allocate a fresh run directory, or read existing ones newest-first. Pure path work — no crawler,
  no document identity, no lane knowledge, no filesystem discovery beyond enumerating the tier root
  itself. Containment checks and the test TEMP convention live in the sibling artifact-boundary.ps1.

  Two properties the layout exists for:

    HYGIENE — regenerable working output does not belong interleaved with source. Everything
    regenerable lands under artifacts/ (gitignored wholesale) and the source dir stays source.

    DETERMINISM — a derived tree that is a pure function of its input is NOT per-run output. It
    lives once beside its source and runs read it, rather than each run re-expanding a private
    copy. Only genuinely per-run output (oracle counts, render logs) gets a runstamp.

  Split out of the retired shared runs helper, which carried this convention alongside the
  paper-local {paper}/.runs layout, membrane chunk resolution, and pig-lane IR discovery. Those are
  dormant in the retired shared helper pending the paired latex/pdf comparison work.
#>

# The artifacts TIER itself — the directory runs live under, never its parent. Callers name this
# directly rather than naming a root that gets 'artifacts' appended: a parameter called "repo root"
# reads like "write at the repo root", which is the opposite of the hygiene this layout exists for.
function Get-ArtifactsRoot([string]$ArtifactsRoot = '') {
    if (-not [string]::IsNullOrWhiteSpace($ArtifactsRoot)) { return [System.IO.Path]::GetFullPath($ArtifactsRoot) }
    return (Join-Path ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))) 'artifacts')
}

# One stamped leaf under a tier root, with the shared `_NN` same-second collision sequence.
function New-StampedRunDir([string]$TierRoot, [string]$Slug = '') {
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $leaf = if ([string]::IsNullOrWhiteSpace($Slug)) { '' } else { $Slug }
    $stampDir = Join-Path $TierRoot $stamp
    $n = 0
    while (Test-Path -LiteralPath $stampDir) {
        $n++
        if ($n -gt 99) { throw "New-StampedRunDir: exhausted _NN suffixes for stamp '$stamp'" }
        $stampDir = Join-Path $TierRoot ('{0}_{1:D2}' -f $stamp, $n)
    }
    $dir = if ($leaf) { Join-Path $stampDir $leaf } else { $stampDir }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    return $dir
}

# {artifacts}/{module}/{stamp}/{slug}/ — per-module run output, created fresh.
function New-ModuleRunDir([string]$Module, [string]$Slug, [string]$ArtifactsRoot = '') {
    if ([string]::IsNullOrWhiteSpace($Module)) { throw 'module is required for a run dir' }
    return New-StampedRunDir (Join-Path (Get-ArtifactsRoot $ArtifactsRoot) $Module) $Slug
}

# {artifacts}/tests/{suite}/{stamp}[_NN]/ — test-batch roots, keyed by the suite the batch selected.
# `tests` is a process bucket, not a module: a run holds results, not product, so it does not sit
# beside the module's own artifacts. A batch spanning more than one suite is honestly named
# `mixed` rather than given a suite it does not have. tests/parallel.ps1 calls this when the caller
# omits -RunDirectory.
function New-TestSuiteRunDir([string]$Suite, [string]$ArtifactsRoot = '') {
    $leaf = if ([string]::IsNullOrWhiteSpace($Suite)) { 'mixed' } else { $Suite }
    return New-StampedRunDir (Join-Path (Get-ArtifactsRoot $ArtifactsRoot) 'tests' $leaf)
}

# newest-first run dirs for one slug under a module, stamp-descending. Harnesses read newest-run-wins.
function Get-ModuleRunDirs([string]$Module, [string]$Slug, [string]$ArtifactsRoot = '') {
    $out = [System.Collections.Generic.List[string]]::new()
    $runsRoot = Join-Path (Get-ArtifactsRoot $ArtifactsRoot) $Module
    if ([System.IO.Directory]::Exists($runsRoot)) {
        foreach ($d in ([System.IO.Directory]::EnumerateDirectories($runsRoot) | Sort-Object -Descending)) {
            $slugDir = if ([string]::IsNullOrWhiteSpace($Slug)) { $d } else { Join-Path $d $Slug }
            if ([System.IO.Directory]::Exists($slugDir)) { $out.Add($slugDir) }
        }
    }
    return $out
}
