#requires -Version 7
# Figure weave (src/finalize.ps1 Get-FigureWeave + emission): the finalized markdown DRINKS the pig
# figure lane through the shared md-register (src/md-register.ps1) — captioned crops ride their
# caption chunks, uncaptioned crops flush at page boundaries, failed crops emit flagged markers.
# Synthetic paper: a membrane run (chunks.jsonl) + a pig run (figures.jsonl / images.jsonl / crop
# PNG stubs) under one temp paper root — no corpus dependence.

BeforeAll {
    $repo = Split-Path $PSScriptRoot -Parent
    . (Join-Path $repo 'src/finalize.ps1')

    $script:wf = Join-Path ([IO.Path]::GetTempPath()) ('fin-weave-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    $paper = Join-Path $script:wf 'wpaper'
    $script:runDir = Join-Path $paper '.runs/20990101_000001'
    $pig = Join-Path $paper '.runs/20990101_000000/pig'
    New-Item -ItemType Directory -Force -Path $script:runDir, (Join-Path $pig 'images') | Out-Null

    # pig run: envelope stub (Get-PigRunDirs keys on it), 3 figure regions — captioned+ok,
    # uncaptioned+ok, captioned+FAILED crop
    [IO.File]::WriteAllText((Join-Path $pig 'wpaper.pdfdig.json'), '{}')
    [IO.File]::WriteAllLines((Join-Path $pig 'wpaper.figures.jsonl'), @(
        '{"id":0,"page":1,"kind":"figure","caption":{"block_id":9,"text":"Figure 1: alpha beta"}}',
        '{"id":1,"page":1,"kind":"figure","caption":null}',
        '{"id":2,"page":2,"kind":"figure","caption":{"block_id":10,"text":"Figure 2: gamma"}}'
    ))
    [IO.File]::WriteAllLines((Join-Path $pig 'images.jsonl'), @(
        '{"id":0,"figure_id":0,"page":1,"png":"images/imageFile0.png","status":"ok"}',
        '{"id":1,"figure_id":1,"page":1,"png":"images/imageFile1.png","status":"ok"}',
        '{"id":2,"figure_id":2,"page":2,"png":null,"status":"failed"}'
    ))
    [IO.File]::WriteAllBytes((Join-Path $pig 'images/imageFile0.png'), [byte[]](137, 80, 78, 71))
    [IO.File]::WriteAllBytes((Join-Path $pig 'images/imageFile1.png'), [byte[]](137, 80, 78, 71))

    # membrane chunks: pg1 anchor prose (mentions Figure 1), the pg1 caption chunk, pg2 prose
    $script:chunksPath = Join-Path $script:runDir 'wpaper.chunks.jsonl'
    [IO.File]::WriteAllLines($script:chunksPath, @(
        '{"id":0,"type":"paragraph","page":1,"content":"Opening prose that mentions Figure 1 in passing."}',
        '{"id":1,"type":"paragraph","page":1,"is_furniture":"caption","content":"Figure 1: alpha beta"}',
        '{"id":2,"type":"paragraph","page":2,"content":"Second page prose, nothing else."}'
    ))

    $script:res = Invoke-Finalize -ChunksPath $script:chunksPath
    $script:md = [IO.File]::ReadAllText($script:res.body)
}
AfterAll { if ($script:wf -and (Test-Path $script:wf)) { Remove-Item -Recurse -Force $script:wf } }

Describe 'finalize figure weave' {
    It 'weaves the captioned crop immediately before its caption paragraph' {
        $imgIdx = $md.IndexOf('![figure: Figure 1](wpaper-membrane/imageFile0.png)')
        $capIdx = $md.IndexOf('*Figure 1: alpha beta*')
        $imgIdx | Should -BeGreaterThan (-1)
        $capIdx | Should -BeGreaterThan $imgIdx
    }
    It 'flushes the uncaptioned crop at its page boundary (after pg1 content, before pg2 prose)' {
        $dImg = $md.IndexOf('![diagram: p1 region 1](wpaper-membrane/imageFile1.png)')
        $pg2  = $md.IndexOf('Second page prose')
        $dImg | Should -BeGreaterThan (-1)
        $pg2  | Should -BeGreaterThan $dImg
    }
    It 'emits a flagged marker (with the pig caption) for a failed crop — never silence' {
        $md | Should -Match '\*\[figure: Figure 2 — crop render failed\]\*'
        $md | Should -Match '\*Figure 2: gamma\.\*'
    }
    It 'copies the crop PNGs run-locally into {slug}-membrane/' {
        Test-Path (Join-Path $script:runDir 'wpaper-membrane/imageFile0.png') | Should -BeTrue
        Test-Path (Join-Path $script:runDir 'wpaper-membrane/imageFile1.png') | Should -BeTrue
    }
    It 'carries the image dir UP with the paper-root mirror (links resolve there too)' {
        $paperRoot = Split-Path -Parent (Split-Path -Parent $script:runDir)   # {wf}/wpaper
        Test-Path (Join-Path $paperRoot 'wpaper-membrane.md')                | Should -BeTrue
        Test-Path (Join-Path $paperRoot 'wpaper-membrane/imageFile0.png')    | Should -BeTrue   # -Path glob, not -LiteralPath
        Test-Path (Join-Path $paperRoot 'wpaper-membrane/imageFile1.png')    | Should -BeTrue
    }
    It 'reports weave counters (woven / copied / markers)' {
        $res.weave.figures_woven | Should -Be 1
        $res.weave.images_copied | Should -Be 2
        $res.weave.weave_markers | Should -Be 1
    }
    It 'is a clean no-op for a paper without a pig run' {
        $paper2 = Join-Path $script:wf 'nopig'
        $run2 = Join-Path $paper2 '.runs/20990101_000002'
        New-Item -ItemType Directory -Force -Path $run2 | Out-Null
        $cp = Join-Path $run2 'nopig.chunks.jsonl'
        [IO.File]::WriteAllLines($cp, @('{"id":0,"type":"paragraph","page":1,"content":"plain prose"}'))
        $r2 = Invoke-Finalize -ChunksPath $cp
        $r2.weave.images_copied | Should -Be 0
        [IO.File]::ReadAllText($r2.body) | Should -Not -Match '!\['
    }
}
