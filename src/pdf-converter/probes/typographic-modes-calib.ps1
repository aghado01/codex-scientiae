#requires -Version 7
<#
  probes/typographic-modes-calib.ps1 — per-document typographic mode discovery (truffle stage-0).

  Question: do a document's line-level typographic features form CRISP, STABLY SEPARABLE
  density modes — the precondition for the semi-supervised role-classification lane
  (cluster-canonicalize -> tree-classify, working name "truffle")? Two readouts, SPC-style:

    crispness   noise fraction + mean membership probability + cluster purity against
                (a) the discrete font|size tuple truth and (b) pig's own node `type` guess
                (prose / marker / heading-candidate / formula-block).
    plateau     cluster-count-vs-merge-distance curve off the single-linkage dendrogram —
                the analog of SPC's superparamagnetic window: a wide distance range where
                the count of size>=k clusters holds constant. Widths in log10(d).

  Method: per paper, read the newest pig run's nodes.jsonl; per node extract an INTRINSIC
  typographic vector — no page geometry: size (pt), thickness (bbox extent perpendicular to
  reading direction; rotated_text flips the axis), and weight/slant/family axes parsed from
  the font name (bold / italic / math / mono), each scaled to $FlagWeightPt so one style flip
  ~ a 2pt size step under euclidean. hdbscan.exe (min-pts 5, min-cluster-size 8) clusters
  each document independently; partition + dendrogram + evaluator scores read back.

  Falsifier contract (predeclared): CRISP+PLATEAU = low noise (<~15%), high tuple purity
  (>~0.9), and a dominant non-trivial plateau -> build the lane on cluster-relative features.
  MUSH = high noise / smeared purity / no plateau -> re-scope to raw-feature trees and route
  more residue to the membrane's semantic tier.

    pwsh -File probes/typographic-modes-calib.ps1

  Iteration record:
    v1  2026-07-17 (size+thick+flags, 6 papers, 4 corpora): CRISP confirmed hard — noise
        1.3–9.3%, mean membership 0.95–1.00, font|size-tuple purity 0.92–0.995 (even
        spc/Domany1999, 1990s typography). BUT cluster counts run 2–4x the tuple counts
        (162 clusters / 48 tuples on 2111.15058v3): bbox THICKNESS micro-quantizes
        (~0.01pt clumps) and fragments same-tuple lines. Purity survives (fragments stay
        tuple-pure) but the mode level is over-resolved; dominant plateaus sit at d≈0.01pt
        (quantization artifacts), role-level structure only at d≈2–5pt.
    v2  2026-07-17 (-DropThickness — pure size+style-axes space): the mode level emerges.
        9–24 clusters/doc, noise 0.1–3.1%, membership 1.000, wide SPC-style windows at the
        mode count (2111: c=24 stable d 0.10→0.60, log-width 0.78; 1705: c=13 w=0.48;
        kisungyou: c=14 w=0.54). Modes read as roles: body roman / math italic / CMBX bold
        (heading material, 96–100% pure) / CMTI italic / CMR8 footnote / tiny
        Helvetica-DejaVu-Arial figure-axis labels / Times-20 rotated arXiv stamp. Tuple
        purity drops (0.69–0.96) for the RIGHT reason: co-occurring math fonts
        (TeX-matha/CMSY/CMEX at same size) merge into one math-furniture mode.
    VERDICT (locked): CRISP + PLATEAU — the truffle precondition HOLDS across eras and
        class files. Two-scale structure is real: micro = font|size tuples (v1, ~0.99
        pure), macro = role-shaped modes (v2, 9–24/doc, wide plateaus) — the condensed
        tree carries both, so cluster-relative canonicalization has a stable substrate.
        Pig-type NMI stays low (0.02–0.11): modes are FINER than roles — unsupervised
        alone does not yield roles; it canonicalizes for the supervised layer (as
        designed). Thickness: drop as a clustering feature, keep downstream (display-math
        signal). Next: cluster-relative features + oracle-labeled role trees (stage 1).
