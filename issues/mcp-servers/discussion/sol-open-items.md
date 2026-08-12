We were at the end of the provider/descriptor catalog slice, with the code green but not yet committed.

Current state:

- `main` is three commits ahead of `origin/main`.
- The working tree still contains the provider-catalog refactor and artifact-scratch naming changes.
- Latest comprehensive gate: 26 test containers, 503 outcomes, 3 skips, zero failures/errors.

What is now implemented:

- The reverse dependency is corrected:
  - `jsonl_engine` owns `article.json` and inventory infrastructure.
  - Procurement layers its [schema catalog](D:/aghado01/codex-scientiae/src/procurement/storage/schemas.py) and [article metadata extension](D:/aghado01/codex-scientiae/src/procurement/storage/article.py) over it.
- Provider identity is declared by adapters through immutable `ProviderDefinition` records.
- [ProviderCatalog](D:/aghado01/codex-scientiae/src/procurement/providers/catalog.py) replaced the old flat registry.
- Categories are explicit:
  - OpenAlex/Semantic Scholar: aggregators
  - arXiv/Zenodo: repositories and metadata authorities
  - Sci-Hub: access source
- [defaults.json](D:/aghado01/codex-scientiae/src/procurement/configs/defaults.json) now owns endpoints, request pacing, retries, provider ordering, roots, and limits. Provider roles/capabilities remain executable adapter declarations.
- MCP provider arguments are dynamically backend-validated rather than frozen `Literal` enums, preparing for BioRxiv and other additions.
- The non-unitary workflow is operational:

```text
acquire or local-import -> acquisition.json
resolve metadata by artifact identity or explicit DOI
materialize LaTeX source -> article.json
independently rebuild -> inventory.jsonl
```

Important limitations:

- [SciHubProvider](D:/aghado01/codex-scientiae/src/procurement/providers/scihub.py) is currently declaration-only; it advertises the access-source role but no callable acquisition capability.
- Adding BioRxiv still requires editing the static provider type table in [composition.py](D:/aghado01/codex-scientiae/src/procurement/composition.py). The descriptor catalog is extensible, but composition is not yet a clean provider-factory catalog.
- Manual PDF or tarball intake and explicit-DOI metadata work. A PDF alone still cannot mint `article.json`; only the LaTeX-backed article profile exists.
- Inventory publication pins the physical catalog generation. Acquisition staging and source materialization remain pathname-confined but not fully root-identity-pinned—still the main production-cutover blocker.
- Rate limiting has floors, exponential backoff, bounded `Retry-After`, and Semantic Scholar 429 retries. The old mirror/key rotation machinery was not ported. Any compliant endpoint/mirror-pool routing remains a separate design task.
- Background acquisition jobs remain deferred.

The clean resumption sequence is:

1. Final-review and isolate the provider-catalog changes from the artifact-hygiene changes.
2. Replace the static composition tables with a small provider factory/declaration catalog, making BioRxiv addition routine.
3. Commit the green catalog slice on `main`.

4. Implement acquisition-root identity pinning, followed by the more involved source-materialization pinning.
5. Add actual Sci-Hub/BioRxiv adapters and later a versioned PDF article profile.
6. Reorganize the remaining top-level procurement modules after the current behavioral slice is landed.

The latest evidence is under [20261108_223300](D:/aghado01/codex-scientiae/artifacts/test-runs/20261108_223300).
