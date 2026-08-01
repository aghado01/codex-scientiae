#requires -Version 7.0
<#
  tests/fixtures/regenerate-chunks.ps1 — provenance record + regenerator for the committed corpus-anchor
  fixtures (legacy.chunks.jsonl / current.chunks.jsonl) that spine/corpus/agreement.Tests.ps1 read.

  WHY THESE ARE COMMITTED. The corpus-anchored Its used to point at the pre-runs per-paper working
  dirs, retired 2026-07-01 for runstamped {paper}/.runs/{stamp}/ — which is git-ignored
  and regenerable, so pointing tests at it is flaky (the Test-Path guards just silently skipped the whole
  corpus differential). These two small committed streams are the durable on-disk anchor instead.

  THE TWO POOLS (corpus.Tests.ps1 needs both provenances; the other two suites are provenance-agnostic):
    legacy.chunks.jsonl  — the LEGACY pool. Curated real chunks from voroninski/2008.10579v1 (the stream
                           that still carries genuine MathLatexRx residue AND clean/gibberish/unbalanced
                           gate kinds), each STAMPED with math_dirt = Legacy-MathDirt(content) — the
                           pre-refinement residual — so the "stored math_dirt == legacy residual" pin and
                           the old-vs-new detector differential are LIVE, not vacuous.
    current.chunks.jsonl — the CURRENT pool. Curated real chunks from voroninski/1109.4499v1 (PhaseLift),
                           left exactly as the current engine emits them (refined; no stored math_dirt).

  EVERY chunk in both files is machine-verified to satisfy the corpus invariants BEFORE it is written:
    * old-vs-new differential within the sanctioned band (typeChange / rejectToAccept / nonGibberishFlip
      all 0; the only permitted flip is the gibberish-recall accept->reject);
    * refined math_dirt <= legacy residual (refinedExceeds 0);
    * clean formula chunks survive normalize (the detector-∘-normalize fixed point; cleanBroke 0);
    * gate == first inventory corruption-signature, and never throws (the spine share-table);
    * agreement total / in [0,1] / deterministic / non-gating.

  This script re-mints both files from whatever the NEWEST preprocessed run of each source paper is. It is
  a maintenance tool, NOT a test (Pester discovers only *.Tests.ps1, so run.ps1 never picks it up). Run it
  only when you deliberately want to refresh the anchors; the committed .jsonl is the source of truth.

    pwsh -File tests/fixtures/regenerate-chunks.ps1
#>
[CmdletBinding()] param(
    [string]$LegacyPaper  = 'ingestion/gauntlet/voroninski/2008.10579v1',
    [string]$CurrentPaper = 'ingestion/gauntlet/voroninski/1109.4499v1',
    [int]$LegacyCap  = 44,
    [int]$CurrentCap = 30
)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path "$PSScriptRoot/../..").Path
. "$repo/src/codex-membrane/serving.ps1"

# ── legacy detectors, copied VERBATIM from tests/codex-membrane/corpus.Tests.ps1 (keep in lockstep with that file) ──
function Old-IsMath([string]$s) { $t = $s -replace '\\(?:text|operatorname|mathrm|mbox|textrm|textbf|textit)\s*\{[^{}]*\}', ' '; $t = $t -replace '\\[A-Za-z]+', ' '; return (([regex]::Matches($t, '[A-Za-z]{4,}')).Count -le 2) }
function Old-AlignOutside([string]$m) { return ($m -match '(?<!\\)&' -and $m -notmatch '\\begin\s*\{') }
function Old-Gibberish([string]$c) { return ($c -match '(?:\b\w\s+){6,}\b\w\b') }
function Old-CorruptionType($Chunk) {
    $content = [string]$Chunk.content
    if (-not $content) { return $null }
    if ($content.Contains('\intertext')) { return 'intertext' }
    if ($content.Contains([char]0xFFFD)) { return 'replacement_char' }
    if (Old-Gibberish $content) { return 'gibberish' }
    if ($content -match '[ﬀ-ﬄ]') { return 'ligature_residue' }
    if ($Chunk.type -eq 'formula' -and (Old-AlignOutside $content)) { return 'alignment_outside_env' }
    if ($Chunk.type -eq 'formula' -and -not (Old-IsMath $content)) { return 'prose_in_formula' }
    if ($Chunk.type -eq 'formula') { if (-not (Get-LatexBalance $content).full) { return 'unbalanced_delimiters' } }
    elseif ($content.Contains('$')) { if (-not (Get-LatexBalance $content).braceBalanced) { return 'unbalanced_delimiters' } }
    return $null
}
function Legacy-MathDirt([string]$w) { return ($script:MathLatexRx.Matches([regex]::Replace($w, '\$[^$\n]+\$', ' ')).Count) }

