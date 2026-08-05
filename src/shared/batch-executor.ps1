#requires -Version 7.0
<#
  src/shared/batch-executor.ps1 — finite, greedy batch execution over a runspace pool.

  The execution kernel owns scheduling and lifecycle mechanics. The job/plan layer below it normalizes
  caller entrypoints, runtime dependencies, process policy and declared write sets before any work starts.
  Domain adapters still own discovery and domain-specific logging. One PowerShell pipeline is submitted
  per job to a shared runspace pool; the pool therefore assigns the next queued job to whichever runspace
  becomes free instead of pinning static slices to workers.

  Worker script contract (positional so parameter names are documentary):

      param($Item, $Context, $RunspaceState, $CancellationToken)

  Runspace mode registers the worker body in an InitialSessionState and invokes it directly. Context is
  a shared in-process reference and must be treated as read-only. An optional initialization script,
  `param($Context)`, runs once in each pooled runspace and its success output becomes $RunspaceState.
  RunspaceDataPolicy=PerItemCopy trades type fidelity and serialization cost for isolated CLIXML copies
  of each Item and Context; SharedReadOnly is the faster default and makes caller discipline explicit.

  Process mode uses the same outer runspace pool as a greedy supervisor, but starts one clean child pwsh
  per item. Item and Context cross that process boundary through CLIXML; they are copies and custom types
  may return as Deserialized.* objects. Modules and the optional initialization script are loaded inside
  every child process. The parent keeps a concurrent registry of live children and kills process trees on
  cancellation, timeout, Ctrl+C, or exceptional teardown; it never waits for an orphan's own timeout.
  Process launch policy includes executable, working directory, environment overlay, profile loading,
  window/no-window behavior, priority and timeout. CODEX_BATCH_JOB_ID is injected for logging correlation;
  inherited CODEX_RUNLOG_* variables naturally connect child-local log files to the parent run.

  BeginInvoke is the internal asynchronous mechanism: all item pipelines are queued without blocking and
  the pool greedily schedules them. Invoke-BatchExecutor deliberately remains a synchronous finite-batch
  join. A caller-owned CancellationToken provides external cancellation without introducing a second job
  registry or detached-work lifecycle.

  Mixed mode lets RunspaceScript and PowerShellProcess jobs share that same greedy worker budget. A
  compiled BatchPlan dispatches higher estimated-cost jobs first to reduce long-tail idle time, then
  restores results to original plan order. It rejects duplicate ids, missing entrypoints or modules,
  incompatible direct runspace profiles, malformed child policies and exact/ancestor write collisions.
  One direct runtime profile maps to one InitialSessionState; process jobs carry their own ProcessSpec and
  job-local dependencies. Thin test and ingestion adapters should emit New-BatchJob records and stop there.

  WaitTimeoutSeconds is an optional total-batch ceiling. Stopping a direct runspace pipeline is cooperative;
  Process mode should additionally use ProcessTimeoutSeconds so external work receives a process-tree kill.

  Item failures are result data: they never abort or cancel sibling items. Results are always index-stable
  and contain per-item Output/Errors/Warnings plus timing and execution identity. An item.Id property is
  used when present; otherwise a deterministic batch-NNNN id is assigned.

    $run = Invoke-BatchExecutor -InputObject $jobs -ScriptPath ./worker.ps1 -ExecutionMode Runspace
    $run = Invoke-BatchExecutor -InputObject $jobs -ScriptPath ./worker.ps1 -ExecutionMode Process `
                                -MaxWorkers 4 -ProcessTimeoutSeconds 900

    $jobs = @(
        New-BatchJob -Id test-a -Kind RunspaceScript -EntryPoint ./run-test.ps1 -ArgumentList test-a
        New-BatchJob -Id doc-a -Kind PowerShellProcess -EntryPoint ./ingest.ps1 `
            -Parameters @{ Path = './paper.tex' } -Writes ./output/paper
    )
    $compiled = Compile-BatchPlan $jobs
    $run = Invoke-BatchPlan $compiled -MaxWorkers 4
#>

$script:BatchExecutorDirectDispatcher = @'
param($Item, $Context, [System.Threading.CancellationToken] $CancellationToken)

$started = [datetime]::UtcNow
$failure = $null
$output = @()
$state = 'Succeeded'

if ($CancellationToken.IsCancellationRequested) {
    $state = 'Cancelled'
}
else { try {
    if ($script:BatchExecutorRunspaceInitialized -ne $true) {
        $initializerOutput = @(Invoke-BatchRunspaceInitializer $Context)
        $script:BatchExecutorRunspaceState = if ($initializerOutput.Count -eq 0) { $null }
            elseif ($initializerOutput.Count -eq 1) { $initializerOutput[0] }
            else { $initializerOutput }
        $script:BatchExecutorRunspaceInitialized = $true
    }

    $output = @(Invoke-BatchWorkItem $Item $Context $script:BatchExecutorRunspaceState $CancellationToken)
    if ($CancellationToken.IsCancellationRequested) { $state = 'Cancelled' }
}
catch {
    if ($CancellationToken.IsCancellationRequested) { $state = 'Cancelled' }
    else { $failure = $_.ToString(); $state = 'Failed' }
} }

$ended = [datetime]::UtcNow
[pscustomobject]@{
    Output      = $output
    Failure     = $failure
    State       = $state
    StartedUtc  = $started
    EndedUtc    = $ended
    RunspaceId  = [System.Management.Automation.Runspaces.Runspace]::DefaultRunspace.InstanceId.ToString()
    ThreadId    = [System.Environment]::CurrentManagedThreadId
    ProcessId   = $PID
}
'@

$script:BatchExecutorProcessDispatcher = @'
param(
    [string] $JobId,
    [string] $PayloadXml,
    [string] $PowerShellPath,
    [string] $WorkingDirectory,
    [string] $EncodedChildCommand,
    [int] $ProcessTimeoutSeconds,
    [bool] $CreateNoWindow,
    [string] $WindowStyle,
    [bool] $LoadProfile,
    [System.Collections.IDictionary] $ProcessEnvironment,
    [string] $PriorityClass,
    [System.Collections.Concurrent.ConcurrentDictionary[string, System.Diagnostics.Process]] $ProcessRegistry,
    [System.Threading.CancellationToken] $CancellationToken
)

$started = [datetime]::UtcNow
$process = $null
$failure = $null
$state = 'Failed'
$output = @()
$childErrors = @()
$childWarnings = @()
$stdoutLines = @()
$stderrLines = @()
$exitCode = $null
$childProcessId = $null
$prefix = 'BATCH-EXECUTOR-RESULT '
$registered = $false

