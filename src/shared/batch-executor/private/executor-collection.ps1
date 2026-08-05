function Receive-BatchExecutorResults {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor collection requires a lifecycle state record'
    }

    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Collecting
    $preparation = $Lifecycle.Preparation
    $swCollect = [System.Diagnostics.Stopwatch]::StartNew()
    foreach ($invocation in $Lifecycle.Invocations) {
        $preparedItem = $invocation.PreparedItem
        $pipeline = $invocation.Pipeline
        try {
            $pipelineOutput = @()
            try {
                if ($invocation.TerminalOverride -eq 'TimedOut' -and
                        -not $invocation.AsyncResult.IsCompleted) {
                    try { $pipeline.Stop() } catch {}
                }
                if ($invocation.AsyncResult.IsCompleted) {
                    $pipelineOutput = @($pipeline.EndInvoke($invocation.AsyncResult))
                }
            }
            catch {
                if ($null -eq $invocation.TerminalOverride) {
                    $Lifecycle.InfrastructureErrors.Add(
                        "item '$($preparedItem.Id)' collection failed: $($_.Exception.Message)")
                }
            }

            # EndInvoke output is already adapted/unwrapped when materialized through @(...).
            $envelope = if ($pipelineOutput.Count -gt 0) { $pipelineOutput[-1] } else { $null }
            $errors = [System.Collections.Generic.List[string]]::new()
            $warnings = [System.Collections.Generic.List[string]]::new()
            $information = [System.Collections.Generic.List[string]]::new()
            foreach ($record in @($pipeline.Streams.Error)) { $errors.Add($record.ToString()) }
            foreach ($record in @($pipeline.Streams.Warning)) { $warnings.Add($record.Message) }
            foreach ($record in @($pipeline.Streams.Information)) {
                $information.Add($(if ($null -ne $record.MessageData) {
                            $record.MessageData.ToString()
                        }
                        else { $record.ToString() }))
            }
            if ($envelope -and $envelope.Failure) { $errors.Add([string]$envelope.Failure) }
            if ($envelope -and $envelope.PSObject.Properties['Errors']) {
                foreach ($record in @($envelope.Errors)) {
                    if ($record) { $errors.Add([string]$record) }
                }
            }
            if ($envelope -and $envelope.PSObject.Properties['Warnings']) {
                foreach ($record in @($envelope.Warnings)) {
                    if ($record) { $warnings.Add([string]$record) }
                }
            }
            if ($invocation.TerminalOverride -eq 'TimedOut') {
                $errors.Add(
                    "batch wait exceeded the total timeout of $($preparation.WaitTimeoutSeconds) second(s)")
            }
            if ($invocation.TerminalOverride -eq 'Cancelled') {
                $warnings.Add('caller cancellation requested')
            }

            $state = if ($invocation.TerminalOverride) { $invocation.TerminalOverride }
                     elseif ($envelope -and $envelope.PSObject.Properties['State']) {
                        [string]$envelope.State
                     }
                     elseif ($null -eq $envelope -or $errors.Count -gt 0) { 'Failed' }
                     else { 'Succeeded' }
            if ($state -eq 'Succeeded' -and $errors.Count -gt 0) { $state = 'Failed' }

            $startedUtc = if ($envelope) { $envelope.StartedUtc } else { $null }
            $endedUtc = if ($envelope) { $envelope.EndedUtc } else { [datetime]::UtcNow }
            $durationMs = if ($startedUtc -and $endedUtc) {
                [math]::Round(
                    (([datetime]$endedUtc) - ([datetime]$startedUtc)).TotalMilliseconds, 2)
            }
            else { $null }
            [object[]] $jobOutput = @()
            [string[]] $jobStdOut = @()
            [string[]] $jobStdErr = @()
            if ($envelope) { $jobOutput = [object[]]@($envelope.Output) }
            if ($envelope -and $envelope.PSObject.Properties['StdOut']) {
                $jobStdOut = [string[]]@($envelope.StdOut)
            }
            if ($envelope -and $envelope.PSObject.Properties['StdErr']) {
                $jobStdErr = [string[]]@($envelope.StdErr)
            }

            $Lifecycle.Results[$preparedItem.Index] = [pscustomobject]@{
                Id = $preparedItem.Id
                Index = $preparedItem.Index
                Input = $preparedItem.Input
                State = $state
                Output = $jobOutput
                Errors = $errors.ToArray()
                Warnings = $warnings.ToArray()
                Information = $information.ToArray()
                QueuedUtc = $invocation.QueuedUtc
                StartedUtc = $startedUtc
                EndedUtc = $endedUtc
                DurationMs = $durationMs
                RunspaceId = if ($envelope) { $envelope.RunspaceId } else { $null }
                ThreadId = if ($envelope) { $envelope.ThreadId } else { $null }
                ProcessId = if ($envelope) { $envelope.ProcessId } else { $null }
                ExitCode = if ($envelope -and $envelope.PSObject.Properties['ExitCode']) {
                    $envelope.ExitCode
                }
                else { $null }
                StdOut = $jobStdOut
                StdErr = $jobStdErr
            }
        }
        catch {
            $materializationError = $_
            $Lifecycle.InfrastructureErrors.Add(
                "item '$($preparedItem.Id)' collection failed: $($materializationError.Exception.Message)")
            $fallbackErrors = [System.Collections.Generic.List[string]]::new()
            $fallbackWarnings = [System.Collections.Generic.List[string]]::new()
            $fallbackErrors.Add($materializationError.ToString())
            if ($invocation.TerminalOverride -eq 'TimedOut') {
                $fallbackErrors.Add(
                    "batch wait exceeded the total timeout of $($preparation.WaitTimeoutSeconds) second(s)")
            }
            if ($invocation.TerminalOverride -eq 'Cancelled') {
                $fallbackWarnings.Add('caller cancellation requested')
            }
            $Lifecycle.Results[$preparedItem.Index] = [pscustomobject]@{
                Id = $preparedItem.Id
                Index = $preparedItem.Index
                Input = $preparedItem.Input
                State = if ($invocation.TerminalOverride) {
                    $invocation.TerminalOverride
                }
                else { 'Failed' }
                Output = @()
                Errors = $fallbackErrors.ToArray()
                Warnings = $fallbackWarnings.ToArray()
                Information = @()
                QueuedUtc = $invocation.QueuedUtc
                StartedUtc = $null
                EndedUtc = [datetime]::UtcNow
                DurationMs = $null
                RunspaceId = $null
                ThreadId = $null
                ProcessId = $null
                ExitCode = $null
                StdOut = @()
                StdErr = @()
            }
        }
    }

    $Lifecycle.Timing['CollectMs'] = $swCollect.ElapsedMilliseconds
    $missingResultIndexes = @(
        for ($index = 0; $index -lt $Lifecycle.Results.Count; $index++) {
            if ($null -eq $Lifecycle.Results[$index]) { $index }
        }
    )
    if ($missingResultIndexes.Count -gt 0) {
        throw "batch executor collection left result indexes unmaterialized: $($missingResultIndexes -join ', ')"
    }
    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Collected
    $Lifecycle.CompletedNormally = $true
}
