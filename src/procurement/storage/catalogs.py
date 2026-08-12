"""Article-catalog view over the application-owned configured-root catalog."""

from __future__ import annotations

from dataclasses import dataclass, field

from jsonl_engine.publication import PinnedPublicationRoot

from procurement.storage.roots import (
    ConfiguredRootDescriptor,
    ConfiguredRootError,
    ConfiguredRootKind,
    ProcurementRootCatalog,
)


class ArticleCatalogConfigurationError(ValueError):
    """A named article-catalog configuration is invalid or unknown."""


@dataclass(frozen=True, slots=True)
class ArticleCatalogDescriptor:
    """One configured catalog and its retained physical root generation."""

    name: str
    catalog_dir: str
    identity: tuple[int, ...]
    publication_root: PinnedPublicationRoot = field(repr=False, compare=False)

    def as_dict(self) -> dict[str, str]:
        return {"name": self.name, "catalog_dir": self.catalog_dir}


class ArticleCatalogRoots:
    """Resolve article-catalog names through one active configured-root catalog."""

    def __init__(self, roots: ProcurementRootCatalog) -> None:
        if not isinstance(roots, ProcurementRootCatalog):
            raise TypeError("ArticleCatalogRoots requires a ProcurementRootCatalog")
        if not roots.is_open:
            raise ArticleCatalogConfigurationError("configured root catalog is not open")
        self._roots = roots

    @staticmethod
    def _descriptor(value: ConfiguredRootDescriptor) -> ArticleCatalogDescriptor:
        return ArticleCatalogDescriptor(
            name=value.name,
            catalog_dir=value.path,
            identity=value.identity,
            publication_root=value.publication_root,
        )

    def catalogs(self) -> tuple[ArticleCatalogDescriptor, ...]:
        """Return configured catalogs in canonical name order."""

        try:
            values = self._roots.descriptors(ConfiguredRootKind.ARTICLE_CATALOG)
        except ConfiguredRootError as exc:
            raise ArticleCatalogConfigurationError(str(exc)) from exc
        return tuple(self._descriptor(value) for value in values)

    def resolve(self, name: str) -> ArticleCatalogDescriptor:
        """Return one configured, case-insensitive article-catalog descriptor."""

        try:
            value = self._roots.resolve(ConfiguredRootKind.ARTICLE_CATALOG, name)
        except ConfiguredRootError as exc:
            raise ArticleCatalogConfigurationError(str(exc)) from exc
        return self._descriptor(value)


__all__ = [
    "ArticleCatalogConfigurationError",
    "ArticleCatalogDescriptor",
    "ArticleCatalogRoots",
]
