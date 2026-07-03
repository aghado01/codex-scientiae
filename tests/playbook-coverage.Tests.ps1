#requires -Version 7.0
# Playbook coverage invariant: every issue type the membrane can emit has a paired repair recipe in
# $script:RepairPlaybook. Adding a new corruption signature or needs_review kind without a recipe
# breaks this test, forcing the author to single-source the instruction in playbook.ps1.

BeforeDiscovery {
    # -ForEach test cases are bound at DISCOVERY time, before BeforeAll runs — so the emittable-type
    # list that drives the per-type cases must be built here, or each case binds to $null.
    . "$PSScriptRoot/../src/fidelity.ps1"
    . "$PSScriptRoot/../src/playbook.ps1"
    $AllEmittableTypes =
        @($script:CorruptionSignatures | ForEach-Object { $_.type }) +              # 14 corruption signatures (8 hard gate + 6 soft tells)
        @('heading_level_unknown', 'unwrapped_math', 'prose_seam_merge', 'needs_2d_assembly') + # needs_review kinds (last: pig-lane flattened 2-D, flag-based)
        @('fragmented_formula')                                                     # hotspot span kind (Group-MathHotspots)
}

BeforeAll {
    . "$PSScriptRoot/../src/fidelity.ps1"    # loads the corruption signatures table + needs_review kinds
    . "$PSScriptRoot/../src/playbook.ps1"    # loads the repair playbook data map

    # The complete set of issue types the membrane can emit to a work-order:
    #   - the 14 corruption signatures in $script:CorruptionSignatures (8 hard gate + 6 soft tells)
    #   - the 3 needs_review kinds Invoke-Fidelity routes on: heading_level_unknown, unwrapped_math,
    #     prose_seam_merge (the cross-chunk seam tell, set by Set-SeamMergeFlags)
    #   - fragmented_formula (the hotspot span kind, emitted by Group-MathHotspots in serving.ps1)
    $script:CorruptionKinds  = @($script:CorruptionSignatures | ForEach-Object { $_.type })
    $script:HardKinds        = @($script:CorruptionSignatures | Where-Object { $_.severity -eq 'hard' } | ForEach-Object { $_.type })
    $script:SoftKinds        = @($script:CorruptionSignatures | Where-Object { $_.severity -eq 'soft' } | ForEach-Object { $_.type })
    $script:NeedsReviewKinds = @('heading_level_unknown', 'unwrapped_math', 'prose_seam_merge', 'needs_2d_assembly')
    $script:SpanKinds = @('fragmented_formula')
    $script:AllEmittableTypes = $script:CorruptionKinds + $script:NeedsReviewKinds + $script:SpanKinds
}

Describe 'playbook coverage — every emittable issue type has a paired recipe' {
    It 'RepairPlaybook covers all <type>' -ForEach @(
        $AllEmittableTypes | ForEach-Object { @{ type = $_ } }
    ) {
        $script:RepairPlaybook.Contains($type) | Should -BeTrue -Because "issue type '$type' is emittable but has no recipe in playbook.ps1"
        $recipe = Get-RepairRecipe $type
        $recipe | Should -Not -BeNullOrEmpty
        $recipe.fix | Should -Not -BeNullOrEmpty -Because "recipe for '$type' must have a non-empty fix instruction"
    }

    It 'the total emittable type count is 19 (14 signatures + 4 needs_review + 1 span)' {
        $script:AllEmittableTypes.Count | Should -Be 19
    }

    It 'RepairPlaybook has no orphan entries (every recipe maps to an emittable type)' {
        foreach ($key in $script:RepairPlaybook.Keys) {
            $key | Should -BeIn $script:AllEmittableTypes -Because "playbook entry '$key' does not map to any emittable issue type"
        }
    }

    It 'the HARD gate has exactly 8 entries (frozen — corpus A/B pins these)' {
        $script:HardKinds.Count | Should -Be 8
    }

    It 'the SOFT band has exactly 6 entries (the needs_review tells)' {
        $script:SoftKinds.Count | Should -Be 6
    }

    It 'every soft signature carries severity=soft and the gate ignores it' {
        foreach ($t in $script:SoftKinds) {
            (Get-CorruptionType ([pscustomobject]@{ type = 'formula'; content = 'x \in' })) | Should -Not -Be $t
        }
        $script:HardKinds + $script:SoftKinds | Should -HaveCount 14
    }
}
