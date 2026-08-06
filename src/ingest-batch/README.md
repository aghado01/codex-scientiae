# Ingestion batch adapter

`ingest-batch` converts document-inventory rows into isolated latex-ingest jobs for the shared finite-batch
executor. It is a separate module and exports only `Get-IngestBatchJob`; neither the executor nor
latex-ingest gains another scheduling surface.

## Planning contract

Each row must expose a manifest address through the caller-selected `MetadataPathProperty`, which defaults to
the current source-deposit field `metadata_path`. Relative values resolve beneath `InventoryRoot`; absolute
values must remain inside that root. This minimal projection deliberately does not freeze the provisional
parent-inventory schema. A string manifest address is also accepted as a row.

Planning reads enough of the referenced `codex-scientiae/document-metadata/0.1` manifest to require
`source-ready`, one safe slug, and exactly one identified LaTeX archive and source tree. The latex-ingest
worker revalidates the source deposit at execution time. Archive size supplies a cost hint; stable identity
uses the scoped manifest address, source-tree fingerprint, and output-affecting switches.

The caller supplies an existing absolute `RunDirectory`. One private pure resolver derives a unique job root
and these application destinations beneath it:

- latex-ingest run evidence;
- lane markdown and assets; and
- an optional standalone deliverable bundle.

Those destination roots are the job's complete declared `Writes`. Planning creates none of them. Every row
becomes one `PowerShellProcess` job because latex-ingest maintains script-scoped conversion state and invokes
document-local rendering toolchains. The job pins the worker, exact latex-ingest script plus SHA-256, child
PowerShell, working directory, timeout, window/profile policy, and caller environment.

`ProcessEnvironment` is copied into the child policy without choosing a logger or correlation schema. The
executor still injects `CODEX_BATCH_JOB_ID` and `CODEX_BATCH_EXECUTION_MODE` and preserves inherited
`CODEX_RUNLOG_*` transport. The adapter never allocates a run, initializes source deposits, owns execution,
serializes the generic execution record, or publishes the per-job output into a durable catalog or shelf.
