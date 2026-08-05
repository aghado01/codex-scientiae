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
