#requires -Version 7.0
# Part B — structural impossibility gate on retype / split / merge. Geometry rejections, merge
# balance-worsening guard (not full-balance), split orphan guard, partial-balance hotspot merge.

BeforeAll {
    . "$PSScriptRoot/../src/restructure.ps1"
    . "$PSScriptRoot/../src/serving.ps1"

    $FB2 = [char]0xFB02   # ﬂ ligature (U+FB02)

    $script:Roots = [System.Collections.Generic.List[string]]::new()
    function New-GateFixture([object[]]$Chunks, [string]$Paper = 'p') {
        $root    = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-gate-" + [guid]::NewGuid().ToString('N'))
        $scratch = Join-Path $root "$Paper/.scratch"
        New-Item -ItemType Directory -Force -Path $scratch | Out-Null
        $cp = Join-Path $scratch "$Paper.chunks.jsonl"
        [void](Write-JsonlStage -Records $Chunks -OutputPath $cp -Stage 'fidelity')
        $script:Roots.Add($root)
        return [pscustomobject]@{ root = $root; cp = $cp; paper = $Paper }
    }

    function Read-ChunkContent([string]$Cp, [int]$Id) {
        $line = [System.IO.File]::ReadLines($Cp) | Select-Object -Index $Id
        return [string](($line | ConvertFrom-Json).content)
    }

    function Count-Lines([string]$Cp) {
        @([System.IO.File]::ReadLines($Cp) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count
    }
}

AfterAll {
    foreach ($r in $script:Roots) { if (Test-Path -LiteralPath $r) { Remove-Item -LiteralPath $r -Recurse -Force -ErrorAction SilentlyContinue } }
}

Describe 'Get-StructuralImpossibility — geometry only (mis-label / alignment)' {
    It 'does NOT flag unbalanced delimiters — that is fixable corruption, not geometry' {
        Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = '\left( x' }) | Should -BeNullOrEmpty
    }
    It 'flags prose_in_formula when retyped content reads as prose' {
        $imp = Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = 'the lazy brown fox jumps over many fences' })
        $imp.reason | Should -Be 'prose_in_formula'
    }
    It 'flags alignment_outside_env on bare ampersand in a formula' {
        $imp = Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = 'a & b' })
        $imp.reason | Should -Be 'alignment_outside_env'
    }
    It 'does NOT flag content-only signatures (ligature)' {
        Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = ('x ' + $FB2) }) | Should -BeNullOrEmpty
    }
    It 'returns $null for a balanced formula' {
        Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = '$$ x = y $$' }) | Should -BeNullOrEmpty
    }
}

Describe 'Test-ChunkUnbalanced — reuses the shared table row (split gate)' {
    It 'flags unbalanced delimiters on a would-be formula' {
        Test-ChunkUnbalanced ([pscustomobject]@{ type = 'formula'; content = '\left( x' }) | Should -BeTrue
        Get-UnbalancedDiagnostic ([pscustomobject]@{ type = 'formula'; content = '\left( x' }) | Should -Match 'lr=1'
    }
}

Describe 'retype_chunk — rejects geometry impossibilities; unbalanced content is allowed' {
    It 'allows retype to formula when delimiters are not yet balanced (content path fixes after)' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = '\left( x'; fidelity = 'faithful' }
        )
        $r = Set-ChunkType -ChunksPath $fx.cp -Id 0 -NewType 'formula'
        $r.ok | Should -BeTrue
        $r.to | Should -Be 'formula'
        $rec = (Get-Content -LiteralPath $fx.cp -Raw).Trim() | ConvertFrom-Json
        $rec.type | Should -Be 'formula'
        $rec.fidelity | Should -Be 'suspect'
    }
    It 'rejects retype to formula when content reads as prose' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = 'many words of natural language here'; fidelity = 'faithful' }
        )
        $r = Set-ChunkType -ChunksPath $fx.cp -Id 0 -NewType 'formula'
        $r.ok | Should -BeFalse
        $r.reason | Should -Be 'prose_in_formula'
    }
    It 'accepts a valid retype and re-grades (unchanged happy path)' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = '$$ x = 1 $$'; fidelity = 'faithful' }
        )
        $r = Set-ChunkType -ChunksPath $fx.cp -Id 0 -NewType 'formula'
        $r.ok | Should -BeTrue
        $r.to | Should -Be 'formula'
    }
}

