"""The inventory registry: one row per article deposited under a catalog root.

Rows are article objects inserted verbatim. The article schema governs both the manifest and the
row, so there is no row shape to project into and no derived fields to keep in step -- and because
the schema declares its own x-identity, the key this registry orders and deduplicates by comes from
the same document rather than from a second declaration here.

Enumerating the deposits is not this class's job and never reaches the engine. A caller hands
rebuild() an iterable of article objects; where they were found is run-layout knowledge.
"""

from .catalog import KindCatalog
from .registry import Registry


@KindCatalog.register
class InventoryRegistry(Registry):
    KIND = "inventory"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    NAME_FORMAT = "inventory.jsonl"
