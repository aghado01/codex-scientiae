# PowerShell script to replace page numbers with byte offsets in SubjectIndex.md

$subjectIndexPath = "D:\aghado01\codex-scientiae\codices\Grimmett2006\SubjectIndex.md"
$chapterDir = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters"

# Helper to compute byte offset of a given 1‑based line number in a file (UTF‑8, including newline)
function Get-ByteOffset([string]$filePath, [int]$lineNumber) {
    $bytes = 0
    $current = 1
    Get-Content $filePath -Encoding UTF8 | ForEach-Object {
        if ($current -eq $lineNumber) { return $bytes }
        $bytes += [System.Text.Encoding]::UTF8.GetByteCount($_ + "`n")
        $current++
    }
    return $bytes
}

# Build a map of anchor IDs to byte offsets for each chapter file
$anchorMap = @{}
Get-ChildItem -Path $chapterDir -Filter "Chapter*.md" | ForEach-Object {
    $chapterFile = $_.FullName
    $lines = Get-Content $chapterFile -Encoding UTF8
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        # Match anchors like <a id="sec-1-2"> or <a id="ch-1">
        if ($line -match '<a id="([^\"]+)">') {
            $anchor = $Matches[1]
            $byteOffset = Get-ByteOffset $chapterFile ($i + 1)
            $anchorMap["$($_.Name)|$anchor"] = $byteOffset
        }
    }
    # Store file‑end offset for completeness (not used here)
    $anchorMap["$($_.Name)|__file_end"] = (Get-Item $chapterFile).Length - 1
}

# Read SubjectIndex file
$lines = Get-Content -Path $subjectIndexPath -Encoding UTF8
$updated = @()
foreach ($line in $lines) {
    # Pattern: - term: [<page>](<path#anchor>)
    if ($line -match "^-\s+[^:]+:\s+\[(\d+)\]\(([^)#]+)\.md#([^\)]+)\)") {
        $pageNum = $Matches[1]
        $chapterFile = $Matches[2] + ".md"
        $anchor = $Matches[3]
        $key = "$chapterFile|$anchor"
        if ($anchorMap.ContainsKey($key)) {
            $byteOffset = $anchorMap[$key]
            # Replace the page number with the byte offset
            $newLine = $line -replace "\\[(\d+)\\]", "[$byteOffset]"
            $updated += $newLine
            continue
        }
    }
    $updated += $line
}

# Write back the transformed SubjectIndex.md
Set-Content -Path $subjectIndexPath -Value ($updated -join "`n") -Encoding UTF8
Write-Host "SubjectIndex.md updated: page numbers replaced with byte offsets."
