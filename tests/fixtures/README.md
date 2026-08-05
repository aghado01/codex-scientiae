# Test fixtures

Durable, committed artifacts that let tests pin behavior without depending on regenerable working output.

## `2408.16741v2.refs.golden.jsonl`

Golden reference-model projection for `tests/latex-ingest.refs.Tests.ps1`. It pins every declared label
with normalized and faithful display projections, plus rendered reference-site text in source order.

Regenerate it only after understanding and accepting a reference-model change. Follow the production
reference-model setup in `tests/latex-ingest.refs.Tests.ps1` against the staged `2408.16741v2` source,
serialize the same `label` and `site` rows, compare them with the pin, and replace the fixture
deliberately. There is no automatic refresh command: never rewrite the golden merely to silence a test.

The former `chunks/` fixtures and their regenerator belonged exclusively to the retired codex-membrane
corpus suites. They were removed with the remaining active-tree references after that product's eviction.
