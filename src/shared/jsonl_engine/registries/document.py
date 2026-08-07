"""
src/shared/jsonl_engine/registries/document.py - Single-Document Metadata Manifest Registry
"""

from typing import Dict, Any, List, Optional
from ..registry import BaseArtifactRegistry
from .catalog import RegistryCatalog


@RegistryCatalog.register
class DocumentMetadataRegistry(BaseArtifactRegistry):
    KIND = "document"
    VERSION = "0.1"
    SCHEMA_NAME = "metadata.schema.json"
    EMIT_HEADER = False
    NAME_FORMAT = "metadata.json"
    PARENT_KIND = "inventory"
    CHILD_KINDS = ["docgraph", "math"]

    def add_manifest(
        self,
        slug: str,
        initialized_utc: str,
        document_info: Dict[str, Any],
        evidence: Dict[str, Any],
        source_forms: List[Dict[str, Any]],
        validation_info: Dict[str, Any]
    ) -> None:
        """Adds a single-document metadata manifest object."""
        self.add({
            "schema": "codex-scientiae/document-metadata/0.1",
            "state": "source-ready",
            "slug": slug,
            "initialized_utc": initialized_utc,
            "document": document_info,
            "evidence": evidence,
            "source_forms": source_forms,
            "validation": validation_info
        })
