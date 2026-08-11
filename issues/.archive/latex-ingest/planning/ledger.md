# latex-ingest — ledger (completed)

Newest first. Detail lives in the field notes
([probe-prose-channel-20260802.md](../discussions/probe-prose-channel-20260802.md)) and commit
messages; this is the index of what landed.

## 2026-08-08

- **Canonical per-document LaTeX patch lane** (D20). The converter now resolves only
  `{document-directory}/{slug}-latex.patch.jsonl`, keeps the stable source tree and generated `OutDir`
  independent, and treats absence as faithful input rather than searching generated output. The domain-owned
  reader retains blank and full-line-comment tolerance while enforcing UTF-8/no-BOM bytes, a closed record
  vocabulary, the article schema's exact portable-leaf slug rule, literal non-reparse lookup, a 1 MiB raw
  byte ceiling, guarded operations, physical-line provenance, bounded regular expressions, and raw-byte
  identity. Source and output phases retain their execution boundaries while `patched[]` projects applied
  records back into authored file order; conversion and oracle evidence agree on identity and count. Batch
  planning obtains `absent` or `sha256:<digest>` through a bounded incremental read, pins that identity into
  stable job identity, and transports the planned slug with it. Before writes, the core compares the resolved
  slug ordinally and refuses slug drift in supported legacy metadata; it separately refuses patch appearance,
  deletion, or byte drift without treating the curated input as a write. Focused Pester 6 gates are 22/22
  patch-contract tests, 10/10 adapter tests, and 7/7 integration tests, including a real article deposit,
  separate conflicting `OutDir`, unchanged source fingerprint, provenance/order, and deterministic rerun.

## 2026-08-06

- **Localized inventory 0.1 + latex-batch development entrypoint** (D18). Added a schema-bound,
  deterministic direct-child `inventory.jsonl` materializer/reader over source-ready sentinels and a
  `src/latex-ingest/latex-batch.ps1` shell that selects catalog rows, allocates or joins one caller run, and
  composes the existing adapter and executor without implicit initialization. Focused coverage proves
  byte-identical rebuilds, invalid-sentinel atomicity, stale detection, ownership structure, selection,
  automatic `artifacts/latex-batch/runs` allocation, sibling failure containment, and child cleanup. The
  retained 11-paper development inventory materializes and rereads 11 rows; a real selected-paper wrapper
  run completed in 9.811 s with a clean math audit and no surviving child. Complete LaTeX-ingest and adapter
  gates are 108/108 and 23/23, and the four-worker repository gate completed all 46 containers with 490
  selected tests and no failed job.

## 2026-08-03

- **docstream + latex refgraph + doc graph as production artifacts** (D7 layers; `0f07c3d` +
  golden regen `e9bd8cc`). Walk graduated to `src/latex-ingest/docstream.ps1`; capture unconditional; float
  bundles realized at the tail (`Render-FloatBundle`, both check directions); `\FloatBarrier` +
  `\appendix` deliverable leaks closed; algorithm label map added — exposed silently-WRONG alg
  refs (custom-counter shadow), now typed and correct.
- **Channel batch: inline `\verb`, algorithm2e, tables + golden pin** (`9be693e`, `fc64724`).
  Closing sweep: 43/43 papers convert, ledger collapse (`\small` 301→20), 2405 residue
  2716→25. New seam found: verb-in-table loss (2605.01664v1).
- **Refs model + normalization flag + proof spine + paragraph grain + cite qualifiers**
  (`74336a8`, `bac5bd9`). `{slug}.refs.jsonl` sidecar; `-FaithfulNumbering` end-to-end;
  Build-LabelMaps flat-thm map deleted (refs-consolidation step 2); 2405 empty-math-span crash
  fixed.
- **The tackle** (`538bde6`, `3e4d288`, `0a0d3b8`): lexicon o-corruption repaired (4 damaged
  glyph entries; pure-ASCII keys refused at load) + Store-Math diagram divert; brace-aware
  text-format/heading/caption renders; front-matter discard-then-capture ordering. Result:
  leaked 0 AND orphaned 0 corpus-wide.
- **Sweep census ×3** (`c4c3004` field notes): 34 → 42 → 43/43 papers; residue taxonomy;
  placement-evidence census; normalization guard corpus-green.

## 2026-08-04

- **Closing sweep with the graph layers**: 43/43 convert; corpus refgraph = 7,301 edges,
  1,494 dangling → classified **bib-missing 1,226** (staging fact: sources without `.bbl`),
  **declared-unmapped 121** (the remaining converter class — next fixes live here),
  **undeclared 147** (author errors, rendered honestly). Closure invariants hold corpus-wide.

## 2026-08-02

- **Probe passes 1–5** (`44b2864`, `8d7848b`, `b38617d`, `33ede29`, `459fa66`): prose channel
  emission + closure both directions; placement evidence (barriers, specs); residue 3→2→0 on
  the first specimen (appendix admitted, bracket-aware theorem titles fixed); the full
  interleaved stream (spine rows, silhouette-parity addressing); numbering as (mode, ordinal,
  regime) with faithful/normalized projections + injectivity guard.
- **Doctrine captures** (discussions/): latent manuscript, protograph, channel/graph
  refinements, KisungYou silhouette census.
