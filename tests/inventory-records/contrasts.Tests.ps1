#requires -Version 7.5
Describe 'Declared LaTeXAI contrasts and historical import' -Skip:([string]::IsNullOrWhiteSpace($env:LATEXAI_ROOT)) {
    BeforeAll {
        $script:RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
        $script:EngineRoot=(Resolve-Path $env:LATEXAI_ROOT).Path
        . (Join-Path $script:EngineRoot 'scripts/latexai-common.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-freeze.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-reuse.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-legacy.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-contrasts.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-convert.ps1')
        Import-Module (Join-Path $script:RepositoryRoot 'src/inventory-records/inventory-records.psm1') -Force
        $script:Root=Join-Path ($env:CDXSCI_TEST_ARTIFACT_ROOT ? $env:CDXSCI_TEST_ARTIFACT_ROOT : $TestDrive) 'contrasts'
        $script:Article=Join-Path $script:Root 'paper'
        $tree=Join-Path $script:Article 'paper-tex'
        [void][IO.Directory]::CreateDirectory($tree)
        $utf8=[Text.UTF8Encoding]::new($false)
        [IO.File]::WriteAllText((Join-Path $tree 'main.tex'),"\documentclass{article}`n\usepackage{amsmath}`n\usepackage{localstyle}`n\providecommand{\localvalue}{a}`n\begin{document}`n\localvalue`n\begin{equation}\begin{aligned}a&=b\\c&=d\end{aligned}\end{equation}`n\[e=f\]`n\end{document}`n",$utf8)
        [IO.File]::WriteAllText((Join-Path $tree 'localstyle.sty'),'\ProvidesPackage{localstyle}\newcommand{\localvalue}{b}',$utf8)
        $source=Get-LaTeXAITreeRecord $tree
        $manifest=@{schema='codex-scientiae/article/0.1';state='source-ready';slug='paper';source_forms=@(@{role='latex-source-tree';path='paper-tex';entrypoint='main.tex';sha256=$source.sha256;files=2;tex_files=1})}
        $null=Write-LaTeXAIFrozenJson (Join-Path $script:Article 'article.json') $manifest
        $script:Identity=@{directory=$script:Article;slug='paper';sourceTree=$tree;entrypoint='main.tex';treeSha256=$source.sha256}
        $script:Perl=(Resolve-LaTeXAIRuntime -RequirePerl).PerlPath
        $conditions=@()
        $script:Legacy=@{}
        foreach($id in @('off','on')){
            $directory=Join-Path $script:Root "legacy-$id"
            $job=Join-Path $directory 'jobs/paper'
            $nativeFlags=@(if($id -eq 'on'){'--capture'})
            $converted=Invoke-LaTeXAICondition -Article $script:Article -OutDirectory $job -EngineRoot $script:EngineRoot -SourceTree $tree `
                -Entrypoint main.tex -TreeSha256 $source.sha256 -PerlPath $script:Perl -Preload @() -SearchPath @() -IncludeStyles:$false `
                -Kpsewhich:$false -TimeoutSeconds 60 -LatexmlArgument $nativeFlags -ConditionId $id
            if($converted.Condition.status -ne 'ok'){throw ($converted.Condition|ConvertTo-Json -Depth 30)}
            $c=$converted.Condition
            $receipt=@{schema='codex-scientiae/inventory-receipt/0.1';engine='latexai';engineVersion=$c.engine.version;engineCommit=$c.engine.commit
                article=@{directory=$script:Article;slug='paper';treeSha256=$source.sha256};entrypoint='main.tex';status='ok';counts=$c.counts;details=$c.details}
            $null=Write-LaTeXAIFrozenJson (Join-Path $job 'receipt.json') $receipt
            $null=Write-LaTeXAIFrozenJson (Join-Path $directory 'run.json') @{schema='codex-scientiae/inventory-run/0.1';engine='latexai';jobs=1;selectedPaths=@($script:Article)}
            $script:Legacy[$id]=$directory
            $conditions+=@{id="legacy-$id";capture=($id -eq 'on');includeStyles=$false;legacy=@{directory=$directory;rule='receipt-native-fields/1'}}
        }
        # Distinct engine bytes, equal semantics; pinning must not depend on a
        # commit name alone. The fixture is its own small Git repository.
        $alternate=Join-Path $script:Root 'engine'
        [void][IO.Directory]::CreateDirectory($alternate)
        foreach($name in @('lib','bin','lib-ctan')){Copy-Item -LiteralPath (Join-Path $script:EngineRoot $name) -Destination (Join-Path $alternate $name) -Recurse -ProgressAction SilentlyContinue}
        [IO.File]::AppendAllText((Join-Path $alternate 'lib/LaTeXML/Version.pm'),"`n# contrast fixture revision`n",$utf8)
        $null=& git -C $alternate init -q
        $null=& git -C $alternate add lib/LaTeXML/Version.pm
        $null=& git -C $alternate -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm fixture
        if($LASTEXITCODE){throw 'Cannot prepare alternate engine fixture'}
        foreach($prefix in @('baseline','candidate')){foreach($capture in @($false,$true)){
            $row=@{id="$prefix-$(if($capture){'on'}else{'off'})";capture=$capture;includeStyles=$false}
            if($prefix -eq 'candidate'){$row.engineRoot=$alternate}
            $conditions+=$row
        }}
        $conditions+=@{id='styles-on';capture=$false;includeStyles=$true}
        $input=@{schema='latexai/contrast-input/1';conditions=$conditions;comparisons=@(
            @{id='legacy-parity';left='legacy-off';right='legacy-on';mode='parity';required=$true},
            @{id='baseline-parity';left='baseline-off';right='baseline-on';mode='parity';required=$true},
            @{id='candidate-parity';left='candidate-off';right='candidate-on';mode='parity';required=$true},
            @{id='off-regression';left='baseline-off';right='candidate-off';mode='regression';required=$true},
            @{id='on-regression';left='baseline-on';right='candidate-on';mode='regression';required=$true},
            @{id='styles';left='baseline-off';right='styles-on';mode='styles';required=$true})}
        $script:InputPath=Join-Path $script:Root 'input.json'
        $null=Write-LaTeXAIFrozenJson $script:InputPath $input
        $script:Run=Join-Path $script:Root 'run'
        [void][IO.Directory]::CreateDirectory($script:Run)
        $previous=@{}
        foreach($key in @('CDXSCI_TEMP','CDXSCI_JSON_SCRATCH_ROOT','TEMP','TMP','TMPDIR')){$previous[$key]=[Environment]::GetEnvironmentVariable($key)}
        try {
            $null=& (Join-Path $script:EngineRoot 'scripts/gauntlet-run.ps1') -CdxsciRoot $script:RepositoryRoot -Path $script:Article `
                -ExperimentFile $script:InputPath -RunDirectory $script:Run -Preload @() -Kpsewhich:$false -MaxWorkers 1 `
                -NativeTimeoutSeconds 60 -ComparisonTimeoutSeconds 90 -ProcessTimeoutSeconds 2400 -WaitTimeoutSeconds 2700 -ExecutionTimeoutSeconds 2700
        }catch{[IO.File]::WriteAllText((Join-Path $script:Root 'setup-error.txt'),($_|Format-List * -Force|Out-String),$utf8);throw}
        finally{foreach($key in $previous.Keys){[Environment]::SetEnvironmentVariable($key,$previous[$key])}}
        $script:Result=Read-InventoryBatch $script:Run
        $script:Paper=$script:Result.Papers[0]
    }
    It 'runs only declared conditions and edges and qualifies four engine conditions' {
        $script:Result.Record.status | Should -Be 'complete'
        $script:Result.Record.qualification.status | Should -Be 'pass'
        $script:Paper.Record.payload.conditions.Count | Should -Be 7
        $script:Paper.Record.payload.comparisons.Count | Should -Be 6
        @($script:Paper.Record.payload.comparisons.status|Sort-Object -Unique) | Should -Be @('pass')
        $script:Paper.Record.summary.conversionsExecuted | Should -Be 5
        $script:Paper.Record.summary.conversionsImported | Should -Be 2
        $a=@($script:Paper.Record.payload.conditions|Where-Object id -eq 'baseline-off')[0]
        $b=@($script:Paper.Record.payload.conditions|Where-Object id -eq 'candidate-off')[0]
        $a.conversion.identity.engine.lib | Should -Not -Be $b.conversion.identity.engine.lib
    }
    It 'reports style-induced output and package differences as observations' {
        $report=Get-Content (Join-Path $script:Paper.Directory 'comparisons/styles/comparison.json') -Raw|ConvertFrom-Json -AsHashtable
        $report.status | Should -Be 'pass'
        $report.paper.observations | Should -Contain 'paper:non-capture-tree'
        $report.paper.observations | Should -Contain 'paper:package-routes'
        $report.paper.comparison_document_equal | Should -BeFalse
    }
    It 'rejects <Fault> in a same-capture engine regression' -ForEach @(@{Fault='manuscript-change'},@{Fault='extra-option'}) {
        $request=Get-Content (Join-Path $script:Paper.Directory 'comparisons/off-regression.request.json') -Raw|ConvertFrom-Json -AsHashtable
        $xml=Join-Path $script:Paper.Directory $request.right.condition.outputs.xml
        $bytes=[IO.File]::ReadAllBytes($xml)
        try {
            if($Fault -eq 'manuscript-change'){
                [IO.File]::AppendAllText($xml,'<!--regression control-->')
                $artifact=@($request.right.artifacts|Where-Object {$_.path -ceq $request.right.condition.outputs.xml})[0]
                $artifact.sha256=(Get-InventoryFileReference $xml).sha256;$artifact.bytes=(Get-Item $xml).Length
            }else{
                $nativeArguments=@($request.right.condition.details.arguments)
                $request.right.condition.details.arguments=@($nativeArguments[0..($nativeArguments.Count-2)])+@('--quiet',$nativeArguments[-1])
            }
            $path=Join-Path $script:Root "$Fault.request.json"
            $output=Join-Path $script:Root $Fault
            $null=Write-LaTeXAIFrozenJson $path $request
            $run=Invoke-LaTeXAINative -FilePath $script:Perl -WorkingDirectory $script:EngineRoot -TimeoutSeconds 90 `
                -Arguments @('-I','lib','tools/dev/compare-paper.pl',$path,$output)
            $run.ExitCode | Should -Be 1 -Because ($run.StdOut+$run.StdErr)
            $report=Get-Content (Join-Path $output 'comparison.json') -Raw|ConvertFrom-Json -AsHashtable
            $report.issues | Should -Contain ($Fault -eq 'manuscript-change' ? 'paper:non-capture-tree' : 'paper:runtime-invocation')
        }finally{[IO.File]::WriteAllBytes($xml,$bytes)}
    }
    It 'imports raw evidence without claiming native execution or historical engine availability' {
        $conditions=@($script:Paper.Record.payload.conditions|Where-Object {$_.Contains('legacy')})
        foreach($c in $conditions){
            $c.counts.latexmlMs | Should -Be 0
            $c.legacy.nativeDurationMs | Should -BeGreaterThan 0
            $c.legacy.memory.bytes | Should -BeNullOrEmpty
            $c.details.attributionStatus | Should -Be 'unavailable-historical-engine'
            $c.Contains('conversion') | Should -BeFalse
            foreach($pin in @($c.legacy.batch,$c.legacy.receipt)+@($c.legacy.raw)){(Get-InventoryFileReference $pin.path).sha256 | Should -Be $pin.sha256}
        }
        $report=Get-Content (Join-Path $script:Paper.Directory 'comparisons/legacy-parity/comparison.json') -Raw|ConvertFrom-Json -AsHashtable
        $report.paper.after.source_ranges_checked | Should -BeGreaterThan 0
    }
    It 'admits a frozen alternate-engine condition for selective reuse' {
        $reuse=New-LaTeXAIReusePlan $script:Run
        $declared=@($reuse.Plan.specification.conditions|Where-Object id -eq 'candidate-on')[0]
        $freeze=Read-LaTeXAIPinnedJson $declared.freeze
        $parameters=$reuse.Plan.workerParameters|ConvertTo-Json -Depth 30|ConvertFrom-Json -AsHashtable
        $parameters.IncludeStyles=$declared.includeStyles
        $identity=Get-LaTeXAIConversionIdentity $freeze $script:Paper.Record.article $parameters $declared
        $retained=Get-LaTeXAIRetainedCondition $reuse.Specification $script:Paper.Record.article $declared $identity
        $retained.Raw.Count | Should -Be 4
        $retained.Origin.condition | Should -Be 'candidate-on'
        $retained.Origin.freeze.sha256 | Should -Be $declared.freeze.sha256
    }
    It 'keeps unknown cleanup unknown and marks measurement incomplete' {
        $legacy=Join-Path $script:Root 'unknown-cleanup'
        Copy-Item -LiteralPath $script:Legacy.off -Destination $legacy -Recurse -ProgressAction SilentlyContinue
        $receiptPath=Join-Path $legacy 'jobs/paper/receipt.json'
        $receipt=Get-Content $receiptPath -Raw|ConvertFrom-Json -AsHashtable
        $receipt.details.Remove('nativeCleanupComplete')
        [IO.File]::WriteAllText($receiptPath,($receipt|ConvertTo-Json -Depth 100),[Text.UTF8Encoding]::new($false))
        $jobs=@(@{Metadata=@{ArticleIdentity=$script:Identity}})
        $import=New-LaTeXAILegacyImport @{directory=$legacy;rule='receipt-native-fields/1'} $jobs
        $measured=Measure-LaTeXAILegacyCondition @{id='unknown';capture=$false;includeStyles=$false;legacy=$import} $script:Identity (Join-Path $script:Root 'unknown-output')
        $measured.Condition.execution.cleanupComplete | Should -BeNullOrEmpty
        $measured.Condition.status | Should -Be 'failed'
        $measured.Condition.counts.outputBytes | Should -BeGreaterThan 0
        $measured.Condition.legacy.appliedRules -join ' ' | Should -Match 'cleanupComplete'
    }
    It 'rejects changed legacy bytes after pinning' {
        $jobs=@(@{Metadata=@{ArticleIdentity=$script:Identity}})
        $import=New-LaTeXAILegacyImport @{directory=$script:Legacy.off;rule='receipt-native-fields/1'} $jobs
        $path=$import.papers[0].raw[0].path
        $bytes=[IO.File]::ReadAllBytes($path)
        try{[IO.File]::AppendAllText($path,'changed');{Assert-LaTeXAILegacyPins $import $import.papers[0]}|Should -Throw '*Changed legacy raw artifact*'}
        finally{[IO.File]::WriteAllBytes($path,$bytes)}
    }
    It 'rejects duplicate endpoints and undeclared file-taking arguments before dispatch' {
        foreach($kind in @('duplicate','file-option')){
            $input=Get-Content $script:InputPath -Raw|ConvertFrom-Json -AsHashtable
            if($kind -eq 'duplicate'){$input.conditions[1].id=$input.conditions[0].id}else{$input.conditions[0].arguments=@('--path')}
            $path=Join-Path $script:Root "$kind.json"
            $null=Write-LaTeXAIFrozenJson $path $input
            {Read-LaTeXAIContrastInput $path}|Should -Throw
        }
    }
}
