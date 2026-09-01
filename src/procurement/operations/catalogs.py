"""Inspection and inventory operations over named article catalogs."""

from __future__ import annotations

import os
import stat
from dataclasses import dataclass

from jsonl_engine.inventory_catalog import (
    InventoryCatalogResult,
    build_inventory,
    discover_article_paths,
    fold_inventory,
)
from procurement.storage.catalogs import ArticleCatalogDescriptor, ArticleCatalogRoots
from procurement.storage.safety import is_link_or_reparse


@dataclass(frozen=True)
class ArticleCatalogSnapshot:
    """Direct-child article membership observed without publishing an inventory."""

    name: str
    catalog_dir: str
    article_count: int
    slugs: tuple[str, ...]
    has_inventory: bool

    def as_dict(self) -> dict[str, object]:
        return {
            "name": self.name,
            "catalog_dir": self.catalog_dir,
            "article_count": self.article_count,
            "slugs": list(self.slugs),
            "has_inventory": self.has_inventory,
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
        article_paths = discover_article_paths(
            descriptor.catalog_dir,
            publication_root=descriptor.publication_root,
        )
        slugs = tuple(os.path.basename(os.path.dirname(path)) for path in article_paths)
        return ArticleCatalogSnapshot(
            name=descriptor.name,
            catalog_dir=descriptor.catalog_dir,
            article_count=len(slugs),
            slugs=slugs,
            has_inventory=_catalog_has_inventory(descriptor),
        )

    def rebuild(self, name: str, *, force: bool = False) -> InventoryCatalogResult:
        """Publish the named catalog inventory from safe direct-child discovery."""
        descriptor = self.resolve(name)
        return build_inventory(
            catalog_dir=descriptor.catalog_dir,
            force=force,
            publication_root=descriptor.publication_root,
        )

    def fold(self, name: str, *, force: bool = False) -> InventoryCatalogResult:
        """Publish the named catalog inventory from direct-child inventory.jsonl stores."""
        descriptor = self.resolve(name)
        return fold_inventory(
            catalog_dir=descriptor.catalog_dir,
            force=force,
            publication_root=descriptor.publication_root,
        )


def _catalog_has_inventory(descriptor: ArticleCatalogDescriptor) -> bool:
    try:
        info = descriptor.publication_root.stat_leaf("inventory.jsonl")
    except FileNotFoundError:
        return False
    except OSError:
        return False
    return stat.S_ISREG(info.st_mode) and not is_link_or_reparse(info)


__all__ = ["ArticleCatalogService", "ArticleCatalogSnapshot"]
