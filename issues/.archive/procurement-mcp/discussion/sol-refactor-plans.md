## Recommended sequence

1. Stabilize the current functional work before moving modules; the checkout is still heavily modified.
2. Remove the four orphan legacy JSON files, five dead Pester containers, and stale ignore/documentation references.
3. Rename `stores/discovery.json` to `config/defaults.json`; make JSON the sole authority for operational defaults.
4. Move provider declarations into provider classes and rename `ProviderRegistry` to `ProviderCatalog` to avoid collision with the engine’s persisted Registry concept.
5. Perform mechanical module moves with temporary re-export shims.
6. Correct the `jsonl_engine` dependency direction and consolidate filesystem/publication primitives.
7. Add JSONL acquisition views or job ledgers only when a real reader or lifecycle requires them.

- `jsonl_engine` owns `article.schema.json`, `article.json` publication, and `inventory.jsonl`.
- Procurement owns `acquisition.schema.json`, `deposit.metadata.schema.json`, provider evidence, and the adapter that projects procurement metadata into an article.
- Importing `jsonl_engine` no longer imports procurement.

The generic extension contract is in [article.py](D:/aghado01/codex-scientiae/src/jsonl_engine/kinds/article.py:24). Procurement supplies its layered schema catalog and article adapter in [schemas.py](D:/aghado01/codex-scientiae/src/procurement/storage/schemas.py:14) and [article.py](D:/aghado01/codex-scientiae/src/procurement/storage/article.py:20). The CLI can load that extension explicitly without acquiring a static dependency.

### Provider categories

Provider categories are now explicit in [defaults.json](D:/aghado01/codex-scientiae/src/procurement/configs/defaults.json:5):

- Aggregators: OpenAlex, Semantic Scholar
- Repositories: arXiv, Zenodo; future BioRxiv fits here
- Access-only: Sci-Hub

This grouping is currently a bridge. [composition.py](D:/aghado01/codex-scientiae/src/procurement/composition.py:268) still duplicates the expected classifications and manually constructs each adapter. The next provider pass should introduce typed provider descriptors/factories so capabilities and roles are derived from registrations, while configuration controls endpoint policy, ordering, and enablement.

### Package consolidation

The provisional target is now recorded in [procurement-python-architecture.md](D:/aghado01/codex-scientiae/issues/mcps/procurement-python-architecture.md:214):

```text
procurement/
  configuration/       validated settings and loaders
  configs/             non-secret deployment data
  domain/              identifiers, works, metadata, acquisition, source models
  providers/
    aggregators/
    repositories/
    access/
  operations/          discovery, metadata, acquisition, import, materialization
  infrastructure/      HTTP, filesystem, archive handling
  storage/             procurement stores, schemas, article adapter
  schemas/             actual JSON Schemas only
  composition.py
```

The priority split candidates are currently `archive.py` (1,155 lines), `models.py` (966), `source.py` (784), `payloads.py` (598), and `http.py` (595).

Do not force everything into JSONL:

- `defaults.json` is configuration.
- `acquisition.json` is one bounded, collated receipt.
- API metadata is one bounded evidence document.
- `inventory.jsonl` is correctly a rebuildable registry.
- A future `acquisitions.jsonl` could be a derived registry view.
- A future background-job history could use a Log/Ledger, once that lifecycle exists.

### Storage slice

The next storage slice should add a procurement `BaseStore` default and procurement-local kind catalog, then migrate `acquisition.json` and API-metadata publication onto those kinds. I would not force `defaults.json` through `BaseStore` or a JSONL registry: it is currently one validated configuration resource, not a keyed published population.

### Additional reuse

The other worthwhile engine reuse is filesystem publication. Physical-directory checks, stable reads, generation witnesses, hashing, and no-clobber publication are currently repeated across [filesystem.py](D:/aghado01/codex-scientiae/src/procurement/filesystem.py:1), [storage/acquisitions.py](D:/aghado01/codex-scientiae/src/procurement/storage/acquisitions.py:29), local import, archive inspection, and engine publication. The generic primitives should be consolidated around [PinnedPublicationRoot](D:/aghado01/codex-scientiae/src/jsonl_engine/publication.py:144) or a small neutral artifact-I/O package, then used by acquisition and source-deposit transactions.
