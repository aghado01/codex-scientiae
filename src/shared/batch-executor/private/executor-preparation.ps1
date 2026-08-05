function ConvertTo-BatchExecutorCliXml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowNull()] [object] $Value,
        [Parameter(Mandatory)] [ValidateRange(1, 100)] [int] $Depth
    )

    return [System.Management.Automation.PSSerializer]::Serialize($Value, $Depth)
}

function Resolve-BatchExecutorPreparation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $InputObject,
        [Parameter(Mandatory)] [string] $ScriptPath,
        [ValidateSet('Runspace', 'Process', 'Mixed')] [string] $ExecutionMode = 'Runspace',
        [string] $ExecutionModeProperty = 'ExecutionMode',
        [string] $ProcessSpecProperty = 'ProcessSpec',
        [object] $Context = $null,
        [string] $InitializationScriptPath,
        [string[]] $ModulePath = @(),
        [ValidateSet('Bare', 'Core', 'Full')] [string] $IssPreset = 'Core',
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
        [string] $IdProperty = 'Id',
        [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
        [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [System.Threading.CancellationToken] $CancellationToken = `
            [System.Threading.CancellationToken]::None,
        [ValidateSet('SharedReadOnly', 'PerItemCopy')] [string] $RunspaceDataPolicy = 'SharedReadOnly',
        [string] $PowerShellPath,
        [string] $WorkingDirectory = (Get-Location).Path,
        [System.Collections.IDictionary] $ProcessEnvironment = @{},
        [bool] $CreateNoWindow = $true,
        [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')] [string] $WindowStyle = 'Hidden',
        [switch] $LoadProfile,
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')]
        [string] $PriorityClass = 'Normal'
    )

    $workerDefinition = Get-BatchExecutorScriptDefinition -Path $ScriptPath -Role worker `
        -RejectRequires:($ExecutionMode -ne 'Process')
    $initializerDefinition = if ($InitializationScriptPath) {
        Get-BatchExecutorScriptDefinition -Path $InitializationScriptPath -Role initializer `
            -RejectRequires:($ExecutionMode -ne 'Process')
    }
    else { $null }

    $count = $InputObject.Count
    $itemModes = [string[]]::new($count)
    $hasProcessItems = $false
    $hasRunspaceItems = $false
    for ($i = 0; $i -lt $count; $i++) {
        $mode = if ($ExecutionMode -eq 'Mixed') {
            [string](Get-BatchExecutorPropertyValue -Object $InputObject[$i] `
                -Name $ExecutionModeProperty)
        }
        else { $ExecutionMode }
        if ($mode -notin @('Runspace', 'Process')) {
            throw "batch executor item [$i] has invalid execution mode '$mode' (expected Runspace or Process)"
        }
        $itemModes[$i] = $mode
        if ($mode -eq 'Process') { $hasProcessItems = $true }
        else { $hasRunspaceItems = $true }
    }

    if (-not (Test-Path -LiteralPath $WorkingDirectory -PathType Container)) {
        throw "batch executor working directory not found: '$WorkingDirectory'"
    }
    $resolvedWorkingDirectory = (Resolve-Path -LiteralPath $WorkingDirectory).Path

    $processEnvironmentSnapshot = @{}
    if ($null -ne $ProcessEnvironment) {
        foreach ($key in @($ProcessEnvironment.Keys)) {
            $processEnvironmentSnapshot[[string]$key] = $ProcessEnvironment[$key]
        }
    }

    if ($hasProcessItems) {
        if (-not $PowerShellPath) {
            $candidate = Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })
            $PowerShellPath = if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                (Resolve-Path -LiteralPath $candidate).Path
            }
            else { (Get-Command pwsh -ErrorAction Stop).Source }
        }
        if (-not (Test-Path -LiteralPath $PowerShellPath -PathType Leaf)) {
            throw "batch executor child PowerShell not found: '$PowerShellPath'"
        }
        $PowerShellPath = (Resolve-Path -LiteralPath $PowerShellPath).Path
    }

    $effectiveProcessSpecs = [object[]]::new($count)
    if ($hasProcessItems) {
        for ($i = 0; $i -lt $count; $i++) {
            if ($itemModes[$i] -ne 'Process') { continue }

            $rawSpec = Get-BatchExecutorPropertyValue -Object $InputObject[$i] `
                -Name $ProcessSpecProperty
            $itemPowerShellPath = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'PowerShellPath' -Default $PowerShellPath)
            $itemWorkingDirectory = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'WorkingDirectory' -Default $resolvedWorkingDirectory)
            $itemTimeout = [int](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'TimeoutSeconds' -Default $ProcessTimeoutSeconds)
            $itemCreateNoWindow = [bool](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'CreateNoWindow' -Default $CreateNoWindow)
            $itemWindowStyle = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'WindowStyle' -Default $WindowStyle)
            $itemLoadProfile = [bool](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'LoadProfile' -Default ([bool]$LoadProfile))
            $itemPriorityClass = [string](Get-BatchExecutorPropertyValue -Object $rawSpec `
                -Name 'PriorityClass' -Default $PriorityClass)

            if (-not (Test-Path -LiteralPath $itemPowerShellPath -PathType Leaf)) {
                throw "batch executor item [$i] child PowerShell not found: '$itemPowerShellPath'"
            }
            if (-not (Test-Path -LiteralPath $itemWorkingDirectory -PathType Container)) {
                throw "batch executor item [$i] working directory not found: '$itemWorkingDirectory'"
            }
            if ($itemTimeout -lt 0) { throw "batch executor item [$i] timeout must not be negative" }
            if ($itemWindowStyle -notin @('Hidden', 'Normal', 'Minimized', 'Maximized')) {
                throw "batch executor item [$i] has invalid window style '$itemWindowStyle'"
            }
            if ($itemPriorityClass -notin @('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')) {
                throw "batch executor item [$i] has invalid priority class '$itemPriorityClass'"
            }

            $itemEnvironment = @{}
            foreach ($key in @($processEnvironmentSnapshot.Keys)) {
                $itemEnvironment[[string]$key] = $processEnvironmentSnapshot[$key]
            }
            $environmentOverride = Get-BatchExecutorPropertyValue -Object $rawSpec -Name 'Environment'
            if ($null -ne $environmentOverride) {
                if ($environmentOverride -isnot [System.Collections.IDictionary]) {
                    throw "batch executor item [$i] process environment must be a dictionary"
                }
                foreach ($key in @($environmentOverride.Keys)) {
                    $itemEnvironment[[string]$key] = $environmentOverride[$key]
                }
            }

            $effectiveProcessSpecs[$i] = New-BatchExecutorResolvedProcessSpec `
                -PowerShellPath (Resolve-Path -LiteralPath $itemPowerShellPath).Path `
                -WorkingDirectory (Resolve-Path -LiteralPath $itemWorkingDirectory).Path `
                -TimeoutSeconds $itemTimeout -CreateNoWindow $itemCreateNoWindow `
                -WindowStyle $itemWindowStyle -LoadProfile $itemLoadProfile `
                -Environment $itemEnvironment -PriorityClass $itemPriorityClass
        }
    }

    $policy = [pscustomobject]@{
        FailureAction = 'Continue'
        ExecutionMode = $ExecutionMode
        RunspaceData = if (-not $hasRunspaceItems) { 'SerializedCopy' }
            elseif ($hasProcessItems) { "$RunspaceDataPolicy (Runspace); SerializedCopy (Process)" }
            else { $RunspaceDataPolicy }
        Cancellation = 'CallerTokenAndTimeout'
        ChildProcess = if ($hasProcessItems) {
            [pscustomobject]@{
                PowerShellPath = $PowerShellPath
                WorkingDirectory = $resolvedWorkingDirectory
                CreateNoWindow = $CreateNoWindow
                WindowStyle = $WindowStyle
                LoadProfile = [bool]$LoadProfile
                PriorityClass = $PriorityClass
                TimeoutSeconds = $ProcessTimeoutSeconds
                EnvironmentKeys = [string[]]@($processEnvironmentSnapshot.Keys | Sort-Object)
            }
        }
        else { $null }
    }

    $budget = Resolve-BatchWorkerBudget -ItemCount $count -MaxWorkers $MaxWorkers `
        -ReservedCores $ReservedCores -MinItemsPerWorker $MinItemsPerWorker

    if ($count -eq 0) {
        return New-BatchExecutorPreparation -Item @() -ExecutionMode $ExecutionMode `
            -WorkerDefinition $workerDefinition -InitializerDefinition $initializerDefinition `
            -IssPreset $IssPreset -ModulePath $ModulePath -Budget $budget -Policy $policy `
            -CancellationToken $CancellationToken -WaitTimeoutSeconds $WaitTimeoutSeconds
    }

    $ids = [string[]]::new($count)
    $seenIds = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    for ($i = 0; $i -lt $count; $i++) {
        $item = $InputObject[$i]
        $id = $null
        if ($null -ne $item -and $item -is [System.Collections.IDictionary] -and
                $item.Contains($IdProperty)) {
            $id = [string]$item[$IdProperty]
        }
        elseif ($null -ne $item) {
            $property = $item.PSObject.Properties[$IdProperty]
            if ($null -ne $property) { $id = [string]$property.Value }
        }
        if ([string]::IsNullOrWhiteSpace($id)) { $id = 'batch-{0:d4}' -f $i }
        if (-not $seenIds.Add($id)) { throw "batch executor duplicate item id: '$id'" }
        $ids[$i] = $id
    }

    $iss = New-BatchExecutorSessionState -ExecutionMode $ExecutionMode -IssPreset $IssPreset `
        -ModulePath $ModulePath -WorkerBody $workerDefinition.Body `
        -InitializerBody $(if ($initializerDefinition) { $initializerDefinition.Body } else { $null })
    $encodedChildCommand = if ($hasProcessItems) {
        $childCommandBytes = [System.Text.Encoding]::Unicode.GetBytes(
            $script:BatchExecutorChildCommand)
        [System.Convert]::ToBase64String($childCommandBytes)
    }
    else { $null }

    $serializedContext = if ($hasRunspaceItems -and $RunspaceDataPolicy -eq 'PerItemCopy') {
        ConvertTo-BatchExecutorCliXml -Value $Context -Depth $SerializationDepth
    }
    else { $null }

    $preparedItems = [object[]]::new($count)
    for ($i = 0; $i -lt $count; $i++) {
        if ($itemModes[$i] -eq 'Runspace') {
            $dispatchItem = $InputObject[$i]
            $dispatchContext = $Context
            if ($RunspaceDataPolicy -eq 'PerItemCopy') {
                $itemXml = ConvertTo-BatchExecutorCliXml -Value $InputObject[$i] `
                    -Depth $SerializationDepth
                $dispatchItem = [System.Management.Automation.PSSerializer]::Deserialize($itemXml)
                $dispatchContext = [System.Management.Automation.PSSerializer]::Deserialize(
                    $serializedContext)
            }
            $preparedItems[$i] = New-BatchExecutorPreparedItem -Index $i -Id $ids[$i] `
                -Mode Runspace -OriginalInput $InputObject[$i] -DispatchItem $dispatchItem `
                -DispatchContext $dispatchContext
            continue
        }

        # Process payloads are complete before the pool opens. Mixed-mode process items intentionally do
        # not inherit the direct pool's global initializer or modules; job-local dependencies remain data.
        $payload = [pscustomobject]@{
            ScriptPath = $workerDefinition.Path
            InitializationScriptPath = if ($ExecutionMode -eq 'Process' -and $initializerDefinition) {
                $initializerDefinition.Path
            }
            else { $null }
            ModulePath = if ($ExecutionMode -eq 'Process') { [string[]]@($ModulePath) }
                else { [string[]]@() }
            Item = $InputObject[$i]
            Context = $Context
            SerializationDepth = $SerializationDepth
        }
        $payloadXml = ConvertTo-BatchExecutorCliXml -Value $payload -Depth $SerializationDepth
        $preparedItems[$i] = New-BatchExecutorPreparedItem -Index $i -Id $ids[$i] `
            -Mode Process -OriginalInput $InputObject[$i] -ProcessPayloadXml $payloadXml `
            -ProcessSpec $effectiveProcessSpecs[$i]
    }

    return New-BatchExecutorPreparation -Item $preparedItems -ExecutionMode $ExecutionMode `
        -WorkerDefinition $workerDefinition -InitializerDefinition $initializerDefinition `
        -IssPreset $IssPreset -ModulePath $ModulePath -Budget $budget -Policy $policy `
        -CancellationToken $CancellationToken -WaitTimeoutSeconds $WaitTimeoutSeconds `
        -InitialSessionState $iss -EncodedChildCommand $encodedChildCommand
}
