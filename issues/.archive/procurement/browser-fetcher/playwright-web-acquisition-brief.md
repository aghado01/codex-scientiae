# codex-scientiae — Browser-based web acquisition (Playwright) — design brief

**Status:** brief / not built. A future **expanded capability**: a browser-driven fetcher **and** scraper as
a member of the web-fetcher family, for **stubborn / hostile** sources (and, optionally, a max-robustness
fallback for *any* source including arXiv). Captures the picture from the 2026-07-01 async-fetch + transport
work so it stands alone when picked up later.

---

## 1. The arc that led here (reflecting the past few turns)

The thread started as "why do arXiv **LaTeX source** fetches time out when the **PDF** downloads fine?" and
peeled back three layers:

1. **Timeout budget.** The MCP `fetch` used a 180 s total timeout, **no idle/read timeout**, and a 3× retry
   each behind a 3 s wait — so a slow fetch could hang ~9 min and blow past the MCP client's own tool
   timeout. Not a proxy / IPv6 / TLS problem (verified: arXiv is IPv4-only Fastly, no proxy, TLS 1.3 auto).
2. **Cache economics** (the source-vs-PDF asymmetry). The **PDF** is a hot, pre-rendered, **edge-cached**
   static artifact (`arxiv.org/pdf`) — near-always a cache HIT, fast, low variance. The **e-print source** is
   **dynamically packaged, rarely requested → cache MISS → origin**, throttled and size-variable → high/
   variable TTFB and truncation risk. The reference `packages/arxiv-mcp-server` documents the same thing
   ("incomplete response bodies… truncated reads" on `export.arxiv.org`) and never fetches source at all
   (it does HTML→PDF). Host (export vs arxiv.org) is secondary — cache warmth dominates.
3. **Transport** (the big one). The code was pinned to **HTTP/1.1**, which head-of-line-blocks a whole TCP
   stream on a single lost packet. Fastly serves arXiv over **HTTP/2 and HTTP/3 (QUIC)**, and **browsers use
   those** — which is why the user's manual browser downloads *never* time out. QUIC has no TCP HoL blocking,
   fast loss recovery, and connection migration; on a lossy/jittery link a pinned-1.1 client stalls where a
   browser sails through.

**Landed (codex-arxiv v0.4.0 + follow-ups):** non-blocking async `fetch` (single background worker runspace,
`fetch_status` poll + opt-in `wait=N` long-poll + worker-liveness), egress hardening
(`-OperationTimeoutSeconds` idle timeout, `-HttpVersion 2.0`), a truncation completeness guard
(Content-Length match, or gzip **ISIZE**-verified inflate — `Test-ArxivGzipIntact`), and a shared 3 s rate
clock across runspaces. See the codex-arxiv memory + `issues/arxiv-async/`.

**Deferred HTTP-layer option:** a `SocketsHttpHandler` fetch engine — the **only** way to reach **HTTP/3** in
.NET (IWR caps at h2), plus resume (Range) and connection reuse. See
`issues/arxiv-async/sockets-httphandler-fetch-engine.md`. HTTP/3 is now its headline justification.

**The realization this brief captures:** a browser is not magic and not (for arXiv) about anti-bot — its
reliability is the whole **adaptive transport stack** (HTTP/3, IP-racing across Fastly's anycast addresses,
tuned congestion control, transparent resume/retry, a real download manager) plus a realistic fingerprint.
That stack is the **ceiling of robustness**, and it's the right tool for sources the HTTP ladder can't clear.

---

## 2. The ladder — where the browser sits

| rung | transport | inherits from the browser | cost |
|---|---|---|---|
| HTTP/1.1 (old pin) | TCP, HoL-blocked | nothing | — |
| **HTTP/2** (landed) | TCP multiplexed | framing/flow-control resilience | one param |
| **HTTP/3 via SocketsHttpHandler** (briefed) | QUIC/UDP | loss recovery, no HoL, conn migration, + resume/multi-IP | the sockets rewrite |
| **full browser (Playwright)** (this brief) | engine picks (usually h3) | the **entire** adaptive stack + anti-bot + download manager | Node/Playwright runtime |

**Principle: cheapest rung that works, escalate on failure.** arXiv lives at rung 1–2 (→ 3 with h3-sockets);
stubborn/hostile sources escalate into the browser. Do **not** Chromium-ify arXiv by default.

