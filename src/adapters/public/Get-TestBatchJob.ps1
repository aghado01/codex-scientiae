function Get-TestBatchJob {
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

    $repository = Resolve-TestBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-TestBatchRunDirectory -RunDirectory $RunDirectory
    $runner = [System.IO.Path]::Combine($repository, 'tests', 'run.ps1')
    if (-not (Test-Path -LiteralPath $runner -PathType Leaf)) {
        throw "test-batch runner not found: '$runner'"
    }
    $runner = (Resolve-Path -LiteralPath $runner).Path
    $pester = Resolve-TestBatchPesterDependency -PesterManifest $PesterManifest `
        -RepositoryRoot $repository
    $childPowerShell = Resolve-TestBatchPowerShellPath -PowerShellPath $PowerShellPath
    $fullName = ConvertTo-TestBatchFilter -Value $FullNameFilter -Role FullName
    $includeTag = ConvertTo-TestBatchFilter -Value $Tag -Role Tag
    $exclude = ConvertTo-TestBatchFilter -Value $ExcludeTag -Role ExcludeTag
    $files = @(Find-TestBatchFile -Path $Path -RepositoryRoot $repository)

    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath($repository, $file) -replace '\\', '/'
        $identityMaterial = @(
            "path=$relativePath"
            "fullname=$($fullName -join [char]0)"
            "tag=$($includeTag -join [char]0)"
            "exclude=$($exclude -join [char]0)"
        ) -join "`n"
        $digest = Get-TestBatchStableHash -Value $identityMaterial
        $id = "test:$relativePath#$digest"
        $addressLeaf = ConvertTo-TestBatchAddressLeaf -TestPath $file -Digest $digest
        $address = Resolve-TestBatchJobAddress -RunDirectory $run -AddressLeaf $addressLeaf

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
            Domain = 'test'
            Adapter = 'test-batch'
            AddressingContract = 'D19/RunDirectory'
            ResultPersistence = 'PesterNative'
            RepositoryRelativePath = $relativePath
            SourcePath = $file
            RunDirectory = $run
            JobDirectory = $address.JobDirectory
            ResultPath = $address.ResultPath
            ResultFormat = $ResultFormat
            PesterManifest = $pester.Path
            PesterVersion = $pester.Version.ToString()
            FullNameFilter = $fullName
            Tag = $includeTag
            ExcludeTag = $exclude
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess -EntryPoint $runner `
            -Parameters $parameters -RuntimeProfile 'pester-process' `
            -ProcessSpec @{ PowerShellPath = $childPowerShell; WorkingDirectory = $repository } `
            -EstimatedCost ([math]::Max(1, [double]$fileInfo.Length)) `
            -Writes $address.ResultPath -ModulePath $pester.Path `
            -WorkingDirectory $repository -Metadata $metadata
    }
}
