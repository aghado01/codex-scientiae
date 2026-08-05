function New-BatchPlan {
    <# Normalizes and freezes jobs before any worker starts. A plan is either executable or contains
       errors and no Plan value; execution never begins with a partially valid queue. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [AllowEmptyCollection()] [object[]] $Job,
        [object] $RunspaceProfile,
        [string] $PlanId = ([guid]::NewGuid().ToString('n')),
        [string] $BasePath = (Get-Location).Path,
        [switch] $AllowWriteCollisions
    )

    $errors = [System.Collections.Generic.List[string]]::new()
    $warnings = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-Path -LiteralPath $BasePath -PathType Container)) {
        $errors.Add("batch plan base path not found: '$BasePath'")
        return [pscustomobject]@{ Plan = $null; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
    }
    $resolvedBasePath = (Resolve-Path -LiteralPath $BasePath).Path

    $profileName = [string](Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'Name' -Default 'default')
    $profileIssPreset = [string](Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'IssPreset' -Default 'Core')
    $profileModules = [string[]]@(Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'ModulePath' -Default @())
    $profileInitializer = [string](Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'InitializationScriptPath')
    $profileContext = Get-BatchExecutorPropertyValue -Object $RunspaceProfile -Name 'Context'
    if ([string]::IsNullOrWhiteSpace($profileName)) { $errors.Add('runspace profile name must not be empty') }
    if ($profileIssPreset -notin @('Bare', 'Core', 'Full')) {
        $errors.Add("runspace profile '$profileName' has invalid ISS preset '$profileIssPreset'")
    }
    $resolvedProfileModules = [System.Collections.Generic.List[string]]::new()
    foreach ($module in $profileModules) {
        try { $resolvedProfileModules.Add((Resolve-BatchPlanModuleReference -Module $module -BasePath $resolvedBasePath)) }
        catch { $errors.Add("runspace profile '$profileName' $($_.Exception.Message)") }
    }
    $profileModules = $resolvedProfileModules.ToArray()
    if (-not [string]::IsNullOrWhiteSpace($profileInitializer)) {
        try {
            $profileInitializer = (Get-BatchExecutorScriptDefinition -Path `
                (Resolve-BatchPlanPath -Path $profileInitializer -BasePath $resolvedBasePath) `
                -Role 'runspace profile initializer' -RejectRequires).Path
        }
        catch { $errors.Add($_.Exception.Message) }
    }

    $normalized = [System.Collections.Generic.List[object]]::new($Job.Count)
    $seenIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    for ($index = 0; $index -lt $Job.Count; $index++) {
        $source = $Job[$index]
        $id = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'Id')
        $kind = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'Kind')
        $entryPoint = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'EntryPoint')
        $runtimeProfile = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'RuntimeProfile' -Default 'default')
        $estimatedCost = Get-BatchExecutorPropertyValue -Object $source -Name 'EstimatedCost' -Default 1
        $argumentMode = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'ArgumentMode' -Default 'None')
        $parameters = Get-BatchExecutorPropertyValue -Object $source -Name 'Parameters'
        $argumentList = Get-BatchExecutorPropertyValue -Object $source -Name 'ArgumentList'
        $workingDirectory = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'WorkingDirectory')
        $processSpecSource = Get-BatchExecutorPropertyValue -Object $source -Name 'ProcessSpec' -Default @{}
        $modulePath = [string[]]@(Get-BatchExecutorPropertyValue -Object $source -Name 'ModulePath' -Default @())
        $initializerPath = [string](Get-BatchExecutorPropertyValue -Object $source -Name 'InitializationScriptPath')
        $writes = [string[]]@(Get-BatchExecutorPropertyValue -Object $source -Name 'Writes' -Default @())
        $metadata = Get-BatchExecutorPropertyValue -Object $source -Name 'Metadata' -Default @{}

        $jobHasErrors = $false
        if ([string]::IsNullOrWhiteSpace($id)) { $errors.Add("batch plan job [$index] has no id"); $jobHasErrors = $true }
        elseif (-not $seenIds.Add($id)) { $errors.Add("batch plan contains duplicate job id '$id'"); $jobHasErrors = $true }
        if ($kind -notin @('RunspaceScript', 'PowerShellProcess')) {
            $errors.Add("batch plan job '$id' has invalid kind '$kind'"); $jobHasErrors = $true
        }
        if ($argumentMode -notin @('None', 'Named', 'Positional')) {
            $errors.Add("batch plan job '$id' has invalid argument mode '$argumentMode'"); $jobHasErrors = $true
        }
        if ($argumentMode -eq 'Named' -and $parameters -isnot [System.Collections.IDictionary]) {
            $errors.Add("batch plan job '$id' named parameters must be a dictionary"); $jobHasErrors = $true
        }
        if ($processSpecSource -isnot [System.Collections.IDictionary]) {
            $errors.Add("batch plan job '$id' process specification must be a dictionary"); $jobHasErrors = $true
            $processSpecSource = @{}
        }
        try {
            $cost = [double]$estimatedCost
            if ([double]::IsNaN($cost) -or [double]::IsInfinity($cost) -or $cost -lt 0) { throw 'invalid' }
        }
        catch { $errors.Add("batch plan job '$id' estimated cost must be a finite non-negative number"); $jobHasErrors = $true; $cost = 1 }

        $processSpec = @{}
        foreach ($key in @($processSpecSource.Keys)) { $processSpec[[string]$key] = $processSpecSource[$key] }
        if ([string]::IsNullOrWhiteSpace($workingDirectory)) {
            $workingDirectory = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'WorkingDirectory' -Default $resolvedBasePath)
        }
        try {
            $workingDirectory = Resolve-BatchPlanPath -Path $workingDirectory -BasePath $resolvedBasePath
            if (-not (Test-Path -LiteralPath $workingDirectory -PathType Container)) {
                throw "working directory not found: '$workingDirectory'"
            }
            $workingDirectory = (Resolve-Path -LiteralPath $workingDirectory).Path
            $processSpec['WorkingDirectory'] = $workingDirectory
        }
        catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }

        if ($kind -eq 'PowerShellProcess') {
            $environment = Get-BatchExecutorPropertyValue -Object $processSpec -Name 'Environment'
            if ($null -ne $environment) {
                if ($environment -isnot [System.Collections.IDictionary]) {
                    $errors.Add("batch plan job '$id' process environment must be a dictionary"); $jobHasErrors = $true
                }
                else {
                    $environmentCopy = @{}
                    foreach ($key in @($environment.Keys)) { $environmentCopy[[string]$key] = $environment[$key] }
                    $processSpec['Environment'] = $environmentCopy
                }
            }
            $timeout = Get-BatchExecutorPropertyValue -Object $processSpec -Name 'TimeoutSeconds'
            if ($null -ne $timeout) {
                try {
                    $timeout = [int]$timeout
                    if ($timeout -lt 0) { throw 'negative' }
                    $processSpec['TimeoutSeconds'] = $timeout
                }
                catch { $errors.Add("batch plan job '$id' process timeout must be a non-negative integer"); $jobHasErrors = $true }
            }
            $jobWindowStyle = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'WindowStyle')
            if ($jobWindowStyle -and $jobWindowStyle -notin @('Hidden', 'Normal', 'Minimized', 'Maximized')) {
                $errors.Add("batch plan job '$id' has invalid process window style '$jobWindowStyle'"); $jobHasErrors = $true
            }
            $jobPriority = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'PriorityClass')
            if ($jobPriority -and $jobPriority -notin @('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')) {
                $errors.Add("batch plan job '$id' has invalid process priority '$jobPriority'"); $jobHasErrors = $true
            }
            $jobPowerShell = [string](Get-BatchExecutorPropertyValue -Object $processSpec -Name 'PowerShellPath')
            if ($jobPowerShell) {
                try {
                    $jobPowerShell = Resolve-BatchPlanPath -Path $jobPowerShell -BasePath $workingDirectory
                    if (-not (Test-Path -LiteralPath $jobPowerShell -PathType Leaf)) {
                        throw "child PowerShell not found: '$jobPowerShell'"
                    }
                    $processSpec['PowerShellPath'] = (Resolve-Path -LiteralPath $jobPowerShell).Path
                }
                catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }
            }
        }

        try {
            if ([string]::IsNullOrWhiteSpace($entryPoint)) { throw 'has no entrypoint' }
            $entryPoint = Resolve-BatchPlanPath -Path $entryPoint -BasePath $workingDirectory
            if (-not (Test-Path -LiteralPath $entryPoint -PathType Leaf)) { throw "entrypoint not found: '$entryPoint'" }
            $entryPoint = (Resolve-Path -LiteralPath $entryPoint).Path
            $parseTokens = $null; $parseErrors = $null
            [void][System.Management.Automation.Language.Parser]::ParseFile($entryPoint, [ref]$parseTokens, [ref]$parseErrors)
            if ($parseErrors.Count -gt 0) { throw "entrypoint does not parse: $($parseErrors[0].Message)" }
        }
        catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }

        $resolvedModules = [System.Collections.Generic.List[string]]::new()
        foreach ($module in $modulePath) {
            try { $resolvedModules.Add((Resolve-BatchPlanModuleReference -Module $module -BasePath $workingDirectory)) }
            catch { $errors.Add("batch plan job '$id' $($_.Exception.Message)"); $jobHasErrors = $true }
        }
        $modulePath = $resolvedModules.ToArray()
        if (-not [string]::IsNullOrWhiteSpace($initializerPath)) {
            try {
                $initializerPath = (Get-BatchExecutorScriptDefinition -Path `
                    (Resolve-BatchPlanPath -Path $initializerPath -BasePath $workingDirectory) `
                    -Role "job '$id' initializer").Path
            }
            catch { $errors.Add($_.Exception.Message); $jobHasErrors = $true }
        }

        $normalizedWrites = [System.Collections.Generic.List[string]]::new()
        foreach ($writePath in $writes) {
            if ([string]::IsNullOrWhiteSpace($writePath)) {
                $errors.Add("batch plan job '$id' declares an empty write path"); $jobHasErrors = $true; continue
            }
            try {
                $normalizedWrite = Resolve-BatchPlanPath -Path $writePath -BasePath $workingDirectory
                $writeRoot = [System.IO.Path]::GetPathRoot($normalizedWrite)
                if (-not $normalizedWrite.Equals($writeRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $normalizedWrite = $normalizedWrite.TrimEnd(
                        [System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
                }
                $normalizedWrites.Add($normalizedWrite)
            }
            catch { $errors.Add("batch plan job '$id' has invalid write path '$writePath': $($_.Exception.Message)"); $jobHasErrors = $true }
        }

        $parameterCopy = if ($argumentMode -eq 'Named' -and $parameters -is [System.Collections.IDictionary]) {
            $copy = @{}; foreach ($key in @($parameters.Keys)) { $copy[[string]$key] = $parameters[$key] }; $copy
        }
        else { $null }
        $metadataCopy = @{}
        if ($metadata -is [System.Collections.IDictionary]) {
            foreach ($key in @($metadata.Keys)) { $metadataCopy[[string]$key] = $metadata[$key] }
        }

        if (-not $jobHasErrors) {
            $normalized.Add([pscustomobject]@{
                Id = $id; Kind = $kind
                ExecutionMode = if ($kind -eq 'RunspaceScript') { 'Runspace' } else { 'Process' }
                EntryPoint = $entryPoint; ArgumentMode = $argumentMode
                Parameters = $parameterCopy
                ArgumentList = if ($argumentMode -eq 'Positional') { [object[]]@($argumentList) } else { $null }
                RuntimeProfile = $runtimeProfile; ProcessSpec = $processSpec; EstimatedCost = $cost
                Writes = $normalizedWrites.ToArray(); ModulePath = $modulePath
                InitializationScriptPath = $initializerPath; WorkingDirectory = $workingDirectory
                Metadata = $metadataCopy; PlanIndex = $index
            })
        }
    }

    $directProfiles = [string[]]@($normalized | Where-Object ExecutionMode -EQ 'Runspace' |
        ForEach-Object RuntimeProfile | Sort-Object -Unique)
    if ($directProfiles.Count -gt 1) {
        $errors.Add("one runspace pool cannot host multiple direct runtime profiles: $($directProfiles -join ', ')")
    }
    elseif ($directProfiles.Count -eq 1 -and $directProfiles[0] -ne $profileName) {
        $errors.Add("direct jobs request runtime profile '$($directProfiles[0])' but plan provides '$profileName'")
    }

    if (-not $AllowWriteCollisions) {
        $comparison = if ($IsWindows) { [System.StringComparison]::OrdinalIgnoreCase } else { [System.StringComparison]::Ordinal }
        $separator = [string][System.IO.Path]::DirectorySeparatorChar
        for ($left = 0; $left -lt $normalized.Count; $left++) {
            for ($right = $left + 1; $right -lt $normalized.Count; $right++) {
                foreach ($leftPath in @($normalized[$left].Writes)) {
                    foreach ($rightPath in @($normalized[$right].Writes)) {
                        $leftPrefix = if ($leftPath.EndsWith($separator)) { $leftPath } else { $leftPath + $separator }
                        $rightPrefix = if ($rightPath.EndsWith($separator)) { $rightPath } else { $rightPath + $separator }
                        $overlap = $leftPath.Equals($rightPath, $comparison) -or
                            $leftPath.StartsWith($rightPrefix, $comparison) -or
                            $rightPath.StartsWith($leftPrefix, $comparison)
                        if ($overlap) {
                            $errors.Add("write-set collision between jobs '$($normalized[$left].Id)' and '$($normalized[$right].Id)': '$leftPath' <> '$rightPath'")
                        }
                    }
                }
            }
        }
    }

    if ($errors.Count -gt 0) {
        return [pscustomobject]@{ Plan = $null; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
    }

    $dispatchJobs = [object[]]@($normalized | Sort-Object -Property `
        @{ Expression = 'EstimatedCost'; Descending = $true },
        @{ Expression = 'PlanIndex'; Ascending = $true })
    $workerScriptPath = $script:BatchExecutorJobWorkerPath
    if (-not (Test-Path -LiteralPath $workerScriptPath -PathType Leaf)) {
        $errors.Add("batch plan worker not found: '$workerScriptPath'")
        return [pscustomobject]@{ Plan = $null; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
    }
    $plan = [pscustomobject]@{
        Id = $PlanId
        Jobs = [object[]]@($normalized | Sort-Object PlanIndex)
        DispatchJobs = $dispatchJobs
        WorkerScriptPath = (Resolve-Path -LiteralPath $workerScriptPath).Path
        BasePath = $resolvedBasePath
        RunspaceProfile = [pscustomobject]@{
            Name = $profileName; IssPreset = $profileIssPreset; ModulePath = $profileModules
            InitializationScriptPath = $profileInitializer; Context = $profileContext
        }
        Policy = [pscustomobject]@{
            Scheduling = 'GreedyCostDescending'; ResultOrdering = 'OriginalPlanOrder'
            WriteCollisionPolicy = if ($AllowWriteCollisions) { 'CallerOverride' } else { 'RejectOverlap' }
            FailureAction = 'Continue'
        }
        Warnings = $warnings.ToArray()
    }
    $plan.PSObject.TypeNames.Insert(0, 'CodexScientiae.BatchPlan')
    [pscustomobject]@{ Plan = $plan; Errors = $errors.ToArray(); Warnings = $warnings.ToArray() }
}
