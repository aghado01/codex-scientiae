#requires -Version 7.0
# Managed-store automation remains additive and is not imported by production code.

BeforeAll {
    . "$PSScriptRoot/../../src/shared/jsonl-store-v2.ps1"
}

Describe 'managed JSONL store automation' {
    It 'defines application-bound policies without creating store metadata sidecars' {
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        $policy.PSObject.TypeNames | Should -Contain 'Jsonl.StorePolicy'
        $policy.Kind | Should -Be 'inventory'
        $policy.KeyPointer | Should -Be '/document_parent'
        $policy.KeyMode | Should -Be 'ScopedRelativePath'
        $policy.UniqueKey | Should -BeTrue
        $policy.KeyComparison | Should -Be 'OrdinalIgnoreCase'
        $policy.CanonicalSort[0].Pointer | Should -Be '/document_parent'
        $policy.CanonicalSort[0].Descending | Should -BeFalse

        { New-JsonlStorePolicy -Kind demo -SchemaPath (Join-Path $TestDrive 'schema.json') } |
            Should -Throw '*requires SchemaValidator*'
    }

    It 'creates an inventory store in canonical path order and maintains one index' {
        $path = Join-Path $TestDrive 'inventory-create.jsonl'
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        $created = Create-JsonlStore -Path $path -Policy $policy -BuildIndex -Records @(
            [ordered]@{ document_parent = 'topic/zeta'; title = 'z' },
            [ordered]@{ document_parent = 'topic/alpha'; title = 'a' },
            [ordered]@{ document_parent = 'topic/middle'; title = 'm' }
        )

        $created.StoreKind | Should -Be 'inventory'
        $created.IndexStatus | Should -Be 'Current'
        @((Read-Jsonl $path) | ForEach-Object document_parent) |
            Should -Be @('topic/alpha', 'topic/middle', 'topic/zeta')
        @(Get-ChildItem -LiteralPath $TestDrive -File | Where-Object Extension -eq '.jidx').Count | Should -Be 1
    }

    It 'rejects noncanonical scoped inventory paths before publication' {
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        $badPaths = @(
            '/rooted', 'C:/rooted', 'topic\paper', 'topic//paper', 'topic/./paper', 'topic/../paper',
            "topic/cafe$([char]0x0301)", ''
        )
        for ($i = 0; $i -lt $badPaths.Count; $i++) {
            $path = Join-Path $TestDrive "bad-path-$i.jsonl"
            { Create-JsonlStore -Path $path -Policy $policy -Records @(@{ document_parent = $badPaths[$i] }) } |
                Should -Throw
            Test-Path -LiteralPath $path | Should -BeFalse
        }
    }

    It 'uses dot as the canonical key for one document directly at the store scope root' {
        $path = Join-Path $TestDrive 'inventory-scope-root.jsonl'
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        Create-JsonlStore -Path $path -Policy $policy -Records @(
            @{ document_parent = '.'; title = 'direct document' }
        ) | Out-Null
        (Get-JsonlRecord -Path $path -At 0).document_parent | Should -Be '.'

        { Add-JsonlStoreRecords -Path $path -Policy $policy -Records @(
            @{ document_parent = '.'; title = 'second direct document' }
        ) } | Should -Throw '*Duplicate key*'
        Get-JsonlRecordCount -Path $path | Should -Be 1
    }

    It 'rejects duplicate and case-colliding inventory keys before publication' {
        $path = Join-Path $TestDrive 'duplicate-create.jsonl'
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        { Create-JsonlStore -Path $path -Policy $policy -Records @(
            @{ document_parent = 'topic/Paper' },
            @{ document_parent = 'topic/paper' }
        ) } | Should -Throw '*Duplicate key*'
        Test-Path -LiteralPath $path | Should -BeFalse
    }

    It 'merges an inventory batch, resorts once, and refreshes its index' {
        $path = Join-Path $TestDrive 'inventory-add.jsonl'
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        Create-JsonlStore -Path $path -Policy $policy -BuildIndex -Records @(
            @{ document_parent = 'topic/zeta'; title = 'z' }
        ) | Out-Null

        $result = Add-JsonlStoreRecords -Path $path -Policy $policy -FlushToDisk -Records @(
            @{ document_parent = 'topic/middle'; title = 'm' },
            @{ document_parent = 'topic/alpha'; title = 'a' }
        )

        $result.AffectedRecords | Should -Be 2
        $result.RecordCount | Should -Be 3
        $result.IndexStatus | Should -Be 'Current'
        @((Read-Jsonl $path) | ForEach-Object document_parent) |
            Should -Be @('topic/alpha', 'topic/middle', 'topic/zeta')
    }

    It 'can apply a store policy to validate and canonically sort an existing draft store' {
        $path = Join-Path $TestDrive 'inventory-policy-sort.jsonl'
        Write-Jsonl -Path $path -Records @(
            @{ document_parent = 'topic/zeta'; title = 'z' },
            @{ document_parent = 'topic/alpha'; title = 'a' }
        ) | Out-Null
        New-JsonlIndex -Path $path | Out-Null
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'

        $result = Sort-JsonlStore -Path $path -Policy $policy
        $result.Changed | Should -BeTrue
        $result.StoreKind | Should -Be 'inventory'
        $result.IndexStatus | Should -Be 'Current'
        @((Read-Jsonl $path) | ForEach-Object document_parent) |
            Should -Be @('topic/alpha', 'topic/zeta')
    }

    It 'makes duplicate merge behavior explicit and leaves rejected stores untouched' {
        $path = Join-Path $TestDrive 'inventory-duplicate-add.jsonl'
        $policy = New-JsonlInventoryStorePolicy -KeyPointer '/document_parent'
        Create-JsonlStore -Path $path -Policy $policy -BuildIndex -Records @(
            [ordered]@{ document_parent = 'topic/paper'; title = 'old' }
        ) | Out-Null
        $indexPath = Resolve-JsonlIndexPath $path
        $beforeStore = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($path))
        $beforeIndex = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($indexPath))

        { Add-JsonlStoreRecords -Path $path -Policy $policy -Records @(
            @{ document_parent = 'topic/PAPER'; title = 'rejected' }
        ) } | Should -Throw '*Duplicate key*'
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($path)) | Should -BeExactly $beforeStore
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($indexPath)) | Should -BeExactly $beforeIndex

        $kept = Add-JsonlStoreRecords -Path $path -Policy $policy -DuplicateKeyAction KeepExisting -Records @(
            @{ document_parent = 'topic/PAPER'; title = 'ignored' }
        )
        $kept.Changed | Should -BeFalse
        (Get-JsonlRecord -Path $path -At 0).title | Should -Be 'old'

        $replaced = Add-JsonlStoreRecords -Path $path -Policy $policy -DuplicateKeyAction Replace -Records @(
            @{ document_parent = 'topic/PAPER'; title = 'new' }
        )
        $replaced.AffectedRecords | Should -Be 1
        $replaced.RecordCount | Should -Be 1
        $replaced.IndexStatus | Should -Be 'Current'
        (Get-JsonlRecord -Path $path -At 0).title | Should -Be 'new'
    }

    It 'runs an application validator before mutation and preserves content and index on failure' {
        $path = Join-Path $TestDrive 'validated.jsonl'
        $validator = {
            param($element, $schemaPath, $context)
            if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) { return $false }
            foreach ($property in $element.EnumerateObject()) {
                if ($property.NameEquals('title') -and $property.Value.ValueKind -eq [System.Text.Json.JsonValueKind]::String) {
                    return $true
                }
            }
            return $false
        }
        $policy = New-JsonlStorePolicy -Kind demo -KeyPointer '/id' -KeyMode Scalar -UniqueKey `
            -CanonicalSort @(@{ Pointer = '/id' }) -SchemaValidator $validator
        Create-JsonlStore -Path $path -Policy $policy -BuildIndex -Records @(@{ id = 'a'; title = 'valid' }) | Out-Null
        $indexPath = Resolve-JsonlIndexPath $path
        $beforeStore = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($path))
        $beforeIndex = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($indexPath))

        { Add-JsonlStoreRecords -Path $path -Policy $policy -Records @(@{ id = 'b' }) } |
            Should -Throw '*rejected record*'
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($path)) | Should -BeExactly $beforeStore
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($indexPath)) | Should -BeExactly $beforeIndex
    }

    It 'names creation and reflexively maintains an explicitly requested index' {
        $path = Join-Path $TestDrive 'created.jsonl'
        $created = Create-JsonlStore -Path $path -Records @(@{ id = 'a' }, @{ id = 'b' }) -BuildIndex
        $created.Operation | Should -Be 'Create'
        $created.RecordCount | Should -Be 2
        $created.IndexStatus | Should -Be 'Current'
        { Create-JsonlStore -Path $path -Records @() } | Should -Throw '*already exists*'

        $replaced = Create-JsonlStore -Path $path -Records @(@{ id = 'c' }) -ExistingFile Replace
        $replaced.RecordCount | Should -Be 1
        $replaced.IndexStatus | Should -Be 'Current'
        (Get-JsonlRecord -Path $path -At 0).id | Should -Be 'c'
    }

    It 'appends and refreshes an existing index without requiring the caller to repeat index policy' {
        $path = Join-Path $TestDrive 'append.jsonl'
        Create-JsonlStore -Path $path -Records @(@{ id = 1 }) -BuildIndex | Out-Null
        $result = Add-JsonlStoreRecords -Path $path -Records @(@{ id = 2 }, @{ id = 3 })
        $result.Operation | Should -Be 'Append'
        $result.AffectedRecords | Should -Be 2
        $result.RecordCount | Should -Be 3
        $result.IndexStatus | Should -Be 'Current'
        @((Read-Jsonl $path) | ForEach-Object id) | Should -Be @(1, 2, 3)
    }

    It 'removes by condition or ordinal while preserving untouched serialized rows' {
        $path = Join-Path $TestDrive 'remove.jsonl'
        $lines = @(
            '{"id":"a","escaped":"\u0061"}',
            '{"id":"b","escaped":"b"}',
            '{"id":"c","escaped":"c"}'
        )
        Write-JsonlLines -Path $path -Lines $lines | Out-Null
        New-JsonlIndex -Path $path | Out-Null

        $removed = Remove-JsonlStoreRecords -Path $path -Condition @(@{ Pointer = '/id'; Equals = 'b' })
        $removed.AffectedRecords | Should -Be 1
        $removed.IndexStatus | Should -Be 'Current'
        @(Read-Jsonl $path -AsRawText) | Should -Be @($lines[0], $lines[2])

        $removed = Remove-JsonlStoreRecords -Path $path -At 0
        $removed.AffectedRecords | Should -Be 1
        @(Read-Jsonl $path -AsRawText) | Should -Be @($lines[2])
        { Remove-JsonlStoreRecords -Path $path -At 4 } | Should -Throw '*out of range*'
    }

    It 'sorts numerically, keeps equal keys stable, and leaves missing keys last' {
        $path = Join-Path $TestDrive 'sort.jsonl'
        Create-JsonlStore -Path $path -Records @(
            [ordered]@{ id = 'ten'; rank = 10 },
            [ordered]@{ id = 'two-a'; rank = 2 },
            [ordered]@{ id = 'missing' },
            [ordered]@{ id = 'two-b'; rank = 2 }
        ) -BuildIndex | Out-Null

        $sorted = Sort-JsonlStore -Path $path -By '/rank'
        $sorted.Changed | Should -BeTrue
        $sorted.IndexStatus | Should -Be 'Current'
        @((Read-Jsonl $path) | ForEach-Object id) | Should -Be @('two-a', 'two-b', 'ten', 'missing')
    }

    It 'subtracts one store from another by an exact scalar key' {
        $path = Join-Path $TestDrive 'minuend.jsonl'
        $difference = Join-Path $TestDrive 'difference.jsonl'
        Create-JsonlStore -Path $path -Records @(@{ id = 'a' }, @{ id = 'aa' }, @{ id = 'b' }) -BuildIndex | Out-Null
        Create-JsonlStore -Path $difference -Records @(@{ id = 'a' }, @{ id = 'b' }) | Out-Null

        $result = Subtract-JsonlStore -Path $path -DifferencePath $difference -KeyPointer '/id'
        $result.AffectedRecords | Should -Be 2
        $result.IndexStatus | Should -Be 'Current'
        @((Read-Jsonl $path) | ForEach-Object id) | Should -Be @('aa')
    }

    It 'makes a committed mutation plus failed derived refresh explicit' {
        $path = Join-Path $TestDrive 'refresh-failure.jsonl'
        Create-JsonlStore -Path $path -Records @(@{ id = 1 }) -BuildIndex | Out-Null
        $indexPath = Resolve-JsonlIndexPath $path
        $held = [System.IO.FileStream]::new(
            $indexPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read
        )
        try {
            { Add-JsonlStoreRecords -Path $path -Records @(@{ id = 2 }) } |
                Should -Throw '*content was committed*derived index refresh failed*'
        } finally { $held.Dispose() }

        Get-JsonlRecordCount -Path $path -IgnoreIndex | Should -Be 2
        (Get-JsonlStoreInfo -Path $path).IndexStatus | Should -Be 'Stale'
    }
}
