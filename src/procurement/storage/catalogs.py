"""Article-catalog view over the application-owned configured-root catalog."""

from __future__ import annotations

import os
import stat
import threading
from dataclasses import dataclass, field
from pathlib import Path

from jsonl_engine.publication import PinnedPublicationRoot

from procurement.domain.deposits import validate_catalog_destination
from procurement.storage.roots import (
    ConfiguredRootDescriptor,
    ConfiguredRootError,
    ConfiguredRootKind,
    ProcurementRootCatalog,
)
from procurement.storage.safety import is_link_or_reparse


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


def _ensure_workspace_directory(
    workspace: Path,
    relative: str,
    *,
    create: bool,
) -> Path:
    """Create or retain one confined physical directory under the workspace."""

    current = workspace
    for part in relative.split("/"):
        child = current / part
        lexical = child.absolute()
        try:
            lexical.relative_to(workspace)
        except ValueError as exc:
            raise ArticleCatalogConfigurationError(
                f"catalog destination escapes the workspace: {relative!r}"
            ) from exc
        if os.path.lexists(child):
            try:
                info = os.lstat(child)
            except OSError as exc:
                raise ArticleCatalogConfigurationError(
                    f"catalog destination cannot be read: {relative!r}"
                ) from exc
            if not stat.S_ISDIR(info.st_mode) or is_link_or_reparse(info):
                raise ArticleCatalogConfigurationError(
                    f"catalog destination is not a physical directory: {relative!r}"
                )
            current = lexical
            continue
        if not create:
            raise ArticleCatalogConfigurationError(
                f"unknown article catalog {relative!r}"
            )
        try:
            os.mkdir(child)
        except FileExistsError:
            pass
        except OSError as exc:
            raise ArticleCatalogConfigurationError(
                f"catalog destination could not be created: {relative!r}"
            ) from exc
        try:
            info = os.lstat(child)
        except OSError as exc:
            raise ArticleCatalogConfigurationError(
                f"catalog destination could not be created: {relative!r}"
            ) from exc
        if not stat.S_ISDIR(info.st_mode) or is_link_or_reparse(info):
            raise ArticleCatalogConfigurationError(
                f"catalog destination is not a physical directory: {relative!r}"
            )
        current = lexical
    return current


class ArticleCatalogRoots:
    """Resolve article-catalog names and workspace-relative deposit destinations."""

    def __init__(
        self,
        roots: ProcurementRootCatalog,
        *,
        workspace_root: str | Path | None = None,
    ) -> None:
        if not isinstance(roots, ProcurementRootCatalog):
            raise TypeError("ArticleCatalogRoots requires a ProcurementRootCatalog")
        if not roots.is_open:
            raise ArticleCatalogConfigurationError("configured root catalog is not open")
        self._roots = roots
        self._lock = threading.Lock()
        self._workspace_root = (
            Path(workspace_root).absolute() if workspace_root is not None else None
        )

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

    def resolve(self, name: str, *, create: bool = False) -> ArticleCatalogDescriptor:
        """Return a configured catalog or a confined workspace-relative destination."""

        destination = validate_catalog_destination(name)
        try:
            return self._descriptor(
                self._roots.resolve(ConfiguredRootKind.ARTICLE_CATALOG, destination)
            )
        except ConfiguredRootError:
            pass
        workspace = self._workspace_root
        if workspace is None:
            raise ArticleCatalogConfigurationError(
                f"unknown article catalog {destination!r}"
            )
        with self._lock:
            try:
                return self._descriptor(
                    self._roots.resolve(ConfiguredRootKind.ARTICLE_CATALOG, destination)
                )
            except ConfiguredRootError:
                pass
            directory = _ensure_workspace_directory(
                workspace,
                destination,
                create=create,
            )
            try:
                value = self._roots.ensure_article_catalog(destination, str(directory))
            except ConfiguredRootError as exc:
                raise ArticleCatalogConfigurationError(str(exc)) from exc
            return self._descriptor(value)


__all__ = [
    "ArticleCatalogConfigurationError",
    "ArticleCatalogDescriptor",
    "ArticleCatalogRoots",
]
