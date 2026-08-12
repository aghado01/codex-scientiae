"""Procurement persistence adapters built on JSON/JSONL infrastructure."""

from procurement.storage.article import (
    ProcurementArticleMetadataExtension,
    deposit_procurement_article,
    get_procurement_article_metadata_extension,
)
from procurement.storage.schemas import ProcurementSchemaCatalog, get_procurement_schema_catalog

__all__ = [
    "ProcurementArticleMetadataExtension",
    "ProcurementSchemaCatalog",
    "deposit_procurement_article",
    "get_procurement_article_metadata_extension",
    "get_procurement_schema_catalog",
]
