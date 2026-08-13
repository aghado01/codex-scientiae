BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:FixtureDir = Join-Path $script:RepositoryRoot "tests/fixtures/texdig/mini_article"
    $script:FixtureTree = Join-Path $script:FixtureDir "mini_article-tex"

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
        It "returns a typed 0.2 physical-census run record" {
            $script:Run.PSObject.TypeNames | Should -Contain "TeXdig.CensusRun"
            $script:Run.Slug | Should -Be "mini_article"
            $script:Run.Conflict | Should -Be 0
            $script:Run.Defects | Should -Be 0
            $script:Run.NodePath | Should -Not -BeNullOrEmpty
            $script:Run.NodeVersion | Should -Match '^v\d+\.\d+\.\d+'
        }

        It "partitions the full decoded corpus into physical claims and residue" {
            ($script:Run.ClaimedUtf16 + $script:Run.ResidueUtf16) |
                Should -Be $script:Run.TotalUtf16
            # Argument delimiters are not absorbed into token-only macro
            # invocation carriers in the physical census.
            $script:Run.ResidueUtf16 | Should -Be 12
        }

        It "emits all 6 evidence and audit tier stores" {
            Test-Path (Join-Path $script:OutDir "sources.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "entities.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "claims.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "coverage.json") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "diagnostics.jsonl") | Should -BeTrue
            Test-Path (Join-Path $script:OutDir "summary.json") | Should -BeTrue
        }

        It "does not publish the withdrawn 0.1 binding-derived stores" {
            Test-Path (Join-Path $script:OutDir "expansion.jsonl") | Should -BeFalse
            Test-Path (Join-Path $script:OutDir "macros.jsonl") | Should -BeFalse
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

        It "records exact bytes for every source and UTF-16 lengths only for parsed text" {
            foreach ($source in $script:Sources) {
                $physicalPath = Join-Path $script:FixtureTree $source.id
                $rawBytes = [System.IO.File]::ReadAllBytes($physicalPath)

                $source.bytes | Should -Be $rawBytes.Length
                if ($source.parsed) {
                    $decoded = [System.Text.UTF8Encoding]::new($false, $true).GetString($rawBytes)
                    $source.PSObject.Properties['lengthUtf16'] | Should -Not -BeNullOrEmpty
                    $source.lengthUtf16 | Should -Be $decoded.Length
                } else {
                    $source.PSObject.Properties['lengthUtf16'] | Should -BeNullOrEmpty
                }
            }
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

        It "retains the exact physical macro declaration span" {
            $wdef = $script:Entities | Where-Object { $_.kind -eq "macro-definition" -and $_.definedName -eq "wrap" -and $_.dialect -eq "newcommand" }
            $wdef.text | Should -Be '\newcommand{\wrap}{\mathsf{W}}'
        }

        It "keeps \pair{x} as a physical control-sequence token without a binding hull" {
            $inv = $script:Entities | Where-Object { $_.kind -eq "macro-invocation" -and $_.name -eq "pair" }
            $inv | Should -Not -BeNullOrEmpty
            $inv.spanProvenance | Should -Not -Be "synthesized-hull"
            $inv.text | Should -Be '\pair'
            ($inv.span.endUtf16 - $inv.span.startUtf16) | Should -Be '\pair'.Length
            $inv.PSObject.Properties['argumentSpans'] | Should -BeNullOrEmpty
            $inv.id | Should -Be "ent:macro-invocation@$($inv.span.sourceId):$($inv.span.startUtf16)-$($inv.span.endUtf16)"
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
            $conf.argumentSpec | Should -Be "o m m"
            $conf.PSObject.Properties['signatureRaw'] | Should -BeNullOrEmpty
            $conf.witnesses[0].witness | Should -Be "configured"
            $conf.witnesses[0].instrument | Should -Be "unified-latex-ctan"

            # The physical census records the control-sequence token only;
            # configured signatures become binding inputs in a later store.
            $inv = $script:Entities | Where-Object { $_.kind -eq "macro-invocation" -and $_.name -eq "textcolor" }
            $inv.text | Should -Be '\textcolor'
            $inv.spanProvenance | Should -Not -Be "synthesized-hull"
            $inv.PSObject.Properties['argumentSpans'] | Should -BeNullOrEmpty

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

        It "backs every two-instrument agreement with two witness records" {
            $twoInstrument = @($script:Entities | Where-Object agreementBasis -eq 'two-instrument')
            $twoInstrument | Should -Not -BeNullOrEmpty
            $suspect = @($twoInstrument | Where-Object { $_.witnesses.Count -lt 2 })
            $suspect | Should -BeNullOrEmpty
        }

        It "accounts the fixture's honest mixed-authority witness distribution" {
            $sum = Get-Content -Raw (Join-Path $script:OutDir "summary.json") | ConvertFrom-Json
            $accounted = ($sum.agreementCounts.PSObject.Properties | Measure-Object -Sum Value).Sum
            $accounted | Should -Be $script:Entities.Count
            $accounted | Should -Be 95
            $sum.agreementCounts.agreed | Should -Be 90
            $sum.agreementCounts.'parser-only' | Should -Be 4
            $sum.agreementCounts.'lexical-only' | Should -Be 1
            $sum.agreementCounts.PSObject.Properties['conflict'] | Should -BeNullOrEmpty
        }

        It "marks parser-only Bib fields as an explicit single-authority boundary" {
            $fields = @($script:Entities | Where-Object kind -eq 'bib-field')
            $fields.Count | Should -Be 4
            foreach ($field in $fields) {
                $field.agreement | Should -Be 'parser-only'
                $field.agreementBasis | Should -Be 'single-authority'
                @($field.witnesses).Count | Should -Be 1
                $field.witnesses[0].instrument | Should -Be 'latex-utensils'
            }
        }

        It "retains the math-script underscore as explicit lexical-only evidence" {
            $lexicalOnly = @($script:Entities | Where-Object agreement -eq 'lexical-only')
            $lexicalOnly.Count | Should -Be 1
            $lexicalOnly[0].kind | Should -Be 'macro-invocation'
            $lexicalOnly[0].name | Should -Be '_'
            $lexicalOnly[0].text | Should -Be '_'
            $lexicalOnly[0].agreementBasis | Should -Be 'single-authority'
            @($lexicalOnly[0].witnesses).Count | Should -Be 1
            $lexicalOnly[0].witnesses[0].witness | Should -Be 'lexical'
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

    Context "Catcode Arbitration" {
        It "resolves truncated @-name conflicts inside makeatletter regions for the lexical witness" {
            # Harvested corpus specimen: near #-parameter tokens unified-latex
            # truncates csnames (\m@th read as m@t or m); the scanner is
            # byte-exact and the region licenses the @-name reading.
            $mth = $script:Entities | Where-Object { $_.name -eq "m@th" }
            $mth | Should -Not -BeNullOrEmpty
            $mth.agreement | Should -Be "agreed"
            $mth.text | Should -Be '\m@th'
        }

        It "names the arbitration and leaves no conflicts on the fixture" {
            $diag = Get-Content (Join-Path $script:OutDir "diagnostics.jsonl") | ForEach-Object { ConvertFrom-Json $_ }
            ($diag | Where-Object { $_.code -eq "census/catcode-arbitrated" }) | Should -Not -BeNullOrEmpty
            $sum = Get-Content -Raw (Join-Path $script:OutDir "summary.json") | ConvertFrom-Json
            $sum.agreementCounts.PSObject.Properties["conflict"] | Should -BeNullOrEmpty
        }
    }

    Context "Summary & Coverage Gates" {
        BeforeAll {
            $sumRaw = Get-Content -Raw (Join-Path $script:OutDir "summary.json")
            $script:Summary = ConvertFrom-Json $sumRaw
        }

        It "conforms to the 0.2 summary, source identity, and runtime contract" {
            $script:Summary.schema | Should -Be "texdig-census/0.2"
            $script:Summary.slug | Should -Be "mini_article"
            $script:Summary.sourceCount | Should -Be 7

            $manifest = Get-Content -LiteralPath (Join-Path $script:FixtureDir 'article.json') -Raw | ConvertFrom-Json
            $treeForm = $manifest.source_forms | Where-Object role -eq 'latex-source-tree'
            $script:Summary.treeSha256 | Should -Be $treeForm.sha256
            $script:Run.TreeSha256 | Should -Be $treeForm.sha256
            $script:Summary.runtime.node | Should -Be $script:Run.NodeVersion
        }

        It "declares exactly the six physical stores and their normative schemas" {
            $expectedSchemas = [ordered]@{
                'sources.jsonl'     = 'codex-scientiae/texdig-sources/0.2'
                'entities.jsonl'    = 'codex-scientiae/texdig-entities/0.2'
                'claims.jsonl'      = 'codex-scientiae/texdig-claims/0.2'
                'coverage.json'     = 'codex-scientiae/texdig-coverage/0.2'
                'diagnostics.jsonl' = 'codex-scientiae/texdig-diagnostics/0.2'
                'summary.json'      = 'codex-scientiae/texdig-summary/0.2'
            }

            @($script:Summary.stores.emitted).Count | Should -Be $expectedSchemas.Count
            @($script:Summary.storeSchemas.PSObject.Properties).Count | Should -Be $expectedSchemas.Count
            foreach ($store in $expectedSchemas.Keys) {
                $script:Summary.stores.emitted | Should -Contain $store
                $script:Summary.storeSchemas.PSObject.Properties[$store].Value |
                    Should -Be $expectedSchemas[$store]
            }
        }

        It "explicitly defers the withdrawn binding-derived stores" {
            $script:Summary.stores.emitted | Should -Not -Contain "expansion.jsonl"
            $script:Summary.stores.emitted | Should -Not -Contain "macros.jsonl"
            $script:Summary.stores.deferred | Should -Contain "expansion.jsonl"
            $script:Summary.stores.deferred | Should -Contain "macros.jsonl"
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

        It "emits exactly one coverage row for every parsed source" {
            $covRows = @(Get-Content -Raw (Join-Path $script:OutDir "coverage.json") | ConvertFrom-Json)
            $parsedIds = @($script:Sources | Where-Object parsed | ForEach-Object id | Sort-Object)
            $coverageIds = @($covRows | ForEach-Object sourceId | Sort-Object)

            $coverageIds.Count | Should -Be $parsedIds.Count
            ($coverageIds -join '|') | Should -Be ($parsedIds -join '|')
        }
    }
}