if ($CancellationToken.IsCancellationRequested) {
    $state = 'Cancelled'
    $childWarnings = @('cancellation requested before child process start')
}
else { try {
    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $PowerShellPath
    $startInfo.WorkingDirectory = $WorkingDirectory
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $CreateNoWindow
    $startInfo.WindowStyle = [System.Enum]::Parse([System.Diagnostics.ProcessWindowStyle], $WindowStyle, $true)
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    foreach ($key in @($ProcessEnvironment.Keys)) {
        $name = [string]$key
        $value = $ProcessEnvironment[$key]
        if ($null -eq $value) { [void]$startInfo.Environment.Remove($name) }
        else { $startInfo.Environment[$name] = [string]$value }
    }
    $startInfo.Environment['CODEX_BATCH_JOB_ID'] = $JobId
    $startInfo.Environment['CODEX_BATCH_EXECUTION_MODE'] = 'Process'
    [void] $startInfo.ArgumentList.Add('-NoLogo')
    if (-not $LoadProfile) { [void] $startInfo.ArgumentList.Add('-NoProfile') }
    [void] $startInfo.ArgumentList.Add('-NonInteractive')
    [void] $startInfo.ArgumentList.Add('-EncodedCommand')
    [void] $startInfo.ArgumentList.Add($EncodedChildCommand)

    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    if (-not $process.Start()) { throw "failed to start child PowerShell: $PowerShellPath" }
    $childProcessId = $process.Id
    if (-not $ProcessRegistry.TryAdd($JobId, $process)) {
        try { $process.Kill($true) } catch {}
        throw "live child registry already contains job id '$JobId'"
    }
    $registered = $true

    if ($PriorityClass -ne 'Normal') {
        try {
            $process.PriorityClass = [System.Enum]::Parse(
                [System.Diagnostics.ProcessPriorityClass], $PriorityClass, $true)
        }
        catch { $childWarnings += "could not set child priority '$PriorityClass': $($_.Exception.Message)" }
    }

    # Cancellation can race process start. Registration precedes the second check so either this
    # dispatcher or the parent registry sweep owns an immediately killable process reference.
    if ($CancellationToken.IsCancellationRequested) {
        try { $process.Kill($true) } catch {}
    }

    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.StandardInput.Write($payloadXml)
    $process.StandardInput.Close()

    $completed = if ($ProcessTimeoutSeconds -gt 0) {
        $waitMs = [math]::Min([int64]::MaxValue, [int64]$ProcessTimeoutSeconds * 1000)
        $process.WaitForExit([int][math]::Min([int]::MaxValue, $waitMs))
    }
    else {
        $process.WaitForExit()
        $true
    }

    if ($CancellationToken.IsCancellationRequested) {
        if (-not $process.HasExited) { try { $process.Kill($true) } catch {} }
        try { $process.WaitForExit() } catch {}
        $state = 'Cancelled'
        $childWarnings += 'cancellation requested; child process tree terminated'
    }
    elseif (-not $completed) {
        try { $process.Kill($true) } catch {}
        try { $process.WaitForExit() } catch {}
        $state = 'TimedOut'
        $failure = "child process exceeded timeout of $ProcessTimeoutSeconds second(s)"
    }

    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    $exitCode = if ($process.HasExited) { $process.ExitCode } else { $null }

    $stdoutList = [System.Collections.Generic.List[string]]::new()
    $stderrList = [System.Collections.Generic.List[string]]::new()
    $marker = $null
    foreach ($line in @($stdout -split '\r?\n')) {
        if ($line.Length -eq 0) { continue }
        if ($line.StartsWith($prefix, [System.StringComparison]::Ordinal)) { $marker = $line }
        else { $stdoutList.Add($line) }
    }
    foreach ($line in @($stderr -split '\r?\n')) {
        if ($line.Length -gt 0) { $stderrList.Add($line) }
    }
    $stdoutLines = $stdoutList.ToArray()
    $stderrLines = $stderrList.ToArray()

    if ($state -notin @('Cancelled', 'TimedOut') -and $null -ne $marker) {
        $wireBytes = [System.Convert]::FromBase64String($marker.Substring($prefix.Length))
        $wireXml = [System.Text.Encoding]::UTF8.GetString($wireBytes)
        $wire = [System.Management.Automation.PSSerializer]::Deserialize($wireXml)
        $output = @($wire.Output)
        $childErrors = @($wire.Errors)
        $childWarnings = @($wire.Warnings)
        $failure = if ($wire.Failure) { [string]$wire.Failure } else { $null }
        $state = if ([bool]$wire.Succeeded -and $exitCode -eq 0) { 'Succeeded' } else { 'Failed' }
    }
    elseif ($state -notin @('Cancelled', 'TimedOut')) {
        # A worker may intentionally call exit (Pester runners commonly do). In that case the
        # wrapper cannot emit its structured marker, so the native exit code remains authoritative.
        $output = $stdoutLines
        $state = if ($exitCode -eq 0) { 'Succeeded' } else { 'Failed' }
        if ($state -eq 'Failed') {
            $failure = "child PowerShell exited with code $exitCode without a structured result"
        }
    }

    if ($stderrLines.Count -gt 0) {
        if ($state -in @('Succeeded', 'Cancelled')) { $childWarnings += $stderrLines }
        else { $childErrors += $stderrLines }
    }
}
catch {
    if ($CancellationToken.IsCancellationRequested) {
        $state = 'Cancelled'
        $childWarnings += 'cancellation requested during child process setup'
    }
    else { $failure = $_.ToString(); $state = 'Failed' }
}
finally {
    if ($registered) {
        [System.Diagnostics.Process] $removedProcess = $null
        [void] $ProcessRegistry.TryRemove($JobId, [ref]$removedProcess)
    }
    if ($null -ne $process) { $process.Dispose() }
} }

$ended = [datetime]::UtcNow
[pscustomobject]@{
    Output      = @($output)
    Failure     = $failure
    State       = $state
    Errors      = @($childErrors)
    Warnings    = @($childWarnings)
    StdOut      = @($stdoutLines)
    StdErr      = @($stderrLines)
    ExitCode    = $exitCode
    StartedUtc  = $started
    EndedUtc    = $ended
    RunspaceId  = [System.Management.Automation.Runspaces.Runspace]::DefaultRunspace.InstanceId.ToString()
    ThreadId    = [System.Environment]::CurrentManagedThreadId
    ProcessId   = $childProcessId
}
'@

$script:BatchExecutorChildCommand = @'
$ErrorActionPreference = 'Continue'
$prefix = 'BATCH-EXECUTOR-RESULT '
$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$output = [System.Collections.Generic.List[object]]::new()
$failure = $null
$succeeded = $false

try {
    $payloadXml = [Console]::In.ReadToEnd()
    $payload = [System.Management.Automation.PSSerializer]::Deserialize($payloadXml)

    $events = @(& {
        foreach ($module in @($payload.ModulePath)) {
            if (-not [string]::IsNullOrWhiteSpace([string]$module)) {
                Import-Module -Name ([string]$module) -ErrorAction Stop
            }
        }

        $initializerOutput = if ($payload.InitializationScriptPath) {
            @(& ([string]$payload.InitializationScriptPath) $payload.Context)
        }
        else { @() }
        $runspaceState = if ($initializerOutput.Count -eq 0) { $null }
            elseif ($initializerOutput.Count -eq 1) { $initializerOutput[0] }
            else { $initializerOutput }

        & ([string]$payload.ScriptPath) $payload.Item $payload.Context $runspaceState
    } *>&1)

    foreach ($event in $events) {
        if ($event -is [System.Management.Automation.ErrorRecord]) {
            $errors.Add($event.ToString())
        }
        elseif ($event -is [System.Management.Automation.WarningRecord]) {
            $warnings.Add($event.Message)
        }
        elseif ($event -is [System.Management.Automation.InformationRecord] -or
                $event -is [System.Management.Automation.VerboseRecord] -or
                $event -is [System.Management.Automation.DebugRecord]) {
            # Diagnostic streams are intentionally not promoted to success output.
        }
        else {
            $output.Add($event)
        }
    }

    $succeeded = ($errors.Count -eq 0)
}
catch {
    $failure = $_.ToString()
}

$wire = [pscustomobject]@{
    Succeeded = ($succeeded -and -not $failure)
    Output    = $output.ToArray()
    Errors    = $errors.ToArray()
    Warnings  = $warnings.ToArray()
    Failure   = $failure
}
$depth = if ($payload -and $payload.SerializationDepth) { [int]$payload.SerializationDepth } else { 12 }
$wireXml = [System.Management.Automation.PSSerializer]::Serialize($wire, $depth)
$wireBytes = [System.Text.Encoding]::UTF8.GetBytes($wireXml)
[Console]::Out.WriteLine($prefix + [System.Convert]::ToBase64String($wireBytes))

if (-not $wire.Succeeded) { exit 1 }
'@

function Get-BatchExecutorScriptDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Role,
        [switch] $RejectRequires
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "batch executor $Role script not found: '$Path'"
    }

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $resolved, [ref]$tokens, [ref]$parseErrors)

    if ($parseErrors.Count -gt 0) {
        throw "batch executor $Role script does not parse: $($parseErrors[0].Message)"
    }
    if ($null -eq $ast.ParamBlock) {
        throw "batch executor $Role script must begin with a top-level param(...) block"
    }
    if ($RejectRequires -and $null -ne $ast.ScriptRequirements) {
        throw "batch executor $Role script must not declare #Requires in Runspace mode; the executor owns its InitialSessionState"
    }

    [pscustomobject]@{
        Path = $resolved
        Body = [System.IO.File]::ReadAllText($resolved)
    }
}

