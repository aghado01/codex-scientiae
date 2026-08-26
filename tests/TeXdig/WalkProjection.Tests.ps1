BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:FixtureDir = Join-Path $script:RepositoryRoot "tests/fixtures/texdig/mini_article"

    . (Join-Path $script:RepositoryRoot "src/TeXdig/run-census.ps1")
    Set-StrictMode -Off

    $outRoot = if ($env:CODEX_TEST_ARTIFACT_ROOT) {
        $env:CODEX_TEST_ARTIFACT_ROOT
    } else {
        Join-Path $TestDrive "walk-runs"
    }

    $script:RunA = Invoke-TeXdigCensus -Article $script:FixtureDir -OutRoot $outRoot -Stamp "walk-a"
    $script:RunB = Invoke-TeXdigCensus -Article $script:FixtureDir -OutRoot $outRoot -Stamp "walk-b"
    $global:LASTEXITCODE = 0

    $script:OutDir = $script:RunA.RunDir
    $script:Walk = @(Get-Content -LiteralPath (Join-Path $script:OutDir 'walk.jsonl') |
        Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json })
    $script:Zones = @(Get-Content -LiteralPath (Join-Path $script:OutDir 'zones.jsonl') |
        Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json })
    $script:Summary = Get-Content -LiteralPath (Join-Path $script:OutDir 'summary.json') -Raw |
        ConvertFrom-Json

    $script:ZoneById = @{}
    foreach ($zone in $script:Zones) { $script:ZoneById[$zone.id] = $zone }

    # The reading test, rendered the way readWalkProse renders it: refs resolve
    # to their zone's source slice so the spine reads as prose.
    $parts = [System.Collections.Generic.List[string]]::new()
    foreach ($node in ($script:Walk | Sort-Object seq)) {
        if ($node.kind -eq 'section') {
            $title = -join (@($node.title) | ForEach-Object { if ($_.PSObject.Properties['text']) { $_.text } else { '' } })
            $parts.Add(('#' * ($node.level + 1)) + ' ' + $title)
        }
        elseif ($node.kind -eq 'paragraph') {
            $text = -join (@($node.content) | ForEach-Object {
                if ($_.PSObject.Properties['text']) { $_.text }
                else { $script:ZoneById[$_.ref].text }
            })
            $parts.Add($text)
        }
    }
    $script:Spine = $parts -join "`n`n"
}

