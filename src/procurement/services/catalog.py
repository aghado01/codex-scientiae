"""Named access to source-ready article catalogs."""

from __future__ import annotations

import os
from collections.abc import Mapping
from dataclasses import dataclass
from types import MappingProxyType

from jsonl_engine.inventory_catalog import (
    InventoryCatalogResult,
    build_inventory,
    discover_article_paths,
)


class ArticleCatalogConfigurationError(ValueError):
    """A named article-catalog configuration is invalid or unknown."""


@dataclass(frozen=True)
class ArticleCatalogDescriptor:
    """One configured catalog name and its frozen filesystem root."""

    name: str
    catalog_dir: str

    def as_dict(self) -> dict[str, str]:
        return {"name": self.name, "catalog_dir": self.catalog_dir}


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
    """Resolve configured names and delegate catalog operations to jsonl_engine."""

    def __init__(self, catalog_roots: Mapping[str, str]) -> None:
        configured: dict[str, ArticleCatalogDescriptor] = {}
        for raw_name, raw_root in catalog_roots.items():
            if not isinstance(raw_name, str) or not raw_name.strip():
                raise ArticleCatalogConfigurationError(
                    "article catalog names must be non-empty strings"
                )
            if not isinstance(raw_root, str) or not raw_root.strip():
                raise ArticleCatalogConfigurationError(
                    f"article catalog {raw_name!r} requires a non-empty root"
                )
            name = raw_name.strip()
            folded = name.casefold()
            if folded in configured:
                raise ArticleCatalogConfigurationError(
                    f"article catalog names contain a case collision at {name!r}"
                )
            configured[folded] = ArticleCatalogDescriptor(
                name=name,
                catalog_dir=os.path.abspath(raw_root),
            )
        self._catalogs = MappingProxyType(configured)

    def catalogs(self) -> tuple[ArticleCatalogDescriptor, ...]:
        """Return configured catalogs in canonical name order."""
        return tuple(
            sorted(self._catalogs.values(), key=lambda descriptor: descriptor.name.casefold())
        )

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

    def resolve(self, name: str) -> ArticleCatalogDescriptor:
        """Return the frozen descriptor for one configured, case-insensitive name."""
        if not isinstance(name, str) or not name.strip():
            raise ArticleCatalogConfigurationError("article catalog name must not be blank")
        descriptor = self._catalogs.get(name.strip().casefold())
        if descriptor is None:
            available = [item.name for item in self.catalogs()]
            raise ArticleCatalogConfigurationError(
                f"unknown article catalog {name!r}; available: {available}"
            )
        return descriptor
