# PowerShell script to set each chapter's parent byte span to the full file size
$contentsPath = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"
$chapterDir   = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters"

# Read all lines of the TOC
$lines = Get-Content $contentsPath -Encoding UTF8

# Get all chapter markdown files (excluding CONTENTS.md itself)
$chapterFiles = Get-ChildItem $chapterDir -Filter "Chapter*.md" | Where-Object { $_.Name -ne "CONTENTS.md" }

foreach ($ch in $chapterFiles) {
    $size = $ch.Length
    # Build a regex that matches the parent entry for this chapter
    # Example line: [**1 Random-Cluster Measures**](Chapter01.Random-Cluster%20Measures.md#ch-1) — (bytes 0-955)
    $escapedName = [regex]::Escape($ch.Name)
    $pattern = "\\[\\*\\*\\d+ [^\\*]+\\*\\*\\]\\($escapedName#ch-\\d+\\) — \(bytes 0-\\d+\)"
    # Replacement uses the same captured groups but updates the end byte
    $replacement = "[**$($ch.BaseName.Replace('.md',''))**]($($ch.Name)#ch-1) — (bytes 0-$size)"
    # Actually we need to keep the original chapter number and title; easier: replace the byte range only
    $lines = $lines -replace "(\\[\\*\\*\\d+ [^\\*]+\\*\\*\\]\\($escapedName#ch-\\d+\\) — \(bytes 0-)(\\d+)(\))", "`$1$size`$3"
}

# Write back the modified lines
Set-Content -Path $contentsPath -Value $lines -Encoding UTF8
Write-Host "Parent chapter byte spans updated to full file sizes."
