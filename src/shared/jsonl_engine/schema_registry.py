"""Compiled JSON Schema validators, loaded from the *.schema.json files shipped with this package.

auto_discover scans schemas/ relative to this module at construction. Each schema is indexed by its
$id, its filename, and its filename stem.

check_schema runs at registration; the draft is taken from each file's own $schema. Registering two
distinct schemas under one key raises. Re-registering an identical schema is idempotent.

read_schema_file is a classmethod. A schema's authority is the JSON Schema meta-schema rather than a
registry entry, so schemas are not read through reader.read_json with a validator.
"""

import os
import jsonschema
from typing import Any, Dict, List, Optional
from .reader import read_json


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
        
        # Schemas ship with the package rather than sitting at a repository path, so discovery is
        # anchored to this module. The engine's declarations travel with the engine and resolve the
        # same way under an editable install, a wheel, or a relocated checkout.
        self.search_paths: List[str] = search_paths or [
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "schemas")
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

    @classmethod
    def read_schema_file(cls, schema_path: str) -> Dict[str, Any]:
        """Read one *.schema.json and return it, having confirmed it is a valid schema.

        Schemas are not themselves validated. A schema is what validates rather than a thing
        validated, and its authority is the JSON Schema meta-schema via check_schema -- not a
        registry entry, which would be circular. Keeping that on the registry makes the difference
        structural instead of a waived argument at the call site.

        require_object is False because JSON Schema 2020-12 admits a bare boolean as a schema;
        check_schema is the authority on validity, not the document's shape.
        """
        full = os.path.abspath(schema_path)
        if not os.path.exists(full):
            raise FileNotFoundError(f"Schema file not found: {full}")

        schema_data = read_json(full, require_object=False)
        jsonschema.validators.validator_for(schema_data).check_schema(schema_data)
        return schema_data

    def register_schema_file(self, schema_path: str) -> None:
        """Loads, checks, and indexes a single schema file from disk."""
        schema_path = os.path.abspath(schema_path)
        schema_data = self.read_schema_file(schema_path)

        validator_cls = jsonschema.validators.validator_for(schema_data)
        validator = validator_cls(schema_data)

        filename = os.path.basename(schema_path)
        schema_id = schema_data.get("$id") or schema_data.get("id") or filename

        # Register by schema_id, filename, and stem
        self._register_entry(schema_id, schema_data, validator, as_id=True)
        self._register_entry(filename, schema_data, validator)
        stem = filename.split(".")[0]
        self._register_entry(stem, schema_data, validator)

    def register_schema_data(self, key: str, schema_dict: Dict[str, Any]) -> None:
        """Registers a schema dict directly in memory (for testing or runtime registration)."""
        validator_cls = jsonschema.validators.validator_for(schema_dict)
        validator_cls.check_schema(schema_dict)
        validator = validator_cls(schema_dict)

        schema_id = schema_dict.get("$id") or key
        self._register_entry(schema_id, schema_dict, validator, as_id=True)
        self._register_entry(key, schema_dict, validator)

    def _register_entry(
        self,
        key: str,
        schema_dict: Dict[str, Any],
        validator: Any,
        as_id: bool = False
    ) -> None:
        if key in self._schemas_by_name and self._schemas_by_name[key] != schema_dict:
            # Raise exception on ambiguous schema name collision
            raise KeyError(f"Schema registration collision for key '{key}': another distinct schema is already registered under this key.")
        self._schemas_by_name[key] = schema_dict
        self._validators[key] = validator
        if as_id:
            self._schemas_by_id[key] = schema_dict

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
