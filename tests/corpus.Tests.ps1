#requires -Version 7.0
# Integration / regression: the serving layer + a differential A/B of the rebuilt detectors against the
# pre-port versions over the preprocessed corpus. Corpus-dependent assertions skip cleanly when no
# document is preprocessed to the chunk stage; the synthetic hotspot test always runs.
#
# Two pools, because they answer different questions:
#   LEGACY  — tests/fixtures/chunks/legacy.chunks.jsonl: curated real chunks STAMPED with the
#             pre-refinement residual (math_dirt == Legacy-MathDirt by construction). The old-vs-new
#             detector differential and the "stored math_dirt == legacy residual" pin are defined
#             against this baseline; a divergence here would be a real port regression.
#   CURRENT — tests/fixtures/chunks/current.chunks.jsonl: curated real chunks as the CURRENT engine
#             emits them. Old-vs-new divergence here is the new pipeline being *better* (the old detector
#             false-positives on content the new one cleaned), and math_dirt is the REFINED value (in
#             fact unstored) by construction — so the legacy-baseline pins do NOT apply. Only the
#             engine-internal invariants (refined<=legacy, determinism, normalize fixed point) run over
#             the whole corpus, where the current-engine stream strengthens them.

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
    function Legacy-MathDirt([string]$w) { return ($script:MathLatexRx.Matches([regex]::Replace($w, '\$[^$\n]+\$', ' ')).Count) }

    function Read-Stream($Paths) {
        $list = [System.Collections.Generic.List[object]]::new()
        foreach ($f in $Paths) { foreach ($ln in [System.IO.File]::ReadLines($f)) { if ($ln.Trim()) { $list.Add(($ln | ConvertFrom-Json)) } } }
        return $list
    }

    # Committed fixture anchors (see tests/fixtures/README.md). The .scratch streams these replaced were
    # retired 2026-07-01 for git-ignored, regenerable .runs/ — so the old anchors went dead and this whole
    # differential silently skipped. legacy.chunks.jsonl carries the pre-refinement residual stamped onto
    # real chunks (math_dirt == Legacy-MathDirt); current.chunks.jsonl is current-engine output as-is.
    $legacyFiles = @(
        @( "$PSScriptRoot/fixtures/chunks/legacy.chunks.jsonl" ) | Where-Object { Test-Path -LiteralPath $_ }
    )
    $currentFiles = @(
        @( "$PSScriptRoot/fixtures/chunks/current.chunks.jsonl" ) | Where-Object { Test-Path -LiteralPath $_ }
    )

    $hasLegacy = $legacyFiles.Count -gt 0
    $hasCorpus = ($legacyFiles.Count + $currentFiles.Count) -gt 0

    # LEGACY-pool baseline: the old-vs-new differential + stored math_dirt matches legacy residual.
    if ($hasLegacy) {
        $legacy = Read-Stream $legacyFiles
        $acceptToReject = 0; $rejectToAccept = 0; $typeChange = 0; $nonGibberishFlip = 0
        foreach ($c in $legacy) {
            $o = Old-CorruptionType $c; $n = Get-CorruptionType $c
            if ($o -eq $n) { continue }
            if ($null -eq $o) { $acceptToReject++; if ($n -ne 'gibberish') { $nonGibberishFlip++ } }
            elseif ($null -eq $n) { $rejectToAccept++ }
            else { $typeChange++ }
        }
        $storedLegacyMismatch = 0
        foreach ($c in $legacy) {
            $x = [string]$c.content; if (-not $x) { continue }
            if ($null -ne $c.math_dirt -and [int]$c.math_dirt -ne (Legacy-MathDirt $x)) { $storedLegacyMismatch++ }
        }
    }

    # WHOLE-corpus engine-internal invariants (hold on any stream; current-engine streams strengthen them).
    if ($hasCorpus) {
        $all = Read-Stream ($legacyFiles + $currentFiles)
        $refinedExceeds = 0
        foreach ($c in $all) {
            $x = [string]$c.content; if (-not $x) { continue }
            if ((Get-MathDirt $x) -gt (Legacy-MathDirt $x)) { $refinedExceeds++ }
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

Describe 'corpus A/B — compatibility with the pre-port detectors (legacy pool)' {
    It 'merge-gate never increases misses (0 reject->accept)' {
        if (-not $hasLegacy) { Set-ItResult -Skipped -Because 'no legacy document preprocessed to the chunk stage'; return }
        $rejectToAccept | Should -Be 0
    }
    It 'merge-gate makes no corruption_type changes' {
        if (-not $hasLegacy) { Set-ItResult -Skipped; return }
        $typeChange | Should -Be 0
    }
    It 'every new accept->reject flip is a gibberish recall fix' {
        if (-not $hasLegacy) { Set-ItResult -Skipped; return }
        $nonGibberishFlip | Should -Be 0
    }
    It 'math_dirt stored on corpus chunks matches legacy residual (re-normalize to pick up refinement)' {
        if (-not $hasLegacy) { Set-ItResult -Skipped; return }
        $storedLegacyMismatch | Should -Be 0
    }
}

Describe 'corpus invariants — engine-internal, whole corpus (incl. current-engine streams)' {
    It 'refined math_dirt never exceeds legacy residual' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $refinedExceeds | Should -Be 0
    }
    It 'Get-MathDirt is deterministic on corpus prose' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $bad = 0
        foreach ($c in $all) {
            if ([string]$c.type -ne 'prose') { continue }
            $x = [string]$c.content; if (-not $x) { continue }
            if ((Get-MathDirt $x) -ne (Get-MathDirt $x)) { $bad++ }
        }
        $bad | Should -Be 0
    }
    It 'detector∘normalize fixed point: clean formula chunks stay clean (no oscillation, compat a)' {
        if (-not $hasCorpus) { Set-ItResult -Skipped; return }
        $cleanBroke | Should -Be 0
    }
}
