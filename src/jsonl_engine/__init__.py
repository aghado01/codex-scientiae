"""Core JSON/JSONL engine for Codex-Scientiae.

Layered leaf-first, so each module depends only on what sits below it:

    policy      the three declared text axes: encoding, Codec, Eol
    pointer     JSON Pointer (RFC 6901) resolution
    ordering    a total, host-independent order over JSON values
    sidecar     the artifact path triple, .NET ticks, scratch and lock placement
    writer      serialize_json / write_json -- single-object artifacts
    publication retained directory generations and anchored filesystem operations
    documents   schema-backed single-object kinds and pinned stores
    reader      read_json / JsonlStore      -- both artifact shapes
    engine      JsonlEngine                 -- JSONL bytes, offsets, sidecar transaction
    inspect     physical facts and stable views of an actively appended store
    deposit     article assembly and immutable source-deposit publication
    cli         `python -m jsonl_engine`, the protocol used by the PowerShell client
    schemas     the shipped *.schema.json and the catalog that indexes them
    kinds       artifact kinds, and the registry category

Two words that are easy to confuse and are kept apart deliberately: a *catalog* is an in-memory
index of what is available (SchemaCatalog, KindCatalog); a *registry* is a published artifact that
registers a population under a schema-declared key.
"""

from .policy import DEFAULT_ENCODING, Codec, Eol, is_line_framable
from .pointer import MISSING, PointerError, exists as pointer_exists, resolve as pointer_resolve
from .ordering import KeyComparison, SortField
from .sidecar import StorePaths, get_file_dotnet_ticks, store_paths
from .writer import JsonWriterError, serialize_json, write_bytes, write_json
from .publication import (
    PinnedFileCopy,
    PinnedFileMeasurement,
    PinnedPublicationRoot,
    PublicationConflict,
    PublicationError,
    copy_file_no_clobber,
)
from .documents import JsonDocumentError, JsonDocumentKind, JsonDocumentStore
from .reader import (
    Jidx,
    JsonReaderError,
    JsonlStore,
    loads,
    read_index,
    read_json,
    read_json_or_none,
)
from .engine import Discipline, JsonlEngine
from .inspect import (
    StoreInfo,
    StorePrefixScan,
    StoreRepairReceipt,
    complete_prefix,
    inspect_prefix,
    inspect_store,
    repair_prefix,
    snapshot,
)
from .schemas import IDENTITY_KEYWORD, SchemaCatalog, get_schema_catalog
from .kinds import (
    MAX_ARTICLE_MANIFEST_BYTES,
    ArticleManifest,
    ArticleMetadataContribution,
    ArticleMetadataExtension,
    BaseStore,
    DuplicateEntry,
    InventoryRegistry,
    KindCatalog,
    Registry,
    SchemaRegistry,
    StoreWriter,
)
from .paths import RepoPaths, find_repository_root
from .deposit import DepositConflict, DepositError, DepositResult, deposit_article

__all__ = [
    # policy
    "DEFAULT_ENCODING",
    "Codec",
    "Eol",
    # addressing and ordering
    "MISSING",
    "PointerError",
    "pointer_resolve",
    "pointer_exists",
    "KeyComparison",
    "SortField",
    # artifact paths and sidecars
    "StorePaths",
    "store_paths",
    "get_file_dotnet_ticks",
    # writing
    "JsonlEngine",
    "Discipline",
    "JsonWriterError",
    "serialize_json",
    "write_bytes",
    "write_json",
    "PinnedFileCopy",
    "PinnedFileMeasurement",
    "PinnedPublicationRoot",
    "PublicationConflict",
    "PublicationError",
    "copy_file_no_clobber",
    "JsonDocumentError",
    "JsonDocumentKind",
    "JsonDocumentStore",
    # reading
    "JsonReaderError",
    "JsonlStore",
    "Jidx",
    "is_line_framable",
    "loads",
    "read_index",
    "read_json",
    "read_json_or_none",
    # inspection
    "StoreInfo",
    "StorePrefixScan",
    "StoreRepairReceipt",
    "inspect_store",
    "inspect_prefix",
    "complete_prefix",
    "repair_prefix",
    "snapshot",
    # schemas
    "IDENTITY_KEYWORD",
    "SchemaCatalog",
    "get_schema_catalog",
    # kinds
    "MAX_ARTICLE_MANIFEST_BYTES",
    "BaseStore",
    "StoreWriter",
    "KindCatalog",
    "Registry",
    "DuplicateEntry",
    "ArticleManifest",
    "ArticleMetadataContribution",
    "ArticleMetadataExtension",
    "InventoryRegistry",
    "SchemaRegistry",
    # article deposits
    "DepositError",
    "DepositConflict",
    "DepositResult",
    "deposit_article",
    # repository layout
    "RepoPaths",
    "find_repository_root",
]
