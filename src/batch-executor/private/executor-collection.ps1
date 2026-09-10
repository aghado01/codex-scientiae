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
                $asyncCompleted = $null -ne $invocation.AsyncResult -and $invocation.AsyncResult.IsCompleted
                if ($invocation.TerminalOverride -eq 'TimedOut' -and -not $asyncCompleted) {
                    try { $pipeline.Stop() } catch {}
                    $asyncCompleted = $null -ne $invocation.AsyncResult -and $invocation.AsyncResult.IsCompleted
                }
                if ($asyncCompleted) {
                    try { $pipelineOutput = @($pipeline.EndInvoke($invocation.AsyncResult)) }
                    catch {
                        if ($null -eq $invocation.TerminalOverride) { throw }
                    }
                }
            }
            catch {
                if ($null -eq $invocation.TerminalOverride) {
                    $Lifecycle.InfrastructureErrors.Add(
                        "item '$($preparedItem.Id)' collection failed: $($_.Exception.Message)")
                }
            }

            $envelope = if ($pipelineOutput.Count -gt 0) { $pipelineOutput[-1] } else { $null }
            $errors = [System.Collections.Generic.List[string]]::new()
            $warnings = [System.Collections.Generic.List[string]]::new()
            $information = [System.Collections.Generic.List[string]]::new()
            $pipelineCompleted = $null -ne $invocation.AsyncResult -and
                $invocation.AsyncResult.IsCompleted
            if ($pipelineCompleted) {
                foreach ($record in @($pipeline.Streams.Error)) { $errors.Add($record.ToString()) }
                foreach ($record in @($pipeline.Streams.Warning)) { $warnings.Add($record.Message) }
                foreach ($record in @($pipeline.Streams.Information)) {
                    $information.Add($(if ($null -ne $record.MessageData) {
                                $record.MessageData.ToString()
                            }
                            else { $record.ToString() }))
                }
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
                if ($Lifecycle.WaitOutcome.Kind -eq 'ExecutionTimeout') {
                    $errors.Add('executor execution timeout')
                }
                else {
                    $errors.Add(
                        "batch wait exceeded the total timeout of $($preparation.WaitTimeoutSeconds) second(s)")
                }
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

            $observation = if ($envelope -and $envelope.PSObject.Properties['Observation'] -and
                    $null -ne $envelope.Observation) {
                $envelope.Observation
            }
            else {
                New-BatchExecutorObservation -Submitted:$true `
                    -Started:($null -ne $startedUtc) 
            }
            if ($invocation.TerminalOverride -eq 'TimedOut') {
                $observation.StopReason = if ($Lifecycle.WaitOutcome.Kind -eq 'ExecutionTimeout') {
                    'ExecutionTimeout'
                }
                else { 'WaitTimeout' }
                $observation.StopPhase = 'Await'
            }
            elseif ($invocation.TerminalOverride -eq 'Cancelled') {
                $observation.StopReason = 'CallerCancellation'
                $observation.StopPhase = 'Await'
            }

            $capture = if ($envelope -and $envelope.PSObject.Properties['Capture'] -and
                    $null -ne $envelope.Capture) {
                $envelope.Capture
            }
            else {
                New-BatchExecutorCaptureRecord -Protocol $(if ($preparedItem.Mode -eq 'Process') {
                        'missing'
                    }
                    else { 'not-applicable' })
            }

            $Lifecycle.Results[$preparedItem.Index] = New-BatchExecutorItemResult `
                -Id $preparedItem.Id -Index $preparedItem.Index -OriginalInput $preparedItem.Input `
                -State $state -Output $jobOutput -Errors $errors.ToArray() `
                -Warnings $warnings.ToArray() -Information $information.ToArray() `
                -QueuedUtc $invocation.QueuedUtc -StartedUtc $startedUtc -EndedUtc $endedUtc `
                -DurationMs $durationMs `
                -RunspaceId $(if ($envelope) { $envelope.RunspaceId } else { $null }) `
                -ThreadId $(if ($envelope) { $envelope.ThreadId } else { $null }) `
                -ProcessId $(if ($envelope) { $envelope.ProcessId } else { $null }) `
                -ExitCode $(if ($envelope -and $envelope.PSObject.Properties['ExitCode']) {
                    $envelope.ExitCode
                }
                else { $null }) `
                -StdOut $jobStdOut -StdErr $jobStdErr `
                -Observation $observation -Capture $capture
        }
        catch {
            $materializationError = $_
            $Lifecycle.InfrastructureErrors.Add(
                "item '$($preparedItem.Id)' collection failed: $($materializationError.Exception.Message)")
            $fallbackErrors = [System.Collections.Generic.List[string]]::new()
            $fallbackWarnings = [System.Collections.Generic.List[string]]::new()
            $fallbackErrors.Add($materializationError.ToString())
            if ($invocation.TerminalOverride -eq 'TimedOut') {
                if ($Lifecycle.WaitOutcome.Kind -eq 'ExecutionTimeout') {
                    $fallbackErrors.Add('executor execution timeout')
                }
                else {
                    $fallbackErrors.Add(
                        "batch wait exceeded the total timeout of $($preparation.WaitTimeoutSeconds) second(s)")
                }
            }
            if ($invocation.TerminalOverride -eq 'Cancelled') {
                $fallbackWarnings.Add('caller cancellation requested')
            }
            $Lifecycle.Results[$preparedItem.Index] = New-BatchExecutorItemResult `
                -Id $preparedItem.Id -Index $preparedItem.Index -OriginalInput $preparedItem.Input `
                -State $(if ($invocation.TerminalOverride) { $invocation.TerminalOverride } else { 'Failed' }) `
                -Errors $fallbackErrors.ToArray() -Warnings $fallbackWarnings.ToArray() `
                -QueuedUtc $invocation.QueuedUtc -EndedUtc ([datetime]::UtcNow) `
                -Observation (New-BatchExecutorObservation -Submitted:$true -Started:$false `
                    -StopReason $(if ($invocation.TerminalOverride -eq 'Cancelled') { 'CallerCancellation' }
                        elseif ($invocation.TerminalOverride -eq 'TimedOut' -and
                            $Lifecycle.WaitOutcome.Kind -eq 'ExecutionTimeout') { 'ExecutionTimeout' }
                        elseif ($invocation.TerminalOverride -eq 'TimedOut') { 'WaitTimeout' }
                        else { '' }) `
                    -StopPhase Collect) `
                -Capture (New-BatchExecutorCaptureRecord -StdOutComplete:$false -StdErrComplete:$false `
                    -Protocol $(if ($preparedItem.Mode -eq 'Process') { 'missing' } else { 'not-applicable' }))
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
