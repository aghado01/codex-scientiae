# HTML site acquisition (arXiv)

Land arXiv HTML papers as a confined page-requisites tree under the document leaf. Reuse `HttpClient` (rate clock, host allowlist, hashing). Do not shell wget. Do not convert HTML→Markdown in this work.

## Non-goals

- MarkPig / math-register conversion of HTML
- Fetching CDN CSS/JS (`static.arxiv.org`)
- Rewriting links in acquired HTML (`wget -k`)
- Atom “discovery” of the HTML URL (Atom’s `type="text/html"` is the abs page)
- Changing source or PDF retrieval

## Layout and receipt

Document leaf `{slug}/`:

```text
{slug}/
  arXiv-{slug}.tar.gz
  {slug}-tex/
  {slug}.pdf                 # unchanged
  {slug}-html/               # NEW acquired tree
    {slug}.html              # entrypoint
    x1.png …                 # same-prefix requisites only
  acquisition.json
  article.json
```

One html form, always a **tree** named `{slug}-html` (portable leaf). Single-file providers (Zenodo) write `{slug}-html/{slug}.html` with `files: 1` so there is one html shape.

Receipt extras on the html form (keep `path` a portable leaf):

- `format`: `application/x-html-source-tree`
- `entrypoint`: `{slug}.html`
- `files`: member count
- `bytes` / `sha256`: tree identity (same row algorithm as latex-source-tree: `relative\0size\0sha256\n`, UTF-16-BE sort)
- `origin_url`: planned landing URL (`https://arxiv.org/html/{id}`), not a CDN follow
- `candidate_id`: `arxiv-html`

`source-ready` still requires the TeX archive + `{slug}-tex/`. HTML is a witness form, parallel to PDF.

## Retrieve (in-process wget)

Planner still constructs `https://arxiv.org/html/{versioned}` from the id. No extra Atom call when the id is already versioned.

Sequence, all on `rate_key="arxiv"`:

1. `download_to` the landing URL into a private directory (`.html.part/`), not `.download.part`.
2. Use the **final** URL after redirects as the join base. If the path has no trailing slash, append `/` before `urljoin` (otherwise `x1.png` resolves to `/html/x1.png`).
3. Probe the landing body: UTF-8 + paper marker (`ltx_document` or equivalent). arXiv 200 error/chrome pages and 404 → outcome `unavailable`, delete the private tree, continue other kinds. 429 stays a rate-limit error (batch halt).
4. `html.parser` collector on `img`/`source`/`image`/`object` `src`, `srcset`, `href`, `data`. Skip `script`, stylesheets, and `<a href>` (those are navigation, not requisites).
5. Confine each URL: https, host in the plan allowlist, path prefix `/html/{id}/`, no `..`, drop fragments, reject query, portable leaves only. Unique by case-folded path.
6. Sequential `download_to` of each remaining leaf into the private tree. Pin subdirectories with `pin_descendant` / `mkdir_relative` — today’s `download_to` only writes a **direct leaf** of the pinned root.
7. `html_bytes` is a **tree sum** cap.
8. Fingerprint, journal, publish `{slug}-html/`. Do not mutate HTML.

Adopt-in-place: a valid unreceipted `{slug}-html/` at the leaf is adopted like PDF.

## Code

**New**

- `src/procurement/operations/html_tree.py` — parser, URL confine, retrieve loop, tree fingerprint (or a thin wrapper around a shared pinned-tree fingerprint if one is extracted from `jsonl_engine/deposit.py` without pulling latex-specific `tex_files` counting into procurement).

**Acquisition**

- `providers/arxiv.py` — `target_leaf=f"{slug}-html"`, `media_type` tree, keep candidate URL as now.
- `providers/zenodo.py` — same tree leaf; one-file html lands as the entrypoint inside it.
- `operations/acquisition.py` — `payload_kind == "html"` uses the tree retrieve; map 404 / failed probe to `unavailable` (not `error`); keep 429 as error.
- `storage/acquisitions.py` — `validate_form` for a directory (tree hash, not file hash); private `.html.part/` + publish/recover for a tree; crash recovery must not assume every partial is a regular file.
- `domain/acquisition/receipts.py` + `schemas/acquisition.schema.json` + `_schema.py` — optional `entrypoint` / `files` required when `format` is the html tree.

**Defaults (“compulsory when available”)**

- `domain/procure.py` and MCP `procure_source`: default artifacts `("source", "pdf", "html")`.
- `acquire_artifact` stays source-only unless the caller passes artifacts.
- Missing HTML does **not** fail `procure_source` if source receipted.

**article.json (same freeze as PDF)**

- `operations/materialization.py` — adopt unreceipted `{slug}-html/`; pass html into deposit.
- `jsonl_engine/deposit.py` + `latex-source.ps1` — optional `--html` / `{slug}-html` directory; extra `source_forms` role `html-source` after archive+tree(+pdf).
- `storage/source_deposits.py` — freeze HTML inclusion at first publication; `rebuild=true` to add it later.
- `kinds/article.py` — if present, `html-source` path must be `{slug}-html`; at most one; never in slots 0–1.

**Docs**

- `ingestion/inventory/CONVENTION.md` — `{slug}-html/` in the deposit layout.
- `src/mcp-servers/procurement_mcp/prompts/procurement-request.md` and `.agents/skills/procurement-request/SKILL.md` — default artifacts include html; extra Fastly GETs (landing + N figures); absence is skip, not halt.

## Tests

No live arXiv. `httpx.MockTransport` only.

New `tests/procurement/test_html_tree.py` (and extend `test_acquisition.py` fixtures that still name `{slug}.html`):

- `urljoin` slash: landing without `/` + `src="x1.png"` stays under `/html/{id}/`.
- Relative image is fetched; `static.arxiv.org` stylesheet is not.
- `../` and off-prefix `/pdf/` rejected.
- 404 → `unavailable`.
- 200 HTML without paper marker → `unavailable`, no asset GETs.
- 429 on landing or an asset → rate-limit error.
- Tree receipt: path `{slug}-html`, entrypoint, files, sha256 stable under member reorder.
- Adopt existing valid tree.
- `procure` default asks for html; source+PDF still materialize when html is unavailable.
- Zenodo one-file html becomes a one-member tree.

Run via `tests/batch.ps1` / pytest batch for `tests/procurement`.

## Sequence

1. URL confine + parser unit tests (no HTTP).
2. Tree retrieve + private-dir publish on `AcquisitionService` (mocked HTTP).
3. Planner leaf + unavailable mapping.
4. Materialize / `article.json` / PowerShell `--html`.
5. Default artifacts + skill/convention text.

Conversion of `{slug}-html/{slug}.html` into the math register is a later lane and must not land in this change.
