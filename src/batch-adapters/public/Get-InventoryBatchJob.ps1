function Get-InventoryBatchJob {
    <# Plan one process job per deposited article for an external engine.
       Path is an article directory, article.json, inventory.jsonl, or a
       catalog directory that holds inventory.jsonl (first-order or folded).
       Inventory rows are trusted as the article manifest; article.json is
       read only for the single-article forms. The engine lives in its own
       repository (EngineRoot) and supplies the child entrypoint (Worker).
       Emits BatchJob records only; the caller owns New-BatchPlan /
       Invoke-BatchPlan. Planning creates no directories and runs nothing. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [Alias('ArticlePath', 'CatalogPath')]
        [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot = $script:AdaptersDefaultRepositoryRoot,
        [Parameter(Mandatory)] [ValidatePattern('^[a-z][a-z0-9-]{0,31}$')] [string] $Engine,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EngineRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Worker,
        [string] $PowerShellPath,
        [System.Collections.IDictionary] $WorkerParameter = @{},
        [ValidatePattern('^$|^[0-9a-f]{64}$')] [string] $ExperimentSha256 = ''
    )

    $repository = Resolve-InventoryBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-InventoryBatchRunDirectory -RunDirectory $RunDirectory -RepositoryRoot $repository
    $engineRoot = Resolve-InventoryBatchEngineRoot -EngineRoot $EngineRoot -RepositoryRoot $repository
    $worker = Resolve-InventoryBatchWorker -Worker $Worker -EngineRoot $engineRoot
    $childPowerShell = Resolve-InventoryBatchPowerShellPath -PowerShellPath $PowerShellPath
    $frozenWorkerParameter = Resolve-InventoryBatchWorkerParameter -WorkerParameter $WorkerParameter
    $selections = @(Find-InventoryBatchArticle -Path $Path -RepositoryRoot $repository)

    foreach ($selection in $selections) {
        $articleDirectory = $selection.ArticleDirectory
        $manifest = Get-InventoryBatchManifestRecord -ArticleDirectory $articleDirectory `
            -Record $selection.Record
        $relativePath = [System.IO.Path]::GetRelativePath($repository, $articleDirectory) -replace '\\', '/'

        # Identity = engine + article address + frozen tree fingerprint: a
        # re-deposit changes the id, a re-run over the same tree does not, and
        # two engines over one deposit never share a container.
        $identityMaterial = @(
            "engine=$Engine"
            "article=$relativePath"
            "tree=$($manifest.TreeSha256)"
        ) -join "`n"
        $digest = Get-InventoryBatchStableHash -Value $identityMaterial
        $id = "inventory:${Engine}:$relativePath#$digest"
        $addressLeaf = ConvertTo-InventoryBatchAddressLeaf -Slug $manifest.Slug -Digest $digest
        $address = Resolve-InventoryBatchJobAddress -RunDirectory $run -AddressLeaf $addressLeaf
        $attemptId = Get-InventoryBatchStableHash -Value "$run`n$id" -Length 64
        $articleIdentity = [ordered]@{
            slug=$manifest.Slug; directory=$articleDirectory; repositoryRelativePath=$relativePath
            sourceTree=$manifest.TreeDirectory; treeSha256=$manifest.TreeSha256; entrypoint=$manifest.Entrypoint
        }

        # The worker is handed everything the row already resolved; it never
        # has to open article.json or the inventory itself.
        $parameters = @{}
        foreach ($key in @($frozenWorkerParameter.Keys)) { $parameters[$key] = $frozenWorkerParameter[$key] }
        $parameters['Article'] = $articleDirectory
        $parameters['OutDirectory'] = $address.JobDirectory
        $parameters['EngineRoot'] = $engineRoot
        $parameters['SourceTree'] = $manifest.TreeDirectory
        $parameters['Entrypoint'] = $manifest.Entrypoint
        $parameters['TreeSha256'] = $manifest.TreeSha256
        $parameters['RunContext'] = @{
            jobId=$id; attemptId=$attemptId
            experiment=@{path=[IO.Path]::Combine($run, 'experiment.json');sha256=$ExperimentSha256}
            recordsModule=[IO.Path]::Combine($script:AdaptersDefaultRepositoryRoot, 'src/inventory-records/inventory-records.psm1')
        }

        $metadata = @{
            Domain = 'inventory'
            Adapter = 'inventory-batch'
            AddressingContract = 'RunDirectory/jobs'
            ContainerContract = 'JobContainerIsDocumentContainer'
            RunContract = 'codex-scientiae/paper-run/1'
            RunPath = [System.IO.Path]::Combine($address.JobDirectory, 'run.json')
            AttemptId = $attemptId
            ArticleIdentity = $articleIdentity
            TempEnvironment = 'CDXSCI_TEMP'
            ScratchEnvironment = 'CDXSCI_JSON_SCRATCH_ROOT'
            ManifestSource = $selection.Source
            Engine = $Engine
            EngineRoot = $engineRoot
            Worker = $worker
            Slug = $manifest.Slug
            RepositoryRelativePath = $relativePath
            ArticleDirectory = $articleDirectory
            TreeDirectory = $manifest.TreeDirectory
            TreeSha256 = $manifest.TreeSha256
            Entrypoint = $manifest.Entrypoint
            RunDirectory = $run
            JobDirectory = $address.JobDirectory
            TempRoot = $address.TempRoot
            JsonScratchRoot = $address.JsonScratchRoot
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess -EntryPoint $worker `
            -Parameters $parameters -RuntimeProfile 'inventory-process' `
            -ProcessSpec @{
                PowerShellPath = $childPowerShell
                WorkingDirectory = $engineRoot
                Environment = @{
                    CDXSCI_JSON_SCRATCH_ROOT = $address.JsonScratchRoot
                    CDXSCI_TEMP = $address.TempRoot
                    TEMP = $address.TempRoot
                    TMP = $address.TempRoot
                    TMPDIR = $address.TempRoot
                }
            } `
            -EstimatedCost ([math]::Max(1, $manifest.CostHint)) `
            -Writes @($address.JobDirectory, $address.TempRoot) `
            -WorkingDirectory $engineRoot -Metadata $metadata
    }
}
