# A No-Account Sci-Hub Fetcher — design brief for the next web-fetcher sibling

*Status — 2026-06-23: forward-looking design brief, not an implementation. Provenance: built the
`codex-arxiv` acquisition MCP (search/fetch arXiv → inbox), framed as the first of a web-fetcher
family; this captures the second candidate, a Sci-Hub fetcher, while it is still ideation. Nothing
here is to be taken as verified fact about Sci-Hub's current surface — §5 is the list of things to
GO LOOK AT before a line of code is written.*

> Sci-Hub is not a search engine; it is a **DOI → PDF resolver**. That simplifies retrieval to near-
> triviality *if* the front-end is unguarded. The real work of this MCP is therefore upstream: **DOI
> fact-finding** — turning a fuzzy paper reference into a verified DOI (via generic web search +
> structured bibliographic APIs) — to feed a **mirror-rotating** resolver. Every anti-bot measure
> (Cloudflare, captcha, JS-gated embeds) is a CONTINGENCY to confirm by observation, never assumed.

Anchors:
- Template / sibling: [`../src/arxiv-server.ps1`](../src/arxiv-server.ps1) (protocol shell),
  [`../src/arxiv.ps1`](../src/arxiv.ps1) (acquisition core) — clone the shape, swap the source.
- The contract this must honor: [`../src/arxiv-staging.json`](../src/arxiv-staging.json) — the inbox
  layout seam; add a `{doi}` placeholder, reuse the `/`→`_` path-sanitization already written for
  old-style arXiv ids.
- Downstream consumer: the forthcoming from-scratch PdfPig transcription workflow (see project
  `CLAUDE.md`) — it reads `{pdf} + {metadata sidecar}` from the inbox and does not care which fetcher
  staged them. That indifference is the whole point of the decoupling.

---

## 0. Where it sits — the family is unified by the inbox, not by language

The fetcher family (`codex-arxiv`, this, …) shares **one** thing: it stages a raw PDF plus a metadata
sidecar into `ingestion/_inbox/{slug}/…` per the layout config, then stops. It does NOT convert.
Consequence worth stating plainly, correcting an earlier loose claim that siblings are "near-copies of
`arxiv.ps1`":

> The unifying tie is the **staging contract**, not the implementation substrate or language. Two
> fetchers can be written in different languages and still be siblings, as long as they land the same
> `{pdf} + sidecar` shape in the inbox.

This matters here because the substrate decision (PowerShell vs Node/Python) is *downstream of* what
the Sci-Hub surface turns out to be (§6) — and we have not looked yet.

---

## 1. The reframe: DOI resolver, two responsibilities

Because Sci-Hub takes a DOI and returns a PDF, the MCP cleanly splits:

| Responsibility | Nature | Where the difficulty lives |
|---|---|---|
| **A. DOI fact-finding** | turn a reference (title / citation / partial / URL) into a *verified* DOI | ambiguity, wrong-edition matches, the long tail |
| **B. DOI → PDF retrieval** | hand the DOI to a live mirror, get the PDF, stage it | mirror liveness, *possible* anti-bot, scrape shape |

