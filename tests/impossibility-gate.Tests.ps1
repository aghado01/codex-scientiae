#requires -Version 7.0
# Part B — structural impossibility gate on retype / split / merge. Reject cases (synthetic), legitimate
# mutations (incl. fragmented-formula merge), and a check that the apply content-gate is unchanged.

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

Describe 'Get-StructuralImpossibility — reuses the shared table (structural subset only)' {
    It 'flags unbalanced_delimiters on a would-be formula' {
        $imp = Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = '\left( x' })
        $imp.reason | Should -Be 'unbalanced_delimiters'
        $imp.diagnostic | Should -Match 'lr=1'
    }
    It 'flags prose_in_formula when retyped content reads as prose' {
        $imp = Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = 'the lazy brown fox jumps over many fences' })
        $imp.reason | Should -Be 'prose_in_formula'
    }
    It 'flags alignment_outside_env on bare ampersand in a formula' {
        $imp = Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = 'a & b' })
        $imp.reason | Should -Be 'alignment_outside_env'
    }
    It 'does NOT flag content-only signatures (ligature) — those are the content-repair phase' {
        Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = ('x ' + $FB2) }) | Should -BeNullOrEmpty
    }
    It 'returns $null for a balanced formula' {
        Get-StructuralImpossibility ([pscustomobject]@{ type = 'formula'; content = '$$ x = y $$' }) | Should -BeNullOrEmpty
    }
}

Describe 'retype_chunk — rejects impossible results; valid retypes pass' {
    It 'rejects retype to formula when delimiters do not balance (with seam diagnostic)' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = '\left( x'; fidelity = 'faithful' }
        )
        $r = Set-ChunkType -ChunksPath $fx.cp -Id 0 -NewType 'formula'
        $r.ok | Should -BeFalse
        $r.id | Should -Be 0
        $r.reason | Should -Be 'unbalanced_delimiters'
        $r.diagnostic | Should -Match 'lr=1'
        Count-Lines $fx.cp | Should -Be 1
        (Read-ChunkContent $fx.cp 0) | Should -Be '\left( x'
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
        $rec = (Get-Content -LiteralPath $fx.cp -Raw).Trim() | ConvertFrom-Json
        $rec.type | Should -Be 'formula'
    }
}

Describe 'merge_chunks — rejects unbalanced joins; fragmented-formula merge passes' {
    It 'rejects a merge that would leave delimiters unbalanced' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = '\left('; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'x'; fidelity = 'suspect' }
        )
        $r = Merge-Chunks -ChunksPath $fx.cp -Ids @(0, 1)
        $r.ok | Should -BeFalse
        $r.ids | Should -Be @(0, 1)
        $r.reason | Should -Be 'unbalanced_delimiters'
        Count-Lines $fx.cp | Should -Be 2
    }
    It 'accepts a fragmented-formula merge when the join balances (Track 2 dependency)' {
        $fx = New-GateFixture @(
            [pscustomobject]@{ id = 0; type = 'formula'; page = 1; content = 'x ='; fidelity = 'suspect' }
            [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = '\left( \frac{1}{2}'; fidelity = 'suspect' }
            [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = ('+ y \right) ' + $FB2); fidelity = 'suspect' }
        )
        $r = Merge-Chunks -ChunksPath $fx.cp -Ids @(0, 1, 2)
        $r.ok | Should -BeTrue
        Count-Lines $fx.cp | Should -Be 1
        $merged = Read-ChunkContent $fx.cp 0
        (Get-LatexBalance $merged).full | Should -BeTrue
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
        $r = Add-RepairProposal -ChunksPath $fx.cp -Id 0 -Content '\left( x'   # still broken
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
