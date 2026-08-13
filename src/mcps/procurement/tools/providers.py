"""Provider-catalog MCP tools."""

from __future__ import annotations

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from mcps.procurement.runtime import AppContext
from procurement.domain.providers import ProviderCatalogResponse


def register_provider_tools(server: MCPServer) -> None:
    """Register provider-catalog tools."""

    @server.tool()
    async def list_procurement_providers(
        ctx: Context[AppContext],
    ) -> ProviderCatalogResponse:
        """List non-exclusive artifact, authority, aggregator, and access roles."""

        catalog = ctx.request_context.lifespan_context.application.providers
        return ProviderCatalogResponse(providers=catalog.describe())