function Resolve-BatchWorkerBudget {
    <# Pure worker-count policy. Explicit MaxWorkers is not CPU-clamped: subprocess and I/O jobs may
       legitimately use more workers than logical cores. Auto mode reserves cores. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateRange(0, [int]::MaxValue)] [int] $ItemCount,
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1
    )

    if ($null -ne $MaxWorkers -and $MaxWorkers -lt 1) { throw 'MaxWorkers must be at least 1 when specified' }

    $logical = [math]::Max(1, [Environment]::ProcessorCount)
    $warnings = [System.Collections.Generic.List[string]]::new()

    if ($ItemCount -eq 0) {
        return [pscustomobject]@{
            Threads = 0; Policy = if ($null -eq $MaxWorkers) { 'Auto' } else { 'Explicit' }
            Warnings = @(); Inputs = [pscustomobject]@{
                ItemCount = 0; MaxWorkers = $MaxWorkers; ReservedCores = $ReservedCores
                MinItemsPerWorker = $MinItemsPerWorker; LogicalCores = $logical
            }
        }
    }

    if ($null -ne $MaxWorkers) {
        $policy = 'Explicit'
        # PowerShell unwraps Nullable[int] parameters to Int32 when a value is supplied.
        $ceiling = [int]$MaxWorkers
        if ($ceiling -gt $logical) {
            $warnings.Add("MaxWorkers ($ceiling) exceeds logical core count ($logical); retaining the explicit value for I/O or subprocess workloads.")
        }
    }
    else {
        $policy = 'Auto'
        $reserved = [math]::Min($ReservedCores, $logical - 1)
        $ceiling = [math]::Max(1, $logical - $reserved)
    }

    $graded = [math]::Max(1, [int][math]::Ceiling($ItemCount / $MinItemsPerWorker))
    $threads = [math]::Min($ItemCount, [math]::Min($ceiling, $graded))

    [pscustomobject]@{
        Threads = $threads
        Policy = $policy
        Warnings = $warnings.ToArray()
        Inputs = [pscustomobject]@{
            ItemCount = $ItemCount; MaxWorkers = $MaxWorkers; ReservedCores = $ReservedCores
            MinItemsPerWorker = $MinItemsPerWorker; LogicalCores = $logical
        }
    }
}

function Get-BatchExecutorPropertyValue {
    param($Object, [Parameter(Mandatory)] [string] $Name, $Default = $null)
    if ($null -eq $Object) { return $Default }
    if ($Object -is [System.Collections.IDictionary] -and $Object.Contains($Name)) {
        return $Object[$Name]
    }
    $property = $Object.PSObject.Properties[$Name]
    if ($null -ne $property) { return $property.Value }
    return $Default
}

function New-BatchExecutorSessionState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateSet('Runspace', 'Process', 'Mixed')] [string] $ExecutionMode,
        [ValidateSet('Bare', 'Core', 'Full')] [string] $IssPreset = 'Core',
        [string[]] $ModulePath = @(),
        [string] $WorkerBody,
        [string] $InitializerBody
    )

    $iss = switch ($IssPreset) {
        'Bare' { [System.Management.Automation.Runspaces.InitialSessionState]::Create() }
        'Full' { [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault() }
        default { [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2() }
    }

    if ($ExecutionMode -in @('Runspace', 'Mixed')) {
        foreach ($module in $ModulePath) {
            if (-not [string]::IsNullOrWhiteSpace($module)) { $iss.ImportPSModule($module) }
        }
        $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
            'Invoke-BatchWorkItem', $WorkerBody))
        if (-not [string]::IsNullOrWhiteSpace($InitializerBody)) {
            $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
                'Invoke-BatchRunspaceInitializer', $InitializerBody))
        }
        else {
            $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
                'Invoke-BatchRunspaceInitializer', 'param($Context)'))
        }
        $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
            'Invoke-BatchDirectDispatcher', $script:BatchExecutorDirectDispatcher))
    }
    if ($ExecutionMode -in @('Process', 'Mixed')) {
        $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
            'Invoke-BatchProcessDispatcher', $script:BatchExecutorProcessDispatcher))
    }

    return $iss
}

function Stop-BatchExecutorChildProcesses {
    <# Parent-owned teardown primitive. Never disposes Process objects while dispatcher runspaces may
       still be reading them; dispatchers remove and dispose their own entries in finally blocks. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Concurrent.ConcurrentDictionary[string, System.Diagnostics.Process]] $Registry,
        [string] $Reason = 'batch teardown',
        [System.Collections.Generic.List[string]] $Diagnostics
    )

    foreach ($entry in $Registry.ToArray()) {
        try {
            if (-not $entry.Value.HasExited) { $entry.Value.Kill($true) }
        }
        catch {
            if ($null -ne $Diagnostics) {
                $Diagnostics.Add("could not terminate child for item '$($entry.Key)' during ${Reason}: $($_.Exception.Message)")
            }
        }
    }
}

