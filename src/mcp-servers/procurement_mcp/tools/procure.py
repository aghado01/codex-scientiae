"""Lock-step procure MCP tool."""

from __future__ import annotations

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from procurement_mcp.contracts import MainTexPath, NonEmptyIdentifier, ProviderName
from procurement_mcp.runtime import AppContext
from procurement.domain.acquisition.planning import ArtifactKind
from procurement.domain.materialization import ArtifactIdentityMetadata, SourceMetadataInput
from procurement.domain.procure import ProcureRequest, ProcureResult


def register_procure_tools(server: MCPServer) -> None:
    """Register the lock-step acquire-and-materialize tool."""

    @server.tool()
    async def procure_source(
        provider: ProviderName,
        identifier: NonEmptyIdentifier,
        catalog: NonEmptyIdentifier,
        ctx: Context[AppContext],
        artifacts: list[ArtifactKind] | None = None,
        main_tex: MainTexPath | None = None,
        metadata: SourceMetadataInput | None = None,
    ) -> ProcureResult:
        """Acquire one source into a catalog destination and materialize article.json in the same leaf."""

        service = ctx.request_context.lifespan_context.application.procure
        if service is None:
            raise RuntimeError("source procure is not configured for this application")
        return await service.procure(
            ProcureRequest(
                provider=provider,
                identifier=identifier,
                catalog=catalog,
                artifacts=tuple(artifacts) if artifacts is not None else ("source", "pdf"),
                main_tex=main_tex,
                metadata=metadata or ArtifactIdentityMetadata(),
            )
        )
