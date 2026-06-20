#requires -Version 7.0
<#
  scratch/enrichment-surfacer-probe.ps1 — MEASUREMENT probe, not production.

  Scans finalized deliverables for unwrapped ASCII-math candidates and buckets each as
  safe-wrap vs lossy, to get the ratio that decides whether the enrichment tier is a clean
  win or really a re-extraction problem. Reuses the live tokenizer (Test-MathGlyphToken,
  $script:MathFunc) and mask algebra so what it measures reflects the real engine.

  surfacer  — a maximal run of math-glyph tokens (the SAME predicate ConvertTo-InlineMath
              builds runs from), outside existing $…$, that carries a structural cue
              (paren / operator / function / digit) and at least one value-atom.
  bucket    — LOSSY if the run has a bare value-atom <-> value-atom adjacency (e.g. `n s`,
              `s 2`): a glyph (/, _, ^, ·) was plausibly destroyed and wrapping would launder
              the ambiguity. Otherwise SAFE-WRAP (single conventional reading, nothing lost).
#>

. "$PSScriptRoot/../src/normalize.ps1"   # -> latex.ps1 + masks.ps1: Test-MathGlyphToken, $script:MathFunc, New-Mask, Get-MaskedText

$deliverables = @(
    "$PSScriptRoot/../ingestion/compendia/ph/WRD2025/.scratch/WRD2025.md"
    "$PSScriptRoot/../ingestion/compendia/ph/DBK2023/.scratch/DBK2023.md"
    "$PSScriptRoot/../ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.md"
    "$PSScriptRoot/../ingestion/corpora/voroninski/2008.10579v1/.scratch/2008.10579v1.md"
) | Where-Object { Test-Path -LiteralPath $_ }

$rxMath = [regex]'\$\$[\s\S]*?\$\$|\$[^$\n]+\$'   # already-wrapped math — mask it out, never re-surface
$rxMd   = [regex]'!?\[[^\]]*\]\([^)]*\)|`[^`]*`'  # markdown links / images / inline code — formatting, not math
$break  = '.;:'                                    # sentence punctuation: ends a run even though length-1

function Test-Structural([string]$t) {
    if ($t.Length -eq 1 -and '()[]{}+-*/=<>^_|'.Contains($t)) { return $true }
    if ($t -match '^\d+$') { return $true }
    if ($script:MathFunc -contains $t) { return $true }
    return $false
}
function Test-ValueAtom([string]$t) { return ($t -match '^[A-Za-z]$' -or $t -match '^\d+$') }
# A "math-core" token: a single-letter variable, a math function, or an arithmetic/relational operator.
# Citations (years, commas, parens) and markdown link debris carry none of these — this is what separates
# real ASCII math from formatting that merely tokenizes like math.
function Test-MathCore([string]$t) {
    if ($t -match '^[A-Za-z]$') { return $true }
    if ($script:MathFunc -contains $t) { return $true }
    if ($t.Length -eq 1 -and '=<>^_/*+'.Contains($t)) { return $true }
    return $false
}

function Get-Candidates([string]$Text) {
    $out  = [System.Collections.Generic.List[object]]::new()
    $p1    = Get-MaskedText -Text $Text -Mask (New-Mask $Text $rxMath)   # blank existing math
    $prose = Get-MaskedText -Text $p1   -Mask (New-Mask $p1   $rxMd)     # blank markdown links/images/code
    foreach ($line in ($prose -split "`n")) {
        $toks = [regex]::Matches($line, '[A-Za-z]+|\d+|\S') | ForEach-Object { $_.Value }
        $run = [System.Collections.Generic.List[string]]::new()
        $flush = {
            if ($run.Count -ge 2) {
                $hasOp = $false; $hasFuncApp = $false; $lossy = $false
                for ($i = 0; $i -lt $run.Count; $i++) {
                    if (($script:MathFunc -contains $run[$i]) -or ($run[$i].Length -eq 1 -and '=<>^_/*+'.Contains($run[$i]))) { $hasOp = $true }
                    if ($i -gt 0 -and ($run[$i] -eq '(') -and ($run[$i - 1] -match '^[A-Za-z]$')) { $hasFuncApp = $true }
                    if ($i -gt 0 -and (Test-ValueAtom $run[$i]) -and (Test-ValueAtom $run[$i - 1])) { $lossy = $true }
                }
                if ($hasOp -or $hasFuncApp) {
                    $out.Add([pscustomobject]@{ text = ($run -join ' '); bucket = $(if ($lossy) { 'lossy' } else { 'safe-wrap' }) })
                }
            }
            $run.Clear()
        }
        foreach ($t in $toks) {
            if ((Test-MathGlyphToken $t) -and -not $break.Contains($t)) { $run.Add($t) }
            else { & $flush }
        }
        & $flush
    }
    return $out
}

$grand = @{ 'safe-wrap' = 0; 'lossy' = 0 }
$sampSafe = [System.Collections.Generic.List[string]]::new()
$sampLossy = [System.Collections.Generic.List[string]]::new()

foreach ($d in $deliverables) {
    $cands = Get-Candidates ([System.IO.File]::ReadAllText($d, [System.Text.UTF8Encoding]::new($false)))
    $safe = @($cands | Where-Object { $_.bucket -eq 'safe-wrap' })
    $loss = @($cands | Where-Object { $_.bucket -eq 'lossy' })
    $grand['safe-wrap'] += $safe.Count
    $grand['lossy']     += $loss.Count
    foreach ($s in ($safe.text | Select-Object -Unique -First 4)) { if ($sampSafe.Count -lt 12) { $sampSafe.Add($s) } }
    foreach ($s in ($loss.text | Select-Object -Unique -First 4)) { if ($sampLossy.Count -lt 12) { $sampLossy.Add($s) } }
    "{0,-16} safe-wrap={1,-5} lossy={2,-5} ({3} candidates)" -f ([System.IO.Path]::GetFileNameWithoutExtension($d)), $safe.Count, $loss.Count, $cands.Count
}

$tot = $grand['safe-wrap'] + $grand['lossy']
""
"TOTAL  safe-wrap=$($grand['safe-wrap'])  lossy=$($grand['lossy'])  (n=$tot)"
if ($tot -gt 0) { "ratio  safe-wrap={0:P0}  lossy={1:P0}" -f ($grand['safe-wrap'] / $tot), ($grand['lossy'] / $tot) }
""
"--- sample SAFE-WRAP ---"; $sampSafe | Select-Object -Unique | ForEach-Object { "  $_" }
"--- sample LOSSY ---";     $sampLossy | Select-Object -Unique | ForEach-Object { "  $_" }
