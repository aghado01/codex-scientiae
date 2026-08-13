# Crossref DOI metadata resolver

Status: deferred metadata-aggregator adapter for the Python procurement lane.

## Current boundary

DOI-based metadata resolution currently uses the configured OpenAlex and Semantic Scholar aggregators.
No Crossref adapter, provider descriptor, configuration entry, or MCP-visible capability exists. Crossref
would supply DOI registration metadata; it would not establish that staged bytes came from a repository
and would not become an artifact-access provider.

## Intended operation

Add Crossref through the provider factory and descriptor catalog as an `aggregator` with DOI lookup and
metadata capabilities. Endpoint, contact identity, request interval, attempt budget, and optional
credential are configuration or secret data. The adapter returns the existing normalized `WorkRecord`
and exact decoded-response evidence contracts instead of introducing a Crossref-specific service model.

The DOI route must:

- canonicalize and validate the caller-selected DOI before I/O;
- request one exact DOI record rather than treating search ranking as identity proof;
- require the returned DOI to equal the identity anchor;
- preserve Crossref identifiers and response evidence alongside every other contributing provider;
- permit a validated DOI-to-arXiv bridge without claiming Crossref as an artifact repository;
- participate in an explicit ordered fallback policy owned by configuration.

Rate policy is provider-specific and conservative by default. It must identify the client as configured,
honor `Retry-After`, use bounded backoff for transient failures, and never infer a higher allocation from
the mere presence of a credential. Public error projections exclude response bodies and secrets.

## Acceptance boundary

- The descriptor catalog classifies Crossref as an aggregator and advertises only implemented
  capabilities.
- Startup rejects missing or malformed Crossref configuration before constructing an HTTP client.
- Exact DOI success, not-found, identity mismatch, malformed payload, throttle, retry, and cancellation
  paths are covered with deterministic transports.
- Metadata collation preserves compatible aliases and reports incompatible crosswalks without aborting a
  federated result.
- The DOI materialization route persists the same validated metadata bundle and remains byte-idempotent.
- MCP schemas obtain Crossref through the provider catalog rather than a duplicated protocol enum.

## Non-goals

This milestone does not add publisher-page scraping, artifact downloads, client-selected endpoints, or a
new `article.json` shape.
