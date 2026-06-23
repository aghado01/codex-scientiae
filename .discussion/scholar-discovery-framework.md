# The Scholar Discovery Framework — shared core + source adapters

*Status — 2026-06-23: design + build-ready spec. Decisions LOCKED by the user: **shared-core +
adapters** topology; **OpenAlex + Semantic Scholar together** as the first sources, alongside the
existing arXiv. Packaging/repo shape is fluid (migration off the mono-repo ongoing) — this brief commits
to the **core contract + adapter interface + Work model**; where the tools are exposed (which server,
which repo) is the adjustable part. Build it from §7.*

> **Discovery is source-plural; acquisition is source-specific.** Factor one shared core (rate-limited
> + retried HTTP, a normalized Work model, the inbox seam) and make each source a thin adapter behind a
> **unified discovery surface**, so the agentic-RAG loop traverses the whole-literature graph —
> search → related/citations → resolve-DOI → hand to acquisition — regardless of which source answered.

Anchors / reuse:
- Generalize from [`../src/arxiv.ps1`](../src/arxiv.ps1): `Invoke-ArxivApi` (rate-limit + retry),
  `Get-ArxivTransience` (the retry classifier), `Get-ArxivFeedMeta` (paging envelope), the inbox seam.
- Composes with the fetcher family: [`scihub-fetcher-brief.md`](scihub-fetcher-brief.md) (DOI→PDF) and
  the arXiv acquisition lane; feeds [`ingestion-stack-roadmap.md`](ingestion-stack-roadmap.md)'s inbox.

---

## 1. The split that drives the design

| | Role | Sources |
|---|---|---|
| **Discovery** (plural, graph/metadata) | search, citations/references, relatedness, DOI/metadata resolution | OpenAlex, Semantic Scholar, arXiv-search |
| **Acquisition** (source-specific) | stage the actual bytes into the inbox | arXiv-fetch (PDF/source/html), future sci-hub (DOI→PDF) |

OpenAlex and Semantic Scholar are **discovery + graph** sources — cross-publisher, NOT PDF hosts (they
point at OA locations / DOIs). They widen the loop from "arXiv keyword search" to "follow citations,
find related work, resolve a DOI across all of publishing." Acquisition stays where the bytes live.

---

## 2. The shared core (the durable contract)

- **HTTP client** — generalize `Invoke-ArxivApi`/`Get-ArxivTransience` to `Invoke-ScholarApi(BaseUrl,
  Path, Query, Headers)` with a **per-host rate limiter** and the same transient-retry (DNS/conn/timeout
  + 5xx retry; 429/503 fast-fail). Polite identifiers per source (OpenAlex `mailto=`, Semantic Scholar
  optional `x-api-key`).
- **The normalized `Work` model** — every adapter emits this lingua franca so the agent synthesizes
  across sources uniformly:
  `{ source, source_id, doi, arxiv_id, title, authors[], abstract, year, venue, oa_url, pdf_url,
     citation_count, references_count, tldr?, fields[]/concepts[], external_ids{} }`.
  `arxiv_id` **and** `doi` both present when known — that cross-walk is what lets the agent pick the best
  acquisition route (prefer arXiv `source` when `arxiv_id`; else DOI→sci-hub).
- **Inbox seam** — already source-agnostic (stable key = arXiv id or sanitized DOI); reuse as-is.
- **Adapter contract** — each source implements: `search`, `get_work`, `related(kind)`, `resolve`.
  Returns `Work[]` (+ paging envelope) in the normalized model. New source = new adapter, nothing else.

---

## 3. The unified discovery tool surface

| Tool | Does |
|---|---|
| `discover_search(query, source?, filters, start)` | search one source, or fan across; `Work[]` + paging envelope (total_available/next_start), consistent with the arXiv search shape |
| `discover_related(id\|doi, kind, source?)` | graph traversal — `kind` = `citations` (who cites it) \| `references` (what it cites) \| `recommendations` (semantically related) |
| `resolve_doi(reference\|title\|doi)` | reference → canonical DOI + `Work`; the backbone for cross-source linking and the sci-hub hand-off |
| `get_work(id\|doi, source?)` | full normalized record |

