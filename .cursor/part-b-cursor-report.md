Part B — the structural impossibility gate — is implemented and staged (not committed, per the brief).

What landed
Impossibility predicate set (reuses shared table)
Get-StructuralImpossibility in src/fidelity.ps1 filters $script:CorruptionSignatures to the three structural types only:

Type	Meaning
alignment_outside_env
bare & outside an env overlay
prose_in_formula
formula chunk that reads as prose
unbalanced_delimiters
delimiter imbalance (Get-LatexBalance.full for formula; brace-only for inline-math prose)
Content-only signatures (ligature_residue, gibberish, etc.) are excluded — those stay on the content-repair path (apply / Add-RepairProposal). One table, no fork.

Wiring (src/restructure.ps1)
Before any Save-Structure commit:

Set-ChunkType — evaluates the would-be chunk { type = NewType; content = unchanged }
Merge-Chunks — evaluates the joined { type = lead.type; content = merged }
Split-Chunk — evaluates both halves (delimiter orphaning across the cut)
Helper Test-StructImpossibility returns the first failing chunk's diagnostic.

Rejection shape
Mirrors Add-RepairProposal's rejection, with structural ops using ok = $false:

@{ ok = $false; id = <n>; reason = 'unbalanced_delimiters'; diagnostic = 'brace=0 brack=0 paren=0 lr=1' }
# merge uses ids = @(0, 1, 2) instead of id
No write, no renumber on rejection.

MCP docs (src/mcp-server.ps1)
retype_chunk, split_chunk, and merge_chunks descriptions now note impossibility rejection. Tool count unchanged (21); no schema change.

Validation
15 new tests in tests/impossibility-gate.Tests.ps1:

Reject: unbalanced retype→formula (with seam diagnostic), prose retype, unbalanced merge, alignment merge, delimiter-orphaning split
Pass: valid retype, fragmented-formula merge (Track 2 dependency — join balances despite per-chunk fragments), valid prose split
Regression: Add-RepairProposal content gate unchanged
Full suite: 112 passed, 0 failed (97 prior + 15 new). Corpus differential still green.

Invariants held
Frozen Get-CorruptionType / apply gate untouched
Valid mutations renumber exactly as before
masks.ps1 untouched
No rule-engine — hard-coded declared set only


Staged (your commit)
src/fidelity.ps1
src/restructure.ps1
src/mcp-server.ps1
tests/impossibility-gate.Tests.ps1
Deferred (as scoped)
Localized-span / math_dirt difference-localization, full playbook-as-data, new sub-chunk granularity, general rule-table runner.

Committed by User