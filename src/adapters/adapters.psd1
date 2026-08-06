@{
    RootModule = 'adapters.psm1'
    ModuleVersion = '0.1.0'
    GUID = 'de9b2a80-f85d-49aa-8d10-1cdb4b70f542'
    Author = 'codex-scientiae contributors'
    Description = 'Domain adapters that emit jobs for the shared finite-batch executor.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @('Get-LatexBatchJob', 'Get-PesterBatchJob')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('adapters', 'batch', 'latex', 'pester', 'test')
        }
    }
}
