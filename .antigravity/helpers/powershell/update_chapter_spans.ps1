param(
    [string]$repoRoot = "d:\\aghado01\\codex-scientiae"
)

$repoRoot = Resolve-Path $repoRoot
$chaptersDir = Join-Path $repoRoot "codices\\Grimmett2006\\Chapters"
$contentsPath = Join-Path $chaptersDir "CONTENTS.md"

# Load file lines
$contentsLines = Get-Content $contentsPath -Encoding UTF8

# Process each chapter file
Get-ChildItem -Path $chaptersDir -Filter "Chapter*.md" | ForEach-Object {
    $file = $_
    if ($file.Name -match "Chapter(\d{2})") {
        $chapterNum = [int]$matches[1]
        $endByte = $file.Length - 1
        $newSpan = "— (bytes 0-$endByte)"
        # Find the line in CONTENTS.md that defines this chapter
        for ($i = 0; $i -lt $contentsLines.Count; $i++) {
            if ($contentsLines[$i] -match "\[\*\*${chapterNum} ") {
                # Replace any existing byte span
                $contentsLines[$i] = $contentsLines[$i] -replace "— \(bytes [^)]*\)", $newSpan
                break
            }
        }
    }
}

# Write back
Set-Content -Path $contentsPath -Value $contentsLines -Encoding UTF8
Write-Host "Chapter byte spans updated in $contentsPath"
