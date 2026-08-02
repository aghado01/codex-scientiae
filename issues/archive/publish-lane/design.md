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

## DECIDED (2026-07-06 review)

- **New root: `bibliotheca/`** — the library system publishes into a fresh root, NOT into the legacy
  `compendia/` tree. First catalogs: `mapper` + `ph-zigzag` (as its own vertical from day 1) from the
  19 green LaTeX deliverables. Legacy `compendia/` stays live and untouched until migrated catalog by
  catalog — which is when lane-priority replacement and the ph carve actually run.
- **`BIBSCI` env var** — a system-path variable pointing at the bibliotheca root. The reader MCP
  anchors on `$env:BIBSCI` (never cwd/repo-relative), so any OTHER project (SPCX, MarkPig, …) can
  equip the reader and do knowledge-driven coding/reasoning against the library. Set at user level;
  also add to the PDenv bootstrap (portable env may not inherit).
- **TOC granularity v1 = markdown headers with levels** (what the deliverables already have) + the
  References target. Sub-units (theorems/figures/display blocks) are v2.
- **Indexes and all supporting data are committed** to git — clone-and-read, rebuildable derived data.
- **fetch contract confirmed**: section-id sugar + raw byte spans; hash mismatch = loud error naming
  `index_rebuild`; responses carry the sha for agent-side cache validation.
- **`compendia/tmp`** is post-promotion work debris — pure noise apart from possibly reusable tools;
  triage its contents for tool salvage during migration, then delete.

## Artifacts

