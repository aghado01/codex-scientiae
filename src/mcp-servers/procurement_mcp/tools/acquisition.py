"""Provider acquisition and configured local-import MCP tools."""

from __future__ import annotations

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from procurement_mcp.contracts import DepositSlug, NonEmptyIdentifier, ProviderName
from procurement_mcp.runtime import AppContext, finish_sync
from procurement.domain.acquisition.planning import (
    ArtifactAcquisitionRequest,
    ArtifactKind,
    ArtifactPlanSummary,
)
from procurement.domain.acquisition.receipts import AcquisitionManifest, AcquisitionResult
from procurement.operations.local_import import LocalImportInboxCatalog, LocalImportRequest


def register_acquisition_tools(server: MCPServer) -> None:
    """Register staged acquisition and local-import tools."""

    @server.tool()
    async def plan_artifact_acquisition(
        provider: ProviderName,
        identifier: NonEmptyIdentifier,
        ctx: Context[AppContext],
        artifacts: list[ArtifactKind] | None = None,
    ) -> ArtifactPlanSummary:
        """Resolve a URL-free acquisition summary without writing artifact bytes."""

        service = ctx.request_context.lifespan_context.application.acquisition
        if service is None:
            raise RuntimeError("artifact acquisition is not configured for this application")
        return await service.summarize_plan(
            ArtifactAcquisitionRequest(
                provider=provider,
                identifier=identifier,
                artifacts=tuple(artifacts) if artifacts is not None else ("source",),
            )
        )

    @server.tool()
    async def acquire_artifact(
        provider: ProviderName,
        identifier: NonEmptyIdentifier,
        ctx: Context[AppContext],
        artifacts: list[ArtifactKind] | None = None,
    ) -> AcquisitionResult:
        """Acquire validated bytes into configured staging and publish acquisition.json."""

        service = ctx.request_context.lifespan_context.application.acquisition
        if service is None:
            raise RuntimeError("artifact acquisition is not configured for this application")
        return await service.acquire(
            ArtifactAcquisitionRequest(
                provider=provider,
                identifier=identifier,
                artifacts=tuple(artifacts) if artifacts is not None else ("source",),
            )
        )

    @server.tool()
    async def get_acquisition_receipt(
        deposit_slug: DepositSlug,
        ctx: Context[AppContext],
    ) -> AcquisitionManifest:
        """Read and revalidate one configured staging acquisition receipt."""

        service = ctx.request_context.lifespan_context.application.acquisition
        if service is None:
            raise RuntimeError("artifact acquisition is not configured for this application")
        return await finish_sync(service.inspect, deposit_slug)

    @server.tool()
    async def list_local_import_inboxes(
        ctx: Context[AppContext],
    ) -> LocalImportInboxCatalog:
        """List logical local-import inbox names without exposing host paths."""

        service = ctx.request_context.lifespan_context.application.local_import
        if service is None:
            raise RuntimeError("local artifact import is not configured for this application")
        return service.inboxes()

    @server.tool()
    async def import_local_artifact(
        inbox: DepositSlug,
        leaf: DepositSlug,
        deposit_slug: DepositSlug,
        ctx: Context[AppContext],
    ) -> AcquisitionResult:
        """Validate one configured local PDF or gzip source and publish acquisition.json."""

        service = ctx.request_context.lifespan_context.application.local_import
        if service is None:
            raise RuntimeError("local artifact import is not configured for this application")
        return await service.import_artifact(
            LocalImportRequest(
                inbox=inbox,
                leaf=leaf,
                deposit_slug=deposit_slug,
            )
        )
