function Test-BatchExecutorPowerShellFloor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [version] $Version,
        [Parameter(Mandatory)] [string] $Source
    )

    if ($Version -lt [version]'7.5') {
        throw "batch executor requires PowerShell 7.5 or newer; $Source is $Version"
    }
}

function Get-BatchExecutorHostRuntime {
    $executable = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    Test-BatchExecutorPowerShellFloor -Version $PSVersionTable.PSVersion -Source "host '$executable'"
    return [pscustomobject]@{
        Executable = $executable
        PSVersion = $PSVersionTable.PSVersion.ToString()
        Edition = [string]$PSVersionTable.PSEdition
        FrameworkDescription = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
        Source = 'host'
    }
}

function Get-BatchExecutorChildRuntime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $PowerShellPath,
        [ValidateRange(1, [int]::MaxValue)] [int] $TimeoutMilliseconds = 15000
    )

    Import-BatchExecutorNative
    if (-not (Test-Path -LiteralPath $PowerShellPath -PathType Leaf)) {
        throw "batch executor child PowerShell not found: '$PowerShellPath'"
    }
    $resolved = (Resolve-Path -LiteralPath $PowerShellPath).Path

    $probe = @'
$identity = [pscustomobject]@{
    PSVersion = $PSVersionTable.PSVersion.ToString()
    Edition = [string]$PSVersionTable.PSEdition
    FrameworkDescription = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
    Executable = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
}
[Console]::Out.Write(($identity | ConvertTo-Json -Compress))
'@
    $encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($probe))
    $info = [CodexScientiae.BatchExecutor.Native.ContainedProcessStartInfo]::new()
    $info.FileName = $resolved
    $info.WorkingDirectory = [System.IO.Path]::GetDirectoryName($resolved)
    $info.CreateNoWindow = $true
    $info.WindowStyle = 'Hidden'
    [void]$info.Arguments.Add('-NoLogo')
    [void]$info.Arguments.Add('-NoProfile')
    [void]$info.Arguments.Add('-NonInteractive')
    [void]$info.Arguments.Add('-EncodedCommand')
    [void]$info.Arguments.Add($encoded)

    $child = [CodexScientiae.BatchExecutor.Native.ContainedProcess]::Start($info)
    try {
        $child.StandardInput.Close()
        $stdout = [CodexScientiae.BatchExecutor.Native.BoundedCapture]::new(65536)
        $stderr = [CodexScientiae.BatchExecutor.Native.BoundedCapture]::new(65536)
        $cts = [System.Threading.CancellationTokenSource]::new()
        try {
            if ($TimeoutMilliseconds -gt 0) { $cts.CancelAfter($TimeoutMilliseconds) }
            $outTask = [CodexScientiae.BatchExecutor.Native.StreamPump]::PumpAsync(
                $child.StandardOutput, $stdout, $cts.Token)
            $errTask = [CodexScientiae.BatchExecutor.Native.StreamPump]::PumpAsync(
                $child.StandardError, $stderr, $cts.Token)
            $waitTask = $child.WaitForExitAsync($cts.Token)
            $status = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::Wait(
                [System.Threading.Tasks.Task[]]@($waitTask, $outTask, $errTask),
                [TimeSpan]::FromMilliseconds($TimeoutMilliseconds),
                $cts.Token)
            if ($status.ToString() -ne 'AllCompleted' -or -not $child.HasExited) {
                [void]$child.Terminate([TimeSpan]::FromSeconds(2))
                throw "batch executor child PowerShell probe timed out: '$resolved'"
            }
        }
        finally { $cts.Dispose() }

        if ($child.ExitCode -ne 0) {
            $errText = [System.Text.Encoding]::UTF8.GetString($stderr.ToArray())
            throw "batch executor child PowerShell probe exited $($child.ExitCode) for '$resolved': $errText"
        }

        $json = [System.Text.Encoding]::UTF8.GetString($stdout.ToArray())
        $identity = $json | ConvertFrom-Json -DateKind String
        $version = [version][string]$identity.PSVersion
        Test-BatchExecutorPowerShellFloor -Version $version -Source "child '$resolved'"
        return [pscustomobject]@{
            Executable = [string]$identity.Executable
            PSVersion = [string]$identity.PSVersion
            Edition = [string]$identity.Edition
            FrameworkDescription = [string]$identity.FrameworkDescription
            Source = 'child'
        }
    }
    finally { $child.Dispose() }
}

function Resolve-BatchExecutorRuntimeSet {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()] [string[]] $ChildPowerShellPath = @(),
        [System.Collections.IDictionary] $Cache
    )

    $hostRuntime = Get-BatchExecutorHostRuntime
    $children = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    foreach ($path in @($ChildPowerShellPath)) {
        if ([string]::IsNullOrWhiteSpace([string]$path)) { continue }
        $resolved = (Resolve-Path -LiteralPath $path).Path
        if (-not $seen.Add($resolved)) { continue }
        if ($null -ne $Cache -and $Cache.Contains($resolved)) {
            $children.Add($Cache[$resolved])
            continue
        }
        $runtime = Get-BatchExecutorChildRuntime -PowerShellPath $resolved
        if ($null -ne $Cache) { $Cache[$resolved] = $runtime }
        $children.Add($runtime)
    }

    return [pscustomobject]@{
        Host = $hostRuntime
        Children = $children.ToArray()
        Floor = '7.5'
    }
}
