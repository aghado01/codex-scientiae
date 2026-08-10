# JSONL engine PowerShell client

`jsonl_engine-client` is the repository's single PowerShell-to-Python boundary for
[`jsonl_engine`](../jsonl_engine/). The Python package owns JSON/JSONL parsing, text policy, JSON
Pointer behavior, sidecars, signatures, and artifact transactions. This module owns interpreter
resolution, process lifetime, UTF-8 streams, the versioned CLI protocol, and PowerShell value
conversion.

Import the canonical manifest:

```pwsh
Import-Module ./src/jsonl_engine-client/jsonl_engine-client.psd1
Get-JsonlHead ./inventory.jsonl 5
Find-JsonlRecord ./inventory.jsonl /state eq '"source-ready"'
```

`src/jsonl_engine/jso-shell.ps1` is a temporary compatibility importer. New callers import
the manifest directly; no protocol, runtime, or command logic belongs in the compatibility file.

## Runtime and protocol

The interpreter is selected in this order:

1. an explicit `-PythonPath`;
2. `CODEX_JSONL_ENGINE_PYTHON`;
3. the repository `.venv` for the current platform.

There is no ambient `PATH` fallback. The selected environment must have the repository installed
editable. Restore it with the commands in the root `pyproject.toml` when necessary.
Ambient import/startup/warning settings are removed from the child; UTF-8, unbuffered output, user-site
isolation, and no-bytecode policy are pinned by the client.

Relative `-PythonPath` values, including the environment-selected value, and relative path parameters
on the high-level commands are resolved against the caller's current FileSystem location before the
process starts. The child runs with the repository root as its working directory, but that does not
reinterpret those paths. `Invoke-JsonlEngineCommand -Argument` is the low-level escape hatch and its
arguments are deliberately opaque; callers of that command must resolve any path-valued arguments.

Every command executes `python -m jsonl_engine --framed <verb>`. Protocol version 1 emits one compact
UTF-8 JSON value frame per stdout line with a contiguous sequence number. Both redirected streams use
strict UTF-8 decoding: invalid byte sequences, blank stdout lines, malformed JSON, wrong protocol or
frame types, and sequence gaps are protocol failures. A successful invocation requires exit code zero
and no non-whitespace stderr.

Value frames are validated and buffered until the process exits successfully; only then are they
written to the PowerShell pipeline. A timeout, malformed late frame, nonzero exit, or successful process
that writes diagnostics therefore exposes no partial result values. A total timeout kills the Python
descendant tree. On a nonzero exit, a sole nonblank valid protocol-v1 error frame on stderr is decoded
into the terminating error. Startup failures and stderr that does not have that exact structured shape
remain verbatim diagnostic text. The error carries the verb, exit code when available, reproducible
command, and structured error fields when present.

The low-level `Invoke-JsonlEngineCommand` returns `JsonlEngine.CliValueFrame` objects. This is the
extension point for an engine verb that has no high-level wrapper. `-AsFrame` on the high-level
commands retains the same envelope. Ordinary output unwraps each frame, preserves a top-level array
as one pipeline item, and represents explicit JSON null with PowerShell's `NullString` carrier so it
does not disappear from the pipeline. `-AsHashtable` preserves case-distinct JSON object keys.

Bounded reads use `-View Complete` by default. `-View Signed` selects the prefix attested by `.sig`,
and `-View Physical` reads to EOF. `-AtSignature` and `-Unbounded` remain temporary mutually exclusive
compatibility spellings.

## Public commands

- `Invoke-JsonlEngineCommand`
- `New-JsonlEngineInputFile`
- `Get-JsonlEngineCapability`
- `Get-JsonlInfo`, `Get-JsonlCount`, `Get-JsonlHead`, `Get-JsonlTail`, `Get-JsonlRange`, and
  `Get-JsonlRecord`
- `Select-JsonlPath` and `Find-JsonlRecord`
- `Test-JsonlStore`, `Get-JsonlSignature`, and `New-JsonlSnapshot`
- `Get-JsonlSchema` and `Read-JsonDocument`

The engine currently advertises 16 stable verbs through `Get-JsonlEngineCapability`:
`capabilities`, `info`, `count`, `deposit`, `rebuild-inventory`, `head`, `tail`, `range`, `get`, `select`, `find`,
`validate-json`, `verify`, `sig`, `snapshot`, `schemas`, and `json`. Verbs without an ergonomic PowerShell
wrapper remain available through the low-level command. In particular, authoritative schema validation uses
this exact positional surface:

