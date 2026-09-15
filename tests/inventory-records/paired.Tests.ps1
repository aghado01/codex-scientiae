#requires -Version 7.5
# Prepared external engine only; no dependency installation or live corpus access.
Describe 'Frozen LaTeXAI paired worker' -Skip:([string]::IsNullOrWhiteSpace($env:LATEXAI_ROOT)) {
    BeforeAll {
        $script:RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
        $script:EngineRoot=(Resolve-Path $env:LATEXAI_ROOT).Path
        . (Join-Path $script:EngineRoot 'scripts/latexai-common.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-freeze.ps1')
        Import-Module (Join-Path $script:RepositoryRoot 'src/inventory-records/inventory-records.psm1') -Force
        $script:Root=Join-Path ($env:CDXSCI_TEST_ARTIFACT_ROOT ? $env:CDXSCI_TEST_ARTIFACT_ROOT : $TestDrive) 'paired'
        $script:Article=Join-Path $script:Root 'paper'
        $tree=Join-Path $script:Article 'tex'
        [void][IO.Directory]::CreateDirectory($tree)
        $utf8=[Text.UTF8Encoding]::new($false)
        [IO.File]::WriteAllText((Join-Path $tree 'main.tex'),"\documentclass{article}`n\usepackage{amsmath}`n\begin{document}`n\begin{equation}\begin{aligned}a&=b\\c&=d\end{aligned}\end{equation}`n\[e=f\]`n\end{document}`n",$utf8)
        $source=Get-LaTeXAITreeRecord $tree
        $manifest=@{schema='codex-scientiae/article/0.1';state='source-ready';slug='paper';source_forms=@(@{role='latex-source-tree';path='tex';entrypoint='main.tex';sha256=$source.sha256;files=1;tex_files=1})}
        [IO.File]::WriteAllText((Join-Path $script:Article 'article.json'),($manifest|ConvertTo-Json -Depth 10),$utf8)
        $script:OriginalTree=$source.sha256
        $script:Perl=(Resolve-LaTeXAIRuntime -RequirePerl).PerlPath
        $script:SuccessRoot=Join-Path $script:Root 'success'
        function Invoke-PairedFixture([string]$Run,[string[]]$Extra=@()) {
            [void][IO.Directory]::CreateDirectory($Run)
            $previous=@{}
            foreach($key in @('CDXSCI_TEMP','CDXSCI_JSON_SCRATCH_ROOT','TEMP','TMP','TMPDIR')){$previous[$key]=[Environment]::GetEnvironmentVariable($key)}
            try {
                $null=& (Join-Path $script:EngineRoot 'scripts/gauntlet-run.ps1') -CdxsciRoot $script:RepositoryRoot -Path $script:Article `
                    -RunDirectory $Run -CaptureParity -OnArgument $Extra -MaxWorkers 1 -Preload @() -IncludeStyles:$false -Kpsewhich:$false `
                    -NativeTimeoutSeconds 60 -ComparisonTimeoutSeconds 90 -ProcessTimeoutSeconds 900 -WaitTimeoutSeconds 1000 -ExecutionTimeoutSeconds 1000
            } catch {
                [IO.File]::WriteAllText((Join-Path $script:Root 'setup-error.txt'),($_|Format-List * -Force|Out-String),[Text.UTF8Encoding]::new($false))
                throw
            } finally {foreach($key in $previous.Keys){[Environment]::SetEnvironmentVariable($key,$previous[$key])}}
            return (Read-InventoryBatch $Run)
        }
        $script:Success=Invoke-PairedFixture $script:SuccessRoot
    }

    It 'runs and qualifies both frozen conditions inside one paper job' {
        $script:Success.Record.status | Should -Be 'complete'
        $script:Success.Record.qualification.status | Should -Be 'pass'
        $script:Success.Papers.Count | Should -Be 1
        $paper=$script:Success.Papers[0]
        @($paper.Record.payload.conditions.id) | Should -Be @('off','on')
        @($paper.Record.payload.conditions.status) | Should -Be @('ok','ok')
        $paper.Record.payload.comparisons[0].status | Should -Be 'pass'
        $report=Get-Content -LiteralPath (Join-Path $paper.Directory $paper.Record.payload.comparisons[0].report) -Raw|ConvertFrom-Json -AsHashtable
        $report.paper.after.source_ranges_checked | Should -BeGreaterThan 0
        $report.paper.comparison_document_equal | Should -BeTrue
        $paper.Record.payload.conditions[0].memory.method | Should -Be 'sampled-process-PeakWorkingSet64'
        $paper.Record.summary.inputValidationMs | Should -BeGreaterThan 0
        Test-Path -LiteralPath (Join-Path $script:SuccessRoot 'run.json') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path $paper.Directory 'receipt.json') | Should -BeFalse
        (Get-LaTeXAITreeRecord (Join-Path $script:Article 'tex')).sha256 | Should -Be $script:OriginalTree
    }

    It 'keeps failed conditions and incomplete comparisons in the denominator' {
        $failed=Invoke-PairedFixture (Join-Path $script:Root 'failed-native') @('--unknown-paired-test-option')
        $failed.Record.coverage.expected | Should -Be 1
        $failed.Record.coverage.failed | Should -Be 1
        $failed.Record.qualification.status | Should -Be 'incomplete'
        $conditions=$failed.Papers[0].Record.payload.conditions
        @($conditions.status) | Should -Be @('ok','failed')
        $conditions[1].execution.exitCode | Should -Not -Be 0
        $conditions[1].execution.cleanupComplete | Should -BeTrue
        $failed.Papers[0].Record.payload.comparisons[0].status | Should -Be 'incomplete'
    }

    It 'rejects changed frozen source bytes and restores the retained passing evidence' {
        $paper=$script:Success.Papers[0]
        $resolved=Assert-LaTeXAIExperimentFreeze $paper.Record.payload.freeze $paper.Record.article
        $path=$resolved.Source.entrypoint.path
        $bytes=[IO.File]::ReadAllBytes($path)
        try {
            [IO.File]::AppendAllText($path,"`n% changed",[Text.UTF8Encoding]::new($false))
            {Assert-LaTeXAIExperimentFreeze $paper.Record.payload.freeze $paper.Record.article} | Should -Throw '*Changed frozen input tree*'
        } finally {[IO.File]::WriteAllBytes($path,$bytes)}
        {Assert-LaTeXAIExperimentFreeze $paper.Record.payload.freeze $paper.Record.article} | Should -Not -Throw
    }

    It 'reports <Fault> as <Verdict> from direct condition evidence' -ForEach @(
        @{Fault='unchanged';Verdict='pass';Exit=0},
        @{Fault='manuscript-comment';Verdict='fail';Exit=1},
        @{Fault='malformed-xml';Verdict='incomplete';Exit=2},
        @{Fault='changed-artifact';Verdict='incomplete';Exit=2},
        @{Fault='wrong-model-pin';Verdict='incomplete';Exit=2}
    ) {
        $paper=$script:Success.Papers[0]
        $request=Get-Content -LiteralPath (Join-Path $paper.Directory 'comparisons/parity.request.json') -Raw|ConvertFrom-Json -AsHashtable
        $xml=Join-Path $paper.Directory $request.right.condition.outputs.xml
        $bytes=[IO.File]::ReadAllBytes($xml)
        try {
            switch($Fault){
                'manuscript-comment' {[IO.File]::AppendAllText($xml,'<!--negative-control-->',[Text.UTF8Encoding]::new($false))}
                'malformed-xml' {[IO.File]::WriteAllText($xml,'<broken',[Text.UTF8Encoding]::new($false))}
                'changed-artifact' {[IO.File]::AppendAllText($xml,'<!--unrecorded-->',[Text.UTF8Encoding]::new($false))}
                'wrong-model-pin' {$request.model.sha256='0'*64}
            }
            if($Fault -in @('manuscript-comment','malformed-xml')){
                $artifact=@($request.right.artifacts|Where-Object {$_.path -ceq $request.right.condition.outputs.xml})[0]
                $artifact.sha256=(Get-InventoryFileReference $xml).sha256
                $artifact.bytes=(Get-Item -LiteralPath $xml).Length
            }
            $requestPath=Join-Path $script:Root "controls/$Fault.request.json"
            $output=Join-Path $script:Root "controls/$Fault"
            $null=Write-LaTeXAIFrozenJson $requestPath $request
            $run=Invoke-LaTeXAINative -FilePath $script:Perl -WorkingDirectory $script:EngineRoot -TimeoutSeconds 90 `
                -Arguments @('-I','lib','tools/dev/compare-paper.pl',$requestPath,$output)
            $run.ExitCode | Should -Be $Exit -Because ($run.StdOut+$run.StdErr)
            $report=Get-Content -LiteralPath (Join-Path $output 'comparison.json') -Raw|ConvertFrom-Json -AsHashtable
            $report.status | Should -Be $Verdict
            $report.qualified | Should -Be ($Verdict -eq 'pass')
            if($Fault -eq 'manuscript-comment') { $report.issues | Should -Contain 'paper:non-capture-tree' }
        } finally {[IO.File]::WriteAllBytes($xml,$bytes)}
        {Read-InventoryBatch $script:SuccessRoot} | Should -Not -Throw
    }

    It 'validates the paired payload example and rejects unfrozen path options before dispatch' {
        $example=Get-Content -LiteralPath (Join-Path $script:EngineRoot 'scripts/schemas/examples/paired-paper-experiment.json') -Raw
        Test-Json -Json $example -SchemaFile (Join-Path $script:EngineRoot 'scripts/schemas/paper-experiment.schema.json') | Should -BeTrue
        foreach($flag in @('--path','--pre','--output=elsewhere','--nocapture','elsewhere.tex')){
            {& (Join-Path $script:EngineRoot 'scripts/gauntlet-run.ps1') -CaptureParity -Preview -OnArgument @($flag)} | Should -Throw '*Paired*'
        }
    }

    It 'rejects a changed generated engine revision before using its conversions' {
        $paper=$script:Success.Papers[0]
        $freeze=Get-Content -LiteralPath $paper.Record.payload.freeze.path -Raw|ConvertFrom-Json -AsHashtable
        $path=$freeze.generatedVersion.path
        $bytes=[IO.File]::ReadAllBytes($path)
        try {
            [IO.File]::AppendAllText($path,"`n# changed",[Text.UTF8Encoding]::new($false))
            {Assert-LaTeXAIExperimentFreeze $paper.Record.payload.freeze $paper.Record.article} | Should -Throw '*Changed frozen file*'
        } finally {[IO.File]::WriteAllBytes($path,$bytes)}
    }
}