function Invoke-BatchExecutor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [AllowEmptyCollection()] [object[]] $InputObject,
        [Parameter(Mandatory)] [string] $ScriptPath,
        [ValidateSet('Runspace', 'Process', 'Mixed')] [string] $ExecutionMode = 'Runspace',
        [string] $ExecutionModeProperty = 'ExecutionMode',
        [string] $ProcessSpecProperty = 'ProcessSpec',
        [object] $Context = $null,
        [string] $InitializationScriptPath,
        [string[]] $ModulePath = @(),
        [ValidateSet('Bare', 'Core', 'Full')] [string] $IssPreset = 'Core',
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
        [string] $IdProperty = 'Id',
        [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
        [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [System.Threading.CancellationToken] $CancellationToken = [System.Threading.CancellationToken]::None,
        [ValidateSet('SharedReadOnly', 'PerItemCopy')] [string] $RunspaceDataPolicy = 'SharedReadOnly',
        [string] $PowerShellPath,
        [string] $WorkingDirectory = (Get-Location).Path,
        [System.Collections.IDictionary] $ProcessEnvironment = @{},
        [bool] $CreateNoWindow = $true,
        [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')] [string] $WindowStyle = 'Hidden',
        [switch] $LoadProfile,
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')] [string] $PriorityClass = 'Normal'
    )

    $swTotal = [System.Diagnostics.Stopwatch]::StartNew()
    $workerDefinition = Get-BatchExecutorScriptDefinition -Path $ScriptPath -Role worker `
        -RejectRequires:($ExecutionMode -ne 'Process')
    $initializerDefinition = if ($InitializationScriptPath) {
        Get-BatchExecutorScriptDefinition -Path $InitializationScriptPath -Role initializer `
            -RejectRequires:($ExecutionMode -ne 'Process')
    }
    else { $null }

    $count = $InputObject.Count
    $itemModes = [string[]]::new($count)
    $hasProcessJobs = $false
    $hasRunspaceJobs = $false
    for ($i = 0; $i -lt $count; $i++) {
        $mode = if ($ExecutionMode -eq 'Mixed') {
            [string](Get-BatchExecutorPropertyValue -Object $InputObject[$i] -Name $ExecutionModeProperty)
        }
        else { $ExecutionMode }
        if ($mode -notin @('Runspace', 'Process')) {
            throw "batch executor item [$i] has invalid execution mode '$mode' (expected Runspace or Process)"
        }
        $itemModes[$i] = $mode
        if ($mode -eq 'Process') { $hasProcessJobs = $true } else { $hasRunspaceJobs = $true }
    }

    if (-not (Test-Path -LiteralPath $WorkingDirectory -PathType Container)) {
        throw "batch executor working directory not found: '$WorkingDirectory'"
    }
    $resolvedWorkingDirectory = (Resolve-Path -LiteralPath $WorkingDirectory).Path

    # Freeze launch environment before any runspace reads it. Multiple concurrent reads are safe;
    # caller mutations after Invoke-BatchExecutor begins cannot race ProcessStartInfo construction.
    $processEnvironmentSnapshot = @{}
    if ($null -ne $ProcessEnvironment) { foreach ($key in @($ProcessEnvironment.Keys)) {
        $processEnvironmentSnapshot[[string]$key] = $ProcessEnvironment[$key]
    } }

    if ($hasProcessJobs) {
        if (-not $PowerShellPath) {
            $candidate = Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })
            $PowerShellPath = if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                (Resolve-Path -LiteralPath $candidate).Path
            }
            else {
                (Get-Command pwsh -ErrorAction Stop).Source
            }
        }
        if (-not (Test-Path -LiteralPath $PowerShellPath -PathType Leaf)) {
            throw "batch executor child PowerShell not found: '$PowerShellPath'"
        }
        $PowerShellPath = (Resolve-Path -LiteralPath $PowerShellPath).Path
    }

    # Resolve every child launch specification on the parent thread. This both validates policy
    # before work begins and prevents worker runspaces from walking caller-owned job objects.
    $effectiveProcessSpecs = [object[]]::new($count)
    if ($hasProcessJobs) {
        for ($i = 0; $i -lt $count; $i++) {
            if ($itemModes[$i] -ne 'Process') { continue }

            $rawSpec = Get-BatchExecutorPropertyValue -Object $InputObject[$i] -Name $ProcessSpecProperty
            $itemPowerShellPath = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'PowerShellPath' -Default $PowerShellPath)
            $itemWorkingDirectory = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'WorkingDirectory' -Default $resolvedWorkingDirectory)
            $itemTimeout = [int](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'TimeoutSeconds' -Default $ProcessTimeoutSeconds)
            $itemCreateNoWindow = [bool](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'CreateNoWindow' -Default $CreateNoWindow)
            $itemWindowStyle = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'WindowStyle' -Default $WindowStyle)
            $itemLoadProfile = [bool](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'LoadProfile' -Default ([bool]$LoadProfile))
            $itemPriorityClass = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'PriorityClass' -Default $PriorityClass)

            if (-not (Test-Path -LiteralPath $itemPowerShellPath -PathType Leaf)) {
                throw "batch executor item [$i] child PowerShell not found: '$itemPowerShellPath'"
            }
            if (-not (Test-Path -LiteralPath $itemWorkingDirectory -PathType Container)) {
                throw "batch executor item [$i] working directory not found: '$itemWorkingDirectory'"
            }
            if ($itemTimeout -lt 0) { throw "batch executor item [$i] timeout must not be negative" }
            if ($itemWindowStyle -notin @('Hidden', 'Normal', 'Minimized', 'Maximized')) {
                throw "batch executor item [$i] has invalid window style '$itemWindowStyle'"
            }
            if ($itemPriorityClass -notin @('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')) {
                throw "batch executor item [$i] has invalid priority class '$itemPriorityClass'"
            }

            $itemEnvironment = @{}
            foreach ($key in @($processEnvironmentSnapshot.Keys)) {
                $itemEnvironment[[string]$key] = $processEnvironmentSnapshot[$key]
            }
            $environmentOverride = Get-BatchExecutorPropertyValue -Object $rawSpec -Name 'Environment'
            if ($null -ne $environmentOverride) {
                if ($environmentOverride -isnot [System.Collections.IDictionary]) {
                    throw "batch executor item [$i] process environment must be a dictionary"
                }
                foreach ($key in @($environmentOverride.Keys)) {
                    $itemEnvironment[[string]$key] = $environmentOverride[$key]
                }
            }

            $effectiveProcessSpecs[$i] = [pscustomobject]@{
                PowerShellPath = (Resolve-Path -LiteralPath $itemPowerShellPath).Path
                WorkingDirectory = (Resolve-Path -LiteralPath $itemWorkingDirectory).Path
                TimeoutSeconds = $itemTimeout
                CreateNoWindow = $itemCreateNoWindow
                WindowStyle = $itemWindowStyle
                LoadProfile = $itemLoadProfile
                Environment = $itemEnvironment
                PriorityClass = $itemPriorityClass
            }
        }
    }

    $policy = [pscustomobject]@{
        FailureAction = 'Continue'
        ExecutionMode = $ExecutionMode
        RunspaceData = if (-not $hasRunspaceJobs) { 'SerializedCopy' }
            elseif ($hasProcessJobs) { "$RunspaceDataPolicy (Runspace); SerializedCopy (Process)" }
            else { $RunspaceDataPolicy }
        Cancellation = 'CallerTokenAndTimeout'
        ChildProcess = if ($hasProcessJobs) {
            [pscustomobject]@{
                PowerShellPath = $PowerShellPath; WorkingDirectory = $resolvedWorkingDirectory
                CreateNoWindow = $CreateNoWindow; WindowStyle = $WindowStyle; LoadProfile = [bool]$LoadProfile
                PriorityClass = $PriorityClass; TimeoutSeconds = $ProcessTimeoutSeconds
                EnvironmentKeys = [string[]]@($processEnvironmentSnapshot.Keys | Sort-Object)
            }
        }
        else { $null }
    }

    $budget = Resolve-BatchWorkerBudget -ItemCount $count -MaxWorkers $MaxWorkers `
        -ReservedCores $ReservedCores -MinItemsPerWorker $MinItemsPerWorker

    if ($count -eq 0) {
        return [pscustomobject]@{
            Results = [object[]]::new(0); Errors = @(); Warnings = @($budget.Warnings)
            Budget = $budget; Timing = [pscustomobject]@{ TotalMs = $swTotal.ElapsedMilliseconds }
            Policy = $policy
            Summary = [pscustomobject]@{ Total = 0; Succeeded = 0; Failed = 0; TimedOut = 0; Cancelled = 0 }
        }
    }

    # Resolve correlation ids before opening the pool. Duplicate caller ids are a planning error,
    # because logs and domain artifacts commonly key off them even though the executor does not.
    $ids = [string[]]::new($count)
    $seenIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    for ($i = 0; $i -lt $count; $i++) {
        $item = $InputObject[$i]
        $id = $null
        if ($null -ne $item -and $item -is [System.Collections.IDictionary] -and $item.Contains($IdProperty)) {
            $id = [string]$item[$IdProperty]
        }
        elseif ($null -ne $item) {
            $property = $item.PSObject.Properties[$IdProperty]
            if ($null -ne $property) { $id = [string]$property.Value }
        }
        if ([string]::IsNullOrWhiteSpace($id)) { $id = 'batch-{0:d4}' -f $i }
        if (-not $seenIds.Add($id)) { throw "batch executor duplicate item id: '$id'" }
        $ids[$i] = $id
    }

    $iss = New-BatchExecutorSessionState -ExecutionMode $ExecutionMode -IssPreset $IssPreset `
        -ModulePath $ModulePath -WorkerBody $workerDefinition.Body `
        -InitializerBody $(if ($initializerDefinition) { $initializerDefinition.Body } else { $null })

    $pool = $null
    $invocations = [System.Collections.Generic.List[hashtable]]::new($count)
    $ordered = [object[]]::new($count)
    $infrastructureErrors = [System.Collections.Generic.List[string]]::new()
    $processRegistry = [System.Collections.Concurrent.ConcurrentDictionary[string, System.Diagnostics.Process]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    $timing = @{}
    $completedNormally = $false
    $serializedContext = if ($hasRunspaceJobs -and $RunspaceDataPolicy -eq 'PerItemCopy') {
        [System.Management.Automation.PSSerializer]::Serialize($Context, $SerializationDepth)
    }
    else { $null }

    try {
        $swPool = [System.Diagnostics.Stopwatch]::StartNew()
        $pool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool($iss)
        [void] $pool.SetMinRunspaces(1)
        [void] $pool.SetMaxRunspaces($budget.Threads)
        $pool.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::UseNewThread
        $pool.ApartmentState = [System.Threading.ApartmentState]::MTA
        $pool.Open()
        $timing.PoolOpenMs = $swPool.ElapsedMilliseconds

        $childCommandBytes = [System.Text.Encoding]::Unicode.GetBytes($script:BatchExecutorChildCommand)
        $encodedChildCommand = [System.Convert]::ToBase64String($childCommandBytes)

        $swDispatch = [System.Diagnostics.Stopwatch]::StartNew()
        for ($i = 0; $i -lt $count; $i++) {
            $ps = [System.Management.Automation.PowerShell]::Create()
            $ps.RunspacePool = $pool
            if ($itemModes[$i] -eq 'Runspace') {
                $dispatchItem = $InputObject[$i]
                $dispatchContext = $Context
                if ($RunspaceDataPolicy -eq 'PerItemCopy') {
                    $itemXml = [System.Management.Automation.PSSerializer]::Serialize($InputObject[$i], $SerializationDepth)
                    $dispatchItem = [System.Management.Automation.PSSerializer]::Deserialize($itemXml)
                    $dispatchContext = [System.Management.Automation.PSSerializer]::Deserialize($serializedContext)
                }
                $command = $ps.AddCommand('Invoke-BatchDirectDispatcher')
                [void] $command.AddArgument($dispatchItem)
                [void] $command.AddArgument($dispatchContext)
                [void] $command.AddArgument($CancellationToken)
            }
            else {
                $processSpec = $effectiveProcessSpecs[$i]
                # Serialize on the parent thread. Worker runspaces never traverse caller-owned object
                # graphs concurrently; the child receives an immutable snapshot of this submission.
                $payload = [pscustomobject]@{
                    ScriptPath = $workerDefinition.Path
                    InitializationScriptPath = if ($ExecutionMode -eq 'Process' -and $initializerDefinition) {
                        $initializerDefinition.Path
                    }
                    else { $null }
                    ModulePath = if ($ExecutionMode -eq 'Process') { [string[]]@($ModulePath) }
                        else { [string[]]@() }
                    Item = $InputObject[$i]
                    Context = $Context
                    SerializationDepth = $SerializationDepth
                }
                $payloadXml = [System.Management.Automation.PSSerializer]::Serialize($payload, $SerializationDepth)
                $command = $ps.AddCommand('Invoke-BatchProcessDispatcher')
                [void] $command.AddArgument($ids[$i])
                [void] $command.AddArgument($payloadXml)
                [void] $command.AddArgument($processSpec.PowerShellPath)
                [void] $command.AddArgument($processSpec.WorkingDirectory)
                [void] $command.AddArgument($encodedChildCommand)
                [void] $command.AddArgument($processSpec.TimeoutSeconds)
                [void] $command.AddArgument($processSpec.CreateNoWindow)
                [void] $command.AddArgument($processSpec.WindowStyle)
                [void] $command.AddArgument($processSpec.LoadProfile)
                [void] $command.AddArgument($processSpec.Environment)
                [void] $command.AddArgument($processSpec.PriorityClass)
                [void] $command.AddArgument($processRegistry)
                [void] $command.AddArgument($CancellationToken)
            }

            try {
                $async = $ps.BeginInvoke()
                $invocations.Add(@{
                    Index = $i; Id = $ids[$i]; Item = $InputObject[$i]; PS = $ps; Async = $async
                    Mode = $itemModes[$i]
                    QueuedUtc = [datetime]::UtcNow; TimedOut = $false; Cancelled = $false
                })
            }
            catch {
                $ps.Dispose()
                $ordered[$i] = [pscustomobject]@{
                    Id = $ids[$i]; Index = $i; Input = $InputObject[$i]; State = 'Failed'; Output = @()
                    Errors = @($_.ToString()); Warnings = @(); Information = @(); QueuedUtc = [datetime]::UtcNow
                    StartedUtc = $null; EndedUtc = [datetime]::UtcNow; DurationMs = 0
                    RunspaceId = $null; ThreadId = $null; ProcessId = $null; ExitCode = $null
                    StdOut = @(); StdErr = @()
                }
            }
        }
        $timing.DispatchMs = $swDispatch.ElapsedMilliseconds

        $swWait = [System.Diagnostics.Stopwatch]::StartNew()
        $cancellationObserved = $CancellationToken.IsCancellationRequested
        $timeoutObserved = $false
        if (-not $cancellationObserved) { foreach ($invocation in $invocations) {
            if ($invocation.Async.IsCompleted) { continue }
            # Never park the hosting PowerShell pipeline in an indefinite CLR wait. Short slices give
            # Ctrl+C / PowerShell.Stop() regular interpreter checkpoints so the outer finally block can
            # kill registered process trees immediately instead of waiting for child completion.
            while (-not $invocation.Async.IsCompleted) {
                if ($CancellationToken.IsCancellationRequested) {
                    $cancellationObserved = $true
                    break
                }
                $remaining = if ($WaitTimeoutSeconds -gt 0) {
                    ([int64]$WaitTimeoutSeconds * 1000) - $swWait.ElapsedMilliseconds
                }
                else { [int64]-1 }
                if ($WaitTimeoutSeconds -gt 0 -and $remaining -le 0) {
                    $timeoutObserved = $true
                    break
                }
                $waitSlice = if ($remaining -ge 0) {
                    [int][math]::Min(200, [math]::Max(1, $remaining))
                }
                else { 200 }

                if ($CancellationToken.CanBeCanceled) {
                    $handles = [System.Threading.WaitHandle[]]@(
                        $invocation.Async.AsyncWaitHandle,
                        $CancellationToken.WaitHandle)
                    $waitResult = [System.Threading.WaitHandle]::WaitAny($handles, $waitSlice)
                    if ($waitResult -eq 0) { break }
                    if ($waitResult -eq 1) { $cancellationObserved = $true; break }
                }
                elseif ($invocation.Async.AsyncWaitHandle.WaitOne($waitSlice)) { break }
            }
            if ($cancellationObserved -or $timeoutObserved) { break }
        } }

        if ($cancellationObserved -or $timeoutObserved) {
            foreach ($invocation in $invocations) {
                if (-not $invocation.Async.IsCompleted) {
                    if ($cancellationObserved) { $invocation.Cancelled = $true }
                    else { $invocation.TimedOut = $true }
                }
            }

            $reason = if ($cancellationObserved) { 'caller cancellation' } else { 'batch wait timeout' }
            Stop-BatchExecutorChildProcesses -Registry $processRegistry -Reason $reason `
                -Diagnostics $infrastructureErrors

            # Direct pipelines have no diagnostic transport to drain once cancellation is observed.
            # Stop them immediately; process supervisors get a short opportunity to publish the
            # child envelope produced after their registered process tree was terminated.
            foreach ($invocation in $invocations) {
                if ($invocation.Mode -eq 'Runspace' -and -not $invocation.Async.IsCompleted) {
                    try { $invocation.PS.Stop() } catch {}
                }
            }
            if ($hasProcessJobs) {
                # Killed children and token-aware queued dispatchers normally unwind with useful
                # envelopes. Give the outer runspaces one bounded grace period to publish them.
                $drain = [System.Diagnostics.Stopwatch]::StartNew()
                foreach ($invocation in $invocations) {
                    if ($invocation.Mode -ne 'Process' -or $invocation.Async.IsCompleted) { continue }
                    $remainingDrain = [math]::Max(0, 5000 - $drain.ElapsedMilliseconds)
                    if ($remainingDrain -gt 0) {
                        [void]$invocation.Async.AsyncWaitHandle.WaitOne([int]$remainingDrain)
                    }
                }
            }

            foreach ($invocation in $invocations) {
                if (-not $invocation.Async.IsCompleted) { try { $invocation.PS.Stop() } catch {} }
            }
        }
        $timing.WaitMs = $swWait.ElapsedMilliseconds

        $swCollect = [System.Diagnostics.Stopwatch]::StartNew()
        foreach ($invocation in $invocations) {
            $ps = $invocation.PS
            $pipelineOutput = @()
            try {
                if ($invocation.TimedOut -and -not $invocation.Async.IsCompleted) {
                    try { $ps.Stop() } catch {}
                }
                if ($invocation.Async.IsCompleted) {
                    $pipelineOutput = @($ps.EndInvoke($invocation.Async))
                }
            }
            catch {
                if (-not ($invocation.TimedOut -or $invocation.Cancelled)) {
                    $infrastructureErrors.Add("item '$($invocation.Id)' collection failed: $($_.Exception.Message)")
                }
            }

            # EndInvoke output is already adapted/unwrapped when materialized through @(...).
            $envelope = if ($pipelineOutput.Count -gt 0) { $pipelineOutput[-1] } else { $null }
            $errors = [System.Collections.Generic.List[string]]::new()
            $warnings = [System.Collections.Generic.List[string]]::new()
            $information = [System.Collections.Generic.List[string]]::new()
            foreach ($record in @($ps.Streams.Error)) { $errors.Add($record.ToString()) }
            foreach ($record in @($ps.Streams.Warning)) { $warnings.Add($record.Message) }
            foreach ($record in @($ps.Streams.Information)) {
                $information.Add($(if ($null -ne $record.MessageData) { $record.MessageData.ToString() } else { $record.ToString() }))
            }
            if ($envelope -and $envelope.Failure) { $errors.Add([string]$envelope.Failure) }
            if ($envelope -and $envelope.PSObject.Properties['Errors']) {
                foreach ($record in @($envelope.Errors)) { if ($record) { $errors.Add([string]$record) } }
            }
            if ($envelope -and $envelope.PSObject.Properties['Warnings']) {
                foreach ($record in @($envelope.Warnings)) { if ($record) { $warnings.Add([string]$record) } }
            }
            if ($invocation.TimedOut) {
                $errors.Add("batch wait exceeded the total timeout of $WaitTimeoutSeconds second(s)")
            }
            if ($invocation.Cancelled) { $warnings.Add('caller cancellation requested') }

            $state = if ($invocation.Cancelled) { 'Cancelled' }
                     elseif ($invocation.TimedOut) { 'TimedOut' }
                     elseif ($envelope -and $envelope.PSObject.Properties['State']) { [string]$envelope.State }
                     elseif ($null -eq $envelope -or $errors.Count -gt 0) { 'Failed' }
                     else { 'Succeeded' }
            if ($state -eq 'Succeeded' -and $errors.Count -gt 0) { $state = 'Failed' }

            $startedUtc = if ($envelope) { $envelope.StartedUtc } else { $null }
            $endedUtc = if ($envelope) { $envelope.EndedUtc } else { [datetime]::UtcNow }
            $durationMs = if ($startedUtc -and $endedUtc) {
                [math]::Round((([datetime]$endedUtc) - ([datetime]$startedUtc)).TotalMilliseconds, 2)
            }
            else { $null }
            [object[]] $jobOutput = @()
            [string[]] $jobStdOut = @()
            [string[]] $jobStdErr = @()
            if ($envelope) { $jobOutput = [object[]]@($envelope.Output) }
            if ($envelope -and $envelope.PSObject.Properties['StdOut']) {
                $jobStdOut = [string[]]@($envelope.StdOut)
            }
            if ($envelope -and $envelope.PSObject.Properties['StdErr']) {
                $jobStdErr = [string[]]@($envelope.StdErr)
            }

            $ordered[$invocation.Index] = [pscustomobject]@{
                Id = $invocation.Id; Index = $invocation.Index; Input = $invocation.Item; State = $state
                Output = $jobOutput
                Errors = $errors.ToArray(); Warnings = $warnings.ToArray(); Information = $information.ToArray()
                QueuedUtc = $invocation.QueuedUtc; StartedUtc = $startedUtc; EndedUtc = $endedUtc; DurationMs = $durationMs
                RunspaceId = if ($envelope) { $envelope.RunspaceId } else { $null }
                ThreadId = if ($envelope) { $envelope.ThreadId } else { $null }
                ProcessId = if ($envelope) { $envelope.ProcessId } else { $null }
                ExitCode = if ($envelope -and $envelope.PSObject.Properties['ExitCode']) { $envelope.ExitCode } else { $null }
                StdOut = $jobStdOut
                StdErr = $jobStdErr
            }
            $ps.Dispose()
        }
        $timing.CollectMs = $swCollect.ElapsedMilliseconds
        $completedNormally = $true
    }
    finally {
        # This path also runs when Ctrl+C or an infrastructure exception unwinds the function.
        # Kill children first, then stop their supervising pipelines; no child is left orphaned.
        Stop-BatchExecutorChildProcesses -Registry $processRegistry `
            -Reason $(if ($completedNormally) { 'final registry cleanup' } else { 'exceptional batch teardown' }) `
            -Diagnostics $infrastructureErrors
        foreach ($invocation in $invocations) {
            if ($null -ne $invocation.PS) {
                if ($invocation.Async -and -not $invocation.Async.IsCompleted) {
                    try { $invocation.PS.Stop() } catch {}
                }
                try { $invocation.PS.Dispose() } catch {}
            }
        }
        if ($null -ne $pool) {
            try { $pool.Close() } catch {}
            try { $pool.Dispose() } catch {}
        }
    }

    $swTotal.Stop()
    $timing.TotalMs = $swTotal.ElapsedMilliseconds
    $succeeded = @($ordered | Where-Object State -EQ 'Succeeded').Count
    $failed = @($ordered | Where-Object State -EQ 'Failed').Count
    $timedOut = @($ordered | Where-Object State -EQ 'TimedOut').Count
    $cancelled = @($ordered | Where-Object State -EQ 'Cancelled').Count

    [pscustomobject]@{
        Results = $ordered
        Errors = $infrastructureErrors.ToArray()
        Warnings = @($budget.Warnings)
        Budget = $budget
        Policy = $policy
        Timing = [pscustomobject]$timing
        Summary = [pscustomobject]@{
            Total = $count; Succeeded = $succeeded; Failed = $failed; TimedOut = $timedOut; Cancelled = $cancelled
        }
    }
}

