#requires -Version 7.0

BeforeAll {
    . "$PSScriptRoot/../../src/logistics/latex-source-deposit.ps1"

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
