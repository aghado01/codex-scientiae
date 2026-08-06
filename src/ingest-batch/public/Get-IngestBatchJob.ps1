function Get-IngestBatchJob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [Alias('InputObject')]
        [ValidateNotNullOrEmpty()] [object[]] $InventoryRow,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot = $script:IngestBatchDefaultRepositoryRoot,
        [string] $InventoryRoot,
        [ValidateNotNullOrEmpty()] [string] $MetadataPathProperty = 'metadata_path',
        [string] $LatexIngestPath,
        [string] $PowerShellPath,
        [System.Collections.IDictionary] $ProcessEnvironment,
        [ValidateRange(0, [int]::MaxValue)] [int] $TimeoutSeconds = 0,
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')]
        [string] $PriorityClass = 'Normal',
        [switch] $BundleDeliverable,
        [switch] $EnableEmbeddedToc,
        [switch] $DisableTreeToc,
        [switch] $DisableJsonlToc,
        [switch] $FaithfulNumbering
    )

    $repository = Resolve-IngestBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $inventory = Resolve-IngestBatchInventoryRoot -InventoryRoot $InventoryRoot `
        -RepositoryRoot $repository
    $batchRun = Resolve-IngestBatchRunDirectory -RunDirectory $RunDirectory
    $latexIngest = Resolve-IngestBatchLatexDependency -LatexIngestPath $LatexIngestPath `
        -RepositoryRoot $repository
    $childPowerShell = Resolve-IngestBatchPowerShellPath -PowerShellPath $PowerShellPath

    $environment = @{}
    if ($null -ne $ProcessEnvironment) {
        foreach ($key in @($ProcessEnvironment.Keys)) {
            if ([string]::IsNullOrWhiteSpace([string]$key)) {
                throw 'ingest-batch process environment contains an empty name'
            }
            $environment[[string]$key] = $ProcessEnvironment[$key]
        }
    }

    foreach ($row in $InventoryRow) {
        if ($null -eq $row) { throw 'ingest-batch inventory row must not be null' }
        $document = Read-IngestBatchManifestRecord -InventoryRow $row `
            -MetadataPathProperty $MetadataPathProperty -InventoryRoot $inventory
        $identityMaterial = @(
            "manifest=$($document.RelativeManifestPath)"
            "source=$($document.SourceTreeSha256)"
            "bundle=$([bool]$BundleDeliverable)"
            "embedded-toc=$([bool]$EnableEmbeddedToc)"
            "tree-toc-disabled=$([bool]$DisableTreeToc)"
            "jsonl-toc-disabled=$([bool]$DisableJsonlToc)"
            "faithful-numbering=$([bool]$FaithfulNumbering)"
        ) -join "`n"
        $digest = Get-IngestBatchStableHash -Value $identityMaterial
        $id = "ingest:$($document.Slug)#$digest"
        $addressLeaf = ConvertTo-IngestBatchAddressLeaf -Slug $document.Slug -Digest $digest
        $address = Resolve-IngestBatchJobAddress -RunDirectory $batchRun -AddressLeaf $addressLeaf

        $parameters = @{
            LatexIngestPath = $latexIngest.Path
            MetadataPath = $document.ManifestPath
            RunDir = $address.ApplicationRunDirectory
            OutDir = $address.OutputDirectory
        }
        if ($BundleDeliverable) { $parameters['DeliverableDir'] = $address.DeliverableDirectory }
        if ($EnableEmbeddedToc) { $parameters['EnableEmbeddedToc'] = $true }
        if ($DisableTreeToc) { $parameters['DisableTreeToc'] = $true }
        if ($DisableJsonlToc) { $parameters['DisableJsonlToc'] = $true }
        if ($FaithfulNumbering) { $parameters['FaithfulNumbering'] = $true }

        $writes = [System.Collections.Generic.List[string]]::new()
        $writes.Add($address.ApplicationRunDirectory)
        $writes.Add($address.OutputDirectory)
        if ($BundleDeliverable) { $writes.Add($address.DeliverableDirectory) }

        $metadata = @{
            Domain = 'ingestion'
            Adapter = 'ingest-batch'
            AddressingContract = 'D19/RunDirectory'
            ResultPersistence = 'InMemory'
            InventoryRow = $row
            MetadataPathProperty = $MetadataPathProperty
            InventoryRoot = $inventory
            InventoryRelativeMetadataPath = $document.RelativeManifestPath
            MetadataPath = $document.ManifestPath
            MetadataSchema = [string]$document.Manifest['schema']
            Slug = $document.Slug
            SourceTreeSha256 = $document.SourceTreeSha256
            SourceArchiveSha256 = $document.SourceArchiveSha256
            LatexIngestPath = $latexIngest.Path
            LatexIngestSha256 = $latexIngest.Sha256
            BatchRunDirectory = $batchRun
            JobDirectory = $address.JobDirectory
            ApplicationRunDirectory = $address.ApplicationRunDirectory
            OutputDirectory = $address.OutputDirectory
            DeliverableDirectory = if ($BundleDeliverable) {
                $address.DeliverableDirectory
            }
            else { $null }
            BundleDeliverable = [bool]$BundleDeliverable
            EnableEmbeddedToc = [bool]$EnableEmbeddedToc
            DisableTreeToc = [bool]$DisableTreeToc
            DisableJsonlToc = [bool]$DisableJsonlToc
            FaithfulNumbering = [bool]$FaithfulNumbering
        }
        $jobEnvironment = @{}
        foreach ($key in @($environment.Keys)) {
            $jobEnvironment[[string]$key] = $environment[$key]
        }
        $processSpec = @{
            PowerShellPath = $childPowerShell
            WorkingDirectory = $repository
            TimeoutSeconds = $TimeoutSeconds
            CreateNoWindow = $true
            WindowStyle = 'Hidden'
            LoadProfile = $false
            PriorityClass = $PriorityClass
            Environment = $jobEnvironment
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess `
            -EntryPoint $script:IngestBatchWorkerPath -Parameters $parameters `
            -RuntimeProfile 'latex-ingest-process' -ProcessSpec $processSpec `
            -EstimatedCost $document.EstimatedCost -Writes $writes.ToArray() `
            -WorkingDirectory $repository -Metadata $metadata
    }
}
