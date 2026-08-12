"""Discovery orchestration and provider-isolation contracts."""

from __future__ import annotations

import asyncio
import unittest

from procurement.domain.discovery import SearchPage, SearchRequest
from procurement.domain.works import SourceReference, WorkRecord
from procurement.providers.base import Capability, RelatedKind
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.operations.discovery import DiscoveryService


def record(provider: str, identifier: str, *, doi: str | None = None, arxiv_id: str | None = None) -> WorkRecord:
    return WorkRecord(
        doi=doi,
        arxiv_id=arxiv_id,
        sources=(SourceReference(provider=provider, identifier=identifier, doi=doi, arxiv_id=arxiv_id),),
    )


class FakeProvider:
    def __init__(
        self,
        name: str,
        page: SearchPage | None = None,
        failure: Exception | None = None,
        search_constraints: frozenset[str] = frozenset(),
    ) -> None:
        self.name = name
        self.page = page
        self.failure = failure
        self.search_constraints = search_constraints
        self.search_calls: list[SearchRequest] = []
        self.related_calls: list[tuple[str, RelatedKind, int]] = []

    async def search(self, request: SearchRequest) -> SearchPage:
        self.search_calls.append(request)
        if self.failure:
            raise self.failure
        assert self.page is not None
        return self.page

    async def get_work(self, identifier: str) -> WorkRecord:
        if self.failure:
            raise self.failure
        assert self.page and self.page.works
        return self.page.works[0]

    async def related(self, identifier: str, kind: RelatedKind, limit: int) -> tuple[WorkRecord, ...]:
        self.related_calls.append((identifier, kind, limit))
        assert self.page is not None
        return self.page.works

    async def resolve(self, reference: str) -> tuple[WorkRecord, ...]:
        assert self.page is not None
        return self.page.works


class CancelledProvider(FakeProvider):
    async def search(self, request: SearchRequest) -> SearchPage:
        raise asyncio.CancelledError


ALL_DISCOVERY_CAPABILITIES = frozenset(
    capability
    for capability in Capability
    if capability not in {Capability.METADATA, Capability.PLAN_ARTIFACT}
)


class TestDiscoveryService(unittest.TestCase):
    def test_fanout_isolates_failure_and_merges_provenance(self) -> None:
        openalex = FakeProvider(
            "openalex",
            SearchPage(provider="openalex", start=0, works=(record("openalex", "W1", doi="10.1/x"),)),
        )
        semantic = FakeProvider(
            "semanticscholar",
            SearchPage(
                provider="semanticscholar",
                start=0,
                works=(record("semanticscholar", "P1", doi="10.1/x", arxiv_id="2008.10579"),),
            ),
        )
        broken = FakeProvider("arxiv", failure=RuntimeError("temporary outage"))
        registry = ProviderCatalog(
            [
                ProviderBinding(openalex, ALL_DISCOVERY_CAPABILITIES),
                ProviderBinding(semantic, ALL_DISCOVERY_CAPABILITIES),
                ProviderBinding(broken, frozenset({Capability.SEARCH})),
            ]
        )
        service = DiscoveryService(registry, ("openalex", "semanticscholar", "arxiv"))
        response = asyncio.run(service.search(SearchRequest(query="phase retrieval")))

        self.assertEqual(response.returned, 1)
        self.assertEqual(len(response.works[0].sources), 2)
        self.assertEqual([report.status for report in response.providers], ["ok", "ok", "error"])
        self.assertIn("temporary outage", response.providers[2].error or "")

    def test_single_provider_failure_remains_a_tool_error(self) -> None:
        broken = FakeProvider("openalex", failure=RuntimeError("down"))
        service = DiscoveryService(
            ProviderCatalog([ProviderBinding(broken, frozenset({Capability.SEARCH}))]),
            ("openalex",),
        )
        with self.assertRaisesRegex(RuntimeError, "down"):
            asyncio.run(service.search(SearchRequest(query="x"), source="openalex"))

    def test_federated_search_reports_unsupported_constraints_without_calling_provider(self) -> None:
        openalex = FakeProvider(
            "openalex",
            SearchPage(provider="openalex", start=0),
            search_constraints=frozenset({"filters"}),
        )
        arxiv = FakeProvider(
            "arxiv",
            SearchPage(
                provider="arxiv",
                start=0,
                works=(record("arxiv", "2008.10579", arxiv_id="2008.10579"),),
            ),
            search_constraints=frozenset({"categories"}),
        )
        service = DiscoveryService(
            ProviderCatalog(
                [
                    ProviderBinding(openalex, frozenset({Capability.SEARCH})),
                    ProviderBinding(arxiv, frozenset({Capability.SEARCH})),
                ]
            ),
            ("openalex", "arxiv"),
        )

        response = asyncio.run(
            service.search(SearchRequest(query="geometry", categories=("math.AT",)))
        )

        self.assertEqual([report.status for report in response.providers], ["error", "ok"])
        self.assertIn("categories", response.providers[0].error or "")
        self.assertEqual(openalex.search_calls, [])
        self.assertEqual(len(arxiv.search_calls), 1)

    def test_single_provider_rejects_unsupported_constraints(self) -> None:
        semantic = FakeProvider(
            "semanticscholar",
            SearchPage(provider="semanticscholar", start=0),
        )
        service = DiscoveryService(
            ProviderCatalog(
                [ProviderBinding(semantic, frozenset({Capability.SEARCH}))]
            ),
            ("semanticscholar",),
        )

        with self.assertRaisesRegex(ValueError, "does not support search constraints: filters"):
            asyncio.run(
                service.search(
                    SearchRequest(query="geometry", filters=("open_access.is_oa:true",)),
                    source="semanticscholar",
                )
            )
        self.assertEqual(semantic.search_calls, [])

    def test_fanout_propagates_cancellation(self) -> None:
        cancelled = CancelledProvider("openalex")
        service = DiscoveryService(
            ProviderCatalog([ProviderBinding(cancelled, frozenset({Capability.SEARCH}))]),
            ("openalex",),
        )
        with self.assertRaises(asyncio.CancelledError):
            asyncio.run(service.search(SearchRequest(query="x")))

    def test_recommendations_default_to_semantic_scholar(self) -> None:
        semantic = FakeProvider(
            "semanticscholar",
            SearchPage(provider="semanticscholar", start=0, works=(record("semanticscholar", "P1"),)),
        )
        registry = ProviderCatalog(
            [ProviderBinding(semantic, ALL_DISCOVERY_CAPABILITIES)]
        )
        service = DiscoveryService(registry, ("semanticscholar",))
        response = asyncio.run(service.related("seed", kind="recommendations", limit=7))
        self.assertEqual(response.provider, "semanticscholar")
        self.assertEqual(semantic.related_calls, [("seed", "recommendations", 7)])
        with self.assertRaisesRegex(ValueError, "between 1 and 50"):
            asyncio.run(service.related("seed", kind="recommendations", limit=0))
        with self.assertRaisesRegex(ValueError, "nonblank"):
            asyncio.run(service.resolve("   ", source="semanticscholar"))
