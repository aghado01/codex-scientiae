Preserved in Python:
One shared, keyed asynchronous rate limiter per application.
arXiv’s three-second floor across metadata and artifact requests.
Provider-independent clocks, so arXiv does not throttle OpenAlex.
Exponential retry, bounded Retry-After, transient 503 handling, and Semantic Scholar 429 backoff.
arXiv’s export /e-print → /src acquisition ladder.
OpenAlex contact/API-key and Semantic Scholar API-key headers.

Random browser User-Agent rotation
Disguise the client or rotate identities
Semantic Scholar’s automatic 350 ms interval to infer faster grants

A future rate-policy model can expose interval, concurrency ceiling, backoff, bounded cooldown, endpoint failover, and any explicitly granted credential rate. Background job lifecycle remains a separate milestone.

Deferrals are untracked: Sci-Hub (declaration-only) and Crossref (entirely silent) have no briefs — the three under issues/procurement/ all describe the retired PS MCP. Also: html is acquirable and receipted but nothing consumes it, and the README never mentions it.

Integration notes: scientiae-procurement isn't registered in any .mcp.json yet (flagging as a checklist item, presumed deliberate); old-lane retirement is verified complete (no \_inbox, no PS fetcher residue).
