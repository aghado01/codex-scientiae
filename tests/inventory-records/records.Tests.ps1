#requires -Version 7.5
BeforeAll {
    $script:ModuleRoot=Join-Path $PSScriptRoot '../../src/inventory-records'
    Import-Module (Join-Path $script:ModuleRoot 'inventory-records.psm1') -Force
    $script:Utf8=[Text.UTF8Encoding]::new($false)
    function Write-TestJson($Path,$Object) { [IO.File]::WriteAllText($Path,($Object | ConvertTo-Json -Depth 100)+"`n",$script:Utf8) }
    function New-RecordFixture($Root) {
        [void][IO.Directory]::CreateDirectory((Join-Path $Root 'jobs/paper'))
        $worker=Join-Path $Root 'worker.ps1'
        [IO.File]::WriteAllText($worker,'# fixture worker',$script:Utf8)
        $article=[ordered]@{slug='paper';directory=$Root;repositoryRelativePath='paper';sourceTree=$Root;treeSha256=('a'*64);entrypoint='main.tex'}
        $job=[pscustomobject]@{Id='paper';Metadata=@{AttemptId=('b'*64);ArticleIdentity=$article;RunPath=(Join-Path $Root 'jobs/paper/run.json');Engine='example';Worker=$worker}}
        $experiment=Write-InventoryExperiment -RunDirectory $Root -Jobs @($job) -SelectedPaths @($Root)
        $plan=Get-Content -LiteralPath $experiment.path -Raw | ConvertFrom-Json -AsHashtable
        $out=Join-Path $Root 'jobs/paper'
        $artifact=Join-Path $out 'evidence.txt'
        [IO.File]::WriteAllText($artifact,'evidence',$script:Utf8)
        $record=Get-Content -LiteralPath (Join-Path $script:ModuleRoot 'examples/paper-run.json') -Raw | ConvertFrom-Json -AsHashtable
        $record.jobId='paper';$record.attemptId=$job.Metadata.AttemptId;$record.article=$article;$record.experiment=$experiment;$record.producer.worker=$plan.worker
        $record.summary=@{fractionalMs=0.25};$record.artifacts=@(@{path='evidence.txt';sha256=(Get-InventoryFileReference $artifact).sha256;bytes=8})
        $execution=[pscustomobject]@{Results=@([pscustomobject]@{Id='paper';State='Succeeded';ExitCode=0;Errors=@()});Errors=@();Cleanup=[pscustomobject]@{State='Confirmed'};Summary=@{Total=1;Succeeded=1;Failed=0;TimedOut=0;Cancelled=0}}
        Write-TestJson (Join-Path $Root 'executor-execution.json') @{summary=$execution.Summary;cleanup=$execution.Cleanup;errors=@();results=@(@{id='paper';state='Succeeded';exitCode=0;errors=@()})}
        return [pscustomobject]@{Root=$Root;Out=$out;Path=$job.Metadata.RunPath;Record=$record;Execution=$execution;Plan=$plan;Experiment=$experiment;Artifact=$artifact}
    }
}

