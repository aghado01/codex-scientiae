#requires -Version 7.0
<#
  src/benchmark.ps1 — opportunistic harvest of well-posed repair problems into a challenge library.

  A dispatched repair work-unit IS a well-posed, isolatable problem: a flagged chunk + its evidence +
  an objective gate. This captures it BEFORE repair, tagged, so ingestion does double duty — every
  paper it processes opportunistically grows a benchmark of real conversion-repair trials. Two grades
  of supervision, both already present in the pipeline:
    - GATE   (render_check / delimiter balance): objective pass/fail on ANY proposed solution — weak
             but always available. The trial is gate-graded today.
    - ORACLE (dual-availability LaTeX {slug}.latex.md): the source-derived reference answer — strong,
             oracle-upgradeable later once the conversion-metric aligner maps it to this span.

  Uniqueness-gated append (the user's discipline): NOT dedup — some redundancy is fine, and a
  similar-but-different-DIFFICULTY trial is especially valuable. A candidate is skipped only when a
  near-duplicate at the SAME difficulty bucket already fills the redundancy cap; novel content OR novel
  difficulty is kept. Similarity here is a lightweight token-shingle Jaccard (a PROOF signal); the
  production novelty engine is SPCX hashish (MinHash+LSH — sublinear, the conversion-metric's atomic
  layer). See issues/benchmark-harvest.md.

    . ./benchmark.ps1
    Export-BenchmarkTrial -Chunk <flagged chunk> -PaperDir <dir> -Slug <slug> -LibraryPath <trials.jsonl>
#>

. "$PSScriptRoot/pdf-converter/math-assembler.ps1"   # Measure-DelimiterBalance
. "$PSScriptRoot/pdf-converter/math-evidence.ps1"    # Get-ChunkMathEvidence (the problem's geometry)

# difficulty tags from what's cheaply on the chunk — content-only, no geometry load. Difficulty is a
# HEURISTIC score (calibrate against solve-rates later); has_oracle is a supervision axis, not difficulty.
function Get-TrialDifficulty($Chunk, [bool]$HasOracle) {
    $content = [string]$Chunk.content
    $imbalance = [math]::Abs((Measure-DelimiterBalance $content))
    $len = $content.Length
    # nesting proxy: max depth of _{ / ^{ braces (deep scripts = harder structure)
    $depth = 0; $maxDepth = 0
    foreach ($ch in $content.ToCharArray()) {
        if ($ch -eq '{') { $depth++; if ($depth -gt $maxDepth) { $maxDepth = $depth } }
        elseif ($ch -eq '}') { if ($depth -gt 0) { $depth-- } }
    }
    $newlines = ([regex]::Matches($content, "`n")).Count   # stacked lines = multi-row (fraction/matrix)
    $score = $imbalance * 2.0 + [math]::Log([math]::Max(1, $len)) + $maxDepth * 1.5 + $newlines * 2.0
    $tier = if ($score -lt 5) { 'easy' } elseif ($score -lt 10) { 'medium' } else { 'hard' }
    [ordered]@{
        class = @($Chunk.flags) -join ',' ; imbalance = $imbalance; length = $len
        nest_depth = $maxDepth; rows = $newlines + 1; has_oracle = $HasOracle
        score = [math]::Round($score, 2); tier = $tier
    }
}

# content signature for novelty: normalized token 2-shingles. Deterministic, order-insensitive-ish.
function Get-ContentSignature([string]$Content) {
    $norm = ($Content -replace '\s+', ' ').Trim().ToLowerInvariant()
    $toks = @($norm -split '(?<=[^\w])|(?=[^\w])' | Where-Object { $_ -and $_.Trim() })
    $sh = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    for ($i = 0; $i -lt $toks.Count - 1; $i++) { [void]$sh.Add($toks[$i] + '|' + $toks[$i+1]) }
    if ($toks.Count -eq 1) { [void]$sh.Add($toks[0]) }
    return $sh
}

function Get-JaccardSet([System.Collections.Generic.HashSet[string]]$A, [System.Collections.Generic.HashSet[string]]$B) {
    if ($A.Count -eq 0 -and $B.Count -eq 0) { return 1.0 }
    $inter = 0; foreach ($x in $A) { if ($B.Contains($x)) { $inter++ } }
    $union = $A.Count + $B.Count - $inter
    if ($union -eq 0) { return 0.0 }
    return [double]$inter / $union
}

# the uniqueness gate. Keep unless a near-duplicate (Jaccard >= DupThreshold) at the SAME difficulty
# tier already fills the per-bucket redundancy cap. Returns the decision + why + nearest neighbour.
function Test-TrialNovelty {
    param(
        [System.Collections.Generic.HashSet[string]]$Signature,
        [string]$Tier,
        [object[]]$Existing,           # prior trials: each has .signature (HashSet) + .tier
        [double]$DupThreshold = 0.8,
        [int]$RedundancyCap = 2        # allow up to N near-dups per difficulty tier (some redundancy is fine)
    )
    $nearestId = $null; $nearestSim = 0.0; $dupSameTier = 0
    foreach ($e in $Existing) {
        $sim = Get-JaccardSet $Signature $e.signature
        if ($sim -gt $nearestSim) { $nearestSim = $sim; $nearestId = $e.id }
        if ($sim -ge $DupThreshold -and $e.tier -eq $Tier) { $dupSameTier++ }
    }
    $keep = ($dupSameTier -lt $RedundancyCap)
    $reason = if ($keep) {
        if ($nearestSim -lt $DupThreshold) { 'novel content' }
        elseif ($dupSameTier -gt 0) { "near-dup but under redundancy cap ($dupSameTier/$RedundancyCap at tier $Tier)" }
        else { "similar content, different difficulty tier (valuable)" }
    } else { "redundant: $dupSameTier near-dups already at tier $Tier (cap $RedundancyCap)" }
    [pscustomobject]@{ decision = $(if ($keep) {'keep'} else {'skip'}); reason = $reason
                       nearest = $nearestId; similarity = [math]::Round($nearestSim,3) }
}

function Import-TrialLibrary([string]$LibraryPath) {
    $out = [System.Collections.Generic.List[object]]::new()
    if (-not (Test-Path -LiteralPath $LibraryPath)) { return $out }
    foreach ($line in [System.IO.File]::ReadAllLines($LibraryPath)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $t = $line | ConvertFrom-Json
        $sig = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($s in @($t.signature)) { [void]$sig.Add([string]$s) }
        $out.Add([pscustomobject]@{ id = $t.id; tier = $t.difficulty.tier; signature = $sig })
    }
    return $out
}

# assemble a trial from a flagged chunk, gate on novelty, append if kept. Returns the decision + record.
function Export-BenchmarkTrial {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Chunk,
        [Parameter(Mandatory)] [string] $PaperDir,
        [Parameter(Mandatory)] [string] $Slug,
        [Parameter(Mandatory)] [string] $LibraryPath,
        [double] $DupThreshold = 0.8,
        [int]    $RedundancyCap = 2
    )
    $hasOracle = Test-Path -LiteralPath (Join-Path $PaperDir "$Slug.latex.md")
    $difficulty = Get-TrialDifficulty $Chunk $hasOracle
    $sig = Get-ContentSignature ([string]$Chunk.content)

    $existing = Import-TrialLibrary $LibraryPath
    $novel = Test-TrialNovelty -Signature $sig -Tier $difficulty.tier -Existing $existing `
                               -DupThreshold $DupThreshold -RedundancyCap $RedundancyCap
    if ($novel.decision -eq 'skip') {
        return [pscustomobject]@{ harvested = $false; reason = $novel.reason; nearest = $novel.nearest; similarity = $novel.similarity }
    }

    # the problem input: broken content + the geometric evidence (pig lane) so a solver reasons over
    # geometry, not just the flattened LaTeX. Null-degrades for docling-lane / geometry-absent chunks.
    $evidence = $null
    try { $evidence = Get-ChunkMathEvidence -Chunk $Chunk -PaperDir $PaperDir -Slug $Slug } catch { $evidence = $null }

    $id = "$Slug-$($Chunk.id)"
    $trial = [ordered]@{
        id            = $id
        problem_type  = 'math_repair'
        source        = [ordered]@{ paper = $Slug; chunk_id = [int]$Chunk.id }
        input         = [ordered]@{ content = [string]$Chunk.content; evidence = $evidence }
        ground_truth  = [ordered]@{ gate = 'render_check+balance'; oracle_available = $hasOracle
                                    reference = $null }   # oracle reference aligned later (conversion-metric)
        difficulty    = $difficulty
        signature     = @($sig)     # persisted for the next candidate's novelty check
        provenance    = [ordered]@{ harvested_via = 'ingestion'; novelty = $novel.reason }
    }
    $dir = Split-Path -Parent $LibraryPath
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::AppendAllText($LibraryPath, (($trial | ConvertTo-Json -Compress -Depth 8) + "`n"), [System.Text.UTF8Encoding]::new($false))
    [pscustomobject]@{ harvested = $true; id = $id; tier = $difficulty.tier; reason = $novel.reason
                       has_oracle = $hasOracle; nearest = $novel.nearest; similarity = $novel.similarity }
}
