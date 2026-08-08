"""
Core JSONL Engine & Registry Package for Codex-Scientiae
"""
from .policy import DEFAULT_ENCODING, Codec, Eol
from .sidecar import StorePaths, store_paths, get_file_dotnet_ticks
from .engine import JsonlEngine, Discipline
from .writer import JsonWriterError, serialize_json, write_json
from .reader import (
    JsonReaderError,
    JsonlStore,
    Jidx,
    is_line_framable,
    loads,
    read_index,
    read_json,
    read_json_or_none,
)
from .registry import BaseStore
from .paths import RepoPaths, find_repository_root
from .schema_registry import SchemaRegistry, get_global_schema_registry
from .registries import RegistryCatalog

__all__ = [
    # policy
    "DEFAULT_ENCODING",
    "Codec",
    "Eol",
    # store paths and sidecars
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
    # kinds and schemas
    "BaseStore",
    "SchemaRegistry",
    "get_global_schema_registry",
    "RegistryCatalog",
    # repository layout
    "RepoPaths",
    "find_repository_root",
]
