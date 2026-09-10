function Get-BatchExecutorRepositoryRoot {
    return [System.IO.Path]::GetFullPath((Join-Path $script:BatchExecutorModuleRoot '../..'))
}

function Import-BatchExecutorNative {
    if ($script:BatchExecutorNativeLoaded) { return }

    $repositoryRoot = Get-BatchExecutorRepositoryRoot
    $released = Join-Path $repositoryRoot 'packages/batch-executor/BatchExecutor.Native.dll'
    if (-not (Test-Path -LiteralPath $released -PathType Leaf)) {
        $build = Join-Path $repositoryRoot 'brewery/batch-executor/build-native.ps1'
        if (-not (Test-Path -LiteralPath $build -PathType Leaf)) {
            throw "batch executor native helper missing at '$released' and recipe missing at '$build'"
        }
        & $build | Out-Null
    }
    if (-not (Test-Path -LiteralPath $released -PathType Leaf)) {
        throw "batch executor native helper not found: '$released'"
    }

    $script:BatchExecutorNativePath = (Resolve-Path -LiteralPath $released).Path
    Add-Type -Path $script:BatchExecutorNativePath
    $script:BatchExecutorNativeLoaded = $true
}

function New-BatchExecutorDeadlineClock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Timeouts,
        [System.TimeProvider] $TimeProvider
    )

    Import-BatchExecutorNative
    $execution = if ([int]$Timeouts.ExecutionTimeoutSeconds -gt 0) {
        [TimeSpan]::FromSeconds([int]$Timeouts.ExecutionTimeoutSeconds)
    }
    else { $null }
    $wait = if ([int]$Timeouts.WaitTimeoutSeconds -gt 0) {
        [TimeSpan]::FromSeconds([int]$Timeouts.WaitTimeoutSeconds)
    }
    else { $null }
    $cleanup = if ([int]$Timeouts.CleanupTimeoutSeconds -gt 0) {
        [TimeSpan]::FromSeconds([int]$Timeouts.CleanupTimeoutSeconds)
    }
    else { $null }
    $provider = if ($null -ne $TimeProvider) { $TimeProvider } else { [System.TimeProvider]::System }
    return [CodexScientiae.BatchExecutor.Native.DeadlineClock]::new(
        $provider, $execution, $wait, $cleanup)
}

function New-BatchExecutorCaptureLimits {
    [CmdletBinding()]
    param(
        [ValidateRange(1, [long]::MaxValue)] [long] $MaxStdOutBytes = 8MB,
        [ValidateRange(1, [long]::MaxValue)] [long] $MaxStdErrBytes = 8MB,
        [ValidateRange(1, [long]::MaxValue)] [long] $MaxProtocolBytes = 16MB,
        [ValidateRange(1, [int]::MaxValue)] [int] $MaxFrameBytes = 1MB
    )

    Import-BatchExecutorNative
    return [CodexScientiae.BatchExecutor.Native.CaptureLimits]::new(
        $MaxStdOutBytes, $MaxStdErrBytes, $MaxProtocolBytes, $MaxFrameBytes)
}
