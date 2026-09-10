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
        [ValidateRange(0, [int]::MaxValue)] [int] $ExecutionTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $CleanupTimeoutSeconds = 30,
        [ValidateRange(1, [long]::MaxValue)] [long] $MaxStdOutBytes = 8MB,
        [ValidateRange(1, [long]::MaxValue)] [long] $MaxStdErrBytes = 8MB,
        [ValidateRange(1, [long]::MaxValue)] [long] $MaxProtocolBytes = 16MB,
        [ValidateRange(1, [int]::MaxValue)] [int] $MaxFrameBytes = 1MB,
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

    Import-BatchExecutorNative
    $swTotal = [System.Diagnostics.Stopwatch]::StartNew()
    $timeouts = New-BatchExecutorTimeoutPolicy `
        -ExecutionTimeoutSeconds $ExecutionTimeoutSeconds `
        -WaitTimeoutSeconds $WaitTimeoutSeconds `
        -CleanupTimeoutSeconds $CleanupTimeoutSeconds `
        -ProcessTimeoutSeconds $ProcessTimeoutSeconds
    $deadline = New-BatchExecutorDeadlineClock -Timeouts $timeouts
    $swPrep = [System.Diagnostics.Stopwatch]::StartNew()
    $preparation = Resolve-BatchExecutorPreparation -InputObject $InputObject `
        -ScriptPath $ScriptPath -ExecutionMode $ExecutionMode `
        -ExecutionModeProperty $ExecutionModeProperty -ProcessSpecProperty $ProcessSpecProperty `
        -Context $Context -InitializationScriptPath $InitializationScriptPath `
        -ModulePath $ModulePath -IssPreset $IssPreset -MaxWorkers $MaxWorkers `
        -ReservedCores $ReservedCores -MinItemsPerWorker $MinItemsPerWorker `
        -IdProperty $IdProperty -SerializationDepth $SerializationDepth `
        -ProcessTimeoutSeconds $ProcessTimeoutSeconds -WaitTimeoutSeconds $WaitTimeoutSeconds `
        -ExecutionTimeoutSeconds $ExecutionTimeoutSeconds `
        -CleanupTimeoutSeconds $CleanupTimeoutSeconds `
        -MaxStdOutBytes $MaxStdOutBytes -MaxStdErrBytes $MaxStdErrBytes `
        -MaxProtocolBytes $MaxProtocolBytes -MaxFrameBytes $MaxFrameBytes `
        -CancellationToken $CancellationToken -RunspaceDataPolicy $RunspaceDataPolicy `
        -PowerShellPath $PowerShellPath -WorkingDirectory $WorkingDirectory `
        -ProcessEnvironment $ProcessEnvironment -CreateNoWindow $CreateNoWindow `
        -WindowStyle $WindowStyle -LoadProfile:$LoadProfile -PriorityClass $PriorityClass
    $swPrep.Stop()

    $count = $preparation.ItemCount
    $budget = $preparation.Budget
    $policy = $preparation.Policy

    if ($count -eq 0) {
        $emptyErrors = [System.Collections.Generic.List[string]]::new()
        $emptyWarnings = [System.Collections.Generic.List[string]]::new()
        Add-BatchExecutorString -List $emptyWarnings -Value $budget.Warnings
        $emptyProperties = [ordered]@{
            Results = [object[]]::new(0)
            Errors = [string[]]$emptyErrors.ToArray()
            Warnings = [string[]]$emptyWarnings.ToArray()
            Budget = $budget
            Timing = [pscustomobject]@{
                PrepareMs = $swPrep.ElapsedMilliseconds
                TotalMs = $swTotal.ElapsedMilliseconds
            }
            Policy = $policy
            Summary = [pscustomobject]@{ Total = 0; Succeeded = 0; Failed = 0; TimedOut = 0; Cancelled = 0 }
            Cleanup = New-BatchExecutorCleanupRecord -State Confirmed
            Runtime = $preparation.Runtime
        }
        return (New-BatchExecutorPropertyRecord -Property $emptyProperties)
    }

    $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
    $lifecycle.Deadline = $deadline
    $lifecycle.Timing['PrepareMs'] = $swPrep.ElapsedMilliseconds
    try {
        if ($deadline.ExecutionExpired) {
            foreach ($preparedItem in $preparation.Items) {
                $lifecycle.Results[$preparedItem.Index] = New-BatchExecutorNeverStartedResult `
                    -PreparedItem $preparedItem -State TimedOut -StopReason ExecutionTimeout `
                    -StopPhase Preparation -Message 'executor execution timeout before dispatch'
            }
            $lifecycle.WaitOutcome = New-BatchExecutorWaitOutcome -Kind ExecutionTimeout
            $lifecycle.CompletedNormally = $true
        }
        else {
            Start-BatchExecutorInvocations -Lifecycle $lifecycle
            Wait-BatchExecutorInvocations -Lifecycle $lifecycle
            Receive-BatchExecutorResults -Lifecycle $lifecycle
        }
    }
    finally {
        Stop-BatchExecutorLifecycle -Lifecycle $lifecycle
    }

    $swTotal.Stop()
    $lifecycle.Timing['TotalMs'] = $swTotal.ElapsedMilliseconds
    New-BatchExecutorExecutionRecord -Lifecycle $lifecycle
}
