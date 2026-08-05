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

    It 'keeps configured Codex MCP commands and script arguments resolvable' {
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
                    $candidate = if ([System.IO.Path]::IsPathRooted($command)) {
                        $command
                    }
                    else {
                        Join-Path $script:RepoRoot $command
                    }
                    if (-not [System.IO.File]::Exists($candidate) -and
                        -not (Get-Command $command -ErrorAction SilentlyContinue)) {
                        $failures.Add(".codex/config.toml:$name command -> $command")
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
}