A is the genuine onus (user's framing); B is mechanically simple **conditional on** the front-end
being unguarded — which is exactly what §5 must establish.

---

## 2. Responsibility A — DOI fact-finding (the onus)

**Input forms to accept** (degrade gracefully, most-precise first):
1. A DOI already in hand → extract & validate (`10\.\d{4,9}/\S+`), skip discovery.
2. A title (+ optional authors / year).
3. A free citation string or a publisher/landing URL to mine a DOI from.

**Two discovery routes, paired deliberately:**
- **Structured backbone — Crossref / OpenAlex** (free, no account). A bibliographic query returns
  candidate DOIs *with* metadata and a match score. This is the *principled* signal (cf. the project's
  "no magic-string heuristics" stance): it gives a DOI you can verify, not a scraped string.
- **Generic web-search augmentation** (the user's named requirement). For the long tail the structured
  APIs miss — preprints, books, gray literature, exact-title collisions — search the open web
  (title + "doi" / Google Scholar / Semantic Scholar / publisher pages) and mine the DOI out of the
  results. Treated as a *candidate generator*, not ground truth.

**Verification gate (non-negotiable, keeps web-search honest):** whatever route yields a DOI,
round-trip it through Crossref/OpenAlex and fuzzy-match the returned title/authors/year against the
original query. A DOI that doesn't reconcile is a *candidate*, surfaced for disambiguation — not auto-
fetched. This is the principled-signal discipline applied to a heuristic source.

**Output shape:** `{ doi, confidence, provenance (which route), metadata }`, and when ambiguous, a short
ranked candidate list rather than a silent pick.

**OPEN DECISION (do not assume):** does the MCP embed a web-search backend (Brave/Bing/SerpAPI/DDG
scrape — each a key/ToS/cost question), or expose a `resolve_doi(candidates)` surface and let the
orchestrating agent supply search results from its own tools? Both are viable; pick after §5.

---

## 3. Responsibility B — DOI → PDF retrieval

- **Mirror rotation is a MUST** (firm requirement, user). Maintain a configurable mirror list, health-
  check, and fall through on block/timeout/non-PDF. Mirror set + dead-mirror policy belong in an
  external config, same spirit as `arxiv-staging.json` — conventions stay data, not code.
- **Happy-path fetch:** request `{{mirror}}/{doi}`, locate the PDF (embed/iframe `src` or download
  control), download, **`%PDF` magic-byte guard** (reuse the one in `arxiv.ps1` — reject HTML/landing
  pages served as PDFs), then stage via the inbox seam with a `.scihub.json` / `.crossref.json` sidecar
  carrying the DOI + verified metadata.
- **Slug/key:** the DOI (sanitized) is the stable key, mirroring how the arXiv id keys `codex-arxiv`.

---

## 4. Contingencies — gated on observation, NOT baked in

These activate ONLY if §5 confirms the corresponding obstacle exists. Listed so the design has a known
escalation path, not so we build for ghosts:

- **If** the front-end is plain server-rendered HTML → a plain HTTP GET + parse suffices (no browser).
- **If** Cloudflare / JS-gated embeds are present → escalate that mirror's fetch to a real browser
  (Playwright/Puppeteer) that executes JS, follows the redirect chain, scrapes the actual PDF URL, and
  downloads *through the page context* so challenge cookies apply.
- **If** captchas appear → the genuine no-account wall. Mirror the membrane's `request_review`: return
  `challenge_pending`, open the browser visibly for the user to solve once, persist session/cookies,
  and a `resume` tool continues. Human-in-the-loop **on challenge only**.

The escalation is per-mirror and lazy: try cheap, climb only on failure.

---

## 5. Open questions — VERIFY before building (the no-assumptions list)

- [ ] Is classic Sci-Hub currently reachable at all, and from which live mirror domains? (corpus is
      reportedly frozen ~2021 — confirm, and confirm what "frozen" excludes.)
- [ ] What does a DOI request actually return today — server HTML with an inline PDF/iframe, or a
      JS/Cloudflare-gated page? (This single answer decides §4 and §6.)
- [ ] Is there any captcha in the common path, or only on abuse?
- [ ] Where does a reliable, maintained mirror list come from, and how often does it churn?
- [ ] Confirm the Sci-Hub vs **Sci-Net** distinction (Sci-Net = the account + credit/"crypto" request
      platform; out of scope here). Verify current state of both — this brief's premise is classic,
      no-account Sci-Hub only.
- [ ] Web-search backend choice (§2 open decision) — availability, ToS, cost, key handling.

---

## 6. Substrate decision — deferred to §5, on purpose

- Plain-HTML surface → a **PowerShell sibling** (clone `arxiv.ps1`) keeps it in-family, zero new runtime.
- JS/Cloudflare surface → a **Node or Python component with Playwright** for retrieval; it can still be
  a sibling because it honors the same inbox contract. DOI fact-finding (§2) could even stay PowerShell
  while only the guarded-fetch leg is browser-driven — split by need, not dogma.

Do not pre-commit. The §5 observation picks this.

---

## 7. Non-goals / deferred

- **Sci-Net** (account + credit/token economy, request-based, papers newer than the frozen corpus) —
  a separate, account-based fetcher if ever wanted; explicitly not this build.
- Anything newer than the frozen corpus via Sci-Hub — won't be there; falls to other fetchers or manual.
- **Legal posture:** Sci-Hub is under active copyright injunction in several jurisdictions; this is a
  personal research-acquisition tool and that context is the user's to weigh. Noted neutrally, not
  litigated here.

---

## Provisional tool surface (sketch — settle after §5)

`resolve_doi` (reference → verified DOI + candidates) · `fetch` (DOI → staged PDF + sidecar, mirror-
rotating) · `list_inbox` / `inspect` / `clear` (shared inbox lane, as in `codex-arxiv`) · *contingent:*
`resume` (continue after a human-solved challenge).
