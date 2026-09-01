#requires -Version 7.0

BeforeAll {
    . "$PSScriptRoot/../../src/logistics/latex-source.ps1"

    function New-TestLatexTarGzip {
        param(
            [Parameter(Mandatory)] [string]$Path,
            [Parameter(Mandatory)] [System.Collections.IDictionary]$Files
        )
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream,
            [System.IO.Compression.CompressionLevel]::Optimal,
            $true
        )
        $writer = [System.Formats.Tar.TarWriter]::new(
            $gzip,
            [System.Formats.Tar.TarEntryFormat]::Pax,
            $true
        )
        try {
            foreach ($pair in $Files.GetEnumerator()) {
                $bytes = if ($pair.Value -is [byte[]]) {
                    $pair.Value
                } else {
                    [System.Text.UTF8Encoding]::new($false).GetBytes([string]$pair.Value)
                }
                $entry = [System.Formats.Tar.PaxTarEntry]::new(
                    [System.Formats.Tar.TarEntryType]::RegularFile,
                    [string]$pair.Key
                )
                $data = [System.IO.MemoryStream]::new($bytes)
                try {
                    $entry.DataStream = $data
                    $writer.WriteEntry($entry)
                } finally {
                    $data.Dispose()
                }
            }
        } finally {
            $writer.Dispose()
            $gzip.Dispose()
            $fileStream.Dispose()
        }
    }

    function New-TestLatexSingleGzip {
        param([Parameter(Mandatory)] [string]$Path, [Parameter(Mandatory)] [byte[]]$Bytes)
        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream,
            [System.IO.Compression.CompressionLevel]::Optimal
        )
        try { $gzip.Write($Bytes, 0, $Bytes.Length) }
        finally { $gzip.Dispose(); $fileStream.Dispose() }
    }
}

