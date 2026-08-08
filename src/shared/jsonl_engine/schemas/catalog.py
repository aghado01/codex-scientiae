"""Compiled JSON Schema validators, loaded from the *.schema.json files beside this module.

A *catalog* is an in-memory index of what is available. A *registry* is a published artifact that
registers a population under a key. This is the former; see kinds/registry.py for the latter. The
distinction matters because "registry" now carries fixed semantics -- keyed, unique, canonically
ordered, rebuilt wholesale -- and a lookup table is none of those.

auto_discover scans this directory at construction. Each schema is indexed by its $id, its filename,
and its filename stem.

check_schema runs at registration; the draft is taken from each file's own $schema. Registering two
distinct schemas under one key raises. Re-registering an identical schema is idempotent.

read_schema_file is a classmethod. A schema's authority is the JSON Schema meta-schema rather than a
catalog entry, so schemas are not read through reader.read_json with a validator.

mint() and identity_of() are the two places a schema is read for something other than validation:
what a conforming object starts as, and which of its properties address it.
"""

import os
from typing import Any, Dict, List, Optional, Sequence

import jsonschema

from ..pointer import PointerError
from ..pointer import parse as parse_pointer
from ..reader import read_json

# Schemas may declare which of their properties address an instance. JSON Schema ignores unknown
# keywords, so this travels in the schema document without making it invalid -- which is the point:
# shape and identity belong to one document, and a Python class should not be a second place to
# look. Consumed by identity_of and by the Registry kind.
IDENTITY_KEYWORD = "x-identity"


