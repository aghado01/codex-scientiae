#requires -Version 7.0
BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:TestsRoot = Join-Path $script:RepositoryRoot 'tests'
    . (Join-Path $script:RepositoryRoot 'src/logistics/containment.ps1')
    . (Join-Path $script:RepositoryRoot 'src/logistics/assert-codex-temp.ps1')
    . (Join-Path $script:RepositoryRoot 'tests/suite-name.ps1')
}

Describe 'Resolve-TestSuiteName' -Tag 'Infrastructure' {
    It 'names the suite from a selected owner directory' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @('tests/infrastructure') | Should -BeExactly 'infrastructure'
    }

    It 'names the same suite from a file inside that owner' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @('tests/infrastructure/run-paths.Tests.ps1') | Should -BeExactly 'infrastructure'
    }

    It 'accepts absolute and repository-relative paths alike' {
        $absolute = Join-Path $script:TestsRoot 'jsonl_engine'
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @($absolute, 'tests/jsonl_engine') | Should -BeExactly 'jsonl_engine'
    }

    It 'is mixed when the batch spans more than one owner' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @('tests/procurement', 'tests/infrastructure') | Should -BeExactly 'mixed'
    }

    It 'is mixed for the tests root itself, a bare file in it, or anything outside' {
        foreach ($selection in @('tests', 'tests/parallel.ps1', 'src/logistics')) {
            Resolve-TestSuiteName -TestsRoot $script:TestsRoot `
                -RepositoryRoot $script:RepositoryRoot -SelectedPath @($selection) |
                Should -BeExactly 'mixed' -Because "'$selection' is not owner-scoped"
        }
    }

    It 'is mixed rather than throwing on an empty selection' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @() | Should -BeExactly 'mixed'
    }
}

Describe 'Set-CodexTempEnvironment' -Tag 'Infrastructure' {
    BeforeAll {
        $script:ArtifactRoot = Get-RepositoryArtifactsRoot -RepositoryRoot $script:RepositoryRoot
    }
    BeforeEach {
        $script:Saved = @{}
        foreach ($name in @('CODEX_TEMP', 'TEMP', 'TMP', 'TMPDIR')) {
            $script:Saved[$name] = [System.Environment]::GetEnvironmentVariable($name, 'Process')
        }
        $script:RunDir = Join-Path $script:ArtifactRoot (
            'tests/_convention-probe/{0}' -f [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $script:RunDir | Out-Null
        Remove-Item -LiteralPath 'env:CODEX_TEMP' -ErrorAction SilentlyContinue
    }
    AfterEach {
        foreach ($name in @('CODEX_TEMP', 'TEMP', 'TMP', 'TMPDIR')) {
            if ($null -eq $script:Saved[$name]) {
                Remove-Item -LiteralPath "env:$name" -ErrorAction SilentlyContinue
            } else {
                Set-Item -LiteralPath "env:$name" -Value $script:Saved[$name]
            }
        }
        Remove-Item -LiteralPath $script:RunDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'sets CODEX_TEMP under the run directory and does not mutate ambient TEMP' {
        $outside = $script:RepositoryRoot
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            Set-Item -LiteralPath "env:$name" -Value $outside
        }
        $result = Set-CodexTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $expected = Join-Path $script:RunDir 'temp'
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath($expected))
        Test-Path -LiteralPath $expected -PathType Container | Should -BeTrue
        $env:CODEX_TEMP | Should -BeExactly $result
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            [System.Environment]::GetEnvironmentVariable($name, 'Process') |
                Should -BeExactly $outside
        }
    }

    It 'owns the tree when CODEX_TEMP is unset' {
        $result = Set-CodexTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath((Join-Path $script:RunDir 'temp')))
    }

    It 'leaves a deliberate CODEX_TEMP under artifacts alone' {
        $deliberate = Join-Path $script:RunDir 'chosen'
        New-Item -ItemType Directory -Force -Path $deliberate | Out-Null
        Set-Item -LiteralPath 'env:CODEX_TEMP' -Value $deliberate
        $result = Set-CodexTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath($deliberate))
        Test-Path -LiteralPath (Join-Path $script:RunDir 'temp') | Should -BeFalse
    }

    It 'takes over when CODEX_TEMP is outside artifacts' {
        Set-Item -LiteralPath 'env:CODEX_TEMP' -Value $script:RepositoryRoot
        $result = Set-CodexTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath((Join-Path $script:RunDir 'temp')))
        $env:CODEX_TEMP | Should -BeExactly $result
    }

    It 'refuses a RunDirectory outside artifacts and does not create it' {
        $outside = Join-Path $script:RepositoryRoot (
            '_harness-outside-run-{0}' -f [guid]::NewGuid().ToString('N'))
        { Set-CodexTempEnvironment -RunDirectory $outside `
            -RepositoryRoot $script:RepositoryRoot } |
            Should -Throw '*RunDirectory must be a descendant of RepositoryRoot/artifacts*'
        Test-Path -LiteralPath $outside | Should -BeFalse
    }

    It 'does not resolve a relative RunDirectory against the process working directory' {
        $cwd = (Resolve-Path (Join-Path $script:RepositoryRoot '..')).Path
        $leaf = '_codex-harness-cwd-probe-{0}' -f [guid]::NewGuid().ToString('N')
        $leaked = Join-Path $cwd $leaf
        $previous = Get-Location
        try {
            Set-Location -LiteralPath $cwd
            { Set-CodexTempEnvironment -RunDirectory $leaf `
                -RepositoryRoot $script:RepositoryRoot } |
                Should -Throw '*RunDirectory must be a descendant of RepositoryRoot/artifacts*'
            Test-Path -LiteralPath $leaked | Should -BeFalse
        }
        finally {
            Set-Location -LiteralPath $previous.Path
            if (Test-Path -LiteralPath $leaked) {
                Remove-Item -LiteralPath $leaked -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Describe 'Assert-CodexTempEnvironment' -Tag 'Infrastructure' {
    BeforeAll {
        $script:ArtifactRoot = Get-RepositoryArtifactsRoot -RepositoryRoot $script:RepositoryRoot
    }
    BeforeEach {
        $script:Saved = @{}
        foreach ($name in @('CODEX_TEMP', 'TEMP', 'TMP', 'TMPDIR')) {
            $script:Saved[$name] = [System.Environment]::GetEnvironmentVariable($name, 'Process')
        }
        $script:RunDir = Join-Path $script:ArtifactRoot (
            'tests/_convention-probe/{0}' -f [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $script:RunDir | Out-Null
    }
    AfterEach {
        foreach ($name in @('CODEX_TEMP', 'TEMP', 'TMP', 'TMPDIR')) {
            if ($null -eq $script:Saved[$name]) {
                Remove-Item -LiteralPath "env:$name" -ErrorAction SilentlyContinue
            } else {
                Set-Item -LiteralPath "env:$name" -Value $script:Saved[$name]
            }
        }
        Remove-Item -LiteralPath $script:RunDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'rejects a missing CODEX_TEMP even when ambient TEMP is under artifacts' {
        Remove-Item -LiteralPath 'env:CODEX_TEMP' -ErrorAction SilentlyContinue
        Set-Item -LiteralPath 'env:TEMP' -Value $script:ArtifactRoot
        Set-Item -LiteralPath 'env:TMP' -Value $script:ArtifactRoot
        Set-Item -LiteralPath 'env:TMPDIR' -Value $script:ArtifactRoot
        { Assert-CodexTempEnvironment -RepositoryRoot $script:RepositoryRoot } |
            Should -Throw '*CODEX_TEMP must be an absolute path under RepositoryRoot/artifacts*'
    }

    It 'projects CODEX_TEMP onto TEMP TMP and TMPDIR for this process' {
        $owned = Join-Path $script:RunDir 'temp'
        New-Item -ItemType Directory -Force -Path $owned | Out-Null
        Set-Item -LiteralPath 'env:CODEX_TEMP' -Value $owned
        Set-Item -LiteralPath 'env:TEMP' -Value $script:RepositoryRoot
        $result = Assert-CodexTempEnvironment -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath($owned))
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            [System.Environment]::GetEnvironmentVariable($name, 'Process') |
                Should -BeExactly $result
        }
    }
}

Describe 'Resolve-ArtifactRunDirectory' -Tag 'Infrastructure' {
    BeforeAll {
        $script:ArtifactRoot = Get-RepositoryArtifactsRoot -RepositoryRoot $script:RepositoryRoot
    }

    It 'resolves a repository-relative artifacts path regardless of working directory' {
        $run = Join-Path $script:ArtifactRoot (
            'tests/_convention-probe/{0}' -f [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $run | Out-Null
        $relative = [System.IO.Path]::GetRelativePath($script:RepositoryRoot, $run)
        $cwd = (Resolve-Path (Join-Path $script:RepositoryRoot '..')).Path
        $previous = Get-Location
        try {
            Set-Location -LiteralPath $cwd
            $resolved = Resolve-ArtifactRunDirectory -RunDirectory $relative `
                -RepositoryRoot $script:RepositoryRoot
            $resolved | Should -BeExactly (Resolve-Path -LiteralPath $run).Path
        }
        finally {
            Set-Location -LiteralPath $previous.Path
            Remove-Item -LiteralPath $run -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'rejects the retired test-runs name at the repository root' {
        { Resolve-ArtifactRunDirectory -RunDirectory 'test-runs/leak-probe' `
            -RepositoryRoot $script:RepositoryRoot } |
            Should -Throw '*RunDirectory must be a descendant of RepositoryRoot/artifacts*'
        Test-Path -LiteralPath (Join-Path $script:RepositoryRoot 'test-runs') | Should -BeFalse
    }
}
