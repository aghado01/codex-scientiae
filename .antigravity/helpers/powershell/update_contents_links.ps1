# PowerShell script to update CONTENTS.md links to be file-aware for all chapters
$contentsPath = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"

# Read file as lines
$raw = Get-Content $contentsPath -Encoding UTF8 -Raw
$lines = $raw -split "`n"

$updatedLines = @()
$currentChapterFile = $null

foreach ($line in $lines) {
    # Detect chapter header line with file link, e.g., [**1 Random-Cluster Measures**](Chapter01.Random-Cluster%20Measures.md#ch-1)
    if ($line -match '\[\*\*\s*\d+\s+[^\]]*\*\*\]\(([^)]+)') {
        $chapterLink = $Matches[1]
        # Extract filename part after last slash
        $currentChapterFile = $chapterLink.Split('/')[-1]
    }
    # Replace section links that are just #sec-... when we have a current chapter file
    if ($currentChapterFile -and $line -match '\]\(#sec-([\d-]+)\)') {
        $anchor = $Matches[1]
        $newLink = "]($currentChapterFile#sec-$anchor)"
        $line = $line -replace '\]\(#sec-[\d-]+\)', $newLink
    }
    $updatedLines += $line
}

# Write back
Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "Updated CONTENTS.md with full file-aware links."
