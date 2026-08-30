#requires -Version 7.0
<#
  Identify and stop processes that hold this repository's Python environment.

  Windows cannot replace .venv\Scripts\scientiae-procurement.exe (or other venv
  executables) while they are mapped. Restore uses this before uv sync.
#>

function Test-ProjectVenvOccupant {
    param(
        [Parameter(Mandatory)] [string] $RepositoryRoot,
        [Parameter(Mandatory)] [int] $ProcessId,
        [string] $ExecutablePath,
        [string] $CommandLine
    )

    if ($ProcessId -le 0 -or $ProcessId -eq $PID) { return $false }

    $repo = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)
    $venvPrefix = (Join-Path $repo '.venv') + [System.IO.Path]::DirectorySeparatorChar
    $uvExe = Join-Path $repo 'packages\uv\uv.exe'

    $exe = $ExecutablePath
    if (-not [string]::IsNullOrWhiteSpace($exe)) {
        try {
            $exe = [System.IO.Path]::GetFullPath($exe)
        }
        catch {
            $exe = $ExecutablePath
        }
        if ($exe.StartsWith($venvPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
        if (
            $exe.Equals($uvExe, [System.StringComparison]::OrdinalIgnoreCase) -and
            -not [string]::IsNullOrWhiteSpace($CommandLine) -and
            $CommandLine.Contains('scientiae-procurement', [System.StringComparison]::OrdinalIgnoreCase)
        ) {
            return $true
        }
    }

    if (
        -not [string]::IsNullOrWhiteSpace($CommandLine) -and
        $CommandLine.Contains('scientiae-procurement', [System.StringComparison]::OrdinalIgnoreCase) -and
        $CommandLine.Contains($repo, [System.StringComparison]::OrdinalIgnoreCase)
    ) {
        return $true
    }

    return $false
}

function Get-ProjectVenvOccupants {
    param(
        [Parameter(Mandatory)] [string] $RepositoryRoot
    )

    $repo = [System.IO.Path]::GetFullPath($RepositoryRoot)
    @(Get-CimInstance -ClassName Win32_Process) | Where-Object {
        Test-ProjectVenvOccupant `
            -RepositoryRoot $repo `
            -ProcessId ([int]$_.ProcessId) `
            -ExecutablePath $_.ExecutablePath `
            -CommandLine $_.CommandLine
    }
}

function Stop-ProjectVenvOccupants {
    param(
        [Parameter(Mandatory)] [string] $RepositoryRoot,
        [int] $TimeoutSeconds = 20
    )

    if ($TimeoutSeconds -lt 1) { throw 'TimeoutSeconds must be at least 1' }
    $repo = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $occupants = @(Get-ProjectVenvOccupants -RepositoryRoot $repo)
    if ($occupants.Count -eq 0) { return }

    foreach ($occupant in $occupants) {
        Stop-Process -Id $occupant.ProcessId -Force -ErrorAction SilentlyContinue
    }

    $deadline = [datetime]::UtcNow.AddSeconds($TimeoutSeconds)
    do {
        Start-Sleep -Milliseconds 200
        $occupants = @(Get-ProjectVenvOccupants -RepositoryRoot $repo)
    } while ($occupants.Count -gt 0 -and [datetime]::UtcNow -lt $deadline)

    if ($occupants.Count -gt 0) {
        $detail = (
            $occupants |
                ForEach-Object { '{0} pid={1}' -f $_.Name, $_.ProcessId }
        ) -join '; '
        throw "project venv is still occupied after stop: $detail"
    }
}
