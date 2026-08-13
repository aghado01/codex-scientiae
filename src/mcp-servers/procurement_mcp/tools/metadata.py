"""Artifact-linked metadata MCP tools."""

from __future__ import annotations

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from procurement_mcp.contracts import DepositSlug, NonEmptyIdentifier, ProviderName
from procurement_mcp.runtime import AppContext, finish_sync
from procurement.domain.metadata import DepositMetadataBundle


def register_metadata_tools(server: MCPServer) -> None:
    """Register artifact-identity and DOI metadata tools."""

    @server.tool()
    async def prepare_source_deposit_metadata(
        deposit_slug: DepositSlug,
        artifact_provider: ProviderName,
        identifier: NonEmptyIdentifier,
        ctx: Context[AppContext],
        fallback_sources: list[ProviderName] | None = None,
    ) -> DepositMetadataBundle:
        """Build validated article metadata with exact decoded API evidence and fallback."""

        service = ctx.request_context.lifespan_context.application.metadata
        return await service.collect(
            deposit_slug=deposit_slug,
            artifact_provider=artifact_provider,
            identifier=identifier,
            fallback_sources=(
                tuple(fallback_sources) if fallback_sources is not None else None
            ),
        )

    @server.tool()
    async def prepare_article_metadata_by_doi(
        acquisition_slug: DepositSlug,
        doi: NonEmptyIdentifier,
        ctx: Context[AppContext],
        fallback_sources: list[ProviderName] | None = None,
    ) -> DepositMetadataBundle:
        """Resolve a caller-selected DOI for one existing acquisition receipt."""

        application = ctx.request_context.lifespan_context.application
        acquisition = application.acquisition
        if acquisition is None:
            raise RuntimeError("artifact acquisition is not configured for this application")
        manifest = await finish_sync(acquisition.inspect, acquisition_slug)
        return await application.metadata.collect_by_doi(
            deposit_slug=manifest.slug,
            artifact=manifest.artifact,
            doi=doi,
            fallback_sources=(
                tuple(fallback_sources) if fallback_sources is not None else None
            ),
        )
