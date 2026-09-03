#requires -Version 7.0

<#
    Exact-file pytest child entrypoint for Get-PytestBatchJob.

    The public caller is tests/batch.ps1, including a one-file selection. This script owns pytest
    command construction and its native JUnit result. It does not own scheduling, run allocation, or
    generic batch-result persistence.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $ResultPath,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $PythonPath,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $PytestConfig,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $TestSuiteName,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $TempPath,
    [string] $KeywordExpression,
    [string] $MarkerExpression,
    [ValidateSet('Quiet', 'Normal', 'Verbose')]
    [string] $OutputVerbosity = 'Normal'
)

$artifactBoundary = Join-Path $RepositoryRoot 'src/logistics/artifact-boundary.ps1'
if (-not (Test-Path -LiteralPath $artifactBoundary -PathType Leaf)) {
    throw "pytest.ps1: artifact boundary helper not found: '$artifactBoundary'"
}
. $artifactBoundary

function Resolve-PytestRunnerPath {
    param(
        [Parameter(Mandatory)] [string] $Value,
        [Parameter(Mandatory)] [string] $BasePath,
        [Parameter(Mandatory)] [string] $Role,
        [Parameter(Mandatory)] [ValidateSet('Leaf', 'Container', 'Any')] [string] $PathType
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($Value)) {
        [System.IO.Path]::GetFullPath($Value)
    }
    else { [System.IO.Path]::GetFullPath($Value, $BasePath) }
    $exists = switch ($PathType) {
        'Leaf' { Test-Path -LiteralPath $candidate -PathType Leaf }
        'Container' { Test-Path -LiteralPath $candidate -PathType Container }
        default { Test-Path -LiteralPath $candidate }
    }
    if (-not $exists) { throw "pytest.ps1: $Role not found: '$Value'" }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Write-PytestCapturedText {
    param(
        [AllowEmptyString()] [string] $Text,
        [Parameter(Mandatory)] [ValidateSet('Out', 'Error')] [string] $Stream
    )

    if ([string]::IsNullOrEmpty($Text)) { return }
    $writer = if ($Stream -eq 'Out') { [Console]::Out } else { [Console]::Error }
    $writer.Write($Text)
    if (-not ($Text.EndsWith("`n") -or $Text.EndsWith("`r"))) { $writer.WriteLine() }
}

function Set-PytestProcessEnvironment {
    param(
        [Parameter(Mandatory)] [System.Diagnostics.ProcessStartInfo] $StartInfo,
        [Parameter(Mandatory)] [string] $TempPath,
        [Parameter(Mandatory)] [string] $JsonScratchPath
    )

    foreach ($name in @(
            'PYTEST_ADDOPTS', 'PYTEST_PLUGINS', 'CODEX_REGEN_FIXTURES',
            'PYTHONPATH', 'PYTHONHOME'
        )) {
        [void]$StartInfo.Environment.Remove($name)
    }
    $StartInfo.Environment['PYTEST_DISABLE_PLUGIN_AUTOLOAD'] = '1'
    $StartInfo.Environment['PYTHONDONTWRITEBYTECODE'] = '1'
    $StartInfo.Environment['PYTHONUTF8'] = '1'
    $StartInfo.Environment['CODEX_TEMP'] = $TempPath
    $StartInfo.Environment['TMP'] = $TempPath
    $StartInfo.Environment['TEMP'] = $TempPath
    $StartInfo.Environment['TMPDIR'] = $TempPath
    $StartInfo.Environment['CODEX_JSON_SCRATCH_ROOT'] = $JsonScratchPath
    $StartInfo.Environment['CODEX_PROCUREMENT_RATE_CLOCK'] = Join-Path $TempPath 'procurement-rate-clock.json'
}

function Invoke-PytestCapturedProcess {
    param(
        [Parameter(Mandatory)] [string] $FilePath,
        [Parameter(Mandatory)] [string[]] $ArgumentList,
        [Parameter(Mandatory)] [string] $WorkingDirectory,
        [Parameter(Mandatory)] [string] $TempPath,
        [Parameter(Mandatory)] [string] $JsonScratchPath
    )

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $FilePath
    $startInfo.WorkingDirectory = $WorkingDirectory
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardInput = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $startInfo.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)
    Set-PytestProcessEnvironment -StartInfo $startInfo -TempPath $TempPath `
        -JsonScratchPath $JsonScratchPath
    foreach ($argument in $ArgumentList) { [void]$startInfo.ArgumentList.Add($argument) }

    $process = [System.Diagnostics.Process]::new()
    try {
        $process.StartInfo = $startInfo
        if (-not $process.Start()) { throw "failed to start Python interpreter: '$FilePath'" }
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        $process.WaitForExit()
        return [pscustomobject]@{
            StdOut = $stdoutTask.GetAwaiter().GetResult()
            StdErr = $stderrTask.GetAwaiter().GetResult()
            ExitCode = $process.ExitCode
        }
    }
    finally { $process.Dispose() }
}

function Read-PytestJUnitCounts {
    param([Parameter(Mandatory)] [string] $Path)

    [xml]$document = [System.IO.File]::ReadAllText($Path)
    $suites = if ($document.DocumentElement.LocalName -eq 'testsuite') {
        @($document.DocumentElement)
    }
    else { @($document.DocumentElement.SelectNodes('./testsuite')) }
    if ($suites.Count -eq 0) { throw 'JUnit result contains no testsuite element' }

    $tests = 0
    $failures = 0
    $errors = 0
    $skipped = 0
    foreach ($suite in $suites) {
        $tests += [int]$suite.GetAttribute('tests')
        $failures += [int]$suite.GetAttribute('failures')
        $errors += [int]$suite.GetAttribute('errors')
        $skipped += [int]$suite.GetAttribute('skipped')
    }
    return [pscustomobject]@{
        Selected = $tests
        Passed = [math]::Max(0, $tests - $failures - $errors - $skipped)
        Failed = $failures
        Errors = $errors
        Skipped = $skipped
    }
}

$repository = Resolve-PytestRunnerPath -Value $RepositoryRoot -BasePath (Get-Location).Path `
    -Role 'repository root' -PathType Container
$testPath = Resolve-PytestRunnerPath -Value $Path -BasePath $repository `
    -Role 'test path' -PathType Leaf
$python = Resolve-PytestRunnerPath -Value $PythonPath -BasePath $repository `
    -Role 'Python interpreter' -PathType Leaf
$config = Resolve-PytestRunnerPath -Value $PytestConfig -BasePath $repository `
    -Role 'pytest config' -PathType Leaf
$resolvedResultPath = Resolve-TestHarnessArtifactPath -Value $ResultPath `
    -RepositoryRoot $repository -Role 'pytest.ps1 ResultPath' -BasePath $repository
$resolvedTempPath = Resolve-TestHarnessArtifactPath -Value $TempPath `
    -RepositoryRoot $repository -Role 'pytest.ps1 TempPath' -BasePath $repository

$resultDirectory = [System.IO.Path]::GetDirectoryName($resolvedResultPath)
if ([string]::IsNullOrWhiteSpace($resultDirectory)) {
    throw "pytest.ps1: ResultPath has no parent directory: '$ResultPath'"
}
[void][System.IO.Directory]::CreateDirectory($resultDirectory)
[void][System.IO.Directory]::CreateDirectory($resolvedTempPath)
$jsonScratchPath = [System.IO.Path]::Combine($resolvedTempPath, 'json-scratch')
[void][System.IO.Directory]::CreateDirectory($jsonScratchPath)

$pytestArguments = [System.Collections.Generic.List[string]]::new()
foreach ($argument in @(
        '-m', 'pytest'
        '--rootdir', $repository
        '-c', $config
        '-p', 'no:cacheprovider'
        '--color=no'
        "--junitxml=$resolvedResultPath"
        '-o', 'junit_family=xunit2'
        '-o', "junit_suite_name=$TestSuiteName"
        "--basetemp=$([System.IO.Path]::Combine($resolvedTempPath, 'pytest'))"
    )) {
    $pytestArguments.Add([string]$argument)
}
switch ($OutputVerbosity) {
    'Quiet' { $pytestArguments.Add('-q') }
    'Verbose' { $pytestArguments.Add('-vv') }
}
if (-not [string]::IsNullOrWhiteSpace($KeywordExpression)) {
    $pytestArguments.Add('-k')
    $pytestArguments.Add($KeywordExpression)
}
if (-not [string]::IsNullOrWhiteSpace($MarkerExpression)) {
    $pytestArguments.Add('-m')
    $pytestArguments.Add($MarkerExpression)
}
$pytestArguments.Add($testPath)

$timer = [System.Diagnostics.Stopwatch]::StartNew()
$exitCode = $null
$runnerFailure = $null
$stdout = ''
$stderr = ''
$pythonVersion = $null
$pytestVersion = $null
try {
    $probeCode = 'import filelock,json,jsonschema,sys,pytest; print(json.dumps({' +
        '"python_version":".".join(map(str,sys.version_info[:3])),' +
        '"pytest_version":pytest.__version__}))'
    $probe = Invoke-PytestCapturedProcess -FilePath $python -ArgumentList @('-c', $probeCode) `
        -WorkingDirectory $repository -TempPath $resolvedTempPath `
        -JsonScratchPath $jsonScratchPath
    if ($probe.ExitCode -ne 0) {
        $stderr = $probe.StdErr
        throw "pytest dependency probe exited with code $($probe.ExitCode)"
    }
    $versions = $probe.StdOut.Trim() | ConvertFrom-Json -ErrorAction Stop
    $pythonVersion = [string]$versions.python_version
    $pytestVersion = [string]$versions.pytest_version

    $run = Invoke-PytestCapturedProcess -FilePath $python `
        -ArgumentList $pytestArguments.ToArray() -WorkingDirectory $repository `
        -TempPath $resolvedTempPath -JsonScratchPath $jsonScratchPath
    $stdout = $run.StdOut
    $stderr = $run.StdErr
    $exitCode = $run.ExitCode
}
catch { $runnerFailure = $_.Exception.Message }
finally { $timer.Stop() }

Write-PytestCapturedText -Text $stdout -Stream Out
Write-PytestCapturedText -Text $stderr -Stream Error

$counts = [pscustomobject]@{ Selected = 0; Passed = 0; Failed = 0; Errors = 0; Skipped = 0 }
$resultPresent = Test-Path -LiteralPath $resolvedResultPath -PathType Leaf
$evidenceFailure = $null
if ($resultPresent) {
    try { $counts = Read-PytestJUnitCounts -Path $resolvedResultPath }
    catch { $evidenceFailure = "could not read pytest JUnit result: $($_.Exception.Message)" }
}
else { $evidenceFailure = 'pytest did not produce its declared JUnit result' }

$observation = [ordered]@{
    container_path = $testPath
    selected = $counts.Selected
    passed = $counts.Passed
    failed = $counts.Failed
    errors = $counts.Errors
    skipped = $counts.Skipped
    duration_ms = [int64][math]::Round($timer.Elapsed.TotalMilliseconds)
    result_path = $resolvedResultPath
    result_present = $resultPresent
    python_version = $pythonVersion
    pytest_version = $pytestVersion
    pytest_exit_code = $exitCode
}
[Console]::Out.WriteLine(
    'PytestContainerObservation ' + ($observation | ConvertTo-Json -Compress))

# ProcessStartInfo does not assign LASTEXITCODE. Explicitly neutralize any caller value so the
# runner's success/failure projection below remains the sole native-status authority.
$global:LASTEXITCODE = 0
if ($null -ne $runnerFailure) { throw "pytest.ps1: $runnerFailure" }
if ($null -eq $exitCode) { throw 'pytest.ps1: pytest produced no exit code' }
if ($exitCode -ne 0) { throw "pytest.ps1: pytest exited with code $exitCode" }
if ($null -ne $evidenceFailure) { throw "pytest.ps1: $evidenceFailure" }
if ($counts.Selected -eq 0) { throw 'pytest.ps1: pytest selected no tests; refusing success' }
