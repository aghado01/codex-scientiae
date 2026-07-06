# Library v1 — construction plan (librarian, bibliotheca, lifecycle, reader)

**Status:** PLAN (2026-07-06). Companion to `design.md` (the concept). Scope = v1 only: structural
rung, geometry-free; the semantic tier is designed-for but not built here.

## Work breakdown

### A. Bibliotheca architecture (the ground)
- `bibliotheca/` root in-repo; root manifest (`_BIBLIOTHECA.json`) + human index (`_BIBLIOTHECA.md`)
  = what reader `catalogs()` serves. `BIBSCI` env var → root (user-level + PDenv bootstrap).
- Per-catalog: `_catalog.json` (identity, profile, membership w/ provenance {source, source_sha256,
  lane, published_utc}), `_CONTENTS.md` (lean: title + hook per paper), bodies, `{slug}.toc.jsonl`,
  `references/`, `images/{slug}/`.
- ALL artifacts committed; UTF-8 no BOM; indexes = derived data (rebuildable, never hand-edited).

### B. Librarian — promotion logistics + standards
- `publish(source_md, catalog)`: gate (render_check + lint + sentinels) → transform per profile
  (refs → sidecar; Contents block DERIVED from headings, §6 indentation; image links → images/{slug}/)
  → emit toc.jsonl (UTF-8 byte offsets + sha256 header) → upsert `_catalog.json` + `_CONTENTS.md`.
  Idempotent per (slug, catalog). Lane-agnostic input; slug = versionless arXiv id, version in
  provenance.
- Standards work: rewrite §8 as artifact schema + profiles once publish exists (write the code first,
  extract the contract from what's true).

### C. Lifecycle machinery
- `index_rebuild(catalog|slug)` — rescan bodies, recompute spans/hashes. Cheap, idempotent.
- `audit(catalog?)` — verify: every toc sha vs body bytes; every member's source_sha256 vs its
  ingestion deliverable (stale-publish detection); every image link vs disk; manifest membership vs
  directory truth. CI-able; corpus-audit family.
- `refresh(slug)` — re-publish a stale member from its provenance source.
- (Migration-era, not v1: catalog_create/move/split surgery.)

### D. Reader MCP — mount semantics (S3FS-style, the jso-jackson lineage)
- **`Mount-Bibliotheca($env:BIBSCI)`** at server init: load root manifest → catalog manifests →
  RETURN A MOUNT HANDLE; all tools traverse the handle, never raw paths. Lazy per-file toc load with
  **sha verification on first touch** (mount-time validation replaces jso's snapshotting — the corpus
  is git-versioned and plane-enforced read-only, so verify-don't-copy gives the same immutability).
- `fetch` = FileStream seek + exact byte-range read (never full-file read) — the .jidx discipline.
- Hash mismatch anywhere = loud error naming `index_rebuild` (librarian's job, not reader's).
- Response discipline lifted from the jso guidelines verbatim: targeted probes over dumps, preview
  before expanding, counts/structure before content — the token-economy ethos as tool contract.

## jso-jackson lift assessment (C:\Users\azrie\.claude\tools\jso-jackson)

**Concept lifts (strong):**
- `JsonlFile::MountSnapshot(snapshot, index) → Traverse()` — THE reader backend shape.
- `.jidx` sibling-index convention (int64 offsets, byte-scanned, no string allocation) — toc.jsonl is
  this idea generalized from "line k" to "section k" over markdown; and .jidx itself remains useful
  verbatim for large JSONL artifacts.
- Hash sidecars + verify (`New/Test-JsonlHashIndex`) — the guard pattern, pre-echoed.
- Layering: hash primitives / jsonl primitives / workflows / domain servers — mirror it:
  `core json-io / span-index primitives / librarian workflows / reader server`.
- Probe-before-dump usage doctrine (README) — becomes the reader's response contract.

**Code lifts (selective, with hardening):**
- `ConvertTo-CanonicalJson` — stable manifest hashing needs canonical serialization.
- Byte-scan offset builder pattern — adapt from newline-scan to UTF-8-correct heading scan.
- `JsonlIndex` build/load — reuse for any jsonl sidecar consumers.
- Bloom filters — NOT v1; parked as a cheap corpus-wide term pre-screen for the lexical tier.
- claude-jso-units' stream→addressable-units grouping — conceptual kin to section unitization;
  revisit when sub-section (v2) addressing lands.

**Hardening ledger (the primitives are pre-gotcha vintage — apply the session's lessons):**
- ordinal dictionaries/comparers everywhere keys are identifiers (case-insensitive PS hashtables);
- never `-ne`/String.Replace for content decisions (culture traps) — [regex] ordinal + explicit gates;
- `switch -CaseSensitive` where arms differ by case; no variable reuse modulo case ($r/$R);
- collection returns pinned (`return ,$list`); value-type closure scoping (hashtable state in
  MatchEvaluators); UTF-8-no-BOM `[IO.File]` everywhere; byte offsets computed on ENCODED bytes.

## Open (blocking construction start)
1. Server names (working: codex-librarian / codex-reader; lector candidate).
2. Confirm bibliotheca in-repo at codex-scientiae root.
3. Reader registration pattern for other projects (per-project .mcp.json vs user-level).
4. Where the shared low-level layer lives: `src/jso/` as jso-jackson v2 (hardened primitives graduate
   into the repo), keeping the toolshed original intact as-is.

## Build order
1. Shared primitives (`src/jso/`?): canonical json, jsonl IO, UTF-8 span scanner — WITH Pester tests
   (tests/ convention; the hardening ledger is the test spec).
2. Librarian `publish` + toc emitter → publish the 19 green papers → bibliotheca/{mapper, ph-zigzag}.
3. `audit` + `index_rebuild` (lifecycle floor).
4. Reader server (mount, catalogs/catalog/toc/fetch) → register in a second project → validate the
   full flow (catalog → toc → fetch) on a real question from SPCX.
5. §8 rewrite from the shipped truth.
