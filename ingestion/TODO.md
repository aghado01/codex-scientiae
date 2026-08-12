update procurement mcp to download to `staging` with {slug} dir

rename `ingestion` to `procurement`

add a versioned PDF-only producer for the canonical article.json sentinel

- require a validated PDF form plus an explicit DOI/arXiv identity before publication
- keep automatic PDF identifier extraction as candidate evidence; never select the first bibliography DOI
- dispatch article validation by source profile without weakening existing LaTeX deposits

- then build reconciliation/cross-validation when latex+pdf are present

back migrate old \_inbox after updating procurement and inventory conventions

consolidate procurement MCPs
