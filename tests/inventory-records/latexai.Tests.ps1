#requires -Version 7.5
# Optional cross-repository boundary test. The caller supplies a prepared LaTeXAI checkout.
Describe 'LaTeXAI paper record integration' -Skip:([string]::IsNullOrWhiteSpace($env:LATEXAI_ROOT)) {
    BeforeAll {
        $script:RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
        $script:EngineRoot=(Resolve-Path $env:LATEXAI_ROOT).Path
        . (Join-Path $script:EngineRoot 'scripts/latexai-common.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-select.ps1')
        Import-Module (Join-Path $script:RepositoryRoot 'src/inventory-records/inventory-records.psm1') -Force
        $runtime=Resolve-LaTeXAIRuntime -RequirePerl
        $script:Perl=$runtime.PerlPath
        $script:FixtureRoot=Join-Path ($env:CDXSCI_TEST_ARTIFACT_ROOT ? $env:CDXSCI_TEST_ARTIFACT_ROOT : $TestDrive) 'latexai'
        $script:BatchRoot=Join-Path $script:FixtureRoot 'batch'
        $article=Join-Path $script:FixtureRoot 'g1-record-fixture'
        $tree=Join-Path $article 'tex'
        [void][IO.Directory]::CreateDirectory($tree)
        [void][IO.Directory]::CreateDirectory($script:BatchRoot)
        $utf8=[Text.UTF8Encoding]::new($false)
        $tex=@'
\documentclass{article}
\usepackage{amsmath}
\begin{document}
\begin{equation}\begin{aligned}a&=b\\c&=d\end{aligned}\end{equation}
\[e=f\]
\end{document}
'@
        [IO.File]::WriteAllText((Join-Path $tree 'main.tex'),$tex+"`n",$utf8)
        $manifest=@{schema='codex-scientiae/article/0.1';state='source-ready';slug='g1-record-fixture';source_forms=@(@{role='latex-source-tree';path='tex';entrypoint='main.tex';sha256=('a'*64);files=1;tex_files=1})}
        [IO.File]::WriteAllText((Join-Path $article 'article.json'),($manifest|ConvertTo-Json -Depth 10),$utf8)
        $schema=Join-Path $script:EngineRoot 'scripts/schemas/paper-experiment.schema.json'
        $previous=@{}
        foreach($key in @('CDXSCI_TEMP','CDXSCI_JSON_SCRATCH_ROOT','TEMP','TMP','TMPDIR')){$previous[$key]=[Environment]::GetEnvironmentVariable($key)}
        try {
            $null=& (Join-Path $script:RepositoryRoot 'src/batch-runner.ps1') -RepositoryRoot $script:RepositoryRoot `
                -Path $article -RunDirectory $script:BatchRoot -Engine latexai -EngineRoot $script:EngineRoot `
                -Worker (Join-Path $script:EngineRoot 'scripts/gauntlet-worker.ps1') `
                -WorkerParameter @{PerlPath=$script:Perl;IncludeStyles=$false;Kpsewhich=$false;TimeoutSeconds=60;LatexmlArgument=@('--capture');ConversionWorkingDirectory='output'} `
                -ExperimentSpecification @{schema='latexai/acquisition-plan/1';conditions=@(@{id='conversion';capture=$true});comparisons=@();payloadSchema=(Get-InventoryFileReference $schema)} `
                -MaxWorkers 1 -ProcessTimeoutSeconds 120 -WaitTimeoutSeconds 180 -ExecutionTimeoutSeconds 180 -CleanupTimeoutSeconds 30
        } finally {
            foreach($key in $previous.Keys){[Environment]::SetEnvironmentVariable($key,$previous[$key])}
        }
        $script:Observed=Read-InventoryBatch $script:BatchRoot
    }

    It 'produces one complete acquisition with direct native evidence and no competing receipt' {
        $script:Observed.Record.status | Should -Be 'complete'
        $script:Observed.Record.qualification.status | Should -Be 'not-requested'
        $script:Observed.Papers.Count | Should -Be 1
        $paper=$script:Observed.Papers[0]
        $condition=$paper.Record.payload.conditions[0]
        $condition.execution.outcome | Should -Be 'exited'
        $condition.execution.exitCode | Should -Be 0
        $condition.execution.cleanupComplete | Should -BeTrue
        $condition.counts.mathElements | Should -BeGreaterThan 0
        Test-Path -LiteralPath (Join-Path $paper.Directory 'receipt.json') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path $script:BatchRoot 'run.json') | Should -BeFalse
    }

    It 'feeds the existing comparator through the new record boundary and checks captured source bytes' {
        $output=Join-Path $script:FixtureRoot 'comparison'
        $result=Invoke-LaTeXAINative -FilePath $script:Perl -WorkingDirectory $script:EngineRoot -TimeoutSeconds 90 `
            -Arguments @('-I','lib','tools/dev/capture-corpus-audit.pl','--baseline',$script:BatchRoot,'--candidate',$script:BatchRoot,
                '--output',$output,'--project-baseline',$script:Observed.Reference.sha256)
        if($result.ExitCode -ne 0){Write-Host $result.StdOut;Write-Host $result.StdErr}
        $result.ExitCode | Should -Be 0 -Because ("stdout: $($result.StdOut)`nstderr: $($result.StdErr)")
        $report=Get-Content -LiteralPath (Join-Path $output 'comparison.json') -Raw | ConvertFrom-Json
        $report.qualified | Should -BeTrue
        @($report.inventory_formats) | Should -Be @('paper-run','paper-run')
        $report.papers[0].after.source_ranges_checked | Should -BeGreaterThan 0
    }

    It 'reads package observations and pins the worker record in the selector' {
        $selected=Select-LaTeXAIGauntletPackage -CdxsciRoot $script:RepositoryRoot -EvidenceDirectory $script:BatchRoot -Package amsmath
        $selected.schema | Should -Be 'latexai/gauntlet-package-selection/0.2'
        $selected.basis | Should -Be 'paper-conditions'
        $selected.observedCount | Should -Be 1
        $selected.inputs[$script:Observed.Papers[0].Reference.path] | Should -Be $script:Observed.Papers[0].Reference.sha256
    }

    It 'feeds XML inspection and the Markdown input manifest from the recorded condition' {
        $paper=$script:Observed.Papers[0]
        $condition=$paper.Record.payload.conditions[0]
        $xml=Join-Path $paper.Directory $condition.outputs.xml
        $report=& (Join-Path $script:EngineRoot 'scripts/xml-inspect.ps1') -XmlPath $xml -RunPath $paper.Reference.path -CdxsciRoot $script:RepositoryRoot | ConvertFrom-Json
        $report.evidence.format | Should -Be 'paper-run'
        $report.differences.mathElements | Should -Be 0
        $report.differences.ltxErrors | Should -Be 0
        $manifest=Join-Path $script:FixtureRoot 'markdown-inputs.json'
        $inputRecord=@{schema='latexai/markdown-projection-inputs/0.2';inputs=@(@{
            slug=$paper.Record.article.slug;xml=$xml;xmlSha256=(Get-InventoryFileReference $xml).sha256
            run=$paper.Reference.path;runSha256=$paper.Reference.sha256;condition='conversion'
        })}
        [IO.File]::WriteAllText($manifest,($inputRecord | ConvertTo-Json -Depth 20),[Text.UTF8Encoding]::new($false))
        $output=Join-Path $script:FixtureRoot 'markdown'
        & (Join-Path $script:EngineRoot 'scripts/markdown-compare.ps1') -Manifest $manifest -OutputDirectory $output -Repetitions 3 -CdxsciRoot $script:RepositoryRoot -TimeoutSeconds 60
        $comparison=Get-Content -LiteralPath (Join-Path $output 'comparison.json') -Raw | ConvertFrom-Json
        $comparison.inventory_format | Should -Be 'paper-run'
        $comparison.inputs[0].identical | Should -BeTrue
    }

    It 'rejects an unknown condition and changed XML in the consumer boundary' {
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-records.ps1')
        $paper=$script:Observed.Papers[0]
        {Get-LaTeXAIPaperCondition -RunPath $paper.Reference.path -Condition absent -CdxsciRoot $script:RepositoryRoot} | Should -Throw '*condition*'
        $xml=Join-Path $paper.Directory $paper.Record.payload.conditions[0].outputs.xml
        $bytes=[IO.File]::ReadAllBytes($xml)
        try {
            [IO.File]::AppendAllText($xml,"`n",[Text.UTF8Encoding]::new($false))
            {Get-LaTeXAIPaperCondition -RunPath $paper.Reference.path -CdxsciRoot $script:RepositoryRoot} | Should -Throw '*Changed artifact*'
        } finally {[IO.File]::WriteAllBytes($xml,$bytes)}
    }

    It 'rejects forged <Field> in the Perl inventory reader' -ForEach @(
        @{Field='totals'},@{Field='coverage'},@{Field='executor'}
    ) {
        $path=Join-Path $script:BatchRoot 'batch.json'
        $bytes=[IO.File]::ReadAllBytes($path)
        $batch=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -AsHashtable
        try {
            switch($Field){
                'totals' {$batch.totals.mathElements++}
                'coverage' {$batch.coverage.failed=1}
                'executor' {$batch.records[0].executor.exitCode=123}
            }
            [IO.File]::WriteAllText($path,($batch|ConvertTo-Json -Depth 100),[Text.UTF8Encoding]::new($false))
            $result=Invoke-LaTeXAINative -FilePath $script:Perl -WorkingDirectory $script:EngineRoot -TimeoutSeconds 30 `
                -Arguments @('-I','lib','-I','tools/dev','-MCaptureInventory=load_inventory','-e','load_inventory($ARGV[0])',$script:BatchRoot)
            $result.ExitCode | Should -Not -Be 0
            $result.StdErr | Should -Match '(mismatch|coverage)'
        } finally {[IO.File]::WriteAllBytes($path,$bytes)}
    }

    It 'retains a failed native invocation without claiming conversion or qualification success' {
        $root=Join-Path $script:FixtureRoot 'failed-native'
        [void][IO.Directory]::CreateDirectory($root)
        $previous=@{}
        foreach($key in @('CDXSCI_TEMP','CDXSCI_JSON_SCRATCH_ROOT','TEMP','TMP','TMPDIR')){$previous[$key]=[Environment]::GetEnvironmentVariable($key)}
        try {
            $null=& (Join-Path $script:RepositoryRoot 'src/batch-runner.ps1') -RepositoryRoot $script:RepositoryRoot `
                -Path (Join-Path $script:FixtureRoot 'g1-record-fixture') -RunDirectory $root -Engine latexai -EngineRoot $script:EngineRoot `
                -Worker (Join-Path $script:EngineRoot 'scripts/gauntlet-worker.ps1') `
                -WorkerParameter @{PerlPath=$script:Perl;IncludeStyles=$false;Kpsewhich=$false;TimeoutSeconds=60;LatexmlArgument=@('--unknown-g1-test-option');ConversionWorkingDirectory='output'} `
                -ExperimentSpecification @{schema='latexai/acquisition-plan/1';conditions=@(@{id='conversion';capture=$false});comparisons=@();payloadSchema=(Get-InventoryFileReference (Join-Path $script:EngineRoot 'scripts/schemas/paper-experiment.schema.json'))} `
                -MaxWorkers 1 -ProcessTimeoutSeconds 120 -WaitTimeoutSeconds 180 -ExecutionTimeoutSeconds 180 -CleanupTimeoutSeconds 30
        } finally {foreach($key in $previous.Keys){[Environment]::SetEnvironmentVariable($key,$previous[$key])}}
        $failed=Read-InventoryBatch $root
        $failed.Record.status | Should -Be 'incomplete'
        $failed.Record.coverage.failed | Should -Be 1
        $failed.Record.qualification.status | Should -Be 'incomplete'
        $failed.Papers[0].Record.status | Should -Be 'failed'
        $native=$failed.Papers[0].Record.payload.conditions[0].execution
        $native.outcome | Should -Be 'exited'
        $native.exitCode | Should -Not -Be 0
        $native.cleanupComplete | Should -BeTrue
        @($failed.Papers[0].Record.artifacts).Count | Should -BeGreaterThan 0
        $advisory=Invoke-LaTeXAINative -FilePath $script:Perl -WorkingDirectory $script:EngineRoot -TimeoutSeconds 30 `
            -Arguments @('-I','lib','-I','tools/dev','-MCaptureInventory=load_inventory','-e',
                'my $r=load_inventory($ARGV[0],require_xml=>0); die "lost failed paper" unless keys(%{$r->{papers}})==1;',$root)
        $advisory.ExitCode | Should -Be 0 -Because $advisory.StdErr
    }
}
