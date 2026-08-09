@{
    RootModule        = 'jsonl_engine-client.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'ae40f855-7846-408a-ad0e-8cb0850477ca'
    Author            = 'Codex Scientiae'
    Description       = 'PowerShell client for the repository JSONL engine command protocol.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')

    FunctionsToExport = @(
        'Invoke-JsonlEngineCommand'
        'New-JsonlEngineInputFile'
        'Get-JsonlEngineCapability'
        'Get-JsonlInfo'
        'Get-JsonlCount'
        'Get-JsonlHead'
        'Get-JsonlTail'
        'Get-JsonlRange'
        'Get-JsonlRecord'
        'Select-JsonlPath'
        'Find-JsonlRecord'
        'Test-JsonlStore'
        'Get-JsonlSignature'
        'New-JsonlSnapshot'
        'Get-JsonlSchema'
        'Read-JsonDocument'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
