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
        """List configured catalog names and any destinations opened this session."""

        service = ctx.request_context.lifespan_context.application.catalogs
        if service is None:
            raise RuntimeError("article catalogs are not configured for this application")
        return ArticleCatalogListResponse(
            catalogs=tuple(
                ArticleCatalogDescriptorResponse(name=item.name)
                for item in service.catalogs()
            )
        )

    @server.tool()
    async def inspect_article_catalog(
        catalog: NonEmptyIdentifier,
        ctx: Context[AppContext],
    ) -> ArticleCatalogSnapshotResponse:
        """Inspect direct-child article.json membership and whether inventory.jsonl is present."""

        service = ctx.request_context.lifespan_context.application.catalogs
        if service is None:
            raise RuntimeError("article catalogs are not configured for this application")
        snapshot = await finish_sync(service.inspect, catalog)
        return ArticleCatalogSnapshotResponse(
            name=snapshot.name,
            article_count=snapshot.article_count,
            slugs=snapshot.slugs,
            has_inventory=snapshot.has_inventory,
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
            article_count=result.article_count,
            slugs=tuple(result.slugs),
        )

    @server.tool()
    async def fold_article_inventory(
        catalog: NonEmptyIdentifier,
        ctx: Context[AppContext],
        force: bool = False,
    ) -> ArticleInventoryResultResponse:
        """Fold direct-child inventory.jsonl stores into this catalog's inventory.jsonl."""

        service = ctx.request_context.lifespan_context.application.catalogs
        if service is None:
            raise RuntimeError("article catalogs are not configured for this application")
        result = await finish_sync(service.fold, catalog, force=force)
        descriptor = service.resolve(catalog)
        return ArticleInventoryResultResponse(
            catalog=descriptor.name,
            article_count=result.article_count,
            slugs=tuple(result.slugs),
        )
