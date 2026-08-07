"""Artifact kinds, declared as classes.

A kind is an archetype of JSONL artifact: `inventory`, not the inventory.jsonl under one directory.

Identity is declared as class attributes -- KIND, VERSION, DISCIPLINE, CODEC, EMIT_HEADER,
NAME_FORMAT, RECORD_SCHEMA, PARENT_KIND and CHILD_KINDS. Location is a call argument.
__init__ accepts target_dir, run_id, and a schema_registry override.

Schema binding is strict. A kind naming a schema that cannot be resolved raises at construction; a
kind naming none is unvalidated.

validate_record dispatches on a row discriminator. HEADER_SCHEMA is the variant for
__type__ == "header". A kind carrying several body shapes needs the same dispatch over its own
discriminator.

Key extraction, uniqueness, and canonical ordering are not implemented.
"""

import os
import jsonschema
from abc import ABC
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from .engine import JsonlEngine, Discipline, Codec
from .schema_registry import get_global_schema_registry, SchemaRegistry


# Standard Schema for Header Records
HEADER_SCHEMA: Dict[str, Any] = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "type": "object",
    "required": ["__type__", "kind", "version", "created_at"],
    "properties": {
        "__type__": {"const": "header"},
        "kind": {"type": "string"},
        "version": {"type": "string"},
        "created_at": {"type": "string"}
    }
}


class BaseArtifactRegistry(ABC):
    """
    Abstract base class for JSONL artifact registries.
    Seals KIND, VERSION, DISCIPLINE, EMIT_HEADER, resolves JSONSchema via SchemaRegistry,
    and captures hierarchical parent-child relationships between artifact kinds.
    Fails fast if a declared schema cannot be resolved.
    """
    KIND: str = "base"
    VERSION: str = "1.0"
    DISCIPLINE: Discipline = Discipline.CREATE

    # UNICODE is readable and refuses unpaired surrogates; ASCII escapes them losslessly and is for
    # extracted-text kinds only.
    CODEC: Codec = Codec.UNICODE

    EMIT_HEADER: bool = False  # Default False to match unheadered production lanes
    NAME_FORMAT: str = "{kind}.jsonl"

    # Hierarchy declaration
    PARENT_KIND: Optional[str] = None
    CHILD_KINDS: List[str] = []

    # The schema governing one record. Accepts any key SchemaRegistry indexes: a $id, a filename, or
    # a filename stem. A JSONL container holds many records under it; a JSON container holds one.
    RECORD_SCHEMA: Optional[str] = None

    def __init__(
        self,
        target_dir: str,
        run_id: Optional[str] = None,
        schema_registry: Optional[SchemaRegistry] = None
    ):
        self.target_dir = os.path.abspath(target_dir)
        self.run_id = run_id
        self._records: List[Dict[str, Any]] = []

        self.schema_registry = schema_registry or get_global_schema_registry()
        self._header_validator = jsonschema.Draft202012Validator(HEADER_SCHEMA)
        self._payload_validator = self._resolve_payload_validator()

    def _resolve_payload_validator(self) -> Optional[jsonschema.protocols.Validator]:
        """
        Resolves the compiled jsonschema validator from the SchemaRegistry.
        Fails fast with KeyError if RECORD_SCHEMA is declared but missing.
        """
        declared_key = self.RECORD_SCHEMA
        if declared_key is not None:
            if not self.schema_registry.has_schema(declared_key):
                raise KeyError(
                    f"Declared schema '{declared_key}' for artifact registry kind '{self.KIND}' "
                    f"could not be resolved from SchemaRegistry."
                )
            return self.schema_registry.get_validator(declared_key)

        # Fallback to KIND lookup if available
        if self.schema_registry.has_schema(self.KIND):
            return self.schema_registry.get_validator(self.KIND)

        return None

    def get_child_registry(self, child_kind: str, child_target_dir: Optional[str] = None) -> 'BaseArtifactRegistry':
        """Instantiates a child registry of this parent artifact."""
        from .registries.catalog import RegistryCatalog
        if child_kind not in self.CHILD_KINDS and child_kind != "any":
            raise ValueError(
                f"Kind '{child_kind}' is not declared as a valid child of parent kind '{self.KIND}'. "
                f"Allowed: {self.CHILD_KINDS}"
            )

        target = child_target_dir or self.target_dir
        return RegistryCatalog.create(child_kind, target_dir=target, run_id=self.run_id)

    def get_output_path(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """
        Resolves final output path cleanly through NAME_FORMAT.
        """
        if filename:
            name = filename
        else:
            name = self.NAME_FORMAT.format(
                kind=self.KIND,
                stem=stem or "",
                run_id=self.run_id or ""
            )
            # Clean up leading or double dots if stem/run_id is empty
            if name.startswith("."):
                name = name[1:]
            name = name.replace("..", ".")
            
        return os.path.join(self.target_dir, name)

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Validates record against appropriate schema:
        - If __type__ == 'header', validates against HEADER_SCHEMA.
        - Otherwise, validates payload against resolved external JSONSchema.
        """
        if not isinstance(record, dict):
            raise jsonschema.ValidationError(f"Record must be a JSON dict, got {type(record)}")

        rec_type = record.get("__type__")
        if rec_type == "header":
            errors = sorted(self._header_validator.iter_errors(record), key=lambda e: str(e.path))
            if errors:
                raise jsonschema.ValidationError(
                    f"Header validation failed for kind '{self.KIND}': {errors[0].message}"
                )
        elif self._payload_validator:
            errors = sorted(self._payload_validator.iter_errors(record), key=lambda e: str(e.path))
            if errors:
                first_err = errors[0]
                path_str = " -> ".join(str(p) for p in first_err.path) if first_err.path else "root"
                raise jsonschema.ValidationError(
                    f"Record validation failed for kind '{self.KIND}': {first_err.message} at [{path_str}]"
                )
        return record

    def build_header(self) -> Dict[str, Any]:
        """Constructs and validates the header record."""
        header = {
            "__type__": "header",
            "kind": self.KIND,
            "version": self.VERSION,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        return self.validate_record(header)

    def add(self, record: Dict[str, Any]) -> None:
        """In-memory batch record accumulation."""
        validated = self.validate_record(record)
        self._records.append(validated)

    def open_writer(self, stem: Optional[str] = None, filename: Optional[str] = None) -> JsonlEngine:
        """Low-memory streaming context writer, incorporating header rules cleanly inside the engine."""
        out_path = self.get_output_path(stem=stem, filename=filename)
        return JsonlEngine(output_path=out_path, discipline=self.DISCIPLINE, codec=self.CODEC)

    def write(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """Flushes buffered records to disk using JsonlEngine."""
        out_path = self.get_output_path(stem=stem, filename=filename)
        engine = JsonlEngine(output_path=out_path, discipline=self.DISCIPLINE, codec=self.CODEC)

        with engine:
            if self.EMIT_HEADER and (self.DISCIPLINE == Discipline.CREATE or not os.path.exists(out_path)):
                header = self.build_header()
                engine.append(header)

            for rec in self._records:
                engine.append(rec)

            engine.commit(stage_metadata={
                "kind": self.KIND,
                "version": self.VERSION,
                "run_id": self.run_id
            })

        return out_path
