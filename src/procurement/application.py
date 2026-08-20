"""Owned procurement runtime dependencies and operations."""

from __future__ import annotations

from dataclasses import dataclass, field

from procurement.operations.acquisition import AcquisitionService
from procurement.operations.catalogs import ArticleCatalogService
from procurement.operations.discovery import DiscoveryService
from procurement.operations.local_import import LocalImportService
from procurement.operations.materialization import SourceMaterializationService
from procurement.operations.metadata import MetadataService
from procurement.operations.procure import ProcureService
from procurement.providers.catalog import ProviderCatalog
from procurement.storage.roots import ProcurementRootCatalog
from procurement.transport.http import HttpClient


@dataclass(slots=True)
class ProcurementApplication:
    """Owned runtime dependencies and application operations."""

    providers: ProviderCatalog
    discovery: DiscoveryService
    metadata: MetadataService
    http: HttpClient
    roots: ProcurementRootCatalog
    acquisition: AcquisitionService | None = None
    local_import: LocalImportService | None = None
    catalogs: ArticleCatalogService | None = None
    materialization: SourceMaterializationService | None = None
    procure: ProcureService | None = None
    _closed: bool = field(default=False, init=False, repr=False)

    async def close(self) -> None:
        if self._closed:
            return
        self._closed = True
        try:
            await self.http.close()
        finally:
            self.roots.close()

    async def __aenter__(self) -> "ProcurementApplication":
        if not self.roots.is_open:
            raise RuntimeError("procurement application roots are closed")
        return self

    async def __aexit__(self, exc_type: object, exc: object, traceback: object) -> None:
        await self.close()


__all__ = ["ProcurementApplication"]
