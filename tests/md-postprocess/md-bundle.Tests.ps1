#requires -Version 7.0
# Copy-MdDeliverable (src/md-postprocess/md-bundle.ps1) — standalone-deliverable bundling to a shelf with
# destination-side link verification and defect-sentinel counting. Coverage: link scan filtering,
# asset copy with relative subpaths preserved, missing-asset reporting (never fatal), sentinel
# counts, the clean verdict, and re-bundle idempotency.

BeforeAll {
    . "$PSScriptRoot/../../src/md-postprocess/md-bundle.ps1"
    $script:u8 = [System.Text.UTF8Encoding]::new($false)

    function Get-MdBundleCairoSvgCapability {
        $python = Get-Command python -CommandType Application -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if (-not $python) {
            return [pscustomobject]@{
                Available = $false
                Reason = 'Python required for SVG-to-PNG rendering is absent from PATH'
                PythonPath = $null
            }
        }
        $probeOutput = @(& $python.Source -c 'import cairosvg' 2>&1)
        $probeExitCode = $LASTEXITCODE
        $global:LASTEXITCODE = 0
        if ($probeExitCode -ne 0) {
            return [pscustomobject]@{
                Available = $false
                Reason = "Python at '$($python.Source)' cannot import CairoSVG"
                PythonPath = $python.Source
            }
        }
        return [pscustomobject]@{
            Available = $true
            Reason = $null
            PythonPath = [System.IO.Path]::GetFullPath($python.Source)
        }
    }

    $script:CairoSvgCapability = Get-MdBundleCairoSvgCapability
    $script:root = Join-Path $TestDrive 'md-bundle'
    $script:srcDir  = Join-Path $root 'paper'
    $script:shelf   = Join-Path $root 'shelf'
    New-Item -ItemType Directory -Force -Path (Join-Path $srcDir 'p') | Out-Null
    [System.IO.File]::WriteAllBytes((Join-Path $srcDir 'p/fig-1.png'), [byte[]](137, 80, 78, 71))
    [System.IO.File]::WriteAllText((Join-Path $srcDir 'p/diagram-2.svg'), '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"><rect width="10" height="10"/></svg>', $script:u8)
    $script:mdPath = Join-Path $srcDir 'p-latex.md'
    [System.IO.File]::WriteAllText($mdPath, @'
# T

![figure 1](p/fig-1.png)
![web image](https://x.test/a.png)
![gone](p/never-made.png)
'@, $u8)
}

AfterAll {
    Remove-Item -LiteralPath $script:root -Recurse -Force -ErrorAction SilentlyContinue
}

Describe 'Get-MdLocalImageLinks — bundle candidates only' {
    It 'keeps relative targets, skips web/data/absolute, dedupes' {
        $links = Get-MdLocalImageLinks "![](p/a.png) ![](p/a.png) ![](https://h/x.png) ![](data:image/png;base64,AA==) ![](C:/abs/x.png)"
        @($links) | Should -Be @('p/a.png')
    }
}

Describe 'Copy-MdDeliverable — bundle + verify' {
    It 'lands md + assets in a self-contained bundle directory with -tree.md sidecar; missing asset reported, not fatal' {
        $r = Copy-MdDeliverable -MarkdownPath $mdPath -DestDir $shelf
        Test-Path $r.bundle_dir | Should -BeTrue
        Test-Path $r.md | Should -BeTrue
        Test-Path $r.toc_md | Should -BeTrue
        Test-Path (Join-Path $r.bundle_dir 'images/fig-1.png') | Should -BeTrue
        $r.links_total | Should -Be 2          # web link excluded
        $r.assets_copied | Should -Be 1
        @($r.assets_missing) | Should -Be @('p/never-made.png')
        @($r.links_broken) | Should -Be @('p/never-made.png')
        $r.clean | Should -BeFalse             # a broken link is never a clean bundle
    }
    It 'renders an SVG asset to PNG and rewrites the shipped link when CairoSVG is available' {
        if (-not $script:CairoSvgCapability.Available) {
            Set-ItResult -Skipped -Because $script:CairoSvgCapability.Reason
            return
        }
        $svgMarkdown = Join-Path $srcDir 'svg-latex.md'
        [System.IO.File]::WriteAllText(
            $svgMarkdown, "# T`n`n![diagram](p/diagram-2.svg)`n", $u8)
        $r = Copy-MdDeliverable -MarkdownPath $svgMarkdown -DestDir (Join-Path $root 'svg-shelf')
        Test-Path (Join-Path $r.bundle_dir 'images/diagram-2.png') | Should -BeTrue
        [System.IO.File]::ReadAllText($r.md, $u8) | Should -Match `
            ([regex]::Escape('![diagram](images/diagram-2.png)'))
        $r.assets_copied | Should -Be 1
        $r.clean | Should -BeTrue
    }
    It 're-bundling is idempotent and a fully-resolved document verdicts clean' {
        $ok = Join-Path $srcDir 'ok-latex.md'
        [System.IO.File]::WriteAllText($ok, "# T`n`n![f](p/fig-1.png)`n", $u8)
        $r1 = Copy-MdDeliverable -MarkdownPath $ok -DestDir $shelf
        $r2 = Copy-MdDeliverable -MarkdownPath $ok -DestDir $shelf
        $r1.clean | Should -BeTrue
        $r2.clean | Should -BeTrue
        $r2.assets_copied | Should -Be 1
    }
    It 'counts defect sentinels instead of shipping them silently' {
        $bad = Join-Path $srcDir 'bad-latex.md'
        [System.IO.File]::WriteAllText($bad, ("# T`n`n@@LMATH3@@ and " + [char]0xFFFD + " and FILL_ME_IN`n"), $u8)
        $r = Copy-MdDeliverable -MarkdownPath $bad -DestDir $shelf
        $r.sentinels.placeholders | Should -Be 1
        $r.sentinels.replacement_char | Should -Be 1
        $r.sentinels.fill_me_in | Should -Be 1
        $r.clean | Should -BeFalse
    }
}
