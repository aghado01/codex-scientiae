#requires -Version 7.0

BeforeAll {
    $script:AdaptersModuleRoot = (Resolve-Path `
        (Join-Path $PSScriptRoot '../../src/adapters')).Path

    function Get-AdapterSourceAst {
        $records = [System.Collections.Generic.List[object]]::new()
        $sourceFiles = @(Get-ChildItem -LiteralPath $script:AdaptersModuleRoot -Recurse -File |
                Where-Object Extension -In @('.ps1', '.psm1') |
                Sort-Object FullName)
        foreach ($sourceFile in $sourceFiles) {
            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile(
                $sourceFile.FullName, [ref]$tokens, [ref]$parseErrors)
            if ($parseErrors.Count -gt 0) {
                throw "adapter source did not parse: '$($sourceFile.FullName)'"
            }
            $records.Add([pscustomobject]@{
                    Path = $sourceFile.FullName
                    Ast = $ast
                })
        }
        return $records.ToArray()
    }

    $script:AdapterSourceAsts = @(Get-AdapterSourceAst)
    $script:AdapterPlannerSourceAsts = @($script:AdapterSourceAsts | Where-Object {
            $_.Path -notmatch '[\\/]workers[\\/]'
        })
}

Describe 'BEX-403 adapter thinness gate' {
    It 'uses the executor only to construct jobs and exposes no execution-owner inputs' {
        $executorCalls = foreach ($record in $script:AdapterSourceAsts) {
            foreach ($command in @($record.Ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.CommandAst]
                        }, $true))) {
                $name = $command.GetCommandName()
                if ($name -like 'batch-executor\*') { $name }
            }
        }
        @($executorCalls | Sort-Object) | Should -Be @(
            'batch-executor\New-BatchJob'
            'batch-executor\New-BatchJob'
        )

        $publicFunctions = foreach ($record in $script:AdapterSourceAsts) {
            if ((Split-Path -Leaf (Split-Path -Parent $record.Path)) -ne 'public') { continue }
            $record.Ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
                }, $true)
        }
        @($publicFunctions.Name | Sort-Object) | Should -Be @(
            'Get-LatexBatchJob', 'Get-PesterBatchJob')

        $forbiddenInputs = @(
            'MaxWorkers'
            'ThrottleLimit'
            'CancellationToken'
            'RetryCount'
            'BackoffSeconds'
            'ResultOrder'
            'RunId'
            'Runstamp'
            'Logger'
            'LogPath'
            'ResultStore'
            'Resume'
            'Detached'
        )
        $ownedInputs = foreach ($function in $publicFunctions) {
            foreach ($parameter in @($function.Body.ParamBlock.Parameters)) {
                $name = $parameter.Name.VariablePath.UserPath
                if ($name -in $forbiddenInputs) { "$($function.Name):$name" }
            }
        }
        @($ownedInputs) | Should -BeNullOrEmpty
    }

    It 'contains no scheduler or lifecycle machinery and keeps planner hosts infrastructure-free' {
        $allCommandNames = [System.Collections.Generic.List[string]]::new()
        $allMemberNames = [System.Collections.Generic.List[string]]::new()
        $allTypeNames = [System.Collections.Generic.List[string]]::new()
        $plannerCommandNames = [System.Collections.Generic.List[string]]::new()
        $plannerMemberNames = [System.Collections.Generic.List[string]]::new()
        $parallelCalls = [System.Collections.Generic.List[string]]::new()
        $plannerAmpersandCalls = [System.Collections.Generic.List[string]]::new()

        foreach ($record in $script:AdapterSourceAsts) {
            foreach ($command in @($record.Ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.CommandAst]
                        }, $true))) {
                $name = $command.GetCommandName()
                if (-not [string]::IsNullOrWhiteSpace($name)) { $allCommandNames.Add($name) }
                if ($name -eq 'ForEach-Object' -and @($command.CommandElements |
                        Where-Object {
                            $_ -is [System.Management.Automation.Language.CommandParameterAst] -and
                            $_.ParameterName -eq 'Parallel'
                        }).Count -gt 0) {
                    $parallelCalls.Add("$($record.Path):ForEach-Object -Parallel")
                }
            }
            foreach ($invokeMember in @($record.Ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst]
                        }, $true))) {
                if ($invokeMember.Member -is `
                        [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    $allMemberNames.Add($invokeMember.Member.Value)
                }
            }
            foreach ($typeNode in @($record.Ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.TypeExpressionAst] -or
                            $node -is [System.Management.Automation.Language.TypeConstraintAst]
                        }, $true))) {
                $allTypeNames.Add($typeNode.TypeName.FullName)
            }
        }

        foreach ($record in $script:AdapterPlannerSourceAsts) {
            foreach ($command in @($record.Ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.CommandAst]
                        }, $true))) {
                $name = $command.GetCommandName()
                if (-not [string]::IsNullOrWhiteSpace($name)) { $plannerCommandNames.Add($name) }
                if ([string]$command.InvocationOperator -eq 'Ampersand') {
                    $plannerAmpersandCalls.Add("$($record.Path):$($command.Extent.Text)")
                }
            }
            foreach ($invokeMember in @($record.Ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst]
                        }, $true))) {
                if ($invokeMember.Member -is `
                        [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    $plannerMemberNames.Add($invokeMember.Member.Value)
                }
            }
        }

        $forbiddenExecutionCommands = @(
            'New-BatchPlan', 'Invoke-BatchPlan', 'Invoke-BatchExecutor'
            'Start-Job', 'Start-ThreadJob', 'Wait-Job', 'Receive-Job', 'Stop-Job', 'Remove-Job'
            'Start-Process', 'Wait-Process', 'Stop-Process', 'Debug-Process', 'Invoke-Command'
        )
        $forbiddenPlannerCommands = @(
            'New-Item', 'New-Guid', 'Get-Date', 'Get-Random'
            'New-ModuleRunDir', 'New-RunDir'
            'Start-Transcript', 'Stop-Transcript'
            'Start-Sleep', 'Register-ObjectEvent', 'Wait-Event'
            'Set-Content', 'Add-Content', 'Out-File', 'Tee-Object'
            'Export-Csv', 'Export-Clixml', 'ConvertTo-Json'
        )
        $forbiddenExecutionMembers = @(
            'CreateRunspacePool', 'CreateRunspace', 'BeginInvoke', 'EndInvoke'
            'AddScript', 'AddCommand', 'Invoke', 'Start', 'Kill', 'WaitForExit'
        )
        $forbiddenPlannerMembers = @(
            'CreateDirectory'
            'WriteAllText', 'AppendAllText', 'NewGuid'
        )
        $forbiddenTypePattern =
            '(?i)(?:^|\.)(?:PowerShell|RunspacePool|RunspaceFactory|CancellationTokenSource|' +
            'ConcurrentDictionary(?:`2)?|SemaphoreSlim|TaskCompletionSource(?:`1)?|Process)$'

        @($allCommandNames | Where-Object { $_ -in $forbiddenExecutionCommands } |
                Sort-Object -Unique) |
            Should -BeNullOrEmpty
        @($allMemberNames | Where-Object { $_ -in $forbiddenExecutionMembers } |
                Sort-Object -Unique) |
            Should -BeNullOrEmpty
        @($allTypeNames | Where-Object { $_ -match $forbiddenTypePattern } | Sort-Object -Unique) |
            Should -BeNullOrEmpty
        @($parallelCalls) | Should -BeNullOrEmpty
        @($plannerCommandNames | Where-Object { $_ -in $forbiddenPlannerCommands } |
                Sort-Object -Unique) |
            Should -BeNullOrEmpty
        @($plannerMemberNames | Where-Object { $_ -in $forbiddenPlannerMembers } |
                Sort-Object -Unique) |
            Should -BeNullOrEmpty
        @($plannerAmpersandCalls) | Should -BeNullOrEmpty
    }
}
