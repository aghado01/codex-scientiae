function New-BatchExecutorRunspacePool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor pool construction requires a lifecycle state record'
    }

    # Publish ownership inside the construction expression. A host stop after the factory returns
    # but before this helper returns must still leave the pool reachable from the outer finally.
    $Lifecycle.Pool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(
        $Lifecycle.Preparation.InitialSessionState)
    return $Lifecycle.Pool
}

function New-BatchExecutorPipeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor pipeline construction requires a lifecycle state record'
    }

    # Direct assignment makes publication part of the construction expression. If host stop lands
    # before this helper returns, the exported owner's finally block can still reach the handle.
    $Lifecycle.PendingPipeline = [System.Management.Automation.PowerShell]::Create()
    return $Lifecycle.PendingPipeline
}

function New-BatchExecutorNeverStartedResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [object] $PreparedItem,
        [Parameter(Mandatory)] [ValidateSet('Cancelled', 'TimedOut')] [string] $State,
        [Parameter(Mandatory)] [string] $StopReason,
        [string] $StopPhase = 'Dispatch',
        [string] $Message
    )

    $errors = [string[]]@()
    $warnings = [string[]]@()
    if ($State -eq 'TimedOut' -and $Message) { $errors = @($Message) }
    if ($State -eq 'Cancelled') { $warnings = @('caller cancellation requested') }
    return New-BatchExecutorItemResult -Id $PreparedItem.Id -Index $PreparedItem.Index `
        -OriginalInput $PreparedItem.Input -State $State -Errors $errors -Warnings $warnings `
        -QueuedUtc ([datetime]::UtcNow) -EndedUtc ([datetime]::UtcNow) -DurationMs 0 `
        -Observation (New-BatchExecutorObservation -Submitted:$false -Started:$false `
            -StopReason $StopReason -StopPhase $StopPhase) `
        -Capture (New-BatchExecutorCaptureRecord -StdOutComplete:$false -StdErrComplete:$false `
            -Protocol $(if ($PreparedItem.Mode -eq 'Process') { 'missing' } else { 'not-applicable' }))
}

function Start-BatchExecutorInvocations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor dispatch requires a lifecycle state record'
    }

    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Dispatching
    $preparation = $Lifecycle.Preparation
    $deadline = $Lifecycle.Deadline
    $cancellationToken = $preparation.CancellationToken

    $swPool = [System.Diagnostics.Stopwatch]::StartNew()
    $pool = New-BatchExecutorRunspacePool -Lifecycle $Lifecycle
    [void]$pool.SetMinRunspaces(1)
    [void]$pool.SetMaxRunspaces($preparation.Budget.Threads)
    $pool.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::UseNewThread
    $pool.ApartmentState = [System.Threading.ApartmentState]::MTA
    $pool.Open()
    $Lifecycle.Timing['PoolOpenMs'] = $swPool.ElapsedMilliseconds

    $swDispatch = [System.Diagnostics.Stopwatch]::StartNew()
    foreach ($preparedItem in $preparation.Items) {
        if ($cancellationToken.IsCancellationRequested -or
                ($null -ne $deadline -and $deadline.ExecutionExpired)) {
            $timedOut = $null -ne $deadline -and $deadline.ExecutionExpired -and
                -not $cancellationToken.IsCancellationRequested
            $Lifecycle.Results[$preparedItem.Index] = New-BatchExecutorNeverStartedResult `
                -PreparedItem $preparedItem `
                -State $(if ($timedOut) { 'TimedOut' } else { 'Cancelled' }) `
                -StopReason $(if ($timedOut) { 'ExecutionTimeout' } else { 'CallerCancellation' }) `
                -Message $(if ($timedOut) { 'executor execution timeout before submission' } else { $null })
            continue
        }

        $pipeline = $null
        $asyncResult = $null
        try {
            $pipeline = New-BatchExecutorPipeline -Lifecycle $Lifecycle
            $pipeline.RunspacePool = $pool
            if ($preparedItem.Mode -eq 'Runspace') {
                $command = $pipeline.AddCommand('Invoke-BatchDirectDispatcher')
                [void]$command.AddArgument($preparedItem.DispatchItem)
                [void]$command.AddArgument($preparedItem.DispatchContext)
                [void]$command.AddArgument($preparation.CancellationToken)
            }
            else {
                $processSpec = $preparedItem.ProcessSpec
                $command = $pipeline.AddCommand('Invoke-BatchProcessDispatcher')
                [void]$command.AddArgument($preparedItem.Id)
                [void]$command.AddArgument($preparedItem.ProcessPayloadXml)
                [void]$command.AddArgument($processSpec.PowerShellPath)
                [void]$command.AddArgument($processSpec.WorkingDirectory)
                [void]$command.AddArgument($preparation.EncodedChildCommand)
                [void]$command.AddArgument($processSpec.TimeoutSeconds)
                [void]$command.AddArgument($processSpec.CreateNoWindow)
                [void]$command.AddArgument($processSpec.WindowStyle)
                [void]$command.AddArgument($processSpec.LoadProfile)
                [void]$command.AddArgument($processSpec.Environment)
                [void]$command.AddArgument($processSpec.PriorityClass)
                [void]$command.AddArgument($Lifecycle.ChildProcessRegistry)
                [void]$command.AddArgument($preparation.CancellationToken)
                [void]$command.AddArgument($deadline)
                [void]$command.AddArgument($preparation.CaptureLimits)
            }

            $asyncResult = $pipeline.BeginInvoke()
            $invocation = New-BatchExecutorInvocationState -PreparedItem $preparedItem `
                -Pipeline $pipeline -AsyncResult $asyncResult `
                -QueuedUtc ([datetime]::UtcNow)
            $Lifecycle.Invocations.Add($invocation)
            $Lifecycle.PendingPipeline = $null
        }
        catch {
            $submissionError = $_
            if ($null -eq $pipeline) { $pipeline = $Lifecycle.PendingPipeline }
            if ($null -ne $asyncResult -and -not $asyncResult.IsCompleted) {
                try { $pipeline.Stop() } catch {}
            }
            $pipelineDisposed = $false
            if ($null -ne $pipeline) {
                try {
                    [void]$pipeline.Dispose()
                    $pipelineDisposed = $true
                }
                catch {
                    $Lifecycle.InfrastructureErrors.Add(
                        "item '$($preparedItem.Id)' pipeline disposal failed: $($_.Exception.Message)")
                }
            }
            if ($pipelineDisposed -and
                    [object]::ReferenceEquals($Lifecycle.PendingPipeline, $pipeline)) {
                $Lifecycle.PendingPipeline = $null
            }
            $Lifecycle.Results[$preparedItem.Index] = New-BatchExecutorItemResult `
                -Id $preparedItem.Id -Index $preparedItem.Index -OriginalInput $preparedItem.Input `
                -State Failed -Errors @($submissionError.ToString()) `
                -QueuedUtc ([datetime]::UtcNow) -EndedUtc ([datetime]::UtcNow) -DurationMs 0 `
                -Observation (New-BatchExecutorObservation -Submitted:$false -Started:$false `
                    -StopReason '' -StopPhase Dispatch) `
                -Capture (New-BatchExecutorCaptureRecord -StdOutComplete:$false -StdErrComplete:$false `
                    -Protocol $(if ($preparedItem.Mode -eq 'Process') { 'missing' } else { 'not-applicable' }))
        }
    }
    $Lifecycle.Timing['DispatchMs'] = $swDispatch.ElapsedMilliseconds
    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Dispatched
}