function New-BatchJob {
    <# Domain-neutral job description. Adapters should discover test cases or documents and emit
       these records; they should not own pools, cancellation, subprocesses, or result ordering. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Id,
        [Parameter(Mandatory)] [ValidateSet('RunspaceScript', 'PowerShellProcess')] [string] $Kind,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EntryPoint,
        [System.Collections.IDictionary] $Parameters,
        [object[]] $ArgumentList,
        [ValidateNotNullOrEmpty()] [string] $RuntimeProfile = 'default',
        [System.Collections.IDictionary] $ProcessSpec,
        [ValidateRange(0, [double]::MaxValue)] [double] $EstimatedCost = 1,
        [string[]] $Writes = @(),
        [string[]] $ModulePath = @(),
        [string] $InitializationScriptPath,
        [string] $WorkingDirectory,
        [System.Collections.IDictionary] $Metadata
    )

    if ($PSBoundParameters.ContainsKey('Parameters') -and $PSBoundParameters.ContainsKey('ArgumentList')) {
        throw "batch job '$Id' cannot specify both Parameters and ArgumentList"
    }

    $parameterCopy = if ($PSBoundParameters.ContainsKey('Parameters')) {
        $copy = @{}
        if ($null -ne $Parameters) {
            foreach ($key in @($Parameters.Keys)) { $copy[[string]$key] = $Parameters[$key] }
        }
        $copy
    }
    else { $null }
    $processSpecCopy = @{}
    if ($null -ne $ProcessSpec) {
        foreach ($key in @($ProcessSpec.Keys)) { $processSpecCopy[[string]$key] = $ProcessSpec[$key] }
    }
    $metadataCopy = @{}
    if ($null -ne $Metadata) {
        foreach ($key in @($Metadata.Keys)) { $metadataCopy[[string]$key] = $Metadata[$key] }
    }

    $job = [pscustomobject]@{
        Id = $Id
        Kind = $Kind
        EntryPoint = $EntryPoint
        ArgumentMode = if ($PSBoundParameters.ContainsKey('Parameters')) { 'Named' }
            elseif ($PSBoundParameters.ContainsKey('ArgumentList')) { 'Positional' }
            else { 'None' }
        Parameters = $parameterCopy
        ArgumentList = if ($PSBoundParameters.ContainsKey('ArgumentList')) { [object[]]@($ArgumentList) } else { $null }
        RuntimeProfile = $RuntimeProfile
        ProcessSpec = $processSpecCopy
        EstimatedCost = $EstimatedCost
        Writes = [string[]]@($Writes)
        ModulePath = [string[]]@($ModulePath)
        InitializationScriptPath = $InitializationScriptPath
        WorkingDirectory = $WorkingDirectory
        Metadata = $metadataCopy
    }
    $job.PSObject.TypeNames.Insert(0, 'CodexScientiae.BatchJob')
    return $job
}

