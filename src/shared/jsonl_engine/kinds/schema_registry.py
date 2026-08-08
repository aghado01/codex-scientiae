"""The schema registry: one row per schema the engine ships.

The first real registry, and the reason the category exists. Everything else the engine writes is a
population of documents; this is a population of declarations, and it is the artifact that lets a
consumer outside Python -- jso-ops, the C# lane -- learn what schemas exist and what each addresses
without importing anything or walking a directory.

It is also self-hosting: the registry of schemas is itself governed by a schema, keyed by an
x-identity that schema declares, and signed by the same engine. entries() reads the in-memory
SchemaCatalog, which is the one population this package may enumerate itself -- the catalog is the
engine's own state, not run layout.
"""

from typing import Any, Dict, Iterator, Optional

from ..schemas import SchemaCatalog
from .catalog import KindCatalog
from .registry import Registry


@KindCatalog.register
class SchemaRegistry(Registry):
    KIND = "schema-registry"
    VERSION = "0.1"
    RECORD_SCHEMA = "schema.entry.schema.json"
    NAME_FORMAT = "schema-registry.jsonl"

    def entries(self, catalog: Optional[SchemaCatalog] = None) -> Iterator[Dict[str, Any]]:
        """One entry per schema the catalog holds, derived from each document's own declarations."""
        source = catalog or self.schemas
        for schema_id in source.keys():
            document = source.get_schema(schema_id)
            values: Dict[str, Any] = {
                "id": schema_id,
                "file": filename_of(source, schema_id),
                "draft": document.get("$schema", ""),
                "title": document.get("title"),
            }
            identity = source.identity_of(schema_id)
            if identity:
                values["identity"] = list(identity)
            yield self.mint(values)

    def rebuild_from_catalog(
        self, catalog: Optional[SchemaCatalog] = None, *, stem: Optional[str] = None
    ) -> str:
        """Publish the catalog as a registry artifact. Returns the path written."""
        return self.rebuild(self.entries(catalog), stem=stem)


def filename_of(catalog: SchemaCatalog, schema_id: str) -> str:
    """Recover the shipped filename for a schema id.

    The catalog indexes each schema under its $id, its filename, and its stem, so the filename is
    the one key that both ends in '.schema.json' and resolves to this same document.
    """
    document = catalog.get_schema(schema_id)
    for key in catalog.filenames():
        if catalog.get_schema(key) is document:
            return key
    return ""
