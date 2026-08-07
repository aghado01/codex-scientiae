"""Localized inventory registry.

A catalog root owns one `inventory.jsonl` holding the `article.json` of each direct child deposit.
Rows are article objects inserted verbatim: the article schema governs both, so there is no row shape
to project into and no derived fields to keep in step.

`slug` carries identity and locality -- it equals the child directory name -- so a row needs no path
or parent field. The catalog is a materialized view; a stale one is rebuilt rather than reconciled.
"""

from typing import Any, Dict

from ..registry import BaseArtifactRegistry
from .catalog import RegistryCatalog


@RegistryCatalog.register
class InventoryCatalogRegistry(BaseArtifactRegistry):
    KIND = "inventory"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    EMIT_HEADER = False
    NAME_FORMAT = "inventory.jsonl"
    CHILD_KINDS = ["article"]

    def add_article(self, article: Dict[str, Any]) -> None:
        """Insert one article object as a row. Validation is the kind's declared schema."""
        self.add(article)