```
bibliotheca/{catalog}/
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
                "source": "ingestion/gauntlet/ph-zigzag/2210.00916/2210.00916-latex.md",
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
- `batch_ingest(targets[], job_types?, workers?, force?)` — the upstream batch throughput surface
  (added 2026-07-15, user direction): a thin wrap of `src/ingest-batch.ps1`'s `Invoke-IngestBatch`,
  which was built parameters-in/rows-out precisely for this exposure. Location-driven targets (any
  pdf / source tarball / paper dir / group dir; explicit files imperative = the hot-example
  iteration loop), greedy parallel child-process pool, intake guards (magic-byte sniff doubles as
  the in-flight-download guard), one-time pre-deployment tectonic warmup. This is the librarian's
  ingestion-maintenance workhorse — batch regen after converter landings, new-corpus first grinds,
  oracle-sidecar refresh — and stays curator-plane (it spends compute and writes runs; readers
  never see it).

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

1. Create `bibliotheca/` root + set `BIBSCI` (user-level env + PDenv bootstrap). Root index
   (`_BIBLIOTHECA.md` / manifest) is what the reader's `catalogs()` serves.
2. Build librarian `publish` (lane-agnostic) + toc emitter; publish the 19 green LaTeX deliverables
   into `bibliotheca/mapper` + `bibliotheca/ph-zigzag`. Fresh root ⇒ zero collision with legacy.
3. Build reader (BIBSCI-anchored, read-only) against those artifacts; validate the agent flow
   end-to-end (catalog → toc → fetch) on a real question, ideally FROM another project via BIBSCI.
4. Catalog surgery ops + audit/refresh. Then migrate legacy `compendia/` catalog-by-catalog INTO
   bibliotheca — this is where lane-priority replacement (latex > membrane > docling) and the
   ph → ph-zigzag carve execute; triage `compendia/tmp` for salvageable tools, delete the rest.
   Retire `src/publish.ps1` (its chunk-finalize becomes just another upstream lane producing gated md).
5. Rewrite STANDARDS §8 as the artifact schema + profiles (layout-as-data), §6 stays the human TOC.

## Semantic tier (down-the-line, designed-for now)

Multiresolution semantic search that MATES with the reader rather than paralleling it. The load-bearing
decision: **embeddings ride the span substrate** — the units embedded are exactly the units the TOC
index defines (paper-level: title+hook/abstract; section-level: the spans; v2: sub-units). A semantic
hit is therefore a NAVIGABLE ADDRESS `(slug, section, span, score)` in the same coordinate system
`toc`/`fetch` speak — never a floating chunk. Structure-augmented retrieval is preserved: land mid-paper
with breadcrumb/parent/siblings one hash-guarded fetch away. Coarse-to-fine = the agent's own
progressive-disclosure flow run in embedding space (paper shortlist → section hits → span).

**Retrieval ladder** (each rung independently useful):
1. structural — TOC navigation (v1)
2. lexical — BM25/SimHash: hashish (SPCX) is a dependency-free C# lib that already implements this
   tier; no model, no query-embedding, shippable right after the reader
3. semantic — embeddings for open-ended queries; hybrid fusion (RRF) with the lexical tier

**Model strategy:** tier-1 = STATIC embedding models (model2vec/potion class): tiny, CPU-instant
(lookup+pool, no transformer inference), deterministic, vendorable — keeps the READER self-contained
for query embedding (its contract: bare clone, no infra). Tier-2 (optional, later) = local gguf
contextual model via llama.cpp as re-ranker over tier-1 candidates only (the local-worker substrate).

**Lifecycle:** embeddings are derived data built by the librarian (`index_embed`), committed, guarded
by {file sha256, model_id, model_version} in the sidecar header — mismatch fails loud; model upgrade =
versioned corpus re-embed (never mix model generations in one search). Reader gains
`search(query, catalog?, level?, k)` returning spans + scores + structural breadcrumbs.

**Scale:** brute-force cosine over a flat committed matrix is sufficient to ~50-75k section vectors
(≈1,000 papers, milliseconds); int8 quantization = 4x headroom; ANN infra explicitly deferred.

**Geometry channels (NOT settling on cosine — decided 2026-07-06):** grounded in the kisungyou corpus
(2504.14164 "Semantics at an Angle: When Cosine Similarity Works Until It Doesn't": norms carry
semantics, embedding spaces are anisotropic cones, magnitude-is-noise is broken) and the ThermoMapper
geometry program. Cosine's failures are STRUCTURAL for this design: the corpus is a TREE (hyperbolic
space embeds trees with arbitrarily low distortion; Euclidean/spherical provably cannot), and
multiresolution retrieval is ASYMMETRIC containment (query→section is entailment-shaped; cosine is
symmetric by construction; the hyperboloid radial coordinate gives generality/depth a representation —
coarse-to-fine as geodesic descent, norm-carries-meaning embraced rather than normalized away).

Embedding sidecars therefore declare a CHANNEL: { geometry: euclidean|sphere|hyperboloid(Lorentz)|
product, curvature, dim, model_id, model_version, built_from, sha256 }. Channels coexist per catalog;
`search(query, …, channel?)`; librarian `index_embed -Channel`; the retrieval EVAL harness — not
aesthetics — picks winners.
- **ch0 (baseline, explicitly not the commitment):** spherical cosine over static embeddings, WITH the
  standard anisotropy debias (mean-centering/whitening) per the cosine critique. Exists to be beaten.
- **ch1 hyperboloid (Lorentz model — numerically preferred; matches You's wrapped-normal work):**
  corpus units re-embedded into H^n supervised by BOTH the semantic kNN graph AND the structural tree
  edges — the backbone-conditioned move. Distance = arcosh(−⟨x,y⟩_L); the C# hyperboloid/poincaré
  metrics in src/hdbscan/Evaluators.cs REUSE directly. Query side, phased: (a) Euclidean shortlist →
  hyperbolic re-rank (no query lift needed), (b) learned query lift (exp-map at fitted base point).
- **ch2 candidate: product manifolds** (S×H mixed curvature — clusters AND hierarchy; You's
  geometric-medians-on-product-manifolds line is in the corpus).
The library doubles as the ThermoMapper metric program's testbed: retrieval quality = the observable.

**Dual-register embeddings (decided 2026-07-06):** prose and math are embedded SEPARATELY, potentially
by different models — mixing KaTeX into prose vectors muddies both registers. REGISTER is an axis of
the channel schema alongside geometry: { register: prose|math, geometry, model_id, … }. Queries route
by register or fuse (RRF) across both.
- **SYMMETRIC MASKING (decided):** both channels are register-complementary masked views of the SAME
  span unit — `Mask-Register(section, keep=prose)` ↔ `Mask-Register(section, keep=math)`. One
  transform, two registers, one address space (a hit in either register resolves to the same
  (slug, section, span); no sub-unit bookkeeping until v2 formula-level addressing).
  - Prose channel: math → ⟨MATH⟩ slots ("combining ⟨MATH⟩ with the triangle inequality" stays
    sensible prose; referential flow preserved).
  - Math channel: prose → ⟨PROSE⟩ slots — preserves derivation RHYTHM (eq→⟨PROSE⟩→eq→eq: the
    arrangement of formulas and their connective tissue is signal that formula-extraction loses).
  - Emergent: math-sparse sections yield weak math vectors — in the MATH register. The registers are
    DISSOCIABLE, not gated: see fusion semantics below.
- **Fusion semantics (decided 2026-07-06): separation exists to make fusion principled.** Mixed
  embeddings fuse ACCIDENTALLY inside one vector, weighted by token volume (prose drowns math and vice
  versa). Separated channels rank per-register, then combine EXPLICITLY in rank space:
  - Default `search` = ALL active channels, rank-fused (RRF-class — sidesteps cross-model score
    incomparability; a strong math hit surfaces even when prose similarity is everywhere mediocre:
    the formalization of "one register doesn't drown the other"). Register routing = optional
    narrowing, never the default.
  - Reconciliation is STRUCTURAL via the shared address space (symmetric masking's payoff): same unit
    hit in both registers → concordant, boosted; math-only → the derivation w/o discussion; prose-only
    → the discussion w/o formulas (the math-sparse paper competes fairly in its own register).
  - Result envelope groups per unit: { slug, section, span, scores: {prose, math}, fused, breadcrumb }
    — evidence provenance legible to the reading agent (a math-only hit invites a toc-neighbor fetch
    for surrounding prose; a concordant hit is the strong lead).
- **Math content itself:** the corpus advantage is the REGISTER DISCIPLINE — polished primitive KaTeX
  (macro expansion already canonicalized every paper's private vocabulary to a shared alphabet), never
  glyph soup. Semantic-vs-syntactic reality (ARQMath/Tangent-CFT lineage): strings lose math
  semantics; STRUCTURE wins — the mature route is canonicalize-then-embed, and the canonicalizer is
  mathdig (AST → α-normalized, argument-ordered linearization → embed). Math-register embeddings are
  thereby mathdig's SECOND consumer — strictly downstream, nothing depends on it existing; the
  primitive-KaTeX masked-view channel is the honest interim.
- **Fine-tune seam (self-supplied):** contrastive pairs mined from the corpus itself — the same
  standard theorems/definitions restated across papers (interleaving stability, quiver reps …),
  registry = the oracle math bank. Small, well-posed; not a moonshot.

**Net-new compute (Lorentz fits, embedding tooling): NEW C# projects** under the existing build
convention, SEPARATE from hdbscan; BORROW/lift from ThermoMapper rather than import it (SPCX is a
scientific-computing stack with its own integration concerns; applications here are strictly more
focused). Lessons feed back to ThermoMapper later.

## Open questions

- **Names for the two servers** (working: `codex-librarian` write / `codex-reader` read; with the
  bibliotheca framing, `codex-lector` is a candidate for the reader).
- Where exactly `bibliotheca/` sits: in-repo at the codex-scientiae root (committed ⇒ BIBSCI points
  into the working copy) is the presumption — confirm.
- Reader registration pattern for other projects: per-project .mcp.json pointing at the reader script
  (which lives here) + BIBSCI, vs a user-level registration.
- Sub-section addressing (theorem/figure/display units) — v2, converter already has the knowledge.
- Single-file profile (refs inline) — supported by `profile`, not exercised by the first catalogs.
- Whether librarian hosts inside the membrane server or standalone — same shared module either way
  (src-reorg makes them dot-source the same sources); decision deferred to the reorg.
- Cross-catalog search (grep-tier? BM25 via hashish?) — reader v2; navigation-by-TOC first.