arXiv's `search`/`get_metadata` re-express cleanly as the **arXiv adapter** behind `discover_search`,
while `codex-arxiv` keeps `fetch`/inbox as the acquisition lane (no change to acquisition).

---

## 4. Exposure (packaging — fluid)

Recommend a **new `codex-scholar` discovery MCP** (sibling to `codex-arxiv`) on the shared core +
all adapters; `codex-arxiv` stays the acquisition lane. Ship a `discovery_procedure`-style prompt for
the **cross-source** RAG loop (search → expand by citations/related → resolve → acquire). Packaging may
change with the repo migration; the core + adapters are the part that survives.

---

## 5. Source specifics + realities (honest, verify on build)

**OpenAlex** — `https://api.openalex.org`
- `GET /works?search=…&filter=…&per-page=…&cursor=…` ; `GET /works/{openalex_id | doi:DOI | arxiv:ID}`.
- Citations: `?filter=cites:{id}`. References: `work.referenced_works[]`. Concepts: `work.concepts[]`.
  OA PDF: `work.best_oa_location.pdf_url`. arXiv ⇄ DOI both exposed.
- **Free, NO key.** Use the polite pool via `mailto=<user email>`. Cursor-based deep paging. Rich filters.

**Semantic Scholar** — `https://api.semanticscholar.org/graph/v1`
- `GET /paper/search?query=&fields=…` ; `GET /paper/{id}` where id can be `DOI:…`, `ARXIV:…`, `CorpusId:…`.
- `GET /paper/{id}/references` and `/citations`; recommendations: `/recommendations/v1/papers/forpaper/{id}`.
- Fields of interest: `tldr` (one-line summary), `embedding` (SPECTER), `influentialCitationCount`,
  `openAccessPdf`. arXiv ⇄ DOI exposed.
- **Keyless works but is RATE-LIMITED** (shared pool, aggressive throttle) — the per-host limiter +
  transient-retry matter here; optional `x-api-key` (env var) lifts limits. Treat 429 as fast-fail+wait.

---

## 6. How it composes with the rest

`discover_*` surfaces ids/DOIs → the `Work.arxiv_id`/`Work.doi` cross-walk picks the route → acquisition
(`codex-arxiv fetch` by arXiv id, prefer `source`; or sci-hub by DOI) → inbox → conversion stack. The
**input-quality ladder** (source > html > PDF-geometry > scanned) is chosen here, at discovery time,
because the Work record already says what's available.

---

## 7. Build increments (delegable / incremental)

1. **Shared core** (`scholar-core.ps1`): `Invoke-ScholarApi` (per-host rate-limit + retry, lifted from
   arxiv), the `Work` model + helpers, the adapter contract. Cheapest, most reusable.
2. **Adapters** (`openalex.ps1`, `semanticscholar.ps1`): `search` / `get_work` / `related` / `resolve`,
   each normalizing its JSON to `Work`.
3. **`codex-scholar` server**: the four tools (§3) + a cross-source discovery prompt; register in `.mcp.json`.
4. **arXiv adapter** (optional now): re-express arXiv search behind `discover_search` for uniformity,
   leaving `codex-arxiv` acquisition untouched.
5. **Tests + smoke**: offline JSON-fixture parsers per source + `Work` normalization + DOI/arXiv
   cross-walk; one live smoke per source (small, polite).

---

## 8. Open / deferred

- **Cross-source dedup** when fanning: merge `Work`s by DOI / arXiv id (the same paper appears in both
  graphs) — a real merge step before the agent synthesizes. Resolve in increment 3.
- **Rate-limit budget across sources** (S2 is the tight one) — conservative per-host limiter; key via env.
- **Whether arXiv-search migrates** into the discovery surface or stays dual-exposed — packaging call,
  defer to build (lean: dual for now, no churn to the working acquisition server).
