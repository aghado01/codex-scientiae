# PowerShell script to replace "(lines A-B)" with "(bytes start-end)" in CONTENTS.md
# It uses anchor tags (<a id="...">) in chapter files to compute byte offsets.

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
        # Match anchor tags like <a id="sec-1-2"> or <a id="ch-1">
        if ($line -match '<a id="([^\"]+)">') {
            $anchor = $Matches[1]
            if (-not $anchorMap.ContainsKey($fileName)) { $anchorMap[$fileName] = @{} }
            $anchorMap[$fileName][$anchor] = $bytesSoFar
        }
        # Increment byte count (include newline as UTF8 \n)
        $bytesSoFar += [System.Text.Encoding]::UTF8.GetByteCount($line + "`n")
    }
}

function Get-EndOffset($fileName, $anchor) {
    $anchors = $anchorMap[$fileName].Keys | Sort-Object
    $idx = $anchors.IndexOf($anchor)
    if ($idx -lt 0) { return $null }
    if ($idx + 1 -lt $anchors.Count) {
        $next = $anchors[$idx + 1]
        return $anchorMap[$fileName][$next] - 1
    } else {
        # End of file offset = file length - 1
        $fileInfo = Get-Item (Join-Path $chapterDir $fileName)
        return $fileInfo.Length - 1
    }
}

# Process CONTENTS.md and replace line spans
$updatedLines = @()
Get-Content $contentsPath -Encoding UTF8 | ForEach-Object {
    $line = $_
    if ($line -match '\\(lines\\s+\\d+-\\d+\\)') {
        # Extract chapter filename from markdown link (decode %20)
        $chapterFile = $null
        if ($line -match '\\(([^)#]+)\\.md') {
            $raw = $Matches[1]
            $decoded = $raw -replace "%20", " "
            $chapterFile = $decoded + ".md"
        }
        # Extract anchor id after the last '#'
        $anchor = $null
        if ($line -match '#([^\)]+)') {
            $full = $Matches[1]
            $parts = $full -split "#"
            $anchor = $parts[-1]
        }
        if ($chapterFile -and $anchor -and $anchorMap.ContainsKey($chapterFile) -and $anchorMap[$chapterFile].ContainsKey($anchor)) {
            $start = $anchorMap[$chapterFile][$anchor]
            $end   = Get-EndOffset $chapterFile $anchor
            if ($null -ne $start -and $null -ne $end) {
                $newSpan = "(bytes $start-$end)"
                $line = $line -replace '\\(lines\\s+\\d+-\\d+\\)', $newSpan
            }
        }
    }
    $updatedLines += $line
}

Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "CONTENTS.md updated with byte‑offset spans based on header anchors."
