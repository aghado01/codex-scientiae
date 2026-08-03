#requires -Version 7.0
# Pending replacement JSONL primitives. This suite imports jsonl-v2.ps1 only; production stays on jsonl.ps1.

BeforeAll {
    . "$PSScriptRoot/../../src/shared/jsonl-v2.ps1"
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false, $true)
}

Describe 'jsonl-v2 primitive substrate' {
    Describe 'complete-file publication' {
        It 'writes deterministic UTF-8-no-BOM, LF-only JSONL and returns metadata' {
            $path = Join-Path $TestDrive 'glyphs.jsonl'
            $records = @(
                [ordered]@{ id = 1; text = 'field 𝔽 and ﬁ' },
                [ordered]@{ id = 2; nested = @{ value = '<&>' } }
            )

            $result = Write-Jsonl -Records $records -Path $path
            $result.Path | Should -Be ([System.IO.Path]::GetFullPath($path))
            $result.Records | Should -Be 2
            $bytes = [System.IO.File]::ReadAllBytes($path)
            ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) | Should -BeFalse
            [Array]::IndexOf($bytes, [byte]0x0D) | Should -Be -1
            @([System.IO.File]::ReadLines($path)).Count | Should -Be 2
            (Get-JsonlRecord -Path $path -At 0).text | Should -Be 'field 𝔽 and ﬁ'
        }

        It 'fails on an existing destination by default and replaces only when explicit' {
            $path = Join-Path $TestDrive 'collision.jsonl'
            Write-Jsonl -Records @(@{ n = 1 }) -Path $path | Out-Null
            $before = [System.IO.File]::ReadAllBytes($path)

            { Write-Jsonl -Records @(@{ n = 2 }) -Path $path } | Should -Throw '*already exists*'
            [Convert]::ToHexString([System.IO.File]::ReadAllBytes($path)) | Should -Be ([Convert]::ToHexString($before))

            Write-Jsonl -Records @(@{ n = 2 }) -Path $path -ExistingFile Replace | Out-Null
            (Get-JsonlRecord -Path $path -At 0).n | Should -Be 2
            @(Get-ChildItem -LiteralPath $TestDrive -Filter '*.tmp' -Force).Count | Should -Be 0
        }
    }

    Describe 'append targets' {
        It 'creates once, appends within the file, and supports an explicit resumed append' {
            $path = Join-Path $TestDrive 'trace.jsonl'
            Initialize-Jsonl -Path $path | Should -Be ([System.IO.Path]::GetFullPath($path))
            Add-JsonlRecord -Path $path -Record @{ n = 1 }
            Add-JsonlRecord -Path $path -Record @{ n = 2 }
            { Initialize-Jsonl -Path $path } | Should -Throw

            Initialize-Jsonl -Path $path -ExistingFile Append | Out-Null
            Add-JsonlRecord -Path $path -Record @{ n = 3 }
            @((Read-Jsonl $path) | ForEach-Object n) | Should -Be @(1, 2, 3)
        }

        It 'refuses to append across an incomplete record boundary' {
            $path = Join-Path $TestDrive 'partial.jsonl'
            [System.IO.File]::WriteAllText($path, '{"n":1}', $script:Utf8)
            { Initialize-Jsonl -Path $path -ExistingFile Append } | Should -Throw '*LF record boundary*'
        }

        It 'requires initialization before record append' {
            { Add-JsonlRecord -Path (Join-Path $TestDrive 'absent.jsonl') -Record @{ n = 1 } } |
                Should -Throw '*does not exist*'
        }

        It 'does not trust callers to preserve the record boundary after initialization' {
            $path = Join-Path $TestDrive 'changed-after-initialize.jsonl'
            Initialize-Jsonl -Path $path | Out-Null
            [System.IO.File]::WriteAllText($path, '{"n":1}', $script:Utf8)

            { Add-JsonlRecord -Path $path -Record @{ n = 2 } } | Should -Throw '*LF record boundary*'
        }
    }

    Describe 'read and validation policy' {
        It 'stops with a physical line number by default and makes Skip visible' {
            $path = Join-Path $TestDrive 'malformed.jsonl'
            [System.IO.File]::WriteAllText($path, "{`"n`":1}`nnot-json`n{`"n`":3}`n", $script:Utf8)

            { @(Read-Jsonl $path) } | Should -Throw '*line 2*'
            $warnings = @()
            $records = @(Read-Jsonl $path -MalformedAction Skip -WarningVariable warnings -WarningAction SilentlyContinue)
            @($records.n) | Should -Be @(1, 3)
            $warnings.Count | Should -Be 1
            [string]$warnings[0] | Should -Match 'line 2'

            $invalid = @(Test-Jsonl $path)
            $invalid.Count | Should -Be 1
            $invalid[0].Line | Should -Be 2
            $invalid[0].RecordIndex | Should -Be 1
        }

        It 'rejects a UTF-8 BOM as an invariant violation' {
            $path = Join-Path $TestDrive 'bom.jsonl'
            [System.IO.File]::WriteAllText($path, "{`"n`":1}`n", [System.Text.UTF8Encoding]::new($true))
            { @(Read-Jsonl $path) } | Should -Throw '*without BOM*'
            $diagnostics = @(Test-Jsonl $path)
            $diagnostics.Count | Should -Be 1
            $diagnostics[0].Line | Should -Be 0
        }
    }

    Describe 'canonical indexes and random access' {
        It 'uses {stem}.jidx, seeks multibyte records, and rejects silent index replacement' {
            $path = Join-Path $TestDrive 'records.jsonl'
            Write-Jsonl -Records @(
                [ordered]@{ id = 0; text = 'ASCII' },
                [ordered]@{ id = 1; text = '𝒞 and ﬁ' },
                [ordered]@{ id = 2; text = 'tail' }
            ) -Path $path | Out-Null

            Resolve-JsonlIndexPath $path | Should -Be (Join-Path $TestDrive 'records.jidx')
            $index = New-JsonlIndex -Path $path
            $index.Version | Should -Be 2
            $index.LineCount | Should -Be 3
            $index.IndexPath | Should -Be (Join-Path $TestDrive 'records.jidx')
            (Get-JsonlRecord -Path $path -At 1).text | Should -Be '𝒞 and ﬁ'
            (Get-JsonlRecordCount -Path $path) | Should -Be 3
            @((Get-JsonlHead -Path $path -Count 2) | ForEach-Object id) | Should -Be @(0, 1)
            @((Get-JsonlTail -Path $path -Count 2) | ForEach-Object id) | Should -Be @(1, 2)

            { New-JsonlIndex -Path $path } | Should -Throw '*already exists*'
            (New-JsonlIndex -Path $path -ExistingFile Replace).LineCount | Should -Be 3
        }

        It 'fails loudly when the indexed JSONL has changed' {
            $path = Join-Path $TestDrive 'stale.jsonl'
            Write-Jsonl -Records @(@{ id = 0 }) -Path $path | Out-Null
            New-JsonlIndex -Path $path | Out-Null
            Add-JsonlRecord -Path $path -Record @{ id = 1 }

            { Get-JsonlRecordCount -Path $path } | Should -Throw '*Stale JSONL index*'
            Get-JsonlRecordCount -Path $path -IgnoreIndex | Should -Be 2
        }
    }

    Describe 'active-file snapshots' {
        It 'drops only an incomplete tail, leaves the source untouched, and optionally builds the canonical index' {
            $source = Join-Path $TestDrive 'active.jsonl'
            $snapshot = Join-Path $TestDrive 'snapshots/active.jsonl'
            $raw = "{`"id`":1}`n{`"id`":2}`n{`"id`":"
            [System.IO.File]::WriteAllText($source, $raw, $script:Utf8)

            $result = New-JsonlSnapshot -SourcePath $source -DestinationPath $snapshot -BuildIndex
            $result.RecordCount | Should -Be 2
            $result.TailDropped | Should -BeTrue
            $result.IndexPath | Should -Be (Join-Path $TestDrive 'snapshots/active.jidx')
            [System.IO.File]::ReadAllText($source, $script:Utf8) | Should -Be $raw
            @((Read-Jsonl $snapshot) | ForEach-Object id) | Should -Be @(1, 2)
            (Get-JsonlRecord -Path $snapshot -At 1).id | Should -Be 2
        }

        It 'rejects malformed interior records and supports strict tail policy' {
            $middle = Join-Path $TestDrive 'middle.jsonl'
            [System.IO.File]::WriteAllText($middle, "{`"id`":1}`nbad`n{`"id`":2}`n", $script:Utf8)
            { New-JsonlSnapshot -SourcePath $middle -DestinationPath (Join-Path $TestDrive 'middle-copy.jsonl') } |
                Should -Throw '*line 2*'

            $tail = Join-Path $TestDrive 'strict-tail.jsonl'
            [System.IO.File]::WriteAllText($tail, "{`"id`":1}`n{", $script:Utf8)
            { New-JsonlSnapshot -SourcePath $tail -DestinationPath (Join-Path $TestDrive 'strict-copy.jsonl') -TailPolicy Stop } |
                Should -Throw '*tail*'
        }

        It 'treats parseable JSON without its terminating LF as an incomplete tail' {
            $source = Join-Path $TestDrive 'parseable-tail.jsonl'
            $snapshot = Join-Path $TestDrive 'parseable-tail-copy.jsonl'
            [System.IO.File]::WriteAllText($source, "{`"id`":1}`n{`"id`":2}", $script:Utf8)

            $result = New-JsonlSnapshot -SourcePath $source -DestinationPath $snapshot
            $result.RecordCount | Should -Be 1
            $result.TailDropped | Should -BeTrue
            @((Read-Jsonl $snapshot) | ForEach-Object id) | Should -Be @(1)

            { New-JsonlSnapshot -SourcePath $source -DestinationPath (Join-Path $TestDrive 'parseable-tail-strict.jsonl') -TailPolicy Stop } |
                Should -Throw '*tail*'
        }
    }
}
