function New-BatchExecutorSessionState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateSet('Runspace', 'Process', 'Mixed')] [string] $ExecutionMode,
        [ValidateSet('Bare', 'Core', 'Full')] [string] $IssPreset = 'Core',
        [string[]] $ModulePath = @(),
        [string] $WorkerBody,
        [string] $InitializerBody
    )

    $iss = switch ($IssPreset) {
        'Bare' { [System.Management.Automation.Runspaces.InitialSessionState]::Create() }
        'Full' { [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault() }
        default { [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2() }
    }

    if ($ExecutionMode -in @('Runspace', 'Mixed')) {
        foreach ($module in $ModulePath) {
            if (-not [string]::IsNullOrWhiteSpace($module)) { $iss.ImportPSModule($module) }
        }
        $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
            'Invoke-BatchWorkItem', $WorkerBody))
        if (-not [string]::IsNullOrWhiteSpace($InitializerBody)) {
            $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
                'Invoke-BatchRunspaceInitializer', $InitializerBody))
        }
        else {
            $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
                'Invoke-BatchRunspaceInitializer', 'param($Context)'))
        }
        $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
            'Invoke-BatchDirectDispatcher', $script:BatchExecutorDirectDispatcher))
    }
    if ($ExecutionMode -in @('Process', 'Mixed')) {
        $iss.Commands.Add([System.Management.Automation.Runspaces.SessionStateFunctionEntry]::new(
            'Invoke-BatchProcessDispatcher', $script:BatchExecutorProcessDispatcher))
    }

    return $iss
}
