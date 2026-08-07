"""Declared artifact kinds.

Importing this package registers every kind with RegistryCatalog; a kind whose module is never
imported is absent from the catalog.
"""

from .catalog import RegistryCatalog
from .inventory import InventoryCatalogRegistry
from .article import ArticleRegistry
from .docgraph import DocGraphRegistry

__all__ = [
    "RegistryCatalog",
    "InventoryCatalogRegistry",
    "ArticleRegistry",
    "DocGraphRegistry",
]
