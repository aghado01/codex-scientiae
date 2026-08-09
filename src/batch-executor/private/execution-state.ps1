function New-BatchExecutorResolvedProcessSpec {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $PowerShellPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $WorkingDirectory,
        [ValidateRange(0, [int]::MaxValue)] [int] $TimeoutSeconds = 0,
        [bool] $CreateNoWindow = $true,
        [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')] [string] $WindowStyle = 'Hidden',
        [bool] $LoadProfile = $false,
        [System.Collections.IDictionary] $Environment = @{},
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')] [string] $PriorityClass = 'Normal'
    )

    $environmentSnapshot = @{}
    if ($null -ne $Environment) {
        foreach ($key in @($Environment.Keys)) {
            $value = $Environment[$key]
            $environmentSnapshot[[string]$key] = if ($null -eq $value) { $null }
                else { [string]$value }
        }
    }

    $record = [pscustomobject]@{
        PowerShellPath = $PowerShellPath
        WorkingDirectory = $WorkingDirectory
        TimeoutSeconds = $TimeoutSeconds
        CreateNoWindow = $CreateNoWindow
        WindowStyle = $WindowStyle
        LoadProfile = $LoadProfile
        Environment = $environmentSnapshot
        PriorityClass = $PriorityClass
    }
    $record.PSObject.TypeNames.Insert(
        0, 'CodexScientiae.BatchExecutor.Internal.ResolvedProcessSpec')
    return $record
}

