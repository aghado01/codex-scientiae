# PowerShell script to replace "(lines A-B)" with "(bytes start-end)" in CONTENTS.md and strip page numbers
$contentsPath = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"
$chapterDir   = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters"

# Helper: compute byte offset of a given 1‑based line number in a file (UTF‑8, including newline)
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

# Read CONTENTS.md line‑by‑line
$updatedLines = @()
Get-Content $contentsPath -Encoding UTF8 | ForEach-Object {
    $line = $_
    # Replace any (lines X-Y) with (bytes startByte-endByte)
    if ($line -match '\(lines\s+(\d+)-(\d+)\)') {
        $startLine = [int]$Matches[1]
        $endLine   = [int]$Matches[2]
        # Extract the chapter markdown filename from the link preceding the dash
        $chapterFile = $null
        if ($line -match '\(([^)#]+)\.md') {
            $chapterFile = $Matches[1] + ".md"
        }
        if ($chapterFile) {
            $fullPath = Join-Path $chapterDir $chapterFile
            if (Test-Path $fullPath) {
                $startByte = Get-ByteOffset $fullPath $startLine
                $endByte   = Get-ByteOffset $fullPath $endLine
                $newSpan = "(bytes $startByte-$endByte)"
                $line = $line -replace '\(lines\s+\d+-\d+\)', $newSpan
            }
        }
    }
    # Strip any stray page number before the byte span, e.g., "— 123 (bytes" -> "— (bytes"
    $line = $line -replace '(—\s+)\d+\s+\(bytes', '$1(bytes'
    $updatedLines += $line
}

# Write back the transformed CONTENTS.md
Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "CONTENTs.md updated: line spans replaced with byte offset spans and page numbers stripped."
