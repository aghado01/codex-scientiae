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
        # PendingPipeline closes the narrow window before BeginInvoke returns and a complete
        # InvocationState can be registered.
        $pipeline = $null
        $asyncResult = $null
        try {
            # Construction and command binding are part of the item-local ownership boundary too.
            # Until registration succeeds, this scope must dispose every handle it acquires.
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
            }

            $asyncResult = $pipeline.BeginInvoke()
            $invocation = New-BatchExecutorInvocationState -PreparedItem $preparedItem `
                -Pipeline $pipeline -AsyncResult $asyncResult -QueuedUtc ([datetime]::UtcNow)
            $Lifecycle.Invocations.Add($invocation)
            $Lifecycle.PendingPipeline = $null
        }
        catch {
            $submissionError = $_
            if ($null -eq $pipeline) { $pipeline = $Lifecycle.PendingPipeline }
            # BeginInvoke failure is item-local. If submission itself succeeded but registration failed,
            # stop that unowned pipeline before disposing it so the lifecycle cannot lose a live handle.
            if ($null -ne $asyncResult -and -not $asyncResult.IsCompleted) {
                try {
                    $stopAsync = $pipeline.BeginStop($null, $null)
                    $pipeline.EndStop($stopAsync)
                }
                catch {}
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
            $Lifecycle.Results[$preparedItem.Index] = [pscustomobject]@{
                Id = $preparedItem.Id
                Index = $preparedItem.Index
                Input = $preparedItem.Input
                State = 'Failed'
                Output = @()
                Errors = @($submissionError.ToString())
                Warnings = @()
                Information = @()
                QueuedUtc = [datetime]::UtcNow
                StartedUtc = $null
                EndedUtc = [datetime]::UtcNow
                DurationMs = 0
                RunspaceId = $null
                ThreadId = $null
                ProcessId = $null
                ExitCode = $null
                StdOut = @()
                StdErr = @()
            }
        }
    }
    $Lifecycle.Timing['DispatchMs'] = $swDispatch.ElapsedMilliseconds
    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Dispatched
}
