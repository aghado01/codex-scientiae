BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:FixtureDir = Join-Path $script:RepositoryRoot "tests/fixtures/texdig/mini_article"

    Import-Module (Join-Path $script:RepositoryRoot "src/batch-adapters/adapters.psd1") -Force
    Import-Module (Join-Path $script:RepositoryRoot "src/batch-executor/batch-executor.psd1") -Force

    $script:RunDirectory = Join-Path $TestDrive "texdig-batch-run"
    New-Item -ItemType Directory -Path $script:RunDirectory -Force | Out-Null
}

Describe "TeXdig batch adapter" -Tag "TeXdig", "BatchAdapter" {
    Context "Planning contract" {
        BeforeAll {
            $script:Jobs = @(Get-TeXdigBatchJob -Path $script:FixtureDir -RunDirectory $script:RunDirectory)
        }

        It "emits one PowerShellProcess job per deposited article" {
            $script:Jobs.Count | Should -Be 1
            $script:Jobs[0].Kind | Should -Be "PowerShellProcess"
            $script:Jobs[0].EntryPoint | Should -Match "run-census\.ps1$"
        }

        It "mints a stable texdig:{path}#{digest} id from article + tree identity" {
            $script:Jobs[0].Id | Should -Match "^texdig:tests/fixtures/texdig/mini_article#[0-9a-f]{12}$"
            $again = @(Get-TeXdigBatchJob -Path $script:FixtureDir -RunDirectory $script:RunDirectory)
            $again[0].Id | Should -Be $script:Jobs[0].Id
        }

        It "addresses one job container under texdig-jobs and declares it in Writes" {
            $jobDir = $script:Jobs[0].Metadata.JobDirectory
            $jobDir | Should -Match ([regex]::Escape((Join-Path $script:RunDirectory "texdig-jobs")))
            $script:Jobs[0].Writes | Should -Be @($jobDir, $script:Jobs[0].Metadata.TempRoot)
            $script:Jobs[0].Parameters.OutDirectory | Should -Be $jobDir
            $environment = $script:Jobs[0].ProcessSpec.Environment
            @($environment.TEMP, $environment.TMP, $environment.TMPDIR) | Should -Be @(
                $script:Jobs[0].Metadata.TempRoot,
                $script:Jobs[0].Metadata.TempRoot,
                $script:Jobs[0].Metadata.TempRoot)
            $environment.CODEX_JSON_SCRATCH_ROOT |
                Should -Be $script:Jobs[0].Metadata.JsonScratchRoot
        }

        It "creates no directories at planning time" {
            Test-Path -LiteralPath $script:Jobs[0].Metadata.JobDirectory | Should -BeFalse
            Test-Path -LiteralPath $script:Jobs[0].Metadata.TempRoot | Should -BeFalse
        }

        It "freezes worker inputs and identity metadata" {
            $script:Jobs[0].Parameters.Article | Should -Be $script:FixtureDir
            $script:Jobs[0].Parameters.DepsRoot | Should -Match "node_modules"
            $script:Jobs[0].Metadata.Slug | Should -Be "mini_article"
            $script:Jobs[0].Metadata.TreeSha256 | Should -Not -BeNullOrEmpty
            $script:Jobs[0].Metadata.ContainerContract | Should -Be "JobContainerIsDocumentContainer"
            $script:Jobs[0].EstimatedCost | Should -BeGreaterThan 1
        }

        It "expands a collection directory one level to its article children" {
            $collection = Join-Path $script:RepositoryRoot "tests/fixtures/texdig"
            $expanded = @(Get-TeXdigBatchJob -Path $collection -RunDirectory $script:RunDirectory)
            $expanded.Count | Should -Be 1
            $expanded[0].Metadata.Slug | Should -Be "mini_article"
        }

        It "refuses paths holding no deposited article" {
            { Get-TeXdigBatchJob -Path (Join-Path $script:RepositoryRoot "src/TeXdig/core") `
                -RunDirectory $script:RunDirectory } | Should -Throw "*no deposited articles*"
        }

        It "refuses a run directory outside the repository artifacts root" {
            { Get-TeXdigBatchJob -Path $script:FixtureDir `
                    -RunDirectory (Join-Path $script:RepositoryRoot 'src') } |
                Should -Throw "*RunDirectory must be a descendant of RepositoryRoot/artifacts*"
        }
    }

    Context "Execution through the executor" {
        BeforeAll {
            $jobs = @(Get-TeXdigBatchJob -Path $script:FixtureDir -RunDirectory $script:RunDirectory)
            $compiled = New-BatchPlan -Job $jobs -BasePath $jobs[0].WorkingDirectory
            if ($compiled.Errors.Count -gt 0 -or $null -eq $compiled.Plan) {
                throw "plan validation failed: $(@($compiled.Errors) -join '; ')"
            }
            $script:Execution = Invoke-BatchPlan -Plan $compiled -MaxWorkers 1
            $script:JobDirectory = $jobs[0].Metadata.JobDirectory
        }

        It "completes the plan without failures" {
            $script:Execution.Summary.Failed | Should -Be 0
            $script:Execution.Summary.Succeeded | Should -Be 1
        }

        It "emits the six stores into the job container (document container)" {
            foreach ($store in @("sources.jsonl", "entities.jsonl", "claims.jsonl",
                    "coverage.json", "diagnostics.jsonl", "summary.json")) {
                Test-Path (Join-Path $script:JobDirectory $store) | Should -BeTrue
            }
        }

        It "produces the same census the direct runner produces" {
            $summary = Get-Content -Raw (Join-Path $script:JobDirectory "summary.json") | ConvertFrom-Json
            $summary.slug | Should -Be "mini_article"
            $summary.coverage.residueUtf16 | Should -Be 0
        }
    }
}
