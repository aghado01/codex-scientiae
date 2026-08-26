# codex-arxiv — SocketsHttpHandler fetch engine (low-level alternative to Invoke-WebRequest)

**Status:** brief / not built. A **deeper** option than the v0.4.0 hardening, to be built only on evidence
(see "When to build" — the async work + idle timeout + completeness guard may already suffice).

## Context

v0.4.0 already: async background fetch, `-OperationTimeoutSeconds` (idle timeout) + `-HttpVersion 1.1`,
and a truncation guard (Content-Length match, or a gzip ISIZE-verified inflate when Content-Length is
withheld — `Test-ArxivGzipIntact`). The two fetch sites use `Invoke-WebRequest`.

The reference implementation (`packages/arxiv-mcp-server`) fetches with **httpx streaming** and a
`httpx.Timeout(connect=30, read=120)` split — the Python equivalent of a configured `HttpClient` +
`SocketsHttpHandler`. Its connect/read split is exactly our `-ConnectionTimeoutSeconds`/
`-OperationTimeoutSeconds`, so mechanism-wise IWR is already at parity. Going lower-level buys **robustness
knobs IWR doesn't expose**, not correctness.

**Headline driver (added 2026-07-01): HTTP/3.** Probing showed Fastly serves arXiv over **HTTP/3 (QUIC)** on
both `/pdf` and `/e-print` (requesting 3.0 negotiated 3.0). Browsers use HTTP/2–3; a user reports manual
browser downloads that "never time out." The old code pinned **HTTP/1.1** — the least loss-resilient option
(a lost packet head-of-line-blocks the whole TCP stream). We flipped the IWR pin to **HTTP/2** as an interim
fix (v0.4.0 follow-up), and **IWR caps at h2** — requesting 3.0 falls back to 2.0. **HTTP/3 is only reachable
via this SocketsHttpHandler engine.**

**BUT the h3 policy is thorny (probed 2026-07-01):** `Version 3.0 + RequestVersionOrHigher` negotiates h3,
but that *forces* QUIC with **no fallback** — and h3 is UDP/443, which plenty of networks/firewalls block.
`Version 3.0 + RequestVersionOrLower` does **not** try h3 at all (it gives h2). So there is **no single
policy** for "h3 if available, else h2." Safe h3 = **force h3, catch the QUIC connection failure, retry the
request forced to h2** — application-level fallback the engine must implement, or it breaks every fetch on a
UDP-blocked network.

**Reframed priority:** since **h2 is already landed** (IWR) and is the reliable baseline (TCP, works
everywhere, already a big jump from the old h1.1 pin), the incremental h2→h3 gain is **situational** (only
helps on lossy links) and **costs the force+fallback complexity above**. So the sockets engine's real
sure-win is **resume (Range)** for large/interrupted source; **h3 is a bonus behind a config flag + the
fallback dance**, not the headline. Build for resume when large-source interruption is evidenced; add h3
opportunistically.

## What a shared HttpClient/SocketsHttpHandler unlocks

| capability | via Invoke-WebRequest | via SocketsHttpHandler |
|---|---|---|
| **HTTP/3 (QUIC)** — no TCP head-of-line block on a lost packet; the big loss-resilience win | **no** — IWR caps at HTTP/2 | **yes** — `RequestVersionOrHigher` negotiates h3 (Fastly serves it) |
| connect vs read (idle) timeout split | yes (`-ConnectionTimeoutSeconds`/`-OperationTimeoutSeconds`) | yes (`ConnectTimeout` + per-read `CancellationToken`) |
| Content-Length verify | manual post-hoc (`-PassThru`, done in v0.4.0) | inline while streaming |
| **connection reuse** across the long-lived server | no — IWR builds a fresh handler per call | **yes** — `PooledConnectionIdleTimeout`, kept-alive sockets |
| **Range / resume** for a large interrupted source | no | **yes** — `Range: bytes=<got>-`, append to `.part` |
| **byte-rate watchdog** (abort if throughput < X for Y s) | no (only idle timeout) | yes — track bytes/interval in the copy loop |
| max connections per server, keep-alive pings | no (ignored `ServicePointManager`) | yes (`MaxConnectionsPerServer`, `KeepAlivePingDelay`) |

