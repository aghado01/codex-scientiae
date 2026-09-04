function Get-GauntletBatchJob {
    <# Plan gauntlet work for an external engine: one deposited article per
       job, the job container is the document container. The engine lives in
       its own repository (EngineRoot) and supplies the child entrypoint
       (Worker); this adapter knows neither its runtime nor its store layout.
       Emits BatchJob records only; the caller owns New-BatchPlan /
       Invoke-BatchPlan. Planning creates no directories and runs nothing. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [Alias('ArticlePath')]
        [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot = $script:AdaptersDefaultRepositoryRoot,
        [Parameter(Mandatory)] [ValidatePattern('^[a-z][a-z0-9-]{0,31}$')] [string] $Engine,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EngineRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Worker,
        [string] $PowerShellPath,
        [System.Collections.IDictionary] $WorkerParameter = @{}
    )

    $repository = Resolve-GauntletBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-GauntletBatchRunDirectory -RunDirectory $RunDirectory -RepositoryRoot $repository
    $engineRoot = Resolve-GauntletBatchEngineRoot -EngineRoot $EngineRoot -RepositoryRoot $repository
    $worker = Resolve-GauntletBatchWorker -Worker $Worker -EngineRoot $engineRoot
    $childPowerShell = Resolve-GauntletBatchPowerShellPath -PowerShellPath $PowerShellPath
    $frozenWorkerParameter = Resolve-GauntletBatchWorkerParameter -WorkerParameter $WorkerParameter
    $articles = @(Find-GauntletBatchArticle -Path $Path -RepositoryRoot $repository)

    foreach ($articleDirectory in $articles) {
        $manifest = Get-GauntletBatchManifestRecord -ArticleDirectory $articleDirectory
        $relativePath = [System.IO.Path]::GetRelativePath($repository, $articleDirectory) -replace '\\', '/'

        # Identity = engine + article address + frozen tree fingerprint: a
        # re-deposit changes the id, a re-run over the same tree does not, and
        # two engines over one deposit never share a container.
        $identityMaterial = @(
            "engine=$Engine"
            "article=$relativePath"
            "tree=$($manifest.TreeSha256)"
        ) -join "`n"
        $digest = Get-GauntletBatchStableHash -Value $identityMaterial
        $id = "gauntlet:${Engine}:$relativePath#$digest"
        $addressLeaf = ConvertTo-GauntletBatchAddressLeaf -Slug $manifest.Slug -Digest $digest
        $address = Resolve-GauntletBatchJobAddress -RunDirectory $run -AddressLeaf $addressLeaf

        $parameters = @{}
        foreach ($key in @($frozenWorkerParameter.Keys)) { $parameters[$key] = $frozenWorkerParameter[$key] }
        $parameters['Article'] = $articleDirectory
        $parameters['OutDirectory'] = $address.JobDirectory
        $parameters['EngineRoot'] = $engineRoot

        $metadata = @{
            Domain = 'gauntlet'
            Adapter = 'gauntlet-batch'
            AddressingContract = 'RunDirectory/gauntlet-jobs'
            ContainerContract = 'JobContainerIsDocumentContainer'
            ReceiptContract = 'codex-scientiae/gauntlet-receipt/0.1'
            ReceiptPath = [System.IO.Path]::Combine($address.JobDirectory, 'receipt.json')
            TempEnvironment = 'CDXSCI_TEMP'
            ScratchEnvironment = 'CDXSCI_JSON_SCRATCH_ROOT'
            Engine = $Engine
            EngineRoot = $engineRoot
            Worker = $worker
            Slug = $manifest.Slug
            RepositoryRelativePath = $relativePath
            ArticleDirectory = $articleDirectory
            TreeDirectory = $manifest.TreeDirectory
            TreeSha256 = $manifest.TreeSha256
            RunDirectory = $run
            JobDirectory = $address.JobDirectory
            TempRoot = $address.TempRoot
            JsonScratchRoot = $address.JsonScratchRoot
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess -EntryPoint $worker `
            -Parameters $parameters -RuntimeProfile 'gauntlet-process' `
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
            -EstimatedCost ([math]::Max(1, [double]$manifest.TreeBytes)) `
            -Writes @($address.JobDirectory, $address.TempRoot) `
            -WorkingDirectory $engineRoot -Metadata $metadata
    }
}
