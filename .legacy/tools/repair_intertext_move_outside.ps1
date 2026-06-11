param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_intertext_move_outside.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.intertext.moveout.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$lines = Get-Content -LiteralPath $Path -Encoding UTF8
function norm($s){ if ($null -eq $s) { return $null }; return ($s -replace '\\','' -replace '\s+',' ' -replace '[^0-9A-Za-z \-\,\:\;]','' ).Trim() }
# find $$ blocks
$blocks = @(); $in=$false; $start=-1
for ($i=0;$i -lt $lines.Count;$i++){
    if ($lines[$i] -match '\$\$'){
        if (-not $in){ $in=$true; $start=$i } else { $in=$false; $blocks += ,@{start=$start;end=$i}; $start=-1 }
    }
}
# process from bottom up
foreach ($blk in ($blocks | Sort-Object start -Descending)){
    $s = $blk.start; $e = $blk.end
    $math = $lines[$s..$e]
    $intertexts = @()
    for ($j=0;$j -lt $math.Count;$j++){
        $ml = $math[$j]
        if ($ml -match '\\intertext\{(.*)\}'){
            $inner = $matches[1].Trim()
            $intertexts += ,@{idx=$j; raw=$inner; n=norm($inner)}
        }
    }
    if ($intertexts.Count -eq 0) { continue }
    # remove intertext lines from math
    $newMath = @()
    for ($j=0;$j -lt $math.Count;$j++){ if (($intertexts | Where-Object {$_.idx -eq $j}).Count -gt 0) { continue } ; $newMath += $math[$j] }
    # find next non-empty line after block
    $nextLineIndex = $e + 1
    $nextNonEmpty = $null
    for ($k=$nextLineIndex; $k -lt $lines.Count; $k++){ if ($lines[$k].Trim() -ne '') { $nextNonEmpty = $lines[$k].Trim(); break } }
    $nextNorm = norm($nextNonEmpty)
    $toInsert = @()
    foreach ($it in $intertexts){
        $shouldInsert = $true
        if ($nextNonEmpty -ne $null){
            if ($it.n -ne $null -and $nextNorm -ne $null){
                if ($nextNorm -eq $it.n -or $nextNorm.Contains($it.n) -or $it.n.Contains($nextNorm)) { $shouldInsert = $false }
                else {
                    $a = $it.n.Split(' ') | Where-Object {$_ -ne ''}
                    $b = $nextNorm.Split(' ') | Where-Object {$_ -ne ''}
                    $intersect = @(($a | Where-Object { $b -contains $_ }) ).Count
                    $union = @((,$a + ,$b) | Sort-Object -Unique).Count
                    if ($union -gt 0){ $score = $intersect / $union } else { $score = 0 }
                    if ($score -ge 0.8) { $shouldInsert = $false }
                }
            }
        }
        if ($shouldInsert){ $toInsert += $it.raw }
    }
    # splice back newMath into lines
    $before = $lines[0..($s-1)]
    $after = $lines[($e+1)..($lines.Count-1)]
    $lines = $before + $newMath + $after
    # insert toInsert after the block position (which is at index $s + ($newMath.Count - originalBlockLen?) but simpler: find insertion index as position of the first line from $after in current lines
    # find where the original next line (at index $e+1 in original) ended up: search for first occurrence of $after[0] in the tail starting at $s + $newMath.Count
    $insertPos = $s + $newMath.Count
    if ($toInsert.Count -gt 0){
        # insert as plain text lines separated by blank line
        $ins = @('') + ($toInsert | ForEach-Object { $_ }) + @('')
        $lines = $lines[0..($insertPos-1)] + $ins + $lines[$insertPos..($lines.Count-1)]
    }
}
Set-Content -LiteralPath $Path -Value ($lines -join "`n") -Encoding UTF8
Write-Output "intertext-moveout-applied; backup: $backup"
