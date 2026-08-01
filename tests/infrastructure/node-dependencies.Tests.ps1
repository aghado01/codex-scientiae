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

    It 'keeps the sole dependency declarations under brewery/node' {
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'brewery/node/package.json') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'brewery/node/package-lock.json') | Should -BeTrue
        foreach ($legacy in 'tools/md-lint/package.json', 'tools/md-lint/package-lock.json',
                            'tools/pdf-raster/package.json', 'tools/pdf-raster/package-lock.json',
                            'tools/tikz-render/package.json', 'tools/tikz-render/package-lock.json') {
            Test-Path -LiteralPath (Join-Path $script:RepoRoot $legacy) | Should -BeFalse -Because "$legacy would create a second dependency authority"
        }
    }
}
