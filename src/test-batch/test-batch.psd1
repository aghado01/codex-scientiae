@{
    RootModule = 'test-batch.psm1'
    ModuleVersion = '0.1.0'
    GUID = '7e42e109-bac7-4ba1-b3e0-ce1904fd7290'
    Author = 'codex-scientiae contributors'
    Description = 'Repository Pester discovery adapter for the shared finite-batch executor.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @('Get-TestBatchJob')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('batch', 'pester', 'test')
        }
    }
}
