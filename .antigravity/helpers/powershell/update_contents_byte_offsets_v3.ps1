# PowerShell script to replace "(lines A-B)" with "(bytes start-end)" in CONTENTS.md using header anchors
# It builds a map of anchor IDs to byte offsets for each chapter file, then updates the TOC.

$contentsPath = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"
$chapterDir   = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters"

# Build a map: ChapterFile -> AnchorID -> StartByteOffset
$anchorMap = @{}
Get-ChildItem $chapterDir -Filter "Chapter??*.md" | ForEach-Object {
    $fileName = $_.Name
    $filePath = $_.FullName
    $bytesSoFar = 0
    Get-Content $filePath -Encoding UTF8 | ForEach-Object {
        $line = $_
        # Detect anchor tags like <a id="sec-1-2"> or <a id="ch-1">
        if ($line -match "<a id=\"([^"]+)\"") {
            $anchor = $Matches[1]
            if (-not $anchorMap.ContainsKey($fileName)) { $anchorMap[$fileName] = @{} }
            $anchorMap[$fileName][$anchor] = $bytesSoFar
        }
        # Increment byte count (include UTF8 newline)
        $bytesSoFar += [System.Text.Encoding]::UTF8.GetByteCount($line + "`n")
    }
}

# Helper to get end offset for a given anchor (next anchor start -1, or EOF)
function Get-EndOffset($fileName, $anchor) {
    $anchors = $anchorMap[$fileName].Keys | Sort-Object
    $index = $anchors.IndexOf($anchor)
    if ($index -lt 0) { return $null }
    if ($index + 1 -lt $anchors.Count) {
        $nextAnchor = $anchors[$index + 1]
        return $anchorMap[$fileName][$nextAnchor] - 1
    } else {
        # End of file offset = file length - 1
        $fileInfo = Get-Item (Join-Path $chapterDir $fileName)
        return $fileInfo.Length - 1
    }
}

# Process CONTENTS.md line by line and replace line spans
$updatedLines = @()
Get-Content $contentsPath -Encoding UTF8 | ForEach-Object {
    $line = $_
    if ($line -match "\\(lines\\s+\\d+-\\d+\\)") {
        # Extract chapter filename from the markdown link before the dash
        $chapterFile = $null
        if ($line -match "\(([^)#]+)\.md") {
            $chapterFile = $Matches[1] + ".md"
        }
        # Extract the anchor id (the last part after # in the link)
        $anchor = $null
        if ($line -match "#([^)]+)") {
            $fullAnchor = $Matches[1]
            # If there are multiple #'s (e.g., ch-2#sec-2-1), take the last segment
            $parts = $fullAnchor -split "#"
            $anchor = $parts[-1]
        }
        if ($chapterFile -and $anchor -and $anchorMap.ContainsKey($chapterFile) -and $anchorMap[$chapterFile].ContainsKey($anchor)) {
            $start = $anchorMap[$chapterFile][$anchor]
            $end   = Get-EndOffset $chapterFile $anchor
            if ($null -ne $start -and $null -ne $end) {
                $newSpan = "(bytes $start-$end)"
                $line = $line -replace "\\(lines\\s+\\d+-\\d+\\)", $newSpan
            }
        }
    }
    $updatedLines += $line
}

Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "CONTENTS.md updated with byte‑offset spans based on header anchors."
