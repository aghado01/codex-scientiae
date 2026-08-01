#requires -Version 7.0
<#
  tests/codex-membrane/reflection.Tests.ps1 — the OPTIONAL post-hoc reflection substrate (serving.ps1):
  gather a run's worked examples into an introspection digest, and surface human-examinable
  promotion candidates. The machine never promotes; it surfaces.
#>

BeforeAll {
    . "$PSScriptRoot/../../src/codex-membrane/serving.ps1"
    $script:tmp = Join-Path ([System.IO.Path]::GetTempPath()) "refl-$([guid]::NewGuid())"
    New-Item -ItemType Directory -Path $script:tmp | Out-Null
    $script:chunks = Join-Path $script:tmp 'p.chunks.jsonl'
    'x' | Set-Content $script:chunks   # existence only; reflection reads the audit sidecars
    $audit = @(
        @{ id=1; source='worker'; before='a,'; after='[1] a,'; was='reference_formatting' }
        @{ id=2; source='worker'; before='b,'; after='[2] b,'; was='reference_formatting' }
        @{ id=3; source='worker'; before='x \frac'; after='x'; was='degenerate_structure' }
    )
    $sw = [System.IO.StreamWriter]::new((Join-Path $script:tmp 'p.apply-audit.jsonl'), $false, [System.Text.UTF8Encoding]::new($false))
    foreach ($a in $audit) { $sw.WriteLine(($a | ConvertTo-Json -Compress)) }
    $sw.Dispose()
}
AfterAll { if (Test-Path $script:tmp) { Remove-Item $script:tmp -Recurse -Force -ErrorAction SilentlyContinue } }

Describe 'Get-RunReflection (the digest)' {
    It 'groups a run''s applied repairs by class with counts + before/after' {
        $r = Get-RunReflection -ChunksPath $script:chunks
        $r.applied_total | Should -Be 3
        $ref = $r.classes | Where-Object { $_.type -eq 'reference_formatting' }
        $ref.count | Should -Be 2
        $ref.examples[0].after | Should -Match '^\[1\]'
    }

    It 'carries the introspection prompt (the reflection questions)' {
        $r = Get-RunReflection -ChunksPath $script:chunks
        $r.reflection | Should -Match 'generaliz'
        $r.reflection | Should -Match 'expressib'
        $r.reflection | Should -Match 'never promote|NEVER promote'
    }

    It 'is calm on a run with no applied repairs (no false candidates)' {
        $empty = Join-Path $script:tmp 'q.chunks.jsonl'; 'x' | Set-Content $empty
        $r = Get-RunReflection -ChunksPath $empty
        $r.applied_total | Should -Be 0
        $r.note | Should -Match 'nothing to reflect'
    }
}

Describe 'Add-PromotionCandidate (surface, never promote)' {
    It 'appends a candidate at status=surfaced with provenance' {
        $res = Add-PromotionCandidate -RepoRoot $script:tmp -Pattern 'ordinal [N] within an is_reference run' `
            -Class 'reference_formatting' -Examples @('p:1','p:2') -Expressibility 'structural' `
            -Recommendation 'examine' -Paper 'p'
        $res.surfaced | Should -BeTrue
        $rec = (Get-Content (Join-Path $script:tmp 'issues/promotion-candidates.jsonl') | Select-Object -Last 1) | ConvertFrom-Json
        $rec.status | Should -Be 'surfaced'          # the machine only ever surfaces
        $rec.class  | Should -Be 'reference_formatting'
        @($rec.examples) | Should -Contain 'p:1'
    }

    It 'refuses a candidate with no pattern (evidence is required to surface)' {
        { Add-PromotionCandidate -RepoRoot $script:tmp -Pattern '' } | Should -Throw '*Pattern*'
    }
}