function Resolve-NewestChunks([string]$paperRel) {
    $slug = Split-Path $paperRel -Leaf
    $runs = Join-Path $repo "$paperRel/.runs"
    if (-not (Test-Path -LiteralPath $runs)) { throw "no .runs under $paperRel — preprocess the paper first" }
    $hit = Get-ChildItem -LiteralPath $runs -Directory | Sort-Object Name -Descending |
        ForEach-Object { Join-Path $_.FullName "$slug.chunks.jsonl" } | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
    if (-not $hit) { throw "no {slug}.chunks.jsonl in any run under $paperRel" }
    return $hit
}
function Read-Stream([string]$path) {
    $list = [System.Collections.Generic.List[object]]::new()
    foreach ($ln in [System.IO.File]::ReadLines($path)) { if ($ln.Trim()) { $list.Add(($ln | ConvertFrom-Json)) } }
    return $list
}

function Test-FixedPoint($c) {
    if ([string]$c.type -ne 'formula') { return $true }
    $x = [string]$c.content; if (-not $x) { return $true }
    if ($null -ne (Get-CorruptionType $c)) { return $true }
    $norm = Repair-MathAlignment (Convert-MathToLatex (Optimize-MathContent $x @('mathbb')))
    return ($null -eq (Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = $norm })))
}
function Test-RefineOk($c) { $x = [string]$c.content; if (-not $x) { return $true }; return ((Get-MathDirt $x) -le (Legacy-MathDirt $x)) }
function Test-LegacyDiffOk($c) {
    $o = Old-CorruptionType $c; $n = Get-CorruptionType $c
    if ($o -eq $n) { return $true }
    if ($null -eq $o -and $n -eq 'gibberish') { return $true }   # the sole sanctioned flip (recall fix)
    return $false
}
function Test-ShareTable($c) {
    try {
        $kinds = @('intertext','replacement_char','gibberish','ligature_residue','alignment_outside_env','prose_in_formula','unbalanced_delimiters')
        $gate  = Get-CorruptionType $c
        $sig   = @(Get-ChunkIssues $c | Where-Object { $_.type -in $kinds })
        $first = if ($sig.Count) { $sig[0].type } else { $null }
        return ($gate -eq $first)
    } catch { return $false }
}
function Get-ResidualTier($c) {
    $d = [int](Legacy-MathDirt ([string]$c.content))
    if ($d -ge 3) { return 'r3+' } elseif ($d -eq 2) { return 'r2' } elseif ($d -eq 1) { return 'r1' } else { return 'r0' }
}
function Select-Diverse($chunks, [int]$cap, [scriptblock]$extraFilter, [bool]$ByResidual) {
    $buckets = [ordered]@{}
    foreach ($c in $chunks) {
        if ([string]$c.content -eq '') { continue }
        if (-not (Test-FixedPoint $c)) { continue }
        if (-not (Test-RefineOk $c))   { continue }
        if (-not (Test-ShareTable $c)) { continue }
        if ($extraFilter -and -not (& $extraFilter $c)) { continue }
        $gate = Get-CorruptionType $c; if (-not $gate) { $gate = 'clean' }
        $key  = "$([string]$c.type)|$gate"
        if ($ByResidual) { $key += "|$(Get-ResidualTier $c)" }
        if (-not $buckets.Contains($key)) { $buckets[$key] = [System.Collections.Generic.List[object]]::new() }
        $buckets[$key].Add($c)
    }
    $picked = [System.Collections.Generic.List[object]]::new(); $round = 0
    while ($picked.Count -lt $cap) {
        $added = $false
        foreach ($k in @($buckets.Keys)) {
            if ($round -lt $buckets[$k].Count) { $picked.Add($buckets[$k][$round]); $added = $true; if ($picked.Count -ge $cap) { break } }
        }
        if (-not $added) { break }
        $round++
    }
    return ,$picked
}
function Write-Fixture($chunks, [string]$outPath) {
    $dir = Split-Path -Parent $outPath
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $sb = [System.Text.StringBuilder]::new()
    foreach ($c in $chunks) { [void]$sb.AppendLine(($c | ConvertTo-Json -Compress -Depth 20)) }
    [System.IO.File]::WriteAllText($outPath, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))   # UTF-8, no BOM
}

