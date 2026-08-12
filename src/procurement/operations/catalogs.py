"""Inspection and inventory operations over named article catalogs."""

from __future__ import annotations

import os
from dataclasses import dataclass

from jsonl_engine.inventory_catalog import (
    InventoryCatalogResult,
    build_inventory,
    discover_article_paths,
)
from procurement.storage.catalogs import ArticleCatalogDescriptor, ArticleCatalogRoots


@dataclass(frozen=True)
class ArticleCatalogSnapshot:
    """Direct-child article membership observed without publishing an inventory."""

    name: str
    catalog_dir: str
    article_count: int
    slugs: tuple[str, ...]

    def as_dict(self) -> dict[str, object]:
        return {
            "name": self.name,
            "catalog_dir": self.catalog_dir,
            "article_count": self.article_count,
            "slugs": list(self.slugs),
        }


class ArticleCatalogService:
    """Delegate named catalog operations to jsonl_engine."""

    def __init__(self, catalog_roots: ArticleCatalogRoots) -> None:
        self._catalog_roots = catalog_roots

    def catalogs(self) -> tuple[ArticleCatalogDescriptor, ...]:
        """Return the configured catalog descriptors."""

        return self._catalog_roots.catalogs()

    def resolve(self, name: str) -> ArticleCatalogDescriptor:
        """Resolve one configured catalog name."""

        return self._catalog_roots.resolve(name)

    def inspect(self, name: str) -> ArticleCatalogSnapshot:
        """Validate path topology and report direct-child article membership."""
        descriptor = self.resolve(name)
        article_paths = discover_article_paths(descriptor.catalog_dir)
        slugs = tuple(os.path.basename(os.path.dirname(path)) for path in article_paths)
        return ArticleCatalogSnapshot(
            name=descriptor.name,
            catalog_dir=descriptor.catalog_dir,
            article_count=len(slugs),
            slugs=slugs,
        )

    def rebuild(self, name: str, *, force: bool = False) -> InventoryCatalogResult:
        """Publish the named catalog inventory from safe direct-child discovery."""
        descriptor = self.resolve(name)
        return build_inventory(catalog_dir=descriptor.catalog_dir, force=force)


__all__ = ["ArticleCatalogService", "ArticleCatalogSnapshot"]
