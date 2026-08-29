function Invoke-JsonlEngineValues {
    param(
        [Parameter(Mandatory)] [string] $Verb,
        [string[]] $Argument = @(),
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [int] $TimeoutSeconds = 300
    )

    Invoke-JsonlEngineCommand -Verb $Verb -Argument $Argument -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds |
        Write-JsonlEngineValue -AsHashtable:$AsHashtable -AsFrame:$AsFrame
}

function Invoke-SingleJsonlEngineValue {
    param(
        [Parameter(Mandatory)] [string] $Verb,
        [string[]] $Argument = @(),
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [int] $TimeoutSeconds = 300
    )

    $frames = @(Invoke-JsonlEngineCommand -Verb $Verb -Argument $Argument `
            -PythonPath $PythonPath -TimeoutSeconds $TimeoutSeconds)
    if ($frames.Count -ne 1) {
        throw "jsonl engine verb '$Verb' returned $($frames.Count) values; expected exactly one"
    }
    Write-JsonlEngineValue -Frame $frames[0] -AsHashtable:$AsHashtable -AsFrame:$AsFrame
}

function Get-JsonlEngineCapability {
    <# Return the CLI protocol version, framing support, and stable verb set. #>
    [CmdletBinding()]
    param(
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    Invoke-SingleJsonlEngineValue -Verb capabilities -AsHashtable:$AsHashtable `
        -AsFrame:$AsFrame -PythonPath $PythonPath -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlInfo {
    <# Return physical facts without parsing record payloads. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    Invoke-SingleJsonlEngineValue -Verb info -Argument @($resolvedPath) `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlCount {
    <# Return the number of records in the selected store view. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    if ($AsFrame) {
        Invoke-SingleJsonlEngineValue -Verb count -Argument $arguments.ToArray() -AsFrame `
            -PythonPath $PythonPath -TimeoutSeconds $TimeoutSeconds
        return
    }
    $result = Invoke-SingleJsonlEngineValue -Verb count -Argument $arguments.ToArray() `
        -PythonPath $PythonPath -TimeoutSeconds $TimeoutSeconds
    return [long]$result.count
}

function Get-JsonlHead {
    <# Return the first Count records in the selected view. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Position = 1)] [ValidateRange(0, [int]::MaxValue)] [int] $Count = 10,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    foreach ($item in @($resolvedPath, '-n', [string]$Count)) { $arguments.Add($item) }
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-JsonlEngineValues -Verb head -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlTail {
    <# Return the last Count records in the selected view. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Position = 1)] [ValidateRange(0, [int]::MaxValue)] [int] $Count = 10,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    foreach ($item in @($resolvedPath, '-n', [string]$Count)) { $arguments.Add($item) }
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-JsonlEngineValues -Verb tail -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlRange {
    <# Return records in the half-open interval [Start, Stop). #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Mandatory, Position = 1)] [int] $Start,
        [Parameter(Position = 2)] [Nullable[int]] $Stop,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    $arguments.Add([string]$Start)
    if ($null -ne $Stop) { $arguments.Add([string]$Stop) }
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-JsonlEngineValues -Verb range -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlRecord {
    <# Return one record by index; negative indexes count from the end. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Mandatory, Position = 1)] [int] $At,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    $arguments.Add([string]$At)
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-SingleJsonlEngineValue -Verb get -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Select-JsonlPath {
    <# Project one RFC 6901 JSON Pointer from each record, skipping missing values. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Mandatory, Position = 1)] [string] $Pointer,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    $arguments.Add($Pointer)
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-JsonlEngineValues -Verb select -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Find-JsonlRecord {
    <# Return records whose pointer value satisfies a raw-JSON or typed predicate. #>
    [CmdletBinding(DefaultParameterSetName = 'RawJson')]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Mandatory, Position = 1)] [string] $Pointer,
        [Parameter(Mandatory, Position = 2)]
        [ValidateSet('eq', 'ne', 'gt', 'lt', 'contains', 'exists', 'missing')] [string] $Op,
        [Parameter(Position = 3, ParameterSetName = 'RawJson')]
        [Alias('JsonValue')] [string] $Value,
        [Parameter(Mandatory, ParameterSetName = 'Typed')]
        [AllowNull()] $InputObject,
        [ValidateRange(0, [int]::MaxValue)] [int] $Limit = 0,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )

    $hasJsonValue = $PSBoundParameters.ContainsKey('Value')
    $hasTypedValue = $PSBoundParameters.ContainsKey('InputObject')
    if ($Op -in @('exists', 'missing') -and ($hasJsonValue -or $hasTypedValue)) {
        throw "predicate '$Op' does not accept a comparison value"
    }
    $encodedValue = if ($hasTypedValue) {
        Assert-JsonlEngineJsonValue -Value $InputObject -MaximumDepth 100
        ConvertTo-Json -InputObject $InputObject -Compress -Depth 100 -WarningAction Stop
    }
    elseif ($hasJsonValue) {
        $Value
    }
    else {
        $null
    }

    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    foreach ($item in @($resolvedPath, $Pointer, $Op)) { $arguments.Add($item) }
    if ($null -ne $encodedValue) { $arguments.Add([string]$encodedValue) }
    if ($Limit -gt 0) {
        $arguments.Add('--limit')
        $arguments.Add([string]$Limit)
    }
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-JsonlEngineValues -Verb find -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Test-JsonlStore {
    <# Verify the physical store or the signed committed prefix against its signature. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [ValidateSet('Signed', 'Physical')] [string] $View = 'Physical',
        [switch] $AtSignature,
        [switch] $Unbounded,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    foreach ($item in @(Resolve-JsonlEngineViewArguments -BoundParameters $PSBoundParameters `
                -View $View)) { $arguments.Add($item) }
    Invoke-SingleJsonlEngineValue -Verb verify -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlSignature {
    <# Return the engine signature sidecar for a store. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    Invoke-SingleJsonlEngineValue -Verb sig -Argument @($resolvedPath) `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlPrefix {
    <# Walk records until the first framing or JSON failure. Does not mutate the store. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [switch] $Collect,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    if ($Collect) { $arguments.Add('--collect') }
    Invoke-SingleJsonlEngineValue -Verb inspect-prefix -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Repair-JsonlPrefix {
    <# Preview or publish a complete-record prefix onto the store. Dry-run unless -Apply. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [switch] $Apply,
        [int] $Bytes,
        [string] $BackupLabel = '',
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $arguments = [System.Collections.Generic.List[string]]::new()
    $arguments.Add($resolvedPath)
    if ($Apply) { $arguments.Add('--apply') }
    if ($PSBoundParameters.ContainsKey('Bytes')) {
        $arguments.Add('--bytes')
        $arguments.Add([string]$Bytes)
    }
    if (-not [string]::IsNullOrWhiteSpace($BackupLabel)) {
        $arguments.Add('--backup-label')
        $arguments.Add($BackupLabel)
    }
    Invoke-SingleJsonlEngineValue -Verb repair-prefix -Argument $arguments.ToArray() `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function New-JsonlSnapshot {
    <# Copy the complete-record prefix byte-for-byte to a new destination. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [Parameter(Mandatory, Position = 1)] [string] $Destination,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    $resolvedDestination = Resolve-JsonlEnginePathArgument -Path $Destination
    Invoke-SingleJsonlEngineValue -Verb snapshot `
        -Argument @($resolvedPath, $resolvedDestination) `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}

function Get-JsonlSchema {
    <# Return the schemas and declared identities shipped by the engine. #>
    [CmdletBinding()]
    param(
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    Invoke-JsonlEngineValues -Verb schemas -AsHashtable:$AsHashtable -AsFrame:$AsFrame `
        -PythonPath $PythonPath -TimeoutSeconds $TimeoutSeconds
}

function Read-JsonDocument {
    <# Read one JSON document under the engine's declared decoding rules. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Path,
        [switch] $AsHashtable,
        [switch] $AsFrame,
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )
    $resolvedPath = Resolve-JsonlEnginePathArgument -Path $Path
    Invoke-SingleJsonlEngineValue -Verb json -Argument @($resolvedPath) `
        -AsHashtable:$AsHashtable -AsFrame:$AsFrame -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}
