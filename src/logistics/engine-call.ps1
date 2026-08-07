#requires -Version 7.0
<#
  src/logistics/engine-call.ps1 — the PowerShell -> Python engine boundary.

  This is a mixed-language repository and the seam is placed on purpose, not by convenience:

    OWNERSHIP FOLLOWS THE INVARIANT. Whoever holds the invariant an operation must preserve owns
    that operation. Tarball confinement, entrypoint resolution, and LaTeX declaration parsing carry
    invariants that live in PowerShell and are inseparable from extraction. Atomic publish,
    refuse-overwrite, written-last, and schema conformance are the engine's. So PowerShell owns
    SOURCE truth and the engine owns ARTIFACT truth.

    CROSS ON PATHS AND SCALARS, NEVER ON OBJECTS. A process boundary costs startup, marshalling,
    error fidelity, and cross-runtime debugging. All of it is cheapest when the thing crossing is
    already a file or a scalar. Anything structured that is not already a file gets written to one
    and crosses as its path (see Write-EngineFindings) — if a value is neither a path nor a scalar,
    the split is in the wrong place.

    CROSS PER ARTIFACT, NEVER PER RECORD. Interpreter startup is ~100 ms. Per document that is
    noise; inside a loop over rows it is fatal. Every verb here takes one artifact's worth of work.

    THE CALL IS REPRODUCIBLE BY HAND. Failures carry the exact argument vector, so an invocation
    can be lifted out of a log and rerun. Across two runtimes that is worth more than elegance.

  PENDING: the engine's invocable surface does not exist yet — src/shared/jsonl_engine is a package
  of classes with no `__main__`. Invoke-JsonlEngine is written against the intended contract
  (`python -m jsonl_engine <verb> --flag value`) and will fail until that entry point lands. The
  fact-gathering side is complete and testable without it.
#>

$script:EngineUtf8 = [System.Text.UTF8Encoding]::new($false, $true)

function Get-RepositoryRoot {
    <# Anchored to this file, never to the caller's working directory. #>
    return [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
}

function Resolve-EnginePython {
    <#
    Prefer the repository virtual environment so a deposit does not silently run against whatever
    interpreter happens to be on PATH — the engine's dependencies are pinned to that venv.
    #>
    [CmdletBinding()]
    param([string]$PythonPath = '')

    if ($PythonPath) {
        if (-not [System.IO.File]::Exists($PythonPath)) { throw "python not found: '$PythonPath'" }
        return [System.IO.Path]::GetFullPath($PythonPath)
    }
    $venv = Join-Path (Get-RepositoryRoot) '.venv/Scripts/python.exe'
    if ([System.IO.File]::Exists($venv)) { return [System.IO.Path]::GetFullPath($venv) }
    $venvPosix = Join-Path (Get-RepositoryRoot) '.venv/bin/python'
    if ([System.IO.File]::Exists($venvPosix)) { return [System.IO.Path]::GetFullPath($venvPosix) }

    $onPath = Get-Command python -CommandType Application -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }
    throw 'no python interpreter found: expected .venv under the repository root or python on PATH'
}

function Resolve-EngineModuleRoot {
    <# The directory the engine package sits in, so `-m jsonl_engine` resolves via PYTHONPATH. #>
    $root = Join-Path (Get-RepositoryRoot) 'src/shared'
    $package = Join-Path $root 'jsonl_engine'
    if (-not [System.IO.Directory]::Exists($package)) {
        throw "jsonl engine package not found: '$package'"
    }
    return [System.IO.Path]::GetFullPath($root)
}

function Write-EngineFindings {
    <#
    .SYNOPSIS
        Persist the structured half of a boundary payload and return its path.
    .DESCRIPTION
        Probe results, parsed declarations, and package-control records are the values that are
        neither paths nor scalars. They cross as a file rather than as inflated argument vectors:
        an abstract or an author list on a command line is the shape that eventually meets the
        32767-character limit, and repeated flags reinvent JSON badly.

        UTF-8 without BOM and LF only, matching every other content file this repository writes.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]$Findings,
        [string]$Path = ''
    )

    if (-not $Path) {
        $Path = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-findings-$([guid]::NewGuid().ToString('N')).json")
    }
    $full = [System.IO.Path]::GetFullPath($Path)
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))

    $json = ConvertTo-Json -InputObject $Findings -Depth 32 -WarningAction Stop
    $normalized = [regex]::Replace($json, "`r`n", "`n") + "`n"
    [System.IO.File]::WriteAllBytes($full, $script:EngineUtf8.GetBytes($normalized))
    return $full
}

function ConvertTo-EngineCommandDisplay {
    <# A copy-pasteable rendering of an invocation, for error text and logs. #>
    param([Parameter(Mandatory)][string]$Executable, [Parameter(Mandatory)][string[]]$ArgumentList)

    $parts = [System.Collections.Generic.List[string]]::new()
    $parts.Add('"' + $Executable + '"')
    foreach ($a in $ArgumentList) {
        if ($a -match '[\s"]') { $parts.Add('"' + $a.Replace('"', '\"') + '"') } else { $parts.Add($a) }
    }
    return ($parts -join ' ')
}

function Invoke-JsonlEngine {
    <#
    .SYNOPSIS
        Run one engine verb as a subprocess and return its stdout.
    .DESCRIPTION
        ArgumentList is passed through ProcessStartInfo rather than a composed command string, so
        quoting is the runtime's problem and a path with spaces cannot become two arguments. Both
        streams are drained asynchronously before waiting on exit: reading one to completion first
        deadlocks whenever the other fills its pipe buffer.

        A non-zero exit throws with the reproducible command and the captured stderr, because the
        first question about a cross-runtime failure is always "what exactly did it run".
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][ValidateNotNullOrEmpty()][string]$Verb,
        [string[]]$Argument = @(),
        [string]$PythonPath = '',
        [string]$Module = 'jsonl_engine',
        [ValidateRange(1, 3600)][int]$TimeoutSeconds = 300
    )

    $python = Resolve-EnginePython -PythonPath $PythonPath
    $moduleRoot = Resolve-EngineModuleRoot

    $argv = [System.Collections.Generic.List[string]]::new()
    $argv.Add('-m'); $argv.Add($Module); $argv.Add($Verb)
    foreach ($a in $Argument) { $argv.Add([string]$a) }

    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $python
    foreach ($a in $argv) { $psi.ArgumentList.Add($a) }
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    $psi.WorkingDirectory = (Get-RepositoryRoot)
    $psi.Environment['PYTHONPATH'] = $moduleRoot
    $psi.Environment['PYTHONIOENCODING'] = 'utf-8'

    $display = ConvertTo-EngineCommandDisplay -Executable $python -ArgumentList $argv.ToArray()
    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $psi
    try {
        [void]$process.Start()
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            try { $process.Kill($true) } catch { }
            throw "jsonl engine verb '$Verb' timed out after $TimeoutSeconds s`n  command: $display"
        }
        $stdout = $stdoutTask.GetAwaiter().GetResult()
        $stderr = $stderrTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) {
            throw "jsonl engine verb '$Verb' failed with exit code $($process.ExitCode)`n  command: $display`n  stderr: $stderr"
        }
        return $stdout
    } finally {
        $process.Dispose()
    }
}
