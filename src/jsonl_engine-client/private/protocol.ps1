function ConvertFrom-JsonlEngineFrame {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Json,
        [Parameter(Mandatory)] [int] $ExpectedSequence
    )

    try {
        $parsed = $Json | ConvertFrom-Json -AsHashtable -Depth 100 -NoEnumerate `
            -ErrorAction Stop
    }
    catch {
        throw "jsonl engine emitted invalid JSON protocol output: $($_.Exception.Message)"
    }
    if ($null -eq $parsed -or $parsed -isnot [System.Collections.IDictionary]) {
        throw 'jsonl engine emitted a non-object protocol frame'
    }

    foreach ($required in @('protocol', 'version', 'type', 'sequence', 'value')) {
        if (-not $parsed.Contains($required)) {
            throw "jsonl engine protocol frame is missing '$required'"
        }
    }
    if ($parsed['protocol'] -isnot [string] -or
        $parsed['protocol'] -cne $script:JsonlEngineProtocol -or
        $parsed['version'] -isnot [long] -or
        $parsed['version'] -ne $script:JsonlEngineProtocolVersion -or
        $parsed['type'] -isnot [string] -or
        $parsed['type'] -cne 'value') {
        throw "jsonl engine returned an unsupported protocol frame: '$Json'"
    }
    if ($parsed['sequence'] -isnot [long] -or
        $parsed['sequence'] -ne $ExpectedSequence) {
        throw "jsonl engine protocol sequence mismatch: expected $ExpectedSequence, got $($parsed['sequence'])"
    }

    $frame = [pscustomobject]@{
        protocol = [string]$parsed['protocol']
        version  = [int]$parsed['version']
        type     = [string]$parsed['type']
        sequence = [int]$parsed['sequence']
        value    = $parsed['value']
        RawJson  = $Json
    }
    $frame.PSObject.TypeNames.Insert(0, 'JsonlEngine.CliValueFrame')
    return $frame
}

function ConvertFrom-JsonlEngineError {
    [CmdletBinding()]
    param([AllowEmptyString()] [string] $Text)

    $lines = @($Text -split '\r?\n' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if ($lines.Count -ne 1) { return $null }
    try {
        $parsed = $lines[0] | ConvertFrom-Json -AsHashtable -Depth 100 -NoEnumerate `
            -ErrorAction Stop
    }
    catch {
        return $null
    }
    if ($parsed -isnot [System.Collections.IDictionary] -or
        -not $parsed.Contains('protocol') -or -not $parsed.Contains('version') -or
        -not $parsed.Contains('type') -or -not $parsed.Contains('error') -or
        -not $parsed.Contains('message') -or
        $parsed['protocol'] -isnot [string] -or
        $parsed['protocol'] -cne $script:JsonlEngineProtocol -or
        $parsed['version'] -isnot [long] -or
        $parsed['version'] -ne $script:JsonlEngineProtocolVersion -or
        $parsed['type'] -isnot [string] -or $parsed['type'] -cne 'error' -or
        $parsed['error'] -isnot [string] -or $parsed['message'] -isnot [string]) {
        return $null
    }
    $errorFrame = [pscustomobject]@{
        protocol = [string]$parsed['protocol']
        version  = [int]$parsed['version']
        type     = [string]$parsed['type']
        error    = [string]$parsed['error']
        message  = [string]$parsed['message']
        RawJson  = $lines[0]
    }
    $errorFrame.PSObject.TypeNames.Insert(0, 'JsonlEngine.CliErrorFrame')
    return $errorFrame
}

function Write-JsonlEngineValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)] $Frame,
        [switch] $AsHashtable,
        [switch] $AsFrame
    )
    process {
        if ($AsFrame) {
            Write-Output $Frame
            return
        }

        $value = if ($AsHashtable) {
            $Frame.value
        }
        else {
            $parsed = $Frame.RawJson | ConvertFrom-Json -Depth 100 -NoEnumerate -ErrorAction Stop
            $parsed.value
        }

        if ($null -eq $value) {
            # A literal $null is swallowed by the PowerShell pipeline. NullString is the built-in
            # non-null carrier that serializes back to JSON null and therefore preserves one frame.
            Write-Output ([System.Management.Automation.Language.NullString]::Value)
        }
        elseif ($value -is [System.Array]) {
            Write-Output -NoEnumerate $value
        }
        else {
            Write-Output $value
        }
    }
}

function Resolve-JsonlEngineViewArguments {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [System.Collections.IDictionary] $BoundParameters,
        [ValidateSet('Complete', 'Signed', 'Physical')] [string] $View = 'Complete'
    )

    $atSignature = $BoundParameters.Keys -contains 'AtSignature' -and
        [bool]$BoundParameters['AtSignature']
    $unbounded = $BoundParameters.Keys -contains 'Unbounded' -and
        [bool]$BoundParameters['Unbounded']
    $viewWasBound = $BoundParameters.Keys -contains 'View'
    if ($atSignature -and $unbounded) {
        throw '-AtSignature and -Unbounded are mutually exclusive'
    }
    if ($viewWasBound -and ($atSignature -or $unbounded)) {
        throw '-View cannot be combined with -AtSignature or -Unbounded'
    }
    if ($atSignature -or $View -eq 'Signed') { return [string[]]@('--at-signature') }
    if ($unbounded -or $View -eq 'Physical') { return [string[]]@('--unbounded') }
    return [string[]]@()
}

function Assert-JsonlEngineJsonValue {
    param(
        [AllowNull()] $Value,
        [int] $Level = 0,
        [int] $MaximumDepth = 100
    )

    if ($Level -gt $MaximumDepth) {
        throw "jsonl engine input exceeds the declared JSON depth of $MaximumDepth"
    }
    if ($null -eq $Value -or
        $Value -is [string] -or $Value -is [char] -or $Value -is [bool] -or
        $Value -is [byte] -or $Value -is [sbyte] -or
        $Value -is [int16] -or $Value -is [uint16] -or
        $Value -is [int32] -or $Value -is [uint32] -or
        $Value -is [int64] -or $Value -is [uint64] -or
        $Value -is [decimal] -or $Value -is [datetime] -or
        $Value -is [datetimeoffset] -or $Value -is [guid] -or
        $Value -is [System.Management.Automation.Language.NullString]) {
        return
    }
    if ($Value -is [double]) {
        if ([double]::IsNaN($Value) -or [double]::IsInfinity($Value)) {
            throw 'jsonl engine input contains a non-finite double'
        }
        return
    }
    if ($Value -is [single]) {
        if ([single]::IsNaN($Value) -or [single]::IsInfinity($Value)) {
            throw 'jsonl engine input contains a non-finite single'
        }
        return
    }
    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($item in $Value.Values) {
            Assert-JsonlEngineJsonValue -Value $item -Level ($Level + 1) `
                -MaximumDepth $MaximumDepth
        }
        return
    }
    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($item in $Value) {
            Assert-JsonlEngineJsonValue -Value $item -Level ($Level + 1) `
                -MaximumDepth $MaximumDepth
        }
        return
    }
    foreach ($property in $Value.PSObject.Properties) {
        if ($property.IsGettable) {
            Assert-JsonlEngineJsonValue -Value $property.Value -Level ($Level + 1) `
                -MaximumDepth $MaximumDepth
        }
    }
}