#>
[CmdletBinding()]
param(
    [string[]] $PaperSpecs = @(
        'ph-zigzag/2111.15058v3',    # modern, Utopia text + CM math
        'ph-zigzag/2603.03037v1',    # small, classic CM
        'voroninski/1611.03935v1',   # PhaseMax demo-clean paper
        'voroninski/1705.07576v3',   # 12k-line stress case
        'spc/Domany1999',            # 1990s physics typography
        'kisungyou/2106.02096v3'     # stats/software class file
    ),
    [int]    $MinPts = 5,
    [int]    $MinClusterSize = 8,
    [double] $FlagWeightPt = 2.0,
    [switch] $DropThickness,     # v2: exclude bbox thickness — pure (size, style-axes) space
    [string] $OutRoot = (Join-Path ([IO.Path]::GetTempPath()) 'truffle-modes-calib')
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/../src/shared/runs.ps1"
. "$PSScriptRoot/../src/hdbscan/Invoke-Hdbscan.ps1"

$inv = [System.Globalization.CultureInfo]::InvariantCulture
$root = (Resolve-Path (Join-Path $PSScriptRoot '../ingestion/gauntlet')).Path

# font-name -> style axes. CM families matched ordinal (CMBX/CMTI/CMMI...); generic words
# case-insensitively. CMMI counts as math, not italic, to keep the axes independent.
$rxMath = [regex]::new('CMMI|CMSY|CMEX|CMBSY|MSAM|MSBM|EUF|EUS|RSFS|STMARY|WASY|Math', 'IgnoreCase')
$rxBold = [regex]::new('CMBX|CMB[0-9]|Bold|Heavy|Black', 'IgnoreCase')
$rxItal = [regex]::new('CMTI|CMU[0-9]|Italic|Oblique|Slanted', 'IgnoreCase')
$rxMono = [regex]::new('CMTT|Mono|Courier|Typewriter', 'IgnoreCase')

$rxType = [regex]::new('"type":"([^"]+)"')
$rxFont = [regex]::new('"font":"([^"]+)"')
$rxSize = [regex]::new('"font size":\s*([0-9.]+)')
$rxBbox = [regex]::new('"bounding box":\[([^\]]+)\]')

$results = [System.Collections.Generic.List[object]]::new()

foreach ($spec in $PaperSpecs) {
    $corpus, $slug = $spec -split '/', 2
    $paperDir = Join-Path (Join-Path $root $corpus) $slug
    $pig = @(Get-PigRunDirs $paperDir $slug)[0]
    if (-not $pig) { Write-Warning "no pig run: $spec"; continue }
    $nodesPath = Join-Path $pig "$slug.nodes.jsonl"
    if (-not [System.IO.File]::Exists($nodesPath)) { Write-Warning "no nodes.jsonl: $spec"; continue }

    # ── extract per-line typographic vectors ─────────────────────────────────
    $rows   = [System.Collections.Generic.List[string]]::new()
    $fonts  = [System.Collections.Generic.List[string]]::new()   # font|size tuple per row
    $tuples = @{}
    foreach ($line in [System.IO.File]::ReadLines($nodesPath)) {
        $mF = $rxFont.Match($line); $mS = $rxSize.Match($line); $mB = $rxBbox.Match($line)
        if (-not ($mF.Success -and $mS.Success -and $mB.Success)) { continue }
        $font = $mF.Groups[1].Value
        $size = [double]::Parse($mS.Groups[1].Value, $inv)
        $bb = $mB.Groups[1].Value -split ','
        $w = [double]::Parse($bb[2], $inv) - [double]::Parse($bb[0], $inv)
        $h = [double]::Parse($bb[3], $inv) - [double]::Parse($bb[1], $inv)
        $thick = ($line.Contains('"rotated_text"')) ? $w : $h
        $type = $rxType.Match($line).Groups[1].Value
        $bold = $rxBold.IsMatch($font) ? $FlagWeightPt : 0.0
        $math = $rxMath.IsMatch($font) ? $FlagWeightPt : 0.0
        $ital = (-not $math -and $rxItal.IsMatch($font)) ? $FlagWeightPt : 0.0
        $mono = $rxMono.IsMatch($font) ? $FlagWeightPt : 0.0
        $rows.Add($DropThickness ?
            ('{0},{1},{2},{3},{4},{5}' -f
                $size.ToString($inv),
                $bold.ToString($inv), $ital.ToString($inv), $math.ToString($inv), $mono.ToString($inv), $type) :
            ('{0},{1},{2},{3},{4},{5},{6}' -f
                $size.ToString($inv), ([math]::Round($thick, 2)).ToString($inv),
                $bold.ToString($inv), $ital.ToString($inv), $math.ToString($inv), $mono.ToString($inv), $type))
        $tuple = '{0}|{1}' -f $font, [math]::Round($size, 1).ToString($inv)
        $fonts.Add($tuple)
        $tuples[$tuple] = ($tuples[$tuple] ?? 0) + 1
    }
    if ($rows.Count -lt 2 * $MinClusterSize) { Write-Warning "too few rows: $spec ($($rows.Count))"; continue }

    $dir = Join-Path $OutRoot ($spec -replace '/', '_')
    $null = New-Item -ItemType Directory -Force -Path $dir
    $csv = Join-Path $dir 'lines.csv'
    $hdr = $DropThickness ? 'size,bold,italic,math,mono,type' : 'size,thick,bold,italic,math,mono,type'
    [System.IO.File]::WriteAllLines($csv, [string[]]@($hdr) + $rows.ToArray())

    # ── cluster ──────────────────────────────────────────────────────────────
    $out = Invoke-Hdbscan -In $csv -OutDir $dir -MinPts $MinPts -MinClusterSize $MinClusterSize -LabelColumn type
    $sum = Get-Content $out.Summary -Raw | ConvertFrom-Json

    # ── crispness: read partition back, per-cluster profiles + purities ─────
    $labels = [System.Collections.Generic.List[int]]::new()
    $member = [System.Collections.Generic.List[double]]::new()
    $first = $true; $iLab = -1; $iMem = -1; $iTru = -1
    foreach ($line in [System.IO.File]::ReadLines($out.Partition)) {
        $c = $line -split ','
        if ($first) {
            $first = $false
            for ($i = 0; $i -lt $c.Length; $i++) {
                if ($c[$i] -eq 'label') { $iLab = $i }
                elseif ($c[$i] -eq 'membership_probability') { $iMem = $i }
                elseif ($c[$i] -eq 'true_label') { $iTru = $i }
            }
            continue
        }
        $labels.Add([int]$c[$iLab])
        $member.Add([double]::Parse($c[$iMem], $inv))
    }

    $byCluster = @{}   # label -> @{ n; mem; tuples(ht); types(ht) }
    $typesSeen = [System.Collections.Generic.List[string]]::new()
    $rowIdx = 0
    foreach ($r in $rows) { $typesSeen.Add(($r -split ',')[-1]); $rowIdx++ }
    for ($i = 0; $i -lt $labels.Count; $i++) {
        $L = $labels[$i]
        if (-not $byCluster.ContainsKey($L)) {
            $byCluster[$L] = @{ n = 0; mem = 0.0; tuples = @{}; types = @{} }
        }
        $b = $byCluster[$L]; $b.n++; $b.mem += $member[$i]
        $b.tuples[$fonts[$i]] = ($b.tuples[$fonts[$i]] ?? 0) + 1
        $b.types[$typesSeen[$i]] = ($b.types[$typesSeen[$i]] ?? 0) + 1
    }

    $noiseN = ($byCluster.ContainsKey(-1)) ? $byCluster[-1].n : 0
    $assigned = $labels.Count - $noiseN
    $tuplePureW = 0.0; $typePureW = 0.0; $memSum = 0.0
    foreach ($kv in $byCluster.GetEnumerator()) {
        if ($kv.Key -eq -1) { continue }
        $b = $kv.Value
        $domTuple = ($b.tuples.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Value
        $domType  = ($b.types.GetEnumerator()  | Sort-Object Value -Descending | Select-Object -First 1).Value
        $tuplePureW += $domTuple; $typePureW += $domType; $memSum += $b.mem
    }
    $tuplePurity = ($assigned -gt 0) ? $tuplePureW / $assigned : 0
    $typePurity  = ($assigned -gt 0) ? $typePureW  / $assigned : 0
    $meanMem     = ($assigned -gt 0) ? $memSum     / $assigned : 0

    # ── plateau: size>=k cluster-count curve over the merge distances ───────
    $den = Get-Content $out.Dendrogram -Raw | ConvertFrom-Json
    $N = [int]$den.leaf_count
    $sizes = [int[]]::new(2 * $N - 1)
    for ($i = 0; $i -lt $N; $i++) { $sizes[$i] = 1 }
    $curve = [System.Collections.Generic.List[object]]::new()   # (distance, bigCount) after all merges at <= distance
    $big = 0; $mid = $N; $lastD = -1.0
    foreach ($m in $den.merges) {
        $d = [double]$m.distance
        if ($d -ne $lastD -and $lastD -ge 0) { $curve.Add(@($lastD, $big)) }
        $sL = $sizes[[int]$m.left_child]; $sR = $sizes[[int]$m.right_child]
        $s = [int]$m.size; $sizes[$mid] = $s; $mid++
        if ($sL -ge $MinClusterSize) { $big-- }
        if ($sR -ge $MinClusterSize) { $big-- }
        if ($s -ge $MinClusterSize) { $big++ }
        $lastD = $d
    }
    if ($lastD -ge 0) { $curve.Add(@($lastD, $big)) }

    # plateau widths in log10(d) between successive positive event distances
    $plat = @{}    # count -> total log-width
    $platRange = @{}
    for ($i = 0; $i -lt $curve.Count - 1; $i++) {
        $d0 = [double]$curve[$i][0]; $d1 = [double]$curve[$i + 1][0]; $c = [int]$curve[$i][1]
        if ($d0 -le 0 -or $d1 -le 0 -or $c -lt 2) { continue }
        $wdt = [math]::Log10($d1 / $d0)
        $plat[$c] = ($plat[$c] ?? 0.0) + $wdt
        if (-not $platRange.ContainsKey($c)) { $platRange[$c] = @($d0, $d1) }
        else { if ($d0 -lt $platRange[$c][0]) { $platRange[$c][0] = $d0 }; if ($d1 -gt $platRange[$c][1]) { $platRange[$c][1] = $d1 } }
    }
    $topPlat = $plat.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 3

    # ── report ───────────────────────────────────────────────────────────────
    $ev = $sum.result.evaluator_scores
    Write-Host ''
    Write-Host ("══ {0}  ({1} lines, {2} font|size tuples)" -f $spec, $labels.Count, $tuples.Count) -ForegroundColor Cyan
    Write-Host ("   clusters={0}  noise={1} ({2:P1})  mean-membership={3:F3}" -f
        $sum.result.cluster_count, $noiseN, ($noiseN / [double]$labels.Count), $meanMem)
    Write-Host ("   purity: font|size-tuple={0:F3}  pig-type={1:F3}   evaluators(vs type): purity={2:F3} nmi={3:F3} v={4:F3}" -f
        $tuplePurity, $typePurity, $ev.purity, $ev.nmi, $ev.v_measure)
    foreach ($p in $topPlat) {
        $r = $platRange[$p.Key]
        Write-Host ("   plateau: count={0,-3} log10-width={1:F2}  (d {2:F2} → {3:F2} pt)" -f $p.Key, $p.Value, $r[0], $r[1])
    }
    $top = $byCluster.GetEnumerator() | Where-Object { $_.Key -ne -1 } | Sort-Object { $_.Value.n } -Descending | Select-Object -First 8
    foreach ($kv in $top) {
        $b = $kv.Value
        $domT = $b.tuples.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1
        $domY = $b.types.GetEnumerator()  | Sort-Object Value -Descending | Select-Object -First 1
        Write-Host ("     c{0,-3} n={1,-5} mem={2:F2}  {3} ({4:P0})  type={5} ({6:P0})" -f
            $kv.Key, $b.n, ($b.mem / $b.n), $domT.Key, ($domT.Value / [double]$b.n), $domY.Key, ($domY.Value / [double]$b.n))
    }

    $results.Add([pscustomobject]@{
        paper = $spec; n = $labels.Count; tuples = $tuples.Count
        clusters = $sum.result.cluster_count; noisePct = [math]::Round(100.0 * $noiseN / $labels.Count, 1)
        meanMem = [math]::Round($meanMem, 3); tuplePurity = [math]::Round($tuplePurity, 3)
        typePurity = [math]::Round($typePurity, 3)
        widestPlateau = ($topPlat | Select-Object -First 1 | ForEach-Object { 'c={0} w={1:F2}' -f $_.Key, $_.Value })
    })
}

Write-Host ''
Write-Host '══ VERDICT TABLE ══' -ForegroundColor Yellow
$results | Format-Table -AutoSize
