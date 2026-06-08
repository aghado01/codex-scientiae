# PowerShell script to replace "(lines A-B)" with "(bytes start-end)" in CONTENTS.md using header anchors, handling URL-encoded spaces
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
        if ($line -match "<a id=\"([^\"]+)\"") {
            $anchor = $Matches[1]
            if (-not $anchorMap.ContainsKey($fileName)) { $anchorMap[$fileName] = @{} }
            $anchorMap[$fileName][$anchor] = $bytesSoFar
        }
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
        $fileInfo = Get-Item (Join-Path $chapterDir $fileName)
        return $fileInfo.Length - 1
    }
}

$updatedLines = @()
Get-Content $contentsPath -Encoding UTF8 | ForEach-Object {
    $line = $_
    if ($line -match "\\(lines\\s+\\d+-\\d+\\)") {
        # Extract chapter filename (decode %20 to space)
        $chapterFile = $null
        if ($line -match "\(([^)#]+)\.md") {
            $raw = $Matches[1]
            $decoded = $raw -replace "%20", " "
            $chapterFile = $decoded + ".md"
        }
        # Extract anchor id after the last #
        $anchor = $null
        if ($line -match "#([^\)]+)") {
            $full = $Matches[1]
            $parts = $full -split "#"
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
Write-Host "CONTENTS.md byte‑offset spans updated (URL‑decoded filenames)."
