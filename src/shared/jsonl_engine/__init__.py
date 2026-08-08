"""Core JSON/JSONL engine for Codex-Scientiae.

Layered leaf-first, so each module depends only on what sits below it:

    policy      the three declared text axes: encoding, Codec, Eol
    sidecar     the artifact path triple, .NET ticks, the .sig schema id
    writer      serialize_json / write_json -- single-object artifacts
    reader      read_json / JsonlStore      -- both artifact shapes
    engine      JsonlEngine                 -- JSONL bytes, offsets, sidecar transaction
    schemas     the shipped *.schema.json and the catalog that indexes them
    kinds       artifact kinds, and the registry category

Two words that are easy to confuse and are kept apart deliberately: a *catalog* is an in-memory
index of what is available (SchemaCatalog, KindCatalog); a *registry* is a published artifact that
registers a population under a schema-declared key.
"""

from .policy import DEFAULT_ENCODING, Codec, Eol
from .sidecar import StorePaths, get_file_dotnet_ticks, store_paths
from .writer import JsonWriterError, serialize_json, write_json
from .reader import (
    Jidx,
    JsonReaderError,
    JsonlStore,
    is_line_framable,
    loads,
    read_index,
    read_json,
    read_json_or_none,
)
from .engine import Discipline, JsonlEngine
from .schemas import IDENTITY_KEYWORD, SchemaCatalog, get_schema_catalog
from .kinds import (
    ArticleManifest,
    BaseStore,
    DuplicateEntry,
    InventoryRegistry,
    KindCatalog,
    Registry,
    SchemaRegistry,
    StoreWriter,
)
from .paths import RepoPaths, find_repository_root

__all__ = [
    # policy
    "DEFAULT_ENCODING",
    "Codec",
    "Eol",
    # artifact paths and sidecars
    "StorePaths",
    "store_paths",
    "get_file_dotnet_ticks",
    # writing
    "JsonlEngine",
    "Discipline",
    "JsonWriterError",
    "serialize_json",
    "write_json",
    # reading
    "JsonReaderError",
    "JsonlStore",
    "Jidx",
    "is_line_framable",
    "loads",
    "read_index",
    "read_json",
    "read_json_or_none",
    # schemas
    "IDENTITY_KEYWORD",
    "SchemaCatalog",
    "get_schema_catalog",
    # kinds
    "BaseStore",
    "StoreWriter",
    "KindCatalog",
    "Registry",
    "DuplicateEntry",
    "ArticleManifest",
    "InventoryRegistry",
    "SchemaRegistry",
    # repository layout
    "RepoPaths",
    "find_repository_root",
]
