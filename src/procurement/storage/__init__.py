"""Procurement persistence, document kinds, and configured-root ownership."""

from .documents import AcquisitionManifestDocument, DepositMetadataDocument
from .roots import (
    ConfiguredRootDescriptor,
    ConfiguredRootError,
    ConfiguredRootKind,
    ProcurementRootCatalog,
)

__all__ = [
    "AcquisitionManifestDocument",
    "ConfiguredRootDescriptor",
    "ConfiguredRootError",
    "ConfiguredRootKind",
    "DepositMetadataDocument",
    "ProcurementRootCatalog",
]