```text
python -m jsonl_engine --framed validate-json <path> <schema>
```

`<schema>` names a schema shipped in the engine catalog by its ID, filename, or stem. The verb strictly
reads one JSON object, applies that schema, and returns the validated object in exactly one value frame.
For `article.schema.json`, validation also dispatches through `ArticleManifest`: the archive/tree ordering,
canonical paths, derived-from relation, count relation, and entrypoint/selection agreement are enforced in
addition to the portable-path and structural JSON Schema rules. PowerShell callers of
`Invoke-JsonlEngineCommand` must resolve `<path>` themselves because low-level arguments remain opaque.

`Find-JsonlRecord` retains the legacy positional or named `-Value` as raw JSON; `-JsonValue` is an
equivalent raw spelling. A string comparison therefore includes JSON quotes, for example
`-Value '"alpha"'`. New code may instead pass a PowerShell value through `-InputObject`; the client
validates and serializes it exactly once before invoking the engine.

`New-JsonlEngineInputFile` stages one structured boundary value as strict UTF-8 without a BOM and with
one terminating LF. An explicit relative `-Path` is caller-relative. With no path, the command uses the
absolute `CODEX_JSON_SCRATCH_ROOT` when set and otherwise the operating-system process temp directory;
when configured, a blank or relative scratch root is rejected. Publication uses a sibling scratch file
and removes that transaction file on failure. The returned `JsonlEngine.InputFile` is never removed
automatically: `IsTemporary` records that the module chose its name, while the caller owns retention and
cleanup. The module does not allocate run identities. Batch owners must provide job-local scratch when
isolation is required; the child engine otherwise retains its own direct-call scratch policy.

## Non-goals

The module does not implement JSONL rules in PowerShell, schedule work, allocate runs, own logging,
or define domain schemas. Calls cross the runtime boundary once per artifact or query, never once per
record in a producer loop. The PowerShell-native logger, the self-contained reader MCP, and tolerant
human-authored patch reader therefore remain independent.

Whole-artifact mutation verbs are admitted only when the Python CLI exposes the corresponding engine
transaction. `deposit` is the first such application boundary. It is intentionally available through
`Invoke-JsonlEngineCommand`, rather than a domain-named cmdlet in this generic client:

```text
python -m jsonl_engine --framed deposit
  --document-dir <absolute-document-directory>
  --slug <slug>
  --archive <document-relative-archive-path>
  --archive-kind <tar+gzip|single-tex+gzip>
  --tree <document-relative-source-tree-path>
  --tree-sha256 <lowercase-sha256>
  --files <count>
  --tex-files <count>
  --entrypoint <tree-relative-tex-path>
  --entrypoint-selection <selection>
  --publication <published-new-tree|recovered-existing-tree>
  --findings-json <absolute-staged-findings-path>
  [--provider-json <document-relative-provider-path>]
  [--pdf <document-relative-pdf-path>]
```

The PowerShell source-deposit orchestrator owns archive extraction, source confinement, entrypoint
resolution, LaTeX declarations, the tree fingerprint, and the probe ledger. It holds the per-document
source lock through this finalization call. A caller-specified findings file is create-only and must be
outside the document deposit and may not traverse a reparse point, so transport staging cannot overwrite or
alter an immutable input or output. The orchestrator rejects reparse traversal at the document root, below
the extracted tree, and through explicit or implicitly discovered archive, provider, PDF, and findings
paths. Direct low-level callers inherit the source-stability precondition and must prevent source-tree and
input mutation for the duration of the command.

Python independently rechecks document-relative confinement and portable path rules, establishes regular-file
facts, and witnesses measured file generations before and after publication. If the closing check detects
drift after this transaction created the sentinel, it removes only the exact candidate it published while
holding the article lease; it refuses rollback if another actor replaced the article. Python also projects
provider evidence, applies both `article.schema.json` and `ArticleManifest` semantic relations, and publishes
or idempotently validates the immutable `{document-dir}/article.json` without clobbering an existing file.
The verb returns exactly one value frame containing `status`, `created`, `article_path`, `archive_path`,
`source_path`, and the flat `article` object; a conflict or validation failure returns no value frame.
