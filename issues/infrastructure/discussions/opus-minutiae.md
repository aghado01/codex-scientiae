Yes, it makes sense — and your own [ingestion/TODO.md](ingestion/TODO.md) already states the destination, which matches what I found on disk. Here's what I verified.

## The `_inbox` blast radius is small — it's a seam by design

The literal appears in exactly four places that matter:

- [arxiv-staging.json:11](src/procurement/arxiv-staging.json:11) — `"staging_root": "ingestion/_inbox"`
- [arxiv.ps1:83](src/procurement/arxiv.ps1:83) — in-code default fallback
- [zenodo-staging.json:9](src/procurement/zenodo-staging.json:9)
- [zenodo.ps1:17](src/procurement/zenodo.ps1:17)

`scholar-server.ps1` reads arxiv's config, and `scihub-get.ps1` takes `StagingRoot` as a param — both inherit the fix for free. Everything else is prose in tool descriptions plus the `list_inbox` tool name. So the repoint to `ingestion/staging` is four strings, exactly as the config's own `description` promised.

One benign note: `Get-ArxivInbox` scans the staging root recursively but keys off the `.arxiv.json` suffix, so your hand-dumped PDFs in `staging/isolet-literature/` and `staging/misc/` stay invisible to `list_inbox` rather than colliding with it.

## Three decisions I'd want from you before editing

**1. Archive filename on landing.** Procurement's layout writes `{slug}/{slug}.tar.gz`, but all eleven existing inventory leaves are `arXiv-{slug}.tar.gz`, and `Initialize-LatexSourceDeposit` normalizes the alias to the bare name _only after_ extraction/confinement validation passes. That makes the alias a meaningful state marker: "acquired, not yet validated." If procurement lands the bare name, it forges the validated form. I'd have procurement emit `arXiv-{slug}.tar.gz` so the alias consistently means un-vetted — which also makes staging→inventory transport a plain move.

**2. `artifact.json` vs `metadata.json`.** The string `artifact.json` exists in exactly one place in the repo — line 5 of your TODO. The per-document manifest is `metadata.json` (`codex-scientiae/document-metadata/0.1`, schema under `src/shared/jsonl_engine/schemas/`). Assuming that's just shorthand for the same manifest, not a new artifact.

**3. Reconciliation has a socket already.** [CONVENTION.md](ingestion/inventory/CONVENTION.md) states it directly: a newly acquired form "updates the same manifest through an explicit, validated operation. It does not create a competing document manifest." The provisional schema already reserves field/source provenance and explicit conflict handling. So the PDF lane isn't a second manifest writer — it's a second evidence contributor into the existing one, and what's actually missing is (a) the PDF-side extractor and (b) the conflict-resolution policy when LaTeX and PDF disagree. Your `2602.00217v3` is the only leaf with both forms, so it's the reconciliation test case; the three PDF-only leaves (`2410.02707v4`, `2607.09648v1`, `2607.11883v1`) are the PDF-alone path.

Worth noting the inventory is fully at square one — no `metadata.json`, no `{slug}-tex/`, no `inventory.jsonl` anywhere. Clean slate for exercising the transaction.

## Same-cleanup fallout, your call whether to touch now

- [ingestion/README.md](ingestion/README.md)'s "Existing top-level segments" table still lists `_inbox/`, `re-ingest/`, `_markdown/`, `codices/`, `compendia/` — only `inventory/` and `staging/` remain.
- [corpus-audit.ps1:28](src/audits/corpus-audit.ps1:28) defaults `-Roots` to `bibliotecha/{compendia,codices,corpora}`; `bibliotecha/` is now an empty dir. That tool currently has nothing to audit.
- `.runs/` and `bibliotecha/` are both empty directories at root.

Want me to start with the mechanical repoint (four strings + the server prose, plus [tests/procurement/arxiv.Tests.ps1](tests/procurement/arxiv.Tests.ps1)), and settle the archive-alias question as part of it? The PDF→manifest extractor is the substantial piece and deserves its own pass.
