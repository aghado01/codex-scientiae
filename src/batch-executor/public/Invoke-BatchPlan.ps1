function Invoke-BatchPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [object] $Plan,
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
        [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
        [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [System.Threading.CancellationToken] $CancellationToken = [System.Threading.CancellationToken]::None,
        [ValidateSet('SharedReadOnly', 'PerItemCopy')] [string] $RunspaceDataPolicy = 'SharedReadOnly',
        [string] $PowerShellPath,
        [System.Collections.IDictionary] $ProcessEnvironment = @{},
        [bool] $CreateNoWindow = $true,
        [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')] [string] $WindowStyle = 'Hidden',
        [switch] $LoadProfile,
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')] [string] $PriorityClass = 'Normal'
    )

    if ($Plan.PSObject.Properties['Plan'] -and $Plan.PSObject.Properties['Errors']) {
        if ($Plan.Errors.Count -gt 0 -or $null -eq $Plan.Plan) {
            throw "cannot invoke invalid batch plan: $(@($Plan.Errors) -join '; ')"
        }
        $Plan = $Plan.Plan
    }
    if ($null -eq $Plan -or -not $Plan.PSObject.Properties['DispatchJobs']) {
        throw 'Invoke-BatchPlan requires a compiled batch plan'
    }

    $modes = [string[]]@($Plan.DispatchJobs | ForEach-Object ExecutionMode | Sort-Object -Unique)
    $executionMode = if ($modes.Count -eq 0) { 'Runspace' }
        elseif ($modes.Count -eq 1) { $modes[0] }
        else { 'Mixed' }
    $hasDirectJobs = $modes -contains 'Runspace'
    $profile = $Plan.RunspaceProfile
    $invoke = @{
        InputObject = [object[]]@($Plan.DispatchJobs)
        ScriptPath = [string]$Plan.WorkerScriptPath
        ExecutionMode = $executionMode
        ExecutionModeProperty = 'ExecutionMode'
        ProcessSpecProperty = 'ProcessSpec'
        Context = $profile.Context
        InitializationScriptPath = if ($hasDirectJobs) { [string]$profile.InitializationScriptPath } else { '' }
        ModulePath = if ($hasDirectJobs) { [string[]]@($profile.ModulePath) } else { [string[]]@() }
        IssPreset = [string]$profile.IssPreset
        MaxWorkers = $MaxWorkers
        ReservedCores = $ReservedCores
        MinItemsPerWorker = $MinItemsPerWorker
        SerializationDepth = $SerializationDepth
        ProcessTimeoutSeconds = $ProcessTimeoutSeconds
        WaitTimeoutSeconds = $WaitTimeoutSeconds
        CancellationToken = $CancellationToken
        RunspaceDataPolicy = $RunspaceDataPolicy
        WorkingDirectory = [string]$Plan.BasePath
        ProcessEnvironment = $ProcessEnvironment
        CreateNoWindow = $CreateNoWindow
        WindowStyle = $WindowStyle
        LoadProfile = $LoadProfile
        PriorityClass = $PriorityClass
    }
    if (-not [string]::IsNullOrWhiteSpace($PowerShellPath)) { $invoke.PowerShellPath = $PowerShellPath }
    $execution = Invoke-BatchExecutor @invoke

    $stableResults = [object[]]::new($Plan.Jobs.Count)
    foreach ($result in @($execution.Results)) {
        $planIndex = [int]$result.Input.PlanIndex
        $result | Add-Member -NotePropertyName DispatchIndex -NotePropertyValue $result.Index
        $result.Index = $planIndex
        $stableResults[$planIndex] = $result
    }

    [pscustomobject]@{
        PlanId = $Plan.Id; Results = $stableResults
        Errors = $execution.Errors; Warnings = @($Plan.Warnings) + @($execution.Warnings)
        Budget = $execution.Budget
        Policy = [pscustomobject]@{ Plan = $Plan.Policy; Execution = $execution.Policy }
        Timing = $execution.Timing
        Summary = $execution.Summary
    }
}