function Resolve-BatchPlanPath {
    param([Parameter(Mandatory)] [string] $Path, [Parameter(Mandatory)] [string] $BasePath)
    if ([System.IO.Path]::IsPathFullyQualified($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }
    return [System.IO.Path]::GetFullPath($Path, $BasePath)
}

function Resolve-BatchPlanModuleReference {
    param(
        [Parameter(Mandatory)] [string] $Module,
        [Parameter(Mandatory)] [string] $BasePath
    )
    if ([string]::IsNullOrWhiteSpace($Module)) { throw 'module reference must not be empty' }
    $looksLikePath = [System.IO.Path]::IsPathFullyQualified($Module) -or
        $Module.Contains([System.IO.Path]::DirectorySeparatorChar) -or
        $Module.Contains([System.IO.Path]::AltDirectorySeparatorChar) -or
        [System.IO.Path]::GetExtension($Module) -in @('.psd1', '.psm1', '.dll')
    if ($looksLikePath) {
        $resolved = Resolve-BatchPlanPath -Path $Module -BasePath $BasePath
        if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
            throw "module is unavailable: '$Module'"
        }
        return (Resolve-Path -LiteralPath $resolved).Path
    }
    if ($null -eq (Get-Module -ListAvailable -Name $Module | Select-Object -First 1)) {
        throw "module is unavailable: '$Module'"
    }
    return $Module
}

