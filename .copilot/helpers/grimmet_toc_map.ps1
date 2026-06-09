$root = 'c:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmet2006\Chapters'
$files = Get-ChildItem -LiteralPath $root -Filter 'Chapter*.md' | Sort-Object Name

function Get-RelativeChapterLink([string]$fileName, [string]$anchor) {
    return "<Chapters/$fileName#$anchor>"
}

foreach ($file in $files) {
    $lines = Get-Content -LiteralPath $file.FullName
    $pendingAnchor = $null
    $chapterTitle = $null
    $chapterAnchor = $null
    $sections = New-Object System.Collections.Generic.List[object]

    foreach ($line in $lines) {
        if ($line -match '^<a id="([^"]+)"></a>$') {
            $pendingAnchor = $Matches[1]
            continue
        }

        if ($line -match '^##\s+(.*)$') {
            $chapterTitle = $Matches[1]
            $chapterAnchor = $pendingAnchor
            $pendingAnchor = $null
            continue
        }

        if ($line -match '^###\s+(.*)$') {
            if ($pendingAnchor) {
                $sections.Add([pscustomobject]@{
                    Title = $Matches[1]
                    Anchor = $pendingAnchor
                })
            }
            $pendingAnchor = $null
            continue
        }

        if ($line -match '^####\s+(.*)$') {
            $pendingAnchor = $null
            continue
        }
    }

    if ($chapterTitle -match '^Chapter\s+(.*)$') {
        $chapterLabel = $Matches[1]
    } else {
        $chapterLabel = $chapterTitle
    }

    Write-Output "- [**$chapterLabel**]($(Get-RelativeChapterLink $file.Name $chapterAnchor))"
    foreach ($section in $sections) {
        Write-Output "  - [$($section.Title)]($(Get-RelativeChapterLink $file.Name $section.Anchor))"
    }
    Write-Output ''
}
