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
        $adapterRoot = Join-Path $script:RepoRoot 'src/batch-adapters'
        $expectedManifest = Join-Path $adapterRoot 'adapters.psd1'
        $expectedModule = Join-Path $adapterRoot 'adapters.psm1'

        $adapterManifests = @(Get-ChildItem -LiteralPath $adapterRoot -Recurse -Filter *.psd1 -File)
        if ($adapterManifests.Count -ne 1 -or
            $adapterManifests[0].FullName -ne $expectedManifest) {
            $failures.Add('Pester, pytest, and LaTeX planners must share only src/batch-adapters/adapters.psd1')
        }
        $adapterModules = @(Get-ChildItem -LiteralPath $adapterRoot -Recurse -Filter *.psm1 -File)
        if ($adapterModules.Count -ne 1 -or $adapterModules[0].FullName -ne $expectedModule) {
            $failures.Add('Pester, pytest, and LaTeX planners must share only src/batch-adapters/adapters.psm1')
        }

        $oldPaths = @(
            (Join-Path $adapterRoot ('public/Get-' + 'TestBatchJob.ps1'))
            (Join-Path $adapterRoot ('private/test-' + 'address.ps1'))
            (Join-Path $adapterRoot ('private/test-' + 'discovery.ps1'))
            (Join-Path $script:RepoRoot ('tests/batch-adapters/test-' + 'batch.Tests.ps1'))
        )
        foreach ($oldPath in $oldPaths) {
            if ([System.IO.File]::Exists($oldPath)) {
                $failures.Add("retired generic Pester adapter path returned: '$oldPath'")
            }
        }
        $adapterSource = @(Get-ChildItem -LiteralPath $adapterRoot -Recurse -File | Where-Object {
                $_.Extension -in @('.ps1', '.psm1', '.psd1', '.md')
            } | ForEach-Object { [System.IO.File]::ReadAllText($_.FullName) }) -join "`n"
        if ($adapterSource -match 'Get-TestBatchJob|\bTestBatch|\btest-batch|\btest-jobs') {
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
        $pytestRunnerOwners = [System.Collections.Generic.List[string]]::new()
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
            if ($scriptFile.Name -notlike '*.Tests.ps1' -and
                    $ast.Extent.Text -match 'PytestContainerObservation') {
                $pytestRunnerOwners.Add($relative)
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
                        'adapters\Get-PesterBatchJob'
                        'adapters\Get-PytestBatchJob'
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
        $actualPytestRunnerOwners = @($pytestRunnerOwners | Sort-Object)
        if (($actualPytestRunnerOwners -join "`n") -ne 'tests/pytest.ps1') {
            $failures.Add(
                "repository pytest runner ownership drifted: $($actualPytestRunnerOwners -join ', ')")
        }
        $actualCompositionOwners = @($compositionOwners | Sort-Object)
        $expectedCompositionOwners = @(
            'tests/parallel.ps1::adapters\Get-PesterBatchJob'
            'tests/parallel.ps1::adapters\Get-PytestBatchJob'
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

    function Get-JsonlClientTopologyFailures {
        $failures = [System.Collections.Generic.List[string]]::new()
        $clientRoot = Join-Path $script:RepoRoot 'src/jsonl_engine-client'
        $expectedManifest = Join-Path $clientRoot 'jsonl_engine-client.psd1'
        $expectedModule = Join-Path $clientRoot 'jsonl_engine-client.psm1'
        foreach ($required in @($expectedManifest, $expectedModule)) {
            if (-not [System.IO.File]::Exists($required)) {
                $failures.Add("required JSONL engine client file missing: '$required'")
            }
        }

        $manifests = @(Get-ChildItem -LiteralPath $clientRoot -Recurse -Filter *.psd1 -File)
        if ($manifests.Count -ne 1 -or $manifests[0].FullName -ne $expectedManifest) {
            $failures.Add('JSONL engine client must have one canonical manifest')
        }
        $modules = @(Get-ChildItem -LiteralPath $clientRoot -Recurse -Filter *.psm1 -File)
        if ($modules.Count -ne 1 -or $modules[0].FullName -ne $expectedModule) {
            $failures.Add('JSONL engine client must have one canonical root module')
        }

        $retiredLogisticsBoundary = Join-Path $script:RepoRoot `
            ('src/logistics/engine-' + 'call.ps1')
        if ([System.IO.File]::Exists($retiredLogisticsBoundary)) {
            $failures.Add('retired logistics JSONL process boundary returned')
        }
        $facade = Join-Path $script:RepoRoot 'src/jsonl_engine/jso-shell.ps1'
        if (-not [System.IO.File]::Exists($facade)) {
            $failures.Add('temporary jso-shell compatibility importer is missing')
        }
        else {
            $facadeText = [System.IO.File]::ReadAllText($facade)
            if ($facadeText -notmatch 'Import-Module' -or
                $facadeText -match 'ProcessStartInfo|function\s+(?:Invoke|Get|Find|Test|New|Read)-Jsonl') {
                $failures.Add('jso-shell compatibility path must import, not reimplement, the client')
            }
        }

        $processOwners = [System.Collections.Generic.List[string]]::new()
        foreach ($file in @(Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot 'src') `
                -Recurse -File | Where-Object { $_.Extension -in @('.ps1', '.psm1') })) {
            $text = [System.IO.File]::ReadAllText($file.FullName)
            if ($text -match 'ProcessStartInfo' -and $text -match "jsonl_engine") {
                $processOwners.Add(
                    ([System.IO.Path]::GetRelativePath($script:RepoRoot, $file.FullName) -replace '\\', '/'))
            }
        }
        $expectedOwner = 'src/jsonl_engine-client/private/process.ps1'
        if ((@($processOwners | Sort-Object) -join "`n") -cne $expectedOwner) {
            $failures.Add("JSONL engine PowerShell process ownership drifted: $($processOwners -join ', ')")
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
    }

    It 'keeps batch planners, runners, and composition under their declared owners' {
        $batchFailures = @(Get-BatchTopologyFailures)
        $batchFailures.Count | Should -Be 0 -Because ($batchFailures -join [Environment]::NewLine)
    }

    It 'keeps one PowerShell owner for the JSONL engine process boundary' {
        $failures = @(Get-JsonlClientTopologyFailures)
        $failures.Count | Should -Be 0 -Because ($failures -join [Environment]::NewLine)
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
                $moduleIndexes = @(for ($i = 0; $i -lt $argsList.Count; $i++) {
                        if ($argsList[$i] -ceq '-m') { $i }
                    })
                if (($fileIndexes.Count + $moduleIndexes.Count) -ne 1) {
                    $failures.Add(
                        ".codex/config.toml:$name requires exactly one -File or -m target")
                    continue
                }
                if ($fileIndexes.Count -eq 1) {
                    if ($fileIndexes[0] -ge ($argsList.Count - 1)) {
                        $failures.Add(".codex/config.toml:$name has no -File target")
                        continue
                    }
                    $scriptArg = $argsList[$fileIndexes[0] + 1]
                    $scriptPath = if ([System.IO.Path]::IsPathRooted($scriptArg)) {
                        $scriptArg
                    }
                    else { Join-Path $script:RepoRoot $scriptArg }
                    if (-not [System.IO.File]::Exists($scriptPath)) {
                        $failures.Add(".codex/config.toml:$name script -> $scriptArg")
                    }
                    continue
                }

                if ($moduleIndexes[0] -ge ($argsList.Count - 1)) {
                    $failures.Add(".codex/config.toml:$name has no -m target")
                    continue
                }
                $module = $argsList[$moduleIndexes[0] + 1]
                $modulePath = $module.Replace('.', [System.IO.Path]::DirectorySeparatorChar)
                $moduleCandidates = @(
                    [System.IO.Path]::Combine($script:RepoRoot, 'src', $modulePath, '__main__.py')
                    [System.IO.Path]::Combine(
                        $script:RepoRoot, 'src', 'mcp-servers', $modulePath, '__main__.py')
                )
                if (-not ($moduleCandidates | Where-Object { [System.IO.File]::Exists($_) })) {
                    $failures.Add(".codex/config.toml:$name module -> $module")
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