## Design sketch

- **One module-scoped client** (`$script:ArxivHttp`), built once from a `SocketsHttpHandler` with:
  `AutomaticDecompression = None` (arXiv e-print is a raw gzip we must NOT auto-inflate),
  `AllowAutoRedirect = $true` (MaxAutomaticRedirections = 5), `ConnectTimeout = 30s`,
  `PooledConnectionIdleTimeout`. `HttpClient` is thread-safe, so the main runspace and the worker runspace
  can share the one instance (or the worker builds its own — decide during build).
- **`Invoke-ArxivDownload`** replaces the IWR call in `Invoke-ArxivFetch`:
  `SendAsync(req, ResponseHeadersRead)` → stream to a `FileStream` in 256 KiB chunks, each `ReadAsync`
  guarded by a linked `CancellationTokenSource(idleTimeout)` reset per chunk (true per-read stall abort),
  verifying bytes-vs-Content-Length inline. Reuse the existing `Get-ArxivTransience` classifier + retry loop
  + shared 3s rate clock unchanged.
- **Resume (the real large-source win):** keep the partial `.part`; on a transient retry, `HEAD` or resume
  with `Range: bytes=<partialLen>-` and append, so a 40 MB source that dies at 38 MB doesn't restart from 0
  (and doesn't re-spend the 3s budget on wasted bytes). Fall back to a fresh GET if the server ignores Range
  (200 instead of 206). Confirm export.arxiv.org honours Range on `/e-print` first (open question).
- **`Invoke-ArxivApi`** (the Atom call) can move to the same client for connection reuse; lower stakes.

## Alternatives considered (and why HttpClient wins here)

- **curl.exe** (ships in Win10+): `--speed-time`/`--speed-limit` (stall watchdog), `--retry`, `-C -` (resume),
  HTTP version toggle — battle-tested. But it's a **subprocess**: manual `-H`/`-U` header wiring, exit-code
  parsing, and the payload-kind/gzip-integrity checks would move outside the process. Good fallback, not first
  choice.
- **wget**: a peer of curl (`--read-timeout`, `--continue`, `--tries`) but **not built into Windows** — adds a
  vendored/signed binary dependency for no capability curl.exe doesn't already give. No reason to add it.
- **BITS (`Start-BitsTransfer`)**: OS-managed, resumable, survives network drops. But awkward custom headers
  (arXiv needs a real User-Agent), a Windows-service dependency, and far less control over inline payload
  inspection. Consider only if OS-managed resumption becomes the priority.
- **raw `TcpClient`/`SslStream`**: reinventing HTTP — rejected.

`HttpClient`/`SocketsHttpHandler` is preferred: in-process (no subprocess, no `-NoProfile`/portable-env
concerns), full control over timeouts/resume/verification, thread-safe for the worker, and it's the direct
analog of the reference's proven httpx approach.

## When to build (gate on evidence)

Only if, in practice, **large or cold source fetches still stall or truncate** despite the common-case
hardening now landed: async (non-blocking), idle timeout, completeness guard, **HTTP/2** (h1.1→2.0), and the
**direct-URL escalation** (export/e-print → arxiv.org/src fallback). Those together closed most of the gap.
The remaining trigger is specifically **resume-worthy failures on multi-MB source** (repeated
`truncated download` / idle-timeout retries on big e-prints) — i.e. the case where restarting a 40 MB
download from byte 0 is the pain. If that doesn't materialize, this stays on the shelf: the guard already
rejects a bad tarball, and async means a slow retry costs the agent nothing. (h3 rides along only as the
config-gated bonus described above, not a reason to build on its own.)

## Scope

Medium: a shared client builder, one `Invoke-ArxivDownload` (streaming + idle-cancel + inline verify +
optional resume), swap the two call sites, keep the classifier/retry/rate-clock, and tests (offline via a
local `HttpListener` or a mocked handler for truncation/resume; live smoke). Bigger than the v0.4.0 tweaks,
so evidence-gated.
