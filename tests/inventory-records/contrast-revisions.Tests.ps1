#requires -Version 7.5
Describe 'Contrast engine revision provenance' -Skip:([string]::IsNullOrWhiteSpace($env:LATEXAI_ROOT)) {
    BeforeAll {
        $script:EngineRoot=(Resolve-Path $env:LATEXAI_ROOT).Path
        . (Join-Path $script:EngineRoot 'scripts/latexai-common.ps1')
        . (Join-Path $script:EngineRoot 'scripts/gauntlet-contrasts.ps1')
        Import-Module (Join-Path $PSScriptRoot '../../src/inventory-records/inventory-records.psm1') -Force
    }
    It 'records the commit of an actual checkout root' {
        $record=Get-LaTeXAIEngineRevision $script:EngineRoot (Join-Path $TestDrive 'checkout.patch')
        $record.Commit | Should -Match '^[0-9a-f]{40}$'
        $expected=(& git -C $script:EngineRoot rev-parse HEAD).Trim()
        $record.Commit | Should -Be $expected
        (Get-InventoryFileReference $record.Patch.path).sha256 | Should -Be $record.Patch.sha256
    }
    It 'does not attribute a nested snapshot to its parent checkout' {
        $nested=Join-Path $script:EngineRoot 'lib'
        $record=Get-LaTeXAIEngineRevision $nested (Join-Path $TestDrive 'nested.patch')
        $record.Commit | Should -Be 'unversioned'
        $record.Dirty.Count | Should -Be 0
        (Get-Item $record.Patch.path).Length | Should -Be 0
    }
}
