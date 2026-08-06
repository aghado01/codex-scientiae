#requires -Version 7.0

BeforeAll {
    $script:RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $script:RequiredTopologyFiles = @(
        '.codex/config.toml'
        'README.md'
        'CLAUDE.md'
        'AGENTS.md'
        'CONTRIBUTING.md'
        'TODO.md'
    )

    function Get-ActiveTopologyFiles {
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [System.Collections.Generic.List[string]] $Failures
        )

        $files = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
        foreach ($rootName in @('src', 'tests')) {
            $root = Join-Path $script:RepoRoot $rootName
            if (-not [System.IO.Directory]::Exists($root)) {
                $Failures.Add("required topology root missing: $rootName")
                continue
            }
            foreach ($file in @(Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object {
                $_.Extension -in '.ps1', '.psm1', '.psd1', '.json', '.md', '.js', '.mjs', '.cmd', '.toml'
            })) {
                $files.Add($file)
            }
        }

        foreach ($relativePath in $script:RequiredTopologyFiles) {
            $path = Join-Path $script:RepoRoot $relativePath
            if (-not [System.IO.File]::Exists($path)) {
                $Failures.Add("required topology input missing: $relativePath")
                continue
            }
            $files.Add((Get-Item -LiteralPath $path))
        }
        return $files.ToArray()
    }

    function Get-StaticDotSourceFailures {
        $dotSourceRx = [regex]'(?:^|\s)\.\s+'
        $directRx = [regex]'\$PSScriptRoot[\\/](?<rel>[^"'']+?\.ps(?:1|m1|d1))'
        $joinRx = [regex]'Join-Path\s+\$PSScriptRoot\s+[''"](?<rel>[^''"]+?\.ps(?:1|m1|d1))[''"]'
        $failures = [System.Collections.Generic.List[string]]::new()

        $files = @(Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot 'src'),
                    (Join-Path $script:RepoRoot 'tests') -Recurse -File | Where-Object {
                $_.Extension -in '.ps1', '.psm1'
            })
        foreach ($file in $files) {
            $lineNumber = 0
            foreach ($line in [System.IO.File]::ReadLines($file.FullName)) {
                $lineNumber++
                if (-not $dotSourceRx.IsMatch($line)) { continue }
                $match = $directRx.Match($line)
                if (-not $match.Success) { $match = $joinRx.Match($line) }
                if (-not $match.Success) { continue }

                $target = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $match.Groups['rel'].Value))
                if (-not [System.IO.File]::Exists($target)) {
                    $relativeFile = [System.IO.Path]::GetRelativePath($script:RepoRoot, $file.FullName)
                    $relativeTarget = [System.IO.Path]::GetRelativePath($script:RepoRoot, $target)
                    $failures.Add("${relativeFile}:$lineNumber -> $relativeTarget")
                }
            }
        }
        return $failures.ToArray()
    }

    function Get-LiteralSourcePathFailures {
        $sourcePathRx = [regex]'(?:src|tests)[\\/][A-Za-z0-9_.\\/-]+\.(?:ps1|psm1|psd1|js|mjs)(?![A-Za-z0-9])'
        $failures = [System.Collections.Generic.List[string]]::new()
        $activeFiles = @(Get-ActiveTopologyFiles -Failures $failures)

        foreach ($file in $activeFiles) {
            $lineNumber = 0
            foreach ($line in [System.IO.File]::ReadLines($file.FullName)) {
                $lineNumber++
                foreach ($match in $sourcePathRx.Matches($line)) {
                    $target = Join-Path $script:RepoRoot ($match.Value -replace '\\', '/')
                    if (-not [System.IO.File]::Exists($target)) {
                        $relativeFile = [System.IO.Path]::GetRelativePath($script:RepoRoot, $file.FullName)
                        $failures.Add("${relativeFile}:$lineNumber -> $($match.Value)")
                    }
                }
            }
        }
        return $failures.ToArray()
    }

    function Get-BatchTopologyFailures {
        $failures = [System.Collections.Generic.List[string]]::new()
        $adapterRoot = Join-Path $script:RepoRoot 'src/adapters'
        $expectedManifest = Join-Path $adapterRoot 'adapters.psd1'
        $expectedModule = Join-Path $adapterRoot 'adapters.psm1'

        $adapterManifests = @(Get-ChildItem -LiteralPath $adapterRoot -Recurse -Filter *.psd1 -File)
        if ($adapterManifests.Count -ne 1 -or
            $adapterManifests[0].FullName -ne $expectedManifest) {
            $failures.Add('Pester and LaTeX planners must share only src/adapters/adapters.psd1')
        }
        $adapterModules = @(Get-ChildItem -LiteralPath $adapterRoot -Recurse -Filter *.psm1 -File)
        if ($adapterModules.Count -ne 1 -or $adapterModules[0].FullName -ne $expectedModule) {
            $failures.Add('Pester and LaTeX planners must share only src/adapters/adapters.psm1')
        }

        $oldPaths = @(
            (Join-Path $adapterRoot ('public/Get-' + 'TestBatchJob.ps1'))
            (Join-Path $adapterRoot ('private/test-' + 'address.ps1'))
            (Join-Path $adapterRoot ('private/test-' + 'discovery.ps1'))
            (Join-Path $script:RepoRoot ('tests/adapters/test-' + 'batch.Tests.ps1'))
        )
        foreach ($oldPath in $oldPaths) {
            if ([System.IO.File]::Exists($oldPath)) {
                $failures.Add("retired generic Pester adapter path returned: '$oldPath'")
            }
        }
        $adapterSource = @(Get-ChildItem -LiteralPath $adapterRoot -Recurse -File | Where-Object {
                $_.Extension -in @('.ps1', '.psm1', '.psd1', '.md')
            } | ForEach-Object { [System.IO.File]::ReadAllText($_.FullName) }) -join "`n"
        if ($adapterSource -match 'Get-TestBatchJob|\bTestBatch|test-batch|test-jobs') {
            $failures.Add('live adapter source contains a retired generic Pester adapter name')
        }

        $testSidecars = @(Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot 'tests') `
                -Recurse -File | Where-Object {
                $_.Name -match '(?i)\.Tests\.(?:json|psd1|ya?ml)$' -or
                $_.Name -match '(?i)\.(?:batch|resources|workload)\.(?:json|psd1|ya?ml)$'
            })
        foreach ($sidecar in $testSidecars) {
            $relative = [System.IO.Path]::GetRelativePath($script:RepoRoot, $sidecar.FullName)
            $failures.Add("per-container batch sidecar is not allowed: '$relative'")
        }

        $runnerOwners = [System.Collections.Generic.List[string]]::new()
        $compositionOwners = [System.Collections.Generic.List[string]]::new()
        $scriptFiles = @(Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot 'src'),
                (Join-Path $script:RepoRoot 'tests') -Recurse -File | Where-Object {
                $_.Extension -in @('.ps1', '.psm1')
            })
        foreach ($scriptFile in $scriptFiles) {
            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile(
                $scriptFile.FullName, [ref]$tokens, [ref]$parseErrors)
            $relative = [System.IO.Path]::GetRelativePath(
                $script:RepoRoot, $scriptFile.FullName) -replace '\\', '/'
            if ($parseErrors.Count -gt 0) {
                $failures.Add("batch topology could not parse '$relative'")
                continue
            }
            foreach ($command in @($ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.CommandAst]
                        }, $true))) {
                $name = $command.GetCommandName()
                if ($name -in @('New-PesterContainer', 'Invoke-Pester')) {
                    $runnerOwners.Add("$relative::$name")
                }
                if ($scriptFile.Name -notlike '*.Tests.ps1' -and $name -in @(
                        'adapters\Get-LatexBatchJob'
                        'adapters\Get-PesterBatchJob'
                        'batch-executor\New-BatchPlan'
                        'batch-executor\Invoke-BatchPlan'
                    )) {
                    $compositionOwners.Add("$relative::$name")
                }
            }
        }

        $actualRunnerOwners = @($runnerOwners | Sort-Object)
        $expectedRunnerOwners = @(
            'tests/run.ps1::Invoke-Pester'
            'tests/run.ps1::New-PesterContainer'
        )
        if (($actualRunnerOwners -join "`n") -ne ($expectedRunnerOwners -join "`n")) {
            $failures.Add("repository Pester runner ownership drifted: $($actualRunnerOwners -join ', ')")
        }
        $actualCompositionOwners = @($compositionOwners | Sort-Object)
        $expectedCompositionOwners = @(
            'src/latex-ingest/latex-batch.ps1::adapters\Get-LatexBatchJob'
            'src/latex-ingest/latex-batch.ps1::batch-executor\Invoke-BatchPlan'
            'src/latex-ingest/latex-batch.ps1::batch-executor\New-BatchPlan'
            'tests/parallel.ps1::adapters\Get-PesterBatchJob'
            'tests/parallel.ps1::batch-executor\Invoke-BatchPlan'
            'tests/parallel.ps1::batch-executor\New-BatchPlan'
        )
        if (($actualCompositionOwners -join "`n") -ne
            ($expectedCompositionOwners -join "`n")) {
            $failures.Add(
                "repository batch composition ownership drifted: $($actualCompositionOwners -join ', ')")
        }

        return $failures.ToArray()
    }
}