Describe "TeXdig walk projection" -Tag "TeXdig", "Walk" {
    Context "The spine" {
        It "emits only section, paragraph, and anchor nodes in one strict seq order" {
            $script:Walk.Count | Should -BeGreaterThan 0
            foreach ($node in $script:Walk) {
                $node.kind | Should -BeIn @('section', 'paragraph', 'anchor')
                $node.id | Should -Match '^walk:[0-9a-f]{64}$'
            }
            $seqs = @($script:Walk | ForEach-Object { $_.seq })
            @($seqs | Sort-Object -Unique).Count | Should -Be $seqs.Count
        }

        It "reads as continuous prose" {
            # The acceptance test for the first artifact that is supposed to BE
            # the document: a human can adjudicate this in under a minute.
            $script:Spine | Should -Match 'This is the introduction section included from intro\.tex'
            $script:Spine | Should -Match 'inline math'
            $script:Spine | Should -Match '### Introduction'
        }

        It "recovers reading order across an include boundary" {
            $sources = @($script:Walk | Sort-Object seq | ForEach-Object { $_.span.sourceId })
            $sources | Should -Contain 'intro.tex'
            # intro.tex content is spliced at its include site, between main.tex nodes.
            $introIndex = [array]::IndexOf($sources, 'intro.tex')
            $introIndex | Should -BeGreaterThan 0
            $sources[$introIndex - 1] | Should -Be 'main.tex'
        }

        It "excludes the preamble: the manuscript starts at begin-document" {
            # \documentclass, \usepackage, \newcommand and \newtheorem arguments
            # are declarations, not prose, and must not reach the spine.
            $script:Spine | Should -Not -Match 'documentclass'
            $script:Spine | Should -Not -Match 'usepackage'
            $script:Spine | Should -Not -Match 'newtheorem'
        }
    }

    Context "Anchors and zones" {
        It "gives every anchor and every inline ref a resident zone" {
            # Referential EXISTENCE — not expressible in JSON Schema, so it is
            # asserted here rather than left to the validator.
            foreach ($node in $script:Walk) {
                if ($node.kind -eq 'anchor') {
                    $script:ZoneById.ContainsKey($node.zone) | Should -BeTrue -Because "anchor $($node.id) targets $($node.zone)"
                }
                elseif ($node.kind -eq 'paragraph') {
                    foreach ($part in @($node.content)) {
                        if ($part.PSObject.Properties['ref']) {
                            $script:ZoneById.ContainsKey($part.ref) | Should -BeTrue -Because "ref $($part.ref)"
                        }
                    }
                }
            }
        }

        It "carries the exact source slice on every zone" {
            foreach ($zone in $script:Zones) {
                $zone.id | Should -Match '^zone:[0-9a-f]{64}$'
                $zone.text.Length | Should -Be ($zone.span.endUtf16 - $zone.span.startUtf16)
            }
        }

        It "anchors display math as a block and keeps inline math inside the paragraph" {
            $anchoredKinds = @($script:Walk |
                Where-Object { $_.kind -eq 'anchor' } |
                ForEach-Object { $script:ZoneById[$_.zone].kind })
            $anchoredKinds | Should -Contain 'math-display'
            $anchoredKinds | Should -Not -Contain 'math-inline'

            $inlineRefKinds = @($script:Walk |
                Where-Object { $_.kind -eq 'paragraph' } |
                ForEach-Object { $_.content } |
                Where-Object { $_.PSObject.Properties['ref'] } |
                ForEach-Object { $script:ZoneById[$_.ref].kind })
            $inlineRefKinds | Should -Contain 'math-inline'
        }

        It "marks a hole only where the binding is not bound" {
            $holes = @($script:Zones | Where-Object { $null -ne $_.unresolved })
            foreach ($hole in $holes) {
                $hole.unresolved.reason |
                    Should -BeIn @('unbound', 'indeterminate', 'deferred', 'unentered-source')
            }
            # A bound macro site is NOT a hole: it is known, merely unexpanded.
            $boundSites = @($script:Zones |
                Where-Object { $_.kind -eq 'macro-site' -and $null -eq $_.unresolved })
            $boundSites.Count | Should -BeGreaterThan 0
            $script:Summary.walk.holeCount | Should -Be $holes.Count
        }
    }

    Context "The walk ledger" {
        It "tiles the entered body extent with prose, zones, and residue" {
            ($script:Summary.walk.proseUtf16 +
             $script:Summary.walk.zoneUtf16 +
             $script:Summary.walk.residueUtf16) |
                Should -Be $script:Summary.walk.enteredUtf16
        }

        It "counts holes inside the zone total, never beside it" {
            $script:Summary.walk.holeUtf16 |
                Should -BeLessOrEqual $script:Summary.walk.zoneUtf16
        }

        It "reports hole fraction as holeUtf16 over the entered extent" {
            $expected = if ($script:Summary.walk.enteredUtf16 -eq 0) { 0 } else {
                $script:Summary.walk.holeUtf16 / $script:Summary.walk.enteredUtf16
            }
            [Math]::Abs($script:Summary.walk.holeFraction - $expected) |
                Should -BeLessThan 1e-12
            $script:Summary.walk.holeFraction | Should -BeGreaterOrEqual 0
            $script:Summary.walk.holeFraction | Should -BeLessOrEqual 1
        }

        It "agrees with the emitted node and zone counts" {
            $script:Summary.walk.sectionCount |
                Should -Be @($script:Walk | Where-Object { $_.kind -eq 'section' }).Count
            $script:Summary.walk.paragraphCount |
                Should -Be @($script:Walk | Where-Object { $_.kind -eq 'paragraph' }).Count
            $script:Summary.walk.anchorCount |
                Should -Be @($script:Walk | Where-Object { $_.kind -eq 'anchor' }).Count
            $script:Summary.walk.zoneCount | Should -Be $script:Zones.Count
        }
    }

    Context "Determinism" {
        It "emits byte-identical walk and zone stores across two runs" {
            foreach ($store in @('walk.jsonl', 'zones.jsonl')) {
                $a = Get-FileHash -LiteralPath (Join-Path $script:RunA.RunDir $store) -Algorithm SHA256
                $b = Get-FileHash -LiteralPath (Join-Path $script:RunB.RunDir $store) -Algorithm SHA256
                $a.Hash | Should -BeExactly $b.Hash -Because "$store must be route-derived, not run-derived"
            }
        }
    }
}
