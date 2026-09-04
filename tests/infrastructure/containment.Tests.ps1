#requires -Version 7.0
BeforeAll {
    . "$PSScriptRoot/../../src/infrastructure/containment.ps1"
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path

    function New-FixtureRepository {
        <# A repository-shaped root with its artifacts tier present, as every real caller has. #>
        $repository = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path (Join-Path $repository 'artifacts') | Out-Null
        return (Resolve-Path -LiteralPath $repository).Path
    }
}

Describe 'Test-PortableLeaf' {
    It 'accepts a plain leaf' { Test-PortableLeaf '2403.08110v4' | Should -BeTrue }
    It 'accepts a dotted leaf that only starts like a reserved name' { Test-PortableLeaf 'CONsole.tex' | Should -BeTrue }
    It 'rejects empty' { Test-PortableLeaf '' | Should -BeFalse }
    It 'rejects dot and dotdot' { Test-PortableLeaf '.' | Should -BeFalse; Test-PortableLeaf '..' | Should -BeFalse }
    It 'rejects trailing dot or space' { Test-PortableLeaf 'a.' | Should -BeFalse; Test-PortableLeaf 'a ' | Should -BeFalse }
    It 'rejects invalid characters' { Test-PortableLeaf 'a/b' | Should -BeFalse; Test-PortableLeaf 'a:b' | Should -BeFalse; Test-PortableLeaf 'a*b' | Should -BeFalse }
    It 'rejects reserved device names case-insensitively' { Test-PortableLeaf 'CON' | Should -BeFalse; Test-PortableLeaf 'com1' | Should -BeFalse; Test-PortableLeaf 'LPT9.txt' | Should -BeFalse }
    It 'accepts a non-reserved lookalike' { Test-PortableLeaf 'COM10' | Should -BeTrue }
}

Describe 'Test-PathHasReparsePoint' {
    It 'is false for a real directory tree' {
        $d = Join-Path $TestDrive 'plain/child'; New-Item -ItemType Directory -Force -Path $d | Out-Null
        Test-PathHasReparsePoint -Path $d | Should -BeFalse
    }
    It 'is false for a path whose tail does not exist yet' {
        Test-PathHasReparsePoint -Path (Join-Path $TestDrive 'nope/notyet') | Should -BeFalse
    }
}

Describe 'Test-PathIsDescendant' {
    It 'is true only for a strict descendant' {
        $root = Join-Path $TestDrive 'root'
        Test-PathIsDescendant -Root $root -Path (Join-Path $root 'child/leaf') | Should -BeTrue
        Test-PathIsDescendant -Root $root -Path $root | Should -BeFalse
        Test-PathIsDescendant -Root $root -Path (Split-Path $root -Parent) | Should -BeFalse
        Test-PathIsDescendant -Root $root -Path (Join-Path $TestDrive 'root-sibling') | Should -BeFalse
    }
}

Describe 'Get-ArtifactsRoot' {
    It 'defaults to this repository and requires the tier to exist' {
        (Get-ArtifactsRoot) | Should -Be (Join-Path $script:RepositoryRoot 'artifacts')
        $repository = New-FixtureRepository
        (Get-ArtifactsRoot -RepositoryRoot $repository) | Should -Be (Join-Path $repository 'artifacts')
        $bare = Join-Path $TestDrive 'bare'
        New-Item -ItemType Directory -Force -Path $bare | Out-Null
        { Get-ArtifactsRoot -RepositoryRoot $bare } | Should -Throw '*artifacts root not found*'
        { Get-ArtifactsRoot -RepositoryRoot (Join-Path $TestDrive 'absent') } | Should -Throw '*repository root not found*'
    }
}

Describe 'New-TestSuiteRunDir' {
    BeforeEach {
        $script:Repository = New-FixtureRepository
        $script:Root = Join-Path $script:Repository 'artifacts'
    }

    It 'keys the run by suite under the tests process bucket' {
        $dir = New-TestSuiteRunDir -Suite 'TeXdig' -RepositoryRoot $script:Repository
        (Split-Path $dir -Parent) | Should -BeExactly (Join-Path $script:Root 'tests/TeXdig')
        Test-Path -LiteralPath $dir -PathType Container | Should -BeTrue
    }

    It 'names a suiteless batch mixed rather than claiming a suite' {
        foreach ($absent in @('', '   ')) {
            $dir = New-TestSuiteRunDir -Suite $absent -RepositoryRoot $script:Repository
            (Split-Path (Split-Path $dir -Parent) -Leaf) | Should -BeExactly 'mixed'
        }
    }

    It 'stamps YYYYMMDD_HHmmss in ISO order and carries no label' {
        $leaf = Split-Path (New-TestSuiteRunDir -Suite 'infrastructure' -RepositoryRoot $script:Repository) -Leaf
        # ISO date order is the whole point: lexical sort must be chronological.
        $leaf | Should -Match '^\d{8}_\d{6}$'
        $month = [int]$leaf.Substring(4, 2)
        $month | Should -BeGreaterOrEqual 1
        $month | Should -BeLessOrEqual 12
    }

    It 'appends a two-digit _NN sequence on collision, never a label' {
        $leaves = 1..3 | ForEach-Object {
            Split-Path (New-TestSuiteRunDir -Suite 'infrastructure' -RepositoryRoot $script:Repository) -Leaf
        }
        ($leaves | Sort-Object -Unique).Count | Should -Be 3
        foreach ($leaf in $leaves) {
            $leaf | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
            # No run directory may carry a descriptive suffix.
            $leaf | Should -Not -Match '[A-Za-z-]'
        }
    }

    It 'sorts chronologically as plain strings' {
        $first = Split-Path (New-TestSuiteRunDir -Suite 's' -RepositoryRoot $script:Repository) -Leaf
        $second = Split-Path (New-TestSuiteRunDir -Suite 's' -RepositoryRoot $script:Repository) -Leaf
        (@($second, $first) | Sort-Object)[0] | Should -BeExactly $first
    }
}

