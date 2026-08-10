#requires -Version 7.0

BeforeAll {
    . "$PSScriptRoot/../../src/logistics/crawl.ps1"
}

Describe 'Invoke-Crawl reparse semantics' {
    It 'skips reparse directories by default' {
        $root = Join-Path $TestDrive ("skip-" + [guid]::NewGuid().ToString('N'))
        $keep = Join-Path $root 'keep'
        $hidden = Join-Path $TestDrive ("hidden-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $keep, $hidden -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $keep 'a.txt') -Value 'visible' -Encoding utf8
        Set-Content -LiteralPath (Join-Path $hidden 'secret.txt') -Value 'hidden' -Encoding utf8
        $link = Join-Path $root 'alias'
        $linkType = if ([System.OperatingSystem]::IsWindows()) { 'Junction' } else { 'SymbolicLink' }
        New-Item -ItemType $linkType -Path $link -Target $hidden | Out-Null

        $hits = @(Invoke-Crawl -Root $root -Patterns '**/*.txt')
        $hits.Count | Should -Be 1
        $hits[0] | Should -BeLike '*keep*a.txt'
    }

    It 'throws on reparse directories when -FailOnReparse is set' {
        $root = Join-Path $TestDrive ("fail-" + [guid]::NewGuid().ToString('N'))
        $keep = Join-Path $root 'keep'
        $hidden = Join-Path $TestDrive ("hidden-fail-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $keep, $hidden -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $keep 'a.txt') -Value 'visible' -Encoding utf8
        $link = Join-Path $root 'alias'
        $linkType = if ([System.OperatingSystem]::IsWindows()) { 'Junction' } else { 'SymbolicLink' }
        New-Item -ItemType $linkType -Path $link -Target $hidden | Out-Null

        { Invoke-Crawl -Root $root -Patterns '**/*' -FailOnReparse } |
            Should -Throw '*reparse point*'
    }
}
