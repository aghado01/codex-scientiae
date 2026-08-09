@{
    RootModule = 'batch-executor.psm1'
    ModuleVersion = '0.1.0'
    GUID = 'dfeb985d-262b-46ed-a7e6-156df225b601'
    Author = 'codex-scientiae contributors'
    Description = 'Finite greedy batch execution with shared runspace and child-process modes.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @(
        'New-BatchJob'
        'New-BatchPlan'
        'Invoke-BatchPlan'
        'Invoke-BatchExecutor'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('batch', 'runspace', 'process')
        }
    }
}