Describe 'New-ModuleRunDir' {
    BeforeEach {
        $script:Repository = New-FixtureRepository
        $script:Root = Join-Path $script:Repository 'artifacts'
    }

    It 'stamps directly under the module, with no superfluous runs segment' {
        $dir = New-ModuleRunDir -Module 'texdig' -Slug 'mini_article' -RepositoryRoot $script:Repository
        (Split-Path $dir -Leaf) | Should -BeExactly 'mini_article'
        $stampDir = Split-Path $dir -Parent
        (Split-Path $stampDir -Leaf) | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
        (Split-Path $stampDir -Parent) | Should -BeExactly (Join-Path $script:Root 'texdig')
    }

    It 'omits the slug leaf when none is given' {
        $dir = New-ModuleRunDir -Module 'texdig' -RepositoryRoot $script:Repository
        (Split-Path $dir -Leaf) | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
        (Split-Path (Split-Path $dir -Parent) -Leaf) | Should -BeExactly 'texdig'
    }

    It 'refuses a run dir with no module' {
        { New-ModuleRunDir -Module '' -Slug 's' -RepositoryRoot $script:Repository } | Should -Throw
    }

    It 'refuses a repository without an artifacts tier rather than inventing one' {
        $bare = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $bare | Out-Null
        { New-ModuleRunDir -Module 'texdig' -Slug 's' -RepositoryRoot $bare } | Should -Throw '*artifacts root not found*'
        Test-Path -LiteralPath (Join-Path $bare 'artifacts') | Should -BeFalse
    }

    It 'shares one stamp and one collision sequence with the test tier' {
        $moduleStamp = Split-Path (
            New-ModuleRunDir -Module 'm' -RepositoryRoot $script:Repository) -Leaf
        $testStamp = Split-Path (
            New-TestSuiteRunDir -Suite 's' -RepositoryRoot $script:Repository) -Leaf
        $moduleStamp.Substring(0, 8) | Should -BeExactly $testStamp.Substring(0, 8)
        foreach ($stamp in @($moduleStamp, $testStamp)) {
            $stamp | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
        }
    }
}

Describe 'Get-ModuleRunDirs' {
    It 'reads the same layout New-ModuleRunDir writes, newest first' {
        $repository = New-FixtureRepository
        $moduleRoot = Join-Path $repository 'artifacts/texdig'
        foreach ($stamp in @('20260101_010101', '20260301_030303', '20260201_020202')) {
            New-Item -ItemType Directory -Force -Path (Join-Path $moduleRoot "$stamp/slugA") | Out-Null
        }
        $found = @(Get-ModuleRunDirs -Module 'texdig' -Slug 'slugA' -RepositoryRoot $repository)
        $found.Count | Should -Be 3
        (Split-Path (Split-Path $found[0] -Parent) -Leaf) | Should -BeExactly '20260301_030303'
        (Split-Path (Split-Path $found[-1] -Parent) -Leaf) | Should -BeExactly '20260101_010101'
    }

    It 'skips stamps that do not carry the requested slug' {
        $repository = New-FixtureRepository
        $moduleRoot = Join-Path $repository 'artifacts/texdig'
        New-Item -ItemType Directory -Force -Path (Join-Path $moduleRoot '20260101_010101/slugA') | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $moduleRoot '20260202_020202/slugB') | Out-Null
        @(Get-ModuleRunDirs -Module 'texdig' -Slug 'slugA' -RepositoryRoot $repository).Count | Should -Be 1
    }

    It 'is empty, not null, for a module that never ran' {
        $repository = New-FixtureRepository
        $found = Get-ModuleRunDirs -Module 'never' -Slug 'x' -RepositoryRoot $repository
        @($found).Count | Should -Be 0
    }
}
