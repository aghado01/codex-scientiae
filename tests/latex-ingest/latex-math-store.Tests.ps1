#requires -Version 7.0
BeforeAll {
    . "$PSScriptRoot/../../src/math-register/math-register.ps1"
    . "$PSScriptRoot/../../src/latex-ingest/latex-math-store.ps1"
}

Describe "Get-LatexMathStore" {
    It "loads latex-math-store.json definitions" {
        $store = Get-LatexMathStore
        $store | Should -Not -BeNullOrEmpty
        $store.source_evidence | Should -Not -BeNullOrEmpty
        $store.aliases | Should -Not -BeNullOrEmpty
        $store.unicode_glyphs | Should -Not -BeNullOrEmpty
    }
}

Describe "Invoke-LatexMathStoreLowering & Evidence Tracking" {
    It "lowers \\operatorname{Hom} to \\mathrm{Hom} and records out-of-band evidence" {
        $ledger = New-LatexEvidenceLedger
        $res = Invoke-LatexMathStoreLowering -Latex "\operatorname{Hom}(V, W)" -SpanId "span-1" -EvidenceLedger $ledger

        $res | Should -Be "\mathrm{Hom}(V, W)"
        $ledger.Count | Should -Be 1
        $ledger[0].span_id | Should -Be "span-1"
        $ledger[0].evidence_kind | Should -Be "operator_name"
        $ledger[0].original | Should -Be "\operatorname{Hom}"
        $ledger[0].lowered | Should -Be "\mathrm{Hom}"
    }

    It "applies alias surjection and furniture removal" {
        $ledger = New-LatexEvidenceLedger
        $res = Invoke-LatexMathStoreLowering -Latex "a \ge b \!\color{red}{x}" -SpanId "span-2" -EvidenceLedger $ledger

        $res | Should -Be "a \geq b {x}"
    }

    It "preserves \\text{} prose without applying math rules inside" {
        $ledger = New-LatexEvidenceLedger
        $res = Invoke-LatexMathStoreLowering -Latex "\mathrm{Hom} \text{ where a \ge b}" -SpanId "span-3" -EvidenceLedger $ledger

        $res | Should -Be "\mathrm{Hom} \text{ where a \ge b}"
    }
}
