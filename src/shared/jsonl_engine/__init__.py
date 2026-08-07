"""
Core JSONL Engine & Registry Package for Codex-Scientiae
"""
from .engine import JsonlEngine, Discipline, Codec
from .registry import BaseArtifactRegistry
from .reader import ArtifactReader
from .paths import RepoPaths, find_repository_root
from .schema_registry import SchemaRegistry, get_global_schema_registry
from .json_document import (
    read_json_value,
    read_json_value_or_none,
    read_json_document,
    JsonDocumentError,
)
from .registries import RegistryCatalog

__all__ = [
    "JsonlEngine",
    "Discipline",
    "Codec",
    "BaseArtifactRegistry",
    "ArtifactReader",
    "RepoPaths",
    "find_repository_root",
    "SchemaRegistry",
    "get_global_schema_registry",
    "read_json_value",
    "read_json_value_or_none",
    "read_json_document",
    "JsonDocumentError",
    "RegistryCatalog"
]
