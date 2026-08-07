"""
src/shared/jsonl_engine/registries/inventory.py - Inventory Catalog Registry
"""

from typing import Dict, Any, List, Optional
from ..registry import BaseArtifactRegistry
from .catalog import RegistryCatalog


@RegistryCatalog.register
class InventoryCatalogRegistry(BaseArtifactRegistry):
    KIND = "inventory"
    VERSION = "0.1"
    SCHEMA_NAME = "inventory-row.schema.json"
    EMIT_HEADER = False
    NAME_FORMAT = "inventory.jsonl"
    CHILD_KINDS = ["document"]

    def add_inventory_row(
        self,
        slug: str,
        title: Optional[str],
        authors: List[str],
        abstract: Optional[str],
        identifiers: Dict[str, Any],
        categories: List[str],
        metadata_sha256: str
    ) -> None:
        """Adds a schema-validated row for inventory.jsonl."""
        self.add({
            "schema": "codex-scientiae/document-inventory-row/0.1",
            "document_parent": slug,
            "metadata_path": f"{slug}/metadata.json",
            "metadata_sha256": metadata_sha256,
            "manifest_schema": "codex-scientiae/document-metadata/0.1",
            "state": "source-ready",
            "slug": slug,
            "document": {
                "title": title,
                "authors": authors,
                "abstract": abstract,
                "identifiers": identifiers,
                "categories": categories
            }
        })
