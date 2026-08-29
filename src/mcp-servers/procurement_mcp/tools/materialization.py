"""Source-deposit materialization MCP tools."""

from __future__ import annotations

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from procurement_mcp.contracts import DepositSlug, MainTexPath, NonEmptyIdentifier
from procurement_mcp.runtime import AppContext
from procurement.domain.materialization import (
    ArtifactIdentityMetadata,
    SourceMaterializationRequest,
    SourceMaterializationResult,
    SourceMetadataInput,
)


def register_materialization_tools(server: MCPServer) -> None:
    """Register source-deposit materialization tools."""

    @server.tool()
    async def materialize_source_deposit(
        catalog: NonEmptyIdentifier,
        acquisition_slug: DepositSlug,
        ctx: Context[AppContext],
        main_tex: MainTexPath | None = None,
        metadata: SourceMetadataInput | None = None,
        rebuild: bool = False,
    ) -> SourceMaterializationResult:
        """Validate one destination acquisition in place and publish article.json using one metadata strategy."""

        service = ctx.request_context.lifespan_context.application.materialization
        if service is None:
            raise RuntimeError("source materialization is not configured for this application")
        return await service.materialize(
            SourceMaterializationRequest(
                catalog=catalog,
                acquisition_slug=acquisition_slug,
                main_tex=main_tex,
                metadata=metadata or ArtifactIdentityMetadata(),
                rebuild=rebuild,
            )
        )
