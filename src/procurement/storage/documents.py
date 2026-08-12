"""Procurement JSON document kinds bound to the procurement schema catalog."""

from __future__ import annotations

from typing import Any

from jsonl_engine.documents import JsonDocumentKind
from jsonl_engine.schemas import SchemaCatalog

from procurement.limits import (
    MAX_ACQUISITION_MANIFEST_BYTES,
    MAX_DEPOSIT_METADATA_BUNDLE_BYTES,
)
from procurement.domain.metadata import DepositMetadataBundle
from procurement.payloads import AcquisitionManifest
from procurement.storage.schemas import get_procurement_schema_catalog


class AcquisitionManifestDocument(JsonDocumentKind[AcquisitionManifest]):
    """Validated ``acquisition.json`` document kind."""

    KIND = "acquisition-manifest"
    SCHEMA = "acquisition.schema.json"
    MAXIMUM_BYTES = MAX_ACQUISITION_MANIFEST_BYTES

    def __init__(self, schema_catalog: SchemaCatalog | None = None) -> None:
        super().__init__(schema_catalog or get_procurement_schema_catalog())

    def record_of(self, value: AcquisitionManifest) -> dict[str, Any]:
        return value.model_dump(mode="json", by_alias=True)

    def value_of(self, record: dict[str, Any]) -> AcquisitionManifest:
        return AcquisitionManifest.model_validate(record)


class DepositMetadataDocument(JsonDocumentKind[DepositMetadataBundle]):
    """Validated ``*.api-metadata.json`` evidence document kind."""

    KIND = "deposit-metadata"
    SCHEMA = "deposit.metadata.schema.json"
    MAXIMUM_BYTES = MAX_DEPOSIT_METADATA_BUNDLE_BYTES

    def __init__(self, schema_catalog: SchemaCatalog | None = None) -> None:
        super().__init__(schema_catalog or get_procurement_schema_catalog())

    def record_of(self, value: DepositMetadataBundle) -> dict[str, Any]:
        return value.model_dump(mode="json", by_alias=True)

    def value_of(self, record: dict[str, Any]) -> DepositMetadataBundle:
        return DepositMetadataBundle.model_validate(record)


__all__ = ["AcquisitionManifestDocument", "DepositMetadataDocument"]
