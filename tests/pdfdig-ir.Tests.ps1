#requires -Version 7.0
<#
  tests/pdfdig-ir.Tests.ps1 — pdfdig generic IR substrate (src/pdf-converter/pdfdig-ir.ps1).

  Three tiers:
    1. Store loaders — validation throws on malformed entries (bad data = failure, not silent skip).
    2. Pure classification helpers — subset stripping, family resolution, bold-by-name, origin ladder.
    3. End-to-end — one 2-page conversion of the golden specimen (2508.11646), asserting the lane
       contract: envelope shape, health metrics, back-refs, column bands. Skipped if the specimen
       PDF is absent (registry fixture, not vendored into the repo).
#>

BeforeAll {
    . "$PSScriptRoot/../src/pdf-converter/pdfdig-classify.ps1"   # dot-sources pdfdig-ir.ps1 itself
    $script:SpecimenPdf = "$PSScriptRoot/../ingestion/_inbox/2508.11646/2508.11646.pdf"
}

Describe 'store loaders' {
    It 'loads font-roles.jsonl and sorts longest-pattern-first' {
        $n = Import-FontRoles
        $n | Should -BeGreaterThan 50
        # most-specific-wins ordering: CMMIB must precede CMMI
        $pats = $script:FontRoles.pattern
        $pats.IndexOf('CMMIB') | Should -BeLessThan $pats.IndexOf('CMMI')
    }

    It 'loads producer-map.jsonl' {
        Import-ProducerMap | Should -BeGreaterThan 15
    }

    It 'loads classify-config.json and computes a config hash' {
        Import-ClassifyConfig | Should -Match '^[0-9a-f]{12}$'
        $script:ClassifyConfig.columns.narrow_width_frac | Should -BeGreaterThan 0
        $script:ClassifyConfig.rules.max_thickness_pt | Should -BeGreaterThan 0
    }

    It 'throws with line number on a missing required field' {
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "pdfdig-badstore-$([guid]::NewGuid()).jsonl"
        '{"pattern":"OK","role":"math","family":"cm"}', '{"pattern":"BAD","family":"cm"}' |
            Set-Content -LiteralPath $tmp -Encoding utf8
        try   { { Import-FontRoles -Path $tmp } | Should -Throw '*line 2*role*' }
        finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
    }

    It 'throws with line number on malformed JSON' {
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "pdfdig-badjson-$([guid]::NewGuid()).jsonl"
        '{"pattern": broken' | Set-Content -LiteralPath $tmp -Encoding utf8
        try   { { Import-FontRoles -Path $tmp } | Should -Throw '*line 1*' }
        finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
    }
}

Describe 'font-name helpers' {
    BeforeAll { Import-FontRoles | Out-Null }

    It 'strips the 6+1 subset tag' {
        Get-FontSubsetStripped 'ASYHPE+NimbusRomNo9L-Regu' | Should -Be 'NimbusRomNo9L-Regu'
        Get-FontSubsetStripped 'CMMI10' | Should -Be 'CMMI10'      # no tag → unchanged
        Get-FontSubsetStripped '' | Should -Be ''
    }

    It 'resolves TeX math families' {
        (Resolve-Family 'CMMI10').role  | Should -Be 'math'
        (Resolve-Family 'CMSY7').family | Should -Be 'cm'
        (Resolve-Family 'LMMathItalic12-Regular').role | Should -Be 'math'   # Latin Modern (specimen 2603.03375)
        (Resolve-Family 'NewTXMI').role | Should -Be 'math'                  # newtx (specimen 2401.13157)
    }

    It 'resolves prose/mono and applies most-specific-wins' {
        (Resolve-Family 'NimbusRomNo9L-Medi').role | Should -Be 'prose'
        (Resolve-Family 'LMRomanCaps10-Regular').family | Should -Be 'lm'    # LMRomanCaps, not LMRoman prefix clash
        (Resolve-Family 'NimbusMonL-Regu').role | Should -Be 'mono'
        (Resolve-Family 'CMTT10').role | Should -Be 'mono'                   # CMTT beats CMT* prose patterns
    }

    It 'degrades unknown fonts to unknown, never guesses' {
        (Resolve-Family 'TotallyMadeUpFont-2049').family | Should -Be 'unknown'
        (Resolve-Family 'TotallyMadeUpFont-2049').role   | Should -Be 'unknown'
    }

    It 'derives bold from the name, not the IsBold flag (capability map §1a)' {
        Test-BoldByName 'NimbusRomNo9L-Medi' | Should -BeTrue
        Test-BoldByName 'CMBX12'             | Should -BeTrue
        Test-BoldByName 'LMRoman12-Bold'     | Should -BeTrue
        Test-BoldByName 'NimbusRomNo9L-Regu' | Should -BeFalse
        Test-BoldByName 'CMMI10'             | Should -BeFalse
    }
}

