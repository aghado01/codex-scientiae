#requires -Version 7.0

BeforeAll {
    $script:RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
    $gitCommand = Get-Command git -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    $script:GitPath = if ($null -ne $gitCommand) { $gitCommand.Source } else { $null }
}

Describe 'centralized Node dependency topology' {
    It 'tracks no materialized dependency payloads' {
        if ([string]::IsNullOrWhiteSpace($script:GitPath)) {
            Set-ItResult -Skipped -Because `
                'Git is required only to inspect tracked Node dependency payloads'
            return
        }

        $tracked = @(& $script:GitPath -C $script:RepoRoot ls-files -- '*node_modules*')
        $LASTEXITCODE | Should -Be 0
        $tracked.Count | Should -Be 0 -Because ($tracked -join [Environment]::NewLine)
    }

    It 'keeps the sole dependency declarations under brewery/node and no tools namespace' {
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'brewery/node/package.json') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'brewery/node/package-lock.json') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'tools') | Should -BeFalse -Because 'operation code and dependency payloads have explicit owners elsewhere'
    }

    It 'keeps Node workers colocated with their owning operations' {
        foreach ($worker in 'src/node_utils/md-lint/md-lint.js',
                            'src/node_utils/math-render/katex-check.js',
                            'src/node_utils/pdf-raster/render.mjs',
                            'src/node_utils/tikz-render/tikz-svg.js') {
            Test-Path -LiteralPath (Join-Path $script:RepoRoot $worker) | Should -BeTrue -Because "$worker is part of its operation, not a freestanding tool"
        }
    }
}
