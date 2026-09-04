After the catalog/deposit move, logistics is almost entirely host primitives. Nothing left there belongs to the jsonl engine or the batch executor as a whole. A few files have a single consumer or mixed naming, which is a different question from “this is batch-executor code.”

Current inventory

┌───────────────┬─────────────────────────────────┬─────────────────────────────┬─────────────────────────┐
│ File          │ Job                             │ Live src/ callers           │ Tests                   │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ run-paths.ps1 │ Mint artifacts/{module}/        │ tests/batch.ps1, logger.ps1 │ tests/infrastructure    │
│               │ {stamp}/ and artifacts/tests/{  │                             │ /run-paths.Tests.ps1    │
│               │ suite}/{stamp}/                 │                             │                         │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ artifact-     │ Descendant check, $Root/        │ adapters, tests/batch.ps1,  │ test-batch-conventions  │
│ boundary.ps1  │ artifacts run dir, CODEX_TEMP,  │ tests/run.ps1, tests/pytest │ .Tests.ps1              │
│               │ suite name                      │ .ps1                        │                         │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ logger.ps1    │ Per-run JSONL trace             │ none in production; batch-  │ log.Tests.ps1           │
│               │                                 │ executor fixture only       │                         │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ portable-path │ Portable leaf + reparse         │ procurement scripts,        │ portable-path.Tests.ps1 │
│ .ps1          │                                 │ authored-jsonl.ps1          │                         │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ file-bytes    │ Bounded read + sha256:          │ authored-jsonl.ps1 only     │ file-bytes.Tests.ps1    │
│ .ps1          │                                 │                             │                         │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ authored      │ Comment-tolerant authored JSONL │ none                        │ authored-jsonl.Tests    │
│ -jsonl.ps1    │                                 │                             │ .ps1                    │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ crawl.ps1     │ Glob walk                       │ latex-source.ps1 only       │ crawl.Tests.ps1         │
├───────────────┼─────────────────────────────────┼─────────────────────────────┼─────────────────────────┤
│ probe-ledger  │ Witnessed probe outcomes        │ latex-source.ps1 only       │ none                    │
│ .ps1          │                                 │                             │                         │
└───────────────┴─────────────────────────────────┴─────────────────────────────┴─────────────────────────┘

tests/logistics/ is empty. Those Pester files sit under tests/infrastructure/.

Do not move into jsonl_engine

jsonl_engine is Python, strict JSONL, schema, publication. These files are PowerShell, and authored-jsonl exists because the engine will not accept comments, identity drift checks, or “absent file is a valid empty store.” Putting them under the engine would mix runtimes and invert that split.

file-bytes / portable-path are the same: hot-path FS safety the engine does not own.

Do not move into batch-executor

The executor’s thinness contract forbids minting run directories, naming artifacts/, and owning the logger. tests/parallel.ps1 is held to the same rule. run-paths, artifact-boundary, and logger are what the caller (tests/batch.ps1) and adapters use so the executor stays thin.

Adapters already freeze src/logistics/artifact-boundary.ps1 as runner support because tests/run.ps1 / tests/pytest.ps1 load it. That is a path coupling for out-of-repo callers, not a reason to swallow the file into batch-executor/.

Stay in logistics (shared operational primitives)

These are correctly “not only batch, not only jsonl, not only procurement”:

• run-paths.ps1 — any module run, plus test-suite roots.
• logger.ps1 — optional substrate; production lanes still barely use it.
• portable-path.ps1 — procurement uses it; so does authored-jsonl. Not catalog logic.
• file-bytes.ps1 — generic IO. One live consumer is fine.
• crawl.ps1 — generic walk. Only latex-source calls it today; the primitive is still glob+reparse, not deposits. Do not bury it in procurement/scripts.
• authored-jsonl.ps1 — no live production caller (graveyard latex-patch was the original). Keep as a dormant PS primitive. Do not delete just because unused; do not relocate into the engine.

Mixed or one-consumer — not a wholesale move

artifact-boundary.ps1 is the real tangle. One file holds:

┌─────────────────────────────────────────────────────────────┬───────────────────────────────────────────┐
│ Function                                                    │ Actually is                               │
├─────────────────────────────────────────────────────────────┼───────────────────────────────────────────┤
│ Test-TestHarnessDescendantPath                              │ Generic “path stays under root”           │
├─────────────────────────────────────────────────────────────┼───────────────────────────────────────────┤
│ Get-TestHarnessArtifactRoot / Resolve-                      │ This-repo test/adapter layout: $          │
│ TestHarnessRunDirectory / Set-CodexTempEnvironment          │ RepositoryRoot/artifacts must exist       │
├─────────────────────────────────────────────────────────────┼───────────────────────────────────────────┤
│ Resolve-TestSuiteName                                       │ Only tests/{owner} naming for tests/batch │
│                                                             │ .ps1                                      │
└─────────────────────────────────────────────────────────────┴───────────────────────────────────────────┘

Do not move the whole file into adapters or the executor. For out-of-repo planners, split or rename: keep a generic descendant+temp primitive here; stop calling it TestHarness; Resolve-TestSuiteName can live next to tests/batch.ps1 if you want logistics free of suite vocabulary. That is reshape work, not a folder move.

probe-ledger.ps1 is the only file that could follow a consumer. Design is generic (“a claim in an artifact needs a witness”). Live use is only New-LatexSourceDeposit. No tests. I would still leave it in logistics: it is not catalog/inventory logic, and parking it in procurement/scripts hides a reusable type next to CLI wrappers. Add probe-ledger.Tests.ps1 here rather than moving the source.

Tests

House convention says tests follow the source owner. You currently have:

• source: src/logistics/
• tests: tests/infrastructure/
• tests/logistics/: empty

That is coherent only if you treat logistics as “infrastructure primitives” and keep all of their tests under tests/infrastructure/. Then delete the empty tests/logistics/ directory in your head: it is not an owner anymore.

test-batch-conventions.Tests.ps1 still uses tests/logistics and tests/logistics/run-paths.Tests.ps1 as suite-name examples. Resolve-TestSuiteName does not require those paths to exist, so the tests still pass, but the examples are stale. Point them at tests/infrastructure (or restore tests/logistics/ and put the primitive tests back).

Missing coverage: probe-ledger.ps1.

Bottom line

Nothing in logistics now “belongs only” to jsonl_engine or batch-executor. Procurement already took the catalog/deposit libraries. What remains should stay a small host-primitive bucket.

The useful follow-ups are not more moves:

1. Split or rename artifact-boundary so test-harness / $Repo/artifacts is not the generic containment API.
2. Decide test grouping: tests/logistics/ vs tests/infrastructure/, and fix the suite-name examples.
3. Add probe-ledger tests; leave the file here.