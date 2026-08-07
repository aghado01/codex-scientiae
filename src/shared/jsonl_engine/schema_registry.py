"""
src/shared/jsonl_engine/schema_registry.py - Schema Registry & Factory (V7)
"""

import os
import json
import jsonschema
from typing import Any, Dict, List, Optional
from .paths import RepoPaths


class SchemaRegistry:
    """
    Central Schema Registry and Factory.
    Discovers, loads, indexes, and caches JSON Schema files (.schema.json)
    from configured repository directories.
    Runs check_schema() at registration time to guarantee schema validity.
    """
    def __init__(self, search_paths: Optional[List[str]] = None):
        self._schemas_by_id: Dict[str, Dict[str, Any]] = {}
        self._schemas_by_name: Dict[str, Dict[str, Any]] = {}
        self._validators: Dict[str, jsonschema.protocols.Validator] = {}
        
        # Default search roots relative to repository root
        self.search_paths: List[str] = search_paths or [
            RepoPaths.resolve("ingestion", "inventory"),
            RepoPaths.resolve("schemas")
        ]
        
        self.auto_discover()

    def auto_discover(self) -> None:
        """Scans search paths for all *.schema.json files and registers them."""
        for path in self.search_paths:
            if not os.path.exists(path):
                continue
            if os.path.isfile(path) and path.endswith(".json"):
                self.register_schema_file(path)
            elif os.path.isdir(path):
                for root, _, files in os.walk(path):
                    for file in sorted(files):
                        if file.endswith(".schema.json") or file.endswith(".schema"):
                            self.register_schema_file(os.path.join(root, file))

    def register_schema_file(self, schema_path: str) -> None:
        """Loads, checks, and indexes a single schema file from disk."""
        schema_path = os.path.abspath(schema_path)
        if not os.path.exists(schema_path):
            raise FileNotFoundError(f"Schema file not found: {schema_path}")

        with open(schema_path, "r", encoding="utf-8") as f:
            schema_data = json.load(f)

        # Validate that the loaded schema itself is structurally valid JSON Schema
        validator_cls = jsonschema.validators.validator_for(schema_data)
        validator_cls.check_schema(schema_data)
        validator = validator_cls(schema_data)

        filename = os.path.basename(schema_path)
        schema_id = schema_data.get("$id") or schema_data.get("id") or filename

        # Register by schema_id, filename, and stem
        self._register_entry(schema_id, schema_data, validator)
        self._register_entry(filename, schema_data, validator)
        stem = filename.split(".")[0]
        self._register_entry(stem, schema_data, validator)

    def register_schema_data(self, key: str, schema_dict: Dict[str, Any]) -> None:
        """Registers a schema dict directly in memory (for testing or runtime registration)."""
        validator_cls = jsonschema.validators.validator_for(schema_dict)
        validator_cls.check_schema(schema_dict)
        validator = validator_cls(schema_dict)

        schema_id = schema_dict.get("$id") or key
        self._register_entry(schema_id, schema_dict, validator)
        self._register_entry(key, schema_dict, validator)

    def _register_entry(self, key: str, schema_dict: Dict[str, Any], validator: Any) -> None:
        if key in self._schemas_by_name and self._schemas_by_name[key] != schema_dict:
            # Raise exception on ambiguous schema name collision
            raise KeyError(f"Schema registration collision for key '{key}': another distinct schema is already registered under this key.")
        self._schemas_by_name[key] = schema_dict
        self._validators[key] = validator

    def has_schema(self, key: str) -> bool:
        """Returns True if schema is registered under key."""
        return key in self._validators or key in self._schemas_by_id

    def get_schema(self, key: str) -> Dict[str, Any]:
        """Retrieves a schema dictionary by $id or filename."""
        if key in self._schemas_by_id:
            return self._schemas_by_id[key]
        if key in self._schemas_by_name:
            return self._schemas_by_name[key]
        raise KeyError(f"Schema '{key}' not found in SchemaRegistry.")

    def get_validator(self, key: str) -> jsonschema.protocols.Validator:
        """Retrieves a compiled jsonschema validator by $id or filename."""
        if key in self._validators:
            return self._validators[key]
        raise KeyError(f"Schema validator for '{key}' not found in SchemaRegistry.")


# Global default SchemaRegistry instance
_GLOBAL_SCHEMA_REGISTRY: Optional[SchemaRegistry] = None


def get_global_schema_registry() -> SchemaRegistry:
    """Returns or initializes the global SchemaRegistry singleton."""
    global _GLOBAL_SCHEMA_REGISTRY
    if _GLOBAL_SCHEMA_REGISTRY is None:
        _GLOBAL_SCHEMA_REGISTRY = SchemaRegistry()
    return _GLOBAL_SCHEMA_REGISTRY
