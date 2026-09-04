#requires -Version 7.0
BeforeAll { . "$PSScriptRoot/../../src/logistics/file-bytes.ps1" }

Describe 'Get-ContentIdentity / Test-ContentIdentityFormat' {
    It 'hashes bytes to a lowercase sha256 identity' {
        Get-ContentIdentity -Bytes ([byte[]]@()) | Should -Be 'sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    }
    It 'accepts a well-formed identity and rejects malformed' {
        Test-ContentIdentityFormat 'sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' | Should -BeTrue
        Test-ContentIdentityFormat 'absent' | Should -BeFalse
        Test-ContentIdentityFormat 'sha256:ABCD' | Should -BeFalse
    }
}

Describe 'Read-BoundedFileBytes' {
    It 'reads a small file whole' {
        $p = Join-Path $TestDrive 'a.txt'; [System.IO.File]::WriteAllText($p, 'hello', [System.Text.UTF8Encoding]::new($false))
        (Read-BoundedFileBytes -Path $p -MaxBytes 1MB).Length | Should -Be 5
    }
    It 'throws when the file exceeds MaxBytes' {
        $p = Join-Path $TestDrive 'big.bin'; [System.IO.File]::WriteAllBytes($p, [byte[]]::new(11))
        { Read-BoundedFileBytes -Path $p -MaxBytes 10 } | Should -Throw '*exceeds*'
    }
    It 'throws on a missing file' {
        { Read-BoundedFileBytes -Path (Join-Path $TestDrive 'no.txt') -MaxBytes 1MB } | Should -Throw
    }
}
