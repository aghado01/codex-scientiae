function New-BatchExecutorPropertyRecord {
    param([System.Collections.Specialized.OrderedDictionary] $Property)

    $record = New-Object PSObject
    foreach ($key in $Property.Keys) {
        [void]$record.PSObject.Properties.Add(
            [System.Management.Automation.PSNoteProperty]::new([string]$key, $Property[$key]))
    }
    return $record
}

function Add-BatchExecutorString {
    param(
        [System.Collections.Generic.List[string]] $List,
        [AllowNull()] [object] $Value
    )

    if ($null -eq $List) { return }

    foreach ($item in @($Value)) {
        if ($null -eq $item) { continue }
        $text = [string]$item
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        [void]$List.Add($text)
    }
}

function New-BatchExecutorTimeoutPolicy {
    [CmdletBinding()]
    param(
        [ValidateRange(0, [int]::MaxValue)] [int] $ExecutionTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $CleanupTimeoutSeconds = 30,
        [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0
    )

    return [pscustomobject]@{
        ExecutionTimeoutSeconds = $ExecutionTimeoutSeconds
        WaitTimeoutSeconds = $WaitTimeoutSeconds
        CleanupTimeoutSeconds = $CleanupTimeoutSeconds
        ProcessTimeoutSeconds = $ProcessTimeoutSeconds
    }
}

function New-BatchExecutorObservation {
    [CmdletBinding()]
    param(
        [bool] $Submitted = $false,
        [bool] $Started = $false,
        [string] $StopReason = '',
        [string] $StopPhase = ''
    )

    return [pscustomobject]@{
        Submitted = [bool]$Submitted
        Started = [bool]$Started
        StopReason = [string]$StopReason
        StopPhase = [string]$StopPhase
    }
}

function New-BatchExecutorCaptureRecord {
    [CmdletBinding()]
    param(
        [bool] $StdOutComplete = $true,
        [bool] $StdErrComplete = $true,
        [ValidateSet('not-applicable', 'ok', 'missing', 'malformed', 'native-exit', 'truncated')]
        [string] $Protocol = 'not-applicable',
        [bool] $Truncated = $false,
        [bool] $StdOutLossy = $false,
        [bool] $StdErrLossy = $false,
        [long] $StdOutBytes = 0,
        [long] $StdErrBytes = 0,
        [long] $ProtocolBytes = 0
    )

    return [pscustomobject]@{
        StdOutComplete = [bool]$StdOutComplete
        StdErrComplete = [bool]$StdErrComplete
        Protocol = $Protocol
        Truncated = [bool]$Truncated
        StdOutLossy = [bool]$StdOutLossy
        StdErrLossy = [bool]$StdErrLossy
        StdOutBytes = [long]$StdOutBytes
        StdErrBytes = [long]$StdErrBytes
        ProtocolBytes = [long]$ProtocolBytes
    }
}

function New-BatchExecutorCleanupRecord {
    [CmdletBinding()]
    param(
        [ValidateSet('Confirmed', 'Incomplete')] [string] $State = 'Confirmed',
        [string] $Reason = ''
    )

    return [pscustomobject]@{
        State = $State
        Reason = [string]$Reason
    }
}

function New-BatchExecutorItemResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Id,
        [Parameter(Mandatory)] [int] $Index,
        [AllowNull()] [object] $OriginalInput,
        [ValidateSet('Succeeded', 'Failed', 'TimedOut', 'Cancelled')] [string] $State,
        [AllowNull()] [object[]] $Output = @(),
        [AllowNull()] [string[]] $Errors = @(),
        [AllowNull()] [string[]] $Warnings = @(),
        [AllowNull()] [string[]] $Information = @(),
        [datetime] $QueuedUtc = [datetime]::UtcNow,
        [AllowNull()] [nullable[datetime]] $StartedUtc = $null,
        [AllowNull()] [nullable[datetime]] $EndedUtc = $null,
        [AllowNull()] [object] $DurationMs = $null,
        [AllowNull()] [string] $RunspaceId = $null,
        [AllowNull()] [object] $ThreadId = $null,
        [AllowNull()] [object] $ProcessId = $null,
        [AllowNull()] [object] $ExitCode = $null,
        [AllowNull()] [string[]] $StdOut = @(),
        [AllowNull()] [string[]] $StdErr = @(),
        [AllowNull()] [object] $Observation,
        [AllowNull()] [object] $Capture
    )

    if ($null -eq $Observation) {
        $Observation = New-BatchExecutorObservation
    }
    if ($null -eq $Capture) {
        $Capture = New-BatchExecutorCaptureRecord
    }
    if ($null -eq $EndedUtc) { $EndedUtc = [datetime]::UtcNow }

    $errorList = [System.Collections.Generic.List[string]]::new()
    $warningList = [System.Collections.Generic.List[string]]::new()
    $informationList = [System.Collections.Generic.List[string]]::new()
    Add-BatchExecutorString -List $errorList -Value $Errors
    Add-BatchExecutorString -List $warningList -Value $Warnings
    Add-BatchExecutorString -List $informationList -Value $Information

    $properties = [ordered]@{
        Id = $Id
        Index = $Index
        Input = $OriginalInput
        State = $State
        Output = [object[]]@($Output)
        Errors = [string[]]$errorList.ToArray()
        Warnings = [string[]]$warningList.ToArray()
        Information = [string[]]$informationList.ToArray()
        QueuedUtc = $QueuedUtc
        StartedUtc = $StartedUtc
        EndedUtc = $EndedUtc
        DurationMs = $DurationMs
        RunspaceId = $RunspaceId
        ThreadId = $ThreadId
        ProcessId = $ProcessId
        ExitCode = $ExitCode
        StdOut = [string[]]@($StdOut)
        StdErr = [string[]]@($StdErr)
        Observation = $Observation
        Capture = $Capture
    }
    return (New-BatchExecutorPropertyRecord -Property $properties)
}

function ConvertTo-BatchExecutorWaitKind {
    [CmdletBinding()]
    param(
        [AllowNull()] [string] $ExpiredScope,
        [bool] $CancellationObserved
    )

    if ($CancellationObserved) { return 'CallerCancellation' }
    switch ($ExpiredScope) {
        'Execution' { return 'ExecutionTimeout' }
        'Wait' { return 'BatchTimeout' }
        default { return 'BatchTimeout' }
    }
}
