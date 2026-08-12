BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:FixtureDir = Join-Path $script:RepositoryRoot "tests/fixtures/texdig/mini_article"

    # The runner IS the worker contract: validate-json gate + stamped
    # container + census invocation + typed run record. Dot-sourcing brings
    # its strict mode into this session; the tests' Where-Object probes over
    # heterogeneous entity rows are deliberately lax, so restore.
    . (Join-Path $script:RepositoryRoot "src/TeXdig/run-census.ps1")
    Set-StrictMode -Off

    $outRoot = if ($env:CODEX_TEST_ARTIFACT_ROOT) {
        $env:CODEX_TEST_ARTIFACT_ROOT
    } else {
        Join-Path $TestDrive "texdig-runs"
    }

    $script:Run = Invoke-TeXdigCensus -Article $script:FixtureDir -OutRoot $outRoot -Stamp "pester"
    $script:OutDir = $script:Run.RunDir
    $global:LASTEXITCODE = 0
}

Describe "TeXdig Stage 1 Census Engine" -Tag "TeXdig", "Census", "Cut1" {
    Context "Runner & Worker Contract" {
        It "returns a typed run record with full fixture agreement" {
            $script:Run.PSObject.TypeNames | Should -Contain "TeXdig.CensusRun"
            $script:Run.Slug | Should -Be "mini_article"
            $script:Run.Agreed | Should -Be $script:Run.Entities
            $script:Run.Defects | Should -Be 0
        }

        It "claims the fixture completely" {
            $script:Run.ResidueUtf16 | Should -Be 0
            $script:Run.ClaimedUtf16 | Should -Be $script:Run.TotalUtf16
        }

        It "emits all 6 evidence and audit tier stores" {
            Test-Path (Join-Path $script:OutDir "sources.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "entities.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "claims.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "coverage.json") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "diagnostics.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "summary.json") | Should -BeTrue
        }
    }

    Context "Source Graph & Role Classification" {
        BeforeAll {
            $sourcesRaw = Get-Content -Raw (Join-Path $script:OutDir "sources.jsonl")
            $script:Sources = @($sourcesRaw.Trim().Split("`n") | Where-Object { $_ } | ForEach-Object { ConvertFrom-Json $_ })
        }

        It "classifies entrypoint, included, bbl, bib, and unreachable-tex" {
            $entry = $script:Sources | Where-Object { $_.id -eq "main.tex" }
            $entry.role | Should -Be "entrypoint"
            $entry.parsed | Should -BeTrue

            $included = $script:Sources | Where-Object { $_.id -eq "intro.tex" }
            $included.role | Should -Be "included"
            $included.parsed | Should -BeTrue

            $bbl = $script:Sources | Where-Object { $_.id -eq "main.bbl" }
            $bbl.role | Should -Be "bbl-sidecar"
            $bbl.parsed | Should -BeTrue

            $bib = $script:Sources | Where-Object { $_.id -eq "refs.bib" }
            $bib.role | Should -Be "bibliography-resource"
            $bib.parsed | Should -BeTrue

            $unreach = $script:Sources | Where-Object { $_.id -eq "unreachable.tex" }
            $unreach.role | Should -Be "unreachable-tex"
            $unreach.parsed | Should -BeFalse
        }

        It "inventories the unreferenced bib without parsing (symmetric reachability)" {
            $extra = $script:Sources | Where-Object { $_.id -eq "extra.bib" }
            $extra.role | Should -Be "bibliography-resource"
            $extra.parsed | Should -BeFalse
            $extra.sha256 | Should -Not -BeNullOrEmpty
        }
    }

    Context "Stratification & Casing Diagnostics" {
        BeforeAll {
            $diagRaw = Get-Content -Raw (Join-Path $script:OutDir "diagnostics.jsonl")
            $script:Diagnostics = @($diagRaw.Trim().Split("`n") | Where-Object { $_ } | ForEach-Object { ConvertFrom-Json $_ })
        }

        It "records exactly ONE case mismatch diagnostic for Intro -> intro.tex" {
            $caseMismatch = @($script:Diagnostics | Where-Object { $_.code -eq "census/include-case-mismatch" })
            $caseMismatch.Count | Should -Be 1
            $caseMismatch[0].message | Should -Match "intro.tex"
        }

        It "records unreachable-source diagnostics for unreachable.tex and extra.bib" {
            $unreach = @($script:Diagnostics | Where-Object { $_.code -eq "census/unreachable-source" })
            ($unreach.message -match "unreachable.tex") | Should -Not -BeNullOrEmpty
            ($unreach.message -match "extra.bib") | Should -Not -BeNullOrEmpty
        }

        It "does NOT emit unresolved-include for commented-out include" {
            $commented = $script:Diagnostics | Where-Object { $_.message -match "nonexistent_file" }
            $commented | Should -BeNullOrEmpty
        }

        It "names the planted defects: unterminated math and unmatched end" {
            ($script:Diagnostics | Where-Object { $_.code -eq "census/unterminated-math" }) | Should -Not -BeNullOrEmpty
            ($script:Diagnostics | Where-Object { $_.code -eq "census/unmatched-end" }) | Should -Not -BeNullOrEmpty
        }

        It "queues summoned-but-unconfigured packages as a configured-gap" {
            $gap = $script:Diagnostics | Where-Object { $_.code -eq "census/configured-gap" }
            $gap | Should -Not -BeNullOrEmpty
            $gap.message | Should -Match "amsthm"
        }
    }

    Context "Entities & Reconciliation" {
        BeforeAll {
            $entRaw = Get-Content -Raw (Join-Path $script:OutDir "entities.jsonl")
            $script:Entities = @($entRaw.Trim().Split("`n") | Where-Object { $_ } | ForEach-Object { ConvertFrom-Json $_ })
        }

        It "identifies macro definitions across dialects with elaborability" {
            $mdef = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.definedName -eq "pair" }
            $mdef | Should -Not -BeNullOrEmpty
            $mdef.dialect | Should -Be "newcommand"
            $mdef.elaborable | Should -BeTrue

            $zdef = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.definedName -eq "zz" }
            $zdef.dialect | Should -Be "def"
            $zdef.elaborable | Should -BeFalse

            $ldef = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.definedName -eq "also" }
            $ldef.dialect | Should -Be "let"
            $ldef.elaborable | Should -BeFalse

            $rdef = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.definedName -eq "rank" }
            $rdef.dialect | Should -Be "math-operator"

            $edef = $script:Entities | Where-Object { $_.kind -eq "environment-definition" -and $_.definedName -eq "lemma" }
            $edef | Should -Not -BeNullOrEmpty
            $edef.mechanism | Should -Be "newtheorem"
        }

        It "hulls definition bodies through nested attached arguments" {
            $wdef = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.definedName -eq "wrap" }
            $wdef.text | Should -Be '\newcommand{\wrap}{\mathsf{W}}'
        }

        It "synthesizes the argument hull for \pair{x} and marks it" {
            $inv = $script:Entities | Where-Object { $_.kind -eq "macro-invocation" -and $_.name -eq "pair" }
            $inv | Should -Not -BeNullOrEmpty
            $inv.spanProvenance | Should -Be "synthesized-hull"
            $inv.text | Should -Be '\pair{x}'
        }

        It "identifies math carriers and inline verbatim" {
            $inlineMath = $script:Entities | Where-Object { $_.kind -eq "math" -and $_.mode -eq "inline" }
            $inlineMath | Should -Not -BeNullOrEmpty

            $dispMath = $script:Entities | Where-Object { $_.kind -eq "math" -and $_.mode -eq "display" }
            $dispMath | Should -Not -BeNullOrEmpty

            $verb = $script:Entities | Where-Object { $_.kind -eq "verbatim-inline" }
            $verb | Should -Not -BeNullOrEmpty
            $verb.text | Should -Be '\verb|inline_verb_test|'
        }

        It "censuses the verbatim block as an environment and nothing inside it" {
            $vb = $script:Entities | Where-Object { $_.kind -eq "environment" -and $_.role -eq "verbatim" }
            $vb | Should -Not -BeNullOrEmpty
            # The interior ($math$, \commands) must NOT be censused as LaTeX.
            $inside = $script:Entities | Where-Object {
                $_.span.sourceId -eq "main.tex" -and
                $_.span.startUtf16 -gt $vb.span.startUtf16 -and
                $_.span.endUtf16 -lt $vb.span.endUtf16
            }
            $inside | Should -BeNullOrEmpty
        }

        It "carries include resolution in the artifact" {
            $inc = $script:Entities | Where-Object { $_.kind -eq "include" -and $_.targetRaw -eq "Intro" }
            $inc | Should -Not -BeNullOrEmpty
            $inc.resolvedSourceId | Should -Be "intro.tex"

            $style = $script:Entities | Where-Object { $_.kind -eq "include" -and $_.directive -eq "bibliographystyle" }
            $style.targetRaw | Should -Be "plain"
        }

        It "treats \bibliography as BOTH include and envelope marker (overlay)" {
            $inc = $script:Entities | Where-Object { $_.kind -eq "include" -and $_.directive -eq "bibliography" }
            $inc | Should -Not -BeNullOrEmpty
            $marker = $script:Entities | Where-Object { $_.kind -eq "envelope-marker" -and $_.marker -eq "bibliography" }
            $marker | Should -Not -BeNullOrEmpty
        }

        It "emits begin-document and end-document envelope markers" {
            ($script:Entities | Where-Object { $_.marker -eq "begin-document" }) | Should -Not -BeNullOrEmpty
            ($script:Entities | Where-Object { $_.marker -eq "end-document" }) | Should -Not -BeNullOrEmpty
        }

        It "mints configured-dialect declarations for used package signatures" {
            $conf = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.dialect -eq "configured" -and $_.definedName -eq "textcolor" }
            $conf | Should -Not -BeNullOrEmpty
            $conf.id | Should -Be "ent:macro-definition@configured/xcolor:textcolor"
            $conf.signatureRaw | Should -Be "o m m"
            $conf.witnesses[0].witness | Should -Be "configured"
            $conf.witnesses[0].instrument | Should -Be "unified-latex-ctan"

            # The injected signature must actually drive argument attachment.
            $inv = $script:Entities | Where-Object { $_.kind -eq "macro-invocation" -and $_.name -eq "textcolor" }
            $inv.text | Should -Be '\textcolor{red}{tinted}'
            $inv.spanProvenance | Should -Be "synthesized-hull"

            # Unused declarations from the same package must NOT mint.
            $unused = $script:Entities | Where-Object { $_.dialect -eq "configured" -and $_.definedName -eq "pagecolor" }
            $unused | Should -BeNullOrEmpty
        }

        It "identifies BibTeX entries and @string definitions" {
            $bibEntry = $script:Entities | Where-Object { $_.kind -eq "bib-entry" -and $_.citeKey -eq "dey2021" }
            $bibEntry | Should -Not -BeNullOrEmpty

            $bibString = $script:Entities | Where-Object { $_.kind -eq "bib-string" -and $_.abbreviationName -eq "jmlr" }
            $bibString | Should -Not -BeNullOrEmpty
        }
    }

    Context "Witness Fusion" {
        BeforeAll {
            $entRaw = Get-Content -Raw (Join-Path $script:OutDir "entities.jsonl")
            $script:Entities = @($entRaw.Trim().Split("`n") | Where-Object { $_ } | ForEach-Object { ConvertFrom-Json $_ })
        }

        It "every entity carries at least one witness with provenance" {
            $bare = $script:Entities | Where-Object { -not $_.witnesses -or $_.witnesses.Count -eq 0 }
            $bare | Should -BeNullOrEmpty
        }

        It "agreed control-sequence and math entities are genuinely two-witness" {
            $suspect = $script:Entities | Where-Object {
                $_.agreement -eq "agreed" -and
                $_.kind -in @("macro-invocation", "math", "include", "envelope-marker") -and
                $_.witnesses.Count -lt 2
            }
            $suspect | Should -BeNullOrEmpty
        }

        It "reaches full agreement on the clean fixture through real fusion" {
            $sum = Get-Content -Raw (Join-Path $script:OutDir "summary.json") | ConvertFrom-Json
            $sum.agreementCounts.agreed | Should -Be $script:Entities.Count
        }

        It "backfills cases-in-math interiors via the latex-utensils instrument" {
            # unified-latex reparses `cases` nested inside math in a LOCAL
            # coordinate frame (deterministic; probed 2026-08-12). Those
            # interior sites reach agreement only through the third
            # instrument's position-confirmed backfill.
            $backfilled = $script:Entities | Where-Object {
                $_.kind -eq "macro-invocation" -and
                ($_.witnesses | Where-Object { $_.instrument -eq "latex-utensils" })
            }
            $backfilled | Should -Not -BeNullOrEmpty
            ($backfilled | Where-Object { $_.name -eq "gamma" }) | Should -Not -BeNullOrEmpty
            foreach ($ent in $backfilled) { $ent.agreement | Should -Be "agreed" }
        }
    }

    Context "Expansion Elaboration" {
        BeforeAll {
            $expRaw = Get-Content -Raw (Join-Path $script:OutDir "expansion.jsonl")
            $script:Expansions = @($expRaw.Trim().Split("`n") | Where-Object { $_ } | ForEach-Object { ConvertFrom-Json $_ })
        }

        It "declares the elaboration store in the summary" {
            $sum = Get-Content -Raw (Join-Path $script:OutDir "summary.json") | ConvertFrom-Json
            $sum.stores.emitted | Should -Contain "expansion.jsonl"
        }

        It "applies optional-argument defaults during substitution" {
            $pair = $script:Expansions | Where-Object { $_.definedName -eq "pair" }
            $pair.sourceSlice | Should -Be '\pair{x}'
            $pair.expandedText | Should -Be '(d,x)'
            $pair.status | Should -Be "expanded"
        }

        It "synthesizes math-operator bodies" {
            $rank = $script:Expansions | Where-Object { $_.definedName -eq "rank" }
            $rank.expandedText | Should -Be '\operatorname{rank}'
        }

        It "drives nested chains to a bounded fixed point" {
            $double = $script:Expansions | Where-Object { $_.definedName -eq "double" }
            $double.expandedText | Should -Be '\mathsf{W}\mathsf{W}'
            $double.rounds | Should -BeGreaterOrEqual 2
            $double.status | Should -Be "expanded"
        }

        It "origin-chains every row to census entities (gate 3)" {
            foreach ($row in $script:Expansions) {
                $row.entityId | Should -Match '^ent:macro-invocation@'
                $row.definitionEntityId | Should -Match '^ent:macro-definition@'
                ($script:Entities | Where-Object { $_.id -eq $row.entityId }) | Should -Not -BeNullOrEmpty
            }
        }

        It "leaves non-elaborable dialects out of the expansion table" {
            # \def\zz and \let\also are detected-when-knowable; no expansion rows.
            ($script:Expansions | Where-Object { $_.definedName -in @("zz", "also") }) | Should -BeNullOrEmpty
        }
    }

    Context "Summary & Coverage Gates" {
        BeforeAll {
            $sumRaw = Get-Content -Raw (Join-Path $script:OutDir "summary.json")
            $script:Summary = ConvertFrom-Json $sumRaw
        }

        It "conforms to schema and attributes slug" {
            $script:Summary.schema | Should -Be "texdig-census/0.1"
            $script:Summary.slug | Should -Be "mini_article"
            $script:Summary.sourceCount | Should -Be 7
        }

        It "declares emitted and deferred stores" {
            $script:Summary.stores.emitted.Count | Should -Be 7
            $script:Summary.stores.emitted | Should -Contain "expansion.jsonl"
            $script:Summary.stores.deferred | Should -Contain "walk.jsonl"
        }

        It "reports coverage accounting where claimed + residue equals total" {
            $cov = $script:Summary.coverage
            ($cov.claimedUtf16 + $cov.residueUtf16) | Should -Be $cov.totalUtf16
        }

        It "claims the bib file completely (blank runs included)" {
            $covRows = Get-Content -Raw (Join-Path $script:OutDir "coverage.json") | ConvertFrom-Json
            ($covRows | Where-Object { $_.sourceId -eq "refs.bib" }).residueUtf16 | Should -Be 0
        }
    }
}
