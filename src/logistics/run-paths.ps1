#requires -Version 7.0
<#
  src/logistics/run-paths.ps1 — runstamped artifact addressing.

  The artifacts/{module}/runs/{stamp}/{slug}/ convention: allocate a fresh run directory, or read
  existing ones newest-first. Pure path work — no crawler, no document identity, no lane knowledge,
  no filesystem discovery beyond enumerating the runs root itself.

  Two properties the layout exists for:

    HYGIENE — regenerable working output does not belong interleaved with source. Everything
    regenerable lands under artifacts/ (gitignored wholesale) and the source dir stays source.

    DETERMINISM — a derived tree that is a pure function of its input is NOT per-run output. It
    lives once beside its source and runs read it, rather than each run re-expanding a private
    copy. Only genuinely per-run output (oracle counts, render logs) gets a runstamp.

  Split out of the retired shared runs helper, which carried this convention alongside the
  paper-local {paper}/.runs layout, membrane chunk resolution, and pig-lane IR discovery. Those are
  dormant in src/shared/runs-depr.ps1 pending the paired latex/pdf comparison work.
#>

# The artifacts TIER itself — the directory runs live under, never its parent. Callers name this
# directly rather than naming a root that gets 'artifacts' appended: a parameter called "repo root"
# reads like "write at the repo root", which is the opposite of the hygiene this layout exists for.
function Get-ArtifactsRoot([string]$ArtifactsRoot = '') {
    if (-not [string]::IsNullOrWhiteSpace($ArtifactsRoot)) { return [System.IO.Path]::GetFullPath($ArtifactsRoot) }
    return (Join-Path ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))) 'artifacts')
}

# {artifacts}/{module}/runs/{stamp}/{slug}/ — created fresh; a same-second collision bumps a suffix.
function New-ModuleRunDir([string]$Module, [string]$Slug, [string]$ArtifactsRoot = '') {
    if ([string]::IsNullOrWhiteSpace($Module)) { throw 'module is required for a run dir' }
    $runsRoot = Join-Path (Get-ArtifactsRoot $ArtifactsRoot) $Module 'runs'
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $leaf = if ([string]::IsNullOrWhiteSpace($Slug)) { '' } else { $Slug }
    $dir = if ($leaf) { Join-Path $runsRoot $stamp $leaf } else { Join-Path $runsRoot $stamp }
    $n = 1
    while (Test-Path -LiteralPath $dir) {
        $n++
        $dir = if ($leaf) { Join-Path $runsRoot "$stamp-$n" $leaf } else { Join-Path $runsRoot "$stamp-$n" }
    }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    return $dir
}

# newest-first run dirs for one slug under a module, stamp-descending. Harnesses read newest-run-wins.
function Get-ModuleRunDirs([string]$Module, [string]$Slug, [string]$ArtifactsRoot = '') {
    $out = [System.Collections.Generic.List[string]]::new()
    $runsRoot = Join-Path (Get-ArtifactsRoot $ArtifactsRoot) $Module 'runs'
    if ([System.IO.Directory]::Exists($runsRoot)) {
        foreach ($d in ([System.IO.Directory]::EnumerateDirectories($runsRoot) | Sort-Object -Descending)) {
            $slugDir = if ([string]::IsNullOrWhiteSpace($Slug)) { $d } else { Join-Path $d $Slug }
            if ([System.IO.Directory]::Exists($slugDir)) { $out.Add($slugDir) }
        }
    }
    return $out
}
