function Get-PesterBatchJob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [Alias('TestPath')]
        [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot = $script:AdaptersDefaultRepositoryRoot,
        [string] $PesterManifest,
        [string] $PowerShellPath,
        [AllowEmptyCollection()] [string[]] $FullNameFilter = @(),
        [AllowEmptyCollection()] [string[]] $Tag = @(),
        [AllowEmptyCollection()] [string[]] $ExcludeTag = @(),
        [ValidateSet('NUnitXml', 'NUnit2.5', 'NUnit3', 'JUnitXml')]
        [string] $ResultFormat = 'NUnitXml',
        [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $OutputVerbosity = 'Detailed'
    )

    $repository = Resolve-PesterBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-PesterBatchRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $repository
    $runner = [System.IO.Path]::Combine($repository, 'tests', 'run.ps1')
    if (-not (Test-Path -LiteralPath $runner -PathType Leaf)) {
        throw "pester-batch runner not found: '$runner'"
    }
    $runner = (Resolve-Path -LiteralPath $runner).Path
    $artifactBoundary = [System.IO.Path]::Combine(
        $repository, 'src', 'logistics', 'artifact-boundary.ps1')
    if (-not (Test-Path -LiteralPath $artifactBoundary -PathType Leaf)) {
        throw "pester-batch runner support not found: '$artifactBoundary'"
    }
    $pester = Resolve-PesterBatchDependency -PesterManifest $PesterManifest `
        -RepositoryRoot $repository
    $childPowerShell = Resolve-PesterBatchPowerShellPath -PowerShellPath $PowerShellPath
    $fullName = ConvertTo-PesterBatchFilter -Value $FullNameFilter -Role FullName
    $includeTag = ConvertTo-PesterBatchFilter -Value $Tag -Role Tag
    $exclude = ConvertTo-PesterBatchFilter -Value $ExcludeTag -Role ExcludeTag
    $files = @(Find-PesterBatchFile -Path $Path -RepositoryRoot $repository)

    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath($repository, $file) -replace '\\', '/'
        $identityMaterial = @(
            "path=$relativePath"
            "fullname=$($fullName -join [char]0)"
            "tag=$($includeTag -join [char]0)"
            "exclude=$($exclude -join [char]0)"
        ) -join "`n"
        $digest = Get-PesterBatchStableHash -Value $identityMaterial
        $id = "pester:$relativePath#$digest"
        $addressLeaf = ConvertTo-PesterBatchAddressLeaf -TestPath $file -Digest $digest
        $address = Resolve-PesterBatchJobAddress -RunDirectory $run -AddressLeaf $addressLeaf
        $jsonScratchRoot = [System.IO.Path]::Combine($address.TempRoot, 'json-scratch')

        $parameters = @{
            Path = $file
            ResultPath = $address.ResultPath
            ResultFormat = $ResultFormat
            TestSuiteName = $id
            OutputVerbosity = $OutputVerbosity
        }
        if ($fullName.Count -gt 0) { $parameters['FullNameFilter'] = $fullName }
        if ($includeTag.Count -gt 0) { $parameters['Tag'] = $includeTag }
        if ($exclude.Count -gt 0) { $parameters['ExcludeTag'] = $exclude }

        $fileInfo = [System.IO.FileInfo]::new($file)
        $metadata = @{
            Domain = 'pester'
            Adapter = 'pester-batch'
            AddressingContract = 'D19/RunDirectory'
            ArtifactContract = 'D23/ContainerRoot'
            ResultPersistence = 'PesterNative'
            RepositoryRelativePath = $relativePath
            SourcePath = $file
            RunDirectory = $run
            JobDirectory = $address.JobDirectory
            ResultPath = $address.ResultPath
            ArtifactRoot = $address.ArtifactRoot
            TempRoot = $address.TempRoot
            JsonScratchRoot = $jsonScratchRoot
            ArtifactEnvironment = 'CODEX_TEST_ARTIFACT_ROOT'
            ScratchEnvironment = 'CODEX_JSON_SCRATCH_ROOT'
            ResultFormat = $ResultFormat
            PesterManifest = $pester.Path
            PesterVersion = $pester.Version.ToString()
            FullNameFilter = $fullName
            Tag = $includeTag
            ExcludeTag = $exclude
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess -EntryPoint $runner `
            -Parameters $parameters -RuntimeProfile 'pester-process' `
            -ProcessSpec @{
                PowerShellPath = $childPowerShell
                WorkingDirectory = $repository
                Environment = @{
                    CODEX_TEST_ARTIFACT_ROOT = $address.ArtifactRoot
                    CODEX_JSON_SCRATCH_ROOT = $jsonScratchRoot
                    TEMP = $address.TempRoot
                    TMP = $address.TempRoot
                    TMPDIR = $address.TempRoot
                    PYTHONDONTWRITEBYTECODE = '1'
                }
            } `
            -EstimatedCost ([math]::Max(1, [double]$fileInfo.Length)) `
            -Writes @($address.ResultPath, $address.ArtifactRoot, $address.TempRoot) `
            -ModulePath $pester.Path `
            -WorkingDirectory $repository -Metadata $metadata
    }
}