---

## 3. Scope of this capability

A browser substrate exposing **two verbs**:
- **FETCH** — acquire files into the shared inbox (the acquisition lane).
- **SCRAPE** — navigate + extract structured content / isolate download links (HAP-assisted).

**Targets it's *for*:**
- Anti-bot / JS-gated sources: Cloudflare, publisher & DOI landing pages, ResearchGate, Sci-Hub captcha.
- Sources whose download link is **not a stable/guessable URL** (JS-built, session-gated, interstitial).
- **Max-robustness fallback** for any source (incl. arXiv) when the HTTP path *stubbornly* fails.

**Not for:** being arXiv's default. arXiv has stable URLs, open programmatic access, a per-IP 3 s floor, and
politeness expectations — a browser (and especially a swarm) is counterproductive there. Browser = the
**escalation tier**, not the front door.

---

## 4. Existing assets — dependency largely already satisfied

- **npm is present in the PDenv portable env**, and a **full custom Playwright build is already installed
  under `node_modules`** there → the heavy Node/Playwright runtime is **already in place**. Not greenfield.
- **Dormant prior project:** headless-browser scraping against a specific **Cloudflare detection**, promising
  results, using **JS-based workers to *swarm* a target and download in *pieces*** (segmented/parallel).
  A different application, untouched for a while.
- That project used **PowerShell as a runspace manager deploying parallel Playwright workers that call
  node/playwright** — the **exact orchestration pattern to reuse**, and it mirrors the async-fetch
  worker-runspace pattern just built in codex-arxiv.
- A **signed HtmlAgilityPack build** available for static HTML parse / link-isolation (parse `page.content()`
  off-browser). NB: HAP parses; it does not navigate/click — that's the browser's job.