class SchemaCatalog:
    """Discovers, loads, indexes, and caches JSON Schema files, and compiles their validators."""

    def __init__(self, search_paths: Optional[List[str]] = None):
        self._schemas_by_id: Dict[str, Dict[str, Any]] = {}
        self._schemas_by_name: Dict[str, Dict[str, Any]] = {}
        self._validators: Dict[str, jsonschema.protocols.Validator] = {}

        # Schemas ship with the package rather than sitting at a repository path, so discovery is
        # anchored to this module's own directory. The engine's declarations travel with the engine
        # and resolve the same way under an editable install, a wheel, or a relocated checkout.
        self.search_paths: List[str] = search_paths or [
            os.path.dirname(os.path.abspath(__file__))
        ]

        self.auto_discover()

    def auto_discover(self) -> None:
        """Scan search paths for *.schema.json and register each. Non-schema siblings are skipped."""
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

        Schemas are not themselves validated against a catalog entry, which would be circular.
        Their authority is the JSON Schema meta-schema via check_schema. Keeping that here makes
        the difference structural instead of a waived argument at the call site.

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
        """Load, check, and index a single schema file from disk."""
        schema_path = os.path.abspath(schema_path)
        schema_data = self.read_schema_file(schema_path)

        validator_cls = jsonschema.validators.validator_for(schema_data)
        validator = validator_cls(schema_data)

        filename = os.path.basename(schema_path)
        schema_id = schema_data.get("$id") or schema_data.get("id") or filename

        self._register_entry(schema_id, schema_data, validator, as_id=True)
        self._register_entry(filename, schema_data, validator)
        self._register_entry(filename.split(".")[0], schema_data, validator)

    def register_schema_data(self, key: str, schema_dict: Dict[str, Any]) -> None:
        """Register a schema dict directly, for testing or runtime registration."""
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
        as_id: bool = False,
    ) -> None:
        if key in self._schemas_by_name and self._schemas_by_name[key] != schema_dict:
            raise KeyError(
                f"Schema registration collision for key '{key}': another distinct schema is "
                f"already registered under this key."
            )
        self._schemas_by_name[key] = schema_dict
        self._validators[key] = validator
        if as_id:
            self._schemas_by_id[key] = schema_dict

    def has_schema(self, key: str) -> bool:
        return key in self._validators or key in self._schemas_by_id

    def get_schema(self, key: str) -> Dict[str, Any]:
        """Retrieve a schema dictionary by $id, filename, or stem."""
        if key in self._schemas_by_id:
            return self._schemas_by_id[key]
        if key in self._schemas_by_name:
            return self._schemas_by_name[key]
        raise KeyError(f"Schema '{key}' not found in SchemaCatalog.")

    def get_validator(self, key: str) -> jsonschema.protocols.Validator:
        """Retrieve a compiled validator by $id, filename, or stem."""
        if key in self._validators:
            return self._validators[key]
        raise KeyError(f"Schema validator for '{key}' not found in SchemaCatalog.")

    def keys(self) -> List[str]:
        """Every $id this catalog holds, in sorted order."""
        return sorted(self._schemas_by_id)

    def filenames(self) -> List[str]:
        """Every shipped filename this catalog indexes, in sorted order."""
        return sorted(k for k in self._schemas_by_name if k.endswith(".schema.json"))

    def identity_of(self, key: str) -> Sequence[str]:
        """The properties that address an instance of this schema, as declared by the schema.

        Empty when the schema declares none, which means it cannot back a registry: there is
        nothing to key rows on, dedupe by, or order by.
        """
        declared = self.get_schema(key).get(IDENTITY_KEYWORD)
        if declared is None:
            return ()
        if not isinstance(declared, list) or not all(isinstance(p, str) for p in declared):
            raise ValueError(
                f"Schema '{key}' declares {IDENTITY_KEYWORD} that is not a list of JSON Pointers"
            )
        for pointer in declared:
            # Syntax is checked here rather than at first use, so a malformed declaration is a
            # load-time error naming the schema instead of a runtime one naming a record.
            try:
                parse_pointer(pointer)
            except PointerError as exc:
                raise ValueError(
                    f"Schema '{key}' declares an invalid {IDENTITY_KEYWORD} pointer: {exc}"
                ) from exc
        return tuple(declared)

    def mint(
        self,
        key: str,
        values: Optional[Dict[str, Any]] = None,
        *,
        validate: bool = True,
    ) -> Dict[str, Any]:
        """Build one object conforming to schema `key`.

        A schema constrains shape, not content, so this fills only what the schema itself
        determines -- `const` properties and `default` properties -- and takes everything else from
        `values`. That is enough to retire the two things call sites used to hardcode: the schema's
        own $id (declared as a const on the identifying property) and any fixed state.

        Properties are emitted in the schema's declaration order, with caller keys the schema does
        not mention appended after. Two objects minted from one schema therefore have identical key
        order regardless of how the caller's dict was built, and the engine preserves insertion
        order -- so minted records are byte-canonical without anyone sorting anything.

        `values` is one data structure, not a parameter list. A signature enumerating a schema's
        properties is a second copy of that schema, and it goes stale the moment the schema moves.
        """
        schema = self.get_schema(key)
        supplied = dict(values or {})
        obj: Dict[str, Any] = {}

        for name, spec in schema.get("properties", {}).items():
            if not isinstance(spec, dict):
                continue
            if name in supplied:
                obj[name] = supplied.pop(name)
            elif "const" in spec:
                obj[name] = spec["const"]
            elif "default" in spec:
                obj[name] = spec["default"]

        # Anything the schema does not declare. Kept rather than dropped: whether it is allowed is
        # additionalProperties' call, and validation is where that gets answered.
        obj.update(supplied)

        if validate:
            errors = sorted(
                self.get_validator(key).iter_errors(obj), key=lambda e: str(e.path)
            )
            if errors:
                first = errors[0]
                where = " -> ".join(str(p) for p in first.path) if first.path else "root"
                raise jsonschema.ValidationError(
                    f"minted object does not satisfy '{key}' at [{where}]: {first.message}"
                )
        return obj


# Process-wide default catalog.
_GLOBAL_SCHEMA_CATALOG: Optional[SchemaCatalog] = None


def get_schema_catalog() -> SchemaCatalog:
    """Return or initialize the process-wide SchemaCatalog."""
    global _GLOBAL_SCHEMA_CATALOG
    if _GLOBAL_SCHEMA_CATALOG is None:
        _GLOBAL_SCHEMA_CATALOG = SchemaCatalog()
    return _GLOBAL_SCHEMA_CATALOG
