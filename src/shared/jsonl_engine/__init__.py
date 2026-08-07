"""
Core JSONL Engine & Registry Package for Codex-Scientiae
"""
from .engine import JsonlEngine, Discipline
from .registry import BaseArtifactRegistry
from .reader import ArtifactReader
from .paths import RepoPaths, find_repository_root
from .schema_registry import SchemaRegistry, get_global_schema_registry
from .registries import RegistryCatalog

__all__ = [
    "JsonlEngine",
    "Discipline",
    "BaseArtifactRegistry",
    "ArtifactReader",
    "RepoPaths",
    "find_repository_root",
    "SchemaRegistry",
    "get_global_schema_registry",
    "RegistryCatalog"
]
