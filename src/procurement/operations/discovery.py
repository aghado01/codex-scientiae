"""Cross-provider discovery, lookup, resolution, and graph traversal."""

from __future__ import annotations

import asyncio
from typing import cast

from procurement.domain.discovery import (
    ProviderReport,
    RelatedResponse,
    ResolveResponse,
    SearchPage,
    SearchRequest,
    SearchResponse,
)
from procurement.domain.works import WorkRecord, merge_works
from procurement.providers.base import (
    Capability,
    RelatedKind,
    RelatedProvider,
    SEARCH_CONSTRAINT_FIELDS,
    ResolveProvider,
    SearchProvider,
    WorkProvider,
)
from procurement.providers.catalog import ProviderCatalog


class DiscoveryService:
    """Provider-independent scholarly discovery workflows."""

    def __init__(self, catalog: ProviderCatalog, default_sources: tuple[str, ...]) -> None:
        if not default_sources:
            raise ValueError("at least one default discovery source is required")
        self._catalog = catalog
        self._default_sources = default_sources

    @property
    def providers(self) -> tuple[str, ...]:
        return self._catalog.names()

    async def search(self, request: SearchRequest, *, source: str = "all") -> SearchResponse:
        if source.casefold() != "all":
            provider = cast(SearchProvider, self._catalog.get(source, Capability.SEARCH))
            page = await self._search_provider(provider, request)
            return SearchResponse(
                source=provider.name,
                providers=(self._report(page),),
                works=page.works,
            )

        providers = [
            cast(SearchProvider, self._catalog.get(name, Capability.SEARCH))
            for name in self._default_sources
        ]
        outcomes = await asyncio.gather(
            *(self._search_provider(provider, request) for provider in providers),
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
        identifier = self._nonblank(identifier, label="identifier")
        provider = cast(WorkProvider, self._catalog.get(source, Capability.GET_WORK))
        return await provider.get_work(identifier)

    async def related(
        self,
        identifier: str,
        *,
        kind: RelatedKind = "citations",
        source: str | None = None,
        limit: int = 25,
    ) -> RelatedResponse:
        identifier = self._nonblank(identifier, label="identifier")
        if not 1 <= limit <= 50:
            raise ValueError("related-work limit must be between 1 and 50")
        capability = Capability(kind)
        selected = source or self._default_provider_for(capability)
        provider = cast(RelatedProvider, self._catalog.get(selected, capability))
        works = await provider.related(identifier, kind, limit)
        return RelatedResponse(provider=provider.name, kind=kind, works=works)

    async def resolve(self, reference: str, *, source: str = "openalex") -> ResolveResponse:
        reference = self._nonblank(reference, label="reference")
        provider = cast(ResolveProvider, self._catalog.get(source, Capability.RESOLVE))
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

    @staticmethod
    async def _search_provider(
        provider: SearchProvider,
        request: SearchRequest,
    ) -> SearchPage:
        supported = getattr(provider, "search_constraints", frozenset())
        unsupported = [
            field
            for field in SEARCH_CONSTRAINT_FIELDS
            if getattr(request, field) not in (None, "", ()) and field not in supported
        ]
        if unsupported:
            raise ValueError(
                f"{provider.name} does not support search constraints: "
                + ", ".join(unsupported)
            )
        return await provider.search(request)

    @staticmethod
    def _nonblank(value: object, *, label: str) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError(f"{label} must be a nonblank string")
        return value.strip()

    def _default_provider_for(self, capability: Capability) -> str:
        """Return the first configured discovery source supporting one capability."""

        for name in self._default_sources:
            binding = self._catalog.binding(name)
            if capability in binding.capabilities:
                return binding.name
        raise ValueError(
            f"no default discovery source supports {capability.value!r}"
        )
