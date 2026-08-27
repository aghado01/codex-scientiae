#requires -Version 7.0
BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:TestsRoot = Join-Path $script:RepositoryRoot 'tests'
    . (Join-Path $script:TestsRoot 'artifact-boundary.ps1')
}

Describe 'Resolve-TestSuiteName' -Tag 'Infrastructure' {
    It 'names the suite from a selected owner directory' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @('tests/logistics') | Should -BeExactly 'logistics'
    }

    It 'names the same suite from a file inside that owner' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @('tests/TeXdig/WalkProjection.Tests.ps1') | Should -BeExactly 'TeXdig'
    }

    It 'accepts absolute and repository-relative paths alike' {
        $absolute = Join-Path $script:TestsRoot 'jsonl_engine'
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @($absolute, 'tests/jsonl_engine') | Should -BeExactly 'jsonl_engine'
    }

    It 'is mixed when the batch spans more than one owner' {
        Resolve-TestSuiteName -TestsRoot $script:TestsRoot -RepositoryRoot $script:RepositoryRoot `
            -SelectedPath @('tests/TeXdig', 'tests/logistics') | Should -BeExactly 'mixed'
    }

    It 'is mixed for the tests root itself, a bare file in it, or anything outside' {
        foreach ($selection in @('tests', 'tests/parallel.ps1', 'src/TeXdig')) {
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

Describe 'Set-TestHarnessTempEnvironment' -Tag 'Infrastructure' {
    BeforeAll {
        $script:ArtifactRoot = Get-TestHarnessArtifactRoot -RepositoryRoot $script:RepositoryRoot
    }
    BeforeEach {
        $script:Saved = @{}
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            $script:Saved[$name] = [System.Environment]::GetEnvironmentVariable($name, 'Process')
        }
        # A run root inside the boundary, but not the ambient temp the harness already handed us.
        $script:RunDir = Join-Path $script:ArtifactRoot (
            'tests/_convention-probe/{0}' -f [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $script:RunDir | Out-Null
    }
    AfterEach {
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            if ($null -eq $script:Saved[$name]) {
                Remove-Item -LiteralPath "env:$name" -ErrorAction SilentlyContinue
            } else {
                Set-Item -LiteralPath "env:$name" -Value $script:Saved[$name]
            }
        }
        Remove-Item -LiteralPath $script:RunDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'owns the temp tree when the ambient value is outside the artifact boundary' {
        # Not GetTempPath(): the harness has already pointed that inside the boundary, so it would
        # be treated as a deliberate conformant setting and correctly left alone.
        $outside = $script:RepositoryRoot
        (Test-TestHarnessDescendantPath -Root $script:ArtifactRoot -Path $outside) |
            Should -BeFalse -Because 'the fixture must actually be outside the boundary'
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            Set-Item -LiteralPath "env:$name" -Value $outside
        }
        $result = Set-TestHarnessTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $expected = Join-Path $script:RunDir 'temp'
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath($expected))
        Test-Path -LiteralPath $expected -PathType Container | Should -BeTrue
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            [System.Environment]::GetEnvironmentVariable($name, 'Process') |
                Should -BeExactly $result
        }
    }

    It 'owns the temp tree when a variable is unset' {
        Set-Item -LiteralPath 'env:TEMP' -Value $script:ArtifactRoot
        Set-Item -LiteralPath 'env:TMP' -Value $script:ArtifactRoot
        Remove-Item -LiteralPath 'env:TMPDIR' -ErrorAction SilentlyContinue
        $result = Set-TestHarnessTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath((Join-Path $script:RunDir 'temp')))
    }

    It 'leaves a deliberate conformant setting alone' {
        $deliberate = Join-Path $script:RunDir 'chosen'
        New-Item -ItemType Directory -Force -Path $deliberate | Out-Null
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            Set-Item -LiteralPath "env:$name" -Value $deliberate
        }
        $result = Set-TestHarnessTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath($deliberate))
        Test-Path -LiteralPath (Join-Path $script:RunDir 'temp') | Should -BeFalse
    }

    It 'takes over when the three variables disagree, conformant or not' {
        # Three directories inside the boundary is not one job-local directory, which is what
        # conftest.py and Assert-TestHarnessTempEnvironment both require.
        $i = 0
        foreach ($name in @('TEMP', 'TMP', 'TMPDIR')) {
            $each = Join-Path $script:RunDir "each$i"
            New-Item -ItemType Directory -Force -Path $each | Out-Null
            Set-Item -LiteralPath "env:$name" -Value $each
            $i++
        }
        $result = Set-TestHarnessTempEnvironment -RunDirectory $script:RunDir `
            -RepositoryRoot $script:RepositoryRoot
        $result | Should -BeExactly ([System.IO.Path]::GetFullPath((Join-Path $script:RunDir 'temp')))
    }
}
