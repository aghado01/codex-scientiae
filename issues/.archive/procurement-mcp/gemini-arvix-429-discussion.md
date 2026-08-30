
Based on [rate-policy.md](file:///d:/aghado01/codex-scientiae/issues/mcp-servers/rate-policy.md), the legacy PowerShell implementation in [arxiv.ps1](file:///d:/aghado01/graveyard/codex-scientiae/src/procurement/arxiv.ps1), and current arXiv/Fastly rate-limiting behavior, here is an analysis of what was omitted during the Python migration, why arXiv 429s are so aggressive, and the strategies available to alleviate them.

---

### 1. What was in the PowerShell Implementation but Dropped in Python

| Strategy | PowerShell Legacy ([arxiv.ps1](file:///d:/aghado01/graveyard/codex-scientiae/src/procurement/arxiv.ps1)) | Current Python Engine ([http.py](file:///d:/aghado01/codex-scientiae/src/procurement/transport/http.py), [arxiv.py](file:///d:/aghado01/codex-scientiae/src/procurement/providers/arxiv.py)) | Impact on 429s |
|---|---|---|---|
| **User-Agent Rotation** | Rotated across a pool of desktop Chrome/Firefox/Safari and tool UAs on each request (`Get-ArxivUserAgent`). | Static string: `"codex-scientiae-arxiv/0.1"` (or with email if `CODEX_SCHOLAR_MAILTO` set). | Static script UAs without standard browser headers trigger Fastly edge bot heuristics on web endpoints (`/pdf`, `/src`). |
| **HTTP/2 Transport** | Explicitly pinned `-HttpVersion 2.0` on `Invoke-WebRequest`. | `httpx.AsyncClient(http2=False)` (defaults to HTTP/1.1). | HTTP/1.1 connections face stricter TCP-level connection limits and different edge WAF fingerprinting than multiplexed H2/H3. |
| **Cross-Process Clock** | Synchronized state (`[hashtable]::Synchronized`) shared explicitly across all runspaces (`Use-ArxivRateState`). | In-memory `RateLimiter` per `HttpClient` instance. | If multiple CLI runs, subagents, or MCP worker processes execute concurrently, each starts with a clean clock and collides at the 3s window. |
| **Route Escalation on 429** | Failed or throttled `export.arxiv.org/e-print` calls automatically escalated to `arxiv.org/src`. | `arxiv-export-eprint` is primary and `arxiv-source` is fallback, but `RequestPolicy` sets `retry_rate_limits=False` by default, failing immediately on 429 rather than falling over. | The origin export endpoint throttles much faster than the CDN edge cache. |

---

### 2. Root Causes of arXiv's Aggressive 429s

1. **Shared IP Bucket on Fastly Edge**: Fastly fronts both `export.arxiv.org` (API/origin) and `arxiv.org` (CDN). Querying metadata via `/api/query` and immediately downloading `/pdf` within 3 seconds counts as 2 requests against the **same** client IP quota.
2. **Penalty Box / Backoff Reset**: When Fastly triggers a 429 on arXiv, it imposes a cooldown window (typically 30s to 120s). Any subsequent request sent *during* the cooldown resets the penalty timer.
3. **Missing Request Jitter**: Exact 3.000s polling rhythms look mechanical to WAF anomaly detectors.
4. **Header Incompleteness**: Web routes (`arxiv.org/pdf` and `arxiv.org/src`) expect standard browser header sets (`Accept`, `Accept-Language`, `Sec-Fetch-*`, `Sec-CH-UA`).

---

### 3. Concrete Strategies to Alleviate & Circumvent arXiv 429s

#### A. In-Engine Transport & Policy Adjustments
1. **Enable HTTP/2 & Full Header Sets**:
   - Initialize httpx with `http2=True`.
   - Send complete browser-like headers on artifact routes (`/src`, `/pdf`) and polite tool headers with contact email on `/api/query`.
2. **Jittered Interval & Conservative Floor**:
   - Increase the default minimum interval from 3.0s to `3.2s + random.uniform(0.3, 1.5)` (effective 3.5s–4.7s).
3. **System-Wide / File-Locked Rate Clock & Circuit Breaker**:
   - Use an OS-level file lock (or SQLite/file-backed timestamp in `~/.Codex/` or workspace scratch) for `RateLimiter` so independent processes/CLI commands share one synchronized rate floor.
   - **429 Circuit Breaker**: If any arXiv endpoint returns a 429, lock out all arXiv requests system-wide for a mandatory 60–120s cooldown before retrying.
4. **Make Direct CDN the Primary Route for Source**:
   - Swap the candidate order in [arxiv.py:307-317](file:///d:/aghado01/codex-scientiae/src/procurement/providers/arxiv.py#L307-L317): make `https://arxiv.org/src/{id}` primary and `export.arxiv.org/e-print/{id}` secondary. The `/src` endpoint hits Fastly edge cache directly without a 301 redirect.

#### B. Offload Metadata & Discovery (Bypass arXiv API)
You only need to hit arXiv directly for raw TeX `.tar.gz` packages. For search and metadata, other providers have orders-of-magnitude higher rate limits:
1. **OpenAlex as Primary Metadata Source**:
   - Query works by arXiv ID directly via OpenAlex: `https://api.openalex.org/works/https://arxiv.org/abs/{arxiv_id}` or `arxiv:{arxiv_id}`.
   - OpenAlex grants 10 req/sec in the free polite pool (`User-Agent: mailto:...`) and up to 100k requests/day.
2. **Semantic Scholar Graph API**:
   - `https://api.semanticscholar.org/graph/v1/paper/ARXIV:{arxiv_id}` provides full abstracts, citations, and open-access PDF links with 1 req/sec (or higher with an API key).
3. **Batch Atom Queries (`id_list`)**:
   - arXiv's Atom API allows up to 100-200 comma-separated IDs in a single `id_list` query (`/api/query?id_list=ID1,ID2,ID3...`). Batching discovery/metadata saves 3 seconds per paper and eliminates dozens of potential 429 points.
4. **Aggressive Local Caching**:
   - Cache all Atom responses locally in JSONL/SQLite before querying the network so repeated inspect/plan operations never hit the network.

#### C. Bulk & Alternative Mirrors
1. **Kaggle arXiv Dataset / AWS S3 Requester-Pays**:
   - **Kaggle**: Entire corpus metadata (updated weekly) is downloadable as a single JSON file (`Cornell-University/arxiv`).
   - **AWS S3 Bucket (`s3://arxiv/`)**: Hosts the complete PDF and TeX source corpus. Can be pulled directly without web rate limits.
2. **HTML / MathML Endpoints**:
   - Post-2023 arXiv papers offer native HTML at `https://arxiv.org/html/{id}` and `ar5iv.labs.arxiv.org/html/{id}`.
3. **Unpaywall API**:
   - For papers with DOIs, Unpaywall (`https://api.unpaywall.org/v2/{doi}`) finds open-access PDF mirrors hosted on institutional repositories (HAL, Europe PMC, universities).

#### D. Network & Escalation Tiers
1. **Browser / Playwright Escalation**:
   - As documented in [playwright-web-acquisition-brief.md](file:///d:/aghado01/codex-scientiae/issues/procurement/browser-fetcher/playwright-web-acquisition-brief.md), fall back to Playwright (Firefox/Chromium) for downloads when HTTP clients get flagged.
2. **Egress Proxy / IP Rotation**:
   - Route arXiv requests through a rotating proxy pool, SOCKS5 proxy, or serverless micro-proxy (e.g. AWS Lambda / Cloudflare Worker egress) to distribute IP-based rate buckets.

Viewed procurement.txt
Edited procurement.txt