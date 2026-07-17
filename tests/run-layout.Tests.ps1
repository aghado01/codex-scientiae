#requires -Version 7.0
# The runstamped-run layout + unambiguous paper addressing. Non-destructive iteration by
# construction: EVERY preprocess pass lands in its own fresh {paper}/.runs/{stamp}/ (preprocess
# starts a workflow; the read/repair tools continue one), and resolution is newest-run-wins
# unless the address pins a run ({paper}@{run}). Slug addressing must be UNIQUE — an ambiguous
# slug throws listing candidates (the first-hit-wins footgun this replaces silently resolved to
# whichever copy the crawl met first).

BeforeAll {
    . "$PSScriptRoot/../src/preprocess.ps1"   # pulls serving.ps1 (run-layout helpers + resolution) and the stage files

    $script:Roots = [System.Collections.Generic.List[string]]::new()
    function New-LayoutRoot([string]$Leaf = 'ingestion') {
        $root = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-runlayout-" + [guid]::NewGuid().ToString('N')) $Leaf
        New-Item -ItemType Directory -Force -Path $root | Out-Null
        $script:Roots.Add((Split-Path -Parent $root))
        return $root
    }
    # a paper dir with a raw {slug}.json and any set of .runs chunk streams
    function New-Paper([string]$Root, [string]$RelDir, [string]$Slug, [string[]]$RunStamps = @()) {
        $paperDir = Join-Path $Root $RelDir $Slug
        New-Item -ItemType Directory -Force -Path $paperDir | Out-Null
        # a minimal but pipeline-survivable raw IR (title + heading + prose), for the live preprocess tests
        $ir = '{"type":"document","kids":[' +
              '{"type":"paragraph","content":"A Tiny Paper","font":"F1","font size":20.0,"page number":1},' +
              '{"type":"heading","content":"1 Introduction","heading level":1,"font":"F1","font size":14.0,"page number":1},' +
              '{"type":"paragraph","content":"Hello world, twice over.","font":"F1","font size":10.0,"page number":1}]}'
        [System.IO.File]::WriteAllText((Join-Path $paperDir "$Slug.json"), $ir, [System.Text.UTF8Encoding]::new($false))
        $mk = {
            param($dir)
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            [void](Write-JsonlStage -Records @([pscustomobject]@{ id = 0; type = 'prose'; content = 'x'; fidelity = 'faithful' }) `
                                    -OutputPath (Join-Path $dir "$Slug.chunks.jsonl") -Stage 'fidelity')
        }
        foreach ($s in $RunStamps) { & $mk (Join-Path $paperDir '.runs' $s) }
        return $paperDir
    }
}

AfterAll {
    foreach ($r in $script:Roots) { if (Test-Path -LiteralPath $r) { Remove-Item -LiteralPath $r -Recurse -Force -ErrorAction SilentlyContinue } }
}

Describe 'run layout — Get-RunChunks / Get-LatestChunks' {
    It 'orders newest stamp first' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'p1' -RunStamps '20251231_000000', '20260101_000000', '20260102_000000'
        $runs = @(Get-RunChunks $pd 'p1')
        $runs.Count | Should -Be 3
        $runs[0] | Should -BeLike '*20260102_000000*'
        $runs[-1] | Should -BeLike '*20251231_000000*'
        Get-LatestChunks $pd 'p1' | Should -Be $runs[0]
    }
    It 'returns nothing for a virgin paper' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'p3'
        Get-LatestChunks $pd 'p3' | Should -BeNullOrEmpty
    }
    It 'a same-second collision bump still sorts newest-first' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'p4' -RunStamps '20260101_000000', '20260101_000000-2'
        Get-LatestChunks $pd 'p4' | Should -BeLike '*20260101_000000-2*'
    }
}

Describe 'run layout — New-RunDir' {
    It 'creates .runs/{stamp} and never reuses an existing dir' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'p5'
        $a = New-RunDir $pd
        $b = New-RunDir $pd
        $a | Should -Not -Be $b
        (Split-Path -Leaf (Split-Path -Parent $a)) | Should -Be '.runs'
        Test-Path -LiteralPath $a | Should -BeTrue
        Test-Path -LiteralPath $b | Should -BeTrue
    }
}

Describe 'run layout — Get-PaperDirFromChunks' {
    It 'recovers the paper dir from a run chunk path' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'p6' -RunStamps '20260101_000000'
        Get-PaperDirFromChunks (Join-Path $pd '.runs' '20260101_000000' 'p6.chunks.jsonl') | Should -Be $pd
    }
}

Describe 'paper addressing — Resolve-PaperDir / Resolve-PaperChunks' {
    It 'resolves a unique slug' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'u1' -RunStamps '20260101_000000'
        Resolve-PaperDir $root 'u1' | Should -Be $pd
        Resolve-PaperChunks $root 'u1' | Should -BeLike '*20260101_000000*'
    }
    It 'THROWS on an ambiguous slug, listing every candidate — never first-hit-wins' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/orig' 'dup')
        [void](New-Paper $root 'compendia/testing' 'dup')
        $err = { Resolve-PaperDir $root 'dup' } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike '*ambiguous*'
        $err.Exception.Message | Should -BeLike '*compendia/orig/dup*'
        $err.Exception.Message | Should -BeLike '*compendia/testing/dup*'
    }
    It 'a root-relative path disambiguates (and tolerates a leading ingestion/)' {
        $root = New-LayoutRoot   # leaf named 'ingestion'
        [void](New-Paper $root 'compendia/orig' 'dup2')
        $pd = New-Paper $root 'compendia/testing' 'dup2' -RunStamps '20260101_000000'
        Resolve-PaperDir $root 'compendia/testing/dup2' | Should -Be $pd
        Resolve-PaperDir $root 'ingestion/compendia/testing/dup2' | Should -Be $pd
        Resolve-PaperChunks $root 'compendia/testing/dup2' | Should -BeLike '*20260101_000000*'
    }
    It 'confines the path form to the root' {
        $root = New-LayoutRoot
        { Resolve-PaperDir $root '../escape/p' } | Should -Throw -ExpectedMessage '*escapes*'
    }
    It 'throws not-preprocessed for a virgin paper, not-found for an unknown one' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'v1')
        { Resolve-PaperChunks $root 'v1' } | Should -Throw -ExpectedMessage '*not preprocessed*'
        { Resolve-PaperDir $root 'nope' } | Should -Throw -ExpectedMessage '*not found*'
    }
}

Describe 'discovery — Get-ChunkFiles / Get-IngestionScan give ONE current view per paper' {
    It 'a paper with multiple runs surfaces exactly its newest run' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'm1' -RunStamps '20260101_000000', '20260103_000000')
        [void](New-Paper $root 'compendia/t' 'm2' -RunStamps '20260102_000000')
        $files = @(Get-ChunkFiles $root)
        $files.Count | Should -Be 2
        @($files | Where-Object { $_ -like '*m1*' })[0] | Should -BeLike '*20260103_000000*'
        @($files | Where-Object { $_ -like '*m2*' })[0] | Should -BeLike '*20260102_000000*'
    }
    It 'the scan reports prepped from the latest run and carries the run count' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 's1' -RunStamps '20260101_000000', '20260102_000000')
        [void](New-Paper $root 'compendia/t' 's2')
        $scan = @(Get-IngestionScan $root) | Sort-Object paper
        $scan.Count | Should -Be 2
        $scan[0].paper | Should -Be 's1'; $scan[0].prepped | Should -BeTrue;  $scan[0].runs | Should -Be 2
        $scan[1].paper | Should -Be 's2'; $scan[1].prepped | Should -BeFalse; $scan[1].runs | Should -Be 0
    }
}

Describe 'preprocess — every invocation is a NEW run (starts a workflow; never touches prior runs)' {
    It 'creates a fresh run each call; the earlier run stays intact on disk' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'k1'
        $r1 = Invoke-Preprocess -JsonPath (Join-Path $pd 'k1.json')
        $r2 = Invoke-Preprocess -JsonPath (Join-Path $pd 'k1.json')
        $r1.ok | Should -BeTrue; $r2.ok | Should -BeTrue
        $r2.path | Should -Not -Be $r1.path
        $r1.prior_runs | Should -Be 0
        $r2.prior_runs | Should -Be 1
        Test-Path -LiteralPath $r1.path | Should -BeTrue   # displaced, not destroyed
        Get-LatestChunks $pd 'k1' | Should -Be $r2.path    # the new run is the current view
    }
    It 'flags a displaced run that carries agent work, naming its @pin address' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'k2' -RunStamps '20260101_000000'
        # advance the prior run's ledger to the applied milestone (what a folded agent repair records)
        Add-LedgerEntry (Join-Path $pd '.runs' '20260101_000000' 'k2.chunks.jsonl') 'applied' @{}
        $r = Invoke-Preprocess -JsonPath (Join-Path $pd 'k2.json')
        $r.ok | Should -BeTrue
        $r.displaced | Should -BeLike "*applied*"
        $r.displaced | Should -BeLike "*k2@20260101_000000*"
    }
    It 'a displaced run still at the preprocessed milestone raises no flag' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'k3' -RunStamps '20260101_000000'
        $r = Invoke-Preprocess -JsonPath (Join-Path $pd 'k3.json')
        $r.ok | Should -BeTrue
        $r.displaced | Should -BeNullOrEmpty
    }
}

Describe 'run visibility — surveys and dispatch pointers NAME the run (the agent never guesses)' {
    It 'get_batch_summary rows carry the current run' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'r1' -RunStamps '20260101_000000', '20260102_000000')
        $rows = @(Get-BatchSummary -Root $root)
        $rows.Count | Should -Be 1
        $rows[0].run | Should -Be '20260102_000000'
    }
    It 'dispatch pointers carry the run they were drawn from' {
        $root = New-LayoutRoot
        $pd = New-Paper $root 'compendia/t' 'r2' -RunStamps '20260101_000000'
        # make the run's chunk actionable so dispatch surfaces it
        $cp = Join-Path $pd '.runs' '20260101_000000' 'r2.chunks.jsonl'
        [void](Write-JsonlStage -Records @([pscustomobject]@{ id = 0; type = 'prose'; content = 'broken bit'; fidelity = 'needs_review' }) -OutputPath $cp -Stage 'fidelity')
        $d = Invoke-Dispatch -Root $root -BudgetBytes 1000
        $d.count | Should -Be 1
        @($d.batch)[0].run | Should -Be '20260101_000000'
    }
    It 'the scan names the latest run for pinning' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'r3' -RunStamps '20260101_000000' -Legacy)
        (@(Get-IngestionScan $root) | Where-Object paper -eq 'r3').latest_run | Should -Be '20260101_000000'
    }
}

Describe 'pig lane — IR resolves from the newest {paper}/.runs/{stamp}/pig, not beside source' {
    BeforeAll {
        # a paper dir with N pig runs; each is a .runs/{stamp}/pig/ holding a minimal envelope + the
        # classified nodes.jsonl the classifier emits beside it. -WithDocling also drops a {slug}.json.
        function New-PigPaper([string]$Root, [string]$RelDir, [string]$Slug, [string[]]$Stamps, [switch]$WithDocling) {
            $paperDir = Join-Path $Root $RelDir $Slug
            New-Item -ItemType Directory -Force -Path $paperDir | Out-Null
            if ($WithDocling) {
                [System.IO.File]::WriteAllText((Join-Path $paperDir "$Slug.json"), '{"type":"document","kids":[]}', [System.Text.UTF8Encoding]::new($false))
            }
            foreach ($s in $Stamps) {
                $pig = Join-Path $paperDir '.runs' $s 'pig'
                New-Item -ItemType Directory -Force -Path $pig | Out-Null
                [System.IO.File]::WriteAllText((Join-Path $pig "$Slug.pdfdig.json"), "{`"schema`":`"pdfdig-ir/1`",`"stamp`":`"$s`"}", [System.Text.UTF8Encoding]::new($false))
                # one faithful pdfdig run-node (the adapter's input dialect), enough to survive the pipeline
                $node = '{"id":0,"type":"prose","page":1,"line_id":0,"block":0,"col":0,"baseline_y":700.0,"content":"Hello world, twice over.","font":"F1","font size":10.0,"bounding box":[72,690,300,702],"role":"prose","script":"normal","flags":[]}'
                [System.IO.File]::WriteAllText((Join-Path $pig "$Slug.nodes.jsonl"), $node, [System.Text.UTF8Encoding]::new($false))
            }
            return $paperDir
        }
    }

    It 'Get-PigEnvelope / Resolve-PaperSource pick the NEWEST pig run' {
        $root = New-LayoutRoot
        $pd = New-PigPaper $root 'compendia/t' 'g1' -Stamps '20260101_000000', '20260103_000000'
        $env = Get-PigEnvelope $pd 'g1'
        $env | Should -BeLike '*20260103_000000*pig*g1.pdfdig.json'
        Resolve-PaperSource $root 'g1' -Lane pdfdig | Should -Be $env
        Resolve-PaperSource $root 'g1'              | Should -Be $env   # auto prefers pdfdig
    }

    It 'Get-PaperDirFromIr climbs out of .runs/{stamp}/pig; leaves a beside-source raw alone' {
        $root = New-LayoutRoot
        $pd = New-PigPaper $root 'compendia/t' 'g2' -Stamps '20260101_000000'
        Get-PaperDirFromIr (Join-Path $pd '.runs' '20260101_000000' 'pig' 'g2.pdfdig.json') | Should -Be $pd
        Get-PaperDirFromIr (Join-Path $pd 'g2.json') | Should -Be $pd
    }

    It 'Resolve-PaperDir discovers a pig-ONLY paper (no docling raw beside source)' {
        $root = New-LayoutRoot
        $pd = New-PigPaper $root 'compendia/t' 'g3' -Stamps '20260101_000000'
        Resolve-PaperDir $root 'g3' | Should -Be $pd
    }

    It 'Get-IngestionScan reports the pdfdig lane for a pig-run paper' {
        $root = New-LayoutRoot
        [void](New-PigPaper $root 'compendia/t' 'g4' -Stamps '20260101_000000' -WithDocling)
        $row = @(Get-IngestionScan $root) | Where-Object paper -eq 'g4'
        $row.lanes | Should -Contain 'pdfdig'
        $row.lanes | Should -Contain 'opendataloader'
    }

    It 'preprocess lane=pdfdig lands the membrane run beside the SOURCE (sibling of the pig run), reading IR from the pig run' {
        $root = New-LayoutRoot
        $pd = New-PigPaper $root 'compendia/t' 'g5' -Stamps '20260101_000000'
        $r = Invoke-Preprocess -JsonPath (Resolve-PaperSource $root 'g5' -Lane pdfdig)
        $r.ok | Should -BeTrue
        $r.ir_lane | Should -Be 'pdfdig'
        # the membrane run is a sibling of the pig run under the PAPER's .runs/, NOT nested in pig/
        Get-PaperDirFromChunks $r.path | Should -Be $pd
        $r.path | Should -Not -BeLike '*pig*'
    }
}

Describe 'paper addressing — @{run} pins a specific run' {
    It 'unpinned resolves latest; @stamp pins an older run' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'q1' -RunStamps '20260101_000000', '20260102_000000')
        Resolve-PaperChunks $root 'q1' | Should -BeLike '*20260102_000000*'
        Resolve-PaperChunks $root 'q1@20260101_000000' | Should -BeLike '*20260101_000000*'
        Resolve-PaperChunks $root 'compendia/t/q1@20260101_000000' | Should -BeLike '*20260101_000000*'   # composes with the path form
    }
    It 'an unknown pin throws listing the runs that DO exist' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'q2' -RunStamps '20260101_000000')
        $err = { Resolve-PaperChunks $root 'q2@20991231_000000' } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike '*not found*'
        $err.Exception.Message | Should -BeLike '*20260101_000000*'
    }
    It 'preprocess addressing rejects a pin — runs are immutable' {
        $root = New-LayoutRoot
        [void](New-Paper $root 'compendia/t' 'q3' -RunStamps '20260101_000000')
        { Resolve-PaperSource $root 'q3@20260101_000000' } | Should -Throw -ExpectedMessage '*immutable*'
    }
}