function New-BatchExecutorPreparedItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateRange(0, [int]::MaxValue)] [int] $Index,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Id,
        [Parameter(Mandatory)] [ValidateSet('Runspace', 'Process')] [string] $Mode,
        [Parameter(Mandatory)] [AllowNull()] [object] $OriginalInput,
        [AllowNull()] [object] $DispatchItem,
        [AllowNull()] [object] $DispatchContext,
        [AllowNull()] [string] $ProcessPayloadXml,
        [AllowNull()] [object] $ProcessSpec
    )

    if ($Mode -eq 'Runspace') {
        if ($PSBoundParameters.ContainsKey('ProcessPayloadXml') -or `
                $PSBoundParameters.ContainsKey('ProcessSpec')) {
            throw "runspace prepared item '$Id' must not contain process dispatch material"
        }
    }
    else {
        if ([string]::IsNullOrWhiteSpace($ProcessPayloadXml) -or $null -eq $ProcessSpec) {
            throw "process prepared item '$Id' requires payload XML and a resolved process specification"
        }
        if ($ProcessSpec.PSObject.TypeNames -notcontains `
                'CodexScientiae.BatchExecutor.Internal.ResolvedProcessSpec') {
            throw "process prepared item '$Id' requires a batch-executor resolved process specification"
        }
        if ($PSBoundParameters.ContainsKey('DispatchItem') -or `
                $PSBoundParameters.ContainsKey('DispatchContext')) {
            throw "process prepared item '$Id' must not retain direct dispatch data"
        }
    }

    $record = [pscustomobject]@{
        Index = $Index
        Id = $Id
        Mode = $Mode
        Input = $OriginalInput
        DispatchItem = $DispatchItem
        DispatchContext = $DispatchContext
        ProcessPayloadXml = $ProcessPayloadXml
        ProcessSpec = $ProcessSpec
    }
    $record.PSObject.TypeNames.Insert(
        0, 'CodexScientiae.BatchExecutor.Internal.PreparedItem')
    return $record
}

function New-BatchExecutorPreparation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Item,
        [Parameter(Mandatory)] [ValidateSet('Runspace', 'Process', 'Mixed')] [string] $ExecutionMode,
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $WorkerDefinition,
        [AllowNull()] [object] $InitializerDefinition,
        [Parameter(Mandatory)] [ValidateSet('Bare', 'Core', 'Full')] [string] $IssPreset,
        [AllowEmptyCollection()] [string[]] $ModulePath = @(),
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Budget,
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Policy,
        [System.Threading.CancellationToken] $CancellationToken = `
            [System.Threading.CancellationToken]::None,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [AllowNull()] [object] $InitialSessionState,
        [AllowNull()] [string] $EncodedChildCommand
    )

    $items = [object[]]@($Item)
    $seenIds = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    $hasRunspaceItems = $false
    $hasProcessItems = $false
    for ($i = 0; $i -lt $items.Count; $i++) {
        $preparedItem = $items[$i]
        if ($null -eq $preparedItem -or $preparedItem.PSObject.TypeNames -notcontains `
                'CodexScientiae.BatchExecutor.Internal.PreparedItem') {
            throw "batch executor preparation item [$i] is not a prepared item"
        }
        if ($preparedItem.Index -ne $i) {
            throw "batch executor preparation item [$i] has noncanonical index '$($preparedItem.Index)'"
        }
        if (-not $seenIds.Add([string]$preparedItem.Id)) {
            throw "batch executor preparation contains duplicate item id '$($preparedItem.Id)'"
        }
        if ($preparedItem.Mode -eq 'Process') { $hasProcessItems = $true }
        else { $hasRunspaceItems = $true }
    }

    if ($items.Count -gt 0 -and $null -eq $InitialSessionState) {
        throw 'nonempty batch executor preparation requires an initial session state'
    }
    if (($ExecutionMode -eq 'Runspace' -and $hasProcessItems) -or `
            ($ExecutionMode -eq 'Process' -and $hasRunspaceItems)) {
        throw "batch executor preparation items do not match execution mode '$ExecutionMode'"
    }
    if ($hasProcessItems -and [string]::IsNullOrWhiteSpace($EncodedChildCommand)) {
        throw 'process batch executor preparation requires an encoded child command'
    }

    $record = [pscustomobject]@{
        ItemCount = $items.Count
        Items = $items
        ExecutionMode = $ExecutionMode
        HasRunspaceItems = $hasRunspaceItems
        HasProcessItems = $hasProcessItems
        WorkerDefinition = $WorkerDefinition
        InitializerDefinition = $InitializerDefinition
        IssPreset = $IssPreset
        ModulePath = [string[]]@($ModulePath)
        Budget = $Budget
        Policy = $Policy
        CancellationToken = $CancellationToken
        WaitTimeoutSeconds = $WaitTimeoutSeconds
        WaitSliceMilliseconds = 200
        ProcessDrainMilliseconds = 5000
        InitialSessionState = $InitialSessionState
        EncodedChildCommand = $EncodedChildCommand
    }
    $record.PSObject.TypeNames.Insert(
        0, 'CodexScientiae.BatchExecutor.Internal.ExecutionPreparation')
    return $record
}

function New-BatchExecutorLifecycleState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Preparation
    )

    if ($Preparation.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.ExecutionPreparation') {
        throw 'batch executor lifecycle requires an execution preparation record'
    }

    $record = [pscustomobject]@{
        Preparation = $Preparation
        Phase = 'Prepared'
        Pool = $null
        PendingPipeline = $null
        Invocations = [System.Collections.Generic.List[object]]::new($Preparation.ItemCount)
        Results = [object[]]::new($Preparation.ItemCount)
        ChildProcessRegistry = `
            [System.Collections.Concurrent.ConcurrentDictionary[string, System.Diagnostics.Process]]::new(
                [System.StringComparer]::OrdinalIgnoreCase)
        InfrastructureErrors = [System.Collections.Generic.List[string]]::new()
        Timing = [ordered]@{}
        WaitOutcome = $null
        CompletedNormally = $false
        TeardownCompleted = $false
    }
    $record.PSObject.TypeNames.Insert(
        0, 'CodexScientiae.BatchExecutor.Internal.LifecycleState')
    return $record
}

function Set-BatchExecutorLifecyclePhase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle,
        [Parameter(Mandatory)]
        [ValidateSet('Dispatching', 'Dispatched', 'Awaiting', 'Awaited', 'Collecting', 'Collected',
            'TearingDown', 'Closed')]
        [string] $Phase
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor phase transition requires a lifecycle state record'
    }

    $legalTransitions = @{
        Prepared = @('Dispatching', 'TearingDown')
        Dispatching = @('Dispatched', 'TearingDown')
        Dispatched = @('Awaiting', 'TearingDown')
        Awaiting = @('Awaited', 'TearingDown')
        Awaited = @('Collecting', 'TearingDown')
        Collecting = @('Collected', 'TearingDown')
        Collected = @('TearingDown')
        TearingDown = @('Closed')
        Closed = @()
    }
    $current = [string]$Lifecycle.Phase
    if ($Phase -notin @($legalTransitions[$current])) {
        throw "illegal batch executor lifecycle transition: $current -> $Phase"
    }

    switch ($Phase) {
        'Dispatched' {
            if ($null -ne $Lifecycle.PendingPipeline) {
                throw 'batch executor cannot enter Dispatched with an unpublished pending pipeline'
            }
            $accountedIndexes = [System.Collections.Generic.HashSet[int]]::new()
            foreach ($invocation in $Lifecycle.Invocations) {
                $index = [int]$invocation.PreparedItem.Index
                if (-not $accountedIndexes.Add($index)) {
                    throw "batch executor dispatch accounted for item index $index more than once"
                }
            }
            for ($index = 0; $index -lt $Lifecycle.Results.Count; $index++) {
                if ($null -ne $Lifecycle.Results[$index] -and
                        -not $accountedIndexes.Add($index)) {
                    throw "batch executor dispatch accounted for item index $index more than once"
                }
            }
            if ($accountedIndexes.Count -ne $Lifecycle.Preparation.ItemCount) {
                throw 'batch executor cannot enter Dispatched with unaccounted prepared items'
            }
        }
        'Awaited' {
            if ($null -eq $Lifecycle.WaitOutcome -or
                    $Lifecycle.WaitOutcome.PSObject.TypeNames -notcontains `
                        'CodexScientiae.BatchExecutor.Internal.WaitOutcome') {
                throw 'batch executor cannot enter Awaited without a typed wait outcome'
            }
        }
        'Collected' {
            for ($index = 0; $index -lt $Lifecycle.Results.Count; $index++) {
                if ($null -eq $Lifecycle.Results[$index]) {
                    throw 'batch executor cannot enter Collected with unmaterialized results'
                }
            }
        }
        'Closed' {
            if (-not $Lifecycle.TeardownCompleted) {
                throw 'batch executor cannot enter Closed before teardown completes'
            }
            if ($null -ne $Lifecycle.Pool) {
                throw 'batch executor cannot enter Closed while it retains the runspace pool'
            }
            if ($null -ne $Lifecycle.PendingPipeline) {
                throw 'batch executor cannot enter Closed while it retains a pending pipeline'
            }
            foreach ($invocation in $Lifecycle.Invocations) {
                if ($null -ne $invocation.Pipeline -or $null -ne $invocation.AsyncResult) {
                    throw 'batch executor cannot enter Closed while it retains invocation handles'
                }
            }
            if ($Lifecycle.ChildProcessRegistry.Count -gt 0) {
                throw 'batch executor cannot enter Closed while it retains child process records'
            }
        }
    }
    $Lifecycle.Phase = $Phase
}

