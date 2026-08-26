function Get-TeXdigBatchJob {
    <# Plan TeXdig stage-1 census work: one deposited article per job, the job
       container is the document container. Emits BatchJob records only; the
       caller owns New-BatchPlan / Invoke-BatchPlan. Planning creates no
       directories and never runs the census. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [Alias('ArticlePath')]
        [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot = $script:AdaptersDefaultRepositoryRoot,
        [string] $DepsRoot,
        [string] $PowerShellPath,
        [switch] $SkipValidation
    )

    $repository = Resolve-TeXdigBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-TeXdigBatchRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $repository
    $worker = Resolve-TeXdigBatchWorker -RepositoryRoot $repository -DepsRoot $DepsRoot
    $childPowerShell = Resolve-TeXdigBatchPowerShellPath -PowerShellPath $PowerShellPath
    $articles = @(Find-TeXdigBatchArticle -Path $Path -RepositoryRoot $repository)

    foreach ($articleDirectory in $articles) {
        $manifest = Get-TeXdigBatchManifestRecord -ArticleDirectory $articleDirectory
        $relativePath = [System.IO.Path]::GetRelativePath($repository, $articleDirectory) -replace '\\', '/'

        # Identity = article address + frozen tree fingerprint: a re-deposit
        # changes the id, a re-run over the same tree does not.
        $identityMaterial = @(
            "article=$relativePath"
            "tree=$($manifest.TreeSha256)"
        ) -join "`n"
        $digest = Get-TeXdigBatchStableHash -Value $identityMaterial
        $id = "texdig:$relativePath#$digest"
        $addressLeaf = ConvertTo-TeXdigBatchAddressLeaf -Slug $manifest.Slug -Digest $digest
        $address = Resolve-TeXdigBatchJobAddress -RunDirectory $run -AddressLeaf $addressLeaf

        $parameters = @{
            Article = $articleDirectory
            OutDirectory = $address.JobDirectory
            DepsRoot = $worker.DepsRoot
            NodePath = $worker.NodePath
        }
        if ($SkipValidation) { $parameters['SkipValidation'] = $true }

        $metadata = @{
            Domain = 'texdig'
            Adapter = 'texdig-batch'
            AddressingContract = 'RunDirectory/texdig-jobs'
            ContainerContract = 'JobContainerIsDocumentContainer'
            StoreSchema = 'texdig-census/0.4'
            Slug = $manifest.Slug
            RepositoryRelativePath = $relativePath
            ArticleDirectory = $articleDirectory
            TreeSha256 = $manifest.TreeSha256
            RunDirectory = $run
            JobDirectory = $address.JobDirectory
            TempRoot = $address.TempRoot
            JsonScratchRoot = $address.JsonScratchRoot
            DepsRoot = $worker.DepsRoot
            NodePath = $worker.NodePath
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess -EntryPoint $worker.Runner `
            -Parameters $parameters -RuntimeProfile 'texdig-process' `
            -ProcessSpec @{
                PowerShellPath = $childPowerShell
                WorkingDirectory = $repository
                Environment = @{
                    CODEX_JSON_SCRATCH_ROOT = $address.JsonScratchRoot
                    TEMP = $address.TempRoot
                    TMP = $address.TempRoot
                    TMPDIR = $address.TempRoot
                }
            } `
            -EstimatedCost ([math]::Max(1, [double]$manifest.TreeBytes)) `
            -Writes @($address.JobDirectory, $address.TempRoot) `
            -WorkingDirectory $repository -Metadata $metadata
    }
}
