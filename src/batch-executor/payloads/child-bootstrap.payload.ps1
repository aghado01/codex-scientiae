$ErrorActionPreference = 'Continue'
$prefix = 'BATCH-EXECUTOR-RESULT '
$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$output = [System.Collections.Generic.List[object]]::new()
$failure = $null
$succeeded = $false

try {
    $payloadXml = [Console]::In.ReadToEnd()
    $payload = [System.Management.Automation.PSSerializer]::Deserialize($payloadXml)

    $events = @(& {
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
    } *>&1)

    foreach ($event in $events) {
        if ($event -is [System.Management.Automation.ErrorRecord]) {
            $errors.Add($event.ToString())
        }
        elseif ($event -is [System.Management.Automation.WarningRecord]) {
            $warnings.Add($event.Message)
        }
        elseif ($event -is [System.Management.Automation.InformationRecord] -or
                $event -is [System.Management.Automation.VerboseRecord] -or
                $event -is [System.Management.Automation.DebugRecord]) {
            # Diagnostic streams are intentionally not promoted to success output.
        }
        else {
            $output.Add($event)
        }
    }

    $succeeded = ($errors.Count -eq 0)
}
catch {
    $failure = $_.ToString()
}

$wire = [pscustomobject]@{
    Succeeded = ($succeeded -and -not $failure)
    Output    = $output.ToArray()
    Errors    = $errors.ToArray()
    Warnings  = $warnings.ToArray()
    Failure   = $failure
}
$depth = if ($payload -and $payload.SerializationDepth) { [int]$payload.SerializationDepth } else { 12 }
$wireXml = [System.Management.Automation.PSSerializer]::Serialize($wire, $depth)
$wireBytes = [System.Text.Encoding]::UTF8.GetBytes($wireXml)
[Console]::Out.WriteLine($prefix + [System.Convert]::ToBase64String($wireBytes))

if (-not $wire.Succeeded) { exit 1 }
