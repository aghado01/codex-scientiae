#requires -Version 7.0
# The reusable mathematical-render audit. These tests pin the capability contract independently of
# any one converter and verify that its engine comes from the centralized packages/node payload.

BeforeAll {
    $script:RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
    . (Join-Path $script:RepoRoot 'src/math-channel/math-render/math-render.ps1')
    $script:Available = Test-MathRenderAvailable
    $script:TestArtifacts = Join-Path $script:RepoRoot "artifacts/tests/math-render/$([guid]::NewGuid().ToString('N'))"
    New-Item -ItemType Directory -Force -Path $script:TestArtifacts | Out-Null
}

AfterAll {
    Remove-Item -LiteralPath $script:TestArtifacts -Recurse -Force -ErrorAction SilentlyContinue
}

Describe 'math-render — engine-backed mathematical Markdown audit' {
    It 'is available from the centralized Node payload' {
        $script:Available | Should -BeTrue -Because 'brewery/node/restore-node.ps1 must materialize the test payload under packages/node'
    }

    It 'accepts well-formed display and inline math' {
        if (-not $script:Available) { Set-ItResult -Skipped; return }
        $report = Invoke-MathRenderAudit -Spans @(
            @{ content = '\frac{1}{2} + \sum_{i=1}^n x_i'; display = $true }
            @{ content = 'x \in \mathbb{R}^n'; display = $false }
            @{ content = '\begin{aligned} a &= b \\ c &= d \end{aligned}'; display = $true }
        )
        $report.schema | Should -Be 'math-render-audit/1'
        $report.capability | Should -Be 'math-render'
        $report.engine.name | Should -Be 'katex'
        $report.status | Should -Be 'pass'
        $report.clean | Should -BeTrue
        $report.ok | Should -Be 3
        $report.failed | Should -Be 0
    }

    It 'persists the same report as UTF-8 without BOM when the caller supplies an address' {
        if (-not $script:Available) { Set-ItResult -Skipped; return }
        $path = Join-Path $script:TestArtifacts 'audits/math-render.json'
        $report = Invoke-MathRenderAudit -Spans @(@{ id = 'formula-1'; content = 'x^2'; display = $false }) -Strict -OutputPath $path
        $stored = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
        $stored.schema | Should -Be 'math-render-audit/1'
        $stored.engine.version | Should -Be ((Get-Content (Join-Path $script:RepoRoot 'packages/node/node_modules/katex/package.json') -Raw | ConvertFrom-Json).version)
        $stored.source | Should -Be 'spans'
        $stored.clean | Should -BeTrue
        $report.report_path | Should -Be ([System.IO.Path]::GetFullPath($path))
        [System.IO.File]::ReadAllBytes($path)[0] | Should -Be 123 # opening {, not an EF BB BF BOM
    }

    It 'reports an undefined control sequence without failing the audit process' {
        if (-not $script:Available) { Set-ItResult -Skipped; return }
        $report = Invoke-MathRenderAudit -Spans @(@{ content = '\eps + \norm{x}'; display = $false })
        $report.status | Should -Be 'fail'
        $report.clean | Should -BeFalse
        $report.failed | Should -Be 1
        $report.failures[0].error | Should -Match 'Undefined control sequence'
    }

    It 'reports unbalanced delimiters' {
        if (-not $script:Available) { Set-ItResult -Skipped; return }
        (Invoke-MathRenderAudit -Spans @(@{ content = '\left( \frac{1}{2}'; display = $true })).failed | Should -Be 1
    }

    It 'reports a bare alignment marker outside an environment' {
        if (-not $script:Available) { Set-ItResult -Skipped; return }
        (Invoke-MathRenderAudit -Spans @(@{ content = 'a &= b'; display = $true })).failed | Should -Be 1
    }

    It 'accepts nested dollars inside text content' {
        if (-not $script:Available) { Set-ItResult -Skipped; return }
        (Invoke-MathRenderAudit -Spans @(@{ content = '\phi z \text{ where $z$ is the leading eigenvector}'; display = $true })).failed | Should -Be 0
    }

    It 'audits the standing LaTeX oracle at the strict bar' {
        $oracle = Join-Path $script:RepoRoot 'ingestion/_inbox/1611.03935/1611.03935.latex.md'
        if (-not $script:Available -or -not (Test-Path $oracle)) { Set-ItResult -Skipped -Because 'oracle or shared Node payload absent'; return }
        $report = Invoke-MathRenderAudit -Path $oracle -Strict
        $report.failed | Should -Be 0
        $report.total | Should -BeGreaterThan 100
    }
}
