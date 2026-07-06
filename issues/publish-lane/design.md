# The library system — publish, catalogs, byte-span indexes, and the two-plane MCP split

**Status:** DESIGN (2026-07-06), converged in discussion; supersedes the §8-as-fixed-layout reading.
Replaces nothing yet: `src/publish.ps1` (docling-lane publish) keeps working until this lands.

## Why (the three forces)

1. **Token economy is the product.** The published corpus is read by LLM agents. Cost-in must be
   proportional to relevance: an agent should never pay for a paper — or a section — it didn't choose.
   References/acks are the canonical fat: out of the resident token path, still reachable.
2. **The verticals are frozen.** `compendia/{topic}/` is a directory convention, so introducing a new
   compendium, or promoting `ph-zigzag` out of the generic `ph`, is untooled manual surgery today.
3. **Publish is lane-locked and gate-blind.** `Invoke-Publish` takes a docling `ChunksPath`, gates on
   chunk-lane concepts (pending, sentinels), and cannot publish the LaTeX-oracle deliverables at all —
   currently the *best* content in the repo (2 catalogs, 19 papers, render_check+lint fully green).

## The concept — progressive disclosure over a byte-addressable corpus

Three levels, each a separate fetch an agent *chooses* to make:

1. **Catalog** — lean: one block per paper (title, slug, one-line hook). No embedded per-paper TOCs
   (today's `_CONTENTS.md` inlines them all — fat at catalog scale).
2. **Paper TOC** — the section index: headings/anchors for humans; for machines, **byte spans**
   `[start, end)` per section plus sizes (bytes, ~tokens) so an agent budgets before it fetches.
3. **Section content** — fetched by exact span.

Agent flow: read catalog → reason → fetch TOCs of interesting papers → reason → fetch exact sections.

## Artifacts

```
compendia/{topic}/
  _catalog.json                 # THE manifest: catalog identity + membership + profile + provenance
  _CONTENTS.md                  # human catalog (lean: title + hook per paper); derived, rebuildable
  {slug}.md                     # body (H1 + ## Contents anchor-links + sections)
  {slug}.toc.jsonl              # machine index: one line per section
  references/{slug}.md          # sidecar (profile-dependent)
  images/{slug}/…               # assets (semantic names allowed; imageFileN not mandated)
```

**`{slug}.toc.jsonl`** — one line per addressable unit:
`{ level, heading, anchor, byte_start, byte_end, bytes, tokens_est }`
plus a header line `{ file, sha256, bytes_total, built_utc, builder }`.
- Offsets are **UTF-8 byte offsets computed on the encoded bytes** (SMP math ≠ 1 byte/char —
  membrane codepoint-safety applies with teeth).
- `sha256` of the body file is the **staleness guard**: any reader verifies before serving a span and
  FAILS LOUD on mismatch (patch-lane guard philosophy applied to retrieval). No silent stale reads.
- Granularity v1: heading sections + the References target. v2 candidates: theorems, display blocks,
  figures as addressable sub-units (the converter already knows where they are).
- `tokens_est` = bytes/4 heuristic (budgeting, not billing).

**`_catalog.json`** — catalogs become data, not directory convention:
```json
{ "topic": "ph-zigzag", "title": "…", "description": "…",
  "profile": { "references": "sidecar|inline", "images": "nested" },
  "papers": [ { "slug": "2210.00916",
                "source": "ingestion/compendia/ph-zigzag/2210.00916/2210.00916-latex.md",
                "source_sha256": "…", "published_utc": "…", "lane": "latex" } ] }
```
Provenance (`source` + `source_sha256`) is what powers freshness auditing: a regenerated ingestion
deliverable whose hash no longer matches ⇒ the published copy is stale ⇒ `audit` reports, `refresh`
re-publishes. Publish stops being a one-way copy.

## The two planes (separate MCP toolsets)

**Curator plane — write/maintain (privileged; suggested name `codex-librarian`):**
- `publish(source_md, topic)` — lane-agnostic: takes any **gated** markdown deliverable
  (render_check green + lint clean are THE gates; lane-specific gates stay upstream in their lanes).
  Derives `## Contents` from headings (never assumes one), applies the profile (refs split/inline),
  rewrites image links, copies assets, emits `{slug}.toc.jsonl`, upserts `_CONTENTS.md` +
  `_catalog.json`. Idempotent per (slug, topic).
- `catalog_create(topic, title, profile)` / `catalog_move(slug, from, to)` /
  `catalog_split(from, to, slugs[])` — vertical surgery as transactions: files + manifest + indexes +
  contents move together, provenance preserved. (Worked example: promote ph-zigzag out of `ph`.)
- `index_rebuild(topic|slug)` — recompute spans from current bytes (after any manual edit/merge);
  derived data, idempotent, cheap.
- `audit(topic?)` — the standing verifier: hash-checks every toc.jsonl against its body, every
  catalog member against its ingestion source, every asset link against disk. CI-able; folds into the
  corpus-audit family.
- Human thematic ordering of `_CONTENTS.md` remains a curation act — upsert-in-place, never re-sort.

**Reader plane — access only (unprivileged; suggested name `codex-reader`):**
- `catalogs()` → the verticals (title, description, paper count).
- `catalog(topic)` → the lean paper list (title, slug, hook, TOC pointer).
- `toc(slug)` → the section index (headings + spans + sizes).
- `fetch(slug, section|anchor|byte_span)` → exact bytes, **hash-verified**; section-id sugar resolves
  via the index, raw spans stay available as the composable primitive.
- Read-only by construction: no run model, no ingestion knowledge, works from a bare clone (indexes
  are committed). Safe to hand to any agent; no business performing maintenance, so no ability to.

## Gates & lifecycle rules

- **Publish gates (universal):** render_check green, markdown_lint clean, no defect sentinels.
  Lane-specific notions (chunk `pending`) stay in their lanes.
- **Indexes are derived data**: never hand-edited, always rebuildable, committed for clone-and-read.
- **Only the librarian writes** the published tree (§8's "never by hand", now enforceable by plane).
- **Staleness is always loud**: reader hash-mismatch → explicit error naming `index_rebuild`;
  audit source-mismatch → explicit stale-list naming `refresh`.

## Migration path

1. Build librarian `publish` (lane-agnostic) + toc emitter; publish the 19 green LaTeX deliverables
   into their two catalogs (first real content: `mapper`, `ph-zigzag` as its own vertical from day 1).
2. Build reader (3 tools) against those artifacts; validate the agent flow end-to-end (catalog → toc
   → fetch) on a real question.
3. Catalog surgery ops + audit/refresh; retire `src/publish.ps1` docling path into the same
   librarian entry (its chunk-finalize step becomes just another upstream lane producing gated md).
4. Rewrite STANDARDS §8 as the artifact schema + profiles (layout-as-data), §6 stays the human TOC.

## Open questions (deliberately deferred)

- Sub-section addressing (theorem/figure/display units) — v2, converter already has the knowledge.
- Single-file profile (refs inline) — supported by `profile`, not exercised by the first catalogs.
- Whether librarian hosts inside the membrane server or standalone — same shared module either way
  (src-reorg makes them dot-source the same sources); decision deferred to the reorg.
- Cross-catalog search (grep-tier? BM25 via hashish?) — reader v2; navigation-by-TOC first.
