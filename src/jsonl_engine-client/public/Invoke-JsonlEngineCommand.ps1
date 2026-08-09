function Invoke-JsonlEngineCommand {
    <#
    .SYNOPSIS
        Invoke one versioned JSONL-engine CLI command and emit its protocol value frames.
    .DESCRIPTION
        This is the one public escape hatch for engine verbs without an ergonomic wrapper. Each
        result is a JsonlEngine.CliValueFrame, so a top-level array, scalar, or JSON null remains
        one PowerShell pipeline item. High-level cmdlets unwrap values where that is convenient.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()] [string] $Verb,
        [Parameter(Position = 1)] [string[]] $Argument = @(),
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )

    Invoke-JsonlEngineProcess -Verb $Verb -Argument $Argument -PythonPath $PythonPath `
        -TimeoutSeconds $TimeoutSeconds
}
