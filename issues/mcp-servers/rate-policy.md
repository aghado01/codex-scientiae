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
