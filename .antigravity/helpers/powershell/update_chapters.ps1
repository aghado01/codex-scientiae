# PowerShell script to insert internal TOCs into Grimmett2006 chapters
# Assumes files are located in the repository root under codices/Grimmett2006/Chapters
$chapterDir = "D:\aghado01\codex-scientiae\codices\Grimmett2006\Chapters"
$files = Get-ChildItem -Path $chapterDir -Filter "Chapter??.*.md"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    # Split into lines
    $lines = $content -split "`n"
    # Find first line that starts with '# ' (chapter title)
    $h1Index = $lines | Select-Object -Index (0..($lines.Length-1)) | Where-Object { $_ -match '^#\s' } | Select-Object -First 1
    if (-not $h1Index) { continue }
    $h1Idx = [Array]::IndexOf($lines, $h1Index)
    # Collect sections (## headings) and their titles
    $tocLines = @()
    foreach ($i in ($h1Idx+1)..($lines.Length-1)) {
        $line = $lines[$i]
        if ($line -match '^##\s+(\d+\.\d+)\s+(.*)') {
            $secNum = $Matches[1] # e.g., 2.1
            $title = $Matches[2].Trim()
            # Extract chapter number from filename
            if ($file.BaseName -match 'Chapter(\d{2})') {
                $chapNum = $Matches[1].TrimStart('0')
            } else { $chapNum = "?" }
            # Build anchor id pattern used in file: sec-<chap>-<sectionNumber>
            $anchor = "sec-$chapNum-$($secNum -replace '\.', '-')"
            $tocLines += "- [$title](#$anchor)"
        }
    }
    # Build TOC block (insert after H1 heading, add an empty line before and after)
    $tocBlock = @()
    $tocBlock += ""
    $tocBlock += "## Table of Contents"
    $tocBlock += ""
    $tocBlock += $tocLines
    $tocBlock += ""
    # Insert TOC after H1 line
    $newLines = @()
    for ($j=0; $j -le $h1Idx; $j++) { $newLines += $lines[$j] }
    $newLines += $tocBlock
    for ($j=$h1Idx+1; $j -lt $lines.Length; $j++) { $newLines += $lines[$j] }
    # Write back to file
    $newContent = $newLines -join "`n"
    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
    Write-Host "Processed $($file.Name)"
}