Describe 'merge_chunks — balance-worsening guard; fragmented-formula merges pass' {
    It 'Test-MergeBalanceWorsens is false when join improves (Group-MathHotspots promotion path)' {
        Test-MergeBalanceWorsens @('\left( \left( a', 'b \right)') ('\left( \left( a b \right)') | Should -BeFalse
    }
    It 'allows a same-residual merge (not worsening) so Track 2 can merge-then-fix' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = '\left('; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'x'; fidelity = 'suspect' }
        )
        $r = Merge-Chunks -ChunksPath $fx.cp -Ids @(0, 1)
        $r.ok | Should -BeTrue
        Count-Lines $fx.cp | Should -Be 1
        (Get-LatexBalance (Read-ChunkContent $fx.cp 0)).lr | Should -Be 1
    }
    It 'accepts a partial-balance fragmented-formula merge (join improves but is still unbalanced)' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = '\left( \left( a'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'b \right)'; fidelity = 'suspect' }
        )
        $r = Merge-Chunks -ChunksPath $fx.cp -Ids @(0, 1)
        $r.ok | Should -BeTrue
        Count-Lines $fx.cp | Should -Be 1
        $merged = Read-ChunkContent $fx.cp 0
        (Get-LatexBalance $merged).full | Should -BeFalse
        (Get-LatexBalance $merged).lr | Should -Be 1
    }
    It 'accepts a fully-balanced fragmented-formula merge (Track 2 dependency)' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = 'x ='; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = '\left( \frac{1}{2}'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = ('+ y \right) ' + $FB2); fidelity = 'suspect' }
        )
        $r = Merge-Chunks -ChunksPath $fx.cp -Ids @(0, 1, 2)
        $r.ok | Should -BeTrue
        (Get-LatexBalance (Read-ChunkContent $fx.cp 0)).full | Should -BeTrue
    }
    It 'rejects merge producing alignment_outside_env' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = 'a'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = '& b'; fidelity = 'suspect' }
        )
        $r = Merge-Chunks -ChunksPath $fx.cp -Ids @(0, 1)
        $r.ok | Should -BeFalse
        $r.reason | Should -Be 'alignment_outside_env'
    }
}

Describe 'split_chunk — rejects delimiter orphaning across the cut' {
    It 'rejects a split that orphans \left..\right partners' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = 'x = \left( a + b \right)'; fidelity = 'faithful' }
        )
        $r = Split-Chunk -ChunksPath $fx.cp -Id 0 -Before '+ b'
        $r.ok | Should -BeFalse
        $r.reason | Should -Be 'unbalanced_delimiters'
        Count-Lines $fx.cp | Should -Be 1
    }
    It 'accepts a valid prose split at a unique marker' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = 'First sentence. Second sentence.'; fidelity = 'faithful' }
        )
        $r = Split-Chunk -ChunksPath $fx.cp -Id 0 -Before 'Second'
        $r.ok | Should -BeTrue
        Count-Lines $fx.cp | Should -Be 2
    }
}

Describe 'apply content-gate — unchanged by Part B (no regression)' {
    It 'Add-RepairProposal still rejects content corruption on staged repairs' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = '\left( x'; fidelity = 'suspect'; corruption_type = 'unbalanced_delimiters' }
        )
        $r = Add-RepairProposal -ChunksPath $fx.cp -Id 0 -Content '\left( x'
        $r.accepted | Should -BeFalse
        $r.reason | Should -Match 'unbalanced_delimiters'
        $r.diagnostic | Should -Match 'lr=1'
    }
    It 'Add-RepairProposal accepts a clean repair' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = '\left( x'; fidelity = 'suspect' }
        )
        $r = Add-RepairProposal -ChunksPath $fx.cp -Id 0 -Content '\left( x \right)'
        $r.accepted | Should -BeTrue
    }
}
