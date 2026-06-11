param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_intertext_collapse.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.intertext.collapse.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Encoding UTF8
# find $$ blocks
$blocks = @(); $in=$false; $start=-1
for ($i=0;$i -lt $txt.Count;$i++){
    if ($txt[$i] -match '\$\$'){
        if (-not $in){ $in=$true; $start=$i } else { $in=$false; $blocks += ,@{start=$start;end=$i}; $start=-1 }
    }
}
foreach ($blk in ($blocks | Sort-Object start -Descending)){
    $s=$blk.start; $e=$blk.end
    $math = $txt[$s..$e]
    $newMath = @()
    $prevInter = $null
    for ($j=0;$j -lt $math.Count;$j++){
        $line = $math[$j]
        if ($line -match '\\intertext\{(.*)\}'){
            $inner = $matches[1]
            if ($prevInter -ne $null -and $prevInter -eq $inner){
                # skip duplicate
                continue
            } else {
                $newMath += $line
                $prevInter = $inner
            }
        } else {
            $newMath += $line
            $prevInter = $null
        }
    }
    # splice back
    $before = $txt[0..($s-1)]; $after = $txt[($e+1)..($txt.Count-1)]
    $txt = $before + $newMath + $after
}
Set-Content -LiteralPath $Path -Value ($txt -join "`n") -Encoding UTF8
Write-Output "intertext-collapse-applied; backup: $backup"
