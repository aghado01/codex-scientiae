#requires -Version 7.0
BeforeAll { . "$PSScriptRoot/../../src/logistics/portable-path.ps1" }

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
