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
    $preparation = Resolve-BatchExecutorPreparation -InputObject $InputObject `
        -ScriptPath $ScriptPath -ExecutionMode $ExecutionMode `
        -ExecutionModeProperty $ExecutionModeProperty -ProcessSpecProperty $ProcessSpecProperty `
        -Context $Context -InitializationScriptPath $InitializationScriptPath `
        -ModulePath $ModulePath -IssPreset $IssPreset -MaxWorkers $MaxWorkers `
        -ReservedCores $ReservedCores -MinItemsPerWorker $MinItemsPerWorker `
        -IdProperty $IdProperty -SerializationDepth $SerializationDepth `
        -ProcessTimeoutSeconds $ProcessTimeoutSeconds -WaitTimeoutSeconds $WaitTimeoutSeconds `
        -CancellationToken $CancellationToken -RunspaceDataPolicy $RunspaceDataPolicy `
        -PowerShellPath $PowerShellPath -WorkingDirectory $WorkingDirectory `
        -ProcessEnvironment $ProcessEnvironment -CreateNoWindow $CreateNoWindow `
        -WindowStyle $WindowStyle -LoadProfile:$LoadProfile -PriorityClass $PriorityClass

    $count = $preparation.ItemCount
    $budget = $preparation.Budget
    $policy = $preparation.Policy

    if ($count -eq 0) {
        return [pscustomobject]@{
            Results = [object[]]::new(0); Errors = @(); Warnings = @($budget.Warnings)
            Budget = $budget; Timing = [pscustomobject]@{ TotalMs = $swTotal.ElapsedMilliseconds }
            Policy = $policy
            Summary = [pscustomobject]@{ Total = 0; Succeeded = 0; Failed = 0; TimedOut = 0; Cancelled = 0 }
        }
    }

    $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
    # These are borrowed references for the still-inline phases. LifecycleState remains their sole owner.
    $invocations = $lifecycle.Invocations
    $ordered = $lifecycle.Results
    $infrastructureErrors = $lifecycle.InfrastructureErrors
    $processRegistry = $lifecycle.ChildProcessRegistry
    $timing = $lifecycle.Timing

    try {
        Start-BatchExecutorInvocations -Lifecycle $lifecycle
        Wait-BatchExecutorInvocations -Lifecycle $lifecycle
        Receive-BatchExecutorResults -Lifecycle $lifecycle
    }
    finally {
        # This path also runs when Ctrl+C or an infrastructure exception unwinds the function.
        # Kill children first, then stop their supervising pipelines; no child is left orphaned.
        try {
            if ($lifecycle.Phase -notin @('TearingDown', 'Closed')) {
                Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase TearingDown
            }
        }
        catch { $infrastructureErrors.Add("could not enter teardown phase: $($_.Exception.Message)") }
        Stop-BatchExecutorChildProcesses -Registry $processRegistry `
            -Reason $(if ($lifecycle.CompletedNormally) { 'final registry cleanup' } else { 'exceptional batch teardown' }) `
            -Diagnostics $infrastructureErrors
        Stop-BatchExecutorPipelines -Invocations $invocations
        $pendingPipeline = $lifecycle.PendingPipeline
        Stop-BatchExecutorPendingPipeline -Pipeline $pendingPipeline
        foreach ($invocation in $invocations) {
            if ($null -ne $invocation.Pipeline -and
                    -not [object]::ReferenceEquals($invocation.Pipeline, $pendingPipeline)) {
                try { $invocation.Pipeline.Dispose() } catch {}
            }
        }
        if ($null -ne $pendingPipeline) {
            try { $pendingPipeline.Dispose() } catch {}
            $lifecycle.PendingPipeline = $null
        }
        if ($null -ne $lifecycle.Pool) {
            try { $lifecycle.Pool.Close() } catch {}
            try { $lifecycle.Pool.Dispose() } catch {}
        }
        $lifecycle.TeardownCompleted = $true
        try {
            if ($lifecycle.Phase -eq 'TearingDown') {
                Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Closed
            }
        }
        catch { $infrastructureErrors.Add("could not close teardown phase: $($_.Exception.Message)") }
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
