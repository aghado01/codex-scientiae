#requires -Version 7.0
BeforeAll {
    . "$PSScriptRoot/../../src/procurement/scripts/probe-ledger.ps1"
}

Describe 'ProbeLedger lifecycle and recording' {
    It 'initializes empty with count 0 and non-null empty results array' {
        $ledger = New-ProbeLedger
        $ledger.Count() | Should -Be 0
        $results = $ledger.Results()
        $null -ne $results | Should -BeTrue
        $results.Count | Should -Be 0
    }

    It 'records a passed probe without detail' {
        $ledger = New-ProbeLedger
        $ledger.Record('gzip-readable', 'passed')
        $ledger.Count() | Should -Be 1
        $ledger.Has('gzip-readable') | Should -BeTrue
        $res = $ledger.Results()
        $res.Count | Should -Be 1
        $res[0].name | Should -Be 'gzip-readable'
        $res[0].outcome | Should -Be 'passed'
    }

    It 'records not-applicable and waived probes when reason is provided' {
        $ledger = New-ProbeLedger
        $ledger.Record('archive-members-confined', 'not-applicable', @{ reason = 'single file' })
        $ledger.Record('literal-inputs-resolved', 'waived', @{ reason = 'missing macro'; count = 2 })
        $ledger.Count() | Should -Be 2
        $ledger.Has('archive-members-confined') | Should -BeTrue
        $ledger.Has('literal-inputs-resolved') | Should -BeTrue

        $results = $ledger.Results()
        $results[0].outcome | Should -Be 'not-applicable'
        $results[0].reason | Should -Be 'single file'
        $results[1].outcome | Should -Be 'waived'
        $results[1].reason | Should -Be 'missing macro'
        $results[1].count | Should -Be 2
    }

    It 'rejects null or whitespace probe name' {
        $ledger = New-ProbeLedger
        { $ledger.Record($null, 'passed') } | Should -Throw 'probe name is required'
        { $ledger.Record('   ', 'passed') } | Should -Throw 'probe name is required'
    }

    It 'rejects unknown outcomes' {
        $ledger = New-ProbeLedger
        { $ledger.Record('probe-1', 'unknown-outcome') } | Should -Throw "*unknown probe outcome 'unknown-outcome'*"
    }

    It 'rejects non-passing outcomes without a reason' {
        $ledger = New-ProbeLedger
        { $ledger.Record('probe-na', 'not-applicable') } | Should -Throw "*without a 'reason'*"
        { $ledger.Record('probe-waived', 'waived', @{ detail = 'no reason key' }) } | Should -Throw "*without a 'reason'*"
    }

    It 'rejects duplicate probe recordings' {
        $ledger = New-ProbeLedger
        $ledger.Record('probe-1', 'passed')
        { $ledger.Record('probe-1', 'passed') } | Should -Throw "*already recorded*"
    }

    It 'rejects reserved detail keys' {
        $ledger = New-ProbeLedger
        { $ledger.Record('probe-1', 'passed', @{ name = 'override' }) } | Should -Throw "*cannot redefine reserved key 'name'*"
        { $ledger.Record('probe-2', 'passed', @{ outcome = 'override' }) } | Should -Throw "*cannot redefine reserved key 'outcome'*"
    }
}

Describe 'ProbeLedger AssertCoverage' {
    It 'passes when declared probes match recorded probes exactly' {
        $ledger = New-ProbeLedger
        $ledger.Record('probe-a', 'passed')
        $ledger.Record('probe-b', 'not-applicable', @{ reason = 'n/a' })
        { $ledger.AssertCoverage(@('probe-a', 'probe-b')) } | Should -Not -Throw
    }

    It 'throws when declared probe is missing' {
        $ledger = New-ProbeLedger
        $ledger.Record('probe-a', 'passed')
        { $ledger.AssertCoverage(@('probe-a', 'probe-b')) } | Should -Throw '*missing a declared probe: probe-b*'
    }

    It 'throws when recorded probe is undeclared' {
        $ledger = New-ProbeLedger
        $ledger.Record('probe-a', 'passed')
        $ledger.Record('probe-b', 'passed')
        { $ledger.AssertCoverage(@('probe-a')) } | Should -Throw '*recorded an undeclared probe: probe-b*'
    }
}
