"""Article-catalog MCP tools."""

from __future__ import annotations

from mcp.server import MCPServer
from mcp.server.mcpserver import Context

from procurement_mcp.contracts import (
    ArticleCatalogDescriptorResponse,
    ArticleCatalogListResponse,
    ArticleCatalogSnapshotResponse,
    ArticleInventoryResultResponse,
    NonEmptyIdentifier,
)
from procurement_mcp.runtime import AppContext, finish_sync


def register_catalog_tools(server: MCPServer) -> None:
    """Register article-catalog inspection and publication tools."""

    @server.tool()
    async def list_article_catalogs(
        ctx: Context[AppContext],
    ) -> ArticleCatalogListResponse:
        """List configured catalog names accepted by source and inventory operations."""

        service = ctx.request_context.lifespan_context.application.catalogs
        if service is None:
            raise RuntimeError("article catalogs are not configured for this application")
        return ArticleCatalogListResponse(
            catalogs=tuple(
                ArticleCatalogDescriptorResponse(
                    name=item.name,
                    catalog_directory=item.catalog_dir,
                )
                for item in service.catalogs()
            )
        )

    @server.tool()
    async def inspect_article_catalog(
        catalog: NonEmptyIdentifier,
        ctx: Context[AppContext],
    ) -> ArticleCatalogSnapshotResponse:
        """Inspect current direct-child article.json membership without writing inventory."""

        service = ctx.request_context.lifespan_context.application.catalogs
        if service is None:
            raise RuntimeError("article catalogs are not configured for this application")
        snapshot = await finish_sync(service.inspect, catalog)
        return ArticleCatalogSnapshotResponse(
            name=snapshot.name,
            catalog_directory=snapshot.catalog_dir,
            article_count=snapshot.article_count,
            slugs=snapshot.slugs,
        )

    @server.tool()
    async def rebuild_article_inventory(
        catalog: NonEmptyIdentifier,
        ctx: Context[AppContext],
        force: bool = False,
    ) -> ArticleInventoryResultResponse:
        """Rebuild inventory.jsonl from every current direct-child article.json sentinel."""

        service = ctx.request_context.lifespan_context.application.catalogs
        if service is None:
            raise RuntimeError("article catalogs are not configured for this application")
        result = await finish_sync(service.rebuild, catalog, force=force)
        descriptor = service.resolve(catalog)
        return ArticleInventoryResultResponse(
            catalog=descriptor.name,
            catalog_directory=result.catalog_dir,
            inventory_path=result.inventory_path,
            article_count=result.article_count,
            slugs=tuple(result.slugs),
        )
