# Sci-Hub DOI access route

Status: deferred provider operation for the Python procurement lane.

## Current boundary

`SciHubProvider` declares an `access-source` with the `artifact-access` role and no callable
capabilities. DOI validation and provider identity exist, but the provider cannot plan or acquire an
artifact. Sci-Hub is neither an artifact origin nor a bibliographic metadata authority. OpenAlex,
Semantic Scholar, or another metadata resolver must establish work identity independently.

The local-import route is the current supported path for a manually obtained Sci-Hub PDF. Its
`acquisition.json` records local custody and does not misstate Sci-Hub as the origin of those bytes.

## Intended operation

A future adapter accepts one canonical DOI and resolves an access plan entirely on the server. Mirror
addresses, ordering, cooldown state, and health observations are configuration data. MCP callers submit
neither mirrors nor arbitrary URLs. Redirects and resolved PDF locations remain subject to the shared
HTTPS, host-transition, byte-limit, content-kind, and no-clobber policies.

The successful receipt records:

- `provider = scihub` and `provider role = artifact-access`;
- the canonical DOI used for lookup;
- the selected configured mirror by opaque identifier;
- the validated PDF byte length and SHA-256 digest;
- access time and the bounded attempt history;
- no claim of repository provenance or native provider checksum.

Mirror rotation is a bounded availability policy, not an unbounded throttling bypass. It must apply
per-mirror cooldowns, honor explicit server retry instructions, stop after a configured attempt budget,
and retain enough diagnostics to distinguish throttling, challenge pages, missing records, and invalid
payloads. Browser or captcha interaction belongs to the separate browser-fetcher milestone.

## Acceptance boundary

- DOI-only requests reject malformed or non-canonical identifiers before network I/O.
- No client-controlled URL, mirror, output path, or storage root crosses the MCP boundary.
- HTML, challenge pages, and non-PDF bodies cannot be published as PDFs.
- Redirect downgrades, off-policy hosts, credentials in URLs, and encoded artifact bodies are refused.
- A failed retry cannot overwrite a prior successful receipt or artifact.
- Access evidence remains distinct from work metadata and artifact-origin evidence.
- Protocol tests exercise planning, acquisition, receipt validation, cancellation, and redaction.

## Non-goals

This milestone does not make Sci-Hub a metadata fallback, infer lawful availability, automate captchas,
or mint `article.json` from a PDF-only acquisition.
