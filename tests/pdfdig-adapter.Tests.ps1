#requires -Version 7.0
<#
  tests/pdfdig-adapter.Tests.ps1 — the pdfdig -> membrane node-dialect bridge (src/pdfdig-adapter.ps1)
  and dual-lane source resolution (src/runs.ps1 Resolve-PaperSource).

  Unit-level on synthetic run-nodes (no PDF needed) + a lane-resolution matrix on a temp paper dir.
#>

BeforeAll {
    . "$PSScriptRoot/../src/pdfdig-adapter.ps1"
    . "$PSScriptRoot/../src/runs.ps1"

    # a synthetic pdfdig nodes lane: a heading, a prose line with inline math, a 2-line formula
    # group, and a marker — the four routing cases.
    function New-Run($id, $type, $lineId, $page, $content, $role, $script, $extra) {
        $r = [ordered]@{ id=$id; type=$type; page=$page; line_id=$lineId; block=0; col=0
                         baseline_y=100.0; content=$content; font='X'; 'font size'=10.0
                         'bounding box'=@(10.0,90.0,50.0,100.0); role=$role; script=$script; flags=@() }
        if ($extra) { foreach ($k in $extra.Keys) { $r[$k] = $extra[$k] } }
        [pscustomobject]$r
    }
    $script:runNodes = @(
        (New-Run 0 'heading-candidate' 1 1 'Introduction' 'prose' 'normal' @{ outline_level=0 })
        (New-Run 1 'prose'   2 1 'let ' 'prose' 'normal' $null)
        (New-Run 2 'prose'   2 1 'p'    'math'  'normal' $null)
        (New-Run 3 'prose'   2 1 '1'    'math'  'sub'    $null)
        (New-Run 4 'prose'   2 1 ' be a point' 'prose' 'normal' $null)
        (New-Run 5 'formula-block' 3 1 'x = y' 'math' 'normal' @{ formula_group=0 })
        (New-Run 6 'formula-block' 4 1 '+ z'   'math' 'normal' @{ formula_group=0; flags=@('needs_2d_assembly') })
        (New-Run 7 'marker' 5 1 '2' 'prose' 'normal' @{ flags=@('page_furniture') })
    )
    $script:tmp = Join-Path ([System.IO.Path]::GetTempPath()) "pdfdig-adapter-$([guid]::NewGuid())"
    New-Item -ItemType Directory -Path $script:tmp | Out-Null
    $script:nodesPath = Join-Path $script:tmp 'syn.nodes.jsonl'
    $sw = [System.IO.StreamWriter]::new($script:nodesPath, $false, [System.Text.UTF8Encoding]::new($false))
    foreach ($r in $script:runNodes) { $sw.WriteLine(($r | ConvertTo-Json -Compress -Depth 8)) }
    $sw.Dispose()

    $script:outPath = Join-Path $script:tmp 'membrane.nodes.jsonl'
    $script:res = Invoke-ProjectPdfDigNodes -PdfDigNodesPath $script:nodesPath -OutputPath $script:outPath
    $script:nodes = @([System.IO.File]::ReadAllLines($script:outPath) | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json })
}
AfterAll {
    if (Test-Path $script:tmp) { Remove-Item $script:tmp -Recurse -Force -ErrorAction SilentlyContinue }
}

Describe 'adapter routing' {
    It 'routes the four node classes to membrane types + drops markers' {
        $script:res.Headings   | Should -Be 1
        $script:res.Formulas   | Should -Be 1   # two lines, one group -> one formula node
        $script:res.Paragraphs | Should -Be 1
        $script:res.MarkersDropped | Should -Be 1
        ($script:nodes | Where-Object type -eq 'marker').Count | Should -Be 0
    }

    It 'accounts for every input line (nothing silently lost)' {
        # every input LINE maps to exactly one outcome; formula NODES group multiple lines, so the
        # line-conservation identity counts formula LINES, not formula nodes
        ($script:res.Headings + $script:res.Paragraphs + $script:res.FormulaLines + $script:res.MarkersDropped) |
            Should -Be $script:res.Lines
    }

    It 'pre-promotes the heading with an outline-derived level' {
        $h = $script:nodes | Where-Object type -eq 'heading' | Select-Object -First 1
        $h.content | Should -Be 'Introduction'
        $h.heading_level | Should -Be 1     # outline_level 0 -> H1
    }

    It 'seams inline math with a geometric subscript ($ p_{1} $)' {
        $p = $script:nodes | Where-Object type -eq 'paragraph' | Select-Object -First 1
        $p.content | Should -Match '\$p'      # math seam opened
        $p.content | Should -Match '_\{1\}'   # geometric subscript preserved
        $p.content | Should -Match 'be a point'
    }

    It 'merges a formula group into one node, joined by newline, flags carried' {
        $f = $script:nodes | Where-Object type -eq 'formula' | Select-Object -First 1
        $f.content | Should -Match "x = y"
        $f.content | Should -Match "\+ z"
        $f.content.Contains("`n") | Should -BeTrue
        $f.flags | Should -Contain 'needs_2d_assembly'
    }

    It 'emits a byte-stable lane (SortedSet flags — no HashSet nondeterminism)' {
        $out2 = Join-Path $script:tmp 'membrane2.nodes.jsonl'
        $null = Invoke-ProjectPdfDigNodes -PdfDigNodesPath $script:nodesPath -OutputPath $out2
        (Get-FileHash $script:outPath).Hash | Should -Be (Get-FileHash $out2).Hash
    }
}

Describe 'dual-lane source resolution' {
    BeforeAll {
        $script:root = Join-Path ([System.IO.Path]::GetTempPath()) "pdfdig-lanes-$([guid]::NewGuid())"
        $script:both = Join-Path $script:root 'bothpaper'
        $script:pigOnly = Join-Path $script:root 'pigpaper'
        $script:odlOnly = Join-Path $script:root 'odlpaper'
        foreach ($d in $script:both, $script:pigOnly, $script:odlOnly) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
        '{}' | Set-Content (Join-Path $script:both 'bothpaper.json')
        '{}' | Set-Content (Join-Path $script:both 'bothpaper.pdfdig.json')
        '{}' | Set-Content (Join-Path $script:pigOnly 'pigpaper.pdfdig.json')
        '{}' | Set-Content (Join-Path $script:odlOnly 'odlpaper.json')
    }
    AfterAll { if (Test-Path $script:root) { Remove-Item $script:root -Recurse -Force -ErrorAction SilentlyContinue } }

    It 'auto prefers opendataloader when both exist' {
        (Resolve-PaperSource -Root $script:root -Paper 'bothpaper' -Lane 'auto') | Should -Match 'bothpaper\.json$'
    }
    It 'auto falls to pdfdig when opendataloader is absent' {
        (Resolve-PaperSource -Root $script:root -Paper 'pigpaper' -Lane 'auto') | Should -Match 'pigpaper\.pdfdig\.json$'
    }
    It 'explicit pdfdig lane selects the pig envelope even when both exist' {
        (Resolve-PaperSource -Root $script:root -Paper 'bothpaper' -Lane 'pdfdig') | Should -Match 'bothpaper\.pdfdig\.json$'
    }
    It 'explicit opendataloader lane errors when only pdfdig exists' {
        { Resolve-PaperSource -Root $script:root -Paper 'pigpaper' -Lane 'opendataloader' } | Should -Throw '*opendataloader source not found*'
    }
    It 'explicit pdfdig lane errors when only opendataloader exists' {
        { Resolve-PaperSource -Root $script:root -Paper 'odlpaper' -Lane 'pdfdig' } | Should -Throw '*pdfdig source not found*'
    }
}
