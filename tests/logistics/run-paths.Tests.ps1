#requires -Version 7.0
BeforeAll { . "$PSScriptRoot/../../src/logistics/run-paths.ps1" }

Describe 'New-TestRunDir' {
    BeforeEach {
        $script:Root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    }

    It 'mints under the test-runs tier, not the module tier' {
        $dir = New-TestRunDir -ArtifactsRoot $script:Root
        (Split-Path $dir -Parent) | Should -BeExactly (Join-Path $script:Root 'test-runs')
        Test-Path -LiteralPath $dir -PathType Container | Should -BeTrue
    }

    It 'stamps YYYYMMDD_HHmmss in ISO order and carries no label' {
        $leaf = Split-Path (New-TestRunDir -ArtifactsRoot $script:Root) -Leaf
        # ISO date order is the whole point: lexical sort must be chronological.
        $leaf | Should -Match '^\d{8}_\d{6}$'
        $month = [int]$leaf.Substring(4, 2)
        $month | Should -BeGreaterOrEqual 1
        $month | Should -BeLessOrEqual 12
    }

    It 'appends a two-digit _NN sequence on collision, never a label' {
        $a = Split-Path (New-TestRunDir -ArtifactsRoot $script:Root) -Leaf
        $b = Split-Path (New-TestRunDir -ArtifactsRoot $script:Root) -Leaf
        $c = Split-Path (New-TestRunDir -ArtifactsRoot $script:Root) -Leaf
        @($a, $b, $c) | Should -Not -Contain $null
        ($a, $b, $c | Sort-Object -Unique).Count | Should -Be 3
        # Same-second runs share the stamp and differ only by the sequence.
        foreach ($leaf in @($b, $c)) {
            if ($leaf -ne $a) { $leaf | Should -Match '^\d{8}_\d{6}(_\d{2})?$' }
        }
        # Whatever the second boundary did, no run dir may carry a descriptive suffix.
        foreach ($leaf in @($a, $b, $c)) {
            $leaf | Should -Not -Match '[A-Za-z-]'
        }
    }

    It 'sorts chronologically as plain strings' {
        $first = Split-Path (New-TestRunDir -ArtifactsRoot $script:Root) -Leaf
        $second = Split-Path (New-TestRunDir -ArtifactsRoot $script:Root) -Leaf
        (@($second, $first) | Sort-Object)[0] | Should -BeExactly $first
    }
}

Describe 'New-ModuleRunDir' {
    It 'keeps the module tier distinct from the test-run tier' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $dir = New-ModuleRunDir -Module 'texdig' -Slug 'mini_article' -ArtifactsRoot $root
        $dir | Should -BeLike (Join-Path $root 'texdig/runs/*')
        (Split-Path $dir -Leaf) | Should -BeExactly 'mini_article'
        (Split-Path (Split-Path $dir -Parent) -Leaf) | Should -Match '^\d{8}_\d{6}'
    }

    It 'shares the stamp format with the test-run tier' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $moduleStamp = Split-Path (Split-Path (
            New-ModuleRunDir -Module 'm' -Slug 's' -ArtifactsRoot $root) -Parent) -Leaf
        $testStamp = Split-Path (New-TestRunDir -ArtifactsRoot $root) -Leaf
        $moduleStamp.Substring(0, 8) | Should -BeExactly $testStamp.Substring(0, 8)
    }
}
