param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_intertext_fuzzy.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.intertext.fuzzy.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Encoding UTF8
function norm($s){ if ($null -eq $s) { return $s }; return ($s -replace '\\','' -replace '\s+',' ' -replace '[^0-9A-Za-z ]','' ).Trim().ToLower() }
# find $$ blocks
$blocks = @()
$in = $false; $start=-1
for ($i=0;$i -lt $txt.Count;$i++){
    if ($txt[$i] -match '\$\$'){
        if (-not $in){ $in=$true; $start=$i } else { $in=$false; $blocks += ,@{start=$start;end=$i}; $start=-1 }
    }
}
foreach ($blk in ($blocks | Sort-Object start -Descending)){
    $s = $blk.start; $e = $blk.end
    $math = $txt[$s..$e]
    # collect intertext entries
    $inter = @()
    for ($j=0;$j -lt $math.Count;$j++){
        if ($math[$j] -match '\\intertext\{(.*)\}'){
            $inter += ,@{idx=$j; raw=$matches[1]; norm=norm($matches[1])}
        }
    }
    if ($inter.Count -eq 0) { continue }
    # find next non-empty outside line
    $next = $null
    for ($k=$e+1;$k -lt $txt.Count;$k++){ if ($txt[$k].Trim() -ne '') { $next=$txt[$k]; break } }
    if ($null -eq $next) { continue }
    $nextNorm = norm($next)
    $toRemove = @()
    foreach ($it in $inter){
        if ($it.norm -ne '' -and $nextNorm -ne ''){
            # simple equality or contains
            if ($nextNorm -eq $it.norm -or $nextNorm.Contains($it.norm) -or $it.norm.Contains($nextNorm)){
                $toRemove += $it.idx
            } else {
                # fuzzy similarity: Jaccard on word sets
                $a = $it.norm.Split(' ') | Where-Object {$_ -ne ''}
                $b = $nextNorm.Split(' ') | Where-Object {$_ -ne ''}
                $intersect = @(($a | Where-Object { $b -contains $_ }) ).Count
                $union = @((,$a + ,$b) | Sort-Object -Unique).Count
                if ($union -gt 0){ $score = $intersect / $union } else { $score = 0 }
                if ($score -ge 0.8) { $toRemove += $it.idx }
            }
        }
    }
    if ($toRemove.Count -gt 0){
        $newMath = @()
        for ($j=0;$j -lt $math.Count;$j++){ if ($toRemove -contains $j) { continue } ; $newMath += $math[$j] }
        # splice back
        $before = $txt[0..($s-1)]
        $after = $txt[($e+1)..($txt.Count-1)]
        $txt = $before + $newMath + $after
    }
}
Set-Content -LiteralPath $Path -Value ($txt -join "`n") -Encoding UTF8
Write-Output "intertext-fuzzy-applied; backup: $backup"