Describe 'Inventory record ownership and validation' {
    BeforeEach { $f=New-RecordFixture (Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))) }

    It 'validates each serialized contract example' {
        foreach($file in Get-ChildItem -LiteralPath (Join-Path $script:ModuleRoot 'examples') -Filter '*.json') {
            { Assert-InventoryRecord (Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json -AsHashtable) } | Should -Not -Throw
        }
    }

    It 'publishes a hashed worker record and preserves fractional measurements without qualifying acquisition' {
        Write-PaperRun $f.Out $f.Record
        $result=Write-InventoryBatch $f.Root $f.Execution ([datetime]::UtcNow)
        $result.Record.status | Should -Be 'complete'
        $result.Record.qualification.status | Should -Be 'not-requested'
        $result.Record.totals.fractionalMs | Should -Be 0.25
        $read=Read-InventoryBatch $f.Root
        $read.Papers.Count | Should -Be 1
        $read.Papers[0].Reference.sha256 | Should -Be $result.Record.records[0].sha256
        Test-Path -LiteralPath (Join-Path $f.Root 'run.json') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path $f.Out 'receipt.json') | Should -BeFalse
    }

    It 'allows running-to-terminal publication and refuses terminal rewrites' {
        $running=$f.Record | ConvertTo-Json -Depth 100 | ConvertFrom-Json -AsHashtable
        $running.status='running';$running.endedUtc=$null;$running.qualification.status='incomplete'
        Write-PaperRun $f.Out $running
        Write-PaperRun $f.Out $f.Record
        $hash=(Get-InventoryFileReference $f.Path).sha256
        { Write-PaperRun $f.Out $f.Record } | Should -Throw '*Terminal*'
        (Get-InventoryFileReference $f.Path).sha256 | Should -Be $hash
    }

    It 'refuses malformed schema and wrong source ownership before publication' {
        $f.Record.durationMs='unknown'
        { Write-PaperRun $f.Out $f.Record } | Should -Throw
        $f.Record.durationMs=1
        $f.Record.article=$f.Record.article | ConvertTo-Json | ConvertFrom-Json -AsHashtable
        $f.Record.article.slug='another-paper'
        { Write-PaperRun $f.Out $f.Record } | Should -Throw '*Wrong paper identity*'
        Test-Path -LiteralPath $f.Path | Should -BeFalse
    }

    It 'retains <Fault> as incomplete coverage without manufacturing a worker record' -ForEach @(
        @{Fault='missing';Expected='missing'},@{Fault='nonterminal';Expected='nonterminal'},
        @{Fault='malformed';Expected='invalid'},@{Fault='wrong-paper';Expected='invalid'},
        @{Fault='changed-artifact';Expected='invalid'}
    ) {
        if($Fault -ne 'missing') {
            if($Fault -eq 'nonterminal') {$f.Record.status='running';$f.Record.endedUtc=$null;$f.Record.qualification.status='incomplete'}
            Write-PaperRun $f.Out $f.Record
        }
        switch($Fault) {
            'malformed' {[IO.File]::WriteAllText($f.Path,'{}',$script:Utf8)}
            'wrong-paper' {$f.Record.article.slug='wrong';Write-TestJson $f.Path $f.Record}
            'changed-artifact' {[IO.File]::WriteAllText($f.Artifact,'tampered',$script:Utf8)}
        }
        $before=if(Test-Path -LiteralPath $f.Path){(Get-InventoryFileReference $f.Path).sha256}else{$null}
        $result=Write-InventoryBatch $f.Root $f.Execution ([datetime]::UtcNow)
        $result.Record.status | Should -Be 'incomplete'
        $result.Record.coverage[$Expected] | Should -Be 1
        $result.Record.qualification.status | Should -Be 'incomplete'
        if($null -eq $before){Test-Path -LiteralPath $f.Path | Should -BeFalse}
        else{(Get-InventoryFileReference $f.Path).sha256 | Should -Be $before}
    }

    It 'rejects duplicate paper artifacts and an artifact outside its attempt' {
        $f.Record.artifacts[0].path='../evidence.txt'
        { Write-PaperRun $f.Out $f.Record } | Should -Throw '*record-relative path*'
        $f.Record.artifacts[0].path='evidence.txt'
        $f.Record.artifacts+=@($f.Record.artifacts[0])
        { Write-PaperRun $f.Out $f.Record } | Should -Throw '*Duplicate*'
    }

    It 'counts unexpected worker records and rejects executor disagreement' {
        Write-PaperRun $f.Out $f.Record
        [void][IO.Directory]::CreateDirectory((Join-Path $f.Root 'jobs/extra'))
        [IO.File]::Copy($f.Path,(Join-Path $f.Root 'jobs/extra/run.json'))
        $f.Execution.Results[0].State='TimedOut'
        $result=Write-InventoryBatch $f.Root $f.Execution ([datetime]::UtcNow)
        $result.Record.coverage.unexpected | Should -Be 1
        $result.Record.status | Should -Be 'incomplete'
        ($result.Record.issues -join ' ') | Should -Match 'disagrees with executor'
    }

    It 'does not qualify incomplete cleanup' {
        Write-PaperRun $f.Out $f.Record
        $f.Execution.Cleanup.State='Unconfirmed'
        $result=Write-InventoryBatch $f.Root $f.Execution ([datetime]::UtcNow)
        $result.Record.status | Should -Be 'incomplete'
        ($result.Record.issues -join ' ') | Should -Match 'cleanup'
    }

    It 'rejects changed worker record bytes on readback' {
        Write-PaperRun $f.Out $f.Record
        $null=Write-InventoryBatch $f.Root $f.Execution ([datetime]::UtcNow)
        [IO.File]::AppendAllText($f.Path,"`n",$script:Utf8)
        { Read-InventoryBatch $f.Root } | Should -Throw '*Changed artifact*'
    }

    It 'defers artifact bytes only when a stage consumer explicitly requests metadata' {
        Write-PaperRun $f.Out $f.Record
        [IO.File]::WriteAllText($f.Artifact,'changed',$script:Utf8)
        {Read-PaperRun $f.Path $f.Plan.assignments[0] $f.Experiment} | Should -Throw '*Changed artifact*'
        $metadata=Read-PaperRun $f.Path $f.Plan.assignments[0] $f.Experiment -MetadataOnly
        $metadata.Record.artifacts[0].sha256 | Should -Be $f.Record.artifacts[0].sha256
        $f.Record.article.slug='wrong'
        Write-TestJson $f.Path $f.Record
        {Read-PaperRun $f.Path $f.Plan.assignments[0] $f.Experiment -MetadataOnly} | Should -Throw '*Wrong paper identity*'
    }

    It 'rejects a forged <Field> aggregate on readback' -ForEach @(
        @{Field='coverage'},@{Field='totals'},@{Field='summary'},@{Field='executor'},@{Field='qualification'},@{Field='producer'}
    ) {
        Write-PaperRun $f.Out $f.Record
        $result=Write-InventoryBatch $f.Root $f.Execution ([datetime]::UtcNow)
        $batch=$result.Record
        switch($Field){
            'coverage' {$batch.coverage.complete=0;$batch.coverage.failed=1}
            'totals' {$batch.totals.fractionalMs=25}
            'summary' {$batch.records[0].summary.fractionalMs=25}
            'executor' {$batch.records[0].executor.state='TimedOut'}
            'qualification' {$batch.qualification.status='pass'}
            'producer' {$f.Record.producer.engine='other';Write-TestJson $f.Path $f.Record;$batch.records[0].sha256=(Get-InventoryFileReference $f.Path).sha256}
        }
        Write-TestJson $result.Reference.path $batch
        { Read-InventoryBatch $f.Root } | Should -Throw
    }
}
