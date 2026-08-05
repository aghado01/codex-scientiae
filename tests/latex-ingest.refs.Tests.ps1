#requires -Version 7.0
<#
  tests/latex-ingest.refs.Tests.ps1 — GOLDEN PINNING (refs-consolidation step 1).

  Pins the resolved reference model for a fixture paper: every declared label with BOTH display
  projections (normalized + faithful), and the rendered text of every reference site, in order.
  This is the invariant the refs refactor must not move — any change to numbering, the counter
  model, resolution contracts, or the walk that shifts one number or one rendered phrase fails
  here first; corpus-wide wrongness caught on one paper.

  Regenerate the golden DELIBERATELY (never to silence a failure you don't understand): run the same
  production reference-model setup below against the staged paper, serialize the `label` and `site`
  rows, compare them with the committed fixture, and then replace it intentionally. There is no
  automatic refresh command.

  Skips when the fixture source is not staged locally (paper sources are corpus material,
  untracked; the golden fixture itself is ours and committed).
#>
BeforeDiscovery {
    $script:FixtureSrc = @(
        (Join-Path $PSScriptRoot '..\ingestion\_inbox\2408.16741v2\2408.16741v2-latex'),
        (Join-Path $PSScriptRoot '..\artifacts\latex-ingest\probe\_staging\2408.16741v2-latex')
    ) | Where-Object { Test-Path -LiteralPath $_ -PathType Container } | Select-Object -First 1
}

Describe 'latex-ingest ref model — golden (2408.16741v2)' -Skip:(-not $script:FixtureSrc) {
    BeforeAll {
        . (Join-Path $PSScriptRoot '..\src\latex-ingest\latex-ingest.ps1')
        $u8 = [System.Text.UTF8Encoding]::new($false)
        # recomputed here: discovery-phase variables do not survive into the run phase
        $src = @(
            (Join-Path $PSScriptRoot '..\ingestion\_inbox\2408.16741v2\2408.16741v2-latex'),
            (Join-Path $PSScriptRoot '..\artifacts\latex-ingest\probe\_staging\2408.16741v2-latex')
        ) | Where-Object { Test-Path -LiteralPath $_ -PathType Container } | Select-Object -First 1
        $entrypoint = Get-LatexSourceEntrypoint -RootPath $src -Slug '2408.16741v2'
        $tex = Resolve-LatexSourceInputs -MainPath $entrypoint.path -RootPath $src -UnresolvedInputAction Keep
        # the production driver's bbl ladder, replicated so cite sites resolve identically
        $bbl = @(Get-ChildItem -LiteralPath $src -Recurse -File -Filter *.bbl) | Select-Object -First 1
        $bblTxt = if ($bbl) { [System.IO.File]::ReadAllText($bbl.FullName, $u8) } else { '' }
        if ($bblTxt -match '\\entry\{') { $syn = ConvertFrom-BiblatexBbl $bblTxt; if ($syn) { $bblTxt = $syn } }
        if ($bblTxt -notmatch '\\bibitem') {
            $ib = [regex]::Match($tex, '(?s)\\begin\{thebibliography\}.*?\\end\{thebibliography\}')
            if ($ib.Success) { $bblTxt = $ib.Value }
        }
        $null = ConvertFrom-Latex $tex $bblTxt
        $script:model = $script:LtxRefModel
        $rows = Get-Content (Join-Path $PSScriptRoot 'fixtures\2408.16741v2.refs.golden.jsonl') |
            ForEach-Object { $_ | ConvertFrom-Json -AsHashtable }
        $script:goldLabels = @($rows | Where-Object { $_.row -eq 'label' })
        $script:goldSites = @($rows | Where-Object { $_.row -eq 'site' })
    }
    It 'produces a ref model' {
        $script:model | Should -Not -BeNullOrEmpty
        $script:goldLabels.Count | Should -BeGreaterThan 0
        $script:goldSites.Count | Should -BeGreaterThan 0
    }
    It 'pins the label count' {
        $script:model.labels.Count | Should -Be $script:goldLabels.Count
    }
    It 'pins every label: class, type, and both display projections' {
        # keyed by class|label: a label can legitimately appear under two maps (e.g. a theorem label
        # also captured by the custom-counter scan) — each row pins independently
        $byLabel = @{}
        foreach ($l in $script:model.labels) { $byLabel["$($l.class)|$($l.label)"] = $l }
        foreach ($g in $script:goldLabels) {
            $l = $byLabel["$($g.class)|$($g.label)"]
            $l | Should -Not -BeNullOrEmpty -Because "label '$($g.label)' must still be declared"
            [string]$l.class | Should -Be ([string]$g.class) -Because "class of '$($g.label)'"
            [string]$l.type | Should -Be ([string]$g.type) -Because "type of '$($g.label)'"
            [string]$l.normalized | Should -Be ([string]$g.normalized) -Because "normalized number of '$($g.label)'"
            [string]$l.faithful | Should -Be ([string]$g.faithful) -Because "faithful number of '$($g.label)'"
        }
    }
    It 'pins the site count' {
        $script:model.sites.Count | Should -Be $script:goldSites.Count
    }
    It 'pins every reference site rendering, in order' {
        for ($i = 0; $i -lt $script:goldSites.Count; $i++) {
            $g = $script:goldSites[$i]; $s = $script:model.sites[$i]
            [string]$s.macro | Should -Be ([string]$g.macro) -Because "site $i macro"
            (@($s.targets) -join ',') | Should -Be (@($g.targets) -join ',') -Because "site $i targets"
            [string]$s.rendered | Should -Be ([string]$g.rendered) -Because "site $i rendering"
        }
    }
}
