function Get-PytestBatchJob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [Alias('TestPath')]
        [ValidateNotNullOrEmpty()] [string[]] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [ValidateNotNullOrEmpty()] [string] $RepositoryRoot = $script:AdaptersDefaultRepositoryRoot,
        [string] $PythonPath,
        [string] $PowerShellPath,
        [string] $PytestConfig,
        [Alias('Keyword')] [string] $KeywordExpression,
        [Alias('Marker')] [string] $MarkerExpression,
        [ValidateSet('Quiet', 'Normal', 'Verbose')]
        [string] $OutputVerbosity = 'Normal'
    )

    $repository = Resolve-PytestBatchRepositoryRoot -RepositoryRoot $RepositoryRoot
    $run = Resolve-PytestBatchRunDirectory -RunDirectory $RunDirectory `
        -RepositoryRoot $repository
    $runner = Resolve-PytestBatchFileDependency -Path (
        [System.IO.Path]::Combine($repository, 'tests', 'pytest.ps1')) `
        -RepositoryRoot $repository -Role 'runner'
    $null = Resolve-PytestBatchFileDependency -Path (
        [System.IO.Path]::Combine($repository, 'src', 'logistics', 'containment.ps1')) `
        -RepositoryRoot $repository -Role 'runner support'
    $python = Resolve-PytestBatchPythonPath -PythonPath $PythonPath -RepositoryRoot $repository
    $childPowerShell = Resolve-PytestBatchPowerShellPath -PowerShellPath $PowerShellPath
    $configInput = if ([string]::IsNullOrWhiteSpace($PytestConfig)) {
        [System.IO.Path]::Combine($repository, 'pyproject.toml')
    }
    else { $PytestConfig }
    $config = Resolve-PytestBatchFileDependency -Path $configInput `
        -RepositoryRoot $repository -Role 'pytest config'
    $keyword = if ($PSBoundParameters.ContainsKey('KeywordExpression')) {
        ConvertTo-PytestBatchExpression -Value $KeywordExpression -Role 'keyword'
    }
    else { $null }
    $marker = if ($PSBoundParameters.ContainsKey('MarkerExpression')) {
        ConvertTo-PytestBatchExpression -Value $MarkerExpression -Role 'marker'
    }
    else { $null }
    $files = @(Find-PytestBatchFile -Path $Path -RepositoryRoot $repository)

    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath($repository, $file) -replace '\\', '/'
        $identityMaterial = @(
            "path=$relativePath"
            "keyword=$keyword"
            "marker=$marker"
        ) -join "`n"
        $digest = Get-PytestBatchStableHash -Value $identityMaterial
        $id = "pytest:$relativePath#$digest"
        $addressLeaf = ConvertTo-PytestBatchAddressLeaf -TestPath $file -Digest $digest
        $address = Resolve-PytestBatchJobAddress -RunDirectory $run -AddressLeaf $addressLeaf
        $jsonScratchRoot = [System.IO.Path]::Combine($address.TempRoot, 'json-scratch')

        $parameters = @{
            Path = $file
            ResultPath = $address.ResultPath
            RepositoryRoot = $repository
            PythonPath = $python
            PytestConfig = $config
            TestSuiteName = $id
            OutputVerbosity = $OutputVerbosity
            TempPath = $address.TempRoot
        }
        if ($null -ne $keyword) { $parameters['KeywordExpression'] = $keyword }
        if ($null -ne $marker) { $parameters['MarkerExpression'] = $marker }

        $fileInfo = [System.IO.FileInfo]::new($file)
        $metadata = @{
            Domain = 'pytest'
            Adapter = 'pytest-batch'
            AddressingContract = 'D19/RunDirectory'
            ArtifactContract = 'PytestContainerRoot'
            ResultPersistence = 'PytestJUnit'
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
            TempEnvironment = 'CODEX_TEMP'
            PowerShellEnvironment = 'CODEX_TEST_POWERSHELL_PATH'
            ResultFormat = 'JUnitXml/xunit2'
            PythonPath = $python
            PytestModule = 'pytest'
            PytestConfig = $config
            KeywordExpression = $keyword
            MarkerExpression = $marker
        }

        batch-executor\New-BatchJob -Id $id -Kind PowerShellProcess -EntryPoint $runner `
            -Parameters $parameters -RuntimeProfile 'pytest-process' `
            -ProcessSpec @{
                PowerShellPath = $childPowerShell
                WorkingDirectory = $repository
                Environment = @{
                    CODEX_TEST_ARTIFACT_ROOT = $address.ArtifactRoot
                    CODEX_JSON_SCRATCH_ROOT = $jsonScratchRoot
                    CODEX_TEST_POWERSHELL_PATH = $childPowerShell
                    CODEX_TEMP = $address.TempRoot
                    TEMP = $address.TempRoot
                    TMP = $address.TempRoot
                    TMPDIR = $address.TempRoot
                    PYTHONDONTWRITEBYTECODE = '1'
                    PYTHONUTF8 = '1'
                    PYTEST_ADDOPTS = $null
                    PYTEST_DISABLE_PLUGIN_AUTOLOAD = '1'
                    CODEX_REGEN_FIXTURES = $null
                    PYTHONPATH = $null
                    PYTHONHOME = $null
                }
            } `
            -EstimatedCost ([math]::Max(1, [double]$fileInfo.Length)) `
            -Writes @($address.ResultPath, $address.ArtifactRoot, $address.TempRoot) `
            -WorkingDirectory $repository -Metadata $metadata
    }
}
