#requires -Version 7.5
Set-StrictMode -Version Latest
$script:Schema = Join-Path $PSScriptRoot 'inventory-records.schema.json'
$script:Utf8 = [Text.UTF8Encoding]::new($false, $true)

function Get-InventoryFileReference {
    param([Parameter(Mandatory)][string]$Path)
    return [ordered]@{ path = [IO.Path]::GetFullPath($Path); sha256 = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant() }
}

function Read-RecordJson {
    param([string]$Path)
    return ($script:Utf8.GetString([IO.File]::ReadAllBytes($Path)) | ConvertFrom-Json -AsHashtable -DateKind String -ErrorAction Stop)
}

function Assert-InventoryRecord {
    param([Parameter(Mandatory)][System.Collections.IDictionary]$Record)
    $json = $Record | ConvertTo-Json -Depth 100 -Compress
    if (-not (Test-Json -Json $json -SchemaFile $script:Schema -ErrorAction Stop)) { throw 'Invalid inventory record' }
    if ($Record.schema -eq 'codex-scientiae/paper-run/1') {
        if (($Record.status -eq 'running') -ne ($null -eq $Record.endedUtc)) { throw 'Paper terminal status and endedUtc disagree' }
        if ($Record.qualification.status -eq 'pass' -and ($Record.status -ne 'complete' -or $Record.qualification.issues.Count)) { throw 'Invalid passing qualification' }
    }
}

