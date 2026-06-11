param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_intertext_move.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.intertext.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$lines = Get-Content -LiteralPath $Path -Encoding UTF8
$out = @()
$inMath = $false
$mathBuf = @()
function flushMath {
    param($mathBufRef)
    if ($mathBufRef.Count -eq 0) { return @() }
    $modified = $false
    $newMath = @()
    for ($i=0;$i -lt $mathBufRef.Count;$i++) {
        $line = $mathBufRef[$i]
        if ($line -match '\\intertext\{(.*)\}') {
            $inner = $matches[1].Trim()
            # lookahead: check next non-empty line after math block in original file (we'll inspect later)
            $newMath += $line # keep for now; marker for later pass
        } else {
            $newMath += $line
        }
    }
    return $newMath
}
# Stage 1: locate math blocks delimited by $$ and collect spans with intertext
$blocks = @()
$curStart = -1
for ($i=0;$i -lt $lines.Count;$i++) {
    $l = $lines[$i]
    if ($l -match '\$\$') {
        if ($curStart -eq -1) { $curStart = $i } else {
            $blocks += ,@{start=$curStart; end=$i}
            $curStart = -1
        }
    }
}
# Process each block from last to first so we can modify safely
foreach ($blk in ($blocks | Sort-Object -Property start -Descending)) {
    $s = $blk.start; $e = $blk.end
    $math = $lines[$s..$e]
    # find intertext occurrences and their inner text
    $inter = @()
    for ($j=0;$j -lt $math.Count;$j++) {
        $ml = $math[$j]
        if ($ml -match '\\intertext\{(.*)\}') {
            $inner = $matches[1].Trim()
            $inter += ,@{idx=$j; text=$inner}
        }
    }
    if ($inter.Count -eq 0) { continue }
    # For each intertext entry, check following line after block in original file
    $afterLineIndex = $e + 1
    # get next non-empty line (trimmed)
    $nextNonEmpty = $null
    for ($k=$afterLineIndex; $k -lt $lines.Count; $k++) {
        if ($lines[$k].Trim() -ne '') { $nextNonEmpty = $lines[$k].Trim(); break }
    }
    # If next non-empty equals any intertext inner text, remove those intertext occurrences from math
    $toRemoveIdx = @()
    foreach ($it in $inter) {
        if ($nextNonEmpty -ne $null -and $nextNonEmpty -eq $it.text) {
            $toRemoveIdx += $it.idx
        }
    }
    if ($toRemoveIdx.Count -gt 0) {
        # remove lines at indices from math array
        $newMath = @()
        for ($j=0;$j -lt $math.Count;$j++) {
            if ($toRemoveIdx -contains $j) { continue }
            $newMath += $math[$j]
        }
        # write back into lines
        for ($j=0;$j -lt $newMath.Count;$j++) { $lines[$s + $j] = $newMath[$j] }
        # if newMath shorter than original block, remove extra lines
        $origLen = $e - $s + 1
        if ($newMath.Count -lt $origLen) {
            $removeCount = $origLen - $newMath.Count
            $lines = $lines[0..($s + $newMath.Count -1)] + $lines[($e+1)..($lines.Count-1)]
        }
    }
}
# Final cleanup: remove empty \intertext{} lines inside math blocks
for ($i=0;$i -lt $lines.Count;$i++) {
    if ($lines[$i] -match '\$\$') { # math delimiter toggle
        # do nothing, handled above
    }
    if ($lines[$i] -match '\\intertext\{\s*\}') {
        $lines[$i] = ''
    }
}
Set-Content -LiteralPath $Path -Value ($lines -join "`n") -Encoding UTF8
Write-Output "intertext-dedup-applied; backup: $backup"
