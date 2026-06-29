param(
    [string]$repoRoot = "d:\\aghado01\\codex-scientiae"
)

# Resolve absolute paths
$repoRoot = Resolve-Path $repoRoot
$chaptersDir = Join-Path $repoRoot "codices\\Grimmett2006\\Chapters"
$contentsPath = Join-Path $chaptersDir "CONTENTS.md"

# Read all lines of CONTENTS.md
$contentsLines = Get-Content $contentsPath -Encoding UTF8

# Iterate through each chapter markdown file
Get-ChildItem -Path $chaptersDir -Filter "Chapter*.md" | ForEach-Object {
    $chapterFile = $_
    $fileName = $chapterFile.Name
    if ($fileName -match "Chapter(\d{2})") {
        $num = [int]$matches[1]
        $size = $chapterFile.Length - 1   # end byte (0‑based)
        $newSpan = "— (bytes 0-$size)"
        # Find the line containing the chapter link in CONTENTS.md
        for ($i = 0; $i -lt $contentsLines.Count; $i++) {
            if ($contentsLines[$i] -match "\\[\\*\\*${num} ") {
                $contentsLines[$i] = $contentsLines[$i] -replace "— \(bytes [^)]*\)", $newSpan
                break
            }
        }
    }
}

# Write updated lines back to CONTENTS.md
Set-Content -Path $contentsPath -Value $contentsLines -Encoding UTF8
Write-Host "Updated chapter byte spans in $contentsPath"
