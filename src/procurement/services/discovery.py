"""Cross-provider discovery, lookup, resolution, and graph traversal."""

from __future__ import annotations

import asyncio
from typing import cast

from procurement.models import (
    ProviderReport,
    RelatedResponse,
    ResolveResponse,
    SearchPage,
    SearchRequest,
    SearchResponse,
    WorkRecord,
    merge_works,
)
from procurement.providers.base import (
    Capability,
    RelatedKind,
    RelatedProvider,
    ResolveProvider,
    SearchProvider,
    WorkProvider,
)
from procurement.registry import ProviderRegistry


class DiscoveryService:
    """Provider-independent scholarly discovery workflows."""

    def __init__(self, registry: ProviderRegistry, default_sources: tuple[str, ...]) -> None:
        if not default_sources:
            raise ValueError("at least one default discovery source is required")
        self._registry = registry
        self._default_sources = default_sources

    @property
    def providers(self) -> tuple[str, ...]:
        return self._registry.names()

    async def search(self, request: SearchRequest, *, source: str = "all") -> SearchResponse:
        if source.casefold() != "all":
            provider = cast(SearchProvider, self._registry.get(source, Capability.SEARCH))
            page = await provider.search(request)
            return SearchResponse(
                source=provider.name,
                providers=(self._report(page),),
                works=page.works,
            )

        providers = [
            cast(SearchProvider, self._registry.get(name, Capability.SEARCH))
            for name in self._default_sources
        ]
        outcomes = await asyncio.gather(
            *(provider.search(request) for provider in providers),
            return_exceptions=True,
        )
        reports: list[ProviderReport] = []
        works: list[WorkRecord] = []
        for provider, outcome in zip(providers, outcomes, strict=True):
            if isinstance(outcome, asyncio.CancelledError):
                raise outcome
            if isinstance(outcome, Exception):
                reports.append(
                    ProviderReport(
                        provider=provider.name,
                        status="error",
                        error=str(outcome) or type(outcome).__name__,
                    )
                )
                continue
            reports.append(self._report(outcome))
            works.extend(outcome.works)
        return SearchResponse(
            source="all",
            providers=tuple(reports),
            works=merge_works(works),
        )

    async def get_work(self, identifier: str, *, source: str = "openalex") -> WorkRecord:
        provider = cast(WorkProvider, self._registry.get(source, Capability.GET_WORK))
        return await provider.get_work(identifier)

    async def related(
        self,
        identifier: str,
        *,
        kind: RelatedKind = "citations",
        source: str | None = None,
        limit: int = 25,
    ) -> RelatedResponse:
        capability = Capability(kind)
        selected = source or ("semanticscholar" if kind == "recommendations" else "openalex")
        provider = cast(RelatedProvider, self._registry.get(selected, capability))
        works = await provider.related(identifier, kind, limit)
        return RelatedResponse(provider=provider.name, kind=kind, works=works)

    async def resolve(self, reference: str, *, source: str = "openalex") -> ResolveResponse:
        provider = cast(ResolveProvider, self._registry.get(source, Capability.RESOLVE))
        works = await provider.resolve(reference)
        return ResolveResponse(provider=provider.name, reference=reference, works=works)

    @staticmethod
    def _report(page: SearchPage) -> ProviderReport:
        return ProviderReport(
            provider=page.provider,
            status="ok",
            total_available=page.total_available,
            returned=page.returned,
            next_start=page.next_start,
        )
