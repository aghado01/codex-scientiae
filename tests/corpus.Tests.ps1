#requires -Version 7.0
# Integration / regression: the serving layer + a differential A/B of the rebuilt detectors against the
# pre-port versions over the preprocessed corpus. Corpus-dependent assertions skip cleanly when no
# document is preprocessed to the chunk stage; the synthetic hotspot test always runs.

BeforeAll {
    . "$PSScriptRoot/../src/serving.ps1"   # fidelity (new) + normalize + latex + masks + crawl

    # OLD detectors, inlined verbatim from the pre-port latex.ps1 / fidelity.ps1
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
    function Old-MathDirt([string]$w) { return ($script:MathLatexRx.Matches([regex]::Replace($w, '\$[^$\n]+\$', ' ')).Count) }
    function New-MathDirt([string]$w) { return (Get-MaskDensity -Text $w -Within (Complement-Mask (New-Mask $w '\$[^$\n]+\$')) -Register $script:MathLatexRx) }

    $files = @(
        "$PSScriptRoot/../ingestion/compendia/ph/WRD2025/.scratch/WRD2025.chunks.jsonl"
        "$PSScriptRoot/../ingestion/compendia/ph/DBK2023/.scratch/DBK2023.chunks.jsonl"
        "$PSScriptRoot/../ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.chunks.jsonl"
    ) | Where-Object { Test-Path -LiteralPath $_ }
    $hasCorpus = $files.Count -gt 0

    if ($hasCorpus) {
        $all = [System.Collections.Generic.List[object]]::new()
        foreach ($f in $files) { foreach ($ln in [System.IO.File]::ReadLines($f)) { if ($ln.Trim()) { $all.Add(($ln | ConvertFrom-Json)) } } }

        $acceptToReject = 0; $rejectToAccept = 0; $typeChange = 0; $nonGibberishFlip = 0
        foreach ($c in $all) {
            $o = Old-CorruptionType $c; $n = Get-CorruptionType $c
            if ($o -eq $n) { continue }
            if ($null -eq $o) { $acceptToReject++; if ($n -ne 'gibberish') { $nonGibberishFlip++ } }
            elseif ($null -eq $n) { $rejectToAccept++ }
            else { $typeChange++ }
        }
        $dirtMismatch = 0; $storedMismatch = 0
        foreach ($c in $all) {
            $x = [string]$c.content; if (-not $x) { continue }
            if ((Old-MathDirt $x) -ne (New-MathDirt $x)) { $dirtMismatch++ }
            if ($null -ne $c.math_dirt -and [int]$c.math_dirt -ne (New-MathDirt $x)) { $storedMismatch++ }
        }
        $cleanBroke = 0
        foreach ($c in $all) {
            if ([string]$c.type -ne 'formula') { continue }
            $x = [string]$c.content; if (-not $x) { continue }
            if ($null -ne (Get-CorruptionType $c)) { continue }
            $norm = Repair-MathAlignment (Convert-MathToLatex (Optimize-MathContent $x @('mathbb')))
            if ($null -ne (Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = $norm }))) { $cleanBroke++ }
        }
    }
}

Describe 'Group-MathHotspots (synthetic)' {
    It 'merges fragments that balance only when concatenated into one span' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'x =' }
            [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = '\left( \frac{1}{2}' }
            [pscustomobject]@{ id = 3; type = 'formula'; page = 1; content = '+ y \right)' }
        )
        $spans = @(Group-MathHotspots $chunks)
        $spans.Count | Should -Be 1
        ($spans[0].ids -join ',') | Should -Be '1,2,3'
    }
    It 'does not group well-formed standalone formulas' {
        $chunks = @(
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'a = b' }
            [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = 'c = d' }
        )
        @(Group-MathHotspots $chunks).Count | Should -Be 0
    }
}

Describe 'corpus A/B — compatibility with the pre-port detectors' {
    It 'merge-gate never increases misses (0 reject->accept)' {
        if (-not $hasCorpus) { Set-ItResult -Skipped -Because 'no document preprocessed to the chunk stage'; return }
        $rejectToAccept | Should -Be 0
    }
    It 'merge-gate makes no corruption_type changes' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $typeChange | Should -Be 0
    }
    It 'every new accept->reject flip is a gibberish recall fix' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $nonGibberishFlip | Should -Be 0
    }
    It 'math_dirt is value-identical over the corpus (frozen contract c)' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $dirtMismatch | Should -Be 0
        $storedMismatch | Should -Be 0
    }
    It 'detector∘normalize fixed point: clean formula chunks stay clean (no oscillation, compat a)' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $cleanBroke | Should -Be 0
    }
}
