#requires -Version 7.0
BeforeAll {
    . "$PSScriptRoot/../../src/infrastructure/authored-jsonl.ps1"
    function Write-Jsonl([string]$Name, [string]$Text) {
        $p = Join-Path $TestDrive $Name
        [System.IO.File]::WriteAllText($p, $Text, [System.Text.UTF8Encoding]::new($false)); return $p
    }
}

Describe 'Read-AuthoredJsonl' {
    It 'returns absent + no records when the file is missing' {
        $r = Read-AuthoredJsonl -Path (Join-Path $TestDrive 'nope.jsonl') -MaxBytes 1MB
        $r.identity | Should -Be 'absent'; $r.records | Should -HaveCount 0
    }
    It 'tolerates blanks, # and // comments, LF/CRLF, no final newline; keeps 1-based lines' {
        $p = Write-Jsonl 'a.jsonl' "  # c`r`n`n  // c2`n{`"op`":`"x`",`"n`":1}"
        $r = Read-AuthoredJsonl -Path $p -MaxBytes 1MB
        $r.records | Should -HaveCount 1
        $r.records[0].line | Should -Be 4
        (Get-JsonRequiredString -Fields $r.records[0].fields -Name 'op' -Display 'd') | Should -Be 'x'
    }
    It 'rejects a BOM' {
        $bom = Join-Path $TestDrive 'bom.jsonl'
        [System.IO.File]::WriteAllBytes($bom, ([byte[]]@(0xEF,0xBB,0xBF) + [System.Text.Encoding]::UTF8.GetBytes('{"a":1}')))
        { Read-AuthoredJsonl -Path $bom -MaxBytes 1MB } | Should -Throw '*without a BOM*'
    }
    It 'rejects a bare CR, a non-object line, and duplicate keys' {
        { Read-AuthoredJsonl -Path (Write-Jsonl 'cr.jsonl' "a`rb") -MaxBytes 1MB } | Should -Throw '*bare CR*'
        { Read-AuthoredJsonl -Path (Write-Jsonl 'arr.jsonl' '[1,2]') -MaxBytes 1MB } | Should -Throw '*must be one object*'
        { Read-AuthoredJsonl -Path (Write-Jsonl 'dup.jsonl' '{"A":1,"a":2}') -MaxBytes 1MB } | Should -Throw '*duplicate or case-colliding*'
    }
    It 'asserts an expected identity and reports drift' {
        $p = Write-Jsonl 'id.jsonl' '{"a":1}'
        $good = (Read-AuthoredJsonl -Path $p -MaxBytes 1MB).identity
        { Read-AuthoredJsonl -Path $p -MaxBytes 1MB -ExpectedIdentity $good } | Should -Not -Throw
        { Read-AuthoredJsonl -Path $p -MaxBytes 1MB -ExpectedIdentity 'sha256:0000000000000000000000000000000000000000000000000000000000000000' } | Should -Throw '*drift*'
    }
}

Describe 'field extractors' {
    It 'required string present / typed / missing; optional string; optional positive integer' {
        $p = Write-Jsonl 'f.jsonl' '{"s":"v","n":3}'
        $f = (Read-AuthoredJsonl -Path $p -MaxBytes 1MB).records[0].fields
        Get-JsonRequiredString -Fields $f -Name 's' -Display 'd' | Should -Be 'v'
        { Get-JsonRequiredString -Fields $f -Name 'n' -Display 'd' } | Should -Throw '*must be a JSON string*'
        { Get-JsonRequiredString -Fields $f -Name 'x' -Display 'd' } | Should -Throw "*missing 'x'*"
        Get-JsonOptionalString -Fields $f -Name 'x' -Display 'd' | Should -Be ''
        Get-JsonOptionalPositiveInteger -Fields $f -Name 'n' -Display 'd' | Should -Be 3
    }
}