The two runspace-manager precedents (this session's async worker + the dormant swarm project) mean the
orchestration spine is a **known quantity**, not a research risk.

---

## 5. Architecture sketch

- A PS MCP (working codename **`codex-browser`**) sibling to codex-arxiv / codex-scholar / sci-hub, staging
  into the **same inbox** via the same layout config + sidecar (add provenance fields: engine, rung,
  fingerprint, proxy).
- **Orchestration = the PS runspace-manager pattern** (proven twice): the PS server manages a worker pool;
  each worker is a **Node/Playwright process** (from the existing custom build) driven over a **stdio JSON
  protocol** (reuse the MCP newline-delimited framing discipline).
- **Reuse the async job surface** we just built: enqueue → `job_id` → `fetch_status` / long-poll. Browser
  fetches are slow, so non-blocking is even more essential here.
- **Download mechanisms (tiers *within* the browser):**
  1. `browserContext.request` (`APIRequestContext`) — browser-**fingerprinted HTTP** (engine's cookies/TLS),
     **no page render**. Cheapest browser tier; beats bare HttpClient on fingerprint at near its speed.
  2. `page.goto(url)` + the **`download` event** → the engine's **download manager** streams+resumes to disk
     and hands back the finished file. Literally "click the link."
  3. full render → navigate → solve challenge (Cloudflare / JS / captcha) → locate link (Playwright DOM or
     HAP on `page.content()`) → trigger download. Heaviest; for gated sources.
- **Swarm / segmented (revive prior work):** parallel workers each pulling a byte **Range** (or distributing
  targets) across rotated fingerprints/sessions/**proxies** — robustness + speed + anti-bot distribution.
  **Gated:** only where the target rate-limits *per-connection* (not per-IP) **and** with proxy rotation —
  **never arXiv** (per-IP 3 s floor; swarming one IP = ban).

---

## 6. Engine strategy — any browser type

- **Multi-engine, first-class:** `chromium | firefox | webkit`.
- **Per-source engine selection** via config (like `arxiv-staging.json`). **Default `firefox`** — the user's
  scraping experience found Firefox materially better (different network stack + a less-detectable automation
  fingerprint than headless Chromium). `webkit` for some anti-bot / mobile-fingerprint cases.
- Engine is a **per-source tuning knob**, not a hardcode — fits the substrate-agnostic-instruments telos.

---

## 7. Escalation ladder (routing) — cheapest that works

1. **HTTP** (HttpClient, h2/h3) — arXiv, open sources.
2. **browser-context HTTP** (fingerprinted, no render) — light anti-bot.
3. **full-render download** — JS-gated links, cookie/session gates.
4. **challenge-solving render** — Cloudflare / captcha (port the dormant work).
5. **swarm** (parallel workers + Range + proxy rotation) — stubborn, large, or per-connection-limited
   hostile targets.

Log which rung succeeded into the sidecar. arXiv should almost never leave rung 1.

---

## 8. Points of discussion (to pick up later)

1. **Runtime bridge.** Node/Playwright child-process-per-worker vs a persistent Node bridge (stdio JSON).
   Playwright-.NET (`Microsoft.Playwright`) is a Node-free alternative, **but** the user already has a
   Node/Playwright build — lean Node. Decide the PS↔Node protocol (reuse MCP-style newline JSON?).
2. **Concurrency & politeness.** Per-source rate limits; how the browser pool coexists with arXiv's
   single-worker 3 s discipline; swarm **only** with proxy rotation + per-connection-limited targets; never
   swarm arXiv.
3. **Anti-bot posture & authorization.** Which targets are in scope (authorized research/defensive framing);
   stealth/fingerprint tactics; reuse of the Cloudflare-detection work; ToS/legal is the user's call (same
   posture as the sci-hub fetcher).
4. **Where the download happens per rung.** `browserContext.request` vs `download` event vs response
   intercept — pick per rung; **verify completeness** (reuse `Test-ArxivGzipIntact` / Content-Length guard).
5. **MCP shape.** New `codex-browser` server vs extending the `acquire` lane; tool surface (fetch / scrape /
   status); inbox sidecar provenance fields.
6. **Scrape vs fetch.** Is structured-content / link extraction (HAP-assisted) in this capability now or a
   later phase? (Cross-ref: an HTML→codex-scientiae-standard *transcription* lane for post-2023 arXiv HTML —
   which carries real MathML — is a separate downstream concern where the signed HAP build also fits.)
7. **Relationship to the h3-sockets engine.** Recommended split: build **h3-sockets for arXiv** (cheap,
   covers the common case) and reserve the **browser for genuinely stubborn / hostile** cases — not
   either/or.
8. **Reviving the dormant swarm project.** What's reusable as-is (worker pool, CF-detection, segmenting) vs
   needs porting; where that code currently lives; how it maps onto the `codex-browser` worker model.

---

## 9. Cost / benefit

- **Cost:** browser binaries + Node runtime (**already present** in PDenv) + per-worker memory/CPU +
  orchestration complexity + fragility (engines/anti-bot move). Slower per-fetch than HTTP.
- **Benefit:** the ceiling of transport robustness (the browser stack); the **only** path for anti-bot /
  hostile sources; a download manager that just-finishes-files; multi-engine flexibility; and reuse of the
  proven runspace-manager + dormant swarm/CF-detection assets.
- **Verdict:** build as the **escalation tier** of the fetcher family, not the arXiv default. arXiv →
  HTTP + h3. Stubborn / hostile → browser (Firefox-default, multi-engine); swarm for the hardest.

---

## 10. Phasing (when picked up)

- **P0** — single-engine (`firefox`) fetch via `download` event + `browserContext.request` into the shared
  inbox, reusing the async job surface. Proves the PS↔Node bridge.
- **P1** — multi-engine + per-source config + escalation routing (rungs 1–3).
- **P2** — challenge-solving (Cloudflare / captcha): port the dormant work.
- **P3** — swarm / segmented (rung 5) with proxy rotation, gated to per-connection-limited targets.
- **Parallel track (optional)** — SCRAPE (HAP-assisted structured extraction / link isolation) alongside
  FETCH.

---

## Related

- `issues/arxiv-async/sockets-httphandler-fetch-engine.md` — the HTTP/3 + resume engine (arXiv robustness
  without a browser); the rung below this one.
- `issues/arxiv-async/autowake-background-process.md` — true harness auto-wake via a background *process*
  (not a subagent); orthogonal, applies to any async fetcher.
- codex-arxiv memory — the async-fetch + transport findings this brief builds on.
- Sci-Hub fetcher (built, scholar-server v0.3.x) + its `.discussion/scihub-fetcher-brief.md` — the first
  hostile-ish source; the browser tier is its Cloudflare/captcha contingency.
