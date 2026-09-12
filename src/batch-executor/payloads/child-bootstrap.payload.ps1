$ErrorActionPreference = 'Continue'
$utf8 = [System.Text.UTF8Encoding]::new($false)
$errorCount = 0
$captureTruncated = $false
$failure = $null
$succeeded = $false
$payload = $null
$pipe = $null
$nativeExitCode = $null
$maxFrame = 1MB
if (-not [string]::IsNullOrWhiteSpace($env:CDXSCI_BATCH_CONTROL_MAX_FRAME)) {
    $maxFrame = [int]$env:CDXSCI_BATCH_CONTROL_MAX_FRAME
}

function Write-BatchExecutorControlFrame {
    param(
        [Parameter(Mandatory)] [byte] $Kind,
        [AllowNull()] [byte[]] $Payload,
        [Parameter(Mandatory)] [System.IO.Stream] $Stream,
        [Parameter(Mandatory)] [int] $MaxFrameBytes
    )

    if ($null -eq $Payload) { $Payload = [byte[]]::new(0) }
    if ($Payload.Length -gt $MaxFrameBytes) {
        $script:captureTruncated = $true
        # A zero-payload loss frame fits every configured frame limit.
        $Stream.Write([byte[]]@(0, 0, 0, 0, 6), 0, 5)
        $Stream.Flush()
        return $false
    }
    $header = [System.BitConverter]::GetBytes([int]$Payload.Length)
    $Stream.Write($header, 0, 4)
    $Stream.WriteByte($Kind)
    if ($Payload.Length -gt 0) { $Stream.Write($Payload, 0, $Payload.Length) }
    $Stream.Flush()
    return $true
}

try {
    $pipeName = [string]$env:CDXSCI_BATCH_CONTROL_PIPE
    if ([string]::IsNullOrWhiteSpace($pipeName)) {
        throw 'CDXSCI_BATCH_CONTROL_PIPE is not set'
    }
    $pipe = [System.IO.Pipes.NamedPipeClientStream]::new(
        '.', $pipeName, [System.IO.Pipes.PipeDirection]::Out)
    $pipe.Connect(15000)

    $stdin = [Console]::OpenStandardInput()
    $payloadBuffer = [System.IO.MemoryStream]::new()
    $stdin.CopyTo($payloadBuffer)
    $payloadXml = $utf8.GetString($payloadBuffer.ToArray())
    $payload = [System.Management.Automation.PSSerializer]::Deserialize($payloadXml)
    $depth = if ($payload -and $payload.SerializationDepth) { [int]$payload.SerializationDepth } else { 12 }

    & {
        foreach ($module in @($payload.ModulePath)) {
            if (-not [string]::IsNullOrWhiteSpace([string]$module)) {
                Import-Module -Name ([string]$module) -ErrorAction Stop
            }
        }

        $initializerOutput = if ($payload.InitializationScriptPath) {
            @(& ([string]$payload.InitializationScriptPath) $payload.Context)
        }
        else { @() }
        $runspaceState = if ($initializerOutput.Count -eq 0) { $null }
            elseif ($initializerOutput.Count -eq 1) { $initializerOutput[0] }
            else { $initializerOutput }

        & ([string]$payload.ScriptPath) $payload.Item $payload.Context $runspaceState
    } *>&1 | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            $text = $_.ToString()
            $script:errorCount++
            $bytes = $utf8.GetBytes([System.Management.Automation.PSSerializer]::Serialize($text, 2))
            [void](Write-BatchExecutorControlFrame -Kind 2 -Payload $bytes -Stream $pipe -MaxFrameBytes $maxFrame)
        }
        elseif ($_ -is [System.Management.Automation.WarningRecord]) {
            $text = [string]$_.Message
            $bytes = $utf8.GetBytes([System.Management.Automation.PSSerializer]::Serialize($text, 2))
            [void](Write-BatchExecutorControlFrame -Kind 3 -Payload $bytes -Stream $pipe -MaxFrameBytes $maxFrame)
        }
        elseif ($_ -is [System.Management.Automation.InformationRecord] -or
                $_ -is [System.Management.Automation.VerboseRecord] -or
                $_ -is [System.Management.Automation.DebugRecord]) {
            $text = $_.ToString()
            $bytes = $utf8.GetBytes([System.Management.Automation.PSSerializer]::Serialize($text, 2))
            [void](Write-BatchExecutorControlFrame -Kind 4 -Payload $bytes -Stream $pipe -MaxFrameBytes $maxFrame)
        }
        else {
            $bytes = $utf8.GetBytes([System.Management.Automation.PSSerializer]::Serialize($_, $depth))
            [void](Write-BatchExecutorControlFrame -Kind 1 -Payload $bytes -Stream $pipe -MaxFrameBytes $maxFrame)
        }
    }

    $succeeded = ($errorCount -eq 0)
}
catch {
    if ($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) {
        $nativeExitCode = [int]$LASTEXITCODE
    }
    $failure = $_.ToString()
}

if ($null -eq $nativeExitCode -and $null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) {
    $nativeExitCode = [int]$LASTEXITCODE
}

$depth = if ($payload -and $payload.SerializationDepth) { [int]$payload.SerializationDepth } else { 12 }
$wire = [pscustomobject]@{
    Succeeded = ($succeeded -and -not $failure -and -not $captureTruncated)
    Truncated = $captureTruncated
    Failure   = $failure
}
if ($null -ne $pipe) {
    try {
        $wireXml = [System.Management.Automation.PSSerializer]::Serialize($wire, $depth)
        [void](Write-BatchExecutorControlFrame -Kind 5 -Payload $utf8.GetBytes($wireXml) `
            -Stream $pipe -MaxFrameBytes $maxFrame)
    }
    catch {}
    try { $pipe.Dispose() } catch {}
}

if ($null -ne $nativeExitCode) { exit $nativeExitCode }
if (-not $wire.Succeeded) { exit 1 }
