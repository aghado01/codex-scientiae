@{
    RootModule = 'ingest-batch.psm1'
    ModuleVersion = '0.1.0'
    GUID = 'a79f6ba4-27dc-43c6-b957-39b63ac74831'
    Author = 'codex-scientiae contributors'
    Description = 'Document-inventory adapter for isolated latex-ingest batch jobs.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @('Get-IngestBatchJob')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('batch', 'ingestion', 'latex')
        }
    }
}