function Compile-BatchPlan {
    <# Normalizes and freezes jobs before any worker starts. A plan is either executable or contains
       errors and no Plan value; execution never begins with a partially valid queue. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [AllowEmptyCollection()] [object[]] $Job,
        [object] $RunspaceProfile,
        [string] $PlanId = ([guid]::NewGuid().ToString('n')),
        [string] $BasePath = (Get-Location).Path,
        [switch] $AllowWriteCollisions
    )

    $errors = [System.Collections.Generic.List[string]]::new()
    $warnings = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-Path -LiteralPath $BasePath -PathType Container)) {
        $errors.Add("batch plan base path not found: '$BasePath'")
        return [pscustomobject]@{ Plan = $null; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
    }
    $resolvedBasePath = (Resolve-Path -LiteralPath $BasePath).Path

    $profileName = [string](Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'Name' -Default 'default')
    $profileIssPreset = [string](Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'IssPreset' -Default 'Core')
    $profileModules = [string[]]@(Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'ModulePath' -Default @())
    $profileInitializer = [string](Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'InitializationScriptPath')
    $profileContext = Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'Context'
    if ([string]::IsNullOrWhiteSpace($profileName)) { $errors.Add('runspace profile name must not be empty') }
    if ($profileIssPreset -notin @('Bare', 'Core', 'Full')) {
        $errors.Add("runspace profile '$profileName' has invalid ISS preset '$profileIssPreset'")
    }
    $resolvedProfileModules = [System.Collections.Generic.List[string]]::new()
    foreach ($module in $profileModules) {
        try { $resolvedProfileModules.Add((Resolve-BatchPlanModuleReference -Module $module -BasePath $resolvedBasePath)) }
        catch { $errors.Add("runspace profile '$profileName' $($_.Exception.Message)") }
    }
    $profileModules = $resolvedProfileModules.ToArray()
    if (-not [string]::IsNullOrWhiteSpace($profileInitializer)) {
        try {
            $profileInitializer = (Get-BatchExecutorScriptDefinition -Path `
                (Resolve-BatchPlanPath -Path $profileInitializer -BasePath $resolvedBasePath) `
                -Role 'runspace profile initializer' -RejectRequires).Path
        }
        catch { $errors.Add($_.Exception.Message) }
    }

    $normalized = [System.Collections.Generic.List[object]]::new($Job.Count)
    $seenIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    for ($index = 0; $index -lt $Job.Count; $index++) {
        $source = $Job[$index]
        $id = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'Id')
        $kind = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'Kind')
        $entryPoint = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'EntryPoint')
        $runtimeProfile = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'RuntimeProfile' -Default 'default')
        $estimatedCost = Get-BatchExecutorPropertyValue -Object $source -Name 'EstimatedCost' -Default 1
        $argumentMode = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'ArgumentMode' -Default 'None')
        $parameters = Get-BatchExecutorPropertyValue -Object $source -Name 'Parameters'
        $argumentList = Get-BatchExecutorPropertyValue -Object $source -Name 'ArgumentList'
        $workingDirectory = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'WorkingDirectory')
        $processSpecSource = Get-BatchExecutorPropertyValue -Object $source -Name 'ProcessSpec' -Default @{}
        $modulePath = [string[]]@(Get-BatchExecutorPropertyValue -Object $source -Name 'ModulePath' -Default @())
        $initializerPath = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'InitializationScriptPath')
        $writes = [string[]]@(Get-BatchExecutorPropertyValue -Object $source -Name 'Writes' -Default @())
        $metadata = Get-BatchExecutorPropertyValue -Object $source -Name 'Metadata' -Default @{}

        $jobHasErrors = $false
        if ([string]::IsNullOrWhiteSpace($id)) { $errors.Add("batch plan job [$index] has no id"); $jobHasErrors = $true }
        elseif (-not $seenIds.Add($id)) { $errors.Add("batch plan contains duplicate job id '$id'"); $jobHasErrors = $true }
        if ($kind -notin @('RunspaceScript', 'PowerShellProcess')) {
            $errors.Add("batch plan job '$id' has invalid kind '$kind'"); $jobHasErrors = $true
        }
        if ($argumentMode -notin @('None', 'Named', 'Positional')) {
            $errors.Add("batch plan job '$id' has invalid argument mode '$argumentMode'"); $jobHasErrors = $true
        }
        if ($argumentMode -eq 'Named' -and $parameters -isnot [System.Collections.IDictionary]) {
            $errors.Add("batch plan job '$id' named parameters must be a dictionary"); $jobHasErrors = $true
        }
        if ($processSpecSource -isnot [System.Collections.IDictionary]) {
            $errors.Add("batch plan job '$id' process specification must be a dictionary"); $jobHasErrors = $true
            $processSpecSource = @{}
        }
        try {
            $cost = [double]$estimatedCost
            if ([double]::IsNaN($cost) -or [double]::IsInfinity($cost) -or $cost -lt 0) { throw 'invalid' }
        }
        catch { $errors.Add("batch plan job '$id' estimated cost must be a finite non-negative number"); $jobHasErrors = $true; $cost = 1 }

        $processSpec = @{}
        foreach ($key in @($processSpecSource.Keys)) { $processSpec[[string]$key] = $processSpecSource[$key] }
        if ([string]::IsNullOrWhiteSpace($workingDirectory)) {
            $workingDirectory = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'WorkingDirectory' -Default $resolvedBasePath)
        }
        try {
            $workingDirectory = Resolve-BatchPlanPath -Path $workingDirectory -BasePath $resolvedBasePath
            if (-not (Test-Path -LiteralPath $workingDirectory -PathType Container)) {
                throw "working directory not found: '$workingDirectory'"
            }
            $workingDirectory = (Resolve-Path -LiteralPath $workingDirectory).Path
            $processSpec['WorkingDirectory'] = $workingDirectory
        }
        catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }

        if ($kind -eq 'PowerShellProcess') {
            $environment = Get-BatchExecutorPropertyValue -Object $processSpec -Name 'Environment'
            if ($null -ne $environment) {
                if ($environment -isnot [System.Collections.IDictionary]) {
                    $errors.Add("batch plan job '$id' process environment must be a dictionary"); $jobHasErrors = $true
                }
                else {
                    $environmentCopy = @{}
                    foreach ($key in @($environment.Keys)) { $environmentCopy[[string]$key] = $environment[$key] }
                    $processSpec['Environment'] = $environmentCopy
                }
            }
            $timeout = Get-BatchExecutorPropertyValue -Object $processSpec -Name 'TimeoutSeconds'
            if ($null -ne $timeout) {
                try {
                    $timeout = [int]$timeout
                    if ($timeout -lt 0) { throw 'negative' }
                    $processSpec['TimeoutSeconds'] = $timeout
                }
                catch { $errors.Add("batch plan job '$id' process timeout must be a non-negative integer"); $jobHasErrors = $true }
            }
            $jobWindowStyle = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'WindowStyle')
            if ($jobWindowStyle -and $jobWindowStyle -notin @('Hidden', 'Normal', 'Minimized', 'Maximized')) {
                $errors.Add("batch plan job '$id' has invalid process window style '$jobWindowStyle'"); $jobHasErrors = $true
            }
            $jobPriority = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'PriorityClass')
            if ($jobPriority -and $jobPriority -notin @('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')) {
                $errors.Add("batch plan job '$id' has invalid process priority '$jobPriority'"); $jobHasErrors = $true
            }
            $jobPowerShell = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'PowerShellPath')
            if ($jobPowerShell) {
                try {
                    $jobPowerShell = Resolve-BatchPlanPath -Path $jobPowerShell -BasePath $workingDirectory
                    if (-not (Test-Path -LiteralPath $jobPowerShell -PathType Leaf)) {
                        throw "child PowerShell not found: '$jobPowerShell'"
                    }
                    $processSpec['PowerShellPath'] = (Resolve-Path -LiteralPath $jobPowerShell).Path
                }
                catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }
            }
        }

        try {
            if ([string]::IsNullOrWhiteSpace($entryPoint)) { throw 'has no entrypoint' }
            $entryPoint = Resolve-BatchPlanPath -Path $entryPoint -BasePath $workingDirectory
            if (-not (Test-Path -LiteralPath $entryPoint -PathType Leaf)) { throw "entrypoint not found: '$entryPoint'" }
            $entryPoint = (Resolve-Path -LiteralPath $entryPoint).Path
            $parseTokens = $null; $parseErrors = $null
            [void][System.Management.Automation.Language.Parser]::ParseFile($entryPoint, [ref]$parseTokens, [ref]$parseErrors)
            if ($parseErrors.Count -gt 0) { throw "entrypoint does not parse: $($parseErrors[0].Message)" }
        }
        catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }

        $resolvedModules = [System.Collections.Generic.List[string]]::new()
        foreach ($module in $modulePath) {
            try { $resolvedModules.Add((Resolve-BatchPlanModuleReference -Module $module -BasePath $workingDirectory)) }
            catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }
        }
        $modulePath = $resolvedModules.ToArray()
        if (-not [string]::IsNullOrWhiteSpace($initializerPath)) {
            try {
                $initializerPath = (Get-BatchExecutorScriptDefinition -Path `
                    (Resolve-BatchPlanPath -Path $initializerPath -BasePath $workingDirectory) `
                    -Role "job '$id' initializer").Path
            }
            catch { $errors.Add($_.Exception.Message); $jobHasErrors = $true }
        }

        $normalizedWrites = [System.Collections.Generic.List[string]]::new()
        foreach ($writePath in $writes) {
            if ([string]::IsNullOrWhiteSpace($writePath)) {
                $errors.Add("batch plan job '$id' declares an empty write path"); $jobHasErrors = $true; continue
            }
            try {
                $normalizedWrite = Resolve-BatchPlanPath -Path $writePath -BasePath $workingDirectory
                $writeRoot = [System.IO.Path]::GetPathRoot($normalizedWrite)
                if (-not $normalizedWrite.Equals($writeRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $normalizedWrite = $normalizedWrite.TrimEnd(
                        [System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
                }
                $normalizedWrites.Add($normalizedWrite)
            }
            catch { $errors.Add("batch plan job '$id' has invalid write path '$writePath': $($_.Exception.Message)"); $jobHasErrors = $true }
        }

        $parameterCopy = if ($argumentMode -eq 'Named' -and $parameters -is [System.Collections.IDictionary]) {
            $copy = @{}; foreach ($key in @($parameters.Keys)) { $copy[[string]$key] = $parameters[$key] }; $copy
        }
        else { $null }
        $metadataCopy = @{}
        if ($metadata -is [System.Collections.IDictionary]) {
            foreach ($key in @($metadata.Keys)) { $metadataCopy[[string]$key] = $metadata[$key] }
        }

        if (-not $jobHasErrors) {
            $normalized.Add([pscustomobject]@{
                Id = $id; Kind = $kind
                ExecutionMode = if ($kind -eq 'RunspaceScript') { 'Runspace' } else { 'Process' }
                EntryPoint = $entryPoint; ArgumentMode = $argumentMode
                Parameters = $parameterCopy
                ArgumentList = if ($argumentMode -eq 'Positional') { [object[]]@($argumentList) } else { $null }
                RuntimeProfile = $runtimeProfile; ProcessSpec = $processSpec; EstimatedCost = $cost
                Writes = $normalizedWrites.ToArray(); ModulePath = $modulePath
                InitializationScriptPath = $initializerPath; WorkingDirectory = $workingDirectory
                Metadata = $metadataCopy; PlanIndex = $index
            })
        }
    }

    $directProfiles = [string[]]@($normalized | Where-Object ExecutionMode -EQ 'Runspace' |
        ForEach-Object RuntimeProfile | Sort-Object -Unique)
    if ($directProfiles.Count -gt 1) {
        $errors.Add("one runspace pool cannot host multiple direct runtime profiles: $($directProfiles -join ', ')")
    }
    elseif ($directProfiles.Count -eq 1 -and $directProfiles[0] -ne $profileName) {
        $errors.Add("direct jobs request runtime profile '$($directProfiles[0])' but plan provides '$profileName'")
    }

    if (-not $AllowWriteCollisions) {
        $comparison = if ($IsWindows) { [System.StringComparison]::OrdinalIgnoreCase } else { [System.StringComparison]::Ordinal }
        $separator = [string][System.IO.Path]::DirectorySeparatorChar
        for ($left = 0; $left -lt $normalized.Count; $left++) {
            for ($right = $left + 1; $right -lt $normalized.Count; $right++) {
                foreach ($leftPath in @($normalized[$left].Writes)) {
                    foreach ($rightPath in @($normalized[$right].Writes)) {
                        $leftPrefix = if ($leftPath.EndsWith($separator)) { $leftPath } else { $leftPath + $separator }
                        $rightPrefix = if ($rightPath.EndsWith($separator)) { $rightPath } else { $rightPath + $separator }
                        $overlap = $leftPath.Equals($rightPath, $comparison) -or
                            $leftPath.StartsWith($rightPrefix, $comparison) -or
                            $rightPath.StartsWith($leftPrefix, $comparison)
                        if ($overlap) {
                            $errors.Add("write-set collision between jobs '$($normalized[$left].Id)' and '$($normalized[$right].Id)': '$leftPath' <> '$rightPath'")
                        }
                    }
                }
            }
        }
    }

    if ($errors.Count -gt 0) {
        return [pscustomobject]@{ Plan = $null; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
    }

    $dispatchJobs = [object[]]@($normalized | Sort-Object -Property `
        @{ Expression = 'EstimatedCost'; Descending = $true },
        @{ Expression = 'PlanIndex'; Ascending = $true })
    $workerScriptPath = Join-Path $PSScriptRoot 'batch-job-worker.ps1'
    if (-not (Test-Path -LiteralPath $workerScriptPath -PathType Leaf)) {
        $errors.Add("batch plan worker not found: '$workerScriptPath'")
        return [pscustomobject]@{ Plan = $null; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
    }
    $plan = [pscustomobject]@{
        Id = $PlanId
        Jobs = [object[]]@($normalized | Sort-Object PlanIndex)
        DispatchJobs = $dispatchJobs
        WorkerScriptPath = (Resolve-Path -LiteralPath $workerScriptPath).Path
        BasePath = $resolvedBasePath
        RunspaceProfile = [pscustomobject]@{
            Name = $profileName; IssPreset = $profileIssPreset; ModulePath = $profileModules
            InitializationScriptPath = $profileInitializer; Context = $profileContext
        }
        Policy = [pscustomobject]@{
            Scheduling = 'GreedyCostDescending'; ResultOrdering = 'OriginalPlanOrder'
            WriteCollisionPolicy = if ($AllowWriteCollisions) { 'CallerOverride' } else { 'RejectOverlap' }
            FailureAction = 'Continue'
        }
        Warnings = $warnings.ToArray()
    }
    $plan.PSObject.TypeNames.Insert(0, 'CodexScientiae.BatchPlan')
    [pscustomobject]@{ Plan = $plan; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
}

function Invoke-BatchPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [object] $Plan,
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
        [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
        [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [System.Threading.CancellationToken] $CancellationToken = [System.Threading.CancellationToken]::None,
        [ValidateSet('SharedReadOnly', 'PerItemCopy')] [string] $RunspaceDataPolicy = 'SharedReadOnly',
        [string] $PowerShellPath,
        [System.Collections.IDictionary] $ProcessEnvironment = @{},
        [bool] $CreateNoWindow = $true,
        [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')] [string] $WindowStyle = 'Hidden',
        [switch] $LoadProfile,
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')] [string] $PriorityClass = 'Normal'
    )

    if ($Plan.PSObject.Properties['Plan'] -and $Plan.PSObject.Properties['Errors']) {
        if ($Plan.Errors.Count -gt 0 -or $null -eq $Plan.Plan) {
            throw "cannot invoke invalid batch plan: $(@($Plan.Errors) -join '; ')"
        }
        $Plan = $Plan.Plan
    }
    if ($null -eq $Plan -or -not $Plan.PSObject.Properties['DispatchJobs']) {
        throw 'Invoke-BatchPlan requires a compiled batch plan'
    }

    $modes = [string[]]@($Plan.DispatchJobs | ForEach-Object ExecutionMode | Sort-Object -Unique)
    $executionMode = if ($modes.Count -eq 0) { 'Runspace' }
        elseif ($modes.Count -eq 1) { $modes[0] }
        else { 'Mixed' }
    $hasDirectJobs = $modes -contains 'Runspace'
    $profile = $Plan.RunspaceProfile
    $invoke = @{
        InputObject = [object[]]@($Plan.DispatchJobs)
        ScriptPath = [string]$Plan.WorkerScriptPath
        ExecutionMode = $executionMode
        ExecutionModeProperty = 'ExecutionMode'
        ProcessSpecProperty = 'ProcessSpec'
        Context = $profile.Context
        InitializationScriptPath = if ($hasDirectJobs) { [string]$profile.InitializationScriptPath } else { '' }
        ModulePath = if ($hasDirectJobs) { [string[]]@($profile.ModulePath) } else { [string[]]@() }
        IssPreset = [string]$profile.IssPreset
        MaxWorkers = $MaxWorkers
        ReservedCores = $ReservedCores
        MinItemsPerWorker = $MinItemsPerWorker
        SerializationDepth = $SerializationDepth
        ProcessTimeoutSeconds = $ProcessTimeoutSeconds
        WaitTimeoutSeconds = $WaitTimeoutSeconds
        CancellationToken = $CancellationToken
        RunspaceDataPolicy = $RunspaceDataPolicy
        WorkingDirectory = [string]$Plan.BasePath
        ProcessEnvironment = $ProcessEnvironment
        CreateNoWindow = $CreateNoWindow
        WindowStyle = $WindowStyle
        LoadProfile = $LoadProfile
        PriorityClass = $PriorityClass
    }
    if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) { $invoke.PowerShellPath = $PowerShellPath }
    $execution = Invoke-BatchExecutor @invoke

    $stableResults = [object[]]::new($Plan.Jobs.Count)
    foreach ($result in @($execution.Results)) {
        $planIndex = [int]$result.Input.PlanIndex
        $result | Add-Member -NotePropertyName DispatchIndex -NotePropertyValue $result.Index
        $result.Index = $planIndex
        $stableResults[$planIndex] = $result
    }

    [pscustomobject]@{
        PlanId = $Plan.Id; Results = $stableResults
        Errors = $execution.Errors; Warnings = @($Plan.Warnings) + @($execution.Warnings)
        Budget = $execution.Budget
        Policy = [pscustomobject]@{ Plan = $Plan.Policy; Execution = $execution.Policy }
        Timing = $execution.Timing
        Summary = $execution.Summary
    }
}