Describe 'origin ladder (producer-map store)' {
    BeforeAll { Import-ProducerMap | Out-Null }

    It 'trusts a TeX producer directly' {
        $v = Get-OriginVerdict 'pdfTeX-1.40.21' '' @{}
        $v.tag | Should -Be 'tex'; $v.cue | Should -Be 'producer'
    }

    It 'falls through a rewriter to the creator cue (arXiv/pikepdf case)' {
        $v = Get-OriginVerdict 'pikepdf 8.15.1' 'arXiv GenPDF (tex2pdf:)' @{}
        $v.tag | Should -Be 'tex'; $v.cue | Should -Be 'creator'
        $v.rewriter | Should -Be 'pikepdf'
    }

    It 'falls back to font evidence when metadata is silent' {
        $v = Get-OriginVerdict 'pikepdf 8.15.1' 'something else' @{ cm = $true }
        $v.tag | Should -Be 'tex'; $v.cue | Should -Be 'fonts'
    }

    It 'tags non-TeX producers positively, not unknown' {
        $v = Get-OriginVerdict 'Adobe PDF Library 25.1.211' '' @{}
        $v.tag | Should -Be 'adobe'; $v.cue | Should -Be 'producer'
        $v.producer_verdict | Should -BeFalse
    }

    It 'returns unknown only when every cue is silent' {
        $v = Get-OriginVerdict 'Mystery Engine 1.0' '' @{ nimbus = $true }   # nimbus alone is not CM/AMS evidence
        $v.tag | Should -Be 'unknown'; $v.cue | Should -Be 'none'
    }
}

Describe 'column-band labeling' {
    BeforeAll { Import-ClassifyConfig | Out-Null }

    It 'labels a two-column page: bands 0/1 + span' {
        $mk = { param($l,$r) [pscustomobject]@{ bx = @($l, 0, $r, 10); column_band = $null } }
        $blocks = @(
            (& $mk 50 290), (& $mk 50 290),      # left column
            (& $mk 320 560), (& $mk 320 560),    # right column
            (& $mk 50 560)                        # full-width (title/figure)
        )
        Get-ColumnBands $blocks
        $blocks[0].column_band | Should -Be 0
        $blocks[2].column_band | Should -Be 1
        $blocks[4].column_band | Should -Be 'span'
    }

    It 'labels a single-column page as one confident band' {
        $blocks = @(1..4 | ForEach-Object { [pscustomobject]@{ bx = @(72, 0, 540, 10); column_band = $null } })
        Get-ColumnBands $blocks
        $blocks.column_band | Should -Not -Contain $null
        ($blocks.column_band | Sort-Object -Unique) | Should -Be @(0)
    }
}

Describe 'classifier helpers' {
    BeforeAll { Import-SymbolMap | Out-Null }

    It 'loads symbol-map.jsonl' {
        Import-SymbolMap | Should -BeGreaterThan 5
    }

    It 'maps CMSY k to the KaTeX norm delimiter in math scope only (the kuk class)' {
        Resolve-Symbol 'CMSY10' 'k' 'math'  | Should -Be '\|'   # \| renders as ‖ in KaTeX math mode
        Resolve-Symbol 'CMSY10' 'k' 'prose' | Should -BeNullOrEmpty     # scope-gated
        Resolve-Symbol 'NimbusRomNo9L-Regu' 'k' 'math' | Should -BeNullOrEmpty  # font-gated
    }

    It 'expands ligatures font-independently in prose scope' {
        Resolve-Symbol 'AnyFont' 'ﬁ' 'prose' | Should -Be 'fi'
        Resolve-Symbol 'CMR10' 'ﬄ' 'prose'  | Should -Be 'ffl'
    }

    It 'normalizes titles across numbering dialects' {
        $a = ConvertTo-NormalizedTitle 'II. FROM SPIKING DYNAMICS TO TOPOLOGY'
        $b = ConvertTo-NormalizedTitle 'From Spiking Dynamics to Topology'
        $a.Contains($b) | Should -BeTrue
    }
}