function New-BatchExecutorInvocationState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $PreparedItem,
        [Parameter(Mandatory)] [ValidateNotNull()]
        [System.Management.Automation.PowerShell] $Pipeline,
        [Parameter(Mandatory)] [ValidateNotNull()] [System.IAsyncResult] $AsyncResult,
        [Parameter(Mandatory)] [datetime] $QueuedUtc
    )

    if ($PreparedItem.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.PreparedItem') {
        throw 'batch executor invocation requires a prepared item record'
    }

    $record = [pscustomobject]@{
        PreparedItem = $PreparedItem
        Pipeline = $Pipeline
        AsyncResult = $AsyncResult
        QueuedUtc = $QueuedUtc
        TerminalOverride = $null
    }
    $record.PSObject.TypeNames.Insert(
        0, 'CodexScientiae.BatchExecutor.Internal.InvocationState')
    return $record
}

function Set-BatchExecutorInvocationTerminalOverride {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Invocation,
        [Parameter(Mandatory)] [ValidateSet('Cancelled', 'TimedOut')] [string] $State
    )

    if ($Invocation.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.InvocationState') {
        throw 'batch executor terminal override requires an invocation state record'
    }
    if ($null -ne $Invocation.TerminalOverride -and $Invocation.TerminalOverride -ne $State) {
        throw "batch executor invocation terminal override is already '$($Invocation.TerminalOverride)'"
    }
    $Invocation.TerminalOverride = $State
}

function New-BatchExecutorWaitOutcome {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Completed', 'CallerCancellation', 'BatchTimeout')]
        [string] $Kind,
        [AllowNull()] [string] $Reason
    )

    if (-not $PSBoundParameters.ContainsKey('Reason')) {
        $Reason = switch ($Kind) {
            'CallerCancellation' { 'caller cancellation' }
            'BatchTimeout' { 'batch wait timeout' }
            default { $null }
        }
    }

    $record = [pscustomobject]@{
        Kind = $Kind
        Reason = $Reason
    }
    $record.PSObject.TypeNames.Insert(
        0, 'CodexScientiae.BatchExecutor.Internal.WaitOutcome')
    return $record
}
