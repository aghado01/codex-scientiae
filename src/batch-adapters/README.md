# Batch adapters

`batch-adapters` contains the domain planners for the finite-batch executor. Import the canonical module
through `adapters.psd1`. It exports three commands while leaving the executor's four-command public surface
unchanged: `Get-PesterBatchJob` for repository Pester work, `Get-PytestBatchJob` for repository pytest work,
and `Get-LatexBatchJob` for manifest-backed latex-ingest work. These are public files in one module, not one
PowerShell module per adapter; no unitary adapter module or compatibility alias is introduced.

## Pester adapter

`Get-PesterBatchJob` accepts caller-selected `*.Tests.ps1` files or directories and an existing absolute
`RunDirectory`. Directories expand recursively to one `PowerShellProcess` job per test file. Optional Pester
full-name and tag filters select cases inside each file without loading Pester or suite code in the planning
process.

Planning resolves and freezes:

- a stable `pester:<repository-relative-path>#<digest>` job ID from repository-relative test identity plus
  normalized filters;
- the exact Pester 5-or-newer manifest imported by the child;
- the PowerShell executable, repository working directory, and runner entrypoint;
- a file-size cost hint; and
- one container address beneath `RunDirectory/pester-jobs/`, with a Pester-native `pester.xml` result and
  sibling `artifacts/` root.

One private pure resolver owns all run-relative address composition. Planning creates no directories or
files. The job declares both the XML path and container artifact root in `Writes`, and its
`ProcessSpec.Environment` transports the absolute artifact root to the child as
`CODEX_TEST_ARTIFACT_ROOT`. Pester's XML is an explicit runner-native artifact; retained suite evidence
stays below the container artifact root; and the generic batch execution result remains the in-memory
return from `Invoke-BatchPlan`.

`Get-PesterBatchJob` only plans work. The caller imports the batch-executor module separately, passes the
emitted jobs to `New-BatchPlan`, and invokes a valid plan through `Invoke-BatchPlan`. This keeps adapters
composable: test and LaTeX jobs can share one queue without another scheduler or convenience
wrapper taking ownership of execution policy.

The Pester adapter never allocates or joins a run, selects logger sink topology, serializes the generic
execution record, or owns pools, cancellation, retries, and result ordering. Process jobs receive the
executor's `CODEX_BATCH_JOB_ID`; any caller-supplied logging or correlation environment continues through ordinary
process policy.

## Pytest adapter

`Get-PytestBatchJob` accepts caller-selected `test_*.py` files or directories and an existing absolute
`RunDirectory`. Directory discovery produces one `PowerShellProcess` job per physical file without
importing pytest or test code. Pytest methods, node IDs, parameter rows, and `unittest.subTest` contexts stay
inside the file job; the adapter does not add method-level scheduling or pytest-xdist.

The planning contract freezes:

- a stable `pytest:<repository-relative-path>#<digest>` ID from exact source identity plus normalized
  framework selectors;
- the repository-local or caller-supplied Python interpreter, repository working directory, and
  `tests/pytest.ps1` runner;
- cache, bytecode, temporary-directory, and JSON-engine scratch policy;
- a file-size cost hint; and
- one container beneath `RunDirectory/pytest-jobs/`, containing `pytest.xml`, `artifacts/`, and `temp/`.

One private resolver owns all three addresses. Planning creates none; each is declared in `Writes`.
`CODEX_TEST_ARTIFACT_ROOT` transports the retained evidence root, while the temporary address contains
pytest/Python scratch and the test-local JSON-engine coordination root. Native JUnit remains the durable
framework result and the generic executor record remains in memory. The resolved child PowerShell is
transported as `CODEX_TEST_POWERSHELL_PATH`; shell-surface tests consume that exact path and use `PATH`
only for direct, non-batch pytest. `Metadata.PowerShellEnvironment` names that transport key.

`tests/pytest.ps1` is the authoritative runner and the job's direct PowerShell entrypoint. It invokes the
pinned interpreter as `python -m pytest`, captures native streams and status, rejects empty runs,
writes JUnit, and emits `PytestContainerObservation`. There is no second Python runner or adapter worker.
Executor timeout and teardown continue to own the PowerShell child and its Python descendant; adding this
adapter does not add a native-process executor mode.