$legacyPath  = Resolve-NewestChunks $LegacyPaper
$currentPath = Resolve-NewestChunks $CurrentPaper
"legacy  source: $legacyPath"
"current source: $currentPath"

$legacyPick = Select-Diverse (Read-Stream $legacyPath) $LegacyCap { param($c) Test-LegacyDiffOk $c } $true
foreach ($c in $legacyPick) { $c | Add-Member -NotePropertyName math_dirt -NotePropertyValue ([int](Legacy-MathDirt ([string]$c.content))) -Force }
$currentPick = Select-Diverse (Read-Stream $currentPath) $CurrentCap $null $false

$legacyOutPath  = "$PSScriptRoot/chunks/legacy.chunks.jsonl"
$currentOutPath = "$PSScriptRoot/chunks/current.chunks.jsonl"
Write-Fixture $legacyPick  $legacyOutPath
Write-Fixture $currentPick $currentOutPath

# ── re-verify every corpus-suite aggregate over the WRITTEN files (fail loud if anything is off) ─────
$legacy = Read-Stream $legacyOutPath; $current = Read-Stream $currentOutPath; $all = @($legacy + $current)
$rejectToAccept=0;$typeChange=0;$nonGibberishFlip=0
foreach ($c in $legacy) { $o=Old-CorruptionType $c;$n=Get-CorruptionType $c; if($o -eq $n){continue}; if($null -eq $o){if($n -ne 'gibberish'){$nonGibberishFlip++}}elseif($null -eq $n){$rejectToAccept++}else{$typeChange++} }
$storedLegacyMismatch=0
foreach ($c in $legacy) { $x=[string]$c.content; if(-not $x){continue}; if($null -ne $c.math_dirt -and [int]$c.math_dirt -ne (Legacy-MathDirt $x)){$storedLegacyMismatch++} }
$refinedExceeds=0;$cleanBroke=0
foreach ($c in $all) { $x=[string]$c.content; if(-not $x){continue}; if((Get-MathDirt $x) -gt (Legacy-MathDirt $x)){$refinedExceeds++} }
foreach ($c in $all) { if([string]$c.type -ne 'formula'){continue}; $x=[string]$c.content; if(-not $x){continue}; if($null -ne (Get-CorruptionType $c)){continue}; $norm=Repair-MathAlignment (Convert-MathToLatex (Optimize-MathContent $x @('mathbb'))); if($null -ne (Get-CorruptionType ([pscustomobject]@{type='formula';content=$norm}))){$cleanBroke++} }
$drift=0;$threw=0
foreach ($c in $all) { try { if(-not (Test-ShareTable $c)){$drift++} } catch { $threw++ } }
$outOfRange=0;$nonDet=0;$gateMoved=0
foreach ($c in $all) { $s=Get-AgreementScore $c; if($s -lt 0 -or $s -gt 1){$outOfRange++}; if($s -ne (Get-AgreementScore $c)){$nonDet++}; $b=Get-CorruptionType $c; Set-ChunkAgreement $c | Out-Null; if((Get-CorruptionType $c) -ne $b){$gateMoved++} }
$fail = $rejectToAccept+$typeChange+$nonGibberishFlip+$storedLegacyMismatch+$refinedExceeds+$cleanBroke+$drift+$threw+$outOfRange+$nonDet+$gateMoved
"wrote legacy=$($legacy.Count) current=$($current.Count); invariant failures=$fail"
if ($fail -ne 0) { throw "regenerate-chunks: fixtures violate a corpus invariant (failures=$fail) — NOT durable" }
"OK — all corpus invariants green"
