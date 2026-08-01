#requires -Version 7.0

BeforeAll {
    $script:RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
}

Describe 'centralized Node dependency topology' {
    It 'tracks no materialized dependency payloads' {
        $tracked = @(& git -C $script:RepoRoot ls-files -- '*node_modules*')
        $LASTEXITCODE | Should -Be 0
        $tracked.Count | Should -Be 0 -Because ($tracked -join [Environment]::NewLine)
    }

    It 'keeps the sole dependency declarations under brewery/node and no tools namespace' {
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'brewery/node/package.json') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'brewery/node/package-lock.json') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'tools') | Should -BeFalse -Because 'operation code and dependency payloads have explicit owners elsewhere'
    }

    It 'keeps Node workers colocated with their owning operations' {
        foreach ($worker in 'src/audits/md-lint/md-lint.js',
                            'src/pdf-raster/render.mjs',
                            'src/tikz-render/tikz-svg.js') {
            Test-Path -LiteralPath (Join-Path $script:RepoRoot $worker) | Should -BeTrue -Because "$worker is part of its operation, not a freestanding tool"
        }
    }
}