BEX-604 evolved `tests/parallel.ps1` into the one multilingual repository shell; no pytest-only parallel
shell exists. It combines the adapters' domain-neutral jobs into one plan while
keeping framework selectors, observations, job IDs, address roots, and native reports distinct.

## LaTeX adapter

`Get-LatexBatchJob` accepts caller-selected document-inventory rows and an existing absolute
`RunDirectory`. It resolves each row to one source-ready manifest and emits one isolated latex-ingest
process job per document. A directory address prefers its canonical `article.json` with schema
`codex-scientiae/article/0.1`. Direct `metadata.json` addresses and the older
`codex-scientiae/document-metadata/0.1` shape remain bounded read compatibility during migration; they are
not a license for a new metadata-era producer. The exact latex-ingest script, its SHA-256, the child
PowerShell, output-affecting switches, environment, timeout, priority, and original inventory row are frozen
into each job.

Adapter planning remains pure and shallow. It resolves confined addresses and reads only the discriminator,
state, required top-level fields, and source identity needed to construct a job; it neither starts Python nor
claims authoritative JSON Schema validation. When the planned conversion worker consumes a canonical
article, latex-ingest calls the engine's `validate-json <path> article.schema.json` boundary before trusting
the object or running conversion. A schema-invalid article can therefore be planned but cannot execute as a
valid source.

For a canonical article, planning also resolves exactly
`{document-directory}/{slug}-latex.patch.jsonl`. It constructs that literal sibling from the manifest slug;
there is no directory scan, inferred basename, or `OutDir` fallback. The slug follows
`article.schema.json#/$defs/portableLeaf`: it is one nonempty segment other than `.` or `..`, has no trailing
dot or space, contains none of `<>:"/\|?*` or U+0000–U+001F, and has no case-insensitive Windows device
basename (`CON`, `PRN`, `AUX`, `NUL`, `COM1`–`COM9`, or `LPT1`–`LPT9`) before a dot or end. The resolved
address must stay beneath `InventoryRoot`. A present entry must be a physical non-reparse file no larger than
1 MiB (1,048,576 raw bytes); non-file occupancy, reparse traversal, and larger files are planning errors.
Planning incrementally hashes the admitted raw bytes, bounded at 1 MiB with only a one-byte over-limit probe;
it does not parse patch records, start Python, or create artifacts.

Patch identity is exactly `absent` or `sha256:` followed by 64 lowercase hexadecimal digits over the raw
file bytes. It joins the inventory-relative manifest, source-tree fingerprint, and output options in stable
job identity, so it also affects the job address. Metadata records `PatchPath`,
`InventoryRelativePatchPath`, and `PatchIdentity`. For every batch job, the worker requires and transports the
planned slug as `ExpectedSlug` alongside the frozen `ExpectedPatchIdentity`. After resolving the manifest and
before conversion writes, latex-ingest compares the resolved slug to `ExpectedSlug` with ordinal equality.
This prevents a supported legacy `metadata.json` edit from selecting a different canonical patch or output
address under an already planned job; it is a targeted address guard, not a claim that every manifest byte is
immutable. Latex-ingest also refuses patch appearance, deletion, byte drift, or runtime reparse traversal
instead of executing under a stale plan.

One private resolver owns all paths beneath `RunDirectory/latex-jobs/`: application evidence, lane output,
and an optional deliverable root. The job declares every such root in `Writes`, and planning creates none.
The canonical patch is a read dependency and is never declared in `Writes`. The private worker invokes only
latex-ingest's manifest-backed production entrypoint.

`src/latex-ingest/latex-batch.ps1` is the repository development shell over this planner. It reads a
validated localized `inventory.jsonl`, optionally selects exact slugs, allocates or joins a caller run, then
performs the public `Get-LatexBatchJob` -> `New-BatchPlan` -> `Invoke-BatchPlan` composition. It lives outside
the adapters module because run allocation, selection workflow, console summary, and failure-to-process-exit
projection are application-shell responsibilities rather than planner behavior.

## Ownership boundary

The three commands only interpret domain input and emit `BatchJob` records. Callers compile and invoke
those jobs through `New-BatchPlan` and `Invoke-BatchPlan`. The adapters do not own pools, cancellation,
retries, result ordering, run allocation, logger lifecycle, or durable executor-result storage.
