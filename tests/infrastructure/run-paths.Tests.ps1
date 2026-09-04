#requires -Version 7.0
BeforeAll { . "$PSScriptRoot/../../src/logistics/run-paths.ps1" }

Describe 'New-TestSuiteRunDir' {
    BeforeEach {
        $script:Root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    }

    It 'keys the run by suite under the tests process bucket' {
        $dir = New-TestSuiteRunDir -Suite 'TeXdig' -ArtifactsRoot $script:Root
        (Split-Path $dir -Parent) | Should -BeExactly (Join-Path $script:Root 'tests/TeXdig')
        Test-Path -LiteralPath $dir -PathType Container | Should -BeTrue
    }

    It 'names a suiteless batch mixed rather than claiming a suite' {
        foreach ($absent in @('', '   ')) {
            $dir = New-TestSuiteRunDir -Suite $absent -ArtifactsRoot $script:Root
            (Split-Path (Split-Path $dir -Parent) -Leaf) | Should -BeExactly 'mixed'
        }
    }

    It 'stamps YYYYMMDD_HHmmss in ISO order and carries no label' {
        $leaf = Split-Path (New-TestSuiteRunDir -Suite 'logistics' -ArtifactsRoot $script:Root) -Leaf
        # ISO date order is the whole point: lexical sort must be chronological.
        $leaf | Should -Match '^\d{8}_\d{6}$'
        $month = [int]$leaf.Substring(4, 2)
        $month | Should -BeGreaterOrEqual 1
        $month | Should -BeLessOrEqual 12
    }

    It 'appends a two-digit _NN sequence on collision, never a label' {
        $leaves = 1..3 | ForEach-Object {
            Split-Path (New-TestSuiteRunDir -Suite 'logistics' -ArtifactsRoot $script:Root) -Leaf
        }
        ($leaves | Sort-Object -Unique).Count | Should -Be 3
        foreach ($leaf in $leaves) {
            $leaf | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
            # No run directory may carry a descriptive suffix.
            $leaf | Should -Not -Match '[A-Za-z-]'
        }
    }

    It 'sorts chronologically as plain strings' {
        $first = Split-Path (New-TestSuiteRunDir -Suite 's' -ArtifactsRoot $script:Root) -Leaf
        $second = Split-Path (New-TestSuiteRunDir -Suite 's' -ArtifactsRoot $script:Root) -Leaf
        (@($second, $first) | Sort-Object)[0] | Should -BeExactly $first
    }
}

Describe 'New-ModuleRunDir' {
    BeforeEach {
        $script:Root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    }

    It 'stamps directly under the module, with no superfluous runs segment' {
        $dir = New-ModuleRunDir -Module 'texdig' -Slug 'mini_article' -ArtifactsRoot $script:Root
        (Split-Path $dir -Leaf) | Should -BeExactly 'mini_article'
        $stampDir = Split-Path $dir -Parent
        (Split-Path $stampDir -Leaf) | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
        (Split-Path $stampDir -Parent) | Should -BeExactly (Join-Path $script:Root 'texdig')
    }

    It 'omits the slug leaf when none is given' {
        $dir = New-ModuleRunDir -Module 'texdig' -Slug '' -ArtifactsRoot $script:Root
        (Split-Path $dir -Leaf) | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
        (Split-Path (Split-Path $dir -Parent) -Leaf) | Should -BeExactly 'texdig'
    }

    It 'refuses a run dir with no module' {
        { New-ModuleRunDir -Module '' -Slug 's' -ArtifactsRoot $script:Root } | Should -Throw
    }

    It 'shares one stamp and one collision sequence with the test tier' {
        $moduleStamp = Split-Path (
            New-ModuleRunDir -Module 'm' -Slug '' -ArtifactsRoot $script:Root) -Leaf
        $testStamp = Split-Path (
            New-TestSuiteRunDir -Suite 's' -ArtifactsRoot $script:Root) -Leaf
        $moduleStamp.Substring(0, 8) | Should -BeExactly $testStamp.Substring(0, 8)
        foreach ($stamp in @($moduleStamp, $testStamp)) {
            $stamp | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
        }
    }
}

Describe 'Get-ModuleRunDirs' {
    It 'reads the same layout New-ModuleRunDir writes, newest first' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $moduleRoot = Join-Path $root 'texdig'
        foreach ($stamp in @('20260101_010101', '20260301_030303', '20260201_020202')) {
            New-Item -ItemType Directory -Force -Path (Join-Path $moduleRoot "$stamp/slugA") | Out-Null
        }
        $found = @(Get-ModuleRunDirs -Module 'texdig' -Slug 'slugA' -ArtifactsRoot $root)
        $found.Count | Should -Be 3
        (Split-Path (Split-Path $found[0] -Parent) -Leaf) | Should -BeExactly '20260301_030303'
        (Split-Path (Split-Path $found[-1] -Parent) -Leaf) | Should -BeExactly '20260101_010101'
    }

    It 'skips stamps that do not carry the requested slug' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $moduleRoot = Join-Path $root 'texdig'
        New-Item -ItemType Directory -Force -Path (Join-Path $moduleRoot '20260101_010101/slugA') | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $moduleRoot '20260202_020202/slugB') | Out-Null
        @(Get-ModuleRunDirs -Module 'texdig' -Slug 'slugA' -ArtifactsRoot $root).Count | Should -Be 1
    }
}
