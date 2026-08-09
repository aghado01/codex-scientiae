"""Schemas the engine ships, and the catalog that indexes them.

The *.schema.json files are data and travel with the package; catalog.py is the code that loads
them. They live together because they are one concern.
"""

from .catalog import (
    IDENTITY_KEYWORD,
    SchemaCatalog,
    get_schema_catalog,
)

__all__ = [
    "IDENTITY_KEYWORD",
    "SchemaCatalog",
    "get_schema_catalog",
]
