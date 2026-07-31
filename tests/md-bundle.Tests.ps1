#requires -Version 7.0
# Copy-MdDeliverable (src/audits/md-bundle.ps1) — standalone-deliverable bundling to a shelf with
# destination-side link verification and defect-sentinel counting. Coverage: link scan filtering,
# asset copy with relative subpaths preserved, missing-asset reporting (never fatal), sentinel
# counts, the clean verdict, and re-bundle idempotency.

BeforeAll {
    . "$PSScriptRoot/../src/md-postprocess/md-bundle.ps1"
    $script:u8 = [System.Text.UTF8Encoding]::new($false)

    $script:root = Join-Path ([System.IO.Path]::GetTempPath()) ("mdbundle-" + [guid]::NewGuid().ToString('N'))
    $script:srcDir  = Join-Path $root 'paper'
    $script:shelf   = Join-Path $root 'shelf'
    New-Item -ItemType Directory -Force -Path (Join-Path $srcDir 'p') | Out-Null
    [System.IO.File]::WriteAllBytes((Join-Path $srcDir 'p/fig-1.png'), [byte[]](137, 80, 78, 71))
    [System.IO.File]::WriteAllBytes((Join-Path $srcDir 'p/diagram-2.svg'), [byte[]](60, 115, 118, 103))
    $script:mdPath = Join-Path $srcDir 'p-latex.md'
    [System.IO.File]::WriteAllText($mdPath, @'
# T

![figure 1](p/fig-1.png)
![diagram](p/diagram-2.svg)
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
        Test-Path (Join-Path $r.bundle_dir 'p/fig-1.png') | Should -BeTrue
        Test-Path (Join-Path $r.bundle_dir 'p/diagram-2.svg') | Should -BeTrue
        $r.links_total | Should -Be 3          # web link excluded
        $r.assets_copied | Should -Be 2
        @($r.assets_missing) | Should -Be @('p/never-made.png')
        @($r.links_broken) | Should -Be @('p/never-made.png')
        $r.clean | Should -BeFalse             # a broken link is never a clean bundle
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
