function New-BatchJob {
    <# Domain-neutral job description. Adapters should discover test cases or documents and emit
       these records; they should not own pools, cancellation, subprocesses, or result ordering. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Id,
        [Parameter(Mandatory)] [ValidateSet('RunspaceScript', 'PowerShellProcess')] [string] $Kind,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EntryPoint,
        [System.Collections.IDictionary] $Parameters,
        [object[]] $ArgumentList,
        [ValidateNotNullOrEmpty()] [string] $RuntimeProfile = 'default',
        [System.Collections.IDictionary] $ProcessSpec,
        [ValidateRange(0, [double]::MaxValue)] [double] $EstimatedCost = 1,
        [string[]] $Writes = @(),
        [string[]] $ModulePath = @(),
        [string] $InitializationScriptPath,
        [string] $WorkingDirectory,
        [System.Collections.IDictionary] $Metadata
    )

    if ($PSBoundParameters.ContainsKey('Parameters') -and $PSBoundParameters.ContainsKey('ArgumentList')) {
        throw "batch job '$Id' cannot specify both Parameters and ArgumentList"
    }

    $parameterCopy = if ($PSBoundParameters.ContainsKey('Parameters')) {
        $copy = @{}
        if ($null -ne $Parameters) {
            foreach ($key in @($Parameters.Keys)) { $copy[[string]$key] = $Parameters[$key] }
        }
        $copy
    }
    else { $null }
    $processSpecCopy = @{}
    if ($null -ne $ProcessSpec) {
        foreach ($key in @($ProcessSpec.Keys)) { $processSpecCopy[[string]$key] = $ProcessSpec[$key] }
    }
    $metadataCopy = @{}
    if ($null -ne $Metadata) {
        foreach ($key in @($Metadata.Keys)) { $metadataCopy[[string]$key] = $Metadata[$key] }
    }

    $job = [pscustomobject]@{
        Id = $Id
        Kind = $Kind
        EntryPoint = $EntryPoint
        ArgumentMode = if ($PSBoundParameters.ContainsKey('Parameters')) { 'Named' }
            elseif ($PSBoundParameters.ContainsKey('ArgumentList')) { 'Positional' }
            else { 'None' }
        Parameters = $parameterCopy
        ArgumentList = if ($PSBoundParameters.ContainsKey('ArgumentList')) { [object[]]@($ArgumentList) } else { $null }
        RuntimeProfile = $RuntimeProfile
        ProcessSpec = $processSpecCopy
        EstimatedCost = $EstimatedCost
        Writes = [string[]]@($Writes)
        ModulePath = [string[]]@($ModulePath)
        InitializationScriptPath = $InitializationScriptPath
        WorkingDirectory = $WorkingDirectory
        Metadata = $metadataCopy
    }
    $job.PSObject.TypeNames.Insert(0, 'CodexScientiae.BatchJob')
    return $job
}
