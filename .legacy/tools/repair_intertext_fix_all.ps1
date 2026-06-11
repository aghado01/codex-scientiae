param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_intertext_fix_all.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.intertext.fixall.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$lines = Get-Content -LiteralPath $Path -Encoding UTF8
function normalize($s){ if ($null -eq $s) { return $null }; return ($s -replace '\\','' -replace '\s+',' ' ).Trim().ToLower() }
# find $$ blocks
$blocks = @(); $in=$false; $start=-1
for ($i=0;$i -lt $lines.Count;$i++){
    if ($lines[$i] -match '^\s*\$\$'){
        if (-not $in){ $in=$true; $start=$i } else { $in=$false; $blocks += ,@{start=$start;end=$i}; $start=-1 }
    }
}
# Process from bottom up
foreach ($blk in ($blocks | Sort-Object start -Descending)){
    $s = $blk.start; $e = $blk.end
    $math = $lines[$s..$e]
        $innerList = @()
        for ($j=0;$j -lt $math.Count;$j++){
            $line = $math[$j]
            $matches = [regex]::Matches($line, 'intertext\{(.*?)\}')
            if ($matches.Count -gt 0){
                foreach ($m in $matches){
                    $inner = $m.Groups[1].Value.Trim()
                    $innerList += ,@{idx=$j; raw=$inner; norm=normalize($inner)}
                }
                # remove any intertext{...} occurrences (allow optional leading backslashes and surrounding spaces)
                $line = [regex]::Replace($line, '\s*\\*intertext\{.*?\}\s*', ' ')
            }
            $math[$j] = $line.TrimEnd()
        }
        if ($innerList.Count -eq 0) { continue }
        # New math block with intertext substrings removed
        $newMath = $math
    # Determine insertion point (after block)
    $afterIdx = $e + 1
    # find next non-empty outside line
    $nextNonEmpty = $null; $nextIdx = $null
    for ($k=$afterIdx; $k -lt $lines.Count; $k++){ if ($lines[$k].Trim() -ne '') { $nextNonEmpty = $lines[$k].Trim(); $nextIdx=$k; break } }
    $nextNorm = normalize($nextNonEmpty)
    $toInsert = @()
    foreach ($it in $innerList){
        $shouldInsert = $true
        if ($nextNonEmpty -ne $null -and $it.norm -ne $null -and $nextNorm -ne $null){
            if ($nextNorm -eq $it.norm -or $nextNorm.Contains($it.norm) -or $it.norm.Contains($nextNorm)) { $shouldInsert = $false }
            else {
                $a = $it.norm.Split(' ') | Where-Object {$_ -ne ''}
                $b = $nextNorm.Split(' ') | Where-Object {$_ -ne ''}
                $intersect = @(($a | Where-Object { $b -contains $_ }) ).Count
                $union = @((,$a + ,$b) | Sort-Object -Unique).Count
                if ($union -gt 0){ $score = $intersect / $union } else { $score = 0 }
                if ($score -ge 0.8) { $shouldInsert = $false }
            }
        }
        if ($shouldInsert){ $toInsert += $it.raw }
    }
    # Replace math block with newMath
    $before = $lines[0..($s-1)]
    $after = $lines[($e+1)..($lines.Count-1)]
    $lines = $before + $newMath + $after
    # Compute insertion position: it's the index where $after[0] now sits, which is $s + $newMath.Count
    $insertPos = $s + $newMath.Count
    if ($toInsert.Count -gt 0){
        $ins = @('') + ($toInsert | ForEach-Object { $_ }) + @('')
        if ($insertPos -ge $lines.Count){ $lines = $lines + $ins } else { $lines = $lines[0..($insertPos-1)] + $ins + $lines[$insertPos..($lines.Count-1)] }
    }
}
# Final pass: remove any empty intertext lines and collapse consecutive blank lines
for ($i=0;$i -lt $lines.Count;$i++){ if ($lines[$i] -match '\\intertext\{\s*\}') { $lines[$i]='' } }
# collapse triple newlines to max two
$txt = ($lines -join "`n") -replace "`n{3,}", "`n`n"
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "intertext-fixall-applied; backup: $backup"