Describe 'end-to-end (golden specimen 2508.11646, pages 1-2)' {
    BeforeAll {
        $script:skip = -not (Test-Path $script:SpecimenPdf)
        if (-not $script:skip) {
            $script:outDir = Join-Path ([System.IO.Path]::GetTempPath()) "pdfdig-e2e-$([guid]::NewGuid())"
            $script:res = ConvertTo-PdfDigIr -PdfPath $script:SpecimenPdf -OutDir $script:outDir -Pages 1,2
            $script:env = Get-Content (Join-Path $script:outDir '2508.11646.pdfdig.json') -Raw | ConvertFrom-Json
        }
    }
    AfterAll {
        if (-not $script:skip -and (Test-Path $script:outDir)) { Remove-Item $script:outDir -Recurse -Force }
    }

    It 'emits all four lanes plus envelope with sidecars' -Skip:$script:skip {
        foreach ($lane in 'letters','words','blocks','paths') {
            Join-Path $script:outDir "2508.11646.$lane.jsonl" | Should -Exist
            Join-Path $script:outDir "2508.11646.$lane.jsonl.sig" | Should -Exist
        }
    }

    It 'resolves origin through the rewriter to tex/creator' -Skip:$script:skip {
        $script:env.document.origin.tag | Should -Be 'tex'
        $script:env.document.origin.cue | Should -Be 'creator'
        $script:env.document.origin.rewriter | Should -Be 'pikepdf'
    }

    It 'reports full font-role coverage and confident columns on the golden pages' -Skip:$script:skip {
        $script:env.health.known_font_role_frac | Should -Be 1.0
        $script:env.health.columns_confident_frac | Should -Be 1.0
        $script:env.engine.config_hash | Should -Match '^[0-9a-f]{12}$'
    }

    It 'letters carry filled back-refs after lane 3' -Skip:$script:skip {
        # ReadAllLines (eager) — a lazy ReadLines enumerator left un-drained holds the file handle
        # and breaks AfterAll cleanup (same trap as the store loader)
        $lines = [System.IO.File]::ReadAllLines((Join-Path $script:outDir '2508.11646.letters.jsonl'))
        $withBlock = 0
        foreach ($line in $lines) { if (($line | ConvertFrom-Json).block -ne $null) { $withBlock++ } }
        $lines.Count | Should -BeGreaterThan 9000      # p1+p2 ≈ 10.5k letters
        ($withBlock / $lines.Count) | Should -BeGreaterThan 0.95
    }

    It 'round-trips SMP/math codepoints through the letters lane' -Skip:$script:skip {
        # the specimen's abstract/p1 carries δ, γ, ∈ in CM fonts — they must survive byte-exact
        $lines = [System.IO.File]::ReadAllLines((Join-Path $script:outDir '2508.11646.letters.jsonl'))
        $found = $false
        foreach ($line in $lines) {
            $o = $line | ConvertFrom-Json
            if ($o.text -eq 'δ' -and $o.family -eq 'cm') { $found = $true; break }
        }
        $found | Should -BeTrue
    }

    It 'classifier emits typed nodes with membrane-canonical fields' -Skip:$script:skip {
        $script:cls = ConvertTo-PdfDigNodes -IrDir $script:outDir -Slug '2508.11646'
        $script:cls.Nodes | Should -BeGreaterThan 300
        $script:cls.Calibration.body_size | Should -Be 10.0
        $n = ([System.IO.File]::ReadAllLines((Join-Path $script:outDir '2508.11646.nodes.jsonl'))[0]) | ConvertFrom-Json
        foreach ($k in 'type','page','content','font','font size','bounding box','role','script','flags') {
            $n.PSObject.Properties[$k] | Should -Not -BeNullOrEmpty -Because "node must carry '$k'"
        }
    }

    It 'classifier finds headings via both witnesses and calls scripts' -Skip:$script:skip {
        $script:cls.Health.heading_candidates | Should -BeGreaterThan 0
        $script:cls.Health.bookmarks_matched | Should -BeGreaterThan 1     # Introduction + p2 sections in range
        $sawScript = $false; $sawMathRole = $false
        foreach ($line in [System.IO.File]::ReadAllLines((Join-Path $script:outDir '2508.11646.nodes.jsonl'))) {
            $o = $line | ConvertFrom-Json
            if ($o.script -in 'sub','super') { $sawScript = $true }
            if ($o.role -eq 'math') { $sawMathRole = $true }
            if ($sawScript -and $sawMathRole) { break }
        }
        $sawScript | Should -BeTrue
        $sawMathRole | Should -BeTrue
    }
}
