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
    try {
        Start-BatchExecutorInvocations -Lifecycle $lifecycle
        Wait-BatchExecutorInvocations -Lifecycle $lifecycle
        Receive-BatchExecutorResults -Lifecycle $lifecycle
    }
    finally {
        Stop-BatchExecutorLifecycle -Lifecycle $lifecycle
    }

    $swTotal.Stop()
    $lifecycle.Timing['TotalMs'] = $swTotal.ElapsedMilliseconds
    New-BatchExecutorExecutionRecord -Lifecycle $lifecycle
}