function Resolve-RecordPath {
    param([string]$Root, [string]$Relative)
    if ([IO.Path]::IsPathRooted($Relative) -or $Relative.Contains('\') -or $Relative.Contains(':') -or
            @($Relative.Split('/') | Where-Object { $_ -in @('', '.', '..') }).Count) { throw "Invalid record-relative path: $Relative" }
    $path = [IO.Path]::GetFullPath((Join-Path $Root $Relative))
    $prefix = [IO.Path]::GetFullPath($Root).TrimEnd('\','/') + [IO.Path]::DirectorySeparatorChar
    if (-not $path.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { throw "Record path escapes its owner: $Relative" }
    # Reparse points cannot redirect owned artifacts outside their attempt.
    $cursor = $path
    while ($cursor.Length -gt $prefix.Length) {
        if (Test-Path -LiteralPath $cursor) {
            if ((Get-Item -LiteralPath $cursor -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Reparse point in record path: $Relative" }
        }
        $cursor = [IO.Path]::GetDirectoryName($cursor)
    }
    return $path
}

function Assert-FileReference {
    param([System.Collections.IDictionary]$Reference, [string]$Root = '')
    $path = if ($Root) { Resolve-RecordPath $Root $Reference.path } else { $Reference.path }
    if ((Get-InventoryFileReference $path).sha256 -cne $Reference.sha256) { throw "Changed artifact: $path" }
    if ($Reference.Contains('bytes') -and (Get-Item -LiteralPath $path).Length -ne $Reference.bytes) { throw "Artifact length mismatch: $path" }
}

function Write-RecordAtomic {
    param([string]$Path, [System.Collections.IDictionary]$Record, [switch]$Paper)
    Assert-InventoryRecord $Record
    $directory = [IO.Path]::GetDirectoryName($Path)
    [void][IO.Directory]::CreateDirectory($directory)
    $lock = [IO.File]::Open("$Path.lock", [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    $temporary = "$Path.$([guid]::NewGuid().ToString('N')).tmp"
    try {
        if (Test-Path -LiteralPath $Path) {
            if (-not $Paper) { throw "Terminal record already exists: $Path" }
            $old = Read-RecordJson $Path
            Assert-InventoryRecord $old
            if ($old.status -ne 'running' -or $old.attemptId -cne $Record.attemptId -or $old.experiment.sha256 -cne $Record.experiment.sha256) { throw "Terminal or foreign paper record already exists: $Path" }
        }
        [IO.File]::WriteAllText($temporary, (($Record | ConvertTo-Json -Depth 100) + "`n"), $script:Utf8)
        [IO.File]::Move($temporary, $Path, [bool]$Paper)
    }
    finally {
        if (Test-Path -LiteralPath $temporary) { [IO.File]::Delete($temporary) }
        $lock.Dispose()
    }
}

function Write-InventoryExperiment {
    param([Parameter(Mandatory)][string]$RunDirectory, [Parameter(Mandatory)][object[]]$Jobs,
        [System.Collections.IDictionary]$WorkerParameters = @{}, [System.Collections.IDictionary]$Specification = @{schema='codex-scientiae/acquisition/1'},
        [System.Collections.IDictionary]$Policy = @{requireQualification=$false}, [string[]]$SelectedPaths = @())
    $assignments = @($Jobs | ForEach-Object { [ordered]@{jobId=$_.Id; attemptId=$_.Metadata.AttemptId; article=$_.Metadata.ArticleIdentity; record=([IO.Path]::GetRelativePath($RunDirectory,$_.Metadata.RunPath) -replace '\\','/')} })
    $plan = [ordered]@{
        schema='codex-scientiae/inventory-experiment/1'; engine=$Jobs[0].Metadata.Engine; createdUtc=[datetime]::UtcNow.ToString('o')
        worker=(Get-InventoryFileReference $Jobs[0].Metadata.Worker)
        implementation=@((Get-InventoryFileReference (Join-Path $PSScriptRoot 'inventory-records.psm1')), (Get-InventoryFileReference $script:Schema))
        workerParameters=$WorkerParameters; selectedPaths=@($SelectedPaths); policy=$Policy; specification=$Specification; assignments=$assignments
    }
    Assert-ExperimentAssignments $plan
    $path = Join-Path $RunDirectory 'experiment.json'
    Write-RecordAtomic $path $plan
    return (Get-InventoryFileReference $path)
}

function Assert-ExperimentAssignments {
    param([System.Collections.IDictionary]$Plan)
    Assert-InventoryRecord $Plan
    foreach ($field in @('jobId','attemptId','record')) {
        $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($assignment in $Plan.assignments) { if (-not $seen.Add($assignment[$field])) { throw "Duplicate experiment $field" } }
    }
}

function Get-PaperRunAssignment {
    param([Parameter(Mandatory)][System.Collections.IDictionary]$Context)
    Assert-FileReference $Context.experiment
    $plan = Read-RecordJson $Context.experiment.path
    Assert-ExperimentAssignments $plan
    foreach ($reference in @($plan.worker) + @($plan.implementation)) { Assert-FileReference $reference }
    $matches = @($plan.assignments | Where-Object { $_.jobId -ceq $Context.jobId -and $_.attemptId -ceq $Context.attemptId })
    if ($matches.Count -ne 1) { throw 'Unknown or duplicate paper assignment' }
    return [pscustomobject]@{ Plan=$plan; Assignment=$matches[0]; Experiment=$Context.experiment }
}

function Read-PaperRun {
    param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][System.Collections.IDictionary]$Assignment,
        [Parameter(Mandatory)][System.Collections.IDictionary]$Experiment)
    $record = Read-RecordJson $Path
    Assert-InventoryRecord $record
    $expectedPath = Resolve-RecordPath ([IO.Path]::GetDirectoryName($Experiment.path)) $Assignment.record
    if ([IO.Path]::GetFullPath($Path) -cne $expectedPath) { throw 'Worker record is outside its assigned address' }
    if ($record.schema -cne 'codex-scientiae/paper-run/1' -or $record.jobId -cne $Assignment.jobId -or
            $record.attemptId -cne $Assignment.attemptId -or $record.experiment.path -cne $Experiment.path -or
            $record.experiment.sha256 -cne $Experiment.sha256) { throw 'Wrong paper assignment or experiment' }
    foreach ($key in $Assignment.article.Keys) { if ($record.article[$key] -cne $Assignment.article[$key]) { throw "Wrong paper identity: $key" } }
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($artifact in $record.artifacts) {
        if (-not $seen.Add($artifact.path)) { throw 'Duplicate paper artifact' }
        $null = Resolve-RecordPath ([IO.Path]::GetDirectoryName($Path)) $artifact.path
        if ($record.status -ne 'running') { Assert-FileReference $artifact ([IO.Path]::GetDirectoryName($Path)) }
    }
    return [pscustomobject]@{ Record=$record; Reference=(Get-InventoryFileReference $Path) }
}

function Write-PaperRun {
    param([Parameter(Mandatory)][string]$OutDirectory, [Parameter(Mandatory)][System.Collections.IDictionary]$Record)
    $context = @{experiment=$Record.experiment;jobId=$Record.jobId;attemptId=$Record.attemptId}
    $resolved = Get-PaperRunAssignment $context
    $expected = Resolve-RecordPath ([IO.Path]::GetDirectoryName($Record.experiment.path)) $resolved.Assignment.record
    $path = Join-Path ([IO.Path]::GetFullPath($OutDirectory)) 'run.json'
    if ($path -cne $expected) { throw 'Worker attempted publication outside its assigned record' }
    foreach ($key in $resolved.Assignment.article.Keys) { if ($Record.article[$key] -cne $resolved.Assignment.article[$key]) { throw "Wrong paper identity: $key" } }
    if ($Record.producer.engine -cne $resolved.Plan.engine -or $Record.producer.worker.sha256 -cne $resolved.Plan.worker.sha256 -or
            $Record.producer.worker.path -cne $resolved.Plan.worker.path) { throw 'Wrong paper producer' }
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($artifact in $Record.artifacts) {
        if (-not $seen.Add($artifact.path)) { throw 'Duplicate paper artifact' }
        if ($artifact.path -in @('run.json','run.json.lock')) { throw 'A paper record cannot hash itself' }
        Assert-FileReference $artifact $OutDirectory
    }
    Write-RecordAtomic $path $Record -Paper
}

function Write-InventoryBatch {
    param([Parameter(Mandatory)][string]$RunDirectory, [Parameter(Mandatory)]$Execution,
        [Parameter(Mandatory)][datetime]$StartedUtc)
    $experiment = Get-InventoryFileReference (Join-Path $RunDirectory 'experiment.json')
    $plan = Read-RecordJson $experiment.path
    Assert-ExperimentAssignments $plan
    $issues = [Collections.Generic.List[string]]::new()
    foreach ($reference in @($plan.worker) + @($plan.implementation)) {
        try { Assert-FileReference $reference } catch { $issues.Add($_.Exception.Message) }
    }
    $coverage = [ordered]@{expected=$plan.assignments.Count;complete=0;failed=0;nonterminal=0;missing=0;invalid=0;unexpected=0}
    $rows = [Collections.Generic.List[object]]::new()
    $totals = [ordered]@{}
    $qualifications = [Collections.Generic.List[string]]::new()
    $expectedPaths = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($assignment in $plan.assignments) {
        $path = Resolve-RecordPath $RunDirectory $assignment.record
        [void]$expectedPaths.Add($path)
        $matches = @($Execution.Results | Where-Object { $_.Id -ceq $assignment.jobId })
        $row = [ordered]@{jobId=$assignment.jobId;attemptId=$assignment.attemptId;path=$assignment.record;sha256=$null;state='missing';executor=$null;issues=@();summary=@{}}
        if ($matches.Count -eq 1) {
            $result=$matches[0]
            $row.executor=[ordered]@{state=[string]$result.State;exitCode=$result.ExitCode;errors=@($result.Errors)}
        } else { $row.issues += 'Missing or duplicate executor result' }
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            $row.sha256=(Get-InventoryFileReference $path).sha256
            try {
                $read=Read-PaperRun $path $assignment $experiment
                $record=$read.Record
                if ($record.producer.engine -cne $plan.engine -or $record.producer.worker.sha256 -cne $plan.worker.sha256 -or $record.producer.worker.path -cne $plan.worker.path) { throw 'Wrong paper producer' }
                $row.state=if($record.status -eq 'running'){'nonterminal'}else{$record.status}
                if ($row.state -in @('complete','failed')) {
                    $row.summary=$record.summary
                    foreach($key in $record.summary.Keys) {
                        if(-not $totals.Contains($key)){$totals[$key]=0.0}
                        $totals[$key]+=$record.summary[$key]
                    }
                }
                $qualifications.Add($record.qualification.status)
            } catch { $row.state='invalid';$row.issues += $_.Exception.Message }
        }
        if ($row.state -eq 'complete' -and ($matches.Count -ne 1 -or [string]$matches[0].State -ne 'Succeeded' -or $matches[0].ExitCode -notin @(0,$null))) {
            $row.issues += 'Complete worker record disagrees with executor outcome'
        }
        $coverage[$row.state]++
        foreach($issue in $row.issues){$issues.Add("$($assignment.jobId): $issue")}
        $rows.Add($row)
    }
    $jobsRoot=Join-Path $RunDirectory 'jobs'
    if(Test-Path -LiteralPath $jobsRoot){
        foreach($file in Get-ChildItem -LiteralPath $jobsRoot -Filter run.json -Recurse -File){
            if(-not $expectedPaths.Contains($file.FullName)){$coverage.unexpected++;$issues.Add("Unexpected worker record: $($file.FullName)")}
        }
    }
    foreach($result in $Execution.Results){if($result.Id -cnotin @($plan.assignments.jobId)){$issues.Add("Unexpected executor result: $($result.Id)")}}
    foreach($errorItem in $Execution.Errors){$issues.Add([string]$errorItem)}
    if($null -eq $Execution.Cleanup -or $Execution.Cleanup.State -ne 'Confirmed'){$issues.Add('Executor cleanup is not confirmed')}
    $complete=$coverage.complete -eq $coverage.expected -and $issues.Count -eq 0
    $qualification=if(-not $complete){'incomplete'}elseif(-not $plan.policy.requireQualification){'not-requested'}elseif(@($qualifications | Where-Object {$_ -ne 'pass'}).Count){'fail'}else{'pass'}
    $endedUtc=[datetime]::UtcNow
    $batch=[ordered]@{
        schema='codex-scientiae/inventory-batch/1';engine=$plan.engine;experiment=$experiment
        executor=(Get-InventoryFileReference (Join-Path $RunDirectory 'executor-execution.json'))
        startedUtc=$StartedUtc.ToString('o');endedUtc=$endedUtc.ToString('o');durationMs=($endedUtc-$StartedUtc).TotalMilliseconds
        status=($complete ? 'complete' : 'incomplete');coverage=$coverage;records=$rows.ToArray();totals=$totals;issues=$issues.ToArray()
        qualification=@{status=$qualification;issues=$issues.ToArray()}
    }
    Write-RecordAtomic (Join-Path $RunDirectory 'batch.json') $batch
    return [pscustomobject]@{Record=$batch;Reference=(Get-InventoryFileReference (Join-Path $RunDirectory 'batch.json'))}
}

function Read-InventoryBatch {
    param([Parameter(Mandatory)][string]$RunDirectory)
    $path=Join-Path $RunDirectory 'batch.json'
    $batch=Read-RecordJson $path
    Assert-InventoryRecord $batch
    if($batch.schema -cne 'codex-scientiae/inventory-batch/1'){throw 'Expected inventory batch'}
    Assert-FileReference $batch.experiment
    Assert-FileReference $batch.executor
    $plan=Read-RecordJson $batch.experiment.path
    Assert-ExperimentAssignments $plan
    if ([IO.Path]::GetFullPath($batch.experiment.path) -cne [IO.Path]::GetFullPath((Join-Path $RunDirectory 'experiment.json')) -or
        [IO.Path]::GetFullPath($batch.executor.path) -cne [IO.Path]::GetFullPath((Join-Path $RunDirectory 'executor-execution.json'))) { throw 'Batch references another run' }
    if ($batch.engine -cne $plan.engine) { throw 'Batch engine mismatch' }
    $execution=Read-RecordJson $batch.executor.path
    if($batch.records.Count -ne $plan.assignments.Count -or $batch.coverage.expected -ne $plan.assignments.Count){throw 'Batch coverage mismatch'}
    $records=[Collections.Generic.List[object]]::new()
    $coverage=@{complete=0;failed=0;nonterminal=0;missing=0;invalid=0}
    $totals=@{}
    $qualifications=[Collections.Generic.List[string]]::new()
    $executorComplete=$execution.cleanup.State -eq 'Confirmed' -and @($execution.errors).Count -eq 0 -and @($execution.results).Count -eq $plan.assignments.Count
    foreach($assignment in $plan.assignments){
        $matches=@($batch.records | Where-Object {$_.jobId -ceq $assignment.jobId -and $_.attemptId -ceq $assignment.attemptId -and $_.path -ceq $assignment.record})
        if($matches.Count -ne 1){throw 'Missing or duplicate batch reference'}
        $row=$matches[0]
        $coverage[$row.state]++
        $outcomes=@($execution.results | Where-Object {$_.id -ceq $assignment.jobId})
        if($outcomes.Count -eq 1){
            $outcome=$outcomes[0]
            if($null -eq $row.executor -or $row.executor.state -cne $outcome.state -or $row.executor.exitCode -ne $outcome.exitCode -or
                (ConvertTo-Json -InputObject @($row.executor.errors) -Depth 100 -Compress) -cne (ConvertTo-Json -InputObject @($outcome.errors) -Depth 100 -Compress)){throw 'Batch executor observation mismatch'}
            if($outcome.state -ne 'Succeeded' -or $outcome.exitCode -notin @(0,$null) -or @($outcome.errors).Count){$executorComplete=$false}
        }else{
            $executorComplete=$false
            if($null -ne $row.executor){throw 'Batch invents an executor observation'}
        }
        if($row.state -notin @('complete','failed')){continue}
        $recordPath=Resolve-RecordPath $RunDirectory $row.path
        Assert-FileReference @{path=$recordPath;sha256=$row.sha256}
        $read=Read-PaperRun $recordPath $assignment $batch.experiment
        if($read.Record.status -cne $row.state){throw 'Batch worker state mismatch'}
        if($read.Record.producer.engine -cne $plan.engine -or $read.Record.producer.worker.path -cne $plan.worker.path -or
            $read.Record.producer.worker.sha256 -cne $plan.worker.sha256){throw 'Wrong paper producer'}
        if($row.summary.Count -ne $read.Record.summary.Count){throw 'Batch worker summary mismatch'}
        foreach($key in $read.Record.summary.Keys){
            if(-not $row.summary.Contains($key) -or $row.summary[$key] -ne $read.Record.summary[$key]){throw 'Batch worker summary mismatch'}
            if(-not $totals.ContainsKey($key)){$totals[$key]=0.0}
            $totals[$key]+=$read.Record.summary[$key]
        }
        $qualifications.Add($read.Record.qualification.status)
        $records.Add([pscustomobject]@{Record=$read.Record;Reference=$read.Reference;Directory=[IO.Path]::GetDirectoryName($recordPath)})
    }
    foreach($key in $coverage.Keys){if($batch.coverage[$key] -ne $coverage[$key]){throw 'Batch coverage mismatch'}}
    $expectedPaths=@($plan.assignments | ForEach-Object {Resolve-RecordPath $RunDirectory $_.record})
    $jobsRoot=Join-Path $RunDirectory 'jobs'
    $unexpected=if(Test-Path -LiteralPath $jobsRoot){@(Get-ChildItem -LiteralPath $jobsRoot -Filter run.json -Recurse -File | Where-Object {$_.FullName -notin $expectedPaths}).Count}else{0}
    if($batch.coverage.unexpected -ne $unexpected){throw 'Batch unexpected-record coverage mismatch'}
    if($totals.Count -ne $batch.totals.Count){throw 'Batch totals mismatch'}
    foreach($key in $totals.Keys){if(-not $batch.totals.Contains($key) -or $batch.totals[$key] -ne $totals[$key]){throw 'Batch totals mismatch'}}
    if($batch.status -eq 'complete' -and (-not $executorComplete -or $coverage.complete -ne $plan.assignments.Count -or
        $batch.coverage.unexpected -ne 0 -or $batch.issues.Count -or @($batch.records | Where-Object {$_.issues.Count}).Count)){throw 'Batch falsely claims completion'}
    $qualification=if($batch.status -ne 'complete'){'incomplete'}elseif(-not $plan.policy.requireQualification){'not-requested'}elseif(@($qualifications | Where-Object {$_ -ne 'pass'}).Count){'fail'}else{'pass'}
    if($batch.qualification.status -cne $qualification){throw 'Batch qualification mismatch'}
    return [pscustomobject]@{Record=$batch;Plan=$plan;Reference=(Get-InventoryFileReference $path);Papers=$records.ToArray()}
}

Export-ModuleMember -Function Get-InventoryFileReference, Assert-InventoryRecord, Write-InventoryExperiment, Get-PaperRunAssignment, Read-PaperRun, Write-PaperRun, Write-InventoryBatch, Read-InventoryBatch
