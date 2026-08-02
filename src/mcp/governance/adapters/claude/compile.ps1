#requires -Version 7.0
<#
  .claude/governance/adapters/claude/compile.ps1 — Claude Code reference adapter (compile half).

  Reads the agnostic contract.json and emits the Claude `hooks` block to stdout for you to merge into
  .claude/settings.json (or settings.local.json). It does NOT auto-edit settings — a harness config
  change is yours to apply.

  Claude matches hooks on the TOOL NAME only, so the compiled matcher is the union of each event's rule
  tools; evaluate.ps1 then does the fine-grained arg matching at call time. One evaluator, contract-driven.

    pwsh -NoProfile -File compile.ps1            # print the hooks block
#>

param(
    [string]$ContractPath,
    [string]$EvaluatePath
)
$ErrorActionPreference = 'Stop'
$utf8 = [System.Text.UTF8Encoding]::new($false)
$here = $PSScriptRoot
if (-not $ContractPath) { $ContractPath = Join-Path (Split-Path -Parent (Split-Path -Parent $here)) 'contract.json' }
if (-not $EvaluatePath) { $EvaluatePath = Join-Path $here 'evaluate.ps1' }

$contract = [System.IO.File]::ReadAllText($ContractPath, $utf8) | ConvertFrom-Json

# group rule tools by event (matcher = union of tool names; '*' wins to match-all)
$byEvent = @{}
foreach ($r in $contract.rules) {
    $ev = [string]$r.event
    if (-not $byEvent.ContainsKey($ev)) { $byEvent[$ev] = [System.Collections.Generic.HashSet[string]]::new() }
    foreach ($t in (([string]$r.match.tool) -split '\|')) {
        if ([string]::IsNullOrWhiteSpace($t)) { continue }
        [void]$byEvent[$ev].Add($t)
    }
}

# Hook command. Uses `pwsh`; if your Claude instance must route through the dedicated portable instance,
# swap to your agent-bin `powershell` wrapper here.
$cmd = "pwsh -NoProfile -File `"$EvaluatePath`""

$hooks = [ordered]@{}
foreach ($ev in ($byEvent.Keys | Sort-Object)) {
    $tools = $byEvent[$ev]
    $matcher = if ($tools.Contains('*')) { '*' } else { ($tools | Sort-Object) -join '|' }
    $hooks[$ev] = @(@{ matcher = $matcher; hooks = @(@{ type = 'command'; command = $cmd }) })
}

@{ hooks = $hooks } | ConvertTo-Json -Depth 8
