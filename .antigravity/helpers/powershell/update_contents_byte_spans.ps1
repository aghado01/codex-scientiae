# PowerShell script to replace line‑span info with byte‑offset spans in CONTENTS.md
# This script scans each chapter markdown file for anchor tags (<a id="sec-...">) and records the byte offset of each anchor.
# Then it rewrites the corresponding entries in CONTENTS.md, replacing "(lines X‑Y)" with "(bytes start‑end)".

$contentsPath = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters\CONTENTS.md"
$chapterDir   = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\codices\Grimmett2006\Chapters"

# Load CONTENTS.md as a single string and split into lines
$contentsRaw   = Get-Content $contentsPath -Encoding UTF8 -Raw
$contentsLines = $contentsRaw -split "`n"

# Helper: compute byte offset of a given line index within a file (0‑based)
function Get-ByteOffset([string]$filePath, [int]$targetLine) {
    $bytes = 0
    $i = 0
    Get-Content $filePath -Encoding UTF8 | ForEach-Object {
        if ($i -eq $targetLine) { return $bytes }
        $bytes += [System.Text.Encoding]::UTF8.GetByteCount($_ + "`n")
        $i++
    }
    return $bytes
}

# Build a map: chapter filename -> anchor id -> byte offset (start of line containing the anchor)
$anchorMap = @{}
Get-ChildItem $chapterDir -Filter "Chapter??*.md" | ForEach-Object {
    $fileName = $_.Name
    $filePath = $_.FullName
    $lines    = Get-Content $filePath -Encoding UTF8
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match '<a id="(sec-[0-9-]+)"') {
            $anchor = $Matches[1]
            $offset = Get-ByteOffset $filePath $i
            if (-not $anchorMap.ContainsKey($fileName)) { $anchorMap[$fileName] = @{} }
            $anchorMap[$fileName][$anchor] = $offset
        }
    }
}

# Update CONTENTS.md lines
$updatedLines = @()
foreach ($line in $contentsLines) {
    # Detect the "(lines X-Y)" pattern
    if ($line -match '\(lines\s+\d+-\d+\)') {
        # Try to extract the chapter filename from the markdown link before the dash
        $chapterFile = $null
        if ($line -match '\(([^)#]+)\.md') {
            $chapterFile = $Matches[1] + ".md"
        }
        # Extract the anchor id (sec-...)
        $anchor = $null
        if ($line -match '#(sec-[0-9-]+)') {
            $anchor = $Matches[1]
        }
        if ($chapterFile -and $anchor -and $anchorMap.ContainsKey($chapterFile) -and $anchorMap[$chapterFile].ContainsKey($anchor)) {
            $start = $anchorMap[$chapterFile][$anchor]
            # Determine end offset: next anchor in same file, or EOF
            $sortedAnchors = $anchorMap[$chapterFile].Keys | Sort-Object
            $next = $sortedAnchors | Where-Object { $_ -gt $anchor } | Select-Object -First 1
            if ($next) {
                $end = $anchorMap[$chapterFile][$next] - 1
            } else {
                $end = (Get-Item "$chapterDir\\$chapterFile").Length - 1
            }
            $newSpan = "(bytes $start-$end)"
            $line = $line -replace '\(lines\s+\d+-\d+\)', $newSpan
        }
    }
    $updatedLines += $line
}

# Write updated CONTENTS.md back to disk
Set-Content -Path $contentsPath -Value ($updatedLines -join "`n") -Encoding UTF8
Write-Host "CONTENTs.md updated with byte‑offset spans."
