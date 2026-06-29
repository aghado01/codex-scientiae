# PowerShell script to replace "(lines X-Y)" with "(bytes start-end)" in CONTENTS.md
# It builds a map of section anchors to byte offsets for each chapter file.

$contentsPath = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"
$chapterDir   = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters"

# Build anchor -> byte offset map per chapter file
$anchorMap = @{}
Get-ChildItem $chapterDir -Filter "Chapter??*.md" | ForEach-Object {
    $fileName = $_.Name
    $filePath = $_.FullName
    $bytesSoFar = 0
    $lineIndex = 0
    Get-Content $filePath -Encoding UTF8 | ForEach-Object {
        $line = $_
        # Look for anchor of the form <a id="sec-...">
        if ($line -match '<a id="(sec-[0-9-]+)"') {
            $anchor = $Matches[1]
            if (-not $anchorMap.ContainsKey($fileName)) { $anchorMap[$fileName] = @{} }
            $anchorMap[$fileName][$anchor] = $bytesSoFar
        }
        # Update byte count (include newline)
        $bytesSoFar += [System.Text.Encoding]::UTF8.GetByteCount($line + "`n")
        $lineIndex++
    }
}

# Helper to get end offset (next anchor or eof)
function Get-EndOffset($fileName, $anchor) {
    $anchors = $anchorMap[$fileName].Keys | Sort-Object
    $next = $anchors | Where-Object { $_ -gt $anchor } | Select-Object -First 1
    if ($next) {
        return $anchorMap[$fileName][$next] - 1
    } else {
        # EOF offset is file length - 1
        $fileInfo = Get-Item (Join-Path $chapterDir $fileName)
        return $fileInfo.Length - 1
    }
}

# Process CONTENTS.md line by line
$updatedLines = @()
Get-Content $contentsPath -Encoding UTF8 | ForEach-Object {
    $line = $_
    if ($line -match '\(lines\s+\d+-\d+\)') {
        # Extract chapter filename from the link preceding the dash
        if ($line -match '\(([^)#]+)\.md') {
            $chapterFile = $Matches[1] + ".md"
        } else { $chapterFile = $null }
        # Extract anchor id (sec-...)
        $anchor = $null
        if ($line -match '#(sec-[0-9-]+)') { $anchor = $Matches[1] }
        if ($chapterFile -and $anchor -and $anchorMap.ContainsKey($chapterFile) -and $anchorMap[$chapterFile].ContainsKey($anchor)) {
            $start = $anchorMap[$chapterFile][$anchor]
            $end   = Get-EndOffset $chapterFile $anchor
            $newSpan = "(bytes $start-$end)"
            $line = $line -replace '\(lines\s+\d+-\d+\)', $newSpan
        }
    }
    $updatedLines += $line
}

# Write back to CONTENTS.md
Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "CONTENTs.md updated with byte‑offset spans."