Describe 'source path topology' {
    It 'resolves every literal PSScriptRoot dot-source in src and tests' {
        $failures = @(Get-StaticDotSourceFailures)
        $failures.Count | Should -Be 0 -Because ($failures -join [Environment]::NewLine)
    }

    It 'keeps active literal source-code references pointed at existing files' {
        $failures = @(Get-LiteralSourcePathFailures)
        $failures.Count | Should -Be 0 -Because ($failures -join [Environment]::NewLine)

        $batchFailures = @(Get-BatchTopologyFailures)
        $batchFailures.Count | Should -Be 0 -Because ($batchFailures -join [Environment]::NewLine)
    }

    It 'keeps configured Codex MCP declarations and script arguments portable' {
        $failures = [System.Collections.Generic.List[string]]::new()
        $configPath = Join-Path $script:RepoRoot '.codex/config.toml'
        if (-not [System.IO.File]::Exists($configPath)) {
            $failures.Add('required MCP registry missing: .codex/config.toml')
        }
        else {
            $toml = [System.IO.File]::ReadAllText($configPath)
            $sectionRx = [regex]'(?ms)^\s*\[mcp_servers\.(?<name>[^\]\r\n]+)\]\s*(?<body>.*?)(?=^\s*\[|\z)'
            $sections = @($sectionRx.Matches($toml))
            $declaredHeaders = @([regex]::Matches($toml, '(?m)^\s*\[mcp_servers\.'))
            if ($sections.Count -eq 0) {
                $failures.Add('.codex/config.toml defines no MCP server sections')
            }
            if ($sections.Count -ne $declaredHeaders.Count) {
                $failures.Add(".codex/config.toml has $($declaredHeaders.Count) MCP headers but only $($sections.Count) parseable sections")
            }

            foreach ($section in $sections) {
                $name = $section.Groups['name'].Value
                $body = $section.Groups['body'].Value
                $commands = @([regex]::Matches($body, '(?m)^\s*command\s*=\s*"(?<value>[^"\r\n]+)"\s*$'))
                if ($commands.Count -ne 1) {
                    $failures.Add(".codex/config.toml:$name requires exactly one command (found $($commands.Count))")
                }
                else {
                    $command = $commands[0].Groups['value'].Value
                    # Repository-relative command paths are source topology. Absolute paths and bare
                    # executable names belong to the host-capability assertion below.
                    if (-not [System.IO.Path]::IsPathRooted($command) -and
                        $command -match '[\\/]') {
                        $candidate = Join-Path $script:RepoRoot $command
                        if (-not [System.IO.File]::Exists($candidate)) {
                            $failures.Add(".codex/config.toml:$name command -> $command")
                        }
                    }
                }

                $argsBlocks = @([regex]::Matches($body, '(?ms)^\s*args\s*=\s*\[(?<value>.*?)\]\s*$'))
                if ($argsBlocks.Count -ne 1) {
                    $failures.Add(".codex/config.toml:$name requires exactly one args array (found $($argsBlocks.Count))")
                    continue
                }
                $argsList = @([regex]::Matches($argsBlocks[0].Groups['value'].Value, '"(?<value>[^"\r\n]*)"') |
                    ForEach-Object { $_.Groups['value'].Value })
                $fileIndexes = @(for ($i = 0; $i -lt $argsList.Count; $i++) {
                        if ($argsList[$i] -ieq '-File') { $i }
                    })
                if ($fileIndexes.Count -ne 1 -or $fileIndexes[0] -ge ($argsList.Count - 1)) {
                    $failures.Add(".codex/config.toml:$name requires exactly one -File target")
                    continue
                }
                $scriptArg = $argsList[$fileIndexes[0] + 1]
                $scriptPath = if ([System.IO.Path]::IsPathRooted($scriptArg)) {
                    $scriptArg
                }
                else {
                    Join-Path $script:RepoRoot $scriptArg
                }
                if (-not [System.IO.File]::Exists($scriptPath)) {
                    $failures.Add(".codex/config.toml:$name script -> $scriptArg")
                }
            }
        }

        $failures.Count | Should -Be 0 -Because ($failures -join [Environment]::NewLine)
    }

    It 'resolves configured host-local Codex MCP executables when available' {
        $configPath = Join-Path $script:RepoRoot '.codex/config.toml'
        Test-Path -LiteralPath $configPath -PathType Leaf | Should -BeTrue `
            -Because 'the portable topology assertion requires the repository MCP registry'

        $toml = [System.IO.File]::ReadAllText($configPath)
        $sectionRx = [regex]'(?ms)^\s*\[mcp_servers\.(?<name>[^\]\r\n]+)\]\s*(?<body>.*?)(?=^\s*\[|\z)'
        $sections = @($sectionRx.Matches($toml))
        $sections.Count | Should -BeGreaterThan 0

        $hostCommands = @(foreach ($section in $sections) {
                $name = $section.Groups['name'].Value
                $commands = @([regex]::Matches(
                        $section.Groups['body'].Value,
                        '(?m)^\s*command\s*=\s*"(?<value>[^"\r\n]+)"\s*$'))
                $commands.Count | Should -Be 1 `
                    -Because ".codex/config.toml:$name must declare one command"
                $command = $commands[0].Groups['value'].Value
                if ([System.IO.Path]::IsPathRooted($command) -or $command -notmatch '[\\/]') {
                    [pscustomobject]@{ Name = $name; Command = $command }
                }
            })
        $probes = @(foreach ($record in $hostCommands) {
                $available = if ([System.IO.Path]::IsPathRooted($record.Command)) {
                    [System.IO.File]::Exists($record.Command)
                }
                else {
                    $null -ne (Get-Command $record.Command -CommandType Application `
                            -ErrorAction SilentlyContinue | Select-Object -First 1)
                }
                [pscustomobject]@{
                    Name = $record.Name
                    Command = $record.Command
                    Available = $available
                }
            })
        $missing = @($probes | Where-Object { -not $_.Available })
        if ($missing.Count -gt 0) {
            $reason = @($missing | ForEach-Object { "$($_.Name) -> $($_.Command)" }) -join '; '
            Set-ItResult -Skipped -Because "configured MCP host executable unavailable: $reason"
            return
        }

        $missing.Count | Should -Be 0
    }
}
