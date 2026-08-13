"""Scholarly discovery MCP tools."""

from __future__ import annotations

from datetime import date

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from procurement_mcp.contracts import (
    NonEmptyIdentifier,
    ProviderName,
    RelatedKind,
    RelatedLimit,
    SearchLimit,
    StartOffset,
)
from procurement_mcp.runtime import AppContext
from procurement.domain.discovery import (
    RelatedResponse,
    ResolveResponse,
    SearchRequest,
    SearchResponse,
)
from procurement.domain.works import WorkRecord


def register_discovery_tools(server: MCPServer) -> None:
    """Register discovery and work-resolution tools."""

    @server.tool()
    async def discover_search(
        query: NonEmptyIdentifier,
        ctx: Context[AppContext],
        source: ProviderName = "all",
        filters: list[NonEmptyIdentifier] | None = None,
        categories: list[NonEmptyIdentifier] | None = None,
        date_from: date | None = None,
        date_to: date | None = None,
        resource_type: NonEmptyIdentifier | None = None,
        sort: NonEmptyIdentifier | None = None,
        start: StartOffset = 0,
        max_results: SearchLimit = 25,
    ) -> SearchResponse:
        """Search one provider or fan out, explicitly reporting unsupported constraints."""

        request = SearchRequest(
            query=query,
            filters=filters or (),
            categories=categories or (),
            date_from=date_from,
            date_to=date_to,
            resource_type=resource_type,
            sort=sort,
            start=start,
            limit=max_results,
        )
        service = ctx.request_context.lifespan_context.application.discovery
        return await service.search(request, source=source)

    @server.tool()
    async def discover_related(
        identifier: NonEmptyIdentifier,
        ctx: Context[AppContext],
        kind: RelatedKind = "citations",
        source: ProviderName | None = None,
        max_results: RelatedLimit = 25,
    ) -> RelatedResponse:
        """Traverse citations, references, or semantic recommendations from one work."""

        service = ctx.request_context.lifespan_context.application.discovery
        return await service.related(identifier, kind=kind, source=source, limit=max_results)

    @server.tool()
    async def resolve_reference(
        reference: NonEmptyIdentifier,
        ctx: Context[AppContext],
        source: ProviderName = "openalex",
    ) -> ResolveResponse:
        """Resolve a DOI, arXiv identifier, title, or loose citation to ranked works."""

        service = ctx.request_context.lifespan_context.application.discovery
        return await service.resolve(reference, source=source)

    @server.tool()
    async def get_work(
        identifier: NonEmptyIdentifier,
        ctx: Context[AppContext],
        source: ProviderName = "openalex",
    ) -> WorkRecord:
        """Return one normalized work while preserving its provider identity."""

        service = ctx.request_context.lifespan_context.application.discovery
        return await service.get_work(identifier, source=source)
