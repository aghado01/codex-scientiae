Fix applied. 115 tests green.

What changed
Three-tier gate (op-specific):

Op	Gate
All ops
Geometry only via Get-StructuralImpossibility: alignment_outside_env, prose_in_formula
Merge
Test-MergeBalanceWorsens — reject only when joinRes > sumPartsRes (same metric as Group-MathHotspots)
Split
Test-SplitDelimiterOrphan — each half checked via Test-ChunkUnbalanced (reuses shared table row)
Retype allows unbalanced content — worker fixes via content path after retype; chunk re-grades to suspect.

Deadlock resolved
\left( + x merge now passes (same-residual, merge-then-fix)
\left( \left( a + b \right) merge now passes (partial-balance hotspot case — join improves, still lr=1)
Split orphan guard unchanged
Tests added/updated
Partial-balance fragmented-formula merge (the case that was missing)
Same-residual merge allowed
Unbalanced retype allowed
Test-MergeBalanceWorsens unit check on improvement path
Note: joinRes > sumPartsRes is hard to hit with real LaTeX (concatenation rarely worsens balance), but the guard is wired and won't block any hotspot promotion.

Staged: src/fidelity.ps1, src/restructure.ps1, src/mcp-server.ps1, tests/impossibility-gate.Tests.ps1.

The exploratory merge-balance search finished cleanly on the second run: across the LaTeX fixture pairs tested, none had joinRes > sumPartsRes — joins either improved balance or stayed equal. That matches why the worsening guard is wired but rarely fires in practice, and why the fix leaned on allowing partial-balance hotspot merges instead.

The first attempt failed due to a mangled one-liner in the shell; it was replaced by a small script and then removed after we had the answer. No code changes needed from either run — the fix is already in and 115 tests green.

The Part B fix is staged and ready for your commit:

src/fidelity.ps1
src/restructure.ps1
src/mcp-server.ps1
tests/impossibility-gate.Tests.ps1