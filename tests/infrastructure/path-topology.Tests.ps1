#requires -Version 7.0

BeforeAll {
    $script:RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent

    function Get-StaticDotSourceFailures {
        $dotSourceRx = [regex]'(?:^|\s)\.\s+'
        $directRx = [regex]'\$PSScriptRoot[\\/](?<rel>[^"'']+?\.ps1)'
        $joinRx = [regex]'Join-Path\s+\$PSScriptRoot\s+[''"](?<rel>[^''"]+?\.ps1)[''"]'
        $failures = [System.Collections.Generic.List[string]]::new()

        $files = @(Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot 'src'), (Join-Path $script:RepoRoot 'tests') `
                    -Recurse -File -Filter *.ps1)
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

    function Get-LiteralSrcPathFailures {
        $srcPathRx = [regex]'src[\\/][A-Za-z0-9_.\\/-]+\.ps1'
        $failures = [System.Collections.Generic.List[string]]::new()
        $activeFiles = @(
            Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot 'src'), (Join-Path $script:RepoRoot 'tests') `
                -Recurse -File |
                Where-Object { $_.Extension -in '.ps1', '.psm1', '.json', '.md', '.js', '.cmd' }
            Get-Item -LiteralPath (Join-Path $script:RepoRoot '.mcp.json'),
                                  (Join-Path $script:RepoRoot '.codex/config.toml'),
                                  (Join-Path $script:RepoRoot '.agents/codex-membrane.cmd'),
                                  (Join-Path $script:RepoRoot 'README.md'),
                                  (Join-Path $script:RepoRoot 'CLAUDE.md'),
                                  (Join-Path $script:RepoRoot 'MEMBRANE.md'),
                                  (Join-Path $script:RepoRoot 'AGENTS.md'),
                                  (Join-Path $script:RepoRoot '.legacy/docs/STANDARDS.md'),
                                  (Join-Path $script:RepoRoot '.legacy/docs/WORKFLOW.md'),
                                  (Join-Path $script:RepoRoot '.legacy/docs/CHECKLIST.md'),
                                  (Join-Path $script:RepoRoot 'tools/md-lint/md-lint.js'),
                                  (Join-Path $script:RepoRoot 'tools/pdf-raster/README.md')
        )
        foreach ($file in $activeFiles) {
            $lineNumber = 0
            foreach ($line in [System.IO.File]::ReadLines($file.FullName)) {
                $lineNumber++
                foreach ($match in $srcPathRx.Matches($line)) {
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

    It 'keeps active literal src/*.ps1 references pointed at existing files' {
        $failures = @(Get-LiteralSrcPathFailures)
        $failures.Count | Should -Be 0 -Because ($failures -join [Environment]::NewLine)
    }

    It 'keeps every configured MCP and agent launcher script resolvable' {
        $failures = [System.Collections.Generic.List[string]]::new()
        $mcp = Get-Content -LiteralPath (Join-Path $script:RepoRoot '.mcp.json') -Raw | ConvertFrom-Json
        foreach ($server in $mcp.mcpServers.PSObject.Properties) {
            if (-not [System.IO.File]::Exists([string]$server.Value.command) -and
                -not (Get-Command ([string]$server.Value.command) -ErrorAction SilentlyContinue)) {
                $failures.Add(".mcp.json:$($server.Name) command -> $($server.Value.command)")
            }
            $scriptPath = @($server.Value.args | Where-Object { $_ -match '\.ps1$' }) | Select-Object -First 1
            if (-not $scriptPath -or -not [System.IO.File]::Exists($scriptPath)) {
                $failures.Add(".mcp.json:$($server.Name) -> $scriptPath")
            }
        }

        $toml = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot '.codex/config.toml'))
        foreach ($match in [regex]::Matches($toml, '"(?<path>[A-Za-z]:/[^"\r\n]+\.ps1)"')) {
            if (-not [System.IO.File]::Exists($match.Groups['path'].Value)) {
                $failures.Add(".codex/config.toml -> $($match.Groups['path'].Value)")
            }
        }
        foreach ($match in [regex]::Matches($toml, '(?m)^\s*command\s*=\s*"(?<path>[^"\r\n]+)"')) {
            $command = $match.Groups['path'].Value
            if (-not [System.IO.File]::Exists($command) -and
                -not (Get-Command $command -ErrorAction SilentlyContinue)) {
                $failures.Add(".codex/config.toml command -> $command")
            }
        }

        $launcher = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot '.agents/codex-membrane.cmd'))
        $serverMatch = [regex]::Match($launcher, 'SERVER=(?<path>[^"\r\n]+)')
        if (-not $serverMatch.Success -or -not [System.IO.File]::Exists($serverMatch.Groups['path'].Value)) {
            $failures.Add(".agents/codex-membrane.cmd -> $($serverMatch.Groups['path'].Value)")
        }

        $failures.Count | Should -Be 0 -Because ($failures -join [Environment]::NewLine)
    }
}