Describe 'latex-source archive expansion and tree validation' {
    It 'rejects traversal members before publishing a tree' {
        $root = Join-Path $TestDrive ("trav-" + [guid]::NewGuid().ToString('N'))
        $document = Join-Path $root 'doc'
        New-Item -ItemType Directory -Path $document -Force | Out-Null
        $archive = Join-Path $document 'doc.tar.gz'
        New-TestLatexTarGzip -Path $archive -Files ([ordered]@{
                '../escape.tex' = '\documentclass{article}\begin{document}x\end{document}'
            })
        { Expand-LatexSourceArchive -ArchivePath $archive -DestinationPath (Join-Path $document 'doc-tex') } |
            Should -Throw '*escapes its root*'
    }

    It 'rejects invalid UTF-8 LaTeX during tree validation' {
        $root = Join-Path $TestDrive ("utf8-" + [guid]::NewGuid().ToString('N'))
        $document = Join-Path $root 'doc'
        $tree = Join-Path $document 'doc-tex'
        New-Item -ItemType Directory -Path $tree -Force | Out-Null
        [System.IO.File]::WriteAllBytes(
            (Join-Path $tree 'main.tex'),
            [byte[]](0x64, 0x6F, 0x63, 0xFF))
        { Test-LatexSourceTree -RootPath $tree -Slug 'doc' } | Should -Throw '*not valid UTF-8*'
    }

    It 'accepts the arXiv single-TeX gzip shape' {
        $root = Join-Path $TestDrive ("single-" + [guid]::NewGuid().ToString('N'))
        $document = Join-Path $root 'doc'
        New-Item -ItemType Directory -Path $document -Force | Out-Null
        $archive = Join-Path $document 'doc.tar.gz'
        $tex = [System.Text.UTF8Encoding]::new($false).GetBytes(
            '\documentclass{article}\begin{document}Body.\end{document}')
        New-TestLatexSingleGzip -Path $archive -Bytes $tex
        $tree = Join-Path $document 'doc-tex'
        $expansion = Expand-LatexSourceArchive -ArchivePath $archive -DestinationPath $tree
        $expansion.archive_kind | Should -Be 'single-tex+gzip'
        Test-Path (Join-Path $tree 'main.tex') | Should -BeTrue
        (Test-LatexSourceTree -RootPath $tree -Slug 'doc').entrypoint | Should -Be 'main.tex'
    }

    It 'resolves nested literal inputs from the compile root' {
        $tree = Join-Path $TestDrive ("compile-root-" + [guid]::NewGuid().ToString('N'))
        $sub = Join-Path $tree 'sub'
        New-Item -ItemType Directory -Path $sub -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM -Value @'
\documentclass{article}
\input{sub/wrapper}
\begin{document}x\end{document}
'@
        Set-Content -LiteralPath (Join-Path $sub 'wrapper.tex') -Encoding utf8NoBOM -Value '\input{leaf}'
        Set-Content -LiteralPath (Join-Path $tree 'leaf.tex') -Encoding utf8NoBOM -Value 'COMPILE-ROOT'
        Set-Content -LiteralPath (Join-Path $sub 'leaf.tex') -Encoding utf8NoBOM -Value 'CONTAINING-FILE'

        $resolved = Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree
        $resolved | Should -Match 'COMPILE-ROOT'
        $resolved | Should -Not -Match 'CONTAINING-FILE'
    }

    It 'normalizes leading-dot input syntax at the compile-root boundary' {
        $tree = Join-Path $TestDrive ("leading-dot-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tree -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM `
            -Value '\input{./fragment}' -NoNewline
        Set-Content -LiteralPath (Join-Path $tree 'fragment.tex') -Encoding utf8NoBOM `
            -Value 'LEADING-DOT' -NoNewline

        $resolved = Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree
        $resolved | Should -BeExactly 'LEADING-DOT'
    }

    It 'resolves subfile and preserves its physical spelling under Keep policy' {
        $tree = Join-Path $TestDrive ("subfile-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tree -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM `
            -Value '\subfile{chapter}' -NoNewline
        Set-Content -LiteralPath (Join-Path $tree 'chapter.tex') -Encoding utf8NoBOM `
            -Value 'SUBFILE-CHAPTER' -NoNewline

        $resolved = Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree
        $resolved | Should -BeExactly 'SUBFILE-CHAPTER'

        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM `
            -Value '\subfile{missing}' -NoNewline
        $kept = Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree `
            -UnresolvedInputAction Keep -WarningAction SilentlyContinue
        $kept | Should -BeExactly '\subfile{missing}'
        { Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree } |
            Should -Throw "*LaTeX subfile target 'missing'*"
    }

    It 'validates a tree whose literal input target is missing' {
        $tree = Join-Path $TestDrive ("missing-input-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tree -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM -Value @'
\documentclass{article}
\input{alg_adjlist.tex}
\begin{document}x\end{document}
'@
        $validation = Test-LatexSourceTree -RootPath $tree -Slug 'doc'
        $validation.entrypoint | Should -Be 'main.tex'
        @($validation.unresolved_inputs).Count | Should -Be 1
        $validation.unresolved_inputs[0].command | Should -Be 'input'
        $validation.unresolved_inputs[0].literal | Should -Be 'alg_adjlist.tex'
        $validation.unresolved_inputs[0].referenced_by | Should -Be 'main.tex'
    }

    It 'resolves bare literal forms at TeX token boundaries and keeps exact syntax' {
        $tree = Join-Path $TestDrive ("bare-inputs-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tree -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM -Value @'
\input bare% target stops before this comment
\include ./chapter.tex
\subfile appendix
\input\dynamic
\include[dynamic]
\include]dynamic
\subfilefoo
'@
        Set-Content -LiteralPath (Join-Path $tree 'bare.tex') -Encoding utf8NoBOM `
            -Value 'BARE-INPUT' -NoNewline
        Set-Content -LiteralPath (Join-Path $tree 'chapter.tex') -Encoding utf8NoBOM `
            -Value 'BARE-INCLUDE' -NoNewline
        Set-Content -LiteralPath (Join-Path $tree 'appendix.tex') -Encoding utf8NoBOM `
            -Value 'BARE-SUBFILE' -NoNewline
        Set-Content -LiteralPath (Join-Path $tree 'dynamic.tex') -Encoding utf8NoBOM `
            -Value 'EXPANDED-DYNAMIC-TARGET' -NoNewline
        Set-Content -LiteralPath (Join-Path $tree 'foo.tex') -Encoding utf8NoBOM `
            -Value 'EXPANDED-CONTROL-WORD-PREFIX' -NoNewline

        $resolved = Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree
        $resolved | Should -Match 'BARE-INPUT'
        $resolved | Should -Match 'BARE-INCLUDE'
        $resolved | Should -Match 'BARE-SUBFILE'
        $resolved | Should -Not -Match 'EXPANDED-DYNAMIC|EXPANDED-CONTROL-WORD'

        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding utf8NoBOM `
            -Value '\subfile missing' -NoNewline
        $kept = Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree `
            -UnresolvedInputAction Keep -WarningAction SilentlyContinue
        $kept | Should -BeExactly '\subfile missing'
        { Resolve-LatexSourceInputs -MainPath (Join-Path $tree 'main.tex') -RootPath $tree } |
            Should -Throw "*LaTeX subfile target 'missing'*"
    }

    It 'makes lock contention visible instead of running two deposit writers concurrently' {
        $root = Join-Path $TestDrive ("lock-" + [guid]::NewGuid().ToString('N'))
        $document = Join-Path $root 'doc'
        New-Item -ItemType Directory -Path $document -Force | Out-Null
        $held = Enter-SourceDepositLock -DocumentDir $document
        try {
            { Enter-SourceDepositLock -DocumentDir $document -TimeoutSeconds 0 } |
                Should -Throw '*timed out waiting for the source-deposit lock*'
        } finally {
            Exit-SourceDepositLock -Lock $held
        }
        $reacquired = Enter-SourceDepositLock -DocumentDir $document -TimeoutSeconds 0
        Exit-SourceDepositLock -Lock $reacquired
    }
}
