# PowerShell script to replace "(lines A-B)" with "(bytes start-end)"
# and to normalise dash/byte‑span formatting in CONTENTS.md.

$contentsPath = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"
$chapterDir   = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters"

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

# Keep track of the most recent chapter file (used when only an anchor "#ch-X" appears)
$lastChapterFile = $null

$updatedLines = @()
Get-Content $contentsPath -Encoding UTF8 | ForEach-Object {
    $line = $_

    # Detect a top‑level chapter header to set $lastChapterFile
    if ($line -match '^\s*\[\*\*(\d+).+?\]\(([^)]+)\)') {
        $lastChapterFile = $Matches[2]  # e.g. Chapter03.Fundamental%20Properties.md
    }

    # Replace "(lines A-B)" with "(bytes start-end)" when we can locate the file
    if ($line -match '\\(lines\\s+(\\d+)-(\\d+)\\)') {
        $startLine = [int]$Matches[1]
        $endLine   = [int]$Matches[2]

        # Try to extract a filename from the markdown link preceding the dash
        $chapterFile = $null
        if ($line -match '\\(([^)#]+)\\.md') {
            $chapterFile = $Matches[1] + ".md"
        } elseif ($lastChapterFile) {
            $chapterFile = $lastChapterFile
        }

        if ($chapterFile) {
            $fullPath = Join-Path $chapterDir $chapterFile
            if (Test-Path $fullPath) {
                $startByte = Get-ByteOffset $fullPath $startLine
                $endByte   = Get-ByteOffset $fullPath $endLine
                $newSpan = "(bytes $startByte-$endByte)"
                $line = $line -replace '\\(lines\\s+\\d+-\\d+\\)', $newSpan
            }
        }
    }

    # Strip stray page numbers before byte spans (e.g. "— 123 (bytes …")
    $line = $line -replace '—\s+\d+\s+\(bytes', '— (bytes'

    # Normalise dash style and remove duplicate hyphens
    $line = $line -replace '---', '—'
    $line = $line -replace '–', '—'

    $updatedLines += $line
}

Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "CONTENTS.md updated: line‑spans replaced, dash normalised, and page numbers stripped."
